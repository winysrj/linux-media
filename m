Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4073 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbaAFOVm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 09:21:42 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 12/27] v4l2-ctrls: add initial support for configuration stores.
Date: Mon,  6 Jan 2014 15:21:11 +0100
Message-Id: <1389018086-15903-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1389018086-15903-1-git-send-email-hverkuil@xs4all.nl>
References: <1389018086-15903-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for multiple configuration stores. Three new fields are added to
v4l2_ctrl:

nstores: the number of stores for this control
store: the current store: for use by the control ops
cur_store: the store associated with the current value. Normally 0, but
        it can be a specific store if stores map to shadow registers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 157 +++++++++++++++++++++++++----------
 include/media/v4l2-ctrls.h           |  11 ++-
 2 files changed, 122 insertions(+), 46 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 9b0362e..3e32e21 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1162,7 +1162,7 @@ static void std_init(const struct v4l2_ctrl *ctrl,
 
 static void std_log(const struct v4l2_ctrl *ctrl)
 {
-	union v4l2_ctrl_ptr ptr = ctrl->stores[0];
+	union v4l2_ctrl_ptr ptr = ctrl->stores[ctrl->cur_store];
 
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_INTEGER:
@@ -1304,6 +1304,13 @@ static int new_to_user(struct v4l2_ext_control *c,
 	return ptr_to_user(c, ctrl, ctrl->new);
 }
 
+static int store_to_user(struct v4l2_ext_control *c,
+			 struct v4l2_ctrl *ctrl,
+			 unsigned store)
+{
+	return ptr_to_user(c, ctrl, ctrl->stores[store ? store : ctrl->cur_store]);
+}
+
 /* Helper function: copy the caller-provider value to the given control value */
 static int user_to_ptr(struct v4l2_ext_control *c,
 		       struct v4l2_ctrl *ctrl,
@@ -1375,14 +1382,15 @@ static void ptr_to_ptr(struct v4l2_ctrl *ctrl,
 }
 
 /* Copy the new value to the current value. */
-static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 ch_flags)
+static void new_to_store(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 ch_flags)
 {
+	union v4l2_ctrl_ptr store = ctrl->stores[ctrl->store];
 	bool changed;
 
 	if (ctrl == NULL)
 		return;
-	changed = !ctrl->type_ops->equal(ctrl, ctrl->stores[0], ctrl->new);
-	ptr_to_ptr(ctrl, ctrl->new, ctrl->stores[0]);
+	changed = !ctrl->type_ops->equal(ctrl, store, ctrl->new);
+	ptr_to_ptr(ctrl, ctrl->new, store);
 
 	if (ch_flags & V4L2_EVENT_CTRL_CH_FLAGS) {
 		/* Note: CH_FLAGS is only set for auto clusters. */
@@ -1709,6 +1717,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 			enum v4l2_ctrl_type type,
 			s64 min, s64 max, u64 step, s64 def,
 			u32 elem_size,
+			u32 nstores, u32 initial_store,
 			u32 flags, const char * const *qmenu,
 			const s64 *qmenu_int, void *priv)
 {
@@ -1758,14 +1767,25 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 		handler_set_err(hdl, -ERANGE);
 		return NULL;
 	}
+	if (nstores &&
+	    (type == V4L2_CTRL_TYPE_BUTTON ||
+	     type == V4L2_CTRL_TYPE_CTRL_CLASS)) {
+		handler_set_err(hdl, -EINVAL);
+		return NULL;
+	}
+
+	if (nstores)
+		flags |= V4L2_CTRL_FLAG_CAN_STORE;
+	sz_extra = (1 + nstores) * sizeof(union v4l2_ctrl_ptr);
 
-	sz_extra = sizeof(union v4l2_ctrl_ptr);
 	if (type == V4L2_CTRL_TYPE_BUTTON)
 		flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
 	else if (type == V4L2_CTRL_TYPE_CTRL_CLASS)
 		flags |= V4L2_CTRL_FLAG_READ_ONLY;
 	else if (type == V4L2_CTRL_TYPE_STRING || type >= V4L2_PROP_TYPES)
-		sz_extra += 2 * elem_size;
+		sz_extra += (2 + nstores) * elem_size;
+	else
+		sz_extra += nstores * elem_size;
 
 	ctrl = kzalloc(sizeof(*ctrl) + sz_extra, GFP_KERNEL);
 	if (ctrl == NULL) {
@@ -1791,22 +1811,27 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	ctrl->is_ptr = type >= V4L2_PROP_TYPES || ctrl->is_string;
 	ctrl->is_int = !ctrl->is_ptr && type != V4L2_CTRL_TYPE_INTEGER64;
 	ctrl->elem_size = elem_size;
+	ctrl->nstores = nstores;
+	ctrl->cur_store = initial_store;
 	if (type == V4L2_CTRL_TYPE_MENU)
 		ctrl->qmenu = qmenu;
 	else if (type == V4L2_CTRL_TYPE_INTEGER_MENU)
 		ctrl->qmenu_int = qmenu_int;
 	ctrl->priv = priv;
 	ctrl->cur.val = ctrl->val = def;
-	props = &ctrl->stores[1];
+	props = &ctrl->stores[1 + nstores];
 
 	if (ctrl->is_ptr) {
 		ctrl->p = ctrl->new.p = props;
-		ctrl->stores[0].p = props + elem_size;
+		for (s = 0; s <= nstores; s++)
+			ctrl->stores[s].p = props + (s + 1) * elem_size;
 	} else {
 		ctrl->new.p = &ctrl->val;
 		ctrl->stores[0].p = &ctrl->cur.val;
+		for (s = 1; s <= nstores; s++)
+			ctrl->stores[s].p = props + (s - 1) * elem_size;
 	}
-	for (s = -1; s <= 0; s++)
+	for (s = -1; s <= (int)nstores; s++)
 		ctrl->type_ops->init(ctrl, ctrl->stores[s]);
 
 	if (handler_new_ref(hdl, ctrl)) {
@@ -1857,6 +1882,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_custom(struct v4l2_ctrl_handler *hdl,
 			type, min, max,
 			is_menu ? cfg->menu_skip_mask : step,
 			def, cfg->elem_size,
+			cfg->nstores, cfg->initial_store,
 			flags, qmenu, qmenu_int, priv);
 	if (ctrl)
 		ctrl->is_private = cfg->is_private;
@@ -1882,7 +1908,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_std(struct v4l2_ctrl_handler *hdl,
 		return NULL;
 	}
 	return v4l2_ctrl_new(hdl, ops, NULL, id, name, unit, type,
-			     min, max, step, def, 0,
+			     min, max, step, def, 0, 0, 0,
 			     flags, NULL, NULL, NULL);
 }
 EXPORT_SYMBOL(v4l2_ctrl_new_std);
@@ -1916,7 +1942,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
 		return NULL;
 	}
 	return v4l2_ctrl_new(hdl, ops, NULL, id, name, unit, type,
-			     0, max, mask, def, 0,
+			     0, max, mask, def, 0, 0, 0,
 			     flags, qmenu, qmenu_int, NULL);
 }
 EXPORT_SYMBOL(v4l2_ctrl_new_std_menu);
@@ -1949,8 +1975,8 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu_items(struct v4l2_ctrl_handler *hdl,
 		return NULL;
 	}
 	return v4l2_ctrl_new(hdl, ops, NULL, id, name, unit, type,
-			     0, max, mask, def,
-			     0, flags, qmenu, NULL, NULL);
+			     0, max, mask, def, 0, 0, 0,
+			     flags, qmenu, NULL, NULL);
 
 }
 EXPORT_SYMBOL(v4l2_ctrl_new_std_menu_items);
