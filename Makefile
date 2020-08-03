NAME=qc-font
REMOTEHOST=js.qcode.co.uk
REMOTEDIR=/var/www/html/js.qcode.co.uk
REMOTEUSER=nsd

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
	# Create directory
	ssh $(REMOTEUSER)@$(REMOTEHOST) 'mkdir -p $(REMOTEDIR)/$(NAME)/$(VERSION)'
	# Upload
	rsync -avz $(NAME)-$(VERSION)/src/ $(REMOTEUSER)@$(REMOTEHOST):$(REMOTEDIR)/$(NAME)/$(VERSION)
	# Change permissions to read only to prevent files being overwritten
	ssh $(REMOTEUSER)@$(REMOTEHOST) 'find $(REMOTEDIR)/$(NAME)/$(VERSION) -type f -exec chmod 444 {} +'

clean: 
	rm -rf $(NAME)-$(VERSION)
check-version:
ifndef VERSION
    $(error VERSION is undefined. Usage make VERSION=x.x.x)
endif
