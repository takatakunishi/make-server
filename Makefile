SERVERDIR=server
IMAGESETTING=node:16.14-slim
PROJECTNAME=testserver

setup: clean-all make-directory rewrite-docker-setting-files setup-require-file build

setup-vue: clean-all make-directory rewrite-docker-setting-files cra-vue rewrite-vite-port build

make-directory:
	mkdir -p ${SERVERDIR} && cd ${SERVERDIR} && mkdir -p "lib"

setup-require-file:
	cp -r setupFiles ${SERVERDIR} && \
	cat ./${SERVERDIR}/package.json | sed -e 's/<<ProjectName>>/${PROJECTNAME}/' > tmpfile && \
	cat tmpfile > ./${SERVERDIR}/package.json && rm tmpfile


cra-vue:
	cd ${SERVERDIR} && echo ${PROJECTNAME} |\
	npm create vite@latest . -- --template vue-ts && cp -f ../basic/vue.vite.config.ts vite.config.ts

build:
	docker-compose build

rewrite-docker-setting-files:  rewrite-docker-compose rewrite-dockerfile edit-devcontainer-file

rewrite-vite-port:
	cat front/package.json | sed -e '/vite preview/s/vite preview/vite preview --port 3001/g' | \
	sed -e '/"dev": "vite"/s/"dev": "vite"/"dev": "vite serve --port 3000"/g' > tmpfrontpackage.json && \
	cat tmpfrontpackage.json > front/package.json && rm tmpfrontpackage.json

rewrite-docker-compose:
	cat docker-compose.yml | sed -e 's/<<ProjectName>>/${PROJECTNAME}/' > tmpfile && \
	cat tmpfile > docker-compose.yml && rm tmpfile && \
	cat docker-compose.yml | sed -e 's/<<SrcDirName>>/${SERVERDIR}/' > tmpfile && \
	cat tmpfile > docker-compose.yml && rm tmpfile

rewrite-dockerfile:
	cat Dockerfile | sed -e 's/<<ImageSetting>>/${IMAGESETTING}/' > tmpfile && \
	cat tmpfile > Dockerfile && rm tmpfile && \
	cat Dockerfile | sed -e 's/<<SrcDirName>>/${SERVERDIR}/' > tmpfile && \
	cat tmpfile > Dockerfile && rm tmpfile

edit-devcontainer-file:
	cat .devcontainer/devcontainer.json | sed -e "s/<<ProjectName>>/${PROJECTNAME}/" > .devcontainer/tmp.devcontainer.json && \
	cat .devcontainer/tmp.devcontainer.json > .devcontainer/devcontainer.json && rm .devcontainer/tmp.devcontainer.json

up:
	docker-compose up -d

down:
	docker-compose down

clean-dir:
	-rm -rf $(SERVERDIR)

shell:
	echo 'docker exec -it ${PROJECTNAME} bash'

clean-all: clean-dir