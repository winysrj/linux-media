Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:42490 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751510AbeBTEpZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 23:45:25 -0500
Received: by mail-pf0-f194.google.com with SMTP id t15so2209748pfh.9
        for <linux-media@vger.kernel.org>; Mon, 19 Feb 2018 20:45:24 -0800 (PST)
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
        Alexandre Courbot <acourbot@chromium.org>
Subject: [RFCv4 15/21] v4l2-ctrls: support requests in EXT_CTRLS ioctls
Date: Tue, 20 Feb 2018 13:44:19 +0900
Message-Id: <20180220044425.169493-16-acourbot@chromium.org>
In-Reply-To: <20180220044425.169493-1-acourbot@chromium.org>
References: <20180220044425.169493-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Read and use the request_fd field of struct v4l2_ext_controls to apply
VIDIOC_G_EXT_CTRLS or VIDIOC_S_EXT_CTRLS to a request when asked by
userspace.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/platform/omap3isp/ispvideo.c |  2 +-
 drivers/media/v4l2-core/v4l2-ctrls.c       | 98 +++++++++++++++++++++-
 drivers/media/v4l2-core/v4l2-ioctl.c       |  6 +-
 drivers/media/v4l2-core/v4l2-subdev.c      |  2 +-
 include/media/v4l2-ctrls.h                 |  3 +-
 5 files changed, 102 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index a751c89a3ea8..3976cd9ac2f2 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -1028,7 +1028,7 @@ static int isp_video_check_external_subdevs(struct isp_video *video,
 	ctrls.count = 1;
 	ctrls.controls = &ctrl;
 
-	ret = v4l2_g_ext_ctrls(pipe->external->ctrl_handler, &ctrls);
+	ret = v4l2_g_ext_ctrls(NULL, pipe->external->ctrl_handler, &ctrls);
 	if (ret < 0) {
 		dev_warn(isp->dev, "no pixel rate control in subdev %s\n",
 			 pipe->external->name);
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 7a81aa5959c3..d7b1aeb32470 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -27,6 +27,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-dev.h>
+#include <media/v4l2-request.h>
 
 #define has_op(master, op) \
 	(master->ops && master->ops->op)
@@ -2959,9 +2960,44 @@ static int class_check(struct v4l2_ctrl_handler *hdl, u32 which)
 }
 
 
+#if IS_ENABLED(CONFIG_MEDIA_REQUEST_API)
+static struct media_request *
+get_handler_for_request(struct v4l2_fh *fh, struct v4l2_ext_controls *cs,
+			struct v4l2_ctrl_handler **hdl)
+{
+	struct media_request *req;
+	struct v4l2_request_entity_data *data;
+
+	if (!fh || !fh->entity)
+		return ERR_PTR(-EINVAL);
+
+	req = media_request_get_from_fd(cs->request_fd);
+	if (!req)
+		return ERR_PTR(-EINVAL);
+
+	data = to_v4l2_entity_data(media_request_get_entity_data(req,
+								 fh->entity));
+	if (IS_ERR(data)) {
+		media_request_put(req);
+		return (void *)data;
+	}
+
+	*hdl = &data->ctrls;
+
+	return req;
+}
+#else
+static struct media_request *
+get_handler_for_request(struct v4l2_fh *fh, struct v4l2_ext_controls *cs,
+			struct v4l2_ctrl_handler **hdl)
+{
+	return ERR_PTR(-ENOTSUPP);
+}
+#endif
 
 /* Get extended controls. Allocates the helpers array if needed. */
-int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs)
+int __v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl,
+		       struct v4l2_ext_controls *cs)
 {
 	struct v4l2_ctrl_helper helper[4];
 	struct v4l2_ctrl_helper *helpers = helper;
@@ -3042,6 +3078,30 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 		kvfree(helpers);
 	return ret;
 }
