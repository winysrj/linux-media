Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:35206 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732800AbeHNRIO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 13:08:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv18 15/35] v4l2-ctrls: support g/s_ext_ctrls for requests
Date: Tue, 14 Aug 2018 16:20:27 +0200
Message-Id: <20180814142047.93856-16-hverkuil@xs4all.nl>
In-Reply-To: <20180814142047.93856-1-hverkuil@xs4all.nl>
References: <20180814142047.93856-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The v4l2_g/s_ext_ctrls functions now support control handlers that
represent requests.

The v4l2_ctrls_find_req_obj() function is responsible for finding the
request from the fd.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/omap3isp/ispvideo.c |   2 +-
 drivers/media/v4l2-core/v4l2-ctrls.c       | 138 +++++++++++++++++++--
 drivers/media/v4l2-core/v4l2-ioctl.c       |  12 +-
 drivers/media/v4l2-core/v4l2-subdev.c      |   9 +-
 include/media/v4l2-ctrls.h                 |   7 +-
 5 files changed, 149 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 9d228eac24ea..674e7fd3ad99 100644
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
index 89e7bfee108f..6d34d7a6f235 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -3140,7 +3140,8 @@ static int class_check(struct v4l2_ctrl_handler *hdl, u32 which)
 }
 
 /* Get extended controls. Allocates the helpers array if needed. */
-int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs)
+static int v4l2_g_ext_ctrls_common(struct v4l2_ctrl_handler *hdl,
+				   struct v4l2_ext_controls *cs)
 {
 	struct v4l2_ctrl_helper helper[4];
 	struct v4l2_ctrl_helper *helpers = helper;
@@ -3220,6 +3221,83 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 		kvfree(helpers);
 	return ret;
 }
+
+static struct media_request_object *
+v4l2_ctrls_find_req_obj(struct v4l2_ctrl_handler *hdl,
+			struct media_request *req, bool set)
+{
+	struct media_request_object *obj;
+	struct v4l2_ctrl_handler *new_hdl;
+	int ret;
+
+	if (IS_ERR(req))
+		return ERR_CAST(req);
+
+	if (set && WARN_ON(req->state != MEDIA_REQUEST_STATE_UPDATING))
+		return ERR_PTR(-EBUSY);
+
+	obj = media_request_object_find(req, &req_ops, hdl);
+	if (obj)
+		return obj;
+	if (!set)
+		return ERR_PTR(-ENOENT);
+
+	new_hdl = kzalloc(sizeof(*new_hdl), GFP_KERNEL);
+	if (!new_hdl)
+		return ERR_PTR(-ENOMEM);
+
+	obj = &new_hdl->req_obj;
+	ret = v4l2_ctrl_handler_init(new_hdl, (hdl->nr_of_buckets - 1) * 8);
+	if (!ret)
+		ret = v4l2_ctrl_request_bind(req, new_hdl, hdl);
+	if (ret) {
+		kfree(new_hdl);
+
+		return ERR_PTR(ret);
+	}
+
+	media_request_object_get(obj);
+	return obj;
+}
+
+int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct media_device *mdev,
+		     struct v4l2_ext_controls *cs)
+{
+	struct media_request_object *obj = NULL;
+	int ret;
+
+	if (cs->which == V4L2_CTRL_WHICH_REQUEST_VAL) {
+		struct media_request *req;
+
+		if (!mdev || cs->request_fd < 0)
+			return -EINVAL;
+
+		req = media_request_get_by_fd(mdev, cs->request_fd);
+		if (IS_ERR(req))
+			return PTR_ERR(req);
+
+		if (req->state != MEDIA_REQUEST_STATE_IDLE &&
+		    req->state != MEDIA_REQUEST_STATE_COMPLETE) {
+			media_request_put(req);
+			return -EBUSY;
+		}
+
+		obj = v4l2_ctrls_find_req_obj(hdl, req, false);
+		/* Reference to the request held through obj */
+		media_request_put(req);
+		if (IS_ERR(obj))
+			return PTR_ERR(obj);
+
+		hdl = container_of(obj, struct v4l2_ctrl_handler,
+				   req_obj);
+	}
+
+	ret = v4l2_g_ext_ctrls_common(hdl, cs);
+
+	if (obj)
+		media_request_object_put(obj);
+	return ret;
+}
 EXPORT_SYMBOL(v4l2_g_ext_ctrls);
 
 /* Helper function to get a single control */
@@ -3408,9 +3486,9 @@ static void update_from_auto_cluster(struct v4l2_ctrl *master)
 }
 
 /* Try or try-and-set controls */
-static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
-			     struct v4l2_ext_controls *cs,
-			     bool set)
+static int try_set_ext_ctrls_common(struct v4l2_fh *fh,
+				    struct v4l2_ctrl_handler *hdl,
+				    struct v4l2_ext_controls *cs, bool set)
 {
 	struct v4l2_ctrl_helper helper[4];
 	struct v4l2_ctrl_helper *helpers = helper;
@@ -3523,16 +3601,60 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 	return ret;
 }
 
-int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs)
+static int try_set_ext_ctrls(struct v4l2_fh *fh,
+			     struct v4l2_ctrl_handler *hdl, struct media_device *mdev,
+			     struct v4l2_ext_controls *cs, bool set)
+{
+	struct media_request_object *obj = NULL;
+	struct media_request *req = NULL;
+	int ret;
+
+	if (cs->which == V4L2_CTRL_WHICH_REQUEST_VAL) {
+		if (!mdev || cs->request_fd < 0)
+			return -EINVAL;
+
+		req = media_request_get_by_fd(mdev, cs->request_fd);
+		if (IS_ERR(req))
+			return PTR_ERR(req);
+
+		ret = media_request_lock_for_update(req);
+		if (ret) {
+			media_request_put(req);
+			return ret;
+		}
+
+		obj = v4l2_ctrls_find_req_obj(hdl, req, set);
+		/* Reference to the request held through obj */
+		media_request_put(req);
+		if (IS_ERR(obj)) {
+			media_request_unlock_for_update(req);
+			return PTR_ERR(obj);
+		}
+		hdl = container_of(obj, struct v4l2_ctrl_handler,
+				   req_obj);
+	}
+
+	ret = try_set_ext_ctrls_common(fh, hdl, cs, set);
+
+	if (obj) {
+		media_request_unlock_for_update(obj->req);
+		media_request_object_put(obj);
+	}
+
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
index 03241d6b7ef8..20b5145a5254 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2109,9 +2109,9 @@ static int v4l_g_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 
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
@@ -2128,9 +2128,9 @@ static int v4l_s_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 
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
@@ -2147,9 +2147,9 @@ static int v4l_try_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 
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
index 2b63fa6b6fc9..0fdbd85532dd 100644
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
index ed784e98c293..f4156544150b 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -1179,11 +1179,12 @@ int v4l2_s_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
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
@@ -1191,11 +1192,13 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl,
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
@@ -1204,11 +1207,13 @@ int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl,
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
2.18.0
