Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1089 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933080AbaFLLyk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 07:54:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv4 PATCH 05/34] v4l2-ctrls: add support for compound types.
Date: Thu, 12 Jun 2014 13:52:37 +0200
Message-Id: <9ddfa0c66c43d812ebefd16a7cfeb1b538f0c5ca.1402573818.git.hans.verkuil@cisco.com>
In-Reply-To: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
References: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
References: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch implements initial support for compound types.

The changes are fairly obvious: basic support for is_ptr types, the
type_is_int function is replaced by a is_int bitfield, and
v4l2_query_ext_ctrl is added.

Note that this patch does not yet add support for N-dimensional
arrays, that comes later. So v4l2_query_ext_ctrl just sets elems to
1 and nr_of_dims and dims[] are all zero.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 224 ++++++++++++++++++++++++++---------
 include/media/v4l2-ctrls.h           |  23 +++-
 2 files changed, 187 insertions(+), 60 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 365884b..d5cd1aa 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1124,20 +1124,6 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 }
 EXPORT_SYMBOL(v4l2_ctrl_fill);
 
-/* Helper function to determine whether the control type is compatible with
-   VIDIOC_G/S_CTRL. */
-static bool type_is_int(const struct v4l2_ctrl *ctrl)
-{
-	switch (ctrl->type) {
-	case V4L2_CTRL_TYPE_INTEGER64:
-	case V4L2_CTRL_TYPE_STRING:
-		/* Nope, these need v4l2_ext_control */
-		return false;
-	default:
-		return true;
-	}
-}
-
 static void fill_event(struct v4l2_event *ev, struct v4l2_ctrl *ctrl, u32 changes)
 {
 	memset(ev->reserved, 0, sizeof(ev->reserved));
@@ -1146,7 +1132,7 @@ static void fill_event(struct v4l2_event *ev, struct v4l2_ctrl *ctrl, u32 change
 	ev->u.ctrl.changes = changes;
 	ev->u.ctrl.type = ctrl->type;
 	ev->u.ctrl.flags = ctrl->flags;
-	if (ctrl->type == V4L2_CTRL_TYPE_STRING)
+	if (ctrl->is_ptr)
 		ev->u.ctrl.value64 = 0;
 	else
 		ev->u.ctrl.value64 = ctrl->cur.val64;
@@ -1181,6 +1167,9 @@ static int cur_to_user(struct v4l2_ext_control *c,
 {
 	u32 len;
 
+	if (ctrl->is_ptr && !ctrl->is_string)
+		return copy_to_user(c->ptr, ctrl->cur.p, ctrl->elem_size);
+
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_STRING:
 		len = strlen(ctrl->cur.string);
@@ -1208,6 +1197,9 @@ static int user_to_new(struct v4l2_ext_control *c,
 	u32 size;
 
 	ctrl->is_new = 1;
+	if (ctrl->is_ptr && !ctrl->is_string)
+		return copy_from_user(ctrl->p, c->ptr, ctrl->elem_size);
+
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_INTEGER64:
 		ctrl->val64 = c->value64;
@@ -1242,6 +1234,9 @@ static int new_to_user(struct v4l2_ext_control *c,
 {
 	u32 len;
 
+	if (ctrl->is_ptr && !ctrl->is_string)
+		return copy_to_user(c->ptr, ctrl->p, ctrl->elem_size);
+
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_STRING:
 		len = strlen(ctrl->string);
@@ -1268,6 +1263,7 @@ static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 ch_flags)
 
 	if (ctrl == NULL)
 		return;
+
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_BUTTON:
 		changed = true;
@@ -1282,8 +1278,13 @@ static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 ch_flags)
 		ctrl->cur.val64 = ctrl->val64;
 		break;
 	default:
-		changed = ctrl->val != ctrl->cur.val;
-		ctrl->cur.val = ctrl->val;
+		if (ctrl->is_ptr) {
+			changed = memcmp(ctrl->p, ctrl->cur.p, ctrl->elem_size);
+			memcpy(ctrl->cur.p, ctrl->p, ctrl->elem_size);
+		} else {
+			changed = ctrl->val != ctrl->cur.val;
+			ctrl->cur.val = ctrl->val;
+		}
 		break;
 	}
 	if (ch_flags & V4L2_EVENT_CTRL_CH_FLAGS) {
@@ -1323,7 +1324,10 @@ static void cur_to_new(struct v4l2_ctrl *ctrl)
 		ctrl->val64 = ctrl->cur.val64;
 		break;
 	default:
-		ctrl->val = ctrl->cur.val;
+		if (ctrl->is_ptr)
+			memcpy(ctrl->p, ctrl->cur.p, ctrl->elem_size);
+		else
+			ctrl->val = ctrl->cur.val;
 		break;
 	}
 }
@@ -1536,7 +1540,7 @@ static struct v4l2_ctrl_ref *find_private_ref(
 		   VIDIOC_G/S_CTRL. */
 		if (V4L2_CTRL_ID2CLASS(ref->ctrl->id) == V4L2_CTRL_CLASS_USER &&
 		    V4L2_CTRL_DRIVER_PRIV(ref->ctrl->id)) {
-			if (!type_is_int(ref->ctrl))
+			if (!ref->ctrl->is_int)
 				continue;
 			if (id == 0)
 				return ref;
@@ -1606,8 +1610,12 @@ static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
 	u32 class_ctrl = V4L2_CTRL_ID2CLASS(id) | 1;
 	int bucket = id % hdl->nr_of_buckets;	/* which bucket to use */
 
-	/* Automatically add the control class if it is not yet present. */
-	if (id != class_ctrl && find_ref_lock(hdl, class_ctrl) == NULL)
+	/*
+	 * Automatically add the control class if it is not yet present and
+	 * the new control is not a compound control.
+	 */
+	if (ctrl->type < V4L2_CTRL_COMPOUND_TYPES &&
+	    id != class_ctrl && find_ref_lock(hdl, class_ctrl) == NULL)
 		if (!v4l2_ctrl_new_std(hdl, NULL, class_ctrl, 0, 0, 0, 0))
 			return hdl->error;
 
@@ -1668,18 +1676,28 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
 			u32 id, const char *name, enum v4l2_ctrl_type type,
 			s64 min, s64 max, u64 step, s64 def,
+			u32 elem_size,
 			u32 flags, const char * const *qmenu,
 			const s64 *qmenu_int, void *priv)
 {
 	struct v4l2_ctrl *ctrl;
-	unsigned sz_extra = 0;
+	unsigned sz_extra;
+	void *data;
 	int err;
 
 	if (hdl->error)
 		return NULL;
 
+	if (type == V4L2_CTRL_TYPE_INTEGER64)
+		elem_size = sizeof(s64);
+	else if (type == V4L2_CTRL_TYPE_STRING)
+		elem_size = max + 1;
+	else if (type < V4L2_CTRL_COMPOUND_TYPES)
+		elem_size = sizeof(s32);
+
 	/* Sanity checks */
 	if (id == 0 || name == NULL || id >= V4L2_CID_PRIVATE_BASE ||
+	    elem_size == 0 ||
 	    (type == V4L2_CTRL_TYPE_MENU && qmenu == NULL) ||
 	    (type == V4L2_CTRL_TYPE_INTEGER_MENU && qmenu_int == NULL)) {
 		handler_set_err(hdl, -ERANGE);
@@ -1695,12 +1713,13 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 		return NULL;
 	}
 
+	sz_extra = 0;
 	if (type == V4L2_CTRL_TYPE_BUTTON)
 		flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
 	else if (type == V4L2_CTRL_TYPE_CTRL_CLASS)
 		flags |= V4L2_CTRL_FLAG_READ_ONLY;
-	else if (type == V4L2_CTRL_TYPE_STRING)
-		sz_extra += 2 * (max + 1);
+	else if (type == V4L2_CTRL_TYPE_STRING || type >= V4L2_CTRL_COMPOUND_TYPES)
+		sz_extra += 2 * elem_size;
 
 	ctrl = kzalloc(sizeof(*ctrl) + sz_extra, GFP_KERNEL);
 	if (ctrl == NULL) {
@@ -1719,18 +1738,28 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	ctrl->minimum = min;
 	ctrl->maximum = max;
 	ctrl->step = step;
+	ctrl->default_value = def;
+	ctrl->is_string = type == V4L2_CTRL_TYPE_STRING;
+	ctrl->is_ptr = type >= V4L2_CTRL_COMPOUND_TYPES || ctrl->is_string;
+	ctrl->is_int = !ctrl->is_ptr && type != V4L2_CTRL_TYPE_INTEGER64;
+	ctrl->elem_size = elem_size;
 	if (type == V4L2_CTRL_TYPE_MENU)
 		ctrl->qmenu = qmenu;
 	else if (type == V4L2_CTRL_TYPE_INTEGER_MENU)
 		ctrl->qmenu_int = qmenu_int;
 	ctrl->priv = priv;
-	ctrl->cur.val = ctrl->val = ctrl->default_value = def;
+	ctrl->cur.val = ctrl->val = def;
+	data = &ctrl->cur + 1;
+
+	if (ctrl->is_string) {
+		ctrl->string = data;
+		ctrl->cur.string = data + elem_size;
 
-	if (ctrl->type == V4L2_CTRL_TYPE_STRING) {
-		ctrl->cur.string = (char *)&ctrl[1] + sz_extra - (max + 1);
-		ctrl->string = (char *)&ctrl[1] + sz_extra - 2 * (max + 1);
 		if (ctrl->minimum)
 			memset(ctrl->cur.string, ' ', ctrl->minimum);
+	} else if (ctrl->is_ptr) {
+		ctrl->p = data;
+		ctrl->cur.p = data + elem_size;
 	}
 	if (handler_new_ref(hdl, ctrl)) {
 		kfree(ctrl);
@@ -1778,7 +1807,8 @@ struct v4l2_ctrl *v4l2_ctrl_new_custom(struct v4l2_ctrl_handler *hdl,
 	ctrl = v4l2_ctrl_new(hdl, cfg->ops, cfg->id, name,
 			type, min, max,
 			is_menu ? cfg->menu_skip_mask : step,
-			def, flags, qmenu, qmenu_int, priv);
+			def, cfg->elem_size,
+			flags, qmenu, qmenu_int, priv);
 	if (ctrl)
 		ctrl->is_private = cfg->is_private;
 	return ctrl;
@@ -1795,13 +1825,15 @@ struct v4l2_ctrl *v4l2_ctrl_new_std(struct v4l2_ctrl_handler *hdl,
 	u32 flags;
 
 	v4l2_ctrl_fill(id, &name, &type, &min, &max, &step, &def, &flags);
-	if (type == V4L2_CTRL_TYPE_MENU
-	    || type == V4L2_CTRL_TYPE_INTEGER_MENU) {
+	if (type == V4L2_CTRL_TYPE_MENU ||
+	    type == V4L2_CTRL_TYPE_INTEGER_MENU ||
+	    type >= V4L2_CTRL_COMPOUND_TYPES) {
 		handler_set_err(hdl, -EINVAL);
 		return NULL;
 	}
 	return v4l2_ctrl_new(hdl, ops, id, name, type,
-			     min, max, step, def, flags, NULL, NULL, NULL);
+			     min, max, step, def, 0,
+			     flags, NULL, NULL, NULL);
 }
 EXPORT_SYMBOL(v4l2_ctrl_new_std);
 
@@ -1833,7 +1865,8 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
 		return NULL;
 	}
 	return v4l2_ctrl_new(hdl, ops, id, name, type,
-			     0, max, mask, def, flags, qmenu, qmenu_int, NULL);
+			     0, max, mask, def, 0,
+			     flags, qmenu, qmenu_int, NULL);
 }
 EXPORT_SYMBOL(v4l2_ctrl_new_std_menu);
 
@@ -1864,7 +1897,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu_items(struct v4l2_ctrl_handler *hdl,
 		return NULL;
 	}
 	return v4l2_ctrl_new(hdl, ops, id, name, type, 0, max, mask, def,
-			     flags, qmenu, NULL, NULL);
+			     0, flags, qmenu, NULL, NULL);
 
 }
 EXPORT_SYMBOL(v4l2_ctrl_new_std_menu_items);
@@ -1888,7 +1921,8 @@ struct v4l2_ctrl *v4l2_ctrl_new_int_menu(struct v4l2_ctrl_handler *hdl,
 		return NULL;
 	}
 	return v4l2_ctrl_new(hdl, ops, id, name, type,
-			     0, max, 0, def, flags, NULL, qmenu_int, NULL);
+			     0, max, 0, def, 0,
+			     flags, NULL, qmenu_int, NULL);
 }
 EXPORT_SYMBOL(v4l2_ctrl_new_int_menu);
 
@@ -2177,9 +2211,10 @@ int v4l2_ctrl_handler_setup(struct v4l2_ctrl_handler *hdl)
 }
 EXPORT_SYMBOL(v4l2_ctrl_handler_setup);
 
