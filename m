Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0E81C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 17:08:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A493720842
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 17:08:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730137AbfB0RIw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 12:08:52 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48038 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730647AbfB0RIa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 12:08:30 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id BA6A82787A3
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v2 4/4] media: v4l: ctrls: Add debug messages
Date:   Wed, 27 Feb 2019 14:07:06 -0300
Message-Id: <20190227170706.6258-5-ezequiel@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190227170706.6258-1-ezequiel@collabora.com>
References: <20190227170706.6258-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Currently, the v4l2 control code is a bit silent on errors.
Now that we have a debug parameter, it's possible to enable
debugging messages here.

Add debug messages on (hopefully) most of the error paths.
Since it's really hard to associate all these errors
to video device instance, we are forced to use the global
debug parameter only.

Add a warning in case the user enables control debugging
at the per-device dev_debug level.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c  | 93 +++++++++++++++++++++------
 drivers/media/v4l2-core/v4l2-dev.c    |  2 +
 drivers/media/v4l2-core/v4l2-ioctl.c  |  8 +--
 drivers/media/v4l2-core/v4l2-subdev.c |  4 +-
 include/media/v4l2-ctrls.h            |  9 ++-
 include/media/v4l2-ioctl.h            |  2 +
 6 files changed, 91 insertions(+), 27 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index b79d3bbd8350..af8ad83d1e08 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -18,6 +18,8 @@
     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#define pr_fmt(fmt) "v4l2-ctrls: " fmt
+
 #include <linux/ctype.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
@@ -28,6 +30,14 @@
 #include <media/v4l2-event.h>
 #include <media/v4l2-dev.h>
 
+extern unsigned int videodev_debug;
+
+#define dprintk(fmt, arg...) do {					\
+	if (videodev_debug & V4L2_DEV_DEBUG_CTRL)			\
+		printk(KERN_DEBUG pr_fmt("%s: " fmt),			\
+		       __func__, ##arg);				\
+} while (0)
+
 #define has_op(master, op) \
 	(master->ops && master->ops->op)
 #define call_op(master, op) \
@@ -1952,8 +1962,11 @@ static int validate_new(const struct v4l2_ctrl *ctrl, union v4l2_ctrl_ptr p_new)
 	unsigned idx;
 	int err = 0;
 
-	for (idx = 0; !err && idx < ctrl->elems; idx++)
+	for (idx = 0; !err && idx < ctrl->elems; idx++) {
 		err = ctrl->type_ops->validate(ctrl, idx, p_new);
+		if (err)
+			dprintk("failed to validate control id 0x%x (%d)\n", ctrl->id, err);
+	}
 	return err;
 }
 
@@ -3136,20 +3149,28 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 		if (cs->which &&
 		    cs->which != V4L2_CTRL_WHICH_DEF_VAL &&
 		    cs->which != V4L2_CTRL_WHICH_REQUEST_VAL &&
-		    V4L2_CTRL_ID2WHICH(id) != cs->which)
+		    V4L2_CTRL_ID2WHICH(id) != cs->which) {
+			dprintk("invalid which 0x%x or control id 0x%x\n", cs->which, id);
 			return -EINVAL;
+		}
 
 		/* Old-style private controls are not allowed for
 		   extended controls */
-		if (id >= V4L2_CID_PRIVATE_BASE)
+		if (id >= V4L2_CID_PRIVATE_BASE) {
+			dprintk("old-style private controls not allowed for extended controls\n");
 			return -EINVAL;
+		}
 		ref = find_ref_lock(hdl, id);
-		if (ref == NULL)
+		if (ref == NULL) {
+			dprintk("cannot find control id 0x%x\n", id);
 			return -EINVAL;
+		}
 		h->ref = ref;
 		ctrl = ref->ctrl;
-		if (ctrl->flags & V4L2_CTRL_FLAG_DISABLED)
+		if (ctrl->flags & V4L2_CTRL_FLAG_DISABLED) {
+			dprintk("control id 0x%x is disabled\n", id);
 			return -EINVAL;
+		}
 
 		if (ctrl->cluster[0]->ncontrols > 1)
 			have_clusters = true;
