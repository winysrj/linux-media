Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59050 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727408AbeHOWDY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Aug 2018 18:03:24 -0400
Date: Wed, 15 Aug 2018 16:09:54 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.19-rc1] media updates
Message-ID: <20180815160954.1945dbcc@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/me=
dia/v4.19-1

For:
- New Socionext MN88443x ISDB-S/T demodulator driver: mn88443x;
- New sensor drivers: ak7375, ov2680 and rj54n1cb0c;
- an old soc-camera sensor driver converted to the V4L2 framework: mt9v111;
- A new Voice-Coil Motor (VCM) driver: dw9807-vcm;
- Some cleanups at cx25821, removing legacy unused code;
- Some improvements at ddbridge driver;
- New platform driver: vicodec;
- Some DVB API cleanups, removing ioctls and compat code for old out-of-tree
  drivers that were never merged upstream;
- Improvements at DVB core to support frontents that support both
  Satellite and non-satellite delivery systems;
- got rid of the unused VIDIOC_RESERVED V4L2 ioctl;
- Some cleanups/improvements at gl861 ISDB driver;
- Several improvements on ov772x, ov7670 and ov5640, imx274, ov5645,
  and smiapp sensor drivers;
- fixes at em28xx to support dual TS devices;
- some cleanups at V4L2/VB2 locking logic;
- some API improvements at media controller;
- some cec core and drivers improvements;
- some uvcvideo improvements;
- some improvements at platform drivers: stm32-dcmi, rcar-vin, coda,
  reneseas-ceu, imx, vsp1, venus, camss
- Lots of other cleanups and fixes.

Regards,
Mauro

---

