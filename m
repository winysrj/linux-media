Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:48875 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab0JFI7q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 04:59:46 -0400
Received: from localhost.localdomain (unknown [91.178.188.185])
	by perceval.irobotique.be (Postfix) with ESMTPSA id 88AE2361D7
	for <linux-media@vger.kernel.org>; Wed,  6 Oct 2010 08:59:40 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 11/14] uvcvideo: Embed uvc_control_info inside struct uvc_control
Date: Wed,  6 Oct 2010 10:59:49 +0200
Message-Id: <1286355592-13603-12-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Now that control information structures are not shared between control
instances, embed a uvc_control_info instance inside the uvc_control
structure instead of storing a pointer.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_ctrl.c |  130 +++++++++++++++++-------------------
 drivers/media/video/uvc/uvcvideo.h |   11 ++--
 2 files changed, 68 insertions(+), 73 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index 531a3e1..97a2395 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -643,7 +643,7 @@ static struct uvc_control_mapping uvc_ctrl_mappings[] = {
 
 static inline __u8 *uvc_ctrl_data(struct uvc_control *ctrl, int id)
 {
-	return ctrl->uvc_data + id * ctrl->info->size;
+	return ctrl->uvc_data + id * ctrl->info.size;
 }
 
 static inline int uvc_test_bit(const __u8 *data, int bit)
@@ -766,10 +766,10 @@ static void __uvc_find_control(struct uvc_entity *entity, __u32 v4l2_id,
 
 	for (i = 0; i < entity->ncontrols; ++i) {
 		ctrl = &entity->controls[i];
-		if (ctrl->info == NULL)
+		if (!ctrl->initialized)
 			continue;
 
-		list_for_each_entry(map, &ctrl->info->mappings, list) {
+		list_for_each_entry(map, &ctrl->info.mappings, list) {
 			if ((map->id == v4l2_id) && !next) {
 				*control = ctrl;
 				*mapping = map;
@@ -816,36 +816,36 @@ static int uvc_ctrl_populate_cache(struct uvc_video_chain *chain,
 {
 	int ret;
 
-	if (ctrl->info->flags & UVC_CONTROL_GET_DEF) {
+	if (ctrl->info.flags & UVC_CONTROL_GET_DEF) {
 		ret = uvc_query_ctrl(chain->dev, UVC_GET_DEF, ctrl->entity->id,
-				     chain->dev->intfnum, ctrl->info->selector,
+				     chain->dev->intfnum, ctrl->info.selector,
 				     uvc_ctrl_data(ctrl, UVC_CTRL_DATA_DEF),
-				     ctrl->info->size);
+				     ctrl->info.size);
 		if (ret < 0)
 			return ret;
 	}
 
-	if (ctrl->info->flags & UVC_CONTROL_GET_MIN) {
+	if (ctrl->info.flags & UVC_CONTROL_GET_MIN) {
 		ret = uvc_query_ctrl(chain->dev, UVC_GET_MIN, ctrl->entity->id,
-				     chain->dev->intfnum, ctrl->info->selector,
+				     chain->dev->intfnum, ctrl->info.selector,
 				     uvc_ctrl_data(ctrl, UVC_CTRL_DATA_MIN),
-				     ctrl->info->size);
+				     ctrl->info.size);
 		if (ret < 0)
 			return ret;
 	}
-	if (ctrl->info->flags & UVC_CONTROL_GET_MAX) {
+	if (ctrl->info.flags & UVC_CONTROL_GET_MAX) {
 		ret = uvc_query_ctrl(chain->dev, UVC_GET_MAX, ctrl->entity->id,
-				     chain->dev->intfnum, ctrl->info->selector,
+				     chain->dev->intfnum, ctrl->info.selector,
 				     uvc_ctrl_data(ctrl, UVC_CTRL_DATA_MAX),
-				     ctrl->info->size);
+				     ctrl->info.size);
 		if (ret < 0)
 			return ret;
 	}
-	if (ctrl->info->flags & UVC_CONTROL_GET_RES) {
+	if (ctrl->info.flags & UVC_CONTROL_GET_RES) {
 		ret = uvc_query_ctrl(chain->dev, UVC_GET_RES, ctrl->entity->id,
-				     chain->dev->intfnum, ctrl->info->selector,
+				     chain->dev->intfnum, ctrl->info.selector,
 				     uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES),
-				     ctrl->info->size);
+				     ctrl->info.size);
 		if (ret < 0)
 			return ret;
 	}
@@ -873,9 +873,9 @@ int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 	strlcpy(v4l2_ctrl->name, mapping->name, sizeof v4l2_ctrl->name);
 	v4l2_ctrl->flags = 0;
 
-	if (!(ctrl->info->flags & UVC_CONTROL_GET_CUR))
+	if (!(ctrl->info.flags & UVC_CONTROL_GET_CUR))
 		v4l2_ctrl->flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
-	if (!(ctrl->info->flags & UVC_CONTROL_SET_CUR))
+	if (!(ctrl->info.flags & UVC_CONTROL_SET_CUR))
 		v4l2_ctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 
 	if (!ctrl->cached) {
@@ -884,7 +884,7 @@ int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 			return ret;
 	}
 
-	if (ctrl->info->flags & UVC_CONTROL_GET_DEF) {
+	if (ctrl->info.flags & UVC_CONTROL_GET_DEF) {
 		v4l2_ctrl->default_value = mapping->get(mapping, UVC_GET_DEF,
 				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_DEF));
 	}
@@ -921,15 +921,15 @@ int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 		break;
 	}
 
-	if (ctrl->info->flags & UVC_CONTROL_GET_MIN)
+	if (ctrl->info.flags & UVC_CONTROL_GET_MIN)
 		v4l2_ctrl->minimum = mapping->get(mapping, UVC_GET_MIN,
 				     uvc_ctrl_data(ctrl, UVC_CTRL_DATA_MIN));
 
-	if (ctrl->info->flags & UVC_CONTROL_GET_MAX)
+	if (ctrl->info.flags & UVC_CONTROL_GET_MAX)
 		v4l2_ctrl->maximum = mapping->get(mapping, UVC_GET_MAX,
 				     uvc_ctrl_data(ctrl, UVC_CTRL_DATA_MAX));
 
-	if (ctrl->info->flags & UVC_CONTROL_GET_RES)
+	if (ctrl->info.flags & UVC_CONTROL_GET_RES)
 		v4l2_ctrl->step = mapping->get(mapping, UVC_GET_RES,
 				  uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES));
 
@@ -978,14 +978,14 @@ static int uvc_ctrl_commit_entity(struct uvc_device *dev,
 
 	for (i = 0; i < entity->ncontrols; ++i) {
 		ctrl = &entity->controls[i];
-		if (ctrl->info == NULL)
+		if (!ctrl->initialized)
 			continue;
 
 		/* Reset the loaded flag for auto-update controls that were
 		 * marked as loaded in uvc_ctrl_get/uvc_ctrl_set to prevent
 		 * uvc_ctrl_get from using the cached value.
 		 */
-		if (ctrl->info->flags & UVC_CONTROL_AUTO_UPDATE)
+		if (ctrl->info.flags & UVC_CONTROL_AUTO_UPDATE)
 			ctrl->loaded = 0;
 
 		if (!ctrl->dirty)
@@ -993,16 +993,16 @@ static int uvc_ctrl_commit_entity(struct uvc_device *dev,
 
 		if (!rollback)
 			ret = uvc_query_ctrl(dev, UVC_SET_CUR, ctrl->entity->id,
-				dev->intfnum, ctrl->info->selector,
+				dev->intfnum, ctrl->info.selector,
 				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
-				ctrl->info->size);
+				ctrl->info.size);
 		else
 			ret = 0;
 
 		if (rollback || ret < 0)
 			memcpy(uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
 			       uvc_ctrl_data(ctrl, UVC_CTRL_DATA_BACKUP),
-			       ctrl->info->size);
+			       ctrl->info.size);
 
 		ctrl->dirty = 0;
 
@@ -1040,14 +1040,14 @@ int uvc_ctrl_get(struct uvc_video_chain *chain,
 	int ret;
 
 	ctrl = uvc_find_control(chain, xctrl->id, &mapping);
-	if (ctrl == NULL || (ctrl->info->flags & UVC_CONTROL_GET_CUR) == 0)
+	if (ctrl == NULL || (ctrl->info.flags & UVC_CONTROL_GET_CUR) == 0)
 		return -EINVAL;
 
 	if (!ctrl->loaded) {
 		ret = uvc_query_ctrl(chain->dev, UVC_GET_CUR, ctrl->entity->id,
-				chain->dev->intfnum, ctrl->info->selector,
+				chain->dev->intfnum, ctrl->info.selector,
 				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
-				ctrl->info->size);
+				ctrl->info.size);
 		if (ret < 0)
 			return ret;
 
@@ -1082,7 +1082,7 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
 	int ret;
 
 	ctrl = uvc_find_control(chain, xctrl->id, &mapping);
-	if (ctrl == NULL || (ctrl->info->flags & UVC_CONTROL_SET_CUR) == 0)
+	if (ctrl == NULL || (ctrl->info.flags & UVC_CONTROL_SET_CUR) == 0)
 		return -EINVAL;
 
 	/* Clamp out of range values. */
@@ -1128,16 +1128,16 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
 	 * needs to be loaded from the device to perform the read-modify-write
 	 * operation.
 	 */
-	if (!ctrl->loaded && (ctrl->info->size * 8) != mapping->size) {
-		if ((ctrl->info->flags & UVC_CONTROL_GET_CUR) == 0) {
+	if (!ctrl->loaded && (ctrl->info.size * 8) != mapping->size) {
+		if ((ctrl->info.flags & UVC_CONTROL_GET_CUR) == 0) {
 			memset(uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
-				0, ctrl->info->size);
+				0, ctrl->info.size);
 		} else {
 			ret = uvc_query_ctrl(chain->dev, UVC_GET_CUR,
 				ctrl->entity->id, chain->dev->intfnum,
-				ctrl->info->selector,
+				ctrl->info.selector,
 				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
-				ctrl->info->size);
+				ctrl->info.size);
 			if (ret < 0)
 				return ret;
 		}
@@ -1149,7 +1149,7 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
 	if (!ctrl->dirty) {
 		memcpy(uvc_ctrl_data(ctrl, UVC_CTRL_DATA_BACKUP),
 		       uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
-		       ctrl->info->size);
+		       ctrl->info.size);
 	}
 
 	mapping->set(mapping, value,
@@ -1189,10 +1189,10 @@ int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
 	/* Find the control. */
 	for (i = 0; i < entity->ncontrols; ++i) {
 		ctrl = &entity->controls[i];
-		if (ctrl->info == NULL)
+		if (!ctrl->initialized)
 			continue;
 
-		if (ctrl->info->selector == xctrl->selector) {
+		if (ctrl->info.selector == xctrl->selector) {
 			found = 1;
 			break;
 		}
@@ -1205,11 +1205,11 @@ int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
 	}
 
 	/* Validate control data size. */
-	if (ctrl->info->size != xctrl->size)
+	if (ctrl->info.size != xctrl->size)
 		return -EINVAL;
 
-	if ((set && !(ctrl->info->flags & UVC_CONTROL_SET_CUR)) ||
-	    (!set && !(ctrl->info->flags & UVC_CONTROL_GET_CUR)))
+	if ((set && !(ctrl->info.flags & UVC_CONTROL_SET_CUR)) ||
+	    (!set && !(ctrl->info.flags & UVC_CONTROL_GET_CUR)))
 		return -EINVAL;
 
 	if (mutex_lock_interruptible(&chain->ctrl_mutex))
@@ -1272,13 +1272,13 @@ int uvc_ctrl_resume_device(struct uvc_device *dev)
 		for (i = 0; i < entity->ncontrols; ++i) {
 			ctrl = &entity->controls[i];
 
-			if (ctrl->info == NULL || !ctrl->modified ||
-			    (ctrl->info->flags & UVC_CONTROL_RESTORE) == 0)
+			if (!ctrl->initialized || !ctrl->modified ||
+			    (ctrl->info.flags & UVC_CONTROL_RESTORE) == 0)
 				continue;
 
 			printk(KERN_INFO "restoring control %pUl/%u/%u\n",
-				ctrl->info->entity, ctrl->info->index,
-				ctrl->info->selector);
+				ctrl->info.entity, ctrl->info.index,
+				ctrl->info.selector);
 			ctrl->dirty = 1;
 		}
 
@@ -1361,31 +1361,26 @@ static int uvc_ctrl_add_info(struct uvc_device *dev, struct uvc_control *ctrl,
 {
 	int ret = 0;
 
-	/* Clone the control info struct for this device's instance */
-	ctrl->info = kmemdup(info, sizeof(*info), GFP_KERNEL);
-	if (ctrl->info == NULL) {
-		ret = -ENOMEM;
-		goto done;
-	}
-	INIT_LIST_HEAD(&ctrl->info->mappings);
+	memcpy(&ctrl->info, info, sizeof(*info));
+	INIT_LIST_HEAD(&ctrl->info.mappings);
 
 	/* Allocate an array to save control values (cur, def, max, etc.) */
-	ctrl->uvc_data = kzalloc(ctrl->info->size * UVC_CTRL_DATA_LAST + 1,
+	ctrl->uvc_data = kzalloc(ctrl->info.size * UVC_CTRL_DATA_LAST + 1,
 				 GFP_KERNEL);
 	if (ctrl->uvc_data == NULL) {
 		ret = -ENOMEM;
 		goto done;
 	}
 
+	ctrl->initialized = 1;
+
 	uvc_trace(UVC_TRACE_CONTROL, "Added control %pUl/%u to device %s "
-		"entity %u\n", ctrl->info->entity, ctrl->info->selector,
+		"entity %u\n", ctrl->info.entity, ctrl->info.selector,
 		dev->udev->devpath, ctrl->entity->id);
 
 done:
-	if (ret < 0) {
+	if (ret < 0)
 		kfree(ctrl->uvc_data);
-		kfree(ctrl->info);
-	}
 	return ret;
 }
 
@@ -1418,11 +1413,11 @@ static int __uvc_ctrl_add_mapping(struct uvc_device *dev,
 	if (map->set == NULL)
 		map->set = uvc_set_le_value;
 
-	map->ctrl = ctrl->info;
-	list_add_tail(&map->list, &ctrl->info->mappings);
+	map->ctrl = &ctrl->info;
+	list_add_tail(&map->list, &ctrl->info.mappings);
 	uvc_trace(UVC_TRACE_CONTROL,
 		"Adding mapping '%s' to control %pUl/%u.\n",
-		map->name, ctrl->info->entity, ctrl->info->selector);
+		map->name, ctrl->info.entity, ctrl->info.selector);
 
 	return 0;
 }
@@ -1453,8 +1448,8 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 
 		for (i = 0; i < entity->ncontrols; ++i) {
 			ctrl = &entity->controls[i];
-			if (ctrl->info != NULL &&
-			    ctrl->info->selector == mapping->selector) {
+			if (ctrl->initialized &&
+			    ctrl->info.selector == mapping->selector) {
 				found = 1;
 				break;
 			}
@@ -1469,7 +1464,7 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 	if (mutex_lock_interruptible(&chain->ctrl_mutex))
 		return -ERESTARTSYS;
 
-	list_for_each_entry(map, &ctrl->info->mappings, list) {
+	list_for_each_entry(map, &ctrl->info.mappings, list) {
 		if (mapping->id == map->id) {
 			uvc_trace(UVC_TRACE_CONTROL, "Can't add mapping '%s', "
 				"control id 0x%08x already exists.\n",
@@ -1601,12 +1596,12 @@ static void uvc_ctrl_init_ctrl(struct uvc_device *dev, struct uvc_control *ctrl)
 		 }
 	}
 
-	if (ctrl->info == NULL)
+	if (!ctrl->initialized)
 		return;
 
 	for (; mapping < mend; ++mapping) {
 		if (uvc_entity_match_guid(ctrl->entity, mapping->entity) &&
-		    ctrl->info->selector == mapping->selector)
+		    ctrl->info.selector == mapping->selector)
 			__uvc_ctrl_add_mapping(dev, ctrl, mapping);
 	}
 }
@@ -1676,7 +1671,7 @@ static void uvc_ctrl_cleanup_mappings(struct uvc_device *dev,
 {
 	struct uvc_control_mapping *mapping, *nm;
 
-	list_for_each_entry_safe(mapping, nm, &ctrl->info->mappings, list) {
+	list_for_each_entry_safe(mapping, nm, &ctrl->info.mappings, list) {
 		list_del(&mapping->list);
 		kfree(mapping->menu_info);
 		kfree(mapping);
@@ -1693,12 +1688,11 @@ void uvc_ctrl_cleanup_device(struct uvc_device *dev)
 		for (i = 0; i < entity->ncontrols; ++i) {
 			struct uvc_control *ctrl = &entity->controls[i];
 
-			if (ctrl->info == NULL)
+			if (!ctrl->initialized)
 				continue;
 
 			uvc_ctrl_cleanup_mappings(dev, ctrl);
 			kfree(ctrl->uvc_data);
-			kfree(ctrl->info);
 		}
 
 		kfree(entity->controls);
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 39e9e36..7d67d95 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -236,14 +236,15 @@ struct uvc_control_mapping {
 
 struct uvc_control {
 	struct uvc_entity *entity;
-	struct uvc_control_info *info;
+	struct uvc_control_info info;
 
 	__u8 index;	/* Used to match the uvc_control entry with a
 			   uvc_control_info. */
-	__u8 dirty : 1,
-	     loaded : 1,
-	     modified : 1,
-	     cached : 1;
+	__u8 dirty:1,
+	     loaded:1,
+	     modified:1,
+	     cached:1,
+	     initialized:1;
 
 	__u8 *uvc_data;
 };
-- 
1.7.2.2

