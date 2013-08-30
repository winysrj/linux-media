Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:34737 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab3H3CRp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Aug 2013 22:17:45 -0400
Received: by mail-pd0-f176.google.com with SMTP id q10so1223165pdj.35
        for <linux-media@vger.kernel.org>; Thu, 29 Aug 2013 19:17:44 -0700 (PDT)
From: Pawel Osciak <posciak@chromium.org>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Pawel Osciak <posciak@chromium.org>
Subject: [PATCH v1 10/19] uvcvideo: Support UVC 1.5 runtime control property.
Date: Fri, 30 Aug 2013 11:17:09 +0900
Message-Id: <1377829038-4726-11-git-send-email-posciak@chromium.org>
In-Reply-To: <1377829038-4726-1-git-send-email-posciak@chromium.org>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

UVC 1.5 introduces the concept of runtime controls, which can be set during
streaming. Non-runtime controls can only be changed while device is idle.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 45 +++++++++++++++++++++++++++++++++-------
 drivers/media/usb/uvc/uvc_v4l2.c | 18 ++++++++++------
 drivers/media/usb/uvc/uvcvideo.h | 12 +++++++----
 3 files changed, 57 insertions(+), 18 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index d735c88..b0a19b9 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1076,8 +1076,19 @@ void __uvc_ctrl_unlock(struct uvc_video_chain *chain)
 	mutex_unlock(&chain->pipeline->ctrl_mutex);
 }
 
+static int uvc_check_ctrl_runtime(struct uvc_control *ctrl, bool streaming)
+{
+	if (streaming && !ctrl->in_runtime) {
+		uvc_trace(UVC_TRACE_CONTROL,
+				"Control disabled while streaming\n");
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
 int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
-	struct v4l2_queryctrl *v4l2_ctrl)
+			struct v4l2_queryctrl *v4l2_ctrl, bool streaming)
 {
 	struct uvc_control *ctrl;
 	struct uvc_control_mapping *mapping;
@@ -1093,6 +1104,10 @@ int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 		goto done;
 	}
 
+	ret = uvc_check_ctrl_runtime(ctrl, streaming);
+	if (ret < 0)
+		goto done;
+
 	ret = __uvc_query_v4l2_ctrl(chain, ctrl, mapping, v4l2_ctrl);
 done:
 	__uvc_ctrl_unlock(chain);
