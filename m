Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:47401 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab1K2Rze (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Nov 2011 12:55:34 -0500
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LVF000TJOGJFO@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 29 Nov 2011 17:55:31 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LVF00JM5OGIAZ@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 29 Nov 2011 17:55:31 +0000 (GMT)
Date: Tue, 29 Nov 2011 18:55:25 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 1/3] v4l-ctrl: Add a method for control value range update
In-reply-to: <1322589327-4415-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, m.szyprowski@samsung.com,
	jonghun.han@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com
Message-id: <1322589327-4415-2-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1322589327-4415-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hverkuil@xs4all.nl>

---
This patch is not for merging, I'm just resending it as patch 3/3 depends on
this one.

---
 drivers/media/video/v4l2-ctrls.c |  147 +++++++++++++++++++++++++++-----------
 include/linux/videodev2.h        |    1 +
 include/media/v4l2-ctrls.h       |   17 +++++
 3 files changed, 122 insertions(+), 43 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 5552f81..b59b00a 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -912,8 +912,7 @@ static int new_to_user(struct v4l2_ext_control *c,
 }
 
 /* Copy the new value to the current value. */
-static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
-						bool update_inactive)
+static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 ch_flags)
 {
 	bool changed = false;
 
@@ -937,8 +936,8 @@ static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
 		ctrl->cur.val = ctrl->val;
 		break;
 	}
-	if (update_inactive) {
-		/* Note: update_inactive can only be true for auto clusters. */
+	if (ch_flags & V4L2_EVENT_CTRL_CH_FLAGS) {
+		/* Note: CH_FLAGS is only set for auto clusters. */
 		ctrl->flags &=
 			~(V4L2_CTRL_FLAG_INACTIVE | V4L2_CTRL_FLAG_VOLATILE);
 		if (!is_cur_manual(ctrl->cluster[0])) {
@@ -947,14 +946,13 @@ static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
 				ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
 		}
 	}
-	if (changed || update_inactive) {
+	if (changed || ch_flags) {
 		/* If a control was changed that was not one of the controls
 		   modified by the application, then send the event to all. */
 		if (!ctrl->is_new)
 			fh = NULL;
 		send_event(fh, ctrl,
-			(changed ? V4L2_EVENT_CTRL_CH_VALUE : 0) |
-			(update_inactive ? V4L2_EVENT_CTRL_CH_FLAGS : 0));
+			(changed ? V4L2_EVENT_CTRL_CH_VALUE : 0) | ch_flags);
 	}
 }
 
@@ -1288,6 +1286,40 @@ unlock:
 	return 0;
 }
 
+/* Control range checking */
+static int check_range(enum v4l2_ctrl_type type,
+		s32 min, s32 max, u32 step, s32 def)
+{
+	switch (type) {
+	case V4L2_CTRL_TYPE_BOOLEAN:
+		if (step != 1 || max > 1 || min < 0)
+			return -ERANGE;
+		/* fall through */
+	case V4L2_CTRL_TYPE_INTEGER:
+		if (step <= 0 || min > max || def < min || def > max)
+			return -ERANGE;
+		return 0;
+	case V4L2_CTRL_TYPE_BITMASK:
+		if (step || min || !max || (def & ~max))
+			return -ERANGE;
+		return 0;
+	case V4L2_CTRL_TYPE_MENU:
+		if (min > max || def < min || def > max)
+			return -ERANGE;
+		/* Note: step == menu_skip_mask for menu controls.
+		   So here we check if the default value is masked out. */
+		if (step && ((1 << def) & step))
+			return -EINVAL;
+		return 0;
+	case V4L2_CTRL_TYPE_STRING:
+		if (min > max || min < 0 || step < 1 || def)
+			return -ERANGE;
+		return 0;
+	default:
+		return 0;
+	}
+}
+
 /* Add a new control */
 static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
