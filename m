Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:56318 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752083AbdKMOeL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Nov 2017 09:34:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 6/6] v4l2-ctrls: add v4l2_ctrl_request_setup
Date: Mon, 13 Nov 2017 15:34:08 +0100
Message-Id: <20171113143408.19644-7-hverkuil@xs4all.nl>
In-Reply-To: <20171113143408.19644-1-hverkuil@xs4all.nl>
References: <20171113143408.19644-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a helper function that can set controls from a request.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 71 ++++++++++++++++++++++++++++++++++++
 include/media/v4l2-ctrls.h           |  2 +
 2 files changed, 73 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 36b00ad2d5cb..5513061b033d 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1662,6 +1662,14 @@ static void new_to_req(struct v4l2_ctrl_ref *ref)
 	ptr_to_ptr(ref->ctrl, ref->ctrl->p_new, ref->p_req);
 }
 
+/* Copy the request value to the new value */
+static void req_to_new(struct v4l2_ctrl_ref *ref)
+{
+	if (!ref)
+		return;
+	ptr_to_ptr(ref->ctrl, ref->p_req, ref->ctrl->p_new);
+}
+
 /* Return non-zero if one or more of the controls in the cluster has a new
    value that differs from the current value. */
 static int cluster_changed(struct v4l2_ctrl *master)
@@ -3431,6 +3439,69 @@ int __v4l2_ctrl_s_ctrl_string(struct v4l2_ctrl *ctrl, const char *s)
 }
 EXPORT_SYMBOL(__v4l2_ctrl_s_ctrl_string);
 
+void v4l2_ctrl_request_setup(struct v4l2_ctrl_handler *hdl)
+{
+	struct v4l2_ctrl_ref *ref;
+
+	if (!hdl)
+		return;
+
+	mutex_lock(hdl->lock);
+
+	list_for_each_entry(ref, &hdl->ctrl_refs, node)
+		ref->done = false;
+
+	list_for_each_entry(ref, &hdl->ctrl_refs, node) {
+		struct v4l2_ctrl *ctrl = ref->ctrl;
+		struct v4l2_ctrl *master = ctrl->cluster[0];
+		int i;
+
+		/* Skip if this control was already handled by a cluster. */
+		/* Skip button controls and read-only controls. */
+		if (ref->done || ctrl->type == V4L2_CTRL_TYPE_BUTTON ||
+		    (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY))
+			continue;
+
+		v4l2_ctrl_lock(master);
+		for (i = 0; i < master->ncontrols; i++) {
+			if (master->cluster[i]) {
+				struct v4l2_ctrl_ref *r =
+					find_ref(hdl, master->cluster[i]->id);
+
+				req_to_new(r);
+				master->cluster[i]->is_new = 1;
+				r->done = true;
+			}
+		}
+		/*
+		 * For volatile autoclusters that are currently in auto mode
+		 * we need to discover if it will be set to manual mode.
+		 * If so, then we have to copy the current volatile values
+		 * first since those will become the new manual values (which
+		 * may be overwritten by explicit new values from this set
+		 * of controls).
+		 */
+		if (master->is_auto && master->has_volatiles &&
+		    !is_cur_manual(master)) {
+			s32 new_auto_val = *master->p_new.p_s32;
+
+			/*
+			 * If the new value == the manual value, then copy
+			 * the current volatile values.
+			 */
+			if (new_auto_val == master->manual_mode_value)
+				update_from_auto_cluster(master);
+		}
+
+		try_or_set_cluster(NULL, master, true, 0);
+
+		v4l2_ctrl_unlock(master);
+	}
+
+	mutex_unlock(hdl->lock);
+}
+EXPORT_SYMBOL(v4l2_ctrl_request_setup);
+
 void v4l2_ctrl_notify(struct v4l2_ctrl *ctrl, v4l2_ctrl_notify_fnc notify, void *priv)
 {
 	if (ctrl == NULL)
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index f86d680880e1..2770bff1d6bd 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -252,6 +252,7 @@ struct v4l2_ctrl_ref {
 	struct v4l2_ctrl *ctrl;
 	struct v4l2_ctrl_helper *helper;
 	union v4l2_ctrl_ptr p_req;
+	bool done;
 	bool from_other_dev;
 };
 
@@ -1049,6 +1050,7 @@ struct v4l2_ctrl_handler *v4l2_ctrl_request_alloc(void);
 int v4l2_ctrl_request_clone(struct v4l2_ctrl_handler *hdl,
 			    const struct v4l2_ctrl_handler *from,
 			    bool (*filter)(const struct v4l2_ctrl *ctrl));
+void v4l2_ctrl_request_setup(struct v4l2_ctrl_handler *hdl);
 void v4l2_ctrl_request_get(struct v4l2_ctrl_handler *hdl);
 void v4l2_ctrl_request_put(struct v4l2_ctrl_handler *hdl);
 
-- 
2.14.1