@@ -1109,7 +1124,7 @@ done:
  * manually.
  */
 int uvc_query_v4l2_menu(struct uvc_video_chain *chain,
-	struct v4l2_querymenu *query_menu)
+	struct v4l2_querymenu *query_menu, bool streaming)
 {
 	struct uvc_menu_info *menu_info;
 	struct uvc_control_mapping *mapping;
@@ -1132,6 +1147,10 @@ int uvc_query_v4l2_menu(struct uvc_video_chain *chain,
 		goto done;
 	}
 
+	ret = uvc_check_ctrl_runtime(ctrl, streaming);
+	if (ret < 0)
+		goto done;
+
 	if (query_menu->index >= mapping->menu_count) {
 		ret = -EINVAL;
 		goto done;
@@ -1436,21 +1455,26 @@ done:
 	return ret;
 }
 
-int uvc_ctrl_get(struct uvc_video_chain *chain,
-	struct v4l2_ext_control *xctrl)
+int uvc_ctrl_get(struct uvc_video_chain *chain, struct v4l2_ext_control *xctrl,
+		 bool streaming)
 {
 	struct uvc_control *ctrl;
 	struct uvc_control_mapping *mapping;
+	int ret;
 
 	ctrl = uvc_find_control(chain, xctrl->id, &mapping);
 	if (ctrl == NULL)
 		return -EINVAL;
 
+	ret = uvc_check_ctrl_runtime(ctrl, streaming);
+	if (ret < 0)
+		return ret;
+
 	return __uvc_ctrl_get(chain, ctrl, mapping, &xctrl->value);
 }
 
-int uvc_ctrl_set(struct uvc_video_chain *chain,
-	struct v4l2_ext_control *xctrl)
+int uvc_ctrl_set(struct uvc_video_chain *chain, struct v4l2_ext_control *xctrl,
+		 bool streaming)
 {
 	struct uvc_control *ctrl;
 	struct uvc_control_mapping *mapping;
@@ -1466,6 +1490,10 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
 	if (!(ctrl->info.flags & UVC_CTRL_FLAG_SET_CUR))
 		return -EACCES;
 
+	ret = uvc_check_ctrl_runtime(ctrl, streaming);
+	if (ret < 0)
+		return ret;
+
 	/* Clamp out of range values. */
 	switch (mapping->v4l2_type) {
 	case V4L2_CTRL_TYPE_INTEGER:
@@ -1885,8 +1913,9 @@ static int uvc_ctrl_add_info(struct uvc_device *dev, struct uvc_control *ctrl,
 	ctrl->initialized = 1;
 
 	uvc_trace(UVC_TRACE_CONTROL, "Added control %pUl/%u to device %s "
-		"entity %u\n", ctrl->info.entity, ctrl->info.selector,
-		dev->udev->devpath, ctrl->entity->id);
+		"entity %u, init/runtime %d/%d\n", ctrl->info.entity,
+		ctrl->info.selector, dev->udev->devpath, ctrl->entity->id,
+		ctrl->on_init, ctrl->in_runtime);
 
 done:
 	if (ret < 0)
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index a899159..decd65f 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -597,7 +597,8 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 
 	/* Get, Set & Query control */
 	case VIDIOC_QUERYCTRL:
-		return uvc_query_v4l2_ctrl(chain, arg);
+		return uvc_query_v4l2_ctrl(chain, arg,
+					uvc_is_stream_streaming(stream));
 
 	case VIDIOC_G_CTRL:
 	{
@@ -611,7 +612,8 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (ret < 0)
 			return ret;
 
-		ret = uvc_ctrl_get(chain, &xctrl);
+		ret = uvc_ctrl_get(chain, &xctrl,
+					uvc_is_stream_streaming(stream));
 		uvc_ctrl_rollback(handle);
 		if (ret >= 0)
 			ctrl->value = xctrl.value;
@@ -635,7 +637,8 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (ret < 0)
 			return ret;
 
-		ret = uvc_ctrl_set(chain, &xctrl);
+		ret = uvc_ctrl_set(chain, &xctrl,
+					uvc_is_stream_streaming(stream));
 		if (ret < 0) {
 			uvc_ctrl_rollback(handle);
 			return ret;
@@ -647,7 +650,8 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	}
 
 	case VIDIOC_QUERYMENU:
-		return uvc_query_v4l2_menu(chain, arg);
+		return uvc_query_v4l2_menu(chain, arg,
+					uvc_is_stream_streaming(stream));
 
 	case VIDIOC_G_EXT_CTRLS:
 	{
@@ -660,7 +664,8 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 			return ret;
 
 		for (i = 0; i < ctrls->count; ++ctrl, ++i) {
-			ret = uvc_ctrl_get(chain, ctrl);
+			ret = uvc_ctrl_get(chain, ctrl,
+					uvc_is_stream_streaming(stream));
 			if (ret < 0) {
 				uvc_ctrl_rollback(handle);
 				ctrls->error_idx = i;
@@ -688,7 +693,8 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 			return ret;
 
 		for (i = 0; i < ctrls->count; ++ctrl, ++i) {
-			ret = uvc_ctrl_set(chain, ctrl);
+			ret = uvc_ctrl_set(chain, ctrl,
+					uvc_is_stream_streaming(stream));
 			if (ret < 0) {
 				uvc_ctrl_rollback(handle);
 				ctrls->error_idx = cmd == VIDIOC_S_EXT_CTRLS
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 88f5e38..46ffd92 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -694,6 +694,10 @@ extern int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
 void uvc_video_clock_update(struct uvc_streaming *stream,
 			    struct v4l2_buffer *v4l2_buf,
 			    struct uvc_buffer *buf);
+static inline bool uvc_is_stream_streaming(struct uvc_streaming *stream)
+{
+	return vb2_is_streaming(&stream->queue.queue);
+}
 
 /* Status */
 extern int uvc_status_init(struct uvc_device *dev);
@@ -705,9 +709,9 @@ extern void uvc_status_stop(struct uvc_device *dev);
 extern const struct v4l2_subscribed_event_ops uvc_ctrl_sub_ev_ops;
 
 extern int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
-		struct v4l2_queryctrl *v4l2_ctrl);
+		struct v4l2_queryctrl *v4l2_ctrl, bool streaming);
 extern int uvc_query_v4l2_menu(struct uvc_video_chain *chain,
-		struct v4l2_querymenu *query_menu);
+		struct v4l2_querymenu *query_menu, bool streaming);
 
 extern int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 		const struct uvc_control_mapping *mapping);
@@ -731,9 +735,9 @@ static inline int uvc_ctrl_rollback(struct uvc_fh *handle)
 }
 
 extern int uvc_ctrl_get(struct uvc_video_chain *chain,
-		struct v4l2_ext_control *xctrl);
+		struct v4l2_ext_control *xctrl, bool streaming);
 extern int uvc_ctrl_set(struct uvc_video_chain *chain,
-		struct v4l2_ext_control *xctrl);
+		struct v4l2_ext_control *xctrl, bool streaming);
 
 extern int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
 		struct uvc_xu_control_query *xqry);
-- 
1.8.4

