Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:32870 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753716AbeAaK0c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Jan 2018 05:26:32 -0500
Received: by mail-pf0-f194.google.com with SMTP id t5so12157368pfi.0
        for <linux-media@vger.kernel.org>; Wed, 31 Jan 2018 02:26:32 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [RFCv2 10/17] v4l2-ctrls: support g/s_ext_ctrls for requests
Date: Wed, 31 Jan 2018 19:26:18 +0900
Message-Id: <20180131102625.208021-1-acourbot@chromium.org>
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
index 0fa20c89ece1..e4d29cc76ca8 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1518,6 +1518,13 @@ static int new_to_user(struct v4l2_ext_control *c,
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
@@ -1637,6 +1644,14 @@ static void cur_to_new(struct v4l2_ctrl *ctrl)
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
@@ -2967,7 +2982,8 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 				    struct v4l2_ctrl *ctrl);
 		struct v4l2_ctrl *master;
 
-		ctrl_to_user = def_value ? def_to_user : cur_to_user;
+		ctrl_to_user = def_value ? def_to_user :
+			       (hdl->is_request ? NULL : cur_to_user);
 
 		if (helpers[i].mref == NULL)
 			continue;
@@ -2993,8 +3009,12 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
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
@@ -3267,7 +3287,16 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
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
2.16.0.rc1.238.g530d649a79-goog
