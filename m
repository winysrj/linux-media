Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:34561 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753334AbeC1Num (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 09:50:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@google.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv9 PATCH 16/29] v4l2-ctrls: integrate with requests
Date: Wed, 28 Mar 2018 15:50:17 +0200
Message-Id: <20180328135030.7116-17-hverkuil@xs4all.nl>
In-Reply-To: <20180328135030.7116-1-hverkuil@xs4all.nl>
References: <20180328135030.7116-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add the media_device pointer to the v4l2_g/s/try_ext_ctrls
functions and pass that in from the v4l2 core. The control
framework will look up the request from the request_fd file
descriptor and bind/unbind the request objects.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/omap3isp/ispvideo.c |   2 +-
 drivers/media/v4l2-core/v4l2-ctrls.c       | 136 ++++++++++++++++++++++++++---
 drivers/media/v4l2-core/v4l2-ioctl.c       |  12 +--
 drivers/media/v4l2-core/v4l2-subdev.c      |   9 +-
 include/media/v4l2-ctrls.h                 |  13 ++-
 5 files changed, 148 insertions(+), 24 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index a751c89a3ea8..bd564c2e767f 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -1028,7 +1028,7 @@ static int isp_video_check_external_subdevs(struct isp_video *video,
 	ctrls.count = 1;
 	ctrls.controls = &ctrl;
 
-	ret = v4l2_g_ext_ctrls(pipe->external->ctrl_handler, &ctrls);
+	ret = v4l2_g_ext_ctrls(pipe->external->ctrl_handler, NULL, &ctrls);
 	if (ret < 0) {
 		dev_warn(isp->dev, "no pixel rate control in subdev %s\n",
 			 pipe->external->name);
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 6cf6b2154462..e31bce0207b4 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1898,6 +1898,7 @@ int v4l2_ctrl_handler_init_class(struct v4l2_ctrl_handler *hdl,
 	lockdep_set_class_and_name(hdl->lock, key, name);
 	INIT_LIST_HEAD(&hdl->ctrls);
 	INIT_LIST_HEAD(&hdl->ctrl_refs);
+	INIT_LIST_HEAD(&hdl->requests);
 	hdl->nr_of_buckets = 1 + nr_of_controls_hint / 8;
 	hdl->buckets = kvmalloc_array(hdl->nr_of_buckets,
 				      sizeof(hdl->buckets[0]),
@@ -1918,6 +1919,14 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
 	if (hdl == NULL || hdl->buckets == NULL)
 		return;
 
+	if (!hdl->req_obj.req && !list_empty(&hdl->requests)) {
+		struct v4l2_ctrl_handler *req, *next_req;
+
+		list_for_each_entry_safe(req, next_req, &hdl->requests, requests) {
+			media_request_object_unbind(&req->req_obj);
+			media_request_object_put(&req->req_obj);
+		}
+	}
 	mutex_lock(hdl->lock);
 	/* Free all nodes */
 	list_for_each_entry_safe(ref, next_ref, &hdl->ctrl_refs, node) {
@@ -2844,6 +2853,7 @@ static int v4l2_ctrl_request_clone(struct v4l2_ctrl_handler *hdl,
 			    bool (*filter)(const struct v4l2_ctrl *ctrl))
 {
 	struct v4l2_ctrl_ref *ref;
+	struct media_request *req = hdl->req_obj.req;
 	int err;
 
 	if (WARN_ON(!hdl || hdl == from))
@@ -2857,6 +2867,7 @@ static int v4l2_ctrl_request_clone(struct v4l2_ctrl_handler *hdl,
 	err = v4l2_ctrl_handler_init(hdl, (from->nr_of_buckets - 1) * 8);
 	if (err)
 		return err;
+	hdl->req_obj.req = req;
 	if (!from)
 		return 0;
 
@@ -2892,6 +2903,14 @@ static int v4l2_ctrl_request_clone(struct v4l2_ctrl_handler *hdl,
 	return err;
 }
 
+static void v4l2_ctrl_request_unbind(struct media_request_object *obj)
+{
+	struct v4l2_ctrl_handler *hdl =
+		container_of(obj, struct v4l2_ctrl_handler, req_obj);
+
+	list_del_init(&hdl->requests);
+}
+
 static void v4l2_ctrl_request_release(struct media_request_object *obj)
 {
 	struct v4l2_ctrl_handler *hdl =
@@ -2902,6 +2921,7 @@ static void v4l2_ctrl_request_release(struct media_request_object *obj)
 }
 
 static const struct media_request_object_ops req_ops = {
+	.unbind = v4l2_ctrl_request_unbind,
 	.release = v4l2_ctrl_request_release,
 };
 
@@ -2910,10 +2930,16 @@ static int v4l2_ctrl_request_bind(struct media_request *req,
 			   struct v4l2_ctrl_handler *from,
 			   bool (*filter)(const struct v4l2_ctrl *ctrl))
 {
-	int ret = v4l2_ctrl_request_clone(hdl, from, filter);
+	int ret;
 
-	if (!ret)
+	hdl->req_obj.req = req;
+	ret = v4l2_ctrl_request_clone(hdl, from, filter);
+	hdl->req_obj.req = NULL;
+
+	if (!ret) {
+		list_add_tail(&hdl->requests, &from->requests);
 		media_request_object_bind(req, &req_ops, from, &hdl->req_obj);
+	}
 	return ret;
 }
 
@@ -2977,6 +3003,7 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 
 		if (cs->which &&
 		    cs->which != V4L2_CTRL_WHICH_DEF_VAL &&
+		    cs->which != V4L2_CTRL_WHICH_REQUEST &&
 		    V4L2_CTRL_ID2WHICH(id) != cs->which)
 			return -EINVAL;
 
@@ -3056,15 +3083,15 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
    whether there are any controls at all. */
 static int class_check(struct v4l2_ctrl_handler *hdl, u32 which)
 {
-	if (which == 0 || which == V4L2_CTRL_WHICH_DEF_VAL)
+	if (which == 0 || which == V4L2_CTRL_WHICH_DEF_VAL ||
+	    which == V4L2_CTRL_WHICH_REQUEST)
 		return 0;
 	return find_ref_lock(hdl, which | 1) ? 0 : -EINVAL;
 }
 
-
-
 /* Get extended controls. Allocates the helpers array if needed. */
-int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs)
+int __v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl,
+		       struct v4l2_ext_controls *cs)
 {
 	struct v4l2_ctrl_helper helper[4];
 	struct v4l2_ctrl_helper *helpers = helper;
@@ -3145,6 +3172,64 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 		kvfree(helpers);
 	return ret;
 }
+
+static struct media_request_object *
+v4l2_ctrls_find_req_obj(struct v4l2_ctrl_handler *hdl,
+			struct media_device *mdev, s32 fd)
+{
+	struct media_request *req = media_request_find(mdev, fd);
+	struct media_request_object *obj;
+	struct v4l2_ctrl_handler *new_hdl;
+	int ret;
+
+	if (IS_ERR(req))
+		return NULL;
+	obj = media_request_object_find(req, &req_ops, hdl);
+	if (obj) {
+		media_request_put(req);
+		return obj;
+	}
+	new_hdl = kzalloc(sizeof(*new_hdl), GFP_KERNEL);
+	if (!new_hdl)
+		goto error;
+	obj = &new_hdl->req_obj;
+	ret = v4l2_ctrl_handler_init(new_hdl, 0);
+	if (!ret)
+		ret = v4l2_ctrl_request_bind(req, new_hdl, hdl, NULL);
+	if (!ret) {
+		media_request_object_get(obj);
+		media_request_put(req);
+		return obj;
+	}
+	kfree(new_hdl);
+
+error:
+	media_request_put(req);
+	return NULL;
+}
+
+int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct media_device *mdev,
+		     struct v4l2_ext_controls *cs)
+{
+	struct media_request_object *obj = NULL;
+	int ret;
+
+	if (cs->which == V4L2_CTRL_WHICH_REQUEST) {
+		if (!mdev || cs->request_fd < 0)
+			return -EINVAL;
+		obj = v4l2_ctrls_find_req_obj(hdl, mdev, cs->request_fd);
+		if (!obj)
+			return -EINVAL;
+		hdl = container_of(obj, struct v4l2_ctrl_handler,
+				   req_obj);
+	}
+
+	ret = __v4l2_g_ext_ctrls(hdl, cs);
+
+	if (obj)
+		media_request_object_put(obj);
+	return ret;
+}
 EXPORT_SYMBOL(v4l2_g_ext_ctrls);
 
 /* Helper function to get a single control */
@@ -3320,9 +3405,9 @@ static void update_from_auto_cluster(struct v4l2_ctrl *master)
 }
 
 /* Try or try-and-set controls */
-static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
-			     struct v4l2_ext_controls *cs,
-			     bool set)
+static int __try_set_ext_ctrls(struct v4l2_fh *fh,
+			       struct v4l2_ctrl_handler *hdl,
+			       struct v4l2_ext_controls *cs, bool set)
 {
 	struct v4l2_ctrl_helper helper[4];
 	struct v4l2_ctrl_helper *helpers = helper;
@@ -3435,16 +3520,41 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 	return ret;
 }
 
-int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs)
+static int try_set_ext_ctrls(struct v4l2_fh *fh,
+			     struct v4l2_ctrl_handler *hdl, struct media_device *mdev,
+			     struct v4l2_ext_controls *cs, bool set)
+{
+	struct media_request_object *obj = NULL;
+	int ret;
+
+	if (cs->which == V4L2_CTRL_WHICH_REQUEST) {
+		if (!mdev || cs->request_fd < 0)
+			return -EINVAL;
+		obj = v4l2_ctrls_find_req_obj(hdl, mdev, cs->request_fd);
+		if (!obj)
+			return -EINVAL;
+		hdl = container_of(obj, struct v4l2_ctrl_handler,
+				   req_obj);
+	}
+
+	ret = __try_set_ext_ctrls(fh, hdl, cs, set);
+
+	if (obj)
+		media_request_object_put(obj);
+	return ret;
+}
+
+int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct media_device *mdev,
+		       struct v4l2_ext_controls *cs)
 {
-	return try_set_ext_ctrls(NULL, hdl, cs, false);
+	return try_set_ext_ctrls(NULL, hdl, mdev, cs, false);
 }
 EXPORT_SYMBOL(v4l2_try_ext_ctrls);
 
 int v4l2_s_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
