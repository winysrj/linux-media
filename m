Return-path: <mchehab@pedra>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3537 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab1AVLGV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jan 2011 06:06:21 -0500
Received: from localhost.localdomain (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr2.xs4all.nl (8.13.8/8.13.8) with ESMTP id p0MB69iZ074561
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 22 Jan 2011 12:06:20 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 1/3] v4l2-ctrls: must be able to enable/disable controls
Date: Sat, 22 Jan 2011 12:05:59 +0100
Message-Id: <828e9980aa0934596a85e5a1b83c0bdd52ecc9d0.1295693790.git.hverkuil@xs4all.nl>
In-Reply-To: <1295694361-23237-1-git-send-email-hverkuil@xs4all.nl>
References: <1295694361-23237-1-git-send-email-hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Controls can be dependent on the chosen input/output. So it has to be possible
to enable or disable groups of controls, preventing them from being seen in
the application.

We need to allow duplicate controls as well so that two control handlers
that both have the same control will still work. The first enabled control
will win. And duplicate controls are always sorted based on when they were
added (so the sorted list and the hash are both stable lists/hashes).

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/v4l2-ctrls.c |  123 +++++++++++++++++++++++++-------------
 include/media/v4l2-ctrls.h       |   34 +++++++++++
 2 files changed, 115 insertions(+), 42 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index ef66d2a..983e287 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -820,7 +820,7 @@ static struct v4l2_ctrl_ref *find_private_ref(
 		   VIDIOC_G/S_CTRL. */
 		if (V4L2_CTRL_ID2CLASS(ref->ctrl->id) == V4L2_CTRL_CLASS_USER &&
 		    V4L2_CTRL_DRIVER_PRIV(ref->ctrl->id)) {
-			if (!type_is_int(ref->ctrl))
+			if (!ref->ctrl->is_enabled || !type_is_int(ref->ctrl))
 				continue;
 			if (id == 0)
 				return ref;
@@ -849,7 +849,7 @@ static struct v4l2_ctrl_ref *find_ref(struct v4l2_ctrl_handler *hdl, u32 id)
 
 	/* Not in cache, search the hash */
 	ref = hdl->buckets ? hdl->buckets[bucket] : NULL;
-	while (ref && ref->ctrl->id != id)
+	while (ref && ref->ctrl->id != id && ref->ctrl->is_enabled)
 		ref = ref->next;
 
 	if (ref)
@@ -926,23 +926,28 @@ static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
 
 	/* Find insert position in sorted list */
 	list_for_each_entry(ref, &hdl->ctrl_refs, node) {
-		if (ref->ctrl->id < id)
-			continue;
-		/* Don't add duplicates */
-		if (ref->ctrl->id == id) {
-			kfree(new_ref);
-			goto unlock;
+		/* If there are multiple elements with the same ID, then
+		   add the new element at the end. */
+		if (ref->ctrl->id > id) {
+			list_add(&new_ref->node, ref->node.prev);
+			break;
 		}
-		list_add(&new_ref->node, ref->node.prev);
-		break;
 	}
 
 insert_in_hash:
-	/* Insert the control node in the hash */
-	new_ref->next = hdl->buckets[bucket];
-	hdl->buckets[bucket] = new_ref;
+	/* Append the control ref to the hash */
+	if (hdl->buckets[bucket] == NULL) {
+		hdl->buckets[bucket] = new_ref;
+	} else {
+		for (ref = hdl->buckets[bucket]; ref->next; ref = ref->next)
+			; /* empty */
+		ref->next = new_ref;
+	}
+	/* Note regarding the hdl->cached control ref: since new control refs
+	   are always appended after any existing controls they will never
+	   invalidate the cached control ref. So there is no need to set the
+	   hdl->cached pointer to NULL. */
 
-unlock:
 	mutex_unlock(&hdl->lock);
 	return 0;
 }
@@ -960,8 +965,22 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	if (hdl->error)
 		return NULL;
 
-	/* Sanity checks */
+	/* Sanity checks:
+	   - id must never be 0 (reserved value as it is the starting point
+	     if apps want to iterate over all controls using
+	     V4L2_CTRL_FLAG_NEXT_CTRL).
+	   - name must be set.
+	   - V4L2_CID_PRIVATE_BASE IDs are no longer allowed: these IDs make
+	     it impossible to set the control using explicit control IDs.
+	   - def must be in range and max must be >= min.
+	   - V4L2_CTRL_FLAG_DISABLED must not be used by drivers any more.
+	     There are better ways of doing this.
+	   - Integer types must have a non-zero step.
+	   - Menu types must have a menu.
+	   - String types must have a non-zero max string length.
+	 */
 	if (id == 0 || name == NULL || id >= V4L2_CID_PRIVATE_BASE ||
+	    (flags & V4L2_CTRL_FLAG_DISABLED) ||
 	    max < min ||
 	    (type == V4L2_CTRL_TYPE_INTEGER && step == 0) ||
 	    (type == V4L2_CTRL_TYPE_MENU && qmenu == NULL) ||
@@ -1002,6 +1021,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	ctrl->step = step;
 	ctrl->qmenu = qmenu;
 	ctrl->priv = priv;
+	ctrl->is_enabled = 1;
 	ctrl->cur.val = ctrl->val = ctrl->default_value = def;
 
 	if (ctrl->type == V4L2_CTRL_TYPE_STRING) {
@@ -1193,14 +1213,39 @@ void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed)
 }
 EXPORT_SYMBOL(v4l2_ctrl_grab);
 
+/* Enable/disable a control.
+   Usually used if controls can be enabled/disabled when changing to a
+   different input or output.
+
+   When a control is disabled, then it will no longer show up in the
+   application. */
+void v4l2_ctrl_enable(struct v4l2_ctrl *ctrl, bool enabled)
+{
+	if (ctrl == NULL)
+		return;
+
+	ctrl->is_enabled = enabled;
+}
+EXPORT_SYMBOL(v4l2_ctrl_enable);
+
+void v4l2_ctrl_handler_enable(struct v4l2_ctrl_handler *hdl, bool enabled)
+{
+	struct v4l2_ctrl *ctrl;
+
+	if (hdl == NULL)
+		return;
+	mutex_lock(&hdl->lock);
+	list_for_each_entry(ctrl, &hdl->ctrls, node)
+		ctrl->is_enabled = enabled;
+	mutex_unlock(&hdl->lock);
+}
+EXPORT_SYMBOL(v4l2_ctrl_handler_enable);
+
 /* Log the control name and value */
 static void log_ctrl(const struct v4l2_ctrl *ctrl,
 		     const char *prefix, const char *colon)
 {
-	int fl_inact = ctrl->flags & V4L2_CTRL_FLAG_INACTIVE;
-	int fl_grabbed = ctrl->flags & V4L2_CTRL_FLAG_GRABBED;
-
-	if (ctrl->flags & (V4L2_CTRL_FLAG_DISABLED | V4L2_CTRL_FLAG_WRITE_ONLY))
+	if (ctrl->flags & V4L2_CTRL_FLAG_WRITE_ONLY)
 		return;
 	if (ctrl->type == V4L2_CTRL_TYPE_CTRL_CLASS)
 		return;
@@ -1221,20 +1266,19 @@ static void log_ctrl(const struct v4l2_ctrl *ctrl,
 		printk(KERN_CONT "%lld", ctrl->cur.val64);
 		break;
 	case V4L2_CTRL_TYPE_STRING:
-		printk(KERN_CONT "%s", ctrl->cur.string);
+		printk(KERN_CONT "\"%s\"", ctrl->cur.string);
 		break;
 	default:
 		printk(KERN_CONT "unknown type %d", ctrl->type);
 		break;
 	}
-	if (fl_inact && fl_grabbed)
-		printk(KERN_CONT " (inactive, grabbed)\n");
-	else if (fl_inact)
-		printk(KERN_CONT " (inactive)\n");
-	else if (fl_grabbed)
-		printk(KERN_CONT " (grabbed)\n");
-	else
-		printk(KERN_CONT "\n");
+	if (ctrl->flags & V4L2_CTRL_FLAG_INACTIVE)
+		printk(KERN_CONT " inactive");
+	if (ctrl->flags & V4L2_CTRL_FLAG_GRABBED)
+		printk(KERN_CONT " grabbed");
+	if (!ctrl->is_enabled)
+		printk(KERN_CONT " disabled");
+	printk(KERN_CONT "\n");
 }
 
 /* Log all controls owned by the handler */
@@ -1254,8 +1298,7 @@ void v4l2_ctrl_handler_log_status(struct v4l2_ctrl_handler *hdl,
 		colon = ": ";
 	mutex_lock(&hdl->lock);
 	list_for_each_entry(ctrl, &hdl->ctrls, node)
-		if (!(ctrl->flags & V4L2_CTRL_FLAG_DISABLED))
-			log_ctrl(ctrl, prefix, colon);
+		log_ctrl(ctrl, prefix, colon);
 	mutex_unlock(&hdl->lock);
 }
 EXPORT_SYMBOL(v4l2_ctrl_handler_log_status);
@@ -1324,17 +1367,15 @@ int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc)
 		/* Did we reach the end of the control list? */
 		if (id >= node2id(hdl->ctrl_refs.prev)) {
 			ref = NULL; /* Yes, so there is no next control */
-		} else if (ref) {
-			/* We found a control with the given ID, so just get
-			   the next one in the list. */
-			ref = list_entry(ref->node.next, typeof(*ref), node);
 		} else {
-			/* No control with the given ID exists, so start
-			   searching for the next largest ID. We know there
-			   is one, otherwise the first 'if' above would have
-			   been true. */
-			list_for_each_entry(ref, &hdl->ctrl_refs, node)
-				if (id < ref->ctrl->id)
+			/* If no ref was found, then start searching from the
+			   beginning of the ctrl_refs list. */
+			if (ref == NULL)
+				ref = list_entry(hdl->ctrl_refs.next,
+						typeof(*ref), node);
+			/* Search for the next largest ID. */
+			list_for_each_entry_from(ref, &hdl->ctrl_refs, node)
+				if (ref->ctrl->is_enabled && id < ref->ctrl->id)
 					break;
 		}
 	}
