Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2209 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbaBQJ7D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Feb 2014 04:59:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv3 PATCH 16/35] v4l2-ctrls: add matrix support.
Date: Mon, 17 Feb 2014 10:57:31 +0100
Message-Id: <1392631070-41868-17-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
References: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Finish the userspace-facing matrix support.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 109 ++++++++++++++++++++---------------
 1 file changed, 64 insertions(+), 45 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 7dc997d..adc1c53 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1173,6 +1173,8 @@ static void std_init(const struct v4l2_ctrl *ctrl, u32 idx,
 		ptr.p_s32[idx] = ctrl->default_value;
 		break;
 	default:
+		idx *= ctrl->elem_size;
+		memset(ptr.p + idx, 0, ctrl->elem_size);
 		break;
 	}
 }
@@ -1290,7 +1292,7 @@ static int ptr_to_user(struct v4l2_ext_control *c,
 	u32 len;
 
 	if (ctrl->is_ptr && !ctrl->is_string)
-		return copy_to_user(c->p, ptr.p, ctrl->elem_size);
+		return copy_to_user(c->p, ptr.p, c->size);
 
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_STRING:
@@ -1334,8 +1336,17 @@ static int user_to_ptr(struct v4l2_ext_control *c,
 	u32 size;
 
 	ctrl->is_new = 1;
-	if (ctrl->is_ptr && !ctrl->is_string)
-		return copy_from_user(ptr.p, c->p, ctrl->elem_size);
+	if (ctrl->is_ptr && !ctrl->is_string) {
+		unsigned idx;
+
+		ret = copy_from_user(ptr.p, c->p, c->size);
+		if (ret || !ctrl->is_matrix)
+			return ret;
+		for (idx = c->size / ctrl->elem_size;
+		     idx < ctrl->rows * ctrl->cols; idx++)
+			ctrl->type_ops->init(ctrl, idx, ptr);
+		return 0;
+	}
 
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_INTEGER64:
@@ -1378,21 +1389,7 @@ static void ptr_to_ptr(struct v4l2_ctrl *ctrl,
 {
 	if (ctrl == NULL)
 		return;
-	switch (ctrl->type) {
-	case V4L2_CTRL_TYPE_STRING:
-		/* strings are always 0-terminated */
-		strcpy(to.p_char, from.p_char);
-		break;
-	case V4L2_CTRL_TYPE_INTEGER64:
-		*to.p_s64 = *from.p_s64;
-		break;
-	default:
-		if (ctrl->is_ptr)
-			memcpy(to.p, from.p, ctrl->elem_size);
-		else
-			*to.p_s32 = *from.p_s32;
-		break;
-	}
+	memcpy(to.p, from.p, ctrl->rows * ctrl->cols * ctrl->elem_size);
 }
 
 /* Copy the new value to the current value. */
@@ -1444,15 +1441,20 @@ static void cur_to_new(struct v4l2_ctrl *ctrl)
 static int cluster_changed(struct v4l2_ctrl *master)
 {
 	bool changed = false;
+	unsigned idx;
 	int i;
 
 	for (i = 0; i < master->ncontrols; i++) {
 		struct v4l2_ctrl *ctrl = master->cluster[i];
+		bool ctrl_changed = false;
 
 		if (ctrl == NULL)
 			continue;
-		ctrl->has_changed = !ctrl->type_ops->equal(ctrl, 0,
+		for (idx = 0; !ctrl_changed &&
+			      idx < ctrl->rows * ctrl->cols; idx++)
+			ctrl_changed = !ctrl->type_ops->equal(ctrl, idx,
 						ctrl->stores[0], ctrl->new);
+		ctrl->has_changed = ctrl_changed;
 		changed |= ctrl->has_changed;
 	}
 	return changed;
@@ -1499,26 +1501,32 @@ static int validate_new(const struct v4l2_ctrl *ctrl,
 			struct v4l2_ext_control *c)
 {
 	union v4l2_ctrl_ptr ptr;
-
-	switch (ctrl->type) {
-	case V4L2_CTRL_TYPE_INTEGER:
-	case V4L2_CTRL_TYPE_INTEGER_MENU:
-	case V4L2_CTRL_TYPE_MENU:
-	case V4L2_CTRL_TYPE_BITMASK:
-	case V4L2_CTRL_TYPE_BOOLEAN:
-	case V4L2_CTRL_TYPE_BUTTON:
-	case V4L2_CTRL_TYPE_CTRL_CLASS:
-		ptr.p_s32 = &c->value;
-		return ctrl->type_ops->validate(ctrl, 0, ptr);
-
-	case V4L2_CTRL_TYPE_INTEGER64:
-		ptr.p_s64 = &c->value64;
-		return ctrl->type_ops->validate(ctrl, 0, ptr);
-
-	default:
-		ptr.p = c->p;
-		return ctrl->type_ops->validate(ctrl, 0, ptr);
+	unsigned idx;
+	int err = 0;
+
+	if (!ctrl->is_ptr) {
+		switch (ctrl->type) {
+		case V4L2_CTRL_TYPE_INTEGER:
+		case V4L2_CTRL_TYPE_INTEGER_MENU:
+		case V4L2_CTRL_TYPE_MENU:
+		case V4L2_CTRL_TYPE_BITMASK:
+		case V4L2_CTRL_TYPE_BOOLEAN:
+		case V4L2_CTRL_TYPE_BUTTON:
+		case V4L2_CTRL_TYPE_CTRL_CLASS:
+			ptr.p_s32 = &c->value;
+			return ctrl->type_ops->validate(ctrl, 0, ptr);
+
+		case V4L2_CTRL_TYPE_INTEGER64:
+			ptr.p_s64 = &c->value64;
+			return ctrl->type_ops->validate(ctrl, 0, ptr);
+		default:
+			break;
+		}
 	}
+	ptr.p = c->p;
+	for (idx = 0; !err && idx < c->size / ctrl->elem_size; idx++)
+		err = ctrl->type_ops->validate(ctrl, idx, ptr);
+	return err;
 }
 
 static inline u32 node2id(struct list_head *node)
@@ -1745,6 +1753,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	struct v4l2_ctrl *ctrl;
 	bool is_matrix;
 	unsigned sz_extra, tot_ctrl_size;
+	unsigned idx;
 	void *data;
 	int err;
 	int s;
@@ -1845,7 +1854,8 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 		ctrl->stores[0].p = data;
 	}
 	for (s = -1; s <= 0; s++)
-		ctrl->type_ops->init(ctrl, 0, ctrl->stores[s]);
+		for (idx = 0; idx < rows * cols; idx++)
+			ctrl->type_ops->init(ctrl, idx, ctrl->stores[s]);
 
 	if (handler_new_ref(hdl, ctrl)) {
 		kfree(ctrl);
@@ -2542,12 +2552,18 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 			have_clusters = true;
 		if (ctrl->cluster[0] != ctrl)
 			ref = find_ref_lock(hdl, ctrl->cluster[0]->id);
-		if (ctrl->is_ptr && !ctrl->is_string && c->size < ctrl->elem_size) {
-			if (get) {
-				c->size = ctrl->elem_size;
-				return -ENOSPC;
+		if (ctrl->is_ptr && !ctrl->is_string) {
+			unsigned tot_size = ctrl->rows * ctrl->cols *
+					    ctrl->elem_size;
+
+			if (c->size < tot_size) {
+				if (get) {
+					c->size = tot_size;
+					return -ENOSPC;
+				}
+				return -EFAULT;
 			}
-			return -EFAULT;
+			c->size = tot_size;
 		}
 		/* Store the ref to the master control of the cluster */
 		h->mref = ref;
@@ -3087,7 +3103,7 @@ EXPORT_SYMBOL(v4l2_ctrl_notify);
 int v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
 			s64 min, s64 max, u64 step, s64 def)
 {
-	int ret = check_range(ctrl->type, min, max, step, def);
+	int ret;
 	struct v4l2_ext_control c;
 
 	switch (ctrl->type) {
@@ -3097,6 +3113,9 @@ int v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
 	case V4L2_CTRL_TYPE_MENU:
 	case V4L2_CTRL_TYPE_INTEGER_MENU:
 	case V4L2_CTRL_TYPE_BITMASK:
+		if (ctrl->is_matrix)
+			return -EINVAL;
+		ret = check_range(ctrl->type, min, max, step, def);
 		if (ret)
 			return ret;
 		break;
-- 
1.8.4.rc3

