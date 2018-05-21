Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:28373 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752686AbeEUIzS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 04:55:18 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v14 17/36] v4l2-ctrls: support g/s_ext_ctrls for requests
Date: Mon, 21 May 2018 11:54:42 +0300
Message-Id: <20180521085501.16861-18-sakari.ailus@linux.intel.com>
In-Reply-To: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
References: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
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
 drivers/media/v4l2-core/v4l2-ctrls.c       | 113 +++++++++++++++++++++++++++--
 drivers/media/v4l2-core/v4l2-ioctl.c       |  12 +--
 drivers/media/v4l2-core/v4l2-subdev.c      |   9 ++-
 include/media/v4l2-ctrls.h                 |   7 +-
 5 files changed, 124 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 9d228eac24ea5..674e7fd3ad996 100644
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
index 56b986185463d..df58a23eb731a 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -3124,7 +3124,8 @@ static int class_check(struct v4l2_ctrl_handler *hdl, u32 which)
 }
 
 /* Get extended controls. Allocates the helpers array if needed. */
-int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs)
+int __v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl,
+		       struct v4l2_ext_controls *cs)
 {
 	struct v4l2_ctrl_helper helper[4];
 	struct v4l2_ctrl_helper *helpers = helper;
@@ -3204,6 +3205,73 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 		kvfree(helpers);
 	return ret;
 }
+
+static struct media_request_object *
+v4l2_ctrls_find_req_obj(struct v4l2_ctrl_handler *hdl,
+			struct media_device *mdev, s32 fd, bool set)
+{
+	struct media_request *req = media_request_get_by_fd(mdev, fd);
+	struct media_request_object *obj;
+	struct v4l2_ctrl_handler *new_hdl;
+	int ret;
+
+	if (IS_ERR(req))
+		return ERR_CAST(req);
+
+	if (set && atomic_read(&req->state) != MEDIA_REQUEST_STATE_IDLE) {
+		media_request_put(req);
+		return ERR_PTR(-EBUSY);
+	}
+
+	obj = media_request_object_find(req, &req_ops, hdl);
+	if (obj) {
+		media_request_put(req);
+		return obj;
+	}
+
+	new_hdl = kzalloc(sizeof(*new_hdl), GFP_KERNEL);
+	if (!new_hdl) {
+		ret = -ENOMEM;
+		goto put;
+	}
+	obj = &new_hdl->req_obj;
+	ret = v4l2_ctrl_handler_init(new_hdl, (hdl->nr_of_buckets - 1) * 8);
+	if (!ret)
+		ret = v4l2_ctrl_request_bind(req, new_hdl, hdl);
+	if (!ret) {
+		media_request_object_get(obj);
+		media_request_put(req);
+		return obj;
+	}
+	kfree(new_hdl);
+
+put:
+	media_request_put(req);
+	return ERR_PTR(ret);
+}
+
+int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct media_device *mdev,
+		     struct v4l2_ext_controls *cs)
+{
+	struct media_request_object *obj = NULL;
+	int ret;
+
+	if (cs->which == V4L2_CTRL_WHICH_REQUEST_VAL) {
+		if (!mdev || cs->request_fd < 0)
+			return -EINVAL;
+		obj = v4l2_ctrls_find_req_obj(hdl, mdev, cs->request_fd, false);
+		if (IS_ERR(obj))
+			return PTR_ERR(obj);
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
@@ -3379,9 +3447,9 @@ static void update_from_auto_cluster(struct v4l2_ctrl *master)
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
@@ -3494,16 +3562,45 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
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
+	if (cs->which == V4L2_CTRL_WHICH_REQUEST_VAL) {
+		if (!mdev || cs->request_fd < 0)
+			return -EINVAL;
+		obj = v4l2_ctrls_find_req_obj(hdl, mdev, cs->request_fd, true);
+		if (IS_ERR(obj))
+			return PTR_ERR(obj);
+		if (atomic_read(&obj->req->state) != MEDIA_REQUEST_STATE_IDLE) {
+			media_request_object_put(obj);
+			return -EBUSY;
+		}
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
index 60247dcfa77d4..e91891c587177 100644
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
index f9eed938d3480..ce8c133e0ccdf 100644
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
index d2e5653df645e..90015b7ebf500 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -1174,11 +1174,12 @@ int v4l2_s_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
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
@@ -1186,11 +1187,13 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl,
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
@@ -1199,11 +1202,13 @@ int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl,
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
2.11.0
