Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:65223 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936446Ab3DRVf6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 17:35:58 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 15/24] mx3-camera: support asynchronous subdevice registration
Date: Thu, 18 Apr 2013 23:35:36 +0200
Message-Id: <1366320945-21591-16-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To support asynchronous subdevice registration we only have to pass a
subdevice descriptor array from driver platform data to soc-camera for
camera host driver registration.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/mx3_camera.c |    6 ++++++
 include/linux/platform_data/camera-mx3.h       |    3 +++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 94203f6..75215bc 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -19,6 +19,7 @@
 #include <linux/sched.h>
 #include <linux/dma/ipu-dma.h>
 
+#include <media/v4l2-async.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
 #include <media/videobuf2-dma-contig.h>
@@ -1224,6 +1225,11 @@ static int mx3_camera_probe(struct platform_device *pdev)
 		goto eallocctx;
 	}
 
+	if (pdata->asd_sizes) {
+		soc_host->asd = pdata->asd;
+		soc_host->asd_sizes = pdata->asd_sizes;
+	}
+
 	err = soc_camera_host_register(soc_host);
 	if (err)
 		goto ecamhostreg;
diff --git a/include/linux/platform_data/camera-mx3.h b/include/linux/platform_data/camera-mx3.h
index f226ee3..96f0f78 100644
--- a/include/linux/platform_data/camera-mx3.h
+++ b/include/linux/platform_data/camera-mx3.h
@@ -33,6 +33,7 @@
 #define MX3_CAMERA_DATAWIDTH_MASK (MX3_CAMERA_DATAWIDTH_4 | MX3_CAMERA_DATAWIDTH_8 | \
 				   MX3_CAMERA_DATAWIDTH_10 | MX3_CAMERA_DATAWIDTH_15)
 
+struct v4l2_async_subdev;
 /**
  * struct mx3_camera_pdata - i.MX3x camera platform data
  * @flags:	MX3_CAMERA_* flags
@@ -43,6 +44,8 @@ struct mx3_camera_pdata {
 	unsigned long flags;
 	unsigned long mclk_10khz;
 	struct device *dma_dev;
+	struct v4l2_async_subdev **asd;	/* Flat array, arranged in groups */
+	int *asd_sizes;			/* 0-terminated array pf asd group sizes */
 };
 
 #endif
-- 
1.7.2.5

