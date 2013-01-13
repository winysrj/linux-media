Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56982 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756149Ab3AMWoT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jan 2013 17:44:19 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [media-ctl PATCH 2/3] Implement v4l2_subdev_enum_mbus_code()
Date: Mon, 14 Jan 2013 00:47:32 +0200
Message-Id: <1358117253-13707-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1358117253-13707-1-git-send-email-sakari.ailus@iki.fi>
References: <50F3396E.2010505@iki.fi>
 <1358117253-13707-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_subdev_enum_mbus_code() enumerates the media bus pixel codes on a pad
of a given entity. The function returns a struct containing the array of
enumerated pixel codes. Once the user no longer needs the array, its memory
is released using free(3).

The decision not to store the media bus pixel codes in the library's
internal data structures is an informed one: the configuration of the device
could affect the selection of possible pixel codes on the device. One
example of such is the chosen try pixel code on the sink pad which is known
to affect the selection of available pixel codes on the source pad of the
OMAP 3 ISP resizer.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 src/v4l2subdev.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 src/v4l2subdev.h |   20 ++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/src/v4l2subdev.c b/src/v4l2subdev.c
index 56964ce..946c030 100644
--- a/src/v4l2subdev.c
+++ b/src/v4l2subdev.c
@@ -27,6 +27,7 @@
 #include <fcntl.h>
 #include <stdbool.h>
 #include <stdio.h>
+#include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
 
@@ -64,6 +65,51 @@ void v4l2_subdev_close(struct media_entity *entity)
 	}
 }
 
+struct v4l2_subdev_mbus_codes *
+v4l2_subdev_enum_mbus_code(struct media_entity *entity, unsigned int pad)
+{
+	struct v4l2_subdev_mbus_code_enum c;
+	struct v4l2_subdev_mbus_codes *codes = NULL;
+	int ret;
+
+	ret = v4l2_subdev_open(entity);
+	if (ret < 0)
+		return NULL;
+
+	memset(&c, 0, sizeof(c));
+	c.pad = pad;
+
+	for (; ; c.index++) {
+		void *tmp;
+
+		ret = ioctl(entity->fd, VIDIOC_SUBDEV_ENUM_MBUS_CODE, &c);
+		if (ret == -1) {
+			if (errno == EINVAL)
+				break;
+			else
+				goto out_err;
+		}
+
+		tmp = realloc(codes, sizeof(*codes)
+			      + (c.index + 1) * sizeof(codes->code[0]));
+		if (!tmp)
+			goto out_err;
+		codes = tmp;
+
+		codes->code[c.index] = c.code;
+	}
+
+	codes->ncode = c.index;
+
+	v4l2_subdev_close(entity);
+	return codes;
+
+out_err:
+	v4l2_subdev_close(entity);
+	free(codes);
+	return NULL;
+}
+
 int v4l2_subdev_get_format(struct media_entity *entity,
 	struct v4l2_mbus_framefmt *format, unsigned int pad,
 	enum v4l2_subdev_format_whence which)
diff --git a/src/v4l2subdev.h b/src/v4l2subdev.h
index 43d5c1f..8b42f4d 100644
--- a/src/v4l2subdev.h
+++ b/src/v4l2subdev.h
@@ -48,6 +48,26 @@ int v4l2_subdev_open(struct media_entity *entity);
  */
 void v4l2_subdev_close(struct media_entity *entity);
 
+struct v4l2_subdev_mbus_codes {
+	unsigned int ncode;
+	unsigned int code[0];
+} __packed;
+
+/**
+ * @brief Enumerate mbus pixel codes.
+ * @param entity - subdev-device media entity.
+ * @param pad - the pad of the media entity
+ *
+ * Enumerate media bus pixel codes. This is just a wrapper for
+ * VIDIOC_SUBDEV_ENUM_MBUS_CODE IOCTL.
+ *
+ * @return NULL on error; otherwise struct v4l2_subdev_mbus_code_enum
+ * containing the media bus codes. The user MUST use free(3) to
+ * release the returned struct once the user no longer needs it.
+ */
+struct v4l2_subdev_mbus_codes *
+v4l2_subdev_enum_mbus_code(struct media_entity *entity, unsigned int pad);
+
 /**
  * @brief Retrieve the format on a pad.
  * @param entity - subdev-device media entity.
-- 
1.7.10.4

