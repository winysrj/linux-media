Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:34360 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760772AbbIDXxx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Sep 2015 19:53:53 -0400
Date: Fri, 4 Sep 2015 20:53:47 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.3-rc1] media updates
Message-ID: <20150904205347.1d908985@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.3-1

For the media subsystem patches for Kernel 4.3.

This series contain:

- New DVB frontend drivers: ascot2e, cxd2841er, horus3a, lnbh25;
- New HDMI capture driver: tc358743;
- New driver for NetUP DVB new boards (netup_unidvb);
- IR support for DVBSky cards (smipcie-ir);
- Coda driver has gain macroblock tiling support;
- Renesas R-Car gains JPEG codec driver;
- New DVB platform driver for STi boards: c8sectpfe;
- Added documentation for the media core kABI to device-drivers DocBook;
- Lots of driver fixups, cleanups and improvements.

Thanks!
Mauro

-

The following changes since commit bc0195aad0daa2ad5b0d76cce22b167bc3435590:

  Linux 4.2-rc2 (2015-07-12 15:10:30 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.3-1

for you to fetch changes up to 50ef28a6ac216fd8b796257a3768fef8f57b917d:

  [media] c8sectpfe: Remove select on undefined LIBELF_32 (2015-09-03 14:10:06 -0300)

----------------------------------------------------------------
media updates for v4.3-rc1

----------------------------------------------------------------
Abhilash Jindal (2):
      [media] zoran: Use monotonic time
      [media] bt8xxx: Use monotonic time

Andrzej Pietrasiewicz (1):
      [media] s5p-jpeg: Eliminate double kfree()

Antonio Borneo (1):
      [media] s5c73m3: Remove redundant spi driver bus initialization

Antti Palosaari (11):
      [media] em28xx: remove unused a8293 SEC config
      [media] a8293: remove legacy media attach
      [media] a8293: use i2c_master_send / i2c_master_recv for I2C I/O
      [media] a8293: improve LNB register programming logic
      [media] a8293: coding style issues
      [media] tda10071: remove legacy media attach
      [media] tda10071: rename device state struct to dev
      [media] tda10071: convert to regmap I2C API
      [media] tda10071: protect firmware command exec with mutex
      [media] tda10071: do not get_frontend() when not ready
      [media] tda10071: implement DVBv5 statistics

Ben Dooks (1):
      [media] media: adv7180: add of match table

Benoit Parrot (2):
      [media] media: am437x-vpfe: Requested frame size and fmt overwritten by current sensor setting
      [media] media: am437x-vpfe: Fix a race condition during release

Christian Löpke (1):
      [media] Technisat SkyStar USB HD,(DVB-S/S2) too much URBs for arm devices

Damian Hobson-Garcia (1):
      [media] v4l: vsp1: Align crop rectangle to even boundary for YUV formats

Dan Carpenter (2):
      [media] gspca: sn9c2028: remove an unneeded condition
      [media] v4l: xilinx: missing error code

David Härdeman (5):
      [media] rc-core: fix remove uevent generation
      [media] rc-core: use an IDA rather than a bitmap
      [media] rc-core: remove the LIRC "protocol"
      [media] lmedm04: NEC scancode cleanup
      [media] rc-core: improve the lirc protocol reporting

Ezequiel Garcia (3):
      [media] stk1160: Reduce driver verbosity
      [media] stk1160: Add frame scaling support
      [media] tw68: Move PCI vendor and device IDs to pci_ids.h

Fabian Frederick (6):
      [media] v4l2-dv-timings: use swap() in v4l2_calc_aspect_ratio()
      [media] wl128x: use swap() in fm_rdsparse_swapbytes()
      [media] saa7146: use swap() in sort_and_eliminate()
      [media] saa6588: use swap() in saa6588_i2c_poll()
      [media] btcx-risc: use swap() in btcx_sort_clips()
      [media] ttusb-dec: use swap() in swap_bytes()

Fabien Dessenne (3):
      [media] bdisp: composing support
      [media] bdisp: add debug info for RGB24 format
      [media] bdisp: fix debug info memory access

Fabio Estevam (2):
      [media] mantis: Fix error handling in mantis_dma_init()
      [media] c8sectpfe: Use %pad to print 'dma_addr_t'

Fengguang Wu (1):
      [media] i2c: fix platform_no_drv_owner.cocci warnings

Geert Uytterhoeven (4):
      [media] adv7604/cobalt: Allow compile test if !GPIOLIB
      [media] dvb-frontends: Make all DVB Frontends visible if COMPILE_TEST=y
      [media] i2c: Make all i2c devices visible if COMPILE_TEST=y
      [media] tuners: Make all TV tuners visible if COMPILE_TEST=y

Hans Verkuil (60):
      [media] stk1160: fix sequence handling
      [media] rc/Kconfig: fix indentation problem
      [media] v4l2-dv-timings: log if the timing is reduced blanking V2
      [media] clock-sh7724.c: fix sh-vou clock identifier
      [media] sh-vou: use resource managed calls
      [media] sh-vou: fix querycap support
      [media] sh-vou: use v4l2_fh
      [media] sh-vou: support compulsory G/S/ENUM_OUTPUT ioctls
      [media] sh-vou: fix incorrect initial pixelformat
      [media] sh-vou: replace g/s_crop/cropcap by g/s_selection
      [media] sh-vou: let sh_vou_s_fmt_vid_out call sh_vou_try_fmt_vid_out
      [media] sh-vou: fix bytesperline
      [media] sh-vou: convert to vb2
      [media] sh-vou: add support for log_status
      [media] DocBook/media: fix bad spacing in VIDIOC_EXPBUF
      [media] v4l2-event: v4l2_event_queue: do nothing if vdev == NULL
      [media] DocBook: fix media-ioc-device-info.xml type
      [media] DocBook media: fix typo in V4L2_CTRL_FLAG_EXECUTE_ON_WRITE
      [media] cobalt: accept unchanged timings when vb2_is_busy()
      [media] cobalt: allow fewer than 8 PCIe lanes
      [media] sh-veu: don't use COLORSPACE_JPEG
      [media] v4l2-mem2mem: drop lock in v4l2_m2m_fop_mmap
      [media] tc358743: remove unused variable
      [media] usbvision: remove power_on_at_open and timed power off
      [media] usbvision: convert to the control framework
      [media] usbvision: return valid error in usbvision_register_video()
      [media] usbvision: remove g/s_audio and for radio remove enum/g/s_input
      [media] usbvision: the radio device node has wrong caps
      [media] usbvision: frequency fixes
      [media] usbvision: set field and colorspace
      [media] usbvision: fix locking error
      [media] usbvision: fix DMA from stack warnings
      [media] usbvision: fix standards for S-Video/Composite inputs
      [media] usbvision: move init code to probe()
      [media] fsl-viu: convert to the control framework
      [media] fsl-viu: fill in bus_info in vidioc_querycap
      [media] fsl-viu: fill in colorspace, always set field to interlaced
      [media] fsl-viu: add control event support
      [media] fsl-viu: small fixes
      [media] fsl-viu: drop format names
      [media] zoran: remove unnecessary memset
      [media] zoran: remove unused read/write functions
      [media] zoran: use standard core lock
      [media] zoran: convert to the control framework and to v4l2_fh
      [media] bt819/saa7110/vpx3220: remove legacy control ops
      [media] sh-veu: initialize timestamp_flags and copy timestamp info
      [media] tw9910: don't use COLORSPACE_JPEG
      [media] tw9910: init priv->scale and update standard
      [media] ak881x: simplify standard checks
      [media] mt9t112: JPEG -> SRGB
      [media] sh_mobile_ceu_camera: fix querycap
      [media] sh_mobile_ceu_camera: set field to FIELD_NONE
      [media] soc_camera: fix enum_input
      [media] soc_camera: fix expbuf support
      [media] soc_camera: compliance fixes
      [media] soc_camera: pass on streamoff error
      [media] soc_camera: always release queue for queue owner
      [media] mt9v032: fix uninitialized variable warning
      [media] horus3a: fix compiler warning
      [media] tc358743: add missing Kconfig dependency/select

Ian Molton (2):
      [media] media: adv7604: document support for ADV7612 dual HDMI input decoder
      [media] media: adv7604: ability to read default input port from DT

Jan Roemisch (1):
      [media] radio-bcm2048: Fix region selection

Javier Martinez Canillas (2):
      [media] Export I2C module alias information in missing drivers
      [media] staging: media: lirc: Export I2C module alias information

Joe Perches (3):
      [media] media: uapi: vsp1: Use __u32 instead of u32
      [media] media: ttpci: Use vsprintf %pM extension
      [media] dvb-pll: Convert struct dvb_pll_desc uses to const

Josh Wu (3):
      [media] atmel-isi: disable ISI even if it has codec request
      [media] atmel-isi: add runtime pm support
      [media] atmel-isi: remove mck backward compatibility code

Kozlov Sergey (5):
      [media] horus3a: Sony Horus3A DVB-S/S2 tuner driver
      [media] ascot2e: Sony Ascot2e DVB-C/T/T2 tuner driver
      [media] lnbh25: LNBH25 SEC controller driver
      [media] cxd2841er: Sony CXD2841ER DVB-S/S2/T/T2/C demodulator driver
      [media] netup_unidvb: NetUP Universal DVB-S/S2/T/T2/C PCI-E card driver

Krzysztof Hałasa (5):
      [media] SOLO6x10: Fix G.723 minimum audio period count
      [media] SOLO6x10: unmap registers only after free_irq()
      [media] SOLO6x10: remove unneeded register locking and barriers
      [media] SOLO6x10: Remove dead code
      [media] pci/Kconfig: don't use MEDIA_ANALOG_TV_SUPPORT for grabber cards

Krzysztof Kozlowski (10):
      [media] s5p-tv: Drop owner assignment from i2c_driver
      [media] dvb-frontends: Drop owner assignment from i2c_driver
      [media] dvb-frontends: Drop owner assignment from platform_driver
      [media] i2c: Drop owner assignment from i2c_driver
      [media] radio: Drop owner assignment from i2c_driver
      [media] tuners: Drop owner assignment from i2c_driver
      [media] Drop owner assignment from i2c_driver
      [media] staging: media: Drop owner assignment from i2c_driver
      [media] staging: iio: Drop owner assignment from i2c_driver
      [media] staging: Drop owner assignment from i2c_driver

Lars-Peter Clausen (5):
      [media] adv7604: Add support for control event notifications
      [media] adv7842: Add support for control event notifications
      [media] Add helper function for subdev event notifications
      [media] adv7604: Deliver resolution change events to userspace
      [media] adv7842: Deliver resolution change events to userspace

Laura Abbott (1):
      [media] v4l2-ioctl: Give more information when device_caps are missing

Laurent Pinchart (6):
      [media] v4l: omap4iss: Enable driver compilation as a module
      [media] v4l: omap4iss: Remove video node crop support
      [media] v4l: vsp1: Fix race condition when stopping pipeline
      [media] v4l: vsp1: Fix plane stride and size checks
      [media] v4l: vsp1: Don't sleep in atomic context
      [media] v4l: omap3isp: Drop platform data support

Lucas Stach (1):
      [media] coda: clamp frame sequence counters to 16 bit

Luis R. Rodriguez (1):
      [media] x86/mm/pat, drivers/media/ivtv: move pat warn and replace WARN() with pr_warn()

Maninder Singh (1):
      [media] usb/airspy: removing unneeded goto

Marek Szyprowski (2):
      [media] s5p-mfc: add return value check in mfc_sys_init_cmd
      [media] s5p-mfc: add additional check for incorrect memory configuration

Masanari Iida (2):
      [media] DocBook: Fix typo in intro.xml
      [media] DocBook media: Fix typo "the the" in xml files

Mats Randgaard (1):
      [media] Driver for Toshiba TC358743 HDMI to CSI-2 bridge

Mauro Carvalho Chehab (58):
      Merge tag 'v4.2-rc1' into patchwork
      [media] vsp1: declar vsp1_pipeline_stopped() as static
      [media] sh_vou: declare static functions as such
      Merge tag 'v4.2-rc2' into patchwork
      [media] mantis: remove an uneeded goto
      [media] cxd2841er: declare static functions as such
      [media] cxd2841er: don't use variable length arrays
      [media] horus3a: don't use variable length arrays
      [media] ascot2e: don't use variable length arrays
      [media] c8sectpfe: Allow compiling it with COMPILE_TEST
      [media] c8sectpfe: don't go past channel_data array
      [media] c8sectpfe: fix pinctrl dependencies
      [media] tda10071: use div_s64() when dividing a s64 integer
      [media] c8sectpfe: use a new Kconfig menu for DVB platform drivers
      [media] tc358743: don't use variable length array for I2C writes
      [media] ov9650: remove an extra space
      [media] ov2659: get rid of unused values
      [media] sr030pc30: don't read a new pointer
      Revert "[media] ARM: DT: STi: STiH407: Add c8sectpfe LinuxDVB DT node"
      [media] DocBook: fix an unbalanced <para> tag
      [media] DocBook/device-drivers: Add drivers/media core stuff
      [media] Docbook: Fix description of struct media_devnode
      [media] DocBook/media/Makefile: Avoid make htmldocs to fail
      [media] Docbook: Fix  comments at v4l2-async.h
      [media] Docbook: Fix s_rx_carrier_range parameter description
      [media] Docbook: fix comments at v4l2-flash-led-class.h
      [media] Docbook: Fix comments at v4l2-mem2mem.h
      [media] v4l2-subdev: convert documentation to the right format
      [media] v4l2-subdev: Add description for core ioctl handlers
      [media] v4l2-subdev: Add description for radio ioctl handlers
      [media] v4l2-subdev: reorder the v4l2_subdev_video_ops comments
      [media] v4l2_subdev: describe ioctl parms at v4l2_subdev_video_ops
      [media] v4l2_subdev: describe ioctl parms at the remaining structs
      [media] v4l2-subdev: add remaining argument descriptions
      [media] DocBook: add dvb_ca_en50221.h to documentation
      [media] DocBook: add dvb_frontend.h to documentation
      [media] DocBook: add dvb_math.h to documentation
      [media] DocBook: add dvb_ringbuffer.h to documentation
      [media] v4l2-ctrls.h: add to device-drivers DocBook
      [media] v4l2-ctls: don't document v4l2_ctrl_fill()
      [media] v4l2-ctrls.h: Document a few missing arguments
      [media] v4l2-event.h: fix comments and add to DocBook
      [media] v4l-dv-timings.h: Add to device-drivers DocBook
      [media] videobuf2-core: Add it to device-drivers DocBook
      [media] videobuf2-memops.h: add to device-drivers DocBook
      [media] v4l2-mediabus: Add to DocBook
      [media] DocBook: Better organize media devices
      [media] dvb_frontend: document dvb_frontend_tune_settings
      [media] add documentation for struct dvb_tuner_info
      [media] dvb_frontend.h: get rid of dvbfe_modcod
      [media] Docbook: Document struct analog_parameters
      [media] dvb_frontend.h: Document struct dvb_tuner_ops
      [media] dvb_frontend.h: document struct analog_demod_ops
      [media] dvb: Use DVBFE_ALGO_HW where applicable
      [media] dvb-frontend.h: document struct dvb_frontend_ops
      [media] dvb-frontend.h: document struct dtv_frontend_properties
      [media] dvb_frontend.h: document the struct dvb_frontend
      [media] dvbdev: document most of the functions/data structs

Mike Looijmans (1):
      [media] i2c/adv7511: Fix license, set to GPL v2

Mikhail Ulyanov (3):
      [media] devicetree: bindings: Document Renesas R-Car JPEG Processing Unit
      [media] V4L2: platform: Add Renesas R-Car JPEG codec driver
      [media] MAINTAINERS: V4L2: PLATFORM: Add entry for Renesas JPEG Processing Unit driver

Nibble Max (1):
      [media] SMI PCIe IR driver for DVBSky cards

Nicholas Mc Guire (2):
      [media] gscpa_m5602: use msecs_to_jiffies for conversions
      [media] s5p-tv: fix wait_event_timeout return handling

Nobuhiro Iwamatsu (3):
      [media] v4l: vsp1: Fix VI6_WPF_SZCLIP_SIZE_MASK macro
      [media] v4l: vsp1: Fix VI6_DPR_ROUTE_FP_MASK macro
      [media] v4l: vsp1: Fix VI6_DPR_ROUTE_FXA_MASK macro

Pablo Anton (1):
      [media] media: i2c: ADV7604: Migrate to regmap

Peter Griffin (11):
      [media] stv0367: Refine i2c error trace to include i2c address
      [media] stv0367: Add support for 16Mhz reference clock
      [media] c8sectpfe: Add DT bindings documentation for c8sectpfe driver
      [media] ARM: DT: STi: STiH407: Add c8sectpfe LinuxDVB DT node
      [media] c8sectpfe: STiH407/10 Linux DVB demux support
      [media] c8sectpfe: Add LDVB helper functions
      [media] c8sectpfe: Add support for various ST NIM cards
      [media] c8sectpfe: Add c8sectpfe debugfs support
      [media] c8sectpfe: Add Kconfig and Makefile for the driver
      [media] MAINTAINERS: Add c8sectpfe driver directory to STi section
      [media] c8sectpfe: Remove select on undefined LIBELF_32

Philipp Zabel (25):
      [media] coda: fix mvcol buffer for MPEG4 decoding
      [media] coda: fix bitstream preloading for MPEG4 decoding
      [media] coda: keep buffers on the queue in bitstream end mode
      [media] coda: avoid calling SEQ_END twice
      [media] coda: reset stream end in stop_streaming
      [media] coda: drop custom list of pixel format descriptions
      [media] coda: use event class to deduplicate v4l2 trace events
      [media] coda: reuse src_bufs in coda_job_ready
      [media] coda: rework meta counting and add separate lock
      [media] coda: reset CODA960 hardware after sequence end
      [media] coda: implement VBV delay and buffer size controls
      [media] coda: Use S_PARM to set nominal framerate for h.264 encoder
      [media] coda: move cache setup into coda9_set_frame_cache, also use it in start_encoding
      [media] coda: add macroblock tiling support
      [media] coda: make NV12 format default
      [media] v4l2-dev: use event class to deduplicate v4l2 trace events
      [media] v4l2-mem2mem: set the queue owner field just as vb2_ioctl_reqbufs does
      [media] videobuf2: add trace events
      [media] tc358743: register v4l2 asynchronous subdevice
      [media] tc358743: enable v4l2 subdevice devnode
      [media] tc358743: support probe from device tree
      [media] tc358743: add direct interrupt handling
      [media] tc358743: allow event subscription
      [media] v4l2: move tracepoint generation into separate file
      [media] tc358743: only queue subdev notifications if devnode is set

Prashant Laddha (3):
      [media] v4l2-dv-timings: add support for reduced blanking v2
      [media] v4l2-dv-timings: print refresh rate with better precision
      [media] vivid: support cvt, gtf timings for video out

Randy Dunlap (2):
      [media] media/dvb: fix ts2020.c Kconfig and build
      [media] media/pci/cobalt: fix Kconfig and build when SND is not enabled

Ricardo Ribalda Delgado (13):
      [media] media/v4l2-ctrls: Code cleanout validate_new()
      [media] media/i2c/adv7343: Remove compat control ops
      [media] media/i2c/adv7393: Remove compat control ops
      [media] media/i2c/cs5345: Remove compat control ops
      [media] media/i2c/saa717x: Remove compat control ops
      [media] media/i2c/tda7432: Remove compat control ops
      [media] media/i2c/tlv320aic23: Remove compat control ops
      [media] media/i2c/tvp514x: Remove compat control ops
      [media] media/i2c/tvp7002: Remove compat control ops
      [media] i2c/wm8739: Remove compat control ops
      [media] pci/ivtv/ivtv-gpio: Remove compat control ops
      [media] media/radio/saa7706h: Remove compat control ops
      [media] media/i2c/sr030pc30: Remove compat control ops

Rob Taylor (2):
      [media] media: rcar_vin: fill in bus_info field
      [media] media: rcar_vin: Reject videobufs that are too small for current format

Sakari Ailus (3):
      [media] v4l: omap3isp: Fix async notifier registration order
      [media] v4l: omap3isp: Fix sub-device power management code
      [media] media: Correctly notify about the failed pipeline validation

Sei Fumizono (1):
      [media] v4l: vsp1: Fix Suspend-to-RAM

Seung-Woo Kim (1):
      [media] s5p-mfc: fix state check from encoder queue_setup

Shraddha Barke (1):
      [media] Staging: media: lirc: use USB API functions rather than constants

Steven Rostedt (1):
      [media] cx231xx: Use wake_up_interruptible() instead of wake_up_interruptible_nr()

Sunil Shahu (1):
      [media] staging: media: lirc: fix coding style error

Uwe Kleine-König (2):
      [media] tc358743: set direction of reset gpio using devm_gpiod_get
      [media] tc358743: make reset gpio optional

Vaishali Thakkar (3):
      [media] dvb_core: Replace memset with eth_zero_addr
      [media] ttpci: Replace memset with eth_zero_addr
      [media] pctv452e: Replace memset with eth_zero_addr

William Towle (4):
      [media] media: adv7604: chip info and formats for ADV7612
      [media] media: adv7604: fix probe of ADV7611/7612
      [media] media: adv7604: reduce support to first (digital) input
      [media] media: soc_camera: rcar_vin: Add BT.709 24-bit RGB888 input support

Zahari Doychev (1):
      [media] coda: drop zero payload bitstream buffers

pradheep (1):
      [media] staging:media:lirc Remove the extra braces in if statement of lirc_imon

 Documentation/DocBook/device-drivers.tmpl                     |   34 +
 Documentation/DocBook/media/Makefile                          |    3 +-
 Documentation/DocBook/media/dvb/intro.xml                     |    5 +-
 Documentation/DocBook/media/v4l/controls.xml                  |    2 +-
 Documentation/DocBook/media/v4l/media-ioc-device-info.xml     |    2 +-
 Documentation/DocBook/media/v4l/vidioc-expbuf.xml             |   38 +-
 Documentation/DocBook/media/v4l/vidioc-g-parm.xml             |    2 +-
 Documentation/DocBook/media/v4l/vidioc-queryctrl.xml          |    2 +-
 Documentation/devicetree/bindings/media/i2c/adv7604.txt       |   21 +-
 Documentation/devicetree/bindings/media/i2c/tc358743.txt      |   48 +
 Documentation/devicetree/bindings/media/renesas,jpu.txt       |   24 +
 Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt |   89 +
 MAINTAINERS                                                   |   59 +
 arch/sh/kernel/cpu/sh4a/clock-sh7724.c                        |    2 +-
 drivers/media/common/saa7146/saa7146_hlp.c                    |    9 +-
 drivers/media/dvb-core/dvb_ca_en50221.c                       |  167 +-
 drivers/media/dvb-core/dvb_ca_en50221.h                       |   34 +-
 drivers/media/dvb-core/dvb_frontend.c                         |    1 -
 drivers/media/dvb-core/dvb_frontend.h                         |  410 +-
 drivers/media/dvb-core/dvb_math.h                             |   25 +-
 drivers/media/dvb-core/dvb_net.c                              |    2 +-
 drivers/media/dvb-core/dvb_ringbuffer.h                       |  135 +-
 drivers/media/dvb-core/dvbdev.h                               |  116 +-
 drivers/media/dvb-frontends/Kconfig                           |   34 +-
 drivers/media/dvb-frontends/Makefile                          |    4 +
 drivers/media/dvb-frontends/a8293.c                           |  168 +-
 drivers/media/dvb-frontends/a8293.h                           |   22 -
 drivers/media/dvb-frontends/af9033.c                          |    1 -
 drivers/media/dvb-frontends/ascot2e.c                         |  548 +
 drivers/media/dvb-frontends/ascot2e.h                         |   58 +
 drivers/media/dvb-frontends/au8522_decoder.c                  |    1 -
 drivers/media/dvb-frontends/cx24123.c                         |    2 +-
 drivers/media/dvb-frontends/cxd2841er.c                       | 2727 ++
 drivers/media/dvb-frontends/cxd2841er.h                       |   65 +
 drivers/media/dvb-frontends/cxd2841er_priv.h                  |   43 +
 drivers/media/dvb-frontends/dvb-pll.c                         |   50 +-
 drivers/media/dvb-frontends/horus3a.c                         |  430 +
 drivers/media/dvb-frontends/horus3a.h                         |   58 +
 drivers/media/dvb-frontends/lnbh25.c                          |  189 +
 drivers/media/dvb-frontends/lnbh25.h                          |   56 +
 drivers/media/dvb-frontends/m88ds3103.c                       |    1 -
 drivers/media/dvb-frontends/rtl2830.c                         |    1 -
 drivers/media/dvb-frontends/rtl2832.c                         |    1 -
 drivers/media/dvb-frontends/rtl2832_sdr.c                     |    1 -
 drivers/media/dvb-frontends/s921.c                            |    2 +-
 drivers/media/dvb-frontends/si2168.c                          |    1 -
 drivers/media/dvb-frontends/sp2.c                             |    1 -
 drivers/media/dvb-frontends/stv0367.c                         |   17 +-
 drivers/media/dvb-frontends/tda10071.c                        |  825 +-
 drivers/media/dvb-frontends/tda10071.h                        |   63 +-
 drivers/media/dvb-frontends/tda10071_priv.h                   |   20 +-
 drivers/media/dvb-frontends/ts2020.c                          |    1 -
 drivers/media/i2c/Kconfig                                     |   15 +-
 drivers/media/i2c/Makefile                                    |    1 +
 drivers/media/i2c/adv7170.c                                   |    1 -
 drivers/media/i2c/adv7175.c                                   |    1 -
 drivers/media/i2c/adv7180.c                                   |   12 +-
 drivers/media/i2c/adv7343.c                                   |    8 -
 drivers/media/i2c/adv7393.c                                   |    7 -
 drivers/media/i2c/adv7511.c                                   |    3 +-
 drivers/media/i2c/adv7604.c                                   |  486 +-
 drivers/media/i2c/adv7842.c                                   |   28 +-
 drivers/media/i2c/ak881x.c                                    |    8 +-
 drivers/media/i2c/bt819.c                                     |   12 -
 drivers/media/i2c/bt856.c                                     |    1 -
 drivers/media/i2c/bt866.c                                     |    1 -
 drivers/media/i2c/cs5345.c                                    |    8 -
 drivers/media/i2c/cs53l32a.c                                  |    1 -
 drivers/media/i2c/cx25840/cx25840-core.c                      |    1 -
 drivers/media/i2c/ir-kbd-i2c.c                                |    1 +
 drivers/media/i2c/ks0127.c                                    |    1 -
 drivers/media/i2c/m52790.c                                    |    1 -
 drivers/media/i2c/msp3400-driver.c                            |    1 -
 drivers/media/i2c/mt9v011.c                                   |    1 -
 drivers/media/i2c/mt9v032.c                                   |    2 +-
 drivers/media/i2c/ov2659.c                                    |    4 -
 drivers/media/i2c/ov7640.c                                    |    1 -
 drivers/media/i2c/ov7670.c                                    |    1 -
 drivers/media/i2c/ov9650.c                                    |    2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-spi.c                       |    1 -
 drivers/media/i2c/s5k6a3.c                                    |    1 +
 drivers/media/i2c/saa6588.c                                   |    5 +-
 drivers/media/i2c/saa6752hs.c                                 |    1 -
 drivers/media/i2c/saa7110.c                                   |   12 -
 drivers/media/i2c/saa7115.c                                   |    1 -
 drivers/media/i2c/saa7127.c                                   |    1 -
 drivers/media/i2c/saa717x.c                                   |    8 -
 drivers/media/i2c/saa7185.c                                   |    1 -
 drivers/media/i2c/soc_camera/mt9t112.c                        |    8 +-
 drivers/media/i2c/soc_camera/tw9910.c                         |   35 +-
 drivers/media/i2c/sony-btf-mpx.c                              |    1 -
 drivers/media/i2c/sr030pc30.c                                 |   15 +-
 drivers/media/i2c/tc358743.c                                  | 1979 +
 drivers/media/i2c/tc358743_regs.h                             |  681 +
 drivers/media/i2c/tda7432.c                                   |    8 -
 drivers/media/i2c/tda9840.c                                   |    1 -
 drivers/media/i2c/tea6415c.c                                  |    1 -
 drivers/media/i2c/tea6420.c                                   |    1 -
 drivers/media/i2c/ths7303.c                                   |    1 -
 drivers/media/i2c/tlv320aic23b.c                              |    7 -
 drivers/media/i2c/tvaudio.c                                   |    1 -
 drivers/media/i2c/tvp514x.c                                   |   11 -
 drivers/media/i2c/tvp5150.c                                   |    1 -
 drivers/media/i2c/tvp7002.c                                   |    7 -
 drivers/media/i2c/tw9903.c                                    |    1 -
 drivers/media/i2c/tw9906.c                                    |    1 -
 drivers/media/i2c/upd64031a.c                                 |    1 -
 drivers/media/i2c/upd64083.c                                  |    1 -
 drivers/media/i2c/vp27smpx.c                                  |    1 -
 drivers/media/i2c/vpx3220.c                                   |    8 -
 drivers/media/i2c/wm8739.c                                    |    8 -
 drivers/media/i2c/wm8775.c                                    |    1 -
 drivers/media/media-entity.c                                  |    6 +-
 drivers/media/pci/Kconfig                                     |    7 +-
 drivers/media/pci/Makefile                                    |    3 +-
 drivers/media/pci/bt8xx/btcx-risc.c                           |    5 +-
 drivers/media/pci/bt8xx/bttv-input.c                          |   21 +-
 drivers/media/pci/bt8xx/bttvp.h                               |    2 +-
 drivers/media/pci/cobalt/Kconfig                              |    4 +-
 drivers/media/pci/cobalt/cobalt-driver.c                      |   11 +-
 drivers/media/pci/cobalt/cobalt-v4l2.c                        |   11 +-
 drivers/media/pci/ivtv/ivtv-gpio.c                            |    7 -
 drivers/media/pci/ivtv/ivtvfb.c                               |   15 +-
 drivers/media/pci/mantis/mantis_dma.c                         |    9 +-
 drivers/media/pci/netup_unidvb/Kconfig                        |   12 +
 drivers/media/pci/netup_unidvb/Makefile                       |    9 +
 drivers/media/pci/netup_unidvb/netup_unidvb.h                 |  133 +
 drivers/media/pci/netup_unidvb/netup_unidvb_ci.c              |  248 +
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c            | 1001 +
 drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c             |  381 +
 drivers/media/pci/netup_unidvb/netup_unidvb_spi.c             |  252 +
 drivers/media/pci/smipcie/Kconfig                             |    1 +
 drivers/media/pci/smipcie/Makefile                            |    3 +
 drivers/media/pci/smipcie/smipcie-ir.c                        |  232 +
 drivers/media/pci/smipcie/{smipcie.c => smipcie-main.c}       |   14 +-
 drivers/media/pci/smipcie/smipcie.h                           |   19 +
 drivers/media/pci/solo6x10/solo6x10-core.c                    |   18 +-
 drivers/media/pci/solo6x10/solo6x10-g723.c                    |   13 +-
 drivers/media/pci/solo6x10/solo6x10.h                         |   26 +-
 drivers/media/pci/ttpci/budget-av.c                           |    2 +-
 drivers/media/pci/ttpci/ttpci-eeprom.c                        |    9 +-
 drivers/media/pci/tw68/tw68-core.c                            |   21 +-
 drivers/media/pci/tw68/tw68.h                                 |   16 -
 drivers/media/pci/zoran/zoran.h                               |    7 +-
 drivers/media/pci/zoran/zoran_card.c                          |   11 +-
 drivers/media/pci/zoran/zoran_device.c                        |   18 +-
 drivers/media/pci/zoran/zoran_driver.c                        |  344 +-
 drivers/media/platform/Kconfig                                |   27 +-
 drivers/media/platform/Makefile                               |    2 +
 drivers/media/platform/am437x/am437x-vpfe.c                   |   16 +-
 drivers/media/platform/coda/Makefile                          |    2 +-
 drivers/media/platform/coda/coda-bit.c                        |  147 +-
 drivers/media/platform/coda/coda-common.c                     |  336 +-
 drivers/media/platform/coda/coda-gdi.c                        |  150 +
 drivers/media/platform/coda/coda.h                            |   15 +-
 drivers/media/platform/coda/coda_regs.h                       |   10 +
 drivers/media/platform/coda/trace.h                           |   89 +-
 drivers/media/platform/fsl-viu.c                              |  160 +-
 drivers/media/platform/omap3isp/isp.c                         |  144 +-
 drivers/media/platform/omap3isp/isp.h                         |    7 +-
 drivers/media/platform/omap3isp/ispcsiphy.h                   |    2 +-
 drivers/media/platform/omap3isp/ispvideo.c                    |    9 +-
 {include/media => drivers/media/platform/omap3isp}/omap3isp.h |   42 +-
 drivers/media/platform/rcar_jpu.c                             | 1794 +
 drivers/media/platform/s5p-jpeg/jpeg-core.c                   |   14 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c               |    6 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c                  |    9 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c                  |   11 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h                  |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c               |   12 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c               |    8 +-
 drivers/media/platform/s5p-tv/hdmiphy_drv.c                   |    1 -
 drivers/media/platform/s5p-tv/mixer_reg.c                     |   12 +-
 drivers/media/platform/s5p-tv/sii9234_drv.c                   |    1 -
 drivers/media/platform/sh_veu.c                               |   10 +-
 drivers/media/platform/sh_vou.c                               |  817 +-
 drivers/media/platform/soc_camera/atmel-isi.c                 |  105 +-
 drivers/media/platform/soc_camera/rcar_vin.c                  |   16 +-
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c      |    3 +
 drivers/media/platform/soc_camera/soc_camera.c                |   48 +-
 drivers/media/platform/sti/bdisp/bdisp-debug.c                |    8 +
 drivers/media/platform/sti/bdisp/bdisp-hw.c                   |   12 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c                 |   76 +-
 drivers/media/platform/sti/c8sectpfe/Kconfig                  |   28 +
 drivers/media/platform/sti/c8sectpfe/Makefile                 |    9 +
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-common.c       |  265 +
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-common.h       |   64 +
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c         | 1236 +
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.h         |  288 +
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-debugfs.c      |  271 +
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-debugfs.h      |   26 +
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c          |  244 +
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.h          |   20 +
 drivers/media/platform/vivid/vivid-vid-cap.c                  |    2 +-
 drivers/media/platform/vivid/vivid-vid-out.c                  |   15 +-
 drivers/media/platform/vsp1/vsp1_drv.c                        |   13 +-
 drivers/media/platform/vsp1/vsp1_entity.c                     |   18 +-
 drivers/media/platform/vsp1/vsp1_entity.h                     |    4 +-
 drivers/media/platform/vsp1/vsp1_regs.h                       |    6 +-
 drivers/media/platform/vsp1/vsp1_rwpf.c                       |   11 +
 drivers/media/platform/vsp1/vsp1_video.c                      |   85 +-
 drivers/media/platform/vsp1/vsp1_video.h                      |    5 +-
 drivers/media/platform/xilinx/xilinx-dma.c                    |    4 +-
 drivers/media/radio/radio-tea5764.c                           |    1 -
 drivers/media/radio/saa7706h.c                                |   17 +-
 drivers/media/radio/tef6862.c                                 |    1 -
 drivers/media/radio/wl128x/fmdrv_common.c                     |    5 +-
 drivers/media/rc/Kconfig                                      |   26 +-
 drivers/media/rc/ir-lirc-codec.c                              |    5 +-
 drivers/media/rc/keymaps/rc-lirc.c                            |    2 +-
 drivers/media/rc/keymaps/rc-lme2510.c                         |  132 +-
 drivers/media/rc/rc-ir-raw.c                                  |    2 +-
 drivers/media/rc/rc-main.c                                    |   74 +-
 drivers/media/tuners/Kconfig                                  |    2 +-
 drivers/media/tuners/e4000.c                                  |    1 -
 drivers/media/tuners/fc2580.c                                 |    1 -
 drivers/media/tuners/it913x.c                                 |    1 -
 drivers/media/tuners/m88rs6000t.c                             |    1 -
 drivers/media/tuners/si2157.c                                 |    1 -
 drivers/media/tuners/tda18212.c                               |    1 -
 drivers/media/tuners/tua9001.c                                |    1 -
 drivers/media/usb/airspy/airspy.c                             |    3 -
 drivers/media/usb/cx231xx/cx231xx-video.c                     |    4 +-
 drivers/media/usb/dvb-usb-v2/lmedm04.c                        |   21 +-
 drivers/media/usb/dvb-usb/pctv452e.c                          |    2 +-
 drivers/media/usb/dvb-usb/technisat-usb2.c                    |    2 +-
 drivers/media/usb/em28xx/em28xx-dvb.c                         |    4 -
 drivers/media/usb/go7007/s2250-board.c                        |    1 -
 drivers/media/usb/gspca/m5602/m5602_s5k83a.c                  |    2 +-
 drivers/media/usb/gspca/sn9c2028.c                            |    2 +-
 drivers/media/usb/stk1160/stk1160-core.c                      |    5 +-
 drivers/media/usb/stk1160/stk1160-reg.h                       |   34 +
 drivers/media/usb/stk1160/stk1160-v4l.c                       |  219 +-
 drivers/media/usb/stk1160/stk1160-video.c                     |    4 +-
 drivers/media/usb/stk1160/stk1160.h                           |    4 +-
 drivers/media/usb/ttusb-dec/ttusb_dec.c                       |    9 +-
 drivers/media/usb/usbvision/usbvision-core.c                  |   71 +-
 drivers/media/usb/usbvision/usbvision-i2c.c                   |    2 +-
 drivers/media/usb/usbvision/usbvision-video.c                 |  246 +-
 drivers/media/usb/usbvision/usbvision.h                       |   10 +-
 drivers/media/v4l2-core/Makefile                              |    3 +
 drivers/media/v4l2-core/tuner-core.c                          |    1 -
 drivers/media/v4l2-core/v4l2-ctrls.c                          |   15 -
 drivers/media/v4l2-core/v4l2-dv-timings.c                     |   98 +-
 drivers/media/v4l2-core/v4l2-event.c                          |    3 +
 drivers/media/v4l2-core/v4l2-ioctl.c                          |    6 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c                        |   21 +-
 drivers/media/v4l2-core/v4l2-subdev.c                         |   18 +
 drivers/media/v4l2-core/v4l2-trace.c                          |   11 +
 drivers/media/v4l2-core/videobuf2-core.c                      |   11 +
 drivers/staging/iio/addac/adt7316-i2c.c                       |    1 -
 drivers/staging/iio/light/isl29018.c                          |    1 -
 drivers/staging/iio/light/isl29028.c                          |    1 -
 drivers/staging/media/bcm2048/radio-bcm2048.c                 |   20 +-
 drivers/staging/media/lirc/lirc_imon.c                        |   10 +-
 drivers/staging/media/lirc/lirc_sasem.c                       |    2 +-
 drivers/staging/media/lirc/lirc_zilog.c                       |    2 +-
 drivers/staging/media/mn88472/mn88472.c                       |    1 -
 drivers/staging/media/mn88473/mn88473.c                       |    1 -
 drivers/staging/media/omap4iss/Kconfig                        |    2 +-
 drivers/staging/media/omap4iss/TODO                           |    1 -
 drivers/staging/media/omap4iss/iss_video.c                    |   73 -
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c                 |    1 -
 include/dt-bindings/media/c8sectpfe.h                         |   12 +
 include/linux/pci_ids.h                                       |    9 +
 include/media/media-devnode.h                                 |    4 +
 include/media/rc-core.h                                       |    6 +-
 include/media/rc-map.h                                        |   38 +-
 include/media/tc358743.h                                      |  131 +
 include/media/v4l2-async.h                                    |    8 +-
 include/media/v4l2-ctrls.h                                    | 1018 +-
 include/media/v4l2-dv-timings.h                               |  141 +-
 include/media/v4l2-event.h                                    |   47 +-
 include/media/v4l2-flash-led-class.h                          |   12 +-
 include/media/v4l2-mediabus.h                                 |    4 +-
 include/media/v4l2-mem2mem.h                                  |   20 +
 include/media/v4l2-subdev.h                                   |  376 +-
 include/media/videobuf2-core.h                                |   10 +-
 include/media/videobuf2-memops.h                              |    3 +-
 include/trace/events/v4l2.h                                   |  257 +-
 include/uapi/linux/v4l2-controls.h                            |    4 +
 include/uapi/linux/vsp1.h                                     |    2 +-
 282 files changed, 18648 insertions(+), 4344 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/tc358743.txt
 create mode 100644 Documentation/devicetree/bindings/media/renesas,jpu.txt
 create mode 100644 Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
 create mode 100644 drivers/media/dvb-frontends/ascot2e.c
 create mode 100644 drivers/media/dvb-frontends/ascot2e.h
 create mode 100644 drivers/media/dvb-frontends/cxd2841er.c
 create mode 100644 drivers/media/dvb-frontends/cxd2841er.h
 create mode 100644 drivers/media/dvb-frontends/cxd2841er_priv.h
 create mode 100644 drivers/media/dvb-frontends/horus3a.c
 create mode 100644 drivers/media/dvb-frontends/horus3a.h
 create mode 100644 drivers/media/dvb-frontends/lnbh25.c
 create mode 100644 drivers/media/dvb-frontends/lnbh25.h
 create mode 100644 drivers/media/i2c/tc358743.c
 create mode 100644 drivers/media/i2c/tc358743_regs.h
 create mode 100644 drivers/media/pci/netup_unidvb/Kconfig
 create mode 100644 drivers/media/pci/netup_unidvb/Makefile
 create mode 100644 drivers/media/pci/netup_unidvb/netup_unidvb.h
 create mode 100644 drivers/media/pci/netup_unidvb/netup_unidvb_ci.c
 create mode 100644 drivers/media/pci/netup_unidvb/netup_unidvb_core.c
 create mode 100644 drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c
 create mode 100644 drivers/media/pci/netup_unidvb/netup_unidvb_spi.c
 create mode 100644 drivers/media/pci/smipcie/smipcie-ir.c
 rename drivers/media/pci/smipcie/{smipcie.c => smipcie-main.c} (99%)
 create mode 100644 drivers/media/platform/coda/coda-gdi.c
 rename {include/media => drivers/media/platform/omap3isp}/omap3isp.h (77%)
 create mode 100644 drivers/media/platform/rcar_jpu.c
 create mode 100644 drivers/media/platform/sti/c8sectpfe/Kconfig
 create mode 100644 drivers/media/platform/sti/c8sectpfe/Makefile
 create mode 100644 drivers/media/platform/sti/c8sectpfe/c8sectpfe-common.c
 create mode 100644 drivers/media/platform/sti/c8sectpfe/c8sectpfe-common.h
 create mode 100644 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
 create mode 100644 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.h
 create mode 100644 drivers/media/platform/sti/c8sectpfe/c8sectpfe-debugfs.c
 create mode 100644 drivers/media/platform/sti/c8sectpfe/c8sectpfe-debugfs.h
 create mode 100644 drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c
 create mode 100644 drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.h
 create mode 100644 drivers/media/v4l2-core/v4l2-trace.c
 create mode 100644 include/dt-bindings/media/c8sectpfe.h
 create mode 100644 include/media/tc358743.h

