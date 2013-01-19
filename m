Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:48245 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab3ASV1k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jan 2013 16:27:40 -0500
Received: by mail-ea0-f182.google.com with SMTP id a12so1991742eaa.13
        for <linux-media@vger.kernel.org>; Sat, 19 Jan 2013 13:27:39 -0800 (PST)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sylvester.nawrocki@gmail.com
Subject: [PATCH 2/3] v4l2-ctrl: Add helper function for control range update
Date: Sat, 19 Jan 2013 22:27:21 +0100
Message-Id: <1358630842-12689-3-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1358630842-12689-1-git-send-email-sylvester.nawrocki@gmail.com>
References: <1358630842-12689-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a helper function that allows to modify range,
i.e. minimum, maximum, step and default value of a v4l2 control,
after the control has been created and initialized. This is helpful
in situations when range of a control depends on user configurable
parameters, e.g. camera sensor absolute exposure time depending on
an output image resolution and frame rate.

v4l2_ctrl_modify_range() function allows to modify range of an
INTEGER, BOOL, MENU, INTEGER_MENU and BITMASK type controls.

Based on a patch from Hans Verkuil http://patchwork.linuxtv.org/patch/8654.

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 Documentation/DocBook/media/v4l/vidioc-dqevent.xml |    6 +
 drivers/media/v4l2-core/v4l2-ctrls.c               |  142 ++++++++++++++------
 include/media/v4l2-ctrls.h                         |   20 +++
 include/uapi/linux/videodev2.h                     |    1 +
 4 files changed, 130 insertions(+), 39 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
index 98a856f..89891ad 100644
--- a/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-dqevent.xml
@@ -261,6 +261,12 @@
 	    <entry>This control event was triggered because the control flags
 		changed.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_EVENT_CTRL_CH_RANGE</constant></entry>
+	    <entry>0x0004</entry>
+	    <entry>This control event was triggered because the minimum,
+	    maximum, step or the default value of the control changed.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index f6ee201..d68fb57 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1160,8 +1160,7 @@ static int new_to_user(struct v4l2_ext_control *c,
 }
 
 /* Copy the new value to the current value. */
-static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
-						bool update_inactive)
+static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 ch_flags)
 {
 	bool changed = false;
 
@@ -1185,8 +1184,8 @@ static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
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
@@ -1196,14 +1195,13 @@ static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
 		}
 		fh = NULL;
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
 
@@ -1257,6 +1255,41 @@ static int cluster_changed(struct v4l2_ctrl *master)
 	return diff;
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
+	case V4L2_CTRL_TYPE_INTEGER_MENU:
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
 /* Validate a new control */
 static int validate_new(const struct v4l2_ctrl *ctrl,
 			struct v4l2_ext_control *c)
@@ -1529,30 +1562,21 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
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
 	    (type == V4L2_CTRL_TYPE_MENU && qmenu == NULL) ||
-	    (type == V4L2_CTRL_TYPE_INTEGER_MENU && qmenu_int == NULL) ||
-	    (type == V4L2_CTRL_TYPE_STRING && max == 0)) {
+	    (type == V4L2_CTRL_TYPE_INTEGER_MENU && qmenu_int == NULL)) {
 		handler_set_err(hdl, -ERANGE);
 		return NULL;
 	}
-	if (type != V4L2_CTRL_TYPE_BITMASK && max < min) {
-		handler_set_err(hdl, -ERANGE);
-		return NULL;
-	}
-	if ((type == V4L2_CTRL_TYPE_INTEGER ||
-	     type == V4L2_CTRL_TYPE_MENU ||
-	     type == V4L2_CTRL_TYPE_INTEGER_MENU ||
-	     type == V4L2_CTRL_TYPE_BOOLEAN) &&
-	    (def < min || def > max)) {
-		handler_set_err(hdl, -ERANGE);
+	err = check_range(type, min, max, step, def);
+	if (err) {
+		handler_set_err(hdl, err);
 		return NULL;
 	}
 	if (type == V4L2_CTRL_TYPE_BITMASK && ((def & ~max) || min || step)) {
@@ -2426,8 +2450,8 @@ EXPORT_SYMBOL(v4l2_ctrl_g_ctrl_int64);
 /* Core function that calls try/s_ctrl and ensures that the new value is
    copied to the current value on a set.
    Must be called with ctrl->handler->lock held. */
-static int try_or_set_cluster(struct v4l2_fh *fh,
-			      struct v4l2_ctrl *master, bool set)
+static int try_or_set_cluster(struct v4l2_fh *fh, struct v4l2_ctrl *master,
+			      bool set, u32 ch_flags)
 {
 	bool update_flag;
 	int ret;
@@ -2465,7 +2489,8 @@ static int try_or_set_cluster(struct v4l2_fh *fh,
 	/* If OK, then make the new values permanent. */
 	update_flag = is_cur_manual(master) != is_new_manual(master);
 	for (i = 0; i < master->ncontrols; i++)
-		new_to_cur(fh, master->cluster[i], update_flag && i > 0);
+		new_to_cur(fh, master->cluster[i], ch_flags |
+			((update_flag && i > 0) ? V4L2_EVENT_CTRL_CH_FLAGS : 0));
 	return 0;
 }
 
@@ -2592,7 +2617,7 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 		} while (!ret && idx);
 
 		if (!ret)
-			ret = try_or_set_cluster(fh, master, set);
+			ret = try_or_set_cluster(fh, master, set, 0);
 
 		/* Copy the new values back to userspace. */
 		if (!ret) {
@@ -2638,10 +2663,9 @@ EXPORT_SYMBOL(v4l2_subdev_s_ext_ctrls);
 
 /* Helper function for VIDIOC_S_CTRL compatibility */
 static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
-		    struct v4l2_ext_control *c)
+		    struct v4l2_ext_control *c, u32 ch_flags)
 {
 	struct v4l2_ctrl *master = ctrl->cluster[0];
-	int ret;
 	int i;
 
 	/* String controls are not supported. The user_to_new() and
@@ -2651,12 +2675,6 @@ static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
 	if (ctrl->type == V4L2_CTRL_TYPE_STRING)
 		return -EINVAL;
 
-	ret = validate_new(ctrl, c);
-	if (ret)
-		return ret;
-
-	v4l2_ctrl_lock(ctrl);
-
 	/* Reset the 'is_new' flags of the cluster */
 	for (i = 0; i < master->ncontrols; i++)
 		if (master->cluster[i])
@@ -2670,10 +2688,22 @@ static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
 		update_from_auto_cluster(master);
 
 	user_to_new(c, ctrl);
-	ret = try_or_set_cluster(fh, master, true);
-	cur_to_user(c, ctrl);
+	return try_or_set_cluster(fh, master, true, ch_flags);
+}
 
-	v4l2_ctrl_unlock(ctrl);
+/* Helper function for VIDIOC_S_CTRL compatibility */
+static int set_ctrl_lock(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
+			 struct v4l2_ext_control *c)
+{
+	int ret = validate_new(ctrl, c);
+
+	if (!ret) {
+		v4l2_ctrl_lock(ctrl);
+		ret = set_ctrl(fh, ctrl, c, 0);
+		if (!ret)
+			cur_to_user(c, ctrl);
+		v4l2_ctrl_unlock(ctrl);
+	}
 	return ret;
 }
 
@@ -2691,7 +2721,7 @@ int v4l2_s_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 		return -EACCES;
 
 	c.value = control->value;
-	ret = set_ctrl(fh, ctrl, &c);
+	ret = set_ctrl_lock(fh, ctrl, &c);
 	control->value = c.value;
 	return ret;
 }
