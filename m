Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3193 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab3DNP15 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:27:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 30/30] cx25821: replace custom ioctls with write()
Date: Sun, 14 Apr 2013 17:27:26 +0200
Message-Id: <1365953246-8972-31-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Ideally this should be implemented with vb2, but it'll do for now.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-core.c           |    3 +-
 drivers/media/pci/cx25821/cx25821-video-upstream.c |  248 +++-----------------
 drivers/media/pci/cx25821/cx25821-video.c          |   37 ++-
 drivers/media/pci/cx25821/cx25821.h                |   12 +-
 4 files changed, 72 insertions(+), 228 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index 230bd86..35bea79 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -775,8 +775,8 @@ void cx25821_set_pixel_format(struct cx25821_dev *dev, int channel_select,
 	if (channel_select <= 7 && channel_select >= 0) {
 		cx_write(dev->channels[channel_select].sram_channels->pix_frmt,
 				format);
-		dev->channels[channel_select].pixel_formats = format;
 	}
+	dev->channels[channel_select].pixel_formats = format;
 }
 
 static void cx25821_set_vip_mode(struct cx25821_dev *dev,
@@ -820,6 +820,7 @@ static void cx25821_initialize(struct cx25821_dev *dev)
 	/* Probably only affect Downstream */
 	for (i = VID_UPSTREAM_SRAM_CHANNEL_I;
 		i <= VID_UPSTREAM_SRAM_CHANNEL_J; i++) {
+		dev->channels[i].pixel_formats = PIXEL_FRMT_422;
 		cx25821_set_vip_mode(dev, dev->channels[i].sram_channels);
 	}
 
diff --git a/drivers/media/pci/cx25821/cx25821-video-upstream.c b/drivers/media/pci/cx25821/cx25821-video-upstream.c
index 37cfc83..88ffef4 100644
--- a/drivers/media/pci/cx25821/cx25821-video-upstream.c
+++ b/drivers/media/pci/cx25821/cx25821-video-upstream.c
@@ -25,16 +25,11 @@
 #include "cx25821-video.h"
 #include "cx25821-video-upstream.h"
 
-#include <linux/fs.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/syscalls.h>
-#include <linux/file.h>
-#include <linux/fcntl.h>
 #include <linux/slab.h>
-#include <linux/uaccess.h>
 
 MODULE_DESCRIPTION("v4l2 driver module for cx25821 based TV cards");
 MODULE_AUTHOR("Hiep Huynh <hiep.huynh@conexant.com>");
@@ -258,6 +253,10 @@ void cx25821_stop_upstream_video(struct cx25821_channel *chan)
 		pr_info("No video file is currently running so return!\n");
 		return;
 	}
+
+	/* Set the interrupt mask register, disable irq. */
+	cx_set(PCI_INT_MSK, cx_read(PCI_INT_MSK) & ~(1 << sram_ch->irq_bit));
+
 	/* Disable RISC interrupts */
 	tmp = cx_read(sram_ch->int_msk);
 	cx_write(sram_ch->int_msk, tmp & ~_intr_msk);
@@ -266,6 +265,8 @@ void cx25821_stop_upstream_video(struct cx25821_channel *chan)
 	tmp = cx_read(sram_ch->dma_ctl);
 	cx_write(sram_ch->dma_ctl, tmp & ~(FLD_VID_FIFO_EN | FLD_VID_RISC_EN));
 
+	free_irq(dev->pci->irq, chan);
+
 	/* Clear data buffer memory */
 	if (out->_data_buf_virt_addr)
 		memset(out->_data_buf_virt_addr, 0, out->_data_buf_size);
@@ -275,11 +276,6 @@ void cx25821_stop_upstream_video(struct cx25821_channel *chan)
 	out->_frame_count = 0;
 	out->_file_status = END_OF_FILE;
 
-	destroy_workqueue(out->_irq_queues);
-	out->_irq_queues = NULL;
-
-	kfree(out->_filename);
-
 	tmp = cx_read(VID_CH_MODE_SEL);
 	cx_write(VID_CH_MODE_SEL, tmp & 0xFFFFFE00);
 }
@@ -306,25 +302,15 @@ void cx25821_free_mem_upstream(struct cx25821_channel *chan)
 	}
 }
 
