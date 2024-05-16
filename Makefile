SAGE = sage

lpkbessel.so: lpkbessel.spyx
	@echo "Using sage program '$(SAGE)' to compile lpkbessel..."
	$(SAGE) -c "from sage.misc.cython import cython; cython('lpkbessel.spyx', compile_message=True, use_cache=False, create_local_so_file=True)"
	mv lpkbessel.*.so lpkbessel.so
	@echo "Done"


.PHONY: clean
clean:
	rm -f lpkbessel.so
