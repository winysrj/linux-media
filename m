Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:48875 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab0JFI7o (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 04:59:44 -0400
Received: from localhost.localdomain (unknown [91.178.188.185])
	by perceval.irobotique.be (Postfix) with ESMTPSA id 2FE3D35D56
	for <linux-media@vger.kernel.org>; Wed,  6 Oct 2010 08:59:40 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 09/14] uvcvideo: Hardcode the index/selector relationship for XU controls
Date: Wed,  6 Oct 2010 10:59:47 +0200
Message-Id: <1286355592-13603-10-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Devices advertise XU controls using a bitmask, in which each bit
corresponds to a control. The control selector, used to query the
control, isn't available in the USB descriptors.

All known UVC devices use control selectors equal to the control bit
index plus one. Hardcode that relationship in the driver, making the
UVCIOC_CTRL_ADD ioctl obsolete. All necessary information about XU
controls can be obtained by the driver at enumeration time.

The UVCIOC_CTRL_ADD ioctl is still supported for compatibility reasons,
but now always returns -EEXIST.

Finally, control mappings are now on a per-device basis and no longer
global.

As this changes the userspace interface, bump the driver version number
to 1.0.0 (it was about time).

Signed-off-by: Martin Rubli <martin_rubli@logitech.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_ctrl.c   |  433 +++++++++++++++++-----------------
 drivers/media/video/uvc/uvc_driver.c |   10 -
 drivers/media/video/uvc/uvc_v4l2.c   |   46 +---
 drivers/media/video/uvc/uvcvideo.h   |   21 +--
 4 files changed, 240 insertions(+), 270 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index e7acf55..2c81b7f 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -1294,201 +1294,193 @@ int uvc_ctrl_resume_device(struct uvc_device *dev)
  * Control and mapping handling
  */
 
