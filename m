Return-path: <mchehab@pedra>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2965 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab1AHNhG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 08:37:06 -0500
Received: from localhost.localdomain (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id p08Dalk9015112
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 8 Jan 2011 14:37:05 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv3 PATCH 12/16] radio-cadet: convert to core-assisted locking
Date: Sat,  8 Jan 2011 14:36:37 +0100
Message-Id: <313b22dac11eaa0b6c3c6c81c755d65b2259dd1d.1294493428.git.hverkuil@xs4all.nl>
In-Reply-To: <1294493801-17406-1-git-send-email-hverkuil@xs4all.nl>
References: <1294493801-17406-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1d57787db3bd1a76d292bd80d91ba9e10c07af68.1294493427.git.hverkuil@xs4all.nl>
References: <1d57787db3bd1a76d292bd80d91ba9e10c07af68.1294493427.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/radio/radio-cadet.c |   51 ++++++++-----------------------------
 1 files changed, 11 insertions(+), 40 deletions(-)

diff --git a/drivers/media/radio/radio-cadet.c b/drivers/media/radio/radio-cadet.c
index bc9ad08..4a37b69 100644
--- a/drivers/media/radio/radio-cadet.c
+++ b/drivers/media/radio/radio-cadet.c
@@ -72,7 +72,7 @@ struct cadet {
 	struct timer_list readtimer;
 	__u8 rdsin, rdsout, rdsstat;
 	unsigned char rdsbuf[RDS_BUFFER];
-	struct mutex lock;
+	struct mutex v4l2_lock;
 	int reading;
 };
 
@@ -91,17 +91,13 @@ static __u16 sigtable[2][4] = {
 
 static int cadet_getstereo(struct cadet *dev)
 {
-	int ret = V4L2_TUNER_SUB_MONO;
-
 	if (dev->curtuner != 0)	/* Only FM has stereo capability! */
 		return V4L2_TUNER_SUB_MONO;
 
-	mutex_lock(&dev->lock);
 	outb(7, dev->io);          /* Select tuner control */
 	if ((inb(dev->io + 1) & 0x40) == 0)
-		ret = V4L2_TUNER_SUB_STEREO;
-	mutex_unlock(&dev->lock);
-	return ret;
+		return V4L2_TUNER_SUB_STEREO;
+	return V4L2_TUNER_SUB_MONO;
 }
 
 static unsigned cadet_gettune(struct cadet *dev)
@@ -112,9 +108,6 @@ static unsigned cadet_gettune(struct cadet *dev)
 	/*
 	 * Prepare for read
 	 */
-
-	mutex_lock(&dev->lock);
-
 	outb(7, dev->io);       /* Select tuner control */
 	curvol = inb(dev->io + 1); /* Save current volume/mute setting */
 	outb(0x00, dev->io + 1);  /* Ensure WRITE-ENABLE is LOW */
@@ -136,8 +129,6 @@ static unsigned cadet_gettune(struct cadet *dev)
 	 * Restore volume/mute setting
 	 */
 	outb(curvol, dev->io + 1);
-	mutex_unlock(&dev->lock);
-
 	return fifo;
 }
 
@@ -176,8 +167,6 @@ static void cadet_settune(struct cadet *dev, unsigned fifo)
 	int i;
 	unsigned test;
 
-	mutex_lock(&dev->lock);
-
 	outb(7, dev->io);                /* Select tuner control */
 	/*
 	 * Write the shift register
@@ -196,7 +185,6 @@ static void cadet_settune(struct cadet *dev, unsigned fifo)
 		test = 0x1c | ((fifo >> 23) & 0x02);
 		outb(test, dev->io + 1);
 	}
-	mutex_unlock(&dev->lock);
 }
 
 static void cadet_setfreq(struct cadet *dev, unsigned freq)
@@ -231,10 +219,8 @@ static void cadet_setfreq(struct cadet *dev, unsigned freq)
 	 * Save current volume/mute setting
 	 */
 
-	mutex_lock(&dev->lock);
 	outb(7, dev->io);                /* Select tuner control */
 	curvol = inb(dev->io + 1);
-	mutex_unlock(&dev->lock);
 
 	/*
 	 * Tune the card
@@ -242,10 +228,8 @@ static void cadet_setfreq(struct cadet *dev, unsigned freq)
 	for (j = 3; j > -1; j--) {
 		cadet_settune(dev, fifo | (j << 16));
 
-		mutex_lock(&dev->lock);
 		outb(7, dev->io);         /* Select tuner control */
 		outb(curvol, dev->io + 1);
-		mutex_unlock(&dev->lock);
 
 		msleep(100);
 
