Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35667 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab2GWMiK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 08:38:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2-ctrls: Add v4l2_ctrl_s_ctrl_int64()
Date: Mon, 23 Jul 2012 14:38:14 +0200
Message-Id: <1343047094-20013-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This helper function sets a 64-bit control's value from within a driver.
It's similar to v4l2_ctrl_s_ctrl() but operates on 64-bit integer
controls instead of 32-bit controls.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/v4l2-ctrls.c |   37 +++++++++++++++++++++++++++++--------
 include/media/v4l2-ctrls.h       |   12 ++++++++++++
 2 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 9abd9ab..41a58b0 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -2499,13 +2499,14 @@ int v4l2_subdev_s_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs
 EXPORT_SYMBOL(v4l2_subdev_s_ext_ctrls);
 
 /* Helper function for VIDIOC_S_CTRL compatibility */
-static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, s32 *val)
+static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
+		    struct v4l2_ext_control *c)
 {
 	struct v4l2_ctrl *master = ctrl->cluster[0];
 	int ret;
 	int i;
 
-	ret = validate_new_int(ctrl, val);
+	ret = validate_new(ctrl, c);
 	if (ret)
 		return ret;
 
@@ -2520,12 +2521,13 @@ static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, s32 *val)
 	   manual mode we have to update the current volatile values since
 	   those will become the initial manual values after such a switch. */
 	if (master->is_auto && master->has_volatiles && ctrl == master &&
-	    !is_cur_manual(master) && *val == master->manual_mode_value)
+	    !is_cur_manual(master) && c->value == master->manual_mode_value)
 		update_from_auto_cluster(master);
-	ctrl->val = *val;
-	ctrl->is_new = 1;
+
+	user_to_new(c, ctrl);
 	ret = try_or_set_cluster(fh, master, true);
-	*val = ctrl->cur.val;
+	cur_to_user(c, ctrl);
+
 	v4l2_ctrl_unlock(ctrl);
 	return ret;
 }
@@ -2534,6 +2536,8 @@ int v4l2_s_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 					struct v4l2_control *control)
 {
 	struct v4l2_ctrl *ctrl = v4l2_ctrl_find(hdl, control->id);
+	struct v4l2_ext_control c;
+	int ret;
 
 	if (ctrl == NULL || !type_is_int(ctrl))
 		return -EINVAL;
@@ -2541,7 +2545,10 @@ int v4l2_s_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 	if (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY)
 		return -EACCES;
 
-	return set_ctrl(fh, ctrl, &control->value);
+	c.value = control->value;
+	ret = set_ctrl(fh, ctrl, &c);
+	control->value = c.value;
+	return ret;
 }
 EXPORT_SYMBOL(v4l2_s_ctrl);
 
@@ -2553,12 +2560,26 @@ EXPORT_SYMBOL(v4l2_subdev_s_ctrl);
 
 int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
 {
+	struct v4l2_ext_control c;
+
 	/* It's a driver bug if this happens. */
 	WARN_ON(!type_is_int(ctrl));
-	return set_ctrl(NULL, ctrl, &val);
+	c.value = val;
+	return set_ctrl(NULL, ctrl, &c);
 }
 EXPORT_SYMBOL(v4l2_ctrl_s_ctrl);
 
+int v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val)
+{
+	struct v4l2_ext_control c;
+
+	/* It's a driver bug if this happens. */
+	WARN_ON(ctrl->type != V4L2_CTRL_TYPE_INTEGER64);
+	c.value64 = val;
+	return set_ctrl(NULL, ctrl, &c);
+}
+EXPORT_SYMBOL(v4l2_ctrl_s_ctrl_int64);
+
 static int v4l2_ctrl_add_event(struct v4l2_subscribed_event *sev, unsigned elems)
 {
 	struct v4l2_ctrl *ctrl = v4l2_ctrl_find(sev->fh->ctrl_handler, sev->id);
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 776605f..a2c200d 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -511,6 +511,18 @@ s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl);
   */
 int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val);
 
+/** v4l2_ctrl_s_ctrl_int64() - Helper function to set a 64-bit control's value from within a driver.
+  * @ctrl:	The control.
+  * @val:	The new value.
+  *
+  * This set the control's new value safely by going through the control
+  * framework. This function will lock the control's handler, so it cannot be
+  * used from within the &v4l2_ctrl_ops functions.
+  *
+  * This function is for 64-bit integer type controls only.
+  */
+int v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val);
+
 /* Internal helper functions that deal with control events. */
 extern const struct v4l2_subscribed_event_ops v4l2_ctrl_sub_ev_ops;
 void v4l2_ctrl_replace(struct v4l2_event *old, const struct v4l2_event *new);
-- 
Regards,

Laurent Pinchart