@@ -1297,32 +1329,20 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 {
 	struct v4l2_ctrl *ctrl;
 	unsigned sz_extra = 0;
+	int err;
 
 	if (hdl->error)
 		return NULL;
 
 	/* Sanity checks */
 	if (id == 0 || name == NULL || id >= V4L2_CID_PRIVATE_BASE ||
-	    (type == V4L2_CTRL_TYPE_INTEGER && step == 0) ||
-	    (type == V4L2_CTRL_TYPE_BITMASK && max == 0) ||
-	    (type == V4L2_CTRL_TYPE_MENU && qmenu == NULL) ||
-	    (type == V4L2_CTRL_TYPE_STRING && max == 0)) {
-		handler_set_err(hdl, -ERANGE);
-		return NULL;
-	}
-	if (type != V4L2_CTRL_TYPE_BITMASK && max < min) {
+	    (type == V4L2_CTRL_TYPE_MENU && qmenu == NULL)) {
 		handler_set_err(hdl, -ERANGE);
 		return NULL;
 	}
-	if ((type == V4L2_CTRL_TYPE_INTEGER ||
-	     type == V4L2_CTRL_TYPE_MENU ||
-	     type == V4L2_CTRL_TYPE_BOOLEAN) &&
-	    (def < min || def > max)) {
-		handler_set_err(hdl, -ERANGE);
-		return NULL;
-	}
-	if (type == V4L2_CTRL_TYPE_BITMASK && ((def & ~max) || min || step)) {
-		handler_set_err(hdl, -ERANGE);
+	err = check_range(type, min, max, step, def);
+	if (err) {
+		handler_set_err(hdl, err);
 		return NULL;
 	}
 
@@ -2060,7 +2080,7 @@ EXPORT_SYMBOL(v4l2_ctrl_g_ctrl);
    copied to the current value on a set.
    Must be called with ctrl->handler->lock held. */
 static int try_or_set_cluster(struct v4l2_fh *fh,
-			      struct v4l2_ctrl *master, bool set)
+			      struct v4l2_ctrl *master, bool set, u32 ch_flags)
 {
 	bool update_flag;
 	int ret;
@@ -2098,7 +2118,8 @@ static int try_or_set_cluster(struct v4l2_fh *fh,
 	/* If OK, then make the new values permanent. */
 	update_flag = is_cur_manual(master) != is_new_manual(master);
 	for (i = 0; i < master->ncontrols; i++)
-		new_to_cur(fh, master->cluster[i], update_flag && i > 0);
+		new_to_cur(fh, master->cluster[i], ch_flags |
+			((update_flag && i > 0) ? V4L2_EVENT_CTRL_CH_FLAGS : 0));
 	return 0;
 }
 
@@ -2224,7 +2245,7 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 		} while (!ret && idx);
 
 		if (!ret)
-			ret = try_or_set_cluster(fh, master, set);
+			ret = try_or_set_cluster(fh, master, set, 0);
 
 		/* Copy the new values back to userspace. */
 		if (!ret) {
@@ -2269,18 +2290,12 @@ int v4l2_subdev_s_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs
 EXPORT_SYMBOL(v4l2_subdev_s_ext_ctrls);
 
 /* Helper function for VIDIOC_S_CTRL compatibility */
-static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, s32 *val)
+static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
+		    s32 val, u32 ch_flags)
 {
 	struct v4l2_ctrl *master = ctrl->cluster[0];
-	int ret;
 	int i;
 
-	ret = validate_new_int(ctrl, val);
-	if (ret)
-		return ret;
-
-	v4l2_ctrl_lock(ctrl);
-
 	/* Reset the 'is_new' flags of the cluster */
 	for (i = 0; i < master->ncontrols; i++)
 		if (master->cluster[i])
@@ -2290,13 +2305,25 @@ static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, s32 *val)
 	   manual mode we have to update the current volatile values since
 	   those will become the initial manual values after such a switch. */
 	if (master->is_auto && master->has_volatiles && ctrl == master &&
-	    !is_cur_manual(master) && *val == master->manual_mode_value)
+	    !is_cur_manual(master) && val == master->manual_mode_value)
 		update_from_auto_cluster(master);
-	ctrl->val = *val;
+	ctrl->val = val;
 	ctrl->is_new = 1;
-	ret = try_or_set_cluster(fh, master, true);
-	*val = ctrl->cur.val;
-	v4l2_ctrl_unlock(ctrl);
+	return try_or_set_cluster(fh, master, true, ch_flags);
+}
+
+/* Helper function for VIDIOC_S_CTRL compatibility */
+static int set_ctrl_lock(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, s32 *val)
+{
+	int ret = validate_new_int(ctrl, val);
+
+	if (!ret) {
+		v4l2_ctrl_lock(ctrl);
+		ret = set_ctrl(fh, ctrl, *val, 0);
+		if (!ret)
+			*val = ctrl->cur.val;
+		v4l2_ctrl_unlock(ctrl);
+	}
 	return ret;
 }
 
@@ -2311,7 +2338,7 @@ int v4l2_s_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 	if (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY)
 		return -EACCES;
 
