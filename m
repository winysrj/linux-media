Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3869 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab3DNP1t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:27:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 13/30] cx25821: embed video_device, clean up some kernel log spam
Date: Sun, 14 Apr 2013 17:27:09 +0200
Message-Id: <1365953246-8972-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Embed the video_device struct instead of allocating it.

Remove some of the annoying and ugly kernel messages shown during
loading and unloading of the module.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-core.c  |   15 +-------
 drivers/media/pci/cx25821/cx25821-video.c |   54 ++++++++---------------------
 drivers/media/pci/cx25821/cx25821.h       |    2 +-
 3 files changed, 16 insertions(+), 55 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index 82c2db0..f3a48a1 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -845,8 +845,7 @@ static void cx25821_dev_checkrevision(struct cx25821_dev *dev)
 {
 	dev->hwrevision = cx_read(RDR_CFG2) & 0xff;
 
-	pr_info("%s(): Hardware revision = 0x%02x\n",
-		__func__, dev->hwrevision);
+	pr_info("Hardware revision = 0x%02x\n", dev->hwrevision);
 }
 
 static void cx25821_iounmap(struct cx25821_dev *dev)
@@ -856,7 +855,6 @@ static void cx25821_iounmap(struct cx25821_dev *dev)
 
 	/* Releasing IO memory */
 	if (dev->lmmio != NULL) {
-		CX25821_INFO("Releasing lmmio.\n");
 		iounmap(dev->lmmio);
 		dev->lmmio = NULL;
 	}
@@ -867,10 +865,6 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 	static unsigned int cx25821_devcount;
 	int i;
 
-	pr_info("\n***********************************\n");
-	pr_info("cx25821 set up\n");
-	pr_info("***********************************\n\n");
-
 	mutex_init(&dev->lock);
 
 	dev->nr = ++cx25821_devcount;
@@ -950,17 +944,12 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 /*  cx25821_i2c_register(&dev->i2c_bus[1]);
  *  cx25821_i2c_register(&dev->i2c_bus[2]); */
 
-	CX25821_INFO("i2c register! bus->i2c_rc = %d\n",
-			dev->i2c_bus[0].i2c_rc);
-
 	if (medusa_video_init(dev) < 0)
 		CX25821_ERR("%s(): Failed to initialize medusa!\n", __func__);
 
 	cx25821_video_register(dev);
 
 	cx25821_dev_checkrevision(dev);
-	CX25821_INFO("setup done!\n");
-
 	return 0;
 }
 
@@ -1337,8 +1326,6 @@ static int cx25821_initdev(struct pci_dev *pci_dev,
 		goto fail_unregister_device;
 	}
 
-	pr_info("Athena pci enable !\n");
-
 	err = cx25821_dev_setup(dev);
 	if (err) {
 		if (err == -EBUSY)
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 9919a0e..41e3475 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -144,26 +144,6 @@ static int cx25821_set_tvnorm(struct cx25821_dev *dev, v4l2_std_id norm)
 	return 0;
 }
 
-static struct video_device *cx25821_vdev_init(struct cx25821_dev *dev,
-				       struct pci_dev *pci,
-				       const struct video_device *template,
-				       char *type)
-{
-	struct video_device *vfd;
-	dprintk(1, "%s()\n", __func__);
-
-	vfd = video_device_alloc();
-	if (NULL == vfd)
-		return NULL;
-	*vfd = *template;
-	vfd->v4l2_dev = &dev->v4l2_dev;
-	vfd->release = video_device_release;
-	snprintf(vfd->name, sizeof(vfd->name), "%s %s (%s)", dev->name, type,
-		 cx25821_boards[dev->board].name);
-	video_set_drvdata(vfd, dev);
-	return vfd;
-}
-
 /*
 static int cx25821_ctrl_query(struct v4l2_queryctrl *qctrl)
 {
@@ -657,7 +637,7 @@ static int video_open(struct file *file)
 			v4l2_type_names[type]);
 
 	for (ch_id = 0; ch_id < MAX_VID_CHANNEL_NUM - 1; ch_id++)
-		if (dev->channels[ch_id].video_dev == vdev)
+		if (&dev->channels[ch_id].vdev == vdev)
 			break;
 
 	/* Can't happen */
