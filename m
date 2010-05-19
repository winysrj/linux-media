Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:55173 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047Ab0ESQop (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 May 2010 12:44:45 -0400
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id o4JGiitW026356
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 19 May 2010 11:44:44 -0500
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep33.itg.ti.com (8.13.7/8.13.7) with ESMTP id o4JGii6S024954
	for <linux-media@vger.kernel.org>; Wed, 19 May 2010 11:44:44 -0500 (CDT)
Received: from dlee73.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id o4JGii42013198
	for <linux-media@vger.kernel.org>; Wed, 19 May 2010 11:44:44 -0500 (CDT)
From: <asheeshb@ti.com>
To: <linux-media@vger.kernel.org>
CC: Asheesh Bhardwaj <asheeshb@ti.com>
Subject: [PATCH 5/7] DM365 MMAP buffer allocation for display driver
Date: Wed, 19 May 2010 11:44:36 -0500
Message-ID: <1274287478-14661-6-git-send-email-asheeshb@ti.com>
In-Reply-To: <1274287478-14661-5-git-send-email-asheeshb@ti.com>
References: <1274287478-14661-1-git-send-email-asheeshb@ti.com>
 <1274287478-14661-2-git-send-email-asheeshb@ti.com>
 <1274287478-14661-3-git-send-email-asheeshb@ti.com>
 <1274287478-14661-4-git-send-email-asheeshb@ti.com>
 <1274287478-14661-5-git-send-email-asheeshb@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Asheesh Bhardwaj <asheeshb@ti.com>

---
 drivers/media/video/davinci/davinci_display.c |   79 ++++++++++++++++++++++++-
 include/media/davinci/davinci_display.h       |    1 +
 2 files changed, 77 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/davinci/davinci_display.c b/drivers/media/video/davinci/davinci_display.c
index 4c4efef..8eb98c4 100644
--- a/drivers/media/video/davinci/davinci_display.c
+++ b/drivers/media/video/davinci/davinci_display.c
@@ -45,11 +45,15 @@
 
 static u32 video2_numbuffers = 3;
 static u32 video3_numbuffers = 3;
+static u32 cont2_bufoffset = 0;
+static u32 cont2_bufsize = 0;
+static u32 cont3_bufoffset = 0;
+static u32 cont3_bufsize = 0;
 
 #define DAVINCI_DISPLAY_HD_BUF_SIZE (1280*720*2)
 #define DAVINCI_DISPLAY_SD_BUF_SIZE (720*576*2)
 
-static u32 video2_bufsize = DAVINCI_DISPLAY_SD_BUF_SIZE;
+static u32 video2_bufsize = DAVINCI_DISPLAY_HD_BUF_SIZE;
 static u32 video3_bufsize = DAVINCI_DISPLAY_SD_BUF_SIZE;
 
 module_param(video2_numbuffers, uint, S_IRUGO);
@@ -57,15 +61,24 @@ module_param(video3_numbuffers, uint, S_IRUGO);
 
 module_param(video2_bufsize, uint, S_IRUGO);
 module_param(video3_bufsize, uint, S_IRUGO);
+module_param(cont2_bufoffset, uint, S_IRUGO);
+module_param(cont2_bufsize, uint, S_IRUGO);
+module_param(cont3_bufoffset, uint, S_IRUGO);
+module_param(cont3_bufsize, uint, S_IRUGO);
+
+MODULE_PARM_DESC(cont2_bufoffset,"Display offset(default 0)");
+MODULE_PARM_DESC(cont2_bufsize,"Display buffer size(default 0)");
+MODULE_PARM_DESC(cont3_bufoffset,"Display offset(default 0)");
+MODULE_PARM_DESC(cont3_bufsize,"Display buffer size(default 0)");
 
 #define DAVINCI_DEFAULT_NUM_BUFS 3
 static struct buf_config_params display_buf_config_params = {
 	.min_numbuffers = DAVINCI_DEFAULT_NUM_BUFS,
 	.numbuffers[0] = DAVINCI_DEFAULT_NUM_BUFS,
 	.numbuffers[1] = DAVINCI_DEFAULT_NUM_BUFS,
-	.min_bufsize[0] = DAVINCI_DISPLAY_SD_BUF_SIZE,
+	.min_bufsize[0] = DAVINCI_DISPLAY_HD_BUF_SIZE,
 	.min_bufsize[1] = DAVINCI_DISPLAY_SD_BUF_SIZE,
-	.layer_bufsize[0] = DAVINCI_DISPLAY_SD_BUF_SIZE,
+	.layer_bufsize[0] = DAVINCI_DISPLAY_HD_BUF_SIZE,
 	.layer_bufsize[1] = DAVINCI_DISPLAY_SD_BUF_SIZE,
 };
 
@@ -167,10 +180,17 @@ static int davinci_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 		if (*size > buf_size)
 			*size = buf_size;
 
+        /*Checking if the buffer size exceeds the available buffer*/
+	if (display_buf_config_params.video_limit[layer->device_id]) {
+		while (*size * *count > ( display_buf_config_params.video_limit[layer->device_id]))
+			(*count)--;
+        }
+      
 	/* Store number of buffers allocated in numbuffer member */
 	if (*count < display_buf_config_params.min_numbuffers)
 		*count = layer->numbuffers = display_buf_config_params.numbuffers[layer->device_id];
 	dev_dbg(davinci_display_dev, "</davinci_buffer_setup>\n");
+
 	return 0;
 }
 
