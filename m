Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:43353 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384Ab3A0Tpn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jan 2013 14:45:43 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 3/7] saa7134: v4l2-compliance: use v4l2_fh to fix priority handling
Date: Sun, 27 Jan 2013 20:45:08 +0100
Message-Id: <1359315912-1767-4-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1359315912-1767-1-git-send-email-linux@rainbow-software.org>
References: <1359315912-1767-1-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make saa7134 driver more V4L2 compliant: remove broken priority handling
and use v4l2_fh instead

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/pci/saa7134/saa7134-core.c  |    3 +-
 drivers/media/pci/saa7134/saa7134-video.c |   61 +++-------------------------
 drivers/media/pci/saa7134/saa7134.h       |    4 +-
 3 files changed, 10 insertions(+), 58 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 8976d0e..ba08bd6 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -805,6 +805,7 @@ static struct video_device *vdev_init(struct saa7134_dev *dev,
 	vfd->debug   = video_debug;
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s (%s)",
 		 dev->name, type, saa7134_boards[dev->board].name);
+	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
 	video_set_drvdata(vfd, dev);
 	return vfd;
 }
@@ -1028,8 +1029,6 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 		}
 	}
 
-	v4l2_prio_init(&dev->prio);
-
 	mutex_lock(&saa7134_devlist_lock);
 	list_for_each_entry(mops, &mops_list, next)
 		mpeg_ops_attach(mops, dev);
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index db8da32..be745c0 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1176,14 +1176,6 @@ int saa7134_s_ctrl_internal(struct saa7134_dev *dev,  struct saa7134_fh *fh, str
 	int restart_overlay = 0;
 	int err;
 
-	/* When called from the empress code fh == NULL.
-	   That needs to be fixed somehow, but for now this is
-	   good enough. */
-	if (fh) {
-		err = v4l2_prio_check(&dev->prio, fh->prio);
-		if (0 != err)
-			return err;
-	}
 	err = -EINVAL;
 
 	mutex_lock(&dev->lock);
@@ -1352,6 +1344,7 @@ static int video_open(struct file *file)
 	if (NULL == fh)
 		return -ENOMEM;
 
+	v4l2_fh_init(&fh->fh, vdev);
 	file->private_data = fh;
 	fh->dev      = dev;
 	fh->radio    = radio;
@@ -1359,7 +1352,6 @@ static int video_open(struct file *file)
 	fh->fmt      = format_by_fourcc(V4L2_PIX_FMT_BGR24);
 	fh->width    = 720;
 	fh->height   = 576;
-	v4l2_prio_open(&dev->prio, &fh->prio);
 
 	videobuf_queue_sg_init(&fh->cap, &video_qops,
 			    &dev->pci->dev, &dev->slock,
@@ -1384,6 +1376,8 @@ static int video_open(struct file *file)
 		/* switch to video/vbi mode */
 		video_mux(dev,dev->ctl_input);
 	}
+	v4l2_fh_add(&fh->fh);
+
 	return 0;
 }
 
@@ -1504,7 +1498,8 @@ static int video_release(struct file *file)
 	saa7134_pgtable_free(dev->pci,&fh->pt_cap);
 	saa7134_pgtable_free(dev->pci,&fh->pt_vbi);
 
-	v4l2_prio_close(&dev->prio, fh->prio);
+	v4l2_fh_del(&fh->fh);
+	v4l2_fh_exit(&fh->fh);
 	file->private_data = NULL;
 	kfree(fh);
 	return 0;
