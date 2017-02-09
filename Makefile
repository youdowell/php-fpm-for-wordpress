IMAGE = youdowell/php-fpm-for-wordpress
VERSION ?= snapshot

.PHONY: all build clean tag-latest release

all: build

build: image/$(VARIANT)
ifeq ($(VARIANT),)
	docker build -t $(IMAGE):$(VERSION) --rm image
else
	docker build -t $(IMAGE):$(VERSION)-$(VARIANT) --rm image/$(VARIANT)
endif

tag-latest:
ifeq ($(VARIANT),)
	docker tag -f $(IMAGE):$(VERSION) $(IMAGE):latest
else
	docker tag -f $(IMAGE):$(VERSION)-$(VARIANT) $(IMAGE):$(VARIANT)
endif

release: tag-latest
	@if ! docker images $(IMAGE) | awk '{ print $$2 }' | grep -q -F $(VERSION)-$(VARIANT); then echo "$(IMAGE) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(IMAGE)
	@echo "*** Don't forget to create a tag. git tag v$(VERSION) -m "$(VERSION)" && git push origin v$(VERSION)"
