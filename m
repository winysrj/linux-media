Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55559 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932667Ab0I0NF7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Sep 2010 09:05:59 -0400
Received: by bwz11 with SMTP id 11so3245912bwz.19
        for <linux-media@vger.kernel.org>; Mon, 27 Sep 2010 06:05:57 -0700 (PDT)
From: ruslanpisarev@gmail.com
To: linux-media@vger.kernel.org
Cc: ruslan@rpisarev.org.ua
Subject: [PATCH 09/13] Staging: cx25821: fix braces, tabs and space coding style issue in cx25821-video-upstream-ch2.c
Date: Mon, 27 Sep 2010 16:05:39 +0300
Message-Id: <4ca096b4.1208cc0a.1c0c.ffff9e78@mx.google.com>
In-Reply-To: <y>
References: <y>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Ruslan Pisarev <ruslan@rpisarev.org.ua>

This is a patch to the cx25821-video-upstream-ch2.c file that fixed
up a braces, tabs and space warnings found by the checkpatch.pl tools.

Signed-off-by: Ruslan Pisarev <ruslan@rpisarev.org.ua>
---
 .../staging/cx25821/cx25821-video-upstream-ch2.c   |  135 +++++++++-----------
 1 files changed, 63 insertions(+), 72 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
index d12dbb5..405e2db 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
@@ -32,17 +32,17 @@
 #include <linux/file.h>
 #include <linux/fcntl.h>
 #include <linux/slab.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 MODULE_DESCRIPTION("v4l2 driver module for cx25821 based TV cards");
 MODULE_AUTHOR("Hiep Huynh <hiep.huynh@conexant.com>");
 MODULE_LICENSE("GPL");
 
 static int _intr_msk =
-    FLD_VID_SRC_RISC1 | FLD_VID_SRC_UF | FLD_VID_SRC_SYNC | FLD_VID_SRC_OPC_ERR;
+	FLD_VID_SRC_RISC1 | FLD_VID_SRC_UF | FLD_VID_SRC_SYNC | FLD_VID_SRC_OPC_ERR;
 
 static __le32 *cx25821_update_riscprogram_ch2(struct cx25821_dev *dev,
-					      __le32 * rp, unsigned int offset,
+					      __le32 *rp, unsigned int offset,
 					      unsigned int bpl, u32 sync_line,
 					      unsigned int lines,
 					      int fifo_enable, int field_type)
