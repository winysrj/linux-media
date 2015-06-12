Return-Path: <ricardo.ribalda@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>,
 Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [RFC v2 01/27] media/v4l2-core: Add argument def_value to g_ext_ctrl
Date: Fri, 12 Jun 2015 15:11:55 +0200
Message-id: <1434114742-7420-2-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1434114742-7420-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1434114742-7420-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-version: 1.0
Content-type: text/plain
List-ID: <linux-media.vger.kernel.org>

If def_value is set, the default value for the controls is returned.

Helper function def_to_user is also added with the same interface as
cur_to_user or new_to_user.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/platform/omap3isp/ispvideo.c |  2 +-
 drivers/media/v4l2-core/v4l2-ctrls.c       | 25 ++++++++++++++++++++-----
 drivers/media/v4l2-core/v4l2-ioctl.c       |  4 ++--
 drivers/media/v4l2-core/v4l2-subdev.c      |  2 +-
 include/media/v4l2-ctrls.h                 |  3 ++-
 5 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index d285af18df7f..cdcc51ff6fa7 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -941,7 +941,7 @@ static int isp_video_check_external_subdevs(struct isp_video *video,
 	ctrls.count = 1;
 	ctrls.controls = &ctrl;
 
-	ret = v4l2_g_ext_ctrls(pipe->external->ctrl_handler, &ctrls);
+	ret = v4l2_g_ext_ctrls(pipe->external->ctrl_handler, &ctrls, false);
 	if (ret < 0) {
 		dev_warn(isp->dev, "no pixel rate control in subdev %s\n",
 			 pipe->external->name);
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index b6b7dcc1b77d..02ff6f573fd2 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1489,6 +1489,17 @@ static int new_to_user(struct v4l2_ext_control *c,
 	return ptr_to_user(c, ctrl, ctrl->p_new);
 }
 
+/* Helper function: copy the initial control value back to the caller */
+static int def_to_user(struct v4l2_ext_control *c, struct v4l2_ctrl *ctrl)
+{
+	int idx;
+
+	for (idx = 0; idx < ctrl->elems; idx++)
+		ctrl->type_ops->init(ctrl, idx, ctrl->p_new);
+
+	return ptr_to_user(c, ctrl, ctrl->p_new);
+}
+
 /* Helper function: copy the caller-provider value to the given control value */
 static int user_to_ptr(struct v4l2_ext_control *c,
 		       struct v4l2_ctrl *ctrl,
@@ -2795,7 +2806,8 @@ static int class_check(struct v4l2_ctrl_handler *hdl, u32 ctrl_class)
 
 
 /* Get extended controls. Allocates the helpers array if needed. */
-int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs)
+int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl,
+		     struct v4l2_ext_controls *cs, bool def_value)
 {
 	struct v4l2_ctrl_helper helper[4];
 	struct v4l2_ctrl_helper *helpers = helper;
@@ -2827,9 +2839,11 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 
 	for (i = 0; !ret && i < cs->count; i++) {
 		int (*ctrl_to_user)(struct v4l2_ext_control *c,
-				    struct v4l2_ctrl *ctrl) = cur_to_user;
+				    struct v4l2_ctrl *ctrl);
 		struct v4l2_ctrl *master;
 
+		ctrl_to_user = def_value ? def_to_user : cur_to_user;
+
 		if (helpers[i].mref == NULL)
 			continue;
 
@@ -2839,8 +2853,9 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 		v4l2_ctrl_lock(master);
 
 		/* g_volatile_ctrl will update the new control values */
-		if ((master->flags & V4L2_CTRL_FLAG_VOLATILE) ||
-			(master->has_volatiles && !is_cur_manual(master))) {
+		if (!def_value &&
+		    ((master->flags & V4L2_CTRL_FLAG_VOLATILE) ||
+		    (master->has_volatiles && !is_cur_manual(master)))) {
 			for (j = 0; j < master->ncontrols; j++)
 				cur_to_new(master->cluster[j]);
 			ret = call_op(master, g_volatile_ctrl);
@@ -2869,7 +2884,7 @@ EXPORT_SYMBOL(v4l2_g_ext_ctrls);
 
 int v4l2_subdev_g_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs)
 {
-	return v4l2_g_ext_ctrls(sd->ctrl_handler, cs);
+	return v4l2_g_ext_ctrls(sd->ctrl_handler, cs, false);
 }
 EXPORT_SYMBOL(v4l2_subdev_g_ext_ctrls);
 
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 85de4557f696..a675ccc8f27a 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1982,9 +1982,9 @@ static int v4l_g_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 
 	p->error_idx = p->count;
 	if (vfh && vfh->ctrl_handler)
-		return v4l2_g_ext_ctrls(vfh->ctrl_handler, p);
+		return v4l2_g_ext_ctrls(vfh->ctrl_handler, p, false);
 	if (vfd->ctrl_handler)
-		return v4l2_g_ext_ctrls(vfd->ctrl_handler, p);
+		return v4l2_g_ext_ctrls(vfd->ctrl_handler, p, false);
 	if (ops->vidioc_g_ext_ctrls == NULL)
 		return -ENOTTY;
 	return check_ext_ctrls(p, 0) ? ops->vidioc_g_ext_ctrls(file, fh, p) :
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 63596063b213..90ed61e6df34 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -203,7 +203,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		return v4l2_s_ctrl(vfh, vfh->ctrl_handler, arg);
 
 	case VIDIOC_G_EXT_CTRLS:
-		return v4l2_g_ext_ctrls(vfh->ctrl_handler, arg);
+		return v4l2_g_ext_ctrls(vfh->ctrl_handler, arg, false);
 
 	case VIDIOC_S_EXT_CTRLS:
 		return v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, arg);
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 911f3e542834..16f16b67181b 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -812,7 +812,8 @@ int v4l2_querymenu(struct v4l2_ctrl_handler *hdl, struct v4l2_querymenu *qm);
 int v4l2_g_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_control *ctrl);
 int v4l2_s_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 						struct v4l2_control *ctrl);
-int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *c);
+int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *c,
+		     bool def_value);
 int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *c);
 int v4l2_s_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 						struct v4l2_ext_controls *c);
-- 
2.1.4
