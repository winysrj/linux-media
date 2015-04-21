Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:49850 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751621AbbDUNAU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 09:00:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 05/15] v4l2-ctrls: add request support
Date: Tue, 21 Apr 2015 14:58:48 +0200
Message-Id: <1429621138-17213-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429621138-17213-1-git-send-email-hverkuil@xs4all.nl>
References: <1429621138-17213-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 228 ++++++++++++++++++++++++++++++-----
 drivers/media/v4l2-core/v4l2-ioctl.c |   8 ++
 include/media/v4l2-ctrls.h           |  20 +++
 3 files changed, 228 insertions(+), 28 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index e3a3468..d28035c 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1235,6 +1235,96 @@ static void send_event(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 changes)
 			v4l2_event_queue_fh(sev->fh, &ev);
 }
 
+static int alloc_requests(struct v4l2_ctrl *ctrl)
+{
+	unsigned i;
+
+	ctrl->request_lists = kmalloc_array(VIDEO_MAX_FRAME,
+					sizeof(struct list_head), GFP_KERNEL);
+	if (ctrl->request_lists == NULL)
+		return -ENOMEM;
+	for (i = 0; i < VIDEO_MAX_FRAME; i++)
+		INIT_LIST_HEAD(ctrl->request_lists + i);
+	return 0;
+}
+
+static struct v4l2_ctrl_req *get_request(struct v4l2_ctrl *ctrl, unsigned request)
+{
+	struct v4l2_ctrl_req *req;
+	struct list_head *head;
+
+	if (ctrl->request_lists == NULL)
+		return NULL;
+	head = ctrl->request_lists + (request % VIDEO_MAX_FRAME);
+	list_for_each_entry(req, head, node)
+		if (req->request == request)
+			return req;
+	return NULL;
+}
+
+static int add_request(struct v4l2_ctrl *ctrl, unsigned request,
+		       struct v4l2_ctrl_req **p_req)
+{
+	struct v4l2_ctrl_req *req;
+	struct list_head *head;
+	unsigned idx;
+	int ret;
+
+	if (ctrl->nr_of_requests == ctrl->max_reqs)
+		return -ENOSPC;
+
+	if (ctrl->request_lists == NULL) {
+		ret = alloc_requests(ctrl);
+		if (ret)
+			return ret;
+	}
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (req == NULL)
+		return -ENOMEM;
+	req->ptr.p = kcalloc(ctrl->elems, ctrl->elem_size, GFP_KERNEL);
+	req->request = request;
+	if (req->ptr.p == NULL) {
+		kfree(req);
+		return -ENOMEM;
+	}
+	head = ctrl->request_lists + (request % VIDEO_MAX_FRAME);
+	for (idx = 0; idx < ctrl->elems; idx++)
+		ctrl->type_ops->init(ctrl, idx, req->ptr);
+	ctrl->nr_of_requests++;
+	list_add(&req->node, head);
+	if (p_req)
+		*p_req = req;
+	return 0;
+}
+
+static void del_request(struct v4l2_ctrl *ctrl, struct v4l2_ctrl_req *req)
+{
+	list_del(&req->node);
+	ctrl->nr_of_requests--;
+	kfree(req->ptr.p);
+	kfree(req);
+}
+
+static void free_requests(struct v4l2_ctrl *ctrl)
+{
+	unsigned idx;
+
+	if (!ctrl->request_lists)
+		return;
+
+	for (idx = 0; idx < VIDEO_MAX_FRAME; idx++) {
+		struct list_head *head = ctrl->request_lists + idx;
+
+		while (!list_empty(head)) {
+			struct v4l2_ctrl_req *req =
+				list_first_entry(head, struct v4l2_ctrl_req, node);
+			del_request(ctrl, req);
+		}
+	}
+	kfree(ctrl->request_lists);
+	ctrl->request_lists = NULL;
+}
+
 static bool std_equal(const struct v4l2_ctrl *ctrl, u32 idx,
 		      union v4l2_ctrl_ptr ptr1,
 		      union v4l2_ctrl_ptr ptr2)
