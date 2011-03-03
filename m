Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44759 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757923Ab1CCKYx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2011 05:24:53 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [GIT PULL FOR 2.6.39] Media controller and OMAP3 ISP driver
Date: Thu, 3 Mar 2011 11:25:05 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org,
	Sakari Ailus <sakari.ailus@retiisi.org.uk>,
	Pawel Osciak <pawel@osciak.com>
References: <201102171606.58540.laurent.pinchart@ideasonboard.com> <4D6EA4EB.9070607@redhat.com>
In-Reply-To: <4D6EA4EB.9070607@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103031125.06419.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

The following changes since commit 88a763df226facb74fdb254563e30e9efb64275c:

  [media] dw2102: prof 1100 corrected (2011-03-02 16:56:54 -0300)

are available in the git repository at:
  git://linuxtv.org/pinchartl/media.git media-2.6.39-0005-omap3isp

The branch has been rebased on top of the latest for_v2.6.39 branch, with the
v4l2-ioctl.c conflict resolved.

Antti Koskipaa (1):
      v4l: v4l2_subdev userspace crop API

David Cohen (1):
      omap3isp: Statistics

Laurent Pinchart (36):
      v4l: Share code between video_usercopy and video_ioctl2
      v4l: subdev: Don't require core operations
      v4l: subdev: Add device node support
      v4l: subdev: Uninline the v4l2_subdev_init function
      v4l: subdev: Control ioctls support
      media: Media device node support
      media: Media device
      media: Entities, pads and links
      media: Entity use count
      media: Media device information query
      media: Entities, pads and links enumeration
      media: Links setup
      media: Pipelines and media streams
      v4l: Add a media_device pointer to the v4l2_device structure
      v4l: Make video_device inherit from media_entity
      v4l: Make v4l2_subdev inherit from media_entity
      v4l: Move the media/v4l2-mediabus.h header to include/linux
      v4l: Replace enums with fixed-sized fields in public structure
      v4l: Rename V4L2_MBUS_FMT_GREY8_1X8 to V4L2_MBUS_FMT_Y8_1X8
      v4l: Group media bus pixel codes by types and sort them alphabetically
      v4l: subdev: Add new file operations
      v4l: v4l2_subdev pad-level operations
      v4l: v4l2_subdev userspace format API - documentation binary files
      v4l: v4l2_subdev userspace format API
      v4l: v4l2_subdev userspace frame interval API
      v4l: subdev: Generic ioctl support
      v4l: Add subdev sensor g_skip_frames operation
      v4l: Add 8-bit YUYV on 16-bit bus and SGRBG10 media bus pixel codes
      v4l: Add remaining RAW10 patterns w DPCM pixel code variants
      v4l: Add missing 12 bits bayer media bus formats
      v4l: Add 12 bits bayer pixel formats
      omap3: Add function to register omap3isp platform device structure
      omap3isp: Video devices and buffers queue
      omap3isp: CCP2/CSI2 receivers
      omap3isp: CCDC, preview engine and resizer
      omap3isp: Kconfig and Makefile

Sakari Ailus (3):
      v4l: subdev: Events support
      media: Entity graph traversal
      omap3isp: OMAP3 ISP core

Sergio Aguirre (2):
      omap3: Remove unusued ISP CBUFF resource
      omap2: Fix camera resources for multiomap

Stanimir Varbanov (1):
      v4l: Create v4l2 subdev file handle structure

