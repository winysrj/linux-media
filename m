Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755823Ab2DHP5x (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Apr 2012 11:57:53 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 06/10] uvcvideo: Move __uvc_ctrl_get() up
Date: Sun,  8 Apr 2012 17:59:50 +0200
Message-Id: <1333900794-1932-7-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1333900794-1932-1-git-send-email-hdegoede@redhat.com>
References: <1333900794-1932-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This avoids the need for doing a forward declaration of __uvc_ctrl_get
(which is a static function) in later patches in this series.

Note to reviewers this patch does not change a single line of code, it
just moves the function up in uvc_ctrl.c a bit.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_ctrl.c |   76 ++++++++++++++++++------------------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index d20d0de..0c27cc1 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -899,6 +899,44 @@ static int uvc_ctrl_populate_cache(struct uvc_video_chain *chain,
 	return 0;
 }
 
+static int __uvc_ctrl_get(struct uvc_video_chain *chain,
+	struct uvc_control *ctrl, struct uvc_control_mapping *mapping,
+	s32 *value)
+{
+	struct uvc_menu_info *menu;
+	unsigned int i;
+	int ret;
+
+	if ((ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR) == 0)
+		return -EINVAL;
+
+	if (!ctrl->loaded) {
+		ret = uvc_query_ctrl(chain->dev, UVC_GET_CUR, ctrl->entity->id,
+				chain->dev->intfnum, ctrl->info.selector,
+				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
+				ctrl->info.size);
+		if (ret < 0)
+			return ret;
+
+		ctrl->loaded = 1;
+	}
+
+	*value = mapping->get(mapping, UVC_GET_CUR,
+		uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT));
+
+	if (mapping->v4l2_type == V4L2_CTRL_TYPE_MENU) {
+		menu = mapping->menu_info;
+		for (i = 0; i < mapping->menu_count; ++i, ++menu) {
+			if (menu->value == *value) {
+				*value = i;
+				break;
+			}
+		}
+	}
+
+	return 0;
+}
+
 static int __uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 	struct uvc_control *ctrl,
 	struct uvc_control_mapping *mapping,
@@ -1158,44 +1196,6 @@ done:
 	return ret;
 }
 
-static int __uvc_ctrl_get(struct uvc_video_chain *chain,
-	struct uvc_control *ctrl, struct uvc_control_mapping *mapping,
-	s32 *value)
-{
-	struct uvc_menu_info *menu;
-	unsigned int i;
-	int ret;
-
-	if ((ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR) == 0)
-		return -EINVAL;
-
-	if (!ctrl->loaded) {
-		ret = uvc_query_ctrl(chain->dev, UVC_GET_CUR, ctrl->entity->id,
-				chain->dev->intfnum, ctrl->info.selector,
-				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
-				ctrl->info.size);
-		if (ret < 0)
-			return ret;
-
-		ctrl->loaded = 1;
-	}
-
-	*value = mapping->get(mapping, UVC_GET_CUR,
-		uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT));
-
-	if (mapping->v4l2_type == V4L2_CTRL_TYPE_MENU) {
-		menu = mapping->menu_info;
-		for (i = 0; i < mapping->menu_count; ++i, ++menu) {
-			if (menu->value == *value) {
-				*value = i;
-				break;
-			}
-		}
-	}
-
-	return 0;
-}
-
 int uvc_ctrl_get(struct uvc_video_chain *chain,
 	struct v4l2_ext_control *xctrl)
 {
-- 
1.7.9.3