@@ -1482,6 +1572,15 @@ static int cur_to_user(struct v4l2_ext_control *c,
 	return ptr_to_user(c, ctrl, ctrl->p_cur);
 }
 
+/* Helper function: copy the request's control value back to the caller */
+static int request_to_user(struct v4l2_ext_control *c,
+		       struct v4l2_ctrl *ctrl)
+{
+	if (ctrl->request == NULL)
+		return ptr_to_user(c, ctrl, ctrl->p_new);
+	return ptr_to_user(c, ctrl, ctrl->request->ptr);
+}
+
 /* Helper function: copy the new control value back to the caller */
 static int new_to_user(struct v4l2_ext_control *c,
 		       struct v4l2_ctrl *ctrl)
@@ -1589,6 +1688,13 @@ static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 ch_flags)
 	}
 }
 
+/* Helper function: copy the new control value to the request */
+static void new_to_request(struct v4l2_ctrl *ctrl)
+{
+	if (ctrl)
+		ptr_to_ptr(ctrl, ctrl->p_new, ctrl->request->ptr);
+}
+
 /* Copy the current value to the new value */
 static void cur_to_new(struct v4l2_ctrl *ctrl)
 {
@@ -1750,6 +1856,7 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
 		list_del(&ctrl->node);
 		list_for_each_entry_safe(sev, next_sev, &ctrl->ev_subs, node)
 			list_del(&sev->node);
+		free_requests(ctrl);
 		kfree(ctrl);
 	}
 	kfree(hdl->buckets);
@@ -2095,8 +2202,10 @@ struct v4l2_ctrl *v4l2_ctrl_new_custom(struct v4l2_ctrl_handler *hdl,
 			is_menu ? cfg->menu_skip_mask : step, def,
 			cfg->dims, cfg->elem_size,
 			flags, qmenu, qmenu_int, priv);
-	if (ctrl)
+	if (ctrl) {
 		ctrl->is_private = cfg->is_private;
+		ctrl->max_reqs = cfg->max_reqs;
+	}
 	return ctrl;
 }
 EXPORT_SYMBOL(v4l2_ctrl_new_custom);
@@ -2289,18 +2398,26 @@ EXPORT_SYMBOL(v4l2_ctrl_radio_filter);
 void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls)
 {
 	bool has_volatiles = false;
+	unsigned max_reqs;
 	int i;
 
 	/* The first control is the master control and it must not be NULL */
 	if (WARN_ON(ncontrols == 0 || controls[0] == NULL))
 		return;
 
+	max_reqs = controls[0]->max_reqs;
 	for (i = 0; i < ncontrols; i++) {
 		if (controls[i]) {
 			controls[i]->cluster = controls;
 			controls[i]->ncontrols = ncontrols;
 			if (controls[i]->flags & V4L2_CTRL_FLAG_VOLATILE)
 				has_volatiles = true;
+			/*
+			 * The max_reqs value should be the same for all
+			 * controls inside the cluster.
+			 */
+			if (WARN_ON(controls[i]->max_reqs != max_reqs))
+				controls[i]->max_reqs = max_reqs;
 		}
 	}
 	controls[0]->has_volatiles = has_volatiles;
@@ -2463,6 +2580,7 @@ int v4l2_ctrl_handler_setup(struct v4l2_ctrl_handler *hdl)
 				cur_to_new(master->cluster[i]);
 				master->cluster[i]->is_new = 1;
 				master->cluster[i]->done = true;
+				master->cluster[i]->request = NULL;
 			}
 		}
 		ret = call_op(master, s_ctrl);
@@ -2479,10 +2597,11 @@ int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctr
 {
 	const unsigned next_flags = V4L2_CTRL_FLAG_NEXT_CTRL | V4L2_CTRL_FLAG_NEXT_COMPOUND;
 	u32 id = qc->id & V4L2_CTRL_ID_MASK;
+	u32 req = qc->request;
 	struct v4l2_ctrl_ref *ref;
 	struct v4l2_ctrl *ctrl;
 
-	if (hdl == NULL)
+	if (hdl == NULL || req > USHRT_MAX)
 		return -EINVAL;
 
 	mutex_lock(hdl->lock);
@@ -2516,6 +2635,7 @@ int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctr
 				is_compound =
 					ref->ctrl->type >= V4L2_CTRL_COMPOUND_TYPES;
 				if (id < ref->ctrl->id &&
+				    (!req || get_request(ref->ctrl, req)) &&
 				    (is_compound & mask) == match)
 					break;
 			}
