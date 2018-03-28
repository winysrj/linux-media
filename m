Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:33891 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753313AbeC1Num (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 09:50:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@google.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv9 PATCH 13/29] v4l2-ctrls: add core request API
Date: Wed, 28 Mar 2018 15:50:14 +0200
Message-Id: <20180328135030.7116-14-hverkuil@xs4all.nl>
In-Reply-To: <20180328135030.7116-1-hverkuil@xs4all.nl>
References: <20180328135030.7116-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add the two core request functions:

v4l2_ctrl_request_setup() applies the contents of the request
to the current driver state.

v4l2_ctrl_request_complete() marks the request complete. After
this the contents is fixed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 172 +++++++++++++++++++++++++++++++++++
 include/media/v4l2-ctrls.h           |   9 ++
 2 files changed, 181 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 80714c5bad8b..62f91c0f1e5f 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1781,6 +1781,14 @@ static void new_to_req(struct v4l2_ctrl_ref *ref)
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
@@ -2831,6 +2839,78 @@ int v4l2_querymenu(struct v4l2_ctrl_handler *hdl, struct v4l2_querymenu *qm)
 }
 EXPORT_SYMBOL(v4l2_querymenu);
 
+static int v4l2_ctrl_request_clone(struct v4l2_ctrl_handler *hdl,
+			    const struct v4l2_ctrl_handler *from,
+			    bool (*filter)(const struct v4l2_ctrl *ctrl))
+{
+	struct v4l2_ctrl_ref *ref;
+	int err;
+
+	if (WARN_ON(!hdl || hdl == from))
+		return -EINVAL;
+
+	if (hdl->error)
+		return hdl->error;
+
+	WARN_ON(hdl->lock != &hdl->_lock);
+	v4l2_ctrl_handler_free(hdl);
+	err = v4l2_ctrl_handler_init(hdl, (from->nr_of_buckets - 1) * 8);
+	if (err)
+		return err;
+	if (!from)
+		return 0;
+
+	mutex_lock(from->lock);
+	list_for_each_entry(ref, &from->ctrl_refs, node) {
+		struct v4l2_ctrl *ctrl = ref->ctrl;
+		struct v4l2_ctrl_ref *new_ref;
+
+		/* Skip refs inherited from other devices */
+		if (ref->from_other_dev)
+			continue;
+		/* And buttons and control classes */
+		if (ctrl->type == V4L2_CTRL_TYPE_BUTTON ||
+		    ctrl->type == V4L2_CTRL_TYPE_CTRL_CLASS)
+			continue;
+		/* Filter any unwanted controls */
+		if (filter && !filter(ctrl))
+			continue;
+		err = handler_new_ref(hdl, ctrl, &new_ref, false);
+		if (err)
+			break;
+		if (from->req_obj.req)
+			ptr_to_ptr(ctrl, ref->p_req, new_ref->p_req);
+		else
+			ptr_to_ptr(ctrl, ctrl->p_cur, new_ref->p_req);
+	}
+	mutex_unlock(from->lock);
+	return err;
+}
+
+static void v4l2_ctrl_request_release(struct media_request_object *obj)
+{
+	struct v4l2_ctrl_handler *hdl =
+		container_of(obj, struct v4l2_ctrl_handler, req_obj);
+
+	v4l2_ctrl_handler_free(hdl);
+	kfree(hdl);
+}
+
+static const struct media_request_object_ops req_ops = {
+	.release = v4l2_ctrl_request_release,
+};
+
+static int v4l2_ctrl_request_bind(struct media_request *req,
+			   struct v4l2_ctrl_handler *hdl,
+			   struct v4l2_ctrl_handler *from,
+			   bool (*filter)(const struct v4l2_ctrl *ctrl))
+{
+	int ret = v4l2_ctrl_request_clone(hdl, from, filter);
+
+	if (!ret)
+		media_request_object_bind(req, &req_ops, from, &hdl->req_obj);
+	return ret;
+}
 
 /* Some general notes on the atomic requirements of VIDIOC_G/TRY/S_EXT_CTRLS:
 
@@ -3458,6 +3538,98 @@ int __v4l2_ctrl_s_ctrl_string(struct v4l2_ctrl *ctrl, const char *s)
 }
 EXPORT_SYMBOL(__v4l2_ctrl_s_ctrl_string);
 
+void v4l2_ctrl_request_complete(struct media_request *req,
+				struct v4l2_ctrl_handler *hdl)
+{
+	struct media_request_object *obj;
+
+	if (!req || !hdl)
+		return;
+
+	obj = media_request_object_find(req, &req_ops, hdl);
+	if (!obj)
+		return;
+
+	media_request_object_complete(obj);
+	media_request_object_put(obj);
+}
+EXPORT_SYMBOL(v4l2_ctrl_request_complete);
+
+void v4l2_ctrl_request_setup(struct media_request *req,
+			     struct v4l2_ctrl_handler *hdl)
+{
+	struct media_request_object *obj;
+	struct v4l2_ctrl_ref *ref;
+
+	if (!req || !hdl)
+		return;
+
+	obj = media_request_object_find(req, &req_ops, hdl);
+	if (!obj)
+		return;
+	if (obj->completed) {
+		media_request_object_put(obj);
+		return;
+	}
+	hdl = container_of(obj, struct v4l2_ctrl_handler, req_obj);
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
+	media_request_object_put(obj);
+}
+EXPORT_SYMBOL(v4l2_ctrl_request_setup);
+
 void v4l2_ctrl_notify(struct v4l2_ctrl *ctrl, v4l2_ctrl_notify_fnc notify, void *priv)
 {
 	if (ctrl == NULL)
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 89a985607126..378d4f05c160 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -250,6 +250,9 @@ struct v4l2_ctrl {
  *		``prepare_ext_ctrls`` function at ``v4l2-ctrl.c``.
  * @from_other_dev: If true, then @ctrl was defined in another
  *		device then the &struct v4l2_ctrl_handler.
+ * @done:	If true, then this control reference is part of a
+ *		control cluster that was already set while applying
+ *		the controls in this media request object.
  * @p_req:	The request value. Only used if the control handler
  *		is bound to a media request.
  *
@@ -263,6 +266,7 @@ struct v4l2_ctrl_ref {
 	struct v4l2_ctrl *ctrl;
 	struct v4l2_ctrl_helper *helper;
 	bool from_other_dev;
+	bool done;
 	union v4l2_ctrl_ptr p_req;
 };
 
@@ -1059,6 +1063,11 @@ int v4l2_ctrl_subscribe_event(struct v4l2_fh *fh,
  */
 __poll_t v4l2_ctrl_poll(struct file *file, struct poll_table_struct *wait);
 
+void v4l2_ctrl_request_setup(struct media_request *req,
+			     struct v4l2_ctrl_handler *hdl);
+void v4l2_ctrl_request_complete(struct media_request *req,
+				struct v4l2_ctrl_handler *hdl);
+
 /* Helpers for ioctl_ops */
 
 /**
-- 
2.16.1
