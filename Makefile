# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

# ---- Test patterns for project striVe ----


.SUFFIXES:
.SILENT: clean all
export CUP_ROOT ?= $(shell pwd)
export PROJECT_ROOT = $(CUP_ROOT)


PATTERNS = io_ports la_test1 la_test2 wb_port mprj_stimulus

all:  ${PATTERNS}

	for i in ${PATTERNS}; do \
		( cd $$i && make -f Makefile $${i}.vcd &> verify.log && grep Monitor verify.log) ; \
	done

DV_PATTERNS = $(foreach dv, $(PATTERNS), verify-$(dv))
$(DV_PATTERNS): verify-% : 
	cd $* && make

clean:  ${PATTERNS}
	for i in ${PATTERNS}; do \
		( cd $$i && \rm  -f *.elf *.hex *.bin *.vvp *.log *.vcd *.lst *.hexe ) ; \
	done
	rm -rf *.log
	
.PHONY: clean all
.PHONY: cocotb-verify-all-rtl
cocotb-verify-all-rtl:
	@(cd $(PROJECT_ROOT)/verilog/dv/cocotb && $(PROJECT_ROOT)/venv-cocotb/bin/caravel_cocotb -tl user_proj_tests/user_proj_tests.yaml )

.PHONY: cocotb-verify-all-rtl
cocotb-verify-all-rtl:
	@(cd $(PROJECT_ROOT)/verilog/dv/cocotb && $(MAKE) run-user-proj-tests)

$(cocotb-dv-targets-rtl): cocotb-verify-%-rtl:
	@(cd $(PROJECT_ROOT)/verilog/dv/cocotb && $(PROJECT_ROOT)/venv-cocotb/bin/caravel_cocotb -t $* )

$(cocotb-dv-targets-gl): cocotb-verify-%-gl:
	@(cd $(PROJECT_ROOT)/verilog/dv/cocotb && $(PROJECT_ROOT)/venv-cocotb/bin/caravel_cocotb -t $* -sim GL)
print-project-root:
	@echo PROJECT_ROOT=$(PROJECT_ROOT)
	@../../../venv-cocotb/bin/caravel_cocotb -t hello_world_uart -tag hello_world_yaml
blocks=$(shell cd $(PROJECT_ROOT)/openlane && find * -maxdepth 0 -type d)

.PHONY: $(blocks)
$(blocks): % :
	$(MAKE) -C openlane $*

.PHONY: harden
harden: $(blocks)
user_project_wrapper:
	$(MAKE) -C openlane user_project_wrapper