@@ -1692,6 +1672,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 static const struct video_device cx25821_video_device = {
 	.name = "cx25821-video",
 	.fops = &video_fops,
+	.release = video_device_release_empty,
 	.minor = -1,
 	.ioctl_ops = &video_ioctl_ops,
 	.tvnorms = CX25821_NORMS,
@@ -1701,22 +1682,12 @@ void cx25821_video_unregister(struct cx25821_dev *dev, int chan_num)
 {
 	cx_clear(PCI_INT_MSK, 1);
 
-	if (dev->channels[chan_num].video_dev) {
-		if (video_is_registered(dev->channels[chan_num].video_dev))
-			video_unregister_device(
-					dev->channels[chan_num].video_dev);
-		else
-			video_device_release(
-					dev->channels[chan_num].video_dev);
-
-		dev->channels[chan_num].video_dev = NULL;
+	if (video_is_registered(&dev->channels[chan_num].vdev)) {
+		video_unregister_device(&dev->channels[chan_num].vdev);
 
 		btcx_riscmem_free(dev->pci,
 				&dev->channels[chan_num].vidq.stopper);
-
-		pr_warn("device %d released!\n", chan_num);
 	}
-
 }
 
 int cx25821_video_register(struct cx25821_dev *dev)
@@ -1727,6 +1698,8 @@ int cx25821_video_register(struct cx25821_dev *dev)
 	spin_lock_init(&dev->slock);
 
 	for (i = 0; i < VID_CHANNEL_NUM; ++i) {
+		struct video_device *vdev = &dev->channels[i].vdev;
+
 		if (i == SRAM_CH08) /* audio channel */
 			continue;
 
@@ -1736,7 +1709,6 @@ int cx25821_video_register(struct cx25821_dev *dev)
 			dev->channels[i].sram_channels->dma_ctl, 0x11, 0);
 
 		dev->channels[i].sram_channels = &cx25821_sram_channels[i];
-		dev->channels[i].video_dev = NULL;
 		dev->channels[i].resources = 0;
 
 		cx_write(dev->channels[i].sram_channels->int_stat, 0xffffffff);
@@ -1753,15 +1725,16 @@ int cx25821_video_register(struct cx25821_dev *dev)
 		init_timer(&dev->channels[i].vidq.timeout);
 
 		/* register v4l devices */
-		dev->channels[i].video_dev = cx25821_vdev_init(dev, dev->pci,
-				&cx25821_video_device, "video");
+		*vdev = cx25821_video_device;
+		vdev->v4l2_dev = &dev->v4l2_dev;
+		snprintf(vdev->name, sizeof(vdev->name), "%s #%d", dev->name, i);
+		video_set_drvdata(vdev, dev);
 
-		err = video_register_device(dev->channels[i].video_dev,
-				VFL_TYPE_GRABBER, video_nr[dev->nr]);
+		err = video_register_device(vdev, VFL_TYPE_GRABBER,
+					    video_nr[dev->nr]);
 
 		if (err < 0)
 			goto fail_unreg;
-
 	}
 
 	/* set PCI interrupt */
@@ -1776,6 +1749,7 @@ int cx25821_video_register(struct cx25821_dev *dev)
 	return 0;
 
 fail_unreg:
-	cx25821_video_unregister(dev, i);
+	while (i >= 0)
+		cx25821_video_unregister(dev, i--);
 	return err;
 }
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index 61c6cfc..df2ea22 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -217,7 +217,7 @@ struct cx25821_channel {
 	int ctl_saturation;
 	struct cx25821_data timeout_data;
 
-	struct video_device *video_dev;
+	struct video_device vdev;
 	struct cx25821_dmaqueue vidq;
 
 	const struct sram_channel *sram_channels;
-- 
1.7.10.4