@@ -1975,7 +2001,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_int_menu(struct v4l2_ctrl_handler *hdl,
 		return NULL;
 	}
 	return v4l2_ctrl_new(hdl, ops, NULL, id, name, unit, type,
-			     0, max, 0, def, 0,
+			     0, max, 0, def, 0, 0, 0,
 			     flags, NULL, qmenu_int, NULL);
 }
 EXPORT_SYMBOL(v4l2_ctrl_new_int_menu);
@@ -2225,11 +2251,12 @@ int v4l2_ctrl_handler_setup(struct v4l2_ctrl_handler *hdl)
 			continue;
 
 		for (i = 0; i < master->ncontrols; i++) {
-			if (master->cluster[i]) {
-				cur_to_new(master->cluster[i]);
-				master->cluster[i]->is_new = 1;
-				master->cluster[i]->done = true;
-			}
+			if (master->cluster[i] == NULL)
+				continue;
+			cur_to_new(master->cluster[i]);
+			master->cluster[i]->is_new = 1;
+			master->cluster[i]->done = true;
+			master->cluster[i]->store = master->cur_store;
 		}
 		ret = call_op(master, s_ctrl);
 		if (ret)
@@ -2249,7 +2276,7 @@ int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctr
 	struct v4l2_ctrl_ref *ref;
 	struct v4l2_ctrl *ctrl;
 
