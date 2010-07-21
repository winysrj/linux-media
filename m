Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:51330 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758397Ab0GUOfi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jul 2010 10:35:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v2 00/10] Media controller (core and V4L2)
Date: Wed, 21 Jul 2010 16:35:25 +0200
Message-Id: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here's the second version of the media controller patches. All comments
received on the first version have been incorporated.

The rebased V4L2 API additions and OMAP3 ISP patches will follow. Once again
please consider them as sample code only.

Laurent Pinchart (8):
  media: Media device node support
  media: Media device
  media: Entities, pads and links
  media: Entities, pads and links enumeration
  media: Links setup
  v4l: Add a media_device pointer to the v4l2_device structure
  v4l: Make video_device inherit from media_entity
  v4l: Make v4l2_subdev inherit from media_entity

Sakari Ailus (2):
  media: Entity graph traversal
  media: Reference count and power handling

 Documentation/media-framework.txt            |  481 ++++++++++++++++++++
 Documentation/video4linux/v4l2-framework.txt |   71 +++-
 drivers/media/Makefile                       |    8 +-
 drivers/media/media-device.c                 |  329 ++++++++++++++
 drivers/media/media-devnode.c                |  339 ++++++++++++++
 drivers/media/media-entity.c                 |  619 ++++++++++++++++++++++++++
 drivers/media/video/v4l2-dev.c               |   35 ++-
 drivers/media/video/v4l2-device.c            |   39 ++-
 drivers/media/video/v4l2-subdev.c            |   27 ++-
 include/linux/media.h                        |   74 +++
 include/media/media-device.h                 |   75 +++
 include/media/media-devnode.h                |   91 ++++
 include/media/media-entity.h                 |  101 +++++
 include/media/v4l2-dev.h                     |    6 +
 include/media/v4l2-device.h                  |    2 +
 include/media/v4l2-subdev.h                  |    7 +
 16 files changed, 2284 insertions(+), 20 deletions(-)
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

