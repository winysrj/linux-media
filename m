Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:50312 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab0GGLxl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jul 2010 07:53:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH 0/6] V4L2 subdev userspace API
Date: Wed,  7 Jul 2010 13:53:22 +0200
Message-Id: <1278503608-9126-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here are 6 patches that add a userspace API to the V4L2 subdevices. The API has
been developed to support the media controller and the OMAP3 ISP driver.

A few people have shown interest in the subdev userspace API already. As the
patches are not dependent on the media controller itself I'm submitting them
independently for review.

The API covers controls, events and generic ioctls. The controls and events
support reuse V4L2 ioctls, as explained in
Documentation/video4linux/v4l2-framework.txt. The subdev (and later media
controller) userspace API should probably be converted to DocBook format
eventually. The subdev API can be included in the V4L2 API document, but the
media controller should be kept separate. Comments on this will be appreciated.

While waiting for review I'll prepare the media controller core patches and
send them to the list.

Laurent Pinchart (5):
  v4l: subdev: Don't require core operations
  v4l: subdev: Add device node support
  v4l: subdev: Uninline the v4l2_subdev_init function
  v4l: subdev: Control ioctls support
  v4l: subdev: Generic ioctl support

Sakari Ailus (1):
  v4l: subdev: Events support

 Documentation/video4linux/v4l2-framework.txt |   47 +++++++
 drivers/media/video/Makefile                 |    2 +-
 drivers/media/video/v4l2-common.c            |    3 +
 drivers/media/video/v4l2-dev.c               |    5 +
 drivers/media/video/v4l2-device.c            |   27 ++++-
 drivers/media/video/v4l2-subdev.c            |  172 ++++++++++++++++++++++++++
 include/media/v4l2-dev.h                     |    3 +-
 include/media/v4l2-subdev.h                  |   33 +++--
 8 files changed, 276 insertions(+), 16 deletions(-)
 create mode 100644 drivers/media/video/v4l2-subdev.c

-- 
Regards,

Laurent Pinchart

