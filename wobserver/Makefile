src_dir=./src
src_local=$(src_dir)/.git/config

scm_url=https://github.com/shinyscorpion/wobserver
scm_ref=7c6186ba8a90d9406d2b79351081373a52baffdf

registry=jeanparpaillon
repo=wobserver

all: image

image: src-local

src-local: $(src_local)
	$(MAKE) src-update
	git -C $(src_dir) clean -f -d
	git -C $(src_dir) reset --hard $(scm_ref)

src-update:
	git -C $(src_dir) fetch origin master

$(src_local):
	git clone --no-checkout $(scm_url) $(src_dir)

.PHONY: all image src-local src-update
