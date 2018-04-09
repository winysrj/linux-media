Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:48655 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752282AbeDIOUf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Apr 2018 10:20:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv11 PATCH 15/29] v4l2-ctrls: support g/s_ext_ctrls for requests
Date: Mon,  9 Apr 2018 16:20:12 +0200
Message-Id: <20180409142026.19369-16-hverkuil@xs4all.nl>
In-Reply-To: <20180409142026.19369-1-hverkuil@xs4all.nl>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
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
index 6e2c5e24734f..317a374b6ea6 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -3122,7 +3122,8 @@ static int class_check(struct v4l2_ctrl_handler *hdl, u32 which)
 }
 
 /* Get extended controls. Allocates the helpers array if needed. */
-int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs)
+int __v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl,
+		       struct v4l2_ext_controls *cs)
 {
 	struct v4l2_ctrl_helper helper[4];
 	struct v4l2_ctrl_helper *helpers = helper;
@@ -3202,6 +3203,73 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 		kvfree(helpers);
 	return ret;
 }
+
+static struct media_request_object *
+v4l2_ctrls_find_req_obj(struct v4l2_ctrl_handler *hdl,
+			struct media_device *mdev, s32 fd, bool set)
+{
+	struct media_request *req = media_request_find(mdev, fd);
+	struct media_request_object *obj;
+	struct v4l2_ctrl_handler *new_hdl;
+	int ret;
+
+	if (IS_ERR(req))
+		return ERR_CAST(req);
+
+	if (set && req->state != MEDIA_REQUEST_STATE_IDLE) {
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
+	if (cs->which == V4L2_CTRL_WHICH_REQUEST) {
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
@@ -3377,9 +3445,9 @@ static void update_from_auto_cluster(struct v4l2_ctrl *master)
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
@@ -3492,16 +3560,45 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
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
+		obj = v4l2_ctrls_find_req_obj(hdl, mdev, cs->request_fd, true);
+		if (IS_ERR(obj))
+			return PTR_ERR(obj);
+		if (obj->req->state != MEDIA_REQUEST_STATE_IDLE) {
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
index 9ce23e23c5bf..56741c4a48fc 100644
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
index 9499846aa1d1..be27835334a2 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -1148,11 +1148,12 @@ int v4l2_s_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
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
@@ -1160,11 +1161,13 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl,
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
@@ -1173,11 +1176,13 @@ int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl,
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
2.16.3
