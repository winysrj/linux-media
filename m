Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60080 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754137AbZDUHhl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2009 03:37:41 -0400
Date: Tue, 21 Apr 2009 09:37:45 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] soc-camera: link host drivers after clients
Message-ID: <Pine.LNX.4.64.0904210927190.6551@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the transition of soc-camera to become a platform driver and to the 
v4l2-subdev framework the initialisation order becomes important. In case 
of a static build clients (i2c) drivers have to be available when host 
drivers are probed. Moving host drivers down in the Makefile achieves the 
desired order.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 7c0bd6e..400bbd5 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -134,10 +134,6 @@ obj-$(CONFIG_VIDEO_CX18) += cx18/
 obj-$(CONFIG_VIDEO_VIVI) += vivi.o
 obj-$(CONFIG_VIDEO_CX23885) += cx23885/
 
-obj-$(CONFIG_VIDEO_MX1)			+= mx1_camera.o
-obj-$(CONFIG_VIDEO_MX3)			+= mx3_camera.o
-obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
-obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
 obj-$(CONFIG_VIDEO_OMAP2)		+= omap2cam.o
 obj-$(CONFIG_SOC_CAMERA)		+= soc_camera.o
 obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
@@ -147,6 +143,11 @@ obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= mt9v022.o
 obj-$(CONFIG_SOC_CAMERA_OV772X)		+= ov772x.o
 obj-$(CONFIG_SOC_CAMERA_PLATFORM)	+= soc_camera_platform.o
 obj-$(CONFIG_SOC_CAMERA_TW9910)		+= tw9910.o
+# soc-camera host drivers have to be linked after camera drivers
+obj-$(CONFIG_VIDEO_MX1)			+= mx1_camera.o
+obj-$(CONFIG_VIDEO_MX3)			+= mx3_camera.o
+obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
+obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
 
 obj-$(CONFIG_VIDEO_AU0828) += au0828/
 