-static int uvc_ctrl_add_ctrl(struct uvc_device *dev,
-	struct uvc_control_info *info)
+/*
+ * Query control information (size and flags) for XU controls.
+ */
+static int uvc_ctrl_fill_xu_info(struct uvc_device *dev,
+	const struct uvc_control *ctrl, struct uvc_control_info *info)
 {
-	struct uvc_entity *entity;
-	struct uvc_control *ctrl = NULL;
-	int ret = 0, found = 0;
-	unsigned int i;
-	u8 *uvc_info;
-	u8 *uvc_data;
+	u8 *data;
+	int ret;
 
-	list_for_each_entry(entity, &dev->entities, list) {
-		if (!uvc_entity_match_guid(entity, info->entity))
-			continue;
+	data = kmalloc(2, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
 
-		for (i = 0; i < entity->ncontrols; ++i) {
-			ctrl = &entity->controls[i];
-			if (ctrl->index == info->index) {
-				found = 1;
-				break;
-			}
-		}
+	memcpy(info->entity, ctrl->entity->extension.guidExtensionCode,
+	       sizeof(info->entity));
+	info->index = ctrl->index;
+	info->selector = ctrl->index + 1;
 
-		if (found)
-			break;
+	/* Query and verify the control length (GET_LEN) */
+	ret = uvc_query_ctrl(dev, UVC_GET_LEN, ctrl->entity->id, dev->intfnum,
+			     info->selector, data, 2);
+	if (ret < 0) {
+		uvc_trace(UVC_TRACE_CONTROL,
+			  "GET_LEN failed on control %pUl/%u (%d).\n",
+			   info->entity, info->selector, ret);
+		goto done;
 	}
 
-	if (!found)
-		return 0;
+	info->size = le16_to_cpup((__le16 *)data);
 
-	uvc_data = kmalloc(info->size * UVC_CTRL_DATA_LAST + 1, GFP_KERNEL);
-	if (uvc_data == NULL)
-		return -ENOMEM;
+	/* Query the control information (GET_INFO) */
+	ret = uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id, dev->intfnum,
+			     info->selector, data, 1);
+	if (ret < 0) {
+		uvc_trace(UVC_TRACE_CONTROL,
+			  "GET_INFO failed on control %pUl/%u (%d).\n",
+			  info->entity, info->selector, ret);
+		goto done;
+	}
 
-	uvc_info = uvc_data + info->size * UVC_CTRL_DATA_LAST;
+	info->flags = UVC_CONTROL_GET_MIN | UVC_CONTROL_GET_MAX
+		    | UVC_CONTROL_GET_RES | UVC_CONTROL_GET_DEF
+		    | (data[0] & UVC_CONTROL_CAP_GET ? UVC_CONTROL_GET_CUR : 0)
+		    | (data[0] & UVC_CONTROL_CAP_SET ? UVC_CONTROL_SET_CUR : 0)
+		    | (data[0] & UVC_CONTROL_CAP_AUTOUPDATE ?
+		       UVC_CONTROL_AUTO_UPDATE : 0);
 
-	if (UVC_ENTITY_TYPE(entity) == UVC_VC_EXTENSION_UNIT) {
-		/* Check if the device control information and length match
-		 * the user supplied information.
-		 */
-		ret = uvc_query_ctrl(dev, UVC_GET_LEN, ctrl->entity->id,
-				     dev->intfnum, info->selector, uvc_data, 2);
-		if (ret < 0) {
-			uvc_trace(UVC_TRACE_CONTROL,
-				"GET_LEN failed on control %pUl/%u (%d).\n",
-				info->entity, info->selector, ret);
-			goto done;
-		}
+	uvc_trace(UVC_TRACE_CONTROL, "XU control %pUl/%u queried: len %u, "
+		  "flags { get %u set %u auto %u }.\n",
+		  info->entity, info->selector, info->size,
+		  (info->flags & UVC_CONTROL_GET_CUR) ? 1 : 0,
+		  (info->flags & UVC_CONTROL_SET_CUR) ? 1 : 0,
+		  (info->flags & UVC_CONTROL_AUTO_UPDATE) ? 1 : 0);
 
-		if (info->size != le16_to_cpu(*(__le16 *)uvc_data)) {
-			uvc_trace(UVC_TRACE_CONTROL, "Control %pUl/%u size "
-				"doesn't match user supplied value.\n",
-				info->entity, info->selector);
-			ret = -EINVAL;
-			goto done;
-		}
+done:
+	kfree(data);
+	return ret;
+}
 
-		ret = uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id,
-				     dev->intfnum, info->selector, uvc_info, 1);
-		if (ret < 0) {
-			uvc_trace(UVC_TRACE_CONTROL,
-				"GET_INFO failed on control %pUl/%u (%d).\n",
-				info->entity, info->selector, ret);
-			goto done;
-		}
+/*
+ * Add control information to a given control.
+ */
+static int uvc_ctrl_add_info(struct uvc_device *dev, struct uvc_control *ctrl,
+	const struct uvc_control_info *info)
+{
+	int ret = 0;
 
-		if (((info->flags & UVC_CONTROL_GET_CUR) &&
-		    !(*uvc_info & UVC_CONTROL_CAP_GET)) ||
-		    ((info->flags & UVC_CONTROL_SET_CUR) &&
-		    !(*uvc_info & UVC_CONTROL_CAP_SET))) {
-			uvc_trace(UVC_TRACE_CONTROL, "Control %pUl/%u flags "
-				"don't match supported operations.\n",
-				info->entity, info->selector);
-			ret = -EINVAL;
-			goto done;
-		}
+	/* Clone the control info struct for this device's instance */
+	ctrl->info = kmemdup(info, sizeof(*info), GFP_KERNEL);
+	if (ctrl->info == NULL) {
+		ret = -ENOMEM;
+		goto done;
+	}
+	INIT_LIST_HEAD(&ctrl->info->mappings);
+
+	/* Allocate an array to save control values (cur, def, max, etc.) */
+	ctrl->uvc_data = kzalloc(ctrl->info->size * UVC_CTRL_DATA_LAST + 1,
+				 GFP_KERNEL);
+	if (ctrl->uvc_data == NULL) {
+		ret = -ENOMEM;
+		goto done;
 	}
-
-	ctrl->info = info;
-	ctrl->uvc_data = uvc_data;
-	ctrl->uvc_info = uvc_info;
 
 	uvc_trace(UVC_TRACE_CONTROL, "Added control %pUl/%u to device %s "
 		"entity %u\n", ctrl->info->entity, ctrl->info->selector,
-		dev->udev->devpath, entity->id);
+		dev->udev->devpath, ctrl->entity->id);
 
 done:
-	if (ret < 0)
-		kfree(uvc_data);
-
+	if (ret < 0) {
+		kfree(ctrl->uvc_data);
+		kfree(ctrl->info);
+	}
 	return ret;
 }
 
 /*
- * Add an item to the UVC control information list, and instantiate a control
- * structure for each device that supports the control.
+ * Add a control mapping to a given control.
  */
