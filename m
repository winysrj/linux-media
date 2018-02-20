Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:45898 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751312AbeBTEox (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 23:44:53 -0500
Received: by mail-pl0-f68.google.com with SMTP id p5so6831826plo.12
        for <linux-media@vger.kernel.org>; Mon, 19 Feb 2018 20:44:53 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Gustavo Padovan <gustavo.padovan@collabora.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [RFCv4 04/21] v4l2-ctrls: add core request API
Date: Tue, 20 Feb 2018 13:44:08 +0900
Message-Id: <20180220044425.169493-5-acourbot@chromium.org>
In-Reply-To: <20180220044425.169493-1-acourbot@chromium.org>
References: <20180220044425.169493-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add the four core request functions:

v4l2_ctrl_request_init() initializes a new (empty) request.
v4l2_ctrl_request_clone() resets a request based on another request
(or clears it if that request is NULL).
v4l2_ctrl_request_get(): increase refcount
v4l2_ctrl_request_put(): decrease refcount and delete if it reaches 0.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
[acourbot@chromium.org: turn v4l2_ctrl_request_alloc into init function]
Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 106 ++++++++++++++++++++++++++-
 include/media/v4l2-ctrls.h           |   7 ++
 2 files changed, 110 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index eac70598635d..784879816c24 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1878,6 +1878,7 @@ EXPORT_SYMBOL(v4l2_ctrl_find);
 /* Allocate a new v4l2_ctrl_ref and hook it into the handler. */
 static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
 			   struct v4l2_ctrl *ctrl,
+			   struct v4l2_ctrl_ref **ctrl_ref,
 			   bool from_other_dev)
 {
 	struct v4l2_ctrl_ref *ref;
@@ -1885,6 +1886,10 @@ static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
 	u32 id = ctrl->id;
 	u32 class_ctrl = V4L2_CTRL_ID2WHICH(id) | 1;
 	int bucket = id % hdl->nr_of_buckets;	/* which bucket to use */
+	unsigned int sz_extra = 0;
+
+	if (ctrl_ref)
+		*ctrl_ref = NULL;
 
 	/*
 	 * Automatically add the control class if it is not yet present and
@@ -1898,11 +1903,16 @@ static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
 	if (hdl->error)
 		return hdl->error;
 
-	new_ref = kzalloc(sizeof(*new_ref), GFP_KERNEL);
+	if (hdl->is_request)
+		sz_extra = ctrl->elems * ctrl->elem_size;
+	new_ref = kzalloc(sizeof(*new_ref) + sz_extra, GFP_KERNEL);
 	if (!new_ref)
 		return handler_set_err(hdl, -ENOMEM);
 	new_ref->ctrl = ctrl;
 	new_ref->from_other_dev = from_other_dev;
+	if (sz_extra)
+		new_ref->p_req.p = &new_ref[1];
+
 	if (ctrl->handler == hdl) {
 		/* By default each control starts in a cluster of its own.
 		   new_ref->ctrl is basically a cluster array with one
@@ -1942,6 +1952,8 @@ static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
 	/* Insert the control node in the hash */
 	new_ref->next = hdl->buckets[bucket];
 	hdl->buckets[bucket] = new_ref;
+	if (ctrl_ref)
+		*ctrl_ref = new_ref;
 
 unlock:
 	mutex_unlock(hdl->lock);
@@ -2083,7 +2095,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 		ctrl->type_ops->init(ctrl, idx, ctrl->p_new);
 	}
 
-	if (handler_new_ref(hdl, ctrl, false)) {
+	if (handler_new_ref(hdl, ctrl, NULL, false)) {
 		kvfree(ctrl);
 		return NULL;
 	}
@@ -2276,7 +2288,7 @@ int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
 		/* Filter any unwanted controls */
 		if (filter && !filter(ctrl))
 			continue;
-		ret = handler_new_ref(hdl, ctrl, from_other_dev);
+		ret = handler_new_ref(hdl, ctrl, NULL, from_other_dev);
 		if (ret)
 			break;
 	}
@@ -2685,6 +2697,94 @@ int v4l2_querymenu(struct v4l2_ctrl_handler *hdl, struct v4l2_querymenu *qm)
 }
 EXPORT_SYMBOL(v4l2_querymenu);
 
+int v4l2_ctrl_request_init(struct v4l2_ctrl_handler *hdl)
+{
+	int err;
+
+	err = v4l2_ctrl_handler_init(hdl, 0);
+	if (err)
+		return err;
+	hdl->is_request = true;
+	kref_init(&hdl->ref);
+
+	return 0;
+}
+EXPORT_SYMBOL(v4l2_ctrl_request_init);
+
+int v4l2_ctrl_request_clone(struct v4l2_ctrl_handler *hdl,
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
+	hdl->is_request = true;
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
+		if (from->is_request)
+			ptr_to_ptr(ctrl, ref->p_req, new_ref->p_req);
+		else
+			ptr_to_ptr(ctrl, ctrl->p_cur, new_ref->p_req);
+	}
+	mutex_unlock(from->lock);
+	return err;
+}
+EXPORT_SYMBOL(v4l2_ctrl_request_clone);
+
+void v4l2_ctrl_request_get(struct v4l2_ctrl_handler *hdl)
+{
+	if (WARN_ON(!hdl->is_request))
+		return;
+	kref_get(&hdl->ref);
+}
+EXPORT_SYMBOL(v4l2_ctrl_request_get);
+
+static void v4l2_ctrl_request_release(struct kref *kref)
+{
+	struct v4l2_ctrl_handler *hdl =
+		container_of(kref, struct v4l2_ctrl_handler, ref);
+
+	v4l2_ctrl_handler_free(hdl);
+	kfree(hdl);
+}
+
+void v4l2_ctrl_request_put(struct v4l2_ctrl_handler *hdl)
+{
+	if (WARN_ON(!hdl->is_request))
+		return;
+	kref_put(&hdl->ref, v4l2_ctrl_request_release);
+}
+EXPORT_SYMBOL(v4l2_ctrl_request_put);
 
 /* Some general notes on the atomic requirements of VIDIOC_G/TRY/S_EXT_CTRLS:
 
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index bcabbf8a44b5..c51e1cacc09d 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -1052,6 +1052,13 @@ int v4l2_ctrl_subscribe_event(struct v4l2_fh *fh,
  */
 __poll_t v4l2_ctrl_poll(struct file *file, struct poll_table_struct *wait);
 
+int v4l2_ctrl_request_init(struct v4l2_ctrl_handler *hdl);
+int v4l2_ctrl_request_clone(struct v4l2_ctrl_handler *hdl,
+			    const struct v4l2_ctrl_handler *from,
+			    bool (*filter)(const struct v4l2_ctrl *ctrl));
+void v4l2_ctrl_request_get(struct v4l2_ctrl_handler *hdl);
+void v4l2_ctrl_request_put(struct v4l2_ctrl_handler *hdl);
+
 /* Helpers for ioctl_ops */
 
 /**
-- 
2.16.1.291.g4437f3f132-goog
