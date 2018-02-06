Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:44008 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752183AbeBFLLn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Feb 2018 06:11:43 -0500
Date: Tue, 6 Feb 2018 09:11:30 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.16-rc1] media updates
Message-ID: <20180206091130.75c0f1ae@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.16-2

For:

- videobuf2 was moved to a media/common dir, as it is now used by the DVB
  subsystem too;
- Digital TV core memory mapped support interface;
- New sensor drivers: ov7740;
- Several improvements at ddbridge driver;
- New V4L2 driver: IPU3 CIO2 CSI-2 receiver unit, found on some Intel SoCs;
- New tuner driver: tda18250;
- Finally got rid of all LIRC staging drivers;
- As we don't have old lirc drivers anymore, restruct the lirc device code;
- Add support for UVC metadata;
- Add a new staging driver for NVIDIA Tegra Video Decoder Engine;
- DVB kAPI headers moved to include/media;
- Synchronize the kAPI and uAPI for the DVB subsystem, removing the gap for
  non-legacy APIs;
- Reduce the kAPI gap for V4L2;
- Lots of other driver enhancements, cleanups, etc.

-

PS.:

1) You may expect a merge conflict due to this patch:
	c23e0cb81e40 ("media: annotate ->poll() instances")

     See: https://lkml.org/lkml/2018/1/1/547

As you requested last time, I'm not pulling from vfs in order to solve it.

2) Some patches here required kernel-doc support for nested struct. Those
   patches were already merged on this commit:

	Fixes: 255442c93843 ("Merge tag 'docs-4.16' of git://git.lwn.net/linux")

Yet, those patches appear at the git request-pull log/diffstat, because
git request-pull was not smart enough to accept changeset 255442c93843
as origin. Doing a:

	$ git request-pull 255442c93843 git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media media/v4.16-2

Makes it to silently ignore 255442c93843 and go to a root node from the last
pull request I have from your tree, e. g. changeset 30a7acd57389
("Linux 4.15-rc6"). As such changeset doesn't contain Jon's tree,
it shows all docs-4.16 patches at the diffstat.

I suspect that the only way to fix that would be to either rebase the
media tree or merge from 255442c93843 with would, IMHO, cause more harm 
than good.

Regards,
Mauro

---

