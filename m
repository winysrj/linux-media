Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:42465 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbZISBGW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 21:06:22 -0400
Received: by ewy2 with SMTP id 2so1774105ewy.17
        for <linux-media@vger.kernel.org>; Fri, 18 Sep 2009 18:06:25 -0700 (PDT)
Message-ID: <4AB43041.6050001@gmail.com>
Date: Sat, 19 Sep 2009 03:13:37 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@skynet.be>,
	linux-uvc-devel@lists.berlios.de, linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] uvc: kmalloc failure ignored in uvc_ctrl_add_ctrl()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Produce an error if kmalloc() fails.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found with sed: http://kernelnewbies.org/roelkluin

Build tested. Please review

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index c3225a5..dda80b5 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -1189,7 +1189,7 @@ int uvc_ctrl_resume_device(struct uvc_device *dev)
  * Control and mapping handling
  */
 
-static void uvc_ctrl_add_ctrl(struct uvc_device *dev,
+static int uvc_ctrl_add_ctrl(struct uvc_device *dev,
 	struct uvc_control_info *info)
 {
 	struct uvc_entity *entity;
@@ -1214,7 +1214,7 @@ static void uvc_ctrl_add_ctrl(struct uvc_device *dev,
 	}
 
 	if (!found)
-		return;
+		return 0;
 
 	if (UVC_ENTITY_TYPE(entity) == UVC_VC_EXTENSION_UNIT) {
 		/* Check if the device control information and length match
@@ -1231,7 +1231,7 @@ static void uvc_ctrl_add_ctrl(struct uvc_device *dev,
 				"control " UVC_GUID_FORMAT "/%u (%d).\n",
 				UVC_GUID_ARGS(info->entity), info->selector,
 				ret);
-			return;
+			return -EINVAL;
 		}
 
 		if (info->size != le16_to_cpu(size)) {
@@ -1239,7 +1239,7 @@ static void uvc_ctrl_add_ctrl(struct uvc_device *dev,
 				"/%u size doesn't match user supplied "
 				"value.\n", UVC_GUID_ARGS(info->entity),
 				info->selector);
-			return;
+			return -EINVAL;
 		}
 
 		ret = uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id,
@@ -1249,7 +1249,7 @@ static void uvc_ctrl_add_ctrl(struct uvc_device *dev,
 				"control " UVC_GUID_FORMAT "/%u (%d).\n",
 				UVC_GUID_ARGS(info->entity), info->selector,
 				ret);
-			return;
+			return -EINVAL;
 		}
 
 		flags = info->flags;
@@ -1259,15 +1259,18 @@ static void uvc_ctrl_add_ctrl(struct uvc_device *dev,
 				UVC_GUID_FORMAT "/%u flags don't match "
 				"supported operations.\n",
 				UVC_GUID_ARGS(info->entity), info->selector);
-			return;
+			return -EINVAL;
 		}
 	}
 
 	ctrl->info = info;
 	ctrl->data = kmalloc(ctrl->info->size * UVC_CTRL_NDATA, GFP_KERNEL);
+	if (ctrl->data == NULL)
+		return -ENOMEM;
 	uvc_trace(UVC_TRACE_CONTROL, "Added control " UVC_GUID_FORMAT "/%u "
 		"to device %s entity %u\n", UVC_GUID_ARGS(ctrl->info->entity),
 		ctrl->info->selector, dev->udev->devpath, entity->id);
+	return 0;
 }
 
 /*
@@ -1309,8 +1312,11 @@ int uvc_ctrl_add_info(struct uvc_control_info *info)
 		}
 	}
 
-	list_for_each_entry(dev, &uvc_driver.devices, list)
-		uvc_ctrl_add_ctrl(dev, info);
+	list_for_each_entry(dev, &uvc_driver.devices, list) {
+		ret = uvc_ctrl_add_ctrl(dev, info);
+		if (ret == -ENOMEM)
+			goto end;
+	}
 
 	INIT_LIST_HEAD(&info->mappings);
 	list_add_tail(&info->list, &uvc_driver.controls);
