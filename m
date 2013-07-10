Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39965 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab3GJKTM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jul 2013 06:19:12 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 0/5] Renesas VSP1 driver
Date: Wed, 10 Jul 2013 12:19:27 +0200
Message-Id: <1373451572-3892-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here's a driver for the VSP1 (Video Signal Processor) engine found in several
Renesas R-Car SoCs.

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

Laurent Pinchart (5):
  media: Fix circular graph traversal
  v4l: Fix V4L2_MBUS_FMT_YUV10_1X30 media bus pixel code value
  v4l: Add media format codes for ARGB8888 and AYUV8888 on 32-bit busses
  v4l: Add V4L2_PIX_FMT_NV16M and V4L2_PIX_FMT_NV61M formats
  v4l: Renesas R-Car VSP1 driver

 Documentation/DocBook/media/v4l/pixfmt-nv16m.xml   |  170 +++
 Documentation/DocBook/media/v4l/pixfmt.xml         |    1 +
 Documentation/DocBook/media/v4l/subdev-formats.xml |  611 +++++------
 Documentation/DocBook/media_api.tmpl               |    6 +
 drivers/media/media-entity.c                       |   17 +-
 drivers/media/platform/Kconfig                     |   10 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/vsp1/Makefile               |    5 +
 drivers/media/platform/vsp1/vsp1.h                 |   73 ++
 drivers/media/platform/vsp1/vsp1_drv.c             |  475 ++++++++
 drivers/media/platform/vsp1/vsp1_entity.c          |  186 ++++
 drivers/media/platform/vsp1/vsp1_entity.h          |   68 ++
 drivers/media/platform/vsp1/vsp1_lif.c             |  237 ++++
 drivers/media/platform/vsp1/vsp1_lif.h             |   38 +
 drivers/media/platform/vsp1/vsp1_regs.h            |  581 ++++++++++
 drivers/media/platform/vsp1/vsp1_rpf.c             |  209 ++++
 drivers/media/platform/vsp1/vsp1_rwpf.c            |  124 +++
 drivers/media/platform/vsp1/vsp1_rwpf.h            |   56 +
 drivers/media/platform/vsp1/vsp1_uds.c             |  346 ++++++
 drivers/media/platform/vsp1/vsp1_uds.h             |   41 +
 drivers/media/platform/vsp1/vsp1_video.c           | 1154 ++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_video.h           |  144 +++
 drivers/media/platform/vsp1/vsp1_wpf.c             |  233 ++++
 include/linux/platform_data/vsp1.h                 |   25 +
 include/uapi/linux/v4l2-mediabus.h                 |    6 +-
 include/uapi/linux/videodev2.h                     |    2 +
 26 files changed, 4447 insertions(+), 373 deletions(-)
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

