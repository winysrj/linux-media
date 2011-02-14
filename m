Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58186 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab1BNMV1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:21:27 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v7 06/11] v4l: subdev: Add new file operations
Date: Mon, 14 Feb 2011 13:21:19 +0100
Message-Id: <1297686084-9715-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1297686084-9715-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1297686084-9715-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

V4L2 sub-devices store pad formats and crop settings in the file handle.
To let drivers initialize those settings properly, add an open operation
that is called when the subdev is opened as well as a corresponding
close operation.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/v4l2-subdev.c |   16 +++++++++++++---
 include/media/v4l2-subdev.h       |    7 +++++++
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index ebf7f97..cee7993 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -61,7 +61,7 @@ static int subdev_open(struct file *file)
 	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
 	struct v4l2_subdev_fh *subdev_fh;
 #if defined(CONFIG_MEDIA_CONTROLLER)
-	struct media_entity *entity;
+	struct media_entity *entity = NULL;
 #endif
 	int ret;
 
@@ -101,9 +101,19 @@ static int subdev_open(struct file *file)
 	}
 #endif
 
+	if (sd->internal_ops && sd->internal_ops->open) {
+		ret = sd->internal_ops->open(sd, subdev_fh);
+		if (ret < 0)
+			goto err;
+	}
+
 	return 0;
 
 err:
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	if (entity)
+		media_entity_put(entity);
+#endif
 	v4l2_fh_del(&subdev_fh->vfh);
 	v4l2_fh_exit(&subdev_fh->vfh);
 	subdev_fh_free(subdev_fh);
@@ -114,13 +124,13 @@ err:
 
 static int subdev_close(struct file *file)
 {
-#if defined(CONFIG_MEDIA_CONTROLLER)
 	struct video_device *vdev = video_devdata(file);
 	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
-#endif
 	struct v4l2_fh *vfh = file->private_data;
 	struct v4l2_subdev_fh *subdev_fh = to_v4l2_subdev_fh(vfh);
 
+	if (sd->internal_ops && sd->internal_ops->close)
+		sd->internal_ops->close(sd, subdev_fh);
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	if (sd->v4l2_dev->mdev)
 		media_entity_put(&sd->entity);
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index d64438d..ff42cc4 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -42,6 +42,7 @@ struct v4l2_ctrl_handler;
 struct v4l2_event_subscription;
 struct v4l2_fh;
 struct v4l2_subdev;
+struct v4l2_subdev_fh;
 struct tuner_setup;
 
 /* decode_vbi_line */
@@ -429,10 +430,16 @@ struct v4l2_subdev_ops {
  *
  * unregistered: called when this subdev is unregistered. When called the
  *	v4l2_dev field is still set to the correct v4l2_device.
+ *
+ * open: called when the subdev device node is opened by an application.
+ *
+ * close: called when the subdev device node is closed.
  */
 struct v4l2_subdev_internal_ops {
 	int (*registered)(struct v4l2_subdev *sd);
 	void (*unregistered)(struct v4l2_subdev *sd);
+	int (*open)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh);
+	int (*close)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh);
 };
 
 #define V4L2_SUBDEV_NAME_SIZE 32
-- 
1.7.3.4