@@ -1577,6 +1597,8 @@ static __init int davinci_probe(struct device *device)
 	struct video_device *vbd = NULL;
 	struct display_obj *layer = NULL;
 	struct platform_device *pdev;
+	unsigned long phys_end_kernel;
+	size_t size;
 
 	davinci_display_dev = device;
 
@@ -1588,6 +1610,51 @@ static __init int davinci_probe(struct device *device)
 		dev_err(davinci_display_dev, "probed for an unknown device\n");
 		return -ENODEV;
 	}
+
+       /* Initialising the memory from the input arguments file for contiguous memory buffers and avoid defragmentation */
+       
+	if(cont2_bufsize) {
+		/* attempt to determine the end of Linux kernel memory */
+		phys_end_kernel = virt_to_phys((void *)PAGE_OFFSET) +
+			(num_physpages << PAGE_SHIFT);
+		phys_end_kernel += cont2_bufoffset; 
+		size = cont2_bufsize;
+                       
+		err = dma_declare_coherent_memory(&pdev->dev, phys_end_kernel,
+			phys_end_kernel,
+			size,
+			DMA_MEMORY_MAP |
+			DMA_MEMORY_EXCLUSIVE);
+
+		if (!err) {
+			dev_err(&pdev->dev, "Unable to declare MMAP memory.\n");
+			err = -ENOMEM;
+			goto probe_out;
+		display_buf_config_params.video_limit[DAVINCI_DISPLAY_DEVICE_0] = size;
+		}
+	} 
+	
+	if(cont3_bufsize) {
+	    /* attempt to determine the end of Linux kernel memory */
+		phys_end_kernel = virt_to_phys((void *)PAGE_OFFSET) +
+			(num_physpages << PAGE_SHIFT);
+			phys_end_kernel += cont3_bufoffset; 
+			size = cont3_bufsize;
+                       
+		err = dma_declare_coherent_memory(&pdev->dev, phys_end_kernel,
+			phys_end_kernel,
+			size,
+			DMA_MEMORY_MAP |
+			DMA_MEMORY_EXCLUSIVE);
+
+		if (!err) {
+			dev_err(&pdev->dev, "Unable to declare MMAP memory.\n");
+			err = -ENOMEM;
+			goto probe_out;
+		display_buf_config_params.video_limit[DAVINCI_DISPLAY_DEVICE_1] = size;
+		} 
+	}
+
 	for (i = 0; i < DAVINCI_DISPLAY_MAX_DEVICES; i++) {
 		/* Get the pointer to the layer object */
 		layer = davinci_dm.dev[i];
@@ -1743,6 +1810,12 @@ static __init int davinci_display_init(void)
 	display_buf_config_params.numbuffers[DAVINCI_DISPLAY_DEVICE_1] =
 		video3_numbuffers;
 
+	/*set size of buffers, they could come from bootargs*/
+	display_buf_config_params.layer_bufsize[DAVINCI_DISPLAY_DEVICE_0] =
+		video2_bufsize;
+	display_buf_config_params.layer_bufsize[DAVINCI_DISPLAY_DEVICE_1] =
+		video3_bufsize;
+   
 	if (cpu_is_davinci_dm355()) {
 		strcpy(davinci_display_videocap.card, DM355_EVM_CARD);
 	} else if (cpu_is_davinci_dm365())
diff --git a/include/media/davinci/davinci_display.h b/include/media/davinci/davinci_display.h
index 8524328..d62b849 100644
--- a/include/media/davinci/davinci_display.h
+++ b/include/media/davinci/davinci_display.h
@@ -171,6 +171,7 @@ struct buf_config_params {
 	u8 numbuffers[DAVINCI_DISPLAY_MAX_DEVICES];
 	u32 min_bufsize[DAVINCI_DISPLAY_MAX_DEVICES];
 	u32 layer_bufsize[DAVINCI_DISPLAY_MAX_DEVICES];
+	u32 video_limit[DAVINCI_DISPLAY_MAX_DEVICES];
 };
 
 #endif				/* End of __KERNEL__ */
-- 
1.6.3.3

