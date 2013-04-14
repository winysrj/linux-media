Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2866 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3DNP1q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:27:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 04/30] cx25821: remove bogus radio/vbi/'video-ioctl' support.
Date: Sun, 14 Apr 2013 17:27:00 +0200
Message-Id: <1365953246-8972-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This device does not support radio or vbi, so remove anything referring
to that.

In addition, the driver created an 'video ioctl' node, which was unused and
was effectively identical to the first video node.

This bogus video node is now removed, leaving us with 8 video capture nodes
and 2 video output nodes.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-core.c  |   13 --
 drivers/media/pci/cx25821/cx25821-video.c |  201 +++++++++++++----------------
 drivers/media/pci/cx25821/cx25821-video.h |    1 -
 drivers/media/pci/cx25821/cx25821.h       |   16 ---
 4 files changed, 88 insertions(+), 143 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index 1f47422..2b38a50 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -988,17 +988,6 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 
 	cx25821_video_register(dev);
 
-	/* register IOCTL device */
-	dev->ioctl_dev = cx25821_vdev_init(dev, dev->pci,
-			&cx25821_videoioctl_template, "video");
-
-	if (video_register_device
-	    (dev->ioctl_dev, VFL_TYPE_GRABBER, VIDEO_IOCTL_CH) < 0) {
-		cx25821_videoioctl_unregister(dev);
-		pr_err("%s(): Failed to register video adapter for IOCTL, so unregistering videoioctl device\n",
-		       __func__);
-	}
-
 	cx25821_dev_checkrevision(dev);
 	CX25821_INFO("setup done!\n");
 
@@ -1057,8 +1046,6 @@ void cx25821_dev_unregister(struct cx25821_dev *dev)
 		cx25821_video_unregister(dev, i);
 	}
 
-	cx25821_videoioctl_unregister(dev);
-
 	cx25821_i2c_unregister(&dev->i2c_bus[0]);
 	cx25821_iounmap(dev);
 }
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 4eaa67a..e785bb9 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -33,13 +33,10 @@ MODULE_AUTHOR("Hiep Huynh <hiep.huynh@conexant.com>");
 MODULE_LICENSE("GPL");
 
 static unsigned int video_nr[] = {[0 ... (CX25821_MAXBOARDS - 1)] = UNSET };
-static unsigned int radio_nr[] = {[0 ... (CX25821_MAXBOARDS - 1)] = UNSET };
 
 module_param_array(video_nr, int, NULL, 0444);
-module_param_array(radio_nr, int, NULL, 0444);
 
 MODULE_PARM_DESC(video_nr, "video device numbers");
-MODULE_PARM_DESC(radio_nr, "radio device numbers");
 
 static unsigned int video_debug = VIDEO_DEBUG;
 module_param(video_debug, int, 0644);
@@ -55,9 +52,6 @@ MODULE_PARM_DESC(vid_limit, "capture memory limit in megabytes");
 
 static void cx25821_init_controls(struct cx25821_dev *dev, int chan_num);
 
-static const struct v4l2_file_operations video_fops;
-static const struct v4l2_ioctl_ops video_ioctl_ops;
-
 #define FORMAT_FLAGS_PACKED       0x01
 
 struct cx25821_fmt formats[] = {
@@ -411,111 +405,6 @@ int cx25821_video_irq(struct cx25821_dev *dev, int chan_num, u32 status)
 	return handled;
 }
 
