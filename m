Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:42888 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753356AbeAaKZ2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Jan 2018 05:25:28 -0500
Received: by mail-pf0-f195.google.com with SMTP id b25so12136482pfd.9
        for <linux-media@vger.kernel.org>; Wed, 31 Jan 2018 02:25:27 -0800 (PST)
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
Subject: [RFCv2 09/17] v4l2-ctrls: use ref in helper instead of ctrl
Date: Wed, 31 Jan 2018 19:24:27 +0900
Message-Id: <20180131102427.207721-10-acourbot@chromium.org>
In-Reply-To: <20180131102427.207721-1-acourbot@chromium.org>
References: <20180131102427.207721-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The next patch needs the reference to a control instead of the
control itself, so change struct v4l2_ctrl_helper accordingly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index ca4c320f64c9..0fa20c89ece1 100644
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
@@ -2852,6 +2852,7 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 		ref = find_ref_lock(hdl, id);
 		if (ref == NULL)
 			return -EINVAL;
+		h->ref = ref;
 		ctrl = ref->ctrl;
 		if (ctrl->flags & V4L2_CTRL_FLAG_DISABLED)
 			return -EINVAL;
@@ -2874,7 +2875,6 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 		}
 		/* Store the ref to the master control of the cluster */
 		h->mref = ref;
-		h->ctrl = ctrl;
 		/* Initially set next to 0, meaning that there is no other
 		   control in this helper array belonging to the same
 		   cluster */
@@ -2959,7 +2959,7 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 	cs->error_idx = cs->count;
 
 	for (i = 0; !ret && i < cs->count; i++)
-		if (helpers[i].ctrl->flags & V4L2_CTRL_FLAG_WRITE_ONLY)
+		if (helpers[i].ref->ctrl->flags & V4L2_CTRL_FLAG_WRITE_ONLY)
 			ret = -EACCES;
 
 	for (i = 0; !ret && i < cs->count; i++) {
@@ -2994,7 +2994,7 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 
 			do {
 				ret = ctrl_to_user(cs->controls + idx,
-						   helpers[idx].ctrl);
+						   helpers[idx].ref->ctrl);
 				idx = helpers[idx].next;
 			} while (!ret && idx);
 		}
@@ -3133,7 +3133,7 @@ static int validate_ctrls(struct v4l2_ext_controls *cs,
 
 	cs->error_idx = cs->count;
 	for (i = 0; i < cs->count; i++) {
-		struct v4l2_ctrl *ctrl = helpers[i].ctrl;
+		struct v4l2_ctrl *ctrl = helpers[i].ref->ctrl;
 		union v4l2_ctrl_ptr p_new;
 
 		cs->error_idx = i;
@@ -3245,7 +3245,7 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 			do {
 				/* Check if the auto control is part of the
 				   list, and remember the new value. */
-				if (helpers[tmp_idx].ctrl == master)
+				if (helpers[tmp_idx].ref->ctrl == master)
 					new_auto_val = cs->controls[tmp_idx].value;
 				tmp_idx = helpers[tmp_idx].next;
 			} while (tmp_idx);
@@ -3258,7 +3258,7 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 		/* Copy the new caller-supplied control values.
 		   user_to_new() sets 'is_new' to 1. */
 		do {
-			struct v4l2_ctrl *ctrl = helpers[idx].ctrl;
+			struct v4l2_ctrl *ctrl = helpers[idx].ref->ctrl;
 
 			ret = user_to_new(cs->controls + idx, ctrl);
 			if (!ret && ctrl->is_ptr)
@@ -3274,7 +3274,7 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 			idx = i;
 			do {
 				ret = new_to_user(cs->controls + idx,
-						helpers[idx].ctrl);
+						helpers[idx].ref->ctrl);
 				idx = helpers[idx].next;
 			} while (!ret && idx);
 		}
-- 
2.16.0.rc1.238.g530d649a79-goog
