Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:43251 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832AbcARQSG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 11:18:06 -0500
Received: from epcpsbgm2new.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0O1500V0KPA4UN20@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Jan 2016 01:18:05 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
	gjasny@googlemail.com, hdegoede@redhat.com, hverkuil@xs4all.nl,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 02/15] mediactl: Add support for v4l2-ctrl-redir config
Date: Mon, 18 Jan 2016 17:17:27 +0100
Message-id: <1453133860-21571-3-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1453133860-21571-1-git-send-email-j.anaszewski@samsung.com>
References: <1453133860-21571-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make struct v4l2_subdev capable of aggregating v4l2-ctrl-redir
media device configuration entries. Added are also functions for
validating the config and checking whether a v4l2 sub-device
expects to receive ioctls related to the v4l2-control with given id.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 utils/media-ctl/libv4l2subdev.c |   49 ++++++++++++++++++++++++++++++++++++++-
 utils/media-ctl/v4l2subdev.h    |   30 ++++++++++++++++++++++++
 2 files changed, 78 insertions(+), 1 deletion(-)

diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index 3977ce5..069ded6 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -26,7 +26,6 @@
 #include <ctype.h>
 #include <errno.h>
 #include <fcntl.h>
-#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -50,7 +49,15 @@ int v4l2_subdev_create(struct media_entity *entity)
 
 	entity->sd->fd = -1;
 
+	entity->sd->v4l2_control_redir = malloc(sizeof(__u32));
+	if (entity->sd->v4l2_control_redir == NULL)
+		goto err_v4l2_control_redir_alloc;
+
 	return 0;
+
+err_v4l2_control_redir_alloc:
+	free(entity->sd);
+	return -ENOMEM;
 }
 
 int v4l2_subdev_create_with_fd(struct media_entity *entity, int fd)
@@ -870,3 +877,43 @@ enum v4l2_field v4l2_subdev_string_to_field(const char *string,
 
 	return fields[i].field;
 }
+
+int v4l2_subdev_validate_v4l2_ctrl(struct media_device *media,
+				   struct media_entity *entity,
+				   __u32 ctrl_id)
+{
+	struct v4l2_queryctrl queryctrl = {};
+	int ret;
+
+	ret = v4l2_subdev_open(entity);
+	if (ret < 0)
+		return ret;
+
+	queryctrl.id = ctrl_id;
+
+	ret = ioctl(entity->sd->fd, VIDIOC_QUERYCTRL, &queryctrl);
+	if (ret < 0)
+		return ret;
+
+	media_dbg(media, "Validated control \"%s\" (0x%8.8x) on entity %s\n",
+		  queryctrl.name, queryctrl.id, entity->info.name);
+
+	return 0;
+}
+
+bool v4l2_subdev_has_v4l2_control_redir(struct media_device *media,
+				  struct media_entity *entity,
+				  int ctrl_id)
+{
+	struct v4l2_subdev *sd = entity->sd;
+	int i;
+
+	if (!sd)
+		return false;
+
+	for (i = 0; i < sd->v4l2_control_redir_num; ++i)
+		if (sd->v4l2_control_redir[i] == ctrl_id)
+			return true;
+
+	return false;
+}
diff --git a/utils/media-ctl/v4l2subdev.h b/utils/media-ctl/v4l2subdev.h
index ba9b8c4..f395065 100644
--- a/utils/media-ctl/v4l2subdev.h
+++ b/utils/media-ctl/v4l2subdev.h
@@ -23,12 +23,17 @@
 #define __SUBDEV_H__
 
 #include <linux/v4l2-subdev.h>
+#include <stdbool.h>
 
 struct media_device;
 struct media_entity;
+struct media_device;
 
 struct v4l2_subdev {
 	int fd;
+
+	__u32 *v4l2_control_redir;
+	unsigned int v4l2_control_redir_num;
 };
 
 /**
@@ -316,5 +321,30 @@ const char *v4l2_subdev_field_to_string(enum v4l2_field field);
  */
 enum v4l2_field v4l2_subdev_string_to_field(const char *string,
 					    unsigned int length);
+/**
+ * @brief Validate v4l2 control for a sub-device
+ * @param media - media device.
+ * @param entity - subdev-device media entity.
+ * @param ctrl_id - id of the v4l2 control to validate.
+ *
+ * Verify if the entity supports v4l2-control with given ctrl_id.
+ *
+ * @return 1 if the control is supported, 0 otherwise.
+ */
+int v4l2_subdev_validate_v4l2_ctrl(struct media_device *media,
+				   struct media_entity *entity,
+				   __u32 ctrl_id);
+/**
+ * @brief Check if there was a v4l2_control redirection defined for the entity
+ * @param media - media device.
+ * @param entity - subdev-device media entity.
+ * @param ctrl_id - v4l2 control identifier.
+ *
+ * Check if there was a v4l2-ctrl-redir entry defined for the entity.
+ *
+ * @return true if the entry exists, false otherwise
+ */
+bool v4l2_subdev_has_v4l2_control_redir(struct media_device *media,
+	struct media_entity *entity, int ctrl_id);
 
 #endif
-- 
1.7.9.5

