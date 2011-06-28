Return-path: <mchehab@pedra>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2830 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757231Ab1F1L0R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 07:26:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 06/13] v4l2-ctrls: improve discovery of controls of the same cluster
Date: Tue, 28 Jun 2011 13:25:58 +0200
Message-Id: <3a298da013adcd214a4f45b07f062376f7c39578.1309260043.git.hans.verkuil@cisco.com>
In-Reply-To: <1309260365-4831-1-git-send-email-hverkuil@xs4all.nl>
References: <1309260365-4831-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1309260043.git.hans.verkuil@cisco.com>
References: <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1309260043.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

The implementation of VIDIOC_G/S/TRY_EXT_CTRLS in the control framework has
to figure out which controls in the control list belong to the same cluster.
Since controls belonging to the same cluster need to be handled as a unit,
this is important information.

It did that by going over the controls in the list and for each control that
belonged to a multi-control cluster it would walk the remainder of the list
to try and find controls that belong to that same cluster.

This approach has two disadvantages:

1) it was a potentially quadratic algorithm (although highly unlikely that
it would ever be that bad in practice).
2) it took place with the control handler's lock held.

Since we want to make it possible in the future to change control values
from interrupt context, doing a lot of work while holding a lock is not a
good idea.

In the new code the algorithm is no longer quadratic but linear in the
number of controls in the list. Also, it now can be done beforehand.

Another change that was made was to so the try and set at the same time.
Before when S_TRY_EXT_CTRLS was called it would 'try' the controls first,
and then it would 'set' them. The idea was that any 'try' errors would
prevent the 'set' from happening, thus avoiding having partially set
control lists.

However, this caused more problems than it solved because between the 'try'
and the 'set' changes might have happened, so it had to try a second time,
and since actual controls with a try_ctrl op are very rare (and those that
we have just adjust values and do not return an error), I've decided to
drop that two-stage approach and just combine try and set.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ctrls.c |  279 +++++++++++++++++++------------------
 include/media/v4l2-ctrls.h       |    3 +
 2 files changed, 146 insertions(+), 136 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 1b0422e..8fe4e47 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -32,12 +32,14 @@
 	(has_op(master, op) ? master->ops->op(master) : 0)
 
 /* Internal temporary helper struct, one for each v4l2_ext_control */
-struct ctrl_helper {
+struct v4l2_ctrl_helper {
+	/* Pointer to the control reference of the master control */
+	struct v4l2_ctrl_ref *mref;
 	/* The control corresponding to the v4l2_ext_control ID field. */
 	struct v4l2_ctrl *ctrl;
-	/* Used internally to mark whether this control was already
-	   processed. */
-	bool handled;
+	/* v4l2_ext_control index of the next control belonging to the
+	   same cluster, or 0 if there isn't any. */
+	u32 next;
 };
 
 /* Small helper function to determine if the autocluster is set to manual
@@ -678,20 +680,6 @@ static int new_to_user(struct v4l2_ext_control *c,
 	return 0;
 }
 
-static int ctrl_to_user(struct v4l2_ext_control *c,
-		       struct v4l2_ctrl *ctrl)
-{
-	if (ctrl->is_volatile)
-		return new_to_user(c, ctrl);
-	return cur_to_user(c, ctrl);
-}
-
-static int ctrl_is_volatile(struct v4l2_ext_control *c,
-		       struct v4l2_ctrl *ctrl)
-{
-	return ctrl->is_volatile;
-}
-
 /* Copy the new value to the current value. */
 static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
 						bool update_inactive)
@@ -779,13 +767,11 @@ static int cluster_changed(struct v4l2_ctrl *master)
 	return diff;
 }
 
