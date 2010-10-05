Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:56756 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab0JEOZG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Oct 2010 10:25:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH/RFC v3 06/11] v4l: Create v4l2 subdev file handle structure
Date: Tue,  5 Oct 2010 16:25:09 +0200
Message-Id: <1286288714-16506-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1286288714-16506-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1286288714-16506-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Stanimir Varbanov <svarbanov@mm-sol.com>

Used for storing subdev information per file handle and hold V4L2 file
handle.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Signed-off-by: Antti Koskipaa <antti.koskipaa@nokia.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/v4l2-subdev.c |   81 ++++++++++++++++++++++++------------
 include/media/v4l2-subdev.h       |   25 +++++++++++
 2 files changed, 79 insertions(+), 27 deletions(-)

diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index 731dc12..3d08750 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -30,38 +30,65 @@
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
 
+static int subdev_fh_init(struct v4l2_subdev_fh *fh, struct v4l2_subdev *sd)
+{
+	/* Allocate try format and crop in the same memory block */
+	fh->try_fmt = kzalloc((sizeof(*fh->try_fmt) + sizeof(*fh->try_crop))
+			      * sd->entity.num_pads, GFP_KERNEL);
+	if (fh->try_fmt == NULL)
+		return -ENOMEM;
+
+	fh->try_crop = (struct v4l2_rect *)
+		(fh->try_fmt + sd->entity.num_pads);
+
+	return 0;
+}
+
+static void subdev_fh_free(struct v4l2_subdev_fh *fh)
+{
+	kfree(fh->try_fmt);
+	fh->try_fmt = NULL;
+	fh->try_crop = NULL;
+}
+
 static int subdev_open(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
+	struct v4l2_subdev_fh *subdev_fh;
 	struct media_entity *entity;
-	struct v4l2_fh *vfh = NULL;
 	int ret;
 
 	if (!sd->initialized)
 		return -EAGAIN;
 
-	if (sd->flags & V4L2_SUBDEV_FL_HAS_EVENTS) {
-		vfh = kzalloc(sizeof(*vfh), GFP_KERNEL);
-		if (vfh == NULL)
-			return -ENOMEM;
+	subdev_fh = kzalloc(sizeof(*subdev_fh), GFP_KERNEL);
+	if (subdev_fh == NULL)
+		return -ENOMEM;
 
-		ret = v4l2_fh_init(vfh, vdev);
-		if (ret)
-			goto err;
+	ret = subdev_fh_init(subdev_fh, sd);
+	if (ret) {
+		kfree(subdev_fh);
+		return ret;
+	}
+
+	ret = v4l2_fh_init(&subdev_fh->vfh, vdev);
+	if (ret)
+		goto err;
 
-		ret = v4l2_event_init(vfh);
+	if (sd->flags & V4L2_SUBDEV_FL_HAS_EVENTS) {
+		ret = v4l2_event_init(&subdev_fh->vfh);
 		if (ret)
 			goto err;
 
-		ret = v4l2_event_alloc(vfh, sd->nevents);
+		ret = v4l2_event_alloc(&subdev_fh->vfh, sd->nevents);
 		if (ret)
 			goto err;
-
-		v4l2_fh_add(vfh);
-		file->private_data = vfh;
 	}
 
+	v4l2_fh_add(&subdev_fh->vfh);
+	file->private_data = &subdev_fh->vfh;
+
 	if (sd->v4l2_dev->mdev) {
 		entity = media_entity_get(&sd->entity);
 		if (!entity) {
@@ -73,11 +100,10 @@ static int subdev_open(struct file *file)
 	return 0;
 
 err:
-	if (vfh != NULL) {
-		v4l2_fh_del(vfh);
-		v4l2_fh_exit(vfh);
-		kfree(vfh);
-	}
+	v4l2_fh_del(&subdev_fh->vfh);
+	v4l2_fh_exit(&subdev_fh->vfh);
+	subdev_fh_free(subdev_fh);
+	kfree(subdev_fh);
 
 	return ret;
 }
@@ -87,15 +113,16 @@ static int subdev_close(struct file *file)
 	struct video_device *vdev = video_devdata(file);
 	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
 	struct v4l2_fh *vfh = file->private_data;
+	struct v4l2_subdev_fh *subdev_fh = to_v4l2_subdev_fh(vfh);
 
 	if (sd->v4l2_dev->mdev)
 		media_entity_put(&sd->entity);
 
-	if (vfh != NULL) {
-		v4l2_fh_del(vfh);
-		v4l2_fh_exit(vfh);
-		kfree(vfh);
-	}
+	v4l2_fh_del(vfh);
+	v4l2_fh_exit(vfh);
+	subdev_fh_free(subdev_fh);
+	kfree(subdev_fh);
+	file->private_data = NULL;
 
 	return 0;
 }
@@ -104,7 +131,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
-	struct v4l2_fh *fh = file->private_data;
+	struct v4l2_fh *vfh = file->private_data;
 
 	switch (cmd) {
 	case VIDIOC_QUERYCTRL:
@@ -132,13 +159,13 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (!(sd->flags & V4L2_SUBDEV_FL_HAS_EVENTS))
 			return -ENOIOCTLCMD;
 
-		return v4l2_event_dequeue(fh, arg, file->f_flags & O_NONBLOCK);
+		return v4l2_event_dequeue(vfh, arg, file->f_flags & O_NONBLOCK);
 
 	case VIDIOC_SUBSCRIBE_EVENT:
-		return v4l2_subdev_call(sd, core, subscribe_event, fh, arg);
+		return v4l2_subdev_call(sd, core, subscribe_event, vfh, arg);
 
 	case VIDIOC_UNSUBSCRIBE_EVENT:
-		return v4l2_subdev_call(sd, core, unsubscribe_event, fh, arg);
+		return v4l2_subdev_call(sd, core, unsubscribe_event, vfh, arg);
 
 	default:
 		return -ENOIOCTLCMD;
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 57ef74f..f4d489a 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -24,6 +24,7 @@
 #include <media/media-entity.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
+#include <media/v4l2-fh.h>
 #include <media/v4l2-mediabus.h>
 
 /* generic v4l2_device notify callback notification values */
@@ -469,6 +470,30 @@ struct v4l2_subdev {
 #define vdev_to_v4l2_subdev(vdev) \
 	container_of(vdev, struct v4l2_subdev, devnode)
 
+/*
+ * Used for storing subdev information per file handle
+ */
+struct v4l2_subdev_fh {
+	struct v4l2_fh vfh;
+	struct v4l2_mbus_framefmt *try_fmt;
+	struct v4l2_rect *try_crop;
+};
+
+#define to_v4l2_subdev_fh(fh)	\
+	container_of(fh, struct v4l2_subdev_fh, vfh)
+
+static inline struct v4l2_mbus_framefmt *
+v4l2_subdev_get_try_format(struct v4l2_subdev_fh *fh, unsigned int pad)
+{
+	return &fh->try_fmt[pad];
+}
+
+static inline struct v4l2_rect *
+v4l2_subdev_get_try_crop(struct v4l2_subdev_fh *fh, unsigned int pad)
+{
+	return &fh->try_crop[pad];
+}
+
 extern const struct v4l2_file_operations v4l2_subdev_fops;
 
 static inline void v4l2_set_subdevdata(struct v4l2_subdev *sd, void *p)
-- 
1.7.2.2

