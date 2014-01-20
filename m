Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3072 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbaATMqu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jan 2014 07:46:50 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	t.stanislaws@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 14/21] v4l2-ctrls: prepare for matrix support.
Date: Mon, 20 Jan 2014 13:46:07 +0100
Message-Id: <1390221974-28194-15-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl>
References: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add core support for matrices.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 54 +++++++++++++++++++++++-------------
 include/media/v4l2-ctrls.h           |  8 ++++--
 2 files changed, 39 insertions(+), 23 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index d15a7dd..4968eff 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1123,7 +1123,7 @@ static void send_event(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 changes)
 			v4l2_event_queue_fh(sev->fh, &ev);
 }
 
-static bool std_equal(const struct v4l2_ctrl *ctrl,
+static bool std_equal(const struct v4l2_ctrl *ctrl, u32 idx,
 		      union v4l2_ctrl_ptr ptr1,
 		      union v4l2_ctrl_ptr ptr2)
 {
@@ -1142,7 +1142,7 @@ static bool std_equal(const struct v4l2_ctrl *ctrl,
 	}
 }
 
-static void std_init(const struct v4l2_ctrl *ctrl,
+static void std_init(const struct v4l2_ctrl *ctrl, u32 idx,
 		     union v4l2_ctrl_ptr ptr)
 {
 	switch (ctrl->type) {
@@ -1169,6 +1169,9 @@ static void std_log(const struct v4l2_ctrl *ctrl)
 {
 	union v4l2_ctrl_ptr ptr = ctrl->stores[0];
 
+	if (ctrl->is_matrix)
+		pr_cont("[%u][%u] ", ctrl->rows, ctrl->cols);
+
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_INTEGER:
 		pr_cont("%d", *ptr.p_s32);
@@ -1211,7 +1214,7 @@ static void std_log(const struct v4l2_ctrl *ctrl)
 })
 
 /* Validate a new control */
-static int std_validate(const struct v4l2_ctrl *ctrl,
+static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 			union v4l2_ctrl_ptr ptr)
 {
 	size_t len;
@@ -1435,7 +1438,7 @@ static int cluster_changed(struct v4l2_ctrl *master)
 
 		if (ctrl == NULL)
 			continue;
-		ctrl->has_changed = !ctrl->type_ops->equal(ctrl,
+		ctrl->has_changed = !ctrl->type_ops->equal(ctrl, 0,
 						ctrl->stores[0], ctrl->new);
 		changed |= ctrl->has_changed;
 	}
@@ -1493,15 +1496,15 @@ static int validate_new(const struct v4l2_ctrl *ctrl,
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
 		ptr.p = c->p;
-		return ctrl->type_ops->validate(ctrl, ptr);
+		return ctrl->type_ops->validate(ctrl, 0, ptr);
 	}
 }
 
@@ -1727,7 +1730,8 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 			const s64 *qmenu_int, void *priv)
 {
 	struct v4l2_ctrl *ctrl;
-	unsigned sz_extra;
+	bool is_matrix;
+	unsigned sz_extra, tot_ctrl_size;
 	void *data;
 	int err;
 	int s;
@@ -1739,6 +1743,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 		cols = 1;
 	if (rows == 0)
 		rows = 1;
+	is_matrix = cols > 1 || rows > 1;
 
 	if (type == V4L2_CTRL_TYPE_INTEGER64)
 		elem_size = sizeof(s64);
@@ -1746,17 +1751,18 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 		elem_size = max + 1;
 	else if (type < V4L2_CTRL_COMPLEX_TYPES)
 		elem_size = sizeof(s32);
+	tot_ctrl_size = elem_size * cols * rows;
 
 	/* Sanity checks */
-	if (id == 0 || name == NULL || id >= V4L2_CID_PRIVATE_BASE ||
-	    elem_size == 0 ||
+	if (id == 0 || name == NULL || !elem_size ||
+	    id >= V4L2_CID_PRIVATE_BASE ||
 	    (type == V4L2_CTRL_TYPE_MENU && qmenu == NULL) ||
 	    (type == V4L2_CTRL_TYPE_INTEGER_MENU && qmenu_int == NULL)) {
 		handler_set_err(hdl, -ERANGE);
 		return NULL;
 	}
 	/* Complex controls are always hidden */
-	if (type >= V4L2_CTRL_COMPLEX_TYPES)
+	if (is_matrix || type >= V4L2_CTRL_COMPLEX_TYPES)
 		flags |= V4L2_CTRL_FLAG_HIDDEN;
 	/*
 	 * No hidden controls are allowed in the USER class
@@ -1776,14 +1782,21 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 		handler_set_err(hdl, -ERANGE);
 		return NULL;
 	}
+	if (is_matrix &&
+	    (type == V4L2_CTRL_TYPE_BUTTON ||
+	     type == V4L2_CTRL_TYPE_CTRL_CLASS)) {
+		handler_set_err(hdl, -EINVAL);
+		return NULL;
+	}
 
-	sz_extra = elem_size;
+	sz_extra = tot_ctrl_size;
 	if (type == V4L2_CTRL_TYPE_BUTTON)
 		flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
 	else if (type == V4L2_CTRL_TYPE_CTRL_CLASS)
 		flags |= V4L2_CTRL_FLAG_READ_ONLY;
-	else if (type == V4L2_CTRL_TYPE_STRING || type >= V4L2_CTRL_COMPLEX_TYPES)
-		sz_extra += elem_size;
+	else if (type == V4L2_CTRL_TYPE_STRING ||
+		 type >= V4L2_CTRL_COMPLEX_TYPES || is_matrix)
+		sz_extra += tot_ctrl_size;
 
 	ctrl = kzalloc(sizeof(*ctrl) + sz_extra, GFP_KERNEL);
 	if (ctrl == NULL) {
@@ -1805,9 +1818,10 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	ctrl->maximum = max;
 	ctrl->step = step;
 	ctrl->default_value = def;
-	ctrl->is_string = type == V4L2_CTRL_TYPE_STRING;
-	ctrl->is_ptr = type >= V4L2_CTRL_COMPLEX_TYPES || ctrl->is_string;
+	ctrl->is_string = !is_matrix && type == V4L2_CTRL_TYPE_STRING;
+	ctrl->is_ptr = is_matrix || type >= V4L2_CTRL_COMPLEX_TYPES || ctrl->is_string;
 	ctrl->is_int = !ctrl->is_ptr && type != V4L2_CTRL_TYPE_INTEGER64;
+	ctrl->is_matrix = is_matrix;
 	ctrl->cols = cols;
 	ctrl->rows = rows;
 	ctrl->elem_size = elem_size;
@@ -1821,13 +1835,13 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 
 	if (ctrl->is_ptr) {
 		for (s = -1; s <= 0; s++)
-			ctrl->stores[s].p = data + (s + 1) * elem_size;
+			ctrl->stores[s].p = data + (s + 1) * tot_ctrl_size;
 	} else {
 		ctrl->new.p = &ctrl->val;
 		ctrl->stores[0].p = data;
 	}
 	for (s = -1; s <= 0; s++)
-		ctrl->type_ops->init(ctrl, ctrl->stores[s]);
+		ctrl->type_ops->init(ctrl, 0, ctrl->stores[s]);
 
 	if (handler_new_ref(hdl, ctrl)) {
 		kfree(ctrl);
@@ -2724,7 +2738,7 @@ s64 v4l2_ctrl_g_ctrl_int64(struct v4l2_ctrl *ctrl)
 	struct v4l2_ext_control c;
 
 	/* It's a driver bug if this happens. */
-	WARN_ON(ctrl->type != V4L2_CTRL_TYPE_INTEGER64);
+	WARN_ON(ctrl->is_ptr || ctrl->type != V4L2_CTRL_TYPE_INTEGER64);
 	c.value = 0;
 	get_ctrl(ctrl, &c);
 	return c.value;
@@ -3034,7 +3048,7 @@ int v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val)
 	struct v4l2_ext_control c;
 
 	/* It's a driver bug if this happens. */
-	WARN_ON(ctrl->type != V4L2_CTRL_TYPE_INTEGER64);
+	WARN_ON(ctrl->is_ptr || ctrl->type != V4L2_CTRL_TYPE_INTEGER64);
 	c.value64 = val;
 	return set_ctrl_lock(NULL, ctrl, &c);
 }
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 885a261..8756e47 100644
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
   * @is_ptr:	If set, then this control is a matrix and/or has type >= V4L2_CTRL_COMPLEX_TYPES
   *		and/or has type V4L2_CTRL_TYPE_STRING. In other words, struct
   *		v4l2_ext_control uses field p to point to the data.
+  * @is_matrix: If set, then this control contains a matrix.
   * @has_volatiles: If set, then one or more members of the cluster are volatile.
   *		Drivers should never touch this flag.
   * @call_notify: If set, then call the handler's notify function whenever the
@@ -169,6 +170,7 @@ struct v4l2_ctrl {
 	unsigned int is_int:1;
 	unsigned int is_string:1;
 	unsigned int is_ptr:1;
+	unsigned int is_matrix:1;
 	unsigned int has_volatiles:1;
 	unsigned int call_notify:1;
 	unsigned int manual_mode_value:8;
-- 
1.8.5.2

