Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3398 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaIUOsp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Sep 2014 10:48:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 04/11] v4l2-ctrls: add config store support
Date: Sun, 21 Sep 2014 16:48:22 +0200
Message-Id: <1411310909-32825-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl>
References: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 150 +++++++++++++++++++++++++++++------
 drivers/media/v4l2-core/v4l2-ioctl.c |   4 +-
 include/media/v4l2-ctrls.h           |  14 ++++
 3 files changed, 141 insertions(+), 27 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 35d1f3d..df0f3ee 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1478,6 +1478,15 @@ static int cur_to_user(struct v4l2_ext_control *c,
 	return ptr_to_user(c, ctrl, ctrl->p_cur);
 }
 
+/* Helper function: copy the store's control value back to the caller */
+static int store_to_user(struct v4l2_ext_control *c,
+		       struct v4l2_ctrl *ctrl, unsigned store)
+{
+	if (store == 0)
+		return ptr_to_user(c, ctrl, ctrl->p_new);
+	return ptr_to_user(c, ctrl, ctrl->p_stores[store - 1]);
+}
+
 /* Helper function: copy the new control value back to the caller */
 static int new_to_user(struct v4l2_ext_control *c,
 		       struct v4l2_ctrl *ctrl)
@@ -1585,6 +1594,14 @@ static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 ch_flags)
 	}
 }
 
+/* Helper function: copy the new control value to the store */
+static void new_to_store(struct v4l2_ctrl *ctrl)
+{
+	/* has_changed is set by cluster_changed */
+	if (ctrl && ctrl->has_changed)
+		ptr_to_ptr(ctrl, ctrl->p_new, ctrl->p_stores[ctrl->store - 1]);
+}
+
 /* Copy the current value to the new value */
 static void cur_to_new(struct v4l2_ctrl *ctrl)
 {
@@ -1603,13 +1620,18 @@ static int cluster_changed(struct v4l2_ctrl *master)
 
 	for (i = 0; i < master->ncontrols; i++) {
 		struct v4l2_ctrl *ctrl = master->cluster[i];
+		union v4l2_ctrl_ptr ptr;
 		bool ctrl_changed = false;
 
 		if (ctrl == NULL)
 			continue;
+		if (ctrl->store)
+			ptr = ctrl->p_stores[ctrl->store - 1];
+		else
+			ptr = ctrl->p_cur;
 		for (idx = 0; !ctrl_changed && idx < ctrl->elems; idx++)
 			ctrl_changed = !ctrl->type_ops->equal(ctrl, idx,
-				ctrl->p_cur, ctrl->p_new);
+				ptr, ctrl->p_new);
 		ctrl->has_changed = ctrl_changed;
 		changed |= ctrl->has_changed;
 	}
@@ -1740,6 +1762,13 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
 		list_del(&ctrl->node);
 		list_for_each_entry_safe(sev, next_sev, &ctrl->ev_subs, node)
 			list_del(&sev->node);
+		if (ctrl->p_stores) {
+			unsigned s;
+
+			for (s = 0; s < ctrl->nr_of_stores; s++)
+				kfree(ctrl->p_stores[s].p);
+		}
+		kfree(ctrl->p_stores);
 		kfree(ctrl);
 	}
 	kfree(hdl->buckets);
@@ -1970,7 +1999,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 		handler_set_err(hdl, -ERANGE);
 		return NULL;
 	}
-	if (is_array &&
+	if ((is_array || (flags & V4L2_CTRL_FLAG_CAN_STORE)) &&
 	    (type == V4L2_CTRL_TYPE_BUTTON ||
 	     type == V4L2_CTRL_TYPE_CTRL_CLASS)) {
 		handler_set_err(hdl, -EINVAL);
@@ -2084,8 +2113,10 @@ struct v4l2_ctrl *v4l2_ctrl_new_custom(struct v4l2_ctrl_handler *hdl,
 			is_menu ? cfg->menu_skip_mask : step, def,
 			cfg->dims, cfg->elem_size,
 			flags, qmenu, qmenu_int, priv);
-	if (ctrl)
+	if (ctrl) {
 		ctrl->is_private = cfg->is_private;
+		ctrl->can_store = cfg->can_store;
+	}
 	return ctrl;
 }
 EXPORT_SYMBOL(v4l2_ctrl_new_custom);
@@ -2452,6 +2483,7 @@ int v4l2_ctrl_handler_setup(struct v4l2_ctrl_handler *hdl)
 				cur_to_new(master->cluster[i]);
 				master->cluster[i]->is_new = 1;
 				master->cluster[i]->done = true;
+				master->cluster[i]->store = 0;
 			}
 		}
 		ret = call_op(master, s_ctrl);
