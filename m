Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2795 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab3DNP1x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:27:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 17/30] cx25821: use core locking.
Date: Sun, 14 Apr 2013 17:27:13 +0200
Message-Id: <1365953246-8972-18-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This allows us to replace .ioctl with .unlocked_ioctl.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-medusa-video.c |   44 -------------
 drivers/media/pci/cx25821/cx25821-video.c        |   72 ++++++++--------------
 drivers/media/pci/cx25821/cx25821-video.h        |    6 --
 drivers/media/pci/cx25821/cx25821.h              |    1 -
 4 files changed, 27 insertions(+), 96 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-medusa-video.c b/drivers/media/pci/cx25821/cx25821-medusa-video.c
index 6ab3ae0..22fa044 100644
--- a/drivers/media/pci/cx25821/cx25821-medusa-video.c
+++ b/drivers/media/pci/cx25821/cx25821-medusa-video.c
@@ -94,8 +94,6 @@ static int medusa_initialize_ntsc(struct cx25821_dev *dev)
 	u32 value = 0;
 	u32 tmp = 0;
 
-	mutex_lock(&dev->lock);
-
 	for (i = 0; i < MAX_DECODERS; i++) {
 		/* set video format NTSC-M */
 		value = cx25821_i2c_read(&dev->i2c_bus[0],
@@ -222,8 +220,6 @@ static int medusa_initialize_ntsc(struct cx25821_dev *dev)
 	value |= 0x00080200;
 	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], BYP_AB_CTRL, value);
 
-	mutex_unlock(&dev->lock);
-
 	return ret_val;
 }
 
@@ -265,8 +261,6 @@ static int medusa_initialize_pal(struct cx25821_dev *dev)
 	u32 value = 0;
 	u32 tmp = 0;
 