-void cx25821_videoioctl_unregister(struct cx25821_dev *dev)
-{
-	if (dev->ioctl_dev) {
-		if (video_is_registered(dev->ioctl_dev))
-			video_unregister_device(dev->ioctl_dev);
-		else
-			video_device_release(dev->ioctl_dev);
-
-		dev->ioctl_dev = NULL;
-	}
-}
-
-void cx25821_video_unregister(struct cx25821_dev *dev, int chan_num)
-{
-	cx_clear(PCI_INT_MSK, 1);
-
-	if (dev->channels[chan_num].video_dev) {
-		if (video_is_registered(dev->channels[chan_num].video_dev))
-			video_unregister_device(
-					dev->channels[chan_num].video_dev);
-		else
-			video_device_release(
-					dev->channels[chan_num].video_dev);
-
-		dev->channels[chan_num].video_dev = NULL;
-
-		btcx_riscmem_free(dev->pci,
-				&dev->channels[chan_num].vidq.stopper);
-
-		pr_warn("device %d released!\n", chan_num);
-	}
-
-}
-
-int cx25821_video_register(struct cx25821_dev *dev)
-{
-	static const struct video_device cx25821_video_device = {
-		.name = "cx25821-video",
-		.fops = &video_fops,
-		.minor = -1,
-		.ioctl_ops = &video_ioctl_ops,
-		.tvnorms = CX25821_NORMS,
-		.current_norm = V4L2_STD_NTSC_M,
-	};
-	int err;
-	int i;
-
-	spin_lock_init(&dev->slock);
-
-	for (i = 0; i < VID_CHANNEL_NUM; ++i) {
-		if (i == SRAM_CH08) /* audio channel */
-			continue;
-
-		cx25821_init_controls(dev, i);
-
-		cx25821_risc_stopper(dev->pci, &dev->channels[i].vidq.stopper,
-			dev->channels[i].sram_channels->dma_ctl, 0x11, 0);
-
-		dev->channels[i].sram_channels = &cx25821_sram_channels[i];
-		dev->channels[i].video_dev = NULL;
-		dev->channels[i].resources = 0;
-
-		cx_write(dev->channels[i].sram_channels->int_stat, 0xffffffff);
-
-		INIT_LIST_HEAD(&dev->channels[i].vidq.active);
-		INIT_LIST_HEAD(&dev->channels[i].vidq.queued);
-
-		dev->channels[i].timeout_data.dev = dev;
-		dev->channels[i].timeout_data.channel =
-			&cx25821_sram_channels[i];
-		dev->channels[i].vidq.timeout.function = cx25821_vid_timeout;
-		dev->channels[i].vidq.timeout.data =
-			(unsigned long)&dev->channels[i].timeout_data;
-		init_timer(&dev->channels[i].vidq.timeout);
-
-		/* register v4l devices */
-		dev->channels[i].video_dev = cx25821_vdev_init(dev, dev->pci,
-				&cx25821_video_device, "video");
-
-		err = video_register_device(dev->channels[i].video_dev,
-				VFL_TYPE_GRABBER, video_nr[dev->nr]);
-
-		if (err < 0)
-			goto fail_unreg;
-
-	}
-
-	/* set PCI interrupt */
-	cx_set(PCI_INT_MSK, 0xff);
-
-	/* initial device configuration */
-	mutex_lock(&dev->lock);
-#ifdef TUNER_FLAG
-	dev->tvnorm = cx25821_video_device.current_norm;
-	cx25821_set_tvnorm(dev, dev->tvnorm);
-#endif
-	mutex_unlock(&dev->lock);
-
-	return 0;
-
-fail_unreg:
-	cx25821_video_unregister(dev, i);
-	return err;
-}
-
 int cx25821_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 		 unsigned int *size)
 {
@@ -1983,10 +1872,96 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 #endif
 };
 
