Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2577 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbaATMqq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jan 2014 07:46:46 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	t.stanislaws@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 09/21] v4l2-ctrls: rewrite copy routines to operate on union v4l2_ctrl_ptr.
Date: Mon, 20 Jan 2014 13:46:02 +0100
Message-Id: <1390221974-28194-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl>
References: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

In order to implement matrix support and (for the future) configuration stores
we need to have more generic copy routines. The v4l2_ctrl_ptr union was designed
for this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 129 +++++++++++++++--------------------
 1 file changed, 56 insertions(+), 73 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 9f97af4..c0507ed 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1266,48 +1266,64 @@ static const struct v4l2_ctrl_type_ops std_type_ops = {
 	.validate = std_validate,
 };
 
-/* Helper function: copy the current control value back to the caller */
-static int cur_to_user(struct v4l2_ext_control *c,
-		       struct v4l2_ctrl *ctrl)
+/* Helper function: copy the given control value back to the caller */
+static int ptr_to_user(struct v4l2_ext_control *c,
+		       struct v4l2_ctrl *ctrl,
+		       union v4l2_ctrl_ptr ptr)
 {
 	u32 len;
 
 	if (ctrl->is_ptr && !ctrl->is_string)
-		return copy_to_user(c->p, ctrl->cur.p, ctrl->elem_size);
+		return copy_to_user(c->p, ptr.p, ctrl->elem_size);
 
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_STRING:
-		len = strlen(ctrl->cur.string);
+		len = strlen(ptr.p_char);
 		if (c->size < len + 1) {
 			c->size = len + 1;
 			return -ENOSPC;
 		}
-		return copy_to_user(c->string, ctrl->cur.string,
-						len + 1) ? -EFAULT : 0;
+		return copy_to_user(c->string, ptr.p_char, len + 1) ?
+								-EFAULT : 0;
 	case V4L2_CTRL_TYPE_INTEGER64:
-		c->value64 = ctrl->cur.val64;
+		c->value64 = *ptr.p_s64;
 		break;
 	default:
-		c->value = ctrl->cur.val;
+		c->value = *ptr.p_s32;
 		break;
 	}
 	return 0;
 }
 
