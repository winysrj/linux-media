Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:52686 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682AbZKRAiv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 19:38:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@infradead.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: v4l: Remove video_device::num usage from device drivers
Date: Wed, 18 Nov 2009 01:38:44 +0100
Message-Id: <1258504731-8430-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Index: v4l-dvb-mc-uvc/linux/drivers/media/video/vivi.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/vivi.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/vivi.c
@@ -1376,9 +1376,6 @@ static int __init vivi_create_instance(i
 	/* Now that everything is fine, let's add it to device list */
 	list_add_tail(&dev->vivi_devlist, &vivi_devlist);
 
-	snprintf(vfd->name, sizeof(vfd->name), "%s (%i)",
-			vivi_template.name, vfd->num);
-
 	if (video_nr >= 0)
 		video_nr++;
 
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/w9968cf.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/w9968cf.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/w9968cf.c
@@ -2891,8 +2891,7 @@ static long w9968cf_v4l_ioctl(struct fil
 			.minwidth = cam->minwidth,
 			.minheight = cam->minheight,
 		};
-		sprintf(cap.name, "W996[87]CF USB Camera #%d",
-			cam->v4ldev->num);
+		sprintf(cap.name, "W996[87]CF USB Camera");
 		cap.maxwidth = (cam->upscaling && w9968cf_vpp)
 			       ? max((u16)W9968CF_MAX_WIDTH, cam->maxwidth)
 				 : cam->maxwidth;
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/usbvision/usbvision-i2c.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/usbvision/usbvision-i2c.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/usbvision/usbvision-i2c.c
@@ -219,8 +219,8 @@ int usbvision_i2c_register(struct usb_us
 	memcpy(&usbvision->i2c_adap, &i2c_adap_template,
 	       sizeof(struct i2c_adapter));
 
-	sprintf(usbvision->i2c_adap.name + strlen(usbvision->i2c_adap.name),
-		" #%d", usbvision->vdev->num);
+	sprintf(usbvision->i2c_adap.name, "%s-%d-%s", i2c_adap_template.name,
+		usbvision->dev->bus->busnum, usbvision->dev->devpath);
 	PDEBUG(DBG_I2C,"Adaptername: %s", usbvision->i2c_adap.name);
 	usbvision->i2c_adap.dev.parent = &usbvision->dev->dev;
 
