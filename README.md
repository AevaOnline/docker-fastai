FastAI using nvidia-docker
==========================

This repo contains build tooling for running through the FastAI coursework
using nvidia-docker on a GPU-enabled host. Right now, it pulls in a lot of
dependencies that probably aren't needed.

I'm primarily doing this to learn about the environment requirements for this
framework, and to get something running locally (rather than in a cloud).



Building
========

Pretty straight forward...

```docker build -t fastai:latest .```

Run it!
=======

I mount three volumes to keep state between builds and runs, and make
it portable across hosts.
* `source` contains source code for any projects I'm working on
* `datasets` contains local copies of data sets to compile
* `torch` contains torch's compiled models, for reuse between runs

There may be more state I need to track...

```
R="/media/deva/raid"
docker run -ti -d -v $R/source:/notebooks/source -v $R/datasets:/notebooks/data -v $R/torch:/root/.torch --name myfastai fastai:latest
```

If you use the `-d` flag as above, you'll need to view the logs to get the Jupyter token by running ```docker logs myfastai```.
