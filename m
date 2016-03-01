Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44848 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbcCAO50 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Mar 2016 09:57:26 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 8/8] media-entity.h: Add is_media_entity_v4l2_io()
Date: Tue,  1 Mar 2016 16:57:26 +0200
Message-Id: <1456844246-18778-9-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1456844246-18778-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1456844246-18778-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a is_media_entity_v4l2_io to v4l2-common.h (since this is V4L2
specific) that checks if the entity is a video_device AND if it does
I/O.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/v4l2-core/v4l2-common.c | 21 +++++++++++++++++++++
 include/media/v4l2-common.h           | 12 ++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index 5b808500e7e7..3c57d51d3e90 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -405,3 +405,24 @@ void v4l2_get_timestamp(struct timeval *tv)
 	tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
 }
 EXPORT_SYMBOL_GPL(v4l2_get_timestamp);
+
+#if defined(CONFIG_MEDIA_CONTROLLER)
+bool is_media_entity_v4l2_io(struct media_entity *entity)
+{
+	struct video_device *vdev;
+
+	if (!is_media_entity_v4l2_video_device(entity))
+		return false;
+	vdev = container_of(entity, struct video_device, entity);
+	/*
+	 * For now assume that is device_caps == 0, then I/O is available
+	 * unless it is a radio device.
+	 * Eventually all drivers should set vdev->device_caps and then
+	 * this assumption should be removed.
+	 */
+	if (vdev->device_caps == 0)
+		return vdev->vfl_type != VFL_TYPE_RADIO;
+	return vdev->device_caps & (V4L2_CAP_READWRITE | V4L2_CAP_STREAMING);
+}
+EXPORT_SYMBOL_GPL(is_media_entity_v4l2_io);
+#endif
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 1cc0c5ba16b3..6dae30493276 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -189,4 +189,16 @@ const struct v4l2_frmsize_discrete *v4l2_find_nearest_format(
 
 void v4l2_get_timestamp(struct timeval *tv);
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+/**
+ * is_media_entity_v4l2_io() - Check if the entity is an I/O video_device
+ * @entity:	pointer to entity
+ *
+ * Return: true if the entity is an instance of a video_device object (and can
+ * safely be cast to a struct video_device using the container_of() macro) and
+ * can do I/O, or false otherwise.
+ */
+bool is_media_entity_v4l2_io(struct media_entity *entity);
+#endif
+
 #endif /* V4L2_COMMON_H_ */
-- 
2.4.10

