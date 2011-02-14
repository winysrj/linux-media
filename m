Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58150 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab1BNMU5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:20:57 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v7 0/6] V4L2 subdev userspace API
Date: Mon, 14 Feb 2011 13:20:53 +0100
Message-Id: <1297686059-9622-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi everybody,

Here's the seventh version of the V4L2 subdev userspace API patches. The
patches have been rebased on top of 2.6.38-rc4.

You can find them as usual in  http://git.linuxtv.org/pinchartl/media.git
(media-0001-subdev-devnode branch).

Laurent Pinchart (5):
  v4l: Share code between video_usercopy and video_ioctl2
  v4l: subdev: Don't require core operations
  v4l: subdev: Add device node support
  v4l: subdev: Uninline the v4l2_subdev_init function
  v4l: subdev: Control ioctls support

Sakari Ailus (1):
  v4l: subdev: Events support

 Documentation/video4linux/v4l2-framework.txt |   50 ++++++
 drivers/media/video/Makefile                 |    2 +-
 drivers/media/video/v4l2-dev.c               |   27 ++--
 drivers/media/video/v4l2-device.c            |   37 +++++
 drivers/media/video/v4l2-ioctl.c             |  216 +++++++++-----------------
 drivers/media/video/v4l2-subdev.c            |  176 +++++++++++++++++++++
 include/media/v4l2-dev.h                     |   18 ++-
 include/media/v4l2-device.h                  |    6 +
 include/media/v4l2-ioctl.h                   |    3 +
 include/media/v4l2-subdev.h                  |   40 +++--
 10 files changed, 393 insertions(+), 182 deletions(-)
 create mode 100644 drivers/media/video/v4l2-subdev.c

-- 
Regards,

Laurent Pinchart

