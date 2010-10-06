Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:48874 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279Ab0JFI7q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 04:59:46 -0400
Received: from localhost.localdomain (unknown [91.178.188.185])
	by perceval.irobotique.be (Postfix) with ESMTPSA id B0370361D9
	for <linux-media@vger.kernel.org>; Wed,  6 Oct 2010 08:59:40 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 12/14] uvcvideo: Delay initialization of XU controls
Date: Wed,  6 Oct 2010 10:59:50 +0200
Message-Id: <1286355592-13603-13-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

XU controls initialization requires querying the device for control
information. As some buggy UVC devices will crash when queried
repeatedly in a tight loop, delay XU controls initialization until first
use.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_ctrl.c |  194 ++++++++++++++++++++----------------
 1 files changed, 107 insertions(+), 87 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index 97a2395..a0c9d58 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -1164,6 +1164,90 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
  * Dynamic controls
  */
 
+/*
+ * Query control information (size and flags) for XU controls.
+ */
+static int uvc_ctrl_fill_xu_info(struct uvc_device *dev,
+	const struct uvc_control *ctrl, struct uvc_control_info *info)
+{
+	u8 *data;
+	int ret;
+
+	data = kmalloc(2, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	memcpy(info->entity, ctrl->entity->extension.guidExtensionCode,
+	       sizeof(info->entity));
+	info->index = ctrl->index;
+	info->selector = ctrl->index + 1;
+
+	/* Query and verify the control length (GET_LEN) */
+	ret = uvc_query_ctrl(dev, UVC_GET_LEN, ctrl->entity->id, dev->intfnum,
+			     info->selector, data, 2);
+	if (ret < 0) {
+		uvc_trace(UVC_TRACE_CONTROL,
+			  "GET_LEN failed on control %pUl/%u (%d).\n",
+			   info->entity, info->selector, ret);
+		goto done;
+	}
+
+	info->size = le16_to_cpup((__le16 *)data);
+
+	/* Query the control information (GET_INFO) */
+	ret = uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id, dev->intfnum,
+			     info->selector, data, 1);
+	if (ret < 0) {
+		uvc_trace(UVC_TRACE_CONTROL,
+			  "GET_INFO failed on control %pUl/%u (%d).\n",
+			  info->entity, info->selector, ret);
+		goto done;
+	}
+
+	info->flags = UVC_CONTROL_GET_MIN | UVC_CONTROL_GET_MAX
+		    | UVC_CONTROL_GET_RES | UVC_CONTROL_GET_DEF
+		    | (data[0] & UVC_CONTROL_CAP_GET ? UVC_CONTROL_GET_CUR : 0)
+		    | (data[0] & UVC_CONTROL_CAP_SET ? UVC_CONTROL_SET_CUR : 0)
+		    | (data[0] & UVC_CONTROL_CAP_AUTOUPDATE ?
+		       UVC_CONTROL_AUTO_UPDATE : 0);
+
+	uvc_trace(UVC_TRACE_CONTROL, "XU control %pUl/%u queried: len %u, "
+		  "flags { get %u set %u auto %u }.\n",
+		  info->entity, info->selector, info->size,
+		  (info->flags & UVC_CONTROL_GET_CUR) ? 1 : 0,
+		  (info->flags & UVC_CONTROL_SET_CUR) ? 1 : 0,
+		  (info->flags & UVC_CONTROL_AUTO_UPDATE) ? 1 : 0);
+
+done:
+	kfree(data);
+	return ret;
+}
+
+static int uvc_ctrl_add_info(struct uvc_device *dev, struct uvc_control *ctrl,
+	const struct uvc_control_info *info);
+
+static int uvc_ctrl_init_xu_ctrl(struct uvc_device *dev,
+	struct uvc_control *ctrl)
+{
+	struct uvc_control_info info;
+	int ret;
+
+	if (ctrl->initialized)
+		return 0;
+
+	ret = uvc_ctrl_fill_xu_info(dev, ctrl, &info);
+	if (ret < 0)
+		return ret;
+
+	ret = uvc_ctrl_add_info(dev, ctrl, &info);
+	if (ret < 0)
+		uvc_trace(UVC_TRACE_CONTROL, "Failed to initialize control "
+			  "%pUl/%u on device %s entity %u\n", info.entity,
+			  info.selector, dev->udev->devpath, ctrl->entity->id);
+
+	return ret;
+}
+
 int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
 	struct uvc_xu_control *xctrl, int set)
 {
@@ -1186,13 +1270,10 @@ int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
 		return -EINVAL;
 	}
 