-/* Implement VIDIOC_QUERYCTRL */
-int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc)
+/* Implement VIDIOC_QUERY_EXT_CTRL */
+int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctrl *qc)
 {
+	const unsigned next_flags = V4L2_CTRL_FLAG_NEXT_CTRL | V4L2_CTRL_FLAG_NEXT_COMPOUND;
 	u32 id = qc->id & V4L2_CTRL_ID_MASK;
 	struct v4l2_ctrl_ref *ref;
 	struct v4l2_ctrl *ctrl;
@@ -2192,7 +2227,20 @@ int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc)
 	/* Try to find it */
 	ref = find_ref(hdl, id);
 
-	if ((qc->id & V4L2_CTRL_FLAG_NEXT_CTRL) && !list_empty(&hdl->ctrl_refs)) {
+	if ((qc->id & next_flags) && !list_empty(&hdl->ctrl_refs)) {
+		bool is_compound;
+		/* Match any control that is not hidden */
+		unsigned mask = 1;
+		bool match = false;
+
+		if ((qc->id & next_flags) == V4L2_CTRL_FLAG_NEXT_COMPOUND) {
+			/* Match any hidden control */
+			match = true;
+		} else if ((qc->id & next_flags) == next_flags) {
+			/* Match any control, compound or not */
+			mask = 0;
+		}
+
 		/* Find the next control with ID > qc->id */
 
 		/* Did we reach the end of the control list? */
@@ -2200,19 +2248,34 @@ int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc)
 			ref = NULL; /* Yes, so there is no next control */
 		} else if (ref) {
 			/* We found a control with the given ID, so just get
-			   the next one in the list. */
-			ref = list_entry(ref->node.next, typeof(*ref), node);
+			   the next valid one in the list. */
+			list_for_each_entry_continue(ref, &hdl->ctrl_refs, node) {
+				is_compound =
+					ref->ctrl->type >= V4L2_CTRL_COMPOUND_TYPES;
+				if (id < ref->ctrl->id &&
+				    (is_compound & mask) == match)
+					break;
+			}
+			if (&ref->node == &hdl->ctrl_refs)
+				ref = NULL;
 		} else {
 			/* No control with the given ID exists, so start
 			   searching for the next largest ID. We know there
 			   is one, otherwise the first 'if' above would have
 			   been true. */
-			list_for_each_entry(ref, &hdl->ctrl_refs, node)
-				if (id < ref->ctrl->id)
+			list_for_each_entry(ref, &hdl->ctrl_refs, node) {
+				is_compound =
+					ref->ctrl->type >= V4L2_CTRL_COMPOUND_TYPES;
+				if (id < ref->ctrl->id &&
+				    (is_compound & mask) == match)
 					break;
+			}
+			if (&ref->node == &hdl->ctrl_refs)
+				ref = NULL;
 		}
 	}
 	mutex_unlock(hdl->lock);
