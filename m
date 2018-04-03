Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:60341 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755063AbeDCLJz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 3 Apr 2018 07:09:55 -0400
Date: Tue, 3 Apr 2018 08:09:46 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.17-rc1] media updates
Message-ID: <20180403080946.5887e742@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.17-1

For:
  - New CEC pin injection code for testing purposes;
  - DVB frontend cxd2099 promoted from staging;
  - New platform driver for Sony cxd2880 DVB devices;
  - New sensor drivers: mt9t112, ov2685, ov5695, ov772x, tda1997x, tw9910.c
  - Removal of unused cx18 and ivtv alsa mixers;
  - The reneseas-ceu driver doesn't depend on soc_camera anymore and
    moved from staging;
  - Removed the mantis_vp3028 driver, unused since 2009;
  - s5p-mfc: add support for version 10 of the MSP;
  - Added a decoder for imon protocol;
  - atomisp: lots of cleanups;
  - imx074 and mt9t031: don't depend on soc_camera anymore, being 
    promoted from staging;
  - added helper functions to better support DVB I2C binding;
  - lots of driver improvements and cleanups.

The following changes since commit 661e50bc853209e41a5c14a290ca4decc43cbfd1:

  Linux 4.16-rc4 (2018-03-04 14:54:11 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.17-1

for you to fetch changes up to f8a695c4b43d02c89b8bba9ba6058fd5db1bc71d:

  media: v4l2-ioctl: rename a temp var that stores _IOC_SIZE(cmd) (2018-03-26 06:58:47 -0400)

----------------------------------------------------------------
media updates for v4.17-rc1

----------------------------------------------------------------
A Sun (1):
      media: mceusb: add IR learning support features (IR carrier frequency measurement and wide-band/short-range receiver)

Akinobu Mita (3):
      media: MAINTAINERS: add entry for ov9650 driver
      media: ov9650: add device tree binding
      media: ov9650: support device tree probing

Alexandre Courbot (3):
      media: v4l: vidioc-prepare-buf.rst: fix link to VIDIOC_QBUF
      media: v4l2_fh.h: add missing kconfig.h include
      media: media-types.rst: fix typo

Alexey Khoroshilov (1):
      media: rc: ir-hix5hd2: fix error handling of clk_prepare_enable()

Alona Solntseva (1):
      media: drivers: staging: media: atomisp: pci: atomisp2: css2400: fix misspellings

Andi Kleen (1):
      media: rc: don't mark IR decoders default y

Antonio Cardace (2):
      media: em28xx: use %*phC to print small buffers
      media: gspca: dtcs033: use %*ph to print small buffer

Antti Palosaari (18):
      media: af9013: change lock detection slightly
      media: af9013: dvbv5 signal strength
      media: af9013: dvbv5 cnr
      media: af9013: dvbv5 ber and per
      media: af9013: wrap dvbv3 statistics via dvbv5
      media: af9015: fix logging
      media: af9013: convert inittabs suitable for regmap_update_bits
      media: af9013: add i2c mux adapter for tuner bus
      media: af9015: attach demod using i2c binding
      media: af9013: remove all legacy media attach releated stuff
      media: af9013: add pid filter support
      media: af9015: use af9013 demod pid filters
      media: af9015: refactor firmware download
      media: af9015: refactor copy firmware to slave demod
      media: af9015: enhance streaming config
      media: dvb-usb-v2: add probe/disconnect callbacks
      media: af9015: convert to regmap api
      media: af9015: correct some coding style issues

Arnd Bergmann (10):
      media: au0828: fix VIDEO_V4L2 dependency
      media: i2c: TDA1997x: add CONFIG_SND dependency
      media: ov5695: mark PM functions as __maybe_unused
      media: ov2685: mark PM functions as __maybe_unused
      media: em28xx: split up em28xx_dvb_init to reduce stack size
      media: s3c-camif: fix out-of-bounds array access
      media: renesas-ceu: mark PM functions as __maybe_unused
      media: staging: media: atomisp: remove pointless string copy
      media: v4l: omap_vout: vrfb: remove an unused variable
      media: ngene: avoid unused variable warning

Arushi Singhal (4):
      media: staging: media: Remove unnecessary semicolon
      media: staging: media: Replace "be be" with "be"
      media: staging: media: Replace "dont" with "don't"
      media: staging: media: Replace "cant" with "can't"

Benjamin Gaignard (1):
      media: platform: stm32: Adopt SPDX identifier

Brad Love (37):
      media: em28xx: Hauppauge DualHD second tuner functionality
      media: em28xx: Bulk transfer implementation fix
      media: em28xx: USB bulk packet size fix
      media: em28xx: Increase max em28xx boards to max dvb adapters
      media: em28xx: Add Hauppauge SoloHD/DualHD bulk models
      media: em28xx: Enable Hauppauge SoloHD rebranded 292e SE
      media: lgdt3306a: Set fe ops.release to NULL if probed
      media: lgdt3306a: QAM streaming improvement
      media: lgdt3306a: Add QAM AUTO support
      media: lgdt3306a: Fix module count mismatch on usb unplug
      media: lgdt3306a: Fix a double kfree on i2c device remove
      media: cx23885: Enable new Hauppauge PCIe ImpactVCBe variant
      media: cx23885: Add support for Hauppauge PCIe HVR1265 K4
      media: cx23885: Add support for Hauppauge PCIe Starburst2
      media: cx23885: Add support for new Hauppauge QuadHD (885)
      media: cx231xx: Add support for Hauppauge HVR-935C
      media: cx231xx: Add support for Hauppauge HVR-975
      media: cx231xx: Add second frontend option
      media: cx231xx: Add second i2c demod client
      media: si2168: Add ts bus coontrol, turn off bus on sleep
      media: lgdt3306a: Announce successful creation
      media: si2168: Announce frontend creation failure
      media: si2168: Add spectrum inversion property
      media: em28xx: Enable inversion for Solo/Dual HD DVB models
      media: si2168: change ts bus control logic
      media: lgdt3306a: remove symbol count mismatch fix
      media: em28xx: Change hex to lower case
      media: cx231xx: Use frontend i2c adapter with tuner
      media: cx23885: Add tuner type and analog inputs to 1265
      media: cx231xx: Set mfe_shared if second frontend found
      media: cx231xx: Use constant instead of hard code for max
      media: cx231xx: Add second i2c demod to Hauppauge 975
      media: cx23885: Fix gpio on Hauppauge QuadHD PCIe cards
      media: cx25840: Use subdev host data for PLL override
      media: cx23885: change 887/888 default to 888
      media: cx23885: Set subdev host data to clk_freq pointer
      media: cx23885: Override 888 ImpactVCBe crystal frequency

Chiranjeevi Rapolu (1):
      media: ov13858: Avoid possible null first frame

Christopher Díaz Riveros (1):
      media: s2255drv: Remove unneeded if else blocks

Colin Ian King (3):
      media: cx25821: prevent out-of-bounds read on array card
      media: exynos4-is: make array 'cmd' static, shrinks object size
      media: staging: atomisp: remove redundant assignments to various variables

Corentin Labbe (7):
      media: cx18: remove unused cx18-alsa-mixer
      media: ivtv: remove ivtv-alsa-mixer
      media: drx-j remove bsp_i2c.h
      media: mantis: remove mantis_vp3028.c/mantis_vp3028.h
      media: staging: media: remove remains of VIDEO_ATOMISP_OV8858
      media: staging: media: atomisp2: remove unused headers
      media: staging: media: atomisp: Remove inclusion of non-existing directories

Dan Carpenter (3):
      media: sr030pc30: prevent array underflow in try_fmt()
      media: ov5695: Off by one in ov5695_enum_frame_sizes()
      media: em28xx-cards: fix em28xx_duplicate_dev()

Dan Gopstein (1):
      media: ABS macro parameter parenthesization

Daniel Scheller (28):
      media: dvb-frontend/mxl5xx: add support for physical layer scrambling
      media: ddbridge/ci: further deduplicate code/logic in ddb_ci_attach()
      media: staging/cxd2099: convert to regmap API
      media: ngene: adapt cxd2099 attach to the new i2c_client way
      media: cxd2099: move driver out of staging into dvb-frontends
      media: dvb-frontends/stv0910: rework and fix DiSEqC send
      media: dvb_ca_en50221: fix severity of successful CAM init log message
      media: ngene: add two additional PCI IDs
      media: ngene: convert kernellog printing from printk() to dev_*() macros
      media: ngene: use defines to identify the demod_type
      media: ngene: support STV0367 DVB-C/T DuoFlex addons
      media: ngene: add XO2 module support
      media: ngene: add support for Sony CXD28xx-based DuoFlex modules
      media: ngene: add support for DuoFlex S2 V4 addon modules
      media: ngene: deduplicate I2C adapter evaluation
      media: ngene: check for CXD2099AR presence before attaching
      media: ngene: don't treat non-existing demods as error
      media: ngene: add proper polling to the dvbdev_ci file ops
      media: ddbridge: adapt cxd2099 attach to new i2c_client way
      media: ngene: add I2C_FUNC_I2C to the I2C interface functionality
      media: dvb-frontends/cxd2099: remove remainders from old attach way
      media: ngene: move the tsin_exchange() stripcopy block into a function
      media: ngene: compensate for TS buffer offset shifts
      media: dvb-frontends/cxd2099: Kconfig additions
      media: dvb-frontends/Kconfig: move the SP2 driver to the CI section
      media: ddbridge: use common DVB I2C client handling helpers
      media: ngene: use common DVB I2C client handling helpers
      media: ttpci: improve printing of encoded MAC address

Douglas Fischer (3):
      media: radio: Tuning bugfix for si470x over i2c
      media: radio: Critical v4l2 registration bugfix for si470x over i2c
      media: radio: Critical interrupt bugfix for si470x over i2c

Edgar Thier (1):
      media: uvcvideo: Apply flags from device to actual properties

Evgeny Plehov (1):
      media: dvb-usb-cxusb: Geniatech T230C support

Fabio Estevam (2):
      media: imx-media-internal-sd: Use empty initializer
      media: imx-ic-prpencvf: Use empty initializer to clear all struct members

Florian Echtler (4):
      media: add missing blob structure field for tag id
      media: add default settings and module parameters for video controls
      media: add panel register access functions
      media: add video control handlers using V4L2 control framework

Geert Uytterhoeven (1):
      media: dt-bindings: media: rcar_vin: Use status "okay"

Guennadi Liakhovetski (1):
      media: V4L: remove myself as soc-camera maintainer

Gustavo A. R. Silva (11):
      media: ov13858: Use false for boolean value
      media: i2c: ov9650: fix potential integer overflow in __ov965x_set_frame_interval
      media: venus: hfi: use true for boolean values
      media: staging: imx-media-vdic: fix inconsistent IS_ERR and PTR_ERR
      media: rtl2832: use 64-bit arithmetic instead of 32-bit in rtl2832_set_frontend
      media: dvb-frontends: ves1820: use 64-bit arithmetic instead of 32-bit
      media: i2c: max2175: use 64-bit arithmetic instead of 32-bit
      media: pci: cx88-input: use 64-bit arithmetic instead of 32-bit
      media: rockchip/rga: use 64-bit arithmetic instead of 32-bit
      media: platform: sh_veu: use 64-bit arithmetic instead of 32-bit
      media: platform: vivid-cec: use 64-bit arithmetic instead of 32-bit

Gustavo Padovan (1):
      media: buffer.rst: fix link text of VIDIOC_QBUF

Hans Verkuil (44):
      media: vivid: add SPDX license info
      media: cobalt: add SPDX license info
      media: cec: add SPDX license info
      media: i2c: add SPDX license info
      media: add SPDX license info
      media: include/(uapi/)media: add SPDX license info
      media: v4l2-subdev: clear reserved fields
      media: v4l2-common: create v4l2_g/s_parm_cap helpers
      media: convert g/s_parm to g/s_frame_interval in subdevs
      media: v4l2-subdev.h: remove obsolete g/s_parm
      media: vidioc-g-parm.rst: also allow _MPLANE buffer types
      media: v4l2-dv-timings: add v4l2_hdmi_colorimetry()
      media: imx074: deprecate, move to staging
      media: mt9t031: deprecate, move to staging
      media: vivid: fix incorrect capabilities for radio
      media: v4l2-ctrls.h: fix wrong copy-and-paste comment
      media: cec: improve debugging
      media: vivid: check if the cec_adapter is valid
      media: vimc: fix control event handling
      media: vimc: use correct subdev functions
      media: v4l2-subdev: without controls return -ENOTTY
      media: v4l2-subdev: implement VIDIOC_DBG_G_CHIP_INFO ioctl
      media: media-ioc-g-topology.rst: fix interface-to-entity link description
      media: media-types.rst: fix type, small improvements
      media: media-device.c: zero reserved fields
      media: media.h: fix confusing typo in comment
      media: zero reservedX fields in media_v2_topology
      media: document the reservedX fields in media_v2_topology
      media: media-ioc-enum-entities/links.rst: document reserved fields
      media: media.h: reorganize header to make it easier to understand
      media: imx/Kconfig: add depends on HAS_DMA
      media: add tuner standby op, use where needed
      media: atomisp_fops.c: disable atomisp_compat_ioctl32
      media: imx.rst: fix typo
      media: pixfmt-v4l2.rst: fix broken enum :c:type
      media: cec: add core error injection support
      media: cec-core.rst: document the error injection ops
      media: cec-pin: create cec_pin_start_timer() function
      media: cec-pin-error-inj: parse/show error injection
      media: cec-pin: add error injection support
      media: cec-pin: improve status log
      media: cec: improve CEC pin event handling
      media: cec-pin-error-inj.rst: document CEC Pin Error Injection
      media: debugfs-cec-error-inj: document CEC error inj debugfs ABI

Hugues Fruchet (13):
      media: ov5640: add JPEG support
      media: ov5640: add error trace in case of i2c read failure
      media: ov5640: various typo & style fixes
      media: ov5640: fix virtual_channel parameter permissions
      media: ov5640: fix framerate update
      media: stm32-dcmi: remove redundant capture enable
      media: stm32-dcmi: remove redundant clear of interrupt flags
      media: stm32-dcmi: improve error trace points
      media: stm32-dcmi: add g/s_parm framerate support
      media: stm32-dcmi: fix lock scheme
      media: stm32-dcmi: rework overrun/error case
      media: stm32-dcmi: fix unnecessary parentheses
      media: stm32-dcmi: add JPEG support

Ian Douglas Scott (1):
      media: usbtv: Add USB ID 1f71:3306 to the UTV007 driver

Jacopo Mondi (28):
      media: dt-bindings: Add OF properties to ov7670
      media: v4l2: i2c: ov7670: Implement OF mbus configuration
      media: dt-bindings: media: Add Renesas CEU bindings
      media: include: media: Add Renesas CEU driver interface
      media: platform: Add Renesas CEU driver
      media: MAINTAINERS: Add entry for Renesas CEU
      media: i2c: Copy ov772x soc_camera sensor driver
      media: i2c: ov772x: Remove soc_camera dependencies
      media: i2c: ov772x: Support frame interval handling
      media: MAINTAINERS: Add entry for Omnivision OV772x
      media: i2c: Copy tw9910 soc_camera sensor driver
      media: i2c: tw9910: Remove soc_camera dependencies
      media: MAINTAINERS: Add entry for Techwell TW9910
      media: arch: sh: migor: Use new renesas-ceu camera driver
      media: tw9910: Re-organize in-code comments
      media: tw9910: Mixed style fixes
      media: tw9910: Sort includes alphabetically
      media: tw9910: Replace msleep(1) with usleep_range
      media: ov772x: Align function parameters
      media: ov772x: Re-organize in-code comments
      media: ov772x: Empty line before end-of-function return
      media: ov772x: Replace msleep(1) with usleep_range
      media: ov772x: Unregister async subdevice
      media: platform: renesas-ceu: Fix CSTRST_CPON mask
      media: i2c: Copy mt9t112 soc_camera sensor driver
      media: i2c: mt9t112: Remove soc_camera dependencies
      media: arch: sh: ecovec: Use new renesas-ceu camera driver
      media: MAINTAINERS: Add entry for Aptina MT9T112

Jasmin Jessich (2):
      media: uvcvideo: Fixed ktime_t to ns conversion
      media: MAINTAINERS: add entry for cxd2099

Jean-Michel Hautbois (2):
      media: dt-bindings: media: adv7604: Extend bindings to allow specifying slave map addresses
      media: adv7604: Add support for i2c_new_secondary_device

Jeremy Sowden (1):
      media: atomisp: convert default struct values to use compound-literals with designated initializers

Joe Perches (2):
      media: tw9910: Whitespace alignment
      media: tw9910: Miscellaneous neatening

Johan Hovold (1):
      media: cpia2_usb: drop bogus interface-release call

Kieran Bingham (7):
      media: v4l: doc: Clarify v4l2_mbus_fmt height definition
      media: i2c: adv748x: fix HDMI field heights
      media: v4l: vsp1: Fix header display list status check in continuous mode
      media: i2c: adv748x: Fix cleanup jump on chip identification
      media: i2c: adv748x: Simplify regmap configuration
      media: i2c: adv748x: Add missing CBUS page
      media: i2c: adv748x: Add support for i2c_new_secondary_device

Laurent Pinchart (6):
      media: uvcvideo: Drop extern keyword in function declarations
      media: uvcvideo: Use kernel integer types
      media: uvcvideo: Use internal kernel integer types
      media: uvcvideo: Use parentheses around sizeof operand
      media: v4l: vsp1: Fix display stalls when requesting too many inputs
      media: v4l: vsp1: Print the correct blending unit name in debug messages

Luca Ceresoli (4):
      media: doc: poll: fix links to dual-ioctl sections
      media: vb2-core: vb2_buffer_done: consolidate docs
      media: vb2-core: document the REQUEUEING state
      media: vb2-core: vb2_ops: document non-interrupt-context calling

Marek Szyprowski (1):
      media: s5p-mfc: Use real device for request_firmware() call

Markus Elfring (1):
      media: usb: don't initialize vars if not needed

Masami Hiramatsu (1):
      media: vb2: Fix videobuf2 to map correct area

Mauro Carvalho Chehab (77):
      tda1997x: get rid of an unused var
      ov13858: fix endiannes warnings
      media: ov7740: remove an unused var
      media: tvp541x: fix some kernel-doc parameters
      media: imx: Don't initialize vars that won't be used
      media: ov772x: fix whitespace issues
      media: tw9910: solve coding style issues
      Merge commit 'v4.16-rc4~0' into patchwork
      media: em28xx: constify a new function
      media: em28xx: don't use coherent buffer for DMA transfers
      media: em28xx: improve the logic with sets Xclk and I2C speed
      media: em28xx: stop rewriting device's struct
      media: em28xx: constify most static structs
      media: em28xx: adjust I2C timeout according with I2C speed
      media: dvb-core: add helper functions for I2C binding
      media: em28xx-dvb: simplify DVB module probing logic
      media: s5h14*.h: fix typos for CONTINUOUS
      media: em28xx-dvb: do some coding style improvements
      media: em28xx: Add SPDX license tags where needed
      media: em28xx.h: Fix most coding style issues
      media: em28xx-reg.h: Fix coding style issues
      media: em28xx-audio: fix coding style issues
      media: em28xx-camera: fix coding style issues
      media: em28xx-cards: fix most coding style issues
      media: em28xx-cards: rework the em28xx probing code
      media: em28xx-core: fix most coding style issues
      media: em28xx-i2c: fix most coding style issues
      media: em28xx-input: fix most coding style issues
      media: em28xx-video: fix most coding style issues
      media: ov772x: constify ov772x_frame_intervals
      media: dvbdev: fix building on ia64
      media: cxd2880: Fix location of DVB headers
      media: cxd2880: Makefile: remove an include
      media: cxd2880: don't return unitialized values
      media: cxd2880: remove unused vars
      media: s5c73m3-core: fix logic on a timeout condition
      media: v4l2-subdev: get rid of __V4L2_SUBDEV_MK_GET_TRY() macro
      media: v4l2-subdev: document remaining undocumented functions
      media: si2168: fix a comment about firmware version
      media: Kconfig: fix DVB dependencies
      media: v4l2-common: fix a compilation breakage
      media: extended-controls.rst: don't use adjustbox
      media: s5p_mfc_enc: get rid of new warnings
      media: dvbdev: handle ENOMEM error at dvb_module_probe()
      media: imx-media-utils: fix a warning
      media: dvb_frontend: add proper __user annotations
      media: vpss: fix annotations for vpss_regs_base2
      media: rca: declare formats var as static
      media: ov5670: get rid of a series of __be warnings
      media: v4l2-tpg-core: avoid buffer overflows
      media: v4l2-ioctl: fix some "too small" warnings
      media: sp887x: fix a warning
      media: tvaudio: improve error handling
      media: bttv-input: better handle errors at I2C transfer
      media: solo6x10: simplify the logic at solo_p2m_dma_desc()
      media: cx88: fix two warnings
      media: cx23885: fix a warning
      soc_camera: fix a weird cast on printk
      media: videobuf-dma-sg: Fix a weird cast
      media: ivtvfb: Cleanup some warnings
      media: s2255drv: fix a casting warning
      media: saa7134-input: improve error handling
      media: ir-kbd-i2c: improve error handling code
      media: ir-kbd-i2c: change the if logic to avoid a warning
      media: zoran: don't cast pointers to print them
      media: solo6x10: get rid of an address space warning
      media: saa7134-alsa: don't use casts to print a buffer address
      media: vivid-radio-rx: add a cast to avoid a warning
      media: zr364xx: avoid casting just to print pointer address
      media: em28xx-input: improve error handling code
      media: tm6000:  avoid casting just to print pointer address
      media: tda9840: cleanup a warning
      media: cec-core: fix a bug at cec_error_inj_write()
      media: uvc: to the right check at uvc_ioctl_enum_framesizes()
      media: dvb-usb-v2: fix a missing dependency of I2C_MUX
      media: fimc-capture: get rid of two warnings
      media: v4l2-ioctl: rename a temp var that stores _IOC_SIZE(cmd)

Niklas Söderlund (3):
      media: v4l2-dev.h: fix symbol collision in media_entity_to_video_device()
      media: rcar-vin: allocate a scratch buffer at stream start
      media: rcar-vin: use scratch buffer and always run in continuous mode

Oliver Neukum (1):
      media: usbtv: prevent double free in error case

Parthiban Nallathambi (1):
      media: imx: capture: reformat line to 80 chars or less

Peter Ujfalusi (1):
      media: v4l: omap_vout: vrfb: Use the wrapper for prep_interleaved_dma()

Philipp Rossak (2):
      media: rc: update sunxi-ir driver to get base clock frequency from devicetree
      media: dt: bindings: Update binding documentation for sunxi IR controller

Philipp Zabel (6):
      media: uvcvideo: Support multiple frame descriptors with the same dimensions
      media: dt-bindings: coda: Add compatible for CodaHx4 on i.MX51
      media: coda: Add i.MX51 (CodaHx4) support
      media: imx: allow to build with COMPILE_TEST
      media: coda: bump maximum number of internal framebuffers to 19
      media: imx: add 8-bit grayscale support

Sakari Ailus (12):
      media: staging: atomisp: Kill subdev s_parm abuse
      media: staging: atomisp: i2c: Disable non-preview configurations
      media: staging: atomisp: i2c: Drop g_parm support in sensor drivers
      media: staging: atomisp: mt9m114: Drop empty s_parm callback
      media: staging: atomisp: Drop g_parm and s_parm subdev ops use
      media: ov2685: Assign ret in default case in s_ctrl callback
      media: vb2: core: Finish buffers at the end of the stream
      media: v4l: common: Add a function to obtain best size from a list
      media: ov13858: Use v4l2_find_nearest_size
      media: ov5670: Use v4l2_find_nearest_size
      media: vivid: Use v4l2_find_nearest_size
      media: v4l: common: Remove v4l2_find_nearest_format

Sean Young (18):
      media: rc: ir-spi: fix duty cycle
      media: rc: replace IR_dprintk() with dev_dbg in IR decoders
      media: rc: remove IR_dprintk() from rc-core
      media: rc: remove obsolete comment
      media: rc: remove useless if statement
      media: rc: get start time just before calling driver tx
      media: rc: no need to announce major number
      media: rc: fix race condition in ir_raw_event_store_edge() handling
      media: Revert "[media] staging: lirc_imon: port remaining usb ids to imon and remove"
      media: rc: add keymap for iMON RSC remote
      media: rc: new driver for early iMon device
      media: rc: oops in ir_timer_keyup after device unplug
      media: rc: add new imon protocol decoder and encoder
      media: imon: rename protocol from other to imon
      media: rc: meson-ir: add timeout on idle
      media: rc: meson-ir: lower timeout and make configurable
      media: rc: mceusb: pid 0x0609 vid 0x031d does not under report carrier cycles
      media: rc docs: fix warning for RC_PROTO_IMON

Sergei Shtylyov (1):
      media: v4l: vsp1: Fix video output on R8A77970

Shuah Khan (1):
      media: v4l2-core: v4l2-mc: Add SPDX license identifier

Shunqian Zheng (5):
      media: dt-bindings: media: Add bindings for OV5695
      media: ov5695: add support for OV5695 sensor
      media: dt-bindings: media: Add bindings for OV2685
      media: ov2685: add support for OV2685 sensor
      media: ov2685: Not delay latch for gain

Smitha T Murthy (12):
      media: videodev2.h: Add v4l2 definition for HEVC
      media: v4l2-ioctl: add HEVC format description
      media: v4l2: Documentation of HEVC compressed format
      media: v4l2: Add v4l2 control IDs for HEVC encoder
      media: v4l2: Documentation for HEVC CIDs
      media: s5p-mfc: Rename IS_MFCV8 macro
      media: s5p-mfc: Adding initial support for MFC v10.10
      media: s5p-mfc: Use min scratch buffer size as provided by F/W
      media: s5p-mfc: Support MFCv10.10 buffer requirements
      media: s5p-mfc: Add support for HEVC decoder
      media: s5p-mfc: Add VP9 decoder support
      media: s5p-mfc: Add support for HEVC encoder

Stefan Brüns (1):
      media: cxusb: restore RC_MAP for MyGica T230

Steve Longerbeam (3):
      media: staging/imx: Implement init_cfg subdev pad op
      media: imx: mipi csi-2: Fix set_fmt try
      media: imx.rst: Fix formatting errors

Sylwester Nawrocki (2):
      media: s5p-mfc: Ensure HEVC QP controls range is properly updated
      media: s5p-mfc: Amend initial min, max values of HEVC hierarchical coding QP controls

Tim Harvey (5):
      media: v4l-ioctl: fix clearing pad for VIDIOC_DV_TIMINGS_CAP
      media: add digital video decoder entity functions
      media: MAINTAINERS: add entry for NXP TDA1997x driver
      media: dt-bindings: Add bindings for TDA1997X
      media: i2c: Add TDA1997x HDMI receiver driver

Tomasz Figa (1):
      media: mtk-vcodec: Always signal source change event on format change

Tomoki Sekiyama (1):
      media: siano: Fix coherent memory allocation failure on arm64

Ulf Magnusson (1):
      media: sec: Remove PLAT_S5P dependency

Wei Yongjun (2):
      media: atmel-isc: Make local symbol fmt_configs_list static
      media: rcar_drif: fix error return code in rcar_drif_alloc_dmachannels()

Wolfram Sang (2):
      media: v4l: vsp1: Fix mask creation for MULT_ALPHA_RATIO
      media: v4l: dvb-frontends: stb0899: fix comparison to bitshift when dealing with a mask

Xiongfeng Wang (2):
      media: media-device: use strlcpy() instead of strncpy()
      media: dibx000_common: use strlcpy() instead of strncpy()

Yasunari Takiguchi (12):
      media: Add document file for CXD2880 SPI I/F
      media: cxd2880-spi: Add support for CXD2880 SPI interface
      media: cxd2880: Add common files for the driver
      media: cxd2880: Add spi device IO routines
      media: cxd2880: Add tuner part of the driver
      media: cxd2880: Add integration layer for the driver
      media: cxd2880: Add top level of the driver
      media: cxd2880: Add DVB-T control functions the driver
      media: cxd2880: Add DVB-T monitor functions
      media: cxd2880: Add DVB-T2 control functions for the driver
      media: cxd2880: Add DVB-T2 monitor functions
      media: cxd2880: Add all Makefile, Kconfig files and Update MAINTAINERS file for the driver

Yong Zhi (2):
      media: intel-ipu3: cio2: Disable and sync irq before stream off
      media: intel-ipu3: cio2: Use SPDX license headers

 Documentation/ABI/testing/debugfs-cec-error-inj    |   40 +
 Documentation/devicetree/bindings/media/coda.txt   |    5 +-
 .../devicetree/bindings/media/i2c/adv7604.txt      |   18 +-
 .../devicetree/bindings/media/i2c/ov2685.txt       |   41 +
 .../devicetree/bindings/media/i2c/ov5695.txt       |   41 +
 .../devicetree/bindings/media/i2c/ov7670.txt       |   16 +-
 .../devicetree/bindings/media/i2c/ov9650.txt       |   36 +
 .../devicetree/bindings/media/i2c/tda1997x.txt     |  178 +
 .../devicetree/bindings/media/rcar_vin.txt         |    4 +-
 .../devicetree/bindings/media/renesas,ceu.txt      |   81 +
 .../devicetree/bindings/media/s5p-mfc.txt          |    1 +
 .../devicetree/bindings/media/spi/sony-cxd2880.txt |   14 +
 .../devicetree/bindings/media/sunxi-ir.txt         |    3 +
 Documentation/media/kapi/cec-core.rst              |   72 +-
 Documentation/media/lirc.h.rst.exceptions          |    1 +
 Documentation/media/uapi/cec/cec-api.rst           |    1 +
 Documentation/media/uapi/cec/cec-pin-error-inj.rst |  325 ++
 .../uapi/mediactl/media-ioc-enum-entities.rst      |   19 +-
 .../media/uapi/mediactl/media-ioc-enum-links.rst   |   18 +
 .../media/uapi/mediactl/media-ioc-g-topology.rst   |   54 +-
 Documentation/media/uapi/mediactl/media-types.rst  |   23 +-
 Documentation/media/uapi/rc/lirc-dev-intro.rst     |    1 -
 Documentation/media/uapi/v4l/buffer.rst            |    2 +-
 Documentation/media/uapi/v4l/extended-controls.rst |  410 +++
 Documentation/media/uapi/v4l/func-poll.rst         |    8 +-
 Documentation/media/uapi/v4l/pixfmt-compressed.rst |    5 +
 Documentation/media/uapi/v4l/pixfmt-v4l2.rst       |    2 +-
 Documentation/media/uapi/v4l/subdev-formats.rst    |    8 +-
 Documentation/media/uapi/v4l/vidioc-g-parm.rst     |    7 +-
 .../media/uapi/v4l/vidioc-prepare-buf.rst          |    2 +-
 Documentation/media/v4l-drivers/imx.rst            |   26 +-
 MAINTAINERS                                        |   92 +-
 arch/sh/boards/mach-ecovec24/setup.c               |  338 +-
 arch/sh/boards/mach-migor/setup.c                  |  225 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7722.c             |    2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7724.c             |    4 +-
 drivers/input/touchscreen/sur40.c                  |  178 +-
 drivers/media/Kconfig                              |    1 +
 drivers/media/cec/Kconfig                          |    6 +
 drivers/media/cec/Makefile                         |    4 +
 drivers/media/cec/cec-adap.c                       |   54 +-
 drivers/media/cec/cec-api.c                        |   14 +-
 drivers/media/cec/cec-core.c                       |   72 +-
 drivers/media/cec/cec-edid.c                       |   14 +-
 drivers/media/cec/cec-notifier.c                   |   14 +-
 drivers/media/cec/cec-pin-error-inj.c              |  342 ++
 drivers/media/cec/cec-pin-priv.h                   |  148 +-
 drivers/media/cec/cec-pin.c                        |  678 +++-
 drivers/media/cec/cec-priv.h                       |   14 +-
 drivers/media/common/siano/smscoreapi.c            |   33 +-
 drivers/media/common/siano/smscoreapi.h            |    2 +
 drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c    |   14 +-
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c      |   18 +-
 drivers/media/common/videobuf2/videobuf2-core.c    |    9 +
 drivers/media/common/videobuf2/videobuf2-vmalloc.c |    2 +-
 drivers/media/dvb-core/dvb_ca_en50221.c            |    4 +-
 drivers/media/dvb-core/dvb_frontend.c              |    4 +-
 drivers/media/dvb-core/dvbdev.c                    |   50 +
 drivers/media/dvb-frontends/Kconfig                |   32 +-
 drivers/media/dvb-frontends/Makefile               |    2 +
 drivers/media/dvb-frontends/af9013.c               |  909 ++---
 drivers/media/dvb-frontends/af9013.h               |   48 +-
 drivers/media/dvb-frontends/af9013_priv.h          | 1558 +++++----
 .../cxd2099 => media/dvb-frontends}/cxd2099.c      |  209 +-
 .../cxd2099 => media/dvb-frontends}/cxd2099.h      |   19 +-
 drivers/media/dvb-frontends/cxd2880/Kconfig        |    8 +
 drivers/media/dvb-frontends/cxd2880/Makefile       |   18 +
 drivers/media/dvb-frontends/cxd2880/cxd2880.h      |   29 +
 .../media/dvb-frontends/cxd2880/cxd2880_common.c   |   21 +
 .../media/dvb-frontends/cxd2880/cxd2880_common.h   |   19 +
 .../dvb-frontends/cxd2880/cxd2880_devio_spi.c      |  129 +
 .../dvb-frontends/cxd2880/cxd2880_devio_spi.h      |   23 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_dtv.h  |   29 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt.h |   74 +
 .../media/dvb-frontends/cxd2880/cxd2880_dvbt2.h    |  385 +++
 .../media/dvb-frontends/cxd2880/cxd2880_integ.c    |   72 +
 .../media/dvb-frontends/cxd2880/cxd2880_integ.h    |   27 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_io.c   |   66 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_io.h   |   54 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_spi.h  |   34 +
 .../dvb-frontends/cxd2880/cxd2880_spi_device.c     |  113 +
 .../dvb-frontends/cxd2880/cxd2880_spi_device.h     |   26 +
 .../media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c   | 3519 ++++++++++++++++++++
 .../media/dvb-frontends/cxd2880/cxd2880_tnrdmd.h   |  365 ++
 .../cxd2880/cxd2880_tnrdmd_driver_version.h        |   12 +
 .../dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.c    |  919 +++++
 .../dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.h    |   45 +
 .../dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c   | 1217 +++++++
 .../dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.h   |   65 +
 .../cxd2880/cxd2880_tnrdmd_dvbt2_mon.c             | 1878 +++++++++++
 .../cxd2880/cxd2880_tnrdmd_dvbt2_mon.h             |  135 +
 .../cxd2880/cxd2880_tnrdmd_dvbt_mon.c              |  775 +++++
 .../cxd2880/cxd2880_tnrdmd_dvbt_mon.h              |   77 +
 .../dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.c     |  150 +
 .../dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.h     |   29 +
 drivers/media/dvb-frontends/cxd2880/cxd2880_top.c  | 1947 +++++++++++
 drivers/media/dvb-frontends/dib0090.c              |    4 +-
 drivers/media/dvb-frontends/dib7000p.c             |    2 +-
 drivers/media/dvb-frontends/dib8000.c              |    2 +-
 drivers/media/dvb-frontends/dibx000_common.c       |    2 +-
 drivers/media/dvb-frontends/dibx000_common.h       |    2 -
 drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h     |  139 -
 drivers/media/dvb-frontends/lgdt3306a.c            |   69 +-
 drivers/media/dvb-frontends/mb86a16.c              |    8 +-
 drivers/media/dvb-frontends/mxl5xx.c               |   34 +-
 drivers/media/dvb-frontends/rtl2832.c              |    4 +-
 drivers/media/dvb-frontends/s5h1409.c              |    8 +-
 drivers/media/dvb-frontends/s5h1409.h              |    8 +-
 drivers/media/dvb-frontends/s5h1411.c              |    8 +-
 drivers/media/dvb-frontends/s5h1411.h              |    8 +-
 drivers/media/dvb-frontends/s5h1432.h              |    8 +-
 drivers/media/dvb-frontends/si2168.c               |   49 +-
 drivers/media/dvb-frontends/si2168.h               |    4 +
 drivers/media/dvb-frontends/si2168_priv.h          |    1 +
 drivers/media/dvb-frontends/sp887x.c               |    6 +-
 drivers/media/dvb-frontends/stb0899_reg.h          |    8 +-
 drivers/media/dvb-frontends/stv0367_priv.h         |    1 -
 drivers/media/dvb-frontends/stv0900_priv.h         |    1 -
 drivers/media/dvb-frontends/stv0900_sw.c           |    6 +-
 drivers/media/dvb-frontends/stv0910.c              |   19 +-
 drivers/media/dvb-frontends/ves1820.c              |    2 +-
 drivers/media/i2c/Kconfig                          |   66 +
 drivers/media/i2c/Makefile                         |    6 +
 drivers/media/i2c/ad9389b.c                        |   14 +-
 drivers/media/i2c/adv748x/adv748x-core.c           |  187 +-
 drivers/media/i2c/adv748x/adv748x-hdmi.c           |    3 +
 drivers/media/i2c/adv748x/adv748x.h                |   14 +-
 drivers/media/i2c/adv7511.c                        |   14 +-
 drivers/media/i2c/adv7604.c                        |   76 +-
 drivers/media/i2c/adv7842.c                        |   15 +-
 drivers/media/i2c/cx25840/cx25840-core.c           |   28 +-
 drivers/media/i2c/ir-kbd-i2c.c                     |   20 +-
 drivers/media/i2c/max2175.c                        |    2 +-
 drivers/media/i2c/mt9t112.c                        | 1140 +++++++
 drivers/media/i2c/mt9v011.c                        |   29 +-
 drivers/media/i2c/ov13858.c                        |   55 +-
 drivers/media/i2c/ov2685.c                         |  846 +++++
 drivers/media/i2c/ov5640.c                         |   99 +-
 drivers/media/i2c/ov5670.c                         |   42 +-
 drivers/media/i2c/ov5695.c                         | 1399 ++++++++
 drivers/media/i2c/ov6650.c                         |   33 +-
 drivers/media/i2c/ov7670.c                         |  120 +-
 drivers/media/i2c/ov772x.c                         | 1356 ++++++++
 drivers/media/i2c/ov7740.c                         |   31 +-
 drivers/media/i2c/ov9650.c                         |  134 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |    6 +-
 drivers/media/i2c/soc_camera/Kconfig               |   12 -
 drivers/media/i2c/soc_camera/Makefile              |    2 -
 drivers/media/i2c/soc_camera/mt9t112.c             |    2 +-
 drivers/media/i2c/sr030pc30.c                      |    7 +-
 drivers/media/i2c/tc358743.c                       |   15 +-
 drivers/media/i2c/tc358743_regs.h                  |   15 +-
 drivers/media/i2c/tda1997x.c                       | 2820 ++++++++++++++++
 drivers/media/i2c/tda1997x_regs.h                  |  641 ++++
 drivers/media/i2c/tda9840.c                        |    6 +-
 drivers/media/i2c/tvaudio.c                        |   92 +-
 drivers/media/i2c/tvp514x.c                        |   37 +-
 drivers/media/i2c/tw9910.c                         | 1027 ++++++
 drivers/media/i2c/vs6624.c                         |   27 +-
 drivers/media/media-device.c                       |    9 +-
 drivers/media/media-entity.c                       |   16 -
 drivers/media/pci/bt8xx/bttv-input.c               |    6 +-
 drivers/media/pci/cobalt/Makefile                  |    1 +
 drivers/media/pci/cobalt/cobalt-alsa-main.c        |   14 +-
 drivers/media/pci/cobalt/cobalt-alsa-pcm.c         |   14 +-
 drivers/media/pci/cobalt/cobalt-alsa-pcm.h         |   14 +-
 drivers/media/pci/cobalt/cobalt-alsa.h             |   14 +-
 drivers/media/pci/cobalt/cobalt-cpld.c             |   14 +-
 drivers/media/pci/cobalt/cobalt-cpld.h             |   14 +-
 drivers/media/pci/cobalt/cobalt-driver.c           |   14 +-
 drivers/media/pci/cobalt/cobalt-driver.h           |   14 +-
 drivers/media/pci/cobalt/cobalt-flash.c            |   14 +-
 drivers/media/pci/cobalt/cobalt-flash.h            |   14 +-
 drivers/media/pci/cobalt/cobalt-i2c.c              |   14 +-
 drivers/media/pci/cobalt/cobalt-i2c.h              |   14 +-
 drivers/media/pci/cobalt/cobalt-irq.c              |   14 +-
 drivers/media/pci/cobalt/cobalt-irq.h              |   14 +-
 drivers/media/pci/cobalt/cobalt-omnitek.c          |   14 +-
 drivers/media/pci/cobalt/cobalt-omnitek.h          |   14 +-
 drivers/media/pci/cobalt/cobalt-v4l2.c             |   14 +-
 drivers/media/pci/cobalt/cobalt-v4l2.h             |   14 +-
 .../cobalt/m00233_video_measure_memmap_package.h   |   14 +-
 .../pci/cobalt/m00235_fdma_packer_memmap_package.h |   14 +-
 .../media/pci/cobalt/m00389_cvi_memmap_package.h   |   14 +-
 .../media/pci/cobalt/m00460_evcnt_memmap_package.h |   14 +-
 .../pci/cobalt/m00473_freewheel_memmap_package.h   |   14 +-
 .../m00479_clk_loss_detector_memmap_package.h      |   14 +-
 .../m00514_syncgen_flow_evcnt_memmap_package.h     |   14 +-
 drivers/media/pci/cx18/cx18-alsa-main.c            |    1 -
 drivers/media/pci/cx18/cx18-alsa-mixer.c           |  170 -
 drivers/media/pci/cx18/cx18-alsa-mixer.h           |   18 -
 drivers/media/pci/cx18/cx18-dvb.c                  |    4 +-
 drivers/media/pci/cx23885/cx23885-alsa.c           |    5 +-
 drivers/media/pci/cx23885/cx23885-cards.c          |  108 +-
 drivers/media/pci/cx23885/cx23885-core.c           |   26 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |   90 +-
 drivers/media/pci/cx23885/cx23885-input.c          |    3 +
 drivers/media/pci/cx23885/cx23885-video.c          |    5 +-
 drivers/media/pci/cx23885/cx23885.h                |    4 +
 drivers/media/pci/cx25821/cx25821-core.c           |    7 +-
 drivers/media/pci/cx88/cx88-alsa.c                 |    8 +-
 drivers/media/pci/cx88/cx88-cards.c                |    2 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |   12 +-
 drivers/media/pci/cx88/cx88-input.c                |    4 +-
 drivers/media/pci/ddbridge/Kconfig                 |    1 +
 drivers/media/pci/ddbridge/Makefile                |    3 -
 drivers/media/pci/ddbridge/ddbridge-ci.c           |   53 +-
 drivers/media/pci/ddbridge/ddbridge-core.c         |   36 +-
 drivers/media/pci/ddbridge/ddbridge.h              |    1 +
 drivers/media/pci/intel/ipu3/ipu3-cio2.c           |   16 +-
 drivers/media/pci/intel/ipu3/ipu3-cio2.h           |   14 +-
 drivers/media/pci/ivtv/ivtv-alsa-main.c            |   11 +-
 drivers/media/pci/ivtv/ivtv-alsa-mixer.c           |  165 -
 drivers/media/pci/ivtv/ivtv-alsa-mixer.h           |   18 -
 drivers/media/pci/ivtv/ivtvfb.c                    |   12 +-
 drivers/media/pci/mantis/mantis_vp3028.c           |   38 -
 drivers/media/pci/mantis/mantis_vp3028.h           |   33 -
 drivers/media/pci/ngene/Kconfig                    |    7 +
 drivers/media/pci/ngene/Makefile                   |    3 -
 drivers/media/pci/ngene/ngene-cards.c              |  575 +++-
 drivers/media/pci/ngene/ngene-core.c               |  117 +-
 drivers/media/pci/ngene/ngene-dvb.c                |  151 +-
 drivers/media/pci/ngene/ngene-i2c.c                |    2 +-
 drivers/media/pci/ngene/ngene.h                    |   24 +
 drivers/media/pci/saa7134/saa7134-alsa.c           |    5 +-
 drivers/media/pci/saa7134/saa7134-dvb.c            |    2 +-
 drivers/media/pci/saa7134/saa7134-input.c          |   46 +-
 drivers/media/pci/saa7134/saa7134-video.c          |    2 +-
 drivers/media/pci/saa7164/saa7164-dvb.c            |    2 +-
 drivers/media/pci/solo6x10/solo6x10-g723.c         |   39 +-
 drivers/media/pci/solo6x10/solo6x10-p2m.c          |    7 +-
 drivers/media/pci/ttpci/ttpci-eeprom.c             |    9 +-
 drivers/media/pci/zoran/zoran_driver.c             |    4 +-
 drivers/media/platform/Kconfig                     |   11 +-
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/atmel/atmel-isc.c           |   12 +-
 drivers/media/platform/atmel/atmel-isi.c           |   12 +-
 drivers/media/platform/blackfin/bfin_capture.c     |   14 +-
 drivers/media/platform/cec-gpio/cec-gpio.c         |   14 +-
 drivers/media/platform/coda/coda-bit.c             |   46 +-
 drivers/media/platform/coda/coda-common.c          |   44 +-
 drivers/media/platform/coda/coda.h                 |    3 +-
 drivers/media/platform/davinci/vpss.c              |    2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |    7 +-
 drivers/media/platform/exynos4-is/fimc-is-regs.c   |    2 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |   12 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c |    2 +
 drivers/media/platform/omap/omap_vout_vrfb.c       |    3 +-
 drivers/media/platform/qcom/venus/hfi_msgs.c       |    4 +-
 drivers/media/platform/rcar-vin/rcar-dma.c         |  206 +-
 drivers/media/platform/rcar-vin/rcar-vin.h         |   10 +-
 drivers/media/platform/rcar_drif.c                 |    3 +-
 drivers/media/platform/renesas-ceu.c               | 1677 ++++++++++
 drivers/media/platform/rockchip/rga/rga-buf.c      |    3 +-
 drivers/media/platform/rockchip/rga/rga.c          |    2 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |    7 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v10.h      |   87 +
 drivers/media/platform/s5p-mfc/regs-mfc-v8.h       |    2 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   28 +
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c    |    9 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |   68 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |    8 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   48 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |  599 +++-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h       |   14 +
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |  397 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h    |   15 +
 drivers/media/platform/sh_veu.c                    |    4 +-
 drivers/media/platform/soc_camera/soc_camera.c     |   12 +-
 drivers/media/platform/stm32/stm32-cec.c           |    5 +-
 drivers/media/platform/stm32/stm32-dcmi.c          |  305 +-
 drivers/media/platform/via-camera.c                |    4 +-
 drivers/media/platform/vimc/vimc-common.c          |    4 +-
 drivers/media/platform/vimc/vimc-debayer.c         |    2 +-
 drivers/media/platform/vimc/vimc-scaler.c          |    2 +-
 drivers/media/platform/vimc/vimc-sensor.c          |   10 +-
 drivers/media/platform/vivid/vivid-cec.c           |   33 +-
 drivers/media/platform/vivid/vivid-cec.h           |   14 +-
 drivers/media/platform/vivid/vivid-core.c          |   14 +-
 drivers/media/platform/vivid/vivid-core.h          |   14 +-
 drivers/media/platform/vivid/vivid-ctrls.c         |   16 +-
 drivers/media/platform/vivid/vivid-ctrls.h         |   14 +-
 drivers/media/platform/vivid/vivid-kthread-cap.c   |   14 +-
 drivers/media/platform/vivid/vivid-kthread-cap.h   |   14 +-
 drivers/media/platform/vivid/vivid-kthread-out.c   |   14 +-
 drivers/media/platform/vivid/vivid-kthread-out.h   |   14 +-
 drivers/media/platform/vivid/vivid-osd.c           |   14 +-
 drivers/media/platform/vivid/vivid-osd.h           |   14 +-
 drivers/media/platform/vivid/vivid-radio-common.c  |   14 +-
 drivers/media/platform/vivid/vivid-radio-common.h  |   14 +-
 drivers/media/platform/vivid/vivid-radio-rx.c      |   16 +-
 drivers/media/platform/vivid/vivid-radio-rx.h      |   14 +-
 drivers/media/platform/vivid/vivid-radio-tx.c      |   14 +-
 drivers/media/platform/vivid/vivid-radio-tx.h      |   14 +-
 drivers/media/platform/vivid/vivid-rds-gen.c       |   14 +-
 drivers/media/platform/vivid/vivid-rds-gen.h       |   14 +-
 drivers/media/platform/vivid/vivid-sdr-cap.c       |   14 +-
 drivers/media/platform/vivid/vivid-sdr-cap.h       |   14 +-
 drivers/media/platform/vivid/vivid-vbi-cap.c       |   14 +-
 drivers/media/platform/vivid/vivid-vbi-cap.h       |   14 +-
 drivers/media/platform/vivid/vivid-vbi-gen.c       |   14 +-
 drivers/media/platform/vivid/vivid-vbi-gen.h       |   14 +-
 drivers/media/platform/vivid/vivid-vbi-out.c       |   14 +-
 drivers/media/platform/vivid/vivid-vbi-out.h       |   14 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |   19 +-
 drivers/media/platform/vivid/vivid-vid-cap.h       |   14 +-
 drivers/media/platform/vivid/vivid-vid-common.c    |   17 +-
 drivers/media/platform/vivid/vivid-vid-common.h    |   14 +-
 drivers/media/platform/vivid/vivid-vid-out.c       |   14 +-
 drivers/media/platform/vivid/vivid-vid-out.h       |   14 +-
 drivers/media/platform/vsp1/vsp1_dl.c              |    3 +-
 drivers/media/platform/vsp1/vsp1_drm.c             |   30 +-
 drivers/media/platform/vsp1/vsp1_lif.c             |   12 +
 drivers/media/platform/vsp1/vsp1_regs.h            |    8 +-
 drivers/media/radio/radio-mr800.c                  |    2 +-
 drivers/media/radio/radio-raremono.c               |   14 +-
 drivers/media/radio/radio-wl1273.c                 |    2 +-
 drivers/media/radio/si470x/radio-si470x-common.c   |   17 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c      |   32 +-
 drivers/media/radio/si470x/radio-si470x-usb.c      |    2 +-
 drivers/media/radio/si470x/radio-si470x.h          |    2 +
 drivers/media/radio/si4713/radio-usb-si4713.c      |   14 +-
 drivers/media/rc/Kconfig                           |   32 +-
 drivers/media/rc/Makefile                          |    2 +
 drivers/media/rc/imon.c                            |  170 +-
 drivers/media/rc/imon_raw.c                        |  199 ++
 drivers/media/rc/ir-hix5hd2.c                      |   35 +-
 drivers/media/rc/ir-imon-decoder.c                 |  193 ++
 drivers/media/rc/ir-jvc-decoder.c                  |   14 +-
 drivers/media/rc/ir-mce_kbd-decoder.c              |   60 +-
 drivers/media/rc/ir-nec-decoder.c                  |   20 +-
 drivers/media/rc/ir-rc5-decoder.c                  |   12 +-
 drivers/media/rc/ir-rc6-decoder.c                  |   26 +-
 drivers/media/rc/ir-sanyo-decoder.c                |   18 +-
 drivers/media/rc/ir-sharp-decoder.c                |   17 +-
 drivers/media/rc/ir-sony-decoder.c                 |   14 +-
 drivers/media/rc/ir-spi.c                          |   24 +-
 drivers/media/rc/ir-xmp-decoder.c                  |   29 +-
 drivers/media/rc/keymaps/Makefile                  |    1 +
 drivers/media/rc/keymaps/rc-imon-pad.c             |    3 +-
 drivers/media/rc/keymaps/rc-imon-rsc.c             |   81 +
 drivers/media/rc/lirc_dev.c                        |   20 +-
 drivers/media/rc/mceusb.c                          |  160 +-
 drivers/media/rc/meson-ir.c                        |    7 +-
 drivers/media/rc/rc-core-priv.h                    |   18 +-
 drivers/media/rc/rc-ir-raw.c                       |   60 +-
 drivers/media/rc/rc-main.c                         |  100 +-
 drivers/media/rc/sunxi-cir.c                       |   19 +-
 drivers/media/spi/Kconfig                          |   14 +
 drivers/media/spi/Makefile                         |    5 +
 drivers/media/spi/cxd2880-spi.c                    |  670 ++++
 drivers/media/tuners/e4000.c                       |   16 +-
 drivers/media/tuners/fc2580.c                      |   16 +-
 drivers/media/tuners/msi001.c                      |   19 +-
 drivers/media/usb/au0828/Kconfig                   |    5 +-
 drivers/media/usb/au0828/au0828-video.c            |    4 +-
 drivers/media/usb/cpia2/cpia2_usb.c                |    3 -
 drivers/media/usb/cx231xx/cx231xx-cards.c          |   87 +-
 drivers/media/usb/cx231xx/cx231xx-dvb.c            |  389 ++-
 drivers/media/usb/cx231xx/cx231xx-video.c          |    2 +-
 drivers/media/usb/cx231xx/cx231xx.h                |    3 +
 drivers/media/usb/dvb-usb-v2/Kconfig               |    3 +-
 drivers/media/usb/dvb-usb-v2/af9015.c              |  985 +++---
 drivers/media/usb/dvb-usb-v2/af9015.h              |   20 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb.h             |    4 +
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        |   24 +-
 drivers/media/usb/dvb-usb/cxusb.c                  |  141 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c        |    2 +-
 drivers/media/usb/em28xx/em28xx-audio.c            |  116 +-
 drivers/media/usb/em28xx/em28xx-camera.c           |   49 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |  905 +++--
 drivers/media/usb/em28xx/em28xx-core.c             |  231 +-
 drivers/media/usb/em28xx/em28xx-dvb.c              | 1015 +++---
 drivers/media/usb/em28xx/em28xx-i2c.c              |  173 +-
 drivers/media/usb/em28xx/em28xx-input.c            |  172 +-
 drivers/media/usb/em28xx/em28xx-reg.h              |   52 +-
 drivers/media/usb/em28xx/em28xx-v4l.h              |   27 +-
 drivers/media/usb/em28xx/em28xx-vbi.c              |   39 +-
 drivers/media/usb/em28xx/em28xx-video.c            |  391 ++-
 drivers/media/usb/em28xx/em28xx.h                  |  396 ++-
 drivers/media/usb/go7007/snd-go7007.c              |    2 +-
 drivers/media/usb/gspca/dtcs033.c                  |    6 +-
 drivers/media/usb/s2255/s2255drv.c                 |   12 +-
 drivers/media/usb/siano/smsusb.c                   |    4 +-
 drivers/media/usb/tm6000/tm6000-cards.c            |    2 +-
 drivers/media/usb/tm6000/tm6000-video.c            |    5 +-
 drivers/media/usb/usbtv/usbtv-core.c               |    3 +
 drivers/media/usb/uvc/uvc_ctrl.c                   |  114 +-
 drivers/media/usb/uvc/uvc_driver.c                 |   97 +-
 drivers/media/usb/uvc/uvc_isight.c                 |    6 +-
 drivers/media/usb/uvc/uvc_status.c                 |    4 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |  141 +-
 drivers/media/usb/uvc/uvc_video.c                  |   47 +-
 drivers/media/usb/uvc/uvcvideo.h                   |  320 +-
 drivers/media/usb/zr364xx/zr364xx.c                |    5 +-
 drivers/media/v4l2-core/tuner-core.c               |   15 +-
 drivers/media/v4l2-core/v4l2-common.c              |   82 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |  119 +
 drivers/media/v4l2-core/v4l2-dv-timings.c          |  156 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   18 +-
 drivers/media/v4l2-core/v4l2-mc.c                  |   12 +-
 drivers/media/v4l2-core/v4l2-subdev.c              |   50 +
 drivers/media/v4l2-core/videobuf-dma-sg.c          |    5 +-
 drivers/staging/media/Kconfig                      |    6 +-
 drivers/staging/media/Makefile                     |    3 +-
 drivers/staging/media/atomisp/i2c/Kconfig          |   12 -
 drivers/staging/media/atomisp/i2c/atomisp-gc0310.c |   53 -
 drivers/staging/media/atomisp/i2c/atomisp-gc2235.c |   53 -
 .../staging/media/atomisp/i2c/atomisp-mt9m114.c    |    6 -
 drivers/staging/media/atomisp/i2c/atomisp-ov2680.c |   56 -
 drivers/staging/media/atomisp/i2c/atomisp-ov2722.c |   53 -
 drivers/staging/media/atomisp/i2c/gc0310.h         |   43 -
 drivers/staging/media/atomisp/i2c/gc2235.h         |    7 +-
 drivers/staging/media/atomisp/i2c/ov2680.h         |   68 -
 drivers/staging/media/atomisp/i2c/ov2722.h         |    6 +
 .../media/atomisp/i2c/ov5693/atomisp-ov5693.c      |   56 +-
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.h  |    6 +
 drivers/staging/media/atomisp/i2c/ov8858.c         | 2169 ------------
 drivers/staging/media/atomisp/i2c/ov8858.h         | 1474 --------
 drivers/staging/media/atomisp/i2c/ov8858_btns.h    | 1276 -------
 .../media/atomisp/include/linux/vlv2_plat_clock.h  |   30 -
 .../staging/media/atomisp/pci/atomisp2/Makefile    |   10 -
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       |   11 +-
 .../atomisp/pci/atomisp2/atomisp_compat_css20.c    |    2 +-
 .../media/atomisp/pci/atomisp2/atomisp_file.c      |   16 -
 .../media/atomisp/pci/atomisp2/atomisp_fops.c      |    6 +
 .../media/atomisp/pci/atomisp2/atomisp_subdev.c    |   12 +-
 .../media/atomisp/pci/atomisp2/atomisp_tpg.c       |   14 -
 .../media/atomisp/pci/atomisp2/atomisp_v4l2.c      |    1 -
 .../css2400/css_2400_system/hrt/gp_regs_defs.h     |   22 -
 .../atomisp2/css2400/css_2400_system/hrt/sp_hrt.h  |   24 -
 .../css_2401_csi2p_system/hrt/gp_regs_defs.h       |   22 -
 .../css2400/css_2401_csi2p_system/hrt/sp_hrt.h     |   24 -
 .../css2400/css_2401_system/hrt/gp_regs_defs.h     |   22 -
 .../atomisp2/css2400/css_2401_system/hrt/sp_hrt.h  |   24 -
 .../atomisp/pci/atomisp2/css2400/css_api_version.h |  673 ----
 .../host/hive_isp_css_ddr_hrt_modified.h           |  148 -
 .../host/hive_isp_css_hrt_modified.h               |   79 -
 .../hive_isp_css_common/input_formatter_global.h   |   16 -
 .../css2400/hive_isp_css_common/resource_global.h  |   35 -
 .../css2400/hive_isp_css_common/xmem_global.h      |   20 -
 .../atomisp2/css2400/hive_isp_css_include/bamem.h  |   46 -
 .../css2400/hive_isp_css_include/bbb_config.h      |   27 -
 .../css2400/hive_isp_css_include/cpu_mem_support.h |   59 -
 .../hive_isp_css_include/host/isp2400_config.h     |   24 -
 .../hive_isp_css_include/host/isp2500_config.h     |   29 -
 .../hive_isp_css_include/host/isp2600_config.h     |   34 -
 .../hive_isp_css_include/host/isp2601_config.h     |   70 -
 .../css2400/hive_isp_css_include/host/isp_config.h |   24 -
 .../css2400/hive_isp_css_include/host/isp_op1w.h   |  844 -----
 .../hive_isp_css_include/host/isp_op1w_types.h     |   54 -
 .../css2400/hive_isp_css_include/host/isp_op2w.h   |  674 ----
 .../hive_isp_css_include/host/isp_op2w_types.h     |   49 -
 .../hive_isp_css_include/host/isp_op_count.h       |  226 --
 .../hive_isp_css_include/host/osys_public.h        |   20 -
 .../hive_isp_css_include/host/pipeline_public.h    |   18 -
 .../hive_isp_css_include/host/ref_vector_func.h    | 1221 -------
 .../host/ref_vector_func_types.h                   |  385 ---
 .../atomisp2/css2400/hive_isp_css_include/mpmath.h |  329 --
 .../atomisp2/css2400/hive_isp_css_include/osys.h   |   47 -
 .../css2400/hive_isp_css_include/stream_buffer.h   |   47 -
 .../css2400/hive_isp_css_include/vector_func.h     |   38 -
 .../css2400/hive_isp_css_include/vector_ops.h      |   31 -
 .../atomisp2/css2400/hive_isp_css_include/xmem.h   |   46 -
 .../css2400/hive_isp_css_shared/socket_global.h    |   53 -
 .../hive_isp_css_shared/stream_buffer_global.h     |   26 -
 .../pci/atomisp2/css2400/ia_css_frame_public.h     |   29 +-
 .../atomisp/pci/atomisp2/css2400/ia_css_pipe.h     |  113 +-
 .../pci/atomisp2/css2400/ia_css_pipe_public.h      |  110 +-
 .../atomisp/pci/atomisp2/css2400/ia_css_types.h    |   64 +-
 .../css2400/isp/kernels/aa/aa_2/ia_css_aa2_state.h |   41 -
 .../bayer_ls_1.0/ia_css_bayer_load_param.h         |   20 -
 .../bayer_ls/bayer_ls_1.0/ia_css_bayer_ls_param.h  |   42 -
 .../bayer_ls_1.0/ia_css_bayer_store_param.h        |   21 -
 .../css2400/isp/kernels/bnlm/ia_css_bnlm_state.h   |   31 -
 .../isp/kernels/cnr/cnr_1.0/ia_css_cnr_state.h     |   33 -
 .../isp/kernels/cnr/cnr_2/ia_css_cnr_state.h       |   33 -
 .../isp/kernels/dp/dp_1.0/ia_css_dp_state.h        |   36 -
 .../css2400/isp/kernels/dpc2/ia_css_dpc2_state.h   |   30 -
 .../isp/kernels/eed1_8/ia_css_eed1_8_state.h       |   40 -
 .../io_ls/plane_io_ls/ia_css_plane_io_param.h      |   22 -
 .../io_ls/plane_io_ls/ia_css_plane_io_types.h      |   30 -
 .../io_ls/yuv420_io_ls/ia_css_yuv420_io_param.h    |   22 -
 .../io_ls/yuv420_io_ls/ia_css_yuv420_io_types.h    |   22 -
 .../ipu2_io_ls/plane_io_ls/ia_css_plane_io_param.h |   22 -
 .../ipu2_io_ls/plane_io_ls/ia_css_plane_io_types.h |   30 -
 .../yuv420_io_ls/ia_css_yuv420_io_param.h          |   22 -
 .../yuv420_io_ls/ia_css_yuv420_io_types.h          |   22 -
 .../isp/kernels/norm/norm_1.0/ia_css_norm_types.h  |   21 -
 .../isp/kernels/s3a/s3a_1.0/ia_css_s3a_types.h     |   50 +-
 .../kernels/s3a_stat_ls/ia_css_s3a_stat_ls_param.h |   45 -
 .../s3a_stat_ls/ia_css_s3a_stat_store_param.h      |   21 -
 .../kernels/scale/scale_1.0/ia_css_scale_param.h   |   20 -
 .../kernels/sdis/common/ia_css_sdis_common_types.h |   31 +-
 .../isp/kernels/sdis/common/ia_css_sdis_param.h    |   22 -
 .../isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c   |    3 +-
 .../isp/kernels/sdis/sdis_1.0/ia_css_sdis_param.h  |   21 -
 .../isp/kernels/sdis/sdis_2/ia_css_sdis_param.h    |   21 -
 .../xnr/xnr_3.0/ia_css_xnr3_wrapper_param.h        |   20 -
 .../yuv_ls/yuv_ls_1.0/ia_css_yuv_load_param.h      |   20 -
 .../yuv_ls/yuv_ls_1.0/ia_css_yuv_ls_param.h        |   39 -
 .../yuv_ls/yuv_ls_1.0/ia_css_yuv_store_param.h     |   21 -
 .../css2400/isp/modes/interface/isp_exprs.h        |  286 --
 .../runtime/binary/interface/ia_css_binary.h       |   88 +-
 .../atomisp2/css2400/runtime/binary/src/binary.c   |    3 +-
 .../css2400/runtime/debug/src/ia_css_debug.c       |    8 +-
 .../pci/atomisp2/css2400/runtime/frame/src/frame.c |    2 +-
 .../isp_param/interface/ia_css_isp_param_types.h   |    9 -
 .../runtime/pipeline/interface/ia_css_pipeline.h   |   24 +-
 .../css2400/runtime/pipeline/src/pipeline.c        |    7 +-
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    |   49 +-
 .../atomisp/pci/atomisp2/css2400/sh_css_legacy.h   |   11 -
 .../atomisp/pci/atomisp2/css2400/sh_css_metrics.h  |   21 -
 .../atomisp/pci/atomisp2/include/hmm/hmm_bo_dev.h  |  126 -
 .../atomisp/pci/atomisp2/include/mmu/sh_mmu.h      |   72 -
 .../media/atomisp/pci/atomisp2/mmu/isp_mmu.c       |    2 +-
 drivers/staging/media/cxd2099/Kconfig              |   12 -
 drivers/staging/media/cxd2099/Makefile             |    4 -
 drivers/staging/media/cxd2099/TODO                 |   12 -
 .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |    2 +-
 drivers/staging/media/imx/Kconfig                  |    4 +-
 drivers/staging/media/imx/imx-ic-prp.c             |    1 +
 drivers/staging/media/imx/imx-ic-prpencvf.c        |    3 +-
 drivers/staging/media/imx/imx-media-capture.c      |    3 +-
 drivers/staging/media/imx/imx-media-csi.c          |    9 +-
 drivers/staging/media/imx/imx-media-internal-sd.c  |    2 +-
 drivers/staging/media/imx/imx-media-utils.c        |  118 +-
 drivers/staging/media/imx/imx-media-vdic.c         |    3 +-
 drivers/staging/media/imx/imx-media.h              |    2 +
 drivers/staging/media/imx/imx6-mipi-csi2.c         |   25 +-
 drivers/staging/media/imx074/Kconfig               |    5 +
 drivers/staging/media/imx074/Makefile              |    1 +
 drivers/staging/media/imx074/TODO                  |    5 +
 .../soc_camera => staging/media/imx074}/imx074.c   |    0
 drivers/staging/media/mt9t031/Kconfig              |   11 +
 drivers/staging/media/mt9t031/Makefile             |    1 +
 drivers/staging/media/mt9t031/TODO                 |    5 +
 .../soc_camera => staging/media/mt9t031}/mt9t031.c |    0
 include/dt-bindings/media/tda1997x.h               |   74 +
 include/media/cec-notifier.h                       |   14 +-
 include/media/cec-pin.h                            |   14 +-
 include/media/cec.h                                |   26 +-
 include/media/drv-intf/renesas-ceu.h               |   26 +
 include/media/dvbdev.h                             |   65 +-
 include/media/i2c/ad9389b.h                        |   14 +-
 include/media/i2c/adv7511.h                        |   14 +-
 include/media/i2c/adv7604.h                        |   15 +-
 include/media/i2c/adv7842.h                        |   15 +-
 include/media/i2c/mt9t112.h                        |   17 +-
 include/media/i2c/ov772x.h                         |    6 +-
 include/media/i2c/tc358743.h                       |   18 +-
 include/media/i2c/tda1997x.h                       |   42 +
 include/media/i2c/ths7303.h                        |   10 +-
 include/media/i2c/tw9910.h                         |    9 +
 include/media/i2c/uda1342.h                        |   15 +-
 include/media/rc-core.h                            |   11 +-
 include/media/rc-map.h                             |    9 +-
 include/media/tpg/v4l2-tpg.h                       |   14 +-
 include/media/v4l2-common.h                        |   60 +-
 include/media/v4l2-ctrls.h                         |    4 +-
 include/media/v4l2-dev.h                           |    6 +-
 include/media/v4l2-dv-timings.h                    |   36 +-
 include/media/v4l2-fh.h                            |    1 +
 include/media/v4l2-rect.h                          |   14 +-
 include/media/v4l2-subdev.h                        |  121 +-
 include/media/videobuf2-core.h                     |   33 +-
 include/uapi/linux/cec-funcs.h                     |   29 -
 include/uapi/linux/cec.h                           |   29 -
 include/uapi/linux/lirc.h                          |    2 +
 include/uapi/linux/media.h                         |  344 +-
 include/uapi/linux/v4l2-controls.h                 |   93 +-
 include/uapi/linux/v4l2-mediabus.h                 |    4 +-
 include/uapi/linux/videodev2.h                     |    1 +
 573 files changed, 37796 insertions(+), 21337 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-cec-error-inj
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2685.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5695.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov9650.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/tda1997x.txt
 create mode 100644 Documentation/devicetree/bindings/media/renesas,ceu.txt
 create mode 100644 Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt
 create mode 100644 Documentation/media/uapi/cec/cec-pin-error-inj.rst
 create mode 100644 drivers/media/cec/cec-pin-error-inj.c
 rename drivers/{staging/media/cxd2099 => media/dvb-frontends}/cxd2099.c (78%)
 rename drivers/{staging/media/cxd2099 => media/dvb-frontends}/cxd2099.h (62%)
 create mode 100644 drivers/media/dvb-frontends/cxd2880/Kconfig
 create mode 100644 drivers/media/dvb-frontends/cxd2880/Makefile
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_common.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_common.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_dtv.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_dvbt2.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_integ.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_io.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_io.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_spi.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_spi_device.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_driver_version.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt2_mon.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_dvbt_mon.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.c
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_tnrdmd_mon.h
 create mode 100644 drivers/media/dvb-frontends/cxd2880/cxd2880_top.c
 delete mode 100644 drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h
 create mode 100644 drivers/media/i2c/mt9t112.c
 create mode 100644 drivers/media/i2c/ov2685.c
 create mode 100644 drivers/media/i2c/ov5695.c
 create mode 100644 drivers/media/i2c/ov772x.c
 create mode 100644 drivers/media/i2c/tda1997x.c
 create mode 100644 drivers/media/i2c/tda1997x_regs.h
 create mode 100644 drivers/media/i2c/tw9910.c
 delete mode 100644 drivers/media/pci/cx18/cx18-alsa-mixer.c
 delete mode 100644 drivers/media/pci/cx18/cx18-alsa-mixer.h
 delete mode 100644 drivers/media/pci/ivtv/ivtv-alsa-mixer.c
 delete mode 100644 drivers/media/pci/ivtv/ivtv-alsa-mixer.h
 delete mode 100644 drivers/media/pci/mantis/mantis_vp3028.c
 delete mode 100644 drivers/media/pci/mantis/mantis_vp3028.h
 create mode 100644 drivers/media/platform/renesas-ceu.c
 create mode 100644 drivers/media/platform/s5p-mfc/regs-mfc-v10.h
 create mode 100644 drivers/media/rc/imon_raw.c
 create mode 100644 drivers/media/rc/ir-imon-decoder.c
 create mode 100644 drivers/media/rc/keymaps/rc-imon-rsc.c
 create mode 100644 drivers/media/spi/cxd2880-spi.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/ov8858.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/ov8858.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/ov8858_btns.h
 delete mode 100644 drivers/staging/media/atomisp/include/linux/vlv2_plat_clock.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hrt/gp_regs_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hrt/sp_hrt.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hrt/gp_regs_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hrt/sp_hrt.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hrt/gp_regs_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hrt/sp_hrt.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_api_version.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/hive_isp_css_ddr_hrt_modified.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/hive_isp_css_hrt_modified.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/resource_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/xmem_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/bamem.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/bbb_config.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/cpu_mem_support.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/isp2400_config.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/isp2500_config.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/isp2600_config.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/isp2601_config.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/isp_config.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/isp_op1w.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/isp_op1w_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/isp_op2w.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/isp_op2w_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/isp_op_count.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/osys_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/pipeline_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/ref_vector_func.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/host/ref_vector_func_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/mpmath.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/osys.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/stream_buffer.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/vector_func.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/vector_ops.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/xmem.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_shared/socket_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_shared/stream_buffer_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/aa/aa_2/ia_css_aa2_state.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bayer_ls/bayer_ls_1.0/ia_css_bayer_load_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bayer_ls/bayer_ls_1.0/ia_css_bayer_ls_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bayer_ls/bayer_ls_1.0/ia_css_bayer_store_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bnlm/ia_css_bnlm_state.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/cnr/cnr_1.0/ia_css_cnr_state.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/cnr/cnr_2/ia_css_cnr_state.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/dp/dp_1.0/ia_css_dp_state.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/dpc2/ia_css_dpc2_state.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8_state.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/io_ls/plane_io_ls/ia_css_plane_io_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/io_ls/plane_io_ls/ia_css_plane_io_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/io_ls/yuv420_io_ls/ia_css_yuv420_io_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/io_ls/yuv420_io_ls/ia_css_yuv420_io_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/ipu2_io_ls/plane_io_ls/ia_css_plane_io_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/ipu2_io_ls/plane_io_ls/ia_css_plane_io_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/ipu2_io_ls/yuv420_io_ls/ia_css_yuv420_io_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/ipu2_io_ls/yuv420_io_ls/ia_css_yuv420_io_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/norm/norm_1.0/ia_css_norm_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/s3a_stat_ls/ia_css_s3a_stat_ls_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/s3a_stat_ls/ia_css_s3a_stat_store_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/scale/scale_1.0/ia_css_scale_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/common/ia_css_sdis_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_1.0/ia_css_sdis_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/sdis/sdis_2/ia_css_sdis_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr_3.0/ia_css_xnr3_wrapper_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/yuv_ls/yuv_ls_1.0/ia_css_yuv_load_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/yuv_ls/yuv_ls_1.0/ia_css_yuv_ls_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/yuv_ls/yuv_ls_1.0/ia_css_yuv_store_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/modes/interface/isp_exprs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_bo_dev.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/include/mmu/sh_mmu.h
 delete mode 100644 drivers/staging/media/cxd2099/Kconfig
 delete mode 100644 drivers/staging/media/cxd2099/Makefile
 delete mode 100644 drivers/staging/media/cxd2099/TODO
 create mode 100644 drivers/staging/media/imx074/Kconfig
 create mode 100644 drivers/staging/media/imx074/Makefile
 create mode 100644 drivers/staging/media/imx074/TODO
 rename drivers/{media/i2c/soc_camera => staging/media/imx074}/imx074.c (100%)
 create mode 100644 drivers/staging/media/mt9t031/Kconfig
 create mode 100644 drivers/staging/media/mt9t031/Makefile
 create mode 100644 drivers/staging/media/mt9t031/TODO
 rename drivers/{media/i2c/soc_camera => staging/media/mt9t031}/mt9t031.c (100%)
 create mode 100644 include/dt-bindings/media/tda1997x.h
 create mode 100644 include/media/drv-intf/renesas-ceu.h
 create mode 100644 include/media/i2c/tda1997x.h
