Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56979 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756148Ab3AMWoT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jan 2013 17:44:19 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [media-ctl PATCH 1/3] Count users for entities
Date: Mon, 14 Jan 2013 00:47:31 +0200
Message-Id: <1358117253-13707-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <50F3396E.2010505@iki.fi>
References: <50F3396E.2010505@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The subdev nodes used to be closed immediately on v4l2_subdev_close(), now
the subdev is only closed if there are no users left anymore. This changes the
API from immediate effect (close) to a reference counting one.

Also make functions opening subdevs to close them before returning. This
resolves issues on some machines where not all subdevs can be opened at the
same time. Power management wise this is a sound choice since it forces to
make the decision when to keep a device powered rather than keeping
everything open all the time.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 src/mediactl.c   |    1 -
 src/mediactl.h   |    1 +
 src/v4l2subdev.c |   94 ++++++++++++++++++++++++++++++++++++++++--------------
 src/v4l2subdev.h |   12 ++++---
 4 files changed, 78 insertions(+), 30 deletions(-)

diff --git a/src/mediactl.c b/src/mediactl.c
index 46562de..7600714 100644
--- a/src/mediactl.c
+++ b/src/mediactl.c
@@ -382,7 +382,6 @@ static int media_enum_entities(struct media_device *media)
 
 		entity = &media->entities[media->entities_count];
 		memset(entity, 0, sizeof(*entity));
-		entity->fd = -1;
 		entity->info.id = id | MEDIA_ENT_ID_FLAG_NEXT;
 		entity->media = media;
 
diff --git a/src/mediactl.h b/src/mediactl.h
index 2296fe2..79934a7 100644
--- a/src/mediactl.h
+++ b/src/mediactl.h
@@ -49,6 +49,7 @@ struct media_entity {
 
 	char devname[32];
 	int fd;
+	unsigned int open_count;
 	__u32 padding[6];
 };
 
diff --git a/src/v4l2subdev.c b/src/v4l2subdev.c
index d0c37f3..56964ce 100644
--- a/src/v4l2subdev.c
+++ b/src/v4l2subdev.c
@@ -38,7 +38,8 @@
 
 int v4l2_subdev_open(struct media_entity *entity)
 {
-	if (entity->fd != -1)
+	entity->open_count++;
+	if (entity->open_count > 1)
 		return 0;
 
 	entity->fd = open(entity->devname, O_RDWR);
@@ -46,6 +47,7 @@ int v4l2_subdev_open(struct media_entity *entity)
 		media_dbg(entity->media,
 			  "%s: Failed to open subdev device node %s\n", __func__,
 			  entity->devname);
+		entity->open_count--;
 		return -errno;
 	}
 
@@ -54,8 +56,12 @@ int v4l2_subdev_open(struct media_entity *entity)
 
 void v4l2_subdev_close(struct media_entity *entity)
 {
-	close(entity->fd);
-	entity->fd = -1;
+	entity->open_count--;
+
+	if (!entity->open_count) {
+		close(entity->fd);
+		entity->fd = -1;
+	}
 }
 
 int v4l2_subdev_get_format(struct media_entity *entity,
@@ -74,10 +80,16 @@ int v4l2_subdev_get_format(struct media_entity *entity,
 	fmt.which = which;
 
 	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_FMT, &fmt);
-	if (ret < 0)
-		return -errno;
+	if (ret < 0) {
+		ret = -errno;
+		goto err;
+	}
 
 	*format = fmt.format;
+
+err:
+	v4l2_subdev_close(entity);
+
 	return 0;
 }
 
@@ -98,10 +110,16 @@ int v4l2_subdev_set_format(struct media_entity *entity,
 	fmt.format = *format;
 
 	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_FMT, &fmt);
-	if (ret < 0)
-		return -errno;
+	if (ret < 0) {
+		ret = -errno;
+		goto err;
+	}
 
 	*format = fmt.format;
+
+err:
+	v4l2_subdev_close(entity);
+
 	return 0;
 }
 
@@ -127,21 +145,29 @@ int v4l2_subdev_get_selection(struct media_entity *entity,
 	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_SELECTION, &u.sel);
 	if (ret >= 0) {
 		*rect = u.sel.r;
-		return 0;
+		goto done;
+	}
+	if (errno != ENOTTY || target != V4L2_SEL_TGT_CROP) {
+		ret = -errno;
+		goto done;
 	}
