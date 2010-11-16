Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:1619 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab0KPVzv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 16:55:51 -0500
Message-Id: <124075f49669d3e7787e5f3156c30499f79bd817.1289944160.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1289944159.git.hverkuil@xs4all.nl>
References: <cover.1289944159.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Tue, 16 Nov 2010 22:55:46 +0100
Subject: [RFCv2 PATCH 03/15] cadet: use unlocked_ioctl
To: linux-media@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Converted from ioctl to unlocked_ioctl.

This driver already used an internal lock, but it was missing in cadet_open and
cadet_release and it was not used correctly in cadet_read.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/radio/radio-cadet.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/radio/radio-cadet.c b/drivers/media/radio/radio-cadet.c
index b701ea6..bc9ad08 100644
--- a/drivers/media/radio/radio-cadet.c
+++ b/drivers/media/radio/radio-cadet.c
@@ -328,11 +328,10 @@ static ssize_t cadet_read(struct file *file, char __user *data, size_t count, lo
 	unsigned char readbuf[RDS_BUFFER];
 	int i = 0;
 
+	mutex_lock(&dev->lock);
 	if (dev->rdsstat == 0) {
-		mutex_lock(&dev->lock);
 		dev->rdsstat = 1;
 		outb(0x80, dev->io);        /* Select RDS fifo */
-		mutex_unlock(&dev->lock);
 		init_timer(&dev->readtimer);
 		dev->readtimer.function = cadet_handler;
 		dev->readtimer.data = (unsigned long)dev;
@@ -340,12 +339,15 @@ static ssize_t cadet_read(struct file *file, char __user *data, size_t count, lo
 		add_timer(&dev->readtimer);
 	}
 	if (dev->rdsin == dev->rdsout) {
+		mutex_unlock(&dev->lock);
 		if (file->f_flags & O_NONBLOCK)
 			return -EWOULDBLOCK;
 		interruptible_sleep_on(&dev->read_queue);
+		mutex_lock(&dev->lock);
 	}
 	while (i < count && dev->rdsin != dev->rdsout)
 		readbuf[i++] = dev->rdsbuf[dev->rdsout++];
+	mutex_unlock(&dev->lock);
 
 	if (copy_to_user(data, readbuf, i))
 		return -EFAULT;
@@ -525,9 +527,11 @@ static int cadet_open(struct file *file)
 {
 	struct cadet *dev = video_drvdata(file);
 
+	mutex_lock(&dev->lock);
 	dev->users++;
 	if (1 == dev->users)
 		init_waitqueue_head(&dev->read_queue);
+	mutex_unlock(&dev->lock);
 	return 0;
 }
 
@@ -535,11 +539,13 @@ static int cadet_release(struct file *file)
 {
 	struct cadet *dev = video_drvdata(file);
 
+	mutex_lock(&dev->lock);
 	dev->users--;
 	if (0 == dev->users) {
 		del_timer_sync(&dev->readtimer);
 		dev->rdsstat = 0;
 	}
+	mutex_unlock(&dev->lock);
 	return 0;
 }
 
@@ -559,7 +565,7 @@ static const struct v4l2_file_operations cadet_fops = {
 	.open		= cadet_open,
 	.release       	= cadet_release,
 	.read		= cadet_read,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 	.poll		= cadet_poll,
 };
 
-- 
1.7.0.4

