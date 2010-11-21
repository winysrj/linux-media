Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39751 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750Ab0KUUcu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Nov 2010 15:32:50 -0500
Received: from localhost.localdomain (unknown [91.178.49.10])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5F33035CA7
	for <linux-media@vger.kernel.org>; Sun, 21 Nov 2010 20:32:49 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/5] uvcvideo: Lock controls mutex when querying menus
Date: Sun, 21 Nov 2010 21:32:49 +0100
Message-Id: <1290371573-14907-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1290371573-14907-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1290371573-14907-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

uvc_find_control() must be called with the controls mutex locked. Fix
uvc_query_v4l2_menu() accordingly.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_ctrl.c |   48 +++++++++++++++++++++++++++++++++++-
 drivers/media/video/uvc/uvc_v4l2.c |   36 +--------------------------
 drivers/media/video/uvc/uvcvideo.h |    4 +-
 3 files changed, 50 insertions(+), 38 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index f169f77..59f8a9a 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -785,7 +785,7 @@ static void __uvc_find_control(struct uvc_entity *entity, __u32 v4l2_id,
 	}
 }
 
-struct uvc_control *uvc_find_control(struct uvc_video_chain *chain,
+static struct uvc_control *uvc_find_control(struct uvc_video_chain *chain,
 	__u32 v4l2_id, struct uvc_control_mapping **mapping)
 {
 	struct uvc_control *ctrl = NULL;
@@ -944,6 +944,52 @@ done:
 	return ret;
 }
 
+/*
+ * Mapping V4L2 controls to UVC controls can be straighforward if done well.
+ * Most of the UVC controls exist in V4L2, and can be mapped directly. Some
+ * must be grouped (for instance the Red Balance, Blue Balance and Do White
+ * Balance V4L2 controls use the White Balance Component UVC control) or
+ * otherwise translated. The approach we take here is to use a translation
+ * table for the controls that can be mapped directly, and handle the others
+ * manually.
+ */
+int uvc_query_v4l2_menu(struct uvc_video_chain *chain,
+	struct v4l2_querymenu *query_menu)
+{
+	struct uvc_menu_info *menu_info;
+	struct uvc_control_mapping *mapping;
+	struct uvc_control *ctrl;
+	u32 index = query_menu->index;
+	u32 id = query_menu->id;
+	int ret;
+
+	memset(query_menu, 0, sizeof(*query_menu));
+	query_menu->id = id;
+	query_menu->index = index;
+
+	ret = mutex_lock_interruptible(&chain->ctrl_mutex);
+	if (ret < 0)
+		return -ERESTARTSYS;
+
+	ctrl = uvc_find_control(chain, query_menu->id, &mapping);
+	if (ctrl == NULL || mapping->v4l2_type != V4L2_CTRL_TYPE_MENU) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	if (query_menu->index >= mapping->menu_count) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	menu_info = &mapping->menu_info[query_menu->index];
+	strlcpy(query_menu->name, menu_info->name, sizeof query_menu->name);
+
+done:
+	mutex_unlock(&chain->ctrl_mutex);
+	return ret;
+}
+
 
 /* --------------------------------------------------------------------------
  * Control transactions
diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index 6d15de9..0f865e9 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -101,40 +101,6 @@ done:
  */
 
 /*
- * Mapping V4L2 controls to UVC controls can be straighforward if done well.
- * Most of the UVC controls exist in V4L2, and can be mapped directly. Some
- * must be grouped (for instance the Red Balance, Blue Balance and Do White
- * Balance V4L2 controls use the White Balance Component UVC control) or
- * otherwise translated. The approach we take here is to use a translation
- * table for the controls that can be mapped directly, and handle the others
- * manually.
- */
-static int uvc_v4l2_query_menu(struct uvc_video_chain *chain,
-	struct v4l2_querymenu *query_menu)
-{
-	struct uvc_menu_info *menu_info;
-	struct uvc_control_mapping *mapping;
-	struct uvc_control *ctrl;
-	u32 index = query_menu->index;
-	u32 id = query_menu->id;
-
-	ctrl = uvc_find_control(chain, query_menu->id, &mapping);
-	if (ctrl == NULL || mapping->v4l2_type != V4L2_CTRL_TYPE_MENU)
-		return -EINVAL;
-
-	if (query_menu->index >= mapping->menu_count)
-		return -EINVAL;
-
-	memset(query_menu, 0, sizeof(*query_menu));
-	query_menu->id = id;
-	query_menu->index = index;
-
-	menu_info = &mapping->menu_info[query_menu->index];
-	strlcpy(query_menu->name, menu_info->name, sizeof query_menu->name);
-	return 0;
-}
-
-/*
  * Find the frame interval closest to the requested frame interval for the
  * given frame format and size. This should be done by the device as part of
  * the Video Probe and Commit negotiation, but some hardware don't implement
@@ -624,7 +590,7 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	}
 
 	case VIDIOC_QUERYMENU:
-		return uvc_v4l2_query_menu(chain, arg);
+		return uvc_query_v4l2_menu(chain, arg);
 
 	case VIDIOC_G_EXT_CTRLS:
 	{
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index d97cf6d..4520924 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -606,10 +606,10 @@ extern int uvc_status_suspend(struct uvc_device *dev);
 extern int uvc_status_resume(struct uvc_device *dev);
 
 /* Controls */
-extern struct uvc_control *uvc_find_control(struct uvc_video_chain *chain,
-		__u32 v4l2_id, struct uvc_control_mapping **mapping);
 extern int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 		struct v4l2_queryctrl *v4l2_ctrl);
+extern int uvc_query_v4l2_menu(struct uvc_video_chain *chain,
+		struct v4l2_querymenu *query_menu);
 
 extern int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 		const struct uvc_control_mapping *mapping);
-- 
1.7.2.2