Tuukka Toivonen (1):
      ARM: OMAP3: Update Camera ISP definitions for OMAP3630

 Documentation/ABI/testing/sysfs-bus-media          |    6 +
 Documentation/DocBook/Makefile                     |    5 +-
 Documentation/DocBook/media-entities.tmpl          |   50 +
 Documentation/DocBook/media.tmpl                   |    3 +
 Documentation/DocBook/v4l/bayer.pdf                |  Bin 0 -> 12116 bytes
 Documentation/DocBook/v4l/bayer.png                |  Bin 0 -> 9725 bytes
 Documentation/DocBook/v4l/dev-subdev.xml           |  313 +++
 Documentation/DocBook/v4l/media-controller.xml     |   89 +
 Documentation/DocBook/v4l/media-func-close.xml     |   59 +
 Documentation/DocBook/v4l/media-func-ioctl.xml     |  116 +
 Documentation/DocBook/v4l/media-func-open.xml      |   94 +
 .../DocBook/v4l/media-ioc-device-info.xml          |  133 ++
 .../DocBook/v4l/media-ioc-enum-entities.xml        |  308 +++
 Documentation/DocBook/v4l/media-ioc-enum-links.xml |  207 ++
 Documentation/DocBook/v4l/media-ioc-setup-link.xml |   93 +
 Documentation/DocBook/v4l/pipeline.pdf             |  Bin 0 -> 20276 bytes
 Documentation/DocBook/v4l/pipeline.png             |  Bin 0 -> 12130 bytes
 Documentation/DocBook/v4l/subdev-formats.xml       | 2467 ++++++++++++++++++++
 Documentation/DocBook/v4l/v4l2.xml                 |    7 +
 Documentation/DocBook/v4l/vidioc-streamon.xml      |    9 +
 .../v4l/vidioc-subdev-enum-frame-interval.xml      |  152 ++
 .../DocBook/v4l/vidioc-subdev-enum-frame-size.xml  |  154 ++
 .../DocBook/v4l/vidioc-subdev-enum-mbus-code.xml   |  119 +
 Documentation/DocBook/v4l/vidioc-subdev-g-crop.xml |  155 ++
 Documentation/DocBook/v4l/vidioc-subdev-g-fmt.xml  |  180 ++
 .../DocBook/v4l/vidioc-subdev-g-frame-interval.xml |  141 ++
 Documentation/media-framework.txt                  |  353 +++
 Documentation/video4linux/v4l2-framework.txt       |  127 +-
 MAINTAINERS                                        |    6 +
 arch/arm/mach-omap2/devices.c                      |   63 +-
 arch/arm/mach-omap2/devices.h                      |   19 +
 arch/arm/plat-omap/include/plat/omap34xx.h         |   16 +-
 drivers/media/Kconfig                              |   22 +
 drivers/media/Makefile                             |    6 +
 drivers/media/media-device.c                       |  382 +++
 drivers/media/media-devnode.c                      |  321 +++
 drivers/media/media-entity.c                       |  536 +++++
 drivers/media/video/Kconfig                        |   13 +
 drivers/media/video/Makefile                       |    4 +-
 drivers/media/video/mt9m001.c                      |    2 +-
 drivers/media/video/mt9v022.c                      |    4 +-
 drivers/media/video/omap3-isp/Makefile             |   13 +
 drivers/media/video/omap3-isp/cfa_coef_table.h     |   61 +
 drivers/media/video/omap3-isp/gamma_table.h        |   90 +
 drivers/media/video/omap3-isp/isp.c                | 2220 ++++++++++++++++++
 drivers/media/video/omap3-isp/isp.h                |  427 ++++
 drivers/media/video/omap3-isp/ispccdc.c            | 2268 ++++++++++++++++++
 drivers/media/video/omap3-isp/ispccdc.h            |  219 ++
 drivers/media/video/omap3-isp/ispccp2.c            | 1173 ++++++++++
 drivers/media/video/omap3-isp/ispccp2.h            |   98 +
 drivers/media/video/omap3-isp/ispcsi2.c            | 1317 +++++++++++
 drivers/media/video/omap3-isp/ispcsi2.h            |  166 ++
 drivers/media/video/omap3-isp/ispcsiphy.c          |  247 ++
 drivers/media/video/omap3-isp/ispcsiphy.h          |   74 +
 drivers/media/video/omap3-isp/isph3a.h             |  117 +
 drivers/media/video/omap3-isp/isph3a_aewb.c        |  374 +++
 drivers/media/video/omap3-isp/isph3a_af.c          |  429 ++++
 drivers/media/video/omap3-isp/isphist.c            |  520 ++++
 drivers/media/video/omap3-isp/isphist.h            |   40 +
 drivers/media/video/omap3-isp/isppreview.c         | 2113 +++++++++++++++++
 drivers/media/video/omap3-isp/isppreview.h         |  214 ++
 drivers/media/video/omap3-isp/ispqueue.c           | 1153 +++++++++
 drivers/media/video/omap3-isp/ispqueue.h           |  187 ++
 drivers/media/video/omap3-isp/ispreg.h             | 1589 +++++++++++++
 drivers/media/video/omap3-isp/ispresizer.c         | 1693 ++++++++++++++
 drivers/media/video/omap3-isp/ispresizer.h         |  147 ++
 drivers/media/video/omap3-isp/ispstat.c            | 1092 +++++++++
 drivers/media/video/omap3-isp/ispstat.h            |  169 ++
 drivers/media/video/omap3-isp/ispvideo.c           | 1264 ++++++++++
 drivers/media/video/omap3-isp/ispvideo.h           |  202 ++
 drivers/media/video/omap3-isp/luma_enhance_table.h |   42 +
 drivers/media/video/omap3-isp/noise_filter_table.h |   30 +
 drivers/media/video/ov6650.c                       |   10 +-
 drivers/media/video/sh_mobile_csi2.c               |    6 +-
 drivers/media/video/soc_mediabus.c                 |    2 +-
 drivers/media/video/v4l2-dev.c                     |   76 +-
 drivers/media/video/v4l2-device.c                  |   84 +-
 drivers/media/video/v4l2-ioctl.c                   |  109 +-
 drivers/media/video/v4l2-subdev.c                  |  332 +++
 include/linux/Kbuild                               |    4 +
 include/linux/media.h                              |  132 ++
 include/linux/omap3isp.h                           |  646 +++++
 include/linux/v4l2-mediabus.h                      |  108 +
 include/linux/v4l2-subdev.h                        |  141 ++
 include/linux/videodev2.h                          |    4 +
 include/media/media-device.h                       |   95 +
 include/media/media-devnode.h                      |   97 +
 include/media/media-entity.h                       |  151 ++
 include/media/soc_mediabus.h                       |    3 +-
 include/media/v4l2-dev.h                           |   25 +-
 include/media/v4l2-device.h                        |   10 +
 include/media/v4l2-mediabus.h                      |   61 +-
 include/media/v4l2-subdev.h                        |  111 +-
 93 files changed, 28434 insertions(+), 255 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-media
 create mode 100644 Documentation/DocBook/v4l/bayer.pdf
 create mode 100644 Documentation/DocBook/v4l/bayer.png
 create mode 100644 Documentation/DocBook/v4l/dev-subdev.xml
 create mode 100644 Documentation/DocBook/v4l/media-controller.xml
 create mode 100644 Documentation/DocBook/v4l/media-func-close.xml
 create mode 100644 Documentation/DocBook/v4l/media-func-ioctl.xml
 create mode 100644 Documentation/DocBook/v4l/media-func-open.xml
 create mode 100644 Documentation/DocBook/v4l/media-ioc-device-info.xml
 create mode 100644 Documentation/DocBook/v4l/media-ioc-enum-entities.xml
 create mode 100644 Documentation/DocBook/v4l/media-ioc-enum-links.xml
 create mode 100644 Documentation/DocBook/v4l/media-ioc-setup-link.xml
 create mode 100644 Documentation/DocBook/v4l/pipeline.pdf
 create mode 100644 Documentation/DocBook/v4l/pipeline.png
 create mode 100644 Documentation/DocBook/v4l/subdev-formats.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-enum-frame-interval.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-enum-frame-size.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-enum-mbus-code.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-g-crop.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-g-fmt.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-g-frame-interval.xml
 create mode 100644 Documentation/media-framework.txt
 create mode 100644 arch/arm/mach-omap2/devices.h
 create mode 100644 drivers/media/media-device.c
 create mode 100644 drivers/media/media-devnode.c
 create mode 100644 drivers/media/media-entity.c
 create mode 100644 drivers/media/video/omap3-isp/Makefile
 create mode 100644 drivers/media/video/omap3-isp/cfa_coef_table.h
 create mode 100644 drivers/media/video/omap3-isp/gamma_table.h
 create mode 100644 drivers/media/video/omap3-isp/isp.c
 create mode 100644 drivers/media/video/omap3-isp/isp.h
 create mode 100644 drivers/media/video/omap3-isp/ispccdc.c
 create mode 100644 drivers/media/video/omap3-isp/ispccdc.h
 create mode 100644 drivers/media/video/omap3-isp/ispccp2.c
 create mode 100644 drivers/media/video/omap3-isp/ispccp2.h
 create mode 100644 drivers/media/video/omap3-isp/ispcsi2.c
 create mode 100644 drivers/media/video/omap3-isp/ispcsi2.h
 create mode 100644 drivers/media/video/omap3-isp/ispcsiphy.c
 create mode 100644 drivers/media/video/omap3-isp/ispcsiphy.h
 create mode 100644 drivers/media/video/omap3-isp/isph3a.h
 create mode 100644 drivers/media/video/omap3-isp/isph3a_aewb.c
 create mode 100644 drivers/media/video/omap3-isp/isph3a_af.c
 create mode 100644 drivers/media/video/omap3-isp/isphist.c
 create mode 100644 drivers/media/video/omap3-isp/isphist.h
 create mode 100644 drivers/media/video/omap3-isp/isppreview.c
 create mode 100644 drivers/media/video/omap3-isp/isppreview.h
 create mode 100644 drivers/media/video/omap3-isp/ispqueue.c
 create mode 100644 drivers/media/video/omap3-isp/ispqueue.h
 create mode 100644 drivers/media/video/omap3-isp/ispreg.h
 create mode 100644 drivers/media/video/omap3-isp/ispresizer.c
 create mode 100644 drivers/media/video/omap3-isp/ispresizer.h
 create mode 100644 drivers/media/video/omap3-isp/ispstat.c
 create mode 100644 drivers/media/video/omap3-isp/ispstat.h
 create mode 100644 drivers/media/video/omap3-isp/ispvideo.c
 create mode 100644 drivers/media/video/omap3-isp/ispvideo.h
 create mode 100644 drivers/media/video/omap3-isp/luma_enhance_table.h
 create mode 100644 drivers/media/video/omap3-isp/noise_filter_table.h
 create mode 100644 drivers/media/video/v4l2-subdev.c
 create mode 100644 include/linux/media.h
 create mode 100644 include/linux/omap3isp.h
 create mode 100644 include/linux/v4l2-mediabus.h
 create mode 100644 include/linux/v4l2-subdev.h
 create mode 100644 include/media/media-device.h
 create mode 100644 include/media/media-devnode.h
 create mode 100644 include/media/media-entity.h

-- 
Regards,

Laurent Pinchart