-					struct v4l2_ext_controls *cs)
+		     struct media_device *mdev, struct v4l2_ext_controls *cs)
 {
-	return try_set_ext_ctrls(fh, hdl, cs, true);
+	return try_set_ext_ctrls(fh, hdl, mdev, cs, true);
 }
 EXPORT_SYMBOL(v4l2_s_ext_ctrls);
 
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 2c623da33155..ceeb6df0ef19 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2079,9 +2079,9 @@ static int v4l_g_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 
 	p->error_idx = p->count;
 	if (vfh && vfh->ctrl_handler)
-		return v4l2_g_ext_ctrls(vfh->ctrl_handler, p);
+		return v4l2_g_ext_ctrls(vfh->ctrl_handler, vfd->v4l2_dev->mdev, p);
 	if (vfd->ctrl_handler)
-		return v4l2_g_ext_ctrls(vfd->ctrl_handler, p);
+		return v4l2_g_ext_ctrls(vfd->ctrl_handler, vfd->v4l2_dev->mdev, p);
 	if (ops->vidioc_g_ext_ctrls == NULL)
 		return -ENOTTY;
 	return check_ext_ctrls(p, 0) ? ops->vidioc_g_ext_ctrls(file, fh, p) :
@@ -2098,9 +2098,9 @@ static int v4l_s_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 
 	p->error_idx = p->count;
 	if (vfh && vfh->ctrl_handler)
