Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:32211 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbbBZQAt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2015 11:00:49 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKD00A6NZ5B5I40@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Feb 2015 01:00:47 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
	gjasny@googlemail.com, hdegoede@redhat.com,
	kyungmin.park@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [v4l-utils PATCH/RFC v5 10/14] mediactl: libv4l2subdev: add support
 for setting pipeline format
Date: Thu, 26 Feb 2015 16:59:20 +0100
Message-id: <1424966364-3647-11-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1424966364-3647-1-git-send-email-j.anaszewski@samsung.com>
References: <1424966364-3647-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a function for setting the media device pipeline format.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 utils/media-ctl/libv4l2subdev.c |   61 +++++++++++++++++++++++++++++++++++++++
 utils/media-ctl/v4l2subdev.h    |   15 ++++++++++
 2 files changed, 76 insertions(+)

diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index b9a924c..cc3df1e 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -164,6 +164,67 @@ int v4l2_subdev_set_format(struct media_entity *entity,
 	return 0;
 }
 
+int v4l2_subdev_apply_pipeline_fmt(struct media_device *media,
+				   struct v4l2_format *fmt)
+{
+	struct v4l2_mbus_framefmt mbus_fmt = { 0 };
+	struct media_entity *entity = media->pipeline;
+	struct media_pad *pad;
+	int ret;
+
+	while (entity) {
+		/*
+		 * Source entity is linked only through a source pad
+		 * and this pad should be used for setting the format.
+		 * For other entities set the format on a sink pad.
+		 */
+		pad = entity->pipe_sink_pad ? entity->pipe_sink_pad :
+					      entity->pipe_src_pad;
+		if (pad == NULL)
+			return -EINVAL;
+
+		ret = v4l2_subdev_get_format(entity, &mbus_fmt, pad->index,
+					     V4L2_SUBDEV_FORMAT_TRY);
+
+		if (ret < 0)
+			return ret;
+
+		media_dbg(media, "VIDIOC_SUBDEV_G_FMT %s:%d: mbus_code: %s, width: %d, height: %d\n",
+			  media_entity_get_name(entity), pad->index,
+			  v4l2_subdev_pixelcode_to_string(mbus_fmt.code),
+			  mbus_fmt.width, mbus_fmt.height);
+
+		ret = v4l2_subdev_set_format(entity, &mbus_fmt, pad->index,
+					     V4L2_SUBDEV_FORMAT_ACTIVE);
+		if (ret < 0)
+			return ret;
+
+		media_dbg(media, "VIDIOC_SUBDEV_S_FMT %s:%d: mbus_code: %s, width: %d, height: %d\n",
+			  media_entity_get_name(entity), pad->index,
+			  v4l2_subdev_pixelcode_to_string(mbus_fmt.code),
+			  mbus_fmt.width, mbus_fmt.height);
+
+		entity = entity->next;
+
+		/* Last entity in the pipeline is not a sub-device */
+		if (entity->next == NULL)
+			break;
+	}
+
+	/*
+	 * Sink entity represents a video device node and is not
+	 * a sub-device. Nonetheless because it has associated
+	 * file descriptor and can expose v4l2-controls the
+	 * v4l2-subdev structure is used for caching the
+	 * related data.
+	 */
+	ret = ioctl(entity->sd->fd, VIDIOC_S_FMT, fmt);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
 int v4l2_subdev_get_selection(struct media_entity *entity,
 	struct v4l2_rect *rect, unsigned int pad, unsigned int target,
 	enum v4l2_subdev_format_whence which)
diff --git a/utils/media-ctl/v4l2subdev.h b/utils/media-ctl/v4l2subdev.h
index 2f74975..2b48fb5 100644
--- a/utils/media-ctl/v4l2subdev.h
+++ b/utils/media-ctl/v4l2subdev.h
@@ -131,6 +131,21 @@ int v4l2_subdev_set_format(struct media_entity *entity,
 	enum v4l2_subdev_format_whence which);
 
 /**
+ * @brief Set media device pipeline format
+ * @param media - media device.
+ * @param fmt - negotiated format.
+ *
+ * Set the active format on all the media device pipeline entities.
+ * The format has to be at first negotiated with VIDIOC_SUBDEV_S_FMT
+ * by struct v4l2_subdev_format's 'whence' property set to
+ * V4L2_SUBDEV_FORMAT_TRY.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int v4l2_subdev_apply_pipeline_fmt(struct media_device *media,
+				   struct v4l2_format *fmt);
+
+/**
  * @brief Retrieve a selection rectangle on a pad.
  * @param entity - subdev-device media entity.
  * @param r - rectangle to be filled.
-- 
1.7.9.5