-/* Helper function: copy the caller-provider value as the new control value */
-static int user_to_new(struct v4l2_ext_control *c,
+/* Helper function: copy the current control value back to the caller */
+static int cur_to_user(struct v4l2_ext_control *c,
 		       struct v4l2_ctrl *ctrl)
 {
+	return ptr_to_user(c, ctrl, ctrl->stores[0]);
+}
+
+/* Helper function: copy the new control value back to the caller */
+static int new_to_user(struct v4l2_ext_control *c,
+		       struct v4l2_ctrl *ctrl)
+{
+	return ptr_to_user(c, ctrl, ctrl->new);
+}
+
+/* Helper function: copy the caller-provider value to the given control value */
+static int user_to_ptr(struct v4l2_ext_control *c,
+		       struct v4l2_ctrl *ctrl,
+		       union v4l2_ctrl_ptr ptr)
+{
 	int ret;
 	u32 size;
 
 	ctrl->is_new = 1;
 	if (ctrl->is_ptr && !ctrl->is_string)
-		return copy_from_user(ctrl->p, c->p, ctrl->elem_size);
+		return copy_from_user(ptr.p, c->p, ctrl->elem_size);
 
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_INTEGER64:
-		ctrl->val64 = c->value64;
+		*ptr.p_s64 = c->value64;
 		break;
 	case V4L2_CTRL_TYPE_STRING:
 		size = c->size;
@@ -1315,83 +1331,64 @@ static int user_to_new(struct v4l2_ext_control *c,
 			return -ERANGE;
 		if (size > ctrl->maximum + 1)
 			size = ctrl->maximum + 1;
-		ret = copy_from_user(ctrl->string, c->string, size);
+		ret = copy_from_user(ptr.p_char, c->string, size);
 		if (!ret) {
-			char last = ctrl->string[size - 1];
+			char last = ptr.p_char[size - 1];
 
-			ctrl->string[size - 1] = 0;
+			ptr.p_char[size - 1] = 0;
 			/* If the string was longer than ctrl->maximum,
 			   then return an error. */
-			if (strlen(ctrl->string) == ctrl->maximum && last)
+			if (strlen(ptr.p_char) == ctrl->maximum && last)
 				return -ERANGE;
 		}
 		return ret ? -EFAULT : 0;
 	default:
-		ctrl->val = c->value;
+		*ptr.p_s32 = c->value;
 		break;
 	}
 	return 0;
 }
 
-/* Helper function: copy the new control value back to the caller */
-static int new_to_user(struct v4l2_ext_control *c,
+/* Helper function: copy the caller-provider value as the new control value */
+static int user_to_new(struct v4l2_ext_control *c,
 		       struct v4l2_ctrl *ctrl)
 {
-	u32 len;
-
-	if (ctrl->is_ptr && !ctrl->is_string)
-		return copy_to_user(c->p, ctrl->p, ctrl->elem_size);
+	return user_to_ptr(c, ctrl, ctrl->new);
+}
 
+/* Copy the one value to another. */
+static void ptr_to_ptr(struct v4l2_ctrl *ctrl,
+		       union v4l2_ctrl_ptr from, union v4l2_ctrl_ptr to)
+{
+	if (ctrl == NULL)
+		return;
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_STRING:
-		len = strlen(ctrl->string);
-		if (c->size < len + 1) {
-			c->size = ctrl->maximum + 1;
-			return -ENOSPC;
-		}
-		return copy_to_user(c->string, ctrl->string,
-						len + 1) ? -EFAULT : 0;
+		/* strings are always 0-terminated */
+		strcpy(to.p_char, from.p_char);
+		break;
 	case V4L2_CTRL_TYPE_INTEGER64:
-		c->value64 = ctrl->val64;
+		*to.p_s64 = *from.p_s64;
 		break;
 	default:
-		c->value = ctrl->val;
+		if (ctrl->is_ptr)
+			memcpy(to.p, from.p, ctrl->elem_size);
+		else
+			*to.p_s32 = *from.p_s32;
 		break;
 	}
-	return 0;
 }
 
 /* Copy the new value to the current value. */
 static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 ch_flags)
 {
-	bool changed = false;
+	bool changed;
 
 	if (ctrl == NULL)
 		return;
+	changed = !ctrl->type_ops->equal(ctrl, ctrl->stores[0], ctrl->new);
+	ptr_to_ptr(ctrl, ctrl->new, ctrl->stores[0]);
 
-	switch (ctrl->type) {
-	case V4L2_CTRL_TYPE_BUTTON:
-		changed = true;
-		break;
-	case V4L2_CTRL_TYPE_STRING:
-		/* strings are always 0-terminated */
-		changed = strcmp(ctrl->string, ctrl->cur.string);
-		strcpy(ctrl->cur.string, ctrl->string);
-		break;
-	case V4L2_CTRL_TYPE_INTEGER64:
-		changed = ctrl->val64 != ctrl->cur.val64;
-		ctrl->cur.val64 = ctrl->val64;
-		break;
-	default:
-		if (ctrl->is_ptr) {
-			changed = memcmp(ctrl->p, ctrl->cur.p, ctrl->elem_size);
-			memcpy(ctrl->cur.p, ctrl->p, ctrl->elem_size);
-		} else {
-			changed = ctrl->val != ctrl->cur.val;
-			ctrl->cur.val = ctrl->val;
-		}
-		break;
-	}
 	if (ch_flags & V4L2_EVENT_CTRL_CH_FLAGS) {
 		/* Note: CH_FLAGS is only set for auto clusters. */
 		ctrl->flags &=
@@ -1420,21 +1417,7 @@ static void cur_to_new(struct v4l2_ctrl *ctrl)
 {
 	if (ctrl == NULL)
 		return;
-	switch (ctrl->type) {
-	case V4L2_CTRL_TYPE_STRING:
-		/* strings are always 0-terminated */
-		strcpy(ctrl->string, ctrl->cur.string);
-		break;
-	case V4L2_CTRL_TYPE_INTEGER64:
-		ctrl->val64 = ctrl->cur.val64;
-		break;
-	default:
-		if (ctrl->is_ptr)
-			memcpy(ctrl->p, ctrl->cur.p, ctrl->elem_size);
-		else
-			ctrl->val = ctrl->cur.val;
-		break;
-	}
+	ptr_to_ptr(ctrl, ctrl->stores[0], ctrl->new);
 }
 
 /* Return non-zero if one or more of the controls in the cluster has a new
-- 
1.8.5.2