+
 	if (!ref)
 		return -EINVAL;
 
@@ -2223,6 +2286,12 @@ int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc)
 	else
 		qc->id = ctrl->id;
 	strlcpy(qc->name, ctrl->name, sizeof(qc->name));
+	qc->flags = ctrl->flags;
+	qc->type = ctrl->type;
+	if (ctrl->is_ptr)
+		qc->flags |= V4L2_CTRL_FLAG_HAS_PAYLOAD;
+	qc->elem_size = ctrl->elem_size;
+	qc->elems = 1;
 	qc->minimum = ctrl->minimum;
 	qc->maximum = ctrl->maximum;
 	qc->default_value = ctrl->default_value;
@@ -2231,15 +2300,50 @@ int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc)
 		qc->step = 1;
 	else
 		qc->step = ctrl->step;
-	qc->flags = ctrl->flags;
-	qc->type = ctrl->type;
+	return 0;
+}
+EXPORT_SYMBOL(v4l2_query_ext_ctrl);
+
+/* Implement VIDIOC_QUERYCTRL */
+int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc)
+{
+	struct v4l2_query_ext_ctrl qec = { qc->id };
+	int rc;
+
+	rc = v4l2_query_ext_ctrl(hdl, &qec);
+	if (rc)
+		return rc;
+
+	qc->id = qec.id;
+	qc->type = qec.type;
+	qc->flags = qec.flags;
+	strlcpy(qc->name, qec.name, sizeof(qc->name));
+	switch (qc->type) {
+	case V4L2_CTRL_TYPE_INTEGER:
+	case V4L2_CTRL_TYPE_BOOLEAN:
+	case V4L2_CTRL_TYPE_MENU:
+	case V4L2_CTRL_TYPE_INTEGER_MENU:
+	case V4L2_CTRL_TYPE_STRING:
+	case V4L2_CTRL_TYPE_BITMASK:
+		qc->minimum = qec.minimum;
+		qc->maximum = qec.maximum;
+		qc->step = qec.step;
+		qc->default_value = qec.default_value;
+		break;
+	default:
+		qc->minimum = 0;
+		qc->maximum = 0;
+		qc->step = 0;
+		qc->default_value = 0;
+		break;
+	}
 	return 0;
 }
 EXPORT_SYMBOL(v4l2_queryctrl);
 
 int v4l2_subdev_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
 {
-	if (qc->id & V4L2_CTRL_FLAG_NEXT_CTRL)
+	if (qc->id & (V4L2_CTRL_FLAG_NEXT_CTRL | V4L2_CTRL_FLAG_NEXT_COMPOUND))
 		return -EINVAL;
 	return v4l2_queryctrl(sd->ctrl_handler, qc);
 }
