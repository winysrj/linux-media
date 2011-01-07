Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49389 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab1AGQAA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 11:00:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/5] uvcvideo: Add UVCIOC_CTRL_QUERY ioctl
Date: Fri,  7 Jan 2011 17:00:36 +0100
Message-Id: <1294416040-28371-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1294416040-28371-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1294416040-28371-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Martin Rubli <martin_rubli@logitech.com>

This ioctl extends UVCIOC_CTRL_GET/SET by not only allowing to get/set
XU controls but to also send arbitrary UVC commands to XU controls,
namely GET_CUR, SET_CUR, GET_MIN, GET_MAX, GET_RES, GET_LEN, GET_INFO
and GET_DEF. This is required for applications to work with XU controls,
so that they can properly query the size and allocate the necessary
buffers.

Signed-off-by: Martin Rubli <martin_rubli@logitech.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_ctrl.c |   92 ++++++++++++++++++++++++------------
 drivers/media/video/uvc/uvc_v4l2.c |   19 ++++++-
 drivers/media/video/uvc/uvcvideo.h |   11 ++++-
 3 files changed, 87 insertions(+), 35 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index 59f8a9a..47175cc 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -1344,32 +1344,33 @@ static int uvc_ctrl_init_xu_ctrl(struct uvc_device *dev,
 }
 
 int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
-	struct uvc_xu_control *xctrl, int set)
+	struct uvc_xu_control_query *xqry)
 {
 	struct uvc_entity *entity;
-	struct uvc_control *ctrl = NULL;
+	struct uvc_control *ctrl;
 	unsigned int i, found = 0;
-	int restore = 0;
-	__u8 *data;
+	__u32 reqflags;
+	__u16 size;
+	__u8 *data = NULL;
 	int ret;
 
 	/* Find the extension unit. */
 	list_for_each_entry(entity, &chain->entities, chain) {
 		if (UVC_ENTITY_TYPE(entity) == UVC_VC_EXTENSION_UNIT &&
-		    entity->id == xctrl->unit)
+		    entity->id == xqry->unit)
 			break;
 	}
 
-	if (entity->id != xctrl->unit) {
+	if (entity->id != xqry->unit) {
 		uvc_trace(UVC_TRACE_CONTROL, "Extension unit %u not found.\n",
-			xctrl->unit);
-		return -EINVAL;
+			xqry->unit);
+		return -ENOENT;
 	}
 
 	/* Find the control and perform delayed initialization if needed. */
 	for (i = 0; i < entity->ncontrols; ++i) {
 		ctrl = &entity->controls[i];
-		if (ctrl->index == xctrl->selector - 1) {
+		if (ctrl->index == xqry->selector - 1) {
 			found = 1;
 			break;
 		}
@@ -1377,8 +1378,8 @@ int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
 
 	if (!found) {
 		uvc_trace(UVC_TRACE_CONTROL, "Control %pUl/%u not found.\n",
-			entity->extension.guidExtensionCode, xctrl->selector);
-		return -EINVAL;
+			entity->extension.guidExtensionCode, xqry->selector);
+		return -ENOENT;
 	}
 
 	if (mutex_lock_interruptible(&chain->ctrl_mutex))
@@ -1390,43 +1391,72 @@ int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
 		goto done;
 	}
 