@@ -2539,6 +2571,8 @@ int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctr
 		qc->id = ctrl->id;
 	strlcpy(qc->name, ctrl->name, sizeof(qc->name));
 	qc->flags = ctrl->flags;
+	if (ctrl->can_store)
+		qc->flags |= V4L2_CTRL_FLAG_CAN_STORE;
 	qc->type = ctrl->type;
 	if (ctrl->is_ptr)
 		qc->flags |= V4L2_CTRL_FLAG_HAS_PAYLOAD;
@@ -2700,6 +2734,8 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 			     struct v4l2_ctrl_helper *helpers,
 			     bool get)
 {
+	u32 ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
+	unsigned store = cs->config_store & 0xffff;
 	struct v4l2_ctrl_helper *h;
 	bool have_clusters = false;
 	u32 i;
@@ -2712,7 +2748,7 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 
 		cs->error_idx = i;
 
-		if (cs->ctrl_class && V4L2_CTRL_ID2CLASS(id) != cs->ctrl_class)
+		if (ctrl_class && V4L2_CTRL_ID2CLASS(id) != ctrl_class)
 			return -EINVAL;
 
 		/* Old-style private controls are not allowed for
@@ -2725,6 +2761,8 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 		ctrl = ref->ctrl;
 		if (ctrl->flags & V4L2_CTRL_FLAG_DISABLED)
 			return -EINVAL;
+		if (store && !ctrl->can_store)
+			return -EINVAL;
 
 		if (ctrl->cluster[0]->ncontrols > 1)
 			have_clusters = true;
@@ -2796,6 +2834,32 @@ static int class_check(struct v4l2_ctrl_handler *hdl, u32 ctrl_class)
 	return find_ref_lock(hdl, ctrl_class | 1) ? 0 : -EINVAL;
 }
 
+static int extend_store(struct v4l2_ctrl *ctrl, unsigned stores)
+{
+	unsigned s, idx;
+	union v4l2_ctrl_ptr *p;
+
+	p = kcalloc(stores, sizeof(union v4l2_ctrl_ptr), GFP_KERNEL);
+	if (p == NULL)
+		return -ENOMEM;
+	for (s = ctrl->nr_of_stores; s < stores; s++) {
+		p[s].p = kcalloc(ctrl->elems, ctrl->elem_size, GFP_KERNEL);
+		if (p[s].p == NULL) {
+			while (s > ctrl->nr_of_stores)
+				kfree(p[--s].p);
+			kfree(p);
+			return -ENOMEM;
+		}
+		for (idx = 0; idx < ctrl->elems; idx++)
+			ctrl->type_ops->init(ctrl, idx, p[s]);
+	}
+	if (ctrl->p_stores)
+		memcpy(p, ctrl->p_stores, ctrl->nr_of_stores * sizeof(union v4l2_ctrl_ptr));
+	kfree(ctrl->p_stores);
+	ctrl->p_stores = p;
+	ctrl->nr_of_stores = stores;
+	return 0;
+}
 
 
 /* Get extended controls. Allocates the helpers array if needed. */
@@ -2803,17 +2867,21 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
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
@@ -2843,13 +2911,19 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 		v4l2_ctrl_lock(master);
 
 		/* g_volatile_ctrl will update the new control values */
-		if ((master->flags & V4L2_CTRL_FLAG_VOLATILE) ||
-			(master->has_volatiles && !is_cur_manual(master))) {
+		if (store == 0 &&
+		    ((master->flags & V4L2_CTRL_FLAG_VOLATILE) ||
+		     (master->has_volatiles && !is_cur_manual(master)))) {
 			for (j = 0; j < master->ncontrols; j++)
 				cur_to_new(master->cluster[j]);
 			ret = call_op(master, g_volatile_ctrl);
 			ctrl_to_user = new_to_user;
 		}
+		for (j = 0; j < master->ncontrols; j++)
+			if (!ret && master->cluster[j] &&
+			    store > master->cluster[j]->nr_of_stores)
+				ret = extend_store(master->cluster[j], store);
+
 		/* If OK, then copy the current (for non-volatile controls)
 		   or the new (for volatile controls) control values to the
 		   caller */
@@ -2857,7 +2931,11 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 			u32 idx = i;
 
 			do {
-				ret = ctrl_to_user(cs->controls + idx,
+				if (store)
+					ret = store_to_user(cs->controls + idx,
+						   helpers[idx].ctrl, store);
+				else
+					ret = ctrl_to_user(cs->controls + idx,
 						   helpers[idx].ctrl);
 				idx = helpers[idx].next;
 			} while (!ret && idx);
@@ -2952,12 +3030,11 @@ s64 v4l2_ctrl_g_ctrl_int64(struct v4l2_ctrl *ctrl)
 }
 EXPORT_SYMBOL(v4l2_ctrl_g_ctrl_int64);
 
-
 /* Core function that calls try/s_ctrl and ensures that the new value is
    copied to the current value on a set.
    Must be called with ctrl->handler->lock held. */
 static int try_or_set_cluster(struct v4l2_fh *fh, struct v4l2_ctrl *master,
-			      bool set, u32 ch_flags)
+			      u16 store, bool set, u32 ch_flags)
 {
 	bool update_flag;
 	int ret;
@@ -2973,6 +3050,14 @@ static int try_or_set_cluster(struct v4l2_fh *fh, struct v4l2_ctrl *master,
 		if (ctrl == NULL)
 			continue;
 
+		if (store && !ctrl->can_store)
+			return -EINVAL;
+		if (store > ctrl->nr_of_stores) {
+			ret = extend_store(ctrl, store);
+			if (ret)
+				return ret;
+		}
+		ctrl->store = store;
 		if (!ctrl->is_new) {
 			cur_to_new(ctrl);
 			continue;
@@ -2994,9 +3079,13 @@ static int try_or_set_cluster(struct v4l2_fh *fh, struct v4l2_ctrl *master,
 
 	/* If OK, then make the new values permanent. */
 	update_flag = is_cur_manual(master) != is_new_manual(master);
-	for (i = 0; i < master->ncontrols; i++)
-		new_to_cur(fh, master->cluster[i], ch_flags |
-			((update_flag && i > 0) ? V4L2_EVENT_CTRL_CH_FLAGS : 0));
+	for (i = 0; i < master->ncontrols; i++) {
+		if (store)
+			new_to_store(master->cluster[i]);
+		else
+			new_to_cur(fh, master->cluster[i], ch_flags |
+				((update_flag && i > 0) ? V4L2_EVENT_CTRL_CH_FLAGS : 0));
+	}
 	return 0;
 }
 
@@ -3036,8 +3125,12 @@ static void update_from_auto_cluster(struct v4l2_ctrl *master)
 {
 	int i;
 
-	for (i = 0; i < master->ncontrols; i++)
+	for (i = 0; i < master->ncontrols; i++) {
+		if (master->cluster[i] == NULL)
+			continue;
 		cur_to_new(master->cluster[i]);
+		master->cluster[i]->store = 0;
+	}
 	if (!call_op(master, g_volatile_ctrl))
 		for (i = 1; i < master->ncontrols; i++)
 			if (master->cluster[i])
@@ -3051,17 +3144,21 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
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
@@ -3096,7 +3193,7 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 		   first since those will become the new manual values (which
 		   may be overwritten by explicit new values from this set
 		   of controls). */
-		if (master->is_auto && master->has_volatiles &&
+		if (!store && master->is_auto && master->has_volatiles &&
 						!is_cur_manual(master)) {
 			/* Pick an initial non-manual value */
 			s32 new_auto_val = master->manual_mode_value + 1;
@@ -3123,14 +3220,14 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 		} while (!ret && idx);
 
 		if (!ret)
-			ret = try_or_set_cluster(fh, master, set, 0);
+			ret = try_or_set_cluster(fh, master, store, set, 0);
 
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
@@ -3175,9 +3272,12 @@ static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
 	int i;
 
 	/* Reset the 'is_new' flags of the cluster */
-	for (i = 0; i < master->ncontrols; i++)
-		if (master->cluster[i])
-			master->cluster[i]->is_new = 0;
+	for (i = 0; i < master->ncontrols; i++) {
+		if (master->cluster[i] == NULL)
+			continue;
+		master->cluster[i]->is_new = 0;
+		master->cluster[i]->store = 0;
+	}
 
 	if (c)
 		user_to_new(c, ctrl);
@@ -3190,7 +3290,7 @@ static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
 		update_from_auto_cluster(master);
 
 	ctrl->is_new = 1;
-	return try_or_set_cluster(fh, master, true, ch_flags);
+	return try_or_set_cluster(fh, master, 0, true, ch_flags);
 }
 
 /* Helper function for VIDIOC_S_CTRL compatibility */
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 46f4c04..628852c 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -533,8 +533,8 @@ static void v4l_print_query_ext_ctrl(const void *arg, bool write_only)
 	pr_cont("id=0x%x, type=%d, name=%.*s, min/max=%lld/%lld, "
 		"step=%lld, default=%lld, flags=0x%08x, elem_size=%u, elems=%u, "
 		"nr_of_dims=%u, dims=%u,%u,%u,%u\n",
-			p->id, p->type, (int)sizeof(p->name), p->name,
-			p->minimum, p->maximum,
+			p->id, p->type, (int)sizeof(p->name),
+			p->name, p->minimum, p->maximum,
 			p->step, p->default_value, p->flags,
 			p->elem_size, p->elems, p->nr_of_dims,
 			p->dims[0], p->dims[1], p->dims[2], p->dims[3]);
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index b7cd7a6..4c31688 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -122,6 +122,7 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
   *		Drivers should never touch this flag.
   * @call_notify: If set, then call the handler's notify function whenever the
   *		control's value changes.
+  * @can_store: If set, then this control supports configuration stores.
   * @manual_mode_value: If the is_auto flag is set, then this is the value
   *		of the auto control that determines if that control is in
   *		manual mode. So if the value of the auto control equals this
@@ -140,6 +141,8 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
   * @elem_size:	The size in bytes of the control.
   * @dims:	The size of each dimension.
   * @nr_of_dims:The number of dimensions in @dims.
+  * @nr_of_stores: The number of allocated configuration stores of this control.
+  * @store:	The configuration store that the control op operates on.
   * @menu_skip_mask: The control's skip mask for menu controls. This makes it
   *		easy to skip menu items that are not valid. If bit X is set,
   *		then menu item X is skipped. Of course, this only works for
@@ -179,6 +182,7 @@ struct v4l2_ctrl {
 	unsigned int is_array:1;
 	unsigned int has_volatiles:1;
 	unsigned int call_notify:1;
+	unsigned int can_store:1;
 	unsigned int manual_mode_value:8;
 
 	const struct v4l2_ctrl_ops *ops;
@@ -191,6 +195,8 @@ struct v4l2_ctrl {
 	u32 elem_size;
 	u32 dims[V4L2_CTRL_MAX_DIMS];
 	u32 nr_of_dims;
+	u16 nr_of_stores;
+	u16 store;
 	union {
 		u64 step;
 		u64 menu_skip_mask;
@@ -208,6 +214,7 @@ struct v4l2_ctrl {
 
 	union v4l2_ctrl_ptr p_new;
 	union v4l2_ctrl_ptr p_cur;
+	union v4l2_ctrl_ptr *p_stores;
 };
 
 /** struct v4l2_ctrl_ref - The control reference.
@@ -284,6 +291,7 @@ struct v4l2_ctrl_handler {
   *		must be NULL.
   * @is_private: If set, then this control is private to its handler and it
   *		will not be added to any other handlers.
+  * @can_store: If set, then this control supports configuration stores.
   */
 struct v4l2_ctrl_config {
 	const struct v4l2_ctrl_ops *ops;
@@ -302,6 +310,7 @@ struct v4l2_ctrl_config {
 	const char * const *qmenu;
 	const s64 *qmenu_int;
 	unsigned int is_private:1;
+	unsigned int can_store:1;
 };
 
 /** v4l2_ctrl_fill() - Fill in the control fields based on the control ID.
@@ -763,6 +772,11 @@ static inline int v4l2_ctrl_s_ctrl_string(struct v4l2_ctrl *ctrl, const char *s)
 	return rval;
 }
 
+static inline void v4l2_ctrl_can_store(struct v4l2_ctrl *ctrl)
+{
+	ctrl->can_store = true;
+}
+
 /* Internal helper functions that deal with control events. */
 extern const struct v4l2_subscribed_event_ops v4l2_ctrl_sub_ev_ops;
 void v4l2_ctrl_replace(struct v4l2_event *old, const struct v4l2_event *new);
-- 
2.1.0

