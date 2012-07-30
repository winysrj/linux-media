Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54585 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755016Ab2G3WQE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jul 2012 18:16:04 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org
Subject: [media-ctl PATCH 1/1] libv4l2subdev: Add v4l2_subdev_enum_mbus_code()
Date: Tue, 31 Jul 2012 01:16:00 +0300
Message-Id: <1343686560-31983-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_subdev_enum_mbus_code() enumerates over supported media bus formats on
a pad.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 src/v4l2subdev.c |   23 +++++++++++++++++++++++
 src/v4l2subdev.h |   14 ++++++++++++++
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/src/v4l2subdev.c b/src/v4l2subdev.c
index d60bd7e..6b6df0a 100644
--- a/src/v4l2subdev.c
+++ b/src/v4l2subdev.c
@@ -58,6 +58,29 @@ void v4l2_subdev_close(struct media_entity *entity)
 	entity->fd = -1;
 }
 
+int v4l2_subdev_enum_mbus_code(struct media_entity *entity,
+			       uint32_t *code, uint32_t pad, uint32_t index)
+{
+	struct v4l2_subdev_mbus_code_enum c;
+	int ret;
+
+	ret = v4l2_subdev_open(entity);
+	if (ret < 0)
+		return ret;
+
+	memset(&c, 0, sizeof(c));
+	c.pad = pad;
+	c.index = index;
+
+	ret = ioctl(entity->fd, VIDIOC_SUBDEV_ENUM_MBUS_CODE, &c);
+	if (ret < 0)
+		return -errno;
+
+	*code = c.code;
+
+	return 0;
+}
+
 int v4l2_subdev_get_format(struct media_entity *entity,
 	struct v4l2_mbus_framefmt *format, unsigned int pad,
 	enum v4l2_subdev_format_whence which)
diff --git a/src/v4l2subdev.h b/src/v4l2subdev.h
index 5d55482..1cca7b9 100644
--- a/src/v4l2subdev.h
+++ b/src/v4l2subdev.h
@@ -22,6 +22,7 @@
 #ifndef __SUBDEV_H__
 #define __SUBDEV_H__
 
+#include <stdint.h>
 #include <linux/v4l2-subdev.h>
 
 struct media_entity;
@@ -47,6 +48,19 @@ int v4l2_subdev_open(struct media_entity *entity);
 void v4l2_subdev_close(struct media_entity *entity);
 
 /**
+ * @brief Enumerate mbus pixel codes.
+ * @param entity - subdev-device media entity.
+ * @param code - mbus pixel code
+ *
+ * Enumerate media bus pixel codes. This is just a wrapper for
+ * VIDIOC_SUBDEV_ENUM_MBUS_CODE IOCTL.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int v4l2_subdev_enum_mbus_code(struct media_entity *entity,
+			       uint32_t *code, uint32_t pad, uint32_t index);
+
+/**
  * @brief Retrieve the format on a pad.
  * @param entity - subdev-device media entity.
  * @param format - format to be filled.
-- 
1.7.2.5

