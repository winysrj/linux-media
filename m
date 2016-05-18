Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58011 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbcERJah convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2016 05:30:37 -0400
Date: Wed, 18 May 2016 06:30:28 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.7-rc1] media updates
Message-ID: <20160518063028.3ad0ff60@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media media/v4.7-1


For:
  - added support for Intersil/Techwell TW686x-based video capture cards;
  - v4l PCI skeleton driver moved to samples directory;
  - Documentation cleanups and improvements;
  - RC: reduced the memory footprint for IR raw events;
  - tpg: Export the tpg code from vivid as a module;
  - adv7180: Add device tree binding documentation;
  - lots of driver improvements and fixes.

Regards,
Mauro

The following changes since commit 44549e8f5eea4e0a41b487b63e616cb089922b99:

  Linux 4.6-rc7 (2016-05-08 14:38:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media media/v4.7-1

for you to fetch changes up to aff093d4bbca91f543e24cde2135f393b8130f4b:

  [media] exynos-gsc: avoid build warning without CONFIG_OF (2016-05-09 18:38:33 -0300)

----------------------------------------------------------------
media updates for v4.7-rc1

----------------------------------------------------------------
Alejandro Torrado (1):
      [media] dib0700: add USB ID for another STK8096-PVR ref design based card

Andrzej Pietrasiewicz (1):
      [media] s5p-jpeg: Adjust buffer size for Exynos 4412

Antti Palosaari (2):
      [media] si2157: detect if firmware is running
      [media] af9035: correct eeprom offsets

Arnd Bergmann (6):
      [media] cobalt: add MTD dependency
      [media] am437x-vfpe: fix typo in vpfe_get_app_input_index
      [media] zl10353: use div_u64 instead of do_div
      [media] dvb-usb: hide unused functions
      [media] samples: v4l: from Documentation to samples directory
      [media] exynos-gsc: avoid build warning without CONFIG_OF

Claudiu Beznea (1):
      [media] Staging: media: bcm2048: defined region_configs[] array as const array

Colin Ian King (1):
      [media] media: i2c: ths7303: remove redundant assignment on bt

Dan Carpenter (4):
      [media] am437x-vpfe: fix an uninitialized variable bug
      [media] cx23885: uninitialized variable in cx23885_av_work_handler()
      [media] m5mols: potential uninitialized variable
      [media] cx231xx: silence uninitialized variable warning

Eric Engestrom (3):
      [media] Documentation: dt: media: fix spelling mistake
      [media] Documentation: DocBook: fix spelling mistake
      [media] Documentation: video4linux: fix spelling mistakes

Ezequiel Garcia (2):
      [media] media: Support Intersil/Techwell TW686x-based video capture cards
      [media] tw686x: Specify that the DMA is 32 bits

Franck Jullien (1):
      [media] xilinx-vipp: remove unnecessary of_node_put

Guennadi Liakhovetski (1):
      [media] au0828: remove unused macro

Hans Verkuil (27):
      [media] v4l2: add device_caps to struct video_device
      [media] v4l2-pci-skeleton.c: fill in device_caps in video_device
      [media] vivid: set device_caps in video_device
      [media] v4l2-ioctl: simplify code
      [media] tw686x-kh: specify that the DMA is 32 bits
      [media] tw686x-kh: add audio support to the TODO list
      [media] tw686x: add missing statics
      [media] tw686x-kh: rename three functions to prevent clash with tw686x driver
      [media] vivid: fix smatch errors
      [media] pvrusb2: fix smatch errors
      [media] dib0090: fix smatch error
      [media] tc358743: zero the reserved array
      [media] vidioc-g-edid.xml: be explicit about zeroing the reserved array
      [media] vidioc-enum-dv-timings.xml: explicitly state that pad and reserved should be zeroed
      [media] vidioc-dv-timings-cap.xml: explicitly state that pad and reserved should be zeroed
      [media] v4l2-device.h: add v4l2_device_mask_ variants
      [media] ivtv/cx18: use the new mask variants of the v4l2_device_call_* defines
      [media] v4l2-rect.h: new header with struct v4l2_rect helper functions
      [media] vivid: use new v4l2-rect.h header
      [media] tw686x-video: test for 60Hz instead of 50Hz
      [media] videodev2.h: remove 'experimental' annotations
      [media] DocBook media: drop 'experimental' annotations
      [media] adv7180: fix broken standards handling
      [media] sta2x11_vip: fix s_std
      [media] tc358743: drop bogus comment
      [media] media/i2c/adv*: make controls inheritable instead of private
      [media] v4l2-ioctl.c: improve cropcap compatibility code

Heiner Kallweit (2):
      [media] media: rc: remove unneeded mutex in rc_register_device
      [media] media: rc: reduce size of struct ir_raw_event

Helen Mae Koike Fornazier (3):
      [media] tpg: Export the tpg code from vivid as a module
      [media] media: change pipeline validation return error
      [media] DocBook: update error code in videoc-streamon

Ivaylo Dimitrov (1):
      [media] smiapp: provide g_skip_top_lines method in sensor ops

Javier Martinez Canillas (3):
      [media] exynos4-is: Put node before s5pcsis_parse_dt() return error
      [media] tvp5150: return I2C write operation failure to callers
      [media] tvp5150: propagate I2C write error in .s_register callback

Julia Lawall (1):
      [media] s5p-tv: constify mxr_layer_ops structures

Julian Scheel (2):
      [media] media: adv7180: Add device tree binding document
      [media] media: adv7180: Add of compatible strings for full family

Kevin Fitch (1):
      [media] i2c: saa7115: Support CJC7113 detection

Krzysztof Hałasa (1):
      [media] TW686x frame grabber driver

Krzysztof Kozlowski (1):
      [media] exynos4-is: Add missing port parent of_node_put on error paths

Laurent Pinchart (53):
      [media] media: Add obj_type field to struct media_entity
      [media] media: Rename is_media_entity_v4l2_io to is_media_entity_v4l2_video_device
      [media] v4l: subdev: Add pad config allocator and init
      [media] v4l: vsp1: Fix vsp1_du_atomic_(begin|flush) declarations
      [media] v4l: vsp1: drm: Include correct header file
      [media] v4l: vsp1: video: Fix coding style
      [media] v4l: vsp1: VSPD instances have no LUT on Gen3
      [media] v4l: vsp1: Use pipeline display list to decide how to write to modules
      [media] v4l: vsp1: Always setup the display list
      [media] v4l: vsp1: Simplify frame end processing
      [media] v4l: vsp1: Split display list manager from display list
      [media] v4l: vsp1: Store the display list manager in the WPF
      [media] v4l: vsp1: bru: Don't program background color in control set handler
      [media] v4l: vsp1: rwpf: Don't program alpha value in control set handler
      [media] v4l: vsp1: sru: Don't program intensity in control set handler
      [media] v4l: vsp1: Don't setup control handler when starting streaming
      [media] v4l: vsp1: Enable display list support for the HS[IT], LUT, SRU and UDS
      [media] v4l: vsp1: Don't configure RPF memory buffers before calculating offsets
      [media] v4l: vsp1: Remove unneeded entity streaming flag
      [media] v4l: vsp1: Document calling context of vsp1_pipeline_propagate_alpha()
      [media] v4l: vsp1: Fix 80 characters per line violations
      [media] v4l: vsp1: Add header display list support
      [media] v4l: vsp1: Use display lists with the userspace API
      [media] v4l: vsp1: Move subdev initialization code to vsp1_entity_init()
      [media] v4l: vsp1: Consolidate entity ops in a struct vsp1_entity_operations
      [media] v4l: vsp1: Fix BRU try compose rectangle storage
      [media] v4l: vsp1: Add race condition FIXME comment
      [media] v4l: vsp1: Implement and use the subdev pad::init_cfg configuration
      [media] v4l: vsp1: Store active formats in a pad config structure
      [media] v4l: vsp1: Store active selection rectangles in a pad config structure
      [media] v4l: vsp1: Create a new configure operation to setup modules
      [media] v4l: vsp1: Merge RPF and WPF pad ops structures
      [media] v4l: vsp1: Use __vsp1_video_try_format to initialize format at init time
      [media] v4l: vsp1: Pass display list explicitly to configure functions
      [media] v4l: vsp1: Rename pipeline validate functions to pipeline build
      [media] v4l: vsp1: Pass pipe pointer to entity configure functions
      [media] v4l: vsp1: Store pipeline pointer in rwpf
      [media] v4l: vsp1: video: Reorder functions
      [media] v4l: vsp1: Allocate pipelines on demand
      [media] v4l: vsp1: RPF entities can't be target nodes
      [media] v4l: vsp1: Factorize get pad format code
      [media] v4l: vsp1: Factorize media bus codes enumeration code
      [media] v4l: vsp1: Factorize frame size enumeration code
      [media] v4l: vsp1: Fix LUT format setting
      [media] v4l: vsp1: dl: Make reg_count field unsigned
      [media] v4l: vsp1: dl: Fix race conditions
      [media] v4l: vsp1: dl: Add support for multi-body display lists
      [media] v4l: vsp1: lut: Use display list fragments to fill LUT
      [media] v4l: vsp1: Add support for the RPF alpha multiplier on Gen3
      [media] v4l: vsp1: Add Z-order support for DRM pipeline
      [media] v4l: vsp1: Add global alpha support for DRM pipeline
      [media] v4l: vsp1: Fix V4L2_PIX_FMT_XRGB444 format definition
      [media] v4l: vsp1: Update WPF and LIF maximum sizes for Gen3

Marek Szyprowski (4):
      [media] exynos-gsc: remove non-device-tree init code
      [media] s5p-g2d: remove non-device-tree init code
      [media] s5p-mfc: remove non-device-tree init code
      [media] exynos4-is: remove non-device-tree init code

Mauro Carvalho Chehab (19):
      [media] media-device: Fix a comment
      [media] media-device: make topology_version u64
      [media] au0828: Unregister notifiers
      [media] exynos-gsc: remove an always false condition
      [media] cx231xx: return proper error codes at cx231xx-417.c
      [media] vsp1: make vsp1_drm_frame_end static
      Revert "[media] v4l2-ioctl: simplify code"
      [media] media-device: get rid of the spinlock
      [media] media: Improve documentation for link_setup/link_modify
      [media] tw686x-kh: use the cached value
      [media] sta2x11: remove unused vars
      [media] tw686x: Don't go past array
      [media] tw686x: avoid going past array
      Merge tag 'v4.6-rc6' into patchwork
      [media] dw2102: move USB IDs to dvb-usb-ids.h
      [media] media-device: Simplify compat32 logic
      Merge tag 'v4.6-rc7' into patchwork
      [media] update cx23885 and em28xx cardlists
      [media] em28xx: add missing USB IDs

Max Kellermann (5):
      [media] media-devnode: add missing mutex lock in error handler
      [media] media/dvb-core: forward media_create_pad_links() return value
      [media] drivers/media/rc: postpone kfree(rc_dev)
      [media] drivers/media/media-device: move debug log before _devnode_unregister()
      [media] drivers/media/media-devnode: clear private_data before put_device()

Niklas Söderlund (3):
      [media] adv7180: Add g_std operation
      [media] adv7180: Add cropcap operation
      [media] adv7180: Add g_tvnorms operation

Olli Salonen (9):
      [media] az6027: Add support for Elgato EyeTV Sat v3
      [media] smipcie: add support for TechnoTrend S2-4200 Twin
      [media] smipcie: MAC address printout formatting
      [media] smipcie: add RC map into card configuration options
      [media] ds3000: return meaningful return codes
      [media] pctv452e: correct parameters for TechnoTrend TT S2-3600
      [media] mceusb: add support for Adaptec eHome receiver
      [media] mceusb: add support for SMK eHome receiver
      [media] em28xx: add support for Hauppauge WinTV-dualHD DVB tuner

Peter Griffin (3):
      [media] c8sectpfe: Fix broken circular buffer wp management
      [media] c8sectpfe: Demote print to dev_dbg
      [media] c8sectpfe: Rework firmware loading mechanism

Peter Rosin (1):
      [media] m88ds3103: fix undefined division

Rasmus Villemoes (2):
      [media] drivers/media/pci/zoran: avoid fragile snprintf use
      [media] ati_remote: avoid fragile snprintf use

Satoshi Nagahama (1):
      [media] em28xx: add support for PLEX PX-BCUD (ISDB-S)

Shuah Khan (1):
      [media] media: au0828 fix au0828_v4l2_device_register() to not unlock and free

Simon Horman (4):
      [media] rcar_vin: Use ARCH_RENESAS
      [media] sh_mobile_ceu_camera: Remove dependency on SUPERH
      [media] soc_camera: rcar_vin: add device tree support for r8a7792
      [media] media: platform: rcar_jpu, vsp1: Use ARCH_RENESAS

Sudip Mukherjee (2):
      [media] cx231xx: fix memory leak
      [media] dw2102: fix unreleased firmware

Tiffany Lin (1):
      [media] media: v4l2-compat-ioctl32: fix missing reserved field copy in put_v4l2_create32

Vladimir Zapolskiy (1):
      [media] media: i2c/adp1653: fix check of devm_gpiod_get() error code

Yoshihiro Kaneko (1):
      [media] soc_camera: rcar_vin: add R-Car Gen 2 and 3 fallback compatibility strings

 Documentation/DocBook/device-drivers.tmpl          |   1 +
 Documentation/DocBook/media/dvb/net.xml            |   2 +-
 Documentation/DocBook/media/v4l/compat.xml         |  38 -
 Documentation/DocBook/media/v4l/controls.xml       |  31 -
 Documentation/DocBook/media/v4l/dev-sdr.xml        |   6 -
 Documentation/DocBook/media/v4l/dev-subdev.xml     |   6 -
 Documentation/DocBook/media/v4l/io.xml             |   6 -
 Documentation/DocBook/media/v4l/selection-api.xml  |   9 +-
 Documentation/DocBook/media/v4l/subdev-formats.xml |   6 -
 .../DocBook/media/v4l/vidioc-create-bufs.xml       |   6 -
 .../DocBook/media/v4l/vidioc-dv-timings-cap.xml    |  18 +-
 .../DocBook/media/v4l/vidioc-enum-dv-timings.xml   |  11 +-
 .../DocBook/media/v4l/vidioc-enum-freq-bands.xml   |   6 -
 Documentation/DocBook/media/v4l/vidioc-expbuf.xml  |   6 -
 Documentation/DocBook/media/v4l/vidioc-g-edid.xml  |  10 +-
 .../DocBook/media/v4l/vidioc-g-selection.xml       |   6 -
 .../DocBook/media/v4l/vidioc-prepare-buf.xml       |   6 -
 .../DocBook/media/v4l/vidioc-query-dv-timings.xml  |   6 -
 .../DocBook/media/v4l/vidioc-streamon.xml          |   8 +
 .../v4l/vidioc-subdev-enum-frame-interval.xml      |   6 -
 .../media/v4l/vidioc-subdev-enum-frame-size.xml    |   6 -
 .../media/v4l/vidioc-subdev-enum-mbus-code.xml     |   6 -
 .../DocBook/media/v4l/vidioc-subdev-g-fmt.xml      |   6 -
 .../media/v4l/vidioc-subdev-g-frame-interval.xml   |   6 -
 .../media/v4l/vidioc-subdev-g-selection.xml        |   6 -
 Documentation/Makefile                             |   3 +-
 .../devicetree/bindings/media/i2c/adv7180.txt      |  29 +
 .../devicetree/bindings/media/rcar_vin.txt         |  12 +-
 .../devicetree/bindings/media/xilinx/video.txt     |   2 +-
 Documentation/video4linux/CARDLIST.cx23885         |   2 +
 Documentation/video4linux/CARDLIST.em28xx          |  12 +-
 Documentation/video4linux/v4l2-framework.txt       |   2 +-
 Documentation/video4linux/vivid.txt                |   6 +-
 MAINTAINERS                                        |   8 +
 drivers/media/common/Kconfig                       |   1 +
 drivers/media/common/Makefile                      |   2 +-
 drivers/media/common/v4l2-tpg/Kconfig              |   2 +
 drivers/media/common/v4l2-tpg/Makefile             |   3 +
 .../v4l2-tpg/v4l2-tpg-colors.c}                    |   7 +-
 .../v4l2-tpg/v4l2-tpg-core.c}                      |  25 +-
 drivers/media/dvb-core/dvb-usb-ids.h               |  14 +
 drivers/media/dvb-core/dvbdev.c                    |   4 +-
 drivers/media/dvb-frontends/dib0090.c              |   2 +-
 drivers/media/dvb-frontends/ds3000.c               |  14 +-
 drivers/media/dvb-frontends/m88ds3103_priv.h       |   2 +-
 drivers/media/dvb-frontends/zl10353.c              |   6 +-
 drivers/media/i2c/ad9389b.c                        |   8 -
 drivers/media/i2c/adp1653.c                        |   4 +-
 drivers/media/i2c/adv7180.c                        | 160 +++-
 drivers/media/i2c/adv7511.c                        |   6 -
 drivers/media/i2c/adv7604.c                        |   8 -
 drivers/media/i2c/adv7842.c                        |   6 -
 drivers/media/i2c/m5mols/m5mols_controls.c         |   2 +-
 drivers/media/i2c/saa7115.c                        |  15 +
 drivers/media/i2c/smiapp/smiapp-core.c             |  12 +
 drivers/media/i2c/smiapp/smiapp.h                  |   1 +
 drivers/media/i2c/tc358743.c                       |   5 +-
 drivers/media/i2c/ths7303.c                        |   2 +-
 drivers/media/i2c/tvp5150.c                        |   9 +-
 drivers/media/media-device.c                       |  50 +-
 drivers/media/media-devnode.c                      |   6 +-
 drivers/media/media-entity.c                       |  18 +-
 drivers/media/pci/Kconfig                          |   1 +
 drivers/media/pci/Makefile                         |   1 +
 drivers/media/pci/cobalt/Kconfig                   |   1 +
 drivers/media/pci/cx18/cx18-driver.h               |  13 +-
 drivers/media/pci/cx23885/cx23885-av.c             |   2 +-
 drivers/media/pci/ivtv/ivtv-driver.h               |  13 +-
 drivers/media/pci/smipcie/smipcie-ir.c             |   2 +-
 drivers/media/pci/smipcie/smipcie-main.c           |  17 +-
 drivers/media/pci/smipcie/smipcie.h                |   2 +
 drivers/media/pci/sta2x11/sta2x11_vip.c            |  28 +-
 drivers/media/pci/tw686x/Kconfig                   |  18 +
 drivers/media/pci/tw686x/Makefile                  |   3 +
 drivers/media/pci/tw686x/tw686x-audio.c            | 386 +++++++++
 drivers/media/pci/tw686x/tw686x-core.c             | 415 +++++++++
 drivers/media/pci/tw686x/tw686x-regs.h             | 122 +++
 drivers/media/pci/tw686x/tw686x-video.c            | 937 +++++++++++++++++++++
 drivers/media/pci/tw686x/tw686x.h                  | 158 ++++
 drivers/media/pci/zoran/videocodec.c               |   5 +-
 drivers/media/platform/Kconfig                     |   4 +-
 drivers/media/platform/am437x/am437x-vpfe.c        |   4 +-
 drivers/media/platform/exynos-gsc/gsc-core.c       |  35 +-
 drivers/media/platform/exynos-gsc/gsc-core.h       |   1 -
 drivers/media/platform/exynos4-is/fimc-core.c      |  50 --
 drivers/media/platform/exynos4-is/media-dev.c      |   8 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |   6 +-
 drivers/media/platform/omap3isp/ispvideo.c         |   2 +-
 drivers/media/platform/s5p-g2d/g2d.c               |  27 +-
 drivers/media/platform/s5p-g2d/g2d.h               |   5 -
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |   7 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |  37 +-
 drivers/media/platform/s5p-tv/mixer.h              |   2 +-
 drivers/media/platform/s5p-tv/mixer_grp_layer.c    |   2 +-
 drivers/media/platform/s5p-tv/mixer_video.c        |   2 +-
 drivers/media/platform/s5p-tv/mixer_vp_layer.c     |   2 +-
 drivers/media/platform/soc_camera/Kconfig          |   4 +-
 drivers/media/platform/soc_camera/rcar_vin.c       |   2 +
 .../media/platform/sti/c8sectpfe/c8sectpfe-core.c  |  69 +-
 drivers/media/platform/vivid/Kconfig               |   1 +
 drivers/media/platform/vivid/Makefile              |   2 +-
 drivers/media/platform/vivid/vivid-core.c          |  22 +-
 drivers/media/platform/vivid/vivid-core.h          |   2 +-
 drivers/media/platform/vivid/vivid-kthread-cap.c   |  13 +-
 drivers/media/platform/vivid/vivid-rds-gen.c       |  19 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       | 101 +--
 drivers/media/platform/vivid/vivid-vid-common.c    |  97 ---
 drivers/media/platform/vivid/vivid-vid-common.h    |   9 -
 drivers/media/platform/vivid/vivid-vid-out.c       | 103 +--
 drivers/media/platform/vsp1/vsp1.h                 |  14 +-
 drivers/media/platform/vsp1/vsp1_bru.c             | 359 ++++----
 drivers/media/platform/vsp1/vsp1_bru.h             |   3 +-
 drivers/media/platform/vsp1/vsp1_dl.c              | 567 ++++++++++---
 drivers/media/platform/vsp1/vsp1_dl.h              |  49 +-
 drivers/media/platform/vsp1/vsp1_drm.c             | 234 ++---
 drivers/media/platform/vsp1/vsp1_drm.h             |  27 +-
 drivers/media/platform/vsp1/vsp1_drv.c             |  34 +-
 drivers/media/platform/vsp1/vsp1_entity.c          | 288 +++++--
 drivers/media/platform/vsp1/vsp1_entity.h          |  63 +-
 drivers/media/platform/vsp1/vsp1_hsit.c            | 130 +--
 drivers/media/platform/vsp1/vsp1_lif.c             | 179 ++--
 drivers/media/platform/vsp1/vsp1_lut.c             | 172 ++--
 drivers/media/platform/vsp1/vsp1_lut.h             |   6 +-
 drivers/media/platform/vsp1/vsp1_pipe.c            |  71 +-
 drivers/media/platform/vsp1/vsp1_pipe.h            |  19 +-
 drivers/media/platform/vsp1/vsp1_regs.h            |  10 +
 drivers/media/platform/vsp1/vsp1_rpf.c             | 275 +++---
 drivers/media/platform/vsp1/vsp1_rwpf.c            | 171 ++--
 drivers/media/platform/vsp1/vsp1_rwpf.h            |  64 +-
 drivers/media/platform/vsp1/vsp1_sru.c             | 214 ++---
 drivers/media/platform/vsp1/vsp1_sru.h             |   2 +
 drivers/media/platform/vsp1/vsp1_uds.c             | 223 +++--
 drivers/media/platform/vsp1/vsp1_uds.h             |   3 +-
 drivers/media/platform/vsp1/vsp1_video.c           | 493 ++++++-----
 drivers/media/platform/vsp1/vsp1_video.h           |   2 -
 drivers/media/platform/vsp1/vsp1_wpf.c             | 279 +++---
 drivers/media/platform/xilinx/xilinx-vipp.c        |   8 +-
 drivers/media/rc/ati_remote.c                      |  11 +-
 drivers/media/rc/mceusb.c                          |   6 +
 drivers/media/rc/rc-main.c                         |   9 +-
 drivers/media/tuners/qm1d1c0042.c                  |  38 +-
 drivers/media/tuners/si2157.c                      |  19 +-
 drivers/media/tuners/si2157_priv.h                 |   1 -
 drivers/media/usb/au0828/au0828-core.c             |  38 +-
 drivers/media/usb/au0828/au0828-video.c            |   4 -
 drivers/media/usb/au0828/au0828.h                  |   1 -
 drivers/media/usb/cx231xx/cx231xx-417.c            |  31 +-
 drivers/media/usb/cx231xx/cx231xx-core.c           |   3 +-
 drivers/media/usb/dvb-usb-v2/af9035.h              |  24 +-
 drivers/media/usb/dvb-usb/az6027.c                 |   7 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c        |   4 +-
 drivers/media/usb/dvb-usb/dibusb-common.c          |   4 +-
 drivers/media/usb/dvb-usb/dw2102.c                 |  63 +-
 drivers/media/usb/dvb-usb/pctv452e.c               |   4 +-
 drivers/media/usb/em28xx/Kconfig                   |   2 +
 drivers/media/usb/em28xx/em28xx-cards.c            |  88 ++
 drivers/media/usb/em28xx/em28xx-dvb.c              | 185 ++++
 drivers/media/usb/em28xx/em28xx-reg.h              |  13 +
 drivers/media/usb/em28xx/em28xx.h                  |   3 +
 drivers/media/usb/go7007/go7007-v4l2.c             |   2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |   9 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   3 +-
 drivers/media/v4l2-core/v4l2-dev.c                 |   1 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |  73 +-
 drivers/media/v4l2-core/v4l2-mc.c                  |   2 +-
 drivers/media/v4l2-core/v4l2-subdev.c              |  44 +-
 drivers/staging/media/Kconfig                      |   2 +
 drivers/staging/media/Makefile                     |   1 +
 drivers/staging/media/bcm2048/radio-bcm2048.c      |   2 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |   2 +-
 drivers/staging/media/omap4iss/iss_video.c         |   2 +-
 drivers/staging/media/tw686x-kh/Kconfig            |  17 +
 drivers/staging/media/tw686x-kh/Makefile           |   3 +
 drivers/staging/media/tw686x-kh/TODO               |   6 +
 drivers/staging/media/tw686x-kh/tw686x-kh-core.c   | 140 +++
 drivers/staging/media/tw686x-kh/tw686x-kh-regs.h   | 103 +++
 drivers/staging/media/tw686x-kh/tw686x-kh-video.c  | 821 ++++++++++++++++++
 drivers/staging/media/tw686x-kh/tw686x-kh.h        | 118 +++
 include/media/media-device.h                       |  13 +-
 include/media/media-entity.h                       |  81 +-
 include/media/rc-core.h                            |  18 +-
 include/media/v4l2-dev.h                           |   3 +
 include/media/v4l2-device.h                        |  55 +-
 include/media/v4l2-rect.h                          | 173 ++++
 include/media/v4l2-subdev.h                        |   8 +
 .../media/v4l2-tpg-colors.h                        |   6 +-
 .../vivid/vivid-tpg.h => include/media/v4l2-tpg.h  |   9 +-
 include/media/vsp1.h                               |  23 +-
 include/uapi/linux/videodev2.h                     |  38 +-
 samples/Makefile                                   |   2 +-
 .../video4linux => samples/v4l}/Makefile           |   0
 .../v4l}/v4l2-pci-skeleton.c                       |   5 +-
 192 files changed, 6757 insertions(+), 3001 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/adv7180.txt
 create mode 100644 drivers/media/common/v4l2-tpg/Kconfig
 create mode 100644 drivers/media/common/v4l2-tpg/Makefile
 rename drivers/media/{platform/vivid/vivid-tpg-colors.c => common/v4l2-tpg/v4l2-tpg-colors.c} (99%)
 rename drivers/media/{platform/vivid/vivid-tpg.c => common/v4l2-tpg/v4l2-tpg-core.c} (98%)
 create mode 100644 drivers/media/pci/tw686x/Kconfig
 create mode 100644 drivers/media/pci/tw686x/Makefile
 create mode 100644 drivers/media/pci/tw686x/tw686x-audio.c
 create mode 100644 drivers/media/pci/tw686x/tw686x-core.c
 create mode 100644 drivers/media/pci/tw686x/tw686x-regs.h
 create mode 100644 drivers/media/pci/tw686x/tw686x-video.c
 create mode 100644 drivers/media/pci/tw686x/tw686x.h
 create mode 100644 drivers/staging/media/tw686x-kh/Kconfig
 create mode 100644 drivers/staging/media/tw686x-kh/Makefile
 create mode 100644 drivers/staging/media/tw686x-kh/TODO
 create mode 100644 drivers/staging/media/tw686x-kh/tw686x-kh-core.c
 create mode 100644 drivers/staging/media/tw686x-kh/tw686x-kh-regs.h
 create mode 100644 drivers/staging/media/tw686x-kh/tw686x-kh-video.c
 create mode 100644 drivers/staging/media/tw686x-kh/tw686x-kh.h
 create mode 100644 include/media/v4l2-rect.h
 rename drivers/media/platform/vivid/vivid-tpg-colors.h => include/media/v4l2-tpg-colors.h (93%)
 rename drivers/media/platform/vivid/vivid-tpg.h => include/media/v4l2-tpg.h (99%)
 rename {Documentation/video4linux => samples/v4l}/Makefile (100%)
 rename {Documentation/video4linux => samples/v4l}/v4l2-pci-skeleton.c (99%)

