Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46995 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401Ab0DTRWx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Apr 2010 13:22:53 -0400
Received: by vws5 with SMTP id 5so3134317vws.19
        for <linux-media@vger.kernel.org>; Tue, 20 Apr 2010 10:22:52 -0700 (PDT)
Message-ID: <4BCDE2D7.3020800@gmail.com>
Date: Tue, 20 Apr 2010 14:22:31 -0300
From: Ricardo Maraschini <xrmarsx@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: dougsland@gmail.com
Subject: [PATCH] cx25821-video-upstream.c: Added severity to printk calls
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ricardo Maraschini <ricardo.maraschini@gmail.com>

--- a/linux/drivers/staging/cx25821/cx25821-video-upstream.c	Sun Apr 18 11:12:11 2010 -0300
+++ b/linux/drivers/staging/cx25821/cx25821-video-upstream.c	Tue Apr 20 11:21:17 2010 -0300
@@ -257,7 +257,7 @@
 
 	if (!dev->_is_running) {
 		printk
-		   ("cx25821: No video file is currently running so return!\n");
+		   (KERN_INFO "cx25821: No video file is currently running so return!\n");
 		return;
 	}
 	/* Disable RISC interrupts */
@@ -345,19 +345,19 @@
 
 	if (IS_ERR(myfile)) {
 		const int open_errno = -PTR_ERR(myfile);
-		printk("%s(): ERROR opening file(%s) with errno = %d!\n",
+		printk(KERN_ERR "%s(): ERROR opening file(%s) with errno = %d!\n",
 		       __func__, dev->_filename, open_errno);
 		return PTR_ERR(myfile);
 	} else {
 		if (!(myfile->f_op)) {
-			printk("%s: File has no file operations registered!",
+			printk(KERN_ERR "%s: File has no file operations registered!",
 			       __func__);
 			filp_close(myfile, NULL);
 			return -EIO;
 		}
 
 		if (!myfile->f_op->read) {
-			printk("%s: File has no READ operations registered!",
+			printk(KERN_ERR "%s: File has no READ operations registered!",
 			       __func__);
 			filp_close(myfile, NULL);
 			return -EIO;
@@ -410,7 +410,7 @@
 	    container_of(work, struct cx25821_dev, _irq_work_entry);
 
 	if (!dev) {
-		printk("ERROR %s(): since container_of(work_struct) FAILED!\n",
+		printk(KERN_ERR "ERROR %s(): since container_of(work_struct) FAILED!\n",
 		       __func__);
 		return;
 	}
@@ -436,12 +436,12 @@
 
 	if (IS_ERR(myfile)) {
 		const int open_errno = -PTR_ERR(myfile);
-		printk("%s(): ERROR opening file(%s) with errno = %d!\n",
+		printk(KERN_ERR "%s(): ERROR opening file(%s) with errno = %d!\n",
 		       __func__, dev->_filename, open_errno);
 		return PTR_ERR(myfile);
 	} else {
 		if (!(myfile->f_op)) {
-			printk("%s: File has no file operations registered!",
+			printk(KERN_ERR "%s: File has no file operations registered!",
 			       __func__);
 			filp_close(myfile, NULL);
 			return -EIO;
@@ -449,7 +449,7 @@
 
 		if (!myfile->f_op->read) {
 			printk
-			    ("%s: File has no READ operations registered!  Returning.",
+			    (KERN_ERR "%s: File has no READ operations registered!  Returning.",
 			     __func__);
 			filp_close(myfile, NULL);
 			return -EIO;
@@ -525,7 +525,7 @@
 
 	if (!dev->_dma_virt_addr) {
 		printk
-		    ("cx25821: FAILED to allocate memory for Risc buffer! Returning.\n");
+		    (KERN_ERR "cx25821: FAILED to allocate memory for Risc buffer! Returning.\n");
 		return -ENOMEM;
 	}
 
@@ -546,7 +546,7 @@
 
 	if (!dev->_data_buf_virt_addr) {
 		printk
-		    ("cx25821: FAILED to allocate memory for data buffer! Returning.\n");
+		    (KERN_ERR "cx25821: FAILED to allocate memory for data buffer! Returning.\n");
 		return -ENOMEM;
 	}
 
@@ -641,20 +641,20 @@
 	} else {
 		if (status & FLD_VID_SRC_UF)
 			printk
-			    ("%s: Video Received Underflow Error Interrupt!\n",
+			    (KERN_ERR "%s: Video Received Underflow Error Interrupt!\n",
 			     __func__);
 
 		if (status & FLD_VID_SRC_SYNC)
-			printk("%s: Video Received Sync Error Interrupt!\n",
+			printk(KERN_ERR "%s: Video Received Sync Error Interrupt!\n",
 			       __func__);
 
 		if (status & FLD_VID_SRC_OPC_ERR)
-			printk("%s: Video Received OpCode Error Interrupt!\n",
+			printk(KERN_ERR "%s: Video Received OpCode Error Interrupt!\n",
 			       __func__);
 	}
 
 	if (dev->_file_status == END_OF_FILE) {
-		printk("cx25821: EOF Channel 1 Framecount = %d\n",
+		printk(KERN_ERR "cx25821: EOF Channel 1 Framecount = %d\n",
 		       dev->_frame_count);
 		return -1;
 	}
@@ -794,7 +794,7 @@
 	int str_length = 0;
 
 	if (dev->_is_running) {
-		printk("Video Channel is still running so return!\n");
+		printk(KERN_INFO "Video Channel is still running so return!\n");
 		return 0;
 	}
 
@@ -806,7 +806,7 @@
 
 	if (!dev->_irq_queues) {
 		printk
-		    ("cx25821: create_singlethread_workqueue() for Video FAILED!\n");
+		    (KERN_ERR "cx25821: create_singlethread_workqueue() for Video FAILED!\n");
 		return -ENOMEM;
 	}
 	/* 656/VIP SRC Upstream Channel I & J and 7 - Host Bus Interface for