@@ -3159,10 +3180,16 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 			unsigned tot_size = ctrl->elems * ctrl->elem_size;
 
 			if (c->size < tot_size) {
+				/*
+				 * In the get case the application first queries
+				 * to obtain the size of the control.
+				 */
 				if (get) {
 					c->size = tot_size;
 					return -ENOSPC;
 				}
+				dprintk("pointer control id 0x%x size too small, %d bytes but %d bytes needed\n",
+					id, c->size, tot_size);
 				return -EFAULT;
 			}
 			c->size = tot_size;
@@ -3534,16 +3561,20 @@ static int validate_ctrls(struct v4l2_ext_controls *cs,
 
 		cs->error_idx = i;
 
-		if (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY)
+		if (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY) {
+			dprintk("control id 0x%x is read-only\n", ctrl->id);
 			return -EACCES;
+		}
 		/* This test is also done in try_set_control_cluster() which
 		   is called in atomic context, so that has the final say,
 		   but it makes sense to do an up-front check as well. Once
 		   an error occurs in try_set_control_cluster() some other
 		   controls may have been set already and we want to do a
 		   best-effort to avoid that. */
-		if (set && (ctrl->flags & V4L2_CTRL_FLAG_GRABBED))
+		if (set && (ctrl->flags & V4L2_CTRL_FLAG_GRABBED)) {
+			dprintk("control id 0x%x is grabbed, cannot set\n", ctrl->id);
 			return -EBUSY;
+		}
 		/*
 		 * Skip validation for now if the payload needs to be copied
 		 * from userspace into kernelspace. We'll validate those later.
@@ -3576,7 +3607,8 @@ static void update_from_auto_cluster(struct v4l2_ctrl *master)
 }
 
 /* Try or try-and-set controls */
-static int try_set_ext_ctrls_common(struct v4l2_fh *fh,
+static int try_set_ext_ctrls_common(struct video_device *vdev,
+				    struct v4l2_fh *fh,
 				    struct v4l2_ctrl_handler *hdl,
 				    struct v4l2_ext_controls *cs, bool set)
 {
@@ -3588,13 +3620,17 @@ static int try_set_ext_ctrls_common(struct v4l2_fh *fh,
 	cs->error_idx = cs->count;
 
 	/* Default value cannot be changed */
-	if (cs->which == V4L2_CTRL_WHICH_DEF_VAL)
+	if (cs->which == V4L2_CTRL_WHICH_DEF_VAL) {
+		dprintk("%s: cannot change default value\n", video_device_node_name(vdev));
 		return -EINVAL;
+	}
 
 	cs->which = V4L2_CTRL_ID2WHICH(cs->which);
 
-	if (hdl == NULL)
+	if (hdl == NULL) {
+		dprintk("%s: invalid null control handler\n", video_device_node_name(vdev));
 		return -EINVAL;
+	}
 
 	if (cs->count == 0)
 		return class_check(hdl, cs->which);
@@ -3691,7 +3727,8 @@ static int try_set_ext_ctrls_common(struct v4l2_fh *fh,
 	return ret;
 }
 
-static int try_set_ext_ctrls(struct v4l2_fh *fh,
+static int try_set_ext_ctrls(struct video_device *vdev,
+			     struct v4l2_fh *fh,
 			     struct v4l2_ctrl_handler *hdl, struct media_device *mdev,
 			     struct v4l2_ext_controls *cs, bool set)
 {
@@ -3700,21 +3737,32 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh,
 	int ret;
 
 	if (cs->which == V4L2_CTRL_WHICH_REQUEST_VAL) {
-		if (!mdev || cs->request_fd < 0)
+		if (!mdev) {
+			dprintk("%s: missing media device\n", video_device_node_name(vdev));
+			return -EINVAL;
+		}
+
+		if (cs->request_fd < 0) {
+			dprintk("%s: invalid request fd %d\n", video_device_node_name(vdev), cs->request_fd);
 			return -EINVAL;
+		}
 
 		req = media_request_get_by_fd(mdev, cs->request_fd);
-		if (IS_ERR(req))
+		if (IS_ERR(req)) {
+			dprintk("%s: cannot find request fd %d\n", video_device_node_name(vdev), cs->request_fd);
 			return PTR_ERR(req);
+		}
 
 		ret = media_request_lock_for_update(req);
 		if (ret) {
+			dprintk("%s: cannot lock request fd %d\n", video_device_node_name(vdev), cs->request_fd);
 			media_request_put(req);
 			return ret;
 		}
 
 		obj = v4l2_ctrls_find_req_obj(hdl, req, set);
 		if (IS_ERR(obj)) {
+			dprintk("%s: cannot find request object for request fd %d\n", video_device_node_name(vdev), cs->request_fd);
 			media_request_unlock_for_update(req);
 			media_request_put(req);
 			return PTR_ERR(obj);
@@ -3723,7 +3771,9 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh,
 				   req_obj);
 	}
 
-	ret = try_set_ext_ctrls_common(fh, hdl, cs, set);
+	ret = try_set_ext_ctrls_common(vdev, fh, hdl, cs, set);
+	if (ret)
+		dprintk("%s: try_set_ext_ctrls_common failed (%d)\n", video_device_node_name(vdev), ret);
 
 	if (obj) {
 		media_request_unlock_for_update(req);
@@ -3734,17 +3784,22 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh,
 	return ret;
 }
 
-int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct media_device *mdev,
+int v4l2_try_ext_ctrls(struct video_device *vdev,
+		       struct v4l2_ctrl_handler *hdl,
+		       struct media_device *mdev,
 		       struct v4l2_ext_controls *cs)
 {
-	return try_set_ext_ctrls(NULL, hdl, mdev, cs, false);
+	return try_set_ext_ctrls(vdev, NULL, hdl, mdev, cs, false);
 }
 EXPORT_SYMBOL(v4l2_try_ext_ctrls);
 
-int v4l2_s_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
-		     struct media_device *mdev, struct v4l2_ext_controls *cs)
+int v4l2_s_ext_ctrls(struct video_device *vdev,
+		     struct v4l2_fh *fh,
+		     struct v4l2_ctrl_handler *hdl,
+		     struct media_device *mdev,
+		     struct v4l2_ext_controls *cs)
 {
-	return try_set_ext_ctrls(fh, hdl, mdev, cs, true);
+	return try_set_ext_ctrls(vdev, fh, hdl, mdev, cs, true);
 }
 EXPORT_SYMBOL(v4l2_s_ext_ctrls);
 
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 39d22bfbe420..c6bcc9ea1122 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -83,6 +83,8 @@ static ssize_t dev_debug_store(struct device *cd, struct device_attribute *attr,
 	if (res)
 		return res;
 
+	if (value & V4L2_DEV_DEBUG_CTRL)
+		pr_warn_once("Warning: V4L2_DEV_DEBUG_CTRL cannot be enabled via the dev_debug attribute.\n");
 	vdev->dev_debug = value;
 	return len;
 }
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 6f707466b5d2..078f75eb0a19 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2180,9 +2180,9 @@ static int v4l_s_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 
 	p->error_idx = p->count;
 	if (vfh && vfh->ctrl_handler)
-		return v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, vfd->v4l2_dev->mdev, p);
+		return v4l2_s_ext_ctrls(vfd, vfh, vfh->ctrl_handler, vfd->v4l2_dev->mdev, p);
 	if (vfd->ctrl_handler)
-		return v4l2_s_ext_ctrls(NULL, vfd->ctrl_handler, vfd->v4l2_dev->mdev, p);
+		return v4l2_s_ext_ctrls(vfd, vfh, vfd->ctrl_handler, vfd->v4l2_dev->mdev, p);
 	if (ops->vidioc_s_ext_ctrls == NULL)
 		return -ENOTTY;
 	return check_ext_ctrls(p, 0) ? ops->vidioc_s_ext_ctrls(file, fh, p) :
@@ -2199,9 +2199,9 @@ static int v4l_try_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 
 	p->error_idx = p->count;
 	if (vfh && vfh->ctrl_handler)
-		return v4l2_try_ext_ctrls(vfh->ctrl_handler, vfd->v4l2_dev->mdev, p);
+		return v4l2_try_ext_ctrls(vfd, vfh->ctrl_handler, vfd->v4l2_dev->mdev, p);
 	if (vfd->ctrl_handler)
-		return v4l2_try_ext_ctrls(vfd->ctrl_handler, vfd->v4l2_dev->mdev, p);
+		return v4l2_try_ext_ctrls(vfd, vfd->ctrl_handler, vfd->v4l2_dev->mdev, p);
 	if (ops->vidioc_try_ext_ctrls == NULL)
 		return -ENOTTY;
 	return check_ext_ctrls(p, 0) ? ops->vidioc_try_ext_ctrls(file, fh, p) :
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index f5f0d71ec745..3a09d4441ca3 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -228,13 +228,13 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	case VIDIOC_S_EXT_CTRLS:
 		if (!vfh->ctrl_handler)
 			return -ENOTTY;
-		return v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler,
+		return v4l2_s_ext_ctrls(vdev, vfh, vfh->ctrl_handler,
 					sd->v4l2_dev->mdev, arg);
 
 	case VIDIOC_TRY_EXT_CTRLS:
 		if (!vfh->ctrl_handler)
 			return -ENOTTY;
-		return v4l2_try_ext_ctrls(vfh->ctrl_handler,
+		return v4l2_try_ext_ctrls(vdev, vfh->ctrl_handler,
 					  sd->v4l2_dev->mdev, arg);
 
 	case VIDIOC_DQEVENT:
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index d63cf227b0ab..0e38a59c80dd 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -1272,13 +1272,15 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct media_device *mdev,
  * v4l2_try_ext_ctrls - Helper function to implement
  *	:ref:`VIDIOC_TRY_EXT_CTRLS <vidioc_g_ext_ctrls>` ioctl
  *
+ * @vdev: pointer to &struct video_device
  * @hdl: pointer to &struct v4l2_ctrl_handler
  * @mdev: pointer to &struct media_device
  * @c: pointer to &struct v4l2_ext_controls
  *
  * If hdl == NULL then they will all return -EINVAL.
  */
-int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl,
+int v4l2_try_ext_ctrls(struct video_device *vdev,
+		       struct v4l2_ctrl_handler *hdl,
 		       struct media_device *mdev,
 		       struct v4l2_ext_controls *c);
 
@@ -1286,6 +1288,7 @@ int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl,
  * v4l2_s_ext_ctrls - Helper function to implement
  *	:ref:`VIDIOC_S_EXT_CTRLS <vidioc_g_ext_ctrls>` ioctl
  *
+ * @vdev: pointer to &struct video_device
  * @fh: pointer to &struct v4l2_fh
  * @hdl: pointer to &struct v4l2_ctrl_handler
  * @mdev: pointer to &struct media_device
@@ -1293,7 +1296,9 @@ int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl,
  *
  * If hdl == NULL then they will all return -EINVAL.
  */
-int v4l2_s_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
+int v4l2_s_ext_ctrls(struct video_device *vdev,
+		     struct v4l2_fh *fh,
+		     struct v4l2_ctrl_handler *hdl,
 		     struct media_device *mdev,
 		     struct v4l2_ext_controls *c);
 
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 8533ece5026e..0ecd4e3e76a4 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -612,6 +612,8 @@ struct v4l2_ioctl_ops {
 #define V4L2_DEV_DEBUG_STREAMING	0x08
 /* Log poll() */
 #define V4L2_DEV_DEBUG_POLL		0x10
+/* Log controls */
+#define V4L2_DEV_DEBUG_CTRL		0x20
 
 /*  Video standard functions  */
 
-- 
2.20.1

