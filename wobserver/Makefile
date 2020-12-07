src_dir=./upstream
src_local=$(src_dir)/.git/config

scm_url=https://github.com/shinyscorpion/wobserver
scm_ref=7c6186ba8a90d9406d2b79351081373a52baffdf

registry=jeanparpaillon
repo=wobserver

all: image

image: src-local
	docker build -t $(repo):$(scm_ref) -t $(repo):latest .

push: image
	docker tag $(repo):$(scm_ref) $(registry)/$(repo):$(scm_ref)
	docker tag $(repo):$(scm_ref) $(registry)/$(repo):latest
	docker push $(registry)/$(repo):latest

src-local: $(src_local)
	$(MAKE) src-update
	git -C $(src_dir) clean -f -d
	git -C $(src_dir) reset --hard $(scm_ref)

src-update:
	git -C $(src_dir) fetch origin master

$(src_local):
	git clone --no-checkout $(scm_url) $(src_dir)

.PHONY: all image push src-local src-update