The following changes since commit 30a7acd573899fd8b8ac39236eff6468b195ac7d:

  Linux 4.15-rc6 (2017-12-31 14:47:43 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.16-2

for you to fetch changes up to 273caa260035c03d89ad63d72d8cd3d9e5c5e3f1:

  media: v4l2-compat-ioctl32.c: make ctrl_is_pointer work for subdevs (2018-01-31 03:09:04 -0500)

----------------------------------------------------------------
media updates for v4.16-rc1

----------------------------------------------------------------
Aishwarya Pant (1):
      media: staging: atomisp2: replace DEVICE_ATTR with DEVICE_ATTR_RO

Akinobu Mita (8):
      media: ov7670: use v4l2_async_unregister_subdev()
      media: ov7670: add V4L2_CID_TEST_PATTERN control
      media: dt-bindings: media: xilinx: fix typo in example
      media: xilinx-video: fix bad of_node_put() on endpoint error
      media: mt9m111: create subdevice device node
      media: mt9m111: add media controller support
      media: mt9m111: document missing required clocks property
      media: mt9m111: add V4L2_CID_TEST_PATTERN control

Alexey Khoroshilov (1):
      media: v4l: mt9v032: Disable clock on error paths

Andi Shyti (1):
      media: ir-spi: add SPDX identifier

Andrey Konovalov (1):
      media: pvrusb2: properly check endpoint types

Andy Shevchenko (12):
      media: adv7180: Remove duplicate checks
      media: i2c: adv748x: Remove duplicate NULL check
      media: staging: atomisp: Don't leak GPIO resources if clk_get() failed
      media: staging: atomisp: Remove duplicate NULL-check
      media: staging: atomisp: lm3554: Fix control values
      media: staging: atomisp: Disable custom format for now
      media: staging: atomisp: Remove non-ACPI leftovers
      media: staging: atomisp: Switch to use struct device_driver directly
      media: staging: atomisp: Remove redundant PCI code
      media: staging: atomisp: Unexport local function
      media: staging: atomisp: Use standard DMI match table
      media: staging: atomisp: Fix DMI matching entry for MRD7

Arnd Bergmann (19):
      media: solo6x10: hide unused variable
      media: pulse8-cec: print time using time64_t
      media: vivid: print time in y2038-safe way
      media: solo6x10: use ktime_get_ts64() for time sync
      media: staging: imx: use ktime_t for timestamps
      media: vivid: use ktime_t for timestamp calculation
      media: tuners: tda8290: reduce stack usage with kasan
      media: r820t: fix r820t_write_reg for KASAN
      media: dvb-frontends: fix i2c access helpers for KASAN
      media: exynos4-is: properly initialize frame format
      media: staging: atomisp: convert timestamps to ktime_t
      media: uvcvideo: Use ktime_t for stats
      media: uvcvideo: Use ktime_t for timestamps
      media: intel-ipu3: cio2: mark PM functions as __maybe_unused
      media: intel-ipu3: cio2: fix building with large PAGE_SIZE
      media: staging: tegra-vde: select DMA_SHARED_BUFFER
      media: cobalt: select CONFIG_SND_PCM
      media: intel-ipu3: cio2: mark more PM functions as __maybe_unused
      media: i2c: ov7740: use gpio/consumer.h instead of gpio.h

Arvind Yadav (3):
      media: hdpvr: Fix an error handling path in hdpvr_probe()
      media: cx23885: Handle return value of kasprintf
      media: winbond-cir: Fix pnp_irq's error checking for wbcir_probe

Athanasios Oikonomou (2):
      media: dvb_frontend: add physical layer scrambling support
      media: stv090x: add physical layer scrambling support

Baoyou Xie (1):
      media: uvcvideo: Mark buffer error where overflow

Benjamin Gaignard (1):
      media: platform: sti: Adopt SPDX identifier

Bjorn Helgaas (1):
      media: netup_unidvb: use PCI_EXP_DEVCTL2_COMP_TIMEOUT macro

Christophe JAILLET (1):
      media: bt8xx: Fix err 'bt878_probe()'

Chunyan Zhang (1):
      media: rc: Replace timeval with ktime_t in imon.c

Colin Ian King (9):
      media: tuners: mxl5005s: make arrays static const, reduces object code size
      media: cxusb: pass buf as a const u8 * pointer and make buf static const
      media: pt3: remove redundant assignment to mask
      media: drivers/media/pci/zoran: remove redundant assignment to pointer h
      media: stb0899: remove redundant self assignment of k_indirect
      media: dvb-frontends/stv0367: remove redundant self assignment of temporary
      media: dvb_frontend: remove redundant status self assignment
      media: dvb_ca_en50221: sanity check slot number from userspace
      media: lirc: don't kfree the uninitialized pointer txbuf

Dan Carpenter (3):
      media: stk-webcam: Fix use after free on disconnect
      media: cpia2: Fix a couple off by one bugs
      media: imx274: Silence uninitialized variable warning

Daniel Mentz (1):
      media: v4l2-compat-ioctl32.c: refactor compat ioctl32 logic

Daniel Scheller (32):
      media: ddbridge: remove unneeded *fe vars from attach functions
      media: ddbridge: fixup checkpatch-strict issues
      media: ddbridge: split off CI (common interface) from ddbridge-core
      media: ddbridge/ci: change debug printing to debug severity
      media: ddbridge/max: rename ddbridge-maxs8.[c|h] to ddbridge-max.[c|h]
      media: ddbridge/max: prefix lnb_init_fmode() and fe_attach_mxl5xx()
      media: stv0910: read and update mod_cod in read_status()
      media: ddbridge: update driver version number
      media: frontends/stv0910: add field offsets to field defines
      media: dvb-frontends/stv0910: WARN_ON() on consecutive mutex_unlock()
      media: dvb-frontends/stv6111: handle gate_ctrl errors
      media: dvb-frontends/stv0910: remove unneeded check/call to get_if_freq
      media: dvb-frontends/stv0910: read symbolrate in get_frontend()
      media: dvb-frontends/stv0910: remove unneeded symbol rate inquiry
      media: dvb-frontends/stv0910: remove unneeded dvb_math.h include
      media: ddbridge: improve error handling logic on fe attach failures
      media: ddbridge: stv09xx: detach frontends on lnb failure
      media: staging/cxd2099: fix remaining checkpatch-strict issues
      media: staging/cxd2099: fix debug message severity
      media: staging/cxd2099: cosmetics: improve strings
      media: ddbridge: unregister I2C tuner client before detaching fe's
      media: ddbridge: fix resources cleanup for CI hardware
      media: ddbridge: completely tear down input resources on failure
      media: ddbridge: deduplicate calls to dvb_ca_en50221_init()
      media: ddbridge: fix deinit order in case of failure in ddb_init()
      media: ddbridge: detach first input if the second one failed to init
      media: ddbridge: improve ddb_ports_attach() failure handling
      media: ddbridge: move CI detach code to ddbridge-ci.c
      media: dvb-frontends/stv0910: deduplicate writes in enable_puncture_rate()
      media: dvb-frontends/stv0910: cleanup I2C access functions
      media: dvb-frontends/stv0910: field and register access helpers
      media: dvb-frontends/stv0910: cleanup init_search_param() and enable PLS

Dean A (1):
      media: s2255drv: update firmware load

Dmitry Osipenko (2):
      media: dt: bindings: Add binding for NVIDIA Tegra Video Decoder Engine
      media: staging: media: Introduce NVIDIA Tegra video decoder driver

Fabio Estevam (1):
      media: coda/imx-vdoa: Remove irq member from vdoa_data struct

Fengguang Wu (2):
      media: dvb_frontend: fix ifnullfree.cocci warnings
      media: fix semicolon.cocci warnings

Flavio Ceolin (2):
      media: pxa_camera: disable and unprepare the clock source on error
      media: s5p-jpeg: Fix off-by-one problem

Geert Uytterhoeven (2):
      media: i2c: adv748x: Restore full DT paths in kernel messages
      media: c8sectpfe: DVB_C8SECTPFE should depend on HAS_DMA

Greg Kroah-Hartman (1):
      media: usbvision: remove unneeded DRIVER_LICENSE #define

Guennadi Liakhovetski (3):
      media: v4l: Add a UVC Metadata format
      media: uvcvideo: Add extensible device information
      media: uvcvideo: Add a metadata device node

Gustavo A. R. Silva (4):
      media: staging: media: imx: fix inconsistent IS_ERR and PTR_ERR
      media: davinci: vpif_capture: add NULL check on devm_kzalloc return value
      media: c8sectpfe: fix potential NULL pointer dereference in c8sectpfe_timer_interrupt
      media: siano: fix a potential integer overflow

Hans Verkuil (24):
      media: adv7604.c: add missing return
      media: cec-adap: add '0x' prefix when printing status
      media: vimc: add test_pattern and h/vflip controls to the sensor
      media: cec: add the adap_monitor_pin_enable op
      media: cec-core.rst: document the new adap_monitor_pin_enable op
      media: cec: disable the hardware when unregistered
      media: vidioc-g-dv-timings.rst: fix typo (frontporch -> backporch)
      media: pxa_camera: rename the soc_camera_ prefix to pxa_camera_
      media: pvrusb2: correctly return V4L2_PIX_FMT_MPEG in enum_fmt
      media: dt-bindings/media/cec-gpio.txt: mention the CEC/HPD max voltages
      media: drivers/media/common/videobuf2: rename from videobuf
      media: vivid: fix module load error when enabling fb and no_error_inj=1
      media: v4l2-ioctl.c: use check_fmt for enum/g/s/try_fmt
      media: v4l2-ioctl.c: don't copy back the result for -ENOTTY
      media: v4l2-compat-ioctl32.c: add missing VIDIOC_PREPARE_BUF
      media: v4l2-compat-ioctl32.c: fix the indentation
      media: v4l2-compat-ioctl32.c: move 'helper' functions to __get/put_v4l2_format32
      media: v4l2-compat-ioctl32.c: avoid sizeof(type)
      media: v4l2-compat-ioctl32.c: copy m.userptr in put_v4l2_plane32
      media: v4l2-compat-ioctl32.c: fix ctrl_is_pointer
      media: v4l2-compat-ioctl32.c: copy clip list in put_v4l2_window32
      media: v4l2-compat-ioctl32.c: drop pr_info for unknown buffer type
      media: v4l2-compat-ioctl32.c: don't copy back the result for certain errors
      media: v4l2-compat-ioctl32.c: make ctrl_is_pointer work for subdevs

Hugues Fruchet (6):
      media: ov5640: switch to gpiod_set_value_cansleep()
      media: ov5640: check chip id
      media: dt-bindings: ov5640: refine CSI-2 and add parallel interface
      media: ov5640: add support of DVP parallel interface
      media: ov5640: add support of RGB565 and YUYV formats
      media: ov5640: fix spurious streamon failures

Ian Jamison (1):
      media: imx: Remove incorrect check for queue state in start/stop_streaming

Jacopo Mondi (1):
      media: v4l: sh_mobile_ceu: Return buffers on streamoff()

Jaedon Shin (3):
      media: dvb_frontend: Add unlocked_ioctl in dvb_frontend.c
      media: dvb_frontend: Add compat_ioctl callback
      media: dvb_frontend: Add commands implementation for compat ioct

Jaejoong Kim (1):
      media: uvcvideo: Remove duplicate & operation

Jeremy Sowden (2):
      media: staging: atomisp: fix for sparse "using plain integer as NULL pointer" warnings
      media: staging: atomisp: fixes for "symbol was not declared. Should it be static?" sparse warnings

Jesse Chan (3):
      media: mtk-vcodec: add missing MODULE_LICENSE/DESCRIPTION
      media: soc_camera: soc_scale_crop: add missing MODULE_DESCRIPTION/AUTHOR/LICENSE
      media: tegra-cec: add missing MODULE_DESCRIPTION/AUTHOR/LICENSE

Jia-Ju Bai (1):
      media: bdisp: Fix a possible sleep-in-atomic bug in bdisp_hw_save_request

Joe Perches (3):
      media: gspca: Convert PERR to gspca_err
      media: gspca: Convert PDEBUG to gspca_dbg
      media: dibx000_common: Fix line continuation format

Julia Lawall (1):
      media: pvrusb2: drop unneeded newline

Jérémy Lefaure (1):
      media: use ARRAY_SIZE

Kieran Bingham (2):
      media: i2c: adv748x: Store the pixel rate ctrl on CSI objects
      media: vsp1: Prevent suspending and resuming DRM pipelines

Krzysztof Hałasa (1):
      media: i.MX6: Fix MIPI CSI-2 LP-11 check

Laurent Pinchart (3):
      media: uvcvideo: Stream error events carry no data
      media: uvcvideo: Factor out video device registration to a function
      media: uvcvideo: Report V4L2 device caps through the video_device structure

Loic Poulain (2):
      media: venus: venc: configure entropy mode
      media: venus: venc: Apply inloop deblocking filter

Lucas Stach (1):
      media: coda: set min_buffers_needed

Maciej S. Szmigiero (2):
      media: cx25840: describe standard for 0b1100 value in AFD_FMT_STAT bits
      media: cx25840: fix a possible divide by zero in set_fmt callback

Malcolm Priestley (2):
      media: dvb-usb-v2: lmedm04: Improve logic checking of warm start
      media: dvb-usb-v2: lmedm04: move ts2020 attach to dm04_lme2510_tuner

Marek Szyprowski (3):
      media: exynos-gsc: Drop obsolete capabilities
      media: exynos4-is: Drop obsolete capabilities
      media: exynos4-is: Remove dependency on obsolete SoC support

Martin Kepplinger (1):
      media: coda: remove definition of CODA_STD_MJPG

Matthias Schwarzott (16):
      media: em28xx: Fix use-after-free when disconnecting
      media: si2165: Remove redundant KBUILD_MODNAME from dev_* logging
      media: si2165: Convert debug printk to dev_dbg
      media: si2165: Make checkpatch happy
      media: si2165: define register macros
      media: si2165: move ts parallel mode setting to the ts init code
      media: si2165: Write const value for lock timeout
      media: si2165: Use constellation from property cache instead of hardcoded QAM256
      media: si2165: improve read_status
      media: si2165: add DVBv5 C/N statistics for DVB-C
      media: si2165: add DVBv5 BER statistics
      media: si2165: add DVBv3 wrapper for C/N statistics
      media: si2165: Add DVBv3 wrapper for ber statistics
      media: cx231xx: Use semicolon after assignment instead of comma
      media: cx23885: Use semicolon after assignment instead of comma
      media: MAINTAINERS: add si2165 driver

Mauro Carvalho Chehab (105):
      media: rc: add SPDX identifiers to the code I wrote
      media: tuners: add SPDX identifiers to the code I wrote
      media: usb: add SPDX identifiers to some code I wrote
      media: rc keymaps: add SPDX identifiers to the code I wrote
      media: i2c: add SPDX identifiers to the code I wrote
      media: siano: add SPDX markups
      media:  mxl5xx: fix tuning logic
      media: ddbridge: shut up a new warning
      media: atmel-isc: avoid returning a random value at isc_parse_dt()
      media: tda8290: initialize agc gain
      media: qt1010: fix bogus warnings
      media: radio-si476x: fix behavior when seek->range* are defined
      media: xc4000: don't ignore error if hwmodel fails
      media: stv090x: Only print tuner lock if get_status is available
      media: imx274: don't randomly return if range_count is zero
      media: drxj: better handle errors
      media: mb86a16: be more resilient if I2C fails on sync
      media: mb86a16: avoid division by zero
      media: ov9650: fix bogus warnings
      media: pt1: fix logic when pt1_nr_tables is zero or negative
      media: m88rs2000: handle the case where tuner doesn't have get_frequency
      media: dvbsky: shut up a bogus warning
      media: cx25821-alsa: fix usage of a pointer printk
      media: cxd2841er: ensure that status will always be available
      media: drxd_hard: better handle I2C errors
      media: mxl111sf: improve error handling logic
      media: xc5000: better handle I2C error messages
      media: dvb_frontend: be sure to init dvb_frontend_handle_ioctl() return code
      media: led-class-flash: better handle NULL flash struct
      media: dvb_frontend: fix return error code
      media: RC docs: add enum rc_proto description at the docs
      media: dmxdev: describe nested structs
      media: dvb_demux: describe nested structs
      media: frontend: describe nested structs
      media: tuner-types: add kernel-doc markups for struct tunertype
      media: v4l2-common: get rid of v4l2_routing dead struct
      media: v4l2-common: get rid of struct v4l2_discrete_probe
      media: v4l2-common.h: document helper functions
      media: v4l2-dv-timings.h: convert comment into kernel-doc markup
      media: rc-core.rst: add an introduction for RC core
      media: rc-core.h: minor adjustments at rc_driver_type doc
      media: v4l2-fwnode.h: better describe bus union at fwnode endpoint struct
      media: v4l2-ctrls: document nested members of structs
      media: videobuf2-core: improve kernel-doc markups
      media: media-entity.h: add kernel-doc markups for nested structs
      media: v4l2-event.rst: improve events description
      media: v4l2-dev.h: add kernel-doc to two macros
      media: v4l2-flash-led-class.h: add kernel-doc to two helper funcs
      media: v4l2-mediabus: use BIT() macro for flags
      media: v4l2-dev: convert VFL_TYPE_* into an enum
      media: i2c-addr.h: get rid of now unused defines
      media: get rid of i2c-addr.h
      media: v4l2-dev: document VFL_DIR_* direction defines
      media: v4l2-dev: document video_device flags
      media: v4l2-subdev: create cross-references for ioctls
      media: v4l2-subdev: fix description of tuner.s_radio ops
      media: vb2-core: use bitops for bits
      media: vb2-core: Improve kernel-doc markups
      media: vb2-core: document remaining functions
      media: vb2: add cross references at memops and v4l2 kernel-doc markups
      media: v4l2-tpg*.h: move headers to include/media/tpg and merge them
      media: v4l2-tpg.h: rename color structs
      media: v4l2-tpg: use __u16 instead of int for struct tpg_rbg_color16
      media: v4l2-subdev: fix a typo
      media: v4l2-subdev: better document IO pin configuration flags
      media: v4l2-subdev: convert frame description to enum
      media: vb2-core: fix descriptions for VB2-only functions
      media: fix SPDX comment on some header files
      media: dvb_net: ensure that dvb_net_ule_handle is fully initialized
      media: dvb-core: allow users to enable DVB net ULE debug
      media: dvb_net: let dynamic debug enable some DVB net handling
      media: davinci: fix a debug printk
      Merge branch 'docs-next' of git://git.lwn.net/linux into patchwork
      media: dvb_vb2: fix a warning about streamoff logic
      media: dvb_vb2: limit reqbufs size to a sane value
      media: dvb_vb2: Use the sanitized value after processed by VB2 core
      media: dvb_vb2: add SPDX headers
      fs: compat_ioctl: add new DVB demux ioctls
      media: dvb-core: make DVB mmap API optional
      media: move videobuf2 to drivers/media/common
      media: dvb uAPI docs: document demux mmap/munmap syscalls
      media: dvb uAPI docs: document mmap-related ioctls
      media: dvb-core: get rid of mmap reserved field
      media: move dvb kAPI headers to include/media
      media: don't include drivers/media/i2c at cflags
      media: v4l2-device.h: document helper macros
      media: v4l2-async: simplify v4l2_async_subdev structure
      media: v4l2-async: better describe match union at async match struct
      media: dvb_vb2: use strlcpy instead of strncpy
      media: dvb_vb2: get rid of DVB_BUF_TYPE_OUTPUT
      media: dvb kAPI docs: document dvb_vb2.h
      media: dmx.h documentation: fix a warning
      media: imx: fix breakages when compiling for arm
      Merge tag 'v4.15-rc6' into patchwork
      media: videobuf2-core: don't go out of the buffer range
      media: vb2: add pr_fmt() macro
      media: vb2: add a new warning about pending buffers
      media: fix usage of whitespaces and on indentation
      media: replace all <spaces><tab> occurrences
      media: staging: use tabs instead of spaces at Kconfig and davinci
      media: dw9714: annotate a __be16 integer value
      media: ts2020: avoid integer overflows on 32 bit machines
      media: cxusb, dib0700: ignore XC2028_I2C_FLUSH
      media: dvb_demux: Better handle discontinuity errors
      media: dvb_demux: improve debug messages

Neil Armstrong (1):
      media: uvcvideo: Add a quirk for Generalplus Technology Inc. 808 Camera

Nick Desaulniers (1):
      media: dvb-frontends: remove extraneous parens

Nicolas Dufresne (1):
      media: uvcvideo: Add D3DFMT_L8 support

Olli Salonen (2):
      media: tda18250: support for new silicon tuner
      media: dib0700: add support for Xbox One Digital TV Tuner

Pavel Machek (2):
      media: dt-bindings: et8ek8: Document support for flash and lens devices
      media: ARM: dts: nokia n900: enable autofocus

Philipp Zabel (5):
      media: coda: fix capture TRY_FMT for YUYV with non-MB-aligned widths
      media: coda: round up frame sizes to multiples of 16 for MPEG-4 decoder
      media: coda: allocate space for mpeg4 decoder mvcol buffer
      media: coda: use correct offset for mpeg4 decoder mvcol buffer
      media: vb2: clear V4L2_BUF_FLAG_LAST when filling vb2_buffer

Pravin Shedge (1):
      media: drivers: media: remove duplicate includes

Riccardo Schirone (4):
      media: staging: add missing blank line after declarations in atomisp-ov5693
      media: staging: improve comments usage in atomisp-ov5693
      media: staging: improves comparisons readability in atomisp-ov5693
      media: staging: fix indentation in atomisp-ov5693

Romain Reignier (1):
      media: cx231xx: Add support for The Imaging Source DFG/USB2pro

Ron Economos (1):
      media: [RESEND] media: dvb-frontends: Add delay to Si2168 restart

Russell King (2):
      media: staging/imx: fix complete handler
      media: imx-csi: fix burst size

Sakari Ailus (7):
      media: i2c: as3645a: Remove driver
      media: v4l: Fix references in Intel IPU3 Bayer documentation
      media: vb2: Enforce VB2_MAX_FRAME in vb2_core_reqbufs better
      media: intel-ipu3: Rename arr_size macro, use min
      media: dw9714: Call pm_runtime_idle() at the end of probe()
      media: dw9714: Remove client field in driver's struct
      media: entity: Add a nop variant of media_entity_cleanup

Satendra Singh Thakur (2):
      media: videobuf2: Add new uAPI for DVB streaming I/O
      media: vb2: Fix a bug about unnecessary calls to queue cancel and free

Sean Young (46):
      media: rc: i2c: set parent of rc device and improve name
      media: rc: i2c: use dev_dbg rather hand-rolled debug
      media: rc: i2c: only poll if the rc device is opened
      media: merge ir_tx_z8f0811_haup and ir_rx_z8f0811_haup i2c devices
      media: rc: implement zilog transmitter
      media: i2c: enable i2c IR for hardware which isn't HD-PVR
      media: staging: remove lirc_zilog driver
      media: MAINTAINERS: remove lirc staging area
      media: lirc: remove LIRCCODE and LIRC_GET_LENGTH
      media: lirc: implement scancode sending
      media: lirc: use the correct carrier for scancode transmit
      media: rc: auto load encoder if necessary
      media: lirc: lirc interface should not be a raw decoder
      media: lirc: validate scancode for transmit
      media: rc: document and fix rc_validate_scancode()
      media: lirc: merge lirc_dev_fop_ioctl and ir_lirc_ioctl
      media: lirc: use kfifo rather than lirc_buffer for raw IR
      media: lirc: move lirc_dev->attached to rc_dev->registered
      media: lirc: do not call close() or open() on unregistered devices
      media: lirc: create rc-core open and close lirc functions
      media: lirc: remove name from lirc_dev
      media: lirc: remove last remnants of lirc kapi
      media: lirc: implement reading scancode
      media: lirc: ensure lirc device receives nec repeats
      media: lirc: document LIRC_MODE_SCANCODE
      media: lirc: scancode rc devices should have a lirc device too
      kfifo: DECLARE_KIFO_PTR(fifo, u64) does not work on arm 32 bit
      media: rc: move ir-lirc-codec.c contents into lirc_dev.c
      media: rc: include <uapi/linux/lirc.h> rather than <media/lirc.h>
      media: lirc: allow lirc device to be opened more than once
      media: lirc: improve locking
      media: imon: auto-config ffdc 30 device
      media: cec: move cec autorepeat handling to rc-core
      media: imon: auto-config ffdc 26 device
      media: imon: remove unused function tv2int
      media: rc: bang in ir_do_keyup
      media: lirc: when transmitting scancodes, block until transmit is done
      media: rc: iguanair: simplify tx loop
      media: lirc: do not pass ERR_PTR to kfree
      media: lirc: no need to recalculate duration
      media: lirc: release lock before sleep
      media: lirc: add module alias for lirc_dev
      media: lirc: lirc daemon fails to detect raw IR device
      media: lirc: lirc mode ioctls deal with current mode
      media: rc: clean up leader pulse/space for manchester encoding
      media: rc: do not remove first bit if leader pulse is present

Sergiy Redko (1):
      media: Staging: media: atomisp: made function static

Shuah Khan (2):
      media: s5p-mfc: Remove firmware buf null check in s5p_mfc_load_firmware()
      media: s5p-mfc: Fix lock contention - request_firmware() once

Simon Shields (1):
      media: exynos4-is: Check pipe is valid before calling subdev

Sinan Kaya (1):
      media: atomisp: deprecate pci_get_bus_and_slot()

Srishti Sharma (2):
      media: Staging: media: omap4iss: Use WARN_ON() instead of BUG_ON()
      media: Staging: media: imx: Prefer using BIT macro

Stanimir Varbanov (3):
      media: venus: venc: set correctly GOP size and number of B-frames
      media: venus: cleanup set_property controls
      media: vb2: unify calling of set_page_dirty_lock

Stefan Brüns (1):
      media: dvbsky: MyGica T230C support

Steve Longerbeam (9):
      media: staging/imx: get CSI bus type from nearest upstream entity
      media: staging/imx: remove static media link arrays
      media: staging/imx: of: allow for recursing downstream
      media: staging/imx: remove devname string from imx_media_subdev
      media: staging/imx: pass fwnode handle to find/add async subdev
      media: staging/imx: remove static subdev arrays
      media: staging/imx: convert static vdev lists to list_head
      media: staging/imx: reorder function prototypes
      media: staging/imx: update TODO

Sylwester Nawrocki (1):
      media: s5p-mfc: Fix encoder menu controls initialization

Vasyl Gomonovych (2):
      media: exynos4-is: Use PTR_ERR_OR_ZERO()
      media: c8sectpfe: Use resource_size function on memory resource

Wenyou Yang (2):
      media: ov7740: Document device tree bindings
      media: i2c: Add the ov7740 image sensor driver

Wolfgang Rohdewald (1):
      media: dvb_usb_pctv452e: module refcount changes were unbalanced

Yong Zhi (6):
      media: videodev2.h, v4l2-ioctl: add IPU3 raw10 color format
      media: doc-rst: add IPU3 raw10 bayer pixel format definitions
      media: intel-ipu3: cio2: add new MIPI-CSI2 driver
      media: intel-ipu3: cio2: fix a crash with out-of-bounds access
      media: intel-ipu3: cio2: fix for wrong vb2buf state warnings
      media: intel-ipu3: cio2: fixup off-by-one bug in cio2_vb2_buf_init

 Documentation/00-INDEX                             |    4 -
 Documentation/admin-guide/kernel-parameters.txt    |    3 +
 Documentation/admin-guide/mono.rst                 |    6 +-
 Documentation/conf.py                              |    1 -
 Documentation/core-api/index.rst                   |    2 +
 Documentation/core-api/kernel-api.rst              |   15 +
 .../printk-formats.rst}                            |  227 +--
 Documentation/core-api/refcount-vs-atomic.rst      |  150 ++
 .../devicetree/bindings/media/cec-gpio.txt         |    6 +-
 .../devicetree/bindings/media/i2c/mt9m111.txt      |    4 +
 .../devicetree/bindings/media/i2c/ov5640.txt       |   46 +-
 .../devicetree/bindings/media/i2c/ov7740.txt       |   47 +
 .../bindings/media/i2c/toshiba,et8ek8.txt          |    7 +
 .../devicetree/bindings/media/nvidia,tegra-vde.txt |   55 +
 .../bindings/media/xilinx/xlnx,v-tpg.txt           |    2 +-
 Documentation/doc-guide/kernel-doc.rst             |  360 +++-
 Documentation/driver-api/basics.rst                |   21 +-
 Documentation/driver-api/usb/usb3-debug-port.rst   |   52 +
 .../driver-api/usb/writing_usb_driver.rst          |    2 +-
 Documentation/filesystems/vfat.txt                 |    2 +-
 Documentation/i2c/dev-interface                    |   17 +-
 Documentation/index.rst                            |    1 +
 Documentation/kbuild/kconfig-language.txt          |   21 +
 Documentation/kernel-doc-nano-HOWTO.txt            |  322 ---
 Documentation/kernel-hacking/hacking.rst           |    2 +-
 Documentation/maintainer/conf.py                   |   10 +
 Documentation/maintainer/configure-git.rst         |   34 +
 Documentation/maintainer/index.rst                 |   14 +
 Documentation/maintainer/pull-requests.rst         |  178 ++
 Documentation/media/dmx.h.rst.exceptions           |    2 +
 Documentation/media/kapi/cec-core.rst              |   14 +
 Documentation/media/kapi/dtv-ca.rst                |    2 +-
 Documentation/media/kapi/dtv-common.rst            |   11 +-
 Documentation/media/kapi/dtv-demux.rst             |    8 +-
 Documentation/media/kapi/dtv-frontend.rst          |    8 +-
 Documentation/media/kapi/dtv-net.rst               |    2 +-
 Documentation/media/kapi/rc-core.rst               |   82 +-
 Documentation/media/kapi/v4l2-dev.rst              |   17 +-
 Documentation/media/kapi/v4l2-event.rst            |   67 +-
 Documentation/media/lirc.h.rst.exceptions          |   31 +
 Documentation/media/uapi/dvb/dmx-expbuf.rst        |   88 +
 Documentation/media/uapi/dvb/dmx-mmap.rst          |  116 ++
 Documentation/media/uapi/dvb/dmx-munmap.rst        |   54 +
 Documentation/media/uapi/dvb/dmx-qbuf.rst          |   83 +
 Documentation/media/uapi/dvb/dmx-querybuf.rst      |   63 +
 Documentation/media/uapi/dvb/dmx-reqbufs.rst       |   74 +
 Documentation/media/uapi/dvb/dmx_fcalls.rst        |    6 +
 .../media/uapi/dvb/fe_property_parameters.rst      |   18 +
 .../dvb/frontend-property-satellite-systems.rst    |    2 +
 Documentation/media/uapi/rc/lirc-dev-intro.rst     |   75 +-
 Documentation/media/uapi/rc/lirc-func.rst          |    1 -
 Documentation/media/uapi/rc/lirc-get-features.rst  |   25 +-
 Documentation/media/uapi/rc/lirc-get-length.rst    |   44 -
 Documentation/media/uapi/rc/lirc-get-rec-mode.rst  |   45 +-
 Documentation/media/uapi/rc/lirc-get-send-mode.rst |   40 +-
 Documentation/media/uapi/rc/lirc-read.rst          |   15 +-
 Documentation/media/uapi/rc/lirc-write.rst         |   19 +-
 Documentation/media/uapi/v4l/meta-formats.rst      |    1 +
 Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst   |   51 +
 Documentation/media/uapi/v4l/pixfmt-rgb.rst        |    1 +
 .../media/uapi/v4l/pixfmt-srggb10-ipu3.rst         |  335 ++++
 .../media/uapi/v4l/vidioc-g-dv-timings.rst         |    2 +-
 .../process/kernel-enforcement-statement.rst       |    3 +
 Documentation/process/submit-checklist.rst         |    4 +-
 Documentation/security/self-protection.rst         |   15 +
 Documentation/sysctl/kernel.txt                    |   17 +-
 Documentation/trace/ftrace-uses.rst                |   60 +-
 Documentation/usb/chipidea.txt                     |   12 +-
 Documentation/w1/w1.generic                        |    2 +-
 MAINTAINERS                                        |   56 +-
 arch/arm/boot/dts/omap3-n900.dts                   |    2 +
 drivers/media/Kconfig                              |   20 +-
 drivers/media/cec/cec-adap.c                       |   81 +-
 drivers/media/cec/cec-api.c                        |   32 +-
 drivers/media/cec/cec-core.c                       |   27 +-
 drivers/media/cec/cec-priv.h                       |    2 +
 drivers/media/common/Kconfig                       |    1 +
 drivers/media/common/Makefile                      |    2 +-
 drivers/media/common/b2c2/Makefile                 |    1 -
 drivers/media/common/b2c2/flexcop-common.h         |    8 +-
 drivers/media/common/saa7146/saa7146_video.c       |   17 +-
 drivers/media/common/siano/Makefile                |    4 -
 drivers/media/common/siano/smsdvb-debugfs.c        |   29 +-
 drivers/media/common/siano/smsdvb-main.c           |   10 +-
 drivers/media/common/siano/smsir.c                 |   35 +-
 drivers/media/common/siano/smsir.h                 |   37 +-
 drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c    |    8 +-
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c      |    2 +-
 drivers/media/common/videobuf2/Kconfig             |   31 +
 drivers/media/common/videobuf2/Makefile            |    7 +
 .../videobuf2}/videobuf2-core.c                    |   53 +-
 .../videobuf2}/videobuf2-dma-contig.c              |    6 +-
 .../videobuf2}/videobuf2-dma-sg.c                  |    7 +-
 .../videobuf2}/videobuf2-dvb.c                     |    0
 .../videobuf2}/videobuf2-memops.c                  |    0
 .../videobuf2}/videobuf2-v4l2.c                    |    2 +
 .../videobuf2}/videobuf2-vmalloc.c                 |    0
 drivers/media/dvb-core/Kconfig                     |   13 +
 drivers/media/dvb-core/Makefile                    |    7 +-
 drivers/media/dvb-core/dmxdev.c                    |  232 ++-
 drivers/media/dvb-core/dvb_ca_en50221.c            |    9 +-
 drivers/media/dvb-core/dvb_demux.c                 |   47 +-
 drivers/media/dvb-core/dvb_frontend.c              |  183 +-
 drivers/media/dvb-core/dvb_math.c                  |    2 +-
 drivers/media/dvb-core/dvb_net.c                   |   74 +-
 drivers/media/dvb-core/dvb_ringbuffer.c            |    2 +-
 drivers/media/dvb-core/dvb_vb2.c                   |  430 ++++
 drivers/media/dvb-core/dvbdev.c                    |    2 +-
 drivers/media/dvb-frontends/Makefile               |    1 -
 drivers/media/dvb-frontends/a8293.h                |    2 +-
 drivers/media/dvb-frontends/af9013_priv.h          |    2 +-
 drivers/media/dvb-frontends/af9033_priv.h          |    4 +-
 drivers/media/dvb-frontends/as102_fe.c             |    2 +-
 drivers/media/dvb-frontends/ascot2e.c              |    6 +-
 drivers/media/dvb-frontends/atbm8830.c             |    2 +-
 drivers/media/dvb-frontends/au8522_common.c        |    2 +-
 drivers/media/dvb-frontends/au8522_dig.c           |    2 +-
 drivers/media/dvb-frontends/au8522_priv.h          |  220 +--
 drivers/media/dvb-frontends/bcm3510.c              |    2 +-
 drivers/media/dvb-frontends/cx22700.c              |    2 +-
 drivers/media/dvb-frontends/cx22702.c              |    2 +-
 drivers/media/dvb-frontends/cx24110.c              |    2 +-
 drivers/media/dvb-frontends/cx24113.c              |    2 +-
 drivers/media/dvb-frontends/cx24116.c              |    4 +-
 drivers/media/dvb-frontends/cx24117.c              |    2 +-
 drivers/media/dvb-frontends/cx24120.c              |    2 +-
 drivers/media/dvb-frontends/cx24123.c              |    2 +-
 drivers/media/dvb-frontends/cxd2820r_priv.h        |    4 +-
 drivers/media/dvb-frontends/cxd2841er.c            |   23 +-
 drivers/media/dvb-frontends/dib0070.c              |    2 +-
 drivers/media/dvb-frontends/dib0090.c              |    2 +-
 drivers/media/dvb-frontends/dib3000mb.c            |    2 +-
 drivers/media/dvb-frontends/dib3000mc.c            |    2 +-
 drivers/media/dvb-frontends/dib7000m.c             |    2 +-
 drivers/media/dvb-frontends/dib7000p.c             |    4 +-
 drivers/media/dvb-frontends/dib8000.c              |    4 +-
 drivers/media/dvb-frontends/dib9000.c              |    4 +-
 drivers/media/dvb-frontends/dibx000_common.c       |    8 +-
 drivers/media/dvb-frontends/drx39xyj/Makefile      |    1 -
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.h    |    2 +-
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h  |    2 +-
 drivers/media/dvb-frontends/drx39xyj/drxj.c        |   16 +-
 drivers/media/dvb-frontends/drxd_hard.c            |   27 +-
 drivers/media/dvb-frontends/drxk.h                 |    6 +-
 drivers/media/dvb-frontends/drxk_hard.c            |    6 +-
 drivers/media/dvb-frontends/ds3000.c               |    2 +-
 drivers/media/dvb-frontends/dvb-pll.h              |    2 +-
 drivers/media/dvb-frontends/dvb_dummy_fe.c         |    2 +-
 drivers/media/dvb-frontends/dvb_dummy_fe.h         |    2 +-
 drivers/media/dvb-frontends/ec100.c                |    2 +-
 drivers/media/dvb-frontends/gp8psk-fe.c            |    2 +-
 drivers/media/dvb-frontends/helene.c               |    6 +-
 drivers/media/dvb-frontends/horus3a.c              |    6 +-
 drivers/media/dvb-frontends/isl6405.c              |    2 +-
 drivers/media/dvb-frontends/isl6421.c              |    2 +-
 drivers/media/dvb-frontends/isl6423.c              |    2 +-
 drivers/media/dvb-frontends/itd1000.c              |    7 +-
 drivers/media/dvb-frontends/ix2505v.h              |    2 +-
 drivers/media/dvb-frontends/l64781.c               |    2 +-
 drivers/media/dvb-frontends/lg2160.h               |    2 +-
 drivers/media/dvb-frontends/lgdt3305.c             |    2 +-
 drivers/media/dvb-frontends/lgdt3305.h             |    2 +-
 drivers/media/dvb-frontends/lgdt3306a.c            |    2 +-
 drivers/media/dvb-frontends/lgdt3306a.h            |    2 +-
 drivers/media/dvb-frontends/lgdt330x.c             |    4 +-
 drivers/media/dvb-frontends/lgs8gl5.c              |    2 +-
 drivers/media/dvb-frontends/lgs8gxx.c              |    2 +-
 drivers/media/dvb-frontends/lnbh25.c               |    2 +-
 drivers/media/dvb-frontends/lnbp21.c               |    2 +-
 drivers/media/dvb-frontends/lnbp22.c               |    2 +-
 drivers/media/dvb-frontends/m88ds3103_priv.h       |    4 +-
 drivers/media/dvb-frontends/m88rs2000.c            |   13 +-
 drivers/media/dvb-frontends/m88rs2000.h            |    2 +-
 drivers/media/dvb-frontends/mb86a16.c              |   15 +-
 drivers/media/dvb-frontends/mb86a16.h              |    2 +-
 drivers/media/dvb-frontends/mb86a20s.c             |    4 +-
 drivers/media/dvb-frontends/mn88472_priv.h         |    4 +-
 drivers/media/dvb-frontends/mn88473.c              |    2 +-
 drivers/media/dvb-frontends/mn88473_priv.h         |    4 +-
 drivers/media/dvb-frontends/mt312.c                |    7 +-
 drivers/media/dvb-frontends/mt352.c                |    2 +-
 drivers/media/dvb-frontends/mxl5xx.c               |   11 +-
 drivers/media/dvb-frontends/mxl5xx.h               |    2 +-
 drivers/media/dvb-frontends/nxt200x.c              |    2 +-
 drivers/media/dvb-frontends/nxt6000.c              |    2 +-
 drivers/media/dvb-frontends/or51132.c              |    4 +-
 drivers/media/dvb-frontends/or51211.c              |    4 +-
 drivers/media/dvb-frontends/rtl2830_priv.h         |    4 +-
 drivers/media/dvb-frontends/rtl2832_priv.h         |    4 +-
 drivers/media/dvb-frontends/rtl2832_sdr.h          |    2 +-
 drivers/media/dvb-frontends/s5h1409.c              |    2 +-
 drivers/media/dvb-frontends/s5h1411.c              |    2 +-
 drivers/media/dvb-frontends/s5h1420.c              |    2 +-
 drivers/media/dvb-frontends/s5h1432.c              |    2 +-
 drivers/media/dvb-frontends/s921.c                 |    2 +-
 drivers/media/dvb-frontends/si2165.c               |  613 +++---
 drivers/media/dvb-frontends/si2165.h               |   37 +-
 drivers/media/dvb-frontends/si2165_priv.h          |  114 +-
 drivers/media/dvb-frontends/si2168.c               |    3 +
 drivers/media/dvb-frontends/si2168_priv.h          |    2 +-
 drivers/media/dvb-frontends/si21xx.c               |    2 +-
 drivers/media/dvb-frontends/si21xx.h               |    2 +-
 drivers/media/dvb-frontends/sp2.h                  |    2 +-
 drivers/media/dvb-frontends/sp2_priv.h             |    2 +-
 drivers/media/dvb-frontends/sp8870.c               |    2 +-
 drivers/media/dvb-frontends/sp887x.c               |    2 +-
 drivers/media/dvb-frontends/stb0899_algo.c         |    3 +-
 drivers/media/dvb-frontends/stb0899_drv.c          |   15 +-
 drivers/media/dvb-frontends/stb0899_drv.h          |    4 +-
 drivers/media/dvb-frontends/stb0899_priv.h         |    4 +-
 drivers/media/dvb-frontends/stb6000.h              |    2 +-
 drivers/media/dvb-frontends/stb6100.c              |    8 +-
 drivers/media/dvb-frontends/stb6100.h              |    2 +-
 drivers/media/dvb-frontends/stb6100_cfg.h          |    2 +-
 drivers/media/dvb-frontends/stb6100_proc.h         |    2 +-
 drivers/media/dvb-frontends/stv0288.c              |    2 +-
 drivers/media/dvb-frontends/stv0288.h              |    2 +-
 drivers/media/dvb-frontends/stv0297.c              |    2 +-
 drivers/media/dvb-frontends/stv0297.h              |    2 +-
 drivers/media/dvb-frontends/stv0299.c              |    2 +-
 drivers/media/dvb-frontends/stv0299.h              |    2 +-
 drivers/media/dvb-frontends/stv0367.c              |    8 +-
 drivers/media/dvb-frontends/stv0367.h              |    2 +-
 drivers/media/dvb-frontends/stv0900.h              |    2 +-
 drivers/media/dvb-frontends/stv0900_core.c         |    2 +-
 drivers/media/dvb-frontends/stv0900_init.h         |   34 +-
 drivers/media/dvb-frontends/stv0900_priv.h         |    2 +-
 drivers/media/dvb-frontends/stv090x.c              |   43 +-
 drivers/media/dvb-frontends/stv090x_priv.h         |    4 +-
 drivers/media/dvb-frontends/stv0910.c              |  227 ++-
 drivers/media/dvb-frontends/stv0910_regs.h         | 1854 +++++++++---------
 drivers/media/dvb-frontends/stv6110.h              |    2 +-
 drivers/media/dvb-frontends/stv6110x.c             |    8 +-
 drivers/media/dvb-frontends/stv6110x_priv.h        |    6 +-
 drivers/media/dvb-frontends/stv6111.c              |   46 +-
 drivers/media/dvb-frontends/tc90522.c              |    2 +-
 drivers/media/dvb-frontends/tc90522.h              |    2 +-
 drivers/media/dvb-frontends/tda10021.c             |    2 +-
 drivers/media/dvb-frontends/tda10023.c             |    4 +-
 drivers/media/dvb-frontends/tda10048.c             |    4 +-
 drivers/media/dvb-frontends/tda1004x.c             |    2 +-
 drivers/media/dvb-frontends/tda10071_priv.h        |    2 +-
 drivers/media/dvb-frontends/tda10086.c             |    2 +-
 drivers/media/dvb-frontends/tda18271c2dd.c         |    3 +-
 drivers/media/dvb-frontends/tda18271c2dd.h         |    4 +-
 drivers/media/dvb-frontends/tda665x.c              |    2 +-
 drivers/media/dvb-frontends/tda8083.c              |    2 +-
 drivers/media/dvb-frontends/tda8261.c              |    2 +-
 drivers/media/dvb-frontends/tda826x.h              |    2 +-
 drivers/media/dvb-frontends/ts2020.c               |    6 +-
 drivers/media/dvb-frontends/tua6100.h              |    2 +-
 drivers/media/dvb-frontends/ves1820.c              |    2 +-
 drivers/media/dvb-frontends/ves1x93.c              |    2 +-
 drivers/media/dvb-frontends/zd1301_demod.h         |    2 +-
 drivers/media/dvb-frontends/zl10036.h              |    2 +-
 drivers/media/dvb-frontends/zl10039.c              |    6 +-
 drivers/media/dvb-frontends/zl10353.c              |    2 +-
 drivers/media/firewire/Makefile                    |    2 -
 drivers/media/firewire/firedtv-avc.c               |    6 +-
 drivers/media/firewire/firedtv-ci.c                |    2 +-
 drivers/media/firewire/firedtv-dvb.c               |    8 +-
 drivers/media/firewire/firedtv-fe.c                |    8 +-
 drivers/media/firewire/firedtv-fw.c                |    2 +-
 drivers/media/firewire/firedtv.h                   |   12 +-
 drivers/media/i2c/Kconfig                          |   26 +-
 drivers/media/i2c/Makefile                         |    2 +-
 drivers/media/i2c/adv7180.c                        |   12 +-
 drivers/media/i2c/adv7343.c                        |    2 +-
 drivers/media/i2c/adv7393.c                        |    2 +-
 drivers/media/i2c/adv748x/adv748x-afe.c            |    1 +
 drivers/media/i2c/adv748x/adv748x-core.c           |   16 +-
 drivers/media/i2c/adv748x/adv748x-csi2.c           |   13 +-
 drivers/media/i2c/adv748x/adv748x.h                |    1 +
 drivers/media/i2c/adv7604.c                        |    1 +
 drivers/media/i2c/as3645a.c                        |  880 ---------
 drivers/media/i2c/cx25840/Makefile                 |    2 -
 drivers/media/i2c/cx25840/cx25840-core.c           |   35 +-
 drivers/media/i2c/cx25840/cx25840-core.h           |    2 +-
 drivers/media/i2c/cx25840/cx25840-ir.c             |    6 +-
 drivers/media/i2c/dw9714.c                         |   22 +-
 drivers/media/i2c/imx274.c                         |    4 +-
 drivers/media/i2c/ir-kbd-i2c.c                     |  540 +++++-
 drivers/media/i2c/ks0127.c                         |    2 +-
 drivers/media/i2c/mt9m111.c                        |   49 +-
 drivers/media/i2c/mt9v011.c                        |   13 +-
 drivers/media/i2c/mt9v032.c                        |   21 +-
 drivers/media/i2c/ov2640.c                         |    4 -
 drivers/media/i2c/ov2659.c                         |    4 -
 drivers/media/i2c/ov5640.c                         |  326 +++-
 drivers/media/i2c/ov7670.c                         |   90 +-
 drivers/media/i2c/ov7740.c                         | 1214 ++++++++++++
 drivers/media/i2c/ov9650.c                         |   10 +-
 drivers/media/i2c/saa6752hs.c                      |    8 +-
 drivers/media/i2c/saa7115.c                        |   60 +-
 drivers/media/i2c/saa711x_regs.h                   |   14 +-
 drivers/media/i2c/saa7127.c                        |  162 +-
 drivers/media/i2c/saa717x.c                        |   12 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |    2 +-
 drivers/media/i2c/tda7432.c                        |    1 -
 drivers/media/i2c/ths7303.c                        |    2 +-
 drivers/media/i2c/tvaudio.c                        |    4 +-
 drivers/media/i2c/tvp514x.c                        |    4 -
 drivers/media/i2c/tvp5150.c                        |   13 +-
 drivers/media/i2c/tvp5150_reg.h                    |    9 +-
 drivers/media/i2c/tvp7002_reg.h                    |    6 +-
 drivers/media/i2c/vpx3220.c                        |    2 +-
 drivers/media/mmc/siano/Makefile                   |    2 -
 drivers/media/pci/Kconfig                          |    2 +
 drivers/media/pci/Makefile                         |    3 +-
 drivers/media/pci/b2c2/Makefile                    |    1 -
 drivers/media/pci/bt8xx/Makefile                   |    2 -
 drivers/media/pci/bt8xx/bt878.c                    |    7 +-
 drivers/media/pci/bt8xx/bttv-cards.c               |  273 +--
 drivers/media/pci/bt8xx/bttv-input.c               |    8 +-
 drivers/media/pci/bt8xx/bttv.h                     |    5 +-
 drivers/media/pci/bt8xx/bttvp.h                    |    6 +-
 drivers/media/pci/bt8xx/dst.c                      |    2 +-
 drivers/media/pci/bt8xx/dst_ca.c                   |    4 +-
 drivers/media/pci/bt8xx/dvb-bt8xx.c                |    8 +-
 drivers/media/pci/bt8xx/dvb-bt8xx.h                |    4 +-
 drivers/media/pci/cobalt/Kconfig                   |    1 +
 drivers/media/pci/cx18/Makefile                    |    1 -
 drivers/media/pci/cx18/cx18-alsa-pcm.c             |    2 +-
 drivers/media/pci/cx18/cx18-av-audio.c             |    2 +-
 drivers/media/pci/cx18/cx18-av-core.c              |   18 +-
 drivers/media/pci/cx18/cx18-av-core.h              |    2 +-
 drivers/media/pci/cx18/cx18-cards.c                |    8 +-
 drivers/media/pci/cx18/cx18-cards.h                |   40 +-
 drivers/media/pci/cx18/cx18-driver.h               |   58 +-
 drivers/media/pci/cx18/cx18-fileops.c              |    2 +-
 drivers/media/pci/cx18/cx18-firmware.c             |   96 +-
 drivers/media/pci/cx18/cx18-i2c.c                  |   13 +-
 drivers/media/pci/cx18/cx18-mailbox.c              |    8 +-
 drivers/media/pci/cx18/cx18-streams.c              |    4 +-
 drivers/media/pci/cx18/cx18-vbi.c                  |    2 +-
 drivers/media/pci/cx18/cx23418.h                   |   88 +-
 drivers/media/pci/cx23885/Makefile                 |    2 -
 drivers/media/pci/cx23885/altera-ci.c              |    6 +-
 drivers/media/pci/cx23885/cimax2.c                 |    4 +-
 drivers/media/pci/cx23885/cimax2.h                 |    2 +-
 drivers/media/pci/cx23885/cx23885-cards.c          |    6 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |    6 +-
 drivers/media/pci/cx23885/cx23885-input.c          |   15 +-
 drivers/media/pci/cx23885/cx23885-video.c          |    2 +-
 drivers/media/pci/cx23885/cx23885.h                |    4 +-
 drivers/media/pci/cx23885/cx23888-ir.c             |    6 +-
 drivers/media/pci/cx25821/Makefile                 |    2 -
 drivers/media/pci/cx25821/cx25821-alsa.c           |    4 +-
 drivers/media/pci/cx88/Makefile                    |    3 -
 drivers/media/pci/cx88/cx88-blackbird.c            |    3 +-
 drivers/media/pci/cx88/cx88-video.c                |   10 +-
 drivers/media/pci/cx88/cx88.h                      |    4 +-
 drivers/media/pci/ddbridge/Makefile                |    5 +-
 drivers/media/pci/ddbridge/ddbridge-ci.c           |  359 ++++
 drivers/media/pci/ddbridge/ddbridge-ci.h           |   31 +
 drivers/media/pci/ddbridge/ddbridge-core.c         |  651 ++-----
 drivers/media/pci/ddbridge/ddbridge-hw.c           |    8 +-
 drivers/media/pci/ddbridge/ddbridge-i2c.c          |   16 +-
 drivers/media/pci/ddbridge/ddbridge-main.c         |   23 +-
 .../ddbridge/{ddbridge-maxs8.c => ddbridge-max.c}  |   54 +-
 .../ddbridge/{ddbridge-maxs8.h => ddbridge-max.h}  |   12 +-
 drivers/media/pci/ddbridge/ddbridge-regs.h         |   32 +-
 drivers/media/pci/ddbridge/ddbridge.h              |  105 +-
 drivers/media/pci/dm1105/Makefile                  |    2 +-
 drivers/media/pci/dm1105/dm1105.c                  |   12 +-
 drivers/media/pci/intel/Makefile                   |    5 +
 drivers/media/pci/intel/ipu3/Kconfig               |   19 +
 drivers/media/pci/intel/ipu3/Makefile              |    1 +
 drivers/media/pci/intel/ipu3/ipu3-cio2.c           | 2048 ++++++++++++++++++++
 drivers/media/pci/intel/ipu3/ipu3-cio2.h           |  449 +++++
 drivers/media/pci/ivtv/Makefile                    |    2 -
 drivers/media/pci/ivtv/ivtv-cards.c                |    2 +-
 drivers/media/pci/ivtv/ivtv-cards.h                |  148 +-
 drivers/media/pci/ivtv/ivtv-driver.h               |  102 +-
 drivers/media/pci/ivtv/ivtv-firmware.c             |   36 +-
 drivers/media/pci/ivtv/ivtv-i2c.c                  |   46 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c                |   74 +-
 drivers/media/pci/ivtv/ivtv-mailbox.c              |  182 +-
 drivers/media/pci/mantis/Makefile                  |    2 +-
 drivers/media/pci/mantis/hopper_cards.c            |   10 +-
 drivers/media/pci/mantis/hopper_vp3028.c           |   10 +-
 drivers/media/pci/mantis/mantis_ca.c               |   10 +-
 drivers/media/pci/mantis/mantis_cards.c            |   10 +-
 drivers/media/pci/mantis/mantis_dma.c              |   10 +-
 drivers/media/pci/mantis/mantis_dvb.c              |   10 +-
 drivers/media/pci/mantis/mantis_evm.c              |   10 +-
 drivers/media/pci/mantis/mantis_hif.c              |   10 +-
 drivers/media/pci/mantis/mantis_i2c.c              |   10 +-
 drivers/media/pci/mantis/mantis_input.c            |   10 +-
 drivers/media/pci/mantis/mantis_ioc.c              |   10 +-
 drivers/media/pci/mantis/mantis_link.h             |    2 +-
 drivers/media/pci/mantis/mantis_pci.c              |   10 +-
 drivers/media/pci/mantis/mantis_pcmcia.c           |   10 +-
 drivers/media/pci/mantis/mantis_reg.h              |    6 +-
 drivers/media/pci/mantis/mantis_uart.c             |   10 +-
 drivers/media/pci/mantis/mantis_vp1033.c           |   10 +-
 drivers/media/pci/mantis/mantis_vp1034.c           |   10 +-
 drivers/media/pci/mantis/mantis_vp1034.h           |    2 +-
 drivers/media/pci/mantis/mantis_vp1041.c           |  220 +--
 drivers/media/pci/mantis/mantis_vp2033.c           |   10 +-
 drivers/media/pci/mantis/mantis_vp2040.c           |   10 +-
 drivers/media/pci/mantis/mantis_vp3028.h           |    2 +-
 drivers/media/pci/mantis/mantis_vp3030.c           |   10 +-
 drivers/media/pci/meye/meye.c                      |    2 +-
 drivers/media/pci/netup_unidvb/Makefile            |    1 -
 drivers/media/pci/netup_unidvb/netup_unidvb.h      |    2 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |    2 +-
 drivers/media/pci/ngene/Makefile                   |    1 -
 drivers/media/pci/ngene/ngene.h                    |   14 +-
 drivers/media/pci/pluto2/Makefile                  |    2 +-
 drivers/media/pci/pluto2/pluto2.c                  |   14 +-
 drivers/media/pci/pt1/Makefile                     |    2 +-
 drivers/media/pci/pt1/pt1.c                        |   29 +-
 drivers/media/pci/pt1/va1j5jf8007s.c               |    4 +-
 drivers/media/pci/pt1/va1j5jf8007s.h               |    2 +-
 drivers/media/pci/pt1/va1j5jf8007t.c               |    6 +-
 drivers/media/pci/pt1/va1j5jf8007t.h               |    2 +-
 drivers/media/pci/pt3/Makefile                     |    1 -
 drivers/media/pci/pt3/pt3.c                        |    8 +-
 drivers/media/pci/pt3/pt3.h                        |    6 +-
 drivers/media/pci/pt3/pt3_i2c.c                    |    1 -
 drivers/media/pci/saa7134/Makefile                 |    2 -
 drivers/media/pci/saa7134/saa7134-cards.c          |   64 +-
 drivers/media/pci/saa7134/saa7134-dvb.c            |    6 +-
 drivers/media/pci/saa7134/saa7134-input.c          |    3 +-
 drivers/media/pci/saa7134/saa7134-video.c          |    6 +-
 drivers/media/pci/saa7134/saa7134.h                |    8 +-
 drivers/media/pci/saa7146/hexium_gemini.c          |   25 +-
 drivers/media/pci/saa7146/hexium_orion.c           |   21 +-
 drivers/media/pci/saa7146/mxb.c                    |   29 +-
 drivers/media/pci/saa7164/Makefile                 |    4 -
 drivers/media/pci/saa7164/saa7164.h                |   10 +-
 drivers/media/pci/smipcie/Makefile                 |    1 -
 drivers/media/pci/smipcie/smipcie.h                |   12 +-
 drivers/media/pci/solo6x10/solo6x10-core.c         |   17 +-
 drivers/media/pci/solo6x10/solo6x10-gpio.c         |    2 +
 drivers/media/pci/ttpci/Makefile                   |    2 +-
 drivers/media/pci/ttpci/av7110.c                   |    2 +-
 drivers/media/pci/ttpci/av7110.h                   |   16 +-
 drivers/media/pci/ttpci/budget-av.c                |    8 +-
 drivers/media/pci/ttpci/budget-ci.c                |  212 +-
 drivers/media/pci/ttpci/budget.h                   |   12 +-
 drivers/media/pci/ttpci/dvb_filter.h               |    2 +-
 drivers/media/pci/tw5864/tw5864-video.c            |    2 +-
 drivers/media/pci/zoran/videocodec.c               |    1 -
 drivers/media/pci/zoran/zoran_driver.c             |   38 +-
 drivers/media/pci/zoran/zr36057.h                  |    4 +-
 drivers/media/platform/Kconfig                     |   38 +-
 drivers/media/platform/Makefile                    |   16 +-
 drivers/media/platform/am437x/am437x-vpfe.c        |    6 +-
 drivers/media/platform/arv.c                       |   54 +-
 drivers/media/platform/atmel/atmel-isc.c           |    6 +-
 drivers/media/platform/atmel/atmel-isi.c           |    2 +-
 drivers/media/platform/blackfin/ppi.c              |    2 +-
 drivers/media/platform/coda/coda-bit.c             |   23 +-
 drivers/media/platform/coda/coda-common.c          |   13 +-
 drivers/media/platform/coda/coda_regs.h            |    3 +-
 drivers/media/platform/coda/imx-vdoa.c             |    8 +-
 drivers/media/platform/davinci/dm355_ccdc.c        |    4 +-
 drivers/media/platform/davinci/dm355_ccdc_regs.h   |    6 +-
 drivers/media/platform/davinci/dm644x_ccdc.c       |    6 +-
 drivers/media/platform/davinci/dm644x_ccdc_regs.h  |    4 +-
 drivers/media/platform/davinci/isif_regs.h         |    6 +-
 drivers/media/platform/davinci/vpfe_capture.c      |    8 +-
 drivers/media/platform/davinci/vpif.h              |    4 +-
 drivers/media/platform/davinci/vpif_capture.c      |   10 +-
 drivers/media/platform/davinci/vpss.c              |   10 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |    4 +-
 drivers/media/platform/exynos4-is/Kconfig          |    2 +-
 drivers/media/platform/exynos4-is/fimc-core.c      |    4 +-
 drivers/media/platform/exynos4-is/fimc-core.h      |    2 +-
 drivers/media/platform/exynos4-is/fimc-isp.c       |   14 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |    7 +-
 drivers/media/platform/exynos4-is/fimc-lite.h      |    4 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |   10 +-
 drivers/media/platform/exynos4-is/media-dev.c      |    4 +-
 drivers/media/platform/m2m-deinterlace.c           |   12 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_util.c    |    3 +
 drivers/media/platform/mtk-vcodec/vdec_vpu_if.h    |    2 +-
 drivers/media/platform/omap/omap_vout.c            |   12 +-
 drivers/media/platform/omap3isp/isp.c              |    2 +-
 drivers/media/platform/pxa_camera.c                |   35 +-
 drivers/media/platform/qcom/camss-8x16/camss.c     |    2 +-
 drivers/media/platform/qcom/venus/core.h           |    4 +-
 drivers/media/platform/qcom/venus/hfi_cmds.c       |   73 +-
 drivers/media/platform/qcom/venus/hfi_helper.h     |    4 +-
 drivers/media/platform/qcom/venus/venc.c           |   48 +-
 drivers/media/platform/qcom/venus/venc_ctrls.c     |   59 +-
 drivers/media/platform/rcar-vin/rcar-core.c        |    2 +-
 drivers/media/platform/rcar_drif.c                 |    4 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |    6 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |    3 +
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |   10 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |    2 +-
 drivers/media/platform/sh_vou.c                    |    2 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    7 +-
 drivers/media/platform/soc_camera/soc_camera.c     |    2 +-
 drivers/media/platform/soc_camera/soc_scale_crop.c |    4 +
 drivers/media/platform/sti/bdisp/bdisp-debug.c     |    2 +-
 drivers/media/platform/sti/bdisp/bdisp-filter.h    |    2 +-
 drivers/media/platform/sti/bdisp/bdisp-hw.c        |    4 +-
 drivers/media/platform/sti/bdisp/bdisp-reg.h       |    2 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |    2 +-
 drivers/media/platform/sti/bdisp/bdisp.h           |    2 +-
 drivers/media/platform/sti/c8sectpfe/Kconfig       |    2 +-
 drivers/media/platform/sti/c8sectpfe/Makefile      |    5 +-
 .../platform/sti/c8sectpfe/c8sectpfe-common.c      |   15 +-
 .../platform/sti/c8sectpfe/c8sectpfe-common.h      |   13 +-
 .../media/platform/sti/c8sectpfe/c8sectpfe-core.c  |   19 +-
 .../media/platform/sti/c8sectpfe/c8sectpfe-core.h  |    5 +-
 .../platform/sti/c8sectpfe/c8sectpfe-debugfs.c     |    9 +-
 .../platform/sti/c8sectpfe/c8sectpfe-debugfs.h     |    9 +-
 .../media/platform/sti/c8sectpfe/c8sectpfe-dvb.c   |   11 +-
 .../media/platform/sti/c8sectpfe/c8sectpfe-dvb.h   |    5 +-
 drivers/media/platform/sti/cec/stih-cec.c          |    5 +-
 drivers/media/platform/sti/delta/delta-cfg.h       |    2 +-
 drivers/media/platform/sti/delta/delta-debug.c     |    2 +-
 drivers/media/platform/sti/delta/delta-debug.h     |    2 +-
 drivers/media/platform/sti/delta/delta-ipc.c       |    2 +-
 drivers/media/platform/sti/delta/delta-ipc.h       |    2 +-
 drivers/media/platform/sti/delta/delta-mem.c       |    2 +-
 drivers/media/platform/sti/delta/delta-mem.h       |    2 +-
 drivers/media/platform/sti/delta/delta-mjpeg-dec.c |    2 +-
 drivers/media/platform/sti/delta/delta-mjpeg-fw.h  |    2 +-
 drivers/media/platform/sti/delta/delta-mjpeg-hdr.c |    2 +-
 drivers/media/platform/sti/delta/delta-mjpeg.h     |    2 +-
 drivers/media/platform/sti/delta/delta-v4l2.c      |    2 +-
 drivers/media/platform/sti/delta/delta.h           |    2 +-
 drivers/media/platform/sti/hva/hva-debugfs.c       |    2 +-
 drivers/media/platform/sti/hva/hva-h264.c          |    2 +-
 drivers/media/platform/sti/hva/hva-hw.c            |    2 +-
 drivers/media/platform/sti/hva/hva-hw.h            |    2 +-
 drivers/media/platform/sti/hva/hva-mem.c           |    2 +-
 drivers/media/platform/sti/hva/hva-mem.h           |    2 +-
 drivers/media/platform/sti/hva/hva-v4l2.c          |    2 +-
 drivers/media/platform/sti/hva/hva.h               |    4 +-
 drivers/media/platform/stm32/stm32-dcmi.c          |    2 +-
 drivers/media/platform/tegra-cec/tegra_cec.c       |    5 +
 drivers/media/platform/ti-vpe/cal.c                |    5 +-
 drivers/media/platform/via-camera.h                |    2 +-
 drivers/media/platform/vimc/vimc-common.h          |    5 +
 drivers/media/platform/vimc/vimc-sensor.c          |   65 +-
 drivers/media/platform/vivid/vivid-core.c          |    2 +-
 drivers/media/platform/vivid/vivid-core.h          |    5 +-
 drivers/media/platform/vivid/vivid-ctrls.c         |   35 +-
 drivers/media/platform/vivid/vivid-radio-rx.c      |   11 +-
 drivers/media/platform/vivid/vivid-radio-tx.c      |    8 +-
 drivers/media/platform/vivid/vivid-rds-gen.c       |    2 +-
 drivers/media/platform/vivid/vivid-rds-gen.h       |    1 +
 drivers/media/platform/vivid/vivid-vbi-gen.c       |    2 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |    9 +-
 drivers/media/platform/vsp1/vsp1_drv.c             |   16 +-
 drivers/media/platform/xilinx/xilinx-vipp.c        |   18 +-
 drivers/media/radio/radio-aimslab.c                |    2 +-
 drivers/media/radio/radio-aztech.c                 |    2 +-
 drivers/media/radio/radio-cadet.c                  |    4 +-
 drivers/media/radio/radio-gemtek.c                 |    8 +-
 drivers/media/radio/radio-maxiradio.c              |    2 +-
 drivers/media/radio/radio-mr800.c                  |   24 +-
 drivers/media/radio/radio-rtrack2.c                |    2 +-
 drivers/media/radio/radio-sf16fmi.c                |    4 +-
 drivers/media/radio/radio-sf16fmr2.c               |    2 +-
 drivers/media/radio/radio-si476x.c                 |   16 +-
 drivers/media/radio/radio-tea5764.c                |    2 +-
 drivers/media/radio/radio-terratec.c               |    6 +-
 drivers/media/radio/si470x/radio-si470x-common.c   |   24 +-
 drivers/media/radio/tea575x.c                      |    2 +-
 drivers/media/radio/wl128x/fmdrv_common.h          |   10 +-
 drivers/media/rc/Kconfig                           |   35 +-
 drivers/media/rc/Makefile                          |    5 +-
 drivers/media/rc/iguanair.c                        |   19 +-
 drivers/media/rc/imon.c                            |   55 +-
 drivers/media/rc/ir-jvc-decoder.c                  |    1 +
 drivers/media/rc/ir-lirc-codec.c                   |  448 -----
 drivers/media/rc/ir-mce_kbd-decoder.c              |   18 +-
 drivers/media/rc/ir-nec-decoder.c                  |   20 +-
 drivers/media/rc/ir-rc5-decoder.c                  |   44 +-
 drivers/media/rc/ir-rc6-decoder.c                  |   32 +-
 drivers/media/rc/ir-sanyo-decoder.c                |   38 +-
 drivers/media/rc/ir-sharp-decoder.c                |    1 +
 drivers/media/rc/ir-sony-decoder.c                 |    1 +
 drivers/media/rc/ir-spi.c                          |   15 +-
 drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c    |   17 +-
 drivers/media/rc/keymaps/rc-apac-viewcomp.c        |   17 +-
 drivers/media/rc/keymaps/rc-asus-pc39.c            |   17 +-
 drivers/media/rc/keymaps/rc-asus-ps3-100.c         |   17 +-
 drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c |   17 +-
 drivers/media/rc/keymaps/rc-avermedia-a16d.c       |   17 +-
 drivers/media/rc/keymaps/rc-avermedia-cardbus.c    |   17 +-
 drivers/media/rc/keymaps/rc-avermedia-dvbt.c       |   17 +-
 drivers/media/rc/keymaps/rc-avermedia-m135a.c      |   15 +-
 drivers/media/rc/keymaps/rc-avermedia.c            |   17 +-
 drivers/media/rc/keymaps/rc-avertv-303.c           |   17 +-
 drivers/media/rc/keymaps/rc-behold-columbus.c      |   23 +-
 drivers/media/rc/keymaps/rc-behold.c               |   17 +-
 drivers/media/rc/keymaps/rc-budget-ci-old.c        |   17 +-
 drivers/media/rc/keymaps/rc-cinergy-1400.c         |   17 +-
 drivers/media/rc/keymaps/rc-cinergy.c              |   17 +-
 drivers/media/rc/keymaps/rc-dib0700-nec.c          |   27 +-
 drivers/media/rc/keymaps/rc-dib0700-rc5.c          |   27 +-
 drivers/media/rc/keymaps/rc-dm1105-nec.c           |   17 +-
 drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c      |   17 +-
 drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c   |   17 +-
 drivers/media/rc/keymaps/rc-em-terratec.c          |   17 +-
 drivers/media/rc/keymaps/rc-encore-enltv-fm53.c    |   17 +-
 drivers/media/rc/keymaps/rc-encore-enltv.c         |   17 +-
 drivers/media/rc/keymaps/rc-encore-enltv2.c        |   17 +-
 drivers/media/rc/keymaps/rc-evga-indtube.c         |   17 +-
 drivers/media/rc/keymaps/rc-eztv.c                 |   17 +-
 drivers/media/rc/keymaps/rc-flydvb.c               |   17 +-
 drivers/media/rc/keymaps/rc-flyvideo.c             |   17 +-
 drivers/media/rc/keymaps/rc-fusionhdtv-mce.c       |   17 +-
 drivers/media/rc/keymaps/rc-gadmei-rm008z.c        |   17 +-
 drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c   |   17 +-
 drivers/media/rc/keymaps/rc-gotview7135.c          |   17 +-
 drivers/media/rc/keymaps/rc-hauppauge.c            |   29 +-
 drivers/media/rc/keymaps/rc-iodata-bctv7e.c        |   17 +-
 drivers/media/rc/keymaps/rc-kaiomy.c               |   17 +-
 drivers/media/rc/keymaps/rc-kworld-315u.c          |   17 +-
 .../media/rc/keymaps/rc-kworld-plus-tv-analog.c    |   17 +-
 drivers/media/rc/keymaps/rc-manli.c                |   17 +-
 drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c  |   17 +-
 drivers/media/rc/keymaps/rc-msi-tvanywhere.c       |   17 +-
 drivers/media/rc/keymaps/rc-nebula.c               |   17 +-
 .../media/rc/keymaps/rc-nec-terratec-cinergy-xs.c  |   17 +-
 drivers/media/rc/keymaps/rc-norwood.c              |   17 +-
 drivers/media/rc/keymaps/rc-npgtech.c              |   17 +-
 drivers/media/rc/keymaps/rc-pctv-sedna.c           |   17 +-
 drivers/media/rc/keymaps/rc-pinnacle-color.c       |   17 +-
 drivers/media/rc/keymaps/rc-pinnacle-grey.c        |   17 +-
 drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c     |   17 +-
 drivers/media/rc/keymaps/rc-pixelview-002t.c       |   17 +-
 drivers/media/rc/keymaps/rc-pixelview-mk12.c       |   17 +-
 drivers/media/rc/keymaps/rc-pixelview-new.c        |   17 +-
 drivers/media/rc/keymaps/rc-pixelview.c            |   17 +-
 .../media/rc/keymaps/rc-powercolor-real-angel.c    |   17 +-
 drivers/media/rc/keymaps/rc-proteus-2309.c         |   17 +-
 drivers/media/rc/keymaps/rc-purpletv.c             |   17 +-
 drivers/media/rc/keymaps/rc-pv951.c                |   17 +-
 .../media/rc/keymaps/rc-real-audio-220-32-keys.c   |   17 +-
 drivers/media/rc/keymaps/rc-tbs-nec.c              |   17 +-
 drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c  |   17 +-
 drivers/media/rc/keymaps/rc-tevii-nec.c            |   17 +-
 drivers/media/rc/keymaps/rc-tt-1500.c              |   17 +-
 drivers/media/rc/keymaps/rc-videomate-s350.c       |   17 +-
 drivers/media/rc/keymaps/rc-videomate-tv-pvr.c     |   17 +-
 drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c |   19 +-
 drivers/media/rc/keymaps/rc-winfast.c              |   17 +-
 drivers/media/rc/lirc_dev.c                        |  982 ++++++----
 drivers/media/rc/rc-core-priv.h                    |   72 +-
 drivers/media/rc/rc-ir-raw.c                       |   86 +-
 drivers/media/rc/rc-main.c                         |  248 ++-
 drivers/media/rc/winbond-cir.c                     |    2 +-
 drivers/media/tuners/Kconfig                       |    7 +
 drivers/media/tuners/Makefile                      |    2 +-
 drivers/media/tuners/e4000.h                       |    2 +-
 drivers/media/tuners/fc0011.h                      |    2 +-
 drivers/media/tuners/fc0012.h                      |    2 +-
 drivers/media/tuners/fc0013.h                      |    2 +-
 drivers/media/tuners/fc2580.h                      |    2 +-
 drivers/media/tuners/it913x.h                      |    2 +-
 drivers/media/tuners/m88rs6000t.h                  |    2 +-
 drivers/media/tuners/max2165.c                     |    2 +-
 drivers/media/tuners/mc44s803.c                    |    2 +-
 drivers/media/tuners/mt2060.c                      |    2 +-
 drivers/media/tuners/mt2063.c                      |    4 +-
 drivers/media/tuners/mt2063.h                      |    2 +-
 drivers/media/tuners/mt20xx.h                      |    2 +-
 drivers/media/tuners/mt2131.c                      |    2 +-
 drivers/media/tuners/mt2266.c                      |    2 +-
 drivers/media/tuners/mxl301rf.h                    |    2 +-
 drivers/media/tuners/mxl5005s.c                    |   25 +-
 drivers/media/tuners/mxl5005s.h                    |    2 +-
 drivers/media/tuners/mxl5007t.h                    |    2 +-
 drivers/media/tuners/qm1d1c0042.h                  |    2 +-
 drivers/media/tuners/qt1010.c                      |    4 +-
 drivers/media/tuners/qt1010.h                      |    2 +-
 drivers/media/tuners/r820t.c                       |   69 +-
 drivers/media/tuners/r820t.h                       |    2 +-
 drivers/media/tuners/si2157.c                      |    2 +-
 drivers/media/tuners/si2157.h                      |    2 +-
 drivers/media/tuners/tda18212.h                    |    2 +-
 drivers/media/tuners/tda18218.h                    |    2 +-
 drivers/media/tuners/tda18250.c                    |  902 +++++++++
 drivers/media/tuners/tda18250.h                    |   51 +
 drivers/media/tuners/tda18250_priv.h               |  145 ++
 drivers/media/tuners/tda18271.h                    |    2 +-
 drivers/media/tuners/tda827x.h                     |    4 +-
 drivers/media/tuners/tda8290.c                     |   78 +-
 drivers/media/tuners/tda8290.h                     |    2 +-
 drivers/media/tuners/tda9887.c                     |    4 +-
 drivers/media/tuners/tda9887.h                     |    2 +-
 drivers/media/tuners/tea5761.c                     |   15 +-
 drivers/media/tuners/tea5761.h                     |    2 +-
 drivers/media/tuners/tea5767.c                     |   21 +-
 drivers/media/tuners/tea5767.h                     |    2 +-
 drivers/media/tuners/tua9001.h                     |    2 +-
 drivers/media/tuners/tuner-i2c.h                   |    2 +-
 drivers/media/tuners/tuner-simple.c                |    2 +-
 drivers/media/tuners/tuner-simple.h                |    2 +-
 drivers/media/tuners/tuner-xc2028-types.h          |    5 +-
 drivers/media/tuners/tuner-xc2028.c                |   26 +-
 drivers/media/tuners/tuner-xc2028.h                |    9 +-
 drivers/media/tuners/xc4000.c                      |    7 +-
 drivers/media/tuners/xc5000.c                      |   24 +-
 drivers/media/usb/as102/Makefile                   |    1 -
 drivers/media/usb/as102/as102_drv.c                |    2 +-
 drivers/media/usb/as102/as102_drv.h                |    6 +-
 drivers/media/usb/as102/as10x_cmd_cfg.c            |    6 +-
 drivers/media/usb/au0828/Makefile                  |    1 -
 drivers/media/usb/au0828/au0828-cards.h            |    2 +-
 drivers/media/usb/au0828/au0828-input.c            |   25 +-
 drivers/media/usb/au0828/au0828-video.c            |    2 +-
 drivers/media/usb/au0828/au0828.h                  |   18 +-
 drivers/media/usb/b2c2/Makefile                    |    1 -
 drivers/media/usb/cpia2/cpia2_usb.c                |   14 +-
 drivers/media/usb/cpia2/cpia2_v4l.c                |    4 +-
 drivers/media/usb/cx231xx/Makefile                 |    2 -
 drivers/media/usb/cx231xx/cx231xx-audio.c          |    6 +-
 drivers/media/usb/cx231xx/cx231xx-avcore.c         |    4 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |   30 +-
 drivers/media/usb/cx231xx/cx231xx-core.c           |    2 +-
 drivers/media/usb/cx231xx/cx231xx-dvb.c            |    8 +-
 drivers/media/usb/cx231xx/cx231xx-i2c.c            |    2 +-
 drivers/media/usb/cx231xx/cx231xx-input.c          |   28 +-
 drivers/media/usb/cx231xx/cx231xx-pcb-cfg.h        |    2 +-
 drivers/media/usb/cx231xx/cx231xx-reg.h            |   20 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |    4 +-
 drivers/media/usb/cx231xx/cx231xx.h                |    1 +
 drivers/media/usb/dvb-usb-v2/Makefile              |    1 -
 drivers/media/usb/dvb-usb-v2/anysee.h              |    2 +-
 drivers/media/usb/dvb-usb-v2/az6007.c              |    2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb.h             |   10 +-
 drivers/media/usb/dvb-usb-v2/dvbsky.c              |   92 +-
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |   39 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c      |    9 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h      |    2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h      |    2 +-
 drivers/media/usb/dvb-usb/Kconfig                  |    2 +
 drivers/media/usb/dvb-usb/Makefile                 |    1 -
 drivers/media/usb/dvb-usb/az6027.c                 |  218 +--
 drivers/media/usb/dvb-usb/cxusb.c                  |   10 +-
 drivers/media/usb/dvb-usb/dib0700.h                |    2 +
 drivers/media/usb/dvb-usb/dib0700_core.c           |   26 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c        |  110 +-
 drivers/media/usb/dvb-usb/dvb-usb.h                |   10 +-
 drivers/media/usb/dvb-usb/dw2102.c                 |    2 +-
 drivers/media/usb/dvb-usb/friio-fe.c               |    5 +-
 drivers/media/usb/dvb-usb/pctv452e.c               |   10 +-
 drivers/media/usb/dvb-usb/ttusb2.c                 |    2 +-
 drivers/media/usb/em28xx/Kconfig                   |   14 +-
 drivers/media/usb/em28xx/Makefile                  |    2 -
 drivers/media/usb/em28xx/em28xx-cards.c            |    1 -
 drivers/media/usb/em28xx/em28xx-dvb.c              |    9 +-
 drivers/media/usb/gspca/autogain_functions.c       |   28 +-
 drivers/media/usb/gspca/benq.c                     |    8 +-
 drivers/media/usb/gspca/conex.c                    |   13 +-
 drivers/media/usb/gspca/cpia1.c                    |   76 +-
 drivers/media/usb/gspca/dtcs033.c                  |   28 +-
 drivers/media/usb/gspca/etoms.c                    |   38 +-
 drivers/media/usb/gspca/finepix.c                  |    4 +-
 drivers/media/usb/gspca/gl860/gl860.c              |   37 +-
 drivers/media/usb/gspca/gspca.c                    |  153 +-
 drivers/media/usb/gspca/gspca.h                    |    9 +-
 drivers/media/usb/gspca/jeilinj.c                  |   19 +-
 drivers/media/usb/gspca/jl2005bcd.c                |   45 +-
 drivers/media/usb/gspca/kinect.c                   |   11 +-
 drivers/media/usb/gspca/konica.c                   |   28 +-
 drivers/media/usb/gspca/m5602/m5602_core.c         |   34 +-
 drivers/media/usb/gspca/m5602/m5602_mt9m111.c      |   21 +-
 drivers/media/usb/gspca/m5602/m5602_ov7660.c       |   11 +-
 drivers/media/usb/gspca/m5602/m5602_ov9650.c       |   26 +-
 drivers/media/usb/gspca/m5602/m5602_po1030.c       |   27 +-
 drivers/media/usb/gspca/m5602/m5602_s5k4aa.c       |   16 +-
 drivers/media/usb/gspca/m5602/m5602_s5k83a.c       |    2 +-
 drivers/media/usb/gspca/mars.c                     |    4 +-
 drivers/media/usb/gspca/mr97310a.c                 |   29 +-
 drivers/media/usb/gspca/nw80x.c                    |   24 +-
 drivers/media/usb/gspca/ov519.c                    |  155 +-
 drivers/media/usb/gspca/ov534.c                    |   25 +-
 drivers/media/usb/gspca/ov534_9.c                  |   23 +-
 drivers/media/usb/gspca/pac207.c                   |   16 +-
 drivers/media/usb/gspca/pac7302.c                  |    2 +-
 drivers/media/usb/gspca/pac7311.c                  |    2 +-
 drivers/media/usb/gspca/pac_common.h               |    7 +-
 drivers/media/usb/gspca/sn9c2028.c                 |   34 +-
 drivers/media/usb/gspca/sn9c2028.h                 |    7 +-
 drivers/media/usb/gspca/sn9c20x.c                  |    2 +-
 drivers/media/usb/gspca/sonixj.c                   |   58 +-
 drivers/media/usb/gspca/spca1528.c                 |   17 +-
 drivers/media/usb/gspca/spca500.c                  |   66 +-
 drivers/media/usb/gspca/spca501.c                  |   10 +-
 drivers/media/usb/gspca/spca505.c                  |    6 +-
 drivers/media/usb/gspca/spca506.c                  |   16 +-
 drivers/media/usb/gspca/spca508.c                  |   20 +-
 drivers/media/usb/gspca/spca561.c                  |   20 +-
 drivers/media/usb/gspca/sq905.c                    |   16 +-
 drivers/media/usb/gspca/sq905c.c                   |   37 +-
 drivers/media/usb/gspca/sq930x.c                   |   29 +-
 drivers/media/usb/gspca/stk014.c                   |    6 +-
 drivers/media/usb/gspca/stk1135.c                  |   15 +-
 drivers/media/usb/gspca/stv0680.c                  |   36 +-
 drivers/media/usb/gspca/stv06xx/stv06xx.c          |   76 +-
 drivers/media/usb/gspca/stv06xx/stv06xx.h          |    2 +-
 drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.c     |   10 +-
 drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c   |   23 +-
 drivers/media/usb/gspca/stv06xx/stv06xx_st6422.c   |    2 +-
 drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c   |   16 +-
 drivers/media/usb/gspca/sunplus.c                  |   36 +-
 drivers/media/usb/gspca/t613.c                     |   24 +-
 drivers/media/usb/gspca/topro.c                    |    6 +-
 drivers/media/usb/gspca/touptek.c                  |   89 +-
 drivers/media/usb/gspca/vc032x.c                   |   51 +-
 drivers/media/usb/gspca/w996Xcf.c                  |    9 +-
 drivers/media/usb/gspca/xirlink_cit.c              |   32 +-
 drivers/media/usb/gspca/zc3xx.c                    |   83 +-
 drivers/media/usb/hdpvr/Makefile                   |    4 -
 drivers/media/usb/hdpvr/hdpvr-core.c               |   37 +-
 drivers/media/usb/hdpvr/hdpvr-i2c.c                |   23 +-
 drivers/media/usb/hdpvr/hdpvr-video.c              |   26 +-
 drivers/media/usb/hdpvr/hdpvr.h                    |   19 +-
 drivers/media/usb/pulse8-cec/pulse8-cec.c          |    4 +-
 drivers/media/usb/pvrusb2/Makefile                 |    2 -
 drivers/media/usb/pvrusb2/pvrusb2-devattr.c        |   12 +-
 drivers/media/usb/pvrusb2/pvrusb2-dvb.c            |    2 +-
 drivers/media/usb/pvrusb2/pvrusb2-dvb.h            |    8 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |   15 +-
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c       |   13 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           |   34 +-
 drivers/media/usb/pwc/pwc.h                        |    6 +-
 drivers/media/usb/s2255/s2255drv.c                 |   13 +-
 drivers/media/usb/siano/Makefile                   |    1 -
 drivers/media/usb/siano/smsusb.c                   |    2 +-
 drivers/media/usb/stk1160/Makefile                 |    4 +-
 drivers/media/usb/stkwebcam/stk-sensor.c           |   44 +-
 drivers/media/usb/stkwebcam/stk-webcam.c           |    2 +-
 drivers/media/usb/tm6000/Makefile                  |    2 -
 drivers/media/usb/tm6000/tm6000-alsa.c             |   18 +-
 drivers/media/usb/tm6000/tm6000-cards.c            |   21 +-
 drivers/media/usb/tm6000/tm6000-core.c             |   24 +-
 drivers/media/usb/tm6000/tm6000-i2c.c              |   24 +-
 drivers/media/usb/tm6000/tm6000-regs.h             |   14 +-
 drivers/media/usb/tm6000/tm6000-stds.c             |   18 +-
 drivers/media/usb/tm6000/tm6000-usb-isoc.h         |   14 +-
 drivers/media/usb/tm6000/tm6000-video.c            |   26 +-
 drivers/media/usb/tm6000/tm6000.h                  |   24 +-
 drivers/media/usb/ttusb-budget/Makefile            |    2 +-
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c  |    8 +-
 drivers/media/usb/ttusb-dec/Makefile               |    2 -
 drivers/media/usb/ttusb-dec/ttusb_dec.c            |    8 +-
 drivers/media/usb/ttusb-dec/ttusbdecfe.c           |    2 +-
 drivers/media/usb/usbtv/Kconfig                    |   16 +-
 drivers/media/usb/usbvision/Makefile               |    1 -
 drivers/media/usb/usbvision/usbvision-video.c      |    3 +-
 drivers/media/usb/uvc/Makefile                     |    2 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  243 ++-
 drivers/media/usb/uvc/uvc_isight.c                 |   12 +-
 drivers/media/usb/uvc/uvc_metadata.c               |  179 ++
 drivers/media/usb/uvc/uvc_queue.c                  |   44 +-
 drivers/media/usb/uvc/uvc_status.c                 |    5 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |    4 -
 drivers/media/usb/uvc/uvc_video.c                  |  187 +-
 drivers/media/usb/uvc/uvcvideo.h                   |   35 +-
 drivers/media/v4l2-core/Kconfig                    |   36 +-
 drivers/media/v4l2-core/Makefile                   |    8 -
 drivers/media/v4l2-core/v4l2-async.c               |   16 +-
 drivers/media/v4l2-core/v4l2-common.c              |   27 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      | 1040 ++++++----
 drivers/media/v4l2-core/v4l2-dev.c                 |   10 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c          |    2 +-
 drivers/media/v4l2-core/v4l2-fwnode.c              |   10 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |  212 +-
 drivers/media/v4l2-core/v4l2-mc.c                  |    2 -
 drivers/staging/media/Kconfig                      |   17 +-
 drivers/staging/media/Makefile                     |    2 +-
 drivers/staging/media/atomisp/i2c/atomisp-gc0310.c |   10 +-
 drivers/staging/media/atomisp/i2c/atomisp-gc2235.c |    8 +-
 drivers/staging/media/atomisp/i2c/atomisp-lm3554.c |   38 +-
 .../staging/media/atomisp/i2c/atomisp-mt9m114.c    |    8 +-
 drivers/staging/media/atomisp/i2c/atomisp-ov2680.c |   10 +-
 drivers/staging/media/atomisp/i2c/atomisp-ov2722.c |   17 +-
 drivers/staging/media/atomisp/i2c/ov2680.h         |    1 -
 .../media/atomisp/i2c/ov5693/atomisp-ov5693.c      |   94 +-
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.h  |    2 +-
 drivers/staging/media/atomisp/i2c/ov8858.c         |   43 +-
 .../staging/media/atomisp/include/linux/atomisp.h  |    2 +
 .../atomisp/include/linux/atomisp_gmin_platform.h  |    1 -
 .../media/atomisp/pci/atomisp2/atomisp_drvfs.c     |   17 +-
 .../media/atomisp/pci/atomisp2/atomisp_drvfs.h     |    5 +-
 .../media/atomisp/pci/atomisp2/atomisp_internal.h  |    1 -
 .../media/atomisp/pci/atomisp2/atomisp_ioctl.c     |    5 +-
 .../media/atomisp/pci/atomisp2/atomisp_subdev.c    |    2 +
 .../media/atomisp/pci/atomisp2/atomisp_v4l2.c      |   12 +-
 .../isp/kernels/eed1_8/ia_css_eed1_8.host.c        |   24 +-
 .../css2400/runtime/debug/src/ia_css_debug.c       |    1 +
 .../isp_param/interface/ia_css_isp_param_types.h   |    2 +-
 .../staging/media/atomisp/pci/atomisp2/hmm/hmm.c   |    8 +-
 .../platform/intel-mid/atomisp_gmin_platform.c     |  129 +-
 drivers/staging/media/cxd2099/Makefile             |    1 -
 drivers/staging/media/cxd2099/cxd2099.c            |   30 +-
 drivers/staging/media/cxd2099/cxd2099.h            |   16 +-
 drivers/staging/media/davinci_vpfe/TODO            |   10 +-
 drivers/staging/media/imx/TODO                     |   63 +-
 drivers/staging/media/imx/imx-ic-prp.c             |    4 +-
 drivers/staging/media/imx/imx-media-capture.c      |    8 +-
 drivers/staging/media/imx/imx-media-csi.c          |  197 +-
 drivers/staging/media/imx/imx-media-dev.c          |  400 ++--
 drivers/staging/media/imx/imx-media-fim.c          |   30 +-
 drivers/staging/media/imx/imx-media-internal-sd.c  |  253 +--
 drivers/staging/media/imx/imx-media-of.c           |  278 ++-
 drivers/staging/media/imx/imx-media-utils.c        |  122 +-
 drivers/staging/media/imx/imx-media.h              |  191 +-
 drivers/staging/media/imx/imx6-mipi-csi2.c         |    4 +-
 drivers/staging/media/lirc/Kconfig                 |   21 -
 drivers/staging/media/lirc/Makefile                |    6 -
 drivers/staging/media/lirc/TODO                    |   36 -
 drivers/staging/media/lirc/lirc_zilog.c            | 1653 ----------------
 drivers/staging/media/omap4iss/iss.c               |    2 +-
 drivers/staging/media/tegra-vde/Kconfig            |    8 +
 drivers/staging/media/tegra-vde/Makefile           |    1 +
 drivers/staging/media/tegra-vde/TODO               |    4 +
 drivers/staging/media/tegra-vde/tegra-vde.c        | 1213 ++++++++++++
 drivers/staging/media/tegra-vde/uapi.h             |   78 +
 drivers/w1/w1_netlink.h                            |    6 +-
 fs/compat_ioctl.c                                  |   22 +-
 include/linux/kfifo.h                              |    3 +-
 include/linux/led-class-flash.h                    |    4 +
 include/linux/refcount.h                           |    2 +-
 include/media/cec.h                                |   18 +-
 {drivers/media/dvb-core => include/media}/demux.h  |    0
 {drivers/media/dvb-core => include/media}/dmxdev.h |   43 +-
 include/media/drv-intf/cx2341x.h                   |  144 +-
 include/media/drv-intf/exynos-fimc.h               |    3 +-
 include/media/drv-intf/msp3400.h                   |   62 +-
 include/media/drv-intf/saa7146.h                   |    2 +-
 .../media/dvb-core => include/media}/dvb-usb-ids.h |    3 +
 .../dvb-core => include/media}/dvb_ca_en50221.h    |    2 +-
 .../media/dvb-core => include/media}/dvb_demux.h   |   25 +-
 .../dvb-core => include/media}/dvb_frontend.h      |   19 +-
 .../media/dvb-core => include/media}/dvb_math.h    |    0
 .../media/dvb-core => include/media}/dvb_net.h     |    2 +-
 .../dvb-core => include/media}/dvb_ringbuffer.h    |    0
 include/media/dvb_vb2.h                            |  266 +++
 {drivers/media/dvb-core => include/media}/dvbdev.h |    4 +-
 include/media/i2c-addr.h                           |   43 -
 include/media/i2c/as3645a.h                        |   66 -
 include/media/i2c/bt819.h                          |    4 +-
 include/media/i2c/ir-kbd-i2c.h                     |    6 +-
 include/media/i2c/m52790.h                         |   52 +-
 include/media/i2c/saa7115.h                        |   12 +-
 include/media/i2c/tvaudio.h                        |   17 +-
 include/media/i2c/upd64031a.h                      |    6 +-
 include/media/lirc.h                               |    1 -
 include/media/lirc_dev.h                           |  192 --
 include/media/media-entity.h                       |   11 +-
 include/media/rc-core.h                            |   69 +-
 include/media/rc-map.h                             |   54 +-
 include/media/{ => tpg}/v4l2-tpg.h                 |   45 +-
 include/media/tuner-types.h                        |   15 +
 include/media/v4l2-async.h                         |   39 +-
 include/media/v4l2-common.h                        |  145 +-
 include/media/v4l2-ctrls.h                         |   11 +-
 include/media/v4l2-dev.h                           |  140 +-
 include/media/v4l2-device.h                        |  246 ++-
 include/media/v4l2-dv-timings.h                    |   16 +-
 include/media/v4l2-event.h                         |   36 +-
 include/media/v4l2-flash-led-class.h               |   12 +
 include/media/v4l2-fwnode.h                        |   12 +-
 include/media/v4l2-mediabus.h                      |   80 +-
 include/media/v4l2-subdev.h                        |  150 +-
 include/media/v4l2-tpg-colors.h                    |   68 -
 include/media/videobuf-dvb.h                       |   10 +-
 include/media/videobuf2-core.h                     |  519 +++--
 include/media/videobuf2-dvb.h                      |   11 +-
 include/media/videobuf2-memops.h                   |    8 +-
 include/media/videobuf2-v4l2.h                     |  112 +-
 include/uapi/linux/dvb/dmx.h                       |   63 +-
 include/uapi/linux/dvb/frontend.h                  |   40 +-
 include/uapi/linux/dvb/version.h                   |    2 +-
 include/uapi/linux/dvb/video.h                     |   20 +-
 include/uapi/linux/lirc.h                          |   82 +
 include/uapi/linux/uvcvideo.h                      |   26 +
 include/uapi/linux/v4l2-controls.h                 |   96 +-
 include/uapi/linux/videodev2.h                     |   63 +-
 lib/uuid.c                                         |   34 +-
 lib/vsprintf.c                                     |    5 +-
 scripts/kernel-doc                                 | 1482 ++------------
 988 files changed, 22912 insertions(+), 15973 deletions(-)
 rename Documentation/{printk-formats.txt => core-api/printk-formats.rst} (64%)
 create mode 100644 Documentation/core-api/refcount-vs-atomic.rst
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov7740.txt
 create mode 100644 Documentation/devicetree/bindings/media/nvidia,tegra-vde.txt
 delete mode 100644 Documentation/kernel-doc-nano-HOWTO.txt
 create mode 100644 Documentation/maintainer/conf.py
 create mode 100644 Documentation/maintainer/configure-git.rst
 create mode 100644 Documentation/maintainer/index.rst
 create mode 100644 Documentation/maintainer/pull-requests.rst
 create mode 100644 Documentation/media/uapi/dvb/dmx-expbuf.rst
 create mode 100644 Documentation/media/uapi/dvb/dmx-mmap.rst
 create mode 100644 Documentation/media/uapi/dvb/dmx-munmap.rst
 create mode 100644 Documentation/media/uapi/dvb/dmx-qbuf.rst
 create mode 100644 Documentation/media/uapi/dvb/dmx-querybuf.rst
 create mode 100644 Documentation/media/uapi/dvb/dmx-reqbufs.rst
 delete mode 100644 Documentation/media/uapi/rc/lirc-get-length.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
 create mode 100644 drivers/media/common/videobuf2/Kconfig
 create mode 100644 drivers/media/common/videobuf2/Makefile
 rename drivers/media/{v4l2-core => common/videobuf2}/videobuf2-core.c (97%)
 rename drivers/media/{v4l2-core => common/videobuf2}/videobuf2-dma-contig.c (99%)
 rename drivers/media/{v4l2-core => common/videobuf2}/videobuf2-dma-sg.c (99%)
 rename drivers/media/{v4l2-core => common/videobuf2}/videobuf2-dvb.c (100%)
 rename drivers/media/{v4l2-core => common/videobuf2}/videobuf2-memops.c (100%)
 rename drivers/media/{v4l2-core => common/videobuf2}/videobuf2-v4l2.c (99%)
 rename drivers/media/{v4l2-core => common/videobuf2}/videobuf2-vmalloc.c (100%)
 create mode 100644 drivers/media/dvb-core/dvb_vb2.c
 delete mode 100644 drivers/media/i2c/as3645a.c
 create mode 100644 drivers/media/i2c/ov7740.c
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-ci.c
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-ci.h
 rename drivers/media/pci/ddbridge/{ddbridge-maxs8.c => ddbridge-max.c} (92%)
 rename drivers/media/pci/ddbridge/{ddbridge-maxs8.h => ddbridge-max.h} (73%)
 create mode 100644 drivers/media/pci/intel/Makefile
 create mode 100644 drivers/media/pci/intel/ipu3/Kconfig
 create mode 100644 drivers/media/pci/intel/ipu3/Makefile
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-cio2.c
 create mode 100644 drivers/media/pci/intel/ipu3/ipu3-cio2.h
 delete mode 100644 drivers/media/rc/ir-lirc-codec.c
 create mode 100644 drivers/media/tuners/tda18250.c
 create mode 100644 drivers/media/tuners/tda18250.h
 create mode 100644 drivers/media/tuners/tda18250_priv.h
 create mode 100644 drivers/media/usb/uvc/uvc_metadata.c
 delete mode 100644 drivers/staging/media/lirc/Kconfig
 delete mode 100644 drivers/staging/media/lirc/Makefile
 delete mode 100644 drivers/staging/media/lirc/TODO
 delete mode 100644 drivers/staging/media/lirc/lirc_zilog.c
 create mode 100644 drivers/staging/media/tegra-vde/Kconfig
 create mode 100644 drivers/staging/media/tegra-vde/Makefile
 create mode 100644 drivers/staging/media/tegra-vde/TODO
 create mode 100644 drivers/staging/media/tegra-vde/tegra-vde.c
 create mode 100644 drivers/staging/media/tegra-vde/uapi.h
 rename {drivers/media/dvb-core => include/media}/demux.h (100%)
 rename {drivers/media/dvb-core => include/media}/dmxdev.h (82%)
 rename {drivers/media/dvb-core => include/media}/dvb-usb-ids.h (99%)
 rename {drivers/media/dvb-core => include/media}/dvb_ca_en50221.h (99%)
 rename {drivers/media/dvb-core => include/media}/dvb_demux.h (94%)
 rename {drivers/media/dvb-core => include/media}/dvb_frontend.h (98%)
 rename {drivers/media/dvb-core => include/media}/dvb_math.h (100%)
 rename {drivers/media/dvb-core => include/media}/dvb_net.h (98%)
 rename {drivers/media/dvb-core => include/media}/dvb_ringbuffer.h (100%)
 create mode 100644 include/media/dvb_vb2.h
 rename {drivers/media/dvb-core => include/media}/dvbdev.h (99%)
 delete mode 100644 include/media/i2c-addr.h
 delete mode 100644 include/media/i2c/as3645a.h
 delete mode 100644 include/media/lirc.h
 delete mode 100644 include/media/lirc_dev.h
 rename include/media/{ => tpg}/v4l2-tpg.h (93%)
 delete mode 100644 include/media/v4l2-tpg-colors.h




Thanks,
Mauro
