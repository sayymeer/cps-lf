test:
	@python3.11 scripts/benchmark.py;
run:
ifeq ($(TARGET),)
	@echo "TARGET is not set. Please provide a value, e.g., 'make run TARGET=PingPong'"
else
	@rm -rf mod-gen/$(TARGET)/; \
	echo "Generating Uclid Model using LF";\
	lfc src/$(TARGET).lf >> /dev/null 2>> /dev/null ;\
	echo "Running Uclid";\
	uclid mod-gen/$(TARGET)/*.ucl --json-cex mod-gen/$(TARGET)/
endif
