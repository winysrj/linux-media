Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41753 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaFBPJo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jun 2014 11:09:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/3] media-ctl: libv4l2subdev: Add DV timings support
Date: Mon,  2 Jun 2014 17:10:02 +0200
Message-Id: <1401721804-30133-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1401721804-30133-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1401721804-30133-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Expose the pad-level get caps, query, get and set DV timings ioctls.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 utils/media-ctl/libv4l2subdev.c | 72 +++++++++++++++++++++++++++++++++++++++++
 utils/media-ctl/v4l2subdev.h    | 53 ++++++++++++++++++++++++++++++
 2 files changed, 125 insertions(+)

diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index 14daffa..8015330 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -189,6 +189,78 @@ int v4l2_subdev_set_selection(struct media_entity *entity,
 	return 0;
 }
 
+int v4l2_subdev_get_dv_timings_caps(struct media_entity *entity,
+	struct v4l2_dv_timings_cap *caps)
+{
+	unsigned int pad = caps->pad;
+	int ret;
+
+	ret = v4l2_subdev_open(entity);
+	if (ret < 0)
+		return ret;
+
+	memset(caps, 0, sizeof(*caps));
+	caps->pad = pad;
+
+	ret = ioctl(entity->fd, VIDIOC_SUBDEV_DV_TIMINGS_CAP, caps);
+	if (ret < 0)
+		return -errno;
+
+	return 0;
+}
+
+int v4l2_subdev_query_dv_timings(struct media_entity *entity,
+	struct v4l2_dv_timings *timings)
+{
+	int ret;
+
+	ret = v4l2_subdev_open(entity);
+	if (ret < 0)
+		return ret;
+
+	memset(timings, 0, sizeof(*timings));
+
+	ret = ioctl(entity->fd, VIDIOC_SUBDEV_QUERY_DV_TIMINGS, timings);
+	if (ret < 0)
+		return -errno;
+
+	return 0;
+}
+
+int v4l2_subdev_get_dv_timings(struct media_entity *entity,
+	struct v4l2_dv_timings *timings)
+{
+	int ret;
+
+	ret = v4l2_subdev_open(entity);
+	if (ret < 0)
+		return ret;
+
+	memset(timings, 0, sizeof(*timings));
+
+	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_DV_TIMINGS, timings);
+	if (ret < 0)
+		return -errno;
+
+	return 0;
+}
+
+int v4l2_subdev_set_dv_timings(struct media_entity *entity,
+	struct v4l2_dv_timings *timings)
+{
+	int ret;
+
+	ret = v4l2_subdev_open(entity);
+	if (ret < 0)
+		return ret;
+
+	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_DV_TIMINGS, timings);
+	if (ret < 0)
+		return -errno;
+
+	return 0;
+}
+
 int v4l2_subdev_get_frame_interval(struct media_entity *entity,
 				   struct v4l2_fract *interval)
 {
diff --git a/utils/media-ctl/v4l2subdev.h b/utils/media-ctl/v4l2subdev.h
index c2ca1e5..1cb53ff 100644
--- a/utils/media-ctl/v4l2subdev.h
+++ b/utils/media-ctl/v4l2subdev.h
@@ -132,6 +132,59 @@ int v4l2_subdev_set_selection(struct media_entity *entity,
 	enum v4l2_subdev_format_whence which);
 
 /**
+ * @brief Query the digital video capabilities of a pad.
+ * @param entity - subdev-device media entity.
+ * @param cap - capabilities to be filled.
+ *
+ * Retrieve the digital video capabilities of the @a entity pad specified by
+ * @a cap.pad and store it in the @a cap structure.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int v4l2_subdev_get_dv_timings_caps(struct media_entity *entity,
+	struct v4l2_dv_timings_cap *caps);
+
+/**
+ * @brief Query the digital video timings of a sub-device
+ * @param entity - subdev-device media entity.
+ * @param timings timings to be filled.
+ *
+ * Retrieve the detected digital video timings for the currently selected input
+ * of @a entity and store them in the @a timings structure.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int v4l2_subdev_query_dv_timings(struct media_entity *entity,
+	struct v4l2_dv_timings *timings);
+
+/**
+ * @brief Get the current digital video timings of a sub-device
+ * @param entity - subdev-device media entity.
+ * @param timings timings to be filled.
+ *
+ * Retrieve the current digital video timings for the currently selected input
+ * of @a entity and store them in the @a timings structure.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int v4l2_subdev_get_dv_timings(struct media_entity *entity,
+	struct v4l2_dv_timings *timings);
+
+/**
+ * @brief Set the digital video timings of a sub-device
+ * @param entity - subdev-device media entity.
+ * @param timings timings to be set.
+ *
+ * Set the digital video timings of @a entity to @a timings. The driver is
+ * allowed to modify the requested format, in which case @a timings is updated
+ * with the modifications.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int v4l2_subdev_set_dv_timings(struct media_entity *entity,
+	struct v4l2_dv_timings *timings);
+
+/**
  * @brief Retrieve the frame interval on a sub-device.
  * @param entity - subdev-device media entity.
  * @param interval - frame interval to be filled.
-- 
1.8.5.5