+
+int v4l2_g_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
+		     struct v4l2_ext_controls *cs)
+{
+	struct media_request *req = NULL;
+	int ret;
+
+	if (cs->request_fd > 0) {
+		req = get_handler_for_request(fh, cs, &hdl);
+		if (IS_ERR(req))
+			return PTR_ERR(req);
+
+		 media_request_lock(req);
+	}
+
+	ret = __v4l2_g_ext_ctrls(hdl, cs);
+
+	if (req) {
+		media_request_unlock(req);
+		media_request_put(req);
+	}
+
+	return ret;
+}
 EXPORT_SYMBOL(v4l2_g_ext_ctrls);
 
 /* Helper function to get a single control */
@@ -3217,9 +3277,9 @@ static void update_from_auto_cluster(struct v4l2_ctrl *master)
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
@@ -3332,6 +3392,36 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 	return ret;
 }
 
+static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
+			     struct v4l2_ext_controls *cs, bool set)
+{
+	struct media_request *req = NULL;
+	int ret;
+
+	if (cs->request_fd > 0) {
+		req = get_handler_for_request(fh, cs, &hdl);
+		if (IS_ERR(req))
+			return PTR_ERR(req);
+
+		media_request_lock(req);
+
+		if (media_request_get_state(req) != MEDIA_REQUEST_STATE_IDLE) {
+			ret = -EBUSY;
+			goto out;
+		}
+	}
+
+	ret = __try_set_ext_ctrls(fh, hdl, cs, set);
+
+out:
+	if (req) {
+		media_request_unlock(req);
+		media_request_put(req);
+	}
+
+	return ret;
+}
+
 int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs)
 {
 	return try_set_ext_ctrls(NULL, hdl, cs, false);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 2f40ac0cdf6e..ab4968ea443f 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2077,10 +2077,11 @@ static int v4l_g_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 		test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
 
 	p->error_idx = p->count;
+
 	if (vfh && vfh->ctrl_handler)
-		return v4l2_g_ext_ctrls(vfh->ctrl_handler, p);
+		return v4l2_g_ext_ctrls(vfh, vfh->ctrl_handler, p);
 	if (vfd->ctrl_handler)
-		return v4l2_g_ext_ctrls(vfd->ctrl_handler, p);
+		return v4l2_g_ext_ctrls(NULL, vfd->ctrl_handler, p);
 	if (ops->vidioc_g_ext_ctrls == NULL)
 		return -ENOTTY;
 	return check_ext_ctrls(p, 0) ? ops->vidioc_g_ext_ctrls(file, fh, p) :
@@ -2096,6 +2097,7 @@ static int v4l_s_ext_ctrls(const struct v4l2_ioctl_ops *ops,
 		test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
 
 	p->error_idx = p->count;
+
 	if (vfh && vfh->ctrl_handler)
 		return v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, p);
 	if (vfd->ctrl_handler)
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index c5639817db34..c547788026c6 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -202,7 +202,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		return v4l2_s_ctrl(vfh, vfh->ctrl_handler, arg);
 
 	case VIDIOC_G_EXT_CTRLS:
-		return v4l2_g_ext_ctrls(vfh->ctrl_handler, arg);
+		return v4l2_g_ext_ctrls(vfh, vfh->ctrl_handler, arg);
 
 	case VIDIOC_S_EXT_CTRLS:
 		return v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, arg);
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 3a10fb3419e3..7c6a76479099 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -1126,12 +1126,13 @@ int v4l2_s_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
  * v4l2_g_ext_ctrls - Helper function to implement
  *	:ref:`VIDIOC_G_EXT_CTRLS <vidioc_g_ext_ctrls>` ioctl
  *
+ * @fh: pointer to &struct v4l2_fh
  * @hdl: pointer to &struct v4l2_ctrl_handler
  * @c: pointer to &struct v4l2_ext_controls
  *
  * If hdl == NULL then they will all return -EINVAL.
  */
-int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl,
+int v4l2_g_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 		     struct v4l2_ext_controls *c);
 
 /**
-- 
2.16.1.291.g4437f3f132-goog