@@ -2710,7 +2740,7 @@ int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
 	/* It's a driver bug if this happens. */
 	WARN_ON(!type_is_int(ctrl));
 	c.value = val;
-	return set_ctrl(NULL, ctrl, &c);
+	return set_ctrl_lock(NULL, ctrl, &c);
 }
 EXPORT_SYMBOL(v4l2_ctrl_s_ctrl);
 
@@ -2721,10 +2751,44 @@ int v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val)
 	/* It's a driver bug if this happens. */
 	WARN_ON(ctrl->type != V4L2_CTRL_TYPE_INTEGER64);
 	c.value64 = val;
-	return set_ctrl(NULL, ctrl, &c);
+	return set_ctrl_lock(NULL, ctrl, &c);
 }
 EXPORT_SYMBOL(v4l2_ctrl_s_ctrl_int64);
 
+int v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
+			s32 min, s32 max, u32 step, s32 def)
+{
+	int ret = check_range(ctrl->type, min, max, step, def);
+	struct v4l2_ext_control c;
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
+	c.value = ctrl->cur.val;
+	if (validate_new(ctrl, &c))
+		c.value = def;
+	if (c.value != ctrl->cur.val)
+		ret = set_ctrl(NULL, ctrl, &c, V4L2_EVENT_CTRL_CH_RANGE);
+	else
+		send_event(NULL, ctrl, V4L2_EVENT_CTRL_CH_RANGE);
+	v4l2_ctrl_unlock(ctrl);
+	return ret;
+}
+EXPORT_SYMBOL(v4l2_ctrl_modify_range);
+
 static int v4l2_ctrl_add_event(struct v4l2_subscribed_event *sev, unsigned elems)
 {
 	struct v4l2_ctrl *ctrl = v4l2_ctrl_find(sev->fh->ctrl_handler, sev->id);
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 9650911..534da28 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -507,6 +507,26 @@ void v4l2_ctrl_activate(struct v4l2_ctrl *ctrl, bool active);
   */
 void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed);
 
+/** v4l2_ctrl_modify_range() - Update the range of a control.
+  * @ctrl:	The control to update.
+  * @min:	The control's minimum value.
+  * @max:	The control's maximum value.
+  * @step:	The control's step value
+  * @def:	The control's default value.
+  *
+  * Update the range of a control on the fly. This works for control types
+  * INTEGER, BOOLEAN, MENU, INTEGER MENU and BITMASK. For menu controls the
+  * @step value is interpreted as a menu_skip_mask.
+  *
+  * An error is returned if one of the range arguments is invalid for this
+  * control type.
+  *
+  * This function assumes that the control handler is not locked and will
+  * take the lock itself.
+  */
+int v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
+			s32 min, s32 max, u32 step, s32 def);
+
 /** v4l2_ctrl_lock() - Helper function to lock the handler
   * associated with the control.
   * @ctrl:	The control to lock.
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 3cf3e94..9c3a303 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1810,6 +1810,7 @@ struct v4l2_event_vsync {
 /* Payload for V4L2_EVENT_CTRL */
 #define V4L2_EVENT_CTRL_CH_VALUE		(1 << 0)
 #define V4L2_EVENT_CTRL_CH_FLAGS		(1 << 1)
+#define V4L2_EVENT_CTRL_CH_RANGE		(1 << 2)
 
 struct v4l2_event_ctrl {
 	__u32 changes;
-- 
1.7.4.1

