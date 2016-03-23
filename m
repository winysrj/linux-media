Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38559 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbcCWIqF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2016 04:46:05 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 0/2] media: Add entity types
Date: Wed, 23 Mar 2016 10:45:54 +0200
Message-Id: <1458722756-7269-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series adds an obj_type field to the media entity structure. It is
a resend of v4 rebased on top of the latest media master branch, with the type
field renamed to obj_type and the documentation clarified. I have dropped
patches 1 and 2 as they have been merged already.

As a reminder, a few words about what types are and are not. The purpose of
the entity type is to identify the object type that implements the entity, in
order to safely cast the entity to that object (using container_of()). Two
types are currently defined, for media entities that are embedded in a struct
video_device (MEDIA_ENTITY_TYPE_VIDEO_DEVICE) or embedded in a struct
v4l2_subdev (MEDIA_ENTITY_TYPE_V4L2_SUBDEV). A third type is defined to catch
uninitialized fields (MEDIA_ENTITY_TYPE_INVALID) but should not be used
directly.

Types do not convey any additional information. They don't tell anything about
the features of the entity or the object that implements it. In particular
they don't report capabilities of video_device instances, which is why the
is_media_entity_v4l2_io() function performs additional checks on the video
device capabilities field, after verifying with the type that it can safely be
cast to a video_device instance.

Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>

Laurent Pinchart (2):
  media: Add obj_type field to struct media_entity
  media: Rename is_media_entity_v4l2_io to
    is_media_entity_v4l2_video_device

 drivers/media/media-device.c                    |  2 +
 drivers/media/platform/exynos4-is/media-dev.c   |  4 +-
 drivers/media/platform/omap3isp/ispvideo.c      |  2 +-
 drivers/media/v4l2-core/v4l2-dev.c              |  1 +
 drivers/media/v4l2-core/v4l2-mc.c               |  2 +-
 drivers/media/v4l2-core/v4l2-subdev.c           |  1 +
 drivers/staging/media/davinci_vpfe/vpfe_video.c |  2 +-
 drivers/staging/media/omap4iss/iss_video.c      |  2 +-
 include/media/media-entity.h                    | 81 +++++++++++++------------
 9 files changed, 53 insertions(+), 44 deletions(-)

-- 
Regards,

Laurent Pinchart

