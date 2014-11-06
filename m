Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:51249 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaKFKMN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Nov 2014 05:12:13 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NEM00KF74CC5250@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 06 Nov 2014 19:12:12 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, gjasny@googlemail.com, hdegoede@redhat.com,
	hans.verkuil@cisco.com, b.zolnierkie@samsung.com,
	sakari.ailus@linux.intel.com, kyungmin.park@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [v4l-utils RFC v3 06/11] mediactl: Add subdev_fmt property to the
 media_entity
Date: Thu, 06 Nov 2014 11:11:37 +0100
Message-id: <1415268702-23685-7-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1415268702-23685-1-git-send-email-j.anaszewski@samsung.com>
References: <1415268702-23685-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add subdev_fmt field to the structure media_entity.
Added is also API for setting the media_entity
format and comparing two subdev formats.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 utils/media-ctl/libmediactl.c   |    6 ++++++
 utils/media-ctl/libv4l2subdev.c |   34 ++++++++++++++++++++++++++++++++++
 utils/media-ctl/mediactl-priv.h |    3 +++
 utils/media-ctl/mediactl.h      |   12 ++++++++++++
 utils/media-ctl/v4l2subdev.h    |   12 ++++++++++++
 5 files changed, 67 insertions(+)

diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
index 10f0491..27e7329 100644
--- a/utils/media-ctl/libmediactl.c
+++ b/utils/media-ctl/libmediactl.c
@@ -1260,3 +1260,9 @@ int media_entity_get_fd(struct media_entity *entity)
 {
 	return entity->fd;
 }
+
+void media_entity_set_subdev_fmt(struct media_entity *entity,
+				struct v4l2_subdev_format *fmt)
+{
+	entity->subdev_fmt = *fmt;
+}
diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index 99ac6b2..449565c 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -786,3 +786,37 @@ int v4l2_subdev_validate_v4l2_ctrl(struct media_device *media,
 							entity->info.name);
 	return 0;
 }
+
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
diff --git a/utils/media-ctl/mediactl-priv.h b/utils/media-ctl/mediactl-priv.h
index b9e9b20..b2c466b 100644
--- a/utils/media-ctl/mediactl-priv.h
+++ b/utils/media-ctl/mediactl-priv.h
@@ -23,6 +23,7 @@
 #define __MEDIA_PRIV_H__
 
 #include <linux/media.h>
+#include <linux/v4l2-subdev.h>
 
 #include "mediactl.h"
 
@@ -34,6 +35,8 @@ struct media_entity {
 	unsigned int max_links;
 	unsigned int num_links;
 
+	struct v4l2_subdev_format subdev_fmt;
+
 	char devname[32];
 	int fd;
 };
diff --git a/utils/media-ctl/mediactl.h b/utils/media-ctl/mediactl.h
index 0dc7f95..d28b0a8 100644
--- a/utils/media-ctl/mediactl.h
+++ b/utils/media-ctl/mediactl.h
@@ -42,6 +42,7 @@ struct media_pad {
 
 struct media_device;
 struct media_entity;
+struct v4l2_subdev_format;
 
 /**
  * @brief Create a new media device.
@@ -611,4 +612,15 @@ int media_entity_get_sink_pad_index(struct media_entity *entity);
  */
 int media_entity_get_fd(struct media_entity *entity);
 
+/**
+ * @brief Set sub-device format
+ * @param entity - media entity
+ * @param fmt - pointer to the sub-device format structure
+ *
+ * This function sets the format of the sub-device related
+ * to this entity.
+ */
+void media_entity_set_subdev_fmt(struct media_entity *entity,
+				struct v4l2_subdev_format *fmt);
+
 #endif
diff --git a/utils/media-ctl/v4l2subdev.h b/utils/media-ctl/v4l2subdev.h
index 3bc0412..2c9d507 100644
--- a/utils/media-ctl/v4l2subdev.h
+++ b/utils/media-ctl/v4l2subdev.h
@@ -270,4 +270,16 @@ int v4l2_subdev_validate_v4l2_ctrl(struct media_device *media,
 	struct media_entity *entity,
 	__u32 ctrl_id);
 
+/**
+ * @brief Compare mbus formats
+ * @param fmt1 - 1st mbus format to compare
+ * @param fmt2 - 2nd mbus format to compare
+ *
+ * Check whether two mbus formats are compatible.
+ *
+ * @return 1 if formats are compatible, 0 otherwise
+ */
+int v4l2_subdev_format_compare(struct v4l2_mbus_framefmt *fmt1,
+	struct v4l2_mbus_framefmt *fmt2);
+
 #endif
-- 
1.7.9.5

