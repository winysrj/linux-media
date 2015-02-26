Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:54796 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485AbbBZQBH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2015 11:01:07 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKD000GTZ5UM400@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Feb 2015 01:01:06 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
	gjasny@googlemail.com, hdegoede@redhat.com,
	kyungmin.park@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [v4l-utils PATCH/RFC v5 13/14] mediactl: libv4l2subdev: Enable
 opening/closing pipelines
Date: Thu, 26 Feb 2015 16:59:23 +0100
Message-id: <1424966364-3647-14-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1424966364-3647-1-git-send-email-j.anaszewski@samsung.com>
References: <1424966364-3647-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add functions for opening and closing media entity pipelines
at one go.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 utils/media-ctl/libv4l2subdev.c |   60 +++++++++++++++++++++++++++++++++++++++
 utils/media-ctl/v4l2subdev.h    |   18 ++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index 379fe64..4475ef7 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -117,6 +117,66 @@ void v4l2_subdev_close(struct media_entity *entity)
 	entity->sd->fd = -1;
 }
 
+int v4l2_subdev_open_pipeline(struct media_device *media)
+{
+	struct media_entity *entity = media->pipeline;
+	int ret;
+
+	if (entity == NULL)
+		return 0;
+
+	/*
+	 * Stop walking the pipeline on the last last but one entity, because
+	 * the sink entity sub-device was opened by libv4l2 core and its
+	 * file descriptor needs to be preserved.
+	 */
+	while (entity->next) {
+		media_dbg(media, "Opening sub-device: %s\n", entity->devname);
+		ret = v4l2_subdev_open(entity);
+		if (ret < 0)
+			return ret;
+
+		if (entity->sd->fd < 0)
+			goto err_open_subdev;
+
+		entity = entity->next;
+	}
+
+	return 0;
+
+err_open_subdev:
+	v4l2_subdev_release_pipeline(media);
+
+	return -EINVAL;
+}
+
+void v4l2_subdev_release_pipeline(struct media_device *media)
+{
+	struct media_entity *entity = media->pipeline;
+
+	if (entity == NULL)
+		return;
+	/*
+	 * Stop walking the pipeline on the last last but one entity, because
+	 * the sink entity sub-device should be released by the client that
+	 * instantiated it.
+	 */
+	while (entity->next) {
+		if (!entity->sd) {
+			entity = entity->next;
+			continue;
+		}
+
+		if (entity->sd->fd >= 0) {
+			media_dbg(media, "Releasing sub-device: %s\n", entity->devname);
+			v4l2_subdev_release(entity, true);
+		}
+
+		entity = entity->next;
+	}
+}
+
+
 int v4l2_subdev_get_format(struct media_entity *entity,
 	struct v4l2_mbus_framefmt *format, unsigned int pad,
 	enum v4l2_subdev_format_whence which)
diff --git a/utils/media-ctl/v4l2subdev.h b/utils/media-ctl/v4l2subdev.h
index 0f1deca..2fdcb76 100644
--- a/utils/media-ctl/v4l2subdev.h
+++ b/utils/media-ctl/v4l2subdev.h
@@ -90,6 +90,24 @@ int v4l2_subdev_open(struct media_entity *entity);
 void v4l2_subdev_close(struct media_entity *entity);
 
 /**
+ * @brief Open media device pipeline
+ * @param media - media device.
+ *
+ * Open all sub-devices in the media device pipeline.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int v4l2_subdev_open_pipeline(struct media_device *media);
+
+/**
+ * @brief Release media device pipeline sub-devices
+ * @param media - media device.
+ *
+ * Release all sub-devices in the media device pipeline.
+ */
+void v4l2_subdev_release_pipeline(struct media_device *media);
+
+/**
  * @brief Retrieve the format on a pad.
  * @param entity - subdev-device media entity.
  * @param format - format to be filled.
-- 
1.7.9.5