-int uvc_ctrl_add_info(struct uvc_control_info *info)
+static int __uvc_ctrl_add_mapping(struct uvc_device *dev,
+	struct uvc_control *ctrl, const struct uvc_control_mapping *mapping)
 {
-	struct uvc_control_info *ctrl;
-	struct uvc_device *dev;
-	int ret = 0;
-
-	/* Find matching controls by walking the devices, entities and
-	 * controls list.
-	 */
-	mutex_lock(&uvc_driver.ctrl_mutex);
+	struct uvc_control_mapping *map;
+	unsigned int size;
 
-	/* First check if the list contains a control matching the new one.
-	 * Bail out if it does.
+	/* Most mappings come from static kernel data and need to be duplicated.
+	 * Mappings that come from userspace will be unnecessarily duplicated,
+	 * this could be optimized.
 	 */
-	list_for_each_entry(ctrl, &uvc_driver.controls, list) {
-		if (memcmp(ctrl->entity, info->entity, 16))
-			continue;
+	map = kmemdup(mapping, sizeof(*mapping), GFP_KERNEL);
+	if (map == NULL)
+		return -ENOMEM;
 
-		if (ctrl->selector == info->selector) {
-			uvc_trace(UVC_TRACE_CONTROL,
-				"Control %pUl/%u is already defined.\n",
-				info->entity, info->selector);
-			ret = -EEXIST;
-			goto end;
-		}
-		if (ctrl->index == info->index) {
-			uvc_trace(UVC_TRACE_CONTROL,
-				"Control %pUl/%u would overwrite index %d.\n",
-				info->entity, info->selector, info->index);
-			ret = -EEXIST;
-			goto end;
-		}
+	size = sizeof(*mapping->menu_info) * mapping->menu_count;
+	map->menu_info = kmemdup(mapping->menu_info, size, GFP_KERNEL);
+	if (map->menu_info == NULL) {
+		kfree(map);
+		return -ENOMEM;
 	}
 
-	list_for_each_entry(dev, &uvc_driver.devices, list)
-		uvc_ctrl_add_ctrl(dev, info);
+	if (map->get == NULL)
+		map->get = uvc_get_le_value;
+	if (map->set == NULL)
+		map->set = uvc_set_le_value;
 
-	INIT_LIST_HEAD(&info->mappings);
-	list_add_tail(&info->list, &uvc_driver.controls);
-end:
-	mutex_unlock(&uvc_driver.ctrl_mutex);
-	return ret;
+	map->ctrl = ctrl->info;
+	list_add_tail(&map->list, &ctrl->info->mappings);
+	uvc_trace(UVC_TRACE_CONTROL,
+		"Adding mapping '%s' to control %pUl/%u.\n",
+		map->name, ctrl->info->entity, ctrl->info->selector);
+
+	return 0;
 }
 
-int uvc_ctrl_add_mapping(struct uvc_control_mapping *mapping)
+int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
+	const struct uvc_control_mapping *mapping)
 {
-	struct uvc_control_info *info;
+	struct uvc_device *dev = chain->dev;
 	struct uvc_control_mapping *map;
-	int ret = -EINVAL;
-
-	if (mapping->get == NULL)
-		mapping->get = uvc_get_le_value;
-	if (mapping->set == NULL)
-		mapping->set = uvc_set_le_value;
+	struct uvc_entity *entity;
+	struct uvc_control *ctrl;
+	int found = 0;
 
 	if (mapping->id & ~V4L2_CTRL_ID_MASK) {
-		uvc_trace(UVC_TRACE_CONTROL, "Can't add mapping '%s' with "
-			"invalid control id 0x%08x\n", mapping->name,
+		uvc_trace(UVC_TRACE_CONTROL, "Can't add mapping '%s', control "
+			"control id 0x%08x is invalid.\n", mapping->name,
 			mapping->id);
 		return -EINVAL;
 	}
 
-	mutex_lock(&uvc_driver.ctrl_mutex);
-	list_for_each_entry(info, &uvc_driver.controls, list) {
-		if (memcmp(info->entity, mapping->entity, 16) ||
-			info->selector != mapping->selector)
-			continue;
+	/* Search for the matching (GUID/CS) control in the given device */
+	list_for_each_entry(entity, &dev->entities, list) {
+		unsigned int i;
 
-		if (info->size * 8 < mapping->size + mapping->offset) {
-			uvc_trace(UVC_TRACE_CONTROL,
-				"Mapping '%s' would overflow control %pUl/%u\n",
-				mapping->name, info->entity, info->selector);
-			ret = -EOVERFLOW;
-			goto end;
-		}
+		if (!uvc_entity_match_guid(entity, mapping->entity))
+			continue;
 
-		/* Check if the list contains a mapping matching the new one.
-		 * Bail out if it does.
-		 */
-		list_for_each_entry(map, &info->mappings, list) {
-			if (map->id == mapping->id) {
-				uvc_trace(UVC_TRACE_CONTROL, "Mapping '%s' is "
-					"already defined.\n", mapping->name);
-				ret = -EEXIST;
-				goto end;
+		for (i = 0; i < entity->ncontrols; ++i) {
+			ctrl = &entity->controls[i];
+			if (ctrl->info != NULL &&
+			    ctrl->info->selector == mapping->selector) {
+				found = 1;
+				break;
 			}
 		}
 
-		mapping->ctrl = info;
-		list_add_tail(&mapping->list, &info->mappings);
-		uvc_trace(UVC_TRACE_CONTROL,
-			"Adding mapping %s to control %pUl/%u.\n",
-			mapping->name, info->entity, info->selector);
+		if (found)
+			break;
+	}
+	if (!found)
+		return -ENOENT;
 
-		ret = 0;
-		break;
+	if (mutex_lock_interruptible(&chain->ctrl_mutex))
+		return -ERESTARTSYS;
+
+	list_for_each_entry(map, &ctrl->info->mappings, list) {
+		if (mapping->id == map->id) {
+			uvc_trace(UVC_TRACE_CONTROL, "Can't add mapping '%s', "
+				"control id 0x%08x already exists.\n",
+				mapping->name, mapping->id);
+			ret = -EEXIST;
+			goto done;
+		}
 	}
-end:
-	mutex_unlock(&uvc_driver.ctrl_mutex);
+
+	ret = __uvc_ctrl_add_mapping(dev, ctrl, mapping);
+done:
+	mutex_unlock(&chain->ctrl_mutex);
 	return ret;
 }
 
@@ -1497,8 +1489,8 @@ end:
  * are currently the ones that crash the camera or unconditionally return an
  * error when queried.
  */
-static void
-uvc_ctrl_prune_entity(struct uvc_device *dev, struct uvc_entity *entity)
+static void uvc_ctrl_prune_entity(struct uvc_device *dev,
+	struct uvc_entity *entity)
 {
 	struct uvc_ctrl_blacklist {
 		struct usb_device_id id;
@@ -1555,17 +1547,67 @@ uvc_ctrl_prune_entity(struct uvc_device *dev, struct uvc_entity *entity)
 }
 
 /*
+ * Add control information and hardcoded stock control mappings to the given
+ * device.
+ */
+static void uvc_ctrl_init_ctrl(struct uvc_device *dev, struct uvc_control *ctrl)
+{
+	const struct uvc_control_info *info = uvc_ctrls;
+	const struct uvc_control_info *iend = info + ARRAY_SIZE(uvc_ctrls);
+	const struct uvc_control_mapping *mapping = uvc_ctrl_mappings;
+	const struct uvc_control_mapping *mend =
+		mapping + ARRAY_SIZE(uvc_ctrl_mappings);
+
+	/* Query XU controls for control information */
+	if (UVC_ENTITY_TYPE(ctrl->entity) == UVC_VC_EXTENSION_UNIT) {
+		struct uvc_control_info info;
+		int ret;
+
+		ret = uvc_ctrl_fill_xu_info(dev, ctrl, &info);
+		if (ret < 0)
+			return;
+
+		ret = uvc_ctrl_add_info(dev, ctrl, &info);
+		if (ret < 0) {
+			/* Skip the control */
+			uvc_trace(UVC_TRACE_CONTROL, "Failed to initialize "
+				"control %pUl/%u on device %s entity %u\n",
+				info.entity, info.selector, dev->udev->devpath,
+				ctrl->entity->id);
+			memset(ctrl, 0, sizeof(*ctrl));
+		}
+		return;
+	}
+
+	for (; info < iend; ++info) {
+		if (uvc_entity_match_guid(ctrl->entity, info->entity) &&
+		    ctrl->index == info->index) {
+			uvc_ctrl_add_info(dev, ctrl, info);
+			break;
+		 }
+	}
+
+	if (ctrl->info == NULL)
+		return;
+
+	for (; mapping < mend; ++mapping) {
+		if (uvc_entity_match_guid(ctrl->entity, mapping->entity) &&
+		    ctrl->info->selector == mapping->selector)
+			__uvc_ctrl_add_mapping(dev, ctrl, mapping);
+	}
+}
+
+/*
  * Initialize device controls.
  */
 int uvc_ctrl_init_device(struct uvc_device *dev)
 {
-	struct uvc_control_info *info;
-	struct uvc_control *ctrl;
 	struct uvc_entity *entity;
 	unsigned int i;
 
 	/* Walk the entities list and instantiate controls */
 	list_for_each_entry(entity, &dev->entities, list) {
+		struct uvc_control *ctrl;
 		unsigned int bControlSize = 0, ncontrols = 0;
 		__u8 *bmControls = NULL;
 
@@ -1580,20 +1622,22 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
 			bControlSize = entity->camera.bControlSize;
 		}
 
+		/* Remove bogus/blacklisted controls */
 		uvc_ctrl_prune_entity(dev, entity);
 
+		/* Count supported controls and allocate the controls array */
 		for (i = 0; i < bControlSize; ++i)
 			ncontrols += hweight8(bmControls[i]);
-
 		if (ncontrols == 0)
 			continue;
 
-		entity->controls = kzalloc(ncontrols*sizeof *ctrl, GFP_KERNEL);
+		entity->controls = kzalloc(ncontrols * sizeof(*ctrl),
+					   GFP_KERNEL);
 		if (entity->controls == NULL)
 			return -ENOMEM;
-
 		entity->ncontrols = ncontrols;
 
+		/* Initialize all supported controls */
 		ctrl = entity->controls;
 		for (i = 0; i < bControlSize * 8; ++i) {
 			if (uvc_test_bit(bmControls, i) == 0)
@@ -1601,81 +1645,48 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
 
 			ctrl->entity = entity;
 			ctrl->index = i;
+
+			uvc_ctrl_init_ctrl(dev, ctrl);
 			ctrl++;
 		}
 	}
 
-	/* Walk the controls info list and associate them with the device
-	 * controls, then add the device to the global device list. This has
-	 * to be done while holding the controls lock, to make sure
-	 * uvc_ctrl_add_info() will not get called in-between.
-	 */
-	mutex_lock(&uvc_driver.ctrl_mutex);
-	list_for_each_entry(info, &uvc_driver.controls, list)
-		uvc_ctrl_add_ctrl(dev, info);
-
-	list_add_tail(&dev->list, &uvc_driver.devices);
-	mutex_unlock(&uvc_driver.ctrl_mutex);
-
 	return 0;
 }
 
 /*
  * Cleanup device controls.
  */
-void uvc_ctrl_cleanup_device(struct uvc_device *dev)
+static void uvc_ctrl_cleanup_mappings(struct uvc_device *dev,
+	struct uvc_control *ctrl)
 {
-	struct uvc_entity *entity;
-	unsigned int i;
+	struct uvc_control_mapping *mapping, *nm;
 
-	/* Remove the device from the global devices list */
-	mutex_lock(&uvc_driver.ctrl_mutex);
-	if (dev->list.next != NULL)
-		list_del(&dev->list);
-	mutex_unlock(&uvc_driver.ctrl_mutex);
-
-	list_for_each_entry(entity, &dev->entities, list) {
-		for (i = 0; i < entity->ncontrols; ++i)
-			kfree(entity->controls[i].uvc_data);
-
-		kfree(entity->controls);
+	list_for_each_entry_safe(mapping, nm, &ctrl->info->mappings, list) {
+		list_del(&mapping->list);
+		kfree(mapping->menu_info);
+		kfree(mapping);
 	}
 }
 
-void uvc_ctrl_cleanup(void)
+void uvc_ctrl_cleanup_device(struct uvc_device *dev)
 {
-	struct uvc_control_info *info;
-	struct uvc_control_info *ni;
-	struct uvc_control_mapping *mapping;
-	struct uvc_control_mapping *nm;
+	struct uvc_entity *entity;
+	unsigned int i;
 
-	list_for_each_entry_safe(info, ni, &uvc_driver.controls, list) {
-		if (!(info->flags & UVC_CONTROL_EXTENSION))
-			continue;
+	/* Free controls and control mappings for all entities. */
+	list_for_each_entry(entity, &dev->entities, list) {
+		for (i = 0; i < entity->ncontrols; ++i) {
+			struct uvc_control *ctrl = &entity->controls[i];
+
+			if (ctrl->info == NULL)
+				continue;
 
-		list_for_each_entry_safe(mapping, nm, &info->mappings, list) {
-			list_del(&mapping->list);
-			kfree(mapping->menu_info);
-			kfree(mapping);
+			uvc_ctrl_cleanup_mappings(dev, ctrl);
+			kfree(ctrl->uvc_data);
+			kfree(ctrl->info);
 		}
 
-		list_del(&info->list);
-		kfree(info);
+		kfree(entity->controls);
 	}
 }
-
-void uvc_ctrl_init(void)
-{
-	struct uvc_control_info *ctrl = uvc_ctrls;
-	struct uvc_control_info *cend = ctrl + ARRAY_SIZE(uvc_ctrls);
-	struct uvc_control_mapping *mapping = uvc_ctrl_mappings;
-	struct uvc_control_mapping *mend =
-		mapping + ARRAY_SIZE(uvc_ctrl_mappings);
-
-	for (; ctrl < cend; ++ctrl)
-		uvc_ctrl_add_info(ctrl);
-
-	for (; mapping < mend; ++mapping)
-		uvc_ctrl_add_mapping(mapping);
-}
-
diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index dc035c0..71efda7 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -41,9 +41,6 @@
 #define DRIVER_AUTHOR		"Laurent Pinchart " \
 				"<laurent.pinchart@ideasonboard.com>"
 #define DRIVER_DESC		"USB Video Class driver"
-#ifndef DRIVER_VERSION
-#define DRIVER_VERSION		"v0.1.0"
-#endif
 
 unsigned int uvc_clock_param = CLOCK_MONOTONIC;
 unsigned int uvc_no_drop_param;
@@ -2289,12 +2286,6 @@ static int __init uvc_init(void)
 {
 	int result;
 
-	INIT_LIST_HEAD(&uvc_driver.devices);
-	INIT_LIST_HEAD(&uvc_driver.controls);
-	mutex_init(&uvc_driver.ctrl_mutex);
-
-	uvc_ctrl_init();
-
 	result = usb_register(&uvc_driver.driver);
 	if (result == 0)
 		printk(KERN_INFO DRIVER_DESC " (" DRIVER_VERSION ")\n");
@@ -2304,7 +2295,6 @@ static int __init uvc_init(void)
 static void __exit uvc_cleanup(void)
 {
 	usb_deregister(&uvc_driver.driver);
-	uvc_ctrl_cleanup();
 }
 
 module_init(uvc_init);
diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index 8cecd1c..4a51048 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -31,7 +31,8 @@
 /* ------------------------------------------------------------------------
  * UVC ioctls
  */
-static int uvc_ioctl_ctrl_map(struct uvc_xu_control_mapping *xmap, int old)
+static int uvc_ioctl_ctrl_map(struct uvc_video_chain *chain,
+	struct uvc_xu_control_mapping *xmap, int old)
 {
 	struct uvc_control_mapping *map;
 	unsigned int size;
@@ -58,6 +59,8 @@ static int uvc_ioctl_ctrl_map(struct uvc_xu_control_mapping *xmap, int old)
 
 	case V4L2_CTRL_TYPE_MENU:
 		if (old) {
+			uvc_trace(UVC_TRACE_CONTROL, "V4L2_CTRL_TYPE_MENU not "
+				  "supported for UVCIOC_CTRL_MAP_OLD.\n");
 			ret = -EINVAL;
 			goto done;
 		}
@@ -78,17 +81,17 @@ static int uvc_ioctl_ctrl_map(struct uvc_xu_control_mapping *xmap, int old)
 		break;
 
 	default:
+		uvc_trace(UVC_TRACE_CONTROL, "Unsupported V4L2 control type "
+			  "%u.\n", xmap->v4l2_type);
 		ret = -EINVAL;
 		goto done;
 	}
 
-	ret = uvc_ctrl_add_mapping(map);
+	ret = uvc_ctrl_add_mapping(chain, map);
 
 done:
-	if (ret < 0) {
-		kfree(map->menu_info);
-		kfree(map);
-	}
+	kfree(map->menu_info);
+	kfree(map);
 
 	return ret;
 }
@@ -1021,42 +1024,19 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 
 	/* Dynamic controls. */
 	case UVCIOC_CTRL_ADD:
-	{
-		struct uvc_xu_control_info *xinfo = arg;
-		struct uvc_control_info *info;
-
+		/* Legacy ioctl, kept for API compatibility reasons */
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 
-		if (xinfo->size == 0)
-			return -EINVAL;
-
-		info = kzalloc(sizeof *info, GFP_KERNEL);
-		if (info == NULL)
-			return -ENOMEM;
-
-		memcpy(info->entity, xinfo->entity, sizeof info->entity);
-		info->index = xinfo->index;
-		info->selector = xinfo->selector;
-		info->size = xinfo->size;
-		info->flags = xinfo->flags;
-
-		info->flags |= UVC_CONTROL_GET_MIN | UVC_CONTROL_GET_MAX |
-			       UVC_CONTROL_GET_RES | UVC_CONTROL_GET_DEF |
-			       UVC_CONTROL_EXTENSION;
-
-		ret = uvc_ctrl_add_info(info);
-		if (ret < 0)
-			kfree(info);
-		break;
-	}
+		return -EEXIST;
 
 	case UVCIOC_CTRL_MAP_OLD:
 	case UVCIOC_CTRL_MAP:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 
-		return uvc_ioctl_ctrl_map(arg, cmd == UVCIOC_CTRL_MAP_OLD);
+		return uvc_ioctl_ctrl_map(chain, arg,
+					  cmd == UVCIOC_CTRL_MAP_OLD);
 
 	case UVCIOC_CTRL_GET:
 		return uvc_xu_ctrl_query(chain, arg, 0);
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index f890133..34637fb 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -27,8 +27,6 @@
 #define UVC_CONTROL_RESTORE	(1 << 6)
 /* Control can be updated by the camera. */
 #define UVC_CONTROL_AUTO_UPDATE	(1 << 7)
-/* Control is an extension unit control. */
-#define UVC_CONTROL_EXTENSION	(1 << 8)
 
 #define UVC_CONTROL_GET_RANGE	(UVC_CONTROL_GET_CUR | UVC_CONTROL_GET_MIN | \
 				 UVC_CONTROL_GET_MAX | UVC_CONTROL_GET_RES | \
@@ -159,7 +157,8 @@ struct uvc_xu_control {
  * Driver specific constants.
  */
 
-#define DRIVER_VERSION_NUMBER	KERNEL_VERSION(0, 1, 0)
+#define DRIVER_VERSION_NUMBER	KERNEL_VERSION(1, 0, 0)
+#define DRIVER_VERSION		"v1.0.0"
 
 /* Number of isochronous URBs. */
 #define UVC_URBS		5
@@ -198,11 +197,10 @@ struct uvc_device;
  * structures to maximize cache efficiency.
  */
 struct uvc_control_info {
-	struct list_head list;
 	struct list_head mappings;
 
 	__u8 entity[16];
-	__u8 index;
+	__u8 index;	/* Bit index in bmControls */
 	__u8 selector;
 
 	__u16 size;
@@ -245,7 +243,6 @@ struct uvc_control {
 	     cached : 1;
 
 	__u8 *uvc_data;
-	__u8 *uvc_info;
 };
 
 struct uvc_format_desc {
@@ -474,7 +471,6 @@ struct uvc_device {
 	char name[32];
 
 	enum uvc_device_state state;
-	struct list_head list;
 	atomic_t users;
 
 	/* Video control interface */
@@ -509,11 +505,6 @@ struct uvc_fh {
 
 struct uvc_driver {
 	struct usb_driver driver;
-
-	struct list_head devices;	/* struct uvc_device list */
-	struct list_head controls;	/* struct uvc_control_info list */
-	struct mutex ctrl_mutex;	/* protects controls and devices
-					   lists */
 };
 
 /* ------------------------------------------------------------------------
@@ -615,13 +606,11 @@ extern struct uvc_control *uvc_find_control(struct uvc_video_chain *chain,
 extern int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 		struct v4l2_queryctrl *v4l2_ctrl);
 
-extern int uvc_ctrl_add_info(struct uvc_control_info *info);
-extern int uvc_ctrl_add_mapping(struct uvc_control_mapping *mapping);
+extern int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
+		const struct uvc_control_mapping *mapping);
 extern int uvc_ctrl_init_device(struct uvc_device *dev);
 extern void uvc_ctrl_cleanup_device(struct uvc_device *dev);
 extern int uvc_ctrl_resume_device(struct uvc_device *dev);
-extern void uvc_ctrl_init(void);
-extern void uvc_ctrl_cleanup(void);
 
 extern int uvc_ctrl_begin(struct uvc_video_chain *chain);
 extern int __uvc_ctrl_commit(struct uvc_video_chain *chain, int rollback);
-- 
1.7.2.2

