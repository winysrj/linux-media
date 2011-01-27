Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59763 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab1A0M27 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jan 2011 07:28:59 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v6 0/7] V4L2 subdev userspace API
Date: Thu, 27 Jan 2011 13:28:51 +0100
Message-Id: <1296131338-29892-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi everybody,

Here's the sixth version of the V4L2 subdev userspace API patches. The patches
have been rebased on top of 2.6.37, and support for the control framework has
been integrated.

You can find them as usual in  http://git.linuxtv.org/pinchartl/media.git
(media-0001-subdev-devnode branch).

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
 drivers/media/video/cafe_ccic.c              |   11 +-
 drivers/media/video/davinci/vpfe_capture.c   |    2 +-
 drivers/media/video/davinci/vpif_capture.c   |    2 +-
 drivers/media/video/davinci/vpif_display.c   |    2 +-
 drivers/media/video/ivtv/ivtv-i2c.c          |   11 +-
 drivers/media/video/s5p-fimc/fimc-capture.c  |    2 +-
 drivers/media/video/sh_vou.c                 |    2 +-
 drivers/media/video/soc_camera.c             |    2 +-
 drivers/media/video/v4l2-common.c            |   22 ++-
 drivers/media/video/v4l2-dev.c               |   27 ++--
 drivers/media/video/v4l2-device.c            |   24 +++-
 drivers/media/video/v4l2-ioctl.c             |  216 +++++++++-----------------
 drivers/media/video/v4l2-subdev.c            |  180 +++++++++++++++++++++
 include/media/v4l2-common.h                  |   18 +--
 include/media/v4l2-dev.h                     |   18 ++-
 include/media/v4l2-ioctl.h                   |    3 +
 include/media/v4l2-subdev.h                  |   41 +++--
 20 files changed, 423 insertions(+), 216 deletions(-)
 create mode 100644 drivers/media/video/v4l2-subdev.c

-- 
Regards,

Laurent Pinchart