@@ -2339,7 +2443,8 @@ EXPORT_SYMBOL(v4l2_subdev_querymenu);
    Find the controls in the control array and do some basic checks. */
 static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 			     struct v4l2_ext_controls *cs,
-			     struct v4l2_ctrl_helper *helpers)
+			     struct v4l2_ctrl_helper *helpers,
+			     bool get)
 {
 	struct v4l2_ctrl_helper *h;
 	bool have_clusters = false;
@@ -2371,6 +2476,13 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 			have_clusters = true;
 		if (ctrl->cluster[0] != ctrl)
 			ref = find_ref_lock(hdl, ctrl->cluster[0]->id);
+		if (ctrl->is_ptr && !ctrl->is_string && c->size < ctrl->elem_size) {
+			if (get) {
+				c->size = ctrl->elem_size;
+				return -ENOSPC;
+			}
+			return -EFAULT;
+		}
 		/* Store the ref to the master control of the cluster */
 		h->mref = ref;
 		h->ctrl = ctrl;
@@ -2451,7 +2563,7 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 			return -ENOMEM;
 	}
 
-	ret = prepare_ext_ctrls(hdl, cs, helpers);
+	ret = prepare_ext_ctrls(hdl, cs, helpers, true);
 	cs->error_idx = cs->count;
 
 	for (i = 0; !ret && i < cs->count; i++)