-struct video_device cx25821_videoioctl_template = {
-	.name = "cx25821-videoioctl",
+static const struct video_device cx25821_video_device = {
+	.name = "cx25821-video",
 	.fops = &video_fops,
+	.minor = -1,
 	.ioctl_ops = &video_ioctl_ops,
 	.tvnorms = CX25821_NORMS,
 	.current_norm = V4L2_STD_NTSC_M,
 };
+
+void cx25821_video_unregister(struct cx25821_dev *dev, int chan_num)
+{
+	cx_clear(PCI_INT_MSK, 1);
+
+	if (dev->channels[chan_num].video_dev) {
+		if (video_is_registered(dev->channels[chan_num].video_dev))
+			video_unregister_device(
+					dev->channels[chan_num].video_dev);
+		else
+			video_device_release(
+					dev->channels[chan_num].video_dev);
+
+		dev->channels[chan_num].video_dev = NULL;
+
+		btcx_riscmem_free(dev->pci,
+				&dev->channels[chan_num].vidq.stopper);
+
+		pr_warn("device %d released!\n", chan_num);
+	}
+
+}
+
+int cx25821_video_register(struct cx25821_dev *dev)
+{
+	int err;
+	int i;
+
+	spin_lock_init(&dev->slock);
+
+	for (i = 0; i < VID_CHANNEL_NUM; ++i) {
+		if (i == SRAM_CH08) /* audio channel */
+			continue;
+
+		cx25821_init_controls(dev, i);
+
+		cx25821_risc_stopper(dev->pci, &dev->channels[i].vidq.stopper,
+			dev->channels[i].sram_channels->dma_ctl, 0x11, 0);
+
+		dev->channels[i].sram_channels = &cx25821_sram_channels[i];
+		dev->channels[i].video_dev = NULL;
+		dev->channels[i].resources = 0;
+
+		cx_write(dev->channels[i].sram_channels->int_stat, 0xffffffff);
+
+		INIT_LIST_HEAD(&dev->channels[i].vidq.active);
+		INIT_LIST_HEAD(&dev->channels[i].vidq.queued);
+
+		dev->channels[i].timeout_data.dev = dev;
+		dev->channels[i].timeout_data.channel =
+			&cx25821_sram_channels[i];
+		dev->channels[i].vidq.timeout.function = cx25821_vid_timeout;
+		dev->channels[i].vidq.timeout.data =
+			(unsigned long)&dev->channels[i].timeout_data;
+		init_timer(&dev->channels[i].vidq.timeout);
+
+		/* register v4l devices */
+		dev->channels[i].video_dev = cx25821_vdev_init(dev, dev->pci,
+				&cx25821_video_device, "video");
+
+		err = video_register_device(dev->channels[i].video_dev,
+				VFL_TYPE_GRABBER, video_nr[dev->nr]);
+
+		if (err < 0)
+			goto fail_unreg;
+
+	}
+
+	/* set PCI interrupt */
+	cx_set(PCI_INT_MSK, 0xff);
+
+	/* initial device configuration */
+	mutex_lock(&dev->lock);
+#ifdef TUNER_FLAG
+	dev->tvnorm = cx25821_video_device.current_norm;
+	cx25821_set_tvnorm(dev, dev->tvnorm);
+#endif
+	mutex_unlock(&dev->lock);
+
+	return 0;
+
+fail_unreg:
+	cx25821_video_unregister(dev, i);
+	return err;
+}
diff --git a/drivers/media/pci/cx25821/cx25821-video.h b/drivers/media/pci/cx25821/cx25821-video.h
index 11ba5eb..37cb0c1 100644
--- a/drivers/media/pci/cx25821/cx25821-video.h
+++ b/drivers/media/pci/cx25821/cx25821-video.h
@@ -76,7 +76,6 @@ extern struct sram_channel *channel7;
 extern struct sram_channel *channel9;
 extern struct sram_channel *channel10;
 extern struct sram_channel *channel11;
-extern struct video_device cx25821_videoioctl_template;
 /* extern const u32 *ctrl_classes[]; */
 
 extern unsigned int vid_limit;
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index 85693cd..04c3cb0 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -80,7 +80,6 @@
 #define RESOURCE_VIDEO9       512
 #define RESOURCE_VIDEO10      1024
 #define RESOURCE_VIDEO11      2048
-#define RESOURCE_VIDEO_IOCTL  4096
 
 #define BUFFER_TIMEOUT     (HZ)	/* 0.5 seconds */
 
@@ -125,7 +124,6 @@ struct cx25821_tvnorm {
 struct cx25821_fh {
 	struct cx25821_dev *dev;
 	enum v4l2_buf_type type;
-	int radio;
 	u32 resources;
 
 	enum v4l2_priority prio;
@@ -139,10 +137,7 @@ struct cx25821_fh {
 	struct cx25821_fmt *fmt;
 	unsigned int width, height;
 	int channel_id;
-
-	/* vbi capture */
 	struct videobuf_queue vidq;
-	struct videobuf_queue vbiq;
 
 	/* H264 Encoder specifics ONLY */
 	struct videobuf_queue mpegq;
@@ -153,7 +148,6 @@ enum cx25821_itype {
 	CX25821_VMUX_COMPOSITE = 1,
 	CX25821_VMUX_SVIDEO,
 	CX25821_VMUX_DEBUG,
-	CX25821_RADIO,
 };
 
 enum cx25821_src_sel_type {
@@ -191,9 +185,7 @@ struct cx25821_board {
 	enum port portb;
 	enum port portc;
 	unsigned int tuner_type;
-	unsigned int radio_type;
 	unsigned char tuner_addr;
-	unsigned char radio_addr;
 
 	u32 clk_freq;
 	struct cx25821_input input[CX25821_NR_INPUT];
@@ -295,9 +287,6 @@ struct cx25821_dev {
 	v4l2_std_id tvnorm;
 	unsigned int tuner_type;
 	unsigned char tuner_addr;
-	unsigned int radio_type;
-	unsigned char radio_addr;
-	unsigned int has_radio;
 	unsigned int videc_type;
 	unsigned char videc_addr;
 	unsigned short _max_num_decoders;
@@ -326,9 +315,6 @@ struct cx25821_dev {
 
 	/* V4l */
 	u32 freq;
-	struct video_device *vbi_dev;
-	struct video_device *radio_dev;
-	struct video_device *ioctl_dev;
 
 	spinlock_t slock;
 
@@ -467,7 +453,6 @@ extern struct cx25821_subid cx25821_subids[];
 #define VID_UPSTREAM_SRAM_CHANNEL_I     SRAM_CH09
 #define VID_UPSTREAM_SRAM_CHANNEL_J     SRAM_CH10
 #define AUDIO_UPSTREAM_SRAM_CHANNEL_B   SRAM_CH11
-#define VIDEO_IOCTL_CH  11
 
 struct sram_channel {
 	char *name;
@@ -607,7 +592,6 @@ extern int cx25821_sram_channel_setup_upstream(struct cx25821_dev *dev,
 					       unsigned int bpl, u32 risc);
 extern void cx25821_set_pixel_format(struct cx25821_dev *dev, int channel,
 				     u32 format);
-extern void cx25821_videoioctl_unregister(struct cx25821_dev *dev);
 extern struct video_device *cx25821_vdev_init(struct cx25821_dev *dev,
 					      struct pci_dev *pci,
 					      const struct video_device *template,
-- 
1.7.10.4