-	if (hdl == NULL || store)
+	if (hdl == NULL)
 		return -EINVAL;
 
 	mutex_lock(hdl->lock);
@@ -2276,6 +2303,7 @@ int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctr
 			   the next valid one in the list. */
 			list_for_each_entry_continue(ref, &hdl->ctrl_refs, node)
 				if (id < ref->ctrl->id &&
+				    store <= ref->ctrl->nstores &&
 				    (ref->ctrl->flags & mask) == match)
 					break;
 			if (&ref->node == &hdl->ctrl_refs)
@@ -2287,6 +2315,7 @@ int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctr
 			   been true. */
 			list_for_each_entry(ref, &hdl->ctrl_refs, node)
 				if (id < ref->ctrl->id &&
+				    store <= ref->ctrl->nstores &&
 				    (ref->ctrl->flags & mask) == match)
 					break;
 			if (&ref->node == &hdl->ctrl_refs)
@@ -2312,6 +2341,7 @@ int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctr
 	if (ctrl->unit)
 		strlcpy(qc->unit, ctrl->unit, sizeof(qc->unit));
 	qc->elem_size = ctrl->elem_size;
+	qc->config_store = store;
 	qc->min.val = ctrl->minimum;
 	qc->max.val = ctrl->maximum;
 	qc->def.val = ctrl->default_value;