@@ -2530,6 +2650,7 @@ int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctr
 				is_compound =
 					ref->ctrl->type >= V4L2_CTRL_COMPOUND_TYPES;
 				if (id < ref->ctrl->id &&
+				    (!req || get_request(ref->ctrl, req)) &&
 				    (is_compound & mask) == match)
 					break;
 			}
@@ -2541,6 +2662,8 @@ int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctr
 
 	if (!ref)
 		return -EINVAL;
+	if (req && get_request(ref->ctrl, req) == NULL)
+		return -EINVAL;
 
 	ctrl = ref->ctrl;
 	memset(qc, 0, sizeof(*qc));
@@ -2550,6 +2673,7 @@ int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctr
 		qc->id = ctrl->id;
 	strlcpy(qc->name, ctrl->name, sizeof(qc->name));
 	qc->flags = ctrl->flags;
+	qc->max_reqs = ctrl->max_reqs;
 	qc->type = ctrl->type;
 	if (ctrl->is_ptr)
 		qc->flags |= V4L2_CTRL_FLAG_HAS_PAYLOAD;
@@ -2711,6 +2835,8 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 			     struct v4l2_ctrl_helper *helpers,
 			     bool get)
 {
+	u32 ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
+	unsigned request = cs->request & 0xffff;
 	struct v4l2_ctrl_helper *h;
 	bool have_clusters = false;
 	u32 i;
@@ -2723,7 +2849,7 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 
 		cs->error_idx = i;
 
-		if (cs->ctrl_class && V4L2_CTRL_ID2CLASS(id) != cs->ctrl_class)
+		if (ctrl_class && V4L2_CTRL_ID2CLASS(id) != ctrl_class)
 			return -EINVAL;
 
 		/* Old-style private controls are not allowed for
@@ -2736,6 +2862,8 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 		ctrl = ref->ctrl;
 		if (ctrl->flags & V4L2_CTRL_FLAG_DISABLED)
 			return -EINVAL;
+		if (request && !ctrl->max_reqs)
+			return -EINVAL;
 
 		if (ctrl->cluster[0]->ncontrols > 1)
 			have_clusters = true;
@@ -2807,24 +2935,26 @@ static int class_check(struct v4l2_ctrl_handler *hdl, u32 ctrl_class)
 	return find_ref_lock(hdl, ctrl_class | 1) ? 0 : -EINVAL;
 }
 
-
-
 /* Get extended controls. Allocates the helpers array if needed. */
 int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs)
 {
 	struct v4l2_ctrl_helper helper[4];
 	struct v4l2_ctrl_helper *helpers = helper;
+	unsigned request = 0;
 	int ret;
 	int i, j;
 
 	cs->error_idx = cs->count;
-	cs->ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
+	if (V4L2_CTRL_ID2CLASS(cs->ctrl_class))
+		cs->ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
+	else
+		request = cs->request;
 
-	if (hdl == NULL)
+	if (hdl == NULL || request > USHRT_MAX)
 		return -EINVAL;
 
 	if (cs->count == 0)
-		return class_check(hdl, cs->ctrl_class);
+		return class_check(hdl, V4L2_CTRL_ID2CLASS(cs->ctrl_class));
 
 	if (cs->count > ARRAY_SIZE(helper)) {
 		helpers = kmalloc_array(cs->count, sizeof(helper[0]),
@@ -2854,13 +2984,27 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 		v4l2_ctrl_lock(master);
 
 		/* g_volatile_ctrl will update the new control values */
-		if ((master->flags & V4L2_CTRL_FLAG_VOLATILE) ||
-			(master->has_volatiles && !is_cur_manual(master))) {
+		if (request == 0 &&
+		    ((master->flags & V4L2_CTRL_FLAG_VOLATILE) ||
+		     (master->has_volatiles && !is_cur_manual(master)))) {
 			for (j = 0; j < master->ncontrols; j++)
 				cur_to_new(master->cluster[j]);
 			ret = call_op(master, g_volatile_ctrl);
 			ctrl_to_user = new_to_user;
 		}
+		if (request) {
+			for (j = 0; !ret && j < master->ncontrols; j++) {
+				struct v4l2_ctrl *ctrl = master->cluster[j];
+
+				if (!ctrl)
+					continue;
+				ctrl->request = get_request(ctrl, request);
+				if (ctrl->request)
+					continue;
+				ret = add_request(ctrl, request, &ctrl->request);
+			}
+		}
+
 		/* If OK, then copy the current (for non-volatile controls)
 		   or the new (for volatile controls) control values to the
 		   caller */
@@ -2868,7 +3012,11 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 			u32 idx = i;
 
 			do {
-				ret = ctrl_to_user(cs->controls + idx,
+				if (request)
+					ret = request_to_user(cs->controls + idx,
+						   helpers[idx].ctrl);
+				else
+					ret = ctrl_to_user(cs->controls + idx,
 						   helpers[idx].ctrl);
 				idx = helpers[idx].next;
 			} while (!ret && idx);
@@ -2963,12 +3111,11 @@ s64 v4l2_ctrl_g_ctrl_int64(struct v4l2_ctrl *ctrl)
 }
 EXPORT_SYMBOL(v4l2_ctrl_g_ctrl_int64);
 
-
 /* Core function that calls try/s_ctrl and ensures that the new value is
    copied to the current value on a set.
    Must be called with ctrl->handler->lock held. */
 static int try_or_set_cluster(struct v4l2_fh *fh, struct v4l2_ctrl *master,
-			      bool set, u32 ch_flags)
+			      u16 request, bool set, u32 ch_flags)
 {
 	bool update_flag;
 	int ret;
@@ -2980,10 +3127,20 @@ static int try_or_set_cluster(struct v4l2_fh *fh, struct v4l2_ctrl *master,
 	   called. */
 	for (i = 0; i < master->ncontrols; i++) {
 		struct v4l2_ctrl *ctrl = master->cluster[i];
+		struct v4l2_ctrl_req *req = NULL;
 
 		if (ctrl == NULL)
 			continue;
 
+		if (request) {
+			req = get_request(ctrl, request);
+			if (!req) {
+				ret = add_request(ctrl, request, &req);
+				if (ret)
+					return ret;
+			}
+		}
+		ctrl->request = req;
 		if (!ctrl->is_new) {
 			cur_to_new(ctrl);
 			continue;
@@ -2997,7 +3154,7 @@ static int try_or_set_cluster(struct v4l2_fh *fh, struct v4l2_ctrl *master,
 	ret = call_op(master, try_ctrl);
 
 	/* Don't set if there is no change */
-	if (ret || !set || !cluster_changed(master))
+	if (ret || !set || (!request && !cluster_changed(master)))
 		return ret;
 	ret = call_op(master, s_ctrl);
 	if (ret)
@@ -3005,9 +3162,13 @@ static int try_or_set_cluster(struct v4l2_fh *fh, struct v4l2_ctrl *master,
 
 	/* If OK, then make the new values permanent. */
 	update_flag = is_cur_manual(master) != is_new_manual(master);
-	for (i = 0; i < master->ncontrols; i++)
-		new_to_cur(fh, master->cluster[i], ch_flags |
-			((update_flag && i > 0) ? V4L2_EVENT_CTRL_CH_FLAGS : 0));
+	for (i = 0; i < master->ncontrols; i++) {
+		if (request)
+			new_to_request(master->cluster[i]);
+		else
+			new_to_cur(fh, master->cluster[i], ch_flags |
+				((update_flag && i > 0) ? V4L2_EVENT_CTRL_CH_FLAGS : 0));
+	}
 	return 0;
 }
 
@@ -3058,8 +3219,12 @@ static void update_from_auto_cluster(struct v4l2_ctrl *master)
 {
 	int i;
 
-	for (i = 0; i < master->ncontrols; i++)
+	for (i = 0; i < master->ncontrols; i++) {
+		if (master->cluster[i] == NULL)
+			continue;
 		cur_to_new(master->cluster[i]);
+		master->cluster[i]->request = 0;
+	}
 	if (!call_op(master, g_volatile_ctrl))
 		for (i = 1; i < master->ncontrols; i++)
 			if (master->cluster[i])
@@ -3073,17 +3238,21 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 {
 	struct v4l2_ctrl_helper helper[4];
 	struct v4l2_ctrl_helper *helpers = helper;
+	unsigned request = 0;
 	unsigned i, j;
 	int ret;
 
 	cs->error_idx = cs->count;
-	cs->ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
+	if (V4L2_CTRL_ID2CLASS(cs->ctrl_class))
+		cs->ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
+	else
+		request = cs->request;
 
-	if (hdl == NULL)
+	if (hdl == NULL || request > USHRT_MAX)
 		return -EINVAL;
 
 	if (cs->count == 0)
-		return class_check(hdl, cs->ctrl_class);
+		return class_check(hdl, V4L2_CTRL_ID2CLASS(cs->ctrl_class));
 
 	if (cs->count > ARRAY_SIZE(helper)) {
 		helpers = kmalloc_array(cs->count, sizeof(helper[0]),
@@ -3118,7 +3287,7 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 		   first since those will become the new manual values (which
 		   may be overwritten by explicit new values from this set
 		   of controls). */
-		if (master->is_auto && master->has_volatiles &&
+		if (!request && master->is_auto && master->has_volatiles &&
 						!is_cur_manual(master)) {
 			/* Pick an initial non-manual value */
 			s32 new_auto_val = master->manual_mode_value + 1;
@@ -3149,13 +3318,13 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 		} while (!ret && idx);
 
 		if (!ret)
-			ret = try_or_set_cluster(fh, master, set, 0);
+			ret = try_or_set_cluster(fh, master, request, set, 0);
 
 		/* Copy the new values back to userspace. */
 		if (!ret) {
 			idx = i;
 			do {
-				ret = new_to_user(cs->controls + idx,
+				ret = request_to_user(cs->controls + idx,
 						helpers[idx].ctrl);
 				idx = helpers[idx].next;
 			} while (!ret && idx);
@@ -3201,9 +3370,12 @@ static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 ch_flags)
 	int i;
 
 	/* Reset the 'is_new' flags of the cluster */
-	for (i = 0; i < master->ncontrols; i++)
-		if (master->cluster[i])
-			master->cluster[i]->is_new = 0;
+	for (i = 0; i < master->ncontrols; i++) {
+		if (master->cluster[i] == NULL)
+			continue;
+		master->cluster[i]->is_new = 0;
+		master->cluster[i]->request = NULL;
+	}
 
 	ret = validate_new(ctrl, ctrl->p_new);
 	if (ret)
@@ -3217,7 +3389,7 @@ static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 ch_flags)
 		update_from_auto_cluster(master);
 
 	ctrl->is_new = 1;
-	return try_or_set_cluster(fh, master, true, ch_flags);
+	return try_or_set_cluster(fh, master, 0, true, ch_flags);
 }
 
 /* Helper function for VIDIOC_S_CTRL compatibility */
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index d2d1fb1..a16af7f 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1701,6 +1701,8 @@ static int v4l_query_ext_ctrl(const struct v4l2_ioctl_ops *ops,
 		return v4l2_query_ext_ctrl(vfh->ctrl_handler, p);
 	if (vfd->ctrl_handler)
 		return v4l2_query_ext_ctrl(vfd->ctrl_handler, p);
+	if (p->request)
+		return -EINVAL;
 	if (ops->vidioc_query_ext_ctrl)
 		return ops->vidioc_query_ext_ctrl(file, fh, p);
 	return -ENOTTY;
@@ -1801,6 +1803,8 @@ static int v4l_g_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 		return v4l2_g_ext_ctrls(vfd->ctrl_handler, p);
 	if (ops->vidioc_g_ext_ctrls == NULL)
 		return -ENOTTY;
+	if (p->request)
+		return -EINVAL;
 	return check_ext_ctrls(p, 0) ? ops->vidioc_g_ext_ctrls(file, fh, p) :
 					-EINVAL;
 }
@@ -1820,6 +1824,8 @@ static int v4l_s_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 		return v4l2_s_ext_ctrls(NULL, vfd->ctrl_handler, p);
 	if (ops->vidioc_s_ext_ctrls == NULL)
 		return -ENOTTY;
+	if (p->request)
+		return -EINVAL;
 	return check_ext_ctrls(p, 0) ? ops->vidioc_s_ext_ctrls(file, fh, p) :
 					-EINVAL;
 }
@@ -1839,6 +1845,8 @@ static int v4l_try_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 		return v4l2_try_ext_ctrls(vfd->ctrl_handler, p);
 	if (ops->vidioc_try_ext_ctrls == NULL)
 		return -ENOTTY;
+	if (p->request)
+		return -EINVAL;
 	return check_ext_ctrls(p, 0) ? ops->vidioc_try_ext_ctrls(file, fh, p) :
 					-EINVAL;
 }
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 911f3e5..abc5eb3 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -92,6 +92,12 @@ struct v4l2_ctrl_type_ops {
 
 typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
 
+struct v4l2_ctrl_req {
+	struct list_head node;
+	u32 request;
+	union v4l2_ctrl_ptr ptr;
+};
+
 /** struct v4l2_ctrl - The control structure.
   * @node:	The list node.
   * @ev_subs:	The list of control event subscriptions.
@@ -140,6 +146,9 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
   * @elem_size:	The size in bytes of the control.
   * @dims:	The size of each dimension.
   * @nr_of_dims:The number of dimensions in @dims.
+  * @nr_of_requests: The number of allocated requests of this control.
+  * @max_reqs:	The maximum number of requests supported by this control.
+  * @request:	The request that the control op operates on.
   * @menu_skip_mask: The control's skip mask for menu controls. This makes it
   *		easy to skip menu items that are not valid. If bit X is set,
   *		then menu item X is skipped. Of course, this only works for
@@ -191,6 +200,9 @@ struct v4l2_ctrl {
 	u32 elem_size;
 	u32 dims[V4L2_CTRL_MAX_DIMS];
 	u32 nr_of_dims;
+	u16 nr_of_requests;
+	u16 max_reqs;
+	struct v4l2_ctrl_req *request;
 	union {
 		u64 step;
 		u64 menu_skip_mask;
@@ -208,6 +220,7 @@ struct v4l2_ctrl {
 
 	union v4l2_ctrl_ptr p_new;
 	union v4l2_ctrl_ptr p_cur;
+	struct list_head *request_lists;
 };
 
 /** struct v4l2_ctrl_ref - The control reference.
@@ -284,6 +297,7 @@ struct v4l2_ctrl_handler {
   *		must be NULL.
   * @is_private: If set, then this control is private to its handler and it
   *		will not be added to any other handlers.
+  * @max_reqs:	The maximum number of requests supported by this control.
   */
 struct v4l2_ctrl_config {
 	const struct v4l2_ctrl_ops *ops;
@@ -302,6 +316,7 @@ struct v4l2_ctrl_config {
 	const char * const *qmenu;
 	const s64 *qmenu_int;
 	unsigned int is_private:1;
+	u16 max_reqs;
 };
 
 /** v4l2_ctrl_fill() - Fill in the control fields based on the control ID.
@@ -788,6 +803,11 @@ static inline int v4l2_ctrl_s_ctrl_string(struct v4l2_ctrl *ctrl, const char *s)
 	return rval;
 }
 
+static inline void v4l2_ctrl_s_max_reqs(struct v4l2_ctrl *ctrl, u16 max_reqs)
+{
+	ctrl->max_reqs = max_reqs;
+}
+
 /* Internal helper functions that deal with control events. */
 extern const struct v4l2_subscribed_event_ops v4l2_ctrl_sub_ev_ops;
 void v4l2_ctrl_replace(struct v4l2_event *old, const struct v4l2_event *new);
-- 
2.1.4

