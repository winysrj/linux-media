Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:41585 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753780AbeAaK0f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Jan 2018 05:26:35 -0500
Received: by mail-pg0-f66.google.com with SMTP id 136so9678010pgd.8
        for <linux-media@vger.kernel.org>; Wed, 31 Jan 2018 02:26:35 -0800 (PST)
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
Subject: [RFCv2 11/17] v4l2-ctrls: add v4l2_ctrl_request_setup
Date: Wed, 31 Jan 2018 19:26:19 +0900
Message-Id: <20180131102625.208021-2-acourbot@chromium.org>
In-Reply-To: <20180131102625.208021-1-acourbot@chromium.org>
References: <20180131102625.208021-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a helper function that can set controls from a request.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 71 ++++++++++++++++++++++++++++++++++++
 include/media/v4l2-ctrls.h           |  2 +
 2 files changed, 73 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index e4d29cc76ca8..da3db6268e9c 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1652,6 +1652,14 @@ static void new_to_req(struct v4l2_ctrl_ref *ref)
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
@@ -3423,6 +3431,69 @@ int __v4l2_ctrl_s_ctrl_string(struct v4l2_ctrl *ctrl, const char *s)
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
index 24a60ca1a0dd..9cc9c242ed9d 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -252,6 +252,7 @@ struct v4l2_ctrl_ref {
 	struct v4l2_ctrl *ctrl;
 	struct v4l2_ctrl_helper *helper;
 	union v4l2_ctrl_ptr p_req;
+	bool done;
 	bool from_other_dev;
 };
 
@@ -1049,6 +1050,7 @@ int v4l2_ctrl_request_init(struct v4l2_ctrl_handler *hdl);
 int v4l2_ctrl_request_clone(struct v4l2_ctrl_handler *hdl,
 			    const struct v4l2_ctrl_handler *from,
 			    bool (*filter)(const struct v4l2_ctrl *ctrl));
+void v4l2_ctrl_request_setup(struct v4l2_ctrl_handler *hdl);
 void v4l2_ctrl_request_get(struct v4l2_ctrl_handler *hdl);
 void v4l2_ctrl_request_put(struct v4l2_ctrl_handler *hdl);
 
-- 
2.16.0.rc1.238.g530d649a79-goog