-	/* Validate control data size. */
-	if (ctrl->info.size != xctrl->size) {
+	/* Validate the required buffer size and flags for the request */
+	reqflags = 0;
+	size = ctrl->info.size;
+
+	switch (xqry->query) {
+	case UVC_GET_CUR:
+		reqflags = UVC_CONTROL_GET_CUR;
+		break;
+	case UVC_GET_MIN:
+		reqflags = UVC_CONTROL_GET_MIN;
+		break;
+	case UVC_GET_MAX:
+		reqflags = UVC_CONTROL_GET_MAX;
+		break;
+	case UVC_GET_DEF:
+		reqflags = UVC_CONTROL_GET_DEF;
+		break;
+	case UVC_GET_RES:
+		reqflags = UVC_CONTROL_GET_RES;
+		break;
+	case UVC_SET_CUR:
+		reqflags = UVC_CONTROL_SET_CUR;
+		break;
+	case UVC_GET_LEN:
+		size = 2;
+		break;
+	case UVC_GET_INFO:
+		size = 1;
+		break;
+	default:
 		ret = -EINVAL;
 		goto done;
 	}
 
-	if ((set && !(ctrl->info.flags & UVC_CONTROL_SET_CUR)) ||
-	    (!set && !(ctrl->info.flags & UVC_CONTROL_GET_CUR))) {
-		ret = -EINVAL;
+	if (size != xqry->size) {
+		ret = -ENOBUFS;
 		goto done;
 	}
 
-	memcpy(uvc_ctrl_data(ctrl, UVC_CTRL_DATA_BACKUP),
-	       uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
-	       ctrl->info.size);
-	data = uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT);
-	restore = set;
+	if (reqflags && !(ctrl->info.flags & reqflags)) {
+		ret = -EBADRQC;
+		goto done;
+	}
 
-	if (set && copy_from_user(data, xctrl->data, xctrl->size)) {
+	data = kmalloc(size, GFP_KERNEL);
+	if (data == NULL) {
+		ret = -ENOMEM;
+		goto done;
+	}
+
+	if (xqry->query == UVC_SET_CUR &&
+	    copy_from_user(data, xqry->data, size)) {
 		ret = -EFAULT;
 		goto done;
 	}
 
-	ret = uvc_query_ctrl(chain->dev, set ? UVC_SET_CUR : UVC_GET_CUR,
-			     xctrl->unit, chain->dev->intfnum, xctrl->selector,
-			     data, xctrl->size);
+	ret = uvc_query_ctrl(chain->dev, xqry->query, xqry->unit,
+			     chain->dev->intfnum, xqry->selector, data, size);
 	if (ret < 0)
 		goto done;
 
-	if (!set && copy_to_user(xctrl->data, data, xctrl->size))
+	if (xqry->query != UVC_SET_CUR &&
+	    copy_to_user(xqry->data, data, size))
 		ret = -EFAULT;
 done:
-	if (ret && restore)
-		memcpy(uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
-		       uvc_ctrl_data(ctrl, UVC_CTRL_DATA_BACKUP),
-		       xctrl->size);
-
+	kfree(data);
 	mutex_unlock(&chain->ctrl_mutex);
 	return ret;
 }
diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index 9005a8d..7432336 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -1029,10 +1029,23 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 					  cmd == UVCIOC_CTRL_MAP_OLD);
 
 	case UVCIOC_CTRL_GET:
-		return uvc_xu_ctrl_query(chain, arg, 0);
-
 	case UVCIOC_CTRL_SET:
-		return uvc_xu_ctrl_query(chain, arg, 1);
+	{
+		struct uvc_xu_control *xctrl = arg;
+		struct uvc_xu_control_query xqry = {
+			.unit		= xctrl->unit,
+			.selector	= xctrl->selector,
+			.query		= cmd == UVCIOC_CTRL_GET
+					? UVC_GET_CUR : UVC_SET_CUR,
+			.size		= xctrl->size,
+			.data		= xctrl->data,
+		};
+
+		return uvc_xu_ctrl_query(chain, &xqry);
+	}
+
+	case UVCIOC_CTRL_QUERY:
+		return uvc_xu_ctrl_query(chain, arg);
 
 	default:
 		uvc_trace(UVC_TRACE_IOCTL, "Unknown ioctl 0x%08x\n", cmd);
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 45f01e7..8933b2a 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -73,11 +73,20 @@ struct uvc_xu_control {
 	__u8 __user *data;
 };
 
+struct uvc_xu_control_query {
+	__u8 unit;
+	__u8 selector;
+	__u8 query;
+	__u16 size;
+	__u8 __user *data;
+};
+
 #define UVCIOC_CTRL_ADD		_IOW('U', 1, struct uvc_xu_control_info)
 #define UVCIOC_CTRL_MAP_OLD	_IOWR('U', 2, struct uvc_xu_control_mapping_old)
 #define UVCIOC_CTRL_MAP		_IOWR('U', 2, struct uvc_xu_control_mapping)
 #define UVCIOC_CTRL_GET		_IOWR('U', 3, struct uvc_xu_control)
 #define UVCIOC_CTRL_SET		_IOW('U', 4, struct uvc_xu_control)
+#define UVCIOC_CTRL_QUERY	_IOWR('U', 5, struct uvc_xu_control_query)
 
 #ifdef __KERNEL__
 
@@ -638,7 +647,7 @@ extern int uvc_ctrl_set(struct uvc_video_chain *chain,
 		struct v4l2_ext_control *xctrl);
 
 extern int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
-		struct uvc_xu_control *ctrl, int set);
+		struct uvc_xu_control_query *xqry);
 
 /* Utility functions */
 extern void uvc_simplify_fraction(uint32_t *numerator, uint32_t *denominator,
-- 
1.7.2.2

