Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:34259 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab0ESP5E (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 May 2010 11:57:04 -0400
From: <asheeshb@ti.com>
To: <linux-media@vger.kernel.org>
CC: Asheesh Bhardwaj <asheesh@lab1.dmlab>
Subject: [PATCH 1/7] changed driver for MMAP buffer
Date: Wed, 19 May 2010 10:56:45 -0500
Message-ID: <1274284611-13432-1-git-send-email-asheeshb@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Asheesh Bhardwaj <asheesh@lab1.dmlab>

---
 drivers/media/video/davinci/vpif_display.c |   59 ++++++++++++++++++++++++++++
 drivers/media/video/davinci/vpif_display.h |    1 +
 2 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index 4a72610..db9f395 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -62,18 +62,24 @@ static u32 ch2_numbuffers = 3;
 static u32 ch3_numbuffers = 3;
 static u32 ch2_bufsize = 1920 * 1080 * 2;
 static u32 ch3_bufsize = 720 * 576 * 2;
+static u32 cont_bufoffset = 0;
+static u32 cont_bufsize = 0;
 
 module_param(debug, int, 0644);
 module_param(ch2_numbuffers, uint, S_IRUGO);
 module_param(ch3_numbuffers, uint, S_IRUGO);
 module_param(ch2_bufsize, uint, S_IRUGO);
 module_param(ch3_bufsize, uint, S_IRUGO);
+module_param(cont_bufoffset, bool, S_IRUGO);
+module_param(cont_bufsize, uint, S_IRUGO);
 
 MODULE_PARM_DESC(debug, "Debug level 0-1");
 MODULE_PARM_DESC(ch2_numbuffers, "Channel2 buffer count (default:3)");
 MODULE_PARM_DESC(ch3_numbuffers, "Channel3 buffer count (default:3)");
 MODULE_PARM_DESC(ch2_bufsize, "Channel2 buffer size (default:1920 x 1080 x 2)");
 MODULE_PARM_DESC(ch3_bufsize, "Channel3 buffer size (default:720 x 576 x 2)");
+MODULE_PARM_DESC(cont_bufoffset,"Display offset(default 0)");
+MODULE_PARM_DESC(cont_bufsize,"Display buffer size(default 0)");
 
 static struct vpif_config_params config_params = {
 	.min_numbuffers		= 3,
@@ -224,6 +230,23 @@ static int vpif_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 		return 0;
 
 	*size = config_params.channel_bufsize[ch->channel_id];
+ 	
+        /*Checking if the buffer size exceeds the available buffer*/
+        /*ycmux_mode = 0 means 1 channel mode HD and ycmuxmode = 1 means 2 channels mode SD */
+        if (ch->vpifparams.std_info.ycmux_mode == 0) {
+            if (config_params.video_limit[ch->channel_id]) {
+		while (*size * *count > (config_params.video_limit[0] 
+                         + config_params.video_limit[1]))
+			(*count)--;
+            }
+        }
+        else {
+             if (config_params.video_limit[ch->channel_id]) {
+		while (*size * *count > config_params.video_limit[ch->channel_id])
+			(*count)--;
+            }
+        }
+
 	if (*count < config_params.min_numbuffers)
 		*count = config_params.min_numbuffers;
 
@@ -1434,6 +1457,8 @@ static __init int vpif_probe(struct platform_device *pdev)
 	struct video_device *vfd;
 	struct resource *res;
 	int subdev_count;
+        unsigned long phys_end_kernel;
+        size_t size;
 
 	vpif_dev = &pdev->dev;
 
@@ -1496,6 +1521,40 @@ static __init int vpif_probe(struct platform_device *pdev)
 		ch->video_dev = vfd;
 	}
 
+        /* Initialising the memory from the input arguments file for contiguous memory buffers and avoid defragmentation */
+       
+        if(cont_bufsize) {
+	    /* attempt to determine the end of Linux kernel memory */
+            phys_end_kernel = virt_to_phys((void *)PAGE_OFFSET) +
+                   (num_physpages << PAGE_SHIFT);
+            phys_end_kernel += cont_bufoffset; 
+            size = cont_bufsize;
+            
+	    err = dma_declare_coherent_memory(&pdev->dev, phys_end_kernel,
+		  phys_end_kernel,
+		  size,
+	          DMA_MEMORY_MAP |
+		  DMA_MEMORY_EXCLUSIVE);
+
+		if (!err) {
+			dev_err(&pdev->dev, "Unable to declare MMAP memory.\n");
+			err = -ENOMEM;
+			goto probe_out;
+         } 
+
+       
+        /*The resources are divided into two equal memory and when we have HD output we can add them together*/	
+         for (j = 0; j < VPIF_DISPLAY_MAX_DEVICES; j++) {
+		   ch = vpif_obj.dev[j];
+		   ch->channel_id = j;
+        	   config_params.video_limit[ch->channel_id] = 0; /* only enabled if second resource exists */
+                   if(cont_bufsize) {
+                          config_params.video_limit[ch->channel_id] = size/2;
+                    }
+            }
+        }
+
+
 	for (j = 0; j < VPIF_DISPLAY_MAX_DEVICES; j++) {
 		ch = vpif_obj.dev[j];
 		/* Initialize field of the channel objects */
diff --git a/drivers/media/video/davinci/vpif_display.h b/drivers/media/video/davinci/vpif_display.h
index ffa237b..f13cd43 100644
--- a/drivers/media/video/davinci/vpif_display.h
+++ b/drivers/media/video/davinci/vpif_display.h
@@ -162,6 +162,7 @@ struct vpif_config_params {
 	u32 channel_bufsize[VPIF_DISPLAY_NUM_CHANNELS];
 	u8 numbuffers[VPIF_DISPLAY_NUM_CHANNELS];
 	u8 min_numbuffers;
+        u32 video_limit[VPIF_DISPLAY_NUM_CHANNELS];
 };
 
 /* Struct which keeps track of the line numbers for the sliced vbi service */
-- 
1.6.3.3

