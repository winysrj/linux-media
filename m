Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:49568 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933302AbcJLOiT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 10:38:19 -0400
Received: from epcpsbgm1new.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OEX01FZBV7FY8A0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 12 Oct 2016 23:35:48 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, hverkuil@xs4all.nl,
        mchehab@kernel.org, m.szyprowski@samsung.com,
        s.nawrocki@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH v4l-utils v7 6/7] mediactl: libv4l2subdev: add support for
 comparing mbus formats
Date: Wed, 12 Oct 2016 16:35:21 +0200
Message-id: <1476282922-11544-7-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1476282922-11544-1-git-send-email-j.anaszewski@samsung.com>
References: <1476282922-11544-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a function for checking whether two mbus formats
are compatible.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 utils/media-ctl/libv4l2subdev.c | 42 +++++++++++++++++++++++++++++++++++++++++
 utils/media-ctl/v4l2subdev.h    | 21 +++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index 31393bb..2ec9b5e 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -948,3 +948,45 @@ int v4l2_subdev_supports_v4l2_ctrl(struct media_device *media,
 
 	return 0;
 }
+
+enum v4l2_subdev_fmt_mismatch v4l2_subdev_format_compare(
+				struct v4l2_mbus_framefmt *fmt1,
+				struct v4l2_mbus_framefmt *fmt2)
+{
+	if (fmt1 == NULL || fmt2 == NULL)
+		return 0;
+
+	if (fmt1->width != fmt2->width) {
+		printf("width mismatch (fmt1: %d, fmt2: %d)\n",
+		       fmt1->width, fmt2->width);
+		return FMT_MISMATCH_WIDTH;
+	}
+
+	if (fmt1->height != fmt2->height) {
+		printf("height mismatch (fmt1: %d, fmt2: %d)\n",
+		       fmt1->height, fmt2->height);
+		return FMT_MISMATCH_HEIGHT;
+	}
+
+	if (fmt1->code != fmt2->code) {
+		printf("mbus code mismatch (fmt1: %s, fmt2: %s)\n",
+			v4l2_subdev_pixelcode_to_string(fmt1->code),
+			v4l2_subdev_pixelcode_to_string(fmt2->code));
+		return FMT_MISMATCH_CODE;
+	}
+
+	if (fmt1->field != fmt2->field) {
+		printf("field mismatch (fmt1: %d, fmt2: %d)\n",
+		       fmt1->field, fmt2->field);
+		return FMT_MISMATCH_FIELD;
+	}
+
+	if (fmt1->colorspace != fmt2->colorspace) {
+		printf("colorspace mismatch (fmt1: %s, fmt2: %s)\n",
+			v4l2_subdev_colorspace_to_string(fmt1->colorspace),
+			v4l2_subdev_colorspace_to_string(fmt2->colorspace));
+		return FMT_MISMATCH_COLORSPACE;
+	}
+
+	return FMT_MISMATCH_NONE;
+}
diff --git a/utils/media-ctl/v4l2subdev.h b/utils/media-ctl/v4l2subdev.h
index cf1250d..c438f71 100644
--- a/utils/media-ctl/v4l2subdev.h
+++ b/utils/media-ctl/v4l2subdev.h
@@ -28,6 +28,15 @@ struct media_device;
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
 	unsigned int fd_owner:1;
@@ -342,5 +351,17 @@ const enum v4l2_mbus_pixelcode *v4l2_subdev_pixelcode_list(
 int v4l2_subdev_supports_v4l2_ctrl(struct media_device *device,
 				   struct media_entity *entity,
 				   __u32 ctrl_id);
+/**
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
 
 #endif
-- 
1.9.1

