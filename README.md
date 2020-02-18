# [![Build Status](https://travis-ci.org/Luet-lab/luet-repo.svg?branch=master)](https://travis-ci.org/Luet-lab/luet-repo) Luet-repo

This repository it is automatically built and hosts the luet packages binaries (built with luet).

You can also build this repo locally if you wish:

  $ make deps
  $ curl -LO https://storage.googleapis.com/container-diff/latest/container-diff-linux-amd64 && chmod +x container-diff-linux-amd64 && sudo mv container-diff-linux-amd64 /usr/local/bin/container-diff
  $ LUET=$GOPATH/bin/luet make build-all create-repo

To consume this repository with Luet, add in the `luet.yml`:

```yaml
repositories:
- name: "luet"
  type: "http"
  enable: true
  priority: 1
  urls:
  - "https://raw.githubusercontent.com/Luet-lab/luet-repo/gh-pages"
  - "https://gitlab.com/luet-lab/luet-repo/-/raw/gh-pages/"
```
