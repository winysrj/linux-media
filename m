Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:55172 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046Ab0ESQop (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 May 2010 12:44:45 -0400
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id o4JGiiaY026357
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 19 May 2010 11:44:44 -0500
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep36.itg.ti.com (8.13.8/8.13.8) with ESMTP id o4JGiikd005458
	for <linux-media@vger.kernel.org>; Wed, 19 May 2010 11:44:44 -0500 (CDT)
Received: from dlee73.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id o4JGiimx013202
	for <linux-media@vger.kernel.org>; Wed, 19 May 2010 11:44:44 -0500 (CDT)
From: <asheeshb@ti.com>
To: <linux-media@vger.kernel.org>
CC: Asheesh Bhardwaj <asheeshb@ti.com>
Subject: [PATCH 6/7] DM365 capture MMAP buffer allocation
Date: Wed, 19 May 2010 11:44:37 -0500
Message-ID: <1274287478-14661-7-git-send-email-asheeshb@ti.com>
In-Reply-To: <1274287478-14661-6-git-send-email-asheeshb@ti.com>
References: <1274287478-14661-1-git-send-email-asheeshb@ti.com>
 <1274287478-14661-2-git-send-email-asheeshb@ti.com>
 <1274287478-14661-3-git-send-email-asheeshb@ti.com>
 <1274287478-14661-4-git-send-email-asheeshb@ti.com>
 <1274287478-14661-5-git-send-email-asheeshb@ti.com>
 <1274287478-14661-6-git-send-email-asheeshb@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Asheesh Bhardwaj <asheeshb@ti.com>

---
 drivers/media/video/davinci/vpfe_capture.c |   39 +++++++++++++++++++++++++---
 include/media/davinci/vpfe_capture.h       |    1 +
 2 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index b26b9d5..c6eadba 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -87,11 +87,15 @@ static int debug;
 static u32 numbuffers = 3;
 static u32 bufsize = PAL_IMAGE_SIZE + SECOND_IMAGE_SIZE_MAX;
 static int interface;
+static u32 cont_bufoffset = 0;
+static u32 cont_bufsize = 0;
 
 module_param(interface, bool, S_IRUGO);
 module_param(numbuffers, uint, S_IRUGO);
 module_param(bufsize, uint, S_IRUGO);
 module_param(debug, bool, 0644);
+module_param(cont_bufoffset, uint, S_IRUGO);
+module_param(cont_bufsize, uint, S_IRUGO);
 
 /**
  * VPFE capture can be used for capturing video such as from TVP5146 or TVP7002
@@ -107,6 +111,8 @@ MODULE_PARM_DESC(interface, "interface 0-1 (default:0)");
 MODULE_PARM_DESC(numbuffers, "buffer count (default:3)");
 MODULE_PARM_DESC(bufsize, "buffer size in bytes, (default:1443840 bytes)");
 MODULE_PARM_DESC(debug, "Debug level 0-1");
+MODULE_PARM_DESC(cont_bufoffset,"Capture buffer offset(default 0)");
+MODULE_PARM_DESC(cont_bufsize,"Capture buffer size(default 0)");
 
 MODULE_DESCRIPTION("VPFE Video for Linux Capture Driver");
 MODULE_LICENSE("GPL");
@@ -1828,10 +1834,14 @@ static int vpfe_videobuf_setup(struct videobuf_queue *vq,
 			*size = config_params.device_bufsize;
 	}
 
-	if (*count < config_params.min_numbuffers)
-		*count = config_params.min_numbuffers;
+	if ( config_params.video_limit) {
+		while (*size * *count > config_params.video_limit)
+			(*count)--;
+	}
 
-	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
+ 	if (*count < config_params.min_numbuffers)
+		*count = config_params.min_numbuffers;
+        v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
 		"count=%d, size=%d\n", *count, *size);
 	return 0;
 }
@@ -2608,8 +2618,10 @@ static __init int vpfe_probe(struct platform_device *pdev)
 	struct vpfe_device *vpfe_dev;
 	struct i2c_adapter *i2c_adap;
 	struct video_device *vfd;
-	int ret = -ENOMEM, i, j;
+	int ret = -ENOMEM, i, j, err;
 	int num_subdevs = 0;
+	unsigned long phys_end_kernel;
+	size_t size;
 
 	/* Get the pointer to the device object */
 	vpfe_dev = vpfe_initialize();
@@ -2622,6 +2634,25 @@ static __init int vpfe_probe(struct platform_device *pdev)
 
 	vpfe_dev->pdev = &pdev->dev;
 
+        if(cont_bufsize) {
+            /* attempt to determine the end of Linux kernel memory */
+            phys_end_kernel = virt_to_phys((void *)PAGE_OFFSET) +
+                   (num_physpages << PAGE_SHIFT);
+            size = cont_bufsize;
+            phys_end_kernel += cont_bufoffset; 
+            err = dma_declare_coherent_memory(&pdev->dev, phys_end_kernel,
+		  phys_end_kernel,
+		  size,
+		  DMA_MEMORY_MAP |
+         	  DMA_MEMORY_EXCLUSIVE);
+		if (!err) {
+			dev_err(&pdev->dev, "Unable to declare MMAP memory.\n");
+			ret = -ENOENT;
+		        goto probe_free_dev_mem;
+         	}
+            config_params.video_limit = size;
+        }  
+
 	if (NULL == pdev->dev.platform_data) {
 		v4l2_err(pdev->dev.driver, "Unable to get vpfe config\n");
 		ret = -ENOENT;
diff --git a/include/media/davinci/vpfe_capture.h b/include/media/davinci/vpfe_capture.h
index bd0f13a..785157c 100644
--- a/include/media/davinci/vpfe_capture.h
+++ b/include/media/davinci/vpfe_capture.h
@@ -228,6 +228,7 @@ struct vpfe_config_params {
 	u8 numbuffers;
 	u32 min_bufsize;
 	u32 device_bufsize;
+	u32 video_limit;
 };
 
 #endif				/* End of __KERNEL__ */
-- 
1.6.3.3