@@ -2513,11 +2625,11 @@ static int get_ctrl(struct v4l2_ctrl *ctrl, struct v4l2_ext_control *c)
 	int ret = 0;
 	int i;
 
-	/* String controls are not supported. The new_to_user() and
+	/* Compound controls are not supported. The new_to_user() and
 	 * cur_to_user() calls below would need to be modified not to access
 	 * userspace memory when called from get_ctrl().
 	 */
-	if (ctrl->type == V4L2_CTRL_TYPE_STRING)
+	if (!ctrl->is_int)
 		return -EINVAL;
 
 	if (ctrl->flags & V4L2_CTRL_FLAG_WRITE_ONLY)
@@ -2543,7 +2655,7 @@ int v4l2_g_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_control *control)
 	struct v4l2_ext_control c;
 	int ret;
 
-	if (ctrl == NULL || !type_is_int(ctrl))
+	if (ctrl == NULL || !ctrl->is_int)
 		return -EINVAL;
 	ret = get_ctrl(ctrl, &c);
 	control->value = c.value;
@@ -2562,7 +2674,7 @@ s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl)
 	struct v4l2_ext_control c;
 
 	/* It's a driver bug if this happens. */
-	WARN_ON(!type_is_int(ctrl));
+	WARN_ON(!ctrl->is_int);
 	c.value = 0;
 	get_ctrl(ctrl, &c);
 	return c.value;
