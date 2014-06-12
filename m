Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4052 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236AbaFLLyl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 07:54:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv4 PATCH 14/34] v4l2-ctrls: add array support.
Date: Thu, 12 Jun 2014 13:52:46 +0200
Message-Id: <cabd1863eee3d1d144145cd71a03536aab6f8595.1402573818.git.hans.verkuil@cisco.com>
In-Reply-To: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
References: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
References: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Finish the userspace-facing array support.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 109 ++++++++++++++++++++---------------
 1 file changed, 63 insertions(+), 46 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index f6ac927..b3ab8a9 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1202,6 +1202,8 @@ static void std_init(const struct v4l2_ctrl *ctrl, u32 idx,
 		ptr.p_s32[idx] = ctrl->default_value;
 		break;
 	default:
+		idx *= ctrl->elem_size;
+		memset(ptr.p + idx, 0, ctrl->elem_size);
 		break;
 	}
 }
@@ -1324,7 +1326,7 @@ static int ptr_to_user(struct v4l2_ext_control *c,
 	u32 len;
 
 	if (ctrl->is_ptr && !ctrl->is_string)
-		return copy_to_user(c->ptr, ptr.p, ctrl->elem_size);
+		return copy_to_user(c->ptr, ptr.p, c->size);
 
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_STRING:
@@ -1368,8 +1370,16 @@ static int user_to_ptr(struct v4l2_ext_control *c,
 	u32 size;
 
 	ctrl->is_new = 1;
-	if (ctrl->is_ptr && !ctrl->is_string)
-		return copy_from_user(ptr.p, c->ptr, ctrl->elem_size);
+	if (ctrl->is_ptr && !ctrl->is_string) {
+		unsigned idx;
+
+		ret = copy_from_user(ptr.p, c->ptr, c->size);
+		if (ret || !ctrl->is_array)
+			return ret;
+		for (idx = c->size / ctrl->elem_size; idx < ctrl->elems; idx++)
+			ctrl->type_ops->init(ctrl, idx, ptr);
+		return 0;
+	}
 
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_INTEGER64:
@@ -1412,21 +1422,7 @@ static void ptr_to_ptr(struct v4l2_ctrl *ctrl,
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
+	memcpy(to.p, from.p, ctrl->elems * ctrl->elem_size);
 }
 
 /* Copy the new value to the current value. */
@@ -1478,15 +1474,19 @@ static void cur_to_new(struct v4l2_ctrl *ctrl)
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
+		for (idx = 0; !ctrl_changed && idx < ctrl->elems; idx++)
+			ctrl_changed = !ctrl->type_ops->equal(ctrl, idx,
 				ctrl->p_cur, ctrl->p_new);
+		ctrl->has_changed = ctrl_changed;
 		changed |= ctrl->has_changed;
 	}
 	return changed;
@@ -1533,26 +1533,32 @@ static int validate_new(const struct v4l2_ctrl *ctrl,
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
-		ptr.p = c->ptr;
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
+	ptr.p = c->ptr;
+	for (idx = 0; !err && idx < c->size / ctrl->elem_size; idx++)
+		err = ctrl->type_ops->validate(ctrl, idx, ptr);
+	return err;
 }
 
 static inline u32 node2id(struct list_head *node)
@@ -1781,6 +1787,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	unsigned elems = 1;
 	bool is_array;
 	unsigned tot_ctrl_size;
+	unsigned idx;
 	void *data;
 	int err;
 
@@ -1881,8 +1888,10 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 		ctrl->p_new.p = &ctrl->val;
 		ctrl->p_cur.p = &ctrl->cur.val;
 	}
-	ctrl->type_ops->init(ctrl, 0, ctrl->p_cur);
-	ctrl->type_ops->init(ctrl, 0, ctrl->p_new);
+	for (idx = 0; idx < elems; idx++) {
+		ctrl->type_ops->init(ctrl, idx, ctrl->p_cur);
+		ctrl->type_ops->init(ctrl, idx, ctrl->p_new);
+	}
 
 	if (handler_new_ref(hdl, ctrl)) {
 		kfree(ctrl);
@@ -2578,12 +2587,17 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 			have_clusters = true;
 		if (ctrl->cluster[0] != ctrl)
 			ref = find_ref_lock(hdl, ctrl->cluster[0]->id);
-		if (ctrl->is_ptr && !ctrl->is_string && c->size < ctrl->elem_size) {
-			if (get) {
-				c->size = ctrl->elem_size;
-				return -ENOSPC;
+		if (ctrl->is_ptr && !ctrl->is_string) {
+			unsigned tot_size = ctrl->elems * ctrl->elem_size;
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
@@ -3123,7 +3137,7 @@ EXPORT_SYMBOL(v4l2_ctrl_notify);
 int v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
 			s64 min, s64 max, u64 step, s64 def)
 {
-	int ret = check_range(ctrl->type, min, max, step, def);
+	int ret;
 	struct v4l2_ext_control c;
 
 	switch (ctrl->type) {
@@ -3133,6 +3147,9 @@ int v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
 	case V4L2_CTRL_TYPE_MENU:
 	case V4L2_CTRL_TYPE_INTEGER_MENU:
 	case V4L2_CTRL_TYPE_BITMASK:
+		if (ctrl->is_array)
+			return -EINVAL;
+		ret = check_range(ctrl->type, min, max, step, def);
 		if (ret)
 			return ret;
 		break;
-- 
2.0.0.rc0