-	mutex_lock(&dev->lock);
-
 	for (i = 0; i < MAX_DECODERS; i++) {
 		/* set video format PAL-BDGHI */
 		value = cx25821_i2c_read(&dev->i2c_bus[0],
@@ -397,8 +391,6 @@ static int medusa_initialize_pal(struct cx25821_dev *dev)
 	value &= 0xFFF7FDFF;
 	ret_val = cx25821_i2c_write(&dev->i2c_bus[0], BYP_AB_CTRL, value);
 
-	mutex_unlock(&dev->lock);
-
 	return ret_val;
 }
 
@@ -434,8 +426,6 @@ void medusa_set_resolution(struct cx25821_dev *dev, int width,
 	u32 vscale = 0x0;
 	const int MAX_WIDTH = 720;
 
-	mutex_lock(&dev->lock);
-
 	/* validate the width */
 	if (width > MAX_WIDTH) {
 		pr_info("%s(): width %d > MAX_WIDTH %d ! resetting to MAX_WIDTH\n",
@@ -485,8 +475,6 @@ void medusa_set_resolution(struct cx25821_dev *dev, int width,
 		cx25821_i2c_write(&dev->i2c_bus[0],
 				VSCALE_CTRL + (0x200 * decoder), vscale);
 	}
-
-	mutex_unlock(&dev->lock);
 }
 
 static void medusa_set_decoderduration(struct cx25821_dev *dev, int decoder,
@@ -496,11 +484,8 @@ static void medusa_set_decoderduration(struct cx25821_dev *dev, int decoder,
 	u32 tmp = 0;
 	u32 disp_cnt_reg = DISP_AB_CNT;
 
-	mutex_lock(&dev->lock);
-
 	/* no support */
 	if (decoder < VDEC_A || decoder > VDEC_H) {
-		mutex_unlock(&dev->lock);
 		return;
 	}
 
@@ -535,8 +520,6 @@ static void medusa_set_decoderduration(struct cx25821_dev *dev, int decoder,
 	}
 
 	cx25821_i2c_write(&dev->i2c_bus[0], disp_cnt_reg, fld_cnt);
-
-	mutex_unlock(&dev->lock);
 }
 
 /* Map to Medusa register setting */
@@ -587,10 +570,8 @@ int medusa_set_brightness(struct cx25821_dev *dev, int brightness, int decoder)
 	int value = 0;
 	u32 val = 0, tmp = 0;
 
-	mutex_lock(&dev->lock);
 	if ((brightness > VIDEO_PROCAMP_MAX) ||
 	    (brightness < VIDEO_PROCAMP_MIN)) {
-		mutex_unlock(&dev->lock);
 		return -1;
 	}
 	ret_val = mapM(VIDEO_PROCAMP_MIN, VIDEO_PROCAMP_MAX, brightness,
@@ -601,7 +582,6 @@ int medusa_set_brightness(struct cx25821_dev *dev, int brightness, int decoder)
 	val &= 0xFFFFFF00;
 	ret_val |= cx25821_i2c_write(&dev->i2c_bus[0],
 			VDEC_A_BRITE_CTRL + (0x200 * decoder), val | value);
-	mutex_unlock(&dev->lock);
 	return ret_val;
 }
 
@@ -611,10 +591,7 @@ int medusa_set_contrast(struct cx25821_dev *dev, int contrast, int decoder)
 	int value = 0;
 	u32 val = 0, tmp = 0;
 
-	mutex_lock(&dev->lock);
-
 	if ((contrast > VIDEO_PROCAMP_MAX) || (contrast < VIDEO_PROCAMP_MIN)) {
-		mutex_unlock(&dev->lock);
 		return -1;
 	}
 
@@ -626,7 +603,6 @@ int medusa_set_contrast(struct cx25821_dev *dev, int contrast, int decoder)
 	ret_val |= cx25821_i2c_write(&dev->i2c_bus[0],
 			VDEC_A_CNTRST_CTRL + (0x200 * decoder), val | value);
 
-	mutex_unlock(&dev->lock);
 	return ret_val;
 }
 
@@ -636,10 +612,7 @@ int medusa_set_hue(struct cx25821_dev *dev, int hue, int decoder)
 	int value = 0;
 	u32 val = 0, tmp = 0;
 
-	mutex_lock(&dev->lock);
-
 	if ((hue > VIDEO_PROCAMP_MAX) || (hue < VIDEO_PROCAMP_MIN)) {
-		mutex_unlock(&dev->lock);
 		return -1;
 	}
 
@@ -654,7 +627,6 @@ int medusa_set_hue(struct cx25821_dev *dev, int hue, int decoder)
 	ret_val |= cx25821_i2c_write(&dev->i2c_bus[0],
 			VDEC_A_HUE_CTRL + (0x200 * decoder), val | value);
 
-	mutex_unlock(&dev->lock);
 	return ret_val;
 }
 
@@ -664,11 +636,8 @@ int medusa_set_saturation(struct cx25821_dev *dev, int saturation, int decoder)
 	int value = 0;
 	u32 val = 0, tmp = 0;
 
-	mutex_lock(&dev->lock);
-
 	if ((saturation > VIDEO_PROCAMP_MAX) ||
 	    (saturation < VIDEO_PROCAMP_MIN)) {
-		mutex_unlock(&dev->lock);
 		return -1;
 	}
 
@@ -687,7 +656,6 @@ int medusa_set_saturation(struct cx25821_dev *dev, int saturation, int decoder)
 	ret_val |= cx25821_i2c_write(&dev->i2c_bus[0],
 			VDEC_A_VSAT_CTRL + (0x200 * decoder), val | value);
 
-	mutex_unlock(&dev->lock);
 	return ret_val;
 }
 
@@ -699,8 +667,6 @@ int medusa_video_init(struct cx25821_dev *dev)
 	int ret_val = 0;
 	int i = 0;
 
-	mutex_lock(&dev->lock);
-
 	_num_decoders = dev->_max_num_decoders;
 
 	/* disable Auto source selection on all video decoders */
@@ -719,13 +685,9 @@ int medusa_video_init(struct cx25821_dev *dev)
 	if (ret_val < 0)
 		goto error;
 
-	mutex_unlock(&dev->lock);
-
 	for (i = 0; i < _num_decoders; i++)
 		medusa_set_decoderduration(dev, i, _display_field_cnt[i]);
 
-	mutex_lock(&dev->lock);
-
 	/* Select monitor as DENC A input, power up the DAC */
 	value = cx25821_i2c_read(&dev->i2c_bus[0], DENC_AB_CTRL, &tmp);
 	value &= 0xFF70FF70;
@@ -774,14 +736,8 @@ int medusa_video_init(struct cx25821_dev *dev)
 	if (ret_val < 0)
 		goto error;
 
-
-	mutex_unlock(&dev->lock);
-
 	ret_val = medusa_set_videostandard(dev);
 
-	return ret_val;
-
 error:
-	mutex_unlock(&dev->lock);
 	return ret_val;
 }
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 6088ee9..ab79bd5 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -144,27 +144,8 @@ static int cx25821_set_tvnorm(struct cx25821_dev *dev, v4l2_std_id norm)
 	return 0;
 }
 
