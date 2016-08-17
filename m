Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44800 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbcHQMUV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2016 08:20:21 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH v2 0/4] R-Car VSP1 1-D Histogram support
Date: Wed, 17 Aug 2016 15:20:26 +0300
Message-Id: <1471436430-26245-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series implements support for the Renesas R-Car VSP1 1-D histogram
generator (HGO). It is based on top of the latest media tree's master branch,
and available for convenience at

        git://linuxtv.org/pinchartl/media.git vsp1/hgo

The series starts with the implementation and documentation of the new V4L2
metadata API (1/4), followed by a new pixel format for the R-Car VSP1 1-D
histogram (2/4). The last two patches (3/4 and 4/4) implement support for the
API in the vsp1 driver.

Laurent Pinchart (4):
  v4l: Add metadata buffer type and format
  v4l: Define a pixel format for the R-Car VSP1 1-D histogram engine
  v4l: vsp1: Add HGO support
  v4l: vsp1: Don't create HGO entity when the userspace API is disabled

 Documentation/media/uapi/v4l/buffer.rst            |   8 +
 Documentation/media/uapi/v4l/dev-meta.rst          |  69 +++
 Documentation/media/uapi/v4l/devices.rst           |   1 +
 Documentation/media/uapi/v4l/meta-formats.rst      |  15 +
 .../media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst        | 170 +++++++
 Documentation/media/uapi/v4l/pixfmt.rst            |   1 +
 Documentation/media/uapi/v4l/vidioc-querycap.rst   |  14 +-
 Documentation/media/videodev2.h.rst.exceptions     |   2 +
 drivers/media/platform/Kconfig                     |   1 +
 drivers/media/platform/vsp1/Makefile               |   1 +
 drivers/media/platform/vsp1/vsp1.h                 |   3 +
 drivers/media/platform/vsp1/vsp1_drm.c             |   2 +-
 drivers/media/platform/vsp1/vsp1_drv.c             |  44 +-
 drivers/media/platform/vsp1/vsp1_entity.c          | 136 +++++-
 drivers/media/platform/vsp1/vsp1_entity.h          |   7 +-
 drivers/media/platform/vsp1/vsp1_hgo.c             | 501 +++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_hgo.h             |  50 ++
 drivers/media/platform/vsp1/vsp1_histo.c           | 324 +++++++++++++
 drivers/media/platform/vsp1/vsp1_histo.h           |  69 +++
 drivers/media/platform/vsp1/vsp1_pipe.c            |  22 +-
 drivers/media/platform/vsp1/vsp1_pipe.h            |   2 +
 drivers/media/platform/vsp1/vsp1_regs.h            |  24 +-
 drivers/media/platform/vsp1/vsp1_video.c           |  22 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |  19 +
 drivers/media/v4l2-core/v4l2-dev.c                 |  16 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |  42 ++
 drivers/media/v4l2-core/videobuf2-v4l2.c           |   3 +
 include/media/v4l2-ioctl.h                         |  17 +
 include/uapi/linux/videodev2.h                     |  17 +
 29 files changed, 1552 insertions(+), 50 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/dev-meta.rst
 create mode 100644 Documentation/media/uapi/v4l/meta-formats.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgo.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgo.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_histo.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_histo.h

-- 
Regards,

Laurent Pinchart

