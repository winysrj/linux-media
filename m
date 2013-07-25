Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59952 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753Ab3GYM7X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 08:59:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Katsuya MATSUBARA <matsu@igel.co.jp>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH v3 0/5] Renesas VSP1 driver
Date: Thu, 25 Jul 2013 15:00:08 +0200
Message-Id: <1374757213-20194-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here's the third version of the VSP1 engine (a Video Signal Processor found
in several Renesas R-Car SoCs) driver. I'd like to thank all the v1 and v2
reviewers.

The VSP1 is a video processing engine that includes a blender, scalers,
filters and statistics computation. Configurable data path routing logic
allows ordering the internal blocks in a flexible way, making this driver a
prime candidate for the media controller API.

Due to the configurable nature of the pipeline the driver doesn't use the V4L2
mem-to-mem framework, even though the device usually operates in memory to
memory mode.

Only the read pixel formatters, up/down scalers, write pixel formatters and
LCDC interface are supported at this stage.

The patch series starts with a fix for the media controller graph traversal
code, a documentation fix and new pixel format and media bus code definitions.
The last patch finally adds the VSP1 driver.

Changes since v1:

- Updated to the v3.11 media controller API changes
- Only add the LIF entity to the entities list when the LIF is present
- Added a MODULE_ALIAS()
- Fixed file descriptions in comment blocks
- Removed function prototypes for the unimplemented destroy functions
- Fixed a typo in the HST register name
- Fixed format propagation for the UDS entities
- Added v4l2_capability::device_caps support
- Prefix the device name with "platform:" in bus_info
- Zero the v4l2_pix_format priv field in the internal try format handler
- Use vb2_is_busy() instead of vb2_is_streaming() when setting the
  format
- Use the vb2_ioctl_* handlers where possible

Changes since v2:

- Use a bitmap to track visited entities during graph traversal
- Fixed a typo in the V4L2_MBUS_FMT_ARGB888_1X32 documentation
- Fix register macros that were missing a n argument
- Mask unused bits when clearing the interrupt status register
- Explain why stride alignment to 128 bytes is needed
- Use the aligned stride value when computing the image size
- Assorted cosmetic changes

Laurent Pinchart (5):
  media: Add support for circular graph traversal
  v4l: Fix V4L2_MBUS_FMT_YUV10_1X30 media bus pixel code value
  v4l: Add media format codes for ARGB8888 and AYUV8888 on 32-bit busses
  v4l: Add V4L2_PIX_FMT_NV16M and V4L2_PIX_FMT_NV61M formats
  v4l: Renesas R-Car VSP1 driver

 Documentation/DocBook/media/v4l/pixfmt-nv16m.xml   |  170 +++
 Documentation/DocBook/media/v4l/pixfmt.xml         |    1 +
 Documentation/DocBook/media/v4l/subdev-formats.xml |  611 +++++------
 Documentation/DocBook/media_api.tmpl               |    6 +
 drivers/media/media-entity.c                       |   14 +-
 drivers/media/platform/Kconfig                     |   10 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/vsp1/Makefile               |    5 +
 drivers/media/platform/vsp1/vsp1.h                 |   73 ++
 drivers/media/platform/vsp1/vsp1_drv.c             |  488 +++++++++
 drivers/media/platform/vsp1/vsp1_entity.c          |  181 ++++
 drivers/media/platform/vsp1/vsp1_entity.h          |   68 ++
 drivers/media/platform/vsp1/vsp1_lif.c             |  238 ++++
 drivers/media/platform/vsp1/vsp1_lif.h             |   37 +
 drivers/media/platform/vsp1/vsp1_regs.h            |  581 ++++++++++
 drivers/media/platform/vsp1/vsp1_rpf.c             |  209 ++++
 drivers/media/platform/vsp1/vsp1_rwpf.c            |  124 +++
 drivers/media/platform/vsp1/vsp1_rwpf.h            |   53 +
 drivers/media/platform/vsp1/vsp1_uds.c             |  346 ++++++
 drivers/media/platform/vsp1/vsp1_uds.h             |   40 +
 drivers/media/platform/vsp1/vsp1_video.c           | 1135 ++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_video.h           |  144 +++
 drivers/media/platform/vsp1/vsp1_wpf.c             |  233 ++++
 include/linux/platform_data/vsp1.h                 |   25 +
 include/media/media-entity.h                       |    3 +
 include/uapi/linux/v4l2-mediabus.h                 |    6 +-
 include/uapi/linux/videodev2.h                     |    2 +
 27 files changed, 4434 insertions(+), 371 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-nv16m.xml
 create mode 100644 drivers/media/platform/vsp1/Makefile
 create mode 100644 drivers/media/platform/vsp1/vsp1.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_drv.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_entity.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_entity.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_lif.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_lif.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_regs.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_rpf.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_rwpf.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_rwpf.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_uds.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_uds.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_video.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_video.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_wpf.c
 create mode 100644 include/linux/platform_data/vsp1.h

-- 
Regards,

Laurent Pinchart

