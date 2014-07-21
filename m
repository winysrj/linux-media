Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1818 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403AbaGUNqK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 09:46:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Eduardo Valentin <edubezval@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 6/7] v4l2-ctrls: add support for setting string controls
Date: Mon, 21 Jul 2014 15:45:42 +0200
Message-Id: <1405950343-26892-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1405950343-26892-1-git-send-email-hverkuil@xs4all.nl>
References: <1405950343-26892-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Rather than always having to use a v4l2_ext_control struct to set
a control value from within a driver, switch to just setting the
new value. This is faster and it makes it possible to set more
complex types such as a string control as is added by this
patch.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 47 +++++++++++++++---------------------
 include/media/v4l2-ctrls.h           | 24 ++++++++++++++++++
 2 files changed, 44 insertions(+), 27 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index a7b4d4c..848169c 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -3159,26 +3159,22 @@ static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
 	struct v4l2_ctrl *master = ctrl->cluster[0];
 	int i;
 
-	/* Compound controls are not supported. The user_to_new() and
-	 * cur_to_user() calls below would need to be modified not to access
-	 * userspace memory when called from set_ctrl().
-	 */
-	if (ctrl->is_ptr)
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
 
@@ -3226,40 +3222,37 @@ EXPORT_SYMBOL(v4l2_subdev_s_ctrl);
 
 int __v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
 {
-	struct v4l2_ext_control c;
-	int rval;
-
 	lockdep_assert_held(ctrl->handler->lock);
 
 	/* It's a driver bug if this happens. */
 	WARN_ON(!ctrl->is_int);
-	c.value = val;
-	rval = set_ctrl(NULL, ctrl, &c, 0);
-	if (!rval)
-		cur_to_user(&c, ctrl);
-
-	return rval;
+	ctrl->val = val;
+	return set_ctrl(NULL, ctrl, NULL, 0);
 }
 EXPORT_SYMBOL(__v4l2_ctrl_s_ctrl);
 
 int __v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val)
 {
-	struct v4l2_ext_control c;
-	int rval;
-
 	lockdep_assert_held(ctrl->handler->lock);
 
 	/* It's a driver bug if this happens. */
 	WARN_ON(ctrl->is_ptr || ctrl->type != V4L2_CTRL_TYPE_INTEGER64);
-	c.value64 = val;
-	rval = set_ctrl(NULL, ctrl, &c, 0);
-	if (!rval)
-		cur_to_user(&c, ctrl);
-
-	return rval;
+	*ctrl->p_new.p_s64 = val;
+	return set_ctrl(NULL, ctrl, NULL, 0);
 }
 EXPORT_SYMBOL(__v4l2_ctrl_s_ctrl_int64);
 
+int __v4l2_ctrl_s_ctrl_string(struct v4l2_ctrl *ctrl, const char *s)
+{
+	lockdep_assert_held(ctrl->handler->lock);
+
+	/* It's a driver bug if this happens. */
+	WARN_ON(ctrl->type != V4L2_CTRL_TYPE_STRING);
+	strlcpy(ctrl->p_new.p_char, s, ctrl->maximum + 1);
+	return set_ctrl(NULL, ctrl, NULL, 0);
+}
+EXPORT_SYMBOL(__v4l2_ctrl_s_ctrl_string);
+
 void v4l2_ctrl_notify(struct v4l2_ctrl *ctrl, v4l2_ctrl_notify_fnc notify, void *priv)
 {
 	if (ctrl == NULL)
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index a674bf7..b7cd7a6 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -739,6 +739,30 @@ static inline int v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val)
 	return rval;
 }
 
+/** __v4l2_ctrl_s_ctrl_string() - Unlocked variant of v4l2_ctrl_s_ctrl_string(). */
+int __v4l2_ctrl_s_ctrl_string(struct v4l2_ctrl *ctrl, const char *s);
+
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
+static inline int v4l2_ctrl_s_ctrl_string(struct v4l2_ctrl *ctrl, const char *s)
+{
+	int rval;
+
+	v4l2_ctrl_lock(ctrl);
+	rval = __v4l2_ctrl_s_ctrl_string(ctrl, s);
+	v4l2_ctrl_unlock(ctrl);
+
+	return rval;
+}
+
 /* Internal helper functions that deal with control events. */
 extern const struct v4l2_subscribed_event_ops v4l2_ctrl_sub_ev_ops;
 void v4l2_ctrl_replace(struct v4l2_event *old, const struct v4l2_event *new);
-- 
2.0.1

