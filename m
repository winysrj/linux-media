Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4924 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569Ab1EYNeP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 09:34:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 02/11] v4l2-ctrls: drivers should be able to ignore READ_ONLY and GRABBED flags
Date: Wed, 25 May 2011 15:33:46 +0200
Message-Id: <d7dbb8b185ccd1a6268213d9c05154f6d972a696.1306329390.git.hans.verkuil@cisco.com>
In-Reply-To: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl>
References: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <6cea502820c1684f34b9e862a64be2972afb718f.1306329390.git.hans.verkuil@cisco.com>
References: <6cea502820c1684f34b9e862a64be2972afb718f.1306329390.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

When applications try to set READ_ONLY or GRABBED controls an error should
be returned. However, when drivers do that it should be accepted.

Those controls could reflect some driver status which the application
can't change but the driver obviously has to be able to change it.

This is needed among others for future HDMI status controls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ctrls.c |   59 +++++++++++++++++++++++++-------------
 1 files changed, 39 insertions(+), 20 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 8b5f67f..2afd632 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -1673,11 +1673,6 @@ static int try_or_set_control_cluster(struct v4l2_ctrl *master, bool set)
 			continue;
 
 		if (ctrl->is_new) {
-			/* Double check this: it may have changed since the
-			   last check in try_or_set_ext_ctrls(). */
-			if (set && (ctrl->flags & V4L2_CTRL_FLAG_GRABBED))
-				return -EBUSY;
-
 			/* Validate if required */
 			if (!set)
 				ret = validate_new(ctrl);
@@ -1707,6 +1702,25 @@ static int try_or_set_control_cluster(struct v4l2_ctrl *master, bool set)
 	return ret;
 }
 
+/* Check if the flags allow you to set the modified controls. */
+static int check_flags_cluster(struct v4l2_ctrl *master)
+{
+	int i;
+
+	for (i = 0; i < master->ncontrols; i++) {
+		struct v4l2_ctrl *ctrl = master->cluster[i];
+
+		if (ctrl == NULL || !ctrl->is_new)
+			continue;
+
+		if (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY)
+			return -EACCES;
+		if (ctrl->flags & V4L2_CTRL_FLAG_GRABBED)
+			return -EBUSY;
+	}
+	return 0;
+}
+
 /* Try or set controls. */
 static int try_or_set_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 				struct v4l2_ext_controls *cs,
@@ -1716,24 +1730,23 @@ static int try_or_set_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 	unsigned i, j;
 	int ret = 0;
 
-	cs->error_idx = cs->count;
 	for (i = 0; i < cs->count; i++) {
 		struct v4l2_ctrl *ctrl = helpers[i].ctrl;
 
-		if (!set)
-			cs->error_idx = i;
+		cs->error_idx = i;
 
+		/* These tests are also done later in check_flags_cluster()
+		   which is called in atomic context, so that has the
+		   final say, but it makes sense to do an up-front
+		   check as well. Once an error occurs below some other
+		   controls may have been set already and we want to
+		   do a best-effort to avoid that. */
 		if (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY)
 			return -EACCES;
-		/* This test is also done in try_set_control_cluster() which
-		   is called in atomic context, so that has the final say,
-		   but it makes sense to do an up-front check as well. Once
-		   an error occurs in try_set_control_cluster() some other
-		   controls may have been set already and we want to do a
-		   best-effort to avoid that. */
 		if (set && (ctrl->flags & V4L2_CTRL_FLAG_GRABBED))
 			return -EBUSY;
 	}
+	cs->error_idx = cs->count;
 
 	for (i = 0; !ret && i < cs->count; i++) {
 		struct v4l2_ctrl *ctrl = helpers[i].ctrl;
@@ -1755,6 +1768,9 @@ static int try_or_set_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 		   user_to_new() sets 'is_new' to 1. */
 		ret = cluster_walk(i, cs, helpers, user_to_new);
 
+		if (!ret && set)
+			ret = check_flags_cluster(master);
+
 		if (!ret)
 			ret = try_or_set_control_cluster(master, set);
 
@@ -1841,15 +1857,12 @@ int v4l2_subdev_s_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs
 EXPORT_SYMBOL(v4l2_subdev_s_ext_ctrls);
 
 /* Helper function for VIDIOC_S_CTRL compatibility */
-static int set_ctrl(struct v4l2_ctrl *ctrl, s32 *val)
+static int set_ctrl(struct v4l2_ctrl *ctrl, s32 *val, bool check_flags)
 {
 	struct v4l2_ctrl *master = ctrl->cluster[0];
 	int ret;
 	int i;
 
-	if (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY)
-		return -EACCES;
-
 	v4l2_ctrl_lock(ctrl);
 
 	/* Reset the 'is_new' flags of the cluster */
@@ -1860,6 +1873,8 @@ static int set_ctrl(struct v4l2_ctrl *ctrl, s32 *val)
 	ctrl->val = *val;
 	ctrl->is_new = 1;
 	ret = try_or_set_control_cluster(master, false);
+	if (!ret && check_flags)
+		ret = check_flags_cluster(master);
 	if (!ret)
 		ret = try_or_set_control_cluster(master, true);
 	*val = ctrl->cur.val;
@@ -1874,7 +1889,7 @@ int v4l2_s_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_control *control)
 	if (ctrl == NULL || !type_is_int(ctrl))
 		return -EINVAL;
 
-	return set_ctrl(ctrl, &control->value);
+	return set_ctrl(ctrl, &control->value, true);
 }
 EXPORT_SYMBOL(v4l2_s_ctrl);
 
@@ -1888,6 +1903,10 @@ int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
 {
 	/* It's a driver bug if this happens. */
 	WARN_ON(!type_is_int(ctrl));
-	return set_ctrl(ctrl, &val);
+
+	/* This function is called from within a driver. That means that the
+	   checks for READ_ONLY and GRABBED should be skipped. Those flags
+	   apply to userspace, but not to driver code. */
+	return set_ctrl(ctrl, &val, false);
 }
 EXPORT_SYMBOL(v4l2_ctrl_s_ctrl);
-- 
1.7.1

