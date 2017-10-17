Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:54299 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757147AbdJQOx6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 10:53:58 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] media: v4l2-ctrl: Fix flags field on Control events
Date: Tue, 17 Oct 2017 16:53:53 +0200
Message-Id: <20171017145353.8521-1-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VIDIOC_DQEVENT and VIDIOC_QUERY_EXT_CTRL should give the same output for
the control flags field.

This patch creates a new function user_flags(), that calculates the user
exported flags value (which is different than the kernel internal flags
structure). This function is then used by all the code that exports the
internal flags to userspace.

Reported-by: Dimitrios Katsaros <patcherwork@gmail.com>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---

Maybe we should cc stable on this one.

 drivers/media/v4l2-core/v4l2-ctrls.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 4e53a8654690..751cf5746f90 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1227,6 +1227,16 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 }
 EXPORT_SYMBOL(v4l2_ctrl_fill);
 
+static u32 user_flags(struct v4l2_ctrl *ctrl)
+{
+	u32 flags = ctrl->flags;
+
+	if (ctrl->is_ptr)
+		flags |= V4L2_CTRL_FLAG_HAS_PAYLOAD;
+
+	return flags;
+}
+
 static void fill_event(struct v4l2_event *ev, struct v4l2_ctrl *ctrl, u32 changes)
 {
 	memset(ev->reserved, 0, sizeof(ev->reserved));
@@ -1234,7 +1244,7 @@ static void fill_event(struct v4l2_event *ev, struct v4l2_ctrl *ctrl, u32 change
 	ev->id = ctrl->id;
 	ev->u.ctrl.changes = changes;
 	ev->u.ctrl.type = ctrl->type;
-	ev->u.ctrl.flags = ctrl->flags;
+	ev->u.ctrl.flags = user_flags(ctrl);
 	if (ctrl->is_ptr)
 		ev->u.ctrl.value64 = 0;
 	else
@@ -2577,10 +2587,8 @@ int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctr
 	else
 		qc->id = ctrl->id;
 	strlcpy(qc->name, ctrl->name, sizeof(qc->name));
-	qc->flags = ctrl->flags;
+	qc->flags = user_flags(ctrl);
 	qc->type = ctrl->type;
-	if (ctrl->is_ptr)
-		qc->flags |= V4L2_CTRL_FLAG_HAS_PAYLOAD;
 	qc->elem_size = ctrl->elem_size;
 	qc->elems = ctrl->elems;
 	qc->nr_of_dims = ctrl->nr_of_dims;
-- 
2.14.2
