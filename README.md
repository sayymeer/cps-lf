# Using LF to Verify CPS

Your system must have docker installed and docker daemon running. Run the below commands.

```bash
docker build . -t cps-lf
docker run -it cps-lf
```

Inside `docker` container run the following commands.


```bash
# This will run benchmark tests
make

# To verify .lf models
make run TARGET=ModelName # dont include .lf, write ModelName which should be in src/

```
