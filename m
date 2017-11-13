Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:58178 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752470AbdKMOeL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Nov 2017 09:34:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 5/6] v4l2-ctrls: support g/s_ext_ctrls for requests
Date: Mon, 13 Nov 2017 15:34:07 +0100
Message-Id: <20171113143408.19644-6-hverkuil@xs4all.nl>
In-Reply-To: <20171113143408.19644-1-hverkuil@xs4all.nl>
References: <20171113143408.19644-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The v4l2_g/s_ext_ctrls functions now support control handlers that
represent requests.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 37 ++++++++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index f8de43032b78..36b00ad2d5cb 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1528,6 +1528,13 @@ static int new_to_user(struct v4l2_ext_control *c,
 	return ptr_to_user(c, ctrl, ctrl->p_new);
 }
 
+/* Helper function: copy the request value back to the caller */
+static int req_to_user(struct v4l2_ext_control *c,
+		       struct v4l2_ctrl_ref *ref)
+{
+	return ptr_to_user(c, ref->ctrl, ref->p_req);
+}
+
 /* Helper function: copy the initial control value back to the caller */
 static int def_to_user(struct v4l2_ext_control *c, struct v4l2_ctrl *ctrl)
 {
@@ -1647,6 +1654,14 @@ static void cur_to_new(struct v4l2_ctrl *ctrl)
 	ptr_to_ptr(ctrl, ctrl->p_cur, ctrl->p_new);
 }
 
+/* Copy the new value to the request value */
+static void new_to_req(struct v4l2_ctrl_ref *ref)
+{
+	if (!ref)
+		return;
+	ptr_to_ptr(ref->ctrl, ref->ctrl->p_new, ref->p_req);
+}
+
 /* Return non-zero if one or more of the controls in the cluster has a new
    value that differs from the current value. */
 static int cluster_changed(struct v4l2_ctrl *master)
@@ -2975,7 +2990,8 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 				    struct v4l2_ctrl *ctrl);
 		struct v4l2_ctrl *master;
 
-		ctrl_to_user = def_value ? def_to_user : cur_to_user;
+		ctrl_to_user = def_value ? def_to_user :
+			       (hdl->is_request ? NULL : cur_to_user);
 
 		if (helpers[i].mref == NULL)
 			continue;
@@ -3001,8 +3017,12 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 			u32 idx = i;
 
 			do {
-				ret = ctrl_to_user(cs->controls + idx,
-						   helpers[idx].ref->ctrl);
+				if (ctrl_to_user)
+					ret = ctrl_to_user(cs->controls + idx,
+						helpers[idx].ref->ctrl);
+				else
+					ret = req_to_user(cs->controls + idx,
+						helpers[idx].ref);
 				idx = helpers[idx].next;
 			} while (!ret && idx);
 		}
@@ -3275,7 +3295,16 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 		} while (!ret && idx);
 
 		if (!ret)
-			ret = try_or_set_cluster(fh, master, set, 0);
+			ret = try_or_set_cluster(fh, master,
+						 !hdl->is_request && set, 0);
+		if (!ret && hdl->is_request && set) {
+			for (j = 0; j < master->ncontrols; j++) {
+				struct v4l2_ctrl_ref *ref =
+					find_ref(hdl, master->cluster[j]->id);
+
+				new_to_req(ref);
+			}
+		}
 
 		/* Copy the new values back to userspace. */
 		if (!ret) {
-- 
2.14.1
