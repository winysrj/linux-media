Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44494
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752245AbcJKQTB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 12:19:01 -0400
Date: Tue, 11 Oct 2016 13:17:41 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [GIT PULL for v4.9-rc1] media updates
Message-ID: <20161011131741.24f8ec03@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.9-1

For media patches for Kernel 4.9:

- Documentation improvements: conversion of all non-DocBook documents to
  Sphinx and lots of fixes to the uAPI media book;
- New PCI driver for Techwell TW5864 media grabber boards;
- New SoC driver for ATMEL Image Sensor Controller;
- Removal of some obsolete SoC drivers (s5p-tv driver and soc_camera drivers);
- Addition of ST CEC driver;
- Lots of drivers fixes, improvements and additions;

Regards,
Mauro

- 

You should expect a trivial conflict at the MAINTAINERS file, due to the
ATMEL driver.

PS.: This patchset has merges from Jon's docs tree, as several patches on
it depends on the Sphinx build improvements that I sent to Jon to be
merged via his tree. The diffstat generated via this command:

	git request-pull 02bafd96f3a5  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media media/v4.9-1

looks weird, as it included also the changes that were already merged
on your tree via Jonathan's documentation tree. I tested merging on the top
of your master branch here and everything is OK.


The following changes since commit c8d2bc9bc39ebea8437fd974fdbc21847bb897a3:

  Linux 4.8 (2016-10-02 16:24:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.9-1

for you to fetch changes up to 9fce0c226536fc36c7fb0a80000ca38a995be43e:

  Merge tag 'v4.8' into patchwork (2016-10-05 16:43:53 -0300)

----------------------------------------------------------------
media updates for v4.9-rc1

----------------------------------------------------------------
Abylay Ospan (4):
      [media] cxd2841er: freeze/unfreeze registers when reading stats
      [media] cxd2841er: BER and SNR reading for ISDB-T
      [media] cxd2841er: force 8MHz bandwidth for DVB-C if specified bw not supported
      [media] lgdt3306a: remove 20*50 msec unnecessary timeout

Andrey Utkin (4):
      [media] pci: Add tw5864 driver
      [media] tw5864-core: remove excessive irqsave
      [media] tw5864: constify vb2_ops structure
      [media] tw5864: constify struct video_device template

Antti Palosaari (9):
      [media] cxd2820r: improve IF frequency setting
      [media] cxd2820r: dvbv5 statistics for DVB-T
      [media] cxd2820r: dvbv5 statistics for DVB-T2
      [media] cxd2820r: dvbv5 statistics for DVB-C
      [media] cxd2820r: wrap legacy DVBv3 statistics via DVBv5 statistics
      [media] cxd2820r: add I2C driver bindings
      [media] cxd2820r: correct logging
      [media] cxd2820r: improve lock detection
      [media] cxd2820r: convert to regmap api

Arnd Bergmann (8):
      [media] pulse8-cec: avoid uninitialized data use
      [media] Input: atmel_mxt: disallow impossible configuration
      [media] Input: synaptics-rmi4: disallow impossible configuration
      [media] ad5820: use __maybe_unused for PM functions
      [media] atmel-isc: mark PM functions as __maybe_unused
      [media] usb: gadget: uvc: add V4L2 dependency
      [media] dvb-usb: split out common parts of dibusb
      [media] dvb-usb: avoid link error with dib3000m{b,c|

Baoyou Xie (1):
      [media] staging: media: omap4iss: mark omap4iss_flush() static

Benjamin Gaignard (4):
      [media] bindings for stih-cec driver
      [media] add stih-cec driver
      [media] add stih-cec driver into DT
      [media] add maintainer for stih-cec driver

Bhaktipriya Shridhar (9):
      [media] pvrusb2: Remove deprecated create_singlethread_workqueue
      [media] gspca: sonixj: Remove deprecated create_singlethread_workqueue
      [media] gspca: vicam: Remove deprecated create_singlethread_workqueue
      [media] gspca: jl2005bcd: Remove deprecated create_singlethread_workqueue
      [media] gspca: finepix: Remove deprecated create_singlethread_workqueue
      [media] ad9389b: Remove deprecated create_singlethread_workqueue
      [media] s5p-mfc: Remove deprecated create_singlethread_workqueue
      [media] cx25821: Drop Freeing of Workqueue
      [media] cx25821: Remove deprecated create_singlethread_workqueue

Charles-Antoine Couret (3):
      [media] SDI: add flag for SDI formats and SMPTE 125M definition
      [media] V4L2: Add documentation for SDI timings and related flags
      [media] Add GS1662 driver, a video serializer

Christophe JAILLET (2):
      [media] drxd_hard: Add missing error code assignment before test
      [media] s5p-cec: Fix memory allocation failure check

Colin Ian King (4):
      [media] helene: fix memory leak when heleno_x_pon fails
      [media] pxa_camera: fix spelling mistake: "dequeud" -> "dequeued"
      [media] rc/streamzap: fix spelling mistake "sumbiting" -> "submitting"
      [media] lgdt3306a: fix spelling mistake "supportted" -> "supported"

Ezequiel Garcia (2):
      [media] media: tw686x: Rework initial hardware configuration
      [media] media: tw686x: Support frame sizes and frame intervals enumeration

Florian Echtler (1):
      [media] sur40: properly report a single frame rate of 60 FPS

Geert Uytterhoeven (2):
      [media] VIDEO_MEDIATEK_VPU should depend on HAS_DMA
      [media] rcar-fcp: Make sure rcar_fcp_enable() returns 0 on success

Hans Verkuil (38):
      [media] tw686x-kh: remove obsolete driver
      [media] soc-camera/sh_mobile_csi2: remove unused driver
      [media] s5p-tv: remove obsolete driver
      [media] videodev2.h: fix sYCC/AdobeYCC default quantization range
      [media] vivid: don't mention the obsolete sYCC Y'CbCr encoding
      [media] v4l2-tpg-core: drop SYCC, use higher precision 601 conversion matrix
      [media] videodev2.h: put V4L2_YCBCR_ENC_SYCC under #ifndef __KERNEL__
      [media] pixfmt.rst: drop V4L2_YCBCR_ENC_SYCC from the documentation
      [media] pixfmt-007.rst: fix a messed up note in the DCI-P3 doc
      [media] pixfmt-007.rst: fix copy-and-paste error in SMPTE-240M doc
      [media] cobalt: support reduced fps
      [media] v4l2: remove g/s_crop from video ops
      [media] bttv: convert g/s_crop to g/s_selection
      [media] omap_vout: convert g/s_crop to g/s_selection
      [media] saa7134: convert g/s_crop to g/s_selection
      [media] zoran: convert g/s_crop to g/s_selection
      [media] vpfe_capture: convert g/s_crop to g/s_selection
      [media] vpbe_display: convert g/s_crop to g/s_selection
      [media] pvrusb2: convert g/s_crop to g/s_selection
      [media] v4l2-subdev: rename cropcap to g_pixelaspect
      [media] vivid: return -ENODATA if the current input doesn't support g/s_selection
      [media] media: doc-rst: document ENODATA for cropping ioctls
      [media] vb2: don't return NULL for alloc and get_userptr ops
      [media] vb2: add WARN_ONs checking if a valid struct device was passed
      [media] vidioc-g-dv-timings.rst: document the v4l2_bt_timings reserved field
      [media] tw5864: add missing HAS_DMA dependency
      [media] media-types.rst: fix typo
      [media] redrat3: fix sparse warning
      [media] Revert "[media] tw5864: remove double irq lock code"
      [media] vivid: update EDID
      [media] cobalt: update EDID
      [media] pxa_camera: allow building it if COMPILE_TEST is set
      [media] pxa_camera: merge soc_mediabus.c into pxa_camera.c
      [media] pulse8-cec: fix compiler warning
      [media] v4l-drivers/fourcc.rst: fix typo
      [media] media Kconfig: improve the spi integration
      [media] hva: fix sparse warnings
      [media] soc-camera/rcar-vin: remove obsolete driver

Heiner Kallweit (5):
      [media] media: rc: fix deadlock when module ir_lirc_codec is removed
      [media] media: rc: nuvoton: ignore spurious interrupt when logical device is being disabled
      [media] media: rc: nuvoton: remove usage of b_idx in nvt_get_rx_ir_data
      [media] media: rc: nuvoton: remove unneeded call to ir_raw_event_handle
      [media] media: rc: nuvoton: simplify nvt_get_rx_ir_data a little

Jannik Becher (1):
      [media] drivers: hackrf: fixed a coding style issue

Javier Martinez Canillas (11):
      [media] vb2: include lengths in dmabuf qbuf debug message
      [media] vb2: remove TODO comment for dma-buf in QBUF
      [media] s5p-jpeg: set capablity bus_info as required by VIDIOC_QUERYCAP
      [media] exynos4-is: Fix fimc_is_parse_sensor_config() nodes handling
      [media] s5p-jpeg: only fill driver's name in capabilities driver field
      [media] gsc-m2m: add device name sufix to bus_info capatiliby field
      [media] gsc-m2m: improve v4l2_capability driver and card fields
      [media] tvp5150: use sd internal ops .registered instead .registered_async
      [media] v4l2-async: remove unneeded .registered_async callback
      [media] vb2: Fix vb2_core_dqbuf() kernel-doc
      [media] ov9650: add support for asynchronous probing

Jean Delvare (1):
      [media] cec: fix Kconfig help text

Jean-Christophe Trotin (4):
      [media] Documentation: DT: add bindings for ST HVA
      [media] st-hva: multi-format video encoder V4L2 driver
      [media] st-hva: add H.264 video encoding support
      [media] st-hva: update MAINTAINERS

Johan Fjeldtvedt (6):
      [media] cec: allow configuration both from within driver and from user space
      [media] pulse8-cec: serialize communication with adapter
      [media] pulse8-cec: add notes about behavior in autonomous mode
      [media] pulse8-cec: sync configuration with adapter
      [media] pulse8-cec: some small fixes
      [media] pulse8-cec: store logical address mask

Jonathan Corbet (9):
      Merge branch 'doc/4.8-fixes' into docs-next
      Merge branch 'doc/4.8-fixes' into docs-next
      Merge branch 'doc/4.9' into docs-next
      Merge branch 'doc/4.9' into docs-next
      Merge branch 'doc/4.9' into docs-next
      Merge branch 'doc/4.9' into docs-next
      Merge branch 'doc/4.9' into docs-next
      Merge branch 'doc/4.9' into docs-next
      Merge branch 'doc/4.9' into docs-next

Jouni Ukkonen (1):
      [media] media: Add 1X14 14-bit raw bayer media bus code definitions

Julia Lawall (11):
      [media] mtk-vcodec: constify venc_common_if structures
      [media] pci: constify snd_pcm_ops structures
      [media] usb: constify snd_pcm_ops structures
      [media] usb: constify vb2_ops structures
      [media] platform: constify vb2_ops structures
      [media] pci: constify vb2_ops structures
      [media] constify local structures
      [media] dvb-frontends: constify dvb_tuner_ops structures
      [media] tuners: constify dvb_tuner_ops structures
      [media] constify i2c_algorithm structures
      [media] mxl111sf-tuner: constify dvb_tuner_ops structures

Kieran Bingham (9):
      [media] dt-bindings: Update Renesas R-Car FCP DT bindings for FCPF
      [media] dt-bindings: Document Renesas R-Car FCP power-domains usage
      [media] v4l: rcar-fcp: Extend compatible list to support the FDP
      [media] v4l: vsp1: Ensure pipeline locking in resume path
      [media] v4l: vsp1: Repair race between frame end and qbuf handler
      [media] v4l: vsp1: Use DFE instead of FRE for frame end
      [media] v4l: vsp1: Support chained display lists
      [media] v4l: vsp1: Determine partition requirements for scaled images
      [media] v4l: vsp1: Support multiple partitions per frame

Laurent Pinchart (16):
      [media] media: Move media_device link_notify operation to an ops structure
      [media] v4l: ioctl: Clear the v4l2_pix_format_mplane reserved field
      [media] v4l: rcar-fcp: Keep the coding style consistent
      [media] v4l: rcar-fcp: Don't force users to check for disabled FCP support
      [media] v4l: vsp1: Report device model and rev through media device information
      [media] v4l: vsp1: Fix tri-planar format support through DRM API
      [media] v4l: vsp1: Prevent pipelines from running when not streaming
      [media] v4l: vsp1: Protect against race conditions between get and set format
      [media] v4l: vsp1: Disable cropping on WPF sink pad
      [media] v4l: vsp1: Fix RPF cropping
      [media] v4l: vsp1: Pass parameter type to entity configuration operation
      [media] v4l: vsp1: Replace .set_memory() with VSP1_ENTITY_PARAMS_PARTITION
      [media] v4l: vsp1: Fix spinlock in mixed IRQ context function
      [media] v4l: vsp1: Disable VYUY on Gen3
      [media] v4l: doc: Prepare for table reorganization
      [media] v4l: doc: Remove row numbers from tables

Liu Ying (3):
      [media] media-entity.h: remove redundant macro definition for gobj_to_link()
      [media] media-entity.h: Correct KernelDoc of media_entity_enum_empty()
      [media] media-entity.h: remove redundant macro definition for gobj_to_pad()

Marek Szyprowski (4):
      [media] s5p-jpeg: fix system and runtime PM integration
      [media] s5p-cec: fix system and runtime PM integration
      [media] exynos4-is: Add support for all required clocks
      [media] exynos4-is: Improve clock management

Markus Elfring (6):
      [media] cec: Delete an unnecessary check before the function call "rc_free_device"
      [media] v4l2-common: Delete an unnecessary check before the function call "spi_unregister_device"
      [media] tw686x: Delete an unnecessary check before the function call "video_unregister_device"
      [media] dvb_frontend: Use memdup_user() rather than duplicating its implementation
      [media] media/i2c: Delete owner assignment
      [media] radio-si470x-i2c: Delete owner assignment

Matthias Schwarzott (8):
      [media] si2165: avoid division by zero
      [media] si2165: support i2c_client attach
      [media] cx23885: attach si2165 driver via i2c_client
      [media] cx231xx: Prepare for attaching new style i2c_client DVB demod drivers
      [media] cx231xx: attach si2165 driver via i2c_client
      [media] si2165: Remove legacy attach
      [media] si2165: use i2c_client->dev instead of i2c_adapter->dev for logging
      [media] si2165: switch to regmap

Mauro Carvalho Chehab (152):
      Merge tag 'v4.8-rc1' into patchwork
      [media] pixfmt-nv12mt.rst: use PNG instead of GIF
      [media] vidioc-enumstd.rst: fix a broken reference
      [media] vidioc-enumstd.rst: remove bullets from sound carrier
      [media] docs-rst: better use the .. note:: tag
      [media] docs-rst: get rid of code-block inside tables
      [media] vidioc-querycap.rst: Better format tables on PDF output
      [media] docs-rst: re-generate typical_media_device.pdf
      [media] docs-rst: add tabularcolumns to all tables
      [media] control.rst: Fix table width
      [media] extended-controls.rst: fix table sizes
      [media] docs-rst: add column hints for pixfmt-002 and pixfmt-006
      [media] pixfmt-packed-rgb.rst: Fix cell spans
      [media] pixfmt-packed-rgb.rst: adjust tables to fit in LaTeX
      [media] pixfmt-packed-yuv.rst: adjust tables to fit in LaTeX
      [media] docs-rst: remove width hints from pixfmt byte order tables
      [media] buffer.rst: Adjust table columns for LaTeX output
      [media] dev-overlay.rst: don't ident a note
      [media] dev-raw-vbi.rst: add a footnote for the count limits
      [media] dev-raw-vbi.rst: adjust table columns for LaTeX output
      [media] docs-rst: re-generate vbi_525.pdf and vbi_625.pdf
      [media] dev-sliced-vbi.rst: use a footnote for VBI images
      [media] dev-sliced-vbi.rst: Adjust tables on LaTeX output
      [media] dev-rds.rst: adjust table dimentions for LaTeX
      [media] dev-subdev.rst: make table fully visible on LaTeX
      [media] subdev-formats.rst: adjust most of the tables to fill in page
      [media] diff-v4l.rst: Make capabilities table fit in LaTeX
      [media] vidioc-decoder-cmd.rst: better adjust column widths
      [media] vidioc-dqevent.rst: adjust two table columns for LaTeX output
      [media] vidioc-dv-timings-cap.rst: Adjust LaTeX columns
      [media] vidioc-enumstd.rst: adjust video standards table
      [media] vidioc-g-sliced-vbi-cap.rst: make tables fit on LaTeX output
      [media] adjust some vidioc-*rst tables with wrong columns
      [media] vidioc-g-tuner.rst: improve documentation for tuner type
      [media] vidioc-g-tuner.rst: Fix tables to fit at LaTeX output
      [media] fix v4l2-selection-*.rst tables for LaTeX output
      [media] fe_property_parameters.rst: Adjust column sizes
      [media] adjust remaining tables at DVB uAPI documentation
      [media] media-types.rst: adjust tables to fit on LaTeX output
      [media] docs-rst: move cec kAPI documentation to the media book
      [media] cec-core: Convert it to ReST format
      [media] uapi/cec: adjust tables on LaTeX output
      [media] gen-errors.rst fix error table column limits
      [media] docs-rst: fix warnings introduced by LaTeX patchset
      [media] Fix a few additional tables at uAPI for LaTeX output
      [media] extended-controls.rst: avoid going past page with LaTeX
      [media] subdev-formats.rst: adjust tables size for LaTeX output
      [media] cec-ioc-receive.rst: one table here should be longtable
      [media] v4l2-dev.rst: adjust table to fit into page
      [media] docs-rst: v4l2-drivers book: adjust column margins
      [media] docs-rst: fix some LaTeX errors when in interactive mode
      [media] docs-rst: fix some .. note:: occurrences
      Merge remote-tracking branch 'docs-next/docs-next' into devel/docs-next
      [media] pixfmt-007.rst: use Sphinx math:: expressions
      [media] docs-next: stop abusing on the cpp domain
      [media] docs-rst: Convert V4L2 uAPI to use C function references
      [media] docs-rst: Convert DVB uAPI to use C function references
      [media] docs-rst: Convert CEC uAPI to use C function references
      [media] docs-rst: Convert LIRC uAPI to use C function references
      [media] docs-rst: Convert MC uAPI to use C function references
      [media] index.rst: Fix LaTeX error in interactive mode on Sphinx 1.4.x
      [media] docs-rst: fix some .. note:: occurrences
      docs-rst: add media documentation to PDF output
      [media] ad5820: fix one smatch warning
      [media] extended-controls.rst: fix a build warning
      [media] tw5864: remove double irq lock code
      [media] tw5864: remove two unused vars
      Merge branch 'docs-next' of git://git.lwn.net/linux into patchwork
      [media] tda18271: use prefix on all printk messages
      [media] tea5767: use module prefix on printed messages
      [media] mb86a20s: fix the locking logic
      [media] mb86a20s: fix demod settings
      [media] cx231xx: don't return error on success
      [media] cx231xx: fix GPIOs for Pixelview SBTVD hybrid
      [media] cx231xx: prints error code if can't switch TV mode
      [media] cx231xx-core: fix GPIO comments
      [media] cx231xx-i2c: handle errors with cx231xx_get_i2c_adap()
      [media] cx231xx: can't proceed if I2C bus register fails
      [media] cx231xx-cards: unregister IR earlier
      [media] docs-rst: parse-headers.pl: make debug a command line option
      [media] docs-rst: parse-headers.pl: use the C domain for cross-references
      [media] conf_nitpick.py: add external vars to ignore list
      [media] dvb_ringbuffer.h: Document all functions
      [media] dtv-core.rst: move DTV ringbuffer notes to kAPI doc
      [media] dvb_ringbuffer.h: document the define macros
      [media] demux.h: Fix a few documentation issues
      [media] mc-core.rst: Fix cross-references to the source
      [media] demux.h: fix a documentation warning
      [media] docs-rst: improve the kAPI documentation for the mediactl
      [media] conf_nitpick.py: ignore external functions used on mediactl
      [media] rc-map.h: document structs/enums on it
      [media] v4l2-ctrls: document some extra data structures
      [media] docs-rst: convert uAPI structs to C domain
      [media] diff-v4l.rst: Fix V4L version 1 references
      [media] v4l2-ctrls.h: fix doc reference for prepare_ext_ctrls()
      [media] docs-rst: use C domain for enum references on uapi
      [media] v4l2-ctrls.h: Fix some c:type references
      [media] cec-ioc-dqevent.rst: fix some undefined references
      [media] v4l2-ioctl.h: document the remaining functions
      [media] v4l2-dev.rst: fix a broken c domain reference
      [media] v4l2-device.h: fix some doc tags
      [media] v4l2-dv-timings.h: let kernel-doc parte the typedef argument
      [media] v4l2-subdev.rst: get rid of legacy functions
      [media] v4l2-subdev.h: fix a doc nitpick warning
      [media] docs-rst exceptions: use C domain references for DVB headers
      [media] ca-get-cap.rst: add a table for struct ca_caps
      [media] ca-get-descr-info.rst: add doc for for struct ca_descr_info
      [media] ca-get-msg.rst: add a boilerplate for struct ca_msg
      [media] ca-get-slot-info.rst: document struct ca_slot_info
      [media] ca-set-pid.rst: document struct ca_pid
      [media] docs-rst: fix the remaining broken links for DVB CA API
      [media] fix broken references on dvb/video*rst
      [media] docs-rst: fix dmx bad cross-references
      [media] docs-rst: fix cec bad cross-references
      [media] docs-rst: simplify c:type: cross references
      [media] docs-rst: fix some broken struct references
      [media] fix clock_gettime cross-references
      [media] libv4l-introdution.rst: fix function definitions
      [media] libv4l-introduction.rst: improve crossr-references
      [media] hist-v4l2.rst: don't do refs to old structures
      [media] docs-rst: fix cross-references for videodev2.h
      [media] dev-sliced-vbi.rst: fix reference for v4l2_mpeg_vbi_ITV0
      [media] media-ioc-g-topology.rst: fix a c domain reference
      [media] docs-rst: fix two wrong :name: tags
      [media] rc-map.h: fix a Sphinx warning
      [media] mc-core.rst: fix a warning about an internal routine
      [media] v4l2-mem2mem.h: move descriptions from .c file
      [media] v4l2-mem2mem.h: document function arguments
      [media] v4l2-mem2mem.h: document the public structures
      [media] v4l2-mem2mem.h: make kernel-doc parse v4l2-mem2mem.h again
      [media] conf_nitpick.py: ignore an opaque struct from v4l2-mem2mem.h
      [media] videobuf2-core.h: move function descriptions from c file
      [media] videobuf2-core.h: document enum vb2_memory
      [media] videobuf2-core.h: improve documentation
      [media] conf_nitpick.py: ignore C domain data used on vb2
      [media] videobuf2-v4l2.h: get kernel-doc tags from C file
      [media] videobuf2-v4l2.h: improve documentation
      [media] videobuf2-v4l2: document two helper functions
      [media] v4l2-flash-led-class.h: document v4l2_flash_ops
      [media] v4l2-subdev: fix some references to v4l2_dev
      [media] v4l2-subdev.h: fix a typo at a kernel-doc markup
      [media] pxa_camera: make soc_mbus_xlate_by_fourcc() static
      [media] pxa_camera: remove an unused structure pointer
      MAINTAINERS: update documentation for media subsystem
      [media] videodev2.h.rst.exceptions: fix warnings
      [media] gs1662: make checkpatch happy
      [media] vsp1: fix CodingStyle violations on multi-line comments
      Merge tag 'docs-next' of git://git.lwn.net/linux.git into patchwork
      [media] get rid of a number of problems at the cross references
      [media] cx23885: Fix some smatch warnings
      [media] ttusb_dec: avoid the risk of go past buffer
      Merge tag 'v4.8' into patchwork

Nick Dyer (12):
      [media] Input: atmel_mxt_ts - update MAINTAINERS email address
      [media] v4l2-core: Add support for touch devices
      [media] Input: atmel_mxt_ts - add support for T37 diagnostic data
      [media] Input: atmel_mxt_ts - output diagnostic debug via V4L2 device
      [media] Input: atmel_mxt_ts - read touchscreen size
      [media] Input: atmel_mxt_ts - handle diagnostic data orientation
      [media] Input: atmel_mxt_ts - add diagnostic data support for mXT1386
      [media] Input: atmel_mxt_ts - add support for reference data
      [media] Input: synaptics-rmi4 - add support for F54 diagnostics
      [media] Input: sur40 - use new V4L2 touch input type
      [media] Documentation: add support for V4L touch devices
      [media] Input: v4l-touch - add copyright lines

Niklas Söderlund (18):
      [media] rcar-vin: fix indentation errors in rcar-v4l2.c
      [media] rcar-vin: reduce indentation in rvin_s_dv_timings()
      [media] rcar-vin: arrange enum chip_id in chronological order
      [media] rcar-vin: rename entity to digital
      [media] rcar-vin: return correct error from platform_get_irq()
      [media] rcar-vin: do not use v4l2_device_call_until_err()
      [media] rcar-vin: add dependency on MEDIA_CONTROLLER
      [media] rcar-vin: move chip check for pixelformat support
      [media] rcar-vin: rework how subdevice is found and bound
      [media] rcar-vin: move media bus information to struct rvin_graph_entity
      [media] adv7180: rcar-vin: change mbus format to UYVY
      [media] media: adv7180: fill in mbus format in set_fmt
      [media] media: rcar-vin: make V4L2_FIELD_INTERLACED standard dependent
      [media] media: rcar-vin: allow field to be changed
      [media] media: rcar-vin: fix bug in scaling
      [media] media: rcar-vin: fix height for TOP and BOTTOM fields
      [media] media: rcar-vin: add support for V4L2_FIELD_ALTERNATE
      [media] MAINTAINERS: Add entry for the Renesas VIN driver

Ole Ernst (1):
      [media] Partly revert "[media] rc-core: allow calling rc_open with device not initialized"

Pavel Machek (2):
      [media] dt/bindings: device tree description for AD5820 camera auto-focus coil
      [media] ad5820: Add driver for auto-focus coil

Peter Ujfalusi (1):
      [media] m2m-deinterlace: Fix error print during probe

Ricardo Ribalda Delgado (1):
      [media] Documentation: Fix V4L2_CTRL_FLAG_VOLATILE

Robert Jarzmik (14):
      [media] media: mt9m111: make a standalone v4l2 subdevice
      [media] media: mt9m111: use only the SRGB colorspace
      [media] media: mt9m111: move mt9m111 out of soc_camera
      [media] media: platform: pxa_camera: convert to vb2
      [media] media: platform: pxa_camera: trivial move of functions
      [media] media: platform: pxa_camera: introduce sensor_call
      [media] media: platform: pxa_camera: make printk consistent
      [media] media: platform: pxa_camera: add buffer sequencing
      [media] media: platform: pxa_camera: remove set_selection
      [media] media: platform: pxa_camera: make a standalone v4l2 device
      [media] media: platform: pxa_camera: add debug register access
      [media] media: platform: pxa_camera: change stop_streaming semantics
      [media] media: platform: pxa_camera: move pxa_camera out of soc_camera
      [media] media: platform: pxa_camera: fix style

Sakari Ailus (19):
      [media] v4l: Do not allow re-registering sub-devices
      [media] smiapp: Unify enforced and need-based 8-bit read
      [media] smiapp: Rename smiapp_platform_data as smiapp_hwconfig
      [media] smiapp: Return -EPROBE_DEFER if the clock cannot be obtained
      [media] smiapp: Constify the regs argument to smiapp_write_8s()
      [media] smiapp: Switch to gpiod API for GPIO control
      [media] smiapp: Remove set_xclk() callback from hwconfig
      [media] doc-rst: Correct the ordering of LSBs of the 10-bit raw packed formats
      [media] doc-rst: Fix number of zeroed high order bits in 12-bit raw format defs
      [media] doc-rst: Clean up raw bayer pixel format definitions
      [media] doc-rst: Unify documentation of the 8-bit bayer formats
      [media] doc-rst: 16-bit BGGR is always 16 bits
      [media] media: Add 1X16 16-bit raw bayer media bus code definitions
      [media] smiapp: Add support for 14 and 16 bits per sample depths
      [media] ad5820: Use bool for boolean values
      [media] media: Determine early whether an IOCTL is supported
      [media] media: Unify IOCTL handler calling
      [media] media: Refactor copying IOCTL arguments from and to user space
      [media] media: Add flags to tell whether to take graph mutex for an IOCTL

Sean Young (5):
      [media] rc: rc6 decoder should report protocol correctly
      [media] rc: Hauppauge z8f0811 can decode RC6
      [media] rc: split nec protocol into its three variants
      [media] redrat3: remove hw_timeout member
      [media] redrat3: hardware-specific parameters

Sergei Shtylyov (2):
      [media] v4l: vsp1: Add R8A7792 VSP1V support
      [media] rcar-vin: add R-Car gen2 fallback compatibility string

Shuah Khan (6):
      [media] media: Doc s5p-mfc add missing fields to s5p_mfc_dev structure definition
      [media] media: s5p-mfc fix invalid memory access from s5p_mfc_release()
      [media] media: s5p-mfc remove void function return statement
      [media] media: s5p-mfc Fix misspelled error message and checkpatch errors
      [media] media: s5p-mfc remove unnecessary error messages
      [media] media: s5p-jpeg add missing blank lines after declarations

Songjun Wu (5):
      [media] atmel-isc: add the Image Sensor Controller code
      [media] atmel-isc: DT binding for Image Sensor Controller driver
      [media] MAINTAINERS: atmel-isc: add entry for Atmel ISC
      [media] atmel-isc: remove the warning
      [media] atmel-isc: set the format on the first open

Stanimir Varbanov (1):
      [media] media: v4l2-ctrls: append missing h264 profile string

Stephen Backway (1):
      [media] cx23885: Add support for Hauppauge WinTV quadHD ATSC version

Steve Longerbeam (2):
      [media] media: adv7180: define more registers
      [media] media: adv7180: add power pin control

Sylwester Nawrocki (5):
      [media] exynos4-is: Add missing entity function initialization
      [media] s5k6a3: Add missing entity function initialization
      [media] s5c73m3: Fix entity function assignment for the OIF subdev
      [media] exynos4-is: Clear isp-i2c adapter power.ignore_children flag
      [media] exynos4-is: add of_platform_populate() call for FIMC-IS child devices

Terry Heo (1):
      [media] cx231xx: reset pipe endpoint when it is stalled

Tiffany Lin (2):
      [media] vcodec: mediatek: Add g/s_selection support for V4L2 Encoder
      [media] vcodec: mediatek: Add V4L2_CAP_TIMEPERFRAME capability setting

Ulrich Hecht (2):
      [media] rcar-vin: implement EDID control ioctls
      [media] media: rcar-vin: use sink pad index for DV timings

Wei Yongjun (6):
      [media] s5p-mfc: remove redundant return value check of platform_get_resource()
      [media] adv7511: fix error return code in adv7511_probe()
      [media] pxa_camera: fix error return code in pxa_camera_probe()
      [media] pxa_camera: remove duplicated include from pxa_camera.c
      [media] vivid: fix error return code in vivid_create_instance()
      [media] staging: lirc: add missing platform_device_del() on error

Wolfram Sang (34):
      [media] media: dvb-frontends: rtl2832_sdr: don't print error when allocating urb fails
      [media] media: radio: si470x: radio-si470x-usb: don't print error when allocating urb fails
      [media] media: rc: imon: don't print error when allocating urb fails
      [media] media: rc: redrat3: don't print error when allocating urb fails
      [media] media: usb: airspy: airspy: don't print error when allocating urb fails
      [media] media: usb: as102: as102_usb_drv: don't print error when allocating urb fails
      [media] media: usb: au0828: au0828-video: don't print error when allocating urb fails
      [media] media: usb: cpia2: cpia2_usb: don't print error when allocating urb fails
      [media] media: usb: cx231xx: cx231xx-audio: don't print error when allocating urb fails
      [media] media: usb: cx231xx: cx231xx-core: don't print error when allocating urb fails
      [media] media: usb: cx231xx: cx231xx-vbi: don't print error when allocating urb fails
      [media] media: usb: dvb-usb: dib0700_core: don't print error when allocating urb fails
      [media] media: usb: em28xx: em28xx-audio: don't print error when allocating urb fails
      [media] media: usb: em28xx: em28xx-core: don't print error when allocating urb fails
      [media] media: usb: gspca: benq: don't print error when allocating urb fails
      [media] media: usb: gspca: gspca: don't print error when allocating urb fails
      [media] media: usb: gspca: konica: don't print error when allocating urb fails
      [media] media: usb: hackrf: hackrf: don't print error when allocating urb fails
      [media] media: usb: hdpvr: hdpvr-video: don't print error when allocating urb fails
      [media] media: usb: msi2500: msi2500: don't print error when allocating urb fails
      [media] media: usb: pwc: pwc-if: don't print error when allocating urb fails
      [media] media: usb: s2255: s2255drv: don't print error when allocating urb fails
      [media] media: usb: stk1160: stk1160-video: don't print error when allocating urb fails
      [media] media: usb: stkwebcam: stk-webcam: don't print error when allocating urb fails
      [media] media: usb: tm6000: tm6000-dvb: don't print error when allocating urb fails
      [media] media: usb: tm6000: tm6000-video: don't print error when allocating urb fails
      [media] media: usb: usbvision: usbvision-core: don't print error when allocating urb fails
      [media] media: usb: zr364xx: zr364xx: don't print error when allocating urb fails
      [media] exynos4-is: fimc-is-i2c: don't print error when adding adapter fails
      [media] media: pci: netup_unidvb: don't print error when adding adapter fails
      [media] media: usb: dvb-usb-v2: dvb_usb_core: don't print error when adding adapter fails
      [media] media: pci: pt3: don't print error when adding adapter fails
      [media] staging: media: lirc: lirc_imon: don't print error when allocating urb fails
      [media] staging: media: lirc: lirc_sasem: don't print error when allocating urb fails

 Documentation/CodingStyle                          |    28 +-
 Documentation/DMA-API-HOWTO.txt                    |     6 +-
 Documentation/DocBook/Makefile                     |    10 +-
 Documentation/DocBook/device-drivers.tmpl          |   521 -
 Documentation/Makefile.sphinx                      |    64 +-
 Documentation/arm/sunxi/README                     |    11 +-
 Documentation/clk.txt                              |    42 +-
 Documentation/conf.py                              |   104 +-
 .../{coccinelle.txt => dev-tools/coccinelle.rst}   |   359 +-
 Documentation/dev-tools/gcov.rst                   |   256 +
 .../gdb-kernel-debugging.rst}                      |    77 +-
 Documentation/dev-tools/kasan.rst                  |   173 +
 Documentation/{kcov.txt => dev-tools/kcov.rst}     |    84 +-
 Documentation/dev-tools/kmemcheck.rst              |   733 +
 .../{kmemleak.txt => dev-tools/kmemleak.rst}       |    93 +-
 Documentation/{sparse.txt => dev-tools/sparse.rst} |    39 +-
 Documentation/dev-tools/tools.rst                  |    25 +
 Documentation/{ubsan.txt => dev-tools/ubsan.rst}   |    42 +-
 .../devicetree/bindings/media/atmel-isc.txt        |    65 +
 .../devicetree/bindings/media/exynos4-fimc-is.txt  |     7 +-
 .../devicetree/bindings/media/i2c/ad5820.txt       |    19 +
 .../devicetree/bindings/media/i2c/adv7180.txt      |     5 +
 .../devicetree/bindings/media/renesas,fcp.txt      |     9 +-
 .../devicetree/bindings/media/st,st-hva.txt        |    24 +
 .../devicetree/bindings/media/stih-cec.txt         |    25 +
 Documentation/docutils.conf                        |     7 +
 Documentation/driver-api/basics.rst                |   120 +
 Documentation/driver-api/frame-buffer.rst          |    62 +
 Documentation/driver-api/hsi.rst                   |    88 +
 Documentation/driver-api/i2c.rst                   |    46 +
 Documentation/driver-api/index.rst                 |    26 +
 Documentation/driver-api/infrastructure.rst        |   169 +
 Documentation/driver-api/input.rst                 |    51 +
 Documentation/driver-api/message-based.rst         |    12 +
 Documentation/driver-api/miscellaneous.rst         |    50 +
 Documentation/driver-api/sound.rst                 |    54 +
 Documentation/driver-api/spi.rst                   |    53 +
 Documentation/driver-model/device.txt              |     2 +-
 Documentation/filesystems/proc.txt                 |     2 +-
 Documentation/gcov.txt                             |   257 -
 Documentation/gpu/conf.py                          |     5 +
 Documentation/gpu/index.rst                        |     7 +
 Documentation/hsi.txt                              |    75 -
 Documentation/index.rst                            |    10 +-
 Documentation/ioctl/botching-up-ioctls.txt         |    13 +-
 Documentation/kasan.txt                            |   171 -
 Documentation/kbuild/kconfig-language.txt          |    39 +-
 Documentation/kernel-documentation.rst             |    29 +
 Documentation/kernel-parameters.txt                |    24 +-
 Documentation/kmemcheck.txt                        |   754 -
 Documentation/kprobes.txt                          |    10 +
 Documentation/media/Makefile                       |     3 +-
 Documentation/media/audio.h.rst.exceptions         |     6 +-
 Documentation/media/ca.h.rst.exceptions            |    32 +-
 Documentation/media/cec.h.rst.exceptions           |     6 -
 Documentation/media/conf.py                        |    10 +
 Documentation/media/conf_nitpick.py                |   109 +
 Documentation/media/dmx.h.rst.exceptions           |    85 +-
 Documentation/media/frontend.h.rst.exceptions      |     8 +-
 Documentation/media/index.rst                      |    24 +
 Documentation/media/intro.rst                      |     2 +-
 Documentation/{cec.txt => media/kapi/cec-core.rst} |   147 +-
 Documentation/media/kapi/dtv-core.rst              |    40 +-
 Documentation/media/kapi/mc-core.rst               |    25 +-
 Documentation/media/kapi/v4l2-dev.rst              |    10 +-
 Documentation/media/kapi/v4l2-event.rst            |     6 +-
 Documentation/media/kapi/v4l2-fh.rst               |     4 +-
 Documentation/media/kapi/v4l2-subdev.rst           |    23 +-
 .../media/media_api_files/typical_media_device.pdf |   Bin 134268 -> 52895 bytes
 Documentation/media/media_kapi.rst                 |     1 +
 Documentation/media/net.h.rst.exceptions           |     4 +-
 Documentation/media/uapi/cec/cec-func-close.rst    |     9 +-
 Documentation/media/uapi/cec/cec-func-ioctl.rst    |    11 +-
 Documentation/media/uapi/cec/cec-func-open.rst     |     9 +-
 Documentation/media/uapi/cec/cec-func-poll.rst     |    18 +-
 Documentation/media/uapi/cec/cec-intro.rst         |     4 +-
 .../media/uapi/cec/cec-ioc-adap-g-caps.rst         |    16 +-
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    |    31 +-
 .../media/uapi/cec/cec-ioc-adap-g-phys-addr.rst    |    17 +-
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   |    38 +-
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst    |    20 +-
 Documentation/media/uapi/cec/cec-ioc-receive.rst   |    38 +-
 .../uapi/dvb/audio-bilingual-channel-select.rst    |    15 +-
 .../media/uapi/dvb/audio-channel-select.rst        |    14 +-
 .../media/uapi/dvb/audio-clear-buffer.rst          |    12 +-
 Documentation/media/uapi/dvb/audio-continue.rst    |    11 +-
 Documentation/media/uapi/dvb/audio-fclose.rst      |     4 +-
 Documentation/media/uapi/dvb/audio-fopen.rst       |     6 +-
 Documentation/media/uapi/dvb/audio-fwrite.rst      |     4 +-
 .../media/uapi/dvb/audio-get-capabilities.rst      |    14 +-
 Documentation/media/uapi/dvb/audio-get-pts.rst     |    14 +-
 Documentation/media/uapi/dvb/audio-get-status.rst  |    14 +-
 Documentation/media/uapi/dvb/audio-pause.rst       |    11 +-
 Documentation/media/uapi/dvb/audio-play.rst        |    11 +-
 .../media/uapi/dvb/audio-select-source.rst         |    14 +-
 .../media/uapi/dvb/audio-set-attributes.rst        |    16 +-
 Documentation/media/uapi/dvb/audio-set-av-sync.rst |    24 +-
 .../media/uapi/dvb/audio-set-bypass-mode.rst       |    25 +-
 Documentation/media/uapi/dvb/audio-set-ext-id.rst  |    15 +-
 Documentation/media/uapi/dvb/audio-set-id.rst      |    15 +-
 Documentation/media/uapi/dvb/audio-set-karaoke.rst |    14 +-
 Documentation/media/uapi/dvb/audio-set-mixer.rst   |    15 +-
 Documentation/media/uapi/dvb/audio-set-mute.rst    |    24 +-
 .../media/uapi/dvb/audio-set-streamtype.rst        |    14 +-
 Documentation/media/uapi/dvb/audio-stop.rst        |    11 +-
 Documentation/media/uapi/dvb/audio_data_types.rst  |    37 +-
 Documentation/media/uapi/dvb/ca-fclose.rst         |    18 +-
 Documentation/media/uapi/dvb/ca-fopen.rst          |    51 +-
 Documentation/media/uapi/dvb/ca-get-cap.rst        |    51 +-
 Documentation/media/uapi/dvb/ca-get-descr-info.rst |    44 +-
 Documentation/media/uapi/dvb/ca-get-msg.rst        |    47 +-
 Documentation/media/uapi/dvb/ca-get-slot-info.rst  |    92 +-
 Documentation/media/uapi/dvb/ca-reset.rst          |    24 +-
 Documentation/media/uapi/dvb/ca-send-msg.rst       |    30 +-
 Documentation/media/uapi/dvb/ca-set-descr.rst      |    30 +-
 Documentation/media/uapi/dvb/ca-set-pid.rst        |    37 +-
 Documentation/media/uapi/dvb/ca_data_types.rst     |    12 +-
 Documentation/media/uapi/dvb/dmx-add-pid.rst       |    28 +-
 Documentation/media/uapi/dvb/dmx-fclose.rst        |    16 +-
 Documentation/media/uapi/dvb/dmx-fopen.rst         |    45 +-
 Documentation/media/uapi/dvb/dmx-fread.rst         |    34 +-
 Documentation/media/uapi/dvb/dmx-fwrite.rst        |    34 +-
 Documentation/media/uapi/dvb/dmx-get-caps.rst      |    32 +-
 Documentation/media/uapi/dvb/dmx-get-event.rst     |    28 +-
 Documentation/media/uapi/dvb/dmx-get-pes-pids.rst  |    31 +-
 Documentation/media/uapi/dvb/dmx-get-stc.rst       |    31 +-
 Documentation/media/uapi/dvb/dmx-remove-pid.rst    |    28 +-
 .../media/uapi/dvb/dmx-set-buffer-size.rst         |    29 +-
 Documentation/media/uapi/dvb/dmx-set-filter.rst    |    28 +-
 .../media/uapi/dvb/dmx-set-pes-filter.rst          |    29 +-
 Documentation/media/uapi/dvb/dmx-set-source.rst    |    29 +-
 Documentation/media/uapi/dvb/dmx-start.rst         |    24 +-
 Documentation/media/uapi/dvb/dmx-stop.rst          |    22 +-
 Documentation/media/uapi/dvb/dmx_types.rst         |    40 +-
 Documentation/media/uapi/dvb/dtv-fe-stats.rst      |     2 +-
 Documentation/media/uapi/dvb/dtv-properties.rst    |     2 +-
 Documentation/media/uapi/dvb/dtv-property.rst      |     2 +-
 Documentation/media/uapi/dvb/dtv-stats.rst         |     2 +-
 .../media/uapi/dvb/dvb-fe-read-status.rst          |     4 +-
 .../media/uapi/dvb/dvb-frontend-event.rst          |     2 +-
 .../media/uapi/dvb/dvb-frontend-parameters.rst     |    10 +-
 Documentation/media/uapi/dvb/dvbapi.rst            |     4 +-
 Documentation/media/uapi/dvb/dvbproperty.rst       |     6 +-
 Documentation/media/uapi/dvb/examples.rst          |     4 +-
 Documentation/media/uapi/dvb/fe-bandwidth-t.rst    |     5 +-
 .../media/uapi/dvb/fe-diseqc-recv-slave-reply.rst  |    13 +-
 .../media/uapi/dvb/fe-diseqc-reset-overload.rst    |     7 +-
 .../media/uapi/dvb/fe-diseqc-send-burst.rst        |    15 +-
 .../media/uapi/dvb/fe-diseqc-send-master-cmd.rst   |    14 +-
 .../uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst    |    16 +-
 .../media/uapi/dvb/fe-enable-high-lnb-voltage.rst  |     6 +-
 Documentation/media/uapi/dvb/fe-get-event.rst      |    35 +-
 Documentation/media/uapi/dvb/fe-get-frontend.rst   |    30 +-
 Documentation/media/uapi/dvb/fe-get-info.rst       |    24 +-
 Documentation/media/uapi/dvb/fe-get-property.rst   |    11 +-
 Documentation/media/uapi/dvb/fe-read-ber.rst       |    30 +-
 .../media/uapi/dvb/fe-read-signal-strength.rst     |    31 +-
 Documentation/media/uapi/dvb/fe-read-snr.rst       |    29 +-
 Documentation/media/uapi/dvb/fe-read-status.rst    |    19 +-
 .../media/uapi/dvb/fe-read-uncorrected-blocks.rst  |    31 +-
 .../media/uapi/dvb/fe-set-frontend-tune-mode.rst   |     6 +-
 Documentation/media/uapi/dvb/fe-set-frontend.rst   |    31 +-
 Documentation/media/uapi/dvb/fe-set-tone.rst       |    15 +-
 Documentation/media/uapi/dvb/fe-set-voltage.rst    |    10 +-
 Documentation/media/uapi/dvb/fe-type-t.rst         |    10 +-
 .../media/uapi/dvb/fe_property_parameters.rst      |    77 +-
 .../media/uapi/dvb/frontend-stat-properties.rst    |     2 +-
 Documentation/media/uapi/dvb/frontend.rst          |     4 +-
 Documentation/media/uapi/dvb/frontend_f_close.rst  |     6 +-
 Documentation/media/uapi/dvb/frontend_f_open.rst   |     4 +-
 Documentation/media/uapi/dvb/net-add-if.rst        |    18 +-
 Documentation/media/uapi/dvb/net-get-if.rst        |    12 +-
 Documentation/media/uapi/dvb/net-remove-if.rst     |     6 +-
 .../media/uapi/dvb/video-clear-buffer.rst          |     4 +-
 Documentation/media/uapi/dvb/video-command.rst     |    34 +-
 Documentation/media/uapi/dvb/video-continue.rst    |     4 +-
 .../media/uapi/dvb/video-fast-forward.rst          |     4 +-
 Documentation/media/uapi/dvb/video-fclose.rst      |     3 +-
 Documentation/media/uapi/dvb/video-fopen.rst       |     5 +-
 Documentation/media/uapi/dvb/video-freeze.rst      |     4 +-
 Documentation/media/uapi/dvb/video-fwrite.rst      |     3 +-
 .../media/uapi/dvb/video-get-capabilities.rst      |     4 +-
 Documentation/media/uapi/dvb/video-get-event.rst   |    21 +-
 .../media/uapi/dvb/video-get-frame-count.rst       |     4 +-
 .../media/uapi/dvb/video-get-frame-rate.rst        |     4 +-
 Documentation/media/uapi/dvb/video-get-navi.rst    |    12 +-
 Documentation/media/uapi/dvb/video-get-pts.rst     |     4 +-
 Documentation/media/uapi/dvb/video-get-size.rst    |    14 +-
 Documentation/media/uapi/dvb/video-get-status.rst  |    15 +-
 Documentation/media/uapi/dvb/video-play.rst        |     4 +-
 .../media/uapi/dvb/video-select-source.rst         |    14 +-
 .../media/uapi/dvb/video-set-attributes.rst        |    20 +-
 Documentation/media/uapi/dvb/video-set-blank.rst   |     4 +-
 .../media/uapi/dvb/video-set-display-format.rst    |     4 +-
 Documentation/media/uapi/dvb/video-set-format.rst  |    13 +-
 .../media/uapi/dvb/video-set-highlight.rst         |    28 +-
 Documentation/media/uapi/dvb/video-set-id.rst      |     4 +-
 .../media/uapi/dvb/video-set-spu-palette.rst       |    12 +-
 Documentation/media/uapi/dvb/video-set-spu.rst     |    13 +-
 .../media/uapi/dvb/video-set-streamtype.rst        |     4 +-
 Documentation/media/uapi/dvb/video-set-system.rst  |     4 +-
 Documentation/media/uapi/dvb/video-slowmotion.rst  |     4 +-
 .../media/uapi/dvb/video-stillpicture.rst          |     4 +-
 Documentation/media/uapi/dvb/video-stop.rst        |     4 +-
 Documentation/media/uapi/dvb/video-try-command.rst |     4 +-
 Documentation/media/uapi/dvb/video_types.rst       |    16 +-
 Documentation/media/uapi/gen-errors.rst            |     2 +
 .../media/uapi/mediactl/media-func-close.rst       |     6 +-
 .../media/uapi/mediactl/media-func-ioctl.rst       |     6 +-
 .../media/uapi/mediactl/media-func-open.rst        |     4 +-
 .../media/uapi/mediactl/media-ioc-device-info.rst  |    12 +-
 .../uapi/mediactl/media-ioc-enum-entities.rst      |    14 +-
 .../media/uapi/mediactl/media-ioc-enum-links.rst   |    34 +-
 .../media/uapi/mediactl/media-ioc-g-topology.rst   |    28 +-
 .../media/uapi/mediactl/media-ioc-setup-link.rst   |    10 +-
 Documentation/media/uapi/mediactl/media-types.rst  |    40 +-
 Documentation/media/uapi/rc/lirc-get-features.rst  |     6 +-
 Documentation/media/uapi/rc/lirc-get-length.rst    |     6 +-
 Documentation/media/uapi/rc/lirc-get-rec-mode.rst  |    11 +-
 .../media/uapi/rc/lirc-get-rec-resolution.rst      |     6 +-
 Documentation/media/uapi/rc/lirc-get-send-mode.rst |     9 +-
 Documentation/media/uapi/rc/lirc-get-timeout.rst   |     9 +-
 Documentation/media/uapi/rc/lirc-read.rst          |     7 +-
 .../uapi/rc/lirc-set-measure-carrier-mode.rst      |     6 +-
 .../media/uapi/rc/lirc-set-rec-carrier-range.rst   |     6 +-
 .../media/uapi/rc/lirc-set-rec-carrier.rst         |     6 +-
 .../media/uapi/rc/lirc-set-rec-timeout-reports.rst |     6 +-
 .../media/uapi/rc/lirc-set-rec-timeout.rst         |     6 +-
 .../media/uapi/rc/lirc-set-send-carrier.rst        |     6 +-
 .../media/uapi/rc/lirc-set-send-duty-cycle.rst     |     6 +-
 .../media/uapi/rc/lirc-set-transmitter-mask.rst    |     6 +-
 .../media/uapi/rc/lirc-set-wideband-receiver.rst   |    10 +-
 Documentation/media/uapi/rc/lirc-write.rst         |     8 +-
 Documentation/media/uapi/rc/rc-tables.rst          |     2 +
 Documentation/media/uapi/v4l/audio.rst             |    16 +-
 Documentation/media/uapi/v4l/buffer.rst            |  1404 +-
 Documentation/media/uapi/v4l/control.rst           |   139 +-
 Documentation/media/uapi/v4l/crop.rst              |    26 +-
 Documentation/media/uapi/v4l/dev-capture.rst       |    16 +-
 Documentation/media/uapi/v4l/dev-codec.rst         |     4 +-
 Documentation/media/uapi/v4l/dev-osd.rst           |    26 +-
 Documentation/media/uapi/v4l/dev-output.rst        |    18 +-
 Documentation/media/uapi/v4l/dev-overlay.rst       |    34 +-
 Documentation/media/uapi/v4l/dev-radio.rst         |     2 +-
 Documentation/media/uapi/v4l/dev-raw-vbi.rst       |   267 +-
 .../media/uapi/v4l/dev-raw-vbi_files/vbi_525.pdf   |   Bin 3395 -> 3706 bytes
 .../media/uapi/v4l/dev-raw-vbi_files/vbi_625.pdf   |   Bin 3683 -> 3996 bytes
 Documentation/media/uapi/v4l/dev-rds.rst           |   215 +-
 Documentation/media/uapi/v4l/dev-sdr.rst           |    57 +-
 Documentation/media/uapi/v4l/dev-sliced-vbi.rst    |   784 +-
 Documentation/media/uapi/v4l/dev-subdev.rst        |   133 +-
 Documentation/media/uapi/v4l/dev-touch.rst         |    56 +
 Documentation/media/uapi/v4l/devices.rst           |     1 +
 Documentation/media/uapi/v4l/diff-v4l.rst          |   760 +-
 Documentation/media/uapi/v4l/dmabuf.rst            |     8 +-
 Documentation/media/uapi/v4l/extended-controls.rst |  3331 ++--
 Documentation/media/uapi/v4l/field-order.rst       |   196 +-
 Documentation/media/uapi/v4l/format.rst            |     2 +-
 Documentation/media/uapi/v4l/func-close.rst        |     4 +-
 Documentation/media/uapi/v4l/func-ioctl.rst        |     4 +-
 Documentation/media/uapi/v4l/func-mmap.rst         |    16 +-
 Documentation/media/uapi/v4l/func-munmap.rst       |     8 +-
 Documentation/media/uapi/v4l/func-open.rst         |     4 +-
 Documentation/media/uapi/v4l/func-poll.rst         |     4 +-
 Documentation/media/uapi/v4l/func-read.rst         |     8 +-
 Documentation/media/uapi/v4l/func-select.rst       |    18 +-
 Documentation/media/uapi/v4l/func-write.rst        |     8 +-
 Documentation/media/uapi/v4l/hist-v4l2.rst         |   409 +-
 .../media/uapi/v4l/libv4l-introduction.rst         |    77 +-
 Documentation/media/uapi/v4l/mmap.rst              |    12 +-
 Documentation/media/uapi/v4l/pixfmt-002.rst        |   303 +-
 Documentation/media/uapi/v4l/pixfmt-003.rst        |   208 +-
 Documentation/media/uapi/v4l/pixfmt-006.rst        |   343 +-
 Documentation/media/uapi/v4l/pixfmt-007.rst        |   754 +-
 Documentation/media/uapi/v4l/pixfmt-013.rst        |   188 +-
 Documentation/media/uapi/v4l/pixfmt-grey.rst       |    73 +-
 Documentation/media/uapi/v4l/pixfmt-indexed.rst    |    82 +-
 Documentation/media/uapi/v4l/pixfmt-m420.rst       |   253 +-
 Documentation/media/uapi/v4l/pixfmt-nv12.rst       |   252 +-
 Documentation/media/uapi/v4l/pixfmt-nv12m.rst      |   258 +-
 Documentation/media/uapi/v4l/pixfmt-nv12mt.rst     |     6 +-
 .../media/uapi/v4l/pixfmt-nv12mt_files/nv12mt.gif  |   Bin 2108 -> 0 bytes
 .../media/uapi/v4l/pixfmt-nv12mt_files/nv12mt.png  |   Bin 0 -> 1920 bytes
 .../v4l/pixfmt-nv12mt_files/nv12mt_example.gif     |   Bin 6858 -> 0 bytes
 .../v4l/pixfmt-nv12mt_files/nv12mt_example.png     |   Bin 0 -> 5261 bytes
 Documentation/media/uapi/v4l/pixfmt-nv16.rst       |   325 +-
 Documentation/media/uapi/v4l/pixfmt-nv16m.rst      |   330 +-
 Documentation/media/uapi/v4l/pixfmt-nv24.rst       |   188 +-
 Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst |  2190 +--
 Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst |   469 +-
 Documentation/media/uapi/v4l/pixfmt-reserved.rst   |   547 +-
 Documentation/media/uapi/v4l/pixfmt-rgb.rst        |     3 -
 Documentation/media/uapi/v4l/pixfmt-sbggr16.rst    |   124 +-
 Documentation/media/uapi/v4l/pixfmt-sbggr8.rst     |    81 -
 Documentation/media/uapi/v4l/pixfmt-sdr-cs08.rst   |    21 +-
 Documentation/media/uapi/v4l/pixfmt-sdr-cs14le.rst |    26 +-
 Documentation/media/uapi/v4l/pixfmt-sdr-cu08.rst   |    21 +-
 Documentation/media/uapi/v4l/pixfmt-sdr-cu16le.rst |    25 +-
 Documentation/media/uapi/v4l/pixfmt-sdr-ru12le.rst |    14 +-
 Documentation/media/uapi/v4l/pixfmt-sgbrg8.rst     |    81 -
 Documentation/media/uapi/v4l/pixfmt-sgrbg8.rst     |    81 -
 Documentation/media/uapi/v4l/pixfmt-srggb10.rst    |   134 +-
 .../media/uapi/v4l/pixfmt-srggb10alaw8.rst         |     2 -
 Documentation/media/uapi/v4l/pixfmt-srggb10p.rst   |   109 +-
 Documentation/media/uapi/v4l/pixfmt-srggb12.rst    |   124 +-
 Documentation/media/uapi/v4l/pixfmt-srggb8.rst     |    93 +-
 Documentation/media/uapi/v4l/pixfmt-tch-td08.rst   |    52 +
 Documentation/media/uapi/v4l/pixfmt-tch-td16.rst   |    67 +
 Documentation/media/uapi/v4l/pixfmt-tch-tu08.rst   |    50 +
 Documentation/media/uapi/v4l/pixfmt-tch-tu16.rst   |    66 +
 Documentation/media/uapi/v4l/pixfmt-uv8.rst        |    71 +-
 Documentation/media/uapi/v4l/pixfmt-uyvy.rst       |   231 +-
 Documentation/media/uapi/v4l/pixfmt-vyuy.rst       |   231 +-
 Documentation/media/uapi/v4l/pixfmt-y10.rst        |   119 +-
 Documentation/media/uapi/v4l/pixfmt-y10b.rst       |    22 +-
 Documentation/media/uapi/v4l/pixfmt-y12.rst        |   119 +-
 Documentation/media/uapi/v4l/pixfmt-y12i.rst       |    14 +-
 Documentation/media/uapi/v4l/pixfmt-y16-be.rst     |   123 +-
 Documentation/media/uapi/v4l/pixfmt-y16.rst        |   123 +-
 Documentation/media/uapi/v4l/pixfmt-y41p.rst       |   339 +-
 Documentation/media/uapi/v4l/pixfmt-y8i.rst        |   119 +-
 Documentation/media/uapi/v4l/pixfmt-yuv410.rst     |   231 +-
 Documentation/media/uapi/v4l/pixfmt-yuv411p.rst    |   233 +-
 Documentation/media/uapi/v4l/pixfmt-yuv420.rst     |   276 +-
 Documentation/media/uapi/v4l/pixfmt-yuv420m.rst    |   286 +-
 Documentation/media/uapi/v4l/pixfmt-yuv422m.rst    |   281 +-
 Documentation/media/uapi/v4l/pixfmt-yuv422p.rst    |   271 +-
 Documentation/media/uapi/v4l/pixfmt-yuv444m.rst    |   301 +-
 Documentation/media/uapi/v4l/pixfmt-yuyv.rst       |   241 +-
 Documentation/media/uapi/v4l/pixfmt-yvyu.rst       |   231 +-
 Documentation/media/uapi/v4l/pixfmt-z16.rst        |   119 +-
 Documentation/media/uapi/v4l/pixfmt.rst            |     5 +-
 Documentation/media/uapi/v4l/planar-apis.rst       |    10 +-
 Documentation/media/uapi/v4l/rw.rst                |     2 +-
 Documentation/media/uapi/v4l/selection-api-005.rst |    10 +-
 Documentation/media/uapi/v4l/standard.rst          |    12 +-
 Documentation/media/uapi/v4l/streaming-par.rst     |     2 +-
 Documentation/media/uapi/v4l/subdev-formats.rst    | 17848 +++++++------------
 Documentation/media/uapi/v4l/tch-formats.rst       |    18 +
 Documentation/media/uapi/v4l/tuner.rst             |    18 +-
 Documentation/media/uapi/v4l/userp.rst             |    12 +-
 .../media/uapi/v4l/v4l2-selection-flags.rst        |    85 +-
 .../media/uapi/v4l/v4l2-selection-targets.rst      |   173 +-
 Documentation/media/uapi/v4l/v4l2.rst              |    12 +-
 Documentation/media/uapi/v4l/video.rst             |     2 +-
 .../media/uapi/v4l/vidioc-create-bufs.rst          |    87 +-
 Documentation/media/uapi/v4l/vidioc-cropcap.rst    |   145 +-
 .../media/uapi/v4l/vidioc-dbg-g-chip-info.rst      |   135 +-
 .../media/uapi/v4l/vidioc-dbg-g-register.rst       |   134 +-
 .../media/uapi/v4l/vidioc-decoder-cmd.rst          |   325 +-
 Documentation/media/uapi/v4l/vidioc-dqevent.rst    |   722 +-
 .../media/uapi/v4l/vidioc-dv-timings-cap.rst       |   267 +-
 .../media/uapi/v4l/vidioc-encoder-cmd.rst          |   154 +-
 .../media/uapi/v4l/vidioc-enum-dv-timings.rst      |    73 +-
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst   |   165 +-
 .../media/uapi/v4l/vidioc-enum-frameintervals.rst  |   206 +-
 .../media/uapi/v4l/vidioc-enum-framesizes.rst      |   243 +-
 .../media/uapi/v4l/vidioc-enum-freq-bands.rst      |   202 +-
 Documentation/media/uapi/v4l/vidioc-enumaudio.rst  |    10 +-
 .../media/uapi/v4l/vidioc-enumaudioout.rst         |    14 +-
 Documentation/media/uapi/v4l/vidioc-enuminput.rst  |   438 +-
 Documentation/media/uapi/v4l/vidioc-enumoutput.rst |   228 +-
 Documentation/media/uapi/v4l/vidioc-enumstd.rst    |   325 +-
 Documentation/media/uapi/v4l/vidioc-expbuf.rst     |   106 +-
 Documentation/media/uapi/v4l/vidioc-g-audio.rst    |   125 +-
 Documentation/media/uapi/v4l/vidioc-g-audioout.rst |    86 +-
 Documentation/media/uapi/v4l/vidioc-g-crop.rst     |    50 +-
 Documentation/media/uapi/v4l/vidioc-g-ctrl.rst     |    43 +-
 .../media/uapi/v4l/vidioc-g-dv-timings.rst         |   491 +-
 Documentation/media/uapi/v4l/vidioc-g-edid.rst     |    98 +-
 .../media/uapi/v4l/vidioc-g-enc-index.rst          |   188 +-
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst          |   589 +-
 Documentation/media/uapi/v4l/vidioc-g-fbuf.rst     |   624 +-
 Documentation/media/uapi/v4l/vidioc-g-fmt.rst      |   153 +-
 .../media/uapi/v4l/vidioc-g-frequency.rst          |    91 +-
 Documentation/media/uapi/v4l/vidioc-g-input.rst    |    11 +-
 Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst |   162 +-
 .../media/uapi/v4l/vidioc-g-modulator.rst          |   287 +-
 Documentation/media/uapi/v4l/vidioc-g-output.rst   |    11 +-
 Documentation/media/uapi/v4l/vidioc-g-parm.rst     |   413 +-
 Documentation/media/uapi/v4l/vidioc-g-priority.rst |    86 +-
 .../media/uapi/v4l/vidioc-g-selection.rst          |   101 +-
 .../media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst     |   340 +-
 Documentation/media/uapi/v4l/vidioc-g-std.rst      |    13 +-
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst    |   944 +-
 Documentation/media/uapi/v4l/vidioc-log-status.rst |     5 +-
 Documentation/media/uapi/v4l/vidioc-overlay.rst    |     6 +-
 .../media/uapi/v4l/vidioc-prepare-buf.rst          |     8 +-
 Documentation/media/uapi/v4l/vidioc-qbuf.rst       |    33 +-
 .../media/uapi/v4l/vidioc-query-dv-timings.rst     |    15 +-
 Documentation/media/uapi/v4l/vidioc-querybuf.rst   |    20 +-
 Documentation/media/uapi/v4l/vidioc-querycap.rst   |   581 +-
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |  1020 +-
 Documentation/media/uapi/v4l/vidioc-querystd.rst   |    10 +-
 Documentation/media/uapi/v4l/vidioc-reqbufs.rst    |    66 +-
 .../media/uapi/v4l/vidioc-s-hw-freq-seek.rst       |   146 +-
 Documentation/media/uapi/v4l/vidioc-streamon.rst   |    15 +-
 .../uapi/v4l/vidioc-subdev-enum-frame-interval.rst |   107 +-
 .../uapi/v4l/vidioc-subdev-enum-frame-size.rst     |   119 +-
 .../uapi/v4l/vidioc-subdev-enum-mbus-code.rst      |    75 +-
 .../media/uapi/v4l/vidioc-subdev-g-crop.rst        |    67 +-
 .../media/uapi/v4l/vidioc-subdev-g-fmt.rst         |    91 +-
 .../uapi/v4l/vidioc-subdev-g-frame-interval.rst    |    55 +-
 .../media/uapi/v4l/vidioc-subdev-g-selection.rst   |    85 +-
 .../media/uapi/v4l/vidioc-subscribe-event.rst      |   127 +-
 Documentation/media/v4l-drivers/bttv.rst           |     1 +
 Documentation/media/v4l-drivers/cpia2.rst          |     3 +
 .../media/v4l-drivers/cx23885-cardlist.rst         |     1 +
 Documentation/media/v4l-drivers/fourcc.rst         |     2 +-
 Documentation/media/v4l-drivers/si476x.rst         |   116 +-
 Documentation/media/v4l-drivers/zr364xx.rst        |     2 +-
 Documentation/media/video.h.rst.exceptions         |    20 +-
 Documentation/media/videodev2.h.rst.exceptions     |   210 +-
 Documentation/scsi/scsi-parameters.txt             |     2 -
 Documentation/serial/serial-rs485.txt              |     5 +-
 Documentation/sphinx/cdomain.py                    |   165 +
 Documentation/sphinx/kernel-doc.py                 |     8 +
 Documentation/sphinx/kernel_include.py             |     7 +
 Documentation/sphinx/load_config.py                |    32 +
 Documentation/sphinx/parse-headers.pl              |   129 +-
 Documentation/sphinx/rstFlatTable.py               |     6 +
 Documentation/x86/x86_64/mm.txt                    |     6 +-
 MAINTAINERS                                        |   101 +-
 Makefile                                           |     2 +-
 README                                             |     8 +-
 arch/arm/boot/dts/stih407-family.dtsi              |    12 +
 drivers/gpu/drm/exynos/Kconfig                     |     3 +-
 drivers/input/rmi4/Kconfig                         |    11 +
 drivers/input/rmi4/Makefile                        |     1 +
 drivers/input/rmi4/rmi_bus.c                       |     3 +
 drivers/input/rmi4/rmi_driver.h                    |     1 +
 drivers/input/rmi4/rmi_f54.c                       |   757 +
 drivers/input/touchscreen/Kconfig                  |     9 +
 drivers/input/touchscreen/atmel_mxt_ts.c           |   521 +
 drivers/input/touchscreen/sur40.c                  |   142 +-
 drivers/media/Kconfig                              |     7 +-
 drivers/media/Makefile                             |     2 +-
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c      |    14 +-
 drivers/media/dvb-core/demux.h                     |    44 +-
 drivers/media/dvb-core/dvb_frontend.c              |    28 +-
 drivers/media/dvb-core/dvb_math.h                  |     2 +-
 drivers/media/dvb-core/dvb_ringbuffer.h            |   226 +-
 drivers/media/dvb-frontends/Kconfig                |     2 +
 drivers/media/dvb-frontends/ascot2e.c              |     2 +-
 drivers/media/dvb-frontends/cxd2820r.h             |    26 +
 drivers/media/dvb-frontends/cxd2820r_c.c           |   302 +-
 drivers/media/dvb-frontends/cxd2820r_core.c        |   597 +-
 drivers/media/dvb-frontends/cxd2820r_priv.h        |    42 +-
 drivers/media/dvb-frontends/cxd2820r_t.c           |   300 +-
 drivers/media/dvb-frontends/cxd2820r_t2.c          |   278 +-
 drivers/media/dvb-frontends/cxd2841er.c            |   108 +-
 drivers/media/dvb-frontends/drxk_hard.c            |     2 +-
 drivers/media/dvb-frontends/dvb-pll.c              |     2 +-
 drivers/media/dvb-frontends/helene.c               |    12 +-
 drivers/media/dvb-frontends/horus3a.c              |     2 +-
 drivers/media/dvb-frontends/ix2505v.c              |     2 +-
 drivers/media/dvb-frontends/lgdt3306a.c            |    18 +-
 drivers/media/dvb-frontends/mb86a20s.c             |   104 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |     1 -
 drivers/media/dvb-frontends/si2165.c               |   228 +-
 drivers/media/dvb-frontends/si2165.h               |    27 +-
 drivers/media/dvb-frontends/si2165_priv.h          |    17 +
 drivers/media/dvb-frontends/stb6000.c              |     2 +-
 drivers/media/dvb-frontends/stb6100.c              |     2 +-
 drivers/media/dvb-frontends/stv6110.c              |     2 +-
 drivers/media/dvb-frontends/stv6110x.c             |     2 +-
 drivers/media/dvb-frontends/tda18271c2dd.c         |     2 +-
 drivers/media/dvb-frontends/tda665x.c              |     2 +-
 drivers/media/dvb-frontends/tda8261.c              |     2 +-
 drivers/media/dvb-frontends/tda826x.c              |     2 +-
 drivers/media/dvb-frontends/ts2020.c               |     2 +-
 drivers/media/dvb-frontends/tua6100.c              |     2 +-
 drivers/media/dvb-frontends/zl10036.c              |     2 +-
 drivers/media/dvb-frontends/zl10039.c              |     2 +-
 drivers/media/i2c/Kconfig                          |    18 +-
 drivers/media/i2c/Makefile                         |     2 +
 drivers/media/i2c/ad5820.c                         |   372 +
 drivers/media/i2c/ad9389b.c                        |    23 +-
 drivers/media/i2c/adv7180.c                        |   122 +-
 drivers/media/i2c/adv7183.c                        |     1 -
 drivers/media/i2c/adv7393.c                        |     1 -
 drivers/media/i2c/adv7511.c                        |     1 +
 drivers/media/i2c/ak881x.c                         |    28 +-
 drivers/media/i2c/cs3308.c                         |     1 -
 drivers/media/i2c/ir-kbd-i2c.c                     |    90 +-
 drivers/media/i2c/{soc_camera => }/mt9m111.c       |   116 +-
 drivers/media/i2c/ov9650.c                         |     7 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |     2 +-
 drivers/media/i2c/s5k4ecgx.c                       |     1 -
 drivers/media/i2c/s5k6a3.c                         |     2 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |   180 +-
 drivers/media/i2c/smiapp/smiapp-quirk.c            |    16 +-
 drivers/media/i2c/smiapp/smiapp-regs.c             |    22 +-
 drivers/media/i2c/smiapp/smiapp.h                  |     5 +-
 drivers/media/i2c/soc_camera/Kconfig               |     7 +-
 drivers/media/i2c/soc_camera/Makefile              |     1 -
 drivers/media/i2c/soc_camera/imx074.c              |    42 +-
 drivers/media/i2c/soc_camera/mt9m001.c             |    70 +-
 drivers/media/i2c/soc_camera/mt9t031.c             |    54 +-
 drivers/media/i2c/soc_camera/mt9t112.c             |    60 +-
 drivers/media/i2c/soc_camera/mt9v022.c             |    68 +-
 drivers/media/i2c/soc_camera/ov2640.c              |    41 +-
 drivers/media/i2c/soc_camera/ov5642.c              |    53 +-
 drivers/media/i2c/soc_camera/ov6650.c              |    74 +-
 drivers/media/i2c/soc_camera/ov772x.c              |    44 +-
 drivers/media/i2c/soc_camera/ov9640.c              |    41 +-
 drivers/media/i2c/soc_camera/ov9740.c              |    41 +-
 drivers/media/i2c/soc_camera/rj54n1cb0c.c          |    52 +-
 drivers/media/i2c/soc_camera/tw9910.c              |    47 +-
 drivers/media/i2c/ths8200.c                        |     1 -
 drivers/media/i2c/tlv320aic23b.c                   |     1 -
 drivers/media/i2c/tvp514x.c                        |     3 +-
 drivers/media/i2c/tvp5150.c                        |    89 +-
 drivers/media/i2c/tvp7002.c                        |     1 -
 drivers/media/i2c/vs6624.c                         |     1 -
 drivers/media/media-device.c                       |   224 +-
 drivers/media/media-entity.c                       |    13 +-
 drivers/media/pci/Kconfig                          |     1 +
 drivers/media/pci/Makefile                         |     1 +
 drivers/media/pci/bt8xx/bttv-driver.c              |    59 +-
 drivers/media/pci/bt8xx/bttvp.h                    |     2 +-
 drivers/media/pci/cobalt/cobalt-alsa-pcm.c         |     4 +-
 drivers/media/pci/cobalt/cobalt-driver.c           |    47 +-
 drivers/media/pci/cobalt/cobalt-v4l2.c             |     7 +-
 drivers/media/pci/cx18/cx18-alsa-pcm.c             |     2 +-
 drivers/media/pci/cx18/cx18-i2c.c                  |     3 +-
 drivers/media/pci/cx23885/cx23885-417.c            |     2 +-
 drivers/media/pci/cx23885/cx23885-alsa.c           |     2 +-
 drivers/media/pci/cx23885/cx23885-cards.c          |    29 +
 drivers/media/pci/cx23885/cx23885-dvb.c            |   135 +-
 drivers/media/pci/cx23885/cx23885-i2c.c            |     2 +-
 drivers/media/pci/cx23885/cx23885-input.c          |     2 +-
 drivers/media/pci/cx23885/cx23885-video.c          |     2 +-
 drivers/media/pci/cx23885/cx23885.h                |     5 +-
 drivers/media/pci/cx25821/cx25821-alsa.c           |     2 +-
 drivers/media/pci/cx25821/cx25821-audio-upstream.c |    14 +-
 drivers/media/pci/cx25821/cx25821-i2c.c            |     2 +-
 drivers/media/pci/cx25821/cx25821-video.c          |     2 +-
 drivers/media/pci/cx25821/cx25821.h                |     1 -
 drivers/media/pci/cx88/cx88-alsa.c                 |     2 +-
 drivers/media/pci/cx88/cx88-blackbird.c            |     2 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |     2 +-
 drivers/media/pci/cx88/cx88-input.c                |     8 +-
 drivers/media/pci/cx88/cx88-video.c                |     2 +-
 drivers/media/pci/ddbridge/ddbridge-core.c         |    18 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c             |     2 +-
 drivers/media/pci/ivtv/ivtv-i2c.c                  |     5 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |     2 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c  |     5 +-
 drivers/media/pci/ngene/ngene-cards.c              |    14 +-
 drivers/media/pci/pt3/pt3.c                        |     4 +-
 drivers/media/pci/saa7134/saa7134-alsa.c           |     2 +-
 drivers/media/pci/saa7134/saa7134-empress.c        |     2 +-
 drivers/media/pci/saa7134/saa7134-i2c.c            |     2 +-
 drivers/media/pci/saa7134/saa7134-input.c          |     4 +-
 drivers/media/pci/saa7134/saa7134-video.c          |    41 +-
 drivers/media/pci/saa7164/saa7164-i2c.c            |     2 +-
 drivers/media/pci/smipcie/smipcie-main.c           |     8 +-
 drivers/media/pci/solo6x10/solo6x10-g723.c         |     2 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |     2 +-
 drivers/media/pci/tw5864/Kconfig                   |    12 +
 drivers/media/pci/tw5864/Makefile                  |     3 +
 drivers/media/pci/tw5864/tw5864-core.c             |   359 +
 drivers/media/pci/tw5864/tw5864-h264.c             |   259 +
 drivers/media/pci/tw5864/tw5864-reg.h              |  2133 +++
 drivers/media/pci/tw5864/tw5864-util.c             |    37 +
 drivers/media/pci/tw5864/tw5864-video.c            |  1510 ++
 drivers/media/pci/tw5864/tw5864.h                  |   205 +
 drivers/media/pci/tw68/tw68-video.c                |     2 +-
 drivers/media/pci/tw686x/tw686x-audio.c            |     2 +-
 drivers/media/pci/tw686x/tw686x-video.c            |   182 +-
 drivers/media/pci/zoran/zoran_driver.c             |   113 +-
 drivers/media/platform/Kconfig                     |    28 +-
 drivers/media/platform/Makefile                    |     5 +-
 drivers/media/platform/atmel/Kconfig               |     9 +
 drivers/media/platform/atmel/Makefile              |     1 +
 drivers/media/platform/atmel/atmel-isc-regs.h      |   165 +
 drivers/media/platform/atmel/atmel-isc.c           |  1520 ++
 drivers/media/platform/davinci/vpbe_display.c      |    65 +-
 drivers/media/platform/davinci/vpfe_capture.c      |    52 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |     9 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |     3 +-
 drivers/media/platform/exynos4-is/fimc-is-i2c.c    |    27 +-
 drivers/media/platform/exynos4-is/fimc-is.c        |    29 +-
 drivers/media/platform/exynos4-is/fimc-is.h        |     3 +
 drivers/media/platform/exynos4-is/fimc-isp.c       |     1 +
 drivers/media/platform/exynos4-is/fimc-lite.c      |    17 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |     2 +-
 drivers/media/platform/exynos4-is/media-dev.c      |     6 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |     1 +
 drivers/media/platform/m2m-deinterlace.c           |     4 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h |     2 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c |    71 +-
 .../media/platform/mtk-vcodec/venc/venc_h264_if.c  |     6 +-
 .../media/platform/mtk-vcodec/venc/venc_vp8_if.c   |     6 +-
 drivers/media/platform/mtk-vcodec/venc_drv_if.c    |     4 +-
 drivers/media/platform/mx2_emmaprp.c               |     2 +-
 drivers/media/platform/omap/omap_vout.c            |    53 +-
 drivers/media/platform/omap3isp/isp.c              |     6 +-
 drivers/media/platform/omap3isp/ispvideo.c         |    88 +-
 .../media/platform/{soc_camera => }/pxa_camera.c   |  1949 +-
 drivers/media/platform/rcar-fcp.c                  |     9 +-
 drivers/media/platform/rcar-vin/Kconfig            |     2 +-
 drivers/media/platform/rcar-vin/rcar-core.c        |   263 +-
 drivers/media/platform/rcar-vin/rcar-dma.c         |    59 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c        |   299 +-
 drivers/media/platform/rcar-vin/rcar-vin.h         |    27 +-
 drivers/media/platform/rcar_jpu.c                  |     2 +-
 drivers/media/platform/s5p-g2d/g2d.c               |     2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |    43 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |    86 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |     2 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |    11 +-
 drivers/media/platform/s5p-tv/Kconfig              |    88 -
 drivers/media/platform/s5p-tv/Makefile             |    19 -
 drivers/media/platform/s5p-tv/hdmi_drv.c           |  1059 --
 drivers/media/platform/s5p-tv/hdmiphy_drv.c        |   324 -
 drivers/media/platform/s5p-tv/mixer.h              |   364 -
 drivers/media/platform/s5p-tv/mixer_drv.c          |   527 -
 drivers/media/platform/s5p-tv/mixer_grp_layer.c    |   270 -
 drivers/media/platform/s5p-tv/mixer_reg.c          |   551 -
 drivers/media/platform/s5p-tv/mixer_video.c        |  1130 --
 drivers/media/platform/s5p-tv/mixer_vp_layer.c     |   242 -
 drivers/media/platform/s5p-tv/regs-hdmi.h          |   146 -
 drivers/media/platform/s5p-tv/regs-mixer.h         |   122 -
 drivers/media/platform/s5p-tv/regs-sdo.h           |    63 -
 drivers/media/platform/s5p-tv/regs-vp.h            |    88 -
 drivers/media/platform/s5p-tv/sdo_drv.c            |   497 -
 drivers/media/platform/s5p-tv/sii9234_drv.c        |   407 -
 drivers/media/platform/sh_vou.c                    |    17 +-
 drivers/media/platform/soc_camera/Kconfig          |    25 -
 drivers/media/platform/soc_camera/Makefile         |     3 -
 drivers/media/platform/soc_camera/atmel-isi.c      |     2 +-
 drivers/media/platform/soc_camera/rcar_vin.c       |  1970 --
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |   269 +-
 drivers/media/platform/soc_camera/sh_mobile_csi2.c |   400 -
 drivers/media/platform/soc_camera/soc_camera.c     |   130 +-
 .../platform/soc_camera/soc_camera_platform.c      |    45 +-
 drivers/media/platform/soc_camera/soc_scale_crop.c |    97 +-
 drivers/media/platform/soc_camera/soc_scale_crop.h |     6 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |     2 +-
 drivers/media/platform/sti/hva/Makefile            |     2 +
 drivers/media/platform/sti/hva/hva-h264.c          |  1050 ++
 drivers/media/platform/sti/hva/hva-hw.c            |   538 +
 drivers/media/platform/sti/hva/hva-hw.h            |    42 +
 drivers/media/platform/sti/hva/hva-mem.c           |    59 +
 drivers/media/platform/sti/hva/hva-mem.h           |    34 +
 drivers/media/platform/sti/hva/hva-v4l2.c          |  1415 ++
 drivers/media/platform/sti/hva/hva.h               |   315 +
 drivers/media/platform/ti-vpe/cal.c                |     2 +-
 drivers/media/platform/ti-vpe/vpe.c                |     2 +-
 drivers/media/platform/vim2m.c                     |     2 +-
 drivers/media/platform/vivid/vivid-core.c          |    63 +-
 drivers/media/platform/vivid/vivid-ctrls.c         |     3 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |     4 +-
 drivers/media/platform/vsp1/vsp1.h                 |     2 +
 drivers/media/platform/vsp1/vsp1_bru.c             |    36 +-
 drivers/media/platform/vsp1/vsp1_clu.c             |    62 +-
 drivers/media/platform/vsp1/vsp1_dl.c              |   126 +-
 drivers/media/platform/vsp1/vsp1_dl.h              |     1 +
 drivers/media/platform/vsp1/vsp1_drm.c             |    26 +-
 drivers/media/platform/vsp1/vsp1_drv.c             |    45 +-
 drivers/media/platform/vsp1/vsp1_entity.c          |    22 +-
 drivers/media/platform/vsp1/vsp1_entity.h          |    25 +-
 drivers/media/platform/vsp1/vsp1_hsit.c            |    20 +-
 drivers/media/platform/vsp1/vsp1_lif.c             |    20 +-
 drivers/media/platform/vsp1/vsp1_lut.c             |    42 +-
 drivers/media/platform/vsp1/vsp1_pipe.c            |    13 +-
 drivers/media/platform/vsp1/vsp1_pipe.h            |    11 +-
 drivers/media/platform/vsp1/vsp1_regs.h            |     2 +
 drivers/media/platform/vsp1/vsp1_rpf.c             |   109 +-
 drivers/media/platform/vsp1/vsp1_rwpf.c            |    83 +-
 drivers/media/platform/vsp1/vsp1_rwpf.h            |    13 -
 drivers/media/platform/vsp1/vsp1_sru.c             |    50 +-
 drivers/media/platform/vsp1/vsp1_uds.c             |    71 +-
 drivers/media/platform/vsp1/vsp1_video.c           |   192 +-
 drivers/media/platform/vsp1/vsp1_wpf.c             |   132 +-
 drivers/media/platform/xilinx/xilinx-dma.c         |     2 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c      |     1 -
 drivers/media/radio/si470x/radio-si470x-usb.c      |     1 -
 drivers/media/radio/si4713/radio-usb-si4713.c      |     2 +-
 drivers/media/rc/igorplugusb.c                     |     3 +-
 drivers/media/rc/img-ir/img-ir-nec.c               |     6 +-
 drivers/media/rc/imon.c                            |    13 +-
 drivers/media/rc/ir-nec-decoder.c                  |     8 +-
 drivers/media/rc/ir-rc6-decoder.c                  |     4 +-
 drivers/media/rc/nuvoton-cir.c                     |    40 +-
 drivers/media/rc/rc-ir-raw.c                       |     9 +-
 drivers/media/rc/rc-main.c                         |    13 +-
 drivers/media/rc/redrat3.c                         |    71 +-
 drivers/media/rc/streamzap.c                       |     2 +-
 drivers/media/spi/Kconfig                          |    14 +
 drivers/media/spi/Makefile                         |     1 +
 drivers/media/spi/gs1662.c                         |   478 +
 drivers/media/tuners/mt2063.c                      |     2 +-
 drivers/media/tuners/mt20xx.c                      |     4 +-
 drivers/media/tuners/mxl5007t.c                    |     2 +-
 drivers/media/tuners/tda18271-fe.c                 |    11 +-
 drivers/media/tuners/tda18271-priv.h               |     2 +
 drivers/media/tuners/tda827x.c                     |     4 +-
 drivers/media/tuners/tea5761.c                     |     2 +-
 drivers/media/tuners/tea5767.c                     |    11 +-
 drivers/media/tuners/tuner-simple.c                |     2 +-
 drivers/media/usb/airspy/airspy.c                  |     3 +-
 drivers/media/usb/as102/as102_usb_drv.c            |     2 -
 drivers/media/usb/au0828/au0828-input.c            |     3 +-
 drivers/media/usb/au0828/au0828-video.c            |     3 +-
 drivers/media/usb/cpia2/cpia2_usb.c                |     1 -
 drivers/media/usb/cx231xx/cx231xx-audio.c          |     4 +-
 drivers/media/usb/cx231xx/cx231xx-avcore.c         |     5 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |     6 +-
 drivers/media/usb/cx231xx/cx231xx-core.c           |    71 +-
 drivers/media/usb/cx231xx/cx231xx-dvb.c            |    82 +-
 drivers/media/usb/cx231xx/cx231xx-i2c.c            |     4 +-
 drivers/media/usb/cx231xx/cx231xx-vbi.c            |     2 -
 drivers/media/usb/dvb-usb-v2/af9015.c              |     8 +-
 drivers/media/usb/dvb-usb-v2/af9035.c              |     9 +-
 drivers/media/usb/dvb-usb-v2/az6007.c              |    13 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        |     2 -
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |     5 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c      |     2 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |     9 +-
 drivers/media/usb/dvb-usb/Kconfig                  |    21 +-
 drivers/media/usb/dvb-usb/Makefile                 |    11 +-
 drivers/media/usb/dvb-usb/dib0700_core.c           |     8 +-
 drivers/media/usb/dvb-usb/dibusb-common.c          |   158 -
 drivers/media/usb/dvb-usb/dibusb-mc-common.c       |   168 +
 drivers/media/usb/dvb-usb/dtt200u.c                |     5 +-
 drivers/media/usb/em28xx/em28xx-audio.c            |     3 +-
 drivers/media/usb/em28xx/em28xx-core.c             |     1 -
 drivers/media/usb/em28xx/em28xx-i2c.c              |     2 +-
 drivers/media/usb/em28xx/em28xx-video.c            |     2 +-
 drivers/media/usb/go7007/go7007-i2c.c              |     2 +-
 drivers/media/usb/go7007/go7007-usb.c              |     2 +-
 drivers/media/usb/go7007/go7007-v4l2.c             |     2 +-
 drivers/media/usb/go7007/snd-go7007.c              |     2 +-
 drivers/media/usb/gspca/benq.c                     |     4 +-
 drivers/media/usb/gspca/finepix.c                  |     8 +-
 drivers/media/usb/gspca/gspca.c                    |     4 +-
 drivers/media/usb/gspca/jl2005bcd.c                |     8 +-
 drivers/media/usb/gspca/konica.c                   |     4 +-
 drivers/media/usb/gspca/sonixj.c                   |    13 +-
 drivers/media/usb/gspca/vicam.c                    |     8 +-
 drivers/media/usb/hackrf/hackrf.c                  |     5 +-
 drivers/media/usb/hdpvr/hdpvr-i2c.c                |     4 +-
 drivers/media/usb/hdpvr/hdpvr-video.c              |     4 +-
 drivers/media/usb/msi2500/msi2500.c                |     3 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h   |     1 -
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |    23 +-
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c       |     3 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           |    81 +-
 drivers/media/usb/pwc/pwc-if.c                     |     3 +-
 drivers/media/usb/s2255/s2255drv.c                 |    11 +-
 drivers/media/usb/stk1160/stk1160-i2c.c            |     2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |     2 +-
 drivers/media/usb/stk1160/stk1160-video.c          |     4 +-
 drivers/media/usb/stkwebcam/stk-webcam.c           |     4 +-
 drivers/media/usb/tm6000/tm6000-alsa.c             |     2 +-
 drivers/media/usb/tm6000/tm6000-dvb.c              |     4 +-
 drivers/media/usb/tm6000/tm6000-video.c            |     1 -
 drivers/media/usb/ttusb-dec/ttusb_dec.c            |    30 +-
 drivers/media/usb/usbtv/usbtv-audio.c              |     2 +-
 drivers/media/usb/usbtv/usbtv-video.c              |     2 +-
 drivers/media/usb/usbvision/usbvision-core.c       |     5 +-
 drivers/media/usb/uvc/uvc_queue.c                  |     2 +-
 drivers/media/usb/zr364xx/zr364xx.c                |     4 +-
 drivers/media/v4l2-core/v4l2-async.c               |     7 -
 drivers/media/v4l2-core/v4l2-common.c              |     2 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |     1 +
 drivers/media/v4l2-core/v4l2-dev.c                 |    14 +-
 drivers/media/v4l2-core/v4l2-device.c              |     5 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c          |    11 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |    44 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   128 +-
 drivers/media/v4l2-core/videobuf2-core.c           |   278 +-
 drivers/media/v4l2-core/videobuf2-dma-contig.c     |     9 +
 drivers/media/v4l2-core/videobuf2-dma-sg.c         |    19 +-
 drivers/media/v4l2-core/videobuf2-v4l2.c           |   142 -
 drivers/media/v4l2-core/videobuf2-vmalloc.c        |    13 +-
 drivers/staging/media/Kconfig                      |     4 +-
 drivers/staging/media/Makefile                     |     2 +-
 drivers/staging/media/cec/Kconfig                  |     3 -
 drivers/staging/media/cec/cec-adap.c               |     4 -
 drivers/staging/media/cec/cec-core.c               |     3 +-
 drivers/staging/media/lirc/lirc_imon.c             |     9 +-
 drivers/staging/media/lirc/lirc_parallel.c         |    10 +-
 drivers/staging/media/lirc/lirc_sasem.c            |     5 -
 drivers/staging/media/omap4iss/iss.c               |     8 +-
 drivers/staging/media/omap4iss/iss_video.c         |    99 +
 drivers/staging/media/pulse8-cec/pulse8-cec.c      |   402 +-
 drivers/staging/media/s5p-cec/s5p_cec.c            |    19 +-
 drivers/staging/media/st-cec/Kconfig               |     8 +
 drivers/staging/media/st-cec/Makefile              |     1 +
 drivers/staging/media/st-cec/stih-cec.c            |   380 +
 drivers/staging/media/tw686x-kh/Kconfig            |    17 -
 drivers/staging/media/tw686x-kh/Makefile           |     3 -
 drivers/staging/media/tw686x-kh/TODO               |     6 -
 drivers/staging/media/tw686x-kh/tw686x-kh-core.c   |   140 -
 drivers/staging/media/tw686x-kh/tw686x-kh-regs.h   |   103 -
 drivers/staging/media/tw686x-kh/tw686x-kh-video.c  |   813 -
 drivers/staging/media/tw686x-kh/tw686x-kh.h        |   117 -
 drivers/usb/gadget/Kconfig                         |     1 +
 include/linux/platform_data/media/camera-pxa.h     |     2 +
 include/media/drv-intf/sh_mobile_ceu.h             |     1 -
 include/media/drv-intf/sh_mobile_csi2.h            |    48 -
 include/media/i2c/smiapp.h                         |     7 +-
 include/media/media-device.h                       |   131 +-
 include/media/media-devnode.h                      |     5 +-
 include/media/media-entity.h                       |   248 +-
 include/media/rc-core.h                            |     2 +-
 include/media/rc-map.h                             |   105 +-
 include/media/rcar-fcp.h                           |     2 +-
 include/media/soc_camera.h                         |     7 +-
 include/media/v4l2-ctrls.h                         |    62 +-
 include/media/v4l2-dev.h                           |    18 +-
 include/media/v4l2-device.h                        |    68 +-
 include/media/v4l2-dv-timings.h                    |     4 +-
 include/media/v4l2-event.h                         |     3 +-
 include/media/v4l2-flash-led-class.h               |    15 +-
 include/media/v4l2-ioctl.h                         |   510 +-
 include/media/v4l2-mc.h                            |     4 +-
 include/media/v4l2-mem2mem.h                       |   264 +-
 include/media/v4l2-subdev.h                        |    32 +-
 include/media/videobuf2-core.h                     |   380 +-
 include/media/videobuf2-v4l2.h                     |   182 +-
 include/media/vsp1.h                               |     2 +-
 include/uapi/linux/dvb/video.h                     |     3 +-
 include/uapi/linux/media-bus-format.h              |    10 +-
 include/uapi/linux/media.h                         |     1 +
 include/uapi/linux/v4l2-dv-timings.h               |    12 +
 include/uapi/linux/videodev2.h                     |    38 +-
 scripts/kernel-doc                                 |    48 +-
 832 files changed, 43579 insertions(+), 51373 deletions(-)
 delete mode 100644 Documentation/DocBook/device-drivers.tmpl
 rename Documentation/{coccinelle.txt => dev-tools/coccinelle.rst} (56%)
 create mode 100644 Documentation/dev-tools/gcov.rst
 rename Documentation/{gdb-kernel-debugging.txt => dev-tools/gdb-kernel-debugging.rst} (73%)
 create mode 100644 Documentation/dev-tools/kasan.rst
 rename Documentation/{kcov.txt => dev-tools/kcov.rst} (78%)
 create mode 100644 Documentation/dev-tools/kmemcheck.rst
 rename Documentation/{kmemleak.txt => dev-tools/kmemleak.rst} (73%)
 rename Documentation/{sparse.txt => dev-tools/sparse.rst} (82%)
 create mode 100644 Documentation/dev-tools/tools.rst
 rename Documentation/{ubsan.txt => dev-tools/ubsan.rst} (78%)
 create mode 100644 Documentation/devicetree/bindings/media/atmel-isc.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ad5820.txt
 create mode 100644 Documentation/devicetree/bindings/media/st,st-hva.txt
 create mode 100644 Documentation/devicetree/bindings/media/stih-cec.txt
 create mode 100644 Documentation/docutils.conf
 create mode 100644 Documentation/driver-api/basics.rst
 create mode 100644 Documentation/driver-api/frame-buffer.rst
 create mode 100644 Documentation/driver-api/hsi.rst
 create mode 100644 Documentation/driver-api/i2c.rst
 create mode 100644 Documentation/driver-api/index.rst
 create mode 100644 Documentation/driver-api/infrastructure.rst
 create mode 100644 Documentation/driver-api/input.rst
 create mode 100644 Documentation/driver-api/message-based.rst
 create mode 100644 Documentation/driver-api/miscellaneous.rst
 create mode 100644 Documentation/driver-api/sound.rst
 create mode 100644 Documentation/driver-api/spi.rst
 delete mode 100644 Documentation/gcov.txt
 create mode 100644 Documentation/gpu/conf.py
 delete mode 100644 Documentation/hsi.txt
 delete mode 100644 Documentation/kasan.txt
 delete mode 100644 Documentation/kmemcheck.txt
 create mode 100644 Documentation/media/conf.py
 create mode 100644 Documentation/media/conf_nitpick.py
 create mode 100644 Documentation/media/index.rst
 rename Documentation/{cec.txt => media/kapi/cec-core.rst} (72%)
 create mode 100644 Documentation/media/uapi/v4l/dev-touch.rst
 delete mode 100644 Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt.gif
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt.png
 delete mode 100644 Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt_example.gif
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-nv12mt_files/nv12mt_example.png
 delete mode 100644 Documentation/media/uapi/v4l/pixfmt-sbggr8.rst
 delete mode 100644 Documentation/media/uapi/v4l/pixfmt-sgbrg8.rst
 delete mode 100644 Documentation/media/uapi/v4l/pixfmt-sgrbg8.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-tch-td08.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-tch-td16.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-tch-tu08.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-tch-tu16.rst
 create mode 100644 Documentation/media/uapi/v4l/tch-formats.rst
 create mode 100644 Documentation/sphinx/cdomain.py
 create mode 100644 Documentation/sphinx/load_config.py
 mode change 100644 => 100755 Documentation/sphinx/rstFlatTable.py
 create mode 100644 drivers/input/rmi4/rmi_f54.c
 create mode 100644 drivers/media/i2c/ad5820.c
 rename drivers/media/i2c/{soc_camera => }/mt9m111.c (92%)
 create mode 100644 drivers/media/pci/tw5864/Kconfig
 create mode 100644 drivers/media/pci/tw5864/Makefile
 create mode 100644 drivers/media/pci/tw5864/tw5864-core.c
 create mode 100644 drivers/media/pci/tw5864/tw5864-h264.c
 create mode 100644 drivers/media/pci/tw5864/tw5864-reg.h
 create mode 100644 drivers/media/pci/tw5864/tw5864-util.c
 create mode 100644 drivers/media/pci/tw5864/tw5864-video.c
 create mode 100644 drivers/media/pci/tw5864/tw5864.h
 create mode 100644 drivers/media/platform/atmel/Kconfig
 create mode 100644 drivers/media/platform/atmel/Makefile
 create mode 100644 drivers/media/platform/atmel/atmel-isc-regs.h
 create mode 100644 drivers/media/platform/atmel/atmel-isc.c
 rename drivers/media/platform/{soc_camera => }/pxa_camera.c (50%)
 delete mode 100644 drivers/media/platform/s5p-tv/Kconfig
 delete mode 100644 drivers/media/platform/s5p-tv/Makefile
 delete mode 100644 drivers/media/platform/s5p-tv/hdmi_drv.c
 delete mode 100644 drivers/media/platform/s5p-tv/hdmiphy_drv.c
 delete mode 100644 drivers/media/platform/s5p-tv/mixer.h
 delete mode 100644 drivers/media/platform/s5p-tv/mixer_drv.c
 delete mode 100644 drivers/media/platform/s5p-tv/mixer_grp_layer.c
 delete mode 100644 drivers/media/platform/s5p-tv/mixer_reg.c
 delete mode 100644 drivers/media/platform/s5p-tv/mixer_video.c
 delete mode 100644 drivers/media/platform/s5p-tv/mixer_vp_layer.c
 delete mode 100644 drivers/media/platform/s5p-tv/regs-hdmi.h
 delete mode 100644 drivers/media/platform/s5p-tv/regs-mixer.h
 delete mode 100644 drivers/media/platform/s5p-tv/regs-sdo.h
 delete mode 100644 drivers/media/platform/s5p-tv/regs-vp.h
 delete mode 100644 drivers/media/platform/s5p-tv/sdo_drv.c
 delete mode 100644 drivers/media/platform/s5p-tv/sii9234_drv.c
 delete mode 100644 drivers/media/platform/soc_camera/rcar_vin.c
 delete mode 100644 drivers/media/platform/soc_camera/sh_mobile_csi2.c
 create mode 100644 drivers/media/platform/sti/hva/Makefile
 create mode 100644 drivers/media/platform/sti/hva/hva-h264.c
 create mode 100644 drivers/media/platform/sti/hva/hva-hw.c
 create mode 100644 drivers/media/platform/sti/hva/hva-hw.h
 create mode 100644 drivers/media/platform/sti/hva/hva-mem.c
 create mode 100644 drivers/media/platform/sti/hva/hva-mem.h
 create mode 100644 drivers/media/platform/sti/hva/hva-v4l2.c
 create mode 100644 drivers/media/platform/sti/hva/hva.h
 create mode 100644 drivers/media/spi/Kconfig
 create mode 100644 drivers/media/spi/Makefile
 create mode 100644 drivers/media/spi/gs1662.c
 create mode 100644 drivers/media/usb/dvb-usb/dibusb-mc-common.c
 create mode 100644 drivers/staging/media/st-cec/Kconfig
 create mode 100644 drivers/staging/media/st-cec/Makefile
 create mode 100644 drivers/staging/media/st-cec/stih-cec.c
 delete mode 100644 drivers/staging/media/tw686x-kh/Kconfig
 delete mode 100644 drivers/staging/media/tw686x-kh/Makefile
 delete mode 100644 drivers/staging/media/tw686x-kh/TODO
 delete mode 100644 drivers/staging/media/tw686x-kh/tw686x-kh-core.c
 delete mode 100644 drivers/staging/media/tw686x-kh/tw686x-kh-regs.h
 delete mode 100644 drivers/staging/media/tw686x-kh/tw686x-kh-video.c
 delete mode 100644 drivers/staging/media/tw686x-kh/tw686x-kh.h
 delete mode 100644 include/media/drv-intf/sh_mobile_csi2.h