@@ -53,9 +53,8 @@ static __le32 *cx25821_update_riscprogram_ch2(struct cx25821_dev *dev,
 	*(rp++) = cpu_to_le32(RISC_RESYNC | sync_line);
 
 	if (USE_RISC_NOOP_VIDEO) {
-		for (i = 0; i < NUM_NO_OPS; i++) {
+		for (i = 0; i < NUM_NO_OPS; i++)
 			*(rp++) = cpu_to_le32(RISC_NOOP);
-		}
 	}
 
 	/* scan lines */
@@ -75,7 +74,7 @@ static __le32 *cx25821_update_riscprogram_ch2(struct cx25821_dev *dev,
 }
 
 static __le32 *cx25821_risc_field_upstream_ch2(struct cx25821_dev *dev,
-					       __le32 * rp,
+					       __le32 *rp,
 					       dma_addr_t databuf_phys_addr,
 					       unsigned int offset,
 					       u32 sync_line, unsigned int bpl,
@@ -88,14 +87,12 @@ static __le32 *cx25821_risc_field_upstream_ch2(struct cx25821_dev *dev,
 	int dist_betwn_starts = bpl * 2;
 
 	/* sync instruction */
-	if (sync_line != NO_SYNC_LINE) {
+	if (sync_line != NO_SYNC_LINE)
 		*(rp++) = cpu_to_le32(RISC_RESYNC | sync_line);
-	}
 
 	if (USE_RISC_NOOP_VIDEO) {
-		for (i = 0; i < NUM_NO_OPS; i++) {
+		for (i = 0; i < NUM_NO_OPS; i++)
 			*(rp++) = cpu_to_le32(RISC_NOOP);
-		}
 	}
 
 	/* scan lines */
@@ -133,7 +130,7 @@ int cx25821_risc_buffer_upstream_ch2(struct cx25821_dev *dev,
 {
 	__le32 *rp;
 	int fifo_enable = 0;
-       int singlefield_lines = lines >> 1; /*get line count for single field */
+	int singlefield_lines = lines >> 1; /*get line count for single field */
 	int odd_num_lines = singlefield_lines;
 	int frame = 0;
 	int frame_size = 0;
@@ -218,15 +215,15 @@ void cx25821_stop_upstream_video_ch2(struct cx25821_dev *dev)
 		    ("cx25821: No video file is currently running so return!\n");
 		return;
 	}
-       /* Disable RISC interrupts */
+	/* Disable RISC interrupts */
 	tmp = cx_read(sram_ch->int_msk);
 	cx_write(sram_ch->int_msk, tmp & ~_intr_msk);
 
-       /* Turn OFF risc and fifo */
+	/* Turn OFF risc and fifo */
 	tmp = cx_read(sram_ch->dma_ctl);
 	cx_write(sram_ch->dma_ctl, tmp & ~(FLD_VID_FIFO_EN | FLD_VID_RISC_EN));
 
-       /* Clear data buffer memory */
+	/* Clear data buffer memory */
 	if (dev->_data_buf_virt_addr_ch2)
 		memset(dev->_data_buf_virt_addr_ch2, 0,
 		       dev->_data_buf_size_ch2);
@@ -250,9 +247,8 @@ void cx25821_stop_upstream_video_ch2(struct cx25821_dev *dev)
 
 void cx25821_free_mem_upstream_ch2(struct cx25821_dev *dev)
 {
-	if (dev->_is_running_ch2) {
+	if (dev->_is_running_ch2)
 		cx25821_stop_upstream_video_ch2(dev);
-	}
 
 	if (dev->_dma_virt_addr_ch2) {
 		pci_free_consistent(dev->pci, dev->_risc_size_ch2,
@@ -303,11 +299,10 @@ int cx25821_get_frame_ch2(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 	file_offset = dev->_frame_count_ch2 * frame_size;
 
 	myfile = filp_open(dev->_filename_ch2, O_RDONLY | O_LARGEFILE, 0);
-
 	if (IS_ERR(myfile)) {
 		const int open_errno = -PTR_ERR(myfile);
-		printk("%s(): ERROR opening file(%s) with errno = %d! \n",
-		       __func__, dev->_filename_ch2, open_errno);
+		printk("%s(): ERROR opening file(%s) with errno = %d!\n",
+			__func__, dev->_filename_ch2, open_errno);
 		return PTR_ERR(myfile);
 	} else {
 		if (!(myfile->f_op)) {
@@ -371,8 +366,8 @@ static void cx25821_vidups_handler_ch2(struct work_struct *work)
 	    container_of(work, struct cx25821_dev, _irq_work_entry_ch2);
 
 	if (!dev) {
-		printk("ERROR %s(): since container_of(work_struct) FAILED! \n",
-		       __func__);
+		printk("ERROR %s(): since container_of(work_struct) FAILED!\n",
+			__func__);
 		return;
 	}
 
@@ -398,8 +393,8 @@ int cx25821_openfile_ch2(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 
 	if (IS_ERR(myfile)) {
 		const int open_errno = -PTR_ERR(myfile);
-		printk("%s(): ERROR opening file(%s) with errno = %d! \n",
-		       __func__, dev->_filename_ch2, open_errno);
+		printk("%s(): ERROR opening file(%s) with errno = %d!\n",
+			__func__, dev->_filename_ch2, open_errno);
 		return PTR_ERR(myfile);
 	} else {
 		if (!(myfile->f_op)) {
@@ -450,9 +445,8 @@ int cx25821_openfile_ch2(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 			if (i > 0)
 				dev->_frame_count_ch2++;
 
-			if (vfs_read_retval < line_size) {
+			if (vfs_read_retval < line_size)
 				break;
-			}
 		}
 
 		dev->_file_status_ch2 =
@@ -494,7 +488,7 @@ static int cx25821_upstream_buffer_prepare_ch2(struct cx25821_dev *dev,
 		return -ENOMEM;
 	}
 
-       /* Iniitize at this address until n bytes to 0 */
+	/* Iniitize at this address until n bytes to 0 */
 	memset(dev->_dma_virt_addr_ch2, 0, dev->_risc_size_ch2);
 
 	if (dev->_data_buf_virt_addr_ch2 != NULL) {
@@ -502,7 +496,7 @@ static int cx25821_upstream_buffer_prepare_ch2(struct cx25821_dev *dev,
 				    dev->_data_buf_virt_addr_ch2,
 				    dev->_data_buf_phys_addr_ch2);
 	}
-       /* For Video Data buffer allocation */
+	/* For Video Data buffer allocation */
 	dev->_data_buf_virt_addr_ch2 =
 	    pci_alloc_consistent(dev->pci, dev->upstream_databuf_size_ch2,
 				 &data_dma_addr);
@@ -515,26 +509,26 @@ static int cx25821_upstream_buffer_prepare_ch2(struct cx25821_dev *dev,
 		return -ENOMEM;
 	}
 
-       /* Initialize at this address until n bytes to 0 */
+	/* Initialize at this address until n bytes to 0 */
 	memset(dev->_data_buf_virt_addr_ch2, 0, dev->_data_buf_size_ch2);
 
 	ret = cx25821_openfile_ch2(dev, sram_ch);
 	if (ret < 0)
 		return ret;
 
-       /* Creating RISC programs */
+	/* Creating RISC programs */
 	ret =
 	    cx25821_risc_buffer_upstream_ch2(dev, dev->pci, 0, bpl,
 					     dev->_lines_count_ch2);
 	if (ret < 0) {
 		printk(KERN_INFO
-		       "cx25821: Failed creating Video Upstream Risc programs! \n");
+			"cx25821: Failed creating Video Upstream Risc programs!\n");
 		goto error;
 	}
 
 	return 0;
 
-      error:
+	error:
 	return ret;
 }
 
@@ -542,7 +536,7 @@ int cx25821_video_upstream_irq_ch2(struct cx25821_dev *dev, int chan_num,
 				   u32 status)
 {
 	u32 int_msk_tmp;
-       struct sram_channel *channel = dev->channels[chan_num].sram_channels;
+	struct sram_channel *channel = dev->channels[chan_num].sram_channels;
 	int singlefield_lines = NTSC_FIELD_HEIGHT;
 	int line_size_in_bytes = Y422_LINE_SZ;
 	int odd_risc_prog_size = 0;
@@ -550,13 +544,13 @@ int cx25821_video_upstream_irq_ch2(struct cx25821_dev *dev, int chan_num,
 	__le32 *rp;
 
 	if (status & FLD_VID_SRC_RISC1) {
-	       /* We should only process one program per call */
+		/* We should only process one program per call */
 		u32 prog_cnt = cx_read(channel->gpcnt);
 
-	       /*
-		  Since we've identified our IRQ, clear our bits from the
-		  interrupt mask and interrupt status registers
-	       */
+		/*
+		 *  Since we've identified our IRQ, clear our bits from the
+		 *  interrupt mask and interrupt status registers
+		 */
 		int_msk_tmp = cx_read(channel->int_msk);
 		cx_write(channel->int_msk, int_msk_tmp & ~_intr_msk);
 		cx_write(channel->int_stat, _intr_msk);
@@ -612,7 +606,7 @@ int cx25821_video_upstream_irq_ch2(struct cx25821_dev *dev, int chan_num,
 		       dev->_frame_count_ch2);
 		return -1;
 	}
-       /* ElSE, set the interrupt mask register, re-enable irq. */
+	/* ElSE, set the interrupt mask register, re-enable irq. */
 	int_msk_tmp = cx_read(channel->int_msk);
 	cx_write(channel->int_msk, int_msk_tmp |= _intr_msk);
 
@@ -631,24 +625,22 @@ static irqreturn_t cx25821_upstream_irq_ch2(int irq, void *dev_id)
 		return -1;
 
 	channel_num = VID_UPSTREAM_SRAM_CHANNEL_J;
-
-       sram_ch = dev->channels[channel_num].sram_channels;
+	sram_ch = dev->channels[channel_num].sram_channels;
 
 	msk_stat = cx_read(sram_ch->int_mstat);
 	vid_status = cx_read(sram_ch->int_stat);
 
-       /* Only deal with our interrupt */
+	/* Only deal with our interrupt */
 	if (vid_status) {
 		handled =
 		    cx25821_video_upstream_irq_ch2(dev, channel_num,
 						   vid_status);
 	}
 
-	if (handled < 0) {
+	if (handled < 0)
 		cx25821_stop_upstream_video_ch2(dev);
-	} else {
+	else
 		handled += handled;
-	}
 
 	return IRQ_RETVAL(handled);
 }
@@ -667,22 +659,21 @@ static void cx25821_set_pixelengine_ch2(struct cx25821_dev *dev,
 	value |= dev->_isNTSC_ch2 ? 0 : 0x10;
 	cx_write(ch->vid_fmt_ctl, value);
 
-       /*
-	  set number of active pixels in each line. Default is 720
-	  pixels in both NTSC and PAL format
-       */
+	/*
+	 *  set number of active pixels in each line. Default is 720
+	 * pixels in both NTSC and PAL format
+	 */
 	cx_write(ch->vid_active_ctl1, width);
 
 	num_lines = (height / 2) & 0x3FF;
 	odd_num_lines = num_lines;
 
-	if (dev->_isNTSC_ch2) {
+	if (dev->_isNTSC_ch2)
 		odd_num_lines += 1;
-	}
 
 	value = (num_lines << 16) | odd_num_lines;
 
-       /* set number of active lines in field 0 (top) and field 1 (bottom) */
+	/* set number of active lines in field 0 (top) and field 1 (bottom) */
 	cx_write(ch->vid_active_ctl2, value);
 
 	cx_write(ch->vid_cdt_size, VID_CDT_SIZE >> 3);
@@ -694,27 +685,27 @@ int cx25821_start_video_dma_upstream_ch2(struct cx25821_dev *dev,
 	u32 tmp = 0;
 	int err = 0;
 
-       /*
-	  656/VIP SRC Upstream Channel I & J and 7 - Host Bus Interface
-	  for channel A-C
-       */
+	/*
+	 *  656/VIP SRC Upstream Channel I & J and 7 - Host Bus Interface
+	 * for channel A-C
+	 */
 	tmp = cx_read(VID_CH_MODE_SEL);
 	cx_write(VID_CH_MODE_SEL, tmp | 0x1B0001FF);
 
-       /*
-	  Set the physical start address of the RISC program in the initial
-	  program counter(IPC) member of the cmds.
-       */
+	/*
+	 *  Set the physical start address of the RISC program in the initial
+	 *  program counter(IPC) member of the cmds.
+	 */
 	cx_write(sram_ch->cmds_start + 0, dev->_dma_phys_addr_ch2);
-       cx_write(sram_ch->cmds_start + 4, 0); /* Risc IPC High 64 bits 63-32 */
+	cx_write(sram_ch->cmds_start + 4, 0); /* Risc IPC High 64 bits 63-32 */
 
 	/* reset counter */
 	cx_write(sram_ch->gpcnt_ctl, 3);
 
-       /* Clear our bits from the interrupt status register. */
+	/* Clear our bits from the interrupt status register. */
 	cx_write(sram_ch->int_stat, _intr_msk);
 
-       /* Set the interrupt mask register, enable irq. */
+	/* Set the interrupt mask register, enable irq. */
 	cx_set(PCI_INT_MSK, cx_read(PCI_INT_MSK) | (1 << sram_ch->irq_bit));
 	tmp = cx_read(sram_ch->int_msk);
 	cx_write(sram_ch->int_msk, tmp |= _intr_msk);
@@ -727,7 +718,7 @@ int cx25821_start_video_dma_upstream_ch2(struct cx25821_dev *dev,
 		       dev->pci->irq);
 		goto fail_irq;
 	}
-       /* Start the DMA  engine */
+	/* Start the DMA  engine */
 	tmp = cx_read(sram_ch->dma_ctl);
 	cx_set(sram_ch->dma_ctl, tmp | FLD_VID_RISC_EN);
 
@@ -736,7 +727,7 @@ int cx25821_start_video_dma_upstream_ch2(struct cx25821_dev *dev,
 
 	return 0;
 
-      fail_irq:
+	fail_irq:
 	cx25821_dev_unregister(dev);
 	return err;
 }
@@ -758,7 +749,7 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
 	}
 
 	dev->_channel2_upstream_select = channel_select;
-       sram_ch = dev->channels[channel_select].sram_channels;
+	sram_ch = dev->channels[channel_select].sram_channels;
 
 	INIT_WORK(&dev->_irq_work_entry_ch2, cx25821_vidups_handler_ch2);
 	dev->_irq_queues_ch2 =
@@ -769,10 +760,10 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
 		    ("cx25821: create_singlethread_workqueue() for Video FAILED!\n");
 		return -ENOMEM;
 	}
-       /*
-	  656/VIP SRC Upstream Channel I & J and 7 -
-	  Host Bus Interface for channel A-C
-       */
+	/*
+	 * 656/VIP SRC Upstream Channel I & J and 7 -
+	 * Host Bus Interface for channel A-C
+	 */
 	tmp = cx_read(VID_CH_MODE_SEL);
 	cx_write(VID_CH_MODE_SEL, tmp | 0x1B0001FF);
 
@@ -808,7 +799,7 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
 		       str_length + 1);
 	}
 
-       /* Default if filename is empty string */
+	/* Default if filename is empty string */
 	if (strcmp(dev->input_filename_ch2, "") == 0) {
 		if (dev->_isNTSC_ch2) {
 			dev->_filename_ch2 =
@@ -833,7 +824,7 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
 	dev->upstream_riscbuf_size_ch2 = risc_buffer_size * 2;
 	dev->upstream_databuf_size_ch2 = data_frame_size * 2;
 
-       /* Allocating buffers and prepare RISC program */
+	/* Allocating buffers and prepare RISC program */
 	retval =
 	    cx25821_upstream_buffer_prepare_ch2(dev, sram_ch,
 						dev->_line_size_ch2);
@@ -848,7 +839,7 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
 
 	return 0;
 
-      error:
+	error:
 	cx25821_dev_unregister(dev);
 
 	return err;
-- 
1.7.0.4

