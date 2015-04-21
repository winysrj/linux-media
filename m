Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:49850 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751621AbbDUNA3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 09:00:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 06/15] v4l2-ctrls: add function to apply a request.
Date: Tue, 21 Apr 2015 14:58:49 +0200
Message-Id: <1429621138-17213-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429621138-17213-1-git-send-email-hverkuil@xs4all.nl>
References: <1429621138-17213-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Drivers need to be able to select a specific request. Add a new function that can
be used to apply a given request.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 112 +++++++++++++++++++++++++++++++++--
 include/media/v4l2-ctrls.h           |   3 +
 include/uapi/linux/videodev2.h       |   1 +
 3 files changed, 110 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index d28035c..93c51cc 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1691,8 +1691,10 @@ static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 ch_flags)
 /* Helper function: copy the new control value to the request */
 static void new_to_request(struct v4l2_ctrl *ctrl)
 {
-	if (ctrl)
+	if (ctrl) {
 		ptr_to_ptr(ctrl, ctrl->p_new, ctrl->request->ptr);
+		ctrl->request->applied = 0;
+	}
 }
 
 /* Copy the current value to the new value */
@@ -1703,6 +1705,17 @@ static void cur_to_new(struct v4l2_ctrl *ctrl)
 	ptr_to_ptr(ctrl, ctrl->p_cur, ctrl->p_new);
 }
 
+static void request_to_new(struct v4l2_ctrl *ctrl)
+{
+	if (ctrl == NULL)
+		return;
+	if (ctrl->request)
+		ptr_to_ptr(ctrl, ctrl->request->ptr, ctrl->p_new);
+	else
+		ptr_to_ptr(ctrl, ctrl->p_cur, ctrl->p_new);
+	ctrl->is_new = true;
+}
+
 /* Return non-zero if one or more of the controls in the cluster has a new
    value that differs from the current value. */
 static int cluster_changed(struct v4l2_ctrl *master)
@@ -2599,6 +2612,7 @@ int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctr
 	u32 id = qc->id & V4L2_CTRL_ID_MASK;
 	u32 req = qc->request;
 	struct v4l2_ctrl_ref *ref;
+	struct v4l2_ctrl_req *ctrl_req = NULL;
 	struct v4l2_ctrl *ctrl;
 
 	if (hdl == NULL || req > USHRT_MAX)
@@ -2662,8 +2676,11 @@ int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctr
 
 	if (!ref)
 		return -EINVAL;
-	if (req && get_request(ref->ctrl, req) == NULL)
-		return -EINVAL;
+	if (req) {
+		ctrl_req = get_request(ref->ctrl, req);
+		if (ctrl_req == NULL)
+			return -EINVAL;
+	}
 
 	ctrl = ref->ctrl;
 	memset(qc, 0, sizeof(*qc));
@@ -2673,6 +2690,10 @@ int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctr
 		qc->id = ctrl->id;
 	strlcpy(qc->name, ctrl->name, sizeof(qc->name));
 	qc->flags = ctrl->flags;
+	if (req) {
+		if (ctrl_req->applied)
+			qc->flags |= V4L2_CTRL_FLAG_REQ_APPLIED;
+	}
 	qc->max_reqs = ctrl->max_reqs;
 	qc->type = ctrl->type;
 	if (ctrl->is_ptr)
@@ -2836,7 +2857,7 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 			     bool get)
 {
 	u32 ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
-	unsigned request = cs->request & 0xffff;
+	unsigned request = cs->request & USHRT_MAX;
 	struct v4l2_ctrl_helper *h;
 	bool have_clusters = false;
 	u32 i;
@@ -3223,7 +3244,7 @@ static void update_from_auto_cluster(struct v4l2_ctrl *master)
 		if (master->cluster[i] == NULL)
 			continue;
 		cur_to_new(master->cluster[i]);
-		master->cluster[i]->request = 0;
+		master->cluster[i]->request = NULL;
 	}
 	if (!call_op(master, g_volatile_ctrl))
 		for (i = 1; i < master->ncontrols; i++)
@@ -3374,7 +3395,6 @@ static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 ch_flags)
 		if (master->cluster[i] == NULL)
 			continue;
 		master->cluster[i]->is_new = 0;
-		master->cluster[i]->request = NULL;
 	}
 
 	ret = validate_new(ctrl, ctrl->p_new);
