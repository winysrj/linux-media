Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab2CWQuG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Mar 2012 12:50:06 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5/6] uvcvideo: Refactor uvc_ctrl_get and query
Date: Fri, 23 Mar 2012 17:51:58 +0100
Message-Id: <1332521519-552-6-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1332521519-552-1-git-send-email-hdegoede@redhat.com>
References: <1332521519-552-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a preparation patch for adding ctrl event support.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/uvc/uvc_ctrl.c |   62 +++++++++++++++++++++++++-----------
 1 file changed, 43 insertions(+), 19 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index 0efd3b1..cea5e0a 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -899,24 +899,14 @@ static int uvc_ctrl_populate_cache(struct uvc_video_chain *chain,
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
+	int ret = 0;
 
 	memset(v4l2_ctrl, 0, sizeof *v4l2_ctrl);
 	v4l2_ctrl->id = mapping->id;
@@ -985,6 +975,28 @@ int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 				  uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES));
 
 done:
+	return ret;
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
+done:
 	mutex_unlock(&chain->ctrl_mutex);
 	return ret;
 }
@@ -1148,17 +1160,16 @@ done:
 	return ret;
 }
 
-int uvc_ctrl_get(struct uvc_video_chain *chain,
+static int __uvc_ctrl_get(struct uvc_video_chain *chain,
+	struct uvc_control *ctrl,
+	struct uvc_control_mapping *mapping,
 	struct v4l2_ext_control *xctrl)
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
@@ -1188,6 +1199,19 @@ int uvc_ctrl_get(struct uvc_video_chain *chain,
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
+	return __uvc_ctrl_get(chain, ctrl, mapping, xctrl);
+}
+
 int uvc_ctrl_set(struct uvc_video_chain *chain,
 	struct v4l2_ext_control *xctrl)
 {
-- 
1.7.9.3

