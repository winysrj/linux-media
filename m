Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:53130 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbbBZQAE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2015 11:00:04 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKD005EZZ43B7B0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Feb 2015 01:00:03 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
	gjasny@googlemail.com, hdegoede@redhat.com,
	kyungmin.park@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [v4l-utils PATCH/RFC v5 01/14] mediactl: Introduce v4l2_subdev
 structure
Date: Thu, 26 Feb 2015 16:59:11 +0100
Message-id: <1424966364-3647-2-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1424966364-3647-1-git-send-email-j.anaszewski@samsung.com>
References: <1424966364-3647-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add struct v4l2_subdev - a representation of the v4l2 sub-device,
related to the media entity. Add field 'sd', the pointer to
the newly introduced structure, to the struct media_entity
and move 'fd' property from struct media entity to struct v4l2_subdev.
Avoid accessing sub-device file descriptor from libmediactl and
make the v4l2_subdev_open capable of creating the v4l2_subdev
if the 'sd' pointer is uninitialized.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 utils/media-ctl/libmediactl.c   |    4 --
 utils/media-ctl/libv4l2subdev.c |   82 +++++++++++++++++++++++++++++++--------
 utils/media-ctl/mediactl-priv.h |    5 ++-
 utils/media-ctl/v4l2subdev.h    |   38 ++++++++++++++++++
 4 files changed, 107 insertions(+), 22 deletions(-)

diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
index ec360bd..4bb955f 100644
--- a/utils/media-ctl/libmediactl.c
+++ b/utils/media-ctl/libmediactl.c
@@ -511,7 +511,6 @@ static int media_enum_entities(struct media_device *media)
 
 		entity = &media->entities[media->entities_count];
 		memset(entity, 0, sizeof(*entity));
-		entity->fd = -1;
 		entity->info.id = id | MEDIA_ENT_ID_FLAG_NEXT;
 		entity->media = media;
 
@@ -704,8 +703,6 @@ void media_device_unref(struct media_device *media)
 
 		free(entity->pads);
 		free(entity->links);
-		if (entity->fd != -1)
-			close(entity->fd);
 	}
 
 	free(media->entities);
@@ -732,7 +729,6 @@ int media_device_add_entity(struct media_device *media,
 	entity = &media->entities[media->entities_count - 1];
 	memset(entity, 0, sizeof *entity);
 
-	entity->fd = -1;
 	entity->media = media;
 	strncpy(entity->devname, devnode, sizeof entity->devname);
 	entity->devname[sizeof entity->devname - 1] = '\0';
diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index 8015330..68404d4 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -39,13 +39,61 @@
 #include "tools.h"
 #include "v4l2subdev.h"
 
+int v4l2_subdev_create(struct media_entity *entity)
+{
+	if (entity->sd)
+		return 0;
+
+	entity->sd = calloc(1, sizeof(*entity->sd));
+	if (entity->sd == NULL)
+		return -ENOMEM;
+
+	entity->sd->fd = -1;
+
+	return 0;
+}
+
+int v4l2_subdev_create_with_fd(struct media_entity *entity, int fd)
+{
+	int ret;
+
+	if (entity->sd)
+		return -EEXIST;
+
+	ret = v4l2_subdev_create(entity);
+	if (ret < 0)
+		return ret;
+
+	entity->sd->fd = fd;
+
+	return 0;
+}
+
+void v4l2_subdev_release(struct media_entity *entity, bool close_fd)
+{
+	if (entity->sd == NULL)
+		return;
+
+	if (close_fd)
+		v4l2_subdev_close(entity);
+
+	free(entity->sd->v4l2_control_redir);
+	free(entity->sd);
+}
+
 int v4l2_subdev_open(struct media_entity *entity)
 {
-	if (entity->fd != -1)
+	int ret;
+
+	ret = v4l2_subdev_create(entity);
+	if (ret < 0)
+		return ret;
+
+	if (entity->sd->fd != -1)
 		return 0;
 
-	entity->fd = open(entity->devname, O_RDWR);
-	if (entity->fd == -1) {
+	entity->sd->fd = open(entity->devname, O_RDWR);
+	if (entity->sd->fd == -1) {
 		int ret = -errno;
 		media_dbg(entity->media,
 			  "%s: Failed to open subdev device node %s\n", __func__,
@@ -58,8 +106,8 @@ int v4l2_subdev_open(struct media_entity *entity)
 
 void v4l2_subdev_close(struct media_entity *entity)
 {
-	close(entity->fd);
-	entity->fd = -1;
+	close(entity->sd->fd);
+	entity->sd->fd = -1;
 }
 
 int v4l2_subdev_get_format(struct media_entity *entity,
@@ -77,7 +125,7 @@ int v4l2_subdev_get_format(struct media_entity *entity,
 	fmt.pad = pad;
 	fmt.which = which;
 
-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_FMT, &fmt);
+	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_G_FMT, &fmt);
 	if (ret < 0)
 		return -errno;
 
@@ -101,7 +149,7 @@ int v4l2_subdev_set_format(struct media_entity *entity,
 	fmt.which = which;
 	fmt.format = *format;
 
-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_FMT, &fmt);
+	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_S_FMT, &fmt);
 	if (ret < 0)
 		return -errno;
 
@@ -128,7 +176,7 @@ int v4l2_subdev_get_selection(struct media_entity *entity,
 	u.sel.target = target;
 	u.sel.which = which;
 
-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_SELECTION, &u.sel);
+	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_G_SELECTION, &u.sel);
 	if (ret >= 0) {
 		*rect = u.sel.r;
 		return 0;
@@ -140,7 +188,7 @@ int v4l2_subdev_get_selection(struct media_entity *entity,
 	u.crop.pad = pad;
 	u.crop.which = which;
 
-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_CROP, &u.crop);
+	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_G_CROP, &u.crop);
 	if (ret < 0)
 		return -errno;
 
@@ -168,7 +216,7 @@ int v4l2_subdev_set_selection(struct media_entity *entity,
 	u.sel.which = which;
 	u.sel.r = *rect;
 
-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_SELECTION, &u.sel);
+	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_S_SELECTION, &u.sel);
 	if (ret >= 0) {
 		*rect = u.sel.r;
 		return 0;
@@ -181,7 +229,7 @@ int v4l2_subdev_set_selection(struct media_entity *entity,
 	u.crop.which = which;
 	u.crop.rect = *rect;
 
-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_CROP, &u.crop);
+	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_S_CROP, &u.crop);
 	if (ret < 0)
 		return -errno;
 
@@ -202,7 +250,7 @@ int v4l2_subdev_get_dv_timings_caps(struct media_entity *entity,
 	memset(caps, 0, sizeof(*caps));
 	caps->pad = pad;
 
-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_DV_TIMINGS_CAP, caps);
+	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_DV_TIMINGS_CAP, caps);
 	if (ret < 0)
 		return -errno;
 
@@ -220,7 +268,7 @@ int v4l2_subdev_query_dv_timings(struct media_entity *entity,
 
 	memset(timings, 0, sizeof(*timings));
 
-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_QUERY_DV_TIMINGS, timings);
+	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_QUERY_DV_TIMINGS, timings);
 	if (ret < 0)
 		return -errno;
 
