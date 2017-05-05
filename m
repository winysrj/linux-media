Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:56592
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753359AbdEENCw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 May 2017 09:02:52 -0400
Date: Fri, 5 May 2017 10:02:39 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL for v4.12-rc1] media updates
Message-ID: <20170505100239.0dc7ea49@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.12-1

For:
  - New driver to support mediatek jpeg in hardware codec;
  - rc-lirc, s5p-cec and st-cec staging drivers got promoted;
  - Hardware histogram support for vsp1 driver;
  - added Virtual Media Controller driver, to make easier to test the
    media controller;
  - added a new CEC driver (rainshadow-cec);
  - Removed two staging LIRC drivers for obscure hardware that are
    too obsolete;
  - Added support for Intel SR300 Depth camera;
  - Some improvements at CEC and RC core;
  - Lots of driver cleanups, improvements all over the tree.

With this series, we're finally getting rid of the LIRC staging
driver. There's just one left (lirc_zilog), with require more care,
as part of its functionality (IR RX) is already provided by another
driver. Work in progress to convert it on the proper way.

Thanks!
Mauro

-


The following changes since commit a71c9a1c779f2499fb2afc0553e543f18aff6edf:

  Linux 4.11-rc5 (2017-04-02 17:23:54 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.12-1

for you to fetch changes up to 3622d3e77ecef090b5111e3c5423313f11711dfa:

  [media] ov2640: print error if devm_*_optional*() fails (2017-04-25 07:08:21 -0300)

----------------------------------------------------------------
media updates for v4.12-rc1

----------------------------------------------------------------
Alexandre-Xavier Labonté-Lamoureux (1):
      [media] em28xx: Add new USB ID eb1a:5051

Alexey Khoroshilov (1):
      [media] m2m-deinterlace: don't return zero on failure paths in deinterlace_probe()

Alyssa Milburn (4):
      [media] digitv: limit messages to buffer size
      [media] zr364xx: enforce minimum size when reading header
      [media] ttusb2: limit messages to buffer size
      [media] dw2102: limit messages to buffer size

Anton Leontiev (1):
      [media] vb2: Fix queue_setup() callback description

Anton Sviridenko (1):
      [media] solo6x10: release vb2 buffers in solo_stop_streaming()

Antti Palosaari (4):
      [media] mn88472: implement signal strength statistics
      [media] mn88472: implement cnr statistics
      [media] mn88472: implement PER statistics
      [media] si2157: revert si2157: Si2141/2151 tuner support

Arnd Bergmann (7):
      [media] pvrusb2: reduce stack usage pvr2_eeprom_analyze()
      [media] cx231xx-i2c: reduce stack size in bus scan
      [media] mxl111sf: reduce stack usage in init function
      [media] tc358743: fix register i2c_rd/wr functions
      [media] coda/imx-vdoa: platform_driver should not be const
      [media] tw5864: use dev_warn instead of WARN to shut up warning
      [media] vcodec: mediatek: mark pm functions as __maybe_unused

Arushi Singhal (1):
      [media] staging: media: omap4iss: Replace a bit shift by a use of BIT

Avraham Shukron (2):
      [media] staging: omap4iss: fix multiline comment style
      [media] staging: omap4iss: fix coding style issue

Bartosz Golaszewski (3):
      [media] media: vpif: use a configurable i2c_adapter_id for vpif display
      [media] media: dt-bindings: vpif: fix whitespace errors
      [media] media: dt-bindings: vpif: extend the example with an output port

Baruch Siach (1):
      [media] doc: kapi: fix typo

Ben Hutchings (1):
      [media] dvb-usb-dibusb-mc-common: Add MODULE_LICENSE

Benjamin Gaignard (4):
      [media] sti: hdmi: add CEC notifier support
      [media] stih-cec.txt: document new hdmi phandle
      [media] stih-cec: add CEC notifier support
      [media] ARM: dts: STiH410: update sti-cec for CEC notifier support

Benoit Parrot (2):
      [media] media: ti-vpe: vpdma: add support for user specified stride
      [media] media: ti-vpe: vpe: allow use of user specified stride

Bhumika Goyal (6):
      [media] media: i2c: soc_camera: constify v4l2_subdev_* structures
      [media] b2c2: constify nxt200x_config structure
      [media] saa7134: constify nxt200x_config structures
      [media] cx88: constify mb86a16_config structure
      [media] pci: mantis: constify mb86a16_config structure
      [media] media: pci: constify stv0299_config structures

Christophe JAILLET (2):
      [media] s5p-g2d: Fix error handling
      [media] tm6000: Fix resource freeing in 'tm6000_prepare_isoc()'

Colin Ian King (5):
      [media] atmel-isc: fix off-by-one comparison and out of bounds read issue
      [media] usb: au0828: remove redundant code
      [media] coda: remove redundant call to v4l2_m2m_get_vq
      [media] Staging: media/lirc: don't call put_ir_rx on rx twice
      [media] xc5000: fix spelling mistake: "calibration"

Daniel Patrick Johnson (1):
      [media] uvcvideo: Add support for Intel SR300 depth camera

Daniel Scheller (2):
      [media] dvb-frontends/drxk: don't log errors on unsupported operation mode
      [media] dvb-frontends/cxd2841er: define symbol_rate_min/max in T/C fe-ops

Derek Robson (1):
      [media] staging: lirc: use octal instead of symbolic permission

Dmitry Torokhov (2):
      [media] ad5820: remove incorrect __exit markups
      [media] Staging: media: radio-bcm2048: remove incorrect __exit markups

Elena Reshetova (2):
      [media] cx88: convert struct cx88_core.refcount from atomic_t to refcount_t
      [media] vb2: convert vb2_vmarea_handler refcount from atomic_t to refcount_t

Evgeni Raikhel (1):
      [media] Documentation: Intel SR300 Depth camera INZI format

Evgeny Plehov (3):
      [media] si2168: Si2168-D60 support
      [media] si2157: Si2141/2151 tuner support
      [media] dvb-usb-cxusb: Geniatech T230C support

Ezequiel Garcia (1):
      [media] media: stk1160: Add Kconfig help on snd-usb-audio requirement

Fengguang Wu (1):
      [media] vcodec: mediatek: fix platform_no_drv_owner.cocci warnings

Frank Schaefer (14):
      [media] em28xx: reduce stack usage in sensor probing functions
      [media] em28xx: simplify ID-reading from Micron sensors
      [media] em28xx: get rid of the dummy clock source
      [media] em28xx: add missing auto-selections for build
      [media] em28xx: don't treat device as webcam if an unknown sensor is detected
      [media] em28xx: shed some light on video input formats
      [media] em28xx: add support for V4L2_PIX_FMT_SRGGB8
      [media] ov2640: fix init sequence alignment
      [media] ov2640: improve banding filter register definitions/documentation
      [media] ov2640: add information about DSP register 0xc7
      [media] ov2640: add missing write to size change preamble
      [media] ov2640: fix duplicate width+height returning from ov2640_select_win()
      [media] ov2640: fix vflip control
      [media] ov2640: add support for MEDIA_BUS_FMT_YVYU8_2X8 and MEDIA_BUS_FMT_VYUY8_2X8

Geert Uytterhoeven (1):
      MAINTAINERS: Add file patterns for media device tree bindings

Geliang Tang (13):
      [media] sh_mobile_ceu_camera: use module_platform_driver
      [media] ivtv: use for_each_sg
      [media] saa7134: use setup_timer
      [media] saa7146: use setup_timer
      [media] bt8xx: use setup_timer
      [media] cx18: use setup_timer
      [media] ivtv: use setup_timer
      [media] netup_unidvb: use setup_timer
      [media] av7110: use setup_timer
      [media] fsl-viu: use setup_timer
      [media] c8sectpfe: use setup_timer
      [media] wl128x: use setup_timer
      [media] imon: use setup_timer

Gustavo A. R. Silva (2):
      [media] media: pci: saa7164: remove unnecessary code
      [media] media: pci: saa7164: remove dead code

Gustavo Padovan (6):
      [media] vb2: only check ret if we assigned it
      [media] ivtv: improve subscribe_event handling
      [media] solo6x10: improve subscribe event handling
      [media] tw5864: improve subscribe event handling
      [media] vivid: improve subscribe event handling
      [media] go7007: improve subscribe event handling

Hans Verkuil (64):
      [media] cec.h: small typo fix
      [media] vidioc-g-dv-timings.rst: update v4l2_bt_timings struct
      [media] videodev2.h: map xvYCC601/709 to limited range quantization
      [media] vivid: fix try_fmt behavior
      [media] cec: documentation fixes
      [media] cec: improve flushing queue
      [media] cec: allow specific messages even when unconfigured
      [media] cec: return -EPERM when no LAs are configured
      [media] cec: document the error codes
      [media] cec: document the special unconfigured case
      [media] cec: use __func__ in log messages
      [media] cec: improve cec_transmit_msg_fh logging
      [media] cec: log reason for returning -EINVAL
      [media] cec: don't Feature Abort msgs from Unregistered
      [media] vivid: fix g_edid implementation
      [media] cec-core.rst: document the new cec_get_drvdata() helper
      [media] video.rst: a sensor is also considered to be a physical input
      [media] v4l2-compat-ioctl32: VIDIOC_S_EDID should return all fields on error
      [media] vidioc-enumin/output.rst: improve documentation
      [media] v4l2-ctrls.c: fix RGB quantization range control menu
      [media] ov7670: document device tree bindings
      [media] ov7670: call v4l2_async_register_subdev
      [media] ov7670: fix g/s_parm
      [media] ov7670: get xclk
      [media] ov7670: add devicetree support
      [media] atmel-isi: update device tree bindings documentation
      [media] atmel-isi: remove dependency of the soc-camera framework
      [media] atmel-isi: move out of soc_camera to atmel
      [media] ov2640: fix colorspace handling
      [media] ov2640: update bindings
      [media] MAINTAINERS: update atmel-isi.c path
      [media] dev-capture.rst/dev-output.rst: video standards ioctls are optional
      [media] serio.h: add SERIO_RAINSHADOW_CEC ID
      [media] rainshadow-cec: new RainShadow Tech HDMI CEC driver
      [media] media: add CEC notifier support
      [media] cec: integrate CEC notifier support
      [media] exynos_hdmi: add CEC notifier support
      [media] ARM: dts: exynos: add HDMI controller phandle to exynos4.dtsi
      [media] s5p-cec.txt: document the HDMI controller phandle
      [media] s5p-cec: add cec-notifier support, move out of staging
      [media] cec: fix confusing CEC_CAP_RC and IS_REACHABLE(CONFIG_RC_CORE) code
      [media] ov2640: convert from soc-camera to a standard subdev sensor driver
      [media] ov2640: use standard clk and enable it
      [media] ov2640: add MC support
      [media] em28xx: drop last soc_camera link
      [media] videodev2.h: fix outdated comment
      [media] v4l2-tpg: don't clamp XV601/709 to lim range
      [media] imx074: avoid calling imx074_find_datafmt() twice
      [media] mt9m001: avoid calling mt9m001_find_datafmt() twice
      [media] mt9v022: avoid calling mt9v022_find_datafmt() twice
      [media] ov5642: avoid calling ov5642_find_datafmt() twice
      [media] ov772x: avoid calling ov772x_select_params() twice
      [media] ov9640: avoid calling ov9640_res_roundup() twice
      [media] ov9740: avoid calling ov9740_res_roundup() twice
      [media] ov2640: avoid calling ov2640_select_win() twice
      [media] vidioc-queryctrl.rst: document V4L2_CTRL_FLAG_MODIFY_LAYOUT
      [media] videodev.h: add V4L2_CTRL_FLAG_MODIFY_LAYOUT
      [media] v4l2-ctrls.c: set V4L2_CTRL_FLAG_MODIFY_LAYOUT for ROTATE
      [media] buffer.rst: clarify how V4L2_CTRL_FLAG_MODIFY_LAYOUT/GRABBER are used
      [media] vsp1: set V4L2_CTRL_FLAG_MODIFY_LAYOUT for histogram controls
      [media] cec: Kconfig cleanup
      [media] cec.h: merge cec-edid.h into cec.h
      [media] cec: add MEDIA_CEC_RC config option
      [media] subdev-formats.rst: remove spurious '-'

Helen Fornazier (1):
      [media] media-entity: only call dev_dbg_obj if mdev is not NULL

Helen Koike (1):
      [media] vimc: Virtual Media Controller core, capture and sensor

Hugues Fruchet (1):
      [media] st-delta: mjpeg: fix static checker warning

Janusz Krzysztofik (1):
      [media] media: i2c/soc_camera: fix ov6650 sensor getting wrong clock

Jasmin J (1):
      [media] media/dvb-core: Race condition when writing to CAM

Javier Martinez Canillas (5):
      [media] et8ek8: Export OF device ID as module aliases
      [media] si4713: Add OF device ID table
      [media] soc-camera: ov5642: Add OF device ID table
      [media] et8ek8: Export OF device ID as module aliases
      [media] tc358743: Add OF device ID table

Joe Perches (1):
      [media] drivers/media: Convert remaining use of pr_warning to pr_warn

Johan Hovold (7):
      [media] mceusb: fix NULL-deref at probe
      [media] gspca: konica: add missing endpoint sanity check
      [media] dib0700: fix NULL-deref at probe
      [media] usbvision: fix NULL-deref at probe
      [media] cx231xx-cards: fix NULL-deref at probe
      [media] cx231xx-audio: fix init error path
      [media] cx231xx-audio: fix NULL-deref at probe

Jose Abreu (8):
      [media] cec: Add cec_get_drvdata()
      [media] staging: st-cec: Use cec_get_drvdata()
      [media] staging: s5p-cec: Use cec_get_drvdata()
      [media] i2c: adv7511: Use cec_get_drvdata()
      [media] i2c: adv7604: Use cec_get_drvdata()
      [media] i2c: adv7842: Use cec_get_drvdata()
      [media] usb: pulse8-cec: Use cec_get_drvdata()
      [media] platform: vivid: Use cec_get_drvdata()

Kieran Bingham (7):
      [media] uvcvideo: Fix empty packet statistic
      [media] uvcvideo: Don't record timespec_sub
      [media] v4l: vsp1: Fix format-info documentation
      [media] v4l: vsp1: Prevent multiple streamon race commencing pipeline early
      [media] v4l: vsp1: Remove redundant pipe->dl usage from drm
      [media] v4l: vsp1: Fix struct vsp1_drm documentation
      [media] v4l: vsp1: Register pipe with output WPF

Koji Matsuoka (1):
      [media] soc-camera: fix rectangle adjustment in cropping

Laurent Pinchart (12):
      [media] v4l: soc-camera: Remove videobuf1 support
      [media] v4l: vsp1: Fix RPF/WPF U/V order in 3-planar formats on Gen3
      [media] v4l: vsp1: Fix multi-line comment style
      [media] v4l: vsp1: Disable HSV formats on Gen3 hardware
      [media] v4l: Clearly document interactions between formats, controls and buffers
      [media] v4l: vsp1: wpf: Implement rotation support
      [media] v4l: Add metadata buffer type and format
      [media] v4l: vsp1: Add histogram support
      [media] v4l: vsp1: Support histogram generators in pipeline configuration
      [media] v4l: vsp1: Fix HGO and HGT routing register addresses
      [media] v4l: Define a pixel format for the R-Car VSP1 1-D histogram engine
      [media] v4l: vsp1: Add HGO support

Lee Jones (1):
      [media] cec: Fix runtime BUG when (CONFIG_RC_CORE && !CEC_CAP_RC)

Lucas Stach (1):
      [media] coda: bump maximum number of internal framebuffers to 17

Marek Szyprowski (19):
      [media] s5p-mfc: Fix initialization of internal structures
      [media] s5p-mfc: Fix race between interrupt routine and device functions
      [media] s5p-mfc: Remove unused structures and dead code
      [media] s5p-mfc: Use generic of_device_get_match_data helper
      [media] s5p-mfc: Replace mem_dev_* entries with an array
      [media] s5p-mfc: Replace bank1/bank2 entries with an array
      [media] s5p-mfc: Simplify alloc/release private buffer functions
      [media] s5p-mfc: Move setting DMA max segment size to DMA configure function
      [media] s5p-mfc: Put firmware to private buffer structure
      [media] s5p-mfc: Move firmware allocation to DMA configure function
      [media] s5p-mfc: Allocate firmware with internal private buffer alloc function
      [media] s5p-mfc: Reduce firmware buffer size for MFC v6+ variants
      [media] s5p-mfc: Split variant DMA memory configuration into separate functions
      [media] s5p-mfc: Add support for probe-time preallocated block based allocator
      [media] s5p-mfc: Remove special configuration of IOMMU domain
      [media] s5p-mfc: Use preallocated block allocator always for MFC v6+
      [media] s5p-mfc: Rename BANK1/2 to BANK_L/R to better match documentation
      [media] s5p-mfc: Fix unbalanced call to clock management
      [media] s5p-mfc: Don't allocate codec buffers from pre-allocated region

Matthias Kaehlcke (1):
      [media] vcodec: mediatek: Remove double parentheses

Mauro Carvalho Chehab (14):
      Merge tag 'v4.10' into patchwork
      [media] tveeprom: get rid of unused arg on tveeprom_hauppauge_analog()
      Merge tag 'v4.11-rc1' into patchwork
      [media] coda: get rid of unused var
      [media] platform: compile VIDEO_CODA with COMPILE_TEST
      [media] coda: fix warnings when compiling with 64 bits
      Merge tag 'v4.11-rc5' into patchwork
      [media] dvb_frontend: add kernel-doc tag for a missing parameter
      [media] tveeprom: get rid of documentation of an unused parameter
      [media] mtk-vcodec: avoid warnings because of empty macros
      [media] pixfmt-meta-vsp1-hgo.rst: remove spurious '-'
      [media] vidioc-queryctrl.rst: fix menu/int menu references
      [media] ov2640: make GPIOLIB an optional dependency
      [media] ov2640: print error if devm_*_optional*() fails

Michael Tretter (1):
      [media] coda: Use && instead of & for non-bitfield conditions

Minghsiu Tsai (2):
      [media] media: mtk-jpeg: fix continuous log "Context is NULL"
      [media] media: mtk-vcodec: remove informative log

Niklas Söderlund (2):
      [media] v4l: Define a pixel format for the R-Car VSP1 2-D histogram engine
      [media] v4l: vsp1: Add HGT support

Nikola Jelic (1):
      [media] media: bcm2048: fix several macros

Philipp Zabel (12):
      [media] tc358743: put lanes in STOP state before starting streaming
      [media] coda: implement encoder stop command
      [media] coda: disable BWB for all codecs on CODA 960
      [media] coda: keep queued buffers on a temporary list during start_streaming
      [media] coda: pad first h.264 buffer to 512 bytes
      [media] coda: disable reordering for baseline profile h.264 streams
      [media] coda: restore original firmware locations
      [media] st_rc: simplify optional reset handling
      [media] rc: sunxi-cir: simplify optional reset handling
      [media] tvp5150: allow get/set_fmt on the video source pad
      [media] tvp5150: fix pad format frame height
      [media] coda: do not enumerate YUYV if VDOA is not available

Ramiro Oliveira (2):
      [media] Documentation: DT: Add OV5647 bindings
      [media] media: i2c: Add support for OV5647 sensor

Randy Dunlap (1):
      [media] media/platform/mtk-jpeg: add slab.h to fix build errors

Rick Chang (3):
      [media] dt-bindings: mediatek: Add a binding for Mediatek JPEG Decoder
      [media] vcodec: mediatek: Add Mediatek JPEG Decoder Driver
      [media] vcodec: mediatek: Add Maintainers entry for Mediatek JPEG driver

Sakari Ailus (4):
      [media] docs-rst: media: Explicitly refer to sub-sampling in scaling documentation
      [media] docs-rst: media: Push CEC documentation under CEC section
      [media] docs-rst: Make the CSI-2 bus initialisation documentation match reality
      [media] docs-rst: media: better document refcount in struct dvb_frontend

Sean Young (19):
      [media] cxusb: dvico remotes are nec
      [media] lirc: document lirc modes better
      [media] lirc: return ENOTTY when ioctl is not supported
      [media] lirc: return ENOTTY when device does support ioctl
      [media] winbond: allow timeout to be set
      [media] gpio-ir: do not allow a timeout of 0
      [media] rc: lirc keymap no longer makes any sense
      [media] lirc: advertise LIRC_CAN_GET_REC_RESOLUTION and improve
      [media] mce_kbd: add encoder
      [media] serial_ir: iommap is a memory address, not bool
      [media] lirc: use refcounting for lirc devices
      [media] staging: sir: fill in missing fields and fix probe
      [media] staging: sir: remove unselectable Tekram and Actisys
      [media] staging: sir: fix checkpatch strict warnings
      [media] staging: sir: use usleep_range() rather than busy looping
      [media] staging: sir: remove unnecessary messages
      [media] staging: sir: make sure we are ready to receive interrupts
      [media] rc: promote lirc_sir out of staging
      [media] staging: lirc_sasem: remove

Sebastian Reichel (1):
      [media] v4l: Allow calling v4l2_device_register_subdev_nodes() multiple times

Shailendra Verma (2):
      [media] bdisp: Clean up file handle in open() error path
      [media] v4l: vsp1: Clean up file handle in open() error path

Shilpa P (1):
      [media] staging: Replaced BUG_ON with warnings

Shuah Khan (2):
      [media] s5p_mfc: Remove unneeded io_modes initialization in s5p_mfc_open()
      [media] s5p-mfc: Print buf pointer in hex constistently

Songjun Wu (2):
      [media] atmel-isc: add the isc pipeline function
      [media] atmel-isc: Fix the static checker warning

Stefan Brüns (2):
      [media] dvb-usb-firmware: don't do DMA on stack
      [media] si2157: Add support for Si2141-A10

Thibault Saunier (2):
      [media] exynos-gsc: Do not swap cb/cr for semi planar formats
      [media] exynos-gsc: Add support for NV{16,21,61}M pixel formats

Todor Tomov (2):
      [media] media: i2c/ov5645: add the device tree binding document
      [media] media: Add a driver for the ov5645 camera sensor

Vincent ABRIOU (1):
      [media] vivid: support for contiguous DMA buffers

Wei Yongjun (1):
      [media] mtk-vcodec: remove redundant return value check of platform_get_resource()

Wu-Cheng Li (1):
      [media] mtk-vcodec: check the vp9 decoder buffer index from VPU

simran singhal (1):
      [media] staging: lirc_zilog: Clean up tests if NULL returned on failure

 .../devicetree/bindings/media/atmel-isi.txt        |   91 +-
 .../devicetree/bindings/media/i2c/ov2640.txt       |   23 +-
 .../devicetree/bindings/media/i2c/ov5645.txt       |   54 +
 .../devicetree/bindings/media/i2c/ov5647.txt       |   35 +
 .../devicetree/bindings/media/i2c/ov7670.txt       |   43 +
 .../bindings/media/mediatek-jpeg-decoder.txt       |   37 +
 .../devicetree/bindings/media/s5p-cec.txt          |    2 +
 .../devicetree/bindings/media/s5p-mfc.txt          |    2 +-
 .../devicetree/bindings/media/stih-cec.txt         |    2 +
 .../devicetree/bindings/media/ti,da850-vpif.txt    |   50 +-
 Documentation/media/kapi/cec-core.rst              |   12 +-
 Documentation/media/kapi/csi2.rst                  |    9 +-
 Documentation/media/kapi/v4l2-core.rst             |    2 +-
 Documentation/media/lirc.h.rst.exceptions          |    1 -
 Documentation/media/uapi/cec/cec-func-ioctl.rst    |    2 +-
 Documentation/media/uapi/cec/cec-func-open.rst     |    2 +-
 Documentation/media/uapi/cec/cec-func-poll.rst     |    4 +-
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    |   13 +
 .../media/uapi/cec/cec-ioc-adap-g-phys-addr.rst    |   13 +
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   |   13 +-
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst    |   12 +
 Documentation/media/uapi/cec/cec-ioc-receive.rst   |   55 +-
 Documentation/media/uapi/mediactl/media-types.rst  |    3 +-
 Documentation/media/uapi/rc/lirc-dev-intro.rst     |   53 +-
 Documentation/media/uapi/rc/lirc-get-features.rst  |   13 +-
 Documentation/media/uapi/rc/lirc-get-length.rst    |    3 +-
 Documentation/media/uapi/rc/lirc-get-rec-mode.rst  |    4 +-
 Documentation/media/uapi/rc/lirc-get-send-mode.rst |    7 +-
 Documentation/media/uapi/rc/lirc-read.rst          |   16 +-
 .../media/uapi/rc/lirc-set-rec-carrier-range.rst   |    2 +-
 .../media/uapi/rc/lirc-set-rec-timeout-reports.rst |    2 +
 Documentation/media/uapi/rc/lirc-write.rst         |   17 +-
 Documentation/media/uapi/v4l/buffer.rst            |  122 ++
 Documentation/media/uapi/v4l/depth-formats.rst     |    1 +
 Documentation/media/uapi/v4l/dev-capture.rst       |    4 +-
 Documentation/media/uapi/v4l/dev-meta.rst          |   58 +
 Documentation/media/uapi/v4l/dev-output.rst        |    4 +-
 Documentation/media/uapi/v4l/devices.rst           |    1 +
 Documentation/media/uapi/v4l/meta-formats.rst      |   16 +
 Documentation/media/uapi/v4l/pixfmt-007.rst        |   13 +-
 Documentation/media/uapi/v4l/pixfmt-inzi.rst       |   81 ++
 .../media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst        |  168 +++
 .../media/uapi/v4l/pixfmt-meta-vsp1-hgt.rst        |  120 ++
 Documentation/media/uapi/v4l/pixfmt.rst            |    1 +
 Documentation/media/uapi/v4l/subdev-formats.rst    |  240 ++--
 Documentation/media/uapi/v4l/video.rst             |    7 +-
 Documentation/media/uapi/v4l/vidioc-enuminput.rst  |   11 +-
 Documentation/media/uapi/v4l/vidioc-enumoutput.rst |   15 +-
 .../media/uapi/v4l/vidioc-g-dv-timings.rst         |   16 +-
 Documentation/media/uapi/v4l/vidioc-querycap.rst   |    3 +
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |   17 +-
 Documentation/media/v4l-drivers/vivid.rst          |    8 +
 Documentation/media/videodev2.h.rst.exceptions     |    3 +
 MAINTAINERS                                        |   38 +-
 arch/arm/boot/dts/exynos4.dtsi                     |    1 +
 arch/arm/boot/dts/stih407-family.dtsi              |   12 -
 arch/arm/boot/dts/stih410.dtsi                     |   13 +
 arch/arm/mach-davinci/board-da850-evm.c            |    1 +
 drivers/gpu/drm/exynos/exynos_hdmi.c               |   19 +-
 drivers/gpu/drm/sti/sti_hdmi.c                     |   11 +
 drivers/gpu/drm/sti/sti_hdmi.h                     |    3 +
 drivers/media/Kconfig                              |   22 +-
 drivers/media/Makefile                             |   10 +-
 drivers/media/cec/Kconfig                          |   19 +
 drivers/media/cec/Makefile                         |    8 +-
 drivers/media/cec/cec-adap.c                       |  141 +-
 drivers/media/cec/cec-api.c                        |   21 +-
 drivers/media/cec/cec-core.c                       |   40 +-
 drivers/media/{ => cec}/cec-edid.c                 |    6 +-
 drivers/media/cec/cec-notifier.c                   |  130 ++
 drivers/media/common/b2c2/flexcop-fe-tuner.c       |    2 +-
 drivers/media/common/saa7146/saa7146_vbi.c         |    5 +-
 drivers/media/common/saa7146/saa7146_video.c       |    5 +-
 drivers/media/common/tveeprom.c                    |    4 +-
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c      |    9 +-
 drivers/media/dvb-core/dvb_ca_en50221.c            |   23 +
 drivers/media/dvb-core/dvb_frontend.h              |    2 +
 drivers/media/dvb-frontends/cxd2841er.c            |    4 +-
 drivers/media/dvb-frontends/drxk_hard.c            |    4 +-
 drivers/media/dvb-frontends/mn88472.c              |  134 +-
 drivers/media/dvb-frontends/mn88472_priv.h         |    1 +
 drivers/media/dvb-frontends/si2168.c               |    4 +
 drivers/media/dvb-frontends/si2168_priv.h          |    2 +
 drivers/media/i2c/Kconfig                          |   43 +-
 drivers/media/i2c/Makefile                         |    3 +
 drivers/media/i2c/ad5820.c                         |    4 +-
 drivers/media/i2c/adv7511.c                        |    6 +-
 drivers/media/i2c/adv7604.c                        |    6 +-
 drivers/media/i2c/adv7842.c                        |    6 +-
 drivers/media/i2c/et8ek8/et8ek8_driver.c           |    2 +
 drivers/media/i2c/{soc_camera => }/ov2640.c        |  291 +++--
 drivers/media/i2c/ov5645.c                         | 1345 +++++++++++++++++++
 drivers/media/i2c/ov5647.c                         |  634 +++++++++
 drivers/media/i2c/ov7670.c                         |   75 +-
 drivers/media/i2c/soc_camera/Kconfig               |    6 -
 drivers/media/i2c/soc_camera/Makefile              |    1 -
 drivers/media/i2c/soc_camera/imx074.c              |    8 +-
 drivers/media/i2c/soc_camera/mt9m001.c             |   14 +-
 drivers/media/i2c/soc_camera/mt9t031.c             |    6 +-
 drivers/media/i2c/soc_camera/mt9t112.c             |    6 +-
 drivers/media/i2c/soc_camera/mt9v022.c             |   14 +-
 drivers/media/i2c/soc_camera/ov5642.c              |   17 +-
 drivers/media/i2c/soc_camera/ov6650.c              |    8 +-
 drivers/media/i2c/soc_camera/ov772x.c              |   47 +-
 drivers/media/i2c/soc_camera/ov9640.c              |   30 +-
 drivers/media/i2c/soc_camera/ov9740.c              |   24 +-
 drivers/media/i2c/soc_camera/rj54n1cb0c.c          |    6 +-
 drivers/media/i2c/soc_camera/tw9910.c              |    6 +-
 drivers/media/i2c/tc358743.c                       |   59 +-
 drivers/media/i2c/tvp5150.c                        |    4 +-
 drivers/media/media-entity.c                       |    4 +-
 drivers/media/pci/bt8xx/bttv-cards.c               |    2 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |    4 +-
 drivers/media/pci/cx18/cx18-driver.c               |    2 +-
 drivers/media/pci/cx18/cx18-streams.c              |    4 +-
 drivers/media/pci/cx23885/cx23885-cards.c          |    3 +-
 drivers/media/pci/cx88/cx88-cards.c                |    4 +-
 drivers/media/pci/cx88/cx88-core.c                 |    4 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |    2 +-
 drivers/media/pci/cx88/cx88.h                      |    3 +-
 drivers/media/pci/dm1105/dm1105.c                  |    2 +-
 drivers/media/pci/ivtv/ivtv-driver.c               |    7 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c                |    4 +-
 drivers/media/pci/ivtv/ivtv-udma.c                 |    2 +-
 drivers/media/pci/mantis/mantis_vp1034.c           |    2 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |    5 +-
 drivers/media/pci/saa7134/saa7134-cards.c          |    2 +-
 drivers/media/pci/saa7134/saa7134-dvb.c            |    4 +-
 drivers/media/pci/saa7134/saa7134-ts.c             |    5 +-
 drivers/media/pci/saa7134/saa7134-vbi.c            |    5 +-
 drivers/media/pci/saa7134/saa7134-video.c          |    5 +-
 drivers/media/pci/saa7164/saa7164-cards.c          |    4 +-
 drivers/media/pci/saa7164/saa7164-cmd.c            |    5 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |    5 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         |   11 +
 drivers/media/pci/ttpci/av7110_ir.c                |    5 +-
 drivers/media/pci/ttpci/budget-av.c                |    8 +-
 drivers/media/pci/ttpci/budget-ci.c                |    2 +-
 drivers/media/pci/ttpci/budget.c                   |    4 +-
 drivers/media/pci/tw5864/tw5864-video.c            |   11 +-
 drivers/media/platform/Kconfig                     |   48 +-
 drivers/media/platform/Makefile                    |    6 +
 drivers/media/platform/atmel/Kconfig               |   11 +-
 drivers/media/platform/atmel/Makefile              |    1 +
 drivers/media/platform/atmel/atmel-isc-regs.h      |  102 +-
 drivers/media/platform/atmel/atmel-isc.c           |  628 +++++++--
 drivers/media/platform/atmel/atmel-isi.c           | 1368 ++++++++++++++++++++
 .../platform/{soc_camera => atmel}/atmel-isi.h     |    0
 drivers/media/platform/coda/coda-bit.c             |  100 +-
 drivers/media/platform/coda/coda-common.c          |  130 +-
 drivers/media/platform/coda/coda-h264.c            |   87 +-
 drivers/media/platform/coda/coda.h                 |   10 +-
 drivers/media/platform/coda/coda_regs.h            |    1 +
 drivers/media/platform/davinci/vpif_display.c      |    2 +-
 drivers/media/platform/exynos-gsc/gsc-core.c       |   27 +
 drivers/media/platform/fsl-viu.c                   |    5 +-
 drivers/media/platform/m2m-deinterlace.c           |    1 +
 drivers/media/platform/mtk-jpeg/Makefile           |    2 +
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c    | 1292 ++++++++++++++++++
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.h    |  139 ++
 drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.c      |  417 ++++++
 drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.h      |   91 ++
 drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.c   |  160 +++
 drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.h   |   25 +
 drivers/media/platform/mtk-jpeg/mtk_jpeg_reg.h     |   58 +
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c |   33 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h |    2 +
 .../media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c |    5 -
 .../media/platform/mtk-vcodec/mtk_vcodec_util.h    |   17 +-
 .../media/platform/mtk-vcodec/vdec/vdec_vp9_if.c   |   26 +
 drivers/media/platform/mtk-vcodec/vdec_drv_if.h    |    2 +
 .../media/platform/mtk-vcodec/venc/venc_vp8_if.c   |    4 +-
 .../media => media/platform}/s5p-cec/Makefile      |    0
 .../platform}/s5p-cec/exynos_hdmi_cec.h            |    0
 .../platform}/s5p-cec/exynos_hdmi_cecctrl.c        |    0
 .../media => media/platform}/s5p-cec/regs-cec.h    |    0
 .../media => media/platform}/s5p-cec/s5p_cec.c     |   40 +-
 .../media => media/platform}/s5p-cec/s5p_cec.h     |    3 +
 drivers/media/platform/s5p-g2d/g2d.c               |    2 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h       |    2 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v7.h       |    2 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v8.h       |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |  245 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c    |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |   43 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |   72 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h      |    1 -
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |    8 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   10 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_iommu.h     |   51 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c       |   93 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h       |   12 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |   48 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |   16 +-
 drivers/media/platform/sh_vou.c                    |    4 +-
 drivers/media/platform/soc_camera/Kconfig          |   12 -
 drivers/media/platform/soc_camera/Makefile         |    1 -
 drivers/media/platform/soc_camera/atmel-isi.c      | 1167 -----------------
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |   13 +-
 drivers/media/platform/soc_camera/soc_camera.c     |  103 +-
 drivers/media/platform/soc_camera/soc_scale_crop.c |   11 +-
 .../media/platform/sti/c8sectpfe/c8sectpfe-core.c  |    5 +-
 .../st-cec => media/platform/sti/cec}/Makefile     |    0
 .../st-cec => media/platform/sti/cec}/stih-cec.c   |   37 +-
 drivers/media/platform/sti/delta/delta-mjpeg-dec.c |    2 +-
 drivers/media/platform/ti-vpe/vpdma.c              |   14 +-
 drivers/media/platform/ti-vpe/vpdma.h              |    6 +-
 drivers/media/platform/ti-vpe/vpe.c                |   34 +-
 drivers/media/platform/vimc/Kconfig                |   14 +
 drivers/media/platform/vimc/Makefile               |    3 +
 drivers/media/platform/vimc/vimc-capture.c         |  498 +++++++
 drivers/media/platform/vimc/vimc-capture.h         |   28 +
 drivers/media/platform/vimc/vimc-core.c            |  695 ++++++++++
 drivers/media/platform/vimc/vimc-core.h            |  112 ++
 drivers/media/platform/vimc/vimc-sensor.c          |  276 ++++
 drivers/media/platform/vimc/vimc-sensor.h          |   28 +
 drivers/media/platform/vivid/Kconfig               |    5 +-
 drivers/media/platform/vivid/vivid-cec.c           |    4 +-
 drivers/media/platform/vivid/vivid-core.c          |   32 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |   13 +-
 drivers/media/platform/vivid/vivid-vid-common.c    |    4 +-
 drivers/media/platform/vivid/vivid-vid-out.c       |   26 +-
 drivers/media/platform/vsp1/Makefile               |    1 +
 drivers/media/platform/vsp1/vsp1.h                 |    6 +
 drivers/media/platform/vsp1/vsp1_bru.c             |   27 +-
 drivers/media/platform/vsp1/vsp1_dl.c              |   27 +-
 drivers/media/platform/vsp1/vsp1_drm.c             |   42 +-
 drivers/media/platform/vsp1/vsp1_drm.h             |    2 +-
 drivers/media/platform/vsp1/vsp1_drv.c             |   82 +-
 drivers/media/platform/vsp1/vsp1_entity.c          |  163 ++-
 drivers/media/platform/vsp1/vsp1_entity.h          |    8 +-
 drivers/media/platform/vsp1/vsp1_hgo.c             |  230 ++++
 drivers/media/platform/vsp1/vsp1_hgo.h             |   45 +
 drivers/media/platform/vsp1/vsp1_hgt.c             |  222 ++++
 drivers/media/platform/vsp1/vsp1_hgt.h             |   42 +
 drivers/media/platform/vsp1/vsp1_histo.c           |  646 +++++++++
 drivers/media/platform/vsp1/vsp1_histo.h           |   84 ++
 drivers/media/platform/vsp1/vsp1_hsit.c            |    3 +-
 drivers/media/platform/vsp1/vsp1_lif.c             |    6 +-
 drivers/media/platform/vsp1/vsp1_pipe.c            |   59 +-
 drivers/media/platform/vsp1/vsp1_pipe.h            |    9 +-
 drivers/media/platform/vsp1/vsp1_regs.h            |   33 +-
 drivers/media/platform/vsp1/vsp1_rpf.c             |   54 +-
 drivers/media/platform/vsp1/vsp1_rwpf.c            |   11 +-
 drivers/media/platform/vsp1/vsp1_rwpf.h            |    7 +-
 drivers/media/platform/vsp1/vsp1_sru.c             |    3 +-
 drivers/media/platform/vsp1/vsp1_uds.c             |    3 +-
 drivers/media/platform/vsp1/vsp1_video.c           |   85 +-
 drivers/media/platform/vsp1/vsp1_wpf.c             |  224 +++-
 drivers/media/radio/si4713/si4713.c                |    9 +
 drivers/media/radio/wl128x/fmdrv_common.c          |    5 +-
 drivers/media/rc/Kconfig                           |    9 +
 drivers/media/rc/Makefile                          |    1 +
 drivers/media/rc/gpio-ir-recv.c                    |    2 +-
 drivers/media/rc/igorplugusb.c                     |    2 +-
 drivers/media/rc/imon.c                            |    5 +-
 drivers/media/rc/ir-lirc-codec.c                   |   34 +-
 drivers/media/rc/ir-mce_kbd-decoder.c              |   49 +-
 drivers/media/rc/keymaps/Makefile                  |    1 -
 drivers/media/rc/keymaps/rc-dvico-mce.c            |   92 +-
 drivers/media/rc/keymaps/rc-dvico-portable.c       |   74 +-
 drivers/media/rc/keymaps/rc-lirc.c                 |   42 -
 drivers/media/rc/lirc_dev.c                        |  122 +-
 drivers/media/rc/mceusb.c                          |    4 +-
 drivers/media/rc/rc-core-priv.h                    |    2 +-
 drivers/media/rc/rc-ir-raw.c                       |    6 +-
 drivers/media/rc/rc-main.c                         |    8 +-
 drivers/media/rc/serial_ir.c                       |    4 +-
 drivers/media/rc/sir_ir.c                          |  438 +++++++
 drivers/media/rc/st_rc.c                           |   15 +-
 drivers/media/rc/sunxi-cir.c                       |   21 +-
 drivers/media/rc/winbond-cir.c                     |    4 +-
 drivers/media/tuners/si2157.c                      |   23 +-
 drivers/media/tuners/si2157_priv.h                 |    2 +
 drivers/media/tuners/xc5000.c                      |    3 +-
 drivers/media/usb/Kconfig                          |    1 +
 drivers/media/usb/Makefile                         |    1 +
 drivers/media/usb/au0828/au0828-cards.c            |    2 +-
 drivers/media/usb/au0828/au0828-video.c            |    7 -
 drivers/media/usb/cx231xx/cx231xx-audio.c          |   42 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |   48 +-
 drivers/media/usb/cx231xx/cx231xx-i2c.c            |   16 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c            |   16 +-
 drivers/media/usb/dvb-usb/cxusb.c                  |  163 ++-
 drivers/media/usb/dvb-usb/dib0700_core.c           |    3 +
 drivers/media/usb/dvb-usb/dibusb-mc-common.c       |    2 +
 drivers/media/usb/dvb-usb/digitv.c                 |    3 +
 drivers/media/usb/dvb-usb/dw2102.c                 |   54 +
 drivers/media/usb/dvb-usb/ttusb2.c                 |   19 +
 drivers/media/usb/em28xx/Kconfig                   |    7 +-
 drivers/media/usb/em28xx/em28xx-camera.c           |  107 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |   15 +-
 drivers/media/usb/em28xx/em28xx-reg.h              |   18 +
 drivers/media/usb/em28xx/em28xx-video.c            |   13 +-
 drivers/media/usb/em28xx/em28xx.h                  |    1 -
 drivers/media/usb/go7007/go7007-v4l2.c             |    5 +-
 drivers/media/usb/gspca/konica.c                   |    3 +
 drivers/media/usb/pulse8-cec/Kconfig               |    2 +-
 drivers/media/usb/pulse8-cec/pulse8-cec.c          |    6 +-
 drivers/media/usb/pvrusb2/pvrusb2-eeprom.c         |   13 +-
 drivers/media/usb/rainshadow-cec/Kconfig           |   10 +
 drivers/media/usb/rainshadow-cec/Makefile          |    1 +
 drivers/media/usb/rainshadow-cec/rainshadow-cec.c  |  388 ++++++
 drivers/media/usb/stk1160/Kconfig                  |    6 +-
 drivers/media/usb/tm6000/tm6000-video.c            |    2 +-
 drivers/media/usb/usbvision/usbvision-video.c      |    9 +-
 drivers/media/usb/uvc/uvc_driver.c                 |   15 +
 drivers/media/usb/uvc/uvc_video.c                  |   12 +-
 drivers/media/usb/uvc/uvcvideo.h                   |    9 +
 drivers/media/usb/zr364xx/zr364xx.c                |    8 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   24 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |    8 +-
 drivers/media/v4l2-core/v4l2-dev.c                 |   16 +-
 drivers/media/v4l2-core/v4l2-device.c              |    3 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |   37 +
 drivers/media/v4l2-core/videobuf2-core.c           |   14 +-
 drivers/media/v4l2-core/videobuf2-dma-contig.c     |   11 +-
 drivers/media/v4l2-core/videobuf2-dma-sg.c         |   11 +-
 drivers/media/v4l2-core/videobuf2-memops.c         |    6 +-
 drivers/media/v4l2-core/videobuf2-v4l2.c           |    3 +
 drivers/media/v4l2-core/videobuf2-vmalloc.c        |   11 +-
 drivers/staging/media/Kconfig                      |    4 -
 drivers/staging/media/Makefile                     |    2 -
 drivers/staging/media/bcm2048/radio-bcm2048.c      |   28 +-
 drivers/staging/media/lirc/Kconfig                 |   12 -
 drivers/staging/media/lirc/Makefile                |    2 -
 drivers/staging/media/lirc/lirc_sasem.c            |  899 -------------
 drivers/staging/media/lirc/lirc_sir.c              |  839 ------------
 drivers/staging/media/lirc/lirc_zilog.c            |    9 +-
 drivers/staging/media/omap4iss/iss_csi2.c          |    2 +-
 drivers/staging/media/omap4iss/iss_ipipe.c         |    2 +-
 drivers/staging/media/omap4iss/iss_ipipeif.c       |    2 +-
 drivers/staging/media/omap4iss/iss_resizer.c       |    2 +-
 drivers/staging/media/omap4iss/iss_video.c         |   41 +-
 drivers/staging/media/s5p-cec/Kconfig              |    9 -
 drivers/staging/media/s5p-cec/TODO                 |    7 -
 drivers/staging/media/st-cec/Kconfig               |    8 -
 drivers/staging/media/st-cec/TODO                  |    7 -
 include/media/cec-edid.h                           |  104 --
 include/media/cec-notifier.h                       |  111 ++
 include/media/cec.h                                |  119 +-
 include/media/davinci/vpif_types.h                 |    1 +
 include/media/rc-map.h                             |   79 +-
 include/media/soc_camera.h                         |   14 +-
 include/media/tveeprom.h                           |    3 +-
 include/media/v4l2-ioctl.h                         |   17 +
 include/media/videobuf2-core.h                     |   12 +-
 include/media/videobuf2-memops.h                   |    3 +-
 include/trace/events/v4l2.h                        |    1 +
 include/uapi/linux/cec.h                           |    2 +-
 include/uapi/linux/serio.h                         |    1 +
 include/uapi/linux/videodev2.h                     |   25 +-
 352 files changed, 15001 insertions(+), 5238 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5645.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5647.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov7670.txt
 create mode 100644 Documentation/devicetree/bindings/media/mediatek-jpeg-decoder.txt
 create mode 100644 Documentation/media/uapi/v4l/dev-meta.rst
 create mode 100644 Documentation/media/uapi/v4l/meta-formats.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-inzi.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgt.rst
 create mode 100644 drivers/media/cec/Kconfig
 rename drivers/media/{ => cec}/cec-edid.c (96%)
 create mode 100644 drivers/media/cec/cec-notifier.c
 rename drivers/media/i2c/{soc_camera => }/ov2640.c (86%)
 create mode 100644 drivers/media/i2c/ov5645.c
 create mode 100644 drivers/media/i2c/ov5647.c
 create mode 100644 drivers/media/platform/atmel/atmel-isi.c
 rename drivers/media/platform/{soc_camera => atmel}/atmel-isi.h (100%)
 create mode 100644 drivers/media/platform/mtk-jpeg/Makefile
 create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
 create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.h
 create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.c
 create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_hw.h
 create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.c
 create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_parse.h
 create mode 100644 drivers/media/platform/mtk-jpeg/mtk_jpeg_reg.h
 rename drivers/{staging/media => media/platform}/s5p-cec/Makefile (100%)
 rename drivers/{staging/media => media/platform}/s5p-cec/exynos_hdmi_cec.h (100%)
 rename drivers/{staging/media => media/platform}/s5p-cec/exynos_hdmi_cecctrl.c (100%)
 rename drivers/{staging/media => media/platform}/s5p-cec/regs-cec.h (100%)
 rename drivers/{staging/media => media/platform}/s5p-cec/s5p_cec.c (88%)
 rename drivers/{staging/media => media/platform}/s5p-cec/s5p_cec.h (97%)
 delete mode 100644 drivers/media/platform/soc_camera/atmel-isi.c
 rename drivers/{staging/media/st-cec => media/platform/sti/cec}/Makefile (100%)
 rename drivers/{staging/media/st-cec => media/platform/sti/cec}/stih-cec.c (92%)
 create mode 100644 drivers/media/platform/vimc/Kconfig
 create mode 100644 drivers/media/platform/vimc/Makefile
 create mode 100644 drivers/media/platform/vimc/vimc-capture.c
 create mode 100644 drivers/media/platform/vimc/vimc-capture.h
 create mode 100644 drivers/media/platform/vimc/vimc-core.c
 create mode 100644 drivers/media/platform/vimc/vimc-core.h
 create mode 100644 drivers/media/platform/vimc/vimc-sensor.c
 create mode 100644 drivers/media/platform/vimc/vimc-sensor.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgo.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgo.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgt.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgt.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_histo.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_histo.h
 delete mode 100644 drivers/media/rc/keymaps/rc-lirc.c
 create mode 100644 drivers/media/rc/sir_ir.c
 create mode 100644 drivers/media/usb/rainshadow-cec/Kconfig
 create mode 100644 drivers/media/usb/rainshadow-cec/Makefile
 create mode 100644 drivers/media/usb/rainshadow-cec/rainshadow-cec.c
 delete mode 100644 drivers/staging/media/lirc/lirc_sasem.c
 delete mode 100644 drivers/staging/media/lirc/lirc_sir.c
 delete mode 100644 drivers/staging/media/s5p-cec/Kconfig
 delete mode 100644 drivers/staging/media/s5p-cec/TODO
 delete mode 100644 drivers/staging/media/st-cec/Kconfig
 delete mode 100644 drivers/staging/media/st-cec/TODO
 delete mode 100644 include/media/cec-edid.h
 create mode 100644 include/media/cec-notifier.h