-		return v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, p);
+		return v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, vfd->v4l2_dev->mdev, p);
 	if (vfd->ctrl_handler)
-		return v4l2_s_ext_ctrls(NULL, vfd->ctrl_handler, p);
+		return v4l2_s_ext_ctrls(NULL, vfd->ctrl_handler, vfd->v4l2_dev->mdev, p);
 	if (ops->vidioc_s_ext_ctrls == NULL)
 		return -ENOTTY;
 	return check_ext_ctrls(p, 0) ? ops->vidioc_s_ext_ctrls(file, fh, p) :
@@ -2117,9 +2117,9 @@ static int v4l_try_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 
 	p->error_idx = p->count;
 	if (vfh && vfh->ctrl_handler)
-		return v4l2_try_ext_ctrls(vfh->ctrl_handler, p);
+		return v4l2_try_ext_ctrls(vfh->ctrl_handler, vfd->v4l2_dev->mdev, p);
 	if (vfd->ctrl_handler)
-		return v4l2_try_ext_ctrls(vfd->ctrl_handler, p);
+		return v4l2_try_ext_ctrls(vfd->ctrl_handler, vfd->v4l2_dev->mdev, p);
 	if (ops->vidioc_try_ext_ctrls == NULL)
 		return -ENOTTY;
 	return check_ext_ctrls(p, 0) ? ops->vidioc_try_ext_ctrls(file, fh, p) :
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index f9eed938d348..ce8c133e0ccd 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -222,17 +222,20 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	case VIDIOC_G_EXT_CTRLS:
 		if (!vfh->ctrl_handler)
 			return -ENOTTY;
