Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:56496 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754249AbdBGQ3q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Feb 2017 11:29:46 -0500
Received: from axis700.grange ([81.173.166.100]) by mail.gmx.com (mrgmx101
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0LqE5k-1bxNyi37Mu-00dleN for
 <linux-media@vger.kernel.org>; Tue, 07 Feb 2017 17:29:44 +0100
Received: from 200r.grange (200r.grange [192.168.1.16])
        by axis700.grange (Postfix) with ESMTP id 5F3EF8B11D
        for <linux-media@vger.kernel.org>; Tue,  7 Feb 2017 17:29:37 +0100 (CET)
From: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v2 4/4] uvcvideo: support compound controls
Date: Tue,  7 Feb 2017 17:29:36 +0100
Message-Id: <1486484976-17365-5-git-send-email-guennadi.liakhovetski@intel.com>
In-Reply-To: <1486484976-17365-1-git-send-email-guennadi.liakhovetski@intel.com>
References: <1486484976-17365-1-git-send-email-guennadi.liakhovetski@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Compound controls can transfer arbitrary amount of data, unlike
traditional controls, which are limited to a single integer
parameter. They can also be used to map XU controls with large
payloads. Note, that events can only deliver up to 64 bits of
data. If an event is associated with a compound control with
more data, the data has to be read out separately after the event
has been dequeued.