-	if (errno != ENOTTY || target != V4L2_SEL_TGT_CROP)
-		return -errno;
 
 	memset(&u.crop, 0, sizeof(u.crop));
 	u.crop.pad = pad;
 	u.crop.which = which;
 
 	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_CROP, &u.crop);
-	if (ret < 0)
-		return -errno;
+	if (ret < 0) {
+		ret = -errno;
+		goto done;
+	}
 
 	*rect = u.crop.rect;
-	return 0;
+
+done:
+	v4l2_subdev_close(entity);
+
+	return ret;
 }
 
 int v4l2_subdev_set_selection(struct media_entity *entity,
@@ -167,10 +193,12 @@ int v4l2_subdev_set_selection(struct media_entity *entity,
 	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_SELECTION, &u.sel);
 	if (ret >= 0) {
 		*rect = u.sel.r;
-		return 0;
+		goto done;
+	}
+	if (errno != ENOTTY || target != V4L2_SEL_TGT_CROP) {
+		ret = -errno;
+		goto done;
 	}
-	if (errno != ENOTTY || target != V4L2_SEL_TGT_CROP)
-		return -errno;
 
 	memset(&u.crop, 0, sizeof(u.crop));
 	u.crop.pad = pad;
@@ -178,11 +206,17 @@ int v4l2_subdev_set_selection(struct media_entity *entity,
 	u.crop.rect = *rect;
 
 	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_CROP, &u.crop);
-	if (ret < 0)
-		return -errno;
+	if (ret < 0) {
+		ret = -errno;
+		goto done;
+	}
 
 	*rect = u.crop.rect;
-	return 0;
+
+done:
+	v4l2_subdev_close(entity);
+
+	return ret;
 }
 
 int v4l2_subdev_get_frame_interval(struct media_entity *entity,
@@ -198,11 +232,17 @@ int v4l2_subdev_get_frame_interval(struct media_entity *entity,
 	memset(&ival, 0, sizeof(ival));
 
 	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_FRAME_INTERVAL, &ival);
-	if (ret < 0)
-		return -errno;
+	if (ret < 0) {
+		ret = -errno;
+		goto err;
+	}
 
 	*interval = ival.interval;
-	return 0;
+
+err:
+	v4l2_subdev_close(entity);
+
+	return ret;
 }
 
 int v4l2_subdev_set_frame_interval(struct media_entity *entity,
@@ -219,10 +259,16 @@ int v4l2_subdev_set_frame_interval(struct media_entity *entity,
 	ival.interval = *interval;
 
 	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_FRAME_INTERVAL, &ival);
-	if (ret < 0)
-		return -errno;
+	if (ret < 0) {
+		ret = -errno;
+		goto err;
+	}
 
 	*interval = ival.interval;
+
+err:
+	v4l2_subdev_close(entity);
+
 	return 0;
 }
 
diff --git a/src/v4l2subdev.h b/src/v4l2subdev.h
index 5d55482..43d5c1f 100644
--- a/src/v4l2subdev.h
+++ b/src/v4l2subdev.h
@@ -30,19 +30,21 @@ struct media_entity;
  * @brief Open a sub-device.
  * @param entity - sub-device media entity.
  *
- * Open the V4L2 subdev device node associated with @a entity. The file
- * descriptor is stored in the media_entity structure.
+ * Open the V4L2 subdev device node associated with @a entity. The
+ * file descriptor is stored in the media_entity structure. The subdev
+ * will stay open until the last user has closed it using
+ * v4l2_subdev_close(), i.e. the calls are reference-counted.
  *
  * @return 0 on success, or a negative error code on failure.
  */
 int v4l2_subdev_open(struct media_entity *entity);
 
 /**
- * @brief Close a sub-device.
+ * @brief Release a sub-device.
  * @param entity - sub-device media entity.
  *
- * Close the V4L2 subdev device node associated with the @a entity and opened by
- * a previous call to v4l2_subdev_open() (either explicit or implicit).
+ * Releases a reference to a sub-device. The device will stay open
+ * until the last remaining user has released the device.
  */
 void v4l2_subdev_close(struct media_entity *entity);
 
-- 
1.7.10.4