@@ -2698,7 +2810,7 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 		if (!helpers)
 			return -ENOMEM;
 	}
-	ret = prepare_ext_ctrls(hdl, cs, helpers);
+	ret = prepare_ext_ctrls(hdl, cs, helpers, false);
 	if (!ret)
 		ret = validate_ctrls(cs, helpers, set);
 	if (ret && set)
@@ -2803,11 +2915,11 @@ static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
 	struct v4l2_ctrl *master = ctrl->cluster[0];
 	int i;
 
-	/* String controls are not supported. The user_to_new() and
+	/* Compound controls are not supported. The user_to_new() and
 	 * cur_to_user() calls below would need to be modified not to access
 	 * userspace memory when called from set_ctrl().
 	 */
-	if (ctrl->type == V4L2_CTRL_TYPE_STRING)
+	if (ctrl->is_ptr)
 		return -EINVAL;
 
 	/* Reset the 'is_new' flags of the cluster */
@@ -2849,7 +2961,7 @@ int v4l2_s_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 	struct v4l2_ext_control c;
 	int ret;
 
-	if (ctrl == NULL || !type_is_int(ctrl))
+	if (ctrl == NULL || !ctrl->is_int)
 		return -EINVAL;
 
 	if (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY)
@@ -2873,7 +2985,7 @@ int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
 	struct v4l2_ext_control c;
 
 	/* It's a driver bug if this happens. */
-	WARN_ON(!type_is_int(ctrl));
+	WARN_ON(!ctrl->is_int);
 	c.value = val;
 	return set_ctrl_lock(NULL, ctrl, &c);
 }
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index a2e8f03..9024dae 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -73,6 +73,12 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
   *		members are in 'automatic' mode or 'manual' mode. This is
   *		used for autogain/gain type clusters. Drivers should never
   *		set this flag directly.