Change-Id: I170a07d6172acbd096416e29da9e38d0d68e8f8c
Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Tracked-On:
---
 drivers/media/usb/uvc/uvc_ctrl.c | 123 ++++++++++++++++++++++++++++++++-------
 drivers/media/usb/uvc/uvc_v4l2.c |   6 +-
 drivers/media/usb/uvc/uvcvideo.h |   3 +-
 3 files changed, 108 insertions(+), 24 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 98f2fed..4202eac 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1008,9 +1008,10 @@ static int uvc_ctrl_populate_cache(struct uvc_video_chain *chain,
 
 static int __uvc_ctrl_get(struct uvc_video_chain *chain,
 	struct uvc_control *ctrl, struct uvc_control_mapping *mapping,
-	s32 *value)
+	void *value, size_t size)
 {
 	struct uvc_menu_info *menu;
+	s32 *value32;
 	unsigned int i;
 	int ret;
 
@@ -1029,14 +1030,14 @@ static int __uvc_ctrl_get(struct uvc_video_chain *chain,
 	}
 
 	mapping->get(mapping, UVC_GET_CUR,
-		uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
-		value, sizeof(*value));
+		uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT), value, size);
 
 	if (mapping->v4l2_type == V4L2_CTRL_TYPE_MENU) {
+		value32 = value;
 		menu = mapping->menu_info;
 		for (i = 0; i < mapping->menu_count; ++i, ++menu) {
-			if (menu->value == *value) {
-				*value = i;
+			if (menu->value == *value32) {
+				*value32 = i;
 				break;
 			}
 		}
@@ -1071,7 +1072,9 @@ static int __uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 				   &master_map, &master_ctrl, 0);
 	if (master_ctrl && (master_ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR)) {
 		s32 val;
-		int ret = __uvc_ctrl_get(chain, master_ctrl, master_map, &val);
+		/* No compound master controls so far */
+		int ret = __uvc_ctrl_get(chain, master_ctrl, master_map,
+					 &val, sizeof(val));
 		if (ret < 0)
 			return ret;
 
@@ -1290,7 +1293,8 @@ static void __uvc_ctrl_send_slave_event(struct uvc_fh *handle,
 	if (ctrl == NULL)
 		return;
 
-	if (__uvc_ctrl_get(handle->chain, ctrl, mapping, &val) == 0)
+	/* cannot send compound events, the value must be read separately */
+	if (!__uvc_ctrl_get(handle->chain, ctrl, mapping, &val, sizeof(val)))
 		changes |= V4L2_EVENT_CTRL_CH_VALUE;
 
 	uvc_ctrl_send_event(handle, ctrl, mapping, val, changes);
@@ -1319,9 +1323,19 @@ static void uvc_ctrl_status_event_work(struct work_struct *work)
 		goto free;
 
 	list_for_each_entry(mapping, &ctrl->info.mappings, list) {
-		s32 value;
+		size_t size;
+		s32 value32;
+		void *value;
 
-		mapping->get(mapping, UVC_GET_CUR, data, &value, sizeof(value));
+		if (mapping->v4l2_type >= V4L2_CTRL_COMPOUND_TYPES) {
+			value = mapping->compound;
+			size = DIV_ROUND_UP(mapping->size, 8);
+		} else {
+			value = &value32;
+			size = sizeof(value32);
+		}
+
+		mapping->get(mapping, UVC_GET_CUR, data, value, size);
 
 		for (i = 0; i < ARRAY_SIZE(mapping->slave_ids); ++i) {
 			if (!mapping->slave_ids[i])
@@ -1336,13 +1350,15 @@ static void uvc_ctrl_status_event_work(struct work_struct *work)
 			unsigned int i;
 
 			for (i = 0; i < mapping->menu_count; ++i, ++menu)
-				if (menu->value == value) {
-					value = i;
+				if (menu->value == value32) {
+					value32 = i;
 					break;
 				}
+		} else if (mapping->v4l2_type >= V4L2_CTRL_COMPOUND_TYPES) {
+			memcpy(&value32, value, min(sizeof(value32), size));
 		}
 
-		uvc_ctrl_send_event(handle, ctrl, mapping, value,
+		uvc_ctrl_send_event(handle, ctrl, mapping, value32,
 				    V4L2_EVENT_CTRL_CH_VALUE);
 	}
 
@@ -1461,7 +1477,9 @@ static int uvc_ctrl_add_event(struct v4l2_subscribed_event *sev, unsigned elems)
 		u32 changes = V4L2_EVENT_CTRL_CH_FLAGS;
 		s32 val = 0;
 
-		if (__uvc_ctrl_get(handle->chain, ctrl, mapping, &val) == 0)
+		/* events can only deliver integers so far */
+		if (__uvc_ctrl_get(handle->chain, ctrl, mapping,
+				   &val, sizeof(val)) == 0)
 			changes |= V4L2_EVENT_CTRL_CH_VALUE;
 
 		uvc_ctrl_fill_event(handle->chain, &ev, ctrl, mapping, val,
@@ -1599,12 +1617,33 @@ int uvc_ctrl_get(struct uvc_video_chain *chain,
 {
 	struct uvc_control *ctrl;
 	struct uvc_control_mapping *mapping;
+	size_t size;
+	int ret;
 
 	ctrl = uvc_find_control(chain, xctrl->id, &mapping);
 	if (ctrl == NULL)
 		return -EINVAL;
 
-	return __uvc_ctrl_get(chain, ctrl, mapping, &xctrl->value);
+	if (mapping->v4l2_type < V4L2_CTRL_COMPOUND_TYPES)
+		return __uvc_ctrl_get(chain, ctrl, mapping, &xctrl->value,
+				      sizeof(xctrl->value));
+
+	size = DIV_ROUND_UP(mapping->size, 8);
+
+	if (size < xctrl->size) {
+		uvc_warn_once(chain->dev, UVC_WARN_MINMAX,
+			      "truncating %u to %zu for \"%s\"",
+			      xctrl->size, size, mapping->name);
+		xctrl->size = size;
+	}
+
+	ret = __uvc_ctrl_get(chain, ctrl, mapping,
+			     mapping->compound, size);
+	if (ret < 0)
+		return ret;
+
+	return copy_to_user(xctrl->ptr, mapping->compound, xctrl->size) ?
+		-EFAULT : 0;
 }
 
 int uvc_ctrl_set(struct uvc_fh *handle,
@@ -1614,6 +1653,8 @@ int uvc_ctrl_set(struct uvc_fh *handle,
 	struct uvc_control *ctrl;
 	struct uvc_control_mapping *mapping;
 	s32 value;
+	void *value_p = &value;
+	size_t size = sizeof(value);
 	u32 step;
 	s32 min;
 	s32 max;
@@ -1697,6 +1738,22 @@ int uvc_ctrl_set(struct uvc_fh *handle,
 
 		break;
 
+	case V4L2_CTRL_COMPOUND_TYPES...V4L2_CTRL_TYPE_U32:
+		value_p = mapping->compound;
+
+		size = DIV_ROUND_UP(mapping->size, 8);
+		if (size < xctrl->size)
+			uvc_warn_once(chain->dev, UVC_WARN_MINMAX,
+				      "truncating %u to %zu for \"%s\"",
+				      xctrl->size, size, mapping->name);
+		else
+			size = xctrl->size;
+
+		if (copy_from_user(value_p, xctrl->ptr, size) != 0)
+			return -EFAULT;
+
+		break;
+
 	default:
 		value = xctrl->value;
 		break;
@@ -1731,7 +1788,7 @@ int uvc_ctrl_set(struct uvc_fh *handle,
 	}
 
 	mapping->set(mapping, uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
-		     &value, sizeof(value));
+		     value_p, size);
 
 	ctrl->dirty = 1;
 	ctrl->modified = 1;
@@ -1835,11 +1892,12 @@ static int uvc_ctrl_fill_xu_info(struct uvc_device *dev,
 	uvc_ctrl_fixup_xu_info(dev, ctrl, info);
 
 	uvc_trace(UVC_TRACE_CONTROL, "XU control %pUl/%u queried: len %u, "
-		  "flags { get %u set %u auto %u }.\n",
+		  "flags { get %u set %u auto %u async %u }.\n",
 		  info->entity, info->selector, info->size,
 		  (info->flags & UVC_CTRL_FLAG_GET_CUR) ? 1 : 0,
 		  (info->flags & UVC_CTRL_FLAG_SET_CUR) ? 1 : 0,
-		  (info->flags & UVC_CTRL_FLAG_AUTO_UPDATE) ? 1 : 0);
+		  (info->flags & UVC_CTRL_FLAG_AUTO_UPDATE) ? 1 : 0,
+		  (info->flags & UVC_CTRL_FLAG_ASYNCHRONOUS) ? 1 : 0);
 
 done:
 	kfree(data);
@@ -1871,9 +1929,10 @@ static int uvc_ctrl_init_xu_ctrl(struct uvc_device *dev,
 	return ret;
 }
 
-int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
+int uvc_xu_ctrl_query(struct uvc_fh *handle,
 	struct uvc_xu_control_query *xqry)
 {
+	struct uvc_video_chain *chain = handle->chain;
 	struct uvc_entity *entity;
 	struct uvc_control *ctrl;
 	unsigned int i, found = 0;
@@ -1941,6 +2000,15 @@ int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
 		break;
 	case UVC_SET_CUR:
 		reqflags = UVC_CTRL_FLAG_SET_CUR;
+
+		if (ctrl->info.flags & UVC_CTRL_FLAG_ASYNCHRONOUS) {
+			if (ctrl->handle) {
+				ret = -EBUSY;
+				goto done;
+			}
+			ctrl->handle = handle;
+		}
+
 		break;
 	case UVC_GET_LEN:
 		size = 2;
@@ -2089,9 +2157,14 @@ static int __uvc_ctrl_add_mapping(struct uvc_device *dev,
 
 	size = sizeof(*mapping->menu_info) * mapping->menu_count;
 	map->menu_info = kmemdup(mapping->menu_info, size, GFP_KERNEL);
-	if (map->menu_info == NULL) {
-		kfree(map);
-		return -ENOMEM;
+	if (map->menu_info == NULL)
+		goto free_map;
+
+	if (map->v4l2_type >= V4L2_CTRL_COMPOUND_TYPES) {
+		map->compound = kmalloc(DIV_ROUND_UP(map->size, 8),
+					    GFP_KERNEL);
+		if (map->compound == NULL)
+			goto free_info;
 	}
 
 	if (map->get == NULL)
@@ -2105,6 +2178,12 @@ static int __uvc_ctrl_add_mapping(struct uvc_device *dev,
 		map->name, ctrl->info.entity, ctrl->info.selector);
 
 	return 0;
+
+free_info:
+	kfree(map->menu_info);
+free_map:
+	kfree(map);
+	return -ENOMEM;
 }
 
 int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
@@ -2302,6 +2381,7 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
 
 	spin_lock_init(&dev->async_ctrl.lock);
 	INIT_WORK(&dev->async_ctrl.work, uvc_ctrl_status_event_work);
+	dev->async_ctrl.data = NULL;
 
 	/* Walk the entities list and instantiate controls */
 	list_for_each_entry(entity, &dev->entities, list) {
@@ -2362,6 +2442,7 @@ static void uvc_ctrl_cleanup_mappings(struct uvc_device *dev,
 	list_for_each_entry_safe(mapping, nm, &ctrl->info.mappings, list) {
 		list_del(&mapping->list);
 		kfree(mapping->menu_info);
+		kfree(mapping->compound);
 		kfree(mapping);
 	}
 }
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 06be5f6..ba4750b 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -57,6 +57,7 @@ static int uvc_ioctl_ctrl_map(struct uvc_video_chain *chain,
 	case V4L2_CTRL_TYPE_INTEGER:
 	case V4L2_CTRL_TYPE_BOOLEAN:
 	case V4L2_CTRL_TYPE_BUTTON:
+	case V4L2_CTRL_COMPOUND_TYPES...V4L2_CTRL_TYPE_U32:
 		break;
 
 	case V4L2_CTRL_TYPE_MENU:
@@ -1256,7 +1257,7 @@ static long uvc_ioctl_default(struct file *file, void *fh, bool valid_prio,
 		return uvc_ioctl_ctrl_map(chain, arg);
 
 	case UVCIOC_CTRL_QUERY:
-		return uvc_xu_ctrl_query(chain, arg);
+		return uvc_xu_ctrl_query(handle, arg);
 
 	default:
 		return -ENOTTY;
@@ -1274,6 +1275,7 @@ struct uvc_xu_control_mapping32 {
 	__u8 offset;
 	__u32 v4l2_type;
 	__u32 data_type;
+	compat_caddr_t compound;
 
 	compat_caddr_t menu_info;
 	__u32 menu_count;
@@ -1390,7 +1392,7 @@ static long uvc_v4l2_compat_ioctl32(struct file *file,
 		ret = uvc_v4l2_get_xu_query(&karg.xqry, up);
 		if (ret)
 			return ret;
-		ret = uvc_xu_ctrl_query(handle->chain, &karg.xqry);
+		ret = uvc_xu_ctrl_query(handle, &karg.xqry);
 		if (ret)
 			return ret;
 		ret = uvc_v4l2_put_xu_query(&karg.xqry, up);
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 2ef135a..b618caa 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -215,6 +215,7 @@ struct uvc_control_mapping {
 	__u8 offset;
 	enum v4l2_ctrl_type v4l2_type;
 	__u32 data_type;
+	void *compound;
 
 	struct uvc_menu_info *menu_info;
 	__u32 menu_count;
@@ -753,7 +754,7 @@ extern int uvc_ctrl_get(struct uvc_video_chain *chain,
 extern int uvc_ctrl_set(struct uvc_fh *handle,
 		struct v4l2_ext_control *xctrl);
 
-extern int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
+extern int uvc_xu_ctrl_query(struct uvc_fh *handle,
 		struct uvc_xu_control_query *xqry);
 
 /* Utility functions */
-- 
1.9.3

