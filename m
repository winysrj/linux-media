Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4583 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932580Ab1EYNeQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 09:34:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 05/11] v4l2-ctrls: add v4l2_fh pointer to the set control functions.
Date: Wed, 25 May 2011 15:33:49 +0200
Message-Id: <f3f32913df4962bdb541abe87348e561c5e6d325.1306329390.git.hans.verkuil@cisco.com>
In-Reply-To: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl>
References: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <6cea502820c1684f34b9e862a64be2972afb718f.1306329390.git.hans.verkuil@cisco.com>
References: <6cea502820c1684f34b9e862a64be2972afb718f.1306329390.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

When an application changes a control you want to generate an event.
However, you want to avoid sending such an event back to the application
(file handle) that caused the change.

Add the filehandle to the various set control functions.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ctrls.c  |   45 ++++++++++++++++++++----------------
 drivers/media/video/v4l2-ioctl.c  |    8 +++---
 drivers/media/video/v4l2-subdev.c |    4 +-
 include/media/v4l2-ctrls.h        |    8 ++++--
 4 files changed, 36 insertions(+), 29 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index d895048..3e0d8ab 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -627,7 +627,7 @@ static int new_to_user(struct v4l2_ext_control *c,
 }
 
 /* Copy the new value to the current value. */
-static void new_to_cur(struct v4l2_ctrl *ctrl)
+static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl)
 {
 	if (ctrl == NULL)
 		return;
@@ -1639,7 +1639,8 @@ EXPORT_SYMBOL(v4l2_ctrl_g_ctrl);
 /* Core function that calls try/s_ctrl and ensures that the new value is
    copied to the current value on a set.
    Must be called with ctrl->handler->lock held. */
-static int try_or_set_control_cluster(struct v4l2_ctrl *master, bool set)
+static int try_or_set_control_cluster(struct v4l2_fh *fh,
+					struct v4l2_ctrl *master, bool set)
 {
 	bool try = !set;
 	int ret = 0;
@@ -1680,7 +1681,7 @@ static int try_or_set_control_cluster(struct v4l2_ctrl *master, bool set)
 		/* If OK, then make the new values permanent. */
 		if (!ret)
 			for (i = 0; i < master->ncontrols; i++)
-				new_to_cur(master->cluster[i]);
+				new_to_cur(fh, master->cluster[i]);
 	}
 	return ret;
 }
@@ -1705,7 +1706,8 @@ static int check_flags_cluster(struct v4l2_ctrl *master)
 }
 
 /* Try or set controls. */
-static int try_or_set_ext_ctrls(struct v4l2_ctrl_handler *hdl,
+static int try_or_set_ext_ctrls(struct v4l2_fh *fh,
+				struct v4l2_ctrl_handler *hdl,
 				struct v4l2_ext_controls *cs,
 				struct ctrl_helper *helpers,
 				bool set)
@@ -1755,7 +1757,7 @@ static int try_or_set_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 			ret = check_flags_cluster(master);
 
 		if (!ret)
-			ret = try_or_set_control_cluster(master, set);
+			ret = try_or_set_control_cluster(fh, master, set);
 
 		/* Copy the new values back to userspace. */
 		if (!ret)
@@ -1768,7 +1770,7 @@ static int try_or_set_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 }
 
 /* Try or try-and-set controls */
-static int try_set_ext_ctrls(struct v4l2_ctrl_handler *hdl,
+static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 			     struct v4l2_ext_controls *cs,
 			     bool set)
 {
@@ -1796,7 +1798,7 @@ static int try_set_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 		goto free;
 
 	/* First 'try' all controls and abort on error */
-	ret = try_or_set_ext_ctrls(hdl, cs, helpers, false);
+	ret = try_or_set_ext_ctrls(NULL, hdl, cs, helpers, false);
 	/* If this is a 'set' operation and the initial 'try' failed,
 	   then set error_idx to count to tell the application that no
 	   controls changed value yet. */
@@ -1806,7 +1808,7 @@ static int try_set_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 		/* Reset 'handled' state */
 		for (i = 0; i < cs->count; i++)
 			helpers[i].handled = false;
-		ret = try_or_set_ext_ctrls(hdl, cs, helpers, true);
+		ret = try_or_set_ext_ctrls(fh, hdl, cs, helpers, true);
 	}
 
 free:
@@ -1817,30 +1819,32 @@ free:
 
 int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs)
 {
-	return try_set_ext_ctrls(hdl, cs, false);
+	return try_set_ext_ctrls(NULL, hdl, cs, false);
 }
 EXPORT_SYMBOL(v4l2_try_ext_ctrls);
 
-int v4l2_s_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs)
+int v4l2_s_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
+						struct v4l2_ext_controls *cs)
 {
-	return try_set_ext_ctrls(hdl, cs, true);
+	return try_set_ext_ctrls(fh, hdl, cs, true);
 }
 EXPORT_SYMBOL(v4l2_s_ext_ctrls);
 
 int v4l2_subdev_try_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs)
 {
-	return try_set_ext_ctrls(sd->ctrl_handler, cs, false);
+	return try_set_ext_ctrls(NULL, sd->ctrl_handler, cs, false);
 }
 EXPORT_SYMBOL(v4l2_subdev_try_ext_ctrls);
 
 int v4l2_subdev_s_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs)
 {
-	return try_set_ext_ctrls(sd->ctrl_handler, cs, true);
+	return try_set_ext_ctrls(NULL, sd->ctrl_handler, cs, true);
 }
 EXPORT_SYMBOL(v4l2_subdev_s_ext_ctrls);
 
 /* Helper function for VIDIOC_S_CTRL compatibility */
