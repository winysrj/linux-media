Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:49839 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753618AbdHWJ5C (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 05:57:02 -0400
Subject: [GIT PULL RESEND] SAA716x DVB driver
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andreas Regel <andreas.regel@gmx.de>,
        Manu Abraham <manu@linuxtv.org>,
        Oliver Endriss <o.endriss@gmx.de>, linux-media@vger.kernel.org
References: <50e5ba3c-4e32-f2e4-7844-150eefdf71b5@web.de>
From: Soeren Moch <smoch@web.de>
Message-ID: <76416aa4-0955-b10b-42ba-f24ea0bea678@web.de>
Date: Wed, 23 Aug 2017 11:56:50 +0200
MIME-Version: 1.0
In-Reply-To: <50e5ba3c-4e32-f2e4-7844-150eefdf71b5@web.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Resend this pull request. Apparently my explanation one month ago,
why we need the userspace API of this driver in the current form [1],
got lost.

Regards,
Soeren

[1] https://www.mail-archive.com/linux-media@vger.kernel.org/msg116119.html



The following changes since commit 5771a8c08880cdca3bfb4a3fc6d309d6bba20877:

  Linux v4.13-rc1 (2017-07-15 15:22:10 -0700)

are available in the git repository at:

  https://github.com/s-moch/linux-saa716x for-media

for you to fetch changes up to 1a9e44df11d702b9f569605e60c7cf8e05923178:

  saa716x: Add MAINTAINERS entry (2017-07-16 15:37:00 +0200)

----------------------------------------------------------------
Andreas Regel (127):
      saa716x: Simplified the code for I2C transfers.
      saa716x: Transport stream ports can be configured now.
      saa716x_ff: Disable frontend support through STi7109 firmware.
      saa716x_ff: Initialize the frontend of the TT S2-6400.
      saa716x_ff: Add VIDEO_GET_PTS ioctl.
      saa716x_ff: Add audio device for TT S2-6400.
      saa716x_ff: Use separate interrupts for OSD commands.
      saa716x_ff: Use third TS input of the STi7109 for playback
      saa716x_ff: Set error code when boot of firmware failed.
      saa716x_ff: Added 10ms sleep after configuring the FPGA.
      saa716x: Reduce compiler warnings
      saa716x: fix kernel oops caused by missing initialisation
      saa716x: fixed double frontend detach
      saa716x: 1ms is enough when waiting for the PLL
      saa716x_ff: Adapted frontend init to latest driver changes.
      saa716x: Improve PHI performance by shorten timings a bit.
      saa716x_ff: use double buffering for block transfers.
      saa716x_ff: Reset block_done after receiving it.
      saa716x_ff: add interrupt source for firmware log messages
      saa716x_ff: read FPGA version register
      saa716x_ff: fixed PTS/STC signed/unsigned issue
      saa716x_ff: query and print loader and firmware versions
      saa716x: disable debug printk
      osd.h: Add const keyword to struct members
      saa716x_ff: implement ioctl VIDEO_GET_SIZE
      saa716x_ff: support production version of the S2-6400
      saa716x: disable OVERFLOW and AV interrupts in FGPI
      saa716x_ff: add some FPGA register definitions
      saa716x_ff: restart TS capturing in case of non-aligned TS error
      saa716x_ff: don't clear FGPI interrupts in IRQ routine.
      saa716x: comment out SPI functions that are not needed currently
      saa716x: add changes needed for kernel 2.6.36 and up.
      saa716x: support building with media_build_experimental
      saa716x_ff: use tasklet for FIFO transfer
      saa716x: fix not working MSI
      saa716x: Disable shared IRQ when using MSI mode.
      saa716x_ff: Do an explicit demodulator reset.
      saa716x: enable wait for PLL lock when setting clocks of all ports.
      saa716x_ff: add counting of interrupts
      saa716x: don't set i2c_adapter id field
      saa716x_ff: support non-aligned TS data
      saa716x_ff: Use a TS clock of 135Mhz instead of 90 Mhz.
      saa716x_ff: Ignore false remote events.
      saa716x_ff: Fix possible crash in IRQ handler.
      saa716x_ff: move firmware command interface code to separate file.
      saa716x_ff: Allow to have osd device opened twice.
      saa716x_ff: support correct TS mux setting for FPGA 1.10.
      saa716x_budget: Add missing GPIO initialization.
      saa716x_hybrid: Add missing GPIO initialization.
      saa716x_hybrid: fix tuner settings for nemo reference board
      saa716x_hybrid: TS capturing on the nemo reference board works.
      saa716x_hybrid: Make TS capturing code more generic.
      saa716x: remove unused members from struct saa716x_config.
      saa716x: Add function saa716x_fgpi_get_write_index.
      saa716x_hybrid: Use saa716x_fgpi_get_write_index to simplify code.
      saa716x_ff: Use saa716x_fgpi_get_write_index to simplify code.
      saa716x: Set maximum number of adapters per saa716x to 4.
      saa716x_budget: Add TS capturing code.
      saa716x_hybrid: Do some cleanups.
      saa716x: remove unused load_config functions.
      saa716x_budget: Started with SkyStar 2 eXpress HD.
      saa716x_hybrid: Add support for KWorld Dual DVB-T PE310.
      saa716x: Fix I2C bus assignment on SAA7160ET.
      saa716x: Fix stack corruption when parsing ROM info.
      saa716x: Fix memory leak in ROM parsing.
      saa716x: Skip unknown device descriptors when parsing the ROM
      saa716x: change verbose level for some dprintk
      saa716x_ff: Enable now working EEPROM parsing.
      saa716x_ff: Add error message when FPGA is not responding.
      saa716x_budget: Add frontend attach for the Skystar2 eXpress HD.
      saa716x_ff: Reset the frontend on the SkyStar2 eXpress HD.
      saa716x_ff: support CEC remote codes.
      saa716x: Use interrupts for I2C writes instead of polling.
      saa716x: separate I2C reading and writing into two functions.
      saa716x_ff: change remote event printk to hexadecimal output.
      saa716x: Support buffered I2C transaction using interrupts.
      saa716x_ff: Use buffered I2C interrupt mode.
      saa716x_ff: Don't use dvb_generic_ioctl.
      saa716x_budget: Use GPIO 26 for reset on the Skystar 2 eXpress HD.
      saa716x_budget: Use I2C B for accessing the frontend on the Skystar.
      saa716x_budget: Get the Skystar 2 eXpress HD to work.
      saa716x_budget: Implement LNB power switching for Skystar 2
eXpress HD.
      saa716x_ff: Fix memory leak.
      saa716x_ff: Fix missing copy user <-> kernel space.
      saa716x: FGPI DMA buffer size is passed to saa716x_fgpi_init.
      saa716x: Fix FGPI settings for SD video capture.
      saa716x: Export some FGPI functions.
      saa716x: Remove unused header file.
      saa716x: Remove duplicate definition.
      saa716x: Make BAM register macros more generic.
      saa716x: Use global macros for MMU register access.
      saa716x: Add VI module implementation.
      saa716x: Support one-shot video capturing.
      saa716x_ff: Extend interrupt counters.
      saa716x: Change video capture format from YUYV to UYUV.
      saa716x_ff: Support capturing digital video coming from STi7109.
      saa716x_ff: Protect reading of the captured video with a mutex.
      saa716x_ff: Rename functions.
      saa716x_ff: video capture refactoring.
      saa716x: Use pitch value from stream params when setting FGPI_STRIDE.
      saa716x: use offset from stream params instead of fixed value.
      saa716x: Clear DMA buffer after allocatiion
      saa716x: Support capturing raw data via FGPI unit
      saa716x: Reset FGPI read index in saa716x_fgpi_start
      saa716x_ff: Cancel data transfer in case of a block timeout
      saa716x_ff: print decimal digits for firmware version.
      saa716x: include fix for in-kernel build
      saa716x: support directory structure of linux-3.7+
      saa716x: section mismatch fixes
      saa716x: remove __devinit and friends
      saa716x: convert fifo_worker tasklet to workqueue
      saa716x: TS output buffer cleanup
      saa716x: Fix PHI address space offsets, cleanup register definitions.
      saa716x: Clean up PHI configuration.
      saa716x: Reset PHI on init.
      saa716x: Print EEPROM content on DEBUG verbosity only.
      saa716x: Fix errors and improve saa716x_set_clk.
      saa716x_ff: Fix not setting command result length to 0 per default.
      saa716x: move card specific PHI code to saa716x_ff driver
      saa716x_ff: use special phi_fifo_write function
      saa716x_ff: Add write-combining PCI iomem window for PHI1 access.
      saa716x_ff: implement PHI speedup
      saa716x: IO memory of upper PHI1 regions is mapped in saa716x_ff
driver.
      saa716x_ff: Optimize access to FIFO.
      saa716x_ff: Align block data on 32 bytes for firmware 0.5.0 and up
      saa716x_ff: Do not return on command ready timeout
      saa716x_ff: Usa faster EMI timings only for FPGA version 1.10 and
later

Manu Abraham (137):
      saa716x: Initial framework driver to support SAA7160, SAA7161,
SAA7162 chips
      saa716x: Add missing return, to avoid falling through the error codes
      saa716x: Updated board definitions
      saa716x: Add some register definitions
      saa716x: Add Read/Write macros
      saa716x: Initial attempt to Boot the core
      saa716x: Initial attempt to initialize the I2C core
      saa716x: Setup CGU
      saa716x: Whitespace cleanup
      saa716x: Use subsystem Vendor ID
      saa716x: Small cleanups
      saa716x: Enable all inputs
      saa716x: Initial go at MSI setup
      saa716x: Update I2C register definitions and fields
      saa716x: Initial go at the I2C implementation
      saa716x: Remove unused definitions
      saa716x: Move i2c related stuff to it's own header
      saa716x: Add some labels
      saa716x: Rename files
      saa716x: Fix subdevice ID
      saa716x: Add more register definitions
      saa716x: Update/Reorganize register definitions
      saa716x: Implement internal Boot mode
      saa716x: Update register definitions
      saa716x: Still scratching
      saa716x: Initialize MSI
      saa716x: Cleanup internal Boot configuration
      saa716x: Cleanup external Boot configuration
      saa716x: Initialize CGU and MSI modules
      saa716x: Enable more debugging
      saa716x: Check DMA availability
      saa716x: Small cleanups and fixes
      saa716x: Fix typo
      saa716x: Reset internal modules
      saa716x: Still debugging
      saa716x: Code simplification
      saa716x: Terminate PCI ID list
      saa716x: Rename Rd/Wr operations
      saa716x: Fix usage of wrong datatypes
      saa716x: CGU related fixes
      saa716x: Continue MSI-X implementation
      saa716x: Add routines to handle clock related events
      saa716x: Add support for Avermedia HC82 PCIe expresscard
      saa716x: Disable BAR2 access
      saa716x: Code cleanup
      saa716x: Register SAA716x Adapter
      saa716x: Add initial support for the second adapter
      saa716x: Initialize adapters on the budget device
      saa716x: Register only the relevant adapters for a specific device
      saa716x: Add Avermedia HC82 specific device configuration
      saa716x: Fix typo
      saa716x: Register an array of devices
      saa716x: Add support for the Avermedia H788 device
      saa716x: Add support for the Azurewave VP-6002 device
      saa716x: Usea separate frontend_attach for each of the devices
      saa716x: Use a separate IRQ handler for separate modules
      saa716x: Try to attach the demodulator
      saa716x: Fix typo in register definitions
      saa716x: Updates and Code simplification
      saa716x: Check device revision for I2C bus orderring
      saa716x: Add support for the NXP Atlantis reference design
      saa716x: Free IRQ before module unload
      saa716x: Code reorganization
      saa716x: Add support for the KNC1 Dual S2 device
      saa716x: Add support for the VP-3071 DVB-T dual device
      saa716x: Add GPIO control functions
      saa716x: Use power and reset controls within a sig\ngle loop
      saa716x: Use a configuration per adapter
      saa716x: VP-1028: add power, reset configuration
      saa716x: H788: Add power, reset configuration
      saa716x: HC82: Add power, reset configuration
      saa716x: Display Bus status
      saa716x: Bug: Address needs to be shifted one bit
      saa716x: Initial go at DMA routines
      saa716x: Print warning, if MSI module is not supported
      saa716x: Handle MSI in a generic manner
      saa716x: Add PHI port definitions
      saa716x: Initialize PHI bus
      saa716x: Add GREG routines
      saa716x: Reorganize CGU related routines
      saa716x: Do not initialize the CGU twice
      saa716x: Add more debug info, initialize handler count
      saa716x: Add/remove I2C MSI vectors
      saa716x: Add interrupt debugging
      saa716x: Return error on MSI enable failure
      saa716x: Initialize FPGI pagetables
      saa716x: Setup FGPI parameters
      saa716x: Use a separate module to handle Full fledged cards
      saa716x: NULL terminate PCI ID list
      saa716x: Read the mask bits instead
      saa716x: Reduce a bit of noise in the handler debug mode
      saa716x: Sleep a little while before enabling interrupts again
      saa716x: Use individual handlers
      saa716x: Transmit D is programmed, not S data
      saa716x: Print return values
      saa716x: Use adapter ordering
      saa716x: Disable debugging
      osd.h: Kickstart the TT S2 6400 Dual HD Premium - OSD update
      saa716x: Kickstart the TT S2 6400 Dual HD Premium
      saa716x: Code simplification, Overhaul, ROM dump
      saa716x: Set the default rate for the NEMO reference design
      saa716x: Code simplification, Overhauling, I2C related fixes
      saa716x: Try to attach the frontends
      saa716x: Don't cast pointers to 32 bit int
      saa716x: Partial rework of SPI I/O
      saa716x: Add video device support
      saa716x: S2-6400: Try to attach the frontend
      saa716x: Handle multiple I2C messages
      saa716x: Fix ROM parser
      saa716x: Setup default I2C rates
      saa716x: Fix BUS ordering
      saa716x: Fix swapped I2C buses
      saa716x: Print wait time, reduce number of loops
      saa716x: Fix missing address in single write operation
      saa716x: make register definitions specific to each of the modules
      saa716x: Fix register definition typo
      saa716x: Add function declaration
      saa716x: Fix FGPI internal clock divider state
      saa716x: Fix dmabuf allocation
      saa716x: Cleanup debug prints
      saa716x: Handle failure correctly
      saa716x: Handle proper buffer flush
      saa716x: FGPI DMA handling fixes
      saa716x: Finally! we have stream capture
      saa716x: Make the framework buildable
      saa716x: Fix build issues
      saa716x: Deinitialize I2C interrupts on exit
      saa716x: Factorize register/detach routines to common code
      saa716x: Start DMA engine as and when requested
      saa716x: Enable timeout for modules having no clock
      saa716x: Reset the frontend after powerup
      saa716x: GPIO fix
      saa716x: Fix powerup/reset
      saa716x: Use the correct I2C Bus
      saa716x: Code simplification
      saa716x: Try to attach frontend on the Nemo reference board
      saa716x: Do not report non-fatal errors to avoid issues with buggy
BIOS's

Oliver Endriss (3):
      saa716x_ff: Rename saa716x_ff.c to saa716x_ff_main.c
      saa716x_ff: Support remote control receiver
      saa716x: Use tasklet to transfer data to the demuxer (TT S2-6400)

Soeren Moch (13):
      saa716x: i2c_del_adapter() fix
      saa716x_ff: init frontends to low-power mode
      saa716x_ff: Add linux-4.5 support
      saa716x_ff: Avoid sleeping in fifo_worker
      saa716x: remove unused saa716x_msi_handler
      saa716x: pci: Remove asm includes for compatibility with linux-4.6
      saa716x: add linux-4.10 support
      saa716x: Remove broken MSI-X support
      saa716x: Use %zu printk format for sizeof return values
      saa716x_budget: Fix build in current mainline
      saa716x_hybrid: Fix build in current mainline
      saa716x: Hook up driver in staging/media
      saa716x: Add MAINTAINERS entry

 MAINTAINERS                                      |    6 +
 drivers/staging/media/Kconfig                    |    2 +
 drivers/staging/media/Makefile                   |    1 +
 drivers/staging/media/saa716x/Kconfig            |   63 +
 drivers/staging/media/saa716x/Makefile           |   27 +
 drivers/staging/media/saa716x/TODO               |    6 +
 drivers/staging/media/saa716x/saa716x_adap.c     |  251 +++
 drivers/staging/media/saa716x/saa716x_adap.h     |    9 +
 drivers/staging/media/saa716x/saa716x_aip.c      |   20 +
 drivers/staging/media/saa716x/saa716x_aip.h      |    9 +
 drivers/staging/media/saa716x/saa716x_aip_reg.h  |   62 +
 drivers/staging/media/saa716x/saa716x_boot.c     |  319 ++++
 drivers/staging/media/saa716x/saa716x_boot.h     |   18 +
 drivers/staging/media/saa716x/saa716x_budget.c   |  664 ++++++++
 drivers/staging/media/saa716x/saa716x_budget.h   |   15 +
 drivers/staging/media/saa716x/saa716x_cgu.c      |  540 +++++++
 drivers/staging/media/saa716x/saa716x_cgu.h      |   63 +
 drivers/staging/media/saa716x/saa716x_cgu_reg.h  |  178 +++
 drivers/staging/media/saa716x/saa716x_dcs_reg.h  |   56 +
 drivers/staging/media/saa716x/saa716x_dma.c      |  308 ++++
 drivers/staging/media/saa716x/saa716x_dma.h      |   61 +
 drivers/staging/media/saa716x/saa716x_dma_reg.h  |  201 +++
 drivers/staging/media/saa716x/saa716x_ff.h       |  187 +++
 drivers/staging/media/saa716x/saa716x_ff_cmd.c   |  433 +++++
 drivers/staging/media/saa716x/saa716x_ff_cmd.h   |   16 +
 drivers/staging/media/saa716x/saa716x_ff_ir.c    |  265 +++
 drivers/staging/media/saa716x/saa716x_ff_main.c  | 1859
++++++++++++++++++++++
 drivers/staging/media/saa716x/saa716x_ff_phi.c   |  229 +++
 drivers/staging/media/saa716x/saa716x_ff_phi.h   |   14 +
 drivers/staging/media/saa716x/saa716x_fgpi.c     |  386 +++++
 drivers/staging/media/saa716x/saa716x_fgpi.h     |   92 ++
 drivers/staging/media/saa716x/saa716x_fgpi_reg.h |   74 +
 drivers/staging/media/saa716x/saa716x_gpio.c     |  140 ++
 drivers/staging/media/saa716x/saa716x_gpio.h     |   26 +
 drivers/staging/media/saa716x/saa716x_gpio_reg.h |   47 +
 drivers/staging/media/saa716x/saa716x_greg.c     |   42 +
 drivers/staging/media/saa716x/saa716x_greg.h     |    9 +
 drivers/staging/media/saa716x/saa716x_greg_reg.h |   91 ++
 drivers/staging/media/saa716x/saa716x_hybrid.c   |  726 +++++++++
 drivers/staging/media/saa716x/saa716x_hybrid.h   |   13 +
 drivers/staging/media/saa716x/saa716x_i2c.c      |  728 +++++++++
 drivers/staging/media/saa716x/saa716x_i2c.h      |   52 +
 drivers/staging/media/saa716x/saa716x_i2c_reg.h  |  145 ++
 drivers/staging/media/saa716x/saa716x_mod.h      |   50 +
 drivers/staging/media/saa716x/saa716x_msi.c      |  479 ++++++
 drivers/staging/media/saa716x/saa716x_msi.h      |   87 +
 drivers/staging/media/saa716x/saa716x_msi_reg.h  |  143 ++
 drivers/staging/media/saa716x/saa716x_pci.c      |  222 +++
 drivers/staging/media/saa716x/saa716x_phi.c      |   23 +
 drivers/staging/media/saa716x/saa716x_phi.h      |    8 +
 drivers/staging/media/saa716x/saa716x_phi_reg.h  |   94 ++
 drivers/staging/media/saa716x/saa716x_priv.h     |  193 +++
 drivers/staging/media/saa716x/saa716x_rom.c      | 1071 +++++++++++++
 drivers/staging/media/saa716x/saa716x_rom.h      |  253 +++
 drivers/staging/media/saa716x/saa716x_spi.c      |  313 ++++
 drivers/staging/media/saa716x/saa716x_spi.h      |   23 +
 drivers/staging/media/saa716x/saa716x_spi_reg.h  |   27 +
 drivers/staging/media/saa716x/saa716x_vip.c      |  401 +++++
 drivers/staging/media/saa716x/saa716x_vip.h      |   58 +
 drivers/staging/media/saa716x/saa716x_vip_reg.h  |  141 ++
 include/uapi/linux/dvb/osd.h                     |   16 +
 61 files changed, 12055 insertions(+)
 create mode 100644 drivers/staging/media/saa716x/Kconfig
 create mode 100644 drivers/staging/media/saa716x/Makefile
 create mode 100644 drivers/staging/media/saa716x/TODO
 create mode 100644 drivers/staging/media/saa716x/saa716x_adap.c
 create mode 100644 drivers/staging/media/saa716x/saa716x_adap.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_aip.c
 create mode 100644 drivers/staging/media/saa716x/saa716x_aip.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_aip_reg.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_boot.c
 create mode 100644 drivers/staging/media/saa716x/saa716x_boot.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_budget.c
 create mode 100644 drivers/staging/media/saa716x/saa716x_budget.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_cgu.c
 create mode 100644 drivers/staging/media/saa716x/saa716x_cgu.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_cgu_reg.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_dcs_reg.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_dma.c
 create mode 100644 drivers/staging/media/saa716x/saa716x_dma.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_dma_reg.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_ff.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_ff_cmd.c
 create mode 100644 drivers/staging/media/saa716x/saa716x_ff_cmd.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_ff_ir.c
 create mode 100644 drivers/staging/media/saa716x/saa716x_ff_main.c
 create mode 100644 drivers/staging/media/saa716x/saa716x_ff_phi.c
 create mode 100644 drivers/staging/media/saa716x/saa716x_ff_phi.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_fgpi.c
 create mode 100644 drivers/staging/media/saa716x/saa716x_fgpi.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_fgpi_reg.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_gpio.c
 create mode 100644 drivers/staging/media/saa716x/saa716x_gpio.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_gpio_reg.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_greg.c
 create mode 100644 drivers/staging/media/saa716x/saa716x_greg.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_greg_reg.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_hybrid.c
 create mode 100644 drivers/staging/media/saa716x/saa716x_hybrid.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_i2c.c
 create mode 100644 drivers/staging/media/saa716x/saa716x_i2c.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_i2c_reg.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_mod.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_msi.c
 create mode 100644 drivers/staging/media/saa716x/saa716x_msi.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_msi_reg.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_pci.c
 create mode 100644 drivers/staging/media/saa716x/saa716x_phi.c
 create mode 100644 drivers/staging/media/saa716x/saa716x_phi.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_phi_reg.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_priv.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_rom.c
 create mode 100644 drivers/staging/media/saa716x/saa716x_rom.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_spi.c
 create mode 100644 drivers/staging/media/saa716x/saa716x_spi.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_spi_reg.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_vip.c
 create mode 100644 drivers/staging/media/saa716x/saa716x_vip.h
 create mode 100644 drivers/staging/media/saa716x/saa716x_vip_reg.h
