Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44838 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbcCAO5V (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Mar 2016 09:57:21 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: [PATCH v3 0/8] media: Add entity types
Date: Tue,  1 Mar 2016 16:57:18 +0200
Message-Id: <1456844246-18778-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series adds a type field to the media entity structure.

Let's start with a few words about what types are and are not. The purpose of
the entity type is to identify the object type that implements the entity, in
order to safely cast the entity to that object (using container_of()). Three
types are currently defined, for media entities that are instantiated as such
(MEDIA_ENTITY_TYPE_MEDIA_ENTITY), embedded in a struct video_device
(MEDIA_ENTITY_TYPE_VIDEO_DEVICE) or embedded in a struct v4l2_subdev
(MEDIA_ENTITY_TYPE_V4L2_SUBDEV). The naming is pretty straightforward and
self-explicit.

Types do not convey any additional information. They don't tell anything about
the features of the entity or the object that implements it. In particular
they don't report capabilities of video_device instances, which is why the
is_media_entity_v4l2_io() function performs additional checks on the video
device capabilities field, after verifying with the type that it can safely be
cast to a video_device instance.

The series start by two cleanup patches (1/8 and 2/8) that fix incorrect or
unneeded usage of the is_media_entity_v4l2_*() functions in the vsp1 and
exynos4-is drivers. Patch 3/8 then adds the type field to the media_entity
structure and updates the is_media_entity_v4l2_*() functions implementations.
Patch 4/8 renames is_media_entity_v4l2_io() to
is_media_entity_v4l2_video_device() to clarify its purpose.

Patch 5/8 to 8/8 then implement a is_media_entity_v4l2_io() function that does
what its name suggest, check if the entity is a video device that can perform
I/O. To to so it starts by adding a new device_caps field to the video_device
structure (5/8), makes use of it in the v4l2-pci-skeleton (6/8) and vivid (7/8)
drivers, and finally adds the is_media_entity_v4l2_io() function.

Note that the is_media_entity_v4l2_io() function has no user at the moment, se
we could leave that patch out until drivers need it.

Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>

Hans Verkuil (5):
  media: Rename is_media_entity_v4l2_io to
    is_media_entity_v4l2_video_device
  v4l2: add device_caps to struct video_device
  v4l2-pci-skeleton.c: fill in device_caps in video_device
  vivid: set device_caps in video_device.
  media-entity.h: Add is_media_entity_v4l2_io()

Laurent Pinchart (3):
  v4l: vsp1: Check if an entity is a subdev with the right function
  v4l: exynos4-is: Drop unneeded check when setting up fimc-lite links
  media: Add type field to struct media_entity

 Documentation/video4linux/v4l2-pci-skeleton.c   |  5 +-
 drivers/media/platform/exynos4-is/fimc-lite.c   | 12 +---
 drivers/media/platform/exynos4-is/media-dev.c   |  4 +-
 drivers/media/platform/omap3isp/isp.c           |  2 +-
 drivers/media/platform/omap3isp/ispvideo.c      |  2 +-
 drivers/media/platform/vivid/vivid-core.c       | 22 +++----
 drivers/media/platform/vsp1/vsp1_video.c        |  2 +-
 drivers/media/v4l2-core/v4l2-common.c           | 21 +++++++
 drivers/media/v4l2-core/v4l2-dev.c              |  1 +
 drivers/media/v4l2-core/v4l2-ioctl.c            |  3 +
 drivers/media/v4l2-core/v4l2-subdev.c           |  1 +
 drivers/staging/media/davinci_vpfe/vpfe_video.c |  2 +-
 drivers/staging/media/omap4iss/iss.c            |  2 +-
 drivers/staging/media/omap4iss/iss_video.c      |  2 +-
 include/media/media-entity.h                    | 77 +++++++++++++------------
 include/media/v4l2-common.h                     | 12 ++++
 include/media/v4l2-dev.h                        |  3 +
 17 files changed, 99 insertions(+), 74 deletions(-)

-- 
Regards,

Laurent Pinchart

