Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:31404 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758534AbaKUQO7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Nov 2014 11:14:59 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NFE003HQD4X7LB0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Sat, 22 Nov 2014 01:14:57 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, gjasny@googlemail.com, hdegoede@redhat.com,
	hans.verkuil@cisco.com, b.zolnierkie@samsung.com,
	kyungmin.park@samsung.com, sakari.ailus@linux.intel.com,
	laurent.pinchart@ideasonboard.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v4 02/11] mediactl: Add support for v4l2 controls
Date: Fri, 21 Nov 2014 17:14:31 +0100
Message-id: <1416586480-19982-3-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1416586480-19982-1-git-send-email-j.anaszewski@samsung.com>
References: <1416586480-19982-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make struct v4l2_subdev capable of aggregating information
on its validated v4l2 controls. A control needs to be validated
for a v4l2_subdev in case it is mentioned in the media
configuraion file. Added are also functions for validating
controls and finding validated controls.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 utils/media-ctl/libmediactl.c   |   11 +++++++
 utils/media-ctl/libv4l2subdev.c |   60 ++++++++++++++++++++++++++++++++++++++-
 utils/media-ctl/mediactl-priv.h |    3 ++
 utils/media-ctl/v4l2subdev.h    |   28 ++++++++++++++++++
 4 files changed, 101 insertions(+), 1 deletion(-)

diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
index 53921f5..4c4ddbe 100644
--- a/utils/media-ctl/libmediactl.c
+++ b/utils/media-ctl/libmediactl.c
@@ -537,6 +537,12 @@ static int media_enum_entities(struct media_device *media)
 		entity->sd->fd = -1;
 		media->entities_count++;
 
+		entity->sd->v4l2_controls = malloc(sizeof(__u32));
+		if (entity->sd->v4l2_controls == NULL) {
+			ret = -ENOMEM;
+			break;
+		}
+
 		if (entity->info.flags & MEDIA_ENT_FL_DEFAULT) {
 			switch (entity->info.type) {
 			case MEDIA_ENT_T_DEVNODE_V4L:
@@ -707,6 +713,7 @@ void media_device_unref(struct media_device *media)
 		free(entity->links);
 		if (entity->sd->fd != -1)
 			close(entity->sd->fd);
+		free(entity->sd->v4l2_controls);
 		free(entity->sd);
 	}
 
@@ -732,6 +739,10 @@ int media_device_add_entity(struct media_device *media,
 	if (entity->sd == NULL)
 		return -ENOMEM;
 
+	entity->sd->v4l2_controls = malloc(sizeof(__u32));
+	if (entity->sd->v4l2_controls == NULL)
+		return -ENOMEM;
+
 	media->entities = entity;
 	media->entities_count++;
 
diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index 09e0081..4c5fb12 100644
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
@@ -755,3 +754,62 @@ enum v4l2_mbus_pixelcode v4l2_subdev_string_to_pixelcode(const char *string,
 
 	return mbus_formats[i].code;
 }
+
+int v4l2_subdev_validate_v4l2_ctrl(struct media_device *media,
+				   struct media_entity *entity,
+				   __u32 ctrl_id)
+{
+	struct v4l2_query_ext_ctrl queryctrl;
+	int ret;
+
+	if (v4l2_subdev_has_v4l2_control(media, entity, ctrl_id))
+		goto done;
+
+	ret = v4l2_subdev_open(entity);
+	if (ret < 0)
+		return ret;
+
+	/* Iterate through control ids */
+
+	queryctrl.id = ctrl_id;
+
+	ret = ioctl(entity->sd->fd, VIDIOC_QUERY_EXT_CTRL, &queryctrl);
+	if (ret < 0) {
+		media_dbg(media, "Control (0x%8.8x) not supported on entity %s\n",
+			  queryctrl.name,
+			  ctrl_id,
+			  entity->info.name);
+		return ret;
+	}
+
+	entity->sd->v4l2_controls = realloc(entity->sd->v4l2_controls,
+					    sizeof(*entity->sd->v4l2_controls) *
+					    (entity->sd->v4l2_controls_count + 1));
+	if (!entity->sd->v4l2_controls)
+		return -ENOMEM;
+
+	entity->sd->v4l2_controls[entity->sd->v4l2_controls_count] = ctrl_id;
+	++entity->sd->v4l2_controls_count;
+
+done:
+	media_dbg(media, "Validated control \"%s\" (0x%8.8x) on entity %s\n",
+		  queryctrl.name,
+		  ctrl_id,
+		  entity->info.name);
+
+	return 0;
+}
+
+bool v4l2_subdev_has_v4l2_control(struct media_device *media,
+				  struct media_entity *entity,
+				  int ctrl_id)
+{
+	struct v4l2_subdev *sd = entity->sd;
+	int i;
+
+	for (i = 0; i < sd->v4l2_controls_count; ++i)
+		if (sd->v4l2_controls[i] == ctrl_id)
+			return true;
+
+	return false;
+}
diff --git a/utils/media-ctl/mediactl-priv.h b/utils/media-ctl/mediactl-priv.h
index 4bcb1e0..fbf1989 100644
--- a/utils/media-ctl/mediactl-priv.h
+++ b/utils/media-ctl/mediactl-priv.h
@@ -41,6 +41,9 @@ struct media_entity {
 
 struct v4l2_subdev {
 	int fd;
+
+	__u32 *v4l2_controls;
+	unsigned int v4l2_controls_count;
 };
 
 struct media_device {
diff --git a/utils/media-ctl/v4l2subdev.h b/utils/media-ctl/v4l2subdev.h
index 1cb53ff..ac98b61 100644
--- a/utils/media-ctl/v4l2subdev.h
+++ b/utils/media-ctl/v4l2subdev.h
@@ -22,6 +22,7 @@
 #ifndef __SUBDEV_H__
 #define __SUBDEV_H__
 
+#include <stdbool.h>
 #include <linux/v4l2-subdev.h>
 
 struct media_entity;
@@ -255,4 +256,31 @@ const char *v4l2_subdev_pixelcode_to_string(enum v4l2_mbus_pixelcode code);
  */
 enum v4l2_mbus_pixelcode v4l2_subdev_string_to_pixelcode(const char *string,
 							 unsigned int length);
+
+/**
+ * @brief Validate v4l2 control for a sub-device
+ * @param media - media device.
+ * @param entity - subdev-device media entity.
+ * @param ctrl_id - v4l2 control identifier
+ *
+ * Verify if the entity supports v4l2-control with ctrl_id.
+ *
+ * @return 1 if the control is supported, 0 otherwise.
+ */
+int v4l2_subdev_validate_v4l2_ctrl(struct media_device *media,
+	struct media_entity *entity, __u32 ctrl_id);
+
+/**
+ * @brief Check if the sub-device has a validated control
+ * @param media - media device.
+ * @param entity - subdev-device media entity.
+ * @param ctrl_id - v4l2 control identifier
+ *
+ * Check if the sub-device has validated v4l2-control.
+ *
+ * @return true on success, false otherwise
+ */
+bool v4l2_subdev_has_v4l2_control(struct media_device *media,
+	struct media_entity *entity, int ctrl_id);
+
 #endif
-- 
1.7.9.5

