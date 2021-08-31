NAME=qc-font
PROFILE=sso_qcode_makefile
BUCKET=js-qcode-co-uk

all: check-version concat upload clean
concat: check-version
	# Checkout files from github to a pristine temporary directory
	rm -rf $(NAME)-$(VERSION)
	mkdir $(NAME)-$(VERSION)
	curl --fail -K ~/.curlrc_github -L -o $(NAME)-$(VERSION).tar.gz https://api.github.com/repos/qcode-software/$(NAME)/tarball/v$(VERSION)
	tar --strip-components=1 -xzvf $(NAME)-$(VERSION).tar.gz -C $(NAME)-$(VERSION)
	# Clean up
	rm $(NAME)-$(VERSION).tar.gz
upload: check-version
	# Upload
	aws --profile $(PROFILE) s3 sync $(NAME)-$(VERSION)/src/ s3://$(BUCKET)/$(NAME)/$(VERSION)

clean: 
	rm -rf $(NAME)-$(VERSION)
check-version:
ifndef VERSION
    $(error VERSION is undefined. Usage make VERSION=x.x.x)
endif