@@ -261,28 +245,20 @@ static void cadet_setfreq(struct cadet *dev, unsigned freq)
 
 static int cadet_getvol(struct cadet *dev)
 {
-	int ret = 0;
-
-	mutex_lock(&dev->lock);
-
 	outb(7, dev->io);                /* Select tuner control */
 	if ((inb(dev->io + 1) & 0x20) != 0)
-		ret = 0xffff;
-
-	mutex_unlock(&dev->lock);
-	return ret;
+		return 0xffff;
+	return 0;
 }
 
 
 static void cadet_setvol(struct cadet *dev, int vol)
 {
-	mutex_lock(&dev->lock);
 	outb(7, dev->io);                /* Select tuner control */
 	if (vol > 0)
 		outb(0x20, dev->io + 1);
 	else
 		outb(0x00, dev->io + 1);
-	mutex_unlock(&dev->lock);
 }
 
 static void cadet_handler(unsigned long data)
@@ -290,7 +266,7 @@ static void cadet_handler(unsigned long data)
 	struct cadet *dev = (void *)data;
 
 	/* Service the RDS fifo */
-	if (mutex_trylock(&dev->lock)) {
+	if (mutex_trylock(&dev->v4l2_lock)) {
 		outb(0x3, dev->io);       /* Select RDS Decoder Control */
 		if ((inb(dev->io + 1) & 0x20) != 0)
 			printk(KERN_CRIT "cadet: RDS fifo overflow\n");
@@ -302,7 +278,7 @@ static void cadet_handler(unsigned long data)
 			else
 				dev->rdsin++;
 		}
-		mutex_unlock(&dev->lock);
+		mutex_unlock(&dev->v4l2_lock);
 	}
 
 	/*
@@ -328,7 +304,6 @@ static ssize_t cadet_read(struct file *file, char __user *data, size_t count, lo
 	unsigned char readbuf[RDS_BUFFER];
 	int i = 0;
 
-	mutex_lock(&dev->lock);
 	if (dev->rdsstat == 0) {
 		dev->rdsstat = 1;
 		outb(0x80, dev->io);        /* Select RDS fifo */
@@ -339,15 +314,14 @@ static ssize_t cadet_read(struct file *file, char __user *data, size_t count, lo
 		add_timer(&dev->readtimer);
 	}
 	if (dev->rdsin == dev->rdsout) {
-		mutex_unlock(&dev->lock);
 		if (file->f_flags & O_NONBLOCK)
 			return -EWOULDBLOCK;
+		mutex_unlock(&dev->v4l2_lock);
 		interruptible_sleep_on(&dev->read_queue);
-		mutex_lock(&dev->lock);
+		mutex_lock(&dev->v4l2_lock);
 	}
 	while (i < count && dev->rdsin != dev->rdsout)
 		readbuf[i++] = dev->rdsbuf[dev->rdsout++];
-	mutex_unlock(&dev->lock);
 
 	if (copy_to_user(data, readbuf, i))
 		return -EFAULT;
@@ -527,11 +501,9 @@ static int cadet_open(struct file *file)
 {
 	struct cadet *dev = video_drvdata(file);
 
-	mutex_lock(&dev->lock);
 	dev->users++;
 	if (1 == dev->users)
 		init_waitqueue_head(&dev->read_queue);
-	mutex_unlock(&dev->lock);
 	return 0;
 }
 
@@ -539,13 +511,11 @@ static int cadet_release(struct file *file)
 {
 	struct cadet *dev = video_drvdata(file);
 
-	mutex_lock(&dev->lock);
 	dev->users--;
 	if (0 == dev->users) {
 		del_timer_sync(&dev->readtimer);
 		dev->rdsstat = 0;
 	}
-	mutex_unlock(&dev->lock);
 	return 0;
 }
 
@@ -654,7 +624,7 @@ static int __init cadet_init(void)
 	int res;
 
 	strlcpy(v4l2_dev->name, "cadet", sizeof(v4l2_dev->name));
-	mutex_init(&dev->lock);
+	mutex_init(&dev->v4l2_lock);
 
 	/* If a probe was requested then probe ISAPnP first (safest) */
 	if (io < 0)
@@ -688,6 +658,7 @@ static int __init cadet_init(void)
 	dev->vdev.fops = &cadet_fops;
 	dev->vdev.ioctl_ops = &cadet_ioctl_ops;
 	dev->vdev.release = video_device_release_empty;
+	dev->vdev.lock = &dev->v4l2_lock;
 	video_set_drvdata(&dev->vdev, dev);
 
 	if (video_register_device(&dev->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
-- 
1.7.0.4

