Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:46324 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123AbcARQTG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 11:19:06 -0500
Received: from epcpsbgm1new.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0O1500V0HPBTN320@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Jan 2016 01:19:05 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
	gjasny@googlemail.com, hdegoede@redhat.com, hverkuil@xs4all.nl,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 14/15] mediactl: libv4l2subdev: Enable opening/closing pipelines
Date: Mon, 18 Jan 2016 17:17:39 +0100
Message-id: <1453133860-21571-15-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1453133860-21571-1-git-send-email-j.anaszewski@samsung.com>
References: <1453133860-21571-1-git-send-email-j.anaszewski@samsung.com>
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
index 14e9423..6e626fe 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -118,6 +118,66 @@ void v4l2_subdev_close(struct media_entity *entity)
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
index 607ec50..94f6bf1 100644
--- a/utils/media-ctl/v4l2subdev.h
+++ b/utils/media-ctl/v4l2subdev.h
@@ -100,6 +100,24 @@ int v4l2_subdev_open(struct media_entity *entity);
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

