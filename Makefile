test:
	@python3.11 scripts/benchmark.py;
run:
ifeq ($(TARGET),)
	@echo "TARGET is not set. Please provide a value, e.g., 'make run TARGET=PingPong'"
else
	@rm -rf mod-gen/$(TARGET)/; \
	echo "Running LF verifier";\
	lfc --verify src/$(TARGET).lf 2>> /dev/null | grep -iE "FAILED|PASSED";
endif