+  * @is_int:    If set, then this control has a simple integer value (i.e. it
+  *		uses ctrl->val).
+  * @is_string: If set, then this control has type V4L2_CTRL_TYPE_STRING.
+  * @is_ptr:	If set, then this control is an array and/or has type >= V4L2_CTRL_COMPOUND_TYPES
+  *		and/or has type V4L2_CTRL_TYPE_STRING. In other words, struct
+  *		v4l2_ext_control uses field p to point to the data.
   * @has_volatiles: If set, then one or more members of the cluster are volatile.
   *		Drivers should never touch this flag.
   * @call_notify: If set, then call the handler's notify function whenever the
@@ -90,6 +96,7 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
   * @maximum:	The control's maximum value.
   * @default_value: The control's default value.
   * @step:	The control's step value for non-menu controls.
+  * @elem_size:	The size in bytes of the control.
   * @menu_skip_mask: The control's skip mask for menu controls. This makes it
   *		easy to skip menu items that are not valid. If bit X is set,
   *		then menu item X is skipped. Of course, this only works for
@@ -104,7 +111,6 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
   * @cur:	The control's current value.
   * @val:	The control's new s32 value.
   * @val64:	The control's new s64 value.
-  * @string:	The control's new string value.
   * @priv:	The control's private pointer. For use by the driver. It is
   *		untouched by the control framework. Note that this pointer is
   *		not freed when the control is deleted. Should this be needed
@@ -123,6 +129,9 @@ struct v4l2_ctrl {
 	unsigned int is_new:1;
 	unsigned int is_private:1;
 	unsigned int is_auto:1;
+	unsigned int is_int:1;
+	unsigned int is_string:1;
+	unsigned int is_ptr:1;
 	unsigned int has_volatiles:1;
 	unsigned int call_notify:1;
 	unsigned int manual_mode_value:8;
@@ -132,6 +141,7 @@ struct v4l2_ctrl {
 	const char *name;
 	enum v4l2_ctrl_type type;
 	s64 minimum, maximum, default_value;
+	u32 elem_size;
 	union {
 		u64 step;
 		u64 menu_skip_mask;
@@ -141,17 +151,19 @@ struct v4l2_ctrl {
 		const s64 *qmenu_int;
 	};
 	unsigned long flags;
+	void *priv;
 	union {
 		s32 val;
 		s64 val64;
 		char *string;
-	} cur;
+		void *p;
+	};
 	union {
 		s32 val;
 		s64 val64;
 		char *string;
-	};
-	void *priv;
+		void *p;
+	} cur;
 };
 
 /** struct v4l2_ctrl_ref - The control reference.
@@ -212,6 +224,7 @@ struct v4l2_ctrl_handler {
   * @max:	The control's maximum value.
   * @step:	The control's step value for non-menu controls.
   * @def: 	The control's default value.
+  * @elem_size:	The size in bytes of the control.
   * @flags:	The control's flags.
   * @menu_skip_mask: The control's skip mask for menu controls. This makes it
   *		easy to skip menu items that are not valid. If bit X is set,
@@ -235,6 +248,7 @@ struct v4l2_ctrl_config {
 	s64 max;
 	u64 step;
 	s64 def;
+	u32 elem_size;
 	u32 flags;
 	u64 menu_skip_mask;
 	const char * const *qmenu;
@@ -659,6 +673,7 @@ unsigned int v4l2_ctrl_poll(struct file *file, struct poll_table_struct *wait);
 
 /* Helpers for ioctl_ops. If hdl == NULL then they will all return -EINVAL. */
 int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc);
+int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctrl *qc);
 int v4l2_querymenu(struct v4l2_ctrl_handler *hdl, struct v4l2_querymenu *qm);
 int v4l2_g_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_control *ctrl);
 int v4l2_s_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
-- 
2.0.0.rc0

