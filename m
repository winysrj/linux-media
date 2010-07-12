Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:42362 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab0GLP0D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jul 2010 11:26:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v3 0/7] V4L2 subdev userspace API
Date: Mon, 12 Jul 2010 17:25:45 +0200
Message-Id: <1278948352-17892-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here's the third version of the V4L2 subdev userspace API patches. Comments
received on the first and second versions have been incorporated, including the
video_usercopy usage. The generic ioctls support patch has been dropped and
will be resubmitted later with a use case.

Laurent Pinchart (6):
  v4l: Share code between video_usercopy and video_ioctl2
  v4l: subdev: Don't require core operations
  v4l: subdev: Merge v4l2_i2c_new_subdev_cfg and v4l2_i2c_new_subdev
  v4l: subdev: Add device node support
  v4l: subdev: Uninline the v4l2_subdev_init function
  v4l: subdev: Control ioctls support

Sakari Ailus (1):
  v4l: subdev: Events support

 Documentation/video4linux/v4l2-framework.txt |   52 ++++++
 drivers/media/radio/radio-si4713.c           |    2 +-
 drivers/media/video/Makefile                 |    2 +-
 drivers/media/video/soc_camera.c             |    2 +-
 drivers/media/video/v4l2-common.c            |   22 ++-
 drivers/media/video/v4l2-dev.c               |   27 ++--
 drivers/media/video/v4l2-device.c            |   25 +++-
 drivers/media/video/v4l2-ioctl.c             |  216 +++++++++-----------------
 drivers/media/video/v4l2-subdev.c            |  176 +++++++++++++++++++++
 include/media/v4l2-common.h                  |   21 +--
 include/media/v4l2-dev.h                     |   18 ++-
 include/media/v4l2-ioctl.h                   |    3 +
 include/media/v4l2-subdev.h                  |   40 +++--
 13 files changed, 398 insertions(+), 208 deletions(-)
 create mode 100644 drivers/media/video/v4l2-subdev.c

-- 
Regards,

Laurent Pinchart