-static int cx25821_get_frame(struct cx25821_channel *chan,
-			     const struct sram_channel *sram_ch)
+int cx25821_write_frame(struct cx25821_channel *chan,
+		const char __user *data, size_t count)
 {
 	struct cx25821_video_out_data *out = chan->out;
-	struct file *myfile;
-	int frame_index_temp = out->_frame_index;
-	int i = 0;
 	int line_size = (out->_pixel_format == PIXEL_FRMT_411) ?
 		Y411_LINE_SZ : Y422_LINE_SZ;
 	int frame_size = 0;
 	int frame_offset = 0;
-	ssize_t vfs_read_retval = 0;
-	char mybuf[line_size];
-	loff_t file_offset;
-	loff_t pos;
-	mm_segment_t old_fs;
-
-	if (out->_file_status == END_OF_FILE)
-		return 0;
+	int curpos = out->curpos;
 
 	if (out->is_60hz)
 		frame_size = (line_size == Y411_LINE_SZ) ?
@@ -333,160 +319,27 @@ static int cx25821_get_frame(struct cx25821_channel *chan,
 		frame_size = (line_size == Y411_LINE_SZ) ?
 			FRAME_SIZE_PAL_Y411 : FRAME_SIZE_PAL_Y422;
 
-	frame_offset = (frame_index_temp > 0) ? frame_size : 0;
-	file_offset = out->_frame_count * frame_size;
-
-	myfile = filp_open(out->_filename, O_RDONLY | O_LARGEFILE, 0);
-
-	if (IS_ERR(myfile)) {
-		const int open_errno = -PTR_ERR(myfile);
-		pr_err("%s(): ERROR opening file(%s) with errno = %d!\n",
-		       __func__, out->_filename, open_errno);
-		return PTR_ERR(myfile);
-	} else {
-		if (!(myfile->f_op)) {
-			pr_err("%s(): File has no file operations registered!\n",
-			       __func__);
-			filp_close(myfile, NULL);
-			return -EIO;
-		}
-
-		if (!myfile->f_op->read) {
-			pr_err("%s(): File has no READ operations registered!\n",
-			       __func__);
-			filp_close(myfile, NULL);
-			return -EIO;
-		}
-
-		pos = myfile->f_pos;
-		old_fs = get_fs();
-		set_fs(KERNEL_DS);
-
-		for (i = 0; i < out->_lines_count; i++) {
-			pos = file_offset;
-
-			vfs_read_retval = vfs_read(myfile, mybuf, line_size,
-					&pos);
-
-			if (vfs_read_retval > 0 && vfs_read_retval == line_size
-			    && out->_data_buf_virt_addr != NULL) {
-				memcpy((void *)(out->_data_buf_virt_addr +
-						frame_offset / 4), mybuf,
-				       vfs_read_retval);
-			}
-
-			file_offset += vfs_read_retval;
-			frame_offset += vfs_read_retval;
-
-			if (vfs_read_retval < line_size) {
-				pr_info("Done: exit %s() since no more bytes to read from Video file\n",
-					__func__);
-				break;
-			}
-		}
-
-		if (i > 0)
-			out->_frame_count++;
-
-		out->_file_status = (vfs_read_retval == line_size) ?
-			IN_PROGRESS : END_OF_FILE;
-
-		set_fs(old_fs);
-		filp_close(myfile, NULL);
+	if (curpos == 0) {
+		out->cur_frame_index = out->_frame_index;
+		if (wait_event_interruptible(out->waitq, out->cur_frame_index != out->_frame_index))
+			return -EINTR;
+		out->cur_frame_index = out->_frame_index;
 	}
 
-	return 0;
-}
-
-static void cx25821_vidups_handler(struct work_struct *work)
-{
-	struct cx25821_video_out_data *out =
-		container_of(work, struct cx25821_video_out_data, _irq_work_entry);
-
-	cx25821_get_frame(out->chan, out->chan->sram_channels);
-}
+	frame_offset = out->cur_frame_index ? frame_size : 0;
 
-static int cx25821_openfile(struct cx25821_channel *chan,
-			    const struct sram_channel *sram_ch)
-{
-	struct cx25821_video_out_data *out = chan->out;
-	struct file *myfile;
-	int i = 0, j = 0;
-	int line_size = (out->_pixel_format == PIXEL_FRMT_411) ?
-		Y411_LINE_SZ : Y422_LINE_SZ;
-	ssize_t vfs_read_retval = 0;
-	char mybuf[line_size];
-	loff_t pos;
-	loff_t offset = (unsigned long)0;
-	mm_segment_t old_fs;
-
-	myfile = filp_open(out->_filename, O_RDONLY | O_LARGEFILE, 0);
-
-	if (IS_ERR(myfile)) {
-		const int open_errno = -PTR_ERR(myfile);
-		pr_err("%s(): ERROR opening file(%s) with errno = %d!\n",
-		       __func__, out->_filename, open_errno);
-		return PTR_ERR(myfile);
-	} else {
-		if (!(myfile->f_op)) {
-			pr_err("%s(): File has no file operations registered!\n",
-			       __func__);
-			filp_close(myfile, NULL);
-			return -EIO;
-		}
-
-		if (!myfile->f_op->read) {
-			pr_err("%s(): File has no READ operations registered!  Returning\n",
-			       __func__);
-			filp_close(myfile, NULL);
-			return -EIO;
-		}
-
-		pos = myfile->f_pos;
-		old_fs = get_fs();
-		set_fs(KERNEL_DS);
-
-		for (j = 0; j < NUM_FRAMES; j++) {
-			for (i = 0; i < out->_lines_count; i++) {
-				pos = offset;
-
-				vfs_read_retval = vfs_read(myfile, mybuf,
-						line_size, &pos);
-
-				if (vfs_read_retval > 0
-				    && vfs_read_retval == line_size
-				    && out->_data_buf_virt_addr != NULL) {
-					memcpy((void *)(out->
-							_data_buf_virt_addr +
-							offset / 4), mybuf,
-					       vfs_read_retval);
-				}
-
-				offset += vfs_read_retval;
-
-				if (vfs_read_retval < line_size) {
-					pr_info("Done: exit %s() since no more bytes to read from Video file\n",
-						__func__);
-					break;
-				}
-			}
-
-			if (i > 0)
-				out->_frame_count++;
-
-			if (vfs_read_retval < line_size)
-				break;
-		}
-
-		out->_file_status = (vfs_read_retval == line_size) ?
-			IN_PROGRESS : END_OF_FILE;
-
-		set_fs(old_fs);
-		myfile->f_pos = 0;
-		filp_close(myfile, NULL);
+	if (frame_size - curpos < count)
+		count = frame_size - curpos;
+	memcpy((char *)out->_data_buf_virt_addr + frame_offset + curpos,
+			data, count);
+	curpos += count;
+	if (curpos == frame_size) {
+		out->_frame_count++;
+		curpos = 0;
 	}
+	out->curpos = curpos;
 
-	return 0;
+	return count;
 }
 
 static int cx25821_upstream_buffer_prepare(struct cx25821_channel *chan,
@@ -536,10 +389,6 @@ static int cx25821_upstream_buffer_prepare(struct cx25821_channel *chan,
 	/* Clear memory at address */
 	memset(out->_data_buf_virt_addr, 0, out->_data_buf_size);
 
-	ret = cx25821_openfile(chan, sram_ch);
-	if (ret < 0)
-		return ret;
-
 	/* Create RISC programs */
 	ret = cx25821_risc_buffer_upstream(chan, dev->pci, 0, bpl,
 			out->_lines_count);
@@ -576,12 +425,12 @@ static int cx25821_video_upstream_irq(struct cx25821_channel *chan, u32 status)
 		cx_write(channel->int_msk, int_msk_tmp & ~_intr_msk);
 		cx_write(channel->int_stat, _intr_msk);
 
+		wake_up(&out->waitq);
+
 		spin_lock(&dev->slock);
 
 		out->_frame_index = prog_cnt;
 
-		queue_work(out->_irq_queues, &out->_irq_work_entry);
-
 		if (out->_is_first_frame) {
 			out->_is_first_frame = 0;
 
@@ -762,7 +611,6 @@ int cx25821_vidupstream_init(struct cx25821_channel *chan,
 	int err = 0;
 	int data_frame_size = 0;
 	int risc_buffer_size = 0;
-	int str_length = 0;
 
 	if (out->_is_running) {
 		pr_info("Video Channel is still running so return!\n");
@@ -771,13 +619,8 @@ int cx25821_vidupstream_init(struct cx25821_channel *chan,
 
 	sram_ch = chan->sram_channels;
 
-	INIT_WORK(&out->_irq_work_entry, cx25821_vidups_handler);
-	out->_irq_queues = create_singlethread_workqueue("cx25821_workqueue");
+	out->is_60hz = dev->tvnorm & V4L2_STD_525_60;
 
-	if (!out->_irq_queues) {
-		pr_err("create_singlethread_workqueue() for Video FAILED!\n");
-		return -ENOMEM;
-	}
 	/* 656/VIP SRC Upstream Channel I & J and 7 - Host Bus Interface for
 	 * channel A-C
 	 */
@@ -795,39 +638,6 @@ int cx25821_vidupstream_init(struct cx25821_channel *chan,
 	risc_buffer_size = out->is_60hz ?
 		NTSC_RISC_BUF_SIZE : PAL_RISC_BUF_SIZE;
 
-	if (out->input_filename) {
-		str_length = strlen(out->input_filename);
-		out->_filename = kmemdup(out->input_filename, str_length + 1,
-					 GFP_KERNEL);
-
-		if (!out->_filename) {
-			err = -ENOENT;
-			goto error;
-		}
-	} else {
-		str_length = strlen(out->_defaultname);
-		out->_filename = kmemdup(out->_defaultname, str_length + 1,
-					 GFP_KERNEL);
-
-		if (!out->_filename) {
-			err = -ENOENT;
-			goto error;
-		}
-	}
-
-	/* Default if filename is empty string */
-	if (strcmp(out->_filename, "") == 0) {
-		if (out->is_60hz) {
-			out->_filename =
-				(out->_pixel_format == PIXEL_FRMT_411) ?
-				"/root/vid411.yuv" : "/root/vidtest.yuv";
-		} else {
-			out->_filename =
-				(out->_pixel_format == PIXEL_FRMT_411) ?
-				"/root/pal411.yuv" : "/root/pal422.yuv";
-		}
-	}
-
 	out->_is_running = 0;
 	out->_frame_count = 0;
 	out->_file_status = RESET_STATUS;
@@ -835,6 +645,8 @@ int cx25821_vidupstream_init(struct cx25821_channel *chan,
 	out->_pixel_format = pixel_format;
 	out->_line_size = (out->_pixel_format == PIXEL_FRMT_422) ?
 		(WIDTH_D1 * 2) : (WIDTH_D1 * 3) / 2;
+	out->curpos = 0;
+	init_waitqueue_head(&out->waitq);
 
 	err = cx25821_sram_channel_setup_upstream(dev, sram_ch,
 			out->_line_size, 0);
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index dde0ba3..b194138 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -893,15 +893,47 @@ static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
 	return 0;
 }
 
+static ssize_t video_write(struct file *file, const char __user *data, size_t count,
+			 loff_t *ppos)
+{
+	struct cx25821_channel *chan = video_drvdata(file);
+	struct cx25821_dev *dev = chan->dev;
+	struct v4l2_fh *fh = file->private_data;
+	int err = 0;
+
+	if (mutex_lock_interruptible(&dev->lock))
+		return -ERESTARTSYS;
+	if (chan->streaming_fh && chan->streaming_fh != fh) {
+		err = -EBUSY;
+		goto unlock;
+	}
+	if (!chan->streaming_fh) {
+		err = cx25821_vidupstream_init(chan, chan->pixel_formats);
+		if (err)
+			goto unlock;
+		chan->streaming_fh = fh;
+	}
+
+	err = cx25821_write_frame(chan, data, count);
+	count -= err;
+	*ppos += err;
+
+unlock:
+	mutex_unlock(&dev->lock);
+	return err;
+}
+
 static int video_out_release(struct file *file)
 {
 	struct cx25821_channel *chan = video_drvdata(file);
-	struct cx25821_video_out_data *out = chan->out;
 	struct cx25821_dev *dev = chan->dev;
+	struct v4l2_fh *fh = file->private_data;
 
 	mutex_lock(&dev->lock);
-	if ((chan->id == SRAM_CH09 || chan->id == SRAM_CH10) && out->_is_running)
+	if (chan->streaming_fh == fh) {
 		cx25821_stop_upstream_video(chan);
+		chan->streaming_fh = NULL;
+	}
 	mutex_unlock(&dev->lock);
 
 	return v4l2_fh_release(file);
@@ -955,6 +987,7 @@ static const struct video_device cx25821_video_device = {
 static const struct v4l2_file_operations video_out_fops = {
 	.owner = THIS_MODULE,
 	.open = v4l2_fh_open,
+	.write = video_write,
 	.release = video_out_release,
 	.unlocked_ioctl = video_ioctl2,
 };
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index b0bc2e6..90bdc19 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -197,15 +197,11 @@ struct cx25821_video_out_data {
 
 	u32 upstream_riscbuf_size;
 	u32 upstream_databuf_size;
-	struct workqueue_struct *_irq_queues;
-	struct work_struct _irq_work_entry;
 	int is_60hz;
 	int _frame_index;
-	char *input_filename;
-	char *vid_stdname;
-	int pixel_format;
-	char *_filename;
-	char *_defaultname;
+	int cur_frame_index;
+	int curpos;
+	wait_queue_head_t waitq;
 };
 
 struct cx25821_channel {
@@ -440,6 +436,8 @@ extern int cx25821_sram_channel_setup_audio(struct cx25821_dev *dev,
 extern int cx25821_vidupstream_init(struct cx25821_channel *chan, int pixel_format);
 extern int cx25821_audio_upstream_init(struct cx25821_dev *dev,
 				       int channel_select);
+extern int cx25821_write_frame(struct cx25821_channel *chan,
+		const char __user *data, size_t count);
 extern void cx25821_free_mem_upstream(struct cx25821_channel *chan);
 extern void cx25821_free_mem_upstream_audio(struct cx25821_dev *dev);
 extern void cx25821_stop_upstream_video(struct cx25821_channel *chan);
-- 
1.7.10.4

