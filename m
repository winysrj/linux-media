Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:48874 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289Ab0JFI7r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 04:59:47 -0400
Received: from localhost.localdomain (unknown [91.178.188.185])
	by perceval.irobotique.be (Postfix) with ESMTPSA id 17270361EC
	for <linux-media@vger.kernel.org>; Wed,  6 Oct 2010 08:59:41 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 14/14] uvcvideo: Fix uvc_query_v4l2_ctrl() and uvc_xu_ctrl_query() locking
Date: Wed,  6 Oct 2010 10:59:52 +0200
Message-Id: <1286355592-13603-15-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Take the ctrl_mutex mutex before touching control information in those
functions.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_ctrl.c |   63 +++++++++++++++++++++--------------
 drivers/media/video/uvc/uvcvideo.h |    2 +-
 2 files changed, 39 insertions(+), 26 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index 0d310c4..f169f77 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -863,9 +863,15 @@ int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 	unsigned int i;
 	int ret;
 
+	ret = mutex_lock_interruptible(&chain->ctrl_mutex);
+	if (ret < 0)
+		return -ERESTARTSYS;
+
 	ctrl = uvc_find_control(chain, v4l2_ctrl->id, &mapping);
-	if (ctrl == NULL)
-		return -EINVAL;
+	if (ctrl == NULL) {
+		ret = -EINVAL;
+		goto done;
+	}
 
 	memset(v4l2_ctrl, 0, sizeof *v4l2_ctrl);
 	v4l2_ctrl->id = mapping->id;
@@ -881,7 +887,7 @@ int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 	if (!ctrl->cached) {
 		ret = uvc_ctrl_populate_cache(chain, ctrl);
 		if (ret < 0)
-			return ret;
+			goto done;
 	}
 
 	if (ctrl->info.flags & UVC_CONTROL_GET_DEF) {
@@ -903,19 +909,19 @@ int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 			}
 		}
 
-		return 0;
+		goto done;
 
 	case V4L2_CTRL_TYPE_BOOLEAN:
 		v4l2_ctrl->minimum = 0;
 		v4l2_ctrl->maximum = 1;
 		v4l2_ctrl->step = 1;
-		return 0;
+		goto done;
 
 	case V4L2_CTRL_TYPE_BUTTON:
 		v4l2_ctrl->minimum = 0;
 		v4l2_ctrl->maximum = 0;
 		v4l2_ctrl->step = 0;
-		return 0;
+		goto done;
 
 	default:
 		break;
@@ -933,7 +939,9 @@ int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 		v4l2_ctrl->step = mapping->get(mapping, UVC_GET_RES,
 				  uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES));
 
-	return 0;
+done:
+	mutex_unlock(&chain->ctrl_mutex);
+	return ret;
 }
 
 
@@ -1295,6 +1303,7 @@ int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
 	struct uvc_entity *entity;
 	struct uvc_control *ctrl = NULL;
 	unsigned int i, found = 0;
+	int restore = 0;
 	__u8 *data;
 	int ret;
 
@@ -1326,44 +1335,48 @@ int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
 		return -EINVAL;
 	}
 
+	if (mutex_lock_interruptible(&chain->ctrl_mutex))
+		return -ERESTARTSYS;
+
 	ret = uvc_ctrl_init_xu_ctrl(chain->dev, ctrl);
-	if (ret < 0)
-		return -ENOENT;
+	if (ret < 0) {
+		ret = -ENOENT;
+		goto done;
+	}
 
 	/* Validate control data size. */
-	if (ctrl->info.size != xctrl->size)
-		return -EINVAL;
+	if (ctrl->info.size != xctrl->size) {
+		ret = -EINVAL;
+		goto done;
+	}
 
 	if ((set && !(ctrl->info.flags & UVC_CONTROL_SET_CUR)) ||
-	    (!set && !(ctrl->info.flags & UVC_CONTROL_GET_CUR)))
-		return -EINVAL;
-
-	if (mutex_lock_interruptible(&chain->ctrl_mutex))
-		return -ERESTARTSYS;
+	    (!set && !(ctrl->info.flags & UVC_CONTROL_GET_CUR))) {
+		ret = -EINVAL;
+		goto done;
+	}
 
 	memcpy(uvc_ctrl_data(ctrl, UVC_CTRL_DATA_BACKUP),
 	       uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
-	       xctrl->size);
+	       ctrl->info.size);
 	data = uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT);
+	restore = set;
 
 	if (set && copy_from_user(data, xctrl->data, xctrl->size)) {
 		ret = -EFAULT;
-		goto out;
+		goto done;
 	}
 
 	ret = uvc_query_ctrl(chain->dev, set ? UVC_SET_CUR : UVC_GET_CUR,
 			     xctrl->unit, chain->dev->intfnum, xctrl->selector,
 			     data, xctrl->size);
 	if (ret < 0)
-		goto out;
+		goto done;
 
-	if (!set && copy_to_user(xctrl->data, data, xctrl->size)) {
+	if (!set && copy_to_user(xctrl->data, data, xctrl->size))
 		ret = -EFAULT;
-		goto out;
-	}
-
-out:
-	if (ret)
+done:
+	if (ret && restore)
 		memcpy(uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
 		       uvc_ctrl_data(ctrl, UVC_CTRL_DATA_BACKUP),
 		       xctrl->size);
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 7d67d95..d97cf6d 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -413,7 +413,7 @@ struct uvc_video_chain {
 	struct uvc_entity *processing;		/* Processing unit */
 	struct uvc_entity *selector;		/* Selector unit */
 
-	struct mutex ctrl_mutex;
+	struct mutex ctrl_mutex;		/* Protects ctrl.info */
 };
 
 struct uvc_streaming {
-- 
1.7.2.2

