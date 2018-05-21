Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:28374 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752687AbeEUIzS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 04:55:18 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH v14 18/36] v4l2-ctrls: Lock the request for updating during S_EXT_CTRLS
Date: Mon, 21 May 2018 11:54:43 +0300
Message-Id: <20180521085501.16861-19-sakari.ailus@linux.intel.com>
In-Reply-To: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
References: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of checking the media request state is idle at one point, lock the
request for updating during the S_EXT_CTRLS call. As a by-product, finding
the request has been moved out of the v4l2_ctrls_find_req_obj() in order
to keep request object lookups to the minimum.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 67 +++++++++++++++++++++---------------
 1 file changed, 40 insertions(+), 27 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index df58a23eb731a..1a99d6e238791 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -3208,9 +3208,8 @@ int __v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 
 static struct media_request_object *
 v4l2_ctrls_find_req_obj(struct v4l2_ctrl_handler *hdl,
-			struct media_device *mdev, s32 fd, bool set)
+			struct media_request *req, bool set)
 {
-	struct media_request *req = media_request_get_by_fd(mdev, fd);
 	struct media_request_object *obj;
 	struct v4l2_ctrl_handler *new_hdl;
 	int ret;
@@ -3218,36 +3217,29 @@ v4l2_ctrls_find_req_obj(struct v4l2_ctrl_handler *hdl,
 	if (IS_ERR(req))
 		return ERR_CAST(req);
 
-	if (set && atomic_read(&req->state) != MEDIA_REQUEST_STATE_IDLE) {
-		media_request_put(req);
+	if (set && WARN_ON(req->state != MEDIA_REQUEST_STATE_UPDATING))
 		return ERR_PTR(-EBUSY);
-	}
 
 	obj = media_request_object_find(req, &req_ops, hdl);
-	if (obj) {
-		media_request_put(req);
+	if (obj)
 		return obj;
-	}
 
 	new_hdl = kzalloc(sizeof(*new_hdl), GFP_KERNEL);
-	if (!new_hdl) {
-		ret = -ENOMEM;
-		goto put;
-	}
+	if (!new_hdl)
+		return ERR_PTR(-ENOMEM);
+
 	obj = &new_hdl->req_obj;
 	ret = v4l2_ctrl_handler_init(new_hdl, (hdl->nr_of_buckets - 1) * 8);
 	if (!ret)
 		ret = v4l2_ctrl_request_bind(req, new_hdl, hdl);
-	if (!ret) {
-		media_request_object_get(obj);
-		media_request_put(req);
-		return obj;
+	if (ret) {
+		kfree(new_hdl);
+
+		return ERR_PTR(ret);
 	}
-	kfree(new_hdl);
 
-put:
-	media_request_put(req);
-	return ERR_PTR(ret);
+	media_request_object_get(obj);
+	return obj;
 }
 
 int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct media_device *mdev,
@@ -3257,11 +3249,21 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct media_device *mdev,
 	int ret;
 
 	if (cs->which == V4L2_CTRL_WHICH_REQUEST_VAL) {
+		struct media_request *req;
+
 		if (!mdev || cs->request_fd < 0)
 			return -EINVAL;
-		obj = v4l2_ctrls_find_req_obj(hdl, mdev, cs->request_fd, false);
+
+		req = media_request_get_by_fd(mdev, cs->request_fd);
+		if (!req)
+			return -ENOENT;
+
+		obj = v4l2_ctrls_find_req_obj(hdl, req, false);
+		/* Reference to the request held through obj */
+		media_request_put(req);
 		if (IS_ERR(obj))
 			return PTR_ERR(obj);
+
 		hdl = container_of(obj, struct v4l2_ctrl_handler,
 				   req_obj);
 	}
@@ -3567,18 +3569,28 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh,
 			     struct v4l2_ext_controls *cs, bool set)
 {
 	struct media_request_object *obj = NULL;
+	struct media_request *req = NULL;
 	int ret;
 
 	if (cs->which == V4L2_CTRL_WHICH_REQUEST_VAL) {
 		if (!mdev || cs->request_fd < 0)
 			return -EINVAL;
-		obj = v4l2_ctrls_find_req_obj(hdl, mdev, cs->request_fd, true);
+
+		req = media_request_get_by_fd(mdev, cs->request_fd);
+		if (!req)
+			return -ENOENT;
+
+		ret = media_request_lock_for_update(req);
+		if (req) {
+			media_request_put(req);
+			return ret;
+		}
+
+		obj = v4l2_ctrls_find_req_obj(hdl, req, true);
+		/* Reference to the request held through obj */
+		media_request_object_put(obj);
 		if (IS_ERR(obj))
 			return PTR_ERR(obj);
-		if (atomic_read(&obj->req->state) != MEDIA_REQUEST_STATE_IDLE) {
-			media_request_object_put(obj);
-			return -EBUSY;
-		}
 		hdl = container_of(obj, struct v4l2_ctrl_handler,
 				   req_obj);
 	}
@@ -3586,7 +3598,8 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh,
 	ret = __try_set_ext_ctrls(fh, hdl, cs, set);
 
 	if (obj)
-		media_request_object_put(obj);
+		media_request_unlock_for_update(obj->req);
+
 	return ret;
 }
 
-- 
2.11.0
