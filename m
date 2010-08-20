Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:40624 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab0HTP3O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Aug 2010 11:29:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v4 00/11] Media controller (core and V4L2)
Date: Fri, 20 Aug 2010 17:29:02 +0200
Message-Id: <1282318153-18885-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi everybody,

Here's the fourth version of the media controller patches. All comments received
so far have hopefully been incorporated.

Compared to the previous version, the patches have been rebased on top of 2.6.35
and a MEDIA_IOC_DEVICE_INFO ioctl has been added.

I won't submit a rebased version of the V4L2 API additions and OMAP3 ISP patches
right now. I will first clean up (and document) the V4L2 API additions patches,
and I will submit them as a proper RFC instead of sample code.

Laurent Pinchart (9):
  media: Media device node support
  media: Media device
  media: Entities, pads and links
  media: Media device information query
  media: Entities, pads and links enumeration
  media: Links setup
  v4l: Add a media_device pointer to the v4l2_device structure
  v4l: Make video_device inherit from media_entity
  v4l: Make v4l2_subdev inherit from media_entity

Sakari Ailus (2):
  media: Entity graph traversal
  media: Reference count and power handling

 Documentation/media-framework.txt            |  574 ++++++++++++++++++++++++
 Documentation/video4linux/v4l2-framework.txt |   72 +++-
 drivers/media/Makefile                       |    8 +-
 drivers/media/media-device.c                 |  377 ++++++++++++++++
 drivers/media/media-devnode.c                |  310 +++++++++++++
 drivers/media/media-entity.c                 |  614 ++++++++++++++++++++++++++
 drivers/media/video/v4l2-dev.c               |   35 ++-
 drivers/media/video/v4l2-device.c            |   45 ++-
 drivers/media/video/v4l2-subdev.c            |   27 ++-
 include/linux/media.h                        |  105 +++++
 include/media/media-device.h                 |   90 ++++
 include/media/media-devnode.h                |   78 ++++
 include/media/media-entity.h                 |  112 +++++
 include/media/v4l2-dev.h                     |    6 +
 include/media/v4l2-device.h                  |    2 +
 include/media/v4l2-subdev.h                  |    7 +
 16 files changed, 2440 insertions(+), 22 deletions(-)
 create mode 100644 Documentation/media-framework.txt
 create mode 100644 drivers/media/media-device.c
 create mode 100644 drivers/media/media-devnode.c
 create mode 100644 drivers/media/media-entity.c
 create mode 100644 include/linux/media.h
 create mode 100644 include/media/media-device.h
 create mode 100644 include/media/media-devnode.h
 create mode 100644 include/media/media-entity.h

-- 
Regards,

Laurent Pinchart

