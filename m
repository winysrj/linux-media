Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:41472 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123AbcARQSx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 11:18:53 -0500
Received: from epcpsbgm2new.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0O1501N1RPAIDD20@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Jan 2016 01:18:52 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
	gjasny@googlemail.com, hdegoede@redhat.com, hverkuil@xs4all.nl,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 10/15] mediactl: libv4l2subdev: add support for comparing mbus
 formats
Date: Mon, 18 Jan 2016 17:17:35 +0100
Message-id: <1453133860-21571-11-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1453133860-21571-1-git-send-email-j.anaszewski@samsung.com>
References: <1453133860-21571-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a function for checking whether two mbus formats
are compatible.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 utils/media-ctl/libv4l2subdev.c |   39 +++++++++++++++++++++++++++++++++++++++
 utils/media-ctl/v4l2subdev.h    |   22 ++++++++++++++++++++++
 2 files changed, 61 insertions(+)

diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index b3d11ef..3282fe9 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -934,6 +934,45 @@ int v4l2_subdev_validate_v4l2_ctrl(struct media_device *media,
 	return 0;
 }
 
+enum v4l2_subdev_fmt_mismatch v4l2_subdev_format_compare(
+				struct v4l2_mbus_framefmt *fmt1,
+				struct v4l2_mbus_framefmt *fmt2)
+{
+	if (fmt1 == NULL || fmt2 == NULL)
+		return 0;
+
+	if (fmt1->width != fmt2->width) {
+		printf("width mismatch (%d %d)\n", fmt1->width, fmt2->width);
+		return FMT_MISMATCH_WIDTH;
+	}
+
+	if (fmt1->height != fmt2->height) {
+		printf("height mismatch (%d %d)\n", fmt1->height, fmt2->height);
+		return FMT_MISMATCH_HEIGHT;
+	}
+
+	if (fmt1->code != fmt2->code) {
+		printf("mbus code mismatch (%s %s)\n",
+			v4l2_subdev_pixelcode_to_string(fmt1->code),
+			v4l2_subdev_pixelcode_to_string(fmt2->code));
+		return FMT_MISMATCH_CODE;
+	}
+
+	if (fmt1->field != fmt2->field) {
+		printf("field mismatch (%d %d)\n", fmt1->field, fmt2->field);
+		return FMT_MISMATCH_FIELD;
+	}
+
+	if (fmt1->colorspace != fmt2->colorspace) {
+		printf("colorspace mismatch (%s %s)\n",
+			v4l2_subdev_colorspace_to_string(fmt1->colorspace),
+			v4l2_subdev_colorspace_to_string(fmt2->colorspace));
+		return FMT_MISMATCH_COLORSPACE;
+	}
+
+	return FMT_MISMATCH_NONE;
+}
+
 bool v4l2_subdev_has_v4l2_control_redir(struct media_device *media,
 				  struct media_entity *entity,
 				  int ctrl_id)
diff --git a/utils/media-ctl/v4l2subdev.h b/utils/media-ctl/v4l2subdev.h
index 7d9e53a..3732755 100644
--- a/utils/media-ctl/v4l2subdev.h
+++ b/utils/media-ctl/v4l2subdev.h
@@ -29,6 +29,15 @@ struct media_device;
 struct media_entity;
 struct media_device;
 
+enum v4l2_subdev_fmt_mismatch {
+	FMT_MISMATCH_NONE = 0,
+	FMT_MISMATCH_WIDTH,
+	FMT_MISMATCH_HEIGHT,
+	FMT_MISMATCH_CODE,
+	FMT_MISMATCH_FIELD,
+	FMT_MISMATCH_COLORSPACE,
+};
+
 struct v4l2_subdev {
 	int fd;
 
@@ -345,6 +354,19 @@ int v4l2_subdev_validate_v4l2_ctrl(struct media_device *media,
 				   struct media_entity *entity,
 				   __u32 ctrl_id);
 /**
+ * @brief Compare mbus formats
+ * @param fmt1 - 1st mbus format to compare.
+ * @param fmt2 - 2nd mbus format to compare.
+ *
+ * Check whether two mbus formats are compatible.
+ *
+ * @return 1 if formats are compatible, 0 otherwise.
+ */
+enum v4l2_subdev_fmt_mismatch v4l2_subdev_format_compare(
+				struct v4l2_mbus_framefmt *fmt1,
+				struct v4l2_mbus_framefmt *fmt2);
+
+/**
  * @brief Check if there was a v4l2_control redirection defined for the entity
  * @param media - media device.
  * @param entity - subdev-device media entity.
-- 
1.7.9.5

