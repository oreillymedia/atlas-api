# Atlas::Api

Gem to interact with the O'Reilly Media Atlas API.

## Installing

Install this gem by running:

```bash
$ gem install atlas-api
```

## Command Line Script

You can build a specific project by calling the `atlas build` command line:

```bash
$ atlas build ATLAS_TOKEN PROJECT FORMATS BRANCH
```

A real world example of this would look something like this:

```bash
$ atlas build abcdefg oreillymedia/atlas_book_skeleton pdf,epub,html master
```