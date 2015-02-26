Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:36500 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbbBZQAi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2015 11:00:38 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKD00MCJZ51RPC0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Feb 2015 01:00:37 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
	gjasny@googlemail.com, hdegoede@redhat.com,
	kyungmin.park@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [v4l-utils PATCH/RFC v5 09/14] mediactl: libv4l2subdev: add support
 for comparing mbus formats
Date: Thu, 26 Feb 2015 16:59:19 +0100
Message-id: <1424966364-3647-10-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1424966364-3647-1-git-send-email-j.anaszewski@samsung.com>
References: <1424966364-3647-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a function for checking whether two mbus formats
are compatible.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 utils/media-ctl/libv4l2subdev.c |   34 ++++++++++++++++++++++++++++++++++
 utils/media-ctl/v4l2subdev.h    |   12 ++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index dfd3bd5..b9a924c 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -835,6 +835,40 @@ int v4l2_subdev_validate_v4l2_ctrl(struct media_device *media,
 	return 0;
 }
 
+int v4l2_subdev_format_compare(struct v4l2_mbus_framefmt *fmt1,
+				struct v4l2_mbus_framefmt *fmt2)
+{
+	if (fmt1 == NULL || fmt2 == NULL)
+		return 0;
+
+	if (fmt1->width != fmt2->width) {
+		printf("width mismatch\n");
+		return 0;
+	}
+
+	if (fmt1->height != fmt2->height) {
+		printf("height mismatch\n");
+		return 0;
+	}
+
+	if (fmt1->code != fmt2->code) {
+		printf("mbus code mismatch\n");
+		return 0;
+	}
+
+	if (fmt1->field != fmt2->field) {
+		printf("field mismatch\n");
+		return 0;
+	}
+
+	if (fmt1->colorspace != fmt2->colorspace) {
+		printf("colorspace mismatch\n");
+		return 0;
+	}
+
+	return 1;
+}
+
 bool v4l2_subdev_has_v4l2_control_redir(struct media_device *media,
 				  struct media_entity *entity,
 				  int ctrl_id)
diff --git a/utils/media-ctl/v4l2subdev.h b/utils/media-ctl/v4l2subdev.h
index 07f9697..2f74975 100644
--- a/utils/media-ctl/v4l2subdev.h
+++ b/utils/media-ctl/v4l2subdev.h
@@ -314,6 +314,18 @@ int v4l2_subdev_validate_v4l2_ctrl(struct media_device *media,
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
+int v4l2_subdev_format_compare(struct v4l2_mbus_framefmt *fmt1,
+	struct v4l2_mbus_framefmt *fmt2);
+
+/**
  * @brief Check if there was a v4l2_control redirection defined for the entity
  * @param media - media device.
  * @param entity - subdev-device media entity.
-- 
1.7.9.5

