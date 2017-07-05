Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44114
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751743AbdGEMtv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Jul 2017 08:49:51 -0400
Date: Wed, 5 Jul 2017 09:49:40 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.13-rc1] media updates
Message-ID: <20170705094940.735096aa@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.13-1

For:

- Addition of fwnode support at V4L2 core;
- Addition of a few more SDR formats;
- New imx driver to support i.MX6 cameras;
- New driver for Qualcon venus codecs;
- New I2C sensor drivers: dw9714, max2175, ov13858, ov5640;
- New CEC driver: stm32-cec;
- Some Improvements at DVB frontend documentation and a few fixups;
- Several drivers improvements and fixups.

Regards,
Mauro

--


The following changes since commit 41f1830f5a7af77cf5c86359aba3cbd706687e52:

  Linux 4.12-rc6 (2017-06-19 22:19:37 +0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.13-1

for you to fetch changes up to 2a2599c663684a1142dae0bff7737e125891ae6d:

  [media] media: entity: Catch unbalanced media_pipeline_stop calls (2017-06-23 09:23:36 -0300)

----------------------------------------------------------------
media updates for v4.13-rc1

----------------------------------------------------------------
A Sun (4):
      [media] mceusb: sporadic RX truncation corruption fix
      [media] mceusb: fix inaccurate debug buffer dumps, and misleading debug messages
      [media] mceusb: RX -EPIPE (urb status = -32) lockup failure fix
      [media] mceusb: TX -EPIPE (urb status = -32) lockup fix

Alan Cox (10):
      [media] atompisp: HAS_BL is never defined so lose it
      [media] atomisp: remove NUM_OF_BLS
      [media] atomisp2: remove HRT_UNSCHED
      [media] atomisp2: tidy up confused ifdefs
      [media] atomisp: eliminate dead code under HAS_RES_MGR
      [media] atomisp: unify sh_css_hmm_buffer_record_acquire
      [media] atomisp: Unify load_preview_binaries for the most part
      [media] atomisp: Unify lut free logic
      [media] atomisp: remove sh_css_irq - it contains nothing
      [media] atomisp: de-duplicate sh_css_mmu_set_page_table_base_index

Alex Deryskyba (1):
      [media] rc: meson-ir: switch config to NEC decoding on shutdown

Alexandre Courbot (2):
      [media] media-ioc-g-topology.rst: fix typos
      [media] s5p-jpeg: fix recursive spinlock acquisition

Andi Shyti (1):
      [media] rc: ir-spi: remove unnecessary initialization

Andrey Utkin (2):
      [media] MAINTAINERS: solo6x10, tw5864: add Anton Sviridenko
      [media] MAINTAINERS: solo6x10: update Andrey Utkin email

Andy Shevchenko (1):
      [media] as3645a: Join string literals back

Anton Blanchard (1):
      [media] ir-spi: Fix issues with lirc API

Antti Palosaari (15):
      [media] af9015: use correct 7-bit i2c addresses
      [media] af9013: move config values directly under driver state
      [media] af9013: add i2c client bindings
      [media] af9013: use kernel 64-bit division
      [media] af9013: fix logging
      [media] af9013: convert to regmap api
      [media] af9013: fix error handling
      [media] af9013: add dvbv5 cnr
      [media] af9015: fix and refactor i2c adapter algo logic
      [media] af9015: enable 2nd TS flow control when dual mode
      [media] af9013: add configurable TS output pin
      [media] af9013: remove unneeded register writes
      [media] af9015: move 2nd demod power-up wait different location
      [media] af9013: refactor firmware download routine
      [media] af9013: refactor power control

Arnd Bergmann (6):
      [media] rainshadow-cec: use strlcat instead of strncat
      [media] rainshadow-cec: avoid -Wmaybe-uninitialized warning
      [media] cec: improve MEDIA_CEC_RC dependencies
      [media] cec-notifier.h: handle unreachable CONFIG_CEC_CORE
      [media] ir-core: fix gcc-7 warning on bool arithmetic
      [media] dvb: don't use 'time_t' in event ioctl

Arvind Yadav (1):
      [media] tc358743: Handle return value of clk_prepare_enable

Avraham Shukron (3):
      [media] atomisp: fixed sparse warnings
      [media] atomisp: fixed coding style errors
      [media] atomisp: fix coding style warnings

Benjamin Gaignard (5):
      [media] cec: stih: allow to use max CEC logical addresses
      [media] cec: stih: fix typos in comments
      [media] dt-bindings: media: stm32 cec driver
      [media] cec: add STM32 cec driver
      [media] exynos4-is: use devm_of_platform_populate()

Chen Guanqiao (1):
      [media] staging: atomisp: lm3554: fix sparse warnings(was not declared. Should it be static?)

Christoph Fanelsa (1):
      [media] staging: media: cxd2099: Fix checkpatch issues

Christophe JAILLET (2):
      [media] vb2: Fix an off by one error in 'vb2_plane_vaddr'
      [media] vb2: Fix error handling in '__vb2_buf_mem_alloc'

Colin Ian King (4):
      [media] cx18: fix spelling mistake: "demodualtor" -> "demodulator"
      [media] em28xx: fix spelling mistake: "missdetected" -> "misdetected"
      [media] pvrusb2: remove redundant check on cnt > 8
      [media] s5p-mfc: fix spelling mistake: "destionation" -> "destination"

Dan Carpenter (3):
      [media] atomisp: one char read beyond end of string
      [media] atomisp: putting NULs in the wrong place
      [media] atomisp2: off by one in atomisp_s_input()

Daniel Kurtz (1):
      [media] media: mtk-mdp: Fix mdp device tree

Daniel Roschka (1):
      [media] uvcvideo: Quirk for webcam in MacBook Pro 2016

Daniel Scheller (32):
      [media] dvb-frontends/stv0367: add flag to make i2c_gatectrl optional
      [media] dvb-frontends/stv0367: print CPAMP status only if stv_debug is enabled
      [media] dvb-frontends/stv0367: refactor defaults table handling
      [media] dvb-frontends/stv0367: move out tables, support multiple tab variants
      [media] dvb-frontends/stv0367: make PLLSETUP a function, add 58MHz IC speed
      [media] dvb-frontends/stv0367: make full reinit on set_frontend() optional
      [media] dvb-frontends/stv0367: support reading if_khz from tuner config
      [media] dvb-frontends/stv0367: selectable QAM FEC Lock status register
      [media] dvb-frontends/stv0367: fix symbol rate conditions in cab_SetQamSize()
      [media] dvb-frontends/stv0367: add defaults for use w/DD-branded devices
      [media] dvb-frontends/stv0367: add Digital Devices compatibility
      [media] ddbridge: add i2c_read_regs()
      [media] ddbridge: support STV0367-based cards and modules
      [media] dvb-frontends/cxd2841er: remove kernel log spam in non-debug levels
      [media] dvb-frontends/cxd2841er: do I2C reads in one go
      [media] dvb-frontends/cxd2841er: immediately unfreeze regs when done
      [media] dvb-frontends/cxd2841er: support CXD2837/38/43ER demods/Chip IDs
      [media] dvb-frontends/cxd2841er: replace IFFREQ calc macros into functions
      [media] dvb-frontends/cxd2841er: add variable for configuration flags
      [media] dvb-frontends/cxd2841er: make call to i2c_gate_ctrl optional
      [media] dvb-frontends/cxd2841er: support IF speed calc from tuner values
      [media] dvb-frontends/cxd2841er: TS_SERIAL config flag
      [media] dvb-frontends/cxd2841er: make ASCOT use optional
      [media] dvb-frontends/cxd2841er: optionally tune earlier in set_frontend()
      [media] dvb-frontends/cxd2841er: make lock wait in set_fe_tc() optional
      [media] dvb-frontends/cxd2841er: configurable IFAGCNEG
      [media] dvb-frontends/cxd2841er: more configurable TSBITS
      [media] dvb-frontends/cxd2841er: improved snr reporting
      [media] ddbridge: board control setup, ts quirk flags
      [media] ddbridge: add I2C functions, add XO2 module support
      [media] ddbridge: support for Sony CXD28xx C/C2/T/T2 tuner modules
      [media] ddbridge: hardware IDs for new C2T2 cards and other devices

Dave Stevenson (3):
      [media] tc358743: Add enum_mbus_code
      [media] tc358743: Setup default mbus_fmt before registering
      [media] tc358743: Add support for platforms without IRQ line

David Härdeman (21):
      [media] rc-core: fix input repeat handling
      [media] ir-lirc-codec: let lirc_dev handle the lirc_buffer
      [media] lirc_dev: remove pointless functions
      [media] lirc_dev: remove unused set_use_inc/set_use_dec
      [media] lirc_dev: remove sampling kthread
      [media] lirc_dev: clarify error handling
      [media] lirc_dev: make fops mandatory
      [media] lirc_dev: merge lirc_register_driver() and lirc_allocate_driver()
      [media] lirc_zilog: remove module parameter minor
      [media] lirc_dev: remove lirc_irctl_init() and lirc_cdev_add()
      [media] lirc_dev: remove superfluous get/put_device() calls
      [media] lirc_dev: remove unused module parameter
      [media] lirc_dev: return POLLHUP and POLLERR when device is gone
      [media] lirc_dev: cleanup includes
      [media] lirc_dev: cleanup header
      [media] rc-core: ati_remote - leave the internals of rc_dev alone
      [media] rc-core: img-ir - leave the internals of rc_dev alone
      [media] rc-core: cx231xx - leave the internals of rc_dev alone
      [media] tm6000: key_addr is unused
      [media] rc-core: cleanup rc_register_device
      [media] rc-core: cleanup rc_register_device pt2

Devin Heitmueller (13):
      [media] cx88: Fix regression in initial video standard setting
      [media] mxl111sf: Fix driver to use heap allocate buffers for USB messages
      [media] au8522: don't attempt to configure unsupported VBI slicer
      [media] au8522: don't touch i2c master registers on au8522
      [media] au8522: rework setup of audio routing
      [media] au8522: remove note about VBI not being implemented
      [media] au8522: remove leading bit for register writes
      [media] au8522 Remove 0x4 bit for register reads
      [media] au8522: fix lock detection to be more reliable
      [media] xc5000: Don't spin waiting for analog lock
      [media] au8522: Set the initial modulation
      [media] au0828: Add timer to restart TS stream if no data arrives on bulk endpoint
      [media] rc: fix breakage in "make menuconfig" for media_build

Fabrizio Perria (1):
      [media] atomisp: Fix unnecessary initialization of static

Frank Schaefer (1):
      [media] em28xx: fix+improve the register (usb control message) debugging

Guru Das Srinagesh (2):
      [media] atomisp: use logical AND, not bitwise
      [media] atomisp: Make undeclared symbols static

Gustavo A. R. Silva (5):
      [media] media: platform: coda: remove variable self assignment
      [media] media: i2c: initialize scalar variables
      [media] s3c-camif: fix arguments position in a function call
      [media] i2c: tc358743: remove useless variable assignment in tc358743_isr
      [media] af9013: add check on af9013_wr_regs() return value

Hans Verkuil (14):
      [media] v4l2-ioctl.c: always copy G/S_EDID result
      [media] cec: improve debug messages
      [media] cec: add cec_s_phys_addr_from_edid helper function
      [media] cec: add cec_phys_addr_invalidate() helper function
      [media] cec: add cec_transmit_attempt_done helper function
      [media] stih-cec/vivid/pulse8/rainshadow: use cec_transmit_attempt_done
      [media] cec: add CEC_CAP_NEEDS_HPD
      [media] cec-ioc-adap-g-caps.rst: document CEC_CAP_NEEDS_HPD
      [media] dt-bindings: media/s5p-cec.txt: document needs-hpd property
      [media] s5p_cec: set the CEC_CAP_NEEDS_HPD flag if needed
      [media] dt-bindings: add media/cec.txt
      [media] dt-bindings: media/s5p-cec.txt, media/stih-cec.txt: refer to cec.txt
      [media] v4l2-ioctl/exynos: fix G/S_SELECTION's type handling
      [media] media/uapi/v4l: clarify cropcap/crop/selection behavior

Hans de Goede (9):
      [media] atomisp: Fix -Werror=int-in-bool-context compile errors
      [media] staging: atomisp: Fix calling efivar_entry_get() with unaligned arguments
      [media] staging: atomisp: Do not call dev_warn with a NULL device
      [media] staging: atomisp: Set step to 0 for mt9m114 menu control
      [media] staging: atomisp: Add INT0310 ACPI id to gc0310 driver
      [media] staging: atomisp: Add OVTI2680 ACPI id to ov2680 driver
      [media] staging: atomisp: Ignore errors from second gpio in ov2680 driver
      [media] staging: atomisp: Make ov2680 driver less chatty
      [media] staging: atomisp: Fix endless recursion in hmm_init

Heiner Kallweit (5):
      [media] rc: meson-ir: remove irq from struct meson_ir
      [media] rc: meson-ir: make use of the bitfield macros
      [media] rc: meson-ir: switch to managed rc device allocation / registration
      [media] rc: meson-ir: use readl_relaxed in the interrupt handler
      [media] rc: meson-ir: change irq name to to of node name

Helen Fornazier (12):
      [media] vimc: sen: Integrate the tpg on the sensor
      [media] vimc: Move common code from the core
      [media] vimc: common: Add vimc_ent_sd_* helper
      [media] vimc: common: Add vimc_pipeline_s_stream helper
      [media] vimc: common: Add vimc_link_validate
      [media] vimc: common: Add vimc_colorimetry_clamp
      [media] vimc: sen: Support several image formats
      [media] vimc: cap: Support several image formats
      [media] vimc: Subdevices as modules
      [media] vimc: deb: Add debayer filter
      [media] vimc: sca: Add scaler
      [media] vimc: sen: Declare vimc_sen_video_ops as static

Hirokazu Honda (1):
      [media] mtk-vcodec: Show mtk driver error without DEBUG definition

Hugues Fruchet (3):
      [media] dt-bindings: Document STM32 DCMI bindings
      [media] stm32-dcmi: STM32 DCMI camera interface driver
      [media] atmel-isi: code cleanup

Hyungwoo Yang (1):
      [media] ov13858: add support for OV13858 sensor

Jacopo Mondi (1):
      [media] media: i2c: ov772x: Force use of SCCB protocol

Jasmin Jessich (2):
      [media] dvb_ca_en50221: use foo *bar, instead of foo * bar
      [media] dvb_ca_en50221: Fix wrong EXPORT_SYMBOL order

Jia-Ju Bai (2):
      [media] ivtv: Fix a sleep-in-atomic bug in snd_ivtv_pcm_hw_free
      [media] cx18: Fix a sleep-in-atomic bug in snd_cx18_pcm_hw_free

Joe Perches (1):
      [media] atomisp: Add __printf validation and fix fallout

Johan Hovold (3):
      [media] usbvision: add missing USB-descriptor endianness conversions
      [media] mceusb: fix memory leaks in error path
      [media] mceusb: drop redundant urb reinitialisation

Jonas Karlman (1):
      [media] rc: meson-ir: store raw event without processing

Juan Antonio Pedreira Martos (1):
      [media] staging: media: atomisp: fix non static symbol warnings

Kevin Hilman (4):
      [media] davinci: vpif_capture: drop compliance hack
      [media] davinci: vpif_capture: get subdevs from DT when available
      [media] davinci: vpif_capture: cleanup raw camera support
      [media] davinci: vpif: adaptions for DT support

Kieran Bingham (3):
      [media] v4l: subdev: tolerate null in media_entity_to_v4l2_subdev
      [media] media: fdp1: Support ES2 platforms
      [media] media: entity: Catch unbalanced media_pipeline_stop calls

Lucas Stach (3):
      [media] coda: use correct offset for mvcol buffer
      [media] coda: first step at error recovery
      [media] coda/imx-vdoa: always wait for job completion

Manny Vindiola (1):
      [media] atomisp: fix missing blank line coding style issue in atomisp_tpg.c

Marek Szyprowski (1):
      [media] s5p-cec: update MAINTAINERS entry

Marek Vasut (1):
      [media] media: imx: Drop warning upon multiple S_STREAM disable calls

Mauro Carvalho Chehab (23):
      Merge tag 'v4.12-rc1' into patchwork
      [media] atomisp: don't treat warnings as errors
      [media] bcm3510: fix handling of VSB16 modulation
      [media] saa7164: better handle error codes
      [media] bt8xx: add missing break
      [media] dvb-usb-remote: don't write bogus debug messages
      [media] media drivers: annotate fall-through
      [media] s5p-jpeg: don't return a random width/height
      [media] mtk_vcodec_dec: return error at mtk_vdec_pic_info_update()
      [media] atomisp: disable several warnings when W=1
      [media] av7110: avoid switch fall through
      [media] zoran: annotate switch fall through
      [media] soc_camera: annotate a switch fall through
      [media] s2255drv: avoid a switch fall through
      [media] uvcvideo: annotate a switch fall through
      Merge tag 'media/v4.12-2' into patchwork
      [media] platform/Makefile: don't depend on arch to include dirs
      [media] staging: css2400/Makefile: don't include non-existing files
      [media] atomisp: use correct dialect to disable warnings
      [media] max2175: remove an useless comparision
      [media] ov13858: remove duplicated const declaration
      Merge tag 'v4.12-rc6' into patchwork
      [media] dvb uapi docs: enums are passed by value, not reference

Minghsiu Tsai (1):
      [media] dt-bindings: mt8173: Fix mdp device tree

Nicholas Mc Guire (1):
      [media] s5k6aa: set usleep_range() range greater than 0

Niklas Söderlund (19):
      [media] rcar-vin: reset bytesperline and sizeimage when resetting format
      [media] rcar-vin: use rvin_reset_format() in S_DV_TIMINGS
      [media] rcar-vin: fix how pads are handled for v4l2 subdevice operations
      [media] rcar-vin: fix standard in input enumeration
      [media] rcar-vin: move subdev source and sink pad index to rvin_graph_entity
      [media] rcar-vin: refactor pad lookup code
      [media] rcar-vin: move pad lookup to async bound handler
      [media] rcar-vin: use pad information when verifying media bus format
      [media] rcar-vin: decrease buffers needed to capture
      [media] rcar-vin: move functions which acts on hardware
      [media] rcar-vin: select capture mode based on free buffers
      [media] rcar-vin: allow switch between capturing modes when stalling
      [media] rcar-vin: refactor and fold in function after stall handling rework
      [media] rcar-vin: remove subdevice matching from bind and unbind callbacks
      [media] rcar-vin: add missing error check to propagate error
      [media] rcar-vin: fix bug in pixelformat selection
      [media] v4l: async: check for v4l2_dev in v4l2_async_notifier_register()
      [media] media: entity: Add get_fwnode_pad entity operation
      [media] media: entity: Add media_entity_get_fwnode_pad() function

Nori, Sekhar (1):
      [media] davinci: vpif_capture: fix default pixel format for BT.656/BT.1120 video

Oleh Kravchenko (1):
      [media] cx231xx: Initial support Astrometa T2hybrid

Pan Bian (3):
      [media] m5602_s5k83a: check return value of kthread_create
      [media] cobalt: fix unchecked return values
      [media] cx25840: fix unchecked return values

Paolo Cretaro (1):
      [media] atomisp: use NULL instead of 0 for pointers

Pavel Machek (1):
      [media] Doc*/media/uapi: fix control name

Peter Boström (1):
      [media] uvcvideo: Add iFunction or iInterface to device names

Petr Cvek (5):
      [media] pxa_camera: fix module remove codepath for v4l2 clock
      [media] pxa_camera: Add remaining Bayer 8 formats
      [media] pxa_camera: Fix incorrect test in the image size generation
      [media] pxa_camera: Add (un)subscribe_event ioctl
      [media] pxa_camera: Fix a call with an uninitialized device pointer

Philipp Zabel (12):
      [media] tc358743: fix register i2c_rd/wr function fix
      [media] coda: simplify optional reset handling
      [media] coda: improve colorimetry handling
      [media] coda: implement forced key frames
      [media] coda: copy headers in front of every I-frame
      [media] dt-bindings: Add bindings for video-multiplexer device
      [media] add mux and video interface bridge entity functions
      [media] platform: add video-multiplexer subdevice driver
      [media] MAINTAINERS: add maintainer entry for video multiplexer v4l2 subdevice driver
      [media] media: imx: csi: increase burst size for YUV formats
      [media] media: imx: csi: add frame skipping support
      [media] media: imx: csi: add sink selection rectangles

Rajmohan Mani (1):
      [media] dw9714: Initial driver for dw9714 VCM

Ramesh Shanmugasundaram (8):
      [media] media: v4l2-ctrls: Reserve controls for MAX217X
      [media] dt-bindings: media: Add MAX2175 binding description
      [media] media: i2c: max2175: Add MAX2175 support
      [media] media: Add new SDR formats PC16, PC18 & PC20
      [media] doc_rst: media: New SDR formats PC16, PC18 & PC20
      [media] dt-bindings: media: Add Renesas R-Car DRIF binding
      [media] media: platform: rcar_drif: Add DRIF support
      [media] MAINTAINERS: Add entry for R-Car DRIF & MAX2175 drivers

Rene Hickersberger (1):
      [media] media: s5p-cec: Fixed spelling mistake

Ricardo Silva (5):
      [media] lirc_zilog: Fix whitespace style checks
      [media] lirc_zilog: Fix NULL comparisons style
      [media] lirc_zilog: Use __func__ for logging function name
      [media] lirc_zilog: Use sizeof(*p) instead of sizeof(struct P)
      [media] lirc_zilog: Fix unbalanced braces around if/else

Russell King (3):
      [media] media: imx: csi: add support for bayer formats
      [media] media: imx: csi: add frame size/interval enumeration
      [media] media: imx: capture: add frame sizes/interval enumeration

Sakari Ailus (14):
      [media] v4l: fwnode: Support generic fwnode for parsing standardised properties
      [media] v4l: async: Add fwnode match support
      [media] v4l: flash led class: Use fwnode_handle instead of device_node in init
      [media] v4l: Switch from V4L2 OF not V4L2 fwnode API
      [media] docs-rst: media: Switch documentation to V4L2 fwnode API
      [media] v4l: Remove V4L2 OF framework in favour of V4L2 fwnode framework
      [media] v4l2-ctrls.c: Implement unlocked variant of v4l2_ctrl_handler_setup()
      [media] v4l2-ctrls: Correctly destroy mutex in v4l2_ctrl_handler_free()
      [media] davinci: Switch from V4L2 OF to V4L2 fwnode
      [media] ad5820: unregister async sub-device
      [media] vb2: Rename confusingly named internal buffer preparation functions
      [media] vb2: Move buffer cache synchronisation to prepare from queue
      [media] v4l: ctrls: Add a control for digital gain
      [media] v4l: controls: Improve documentation for V4L2_CID_GAIN

Sean Young (7):
      [media] sir_ir: infinite loop in interrupt handler
      [media] sir_ir: attempt to free already free_irq
      [media] sir_ir: use dev managed resources
      [media] sir_ir: remove init_port and drop_port functions
      [media] sir_ir: remove init_chrdev and init_sir_ir functions
      [media] staging: remove todo and replace with lirc_zilog todo
      [media] sir_ir: annotate hardware config module parameters

Songjun Wu (1):
      [media] atmel-isc: Set the default DMA memory burst size

Stanimir Varbanov (19):
      [media] media: v4l2-mem2mem: extend m2m APIs for more accurate buffer management
      [media] doc: DT: venus: binding document for Qualcomm video driver
      [media] MAINTAINERS: Add Qualcomm Venus video accelerator driver
      [media] media: venus: adding core part and helper functions
      [media] media: venus: vdec: add video decoder files
      [media] media: venus: venc: add video encoder files
      [media] media: venus: hfi: add Host Firmware Interface (HFI)
      [media] media: venus: hfi: add Venus HFI files
      [media] media: venus: enable building of Venus video driver
      [media] media: venus: hfi: fix mutex unlock
      [media] media: venus: hfi_cmds: fix variable dereferenced before check
      [media] media: venus: helpers: fix variable dereferenced before check
      [media] media: venus: hfi_venus: fix variable dereferenced before check
      [media] media: venus: hfi_msgs: fix set but not used variables
      [media] media: venus: vdec: fix compile error in vdec_close
      [media] media: venus: venc: fix compile error in venc_close
      [media] media: venus: vdec: add support for min buffers for capture
      [media] media: venus: update firmware path with linux-firmware place
      [media] media: venus: enable building with COMPILE_TEST

Steve Longerbeam (14):
      [media] dt/bindings: Add bindings for OV5640
      [media] add Omnivision OV5640 sensor driver
      [media] MAINTAINERS: add entry for OV5640 sensor driver
      [media] dt-bindings: Add bindings for i.MX media driver
      [media] media: Add userspace header file for i.MX
      [media] media: Add i.MX media core driver
      [media] media: imx: Add a TODO file
      [media] media: imx: Add Capture Device Interface
      [media] media: imx: Add CSI subdev driver
      [media] media: imx: Add VDIC subdev driver
      [media] media: imx: Add IC subdev drivers
      [media] media: imx: Add MIPI CSI-2 Receiver subdev driver
      [media] media: imx: set and propagate default field, colorimetry
      [media] MAINTAINERS: add entry for Freescale i.MX media driver

Steven Toth (1):
      [media] saa7164: fix double fetch PCIe access condition

Thibault Saunier (1):
      [media] exynos-gsc: Use user configured colorspace if provided

Tomasz Figa (1):
      [media] v4l2-core: Use kvmalloc() for potentially big allocations

Ulrich Hecht (2):
      [media] media: adv7180: Add adv7180cp, adv7180st bindings
      [media] media: adv7180: add adv7180cp, adv7180st compatible strings

Valentin Vidic (1):
      [media] atomisp: drop unused qos variable

Wei Yongjun (2):
      [media] rainshadow-cec: Fix missing spin_lock_init()
      [media] s5p-cec: remove unused including <linux/version.h>

Wolfram Sang (2):
      [media] rcar_vin: use proper name for the R-Car SoC
      [media] v4l: rcar_fdp1: use proper name for the R-Car SoC

 Documentation/devicetree/bindings/media/cec.txt    |    8 +
 .../devicetree/bindings/media/i2c/adv7180.txt      |   15 +
 .../devicetree/bindings/media/i2c/max2175.txt      |   59 +
 .../devicetree/bindings/media/i2c/ov5640.txt       |   45 +
 Documentation/devicetree/bindings/media/imx.txt    |   53 +
 .../devicetree/bindings/media/mediatek-mdp.txt     |   12 +-
 .../devicetree/bindings/media/qcom,venus.txt       |  107 +
 .../devicetree/bindings/media/rcar_vin.txt         |    4 +-
 .../devicetree/bindings/media/renesas,drif.txt     |  176 ++
 .../devicetree/bindings/media/s5p-cec.txt          |    6 +-
 .../devicetree/bindings/media/st,stm32-cec.txt     |   19 +
 .../devicetree/bindings/media/st,stm32-dcmi.txt    |   45 +
 .../devicetree/bindings/media/stih-cec.txt         |    2 +-
 .../devicetree/bindings/media/video-mux.txt        |   60 +
 .../devicetree/bindings/property-units.txt         |    1 +
 Documentation/media/kapi/cec-core.rst              |   18 +
 Documentation/media/kapi/v4l2-core.rst             |    2 +-
 Documentation/media/kapi/v4l2-fwnode.rst           |    3 +
 Documentation/media/kapi/v4l2-of.rst               |    3 -
 .../media/uapi/cec/cec-ioc-adap-g-caps.rst         |    8 +
 .../media/uapi/dvb/fe-diseqc-send-burst.rst        |    4 +-
 Documentation/media/uapi/dvb/fe-set-tone.rst       |    4 +-
 Documentation/media/uapi/dvb/fe-set-voltage.rst    |    7 +-
 .../media/uapi/mediactl/media-ioc-g-topology.rst   |    8 +-
 Documentation/media/uapi/mediactl/media-types.rst  |   21 +
 Documentation/media/uapi/v4l/control.rst           |    6 +
 Documentation/media/uapi/v4l/extended-controls.rst |    9 +-
 .../media/uapi/v4l/pixfmt-sdr-pcu16be.rst          |   55 +
 .../media/uapi/v4l/pixfmt-sdr-pcu18be.rst          |   55 +
 .../media/uapi/v4l/pixfmt-sdr-pcu20be.rst          |   54 +
 Documentation/media/uapi/v4l/sdr-formats.rst       |    3 +
 Documentation/media/uapi/v4l/vidioc-cropcap.rst    |   23 +-
 Documentation/media/uapi/v4l/vidioc-g-crop.rst     |   22 +-
 .../media/uapi/v4l/vidioc-g-selection.rst          |   22 +-
 Documentation/media/v4l-drivers/imx.rst            |  614 +++++
 Documentation/media/v4l-drivers/index.rst          |    1 +
 Documentation/media/v4l-drivers/max2175.rst        |   62 +
 MAINTAINERS                                        |   78 +-
 drivers/leds/leds-aat1290.c                        |    5 +-
 drivers/leds/leds-max77693.c                       |    5 +-
 drivers/media/cec/cec-adap.c                       |   88 +-
 drivers/media/cec/cec-api.c                        |    5 +-
 drivers/media/cec/cec-core.c                       |    1 +
 drivers/media/dvb-core/dvb_ca_en50221.c            |   39 +-
 drivers/media/dvb-frontends/Kconfig                |    1 +
 drivers/media/dvb-frontends/af9013.c               | 1186 +++++-----
 drivers/media/dvb-frontends/af9013.h               |   86 +-
 drivers/media/dvb-frontends/af9013_priv.h          |    2 +
 drivers/media/dvb-frontends/au8522_common.c        |    1 +
 drivers/media/dvb-frontends/au8522_decoder.c       |   74 +-
 drivers/media/dvb-frontends/au8522_dig.c           |  215 +-
 drivers/media/dvb-frontends/bcm3510.c              |    4 +-
 drivers/media/dvb-frontends/cxd2841er.c            |  302 ++-
 drivers/media/dvb-frontends/cxd2841er.h            |   10 +
 drivers/media/dvb-frontends/cxd2841er_priv.h       |    3 +
 drivers/media/dvb-frontends/dib7000p.c             |    6 +-
 drivers/media/dvb-frontends/drx39xyj/drxj.c        |   20 +-
 drivers/media/dvb-frontends/drxd_hard.c            |   10 +-
 drivers/media/dvb-frontends/drxk_hard.c            |   20 +-
 drivers/media/dvb-frontends/mt352.c                |    1 +
 drivers/media/dvb-frontends/or51132.c              |    4 +-
 drivers/media/dvb-frontends/s5h1411.c              |    4 +-
 drivers/media/dvb-frontends/stv0367.c              | 1168 ++++------
 drivers/media/dvb-frontends/stv0367.h              |   13 +
 drivers/media/dvb-frontends/stv0367_defs.h         | 1301 +++++++++++
 drivers/media/dvb-frontends/stv0367_regs.h         |    4 -
 drivers/media/dvb-frontends/zl10353.c              |    3 +-
 drivers/media/i2c/Kconfig                          |   51 +
 drivers/media/i2c/Makefile                         |    5 +
 drivers/media/i2c/ad5820.c                         |    2 +-
 drivers/media/i2c/adv7180.c                        |    2 +
 drivers/media/i2c/adv7604.c                        |    7 +-
 drivers/media/i2c/as3645a.c                        |   12 +-
 drivers/media/i2c/cx25840/cx25840-core.c           |   36 +-
 drivers/media/i2c/dw9714.c                         |  291 +++
 drivers/media/i2c/max2175.c                        | 1453 ++++++++++++
 drivers/media/i2c/max2175.h                        |  109 +
 drivers/media/i2c/msp3400-kthreads.c               |    1 +
 drivers/media/i2c/mt9v032.c                        |    7 +-
 drivers/media/i2c/ov13858.c                        | 1816 +++++++++++++++
 drivers/media/i2c/ov2659.c                         |   11 +-
 drivers/media/i2c/ov5640.c                         | 2344 ++++++++++++++++++++
 drivers/media/i2c/ov5645.c                         |    7 +-
 drivers/media/i2c/ov5647.c                         |    7 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |    7 +-
 drivers/media/i2c/s5k5baf.c                        |    6 +-
 drivers/media/i2c/s5k6aa.c                         |    2 +-
 drivers/media/i2c/smiapp/Kconfig                   |    1 +
 drivers/media/i2c/smiapp/smiapp-core.c             |   29 +-
 drivers/media/i2c/soc_camera/ov6650.c              |    2 +
 drivers/media/i2c/soc_camera/ov772x.c              |    6 +-
 drivers/media/i2c/tc358743.c                       |   77 +-
 drivers/media/i2c/tvp514x.c                        |    6 +-
 drivers/media/i2c/tvp5150.c                        |    7 +-
 drivers/media/i2c/tvp7002.c                        |    6 +-
 drivers/media/media-entity.c                       |   43 +-
 drivers/media/pci/bt8xx/dst_ca.c                   |    1 +
 drivers/media/pci/cobalt/cobalt-driver.c           |    2 +
 drivers/media/pci/cx18/cx18-alsa-pcm.c             |    4 +-
 drivers/media/pci/cx18/cx18-dvb.c                  |    2 +-
 drivers/media/pci/cx23885/cx23885-cards.c          |    3 +-
 drivers/media/pci/cx88/cx88-cards.c                |    9 +-
 drivers/media/pci/cx88/cx88-video.c                |    4 +-
 drivers/media/pci/ddbridge/Kconfig                 |    6 +
 drivers/media/pci/ddbridge/ddbridge-core.c         |  531 ++++-
 drivers/media/pci/ddbridge/ddbridge-regs.h         |    4 +
 drivers/media/pci/ddbridge/ddbridge.h              |   41 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c             |    4 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |    3 +-
 drivers/media/pci/saa7134/saa7134-cards.c          |    4 +-
 drivers/media/pci/saa7164/saa7164-bus.c            |   13 +-
 drivers/media/pci/saa7164/saa7164-cmd.c            |    2 +
 drivers/media/pci/solo6x10/solo6x10-core.c         |    1 +
 drivers/media/pci/solo6x10/solo6x10-i2c.c          |    1 +
 drivers/media/pci/ttpci/av7110.c                   |    5 +
 drivers/media/pci/zoran/zoran_driver.c             |    2 +
 drivers/media/platform/Kconfig                     |   74 +
 drivers/media/platform/Makefile                    |   13 +-
 drivers/media/platform/am437x/Kconfig              |    1 +
 drivers/media/platform/am437x/am437x-vpfe.c        |   15 +-
 drivers/media/platform/atmel/Kconfig               |    2 +
 drivers/media/platform/atmel/atmel-isc.c           |   36 +-
 drivers/media/platform/atmel/atmel-isi.c           |   35 +-
 drivers/media/platform/coda/coda-bit.c             |   49 +-
 drivers/media/platform/coda/coda-common.c          |   70 +-
 drivers/media/platform/coda/coda.h                 |    5 +
 drivers/media/platform/coda/imx-vdoa.c             |   49 +-
 drivers/media/platform/davinci/Kconfig             |    1 +
 drivers/media/platform/davinci/vpif.c              |   57 +-
 drivers/media/platform/davinci/vpif_capture.c      |  232 +-
 drivers/media/platform/davinci/vpif_display.c      |    5 +
 drivers/media/platform/exynos-gsc/gsc-core.c       |   13 +-
 drivers/media/platform/exynos-gsc/gsc-core.h       |    1 +
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |    8 +-
 drivers/media/platform/exynos4-is/Kconfig          |    2 +
 drivers/media/platform/exynos4-is/fimc-capture.c   |    7 +-
 drivers/media/platform/exynos4-is/fimc-is.c        |    7 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |    4 +-
 drivers/media/platform/exynos4-is/media-dev.c      |   13 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |    6 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |    1 +
 drivers/media/platform/mtk-mdp/mtk_mdp_core.c      |   12 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c |   10 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_util.h    |   20 +-
 drivers/media/platform/omap3isp/isp.c              |   49 +-
 drivers/media/platform/pxa_camera.c                |   77 +-
 drivers/media/platform/qcom/venus/Makefile         |   11 +
 drivers/media/platform/qcom/venus/core.c           |  390 ++++
 drivers/media/platform/qcom/venus/core.h           |  324 +++
 drivers/media/platform/qcom/venus/firmware.c       |  108 +
 drivers/media/platform/qcom/venus/firmware.h       |   23 +
 drivers/media/platform/qcom/venus/helpers.c        |  725 ++++++
 drivers/media/platform/qcom/venus/helpers.h        |   45 +
 drivers/media/platform/qcom/venus/hfi.c            |  522 +++++
 drivers/media/platform/qcom/venus/hfi.h            |  175 ++
 drivers/media/platform/qcom/venus/hfi_cmds.c       | 1259 +++++++++++
 drivers/media/platform/qcom/venus/hfi_cmds.h       |  304 +++
 drivers/media/platform/qcom/venus/hfi_helper.h     | 1050 +++++++++
 drivers/media/platform/qcom/venus/hfi_msgs.c       | 1052 +++++++++
 drivers/media/platform/qcom/venus/hfi_msgs.h       |  283 +++
 drivers/media/platform/qcom/venus/hfi_venus.c      | 1572 +++++++++++++
 drivers/media/platform/qcom/venus/hfi_venus.h      |   23 +
 drivers/media/platform/qcom/venus/hfi_venus_io.h   |  113 +
 drivers/media/platform/qcom/venus/vdec.c           | 1162 ++++++++++
 drivers/media/platform/qcom/venus/vdec.h           |   23 +
 drivers/media/platform/qcom/venus/vdec_ctrls.c     |  158 ++
 drivers/media/platform/qcom/venus/venc.c           | 1283 +++++++++++
 drivers/media/platform/qcom/venus/venc.h           |   23 +
 drivers/media/platform/qcom/venus/venc_ctrls.c     |  270 +++
 drivers/media/platform/rcar-vin/Kconfig            |    1 +
 drivers/media/platform/rcar-vin/rcar-core.c        |   66 +-
 drivers/media/platform/rcar-vin/rcar-dma.c         |  230 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c        |   97 +-
 drivers/media/platform/rcar-vin/rcar-vin.h         |    9 +-
 drivers/media/platform/rcar_drif.c                 | 1498 +++++++++++++
 drivers/media/platform/rcar_fdp1.c                 |   12 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |    4 +-
 drivers/media/platform/s5p-cec/s5p_cec.c           |    6 +-
 drivers/media/platform/s5p-cec/s5p_cec.h           |    1 -
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |   20 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |    2 +-
 drivers/media/platform/sh_vou.c                    |    2 +
 drivers/media/platform/soc_camera/soc_camera.c     |    7 +-
 drivers/media/platform/soc_camera/soc_mediabus.c   |    1 +
 drivers/media/platform/sti/cec/stih-cec.c          |   16 +-
 drivers/media/platform/stm32/Makefile              |    2 +
 drivers/media/platform/stm32/stm32-cec.c           |  362 +++
 drivers/media/platform/stm32/stm32-dcmi.c          | 1404 ++++++++++++
 drivers/media/platform/ti-vpe/cal.c                |   15 +-
 drivers/media/platform/video-mux.c                 |  334 +++
 drivers/media/platform/vimc/Kconfig                |    1 +
 drivers/media/platform/vimc/Makefile               |   10 +-
 drivers/media/platform/vimc/vimc-capture.c         |  321 +--
 drivers/media/platform/vimc/vimc-capture.h         |   28 -
 drivers/media/platform/vimc/vimc-common.c          |  473 ++++
 drivers/media/platform/vimc/vimc-common.h          |  229 ++
 drivers/media/platform/vimc/vimc-core.c            |  610 ++---
 drivers/media/platform/vimc/vimc-core.h            |  112 -
 drivers/media/platform/vimc/vimc-debayer.c         |  601 +++++
 drivers/media/platform/vimc/vimc-scaler.c          |  455 ++++
 drivers/media/platform/vimc/vimc-sensor.c          |  321 ++-
 drivers/media/platform/vimc/vimc-sensor.h          |   28 -
 drivers/media/platform/vivid/vivid-cec.c           |    6 +-
 drivers/media/platform/xilinx/Kconfig              |    1 +
 drivers/media/platform/xilinx/xilinx-vipp.c        |   63 +-
 drivers/media/rc/Kconfig                           |    8 +-
 drivers/media/rc/ati_remote.c                      |    3 -
 drivers/media/rc/iguanair.c                        |    1 +
 drivers/media/rc/img-ir/img-ir-hw.c                |    4 -
 drivers/media/rc/imon.c                            |    2 +-
 drivers/media/rc/ir-lirc-codec.c                   |   37 +-
 drivers/media/rc/ir-spi.c                          |   11 +-
 drivers/media/rc/lirc_dev.c                        |  254 +--
 drivers/media/rc/mceusb.c                          |  158 +-
 drivers/media/rc/meson-ir.c                        |   89 +-
 drivers/media/rc/rc-core-priv.h                    |    2 +
 drivers/media/rc/rc-ir-raw.c                       |   36 +-
 drivers/media/rc/rc-main.c                         |  160 +-
 drivers/media/rc/sir_ir.c                          |   94 +-
 drivers/media/tuners/tda18271-fe.c                 |    2 +-
 drivers/media/tuners/xc5000.c                      |   27 +-
 drivers/media/usb/au0828/au0828-dvb.c              |   30 +
 drivers/media/usb/au0828/au0828.h                  |    2 +
 drivers/media/usb/cpia2/cpia2_core.c               |   51 +-
 drivers/media/usb/cx231xx/Kconfig                  |    2 +
 drivers/media/usb/cx231xx/cx231xx-cards.c          |   34 +
 drivers/media/usb/cx231xx/cx231xx-dvb.c            |   49 +
 drivers/media/usb/cx231xx/cx231xx-input.c          |    5 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |    2 +-
 drivers/media/usb/cx231xx/cx231xx.h                |    1 +
 drivers/media/usb/dvb-usb-v2/af9015.c              |  199 +-
 drivers/media/usb/dvb-usb-v2/af9015.h              |    4 +-
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |    1 +
 drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c        |    4 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c            |   32 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.h            |    8 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c        |    1 +
 drivers/media/usb/dvb-usb/dvb-usb-remote.c         |    5 +
 drivers/media/usb/dvb-usb/dw2102.c                 |    4 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |    4 +-
 drivers/media/usb/em28xx/em28xx-core.c             |   35 +-
 drivers/media/usb/gspca/m5602/m5602_s5k83a.c       |    5 +
 drivers/media/usb/gspca/ov519.c                    |    3 +-
 drivers/media/usb/pulse8-cec/pulse8-cec.c          |    9 +-
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c       |    2 +-
 drivers/media/usb/pwc/pwc-v4l.c                    |    3 +-
 drivers/media/usb/rainshadow-cec/rainshadow-cec.c  |   14 +-
 drivers/media/usb/s2255/s2255drv.c                 |    2 +
 drivers/media/usb/tm6000/tm6000-input.c            |    4 -
 drivers/media/usb/usbvision/usbvision-i2c.c        |    3 +
 drivers/media/usb/usbvision/usbvision-video.c      |    4 +-
 drivers/media/usb/uvc/uvc_driver.c                 |   34 +-
 drivers/media/usb/uvc/uvc_video.c                  |    4 +-
 drivers/media/v4l2-core/Kconfig                    |    3 +
 drivers/media/v4l2-core/Makefile                   |    4 +-
 drivers/media/v4l2-core/v4l2-async.c               |   29 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |   51 +-
 drivers/media/v4l2-core/v4l2-event.c               |    8 +-
 drivers/media/v4l2-core/v4l2-flash-led-class.c     |   12 +-
 drivers/media/v4l2-core/v4l2-fwnode.c              |  345 +++
 drivers/media/v4l2-core/v4l2-ioctl.c               |   94 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   37 +
 drivers/media/v4l2-core/v4l2-of.c                  |  327 ---
 drivers/media/v4l2-core/v4l2-subdev.c              |    8 +-
 drivers/media/v4l2-core/videobuf2-core.c           |   40 +-
 drivers/media/v4l2-core/videobuf2-dma-sg.c         |    8 +-
 drivers/staging/media/Kconfig                      |    2 +
 drivers/staging/media/Makefile                     |    1 +
 drivers/staging/media/atomisp/i2c/Makefile         |    6 +
 drivers/staging/media/atomisp/i2c/gc0310.c         |    1 +
 drivers/staging/media/atomisp/i2c/imx/Makefile     |    7 +
 drivers/staging/media/atomisp/i2c/lm3554.c         |    4 +-
 drivers/staging/media/atomisp/i2c/mt9m114.c        |    2 +-
 drivers/staging/media/atomisp/i2c/ov2680.c         |   15 +-
 drivers/staging/media/atomisp/i2c/ov5693/Makefile  |    7 +
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.c  |    2 +-
 .../staging/media/atomisp/pci/atomisp2/Makefile    |    7 +-
 .../atomisp/pci/atomisp2/atomisp_compat_css20.c    |    1 -
 .../media/atomisp/pci/atomisp2/atomisp_fops.c      |   14 +-
 .../media/atomisp/pci/atomisp2/atomisp_ioctl.c     |    2 +-
 .../media/atomisp/pci/atomisp2/atomisp_tpg.c       |    1 +
 .../media/atomisp/pci/atomisp2/atomisp_v4l2.c      |    6 +-
 .../media/atomisp/pci/atomisp2/css2400/Makefile    |    2 -
 .../css2400/hive_isp_css_include/math_support.h    |    6 +-
 .../css2400/hive_isp_css_include/string_support.h  |    9 +-
 .../pci/atomisp2/css2400/ia_css_mmu_private.h      |    2 -
 .../isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c   |    6 +-
 .../isp/kernels/sdis/sdis_2/ia_css_sdis2.host.c    |    2 +-
 .../isp/kernels/tnr/tnr_1.0/ia_css_tnr.host.c      |    2 +-
 .../css2400/isp/modes/interface/isp_const.h        |   16 -
 .../css2400/isp/modes/interface/isp_exprs.h        |   23 -
 .../atomisp2/css2400/runtime/binary/src/binary.c   |   36 +-
 .../pci/atomisp2/css2400/runtime/bufq/src/bufq.c   |    2 +-
 .../css2400/runtime/debug/interface/ia_css_debug.h |    1 +
 .../css2400/runtime/debug/src/ia_css_debug.c       |   13 +-
 .../atomisp2/css2400/runtime/spctrl/src/spctrl.c   |   10 +-
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    |  297 +--
 .../atomisp/pci/atomisp2/css2400/sh_css_firmware.c |   34 +-
 .../atomisp/pci/atomisp2/css2400/sh_css_internal.h |    7 -
 .../atomisp/pci/atomisp2/css2400/sh_css_irq.c      |   16 -
 .../atomisp/pci/atomisp2/css2400/sh_css_mipi.c     |    2 +-
 .../atomisp/pci/atomisp2/css2400/sh_css_mmu.c      |    6 -
 .../atomisp/pci/atomisp2/css2400/sh_css_params.c   |   24 +-
 .../staging/media/atomisp/pci/atomisp2/hmm/hmm.c   |    8 +-
 .../atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c |    4 +-
 .../platform/intel-mid/atomisp_gmin_platform.c     |  227 +-
 .../platform/intel-mid/intel_mid_pcihelpers.c      |   12 +-
 drivers/staging/media/cxd2099/cxd2099.c            |    6 +-
 drivers/staging/media/imx/Kconfig                  |   21 +
 drivers/staging/media/imx/Makefile                 |   12 +
 drivers/staging/media/imx/TODO                     |   23 +
 drivers/staging/media/imx/imx-ic-common.c          |  113 +
 drivers/staging/media/imx/imx-ic-prp.c             |  518 +++++
 drivers/staging/media/imx/imx-ic-prpencvf.c        | 1309 +++++++++++
 drivers/staging/media/imx/imx-ic.h                 |   38 +
 drivers/staging/media/imx/imx-media-capture.c      |  775 +++++++
 drivers/staging/media/imx/imx-media-csi.c          | 1817 +++++++++++++++
 drivers/staging/media/imx/imx-media-dev.c          |  667 ++++++
 drivers/staging/media/imx/imx-media-fim.c          |  494 +++++
 drivers/staging/media/imx/imx-media-internal-sd.c  |  349 +++
 drivers/staging/media/imx/imx-media-of.c           |  270 +++
 drivers/staging/media/imx/imx-media-utils.c        |  896 ++++++++
 drivers/staging/media/imx/imx-media-vdic.c         | 1009 +++++++++
 drivers/staging/media/imx/imx-media.h              |  325 +++
 drivers/staging/media/imx/imx6-mipi-csi2.c         |  698 ++++++
 drivers/staging/media/lirc/TODO                    |   47 +-
 drivers/staging/media/lirc/TODO.lirc_zilog         |   36 -
 drivers/staging/media/lirc/lirc_zilog.c            |  136 +-
 include/linux/imx-media.h                          |   29 +
 include/media/cec.h                                |   29 +
 include/media/davinci/vpif_types.h                 |    9 +-
 include/media/imx.h                                |   15 +
 include/media/lirc_dev.h                           |   32 -
 include/media/media-entity.h                       |   28 +
 include/media/rc-core.h                            |    2 -
 include/media/v4l2-async.h                         |    8 +-
 include/media/v4l2-ctrls.h                         |   13 +
 include/media/v4l2-flash-led-class.h               |    6 +-
 include/media/{v4l2-of.h => v4l2-fwnode.h}         |   96 +-
 include/media/v4l2-mem2mem.h                       |   92 +
 include/media/v4l2-subdev.h                        |   16 +-
 include/uapi/linux/cec.h                           |    2 +
 include/uapi/linux/dvb/video.h                     |    3 +-
 include/uapi/linux/max2175.h                       |   28 +
 include/uapi/linux/media.h                         |    6 +
 include/uapi/linux/v4l2-controls.h                 |   11 +-
 include/uapi/linux/videodev2.h                     |    3 +
 348 files changed, 40503 insertions(+), 5135 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/cec.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/max2175.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5640.txt
 create mode 100644 Documentation/devicetree/bindings/media/imx.txt
 create mode 100644 Documentation/devicetree/bindings/media/qcom,venus.txt
 create mode 100644 Documentation/devicetree/bindings/media/renesas,drif.txt
 create mode 100644 Documentation/devicetree/bindings/media/st,stm32-cec.txt
 create mode 100644 Documentation/devicetree/bindings/media/st,stm32-dcmi.txt
 create mode 100644 Documentation/devicetree/bindings/media/video-mux.txt
 create mode 100644 Documentation/media/kapi/v4l2-fwnode.rst
 delete mode 100644 Documentation/media/kapi/v4l2-of.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-pcu16be.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-pcu18be.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-pcu20be.rst
 create mode 100644 Documentation/media/v4l-drivers/imx.rst
 create mode 100644 Documentation/media/v4l-drivers/max2175.rst
 create mode 100644 drivers/media/dvb-frontends/stv0367_defs.h
 create mode 100644 drivers/media/i2c/dw9714.c
 create mode 100644 drivers/media/i2c/max2175.c
 create mode 100644 drivers/media/i2c/max2175.h
 create mode 100644 drivers/media/i2c/ov13858.c
 create mode 100644 drivers/media/i2c/ov5640.c
 create mode 100644 drivers/media/platform/qcom/venus/Makefile
 create mode 100644 drivers/media/platform/qcom/venus/core.c
 create mode 100644 drivers/media/platform/qcom/venus/core.h
 create mode 100644 drivers/media/platform/qcom/venus/firmware.c
 create mode 100644 drivers/media/platform/qcom/venus/firmware.h
 create mode 100644 drivers/media/platform/qcom/venus/helpers.c
 create mode 100644 drivers/media/platform/qcom/venus/helpers.h
 create mode 100644 drivers/media/platform/qcom/venus/hfi.c
 create mode 100644 drivers/media/platform/qcom/venus/hfi.h
 create mode 100644 drivers/media/platform/qcom/venus/hfi_cmds.c
 create mode 100644 drivers/media/platform/qcom/venus/hfi_cmds.h
 create mode 100644 drivers/media/platform/qcom/venus/hfi_helper.h
 create mode 100644 drivers/media/platform/qcom/venus/hfi_msgs.c
 create mode 100644 drivers/media/platform/qcom/venus/hfi_msgs.h
 create mode 100644 drivers/media/platform/qcom/venus/hfi_venus.c
 create mode 100644 drivers/media/platform/qcom/venus/hfi_venus.h
 create mode 100644 drivers/media/platform/qcom/venus/hfi_venus_io.h
 create mode 100644 drivers/media/platform/qcom/venus/vdec.c
 create mode 100644 drivers/media/platform/qcom/venus/vdec.h
 create mode 100644 drivers/media/platform/qcom/venus/vdec_ctrls.c
 create mode 100644 drivers/media/platform/qcom/venus/venc.c
 create mode 100644 drivers/media/platform/qcom/venus/venc.h
 create mode 100644 drivers/media/platform/qcom/venus/venc_ctrls.c
 create mode 100644 drivers/media/platform/rcar_drif.c
 create mode 100644 drivers/media/platform/stm32/Makefile
 create mode 100644 drivers/media/platform/stm32/stm32-cec.c
 create mode 100644 drivers/media/platform/stm32/stm32-dcmi.c
 create mode 100644 drivers/media/platform/video-mux.c
 delete mode 100644 drivers/media/platform/vimc/vimc-capture.h
 create mode 100644 drivers/media/platform/vimc/vimc-common.c
 create mode 100644 drivers/media/platform/vimc/vimc-common.h
 delete mode 100644 drivers/media/platform/vimc/vimc-core.h
 create mode 100644 drivers/media/platform/vimc/vimc-debayer.c
 create mode 100644 drivers/media/platform/vimc/vimc-scaler.c
 delete mode 100644 drivers/media/platform/vimc/vimc-sensor.h
 create mode 100644 drivers/media/v4l2-core/v4l2-fwnode.c
 delete mode 100644 drivers/media/v4l2-core/v4l2-of.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_irq.c
 create mode 100644 drivers/staging/media/imx/Kconfig
 create mode 100644 drivers/staging/media/imx/Makefile
 create mode 100644 drivers/staging/media/imx/TODO
 create mode 100644 drivers/staging/media/imx/imx-ic-common.c
 create mode 100644 drivers/staging/media/imx/imx-ic-prp.c
 create mode 100644 drivers/staging/media/imx/imx-ic-prpencvf.c
 create mode 100644 drivers/staging/media/imx/imx-ic.h
 create mode 100644 drivers/staging/media/imx/imx-media-capture.c
 create mode 100644 drivers/staging/media/imx/imx-media-csi.c
 create mode 100644 drivers/staging/media/imx/imx-media-dev.c
 create mode 100644 drivers/staging/media/imx/imx-media-fim.c
 create mode 100644 drivers/staging/media/imx/imx-media-internal-sd.c
 create mode 100644 drivers/staging/media/imx/imx-media-of.c
 create mode 100644 drivers/staging/media/imx/imx-media-utils.c
 create mode 100644 drivers/staging/media/imx/imx-media-vdic.c
 create mode 100644 drivers/staging/media/imx/imx-media.h
 create mode 100644 drivers/staging/media/imx/imx6-mipi-csi2.c
 delete mode 100644 drivers/staging/media/lirc/TODO.lirc_zilog
 create mode 100644 include/linux/imx-media.h
 create mode 100644 include/media/imx.h
 rename include/media/{v4l2-of.h => v4l2-fwnode.h} (50%)
 create mode 100644 include/uapi/linux/max2175.h