-/*
-static int cx25821_ctrl_query(struct v4l2_queryctrl *qctrl)
-{
-	int i;
-
-	if (qctrl->id < V4L2_CID_BASE || qctrl->id >= V4L2_CID_LASTP1)
-		return -EINVAL;
-	for (i = 0; i < CX25821_CTLS; i++)
-		if (cx25821_ctls[i].v.id == qctrl->id)
-			break;
-	if (i == CX25821_CTLS) {
-		*qctrl = no_ctl;
-		return 0;
-	}
-	*qctrl = cx25821_ctls[i].v;
-	return 0;
-}
-*/
-
 /* resource management */
-int cx25821_res_get(struct cx25821_dev *dev, struct cx25821_fh *fh,
+static int cx25821_res_get(struct cx25821_dev *dev, struct cx25821_fh *fh,
 		    unsigned int bit)
 {
 	dprintk(1, "%s()\n", __func__);
@@ -173,41 +154,36 @@ int cx25821_res_get(struct cx25821_dev *dev, struct cx25821_fh *fh,
 		return 1;
 
 	/* is it free? */
-	mutex_lock(&dev->lock);
 	if (dev->channels[fh->channel_id].resources & bit) {
 		/* no, someone else uses it */
-		mutex_unlock(&dev->lock);
 		return 0;
 	}
 	/* it's free, grab it */
 	fh->resources |= bit;
 	dev->channels[fh->channel_id].resources |= bit;
 	dprintk(1, "res: get %d\n", bit);
-	mutex_unlock(&dev->lock);
 	return 1;
 }
 
-int cx25821_res_check(struct cx25821_fh *fh, unsigned int bit)
+static int cx25821_res_check(struct cx25821_fh *fh, unsigned int bit)
 {
 	return fh->resources & bit;
 }
 
-int cx25821_res_locked(struct cx25821_fh *fh, unsigned int bit)
+static int cx25821_res_locked(struct cx25821_fh *fh, unsigned int bit)
 {
 	return fh->dev->channels[fh->channel_id].resources & bit;
 }
 
-void cx25821_res_free(struct cx25821_dev *dev, struct cx25821_fh *fh,
+static void cx25821_res_free(struct cx25821_dev *dev, struct cx25821_fh *fh,
 		      unsigned int bits)
 {
 	BUG_ON((fh->resources & bits) != bits);
 	dprintk(1, "%s()\n", __func__);
 
-	mutex_lock(&dev->lock);
 	fh->resources &= ~bits;
 	dev->channels[fh->channel_id].resources &= ~bits;
 	dprintk(1, "res: put %d\n", bits);
-	mutex_unlock(&dev->lock);
 }
 
 static int cx25821_video_mux(struct cx25821_dev *dev, unsigned int input)
@@ -669,7 +645,7 @@ static int video_open(struct file *file)
 	videobuf_queue_sg_init(&fh->vidq, &cx25821_video_qops, &dev->pci->dev,
 			&dev->slock, V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			V4L2_FIELD_INTERLACED, sizeof(struct cx25821_buffer),
-			fh, NULL);
+			fh, &dev->lock);
 
 	dprintk(1, "post videobuf_queue_init()\n");
 
@@ -680,19 +656,25 @@ static ssize_t video_read(struct file *file, char __user * data, size_t count,
 			 loff_t *ppos)
 {
 	struct cx25821_fh *fh = file->private_data;
+	struct cx25821_dev *dev = fh->dev;
+	int err;
 
 	switch (fh->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		if (mutex_lock_interruptible(&dev->lock))
+			return -ERESTARTSYS;
 		if (cx25821_res_locked(fh, RESOURCE_VIDEO0))
-			return -EBUSY;
-
-		return videobuf_read_one(&fh->vidq, data, count, ppos,
+			err = -EBUSY;
+		else
+			err = videobuf_read_one(&fh->vidq, data, count, ppos,
 					file->f_flags & O_NONBLOCK);
+		mutex_unlock(&dev->lock);
+		return err;
 
 	default:
-		BUG();
-		return 0;
+		return -ENODEV;
 	}
+
 }
 
 static unsigned int video_poll(struct file *file,
@@ -742,6 +724,7 @@ static int video_release(struct file *file)
 	const struct sram_channel *sram_ch =
 		dev->channels[0].sram_channels;
 
+	mutex_lock(&dev->lock);
 	/* stop the risc engine and fifo */
 	cx_write(sram_ch->dma_ctl, 0); /* FIFO and RISC disable */
 
@@ -750,6 +733,7 @@ static int video_release(struct file *file)
 		videobuf_queue_cancel(&fh->vidq);
 		cx25821_res_free(dev, fh, RESOURCE_VIDEO0);
 	}
+	mutex_unlock(&dev->lock);
 
 	if (fh->vidq.read_buf) {
 		cx25821_buffer_release(&fh->vidq, fh->vidq.read_buf);
@@ -1083,9 +1067,7 @@ int cx25821_vidioc_s_std(struct file *file, void *priv, v4l2_std_id tvnorms)
 	if (dev->tvnorm == tvnorms)
 		return 0;
 
-	mutex_lock(&dev->lock);
 	cx25821_set_tvnorm(dev, tvnorms);
-	mutex_unlock(&dev->lock);
 
 	medusa_set_videostandard(dev);
 
@@ -1141,9 +1123,7 @@ static int cx25821_vidioc_s_input(struct file *file, void *priv, unsigned int i)
 	if (i >= CX25821_NR_INPUT || INPUT(i)->type == 0)
 		return -EINVAL;
 
-	mutex_lock(&dev->lock);
 	cx25821_video_mux(dev, i);
-	mutex_unlock(&dev->lock);
 	return 0;
 }
 
@@ -1465,7 +1445,7 @@ static const struct v4l2_file_operations video_fops = {
 	.read = video_read,
 	.poll = video_poll,
 	.mmap = cx25821_video_mmap,
-	.ioctl = cx25821_video_ioctl,
+	.unlocked_ioctl = cx25821_video_ioctl,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
@@ -1521,6 +1501,10 @@ int cx25821_video_register(struct cx25821_dev *dev)
 	int err;
 	int i;
 
+	/* initial device configuration */
+	dev->tvnorm = V4L2_STD_NTSC_M,
+	cx25821_set_tvnorm(dev, dev->tvnorm);
+
 	spin_lock_init(&dev->slock);
 
 	for (i = 0; i < VID_CHANNEL_NUM; ++i) {
@@ -1543,6 +1527,9 @@ int cx25821_video_register(struct cx25821_dev *dev)
 			err = hdl->error;
 			goto fail_unreg;
 		}
+		err = v4l2_ctrl_handler_setup(hdl);
+		if (err)
+			goto fail_unreg;
 
 		cx25821_risc_stopper(dev->pci, &dev->channels[i].vidq.stopper,
 			dev->channels[i].sram_channels->dma_ctl, 0x11, 0);
@@ -1567,6 +1554,7 @@ int cx25821_video_register(struct cx25821_dev *dev)
 		*vdev = cx25821_video_device;
 		vdev->v4l2_dev = &dev->v4l2_dev;
 		vdev->ctrl_handler = hdl;
+		vdev->lock = &dev->lock;
 		snprintf(vdev->name, sizeof(vdev->name), "%s #%d", dev->name, i);
 		video_set_drvdata(vdev, dev);
 
@@ -1580,12 +1568,6 @@ int cx25821_video_register(struct cx25821_dev *dev)
 	/* set PCI interrupt */
 	cx_set(PCI_INT_MSK, 0xff);
 
-	/* initial device configuration */
-	mutex_lock(&dev->lock);
-	dev->tvnorm = V4L2_STD_NTSC_M,
-	cx25821_set_tvnorm(dev, dev->tvnorm);
-	mutex_unlock(&dev->lock);
-
 	return 0;
 
 fail_unreg:
diff --git a/drivers/media/pci/cx25821/cx25821-video.h b/drivers/media/pci/cx25821/cx25821-video.h
index 9d70020..b0f0d53 100644
--- a/drivers/media/pci/cx25821/cx25821-video.h
+++ b/drivers/media/pci/cx25821/cx25821-video.h
@@ -67,12 +67,6 @@ do {									\
 extern void cx25821_video_wakeup(struct cx25821_dev *dev,
 				 struct cx25821_dmaqueue *q, u32 count);
 
-extern int cx25821_res_get(struct cx25821_dev *dev, struct cx25821_fh *fh,
-			   unsigned int bit);
-extern int cx25821_res_check(struct cx25821_fh *fh, unsigned int bit);
-extern int cx25821_res_locked(struct cx25821_fh *fh, unsigned int bit);
-extern void cx25821_res_free(struct cx25821_dev *dev, struct cx25821_fh *fh,
-			     unsigned int bits);
 extern int cx25821_start_video_dma(struct cx25821_dev *dev,
 				   struct cx25821_dmaqueue *q,
 				   struct cx25821_buffer *buf,
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index 95dbf70..ad56232 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -222,7 +222,6 @@ struct cx25821_channel {
 
 	const struct sram_channel *sram_channels;
 
-	struct mutex lock;
 	int resources;
 
 	int pixel_formats;
-- 
1.7.10.4

