Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:32811 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752575AbeGDPiJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Jul 2018 11:38:09 -0400
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2-ctrls: add v4l2_ctrl_request_hdl_find/put/ctrl_find
 functions
Message-ID: <3f4dd554-0385-7ca7-4b1d-34144da8ff49@xs4all.nl>
Date: Wed, 4 Jul 2018 17:38:07 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
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
Paul, please test this. This should be what you need.

Regards,

	Hans
---
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 3ff17c87b3c8..03fd140736fd 100644
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
+	return (ref && ref->req == ref) ? ref : NULL;
+}
+EXPORT_SYMBOL_GPL(v4l2_ctrl_request_hdl_ctrl_find);
+
 static int v4l2_ctrl_request_bind(struct media_request *req,
 			   struct v4l2_ctrl_handler *hdl,
 			   struct v4l2_ctrl_handler *from)
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index de70cc3a1b80..34ee3167d7dd 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -1111,7 +1111,49 @@ void v4l2_ctrl_request_setup(struct media_request *req,
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