@@ -238,7 +286,7 @@ int v4l2_subdev_get_dv_timings(struct media_entity *entity,
 
 	memset(timings, 0, sizeof(*timings));
 
-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_DV_TIMINGS, timings);
+	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_G_DV_TIMINGS, timings);
 	if (ret < 0)
 		return -errno;
 
@@ -254,7 +302,7 @@ int v4l2_subdev_set_dv_timings(struct media_entity *entity,
 	if (ret < 0)
 		return ret;
 
-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_DV_TIMINGS, timings);
+	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_S_DV_TIMINGS, timings);
 	if (ret < 0)
 		return -errno;
 
@@ -273,7 +321,7 @@ int v4l2_subdev_get_frame_interval(struct media_entity *entity,
 
 	memset(&ival, 0, sizeof(ival));
 
-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_FRAME_INTERVAL, &ival);
+	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_G_FRAME_INTERVAL, &ival);
 	if (ret < 0)
 		return -errno;
 
@@ -294,7 +342,7 @@ int v4l2_subdev_set_frame_interval(struct media_entity *entity,
 	memset(&ival, 0, sizeof(ival));
 	ival.interval = *interval;
 
-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_FRAME_INTERVAL, &ival);
+	ret = ioctl(entity->sd->fd, VIDIOC_SUBDEV_S_FRAME_INTERVAL, &ival);
 	if (ret < 0)
 		return -errno;
 
diff --git a/utils/media-ctl/mediactl-priv.h b/utils/media-ctl/mediactl-priv.h
index a0d3a55..f531c52 100644
--- a/utils/media-ctl/mediactl-priv.h
+++ b/utils/media-ctl/mediactl-priv.h
@@ -26,6 +26,8 @@
 
 #include "mediactl.h"
 
+struct v4l2_subdev;
+
 struct media_entity {
 	struct media_device *media;
 	struct media_entity_desc info;
@@ -34,8 +36,9 @@ struct media_entity {
 	unsigned int max_links;
 	unsigned int num_links;
 
+	struct v4l2_subdev *sd;
+
 	char devname[32];
-	int fd;
 };
 
 struct media_device {
diff --git a/utils/media-ctl/v4l2subdev.h b/utils/media-ctl/v4l2subdev.h
index 1cb53ff..b386294 100644
--- a/utils/media-ctl/v4l2subdev.h
+++ b/utils/media-ctl/v4l2subdev.h
@@ -26,6 +26,44 @@
 
 struct media_entity;
 
+struct v4l2_subdev {
+	int fd;
+};
+
+/**
+ * @brief Create a v4l2-subdev
+ * @param entity - sub-device media entity.
+ *
+ * Create the representation of the entity sub-device.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int v4l2_subdev_create(struct media_entity *entity);
+
+/**
+ * @brief Create a representation of the already opened v4l2-subdev
+ * @param entity - sub-device media entity.
+ * @param fd - sub-device file descriptor.
+ *
+ * Create the representation of the sub-device that had been opened
+ * before the parent media device was created, and associate it
+ * with the media entity.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int v4l2_subdev_create_with_fd(struct media_entity *entity, int fd);
+
+/**
+ * @brief Release a v4l2-subdev
+ * @param entity - sub-device media entity.
+ * @param close_fd - indicates whether subdev fd should be closed.
+ *
+ * Release the representation of the entity sub-device.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+void v4l2_subdev_release(struct media_entity *entity, bool close_fd);
+
 /**
  * @brief Open a sub-device.
  * @param entity - sub-device media entity.
-- 
1.7.9.5