-	/* Find the control. */
+	/* Find the control and perform delayed initialization if needed. */
 	for (i = 0; i < entity->ncontrols; ++i) {
 		ctrl = &entity->controls[i];
-		if (!ctrl->initialized)
-			continue;
-
-		if (ctrl->info.selector == xctrl->selector) {
+		if (ctrl->index == xctrl->selector - 1) {
 			found = 1;
 			break;
 		}
@@ -1204,6 +1285,10 @@ int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
 		return -EINVAL;
 	}
 
+	ret = uvc_ctrl_init_xu_ctrl(chain->dev, ctrl);
+	if (ret < 0)
+		return -ENOENT;
+
 	/* Validate control data size. */
 	if (ctrl->info.size != xctrl->size)
 		return -EINVAL;
@@ -1295,65 +1380,6 @@ int uvc_ctrl_resume_device(struct uvc_device *dev)
  */
 
 /*
- * Query control information (size and flags) for XU controls.
- */
-static int uvc_ctrl_fill_xu_info(struct uvc_device *dev,
-	const struct uvc_control *ctrl, struct uvc_control_info *info)
-{
-	u8 *data;
-	int ret;
-
-	data = kmalloc(2, GFP_KERNEL);
-	if (data == NULL)
-		return -ENOMEM;
-
-	memcpy(info->entity, ctrl->entity->extension.guidExtensionCode,
-	       sizeof(info->entity));
-	info->index = ctrl->index;
-	info->selector = ctrl->index + 1;
-
-	/* Query and verify the control length (GET_LEN) */
-	ret = uvc_query_ctrl(dev, UVC_GET_LEN, ctrl->entity->id, dev->intfnum,
-			     info->selector, data, 2);
-	if (ret < 0) {
-		uvc_trace(UVC_TRACE_CONTROL,
-			  "GET_LEN failed on control %pUl/%u (%d).\n",
-			   info->entity, info->selector, ret);
-		goto done;
-	}
-
-	info->size = le16_to_cpup((__le16 *)data);
-
-	/* Query the control information (GET_INFO) */
-	ret = uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id, dev->intfnum,
-			     info->selector, data, 1);
-	if (ret < 0) {
-		uvc_trace(UVC_TRACE_CONTROL,
-			  "GET_INFO failed on control %pUl/%u (%d).\n",
-			  info->entity, info->selector, ret);
-		goto done;
-	}
-
-	info->flags = UVC_CONTROL_GET_MIN | UVC_CONTROL_GET_MAX
-		    | UVC_CONTROL_GET_RES | UVC_CONTROL_GET_DEF
-		    | (data[0] & UVC_CONTROL_CAP_GET ? UVC_CONTROL_GET_CUR : 0)
-		    | (data[0] & UVC_CONTROL_CAP_SET ? UVC_CONTROL_SET_CUR : 0)
-		    | (data[0] & UVC_CONTROL_CAP_AUTOUPDATE ?
-		       UVC_CONTROL_AUTO_UPDATE : 0);
-
-	uvc_trace(UVC_TRACE_CONTROL, "XU control %pUl/%u queried: len %u, "
-		  "flags { get %u set %u auto %u }.\n",
-		  info->entity, info->selector, info->size,
-		  (info->flags & UVC_CONTROL_GET_CUR) ? 1 : 0,
-		  (info->flags & UVC_CONTROL_SET_CUR) ? 1 : 0,
-		  (info->flags & UVC_CONTROL_AUTO_UPDATE) ? 1 : 0);
-
-done:
-	kfree(data);
-	return ret;
-}
-
-/*
  * Add control information to a given control.
  */
 static int uvc_ctrl_add_info(struct uvc_device *dev, struct uvc_control *ctrl,
@@ -1434,7 +1460,7 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 
 	if (mapping->id & ~V4L2_CTRL_ID_MASK) {
 		uvc_trace(UVC_TRACE_CONTROL, "Can't add mapping '%s', control "
-			"control id 0x%08x is invalid.\n", mapping->name,
+			"id 0x%08x is invalid.\n", mapping->name,
 			mapping->id);
 		return -EINVAL;
 	}
@@ -1443,13 +1469,13 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 	list_for_each_entry(entity, &dev->entities, list) {
 		unsigned int i;
 
-		if (!uvc_entity_match_guid(entity, mapping->entity))
+		if (UVC_ENTITY_TYPE(entity) != UVC_VC_EXTENSION_UNIT ||
+		    !uvc_entity_match_guid(entity, mapping->entity))
 			continue;
 
 		for (i = 0; i < entity->ncontrols; ++i) {
 			ctrl = &entity->controls[i];
-			if (ctrl->initialized &&
-			    ctrl->info.selector == mapping->selector) {
+			if (ctrl->index == mapping->selector - 1) {
 				found = 1;
 				break;
 			}
@@ -1464,6 +1490,13 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 	if (mutex_lock_interruptible(&chain->ctrl_mutex))
 		return -ERESTARTSYS;
 
+	/* Perform delayed initialization of XU controls */
+	ret = uvc_ctrl_init_xu_ctrl(dev, ctrl);
+	if (ret < 0) {
+		ret = -ENOENT;
+		goto done;
+	}
+
 	list_for_each_entry(map, &ctrl->info.mappings, list) {
 		if (mapping->id == map->id) {
 			uvc_trace(UVC_TRACE_CONTROL, "Can't add mapping '%s', "
@@ -1567,26 +1600,13 @@ static void uvc_ctrl_init_ctrl(struct uvc_device *dev, struct uvc_control *ctrl)
 	const struct uvc_control_mapping *mend =
 		mapping + ARRAY_SIZE(uvc_ctrl_mappings);
 
-	/* Query XU controls for control information */
-	if (UVC_ENTITY_TYPE(ctrl->entity) == UVC_VC_EXTENSION_UNIT) {
-		struct uvc_control_info info;
-		int ret;
-
-		ret = uvc_ctrl_fill_xu_info(dev, ctrl, &info);
-		if (ret < 0)
-			return;
-
-		ret = uvc_ctrl_add_info(dev, ctrl, &info);
-		if (ret < 0) {
-			/* Skip the control */
-			uvc_trace(UVC_TRACE_CONTROL, "Failed to initialize "
-				"control %pUl/%u on device %s entity %u\n",
-				info.entity, info.selector, dev->udev->devpath,
-				ctrl->entity->id);
-			memset(ctrl, 0, sizeof(*ctrl));
-		}
+	/* XU controls initialization requires querying the device for control
+	 * information. As some buggy UVC devices will crash when queried
+	 * repeatedly in a tight loop, delay XU controls initialization until
+	 * first use.
+	 */
+	if (UVC_ENTITY_TYPE(ctrl->entity) == UVC_VC_EXTENSION_UNIT)
 		return;
-	}
 
 	for (; info < iend; ++info) {
 		if (uvc_entity_match_guid(ctrl->entity, info->entity) &&
-- 
1.7.2.2