-	return set_ctrl(fh, ctrl, &control->value);
+	return set_ctrl_lock(fh, ctrl, &control->value);
 }
 EXPORT_SYMBOL(v4l2_s_ctrl);
 
@@ -2325,10 +2352,44 @@ int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
 {
 	/* It's a driver bug if this happens. */
 	WARN_ON(!type_is_int(ctrl));
-	return set_ctrl(NULL, ctrl, &val);
+	return set_ctrl_lock(NULL, ctrl, &val);
 }
 EXPORT_SYMBOL(v4l2_ctrl_s_ctrl);
 
+int v4l2_ctrl_update_range(struct v4l2_ctrl *ctrl,
+			s32 min, s32 max, u32 step, s32 def)
+{
+	int ret = check_range(ctrl->type, min, max, step, def);
+	s32 val;
+
+	switch (ctrl->type) {
+	case V4L2_CTRL_TYPE_INTEGER:
+	case V4L2_CTRL_TYPE_BOOLEAN:
+	case V4L2_CTRL_TYPE_MENU:
+	case V4L2_CTRL_TYPE_BITMASK:
+		if (ret)
+			return ret;
+		break;
+	default:
+		return -EINVAL;
+	}
+	v4l2_ctrl_lock(ctrl);
+	ctrl->minimum = min;
+	ctrl->maximum = max;
+	ctrl->step = step;
+	ctrl->default_value = def;
+	val = ctrl->cur.val;
+	if (validate_new_int(ctrl, &val))
+		val = def;
+	if (val != ctrl->cur.val)
+		ret = set_ctrl(NULL, ctrl, val, V4L2_EVENT_CTRL_CH_RANGE);
+	else
+		send_event(NULL, ctrl, V4L2_EVENT_CTRL_CH_RANGE);
+	v4l2_ctrl_unlock(ctrl);
+	return ret;
+}
+EXPORT_SYMBOL(v4l2_ctrl_update_range);
+
 void v4l2_ctrl_add_event(struct v4l2_ctrl *ctrl,
 				struct v4l2_subscribed_event *sev)
 {
@@ -2337,7 +2398,7 @@ void v4l2_ctrl_add_event(struct v4l2_ctrl *ctrl,
 	if (ctrl->type != V4L2_CTRL_TYPE_CTRL_CLASS &&
 	    (sev->flags & V4L2_EVENT_SUB_FL_SEND_INITIAL)) {
 		struct v4l2_event ev;
-		u32 changes = V4L2_EVENT_CTRL_CH_FLAGS;
+		u32 changes = V4L2_EVENT_CTRL_CH_FLAGS | V4L2_EVENT_CTRL_CH_RANGE;
 
 		if (!(ctrl->flags & V4L2_CTRL_FLAG_WRITE_ONLY))
 			changes |= V4L2_EVENT_CTRL_CH_VALUE;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 4b752d5..22e632a 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -2063,6 +2063,7 @@ struct v4l2_event_vsync {
 /* Payload for V4L2_EVENT_CTRL */
 #define V4L2_EVENT_CTRL_CH_VALUE		(1 << 0)
 #define V4L2_EVENT_CTRL_CH_FLAGS		(1 << 1)
+#define V4L2_EVENT_CTRL_CH_RANGE		(1 << 2)
 
 struct v4l2_event_ctrl {
 	__u32 changes;
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index eeb3df6..69ea0d5 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -445,6 +445,23 @@ void v4l2_ctrl_activate(struct v4l2_ctrl *ctrl, bool active);
   */
 void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed);
 
+/** v4l2_ctrl_update_range() - Update the range of a control.
+  * @ctrl:	The control to update.
+  * @min:	The control's minimum value.
+  * @max:	The control's maximum value.
+  * @step:	The control's step value
+  * @def: 	The control's default value.
+  *
+  * Update the range of a control on the fly. This works for control types
+  * INTEGER, BOOLEAN, MENU and BITMASK. For menu controls the @step value
+  * is interpreted as a menu_skip_mask.
+  *
+  * An error is returned if one of the range arguments is invalid for this
+  * control type.
+  */
+int v4l2_ctrl_update_range(struct v4l2_ctrl *ctrl,
+			s32 min, s32 max, u32 step, s32 def);
+
 /** v4l2_ctrl_lock() - Helper function to lock the handler
   * associated with the control.
   * @ctrl:	The control to lock.
-- 
1.7.7.2