@@ -1468,8 +1509,6 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 		ctrl = v4l2_ctrl_find(hdl, id);
 		if (ctrl == NULL)
 			return -EINVAL;
-		if (ctrl->flags & V4L2_CTRL_FLAG_DISABLED)
-			return -EINVAL;
 
 		helpers[i].ctrl = ctrl;
 		helpers[i].handled = false;
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 97d0638..a2b2d58 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -65,6 +65,8 @@ struct v4l2_ctrl_ops {
   *		control's current value cannot be cached and needs to be
   *		retrieved through the g_volatile_ctrl op. Drivers can set
   *		this flag.
+  * @is_enabled: If 0, then this control is disabled and will be hidden for
+  *		applications. Controls are always enabled by default.
   * @ops:	The control ops.
   * @id:	The control ID.
   * @name:	The control name.
@@ -105,6 +107,7 @@ struct v4l2_ctrl {
 	unsigned int is_new:1;
 	unsigned int is_private:1;
 	unsigned int is_volatile:1;
+	unsigned int is_enabled:1;
 
 	const struct v4l2_ctrl_ops *ops;
 	u32 id;
@@ -399,6 +402,37 @@ void v4l2_ctrl_activate(struct v4l2_ctrl *ctrl, bool active);
   */
 void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed);
 
+/** v4l2_ctrl_enable() - Mark the control as enabled or disabled.
+  * @ctrl:	The control to en/disable.
+  * @enabled:	True if the control should become enabled.
+  *
+  * Enable/disable a control.
+  * Does nothing if @ctrl == NULL.
+  * Usually called if controls are to be enabled or disabled when changing
+  * to a different input or output.
+  *
+  * When a control is disabled, then it will no longer show up in the
+  * application.
+  *
+  * This function can be called regardless of whether the control handler
+  * is locked or not.
+  */
+void v4l2_ctrl_enable(struct v4l2_ctrl *ctrl, bool enabled);
+
+/** v4l2_ctrl_handler_enable() - Mark the controls in the handler as enabled or disabled.
+  * @hdl:	The control handler.
+  * @enabled:	True if the controls should become enabled.
+  *
+  * Enable/disable the controls owned by the handler.
+  * Does nothing if @hdl == NULL.
+  * Usually called if controls are to be enabled or disabled when changing
+  * to a different input or output.
+  *
+  * When a control is disabled, then it will no longer show up in the
+  * application.
+  */
+void v4l2_ctrl_handler_enable(struct v4l2_ctrl_handler *hdl, bool enabled);
+
 /** v4l2_ctrl_lock() - Helper function to lock the handler
   * associated with the control.
   * @ctrl:	The control to lock.
-- 
1.7.0.4