@@ -2465,6 +2495,8 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 			     bool get)
 {
 	struct v4l2_ctrl_helper *h;
+	u32 ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
+	unsigned store = cs->config_store & 0xffff;
 	bool have_clusters = false;
 	u32 i;
 
@@ -2476,7 +2508,7 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 
 		cs->error_idx = i;
 
-		if (cs->ctrl_class && V4L2_CTRL_ID2CLASS(id) != cs->ctrl_class)
+		if (ctrl_class && V4L2_CTRL_ID2CLASS(id) != ctrl_class)
 			return -EINVAL;
 
 		/* Old-style private controls are not allowed for
@@ -2489,6 +2521,8 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 		ctrl = ref->ctrl;
 		if (ctrl->flags & V4L2_CTRL_FLAG_DISABLED)
 			return -EINVAL;
+		if (store > ctrl->nstores)
+			return -EINVAL;
 
 		if (ctrl->cluster[0]->ncontrols > 1)
 			have_clusters = true;
@@ -2562,17 +2596,21 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 {
 	struct v4l2_ctrl_helper helper[4];
 	struct v4l2_ctrl_helper *helpers = helper;
+	unsigned store = 0;
 	int ret;
 	int i, j;
 
 	cs->error_idx = cs->count;
-	cs->ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
+	if (V4L2_CTRL_ID2CLASS(cs->ctrl_class))
+		cs->ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
+	else
+		store = cs->config_store;
 
 	if (hdl == NULL)
 		return -EINVAL;
 
 	if (cs->count == 0)
-		return class_check(hdl, cs->ctrl_class);
+		return class_check(hdl, V4L2_CTRL_ID2CLASS(cs->ctrl_class));
 
 	if (cs->count > ARRAY_SIZE(helper)) {
 		helpers = kmalloc_array(cs->count, sizeof(helper[0]),
@@ -2589,8 +2627,7 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 			ret = -EACCES;
 
 	for (i = 0; !ret && i < cs->count; i++) {
-		int (*ctrl_to_user)(struct v4l2_ext_control *c,
-				    struct v4l2_ctrl *ctrl) = cur_to_user;
+		bool from_new = false;
 		struct v4l2_ctrl *master;
 
 		if (helpers[i].mref == NULL)
@@ -2602,12 +2639,18 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 		v4l2_ctrl_lock(master);
 
 		/* g_volatile_ctrl will update the new control values */
-		if ((master->flags & V4L2_CTRL_FLAG_VOLATILE) ||
-			(master->has_volatiles && !is_cur_manual(master))) {
-			for (j = 0; j < master->ncontrols; j++)
+		/* Note: volatile configuration stores are not supported (yet) */
+		if (store == master->cur_store &&
+		    ((master->flags & V4L2_CTRL_FLAG_VOLATILE) ||
+		     (master->has_volatiles && !is_cur_manual(master)))) {
+			for (j = 0; j < master->ncontrols; j++) {
+				if (master->cluster[j] == NULL)
+					continue;
 				cur_to_new(master->cluster[j]);
+				master->cluster[j]->store = store;
+			}
 			ret = call_op(master, g_volatile_ctrl);
-			ctrl_to_user = new_to_user;
+			from_new = true;
 		}
 		/* If OK, then copy the current (for non-volatile controls)
 		   or the new (for volatile controls) control values to the
@@ -2616,8 +2659,13 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 			u32 idx = i;
 
 			do {
-				ret = ctrl_to_user(cs->controls + idx,
+				if (from_new)
+					ret = new_to_user(cs->controls + idx,
 						   helpers[idx].ctrl);
+				else
+					ret = store_to_user(cs->controls + idx,
+						   helpers[idx].ctrl,
+						   store);
 				idx = helpers[idx].next;
 			} while (!ret && idx);
 		}
@@ -2656,8 +2704,12 @@ static int get_ctrl(struct v4l2_ctrl *ctrl, struct v4l2_ext_control *c)
 	v4l2_ctrl_lock(master);
 	/* g_volatile_ctrl will update the current control values */
 	if (ctrl->flags & V4L2_CTRL_FLAG_VOLATILE) {
-		for (i = 0; i < master->ncontrols; i++)
+		for (i = 0; i < master->ncontrols; i++) {
+			if (master->cluster[i] == NULL)
+				continue;
 			cur_to_new(master->cluster[i]);
+			master->cluster[i]->store = master->cur_store;
+		}
 		ret = call_op(master, g_volatile_ctrl);
 		new_to_user(c, ctrl);
 	} else {
@@ -2716,7 +2768,7 @@ EXPORT_SYMBOL(v4l2_ctrl_g_ctrl_int64);
    copied to the current value on a set.
    Must be called with ctrl->handler->lock held. */
 static int try_or_set_cluster(struct v4l2_fh *fh, struct v4l2_ctrl *master,
-			      bool set, u32 ch_flags)
+			      u32 store, bool set, u32 ch_flags)
 {
 	bool update_flag;
 	int ret;
@@ -2732,6 +2784,7 @@ static int try_or_set_cluster(struct v4l2_fh *fh, struct v4l2_ctrl *master,
 		if (ctrl == NULL)
 			continue;
 
+		ctrl->store = store;
 		if (!ctrl->is_new) {
 			cur_to_new(ctrl);
 			continue;
@@ -2754,7 +2807,7 @@ static int try_or_set_cluster(struct v4l2_fh *fh, struct v4l2_ctrl *master,
 	/* If OK, then make the new values permanent. */
 	update_flag = is_cur_manual(master) != is_new_manual(master);
 	for (i = 0; i < master->ncontrols; i++)
-		new_to_cur(fh, master->cluster[i], ch_flags |
+		new_to_store(fh, master->cluster[i], ch_flags |
 			((update_flag && i > 0) ? V4L2_EVENT_CTRL_CH_FLAGS : 0));
 	return 0;
 }
@@ -2795,8 +2848,12 @@ static void update_from_auto_cluster(struct v4l2_ctrl *master)
 {
 	int i;
 
-	for (i = 0; i < master->ncontrols; i++)
+	for (i = 0; i < master->ncontrols; i++) {
+		if (master->cluster[i] == NULL)
+			continue;
 		cur_to_new(master->cluster[i]);
+		master->cluster[i]->store = master->cur_store;
+	}
 	if (!call_op(master, g_volatile_ctrl))
 		for (i = 1; i < master->ncontrols; i++)
 			if (master->cluster[i])
@@ -2810,17 +2867,21 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 {
 	struct v4l2_ctrl_helper helper[4];
 	struct v4l2_ctrl_helper *helpers = helper;
+	unsigned store = 0;
 	unsigned i, j;
 	int ret;
 
 	cs->error_idx = cs->count;
-	cs->ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
+	if (V4L2_CTRL_ID2CLASS(cs->ctrl_class))
+		cs->ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
+	else
+		store = cs->config_store;
 
 	if (hdl == NULL)
 		return -EINVAL;
 
 	if (cs->count == 0)
-		return class_check(hdl, cs->ctrl_class);
+		return class_check(hdl, V4L2_CTRL_ID2CLASS(cs->ctrl_class));
 
 	if (cs->count > ARRAY_SIZE(helper)) {
 		helpers = kmalloc_array(cs->count, sizeof(helper[0]),
@@ -2855,8 +2916,8 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 		   first since those will become the new manual values (which
 		   may be overwritten by explicit new values from this set
 		   of controls). */
-		if (master->is_auto && master->has_volatiles &&
-						!is_cur_manual(master)) {
+		if (store == master->cur_store && master->is_auto &&
+		    master->has_volatiles && !is_cur_manual(master)) {
 			/* Pick an initial non-manual value */
 			s32 new_auto_val = master->manual_mode_value + 1;
 			u32 tmp_idx = idx;
@@ -2868,6 +2929,7 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 					new_auto_val = cs->controls[tmp_idx].value;
 				tmp_idx = helpers[tmp_idx].next;
 			} while (tmp_idx);
+
 			/* If the new value == the manual value, then copy
 			   the current volatile values. */
 			if (new_auto_val == master->manual_mode_value)
@@ -2882,14 +2944,16 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 		} while (!ret && idx);
 
 		if (!ret)
-			ret = try_or_set_cluster(fh, master, set, 0);
+			ret = try_or_set_cluster(fh, master,
+					store ? store : master->cur_store,
+					set, 0);
 
 		/* Copy the new values back to userspace. */
 		if (!ret) {
 			idx = i;
 			do {
-				ret = new_to_user(cs->controls + idx,
-						helpers[idx].ctrl);
+				ret = store_to_user(cs->controls + idx,
+						helpers[idx].ctrl, store);
 				idx = helpers[idx].next;
 			} while (!ret && idx);
 		}
@@ -2941,9 +3005,12 @@ static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
 		return -EINVAL;
 
 	/* Reset the 'is_new' flags of the cluster */
-	for (i = 0; i < master->ncontrols; i++)
-		if (master->cluster[i])
-			master->cluster[i]->is_new = 0;
+	for (i = 0; i < master->ncontrols; i++) {
+		if (master->cluster[i] == NULL)
+			continue;
+		master->cluster[i]->is_new = 0;
+		master->cluster[i]->store = master->cur_store;
+	}
 
 	/* For autoclusters with volatiles that are switched from auto to
 	   manual mode we have to update the current volatile values since
@@ -2953,7 +3020,7 @@ static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
 		update_from_auto_cluster(master);
 
 	user_to_new(c, ctrl);
-	return try_or_set_cluster(fh, master, true, ch_flags);
+	return try_or_set_cluster(fh, master, master->cur_store, true, ch_flags);
 }
 
 /* Helper function for VIDIOC_S_CTRL compatibility */
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index b889778..911b22a 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -92,6 +92,9 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
   * @handler:	The handler that owns the control.
   * @cluster:	Point to start of cluster array.
   * @ncontrols:	Number of controls in cluster array.
+  * @nstores:	Number of configuration stores for this control.
+  * @store:	The configuration store that the control op operates on.
+  * @cur_store:	The configuration store used for the current value.
   * @done:	Internal flag: set for each processed control.
   * @is_new:	Set when the user specified a new value for this control. It
   *		is also set when called from v4l2_ctrl_handler_setup. Drivers
@@ -155,7 +158,10 @@ struct v4l2_ctrl {
 	struct list_head ev_subs;
 	struct v4l2_ctrl_handler *handler;
 	struct v4l2_ctrl **cluster;
-	unsigned ncontrols;
+	u16 ncontrols;
+	u16 nstores;
+	u16 store;
+	u16 cur_store;
 	unsigned int done:1;
 
 	unsigned int is_new:1;
@@ -263,6 +269,8 @@ struct v4l2_ctrl_handler {
   * @step:	The control's step value for non-menu controls.
   * @def: 	The control's default value.
   * @elem_size:	The size in bytes of the control.
+  * @nstores:	The number of configuration stores.
+  * @initial_store: The configuration store used as the initial current value.
   * @flags:	The control's flags.
   * @menu_skip_mask: The control's skip mask for menu controls. This makes it
   *		easy to skip menu items that are not valid. If bit X is set,
@@ -289,6 +297,7 @@ struct v4l2_ctrl_config {
 	u64 step;
 	s64 def;
 	u32 elem_size;
+	u32 nstores, initial_store;
 	u32 flags;
 	u64 menu_skip_mask;
 	const char * const *qmenu;
-- 
1.8.5.2

