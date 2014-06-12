Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4902 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933246AbaFLLyn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 07:54:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv4 PATCH 12/34] v4l2-ctrls: prepare for array support.
Date: Thu, 12 Jun 2014 13:52:44 +0200
Message-Id: <d669c46c24aeb99bb8b262bf606120959b790cfe.1402573818.git.hans.verkuil@cisco.com>
In-Reply-To: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
References: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
References: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add core support for N-dimensional arrays.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 58 ++++++++++++++++++++++++------------
 include/media/v4l2-ctrls.h           |  8 +++--
 2 files changed, 44 insertions(+), 22 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index e6c98a7..6ed2d56 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1161,7 +1161,7 @@ static void send_event(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 changes)
 			v4l2_event_queue_fh(sev->fh, &ev);
 }
 
-static bool std_equal(const struct v4l2_ctrl *ctrl,
+static bool std_equal(const struct v4l2_ctrl *ctrl, u32 idx,
 		      union v4l2_ctrl_ptr ptr1,
 		      union v4l2_ctrl_ptr ptr2)
 {
@@ -1180,7 +1180,7 @@ static bool std_equal(const struct v4l2_ctrl *ctrl,
 	}
 }
 
-static void std_init(const struct v4l2_ctrl *ctrl,
+static void std_init(const struct v4l2_ctrl *ctrl, u32 idx,
 		     union v4l2_ctrl_ptr ptr)
 {
 	switch (ctrl->type) {
@@ -1207,6 +1207,14 @@ static void std_log(const struct v4l2_ctrl *ctrl)
 {
 	union v4l2_ctrl_ptr ptr = ctrl->p_cur;
 
+	if (ctrl->is_array) {
+		unsigned i;
+
+		for (i = 0; i < ctrl->nr_of_dims; i++)
+			pr_cont("[%u]", ctrl->dims[i]);
+		pr_cont(" ");
+	}
+
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_INTEGER:
 		pr_cont("%d", *ptr.p_s32);
@@ -1249,7 +1257,7 @@ static void std_log(const struct v4l2_ctrl *ctrl)
 })
 
 /* Validate a new control */
-static int std_validate(const struct v4l2_ctrl *ctrl,
+static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 			union v4l2_ctrl_ptr ptr)
 {
 	size_t len;
@@ -1473,8 +1481,8 @@ static int cluster_changed(struct v4l2_ctrl *master)
 
 		if (ctrl == NULL)
 			continue;
-		ctrl->has_changed = !ctrl->type_ops->equal(ctrl,
-						ctrl->p_cur, ctrl->p_new);
+		ctrl->has_changed = !ctrl->type_ops->equal(ctrl, 0,
+				ctrl->p_cur, ctrl->p_new);
 		changed |= ctrl->has_changed;
 	}
 	return changed;
@@ -1531,15 +1539,15 @@ static int validate_new(const struct v4l2_ctrl *ctrl,
 	case V4L2_CTRL_TYPE_BUTTON:
 	case V4L2_CTRL_TYPE_CTRL_CLASS:
 		ptr.p_s32 = &c->value;
-		return ctrl->type_ops->validate(ctrl, ptr);
+		return ctrl->type_ops->validate(ctrl, 0, ptr);
 
 	case V4L2_CTRL_TYPE_INTEGER64:
 		ptr.p_s64 = &c->value64;
-		return ctrl->type_ops->validate(ctrl, ptr);
+		return ctrl->type_ops->validate(ctrl, 0, ptr);
 
 	default:
 		ptr.p = c->ptr;
-		return ctrl->type_ops->validate(ctrl, ptr);
+		return ctrl->type_ops->validate(ctrl, 0, ptr);
 	}
 }
 
@@ -1767,6 +1775,8 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	unsigned sz_extra;
 	unsigned nr_of_dims = 0;
 	unsigned elems = 1;
+	bool is_array;
+	unsigned tot_ctrl_size;
 	void *data;
 	int err;
 
@@ -1779,6 +1789,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 		if (nr_of_dims == V4L2_CTRL_MAX_DIMS)
 			break;
 	}
+	is_array = nr_of_dims > 0;
 
 	if (type == V4L2_CTRL_TYPE_INTEGER64)
 		elem_size = sizeof(s64);
@@ -1786,10 +1797,11 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 		elem_size = max + 1;
 	else if (type < V4L2_CTRL_COMPOUND_TYPES)
 		elem_size = sizeof(s32);
+	tot_ctrl_size = elem_size * elems;
 
 	/* Sanity checks */
-	if (id == 0 || name == NULL || id >= V4L2_CID_PRIVATE_BASE ||
-	    elem_size == 0 ||
+	if (id == 0 || name == NULL || !elem_size ||
+	    id >= V4L2_CID_PRIVATE_BASE ||
 	    (type == V4L2_CTRL_TYPE_MENU && qmenu == NULL) ||
 	    (type == V4L2_CTRL_TYPE_INTEGER_MENU && qmenu_int == NULL)) {
 		handler_set_err(hdl, -ERANGE);
@@ -1804,6 +1816,12 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 		handler_set_err(hdl, -ERANGE);
 		return NULL;
 	}
+	if (is_array &&
+	    (type == V4L2_CTRL_TYPE_BUTTON ||
+	     type == V4L2_CTRL_TYPE_CTRL_CLASS)) {
+		handler_set_err(hdl, -EINVAL);
+		return NULL;
+	}
 
 	sz_extra = 0;
 	if (type == V4L2_CTRL_TYPE_BUTTON)
@@ -1812,8 +1830,9 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 		flags |= V4L2_CTRL_FLAG_READ_ONLY;
 	else if (type == V4L2_CTRL_TYPE_INTEGER64 ||
 		 type == V4L2_CTRL_TYPE_STRING ||
-		 type >= V4L2_CTRL_COMPOUND_TYPES)
-		sz_extra += 2 * elem_size;
+		 type >= V4L2_CTRL_COMPOUND_TYPES ||
+		 is_array)
+		sz_extra += 2 * tot_ctrl_size;
 
 	ctrl = kzalloc(sizeof(*ctrl) + sz_extra, GFP_KERNEL);
 	if (ctrl == NULL) {
@@ -1834,9 +1853,10 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	ctrl->maximum = max;
 	ctrl->step = step;
 	ctrl->default_value = def;
-	ctrl->is_string = type == V4L2_CTRL_TYPE_STRING;
-	ctrl->is_ptr = type >= V4L2_CTRL_COMPOUND_TYPES || ctrl->is_string;
+	ctrl->is_string = !is_array && type == V4L2_CTRL_TYPE_STRING;
+	ctrl->is_ptr = is_array || type >= V4L2_CTRL_COMPOUND_TYPES || ctrl->is_string;
 	ctrl->is_int = !ctrl->is_ptr && type != V4L2_CTRL_TYPE_INTEGER64;
+	ctrl->is_array = is_array;
 	ctrl->elems = elems;
 	ctrl->nr_of_dims = nr_of_dims;
 	if (nr_of_dims)
@@ -1852,13 +1872,13 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 
 	if (!ctrl->is_int) {
 		ctrl->p_new.p = data;
-		ctrl->p_cur.p = data + elem_size;
+		ctrl->p_cur.p = data + tot_ctrl_size;
 	} else {
 		ctrl->p_new.p = &ctrl->val;
 		ctrl->p_cur.p = &ctrl->cur.val;
 	}
-	ctrl->type_ops->init(ctrl, ctrl->p_cur);
-	ctrl->type_ops->init(ctrl, ctrl->p_new);
+	ctrl->type_ops->init(ctrl, 0, ctrl->p_cur);
+	ctrl->type_ops->init(ctrl, 0, ctrl->p_new);
 
 	if (handler_new_ref(hdl, ctrl)) {
 		kfree(ctrl);
@@ -2764,7 +2784,7 @@ s64 v4l2_ctrl_g_ctrl_int64(struct v4l2_ctrl *ctrl)
 	struct v4l2_ext_control c;
 
 	/* It's a driver bug if this happens. */
-	WARN_ON(ctrl->type != V4L2_CTRL_TYPE_INTEGER64);
+	WARN_ON(ctrl->is_ptr || ctrl->type != V4L2_CTRL_TYPE_INTEGER64);
 	c.value = 0;
 	get_ctrl(ctrl, &c);
 	return c.value;
@@ -3074,7 +3094,7 @@ int v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val)
 	struct v4l2_ext_control c;
 
 	/* It's a driver bug if this happens. */
-	WARN_ON(ctrl->type != V4L2_CTRL_TYPE_INTEGER64);
+	WARN_ON(ctrl->is_ptr || ctrl->type != V4L2_CTRL_TYPE_INTEGER64);
 	c.value64 = val;
 	return set_ctrl_lock(NULL, ctrl, &c);
 }
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index d30da09..7915b1125 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -74,13 +74,13 @@ struct v4l2_ctrl_ops {
   * @validate: validate the value. Return 0 on success and a negative value otherwise.
   */
 struct v4l2_ctrl_type_ops {
-	bool (*equal)(const struct v4l2_ctrl *ctrl,
+	bool (*equal)(const struct v4l2_ctrl *ctrl, u32 idx,
 		      union v4l2_ctrl_ptr ptr1,
 		      union v4l2_ctrl_ptr ptr2);
-	void (*init)(const struct v4l2_ctrl *ctrl,
+	void (*init)(const struct v4l2_ctrl *ctrl, u32 idx,
 		     union v4l2_ctrl_ptr ptr);
 	void (*log)(const struct v4l2_ctrl *ctrl);
-	int (*validate)(const struct v4l2_ctrl *ctrl,
+	int (*validate)(const struct v4l2_ctrl *ctrl, u32 idx,
 			union v4l2_ctrl_ptr ptr);
 };
 
@@ -111,6 +111,7 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
   * @is_ptr:	If set, then this control is an array and/or has type >= V4L2_CTRL_COMPOUND_TYPES
   *		and/or has type V4L2_CTRL_TYPE_STRING. In other words, struct
   *		v4l2_ext_control uses field p to point to the data.
+  * @is_array: If set, then this control contains an N-dimensional array.
   * @has_volatiles: If set, then one or more members of the cluster are volatile.
   *		Drivers should never touch this flag.
   * @call_notify: If set, then call the handler's notify function whenever the
@@ -169,6 +170,7 @@ struct v4l2_ctrl {
 	unsigned int is_int:1;
 	unsigned int is_string:1;
 	unsigned int is_ptr:1;
+	unsigned int is_array:1;
 	unsigned int has_volatiles:1;
 	unsigned int call_notify:1;
 	unsigned int manual_mode_value:8;
-- 
2.0.0.rc0