The following changes since commit 7daf201d7fe8334e2d2364d4e8ed3394ec9af819:

  Linux 4.18-rc2 (2018-06-24 20:54:29 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/me=
dia/v4.19-1

for you to fetch changes up to da2048b7348a0be92f706ac019e022139e29495e:

  Revert "media: vivid: shut up warnings due to a non-trivial logic" (2018-=
08-10 15:06:18 -0400)

----------------------------------------------------------------
media updates for v4.19-rc1

----------------------------------------------------------------
Akihiro Tsukada (4):
      media: dvb-usb/friio, dvb-usb-v2/gl861: decompose friio and merge wit=
h gl861
      media: dvb-frontends/dvb-pll: fix module ref-counting
      media: pci/pt1: suppress compiler warning in xtensa arch
      MAINTAINERS: add entries for several media drivers

Akinobu Mita (14):
      media: ov772x: allow i2c controllers without I2C_FUNC_PROTOCOL_MANGLI=
NG
      media: ov772x: add checks for register read errors
      media: ov772x: add media controller support
      media: ov772x: use generic names for reset and powerdown gpios
      media: ov772x: omit consumer ID when getting clock reference
      media: ov772x: support device tree probing
      media: ov772x: handle nested s_power() calls
      media: ov772x: reconstruct s_frame_interval()
      media: ov772x: use v4l2_ctrl to get current control value
      media: ov772x: avoid accessing registers under power saving mode
      media: ov772x: make set_fmt() and s_frame_interval() return -EBUSY wh=
ile streaming
      media: ov772x: create subdevice device node
      media: s3c-camif: ignore -ENOIOCTLCMD from v4l2_subdev_call for s_pow=
er
      media: soc_camera: ov772x: correct setting of banding filter

Alan Chiang (2):
      media: dt-bindings: Add bindings for Dongwoon DW9807 voice coil
      media: dw9807: Add dw9807 vcm driver

Alexandre Courbot (1):
      media: venus: keep resolution when adjusting format

Alexey Khoroshilov (2):
      media: tc358743: release device_node in tc358743_probe_of()
      media: fsl-viu: fix error handling in viu_of_probe()

Anton Leontiev (6):
      media: vim2m: Remove surplus name initialization
      media: ti-vpe: Remove surplus name initialization
      media: s5p-g2d: Remove surplus name initialization
      media: mx2: Remove surplus name initialization
      media: m2m-deinterlace: Remove surplus name initialization
      media: rga: Remove surplus name initialization

Anton Vasilyev (4):
      media: dw2102: Fix memleak on sequence of probes
      media: dm1105: Limit number of cards to avoid buffer over read
      media: vimc: Remove redundant free
      media: davinci: vpif_display: Mix memory leak on probe error path

Arnd Bergmann (6):
      media: v4l: cadence: include linux/slab.h
      media: v4l: cadence: add VIDEO_V4L2 dependency
      media: cx231xx: fix RC_CORE dependency
      media: v4l: omap: add VIDEO_V4L2 dependency
      media: omap3isp: fix warning for !CONFIG_PM
      media: headers: fix linux/mod_devicetable.h inclusions

Baruch Siach (1):
      media: v4l2-ctrls.h: fix v4l2_ctrl field description typos

Bingbu Cao (2):
      media: dt-bindings: Add bindings for AKM ak7375 voice coil lens
      media: ak7375: Add ak7375 lens voice coil driver

Brad Love (3):
      media: em28xx: Fix dual transport stream operation
      media: em28xx: Fix DualHD disconnect oops
      media: em28xx: Remove duplicate PID

Colin Ian King (7):
      media: mtk-vpu: fix spelling mistake: "Prosessor" -> "Processor"
      media: bt8xx: bttv: fix spelling mistake: "culpit" -> "culprit"
      media: cx18: remove redundant zero check on retval
      media: dvb-usb: fix spelling mistake: "completition" -> "completion"
      media: dvb-usb-v2: fix spelling mistake: "completition" -> "completio=
n"
      media: cx231xx: fix spelling mistake: "completition" -> "completion"
      media: au0828: fix spelling mistake: "completition" -> "completion"

Corentin Labbe (2):
      media: cx25821: remove cx25821-audio-upstream.c and cx25821-video-ups=
tream.c
      media: sii9234: remove unused header

Dan Carpenter (1):
      media: dvb_ca_en50221: off by one in dvb_ca_en50221_io_do_ioctl()

Daniel Scheller (19):
      media: dvb-frontends/stv0910: cast the BER denominator shift exp to U=
LL
      media: ddbridge: probe for LNBH25 chips before attaching
      media: ddbridge: evaluate the actual link when setting up the dummy t=
uner
      media: ddbridge: report I2C bus errors
      media: ddbridge: remove unused MDIO defines and hwinfo member
      media: ddbridge: link structure access cosmetics in ddb_port_probe()
      media: ddbridge: change MCI base ID and define a SX8 ID
      media: ddbridge/mci: update copyright year in headers
      media: ddbridge/mci: read and report signal strength and SNR
      media: ddbridge/mci: rename defines and fix i/q var types
      media: ddbridge/mci: extend mci_command and mci_result structs
      media: ddbridge/mci: store mci type and number of ports in the hwinfo
      media: ddbridge/mci: make ddb_mci_cmd() and ddb_mci_config() public
      media: ddbridge/mci: split MaxSX8 specific code off to ddbridge-sx8.c
      media: ddbridge/mci: add more MCI status codes, improve MCI_SUCCESS m=
acro
      media: ddbridge/sx8: disable automatic PLS code search
      media: ddbridge/sx8: enable modulation selection in set_parameters()
      media: ddbridge/mci: add SX8 I/Q mode remark and remove DIAG CMD defi=
nes
      media: dvb-frontends/tda18271c2dd: fix handling of DVB-T parameters

Dmitry Osipenko (1):
      media: dt: bindings: tegra-vde: Document new optional Memory Client r=
eset property

Ezequiel Garcia (19):
      media: mem2mem: Remove excessive try_run call
      media: rockchip/rga: Fix broken .start_streaming
      media: rockchip/rga: Remove unrequired wait in .job_abort
      media: mem2mem: Remove unused v4l2_m2m_ops .lock/.unlock
      media: rcar_vpu: Drop unneeded job_ready
      media: sta2x11: Add video_device and vb2_queue locks
      media: mtk-mdp: Add locks for capture and output vb2_queues
      media: s5p-g2d: Implement wait_prepare and wait_finish
      media: staging: bcm2835-camera: Provide lock for vb2_queue
      media: davinci_vpfe: Add video_device and vb2_queue locks
      media: mx_emmaprp: Implement wait_prepare and wait_finish
      media: m2m-deinterlace: Implement wait_prepare and wait_finish
      media: stk1160: Set the vb2_queue lock before calling vb2_queue_init
      media: add helpers for memory-to-memory media controller
      media: rcar_jpu: Remove unrequired wait in .job_abort
      media: s5p-g2d: Remove unrequired wait in .job_abort
      media: mem2mem: Make .job_abort optional
      media: rockchip/rga: Fix bad dma_free_attrs() parameter
      media: v4l2-mem2mem: Fix missing v4l2_m2m_try_run call

Gabriel Fanelli (1):
      media: staging: media: bcm2048: match alignment with open parenthesis

Geert Uytterhoeven (1):
      media: v4l: rcar_fdp1: Change platform dependency to ARCH_RENESAS

Guennadi Liakhovetski (3):
      media: uvcvideo: Remove a redundant check
      media: uvcvideo: Handle control pipe protocol STALLs
      media: uvcvideo: Send a control event when a Control Change interrupt=
 arrives

Gustavo A. R. Silva (2):
      media: dvb-bt8xx: remove duplicate code
      media: dib0700: add code comment

Hans Verkuil (35):
      media: Documentation/media/uapi/mediactl: redo tables
      media: subdev-formats.rst: fix incorrect types
      media: media.h: remove __NEED_MEDIA_LEGACY_API
      media: v4l2-ioctl.c: use correct vb2_queue lock for m2m devices
      media: vivid: fix gain when autogain is on
      media: v4l2-ctrls.c: fix broken auto cluster handling
      media: mark entity-intf links as IMMUTABLE
      media: vim2m: add media device
      media: videobuf2-core: check for q->error in vb2_core_qbuf()
      media: cec-gpio.txt: add v5-gpios for testing the 5V line
      media: cec-ioc-dqevent.rst: document the new 5V events
      media: uapi/linux/cec.h: add 5V events
      media: cec: add support for 5V signal testing
      media: cec-gpio: support 5v testing
      media: add 'index' to struct media_v2_pad
      media: media-ioc-g-topology.rst: document new 'index' field
      media: add flags field to struct media_v2_entity
      media: media-ioc-g-topology.rst: document new 'flags' field
      media: rename MEDIA_ENT_F_DTV_DECODER to MEDIA_ENT_F_DV_DECODER
      media: media.h: add MEDIA_ENT_F_DV_ENCODER
      media: media.h: reorder video en/decoder functions
      media: ad9389b/adv7511: set proper media entity function
      media: adv7180/tvp514x/tvp7002: fix entity function
      media: media/i2c: add missing entity functions
      media: media-ioc-enum-links.rst: improve pad index description
      media: media-ioc-enum-entities.rst/-g-topology.rst: clarify ID/name u=
sage
      media: media.h: add encoder/decoder functions for codecs
      media: videodev.h: add PIX_FMT_FWHT for use with vicodec
      media: v4l2-mem2mem: add v4l2_m2m_last_buf()
      media: vicodec: add the FWHT software codec
      media: vicodec: add the virtual codec driver
      media: media-types.rst: codec entities can have more than one source =
pad
      media: vicodec: current -> cur
      media: media-types.rst: fix doc warnings
      media: media.h: remove linux/version.h include

Hugues Fruchet (14):
      media: stm32-dcmi: increase max width/height to 2592
      media: stm32-dcmi: code cleanup
      media: stm32-dcmi: do not fall into error on buffer starvation
      media: stm32-dcmi: return buffer in error state on dma error
      media: stm32-dcmi: clarify state logic on buffer starvation
      media: stm32-dcmi: revisit buffer list management
      media: stm32-dcmi: revisit stop streaming ops
      media: stm32-dcmi: add power saving support
      media: ov5640: add HFLIP/VFLIP controls support
      media: dt-bindings: ov5640: Add "rotation" property
      media: ov5640: add support of module orientation
      media: ov5640: fix frame interval enumeration
      media: ov5640: do not change mode if format or frame interval is unch=
anged
      media: MAINTAINERS: Add entry for STM32 DCMI media driver

Jacopo Mondi (28):
      media: renesas-ceu: Add support for YUYV permutations
      media: i2c: Copy rj54n1cb0c soc_camera sensor driver
      media: i2c: rj54n1: Remove soc_camera dependencies
      media: arch: sh: kfr2r09: Use new renesas-ceu camera driver
      media: arch: sh: ms7724se: Use new renesas-ceu camera driver
      media: arch: sh: ap325rxa: Use new renesas-ceu camera driver
      media: rcar-vin: Rename 'digital' to 'parallel'
      media: rcar-vin: Remove two empty lines
      media: rcar-vin: Create a group notifier
      media: rcar-vin: Cleanup notifier in error path
      media: rcar-vin: Cache the mbus configuration flags
      media: rcar-vin: Parse parallel input on Gen3
      media: rcar-vin: Link parallel input media entities
      media: rcar-vin: Handle parallel subdev in link_notify
      media: rcar-vin: Rename _rcar_info to rcar_info
      media: rcar-vin: Add support for R-Car R8A77995 SoC
      media: dt-bindings: media: rcar-vin: Add R8A77995 support
      media: dt-bindings: media: rcar-vin: Align Gen2 and Gen3
      media: dt-bindings: media: rcar-vin: Describe optional ep properties
      media: dt-bindings: media: Document data-enable-active property
      media: v4l2-fwnode: parse 'data-enable-active' prop
      media: dt-bindings: media: rcar-vin: Add 'data-enable-active'
      media: rcar-vin: Handle data-enable polarity
      media: i2c: ov7670: Put ep fwnode after use
      media: sh: migor: Remove stale soc_camera include
      media: dt-bindings: media: i2c: Document MT9V111 bindings
      media: i2c: Add driver for Aptina MT9V111
      media: mt9v111: Fix build error with no VIDEO_V4L2_SUBDEV_API

Jan Luebbe (2):
      media: imx: capture: refactor enum_/try_fmt
      media: imx: add support for RGB565_2X8 on parallel bus

Janani Sankara Babu (1):
      media: Staging:media:imx Fix multiple assignments in a line

Jasmin Jessich (1):
      media: i2c: fix warning in Aptina MT9V111

Javier Martinez Canillas (2):
      media: Revert "[media] tvp5150: fix pad format frame height"
      media: omap3isp: zero-initialize the isp cam_xclk{a,b} initial data

Jia-Ju Bai (14):
      media: i2c: adv7842: Replace mdelay() with msleep() and usleep_range(=
) in adv7842_ddr_ram_test()
      media: i2c: vs6624: Replace mdelay() with msleep() and usleep_range()=
 in vs6624_probe()
      media: pci: cobalt: Replace GFP_ATOMIC with GFP_KERNEL in cobalt_prob=
e()
      media: pci: cx23885: Replace mdelay() with msleep() and usleep_range(=
) in altera_ci_slot_reset()
      media: pci: cx23885: Replace mdelay() with msleep() and usleep_range(=
) in cx23885_gpio_setup()
      media: pci: cx23885: Replace mdelay() with msleep() in cx23885_reset()
      media: pci: cx25821: Replace mdelay() with msleep()
      media: pci: cx88: Replace mdelay() with msleep() in cx88_card_setup_p=
re_i2c()
      media: pci: cx88: Replace mdelay() with msleep() in dvb_register()
      media: pci: ivtv: Replace GFP_ATOMIC with GFP_KERNEL
      media: dvb-frontends: rtl2832_sdr: Replace GFP_ATOMIC with GFP_KERNEL
      media: usb: em28xx: Replace GFP_ATOMIC with GFP_KERNEL in em28xx_init=
_usb_xfer()
      media: usb: em28xx: Replace mdelay() with msleep() in em28xx_pre_card=
_setup()
      media: usb: hackrf: Replace GFP_ATOMIC with GFP_KERNEL

Julia Lawall (1):
      media: gspca_kinect: cast sizeof to int for comparison

Katsuhiro Suzuki (3):
      media: helene: fix xtal frequency setting at power on
      media: helene: add I2C device probe function
      media: dvb-frontends: add Socionext MN88443x ISDB-S/T demodulator dri=
ver

Keiichi Watanabe (3):
      media: v4l2-ctrl: Change control for VP8 profile to menu control
      media: v4l2-ctrl: Add control for VP9 profile
      media: mtk-vcodec: Support VP9 profile in decoder

Kieran Bingham (12):
      media: uvcvideo: Fix minor spelling
      media: vsp1: Document vsp1_dl_body refcnt
      media: vsp1: drm: Fix minor grammar error
      media: vsp1: use kernel __packed for structures
      media: vsp1: Rename dl_child to dl_next
      media: vsp1: Remove unused display list structure field
      media: vsp1: Clean up DLM objects on error
      media: vsp1: Provide VSP1 feature helper macro
      media: vsp1: Use header display lists for all WPF outputs linked to t=
he DU
      media: vsp1: Add support for extended display list headers
      media: vsp1: Provide support for extended command pools
      media: vsp1: Support Interlaced display pipelines

Krzysztof Ha?asa (1):
      media: tw686x: Fix oops on buffer alloc failure

Kuninori Morimoto (9):
      media: soc_camera_platform: convert to SPDX identifiers
      media: rcar-vin: convert to SPDX identifiers
      media: rcar-fcp: convert to SPDX identifiers
      media: rcar_drif: convert to SPDX identifiers
      media: rcar_fdp1: convert to SPDX identifiers
      media: rcar_jpu: convert to SPDX identifiers
      media: sh_veu: convert to SPDX identifiers
      media: sh_vou: convert to SPDX identifiers
      media: sh_mobile_ceu: convert to SPDX identifiers

Laurent Pinchart (2):
      media: v4l: rcar_fdp1: Enable compilation on Gen2 platforms
      media: uvcvideo: Add KSMedia 8-bit IR format support

Luca Ceresoli (9):
      media: imx274: initialize format before v4l2 controls
      media: imx274: consolidate per-mode data in imx274_frmfmt
      media: imx274: get rid of mode_index
      media: imx274: actually use IMX274_DEFAULT_MODE
      media: imx274: simplify imx274_write_table()
      media: imx274: fix typo
      media: smiapp: fix debug message
      media: imx274: use regmap_bulk_write to write multybyte registers
      media: imx274: add cropping support via SELECTION API

Maciej S. Szmigiero (3):
      media: ivtv: zero-initialize cx25840 platform data
      media: cx25840: add kernel-doc description of struct cx25840_state
      media: tuner-simple: allow setting mono radio mode

Matt Ranostay (2):
      media: video-i2c: add hwmon support for amg88xx
      media: video-i2c: hwmon: fix return value from amg88xx_hwmon_init()

Mauro Carvalho Chehab (27):
      media: em28xx-cards: disable V4L2 mode for dual tuners
      media: dvb: get rid of VIDEO_SET_SPU_PALETTE
      media: media.h.rst.exceptions: ignore MEDIA-ENT-F-DTV-DECODER
      media: videodev2: get rid of VIDIOC_RESERVED
      media: dvb/video.h: get rid of unused APIs
      media: dvb/audio.h: get rid of unused APIs
      media: dvb: convert tuner_info frequencies to Hz
      media: dvb: represent min/max/step/tolerance freqs in Hz
      media: dvb_frontend: ensure that the step is ok for both FE and tuner
      media: imx: shut up a false positive warning
      media: v4l2-mem2mem: add descriptions to MC fields
      media: sta2x11: add a missing parameter description
      media: vsp1_dl: add a description for cmdpool field
      media: mt9v111: avoid going past the buffer
      media: rtl28xxu: be sure that it won't go past the array size
      media: vivid: shut up warnings due to a non-trivial logic
      media: cleanup fall-through comments
      media: tuner-xc2028: don't use casts for printing sizes
      media: drxj: get rid of uneeded casts
      media: xc4000: get rid of uneeded casts
      media: exynos-gsc: fix return code if mutex was interrupted
      media: saa7164: fix return codes for the polling routine
      media: s3c-camif: fix return code for the polling routine
      media: radio-wl1273: fix return code for the polling routine
      media: isp: fix a warning about a wrong struct initializer
      siano: get rid of an unused return code for debugfs register
      Revert "media: vivid: shut up warnings due to a non-trivial logic"

Mika B=C3=A5tsman (1):
      media: gl861: fix probe of dvb_usb_gl861

Neil Armstrong (1):
      media: platform: meson-ao-cec: make busy TX warning silent

Nicholas Mc Guire (6):
      media: adv7604: simplify of_node_put()
      media: atmel-isi: drop unnecessary while loop
      media: atmel-isi: move of_node_put() to cover success branch as well
      media: stm32-dcmi: drop unnecessary while(1) loop
      media: stm32-dcmi: add mandatory of_node_put() in success path
      media: stm32-dcmi: simplify of_node_put usage

Nicolas Dufresne (2):
      media: uvcvideo: Also validate buffers in BULK mode
      media: vivid: Fix V4L2_FIELD_ALTERNATE new frame check

Niklas S=C3=B6derlund (9):
      media: dt-bindings: media: rcar_vin: add support for r8a77965
      media: dt-bindings: media: rcar_vin: fix style for ports and endpoints
      media: rcar-vin: sync which hardware buffer to start capture from
      media: rcar-vin: enable support for r8a77965
      media: v4l2-ioctl: create helper to fill in v4l2_standard for ENUMSTD
      media: v4l: Add support for STD ioctls on subdev nodes
      media: adv7180: fix field type to V4L2_FIELD_ALTERNATE
      media: adv7180: add g_frame_interval support
      media: rcar-csi2: update stream start for V3M

Pavel Machek (1):
      media: i2c: lm3560: add support for lm3559 chip

Peter Seiderer (2):
      media: staging/imx: fill vb2_v4l2_buffer field entry
      media: staging/imx: fill vb2_v4l2_buffer sequence entry

Philipp Puschmann (1):
      media: ov5640: adjust xclk_max

Philipp Zabel (15):
      media: coda: fix encoder source stride
      media: coda: add read-only h.264 decoder profile/level controls
      media: coda: fix reorder detection for unknown levels
      media: coda: clear hold flag on streamoff
      media: coda: jpeg: allow non-JPEG colorspace
      media: coda: jpeg: only queue two buffers into the bitstream for JPEG=
 on CODA7541
      media: coda: jpeg: explicitly disable thumbnails in SEQ_INIT
      media: coda: mark CODA960 firmware version 2.1.9 as supported
      media: video-mux: fix compliance failures
      media: coda: move framebuffer size calculation out of loop
      media: coda: streamline framebuffer size calculation a bit
      media: coda: use encoder crop rectangle to set visible width and heig=
ht
      media: coda: add missing h.264 levels
      media: coda: let CODA960 firmware set frame cropping in SPS header
      media: coda: add SPS fixup code for frame sizes that are not multiple=
s of 16

Robert Schlabbach (2):
      media: em28xx: explicitly disable TS packet filter
      media: em28xx: disable null packet filter for WinTVdualHD

Rui Miguel Silva (2):
      media: ov2680: dt: Add bindings for OV2680
      media: ov2680: Add Omnivision OV2680 sensor driver

Sakari Ailus (9):
      media: imx258: Check the rotation property has a value of 180
      media: dt-bindings: media: Define "rotation" property for sensors
      media: dt-bindings: smia: Add "rotation" property
      media: smiapp: Support the "rotation" property
      media: v4l-common: Make v4l2_find_nearest_size more sparse-friendly
      media: smiapp: Set correct MODULE_LICENSE
      media: v4l: i2c: Replace "sensor-level" by "sensor"
      media: dw9807-vcm: Recognise this is just the VCM bit of the device
      media: doc-rst: Add packed Bayer raw14 pixel formats

Sean Young (1):
      media: bpf: ensure bpf program is freed on detach

Sebastian Andrzej Siewior (3):
      media: cx231xx: use irqsave() in USB's complete callback
      media: go7007: use irqsave() in USB's complete callback
      media: usbtv: use irqsave() in USB's complete callback

Simon Horman (1):
      media: rcar-vin: Drop unnecessary register properties from example vi=
n port

Stanimir Varbanov (27):
      media: venus: hfi_msgs: correct pointer increment
      media: venus: hfi: preparation to support venus 4xx
      media: venus: hfi: update sequence event to handle more properties
      media: venus: hfi_cmds: add set_properties for 4xx version
      media: venus: hfi: support session continue for 4xx version
      media: venus: hfi: handle buffer output2 type as well
      media: venus: hfi_venus: add halt AXI support for Venus 4xx
      media: venus: hfi_venus: fix suspend function for venus 3xx versions
      media: venus: hfi_venus: move set of default properties to core init
      media: venus: hfi_venus: add suspend functionality for Venus 4xx
      media: venus: core, helpers: add two more clocks found in Venus 4xx
      media: venus: hfi_parser: add common capability parser
      media: venus: helpers: rename a helper function and use buffer mode f=
rom caps
      media: venus: helpers: add a helper function to set dynamic buffer mo=
de
      media: venus: helpers: add helper function to set actual buffer size
      media: venus: core: delete not used buffer mode flags
      media: venus: helpers: add buffer type argument to a helper
      media: venus: helpers: add a new helper to set raw format
      media: venus: helpers, vdec, venc: add helpers to set work mode and c=
ore usage
      media: venus: helpers: extend set_num_bufs helper with one more argum=
ent
      media: venus: helpers: add a helper to return opb buffer sizes
      media: venus: vdec: get required input buffers as well
      media: venus: vdec: a new function for output configuration
      media: venus: helpers: move frame size calculations on common place
      media: venus: implementing multi-stream support
      media: venus: core: add sdm845 DT compatible and resource data
      media: venus: add HEVC codec support

Steve Longerbeam (2):
      media: i2c: adv748x: csi2: set entity function to video interface bri=
dge
      media: v4l2-ctrls: Fix CID base conflict between MAX217X and IMX

Sylwester Nawrocki (2):
      media: exynos4-is: Prevent NULL pointer dereference in __isp_video_tr=
y_fmt()
      media: s5p-mfc: Fix buffer look up in s5p_mfc_handle_frame_{new, copy=
_time} functions

Todor Tomov (34):
      media: ov5645: Supported external clock is 24MHz
      media: v4l: Add new 2X8 10-bit grayscale media bus code
      media: v4l: Add new 10-bit packed grayscale format
      media: Rename CAMSS driver path
      media: camss: Use SPDX license headers
      media: camss: Fix OF node usage
      media: camss: csiphy: Ensure clock mux config is done before the rest
      media: dt-bindings: media: qcom, camss: Unify the clock names
      media: camss: Unify the clock names
      media: camss: csiphy: Update settle count calculation
      media: camss: csid: Configure data type and decode format properly
      media: camss: vfe: Fix to_vfe() macro member name
      media: camss: vfe: Get line pointer as container of video_out
      media: camss: vfe: Do not disable CAMIF when clearing its status
      media: dt-bindings: media: qcom,camss: Fix whitespaces
      media: dt-bindings: media: qcom,camss: Add 8996 bindings
      media: camss: Add 8x96 resources
      media: camss: Add basic runtime PM support
      media: camss: csiphy: Split to hardware dependent and independent par=
ts
      media: camss: csiphy: Unify lane handling
      media: camss: csiphy: Add support for 8x96
      media: camss: csid: Add support for 8x96
      media: camss: ispif: Add support for 8x96
      media: camss: vfe: Split to hardware dependent and independent parts
      media: camss: vfe: Add support for 8x96
      media: camss: Format configuration per hardware version
      media: camss: vfe: Different format support on source pad
      media: camss: vfe: Add support for UYVY output from VFE on 8x96
      media: camss: csid: Different format support on source pad
      media: camss: csid: MIPI10 to Plain16 format conversion
      media: camss: Add support for RAW MIPI14 on 8x96
      media: camss: Add support for 10-bit grayscale formats
      media: doc: media/v4l-drivers: Update Qualcomm CAMSS driver document =
for 8x96
      media: camss: csid: Add support for events triggered by user controls

Wolfram Sang (9):
      media: platform: exynos4-is: simplify getting .drvdata
      media: platform: s5p-mfc: simplify getting .drvdata
      media: netup_unidvb: don't check number of messages in the driver
      media: tm6000: don't check number of messages in the driver
      media: dvb-usb: don't check number of messages in the driver
      media: hdpvr: don't check number of messages in the driver
      media: em28xx: don't check number of messages in the driver
      media: si4713: don't check number of messages in the driver
      media: cx231xx: don't check number of messages in the driver

Yong Zhi (1):
      media: MAINTAINERS: Update entry for Intel IPU3 cio2 driver

Zhouyang Jia (2):
      media: cx88: add error handling for snd_ctl_add
      media: tm6000: add error handling for dvb_register_adapter

kbuild test robot (3):
      media: omap2: omapfb: fix ifnullfree.cocci warnings
      media: omap2: omapfb: fix boolreturn.cocci warnings
      media: omap2: omapfb: fix bugon.cocci warnings

 .../devicetree/bindings/media/cec-gpio.txt         |   22 +-
 .../devicetree/bindings/media/i2c/ak7375.txt       |    8 +
 .../bindings/media/i2c/aptina,mt9v111.txt          |   46 +
 .../bindings/media/i2c/dongwoon,dw9807.txt         |    9 +
 .../devicetree/bindings/media/i2c/nokia,smia.txt   |    3 +
 .../devicetree/bindings/media/i2c/ov2680.txt       |   46 +
 .../devicetree/bindings/media/i2c/ov5640.txt       |    5 +
 .../devicetree/bindings/media/nvidia,tegra-vde.txt |   11 +-
 .../devicetree/bindings/media/qcom,camss.txt       |  128 +-
 .../devicetree/bindings/media/qcom,venus.txt       |    1 +
 .../devicetree/bindings/media/rcar_vin.txt         |   54 +-
 .../devicetree/bindings/media/video-interfaces.txt |    6 +
 Documentation/media/audio.h.rst.exceptions         |    3 -
 Documentation/media/media.h.rst.exceptions         |    2 +-
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   |   18 +
 Documentation/media/uapi/dvb/audio-get-pts.rst     |   65 -
 .../media/uapi/dvb/audio-set-attributes.rst        |   67 -
 Documentation/media/uapi/dvb/audio-set-ext-id.rst  |   66 -
 Documentation/media/uapi/dvb/audio-set-karaoke.rst |   66 -
 Documentation/media/uapi/dvb/audio_data_types.rst  |   37 -
 .../media/uapi/dvb/audio_function_calls.rst        |    4 -
 .../media/uapi/dvb/video-get-frame-rate.rst        |   61 -
 Documentation/media/uapi/dvb/video-get-navi.rst    |   84 --
 .../media/uapi/dvb/video-set-attributes.rst        |   93 --
 .../media/uapi/dvb/video-set-highlight.rst         |   86 --
 Documentation/media/uapi/dvb/video-set-id.rst      |   75 -
 .../media/uapi/dvb/video-set-spu-palette.rst       |   82 -
 Documentation/media/uapi/dvb/video-set-spu.rst     |   85 --
 Documentation/media/uapi/dvb/video-set-system.rst  |   77 -
 .../media/uapi/dvb/video_function_calls.rst        |    7 -
 Documentation/media/uapi/dvb/video_types.rst       |  131 --
 .../media/uapi/mediactl/media-ioc-device-info.rst  |   48 +-
 .../uapi/mediactl/media-ioc-enum-entities.rst      |   92 +-
 .../media/uapi/mediactl/media-ioc-enum-links.rst   |   72 +-
 .../media/uapi/mediactl/media-ioc-g-topology.rst   |  240 +--
 Documentation/media/uapi/mediactl/media-types.rst  |  515 ++-----
 Documentation/media/uapi/v4l/extended-controls.rst |   48 +-
 Documentation/media/uapi/v4l/pixfmt-compressed.rst |    7 +
 Documentation/media/uapi/v4l/pixfmt-rgb.rst        |    1 +
 Documentation/media/uapi/v4l/pixfmt-srggb14p.rst   |  127 ++
 Documentation/media/uapi/v4l/pixfmt-y10p.rst       |   33 +
 Documentation/media/uapi/v4l/subdev-formats.rst    |   87 +-
 Documentation/media/uapi/v4l/vidioc-enumstd.rst    |   11 +-
 Documentation/media/uapi/v4l/vidioc-g-std.rst      |   14 +-
 Documentation/media/uapi/v4l/vidioc-querystd.rst   |   11 +-
 Documentation/media/uapi/v4l/yuv-formats.rst       |    1 +
 Documentation/media/v4l-drivers/qcom_camss.rst     |   93 +-
 .../media/v4l-drivers/qcom_camss_8x96_graph.dot    |  104 ++
 Documentation/media/video.h.rst.exceptions         |    3 -
 Documentation/media/videodev2.h.rst.exceptions     |    1 -
 MAINTAINERS                                        |   96 +-
 arch/sh/boards/mach-ap325rxa/setup.c               |  282 +---
 arch/sh/boards/mach-kfr2r09/setup.c                |  217 ++-
 arch/sh/boards/mach-migor/setup.c                  |    8 +-
 arch/sh/boards/mach-se/7724/setup.c                |  120 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7723.c             |    2 +-
 drivers/firmware/qemu_fw_cfg.c                     |    1 +
 drivers/media/cec/cec-adap.c                       |   18 +-
 drivers/media/cec/cec-api.c                        |    8 +
 drivers/media/common/siano/smsdvb-debugfs.c        |   10 +-
 drivers/media/common/siano/smsdvb-main.c           |    6 +-
 drivers/media/common/siano/smsdvb.h                |    7 +-
 drivers/media/common/videobuf2/videobuf2-core.c    |    5 +
 drivers/media/dvb-core/dvb_ca_en50221.c            |    2 +-
 drivers/media/dvb-core/dvb_frontend.c              |   84 +-
 drivers/media/dvb-core/dvbdev.c                    |   18 +-
 drivers/media/dvb-frontends/Kconfig                |   10 +
 drivers/media/dvb-frontends/Makefile               |    1 +
 drivers/media/dvb-frontends/af9013.c               |    7 +-
 drivers/media/dvb-frontends/af9033.c               |    7 +-
 drivers/media/dvb-frontends/as102_fe.c             |    6 +-
 drivers/media/dvb-frontends/ascot2e.c              |    6 +-
 drivers/media/dvb-frontends/atbm8830.c             |    6 +-
 drivers/media/dvb-frontends/au8522_dig.c           |    6 +-
 drivers/media/dvb-frontends/bcm3510.c              |    6 +-
 drivers/media/dvb-frontends/cx22700.c              |    6 +-
 drivers/media/dvb-frontends/cx22702.c              |    6 +-
 drivers/media/dvb-frontends/cx24110.c              |    8 +-
 drivers/media/dvb-frontends/cx24113.c              |    8 +-
 drivers/media/dvb-frontends/cx24116.c              |    8 +-
 drivers/media/dvb-frontends/cx24117.c              |    8 +-
 drivers/media/dvb-frontends/cx24120.c              |    8 +-
 drivers/media/dvb-frontends/cx24123.c              |    8 +-
 drivers/media/dvb-frontends/cxd2820r_t.c           |    4 +-
 drivers/media/dvb-frontends/cxd2820r_t2.c          |    4 +-
 drivers/media/dvb-frontends/cxd2841er.c            |    9 +-
 drivers/media/dvb-frontends/cxd2880/cxd2880_top.c  |    6 +-
 drivers/media/dvb-frontends/dib0070.c              |    8 +-
 drivers/media/dvb-frontends/dib0090.c              |   12 +-
 drivers/media/dvb-frontends/dib3000mb.c            |    6 +-
 drivers/media/dvb-frontends/dib3000mc.c            |    6 +-
 drivers/media/dvb-frontends/dib7000m.c             |    6 +-
 drivers/media/dvb-frontends/dib7000p.c             |    6 +-
 drivers/media/dvb-frontends/dib8000.c              |    6 +-
 drivers/media/dvb-frontends/dib9000.c              |    6 +-
 drivers/media/dvb-frontends/drx39xyj/drxj.c        |   25 +-
 drivers/media/dvb-frontends/drxd_hard.c            |   13 +-
 drivers/media/dvb-frontends/drxk_hard.c            |   26 +-
 drivers/media/dvb-frontends/ds3000.c               |    8 +-
 drivers/media/dvb-frontends/dvb-pll.c              |   27 +-
 drivers/media/dvb-frontends/dvb_dummy_fe.c         |   24 +-
 drivers/media/dvb-frontends/gp8psk-fe.c            |    6 +-
 drivers/media/dvb-frontends/helene.c               |  105 +-
 drivers/media/dvb-frontends/helene.h               |    3 +
 drivers/media/dvb-frontends/horus3a.c              |    6 +-
 drivers/media/dvb-frontends/itd1000.c              |    8 +-
 drivers/media/dvb-frontends/ix2505v.c              |    8 +-
 drivers/media/dvb-frontends/l64781.c               |    7 +-
 drivers/media/dvb-frontends/lg2160.c               |   12 +-
 drivers/media/dvb-frontends/lgdt3305.c             |   12 +-
 drivers/media/dvb-frontends/lgdt3306a.c            |    6 +-
 drivers/media/dvb-frontends/lgdt330x.c             |   12 +-
 drivers/media/dvb-frontends/lgs8gl5.c              |    7 +-
 drivers/media/dvb-frontends/lgs8gxx.c              |    6 +-
 drivers/media/dvb-frontends/m88ds3103.c            |    6 +-
 drivers/media/dvb-frontends/m88rs2000.c            |    8 +-
 drivers/media/dvb-frontends/mb86a16.c              |    7 +-
 drivers/media/dvb-frontends/mb86a20s.c             |    6 +-
 drivers/media/dvb-frontends/mn88443x.c             |  802 ++++++++++
 drivers/media/dvb-frontends/mn88443x.h             |   27 +
 drivers/media/dvb-frontends/mt312.c                |   10 +-
 drivers/media/dvb-frontends/mt352.c                |    7 +-
 drivers/media/dvb-frontends/mxl5xx.c               |    6 +-
 drivers/media/dvb-frontends/nxt200x.c              |    6 +-
 drivers/media/dvb-frontends/nxt6000.c              |    6 +-
 drivers/media/dvb-frontends/or51132.c              |    6 +-
 drivers/media/dvb-frontends/or51211.c              |    8 +-
 drivers/media/dvb-frontends/rtl2830.c              |    4 +-
 drivers/media/dvb-frontends/rtl2832.c              |   10 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |    6 +-
 drivers/media/dvb-frontends/s5h1409.c              |    6 +-
 drivers/media/dvb-frontends/s5h1411.c              |    6 +-
 drivers/media/dvb-frontends/s5h1420.c              |    8 +-
 drivers/media/dvb-frontends/s5h1432.c              |    6 +-
 drivers/media/dvb-frontends/s921.c                 |    7 +-
 drivers/media/dvb-frontends/si2165.c               |    2 +-
 drivers/media/dvb-frontends/si21xx.c               |    7 +-
 drivers/media/dvb-frontends/sp8870.c               |    6 +-
 drivers/media/dvb-frontends/sp887x.c               |    6 +-
 drivers/media/dvb-frontends/stb0899_drv.c          |    6 +-
 drivers/media/dvb-frontends/stb6000.c              |    4 +-
 drivers/media/dvb-frontends/stb6100.c              |    5 +-
 drivers/media/dvb-frontends/stv0288.c              |    7 +-
 drivers/media/dvb-frontends/stv0297.c              |    6 +-
 drivers/media/dvb-frontends/stv0299.c              |    7 +-
 drivers/media/dvb-frontends/stv0367.c              |   20 +-
 drivers/media/dvb-frontends/stv0900_core.c         |    7 +-
 drivers/media/dvb-frontends/stv090x.c              |    6 +-
 drivers/media/dvb-frontends/stv0910.c              |   10 +-
 drivers/media/dvb-frontends/stv6110.c              |    6 +-
 drivers/media/dvb-frontends/stv6110x.c             |    7 +-
 drivers/media/dvb-frontends/stv6111.c              |    5 +-
 drivers/media/dvb-frontends/tc90522.c              |   10 +-
 drivers/media/dvb-frontends/tda10021.c             |   10 +-
 drivers/media/dvb-frontends/tda10023.c             |    6 +-
 drivers/media/dvb-frontends/tda10048.c             |    6 +-
 drivers/media/dvb-frontends/tda1004x.c             |   12 +-
 drivers/media/dvb-frontends/tda10071.c             |   10 +-
 drivers/media/dvb-frontends/tda10086.c             |    6 +-
 drivers/media/dvb-frontends/tda18271c2dd.c         |    7 +-
 drivers/media/dvb-frontends/tda665x.c              |    6 +-
 drivers/media/dvb-frontends/tda8083.c              |    7 +-
 drivers/media/dvb-frontends/tda8261.c              |    9 +-
 drivers/media/dvb-frontends/tda826x.c              |    4 +-
 drivers/media/dvb-frontends/ts2020.c               |    4 +-
 drivers/media/dvb-frontends/tua6100.c              |    6 +-
 drivers/media/dvb-frontends/ves1820.c              |    6 +-
 drivers/media/dvb-frontends/ves1x93.c              |    8 +-
 drivers/media/dvb-frontends/zl10036.c              |    8 +-
 drivers/media/dvb-frontends/zl10353.c              |    7 +-
 drivers/media/firewire/firedtv-fe.c                |   26 +-
 drivers/media/i2c/Kconfig                          |  115 +-
 drivers/media/i2c/Makefile                         |    5 +
 drivers/media/i2c/ad9389b.c                        |    1 +
 drivers/media/i2c/adv7180.c                        |   32 +-
 drivers/media/i2c/adv748x/adv748x-csi2.c           |    2 +-
 drivers/media/i2c/adv7511.c                        |    1 +
 drivers/media/i2c/adv7604.c                        |    8 +-
 drivers/media/i2c/adv7842.c                        |    9 +-
 drivers/media/i2c/ak7375.c                         |  292 ++++
 drivers/media/i2c/cx25840/cx25840-core.h           |   33 +-
 drivers/media/i2c/dw9807-vcm.c                     |  329 ++++
 drivers/media/i2c/et8ek8/et8ek8_driver.c           |    1 +
 drivers/media/i2c/imx258.c                         |    8 +
 drivers/media/i2c/imx274.c                         |  742 +++++----
 drivers/media/i2c/lm3560.c                         |    3 +-
 drivers/media/i2c/mt9m032.c                        |    1 +
 drivers/media/i2c/mt9p031.c                        |    1 +
 drivers/media/i2c/mt9t001.c                        |    1 +
 drivers/media/i2c/mt9v032.c                        |    1 +
 drivers/media/i2c/mt9v111.c                        | 1298 ++++++++++++++++
 drivers/media/i2c/ov2680.c                         | 1186 +++++++++++++++
 drivers/media/i2c/ov5640.c                         |  175 ++-
 drivers/media/i2c/ov5645.c                         |   13 +-
 drivers/media/i2c/ov7670.c                         |    6 +-
 drivers/media/i2c/ov772x.c                         |  353 +++--
 drivers/media/i2c/rj54n1cb0c.c                     | 1437 ++++++++++++++++=
++
 drivers/media/i2c/smiapp/smiapp-core.c             |   20 +-
 drivers/media/i2c/soc_camera/ov772x.c              |    2 +-
 drivers/media/i2c/tc358743.c                       |    5 +-
 drivers/media/i2c/tda1997x.c                       |    2 +-
 drivers/media/i2c/tvp514x.c                        |    2 +-
 drivers/media/i2c/tvp5150.c                        |    2 +-
 drivers/media/i2c/tvp7002.c                        |    2 +-
 drivers/media/i2c/video-i2c.c                      |   81 +
 drivers/media/i2c/vs6624.c                         |    4 +-
 drivers/media/media-device.c                       |   16 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |    2 +-
 drivers/media/pci/bt8xx/dst.c                      |   26 +-
 drivers/media/pci/bt8xx/dvb-bt8xx.c                |   12 +-
 drivers/media/pci/cobalt/cobalt-driver.c           |    2 +-
 drivers/media/pci/cx18/cx18-driver.c               |    2 -
 drivers/media/pci/cx23885/altera-ci.c              |    2 +-
 drivers/media/pci/cx23885/cx23885-cards.c          |   82 +-
 drivers/media/pci/cx23885/cx23885-core.c           |    2 +-
 drivers/media/pci/cx25821/cx25821-audio-upstream.c |  679 ---------
 drivers/media/pci/cx25821/cx25821-audio-upstream.h |   58 -
 drivers/media/pci/cx25821/cx25821-core.c           |    4 +-
 drivers/media/pci/cx25821/cx25821-gpio.c           |    2 +-
 drivers/media/pci/cx25821/cx25821-video-upstream.c |  673 ---------
 drivers/media/pci/cx25821/cx25821-video-upstream.h |  135 --
 drivers/media/pci/cx25821/cx25821.h                |   12 -
 drivers/media/pci/cx88/cx88-alsa.c                 |    7 +-
 drivers/media/pci/cx88/cx88-cards.c                |    4 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |   20 +-
 drivers/media/pci/ddbridge/Makefile                |    3 +-
 drivers/media/pci/ddbridge/ddbridge-core.c         |   45 +-
 drivers/media/pci/ddbridge/ddbridge-hw.c           |    3 +-
 drivers/media/pci/ddbridge/ddbridge-i2c.c          |    5 +-
 drivers/media/pci/ddbridge/ddbridge-max.c          |   18 +-
 drivers/media/pci/ddbridge/ddbridge-max.h          |    2 +-
 drivers/media/pci/ddbridge/ddbridge-mci.c          |  409 +----
 drivers/media/pci/ddbridge/ddbridge-mci.h          |  192 ++-
 drivers/media/pci/ddbridge/ddbridge-regs.h         |    8 -
 drivers/media/pci/ddbridge/ddbridge-sx8.c          |  488 ++++++
 drivers/media/pci/ddbridge/ddbridge.h              |   14 +-
 drivers/media/pci/dm1105/dm1105.c                  |    3 +
 drivers/media/pci/ivtv/ivtv-driver.c               |    2 +-
 drivers/media/pci/ivtv/ivtv-i2c.c                  |    1 +
 drivers/media/pci/ivtv/ivtvfb.c                    |    2 +-
 drivers/media/pci/mantis/mantis_vp3030.c           |    4 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c  |    5 -
 drivers/media/pci/pt1/pt1.c                        |    2 -
 drivers/media/pci/saa7164/saa7164-vbi.c            |    6 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |    7 +
 drivers/media/pci/tw686x/tw686x-video.c            |   11 +-
 drivers/media/platform/Kconfig                     |    9 +-
 drivers/media/platform/Makefile                    |    3 +-
 drivers/media/platform/atmel/atmel-isi.c           |   27 +-
 drivers/media/platform/cadence/Kconfig             |    2 +
 drivers/media/platform/cadence/cdns-csi2rx.c       |    1 +
 drivers/media/platform/cadence/cdns-csi2tx.c       |    1 +
 drivers/media/platform/cec-gpio/cec-gpio.c         |   54 +
 drivers/media/platform/coda/coda-bit.c             |  123 +-
 drivers/media/platform/coda/coda-common.c          |  189 ++-
 drivers/media/platform/coda/coda-h264.c            |  319 ++++
 drivers/media/platform/coda/coda.h                 |    4 +
 drivers/media/platform/coda/coda_regs.h            |    1 +
 drivers/media/platform/davinci/vpbe_osd.c          |    1 +
 drivers/media/platform/davinci/vpbe_venc.c         |    1 +
 drivers/media/platform/davinci/vpif_display.c      |   24 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |    2 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |   11 +-
 drivers/media/platform/exynos4-is/media-dev.c      |    6 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |    6 +-
 drivers/media/platform/fsl-viu.c                   |   38 +-
 drivers/media/platform/m2m-deinterlace.c           |   25 +-
 drivers/media/platform/meson/ao-cec.c              |    2 +-
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c    |    5 -
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c       |   25 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c |   23 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c |   16 -
 drivers/media/platform/mtk-vpu/mtk_vpu.c           |    2 +-
 drivers/media/platform/mx2_emmaprp.c               |   21 +-
 drivers/media/platform/omap/Kconfig                |    1 +
 drivers/media/platform/omap3isp/isp.c              |    6 +-
 drivers/media/platform/qcom/camss-8x16/camss-vfe.h |  123 --
 .../platform/qcom/{camss-8x16 =3D> camss}/Makefile   |    4 +
 .../qcom/{camss-8x16 =3D> camss}/camss-csid.c        |  471 ++++--
 .../qcom/{camss-8x16 =3D> camss}/camss-csid.h        |   17 +-
 .../platform/qcom/camss/camss-csiphy-2ph-1-0.c     |  176 +++
 .../platform/qcom/camss/camss-csiphy-3ph-1-0.c     |  256 ++++
 .../qcom/{camss-8x16 =3D> camss}/camss-csiphy.c      |  363 ++---
 .../qcom/{camss-8x16 =3D> camss}/camss-csiphy.h      |   37 +-
 .../qcom/{camss-8x16 =3D> camss}/camss-ispif.c       |  264 +++-
 .../qcom/{camss-8x16 =3D> camss}/camss-ispif.h       |   23 +-
 drivers/media/platform/qcom/camss/camss-vfe-4-1.c  | 1018 +++++++++++++
 drivers/media/platform/qcom/camss/camss-vfe-4-7.c  | 1140 ++++++++++++++
 .../qcom/{camss-8x16 =3D> camss}/camss-vfe.c         | 1569 +++++---------=
------
 drivers/media/platform/qcom/camss/camss-vfe.h      |  186 +++
 .../qcom/{camss-8x16 =3D> camss}/camss-video.c       |  133 +-
 .../qcom/{camss-8x16 =3D> camss}/camss-video.h       |   12 +-
 .../platform/qcom/{camss-8x16 =3D> camss}/camss.c    |  450 ++++--
 .../platform/qcom/{camss-8x16 =3D> camss}/camss.h    |   43 +-
 drivers/media/platform/qcom/venus/Makefile         |    3 +-
 drivers/media/platform/qcom/venus/core.c           |  107 ++
 drivers/media/platform/qcom/venus/core.h           |  100 +-
 drivers/media/platform/qcom/venus/helpers.c        |  568 ++++++-
 drivers/media/platform/qcom/venus/helpers.h        |   23 +-
 drivers/media/platform/qcom/venus/hfi.c            |   12 +-
 drivers/media/platform/qcom/venus/hfi.h            |   10 +
 drivers/media/platform/qcom/venus/hfi_cmds.c       |   62 +-
 drivers/media/platform/qcom/venus/hfi_helper.h     |  112 +-
 drivers/media/platform/qcom/venus/hfi_msgs.c       |  407 +----
 drivers/media/platform/qcom/venus/hfi_parser.c     |  278 ++++
 drivers/media/platform/qcom/venus/hfi_parser.h     |  110 ++
 drivers/media/platform/qcom/venus/hfi_venus.c      |  108 +-
 drivers/media/platform/qcom/venus/hfi_venus_io.h   |   10 +
 drivers/media/platform/qcom/venus/vdec.c           |  329 ++--
 drivers/media/platform/qcom/venus/vdec_ctrls.c     |   10 +-
 drivers/media/platform/qcom/venus/venc.c           |  227 +--
 drivers/media/platform/qcom/venus/venc_ctrls.c     |   10 +-
 drivers/media/platform/rcar-fcp.c                  |    6 +-
 drivers/media/platform/rcar-vin/Kconfig            |    1 +
 drivers/media/platform/rcar-vin/Makefile           |    1 +
 drivers/media/platform/rcar-vin/rcar-core.c        |  321 ++--
 drivers/media/platform/rcar-vin/rcar-csi2.c        |   20 +-
 drivers/media/platform/rcar-vin/rcar-dma.c         |   63 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c        |   18 +-
 drivers/media/platform/rcar-vin/rcar-vin.h         |   37 +-
 drivers/media/platform/rcar_drif.c                 |    8 +-
 drivers/media/platform/rcar_fdp1.c                 |    6 +-
 drivers/media/platform/rcar_jpu.c                  |   27 +-
 drivers/media/platform/renesas-ceu.c               |   91 +-
 drivers/media/platform/rockchip/rga/rga-buf.c      |   45 +-
 drivers/media/platform/rockchip/rga/rga.c          |   20 +-
 drivers/media/platform/rockchip/rga/rga.h          |    2 -
 drivers/media/platform/s3c-camif/camif-capture.c   |    4 +-
 drivers/media/platform/s5p-g2d/g2d.c               |   19 +-
 drivers/media/platform/s5p-g2d/g2d.h               |    1 -
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |    7 -
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   29 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   15 +-
 drivers/media/platform/sh_veu.c                    |    5 +-
 drivers/media/platform/sh_vou.c                    |    5 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    6 +-
 .../platform/soc_camera/soc_camera_platform.c      |    5 +-
 drivers/media/platform/sti/delta/delta-v4l2.c      |   18 -
 drivers/media/platform/sti/hva/hva-v4l2.c          |    1 +
 drivers/media/platform/stm32/stm32-dcmi.c          |  259 ++--
 drivers/media/platform/ti-vpe/vpe.c                |   20 -
 drivers/media/platform/vicodec/Kconfig             |   13 +
 drivers/media/platform/vicodec/Makefile            |    4 +
 drivers/media/platform/vicodec/vicodec-codec.c     |  797 ++++++++++
 drivers/media/platform/vicodec/vicodec-codec.h     |  129 ++
 drivers/media/platform/vicodec/vicodec-core.c      | 1506 ++++++++++++++++=
+++
 drivers/media/platform/video-mux.c                 |  119 +-
 drivers/media/platform/vim2m.c                     |   42 +-
 drivers/media/platform/vimc/vimc-core.c            |    1 -
 drivers/media/platform/vivid/vivid-ctrls.c         |    2 +-
 drivers/media/platform/vivid/vivid-kthread-cap.c   |    2 +-
 drivers/media/platform/vsp1/vsp1.h                 |    3 +
 drivers/media/platform/vsp1/vsp1_dl.c              |  433 ++++--
 drivers/media/platform/vsp1/vsp1_dl.h              |   28 +
 drivers/media/platform/vsp1/vsp1_drm.c             |    8 +-
 drivers/media/platform/vsp1/vsp1_drv.c             |   20 +-
 drivers/media/platform/vsp1/vsp1_pipe.h            |    2 +
 drivers/media/platform/vsp1/vsp1_regs.h            |    5 +-
 drivers/media/platform/vsp1/vsp1_rpf.c             |   72 +-
 drivers/media/platform/vsp1/vsp1_wpf.c             |    6 +-
 drivers/media/radio/radio-wl1273.c                 |    2 +-
 drivers/media/radio/si4713/radio-usb-si4713.c      |    3 -
 drivers/media/rc/bpf-lirc.c                        |    1 +
 drivers/media/tuners/e4000.c                       |    6 +-
 drivers/media/tuners/fc0011.c                      |    6 +-
 drivers/media/tuners/fc0012.c                      |    7 +-
 drivers/media/tuners/fc0013.c                      |    7 +-
 drivers/media/tuners/fc2580.c                      |    6 +-
 drivers/media/tuners/it913x.c                      |    6 +-
 drivers/media/tuners/m88rs6000t.c                  |    6 +-
 drivers/media/tuners/max2165.c                     |    8 +-
 drivers/media/tuners/mc44s803.c                    |    8 +-
 drivers/media/tuners/mt2060.c                      |    8 +-
 drivers/media/tuners/mt2063.c                      |    7 +-
 drivers/media/tuners/mt2131.c                      |    8 +-
 drivers/media/tuners/mt2266.c                      |    8 +-
 drivers/media/tuners/mxl301rf.c                    |    4 +-
 drivers/media/tuners/mxl5005s.c                    |    8 +-
 drivers/media/tuners/mxl5007t.c                    |    2 -
 drivers/media/tuners/qm1d1b0004.c                  |    4 +-
 drivers/media/tuners/qm1d1c0042.c                  |    4 +-
 drivers/media/tuners/qt1010.c                      |    8 +-
 drivers/media/tuners/qt1010_priv.h                 |   14 +-
 drivers/media/tuners/r820t.c                       |    6 +-
 drivers/media/tuners/si2157.c                      |    6 +-
 drivers/media/tuners/tda18212.c                    |    8 +-
 drivers/media/tuners/tda18218.c                    |    8 +-
 drivers/media/tuners/tda18250.c                    |    6 +-
 drivers/media/tuners/tda18271-fe.c                 |    6 +-
 drivers/media/tuners/tda827x.c                     |   12 +-
 drivers/media/tuners/tua9001.c                     |    6 +-
 drivers/media/tuners/tuner-simple.c                |    5 +-
 drivers/media/tuners/tuner-xc2028.c                |   15 +-
 drivers/media/tuners/xc4000.c                      |   16 +-
 drivers/media/tuners/xc5000.c                      |   12 +-
 drivers/media/usb/au0828/au0828-video.c            |    2 +-
 drivers/media/usb/cx231xx/Kconfig                  |    2 +-
 drivers/media/usb/cx231xx/cx231xx-audio.c          |   14 +-
 drivers/media/usb/cx231xx/cx231xx-core.c           |   10 +-
 drivers/media/usb/cx231xx/cx231xx-i2c.c            |    2 -
 drivers/media/usb/cx231xx/cx231xx-vbi.c            |    7 +-
 drivers/media/usb/dvb-usb-v2/Kconfig               |    5 +-
 drivers/media/usb/dvb-usb-v2/gl861.c               |  492 +++++-
 drivers/media/usb/dvb-usb-v2/gl861.h               |    1 +
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c      |    6 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c      |    6 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |    2 +-
 drivers/media/usb/dvb-usb-v2/usb_urb.c             |    4 +-
 drivers/media/usb/dvb-usb/Kconfig                  |    6 -
 drivers/media/usb/dvb-usb/Makefile                 |    3 -
 drivers/media/usb/dvb-usb/af9005-fe.c              |    6 +-
 drivers/media/usb/dvb-usb/cinergyT2-fe.c           |    6 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c        |    1 +
 drivers/media/usb/dvb-usb/dtt200u-fe.c             |    6 +-
 drivers/media/usb/dvb-usb/dw2102.c                 |   19 +-
 drivers/media/usb/dvb-usb/friio-fe.c               |   11 +-
 drivers/media/usb/dvb-usb/m920x.c                  |    3 -
 drivers/media/usb/dvb-usb/usb-urb.c                |    4 +-
 drivers/media/usb/dvb-usb/vp702x-fe.c              |    7 +-
 drivers/media/usb/dvb-usb/vp7045-fe.c              |    6 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |   39 +-
 drivers/media/usb/em28xx/em28xx-core.c             |    6 +-
 drivers/media/usb/em28xx/em28xx-dvb.c              |    4 +-
 drivers/media/usb/em28xx/em28xx-i2c.c              |    4 -
 drivers/media/usb/go7007/go7007-driver.c           |    9 +-
 drivers/media/usb/go7007/snd-go7007.c              |   11 +-
 drivers/media/usb/gspca/kinect.c                   |    2 +-
 drivers/media/usb/hackrf/hackrf.c                  |    6 +-
 drivers/media/usb/hdpvr/hdpvr-i2c.c                |    3 -
 drivers/media/usb/stk1160/stk1160-v4l.c            |    2 +-
 drivers/media/usb/tm6000/tm6000-dvb.c              |    5 +
 drivers/media/usb/tm6000/tm6000-i2c.c              |    2 -
 drivers/media/usb/ttusb-dec/ttusbdecfe.c           |   12 +-
 drivers/media/usb/usbtv/usbtv-audio.c              |    5 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |  215 ++-
 drivers/media/usb/uvc/uvc_driver.c                 |    5 +
 drivers/media/usb/uvc/uvc_status.c                 |  121 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |    4 +-
 drivers/media/usb/uvc/uvc_video.c                  |   62 +-
 drivers/media/usb/uvc/uvcvideo.h                   |   18 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |   38 +-
 drivers/media/v4l2-core/v4l2-dev.c                 |   16 +-
 drivers/media/v4l2-core/v4l2-device.c              |    3 +-
 drivers/media/v4l2-core/v4l2-fwnode.c              |    4 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |  128 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |  266 +++-
 drivers/media/v4l2-core/v4l2-subdev.c              |   22 +
 drivers/platform/x86/intel_punit_ipc.c             |    1 +
 drivers/staging/media/bcm2048/radio-bcm2048.c      |    2 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |    6 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.h    |    2 +-
 drivers/staging/media/imx/imx-ic-prpencvf.c        |    5 +
 drivers/staging/media/imx/imx-media-capture.c      |   38 +-
 drivers/staging/media/imx/imx-media-csi.c          |  112 +-
 drivers/staging/media/imx/imx-media-utils.c        |    1 +
 drivers/staging/media/imx/imx-media.h              |    2 +
 .../vc04_services/bcm2835-camera/bcm2835-camera.c  |   24 +-
 drivers/video/fbdev/omap2/omapfb/dss/core.c        |    3 +-
 .../video/fbdev/omap2/omapfb/dss/dss_features.c    |    3 +-
 drivers/video/fbdev/omap2/omapfb/omapfb-main.c     |    2 +-
 fs/compat_ioctl.c                                  |   40 -
 include/linux/platform_data/media/sii9234.h        |   24 -
 include/media/cec-pin.h                            |    4 +
 include/media/cec.h                                |   12 +-
 include/media/dvb_frontend.h                       |   49 +-
 include/media/i2c/lm3560.h                         |    1 +
 include/media/v4l2-common.h                        |    2 +-
 include/media/v4l2-ctrls.h                         |    4 +-
 include/media/v4l2-ioctl.h                         |   15 +-
 include/media/v4l2-mediabus.h                      |    2 +
 include/media/v4l2-mem2mem.h                       |   56 +-
 include/media/vsp1.h                               |    2 +
 include/uapi/linux/cec.h                           |    2 +
 include/uapi/linux/dvb/audio.h                     |   37 -
 include/uapi/linux/dvb/video.h                     |   58 -
 include/uapi/linux/media-bus-format.h              |    3 +-
 include/uapi/linux/media.h                         |   46 +-
 include/uapi/linux/uvcvideo.h                      |    2 +
 include/uapi/linux/v4l2-controls.h                 |   20 +-
 include/uapi/linux/v4l2-subdev.h                   |    4 +
 include/uapi/linux/videodev2.h                     |    8 +-
 481 files changed, 21809 insertions(+), 9375 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ak7375.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/aptina,mt9v=
111.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/dongwoon,dw=
9807.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2680.txt
 delete mode 100644 Documentation/media/uapi/dvb/audio-get-pts.rst
 delete mode 100644 Documentation/media/uapi/dvb/audio-set-attributes.rst
 delete mode 100644 Documentation/media/uapi/dvb/audio-set-ext-id.rst
 delete mode 100644 Documentation/media/uapi/dvb/audio-set-karaoke.rst
 delete mode 100644 Documentation/media/uapi/dvb/video-get-frame-rate.rst
 delete mode 100644 Documentation/media/uapi/dvb/video-get-navi.rst
 delete mode 100644 Documentation/media/uapi/dvb/video-set-attributes.rst
 delete mode 100644 Documentation/media/uapi/dvb/video-set-highlight.rst
 delete mode 100644 Documentation/media/uapi/dvb/video-set-id.rst
 delete mode 100644 Documentation/media/uapi/dvb/video-set-spu-palette.rst
 delete mode 100644 Documentation/media/uapi/dvb/video-set-spu.rst
 delete mode 100644 Documentation/media/uapi/dvb/video-set-system.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb14p.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-y10p.rst
 create mode 100644 Documentation/media/v4l-drivers/qcom_camss_8x96_graph.d=
ot
 create mode 100644 drivers/media/dvb-frontends/mn88443x.c
 create mode 100644 drivers/media/dvb-frontends/mn88443x.h
 create mode 100644 drivers/media/i2c/ak7375.c
 create mode 100644 drivers/media/i2c/dw9807-vcm.c
 create mode 100644 drivers/media/i2c/mt9v111.c
 create mode 100644 drivers/media/i2c/ov2680.c
 create mode 100644 drivers/media/i2c/rj54n1cb0c.c
 delete mode 100644 drivers/media/pci/cx25821/cx25821-audio-upstream.c
 delete mode 100644 drivers/media/pci/cx25821/cx25821-audio-upstream.h
 delete mode 100644 drivers/media/pci/cx25821/cx25821-video-upstream.c
 delete mode 100644 drivers/media/pci/cx25821/cx25821-video-upstream.h
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-sx8.c
 delete mode 100644 drivers/media/platform/qcom/camss-8x16/camss-vfe.h
 rename drivers/media/platform/qcom/{camss-8x16 =3D> camss}/Makefile (68%)
 rename drivers/media/platform/qcom/{camss-8x16 =3D> camss}/camss-csid.c (6=
9%)
 rename drivers/media/platform/qcom/{camss-8x16 =3D> camss}/camss-csid.h (7=
4%)
 create mode 100644 drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c
 create mode 100644 drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c
 rename drivers/media/platform/qcom/{camss-8x16 =3D> camss}/camss-csiphy.c =
(71%)
 rename drivers/media/platform/qcom/{camss-8x16 =3D> camss}/camss-csiphy.h =
(60%)
 rename drivers/media/platform/qcom/{camss-8x16 =3D> camss}/camss-ispif.c (=
80%)
 rename drivers/media/platform/qcom/{camss-8x16 =3D> camss}/camss-ispif.h (=
68%)
 create mode 100644 drivers/media/platform/qcom/camss/camss-vfe-4-1.c
 create mode 100644 drivers/media/platform/qcom/camss/camss-vfe-4-7.c
 rename drivers/media/platform/qcom/{camss-8x16 =3D> camss}/camss-vfe.c (54=
%)
 create mode 100644 drivers/media/platform/qcom/camss/camss-vfe.h
 rename drivers/media/platform/qcom/{camss-8x16 =3D> camss}/camss-video.c (=
81%)
 rename drivers/media/platform/qcom/{camss-8x16 =3D> camss}/camss-video.h (=
74%)
 rename drivers/media/platform/qcom/{camss-8x16 =3D> camss}/camss.c (61%)
 rename drivers/media/platform/qcom/{camss-8x16 =3D> camss}/camss.h (75%)
 create mode 100644 drivers/media/platform/qcom/venus/hfi_parser.c
 create mode 100644 drivers/media/platform/qcom/venus/hfi_parser.h
 create mode 100644 drivers/media/platform/vicodec/Kconfig
 create mode 100644 drivers/media/platform/vicodec/Makefile
 create mode 100644 drivers/media/platform/vicodec/vicodec-codec.c
 create mode 100644 drivers/media/platform/vicodec/vicodec-codec.h
 create mode 100644 drivers/media/platform/vicodec/vicodec-core.c
 delete mode 100644 include/linux/platform_data/media/sii9234.h
