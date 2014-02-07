Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2507 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393AbaBGMUO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Feb 2014 07:20:14 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: edubezval@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 6/7] v4l2-ctrls: add support for setting string controls
Date: Fri,  7 Feb 2014 13:19:39 +0100
Message-Id: <1391775580-29907-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1391775580-29907-1-git-send-email-hverkuil@xs4all.nl>
References: <1391775580-29907-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Rather than always having to use a v4l2_ext_control struct to set
a control value from within a driver, switch to just setting the
new value. This is faster and it makes it possible to set more
complex types such as a string control.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 46 ++++++++++++++++++++++++------------
 include/media/v4l2-ctrls.h           | 12 ++++++++++
 2 files changed, 43 insertions(+), 15 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 7c138b5..2aad5c6 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2786,26 +2786,22 @@ static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
 	struct v4l2_ctrl *master = ctrl->cluster[0];
 	int i;
 
-	/* String controls are not supported. The user_to_new() and
-	 * cur_to_user() calls below would need to be modified not to access
-	 * userspace memory when called from set_ctrl().
-	 */
-	if (ctrl->type == V4L2_CTRL_TYPE_STRING)
-		return -EINVAL;
-
 	/* Reset the 'is_new' flags of the cluster */
 	for (i = 0; i < master->ncontrols; i++)
 		if (master->cluster[i])
 			master->cluster[i]->is_new = 0;
 
+	if (c)
+		user_to_new(c, ctrl);
+
 	/* For autoclusters with volatiles that are switched from auto to
 	   manual mode we have to update the current volatile values since
 	   those will become the initial manual values after such a switch. */
 	if (master->is_auto && master->has_volatiles && ctrl == master &&
-	    !is_cur_manual(master) && c->value == master->manual_mode_value)
+	    !is_cur_manual(master) && ctrl->val == master->manual_mode_value)
 		update_from_auto_cluster(master);
 
-	user_to_new(c, ctrl);
+	ctrl->is_new = 1;
 	return try_or_set_cluster(fh, master, true, ch_flags);
 }
 
@@ -2853,26 +2849,46 @@ EXPORT_SYMBOL(v4l2_subdev_s_ctrl);
 
 int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
 {
-	struct v4l2_ext_control c;
+	int ret;
 
 	/* It's a driver bug if this happens. */
 	WARN_ON(!type_is_int(ctrl));
-	c.value = val;
-	return set_ctrl_lock(NULL, ctrl, &c);
+	v4l2_ctrl_lock(ctrl);
+	ctrl->val = val;
+	ret = set_ctrl(NULL, ctrl, NULL, 0);
+	v4l2_ctrl_unlock(ctrl);
+	return ret;
 }
 EXPORT_SYMBOL(v4l2_ctrl_s_ctrl);
 
 int v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val)
 {
-	struct v4l2_ext_control c;
+	int ret;
 
 	/* It's a driver bug if this happens. */
 	WARN_ON(ctrl->type != V4L2_CTRL_TYPE_INTEGER64);
-	c.value64 = val;
-	return set_ctrl_lock(NULL, ctrl, &c);
+	v4l2_ctrl_lock(ctrl);
+	ctrl->val64 = val;
+	ret = set_ctrl(NULL, ctrl, NULL, 0);
+	v4l2_ctrl_unlock(ctrl);
+	return ret;
 }
 EXPORT_SYMBOL(v4l2_ctrl_s_ctrl_int64);
 
+int v4l2_ctrl_s_ctrl_string(struct v4l2_ctrl *ctrl, const char *s)
+{
+	int ret;
+
+	/* It's a driver bug if this happens. */
+	WARN_ON(ctrl->type != V4L2_CTRL_TYPE_STRING);
+	v4l2_ctrl_lock(ctrl);
+	strlcpy(ctrl->string, s, ctrl->maximum + 1);
+	ret = set_ctrl(NULL, ctrl, NULL, 0);
+	v4l2_ctrl_unlock(ctrl);
+	return ret;
+}
+EXPORT_SYMBOL(v4l2_ctrl_s_ctrl_string);
+
 void v4l2_ctrl_notify(struct v4l2_ctrl *ctrl, v4l2_ctrl_notify_fnc notify, void *priv)
 {
 	if (ctrl == NULL)
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 16f7f26..ee00f11 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -640,6 +640,18 @@ s64 v4l2_ctrl_g_ctrl_int64(struct v4l2_ctrl *ctrl);
   */
 int v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val);
 
+/** v4l2_ctrl_s_ctrl_string() - Helper function to set a control's string value from within a driver.
+  * @ctrl:	The control.
+  * @s:		The new string.
+  *
+  * This set the control's new string safely by going through the control
+  * framework. This function will lock the control's handler, so it cannot be
+  * used from within the &v4l2_ctrl_ops functions.
+  *
+  * This function is for string type controls only.
+  */
+int v4l2_ctrl_s_ctrl_string(struct v4l2_ctrl *ctrl, const char *s);
+
 /* Internal helper functions that deal with control events. */
 extern const struct v4l2_subscribed_event_ops v4l2_ctrl_sub_ev_ops;
 void v4l2_ctrl_replace(struct v4l2_event *old, const struct v4l2_event *new);
-- 
1.8.5.2

