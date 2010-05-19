Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:38077 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044Ab0ESQoo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 May 2010 12:44:44 -0400
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id o4JGiiLj006951
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 19 May 2010 11:44:44 -0500
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep35.itg.ti.com (8.13.7/8.13.7) with ESMTP id o4JGiiBx020016
	for <linux-media@vger.kernel.org>; Wed, 19 May 2010 11:44:44 -0500 (CDT)
Received: from dlee73.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id o4JGihG8013188
	for <linux-media@vger.kernel.org>; Wed, 19 May 2010 11:44:44 -0500 (CDT)
From: <asheeshb@ti.com>
To: <linux-media@vger.kernel.org>
CC: Asheesh Bhardwaj <asheeshb@ti.com>
Subject: [PATCH 3/7] Patch for capture driver MMAP buffer allocation.
Date: Wed, 19 May 2010 11:44:34 -0500
Message-ID: <1274287478-14661-4-git-send-email-asheeshb@ti.com>
In-Reply-To: <1274287478-14661-3-git-send-email-asheeshb@ti.com>
References: <1274287478-14661-1-git-send-email-asheeshb@ti.com>
 <1274287478-14661-2-git-send-email-asheeshb@ti.com>
 <1274287478-14661-3-git-send-email-asheeshb@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Asheesh Bhardwaj <asheeshb@ti.com>

The user can specify the size of the buffers with an offset from the kernel
images.
---
 drivers/media/video/davinci/vpif_capture.c |   56 +++++++++++++++++++++++++++-
 drivers/media/video/davinci/vpif_capture.h |    2 +
 2 files changed, 57 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index b4b5905..9ba015d 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -53,18 +53,24 @@ static u32 ch0_numbuffers = 3;
 static u32 ch1_numbuffers = 3;
 static u32 ch0_bufsize = 1920 * 1080 * 2;
 static u32 ch1_bufsize = 720 * 576 * 2;
+static u32 cont_bufoffset = 0;
+static u32 cont_bufsize = 0;
 
 module_param(debug, int, 0644);
 module_param(ch0_numbuffers, uint, S_IRUGO);
 module_param(ch1_numbuffers, uint, S_IRUGO);
 module_param(ch0_bufsize, uint, S_IRUGO);
 module_param(ch1_bufsize, uint, S_IRUGO);
+module_param(cont_bufoffset, uint, S_IRUGO);
+module_param(cont_bufsize, uint, S_IRUGO);
 
 MODULE_PARM_DESC(debug, "Debug level 0-1");
 MODULE_PARM_DESC(ch2_numbuffers, "Channel0 buffer count (default:3)");
 MODULE_PARM_DESC(ch3_numbuffers, "Channel1 buffer count (default:3)");
 MODULE_PARM_DESC(ch2_bufsize, "Channel0 buffer size (default:1920 x 1080 x 2)");
 MODULE_PARM_DESC(ch3_bufsize, "Channel1 buffer size (default:720 x 576 x 2)");
+MODULE_PARM_DESC(cont_bufoffset,"Capture buffer offset(default 0)");
+MODULE_PARM_DESC(cont_bufsize,"Capture buffer size(default 0)");
 
 static struct vpif_config_params config_params = {
 	.min_numbuffers = 3,
@@ -187,10 +193,27 @@ static int vpif_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 
 	/* Calculate the size of the buffer */
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
 
 	if (*count < config_params.min_numbuffers)
 		*count = config_params.min_numbuffers;
-	return 0;
+	
+        return 0;
 }
 
 /**
@@ -1892,6 +1915,8 @@ static __init int vpif_probe(struct platform_device *pdev)
 	struct video_device *vfd;
 	struct resource *res;
 	int subdev_count;
+        unsigned long phys_end_kernel;
+        size_t size;
 
 	vpif_dev = &pdev->dev;
 
@@ -1941,6 +1966,35 @@ static __init int vpif_probe(struct platform_device *pdev)
 		/* Set video_dev to the video device */
 		ch->video_dev = vfd;
 	}
+       
+        /* Initialising the memory from the bootargs for contiguous memory buffers and avoid defragmentation */
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
+	if (!err) {
+		dev_err(&pdev->dev, "Unable to declare MMAP memory.\n");
+		err = -ENOMEM;
+		goto probe_out;
+         } 
+        
+        /*The resources are divided into two equal memory and when we have HD output we can add them together*/	
+         for (j = 0; j < VPIF_CAPTURE_MAX_DEVICES; j++) {
+		   ch = vpif_obj.dev[j];
+		   ch->channel_id = j;
+        	   config_params.video_limit[ch->channel_id] = 0; /* only enabled if second resource exists */
+                   if(cont_bufsize) {
+                          config_params.video_limit[ch->channel_id] = size/2;
+                    }
+            }
+        }
 
 	for (j = 0; j < VPIF_CAPTURE_MAX_DEVICES; j++) {
 		ch = vpif_obj.dev[j];
diff --git a/drivers/media/video/davinci/vpif_capture.h b/drivers/media/video/davinci/vpif_capture.h
index 4e12ec8..b526887 100644
--- a/drivers/media/video/davinci/vpif_capture.h
+++ b/drivers/media/video/davinci/vpif_capture.h
@@ -155,6 +155,8 @@ struct vpif_config_params {
 	u32 channel_bufsize[VPIF_CAPTURE_NUM_CHANNELS];
 	u8 default_device[VPIF_CAPTURE_NUM_CHANNELS];
 	u8 max_device_type;
+        /* Used for limiting the video buffers when we allocate memory*/
+        u32 video_limit[VPIF_CAPTURE_NUM_CHANNELS];
 };
 /* Struct which keeps track of the line numbers for the sliced vbi service */
 struct vpif_service_line {
-- 
1.6.3.3

