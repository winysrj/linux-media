Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:37921 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753287AbeC1Nul (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 09:50:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@google.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv9 PATCH 12/29] v4l2-ctrls: support g/s_ext_ctrls for requests
Date: Wed, 28 Mar 2018 15:50:13 +0200
Message-Id: <20180328135030.7116-13-hverkuil@xs4all.nl>
In-Reply-To: <20180328135030.7116-1-hverkuil@xs4all.nl>
References: <20180328135030.7116-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The v4l2_g/s_ext_ctrls functions now support control handlers that
represent requests.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 37 ++++++++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index fc13f328c6fc..80714c5bad8b 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1647,6 +1647,13 @@ static int new_to_user(struct v4l2_ext_control *c,
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
@@ -1766,6 +1773,14 @@ static void cur_to_new(struct v4l2_ctrl *ctrl)
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
@@ -3002,7 +3017,8 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 				    struct v4l2_ctrl *ctrl);
 		struct v4l2_ctrl *master;
 
-		ctrl_to_user = def_value ? def_to_user : cur_to_user;
+		ctrl_to_user = def_value ? def_to_user :
+			       (hdl->req_obj.req ? NULL : cur_to_user);
 
 		if (helpers[i].mref == NULL)
 			continue;
@@ -3028,8 +3044,12 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
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
@@ -3302,7 +3322,16 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 		} while (!ret && idx);
 
 		if (!ret)
-			ret = try_or_set_cluster(fh, master, set, 0);
+			ret = try_or_set_cluster(fh, master,
+						 !hdl->req_obj.req && set, 0);
+		if (!ret && hdl->req_obj.req && set) {
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
2.16.1
