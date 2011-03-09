Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53083 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab1CIV1A (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 16:27:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, jaeryul.oh@samsung.com
Subject: [PATCH/RFC 1/2] v4l: subdev: Move file handle support to drivers
Date: Wed,  9 Mar 2011 22:27:20 +0100
Message-Id: <1299706041-21589-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1299706041-21589-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1299706041-21589-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Drivers sometimes need to embed the v4l2_subdev_fh structure into a
higher level driver-specific structure. As the v4l2_subdev_fh structure
is allocated by subdev core, this isn't possible.

Fix the problem by moving allocation and free of the structure to the
subdevices. Two helper functions v4l2_subdev_fh_open() and
v4l2_subdev_fh_close() can be used to fill the subdev file operations by
drivers that don't need to perform any specific operation in their open
and close handlers.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/v4l2-subdev.c |  126 ++++++++++++++++++++-----------------
 include/media/v4l2-subdev.h       |    5 ++
 2 files changed, 72 insertions(+), 59 deletions(-)

diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index 0b80644..5f23c9f 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -31,8 +31,10 @@
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
 
-static int subdev_fh_init(struct v4l2_subdev_fh *fh, struct v4l2_subdev *sd)
+int v4l2_subdev_fh_init(struct v4l2_subdev_fh *fh, struct v4l2_subdev *sd)
 {
+	int ret;
+
 #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 	/* Allocate try format and crop in the same memory block */
 	fh->try_fmt = kzalloc((sizeof(*fh->try_fmt) + sizeof(*fh->try_crop))
@@ -43,104 +45,110 @@ static int subdev_fh_init(struct v4l2_subdev_fh *fh, struct v4l2_subdev *sd)
 	fh->try_crop = (struct v4l2_rect *)
 		(fh->try_fmt + sd->entity.num_pads);
 #endif
+
+	ret = v4l2_fh_init(&fh->vfh, &sd->devnode);
+	if (ret)
+		goto error;
+
+	if (sd->flags & V4L2_SUBDEV_FL_HAS_EVENTS) {
+		ret = v4l2_event_init(&fh->vfh);
+		if (ret)
+			goto error;
+
+		ret = v4l2_event_alloc(&fh->vfh, sd->nevents);
+		if (ret)
+			goto error;
+	}
+
+	v4l2_fh_add(&fh->vfh);
 	return 0;
+
+error:
+	v4l2_subdev_fh_exit(fh);
+	return ret;
 }
+EXPORT_SYMBOL_GPL(v4l2_subdev_fh_init);
 
-static void subdev_fh_free(struct v4l2_subdev_fh *fh)
+void v4l2_subdev_fh_exit(struct v4l2_subdev_fh *fh)
 {
+	v4l2_fh_del(&fh->vfh);
+	v4l2_fh_exit(&fh->vfh);
 #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 	kfree(fh->try_fmt);
 	fh->try_fmt = NULL;
 	fh->try_crop = NULL;
 #endif
 }
+EXPORT_SYMBOL_GPL(v4l2_subdev_fh_exit);
 
-static int subdev_open(struct file *file)
+int v4l2_subdev_fh_open(struct v4l2_subdev *sd, struct file *file)
 {
-	struct video_device *vdev = video_devdata(file);
-	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
-	struct v4l2_subdev_fh *subdev_fh;
-#if defined(CONFIG_MEDIA_CONTROLLER)
-	struct media_entity *entity = NULL;
-#endif
+	struct v4l2_subdev_fh *fh;
 	int ret;
 
-	subdev_fh = kzalloc(sizeof(*subdev_fh), GFP_KERNEL);
-	if (subdev_fh == NULL)
+	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
+	if (fh == NULL)
 		return -ENOMEM;
 
-	ret = subdev_fh_init(subdev_fh, sd);
-	if (ret) {
-		kfree(subdev_fh);
-		return ret;
-	}
+	ret = v4l2_subdev_fh_init(fh, sd);
+	if (ret < 0)
+		goto error;
 
-	ret = v4l2_fh_init(&subdev_fh->vfh, vdev);
-	if (ret)
-		goto err;
+	file->private_data = &fh->vfh;
+	return 0;
 
-	if (sd->flags & V4L2_SUBDEV_FL_HAS_EVENTS) {
-		ret = v4l2_event_init(&subdev_fh->vfh);
-		if (ret)
-			goto err;
+error:
+	v4l2_subdev_fh_exit(fh);
+	kfree(fh);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(v4l2_subdev_fh_open);
 
-		ret = v4l2_event_alloc(&subdev_fh->vfh, sd->nevents);
-		if (ret)
-			goto err;
-	}
+int v4l2_subdev_fh_close(struct v4l2_subdev *sd, struct file *file)
+{
+	struct v4l2_subdev_fh *fh = to_v4l2_subdev_fh(file->private_data);
+
+	v4l2_subdev_fh_exit(fh);
+	kfree(fh);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_subdev_fh_close);
+
+static int subdev_open(struct file *file)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
+	int ret;
 
-	v4l2_fh_add(&subdev_fh->vfh);
-	file->private_data = &subdev_fh->vfh;
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	if (sd->v4l2_dev->mdev) {
-		entity = media_entity_get(&sd->entity);
-		if (!entity) {
-			ret = -EBUSY;
-			goto err;
-		}
+		if (!media_entity_get(&sd->entity))
+			return -EBUSY;
 	}
 #endif
-
 	if (sd->internal_ops && sd->internal_ops->open) {
-		ret = sd->internal_ops->open(sd, subdev_fh);
-		if (ret < 0)
-			goto err;
+		ret = sd->internal_ops->open(sd, file);
+		if (ret < 0) {
+			media_entity_put(&sd->entity);
+			return ret;
+		}
 	}
 
 	return 0;
-
-err:
-#if defined(CONFIG_MEDIA_CONTROLLER)
-	if (entity)
-		media_entity_put(entity);
-#endif
-	v4l2_fh_del(&subdev_fh->vfh);
-	v4l2_fh_exit(&subdev_fh->vfh);
-	subdev_fh_free(subdev_fh);
-	kfree(subdev_fh);
-
-	return ret;
 }
 
 static int subdev_close(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
-	struct v4l2_fh *vfh = file->private_data;
-	struct v4l2_subdev_fh *subdev_fh = to_v4l2_subdev_fh(vfh);
 
 	if (sd->internal_ops && sd->internal_ops->close)
-		sd->internal_ops->close(sd, subdev_fh);
+		sd->internal_ops->close(sd, file);
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	if (sd->v4l2_dev->mdev)
 		media_entity_put(&sd->entity);
 #endif
-	v4l2_fh_del(vfh);
-	v4l2_fh_exit(vfh);
-	subdev_fh_free(subdev_fh);
-	kfree(subdev_fh);
-	file->private_data = NULL;
-
 	return 0;
 }
 
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 1562c4f..4671459 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -571,6 +571,11 @@ static inline void *v4l2_get_subdev_hostdata(const struct v4l2_subdev *sd)
 void v4l2_subdev_init(struct v4l2_subdev *sd,
 		      const struct v4l2_subdev_ops *ops);
 
+int v4l2_subdev_fh_init(struct v4l2_subdev_fh *fh, struct v4l2_subdev *sd);
+void v4l2_subdev_fh_exit(struct v4l2_subdev_fh *fh);
+int v4l2_subdev_fh_open(struct v4l2_subdev *sd, struct file *file);
+int v4l2_subdev_fh_close(struct v4l2_subdev *sd, struct file *file);
+
 /* Call an ops of a v4l2_subdev, doing the right checks against
    NULL pointers.
 
-- 
1.7.3.4

