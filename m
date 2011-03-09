Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53087 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab1CIV1B (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 16:27:01 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, jaeryul.oh@samsung.com
Subject: [PATCH/RFC 2/2] v4l: subdev: Add support for file handler control handler
Date: Wed,  9 Mar 2011 22:27:21 +0100
Message-Id: <1299706041-21589-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1299706041-21589-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1299706041-21589-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/v4l2-subdev.c |   18 +++++++++---------
 include/media/v4l2-subdev.h       |    5 +++--
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index 5f23c9f..5d3a4bd 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -157,31 +157,31 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	struct video_device *vdev = video_devdata(file);
 	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
 	struct v4l2_fh *vfh = file->private_data;
-#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 	struct v4l2_subdev_fh *subdev_fh = to_v4l2_subdev_fh(vfh);
-#endif
+	struct v4l2_ctrl_handler *ctrl_handler = subdev_fh->ctrl_handler
+		? subdev_fh->ctrl_handler : sd->ctrl_handler;
 
 	switch (cmd) {
 	case VIDIOC_QUERYCTRL:
-		return v4l2_subdev_queryctrl(sd, arg);
+		return v4l2_queryctrl(ctrl_handler, arg);
 
 	case VIDIOC_QUERYMENU:
-		return v4l2_subdev_querymenu(sd, arg);
+		return v4l2_querymenu(ctrl_handler, arg);
 
 	case VIDIOC_G_CTRL:
-		return v4l2_subdev_g_ctrl(sd, arg);
+		return v4l2_g_ctrl(ctrl_handler, arg);
 
 	case VIDIOC_S_CTRL:
-		return v4l2_subdev_s_ctrl(sd, arg);
+		return v4l2_s_ctrl(ctrl_handler, arg);
 
 	case VIDIOC_G_EXT_CTRLS:
-		return v4l2_subdev_g_ext_ctrls(sd, arg);
+		return v4l2_g_ext_ctrls(ctrl_handler, arg);
 
 	case VIDIOC_S_EXT_CTRLS:
-		return v4l2_subdev_s_ext_ctrls(sd, arg);
+		return v4l2_s_ext_ctrls(ctrl_handler, arg);
 
 	case VIDIOC_TRY_EXT_CTRLS:
-		return v4l2_subdev_try_ext_ctrls(sd, arg);
+		return v4l2_try_ext_ctrls(ctrl_handler, arg);
 
 	case VIDIOC_DQEVENT:
 		if (!(sd->flags & V4L2_SUBDEV_FL_HAS_EVENTS))
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 4671459..6229ffc 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -469,8 +469,8 @@ struct v4l2_subdev_ops {
 struct v4l2_subdev_internal_ops {
 	int (*registered)(struct v4l2_subdev *sd);
 	void (*unregistered)(struct v4l2_subdev *sd);
-	int (*open)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh);
-	int (*close)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh);
+	int (*open)(struct v4l2_subdev *sd, struct file *file);
+	int (*close)(struct v4l2_subdev *sd, struct file *file);
 };
 
 #define V4L2_SUBDEV_NAME_SIZE 32
@@ -527,6 +527,7 @@ struct v4l2_subdev_fh {
 	struct v4l2_mbus_framefmt *try_fmt;
 	struct v4l2_rect *try_crop;
 #endif
+	struct v4l2_ctrl_handler *ctrl_handler;
 };
 
 #define to_v4l2_subdev_fh(fh)	\
-- 
1.7.3.4