-/* Validate a new control */
-static int validate_new(struct v4l2_ctrl *ctrl)
+/* Validate integer-type control */
+static int validate_new_int(const struct v4l2_ctrl *ctrl, s32 *pval)
 {
-	s32 val = ctrl->val;
-	char *s = ctrl->string;
+	s32 val = *pval;
 	u32 offset;
-	size_t len;
 
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_INTEGER:
@@ -798,11 +784,11 @@ static int validate_new(struct v4l2_ctrl *ctrl)
 		offset = val - ctrl->minimum;
 		offset = ctrl->step * (offset / ctrl->step);
 		val = ctrl->minimum + offset;
-		ctrl->val = val;
+		*pval = val;
 		return 0;
 
 	case V4L2_CTRL_TYPE_BOOLEAN:
-		ctrl->val = !!ctrl->val;
+		*pval = !!val;
 		return 0;
 
 	case V4L2_CTRL_TYPE_MENU:
@@ -815,9 +801,28 @@ static int validate_new(struct v4l2_ctrl *ctrl)
 
 	case V4L2_CTRL_TYPE_BUTTON:
 	case V4L2_CTRL_TYPE_CTRL_CLASS:
-		ctrl->val64 = 0;
+		*pval = 0;
 		return 0;
 
+	default:
+		return -EINVAL;
+	}
+}
+
+/* Validate a new control */
+static int validate_new(const struct v4l2_ctrl *ctrl, struct v4l2_ext_control *c)
+{
+	char *s = c->string;
+	size_t len;
+
+	switch (ctrl->type) {
+	case V4L2_CTRL_TYPE_INTEGER:
+	case V4L2_CTRL_TYPE_BOOLEAN:
+	case V4L2_CTRL_TYPE_MENU:
+	case V4L2_CTRL_TYPE_BUTTON:
+	case V4L2_CTRL_TYPE_CTRL_CLASS:
+		return validate_new_int(ctrl, &c->value);
+
 	case V4L2_CTRL_TYPE_INTEGER64:
 		return 0;
 
@@ -1575,12 +1580,15 @@ EXPORT_SYMBOL(v4l2_subdev_querymenu);
    Find the controls in the control array and do some basic checks. */
 static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 			     struct v4l2_ext_controls *cs,
-			     struct ctrl_helper *helpers)
+			     struct v4l2_ctrl_helper *helpers)
 {
+	struct v4l2_ctrl_helper *h;
+	bool have_clusters = false;
 	u32 i;
 
-	for (i = 0; i < cs->count; i++) {
+	for (i = 0, h = helpers; i < cs->count; i++, h++) {
 		struct v4l2_ext_control *c = &cs->controls[i];
+		struct v4l2_ctrl_ref *ref;
 		struct v4l2_ctrl *ctrl;
 		u32 id = c->id & V4L2_CTRL_ID_MASK;
 
@@ -1593,53 +1601,59 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 		   extended controls */
 		if (id >= V4L2_CID_PRIVATE_BASE)
 			return -EINVAL;
-		ctrl = v4l2_ctrl_find(hdl, id);
-		if (ctrl == NULL)
+		ref = find_ref_lock(hdl, id);
+		if (ref == NULL)
 			return -EINVAL;
+		ctrl = ref->ctrl;
 		if (ctrl->flags & V4L2_CTRL_FLAG_DISABLED)
 			return -EINVAL;
 
-		helpers[i].ctrl = ctrl;
-		helpers[i].handled = false;
+		if (ctrl->cluster[0]->ncontrols > 1)
+			have_clusters = true;
+		if (ctrl->cluster[0] != ctrl)
+			ref = find_ref_lock(hdl, ctrl->cluster[0]->id);
+		/* Store the ref to the master control of the cluster */
+		h->mref = ref;
+		h->ctrl = ctrl;
+		/* Initially set next to 0, meaning that there is no other
+		   control in this helper array belonging to the same
+		   cluster */
+		h->next = 0;
 	}
-	return 0;
-}
 
-typedef int (*cluster_func)(struct v4l2_ext_control *c,
-			    struct v4l2_ctrl *ctrl);
+	/* We are done if there were no controls that belong to a multi-
+	   control cluster. */
+	if (!have_clusters)
+		return 0;
 
-/* Walk over all controls in v4l2_ext_controls belonging to the same cluster
-   and call the provided function. */
-static int cluster_walk(unsigned from,
-			struct v4l2_ext_controls *cs,
-			struct ctrl_helper *helpers,
-			cluster_func f)
-{
-	struct v4l2_ctrl **cluster = helpers[from].ctrl->cluster;
-	int ret = 0;
-	int i;
+	/* The code below figures out in O(n) time which controls in the list
+	   belong to the same cluster. */
 
-	/* Find any controls from the same cluster and call the function */
-	for (i = from; !ret && i < cs->count; i++) {
-		struct v4l2_ctrl *ctrl = helpers[i].ctrl;
+	/* This has to be done with the handler lock taken. */
+	mutex_lock(&hdl->lock);
 
-		if (!helpers[i].handled && ctrl->cluster == cluster)
-			ret = f(&cs->controls[i], ctrl);
+	/* First zero the helper field in the master control references */
+	for (i = 0; i < cs->count; i++)
+		helpers[i].mref->helper = 0;
+	for (i = 0, h = helpers; i < cs->count; i++, h++) {
+		struct v4l2_ctrl_ref *mref = h->mref;
+
+		/* If the mref->helper is set, then it points to an earlier
+		   helper that belongs to the same cluster. */
+		if (mref->helper) {
+			/* Set the next field of mref->helper to the current
+			   index: this means that that earlier helper now
+			   points to the next helper in the same cluster. */
+			mref->helper->next = i;
+			/* mref should be set only for the first helper in the
+			   cluster, clear the others. */
+			h->mref = NULL;
+		}
+		/* Point the mref helper to the current helper struct. */
+		mref->helper = h;
 	}
-	return ret;
-}
-
-static void cluster_done(unsigned from,
-			 struct v4l2_ext_controls *cs,
-			 struct ctrl_helper *helpers)
-{
-	struct v4l2_ctrl **cluster = helpers[from].ctrl->cluster;
-	int i;
-
-	/* Find any controls from the same cluster and mark them as handled */
-	for (i = from; i < cs->count; i++)
-		if (helpers[i].ctrl->cluster == cluster)
-			helpers[i].handled = true;
+	mutex_unlock(&hdl->lock);
+	return 0;
 }
 
 /* Handles the corner case where cs->count == 0. It checks whether the
@@ -1657,8 +1671,8 @@ static int class_check(struct v4l2_ctrl_handler *hdl, u32 ctrl_class)
 /* Get extended controls. Allocates the helpers array if needed. */
 int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs)
 {
-	struct ctrl_helper helper[4];
-	struct ctrl_helper *helpers = helper;
+	struct v4l2_ctrl_helper helper[4];
+	struct v4l2_ctrl_helper *helpers = helper;
 	int ret;
 	int i, j;
 
@@ -1685,37 +1699,38 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 			ret = -EACCES;
 
 	for (i = 0; !ret && i < cs->count; i++) {
-		struct v4l2_ctrl *ctrl = helpers[i].ctrl;
-		struct v4l2_ctrl *master = ctrl->cluster[0];
-		bool has_volatiles;
+		int (*ctrl_to_user)(struct v4l2_ext_control *c,
+				    struct v4l2_ctrl *ctrl) = cur_to_user;
+		struct v4l2_ctrl *master;
 
-		if (helpers[i].handled)
+		if (helpers[i].mref == NULL)
 			continue;
 
+		master = helpers[i].mref->ctrl;
 		cs->error_idx = i;
 
-		/* Any volatile controls requested from this cluster? */
-		has_volatiles = ctrl->is_volatile;
-		if (!has_volatiles && has_op(master, g_volatile_ctrl) &&
-				master->ncontrols > 1)
-			has_volatiles = cluster_walk(i, cs, helpers,
-						ctrl_is_volatile);
-
 		v4l2_ctrl_lock(master);
 
 		/* g_volatile_ctrl will update the new control values */
-		if (has_volatiles && !is_cur_manual(master)) {
+		if (has_op(master, g_volatile_ctrl) && !is_cur_manual(master)) {
 			for (j = 0; j < master->ncontrols; j++)
 				cur_to_new(master->cluster[j]);
 			ret = call_op(master, g_volatile_ctrl);
+			ctrl_to_user = new_to_user;
 		}
 		/* If OK, then copy the current (for non-volatile controls)
 		   or the new (for volatile controls) control values to the
 		   caller */
-		if (!ret)
-			ret = cluster_walk(i, cs, helpers, ctrl_to_user);
+		if (!ret) {
+			u32 idx = i;
+
+			do {
+				ret = ctrl_to_user(cs->controls + idx,
+						   helpers[idx].ctrl);
+				idx = helpers[idx].next;
+			} while (!ret && idx);
+		}
 		v4l2_ctrl_unlock(master);
-		cluster_done(i, cs, helpers);
 	}
 
 	if (cs->count > ARRAY_SIZE(helper))
@@ -1789,52 +1804,39 @@ static int try_or_set_control_cluster(struct v4l2_fh *fh,
 					struct v4l2_ctrl *master, bool set)
 {
 	bool update_flag;
-	bool try = !set;
-	int ret = 0;
+	int ret;
 	int i;
 
 	/* Go through the cluster and either validate the new value or
 	   (if no new value was set), copy the current value to the new
 	   value, ensuring a consistent view for the control ops when
 	   called. */
-	for (i = 0; !ret && i < master->ncontrols; i++) {
+	for (i = 0; i < master->ncontrols; i++) {
 		struct v4l2_ctrl *ctrl = master->cluster[i];
 
 		if (ctrl == NULL)
 			continue;
 
-		if (ctrl->is_new) {
-			/* Double check this: it may have changed since the
-			   last check in try_or_set_ext_ctrls(). */
-			if (set && (ctrl->flags & V4L2_CTRL_FLAG_GRABBED))
-				return -EBUSY;
-
-			/* Validate if required */
-			if (!set)
-				ret = validate_new(ctrl);
+		if (!ctrl->is_new) {
+			cur_to_new(ctrl);
 			continue;
 		}
-		/* No new value was set, so copy the current and force
-		   a call to try_ctrl later, since the values for the cluster
-		   may now have changed and the end result might be invalid. */
-		try = true;
-		cur_to_new(ctrl);
+		/* Check again: it may have changed since the
+		   previous check in try_or_set_ext_ctrls(). */
+		if (set && (ctrl->flags & V4L2_CTRL_FLAG_GRABBED))
+			return -EBUSY;
 	}
 
-	/* For larger clusters you have to call try_ctrl again to
-	   verify that the controls are still valid after the
-	   'cur_to_new' above. */
-	if (!ret && try)
-		ret = call_op(master, try_ctrl);
+	ret = call_op(master, try_ctrl);
 
 	/* Don't set if there is no change */
 	if (ret || !set || !cluster_changed(master))
 		return ret;
 	ret = call_op(master, s_ctrl);
-	/* If OK, then make the new values permanent. */
 	if (ret)
 		return ret;
 
+	/* If OK, then make the new values permanent. */
 	update_flag = is_cur_manual(master) != is_new_manual(master);
 	for (i = 0; i < master->ncontrols; i++)
 		new_to_cur(fh, master->cluster[i], update_flag && i > 0);
@@ -1845,16 +1847,19 @@ static int try_or_set_control_cluster(struct v4l2_fh *fh,
 static int try_or_set_ext_ctrls(struct v4l2_fh *fh,
 				struct v4l2_ctrl_handler *hdl,
 				struct v4l2_ext_controls *cs,
-				struct ctrl_helper *helpers,
+				struct v4l2_ctrl_helper *helpers,
 				bool set)
 {
 	unsigned i, j;
 	int ret = 0;
 
+	/* Phase 1: validation */
+	cs->error_idx = cs->count;
 	for (i = 0; i < cs->count; i++) {
 		struct v4l2_ctrl *ctrl = helpers[i].ctrl;
 
-		cs->error_idx = i;
+		if (!set)
+			cs->error_idx = i;
 
 		if (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY)
 			return -EACCES;
@@ -1866,17 +1871,22 @@ static int try_or_set_ext_ctrls(struct v4l2_fh *fh,
 		   best-effort to avoid that. */
 		if (set && (ctrl->flags & V4L2_CTRL_FLAG_GRABBED))
 			return -EBUSY;
+		ret = validate_new(ctrl, &cs->controls[i]);
+		if (ret)
+			return ret;
 	}
 
+	/* Phase 2: set/try controls */
 	for (i = 0; !ret && i < cs->count; i++) {
-		struct v4l2_ctrl *ctrl = helpers[i].ctrl;
-		struct v4l2_ctrl *master = ctrl->cluster[0];
+		struct v4l2_ctrl *master;
+		u32 idx = i;
 
-		if (helpers[i].handled)
+		if (helpers[i].mref == NULL)
 			continue;
 
 		cs->error_idx = i;
-		v4l2_ctrl_lock(ctrl);
+		master = helpers[i].mref->ctrl;
+		v4l2_ctrl_lock(master);
 
 		/* Reset the 'is_new' flags of the cluster */
 		for (j = 0; j < master->ncontrols; j++)
@@ -1885,17 +1895,24 @@ static int try_or_set_ext_ctrls(struct v4l2_fh *fh,
 
 		/* Copy the new caller-supplied control values.
 		   user_to_new() sets 'is_new' to 1. */
-		ret = cluster_walk(i, cs, helpers, user_to_new);
+		do {
+			ret = user_to_new(cs->controls + idx, helpers[idx].ctrl);
+			idx = helpers[idx].next;
+		} while (!ret && idx);
 
 		if (!ret)
 			ret = try_or_set_control_cluster(fh, master, set);
 
 		/* Copy the new values back to userspace. */
-		if (!ret)
-			ret = cluster_walk(i, cs, helpers, new_to_user);
-
-		v4l2_ctrl_unlock(ctrl);
-		cluster_done(i, cs, helpers);
+		if (!ret) {
+			idx = i;
+			do {
+				ret = user_to_new(cs->controls + idx,
+						  helpers[idx].ctrl);
+				idx = helpers[idx].next;
+			} while (!ret && idx);
+		}
+		v4l2_ctrl_unlock(master);
 	}
 	return ret;
 }
@@ -1905,10 +1922,9 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 			     struct v4l2_ext_controls *cs,
 			     bool set)
 {
-	struct ctrl_helper helper[4];
-	struct ctrl_helper *helpers = helper;
+	struct v4l2_ctrl_helper helper[4];
+	struct v4l2_ctrl_helper *helpers = helper;
 	int ret;
-	int i;
 
 	cs->error_idx = cs->count;
 	cs->ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
@@ -1925,21 +1941,10 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 			return -ENOMEM;
 	}
 	ret = prepare_ext_ctrls(hdl, cs, helpers);
-
-	/* First 'try' all controls and abort on error */
 	if (!ret)
-		ret = try_or_set_ext_ctrls(NULL, hdl, cs, helpers, false);
-	/* If this is a 'set' operation and the initial 'try' failed,
-	   then set error_idx to count to tell the application that no
-	   controls changed value yet. */
-	if (set)
+		ret = try_or_set_ext_ctrls(fh, hdl, cs, helpers, set);
+	else if (set)
 		cs->error_idx = cs->count;
-	if (!ret && set) {
-		/* Reset 'handled' state */
-		for (i = 0; i < cs->count; i++)
-			helpers[i].handled = false;
-		ret = try_or_set_ext_ctrls(fh, hdl, cs, helpers, true);
-	}
 
 	if (cs->count > ARRAY_SIZE(helper))
 		kfree(helpers);
@@ -1978,6 +1983,10 @@ static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, s32 *val)
 	int ret;
 	int i;
 
+	ret = validate_new_int(ctrl, val);
+	if (ret)
+		return ret;
+
 	v4l2_ctrl_lock(ctrl);
 
 	/* Reset the 'is_new' flags of the cluster */
@@ -1987,9 +1996,7 @@ static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, s32 *val)
 
 	ctrl->val = *val;
 	ctrl->is_new = 1;
-	ret = try_or_set_control_cluster(NULL, master, false);
-	if (!ret)
-		ret = try_or_set_control_cluster(fh, master, true);
+	ret = try_or_set_control_cluster(fh, master, true);
 	*val = ctrl->cur.val;
 	v4l2_ctrl_unlock(ctrl);
 	return ret;
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index d8123d9..5fc3a2d 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -27,6 +27,7 @@
 
 /* forward references */
 struct v4l2_ctrl_handler;
+struct v4l2_ctrl_helper;
 struct v4l2_ctrl;
 struct video_device;
 struct v4l2_subdev;
@@ -150,6 +151,7 @@ struct v4l2_ctrl {
   * @node:	List node for the sorted list.
   * @next:	Single-link list node for the hash.
   * @ctrl:	The actual control information.
+  * @helper:	Pointer to helper struct. Used internally in prepare_ext_ctrls().
   *
   * Each control handler has a list of these refs. The list_head is used to
   * keep a sorted-by-control-ID list of all controls, while the next pointer
@@ -159,6 +161,7 @@ struct v4l2_ctrl_ref {
 	struct list_head node;
 	struct v4l2_ctrl_ref *next;
 	struct v4l2_ctrl *ctrl;
+	struct v4l2_ctrl_helper *helper;
 };
 
 /** struct v4l2_ctrl_handler - The control handler keeps track of all the
-- 
1.7.1

