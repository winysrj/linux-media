Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:33619 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732807AbeHNRIN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 13:08:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv18 16/35] v4l2-ctrls: add v4l2_ctrl_request_hdl_find/put/ctrl_find functions
Date: Tue, 14 Aug 2018 16:20:28 +0200
Message-Id: <20180814142047.93856-17-hverkuil@xs4all.nl>
In-Reply-To: <20180814142047.93856-1-hverkuil@xs4all.nl>
References: <20180814142047.93856-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If a driver needs to find/inspect the controls set in a request then
it can use these functions.

E.g. to check if a required control is set in a request use this in the
req_validate() implementation:

	int res = -EINVAL;

	hdl = v4l2_ctrl_request_hdl_find(req, parent_hdl);
	if (hdl) {
		if (v4l2_ctrl_request_hdl_ctrl_find(hdl, ctrl_id))
			res = 0;
		v4l2_ctrl_request_hdl_put(hdl);
	}
	return res;

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 25 ++++++++++++++
 include/media/v4l2-ctrls.h           | 49 +++++++++++++++++++++++++++-
 2 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 6d34d7a6f235..a197b60183f5 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2976,6 +2976,31 @@ static const struct media_request_object_ops req_ops = {
 	.release = v4l2_ctrl_request_release,
 };
 
+struct v4l2_ctrl_handler *v4l2_ctrl_request_hdl_find(struct media_request *req,
+					struct v4l2_ctrl_handler *parent)
+{
+	struct media_request_object *obj;
+
+	if (WARN_ON(req->state != MEDIA_REQUEST_STATE_VALIDATING &&
+		    req->state != MEDIA_REQUEST_STATE_QUEUED))
+		return NULL;
+
+	obj = media_request_object_find(req, &req_ops, parent);
+	if (obj)
+		return container_of(obj, struct v4l2_ctrl_handler, req_obj);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(v4l2_ctrl_request_hdl_find);
+
+struct v4l2_ctrl *
+v4l2_ctrl_request_hdl_ctrl_find(struct v4l2_ctrl_handler *hdl, u32 id)
+{
+	struct v4l2_ctrl_ref *ref = find_ref_lock(hdl, id);
+
+	return (ref && ref->req == ref) ? ref->ctrl : NULL;
+}
+EXPORT_SYMBOL_GPL(v4l2_ctrl_request_hdl_ctrl_find);
+
 static int v4l2_ctrl_request_bind(struct media_request *req,
 			   struct v4l2_ctrl_handler *hdl,
 			   struct v4l2_ctrl_handler *from)
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index f4156544150b..53ca4df0c353 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -1111,7 +1111,54 @@ void v4l2_ctrl_request_setup(struct media_request *req,
  * request object.
  */
 void v4l2_ctrl_request_complete(struct media_request *req,
-				struct v4l2_ctrl_handler *hdl);
+				struct v4l2_ctrl_handler *parent);
+
+/**
+ * v4l2_ctrl_request_hdl_find - Find the control handler in the request
+ *
+ * @req: The request
+ * @parent: The parent control handler ('priv' in media_request_object_find())
+ *
+ * This function finds the control handler in the request. It may return
+ * NULL if not found. When done, you must call v4l2_ctrl_request_put_hdl()
+ * with the returned handler pointer.
+ *
+ * If the request is not in state VALIDATING or QUEUED, then this function
+ * will always return NULL.
+ *
+ * Note that in state VALIDATING the req_queue_mutex is held, so
+ * no objects can be added or deleted from the request.
+ *
+ * In state QUEUED it is the driver that will have to ensure this.
+ */
+struct v4l2_ctrl_handler *v4l2_ctrl_request_hdl_find(struct media_request *req,
+					struct v4l2_ctrl_handler *parent);
+
+/**
+ * v4l2_ctrl_request_hdl_put - Put the control handler
+ *
+ * @hdl: Put this control handler
+ *
+ * This function released the control handler previously obtained from'
+ * v4l2_ctrl_request_hdl_find().
+ */
+static inline void v4l2_ctrl_request_hdl_put(struct v4l2_ctrl_handler *hdl)
+{
+	if (hdl)
+		media_request_object_put(&hdl->req_obj);
+}
+
+/**
+ * v4l2_ctrl_request_ctrl_find() - Find a control with the given ID.
+ *
+ * @hdl: The control handler from the request.
+ * @id: The ID of the control to find.
+ *
+ * This function returns a pointer to the control if this control is
+ * part of the request or NULL otherwise.
+ */
+struct v4l2_ctrl *
+v4l2_ctrl_request_hdl_ctrl_find(struct v4l2_ctrl_handler *hdl, u32 id);
 
 /* Helpers for ioctl_ops */
 
-- 
2.18.0
