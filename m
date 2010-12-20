Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51301 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab0LTLhf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Dec 2010 06:37:35 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v5 08/13] v4l: subdev: Add a new file operations class
Date: Mon, 20 Dec 2010 12:37:20 +0100
Message-Id: <1292845045-7945-9-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1292845045-7945-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1292845045-7945-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

V4L2 sub-devices store pad formats and crop settings in the file handle.
To let drivers initialize those settings properly, add a file::open
operation that is called when the subdev is opened as well as a
corresponding file::close operation.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/v4l2-subdev.c |   11 ++++++++++-
 include/media/v4l2-subdev.h       |   10 ++++++++++
 2 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index d389b44..de10a1d 100644
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
 
@@ -104,9 +104,17 @@ static int subdev_open(struct file *file)
 	}
 #endif
 
+	ret = v4l2_subdev_call(sd, file, open, subdev_fh);
+	if (ret < 0 && ret != -ENOIOCTLCMD)
+		goto err;
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
@@ -124,6 +132,7 @@ static int subdev_close(struct file *file)
 	struct v4l2_fh *vfh = file->private_data;
 	struct v4l2_subdev_fh *subdev_fh = to_v4l2_subdev_fh(vfh);
 
+	v4l2_subdev_call(sd, file, close, subdev_fh);
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	if (sd->v4l2_dev->mdev)
 		media_entity_put(&sd->entity);
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index f8704ff..af704df 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -175,6 +175,15 @@ struct v4l2_subdev_core_ops {
 				 struct v4l2_event_subscription *sub);
 };
 
+/* open: called when the subdev device node is opened by an application.
+
+   close: called when the subdev device node is close.
+ */
+struct v4l2_subdev_file_ops {
+	int (*open)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh);
+	int (*close)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh);
+};
+
 /* s_mode: switch the tuner to a specific tuner mode. Replacement of s_radio.
 
    s_radio: v4l device was opened in Radio mode, to be replaced by s_mode.
@@ -416,6 +425,7 @@ struct v4l2_subdev_ir_ops {
 
 struct v4l2_subdev_ops {
 	const struct v4l2_subdev_core_ops	*core;
+	const struct v4l2_subdev_file_ops	*file;
 	const struct v4l2_subdev_tuner_ops	*tuner;
 	const struct v4l2_subdev_audio_ops	*audio;
 	const struct v4l2_subdev_video_ops	*video;
-- 
1.7.2.2