-static int set_ctrl(struct v4l2_ctrl *ctrl, s32 *val, bool check_flags)
+static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, s32 *val,
+							bool check_flags)
 {
 	struct v4l2_ctrl *master = ctrl->cluster[0];
 	int ret;
@@ -1855,30 +1859,31 @@ static int set_ctrl(struct v4l2_ctrl *ctrl, s32 *val, bool check_flags)
 
 	ctrl->val = *val;
 	ctrl->is_new = 1;
-	ret = try_or_set_control_cluster(master, false);
+	ret = try_or_set_control_cluster(NULL, master, false);
 	if (!ret && check_flags)
 		ret = check_flags_cluster(master);
 	if (!ret)
-		ret = try_or_set_control_cluster(master, true);
+		ret = try_or_set_control_cluster(fh, master, true);
 	*val = ctrl->cur.val;
 	v4l2_ctrl_unlock(ctrl);
 	return ret;
 }
 
-int v4l2_s_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_control *control)
+int v4l2_s_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
+					struct v4l2_control *control)
 {
 	struct v4l2_ctrl *ctrl = v4l2_ctrl_find(hdl, control->id);
 
 	if (ctrl == NULL || !type_is_int(ctrl))
 		return -EINVAL;
 
-	return set_ctrl(ctrl, &control->value, true);
+	return set_ctrl(fh, ctrl, &control->value, true);
 }
 EXPORT_SYMBOL(v4l2_s_ctrl);
 
 int v4l2_subdev_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *control)
 {
-	return v4l2_s_ctrl(sd->ctrl_handler, control);
+	return v4l2_s_ctrl(NULL, sd->ctrl_handler, control);
 }
 EXPORT_SYMBOL(v4l2_subdev_s_ctrl);
 
@@ -1890,6 +1895,6 @@ int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
 	/* This function is called from within a driver. That means that the
 	   checks for READ_ONLY and GRABBED should be skipped. Those flags
 	   apply to userspace, but not to driver code. */
-	return set_ctrl(ctrl, &val, false);
+	return set_ctrl(NULL, ctrl, &val, false);
 }
 EXPORT_SYMBOL(v4l2_ctrl_s_ctrl);
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 75d475c..660b486 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1481,11 +1481,11 @@ static long __video_do_ioctl(struct file *file,
 		dbgarg(cmd, "id=0x%x, value=%d\n", p->id, p->value);
 
 		if (vfh && vfh->ctrl_handler) {
-			ret = v4l2_s_ctrl(vfh->ctrl_handler, p);
+			ret = v4l2_s_ctrl(vfh, vfh->ctrl_handler, p);
 			break;
 		}
 		if (vfd->ctrl_handler) {
-			ret = v4l2_s_ctrl(vfd->ctrl_handler, p);
+			ret = v4l2_s_ctrl(NULL, vfd->ctrl_handler, p);
 			break;
 		}
 		if (ops->vidioc_s_ctrl) {
@@ -1530,9 +1530,9 @@ static long __video_do_ioctl(struct file *file,
 			break;
 		v4l_print_ext_ctrls(cmd, vfd, p, 1);
 		if (vfh && vfh->ctrl_handler)
-			ret = v4l2_s_ext_ctrls(vfh->ctrl_handler, p);
+			ret = v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, p);
 		else if (vfd->ctrl_handler)
-			ret = v4l2_s_ext_ctrls(vfd->ctrl_handler, p);
+			ret = v4l2_s_ext_ctrls(NULL, vfd->ctrl_handler, p);
 		else if (check_ext_ctrls(p, 0))
 			ret = ops->vidioc_s_ext_ctrls(file, fh, p);
 		break;
diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index 812729e..be4cbdd 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -164,13 +164,13 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		return v4l2_g_ctrl(sd->ctrl_handler, arg);
 
 	case VIDIOC_S_CTRL:
-		return v4l2_s_ctrl(sd->ctrl_handler, arg);
+		return v4l2_s_ctrl(vfh, sd->ctrl_handler, arg);
 
 	case VIDIOC_G_EXT_CTRLS:
 		return v4l2_g_ext_ctrls(sd->ctrl_handler, arg);
 
 	case VIDIOC_S_EXT_CTRLS:
-		return v4l2_s_ext_ctrls(sd->ctrl_handler, arg);
+		return v4l2_s_ext_ctrls(vfh, sd->ctrl_handler, arg);
 
 	case VIDIOC_TRY_EXT_CTRLS:
 		return v4l2_try_ext_ctrls(sd->ctrl_handler, arg);
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 0f5004b..151bd2e 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -28,6 +28,7 @@
 /* forward references */
 struct v4l2_ctrl_handler;
 struct v4l2_ctrl;
+struct v4l2_fh;
 struct video_device;
 struct v4l2_subdev;
 
@@ -436,15 +437,16 @@ s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl);
   */
 int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val);
 
-
 /* Helpers for ioctl_ops. If hdl == NULL then they will all return -EINVAL. */
 int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc);
 int v4l2_querymenu(struct v4l2_ctrl_handler *hdl, struct v4l2_querymenu *qm);
 int v4l2_g_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_control *ctrl);
-int v4l2_s_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_control *ctrl);
+int v4l2_s_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
+						struct v4l2_control *ctrl);
 int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *c);
 int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *c);
-int v4l2_s_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *c);
+int v4l2_s_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
+						struct v4l2_ext_controls *c);
 
 /* Helpers for subdevices. If the associated ctrl_handler == NULL then they
    will all return -EINVAL. */
-- 
1.7.1

