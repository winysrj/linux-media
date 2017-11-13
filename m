Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:53497 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752260AbdKMOeL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Nov 2017 09:34:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 4/6] v4l2-ctrls: use ref in helper instead of ctrl
Date: Mon, 13 Nov 2017 15:34:06 +0100
Message-Id: <20171113143408.19644-5-hverkuil@xs4all.nl>
In-Reply-To: <20171113143408.19644-1-hverkuil@xs4all.nl>
References: <20171113143408.19644-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The next patch needs the reference to a control instead of the
control itself, so change struct v4l2_ctrl_helper accordingly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 710a75a2e19d..f8de43032b78 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -37,8 +37,8 @@
 struct v4l2_ctrl_helper {
 	/* Pointer to the control reference of the master control */
 	struct v4l2_ctrl_ref *mref;
-	/* The control corresponding to the v4l2_ext_control ID field. */
-	struct v4l2_ctrl *ctrl;
+	/* The control ref corresponding to the v4l2_ext_control ID field. */
+	struct v4l2_ctrl_ref *ref;
 	/* v4l2_ext_control index of the next control belonging to the
 	   same cluster, or 0 if there isn't any. */
 	u32 next;
@@ -2860,6 +2860,7 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 		ref = find_ref_lock(hdl, id);
 		if (ref == NULL)
 			return -EINVAL;
+		h->ref = ref;
 		ctrl = ref->ctrl;
 		if (ctrl->flags & V4L2_CTRL_FLAG_DISABLED)
 			return -EINVAL;
@@ -2882,7 +2883,6 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 		}
 		/* Store the ref to the master control of the cluster */
 		h->mref = ref;
-		h->ctrl = ctrl;
 		/* Initially set next to 0, meaning that there is no other
 		   control in this helper array belonging to the same
 		   cluster */
@@ -2967,7 +2967,7 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 	cs->error_idx = cs->count;
 
 	for (i = 0; !ret && i < cs->count; i++)
-		if (helpers[i].ctrl->flags & V4L2_CTRL_FLAG_WRITE_ONLY)
+		if (helpers[i].ref->ctrl->flags & V4L2_CTRL_FLAG_WRITE_ONLY)
 			ret = -EACCES;
 
 	for (i = 0; !ret && i < cs->count; i++) {
@@ -3002,7 +3002,7 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 
 			do {
 				ret = ctrl_to_user(cs->controls + idx,
-						   helpers[idx].ctrl);
+						   helpers[idx].ref->ctrl);
 				idx = helpers[idx].next;
 			} while (!ret && idx);
 		}
@@ -3141,7 +3141,7 @@ static int validate_ctrls(struct v4l2_ext_controls *cs,
 
 	cs->error_idx = cs->count;
 	for (i = 0; i < cs->count; i++) {
-		struct v4l2_ctrl *ctrl = helpers[i].ctrl;
+		struct v4l2_ctrl *ctrl = helpers[i].ref->ctrl;
 		union v4l2_ctrl_ptr p_new;
 
 		cs->error_idx = i;
@@ -3253,7 +3253,7 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 			do {
 				/* Check if the auto control is part of the
 				   list, and remember the new value. */
-				if (helpers[tmp_idx].ctrl == master)
+				if (helpers[tmp_idx].ref->ctrl == master)
 					new_auto_val = cs->controls[tmp_idx].value;
 				tmp_idx = helpers[tmp_idx].next;
 			} while (tmp_idx);
@@ -3266,7 +3266,7 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 		/* Copy the new caller-supplied control values.
 		   user_to_new() sets 'is_new' to 1. */
 		do {
-			struct v4l2_ctrl *ctrl = helpers[idx].ctrl;
+			struct v4l2_ctrl *ctrl = helpers[idx].ref->ctrl;
 
 			ret = user_to_new(cs->controls + idx, ctrl);
 			if (!ret && ctrl->is_ptr)
@@ -3282,7 +3282,7 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 			idx = i;
 			do {
 				ret = new_to_user(cs->controls + idx,
-						helpers[idx].ctrl);
+						helpers[idx].ref->ctrl);
 				idx = helpers[idx].next;
 			} while (!ret && idx);
 		}
-- 
2.14.1
