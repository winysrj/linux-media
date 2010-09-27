Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51039 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab0I0NHf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Sep 2010 09:07:35 -0400
Received: by mail-bw0-f46.google.com with SMTP id 11so3246776bwz.19
        for <linux-media@vger.kernel.org>; Mon, 27 Sep 2010 06:07:34 -0700 (PDT)
From: Ruslan Pisarev <ruslanpisarev@gmail.com>
To: linux-media@vger.kernel.org
Cc: ruslan@rpisarev.org.ua
Subject: [PATCH 12/13] Staging: cx25821: fix tabs and space coding style issue in cx25821-video-upstream.c
Date: Mon, 27 Sep 2010 16:07:23 +0300
Message-Id: <1285592843-409-1-git-send-email-ruslan@rpisarev.org.ua>
In-Reply-To: <y>
References: <y>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a patch to the cx25821-video-upstream.c file that fixed
up a tabs and space warnings found by the checkpatch.pl tools.

Signed-off-by: Ruslan Pisarev <ruslan@rpisarev.org.ua>
---
 drivers/staging/cx25821/cx25821-video-upstream.c |   28 +++++++++++-----------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video-upstream.c b/drivers/staging/cx25821/cx25821-video-upstream.c
index 756a820..16bf74d 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream.c
@@ -39,7 +39,7 @@ MODULE_AUTHOR("Hiep Huynh <hiep.huynh@conexant.com>");
 MODULE_LICENSE("GPL");
 
 static int _intr_msk =
-    FLD_VID_SRC_RISC1 | FLD_VID_SRC_UF | FLD_VID_SRC_SYNC | FLD_VID_SRC_OPC_ERR;
+	FLD_VID_SRC_RISC1 | FLD_VID_SRC_UF | FLD_VID_SRC_SYNC | FLD_VID_SRC_OPC_ERR;
 
 int cx25821_sram_channel_setup_upstream(struct cx25821_dev *dev,
 					struct sram_channel *ch,
@@ -346,13 +346,13 @@ int cx25821_get_frame(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 
 	if (IS_ERR(myfile)) {
 		const int open_errno = -PTR_ERR(myfile);
-	       printk(KERN_ERR
+		printk(KERN_ERR
 		   "%s(): ERROR opening file(%s) with errno = %d!\n",
 		   __func__, dev->_filename, open_errno);
 		return PTR_ERR(myfile);
 	} else {
 		if (!(myfile->f_op)) {
-		       printk(KERN_ERR
+			printk(KERN_ERR
 			   "%s: File has no file operations registered!",
 			   __func__);
 			filp_close(myfile, NULL);
@@ -360,7 +360,7 @@ int cx25821_get_frame(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 		}
 
 		if (!myfile->f_op->read) {
-		       printk(KERN_ERR
+			printk(KERN_ERR
 			   "%s: File has no READ operations registered!",
 			   __func__);
 			filp_close(myfile, NULL);
@@ -415,7 +415,7 @@ static void cx25821_vidups_handler(struct work_struct *work)
 	    container_of(work, struct cx25821_dev, _irq_work_entry);
 
 	if (!dev) {
-	       printk(KERN_ERR
+		printk(KERN_ERR
 		   "ERROR %s(): since container_of(work_struct) FAILED!\n",
 		   __func__);
 		return;
@@ -448,7 +448,7 @@ int cx25821_openfile(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 		return PTR_ERR(myfile);
 	} else {
 		if (!(myfile->f_op)) {
-		       printk(KERN_ERR
+			printk(KERN_ERR
 			   "%s: File has no file operations registered!",
 			   __func__);
 			filp_close(myfile, NULL);
@@ -456,7 +456,7 @@ int cx25821_openfile(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 		}
 
 		if (!myfile->f_op->read) {
-		       printk(KERN_ERR
+			printk(KERN_ERR
 			   "%s: File has no READ operations registered!  \
 			   Returning.",
 			     __func__);
@@ -589,7 +589,7 @@ int cx25821_video_upstream_irq(struct cx25821_dev *dev, int chan_num,
 			       u32 status)
 {
 	u32 int_msk_tmp;
-       struct sram_channel *channel = dev->channels[chan_num].sram_channels;
+	struct sram_channel *channel = dev->channels[chan_num].sram_channels;
 	int singlefield_lines = NTSC_FIELD_HEIGHT;
 	int line_size_in_bytes = Y422_LINE_SZ;
 	int odd_risc_prog_size = 0;
@@ -657,12 +657,12 @@ int cx25821_video_upstream_irq(struct cx25821_dev *dev, int chan_num,
 			   Interrupt!\n", __func__);
 
 		if (status & FLD_VID_SRC_SYNC)
-		       printk(KERN_ERR "%s: Video Received Sync Error \
-		       Interrupt!\n", __func__);
+			printk(KERN_ERR "%s: Video Received Sync Error \
+				Interrupt!\n", __func__);
 
 		if (status & FLD_VID_SRC_OPC_ERR)
-		       printk(KERN_ERR "%s: Video Received OpCode Error \
-		       Interrupt!\n", __func__);
+			printk(KERN_ERR "%s: Video Received OpCode Error \
+				Interrupt!\n", __func__);
 	}
 
 	if (dev->_file_status == END_OF_FILE) {
@@ -690,7 +690,7 @@ static irqreturn_t cx25821_upstream_irq(int irq, void *dev_id)
 
 	channel_num = VID_UPSTREAM_SRAM_CHANNEL_I;
 
-       sram_ch = dev->channels[channel_num].sram_channels;
+	sram_ch = dev->channels[channel_num].sram_channels;
 
 	msk_stat = cx_read(sram_ch->int_mstat);
 	vid_status = cx_read(sram_ch->int_stat);
@@ -811,7 +811,7 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
 	}
 
 	dev->_channel_upstream_select = channel_select;
-       sram_ch = dev->channels[channel_select].sram_channels;
+	sram_ch = dev->channels[channel_select].sram_channels;
 
 	INIT_WORK(&dev->_irq_work_entry, cx25821_vidups_handler);
 	dev->_irq_queues = create_singlethread_workqueue("cx25821_workqueue");
-- 
1.7.0.4

