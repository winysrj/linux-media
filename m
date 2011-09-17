Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58266 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417Ab1IQPeE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Sep 2011 11:34:04 -0400
Received: from localhost.localdomain (unknown [91.178.181.94])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 846B435A9D
	for <linux-media@vger.kernel.org>; Sat, 17 Sep 2011 15:34:02 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/5] uvcvideo: Remove deprecated UVCIOC ioctls
Date: Sat, 17 Sep 2011 17:33:59 +0200
Message-Id: <1316273642-3624-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1316273642-3624-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1316273642-3624-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The UVCIOC_CTRL_ADD, UVCIOC_CTRL_MAP_OLD, UVCIOC_CTRL_GET and
UVCIOC_CTRL_SET ioctls are deprecated and were scheduled for removal for
v2.6.42. As v2.6.42 == v3.2, remove them.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/feature-removal-schedule.txt |   23 -------
 drivers/media/video/uvc/uvc_v4l2.c         |   54 +--------------
 drivers/media/video/uvc/uvcvideo.h         |  100 +--------------------------
 3 files changed, 6 insertions(+), 171 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 4dc4654..ead08f1 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -495,29 +495,6 @@ Who:	Jean Delvare <khali@linux-fr.org>
 
 ----------------------------
 
-What:	Support for UVCIOC_CTRL_ADD in the uvcvideo driver
-When:	3.2
-Why:	The information passed to the driver by this ioctl is now queried
-	dynamically from the device.
-Who:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
-
-----------------------------
-
-What:	Support for UVCIOC_CTRL_MAP_OLD in the uvcvideo driver
-When:	3.2
-Why:	Used only by applications compiled against older driver versions.
-	Superseded by UVCIOC_CTRL_MAP which supports V4L2 menu controls.
-Who:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
-
-----------------------------
-
-What:	Support for UVCIOC_CTRL_GET and UVCIOC_CTRL_SET in the uvcvideo driver
-When:	3.2
-Why:	Superseded by the UVCIOC_CTRL_QUERY ioctl.
-Who:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
-
-----------------------------
-
 What:	Support for driver specific ioctls in the pwc driver (everything
 	defined in media/pwc-ioctl.h)
 When:	3.3
diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index ea71d5f..dadf11f 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -32,7 +32,7 @@
  * UVC ioctls
  */
 static int uvc_ioctl_ctrl_map(struct uvc_video_chain *chain,
-	struct uvc_xu_control_mapping *xmap, int old)
+	struct uvc_xu_control_mapping *xmap)
 {
 	struct uvc_control_mapping *map;
 	unsigned int size;
@@ -58,13 +58,6 @@ static int uvc_ioctl_ctrl_map(struct uvc_video_chain *chain,
 		break;
 
 	case V4L2_CTRL_TYPE_MENU:
-		if (old) {
-			uvc_trace(UVC_TRACE_CONTROL, "V4L2_CTRL_TYPE_MENU not "
-				  "supported for UVCIOC_CTRL_MAP_OLD.\n");
-			ret = -EINVAL;
-			goto done;
-		}
-
 		size = xmap->menu_count * sizeof(*map->menu_info);
 		map->menu_info = kmalloc(size, GFP_KERNEL);
 		if (map->menu_info == NULL) {
@@ -538,20 +531,6 @@ static int uvc_v4l2_release(struct file *file)
 	return 0;
 }
 
-static void uvc_v4l2_ioctl_warn(void)
-{
-	static int warned;
-
-	if (warned)
-		return;
-
-	uvc_printk(KERN_INFO, "Deprecated UVCIOC_CTRL_{ADD,MAP_OLD,GET,SET} "
-		   "ioctls will be removed in 2.6.42.\n");
-	uvc_printk(KERN_INFO, "See http://www.ideasonboard.org/uvc/upgrade/ "
-		   "for upgrade instructions.\n");
-	warned = 1;
-}
-
 static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 {
 	struct video_device *vdev = video_devdata(file);
@@ -1032,37 +1011,8 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		uvc_trace(UVC_TRACE_IOCTL, "Unsupported ioctl 0x%08x\n", cmd);
 		return -EINVAL;
 
-	/* Dynamic controls. UVCIOC_CTRL_ADD, UVCIOC_CTRL_MAP_OLD,
-	 * UVCIOC_CTRL_GET and UVCIOC_CTRL_SET are deprecated and scheduled for
-	 * removal in 2.6.42.
-	 */
-	case __UVCIOC_CTRL_ADD:
-		uvc_v4l2_ioctl_warn();
-		return -EEXIST;
-
-	case __UVCIOC_CTRL_MAP_OLD:
-		uvc_v4l2_ioctl_warn();
-	case __UVCIOC_CTRL_MAP:
 	case UVCIOC_CTRL_MAP:
-		return uvc_ioctl_ctrl_map(chain, arg,
-					  cmd == __UVCIOC_CTRL_MAP_OLD);
-
-	case __UVCIOC_CTRL_GET:
-	case __UVCIOC_CTRL_SET:
-	{
-		struct uvc_xu_control *xctrl = arg;
-		struct uvc_xu_control_query xqry = {
-			.unit		= xctrl->unit,
-			.selector	= xctrl->selector,
-			.query		= cmd == __UVCIOC_CTRL_GET
-					? UVC_GET_CUR : UVC_SET_CUR,
-			.size		= xctrl->size,
-			.data		= xctrl->data,
-		};
-
-		uvc_v4l2_ioctl_warn();
-		return uvc_xu_ctrl_query(chain, &xqry);
-	}
+		return uvc_ioctl_ctrl_map(chain, arg);
 
 	case UVCIOC_CTRL_QUERY:
 		return uvc_xu_ctrl_query(chain, arg);
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index cbdd49b..e3aec87 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -1,106 +1,16 @@
 #ifndef _USB_VIDEO_H_
 #define _USB_VIDEO_H_
 
-#include <linux/kernel.h>
-#include <linux/videodev2.h>
-
-#ifndef __KERNEL__
-/*
- * This header provides binary compatibility with applications using the private
- * uvcvideo API. This API is deprecated and will be removed in 2.6.42.
- * Applications should be recompiled against the public linux/uvcvideo.h header.
- */
-#warn "The uvcvideo.h header is deprecated, use linux/uvcvideo.h instead."
-
-/*
- * Dynamic controls
- */
-
-/* Data types for UVC control data */
-#define UVC_CTRL_DATA_TYPE_RAW		0
-#define UVC_CTRL_DATA_TYPE_SIGNED	1
-#define UVC_CTRL_DATA_TYPE_UNSIGNED	2
-#define UVC_CTRL_DATA_TYPE_BOOLEAN	3
-#define UVC_CTRL_DATA_TYPE_ENUM		4
-#define UVC_CTRL_DATA_TYPE_BITMASK	5
-
-/* Control flags */
-#define UVC_CONTROL_SET_CUR	(1 << 0)
-#define UVC_CONTROL_GET_CUR	(1 << 1)
-#define UVC_CONTROL_GET_MIN	(1 << 2)
-#define UVC_CONTROL_GET_MAX	(1 << 3)
-#define UVC_CONTROL_GET_RES	(1 << 4)
-#define UVC_CONTROL_GET_DEF	(1 << 5)
-#define UVC_CONTROL_RESTORE	(1 << 6)
-#define UVC_CONTROL_AUTO_UPDATE	(1 << 7)
-
-#define UVC_CONTROL_GET_RANGE	(UVC_CONTROL_GET_CUR | UVC_CONTROL_GET_MIN | \
-				 UVC_CONTROL_GET_MAX | UVC_CONTROL_GET_RES | \
-				 UVC_CONTROL_GET_DEF)
-
-struct uvc_menu_info {
-	__u32 value;
-	__u8 name[32];
-};
-
-struct uvc_xu_control_mapping {
-	__u32 id;
-	__u8 name[32];
-	__u8 entity[16];
-	__u8 selector;
-
-	__u8 size;
-	__u8 offset;
-	__u32 v4l2_type;
-	__u32 data_type;
-
-	struct uvc_menu_info __user *menu_info;
-	__u32 menu_count;
-
-	__u32 reserved[4];
-};
-
-#endif
-
-struct uvc_xu_control_info {
-	__u8 entity[16];
-	__u8 index;
-	__u8 selector;
-	__u16 size;
-	__u32 flags;
-};
-
-struct uvc_xu_control_mapping_old {
-	__u8 reserved[64];
-};
-
-struct uvc_xu_control {
-	__u8 unit;
-	__u8 selector;
-	__u16 size;
-	__u8 __user *data;
-};
-
 #ifndef __KERNEL__
-#define UVCIOC_CTRL_ADD		_IOW('U', 1, struct uvc_xu_control_info)
-#define UVCIOC_CTRL_MAP_OLD	_IOWR('U', 2, struct uvc_xu_control_mapping_old)
-#define UVCIOC_CTRL_MAP		_IOWR('U', 2, struct uvc_xu_control_mapping)
-#define UVCIOC_CTRL_GET		_IOWR('U', 3, struct uvc_xu_control)
-#define UVCIOC_CTRL_SET		_IOW('U', 4, struct uvc_xu_control)
-#else
-#define __UVCIOC_CTRL_ADD	_IOW('U', 1, struct uvc_xu_control_info)
-#define __UVCIOC_CTRL_MAP_OLD	_IOWR('U', 2, struct uvc_xu_control_mapping_old)
-#define __UVCIOC_CTRL_MAP	_IOWR('U', 2, struct uvc_xu_control_mapping)
-#define __UVCIOC_CTRL_GET	_IOWR('U', 3, struct uvc_xu_control)
-#define __UVCIOC_CTRL_SET	_IOW('U', 4, struct uvc_xu_control)
-#endif
-
-#ifdef __KERNEL__
+#error "The uvcvideo.h header is deprecated, use linux/uvcvideo.h instead."
+#endif /* __KERNEL__ */
 
+#include <linux/kernel.h>
 #include <linux/poll.h>
 #include <linux/usb.h>
 #include <linux/usb/video.h>
 #include <linux/uvcvideo.h>
+#include <linux/videodev2.h>
 #include <media/media-device.h>
 #include <media/v4l2-device.h>
 
@@ -698,6 +608,4 @@ extern struct usb_host_endpoint *uvc_find_endpoint(
 void uvc_video_decode_isight(struct urb *urb, struct uvc_streaming *stream,
 		struct uvc_buffer *buf);
 
-#endif /* __KERNEL__ */
-
 #endif
-- 
1.7.3.4