@@ -3466,6 +3486,86 @@ int __v4l2_ctrl_s_ctrl_string(struct v4l2_ctrl *ctrl, const char *s)
 }
 EXPORT_SYMBOL(__v4l2_ctrl_s_ctrl_string);
 
+int v4l2_ctrl_apply_request(struct v4l2_ctrl_handler *hdl, unsigned request)
+{
+	struct v4l2_ctrl_ref *ref;
+	bool found_request = false;
+	int ret = 0;
+	unsigned i;
+
+	if (hdl == NULL)
+		return -EINVAL;
+	if (request == 0)
+		return 0;
+
+	mutex_lock(hdl->lock);
+
+	list_for_each_entry(ref, &hdl->ctrl_refs, node) {
+		struct v4l2_ctrl *master;
+		bool apply_request = false;
+
+		if (ref->ctrl->max_reqs == 0)
+			continue;
+		master = ref->ctrl->cluster[0];
+		if (ref->ctrl != master)
+			continue;
+		if (master->handler != hdl)
+			v4l2_ctrl_lock(master);
+		for (i = 0; !ret && i < master->ncontrols; i++) {
+			struct v4l2_ctrl *ctrl = master->cluster[i];
+
+			if (ctrl == NULL)
+				continue;
+			ctrl->is_new = 0;
+			ctrl->request = get_request(ctrl, request);
+			if (ctrl->request == NULL)
+				continue;
+			found_request = true;
+			if (!ctrl->request->applied) {
+				request_to_new(master->cluster[i]);
+				apply_request = true;
+				ctrl->request->applied = 1;
+			}
+		}
+		if (ret) {
+			if (master->handler != hdl)
+				v4l2_ctrl_unlock(master);
+			break;
+		}
+
+		/*
+		 * Skip if it is a request that has already been applied.
+		 */
+		if (!apply_request)
+			goto unlock;
+
+		/* For volatile autoclusters that are currently in auto mode
+		   we need to discover if it will be set to manual mode.
+		   If so, then we have to copy the current volatile values
+		   first since those will become the new manual values (which
+		   may be overwritten by explicit new values from this set
+		   of controls). */
+		if (master->is_auto && master->has_volatiles &&
+						!is_cur_manual(master)) {
+			s32 new_auto_val = *master->p_new.p_s32;
+
+			/* If the new value == the manual value, then copy
+			   the current volatile values. */
+			if (new_auto_val == master->manual_mode_value)
+				update_from_auto_cluster(master);
+		}
+
+		try_or_set_cluster(NULL, master, 0, true, 0);
+
+unlock:
+		if (master->handler != hdl)
+			v4l2_ctrl_unlock(master);
+	}
+	mutex_unlock(hdl->lock);
+	return ret ? ret : (found_request ? 0 : -EINVAL);
+}
+EXPORT_SYMBOL(v4l2_ctrl_apply_request);
+
 void v4l2_ctrl_notify(struct v4l2_ctrl *ctrl, v4l2_ctrl_notify_fnc notify, void *priv)
 {
 	if (ctrl == NULL)
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index abc5eb3..2d188a2 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -95,6 +95,7 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
 struct v4l2_ctrl_req {
 	struct list_head node;
 	u32 request;
+	unsigned applied:1;
 	union v4l2_ctrl_ptr ptr;
 };
 
@@ -808,6 +809,8 @@ static inline void v4l2_ctrl_s_max_reqs(struct v4l2_ctrl *ctrl, u16 max_reqs)
 	ctrl->max_reqs = max_reqs;
 }
 
+int v4l2_ctrl_apply_request(struct v4l2_ctrl_handler *hdl, unsigned request);
+
 /* Internal helper functions that deal with control events. */
 extern const struct v4l2_subscribed_event_ops v4l2_ctrl_sub_ev_ops;
 void v4l2_ctrl_replace(struct v4l2_event *old, const struct v4l2_event *new);
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index e59a5e3..7f2b548 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1471,6 +1471,7 @@ struct v4l2_querymenu {
 #define V4L2_CTRL_FLAG_VOLATILE		0x0080
 #define V4L2_CTRL_FLAG_HAS_PAYLOAD	0x0100
 #define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE	0x0200
+#define V4L2_CTRL_FLAG_REQ_APPLIED	0x0400
 
 /*  Query flags, to be ORed with the control ID */
 #define V4L2_CTRL_FLAG_NEXT_CTRL	0x80000000
-- 
2.1.4

