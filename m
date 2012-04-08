Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755822Ab2DHP5v (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Apr 2012 11:57:51 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 05/10] uvcvideo: Refactor uvc_ctrl_get and query
Date: Sun,  8 Apr 2012 17:59:49 +0200
Message-Id: <1333900794-1932-6-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1333900794-1932-1-git-send-email-hdegoede@redhat.com>
References: <1333900794-1932-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a preparation patch for adding ctrl event support.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_ctrl.c |   77 +++++++++++++++++++++++-------------
 1 file changed, 49 insertions(+), 28 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index 0efd3b1..d20d0de 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -899,24 +899,13 @@ static int uvc_ctrl_populate_cache(struct uvc_video_chain *chain,
 	return 0;
 }
 
-int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
+static int __uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
+	struct uvc_control *ctrl,
+	struct uvc_control_mapping *mapping,
 	struct v4l2_queryctrl *v4l2_ctrl)
 {
-	struct uvc_control *ctrl;
-	struct uvc_control_mapping *mapping;
 	struct uvc_menu_info *menu;
 	unsigned int i;
-	int ret;
-
-	ret = mutex_lock_interruptible(&chain->ctrl_mutex);
-	if (ret < 0)
-		return -ERESTARTSYS;
-
-	ctrl = uvc_find_control(chain, v4l2_ctrl->id, &mapping);
-	if (ctrl == NULL) {
-		ret = -EINVAL;
-		goto done;
-	}
 
 	memset(v4l2_ctrl, 0, sizeof *v4l2_ctrl);
 	v4l2_ctrl->id = mapping->id;
@@ -930,9 +919,9 @@ int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 		v4l2_ctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 
 	if (!ctrl->cached) {
-		ret = uvc_ctrl_populate_cache(chain, ctrl);
+		int ret = uvc_ctrl_populate_cache(chain, ctrl);
 		if (ret < 0)
-			goto done;
+			return ret;
 	}
 
 	if (ctrl->info.flags & UVC_CTRL_FLAG_GET_DEF) {
@@ -954,19 +943,19 @@ int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 			}
 		}
 
-		goto done;
+		return 0;
 
 	case V4L2_CTRL_TYPE_BOOLEAN:
 		v4l2_ctrl->minimum = 0;
 		v4l2_ctrl->maximum = 1;
 		v4l2_ctrl->step = 1;
-		goto done;
+		return 0;
 
 	case V4L2_CTRL_TYPE_BUTTON:
 		v4l2_ctrl->minimum = 0;
 		v4l2_ctrl->maximum = 0;
 		v4l2_ctrl->step = 0;
-		goto done;
+		return 0;
 
 	default:
 		break;
@@ -984,6 +973,27 @@ int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 		v4l2_ctrl->step = mapping->get(mapping, UVC_GET_RES,
 				  uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES));
 
+	return 0;
+}
+
+int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
+	struct v4l2_queryctrl *v4l2_ctrl)
+{
+	struct uvc_control *ctrl;
+	struct uvc_control_mapping *mapping;
+	int ret;
+
+	ret = mutex_lock_interruptible(&chain->ctrl_mutex);
+	if (ret < 0)
+		return -ERESTARTSYS;
+
+	ctrl = uvc_find_control(chain, v4l2_ctrl->id, &mapping);
+	if (ctrl == NULL) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	ret = __uvc_query_v4l2_ctrl(chain, ctrl, mapping, v4l2_ctrl);
 done:
 	mutex_unlock(&chain->ctrl_mutex);
 	return ret;
@@ -1148,17 +1158,15 @@ done:
 	return ret;
 }
 
-int uvc_ctrl_get(struct uvc_video_chain *chain,
-	struct v4l2_ext_control *xctrl)
+static int __uvc_ctrl_get(struct uvc_video_chain *chain,
+	struct uvc_control *ctrl, struct uvc_control_mapping *mapping,
+	s32 *value)
 {
-	struct uvc_control *ctrl;
-	struct uvc_control_mapping *mapping;
 	struct uvc_menu_info *menu;
 	unsigned int i;
 	int ret;
 
-	ctrl = uvc_find_control(chain, xctrl->id, &mapping);
-	if (ctrl == NULL || (ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR) == 0)
+	if ((ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR) == 0)
 		return -EINVAL;
 
 	if (!ctrl->loaded) {
@@ -1172,14 +1180,14 @@ int uvc_ctrl_get(struct uvc_video_chain *chain,
 		ctrl->loaded = 1;
 	}
 
-	xctrl->value = mapping->get(mapping, UVC_GET_CUR,
+	*value = mapping->get(mapping, UVC_GET_CUR,
 		uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT));
 
 	if (mapping->v4l2_type == V4L2_CTRL_TYPE_MENU) {
 		menu = mapping->menu_info;
 		for (i = 0; i < mapping->menu_count; ++i, ++menu) {
-			if (menu->value == xctrl->value) {
-				xctrl->value = i;
+			if (menu->value == *value) {
+				*value = i;
 				break;
 			}
 		}
@@ -1188,6 +1196,19 @@ int uvc_ctrl_get(struct uvc_video_chain *chain,
 	return 0;
 }
 
+int uvc_ctrl_get(struct uvc_video_chain *chain,
+	struct v4l2_ext_control *xctrl)
+{
+	struct uvc_control *ctrl;
+	struct uvc_control_mapping *mapping;
+
+	ctrl = uvc_find_control(chain, xctrl->id, &mapping);
+	if (ctrl == NULL)
+		return -EINVAL;
+
+	return __uvc_ctrl_get(chain, ctrl, mapping, &xctrl->value);
+}
+
 int uvc_ctrl_set(struct uvc_video_chain *chain,
 	struct v4l2_ext_control *xctrl)
 {
-- 
1.7.9.3