@@ -1784,11 +1779,6 @@ static int saa7134_s_input(struct file *file, void *priv, unsigned int i)
 {
 	struct saa7134_fh *fh = priv;
 	struct saa7134_dev *dev = fh->dev;
-	int err;
-
-	err = v4l2_prio_check(&dev->prio, fh->prio);
-	if (0 != err)
-		return err;
 
 	if (i >= SAA7134_INPUT_MAX)
 		return -EINVAL;
@@ -1853,16 +1843,8 @@ int saa7134_s_std_internal(struct saa7134_dev *dev, struct saa7134_fh *fh, v4l2_
 	unsigned long flags;
 	unsigned int i;
 	v4l2_std_id fixup;
-	int err;
 
-	/* When called from the empress code fh == NULL.
-	   That needs to be fixed somehow, but for now this is
-	   good enough. */
-	if (fh) {
-		err = v4l2_prio_check(&dev->prio, fh->prio);
-		if (0 != err)
-			return err;
-	} else if (res_locked(dev, RESOURCE_OVERLAY)) {
+	if (!fh && res_locked(dev, RESOURCE_OVERLAY)) {
 		/* Don't change the std from the mpeg device
 		   if overlay is active. */
 		return -EBUSY;
@@ -2047,11 +2029,7 @@ static int saa7134_s_tuner(struct file *file, void *priv,
 {
 	struct saa7134_fh *fh = priv;
 	struct saa7134_dev *dev = fh->dev;
-	int rx, mode, err;
-
-	err = v4l2_prio_check(&dev->prio, fh->prio);
-	if (0 != err)
-		return err;
+	int rx, mode;
 
 	mode = dev->thread.mode;
 	if (UNSET == mode) {
@@ -2081,11 +2059,6 @@ static int saa7134_s_frequency(struct file *file, void *priv,
 {
 	struct saa7134_fh *fh = priv;
 	struct saa7134_dev *dev = fh->dev;
-	int err;
-
-	err = v4l2_prio_check(&dev->prio, fh->prio);
-	if (0 != err)
-		return err;
 
 	if (0 != f->tuner)
 		return -EINVAL;
@@ -2114,24 +2087,6 @@ static int saa7134_s_audio(struct file *file, void *priv, const struct v4l2_audi
 	return 0;
 }
 
-static int saa7134_g_priority(struct file *file, void *f, enum v4l2_priority *p)
-{
-	struct saa7134_fh *fh = f;
-	struct saa7134_dev *dev = fh->dev;
-
-	*p = v4l2_prio_max(&dev->prio);
-	return 0;
-}
-
-static int saa7134_s_priority(struct file *file, void *f,
-					enum v4l2_priority prio)
-{
-	struct saa7134_fh *fh = f;
-	struct saa7134_dev *dev = fh->dev;
-
-	return v4l2_prio_change(&dev->prio, &fh->prio, prio);
-}
-
 static int saa7134_enum_fmt_vid_cap(struct file *file, void  *priv,
 					struct v4l2_fmtdesc *f)
 {
@@ -2460,8 +2415,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_g_fbuf			= saa7134_g_fbuf,
 	.vidioc_s_fbuf			= saa7134_s_fbuf,
 	.vidioc_overlay			= saa7134_overlay,
-	.vidioc_g_priority		= saa7134_g_priority,
-	.vidioc_s_priority		= saa7134_s_priority,
 	.vidioc_g_parm			= saa7134_g_parm,
 	.vidioc_g_frequency		= saa7134_g_frequency,
 	.vidioc_s_frequency		= saa7134_s_frequency,
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 9059d08..2ffe069 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -35,6 +35,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-fh.h>
 #include <media/tuner.h>
 #include <media/rc-core.h>
 #include <media/ir-kbd-i2c.h>
@@ -466,11 +467,11 @@ struct saa7134_dmaqueue {
 
 /* video filehandle status */
 struct saa7134_fh {
+	struct v4l2_fh             fh;
 	struct saa7134_dev         *dev;
 	unsigned int               radio;
 	enum v4l2_buf_type         type;
 	unsigned int               resources;
-	enum v4l2_priority	   prio;
 
 	/* video overlay */
 	struct v4l2_window         win;
@@ -541,7 +542,6 @@ struct saa7134_dev {
 	struct list_head           devlist;
 	struct mutex               lock;
 	spinlock_t                 slock;
-	struct v4l2_prio_state     prio;
 	struct v4l2_device         v4l2_dev;
 	/* workstruct for loading modules */
 	struct work_struct request_module_wk;
-- 
Ondrej Zary