-		return v4l2_g_ext_ctrls(vfh->ctrl_handler, arg);
+		return v4l2_g_ext_ctrls(vfh->ctrl_handler,
+					sd->v4l2_dev->mdev, arg);
 
 	case VIDIOC_S_EXT_CTRLS:
 		if (!vfh->ctrl_handler)
 			return -ENOTTY;
-		return v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, arg);
+		return v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler,
+					sd->v4l2_dev->mdev, arg);
 
 	case VIDIOC_TRY_EXT_CTRLS:
 		if (!vfh->ctrl_handler)
 			return -ENOTTY;
-		return v4l2_try_ext_ctrls(vfh->ctrl_handler, arg);
+		return v4l2_try_ext_ctrls(vfh->ctrl_handler,
+					  sd->v4l2_dev->mdev, arg);
 
 	case VIDIOC_DQEVENT:
 		if (!(sd->flags & V4L2_SUBDEV_FL_HAS_EVENTS))
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 378d4f05c160..cf7b36564cd0 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -291,6 +291,11 @@ struct v4l2_ctrl_ref {
  * @notify_priv: Passed as argument to the v4l2_ctrl notify callback.
  * @nr_of_buckets: Total number of buckets in the array.
  * @error:	The error code of the first failed control addition.
+ * @requests:	List to keep track of open control handler request objects.
+ *		For the parent control handler (@req_obj.req == NULL) this
+ *		is the list header. When the parent control handler is
+ *		removed, it has to unbind and put all these requests since
+ *		they refer to the parent.
  * @req_obj:	The &struct media_request_object, used to link into a
  *		&struct media_request.
  */
@@ -305,6 +310,7 @@ struct v4l2_ctrl_handler {
 	void *notify_priv;
 	u16 nr_of_buckets;
 	int error;
+	struct list_head requests;
 	struct media_request_object req_obj;
 };
 
@@ -1134,11 +1140,12 @@ int v4l2_s_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
  *	:ref:`VIDIOC_G_EXT_CTRLS <vidioc_g_ext_ctrls>` ioctl
  *
  * @hdl: pointer to &struct v4l2_ctrl_handler
+ * @mdev: pointer to &struct media_device
  * @c: pointer to &struct v4l2_ext_controls
  *
  * If hdl == NULL then they will all return -EINVAL.
  */
-int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl,
+int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct media_device *mdev,
 		     struct v4l2_ext_controls *c);
 
 /**
@@ -1146,11 +1153,13 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl,
  *	:ref:`VIDIOC_TRY_EXT_CTRLS <vidioc_g_ext_ctrls>` ioctl
  *
  * @hdl: pointer to &struct v4l2_ctrl_handler
+ * @mdev: pointer to &struct media_device
  * @c: pointer to &struct v4l2_ext_controls
  *
  * If hdl == NULL then they will all return -EINVAL.
  */
 int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl,
+		       struct media_device *mdev,
 		       struct v4l2_ext_controls *c);
 
 /**
@@ -1159,11 +1168,13 @@ int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl,
  *
  * @fh: pointer to &struct v4l2_fh
  * @hdl: pointer to &struct v4l2_ctrl_handler
+ * @mdev: pointer to &struct media_device
  * @c: pointer to &struct v4l2_ext_controls
  *
  * If hdl == NULL then they will all return -EINVAL.
  */
 int v4l2_s_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
+		     struct media_device *mdev,
 		     struct v4l2_ext_controls *c);
 
 /**
-- 
2.16.1
