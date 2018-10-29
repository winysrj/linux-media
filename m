Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53240 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729535AbeJ3FYr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 01:24:47 -0400
Date: Mon, 29 Oct 2018 17:34:24 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.20-rc1] media updates
Message-ID: <20181029173424.35da7deb@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/me=
dia/v4.20-1

For:

- New dvb frontend driver: lnbh29
- new sensor drivers: imx319 and imx 355
- Some old soc_camera driver renames to avoid conflict with new drivers;
- new i.MX Pixel Pipeline (PXP) mem-to-mem platform driver;
- a new V4L2 frontend for the FWHT codec;
- several other improvements, bug fixes, code cleanups, etc.

Thanks!
Mauro

PS.: After having this merged, I'll send another pull request with a
new experimental API for stateless codecs.

-

The following changes since commit 3799eca51c5be3cd76047a582ac52087373b54b3:

  media: camss: add missing includes (2018-08-29 14:02:06 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/me=
dia/v4.20-1

for you to fetch changes up to 3b796aa60af087f5fec75aee9b17f2130f2b9adc:

  media: rename soc_camera I2C drivers (2018-10-19 08:07:46 -0400)

----------------------------------------------------------------
media updates for v4.20-rc1

----------------------------------------------------------------
Akinobu Mita (2):
      media: ov772x: use SCCB regmap
      media: ov9650: use SCCB regmap

Alexandre GRIVEAUX (1):
      media: saa7134: add P7131_4871 analog inputs

Alexey Khoroshilov (1):
      media: ov772x: Disable clk on error path

Arnd Bergmann (8):
      media: dvb: fix compat ioctl translation
      media: dvb: dmxdev: move compat_ioctl handling to dmxdev.c
      media: cec: move compat_ioctl handling to cec-api.c
      media: dvb: move most compat_ioctl handling into drivers
      media: dvb: move compat handlers into drivers
      media: imx: work around false-positive warning, again
      media: imx-pxp: include linux/interrupt.h
      media: ov9650: avoid maybe-uninitialized warnings

Benjamin Gaignard (1):
      media: MAINTAINERS: fix reference to STI CEC driver

Biju Das (1):
      media: dt-bindings: media: rcar_vin: add device tree support for r8a7=
744

Bingbu Cao (2):
      media: add imx319 camera sensor driver
      media: add imx355 camera sensor driver

Brad Love (2):
      media: au0828: cannot kfree dev before usb disconnect
      media: au0828: Fix incorrect error messages

B=C3=A5rd Eirik Winther (2):
      media: v4l2-tpg-core: Add 16-bit bayer
      media: vivid: Add 16-bit bayer to format list

Colin Ian King (8):
      media: uvcvideo: Fix spelling mistake: "entites" -> "entities"
      media: ddbridge/sx8: remove redundant check of iq_mode =3D=3D 2
      media: zoran: fix spelling mistake "queing" -> "queuing"
      media: bttv-input: make const array addr_list static
      media: ivtv: make const array addr_list static
      media: cx23885: make const array addr_list static
      media: exynos4-is: make const array config_ids static
      media: cx231xx: fix potential sign-extension overflow on large shift

Dafna Hirschfeld (1):
      media: pvrusb2: replace `printk` with `pr_*`

Dan Carpenter (2):
      media: sr030pc30: remove NULL in sr030pc30_base_config()
      media: VPU: mediatek: don't pass an unused parameter

Daniel Graefe (1):
      media: staging: media: omap4iss: Added SPDX license identifiers

Daniel Scheller (12):
      media: mxl5xx/stv0910/stv6111/ddbridge: fix MODULE_LICENSE to 'GPL v2'
      media: ddbridge: add SPDX license identifiers
      media: ddbridge: header/boilerplate cleanups and cosmetics
      media: dvb-frontends/mxl5xx: cleanup and fix licensing boilerplates
      media: dvb-frontends/mxl5xx: add SPDX license identifier
      media: dvb-frontends/stv0910: cleanup and fix licensing boilerplates
      media: dvb-frontends/stv0910: add SPDX license identifier
      media: dvb-frontends/stv6111: cleanup and fix licensing boilerplates
      media: dvb-frontends/stv6111: add SPDX license identifier
      media: dvb-frontends/cxd2099: fix MODULE_LICENSE to 'GPL v2'
      media: dvb-frontends/cxd2099: add SPDX license identifier
      media: MAINTAINERS: mark ddbridge, stv0910, stv6111 and mxl5xx orphan

Ezequiel Garcia (2):
      media: vicodec: Drop unneeded symbol dependency
      media: vicodec: Drop unused job_abort()

Geert Uytterhoeven (1):
      media: dt-bindings: adv748x: Fix decimal unit addresses

Guennadi Liakhovetski (2):
      media: uvcvideo: Rename UVC_QUIRK_INFO to UVC_INFO_QUIRK
      media: uvcvideo: Add a D4M camera description

Guilherme Gallo (1):
      media: vimc: implement basic v4l2-ctrls

Gustavo A. R. Silva (3):
      media: uvcvideo: Remove unnecessary NULL check before debugfs_remove_=
recursive
      media: drxj: fix spelling mistake in fall-through annotations
      media: venus: helpers: use true and false for boolean values

Hans Verkuil (38):
      media: vicodec: add QP controls
      media: vicodec: add support for more pixel formats
      media: vicodec: simplify flags handling
      media: vicodec: simplify blocktype checking
      media: vicodec: improve handling of uncompressable planes
      media: vicodec: rename and use proper fwht prefix for codec
      media: vicodec: split off v4l2 specific parts for the codec
      media: vicodec: fix out-of-range values when decoding
      media: vidioc-g-dv-timings.rst: document V4L2_DV_FL_CAN_DETECT_REDUCE=
D_FPS
      media: adv7842: enable reduced fps detection
      media: staging/media/mt9t031/Kconfig: remove bogus entry
      media: mediactl/*.rst: document argp
      media: v4l2-tpg: show either Y'CbCr or HSV encoding
      media: v4l2-tpg: add Z16 support
      media: cec-func-poll.rst/func-poll.rst: update EINVAL description
      media: vicodec: fix wrong sizeimage
      media: videodev2.h.rst.exceptions: add V4L2_DV_FL_CAN_DETECT_REDUCED_=
FPS
      media: vicodec: fix sparse warning
      media: vicodec: change codec license to LGPL
      media: vidioc-cropcap/g-crop.rst: fix confusing sentence
      media: cec: make cec_get_edid_spa_location() an inline function
      media: cec: integrate cec_validate_phys_addr() in cec-api.c
      media: cec/v4l2: move V4L2 specific CEC functions to V4L2
      media: cec: remove cec-edid.c
      media: vicodec: check for valid format in v4l2_fwht_en/decode
      media: vicodec: set state->info before calling the encode/decode funcs
      media: replace ADOBERGB by OPRGB
      media: hdmi.h: rename ADOBE_RGB to OPRGB and ADOBE_YCC to OPYCC
      media: media colorspaces*.rst: rename AdobeRGB to opRGB
      media: vidioc-dqevent.rst: clarify V4L2_EVENT_SRC_CH_RESOLUTION
      media: cec-core.rst: improve cec_transmit_done documentation
      media: cec: add new tx/rx status bits to detect aborts/timeouts
      media: adv7604: when the EDID is cleared, unconfigure CEC as well
      media: adv7842: when the EDID is cleared, unconfigure CEC as well
      media: cec: fix the Signal Free Time calculation
      media: cec-gpio: select correct Signal Free Time
      media: v4l2-tpg: fix kernel oops when enabling HFLIP and OSD
      media: cec: forgot to cancel delayed work

Hugues Fruchet (9):
      media: ov5640: fix mode change regression
      media: ov5640: fix exposure regression
      media: ov5640: fix auto gain & exposure when changing mode
      media: ov5640: fix wrong binning value in exposure calculation
      media: ov5640: fix auto controls values when switching to manual mode
      media: ov5640: fix restore of last mode set
      media: ov5640: use JPEG mode 3 for 720p
      media: stm32-dcmi: only enable IT frame on JPEG capture
      media: ov5640: fix framerate update

Jacopo Mondi (10):
      media: i2c: mt9v111: Fix v4l2-ctrl error handling
      media: ov5640: Re-work MIPI startup sequence
      media: ov5640: Fix timings setup code
      media: i2c: adv748x: Support probing a single output
      media: i2c: adv748x: Handle TX[A|B] power management
      media: i2c: adv748x: Conditionally enable only CSI-2 outputs
      media: i2c: adv748x: Register only enabled inputs
      media: dt-bindings: media: renesas-ceu: Refer to video-interfaces.txt
      media: dt-bindings: media: renesas-ceu: Add more endpoint properties
      media: renesas-ceu: Use default mbus settings

Javier Martinez Canillas (2):
      media: ov2680: don't register the v4l2 subdevice before checking chip=
 ID
      media: ov2680: rename ov2680_v4l2_init() to ov2680_v4l2_register()

Jia-Ju Bai (1):
      media: pci: ivtv: Fix a sleep-in-atomic-context bug in ivtv_yuv_init()

Joe Perches (1):
      media: uvcvideo: Make some structs const

Johan Fjeldtvedt (1):
      media: vb2: check for sane values from queue_setup

Jose Abreu (3):
      media: videodev2.h: Add new DV flag CAN_DETECT_REDUCED_FPS
      media: v4l2-dv-timings: Introduce v4l2_calc_timeperframe helper
      media: cobalt: Use v4l2_calc_timeperframe helper

Katsuhiro Suzuki (1):
      media: dvb-frontends: add LNBH29 LNB supply driver

Keiichi Watanabe (1):
      media: vivid: Support 480p for webcam capture

Kieran Bingham (8):
      media: MAINTAINERS: FDP1: Update e-mail address.
      media: dt-bindings: media: adv7604: Fix slave map documentation
      media: dt-bindings: media: adv748x: Document re-mappable addresses
      media: MAINTAINERS: VSP1: Add co-maintainer
      media: vsp1: Remove artificial minimum width/height limitation
      media: vsp1: use periods at the end of comment sentences
      media: vsp1: Document max_width restriction on SRU
      media: vsp1: Document max_width restriction on UDS

Koji Matsuoka (1):
      media: vsp1: Fix YCbCr planar formats pitch calculation

Kuninori Morimoto (9):
      media: vsp1: convert to SPDX identifiers
      media: rcar-fcp: convert to SPDX identifiers
      media: adv7180: convert to SPDX identifiers
      media: adv748x: convert to SPDX identifiers
      media: drm: shmobile: convert to SPDX identifiers
      media: drm: panel-lvds: convert to SPDX identifiers
      media: fbdev: sh7760fb: convert to SPDX identifiers
      media: backlight: as3711_bl: convert to SPDX identifiers
      media: i2c: max2175: convert to SPDX identifiers

Lao Wei (1):
      media: fix: media: pci: meye: validate offset to avoid arbitrary acce=
ss

Laurent Pinchart (4):
      media: uvcvideo: Make uvc_control_mapping menu_info field const
      media: uvcvideo: Store device information pointer in struct uvc_device
      media: vsp1: Fix vsp1_regs.h license header
      media: vsp1: Update LIF buffer thresholds

Lubomir Rintel (1):
      media: ov7670: make "xclk" clock optional

Luca Ceresoli (7):
      media: imx274: rename IMX274_DEFAULT_MODE to IMX274_DEFAULT_BINNING
      media: imx274: rearrange sensor startup register tables
      media: imx274: don't hard-code the subdev name to DRIVER_NAME
      media: imx274: rename frmfmt and format to "mode"
      media: imx274: fix error in function docs
      media: imx274: add helper to read multibyte registers
      media: imx274: switch to SPDX license identifier

Lucas Stach (1):
      media: coda: don't overwrite h.264 profile_idc on decoder instance

Marco Felsch (6):
      media: tvp5150: fix width alignment during set_selection()
      media: tvp5150: fix switch exit in set control handler
      media: tvp5150: make use of regmap_update_bits
      media: v4l2-rect.h: add position and equal helpers
      media: tvp5150: add default format helper
      media: tvp5150: add g_std callback

Marek Szyprowski (1):
      media: MAINTAINERS: update videobuf2 entry

Matthias Reichl (1):
      media: rc: ir-rc6-decoder: enable toggle bit for Kathrein RCU-676 rem=
ote

Mauro Carvalho Chehab (31):
      media: use strscpy() instead of strlcpy()
      media: replace strcpy() by strscpy()
      media: mxl5xx: add a fall-trough annotation
      media: tvp5150: avoid going past array on v4l2_querymenu()
      media: em28xx: fix handler for vidioc_s_input()
      media: em28xx: use a default format if TRY_FMT fails
      media: em28xx: fix input name for Terratec AV 350
      media: em28xx: make v4l2-compliance happier by starting sequence on z=
ero
      media: v4l2: remove VBI output pad
      media: v4l2: taint pads with the signal types for consumer devices
      media: v4l2-mc: switch it to use the new approach to setup pipelines
      media: v4l2-mc: add print messages when media graph fails
      media: dvb: use signal types to discover pads
      media: au0828: use signals instead of hardcoding a pad number
      media: au8522: declare its own pads
      media: msp3400: declare its own pads
      media: saa7115: declare its own pads
      media: tvp5150: declare its own pads
      media: si2157: declare its own pads
      media: saa7134: declare its own pads
      media: mxl111sf: declare its own pads
      media: v4l2-mc: get rid of global pad indexes
      media: tvp5150: implement decoder lock when irq is not used
      media: tvp5150: get rid of some warnings
      media: v4l2-core: cleanup coding style at V4L2 async/fwnode
      media: v4l2-fwnode: cleanup functions that parse endpoints
      media: v4l2-fwnode: simplify v4l2_fwnode_reference_parse_int_props() =
call
      media: imx319: fix a few coding style issues
      media: imx355: fix a few coding style issues
      Revert "media: dvbsky: use just one mutex for serializing device R/W =
ops"
      media: rename soc_camera I2C drivers

Nadav Amit (1):
      media: uvcvideo: Fix uvc_alloc_entity() allocation alignment

Nathan Chancellor (4):
      media: bt8xx: Remove unnecessary self-assignment
      media: davinci: Fix implicit enum conversion warning
      media: pxa_camera: Fix check for pdev->dev.of_node
      media: cx18: Don't check for address of video_dev

Nicholas Mc Guire (1):
      media: pci: cx23885: handle adding to list failure

Niklas S=C3=B6derlund (3):
      media: v4l2-common: fix typo in documentation for v4l_bound_align_ima=
ge()
      media: rcar-vin: fix redeclaration of symbol
      media: i2c: adv748x: fix typo in comment for TXB CSI-2 transmitter po=
wer down

Philipp Zabel (15):
      media: dt-bindings: media: Add i.MX Pixel Pipeline binding
      media: imx-pxp: add i.MX Pixel Pipeline driver
      media: MAINTAINERS: add entry for i.MX PXP media mem2mem driver
      media: tvp5150: convert register access to regmap
      media: tvp5150: trigger autodetection on subdev open to reset cropping
      media: tvp5150: fix standard autodetection
      media: tvp5150: split reset/enable routine
      media: tvp5150: remove pin configuration from initialization tables
      media: tvp5150: Add sync lock interrupt handling
      media: tvp5150: disable output while signal not locked
      media: tvp5150: issue source change events
      media: tvp5150: add sync lock/loss signal debug messages
      media: tvp5150: add querystd
      media: imx-pxp: fix compilation on i386 or x86_64
      media: imx: use well defined 32-bit RGB pixel format

Philippe De Muyter (1):
      media: v4l2-common: v4l2_spi_subdev_init : generate unique name

Rajmohan Mani (1):
      media: dw9714: Fix error handling in probe function

Ricardo Ribalda Delgado (1):
      media: smiapp: Remove unused loop

Rob Herring (1):
      media: Convert to using %pOFn instead of device_node.name

Sakari Ailus (37):
      media: ov5670, ov13858: Use pm_runtime_idle
      media: i2c: Fix pm_runtime_get_if_in_use() usage in sensor drivers
      media: dt-bindings: dw9714, dw9807-vcm: Add files to MAINTAINERS, ren=
ame files
      media: dw9807-vcm: Remove redundant pm_runtime_set_suspended in remove
      media: v4l: subdev: Add a function to set an I=C2=B2C sub-device's na=
me
      media: smiapp: Use v4l2_i2c_subdev_set_name
      media: v4l: sr030pc30: Remove redundant setting of sub-device name
      media: v4l: i2c: Add a comment not to use static sub-device names in =
the future
      media: v4l: Remove support for crop default target in subdev drivers
      media: v4l: fwnode: Add debug prints for V4L2 endpoint property parsi=
ng
      media: v4l: fwnode: Use fwnode_graph_for_each_endpoint
      media: v4l: fwnode: The CSI-2 clock is continuous if it's not non-con=
tinuous
      media: dt-bindings: media: Specify bus type for MIPI D-PHY, others, e=
xplicitly
      media: v4l: fwnode: Add definitions for CSI-2 D-PHY, parallel and Bt.=
656 busses
      media: v4l: mediabus: Recognise CSI-2 D-PHY and C-PHY
      media: v4l: fwnode: Let the caller provide V4L2 fwnode endpoint
      media: v4l: fwnode: Detect bus type correctly
      media: v4l: fwnode: Make use of newly specified bus types
      media: v4l: fwnode: Read lane inversion information despite lane numb=
ering
      media: v4l: fwnode: Only assign configuration if there is no error
      media: v4l: fwnode: Support driver-defined lane mapping defaults
      media: v4l: fwnode: Support default CSI-2 lane mapping for drivers
      media: v4l: fwnode: Parse the graph endpoint as last
      media: v4l: fwnode: Initialise the V4L2 fwnode endpoints to zero
      media: v4l: fwnode: Only zero the struct if bus type is set to V4L2_M=
BUS_UNKNOWN
      media: v4l: fwnode: Use media bus type for bus parser selection
      media: v4l: fwnode: Use default parallel flags
      media: v4l: fwnode: Print bus type
      media: v4l: fwnode: Use V4L2 fwnode endpoint media bus type if set
      media: v4l: fwnode: Support parsing of CSI-2 C-PHY endpoints
      media: v4l: fwnode: Update V4L2 fwnode endpoint parsing documentation
      media: smiapp: Query the V4L2 endpoint for a specific bus type
      media: MAINTAINERS: Fix entry for the renamed dw9807 driver
      media: v4l: ctrl: Remove old documentation from v4l2_ctrl_grab
      media: v4l: ctrl: Provide unlocked variant of v4l2_ctrl_grab
      media: dw9714: Remove useless error message
      media: dw9807-vcm: Fix probe error handling

Sean Young (6):
      media: rc: nec keymaps should specify the nec variant they use
      media: rc: Remove init_ir_raw_event and DEFINE_IR_RAW_EVENT macros
      media: rc: some events are dropped by userspace
      media: rc: imon: report mouse events using rc-core's input device
      media: rc: mce_kbd: input events via rc-core's input device
      media: cec: name for RC passthrough device does not need 'RC for'

Sebastian Andrzej Siewior (3):
      media: em28xx-audio: use GFP_KERNEL for memory allocation during init
      media: gspca: sq930x: use GFP_KERNEL in sd_dq_callback()
      media: usbvision: remove time_in_irq

Steve Longerbeam (17):
      media: v4l2-fwnode: ignore endpoints that have no remote port parent
      media: v4l2: async: Allow searching for asd of any type
      media: v4l2: async: Add v4l2_async_notifier_add_subdev
      media: v4l2: async: Add convenience functions to allocate and add asd=
's
      media: v4l2-fwnode: Switch to v4l2_async_notifier_add_subdev
      media: v4l2-fwnode: Add a convenience function for registering subdev=
s with notifiers
      media: platform: video-mux: Register a subdev notifier
      media: imx: csi: Register a subdev notifier
      media: imx: mipi csi-2: Register a subdev notifier
      media: staging/imx: of: Remove recursive graph walk
      media: staging/imx: Loop through all registered subdevs for media lin=
ks
      media: staging/imx: Rename root notifier
      media: staging/imx: Switch to v4l2_async_notifier_add_*_subdev
      media: staging/imx: TODO: Remove one assumption about OF graph parsing
      media: platform: Switch to v4l2_async_notifier_add_subdev
      media: v4l2: async: Remove notifier subdevs array
      media: v4l2-subdev.rst: Update doc regarding subdev descriptors

Vikash Garodia (1):
      media: venus: vdec: fix decoded data size

Wenwen Wang (1):
      media: isif: fix a NULL pointer dereference bug

zhong jiang (5):
      media: ipu3-cio2: Use dma_zalloc_coherent to replace dma_alloc_cohere=
nt + memset
      media: mtk_vcodec_util: Use dma_zalloc_coherent to replace dma_alloc_=
coherent + memset
      media: coda: remove redundant null pointer check before of_node_put
      media: platform: remove redundant null pointer check before of_node_p=
ut
      media: qcom: remove duplicated include file

 .../devicetree/bindings/media/fsl-pxp.txt          |   26 +
 .../devicetree/bindings/media/i2c/adv748x.txt      |   20 +-
 .../devicetree/bindings/media/i2c/adv7604.txt      |    2 +-
 ...dongwoon,dw9807.txt =3D> dongwoon,dw9807-vcm.txt} |    0
 .../devicetree/bindings/media/rcar_vin.txt         |    1 +
 .../devicetree/bindings/media/renesas,ceu.txt      |   14 +-
 .../devicetree/bindings/media/video-interfaces.txt |    4 +-
 Documentation/media/kapi/cec-core.rst              |    4 +
 Documentation/media/kapi/v4l2-subdev.rst           |   30 +-
 Documentation/media/uapi/cec/cec-func-poll.rst     |    3 +-
 Documentation/media/uapi/cec/cec-ioc-receive.rst   |   25 +-
 .../media/uapi/mediactl/media-ioc-device-info.rst  |    1 +
 .../uapi/mediactl/media-ioc-enum-entities.rst      |    1 +
 .../media/uapi/mediactl/media-ioc-enum-links.rst   |    1 +
 .../media/uapi/mediactl/media-ioc-g-topology.rst   |    1 +
 .../media/uapi/mediactl/media-ioc-setup-link.rst   |    1 +
 Documentation/media/uapi/v4l/biblio.rst            |   10 -
 Documentation/media/uapi/v4l/colorspaces-defs.rst  |    8 +-
 .../media/uapi/v4l/colorspaces-details.rst         |   13 +-
 Documentation/media/uapi/v4l/func-poll.rst         |    3 +-
 Documentation/media/uapi/v4l/meta-formats.rst      |    1 +
 Documentation/media/uapi/v4l/pixfmt-compressed.rst |    2 +-
 Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst  |  210 ++
 Documentation/media/uapi/v4l/vidioc-cropcap.rst    |    2 +-
 Documentation/media/uapi/v4l/vidioc-dqevent.rst    |   12 +-
 Documentation/media/uapi/v4l/vidioc-g-crop.rst     |    2 +-
 .../media/uapi/v4l/vidioc-g-dv-timings.rst         |   27 +-
 Documentation/media/videodev2.h.rst.exceptions     |    7 +-
 MAINTAINERS                                        |   44 +-
 arch/arm/boot/dts/gr-peach-audiocamerashield.dtsi  |    4 -
 drivers/gpu/drm/panel/panel-lvds.c                 |    6 +-
 drivers/gpu/ipu-v3/ipu-csi.c                       |    6 +-
 drivers/hid/hid-picolcd_cir.c                      |    3 +-
 drivers/media/cec/Makefile                         |    2 +-
 drivers/media/cec/cec-adap.c                       |  107 +-
 drivers/media/cec/cec-api.c                        |   24 +-
 drivers/media/cec/cec-core.c                       |    8 +-
 drivers/media/cec/cec-edid.c                       |  155 --
 drivers/media/cec/cec-pin.c                        |   20 +
 drivers/media/common/b2c2/flexcop-i2c.c            |   12 +-
 drivers/media/common/cx2341x.c                     |    2 +-
 drivers/media/common/saa7146/saa7146_fops.c        |    2 +-
 drivers/media/common/saa7146/saa7146_video.c       |    8 +-
 drivers/media/common/siano/smscoreapi.c            |    4 +-
 drivers/media/common/siano/smsir.c                 |   10 +-
 drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c    |  262 +-
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c      |   41 +-
 drivers/media/common/videobuf2/videobuf2-core.c    |    9 +
 drivers/media/dvb-core/dmxdev.c                    |    1 +
 drivers/media/dvb-core/dvb_frontend.c              |    2 +-
 drivers/media/dvb-core/dvb_vb2.c                   |    2 +-
 drivers/media/dvb-core/dvbdev.c                    |   23 +-
 drivers/media/dvb-frontends/Kconfig                |   10 +
 drivers/media/dvb-frontends/Makefile               |    1 +
 drivers/media/dvb-frontends/au8522_decoder.c       |   10 +-
 drivers/media/dvb-frontends/au8522_priv.h          |    9 +-
 drivers/media/dvb-frontends/cx24123.c              |    2 +-
 drivers/media/dvb-frontends/cxd2099.c              |    3 +-
 drivers/media/dvb-frontends/cxd2099.h              |    1 +
 drivers/media/dvb-frontends/cxd2820r_core.c        |    2 +-
 drivers/media/dvb-frontends/dibx000_common.c       |    2 +-
 drivers/media/dvb-frontends/drx39xyj/drxj.c        |   10 +-
 drivers/media/dvb-frontends/lgdt330x.c             |    2 +-
 drivers/media/dvb-frontends/lnbh29.c               |  168 ++
 drivers/media/dvb-frontends/lnbh29.h               |   36 +
 drivers/media/dvb-frontends/m88ds3103.c            |    2 +-
 drivers/media/dvb-frontends/mt312.c                |    9 +-
 drivers/media/dvb-frontends/mxl5xx.c               |    5 +-
 drivers/media/dvb-frontends/mxl5xx.h               |   22 +
 drivers/media/dvb-frontends/mxl5xx_defs.h          |    1 +
 drivers/media/dvb-frontends/mxl5xx_regs.h          |    1 +
 drivers/media/dvb-frontends/rtl2832_sdr.c          |   10 +-
 drivers/media/dvb-frontends/s5h1420.c              |    2 +-
 drivers/media/dvb-frontends/stv0910.c              |    3 +-
 drivers/media/dvb-frontends/stv0910.h              |   18 +
 drivers/media/dvb-frontends/stv0910_regs.h         |    1 +
 drivers/media/dvb-frontends/stv6111.c              |    4 +-
 drivers/media/dvb-frontends/stv6111.h              |   16 +
 drivers/media/dvb-frontends/tc90522.c              |    2 +-
 drivers/media/dvb-frontends/ts2020.c               |    2 +-
 drivers/media/dvb-frontends/zd1301_demod.c         |    3 +-
 drivers/media/dvb-frontends/zl10039.c              |    5 +-
 drivers/media/firewire/firedtv-fe.c                |    2 +-
 drivers/media/i2c/Kconfig                          |   24 +
 drivers/media/i2c/Makefile                         |    2 +
 drivers/media/i2c/ad5820.c                         |    2 +-
 drivers/media/i2c/adv7180.c                        |   13 +-
 drivers/media/i2c/adv748x/adv748x-afe.c            |    8 +-
 drivers/media/i2c/adv748x/adv748x-core.c           |   93 +-
 drivers/media/i2c/adv748x/adv748x-csi2.c           |   35 +-
 drivers/media/i2c/adv748x/adv748x-hdmi.c           |    8 +-
 drivers/media/i2c/adv748x/adv748x.h                |   25 +-
 drivers/media/i2c/adv7511.c                        |    6 +-
 drivers/media/i2c/adv7604.c                        |   12 +-
 drivers/media/i2c/adv7842.c                        |   17 +-
 drivers/media/i2c/ak881x.c                         |    1 -
 drivers/media/i2c/cs53l32a.c                       |    2 +-
 drivers/media/i2c/cx25840/cx25840-ir.c             |    6 +-
 drivers/media/i2c/dw9714.c                         |    5 +-
 drivers/media/i2c/dw9807-vcm.c                     |    4 +-
 drivers/media/i2c/imx274.c                         |  165 +-
 drivers/media/i2c/imx319.c                         | 2560 ++++++++++++++++=
++++
 drivers/media/i2c/imx355.c                         | 1860 ++++++++++++++
 drivers/media/i2c/lm3560.c                         |    3 +-
 drivers/media/i2c/lm3646.c                         |    3 +-
 drivers/media/i2c/m5mols/m5mols_core.c             |    3 +-
 drivers/media/i2c/max2175.c                        |   12 +-
 drivers/media/i2c/max2175.h                        |   12 +-
 drivers/media/i2c/msp3400-driver.c                 |    8 +-
 drivers/media/i2c/msp3400-driver.h                 |    8 +-
 drivers/media/i2c/mt9m111.c                        |    1 -
 drivers/media/i2c/mt9t112.c                        |    6 -
 drivers/media/i2c/mt9v032.c                        |    2 +-
 drivers/media/i2c/mt9v111.c                        |   41 +-
 drivers/media/i2c/noon010pc30.c                    |    3 +-
 drivers/media/i2c/ov13858.c                        |   12 +-
 drivers/media/i2c/ov2640.c                         |    1 -
 drivers/media/i2c/ov2659.c                         |   14 +-
 drivers/media/i2c/ov2680.c                         |   16 +-
 drivers/media/i2c/ov2685.c                         |    2 +-
 drivers/media/i2c/ov5640.c                         |  309 ++-
 drivers/media/i2c/ov5645.c                         |    2 +-
 drivers/media/i2c/ov5647.c                         |    2 +-
 drivers/media/i2c/ov5670.c                         |   12 +-
 drivers/media/i2c/ov5695.c                         |    2 +-
 drivers/media/i2c/ov6650.c                         |    1 -
 drivers/media/i2c/ov7251.c                         |    4 +-
 drivers/media/i2c/ov7670.c                         |   29 +-
 drivers/media/i2c/ov772x.c                         |  194 +-
 drivers/media/i2c/ov7740.c                         |    2 +-
 drivers/media/i2c/ov9650.c                         |  161 +-
 drivers/media/i2c/rj54n1cb0c.c                     |    1 -
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |    9 +-
 drivers/media/i2c/s5k4ecgx.c                       |    3 +-
 drivers/media/i2c/s5k5baf.c                        |    6 +-
 drivers/media/i2c/s5k6aa.c                         |    5 +-
 drivers/media/i2c/saa7115.c                        |   24 +-
 drivers/media/i2c/saa7127.c                        |    4 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |   48 +-
 drivers/media/i2c/soc_camera/Makefile              |   18 +-
 .../i2c/soc_camera/{mt9m001.c =3D> soc_mt9m001.c}    |    1 -
 .../i2c/soc_camera/{mt9t112.c =3D> soc_mt9t112.c}    |    6 -
 .../i2c/soc_camera/{mt9v022.c =3D> soc_mt9v022.c}    |    1 -
 .../i2c/soc_camera/{ov5642.c =3D> soc_ov5642.c}      |    3 +-
 .../i2c/soc_camera/{ov772x.c =3D> soc_ov772x.c}      |    1 -
 .../i2c/soc_camera/{ov9640.c =3D> soc_ov9640.c}      |    1 -
 .../i2c/soc_camera/{ov9740.c =3D> soc_ov9740.c}      |    1 -
 .../soc_camera/{rj54n1cb0c.c =3D> soc_rj54n1cb0c.c}  |    1 -
 .../i2c/soc_camera/{tw9910.c =3D> soc_tw9910.c}      |    0
 drivers/media/i2c/sr030pc30.c                      |    3 +-
 drivers/media/i2c/tc358743.c                       |   34 +-
 drivers/media/i2c/tda1997x.c                       |    2 +-
 drivers/media/i2c/tvaudio.c                        |    2 +-
 drivers/media/i2c/tvp514x.c                        |    2 +-
 drivers/media/i2c/tvp5150.c                        |  560 +++--
 drivers/media/i2c/tvp5150_reg.h                    |    3 +
 drivers/media/i2c/tvp7002.c                        |    2 +-
 drivers/media/i2c/video-i2c.c                      |    8 +-
 drivers/media/media-device.c                       |   28 +-
 drivers/media/media-entity.c                       |   26 +
 drivers/media/pci/bt8xx/bttv-driver.c              |   11 +-
 drivers/media/pci/bt8xx/bttv-i2c.c                 |    6 +-
 drivers/media/pci/bt8xx/bttv-input.c               |    4 +-
 drivers/media/pci/bt8xx/dvb-bt8xx.c                |    3 +-
 drivers/media/pci/cobalt/cobalt-alsa-main.c        |    2 +-
 drivers/media/pci/cobalt/cobalt-alsa-pcm.c         |    4 +-
 drivers/media/pci/cobalt/cobalt-v4l2.c             |   23 +-
 drivers/media/pci/cx18/cx18-alsa-main.c            |    2 +-
 drivers/media/pci/cx18/cx18-alsa-pcm.c             |    2 +-
 drivers/media/pci/cx18/cx18-cards.c                |    8 +-
 drivers/media/pci/cx18/cx18-driver.c               |    4 +-
 drivers/media/pci/cx18/cx18-i2c.c                  |    2 +-
 drivers/media/pci/cx18/cx18-ioctl.c                |    8 +-
 drivers/media/pci/cx23885/altera-ci.c              |   10 +
 drivers/media/pci/cx23885/cx23885-417.c            |    8 +-
 drivers/media/pci/cx23885/cx23885-alsa.c           |    4 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |   54 +-
 drivers/media/pci/cx23885/cx23885-i2c.c            |    6 +-
 drivers/media/pci/cx23885/cx23885-ioctl.c          |    4 +-
 drivers/media/pci/cx23885/cx23885-video.c          |   15 +-
 drivers/media/pci/cx23885/cx23888-ir.c             |    6 +-
 drivers/media/pci/cx25821/cx25821-alsa.c           |    8 +-
 drivers/media/pci/cx25821/cx25821-i2c.c            |    2 +-
 drivers/media/pci/cx25821/cx25821-video.c          |   10 +-
 drivers/media/pci/cx88/cx88-alsa.c                 |    6 +-
 drivers/media/pci/cx88/cx88-blackbird.c            |    6 +-
 drivers/media/pci/cx88/cx88-cards.c                |    2 +-
 drivers/media/pci/cx88/cx88-i2c.c                  |    4 +-
 drivers/media/pci/cx88/cx88-input.c                |    7 +-
 drivers/media/pci/cx88/cx88-video.c                |   12 +-
 drivers/media/pci/cx88/cx88-vp3054-i2c.c           |    2 +-
 drivers/media/pci/ddbridge/ddbridge-ci.c           |    4 +-
 drivers/media/pci/ddbridge/ddbridge-ci.h           |    4 +-
 drivers/media/pci/ddbridge/ddbridge-core.c         |    6 +-
 drivers/media/pci/ddbridge/ddbridge-hw.c           |    2 +-
 drivers/media/pci/ddbridge/ddbridge-hw.h           |    2 +-
 drivers/media/pci/ddbridge/ddbridge-i2c.c          |    2 +-
 drivers/media/pci/ddbridge/ddbridge-i2c.h          |    4 +-
 drivers/media/pci/ddbridge/ddbridge-io.h           |    2 +-
 drivers/media/pci/ddbridge/ddbridge-main.c         |    4 +-
 drivers/media/pci/ddbridge/ddbridge-max.c          |    2 +-
 drivers/media/pci/ddbridge/ddbridge-max.h          |    2 +-
 drivers/media/pci/ddbridge/ddbridge-regs.h         |    5 +-
 drivers/media/pci/ddbridge/ddbridge-sx8.c          |    4 +-
 drivers/media/pci/ddbridge/ddbridge.h              |    5 +-
 drivers/media/pci/dm1105/dm1105.c                  |    5 +-
 drivers/media/pci/dt3155/dt3155.c                  |    8 +-
 drivers/media/pci/intel/ipu3/ipu3-cio2.c           |   30 +-
 drivers/media/pci/ivtv/ivtv-alsa-main.c            |    2 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c             |    2 +-
 drivers/media/pci/ivtv/ivtv-cards.c                |   12 +-
 drivers/media/pci/ivtv/ivtv-i2c.c                  |    6 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c                |   42 +-
 drivers/media/pci/ivtv/ivtv-streams.c              |    9 +
 drivers/media/pci/ivtv/ivtv-yuv.c                  |    2 +-
 drivers/media/pci/ivtv/ivtvfb.c                    |    2 +-
 drivers/media/pci/meye/meye.c                      |   12 +-
 drivers/media/pci/ngene/ngene-i2c.c                |    2 +-
 drivers/media/pci/pluto2/pluto2.c                  |    2 +-
 drivers/media/pci/pt1/pt1.c                        |    2 +-
 drivers/media/pci/pt3/pt3.c                        |    2 +-
 drivers/media/pci/saa7134/saa7134-alsa.c           |    8 +-
 drivers/media/pci/saa7134/saa7134-cards.c          |   15 +
 drivers/media/pci/saa7134/saa7134-core.c           |    9 +-
 drivers/media/pci/saa7134/saa7134-empress.c        |    2 +-
 drivers/media/pci/saa7134/saa7134-go7007.c         |    2 +-
 drivers/media/pci/saa7134/saa7134-i2c.c            |    2 +-
 drivers/media/pci/saa7134/saa7134-input.c          |    2 +-
 drivers/media/pci/saa7134/saa7134-video.c          |   15 +-
 drivers/media/pci/saa7134/saa7134.h                |    8 +-
 drivers/media/pci/saa7146/mxb.c                    |    2 +-
 drivers/media/pci/saa7164/saa7164-core.c           |    2 +-
 drivers/media/pci/saa7164/saa7164-dvb.c            |   10 +-
 drivers/media/pci/saa7164/saa7164-encoder.c        |   10 +-
 drivers/media/pci/saa7164/saa7164-i2c.c            |    2 +-
 drivers/media/pci/saa7164/saa7164-vbi.c            |    4 +-
 drivers/media/pci/smipcie/smipcie-main.c           |   12 +-
 drivers/media/pci/solo6x10/solo6x10-g723.c         |    8 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |   12 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         |    6 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |    6 +-
 drivers/media/pci/ttpci/av7110.c                   |    3 +-
 drivers/media/pci/ttpci/av7110_av.c                |   58 +-
 drivers/media/pci/ttpci/av7110_v4l.c               |    2 +-
 drivers/media/pci/ttpci/budget-core.c              |    6 +-
 drivers/media/pci/tw5864/tw5864-video.c            |    2 +-
 drivers/media/pci/tw68/tw68-video.c                |    6 +-
 drivers/media/pci/tw686x/tw686x-audio.c            |    8 +-
 drivers/media/pci/tw686x/tw686x-video.c            |    4 +-
 drivers/media/platform/Kconfig                     |   10 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/am437x/am437x-vpfe.c        |   93 +-
 drivers/media/platform/atmel/atmel-isc.c           |   26 +-
 drivers/media/platform/atmel/atmel-isi.c           |   29 +-
 drivers/media/platform/cadence/cdns-csi2rx.c       |   32 +-
 drivers/media/platform/cadence/cdns-csi2tx.c       |    4 +-
 drivers/media/platform/coda/coda-common.c          |   14 +-
 drivers/media/platform/davinci/isif.c              |    3 +-
 drivers/media/platform/davinci/vpbe_display.c      |   10 +-
 drivers/media/platform/davinci/vpbe_venc.c         |    2 +-
 drivers/media/platform/davinci/vpfe_capture.c      |    6 +-
 drivers/media/platform/davinci/vpif_capture.c      |   88 +-
 drivers/media/platform/davinci/vpif_display.c      |   29 +-
 drivers/media/platform/exynos-gsc/gsc-core.c       |    2 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |    4 +-
 drivers/media/platform/exynos4-is/common.c         |    4 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |    2 +-
 drivers/media/platform/exynos4-is/fimc-is-i2c.c    |    2 +-
 drivers/media/platform/exynos4-is/fimc-is.c        |    2 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |    6 +-
 drivers/media/platform/exynos4-is/media-dev.c      |   42 +-
 drivers/media/platform/exynos4-is/media-dev.h      |    1 -
 drivers/media/platform/exynos4-is/mipi-csis.c      |    2 +-
 drivers/media/platform/fsl-viu.c                   |    8 +-
 drivers/media/platform/imx-pxp.c                   | 1754 ++++++++++++++
 drivers/media/platform/imx-pxp.h                   | 1685 +++++++++++++
 drivers/media/platform/m2m-deinterlace.c           |    8 +-
 drivers/media/platform/marvell-ccic/cafe-driver.c  |    2 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |   16 +-
 drivers/media/platform/marvell-ccic/mmp-driver.c   |    4 +-
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c    |    4 +-
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c       |    6 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c |    6 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c |    6 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_util.c    |    5 +-
 drivers/media/platform/mtk-vpu/mtk_vpu.c           |    7 +-
 drivers/media/platform/mx2_emmaprp.c               |    2 +-
 drivers/media/platform/omap/omap_vout.c            |   10 +-
 drivers/media/platform/omap3isp/isp.c              |    5 +-
 drivers/media/platform/omap3isp/ispccdc.c          |    2 +-
 drivers/media/platform/omap3isp/ispccp2.c          |    2 +-
 drivers/media/platform/omap3isp/ispcsi2.c          |    2 +-
 drivers/media/platform/omap3isp/isppreview.c       |    2 +-
 drivers/media/platform/omap3isp/ispresizer.c       |    2 +-
 drivers/media/platform/omap3isp/ispvideo.c         |    8 +-
 drivers/media/platform/pxa_camera.c                |   39 +-
 drivers/media/platform/qcom/camss/camss-video.c    |    8 +-
 drivers/media/platform/qcom/camss/camss.c          |   91 +-
 drivers/media/platform/qcom/camss/camss.h          |    3 +-
 drivers/media/platform/qcom/venus/helpers.c        |    2 +-
 drivers/media/platform/qcom/venus/vdec.c           |   11 +-
 drivers/media/platform/qcom/venus/venc.c           |    8 +-
 drivers/media/platform/rcar-vin/rcar-core.c        |   11 +-
 drivers/media/platform/rcar-vin/rcar-csi2.c        |   26 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c        |    8 +-
 drivers/media/platform/rcar_drif.c                 |   22 +-
 drivers/media/platform/rcar_fdp1.c                 |    6 +-
 drivers/media/platform/rcar_jpu.c                  |   10 +-
 drivers/media/platform/renesas-ceu.c               |   78 +-
 drivers/media/platform/rockchip/rga/rga.c          |    6 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |   10 +-
 drivers/media/platform/s3c-camif/camif-core.c      |    4 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |   10 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |    6 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |    6 +-
 drivers/media/platform/sh_veu.c                    |    9 +-
 drivers/media/platform/sh_vou.c                    |   10 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    6 +-
 drivers/media/platform/soc_camera/soc_camera.c     |   43 +-
 .../platform/soc_camera/soc_camera_platform.c      |    2 +-
 drivers/media/platform/soc_camera/soc_mediabus.c   |    2 +-
 drivers/media/platform/soc_camera/soc_scale_crop.c |    2 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |    4 +-
 drivers/media/platform/sti/delta/delta-v4l2.c      |    4 +-
 drivers/media/platform/sti/hva/hva-v4l2.c          |    4 +-
 drivers/media/platform/stm32/stm32-dcmi.c          |   43 +-
 drivers/media/platform/ti-vpe/cal.c                |   61 +-
 drivers/media/platform/via-camera.c                |   10 +-
 drivers/media/platform/vicodec/Kconfig             |    2 +-
 drivers/media/platform/vicodec/Makefile            |    2 +-
 .../vicodec/{vicodec-codec.c =3D> codec-fwht.c}      |  160 +-
 .../vicodec/{vicodec-codec.h =3D> codec-fwht.h}      |   82 +-
 drivers/media/platform/vicodec/codec-v4l2-fwht.c   |  332 +++
 drivers/media/platform/vicodec/codec-v4l2-fwht.h   |   47 +
 drivers/media/platform/vicodec/vicodec-core.c      |  520 ++--
 drivers/media/platform/video-mux.c                 |   38 +-
 drivers/media/platform/vim2m.c                     |    2 +-
 drivers/media/platform/vimc/vimc-capture.c         |    6 +-
 drivers/media/platform/vimc/vimc-common.c          |    2 +-
 drivers/media/platform/vimc/vimc-core.c            |    4 +-
 drivers/media/platform/vimc/vimc-sensor.c          |   20 +
 drivers/media/platform/vivid/vivid-cec.c           |    4 +-
 drivers/media/platform/vivid/vivid-core.c          |    4 +-
 drivers/media/platform/vivid/vivid-core.h          |    2 +-
 drivers/media/platform/vivid/vivid-ctrls.c         |    6 +-
 drivers/media/platform/vivid/vivid-osd.c           |    2 +-
 drivers/media/platform/vivid/vivid-radio-common.c  |    4 +-
 drivers/media/platform/vivid/vivid-radio-rx.c      |    2 +-
 drivers/media/platform/vivid/vivid-radio-tx.c      |    2 +-
 drivers/media/platform/vivid/vivid-rds-gen.c       |    4 +-
 drivers/media/platform/vivid/vivid-sdr-cap.c       |    4 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |   11 +-
 drivers/media/platform/vivid/vivid-vid-common.c    |   30 +-
 drivers/media/platform/vivid/vivid-vid-out.c       |    2 +-
 drivers/media/platform/vsp1/vsp1_brx.c             |    4 +-
 drivers/media/platform/vsp1/vsp1_drm.c             |   11 +-
 drivers/media/platform/vsp1/vsp1_drv.c             |    8 +-
 drivers/media/platform/vsp1/vsp1_entity.c          |    2 +-
 drivers/media/platform/vsp1/vsp1_histo.c           |    4 +-
 drivers/media/platform/vsp1/vsp1_lif.c             |   29 +-
 drivers/media/platform/vsp1/vsp1_regs.h            |    2 +-
 drivers/media/platform/vsp1/vsp1_rpf.c             |    4 +-
 drivers/media/platform/vsp1/vsp1_sru.c             |    7 +-
 drivers/media/platform/vsp1/vsp1_uds.c             |   14 +-
 drivers/media/platform/vsp1/vsp1_video.c           |   13 +-
 drivers/media/platform/vsp1/vsp1_wpf.c             |    2 +-
 drivers/media/platform/xilinx/xilinx-dma.c         |   14 +-
 drivers/media/platform/xilinx/xilinx-tpg.c         |    2 +-
 drivers/media/platform/xilinx/xilinx-vipp.c        |  175 +-
 drivers/media/platform/xilinx/xilinx-vipp.h        |    4 -
 drivers/media/radio/dsbr100.c                      |    9 +-
 drivers/media/radio/radio-cadet.c                  |   12 +-
 drivers/media/radio/radio-isa.c                    |   10 +-
 drivers/media/radio/radio-keene.c                  |    8 +-
 drivers/media/radio/radio-ma901.c                  |    8 +-
 drivers/media/radio/radio-maxiradio.c              |    2 +-
 drivers/media/radio/radio-miropcm20.c              |   10 +-
 drivers/media/radio/radio-mr800.c                  |    8 +-
 drivers/media/radio/radio-raremono.c               |    8 +-
 drivers/media/radio/radio-sf16fmi.c                |   12 +-
 drivers/media/radio/radio-sf16fmr2.c               |    6 +-
 drivers/media/radio/radio-shark.c                  |    2 +-
 drivers/media/radio/radio-shark2.c                 |    2 +-
 drivers/media/radio/radio-si476x.c                 |   12 +-
 drivers/media/radio/radio-tea5764.c                |    6 +-
 drivers/media/radio/radio-tea5777.c                |   12 +-
 drivers/media/radio/radio-timb.c                   |    8 +-
 drivers/media/radio/radio-wl1273.c                 |   12 +-
 drivers/media/radio/si470x/radio-si470x-common.c   |    2 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c      |    4 +-
 drivers/media/radio/si470x/radio-si470x-usb.c      |    4 +-
 drivers/media/radio/si4713/radio-platform-si4713.c |    6 +-
 drivers/media/radio/si4713/radio-usb-si4713.c      |    6 +-
 drivers/media/radio/tea575x.c                      |   10 +-
 drivers/media/radio/tef6862.c                      |    2 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c            |   13 +-
 drivers/media/rc/ati_remote.c                      |    2 +-
 drivers/media/rc/ene_ir.c                          |   12 +-
 drivers/media/rc/fintek-cir.c                      |    3 +-
 drivers/media/rc/igorplugusb.c                     |    2 +-
 drivers/media/rc/iguanair.c                        |    4 +-
 drivers/media/rc/imon_raw.c                        |    2 +-
 drivers/media/rc/ir-hix5hd2.c                      |    2 +-
 drivers/media/rc/ir-imon-decoder.c                 |   62 +-
 drivers/media/rc/ir-mce_kbd-decoder.c              |   77 +-
 drivers/media/rc/ir-rc6-decoder.c                  |    9 +-
 drivers/media/rc/ite-cir.c                         |    5 +-
 drivers/media/rc/keymaps/rc-behold.c               |    2 +-
 drivers/media/rc/keymaps/rc-delock-61959.c         |    2 +-
 drivers/media/rc/keymaps/rc-imon-rsc.c             |    2 +-
 drivers/media/rc/keymaps/rc-it913x-v1.c            |    2 +-
 drivers/media/rc/keymaps/rc-it913x-v2.c            |    2 +-
 drivers/media/rc/keymaps/rc-msi-digivox-iii.c      |    2 +-
 drivers/media/rc/keymaps/rc-pixelview-002t.c       |    2 +-
 drivers/media/rc/keymaps/rc-pixelview-mk12.c       |    2 +-
 drivers/media/rc/keymaps/rc-reddo.c                |    2 +-
 drivers/media/rc/keymaps/rc-terratec-slim.c        |    2 +-
 drivers/media/rc/keymaps/rc-tivo.c                 |    2 +-
 drivers/media/rc/keymaps/rc-total-media-in-hand.c  |    2 +-
 drivers/media/rc/mceusb.c                          |   17 +-
 drivers/media/rc/meson-ir.c                        |    2 +-
 drivers/media/rc/mtk-cir.c                         |    2 +-
 drivers/media/rc/nuvoton-cir.c                     |    2 +-
 drivers/media/rc/rc-core-priv.h                    |   12 +-
 drivers/media/rc/rc-ir-raw.c                       |   12 +-
 drivers/media/rc/rc-loopback.c                     |    2 +-
 drivers/media/rc/rc-main.c                         |   20 +-
 drivers/media/rc/redrat3.c                         |   10 +-
 drivers/media/rc/serial_ir.c                       |   10 +-
 drivers/media/rc/sir_ir.c                          |    2 +-
 drivers/media/rc/st_rc.c                           |    5 +-
 drivers/media/rc/streamzap.c                       |   14 +-
 drivers/media/rc/sunxi-cir.c                       |    2 +-
 drivers/media/rc/ttusbir.c                         |    4 +-
 drivers/media/rc/winbond-cir.c                     |   12 +-
 drivers/media/tuners/e4000.c                       |    2 +-
 drivers/media/tuners/fc2580.c                      |    2 +-
 drivers/media/tuners/msi001.c                      |    2 +-
 drivers/media/tuners/mt20xx.c                      |    2 +-
 drivers/media/tuners/si2157.c                      |   13 +-
 drivers/media/tuners/si2157_priv.h                 |    9 +-
 drivers/media/tuners/tuner-simple.c                |    2 +-
 drivers/media/usb/airspy/airspy.c                  |   10 +-
 drivers/media/usb/au0828/au0828-core.c             |   17 +-
 drivers/media/usb/au0828/au0828-i2c.c              |    2 +-
 drivers/media/usb/au0828/au0828-input.c            |    5 +-
 drivers/media/usb/au0828/au0828-video.c            |   22 +-
 drivers/media/usb/cpia2/cpia2_v4l.c                |   12 +-
 drivers/media/usb/cx231xx/cx231xx-417.c            |    2 +-
 drivers/media/usb/cx231xx/cx231xx-audio.c          |    8 +-
 drivers/media/usb/cx231xx/cx231xx-input.c          |    2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |   29 +-
 drivers/media/usb/dvb-usb-v2/af9035.c              |    2 +-
 drivers/media/usb/dvb-usb-v2/anysee.c              |    2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        |    2 +-
 drivers/media/usb/dvb-usb-v2/dvbsky.c              |   16 +-
 drivers/media/usb/dvb-usb-v2/gl861.c               |    2 +-
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |    2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c            |    8 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.h            |    8 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |   22 +-
 drivers/media/usb/dvb-usb-v2/zd1301.c              |    2 +-
 drivers/media/usb/dvb-usb/cxusb.c                  |    4 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c        |    4 +-
 drivers/media/usb/dvb-usb/dvb-usb-i2c.c            |    2 +-
 drivers/media/usb/dvb-usb/dw2102.c                 |    4 +-
 drivers/media/usb/dvb-usb/technisat-usb2.c         |    5 +-
 drivers/media/usb/em28xx/em28xx-audio.c            |   16 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |   33 +-
 drivers/media/usb/em28xx/em28xx-i2c.c              |    3 +-
 drivers/media/usb/em28xx/em28xx-video.c            |  124 +-
 drivers/media/usb/em28xx/em28xx.h                  |    8 +-
 drivers/media/usb/go7007/go7007-driver.c           |    2 +-
 drivers/media/usb/go7007/go7007-v4l2.c             |   16 +-
 drivers/media/usb/go7007/snd-go7007.c              |    8 +-
 drivers/media/usb/gspca/gspca.c                    |   10 +-
 drivers/media/usb/gspca/sn9c20x.c                  |    2 +-
 drivers/media/usb/gspca/sq930x.c                   |    2 +-
 drivers/media/usb/hackrf/hackrf.c                  |   12 +-
 drivers/media/usb/hdpvr/hdpvr-video.c              |    9 +-
 drivers/media/usb/msi2500/msi2500.c                |    8 +-
 drivers/media/usb/pulse8-cec/pulse8-cec.c          |    3 +-
 drivers/media/usb/pvrusb2/pvrusb2-debug.h          |    2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |    8 +-
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c       |   34 +-
 drivers/media/usb/pvrusb2/pvrusb2-main.c           |    4 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           |   14 +-
 drivers/media/usb/pwc/pwc-if.c                     |    2 +-
 drivers/media/usb/pwc/pwc-v4l.c                    |   12 +-
 drivers/media/usb/rainshadow-cec/rainshadow-cec.c  |    3 +-
 drivers/media/usb/s2255/s2255drv.c                 |   10 +-
 drivers/media/usb/stk1160/stk1160-i2c.c            |    2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |    6 +-
 drivers/media/usb/stkwebcam/stk-webcam.c           |   16 +-
 drivers/media/usb/tm6000/tm6000-alsa.c             |    6 +-
 drivers/media/usb/tm6000/tm6000-i2c.c              |    4 +-
 drivers/media/usb/tm6000/tm6000-video.c            |   13 +-
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c  |    2 +-
 drivers/media/usb/usbtv/usbtv-audio.c              |    6 +-
 drivers/media/usb/usbtv/usbtv-video.c              |   14 +-
 drivers/media/usb/usbvision/usbvision-core.c       |    3 -
 drivers/media/usb/usbvision/usbvision-video.c      |   26 +-
 drivers/media/usb/usbvision/usbvision.h            |    1 -
 drivers/media/usb/uvc/uvc_ctrl.c                   |   18 +-
 drivers/media/usb/uvc/uvc_debugfs.c                |    6 +-
 drivers/media/usb/uvc/uvc_driver.c                 |   75 +-
 drivers/media/usb/uvc/uvc_entity.c                 |    2 +-
 drivers/media/usb/uvc/uvc_metadata.c               |   11 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |   10 +-
 drivers/media/usb/uvc/uvcvideo.h                   |   10 +-
 drivers/media/usb/zr364xx/zr364xx.c                |   10 +-
 drivers/media/v4l2-core/tuner-core.c               |   54 +-
 drivers/media/v4l2-core/v4l2-async.c               |  313 ++-
 drivers/media/v4l2-core/v4l2-common.c              |   25 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |   22 +-
 drivers/media/v4l2-core/v4l2-device.c              |    2 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c          |  202 +-
 drivers/media/v4l2-core/v4l2-flash-led-class.c     |    2 +-
 drivers/media/v4l2-core/v4l2-fwnode.c              |  845 ++++---
 drivers/media/v4l2-core/v4l2-ioctl.c               |    8 +-
 drivers/media/v4l2-core/v4l2-mc.c                  |  147 +-
 drivers/media/v4l2-core/v4l2-subdev.c              |    2 +-
 drivers/staging/media/bcm2048/radio-bcm2048.c      |    4 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |    2 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |    2 +-
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |    2 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |    6 +-
 .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |    3 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |    6 +-
 drivers/staging/media/imx/TODO                     |   29 +-
 drivers/staging/media/imx/imx-media-capture.c      |    4 +-
 drivers/staging/media/imx/imx-media-csi.c          |   70 +-
 drivers/staging/media/imx/imx-media-dev.c          |  149 +-
 drivers/staging/media/imx/imx-media-internal-sd.c  |    5 +-
 drivers/staging/media/imx/imx-media-of.c           |  106 +-
 drivers/staging/media/imx/imx-media-utils.c        |    4 +-
 drivers/staging/media/imx/imx-media.h              |    6 +-
 drivers/staging/media/imx/imx6-mipi-csi2.c         |   33 +-
 drivers/staging/media/imx074/imx074.c              |    3 +-
 drivers/staging/media/mt9t031/Kconfig              |    6 -
 drivers/staging/media/mt9t031/mt9t031.c            |    1 -
 drivers/staging/media/omap4iss/Kconfig             |    2 +
 drivers/staging/media/omap4iss/Makefile            |    3 +
 drivers/staging/media/omap4iss/iss.c               |    8 +-
 drivers/staging/media/omap4iss/iss.h               |    6 +-
 drivers/staging/media/omap4iss/iss_csi2.c          |    6 +-
 drivers/staging/media/omap4iss/iss_csi2.h          |    6 +-
 drivers/staging/media/omap4iss/iss_csiphy.c        |    6 +-
 drivers/staging/media/omap4iss/iss_csiphy.h        |    6 +-
 drivers/staging/media/omap4iss/iss_ipipe.c         |    8 +-
 drivers/staging/media/omap4iss/iss_ipipe.h         |    6 +-
 drivers/staging/media/omap4iss/iss_ipipeif.c       |    8 +-
 drivers/staging/media/omap4iss/iss_ipipeif.h       |    6 +-
 drivers/staging/media/omap4iss/iss_regs.h          |    6 +-
 drivers/staging/media/omap4iss/iss_resizer.c       |    8 +-
 drivers/staging/media/omap4iss/iss_resizer.h       |    6 +-
 drivers/staging/media/omap4iss/iss_video.c         |   16 +-
 drivers/staging/media/omap4iss/iss_video.h         |    6 +-
 drivers/staging/media/zoran/zoran_card.c           |    6 +-
 drivers/staging/media/zoran/zoran_driver.c         |    6 +-
 drivers/video/backlight/as3711_bl.c                |    7 +-
 drivers/video/fbdev/sh7760fb.c                     |    7 +-
 drivers/video/hdmi.c                               |    8 +-
 fs/compat_ioctl.c                                  |  131 -
 include/linux/hdmi.h                               |    4 +-
 include/linux/platform_data/shmob_drm.h            |    6 +-
 include/media/cec.h                                |  154 +-
 include/media/media-entity.h                       |   48 +
 include/media/rc-core.h                            |   11 +-
 include/media/rcar-fcp.h                           |    6 +-
 include/media/v4l2-async.h                         |  111 +-
 include/media/v4l2-common.h                        |   14 +-
 include/media/v4l2-ctrls.h                         |   26 +-
 include/media/v4l2-dv-timings.h                    |   17 +
 include/media/v4l2-fwnode.h                        |  141 +-
 include/media/v4l2-mc.h                            |   78 -
 include/media/v4l2-mediabus.h                      |   40 +-
 include/media/v4l2-rect.h                          |   26 +
 include/media/vsp1.h                               |    8 +-
 include/uapi/linux/cec.h                           |    3 +
 include/uapi/linux/videodev2.h                     |   31 +-
 582 files changed, 14618 insertions(+), 4629 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/fsl-pxp.txt
 rename Documentation/devicetree/bindings/media/i2c/{dongwoon,dw9807.txt =
=3D> dongwoon,dw9807-vcm.txt} (100%)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst
 delete mode 100644 drivers/media/cec/cec-edid.c
 create mode 100644 drivers/media/dvb-frontends/lnbh29.c
 create mode 100644 drivers/media/dvb-frontends/lnbh29.h
 create mode 100644 drivers/media/i2c/imx319.c
 create mode 100644 drivers/media/i2c/imx355.c
 rename drivers/media/i2c/soc_camera/{mt9m001.c =3D> soc_mt9m001.c} (99%)
 rename drivers/media/i2c/soc_camera/{mt9t112.c =3D> soc_mt9t112.c} (99%)
 rename drivers/media/i2c/soc_camera/{mt9v022.c =3D> soc_mt9v022.c} (99%)
 rename drivers/media/i2c/soc_camera/{ov5642.c =3D> soc_ov5642.c} (99%)
 rename drivers/media/i2c/soc_camera/{ov772x.c =3D> soc_ov772x.c} (99%)
 rename drivers/media/i2c/soc_camera/{ov9640.c =3D> soc_ov9640.c} (99%)
 rename drivers/media/i2c/soc_camera/{ov9740.c =3D> soc_ov9740.c} (99%)
 rename drivers/media/i2c/soc_camera/{rj54n1cb0c.c =3D> soc_rj54n1cb0c.c} (=
99%)
 rename drivers/media/i2c/soc_camera/{tw9910.c =3D> soc_tw9910.c} (100%)
 create mode 100644 drivers/media/platform/imx-pxp.c
 create mode 100644 drivers/media/platform/imx-pxp.h
 rename drivers/media/platform/vicodec/{vicodec-codec.c =3D> codec-fwht.c} =
(84%)
 rename drivers/media/platform/vicodec/{vicodec-codec.h =3D> codec-fwht.h} =
(63%)
 create mode 100644 drivers/media/platform/vicodec/codec-v4l2-fwht.c
 create mode 100644 drivers/media/platform/vicodec/codec-v4l2-fwht.h
