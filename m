Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3917 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab2GEK0Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 06:26:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	halli manjunatha <hallimanju@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/6] radio-cadet: fix RDS handling.
Date: Thu,  5 Jul 2012 12:25:32 +0200
Message-Id: <ab3562bbd84fe6635ff30a8c7372f7088107afb1.1341483687.git.hans.verkuil@cisco.com>
In-Reply-To: <1341483933-9986-1-git-send-email-hverkuil@xs4all.nl>
References: <1341483933-9986-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9f434bb4733245d7342b1547f65e40dae1603cd5.1341483687.git.hans.verkuil@cisco.com>
References: <9f434bb4733245d7342b1547f65e40dae1603cd5.1341483687.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The current RDS code suffered from bit rot. Clean it up and make it work again.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/radio-cadet.c |   56 ++++++++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 17 deletions(-)

diff --git a/drivers/media/radio/radio-cadet.c b/drivers/media/radio/radio-cadet.c
index 93536b7..d1fb427 100644
--- a/drivers/media/radio/radio-cadet.c
+++ b/drivers/media/radio/radio-cadet.c
@@ -71,7 +71,7 @@ struct cadet {
 	int sigstrength;
 	wait_queue_head_t read_queue;
 	struct timer_list readtimer;
-	__u8 rdsin, rdsout, rdsstat;
+	u8 rdsin, rdsout, rdsstat;
 	unsigned char rdsbuf[RDS_BUFFER];
 	struct mutex lock;
 	int reading;
@@ -85,8 +85,8 @@ static struct cadet cadet_card;
  * strength value.  These values are in microvolts of RF at the tuner's input.
  */
 static __u16 sigtable[2][4] = {
-	{  5, 10, 30,  150 },
-	{ 28, 40, 63, 1000 }
+	{ 2185, 4369, 13107, 65535 },
+	{ 1835, 2621,  4128, 65535 }
 };
 
 
@@ -240,10 +240,13 @@ static void cadet_setfreq(struct cadet *dev, unsigned freq)
 		cadet_gettune(dev);
 		if ((dev->tunestat & 0x40) == 0) {   /* Tuned */
 			dev->sigstrength = sigtable[dev->curtuner][j];
-			return;
+			goto reset_rds;
 		}
 	}
 	dev->sigstrength = 0;
+reset_rds:
+	outb(3, dev->io);
+	outb(inb(dev->io + 1) & 0x7f, dev->io + 1);
 }
 
 
@@ -259,7 +262,7 @@ static void cadet_handler(unsigned long data)
 		outb(0x80, dev->io);      /* Select RDS fifo */
 		while ((inb(dev->io) & 0x80) != 0) {
 			dev->rdsbuf[dev->rdsin] = inb(dev->io + 1);
-			if (dev->rdsin == dev->rdsout)
+			if (dev->rdsin + 1 == dev->rdsout)
 				printk(KERN_WARNING "cadet: RDS buffer overflow\n");
 			else
 				dev->rdsin++;
@@ -278,11 +281,21 @@ static void cadet_handler(unsigned long data)
 	 */
 	init_timer(&dev->readtimer);
 	dev->readtimer.function = cadet_handler;
-	dev->readtimer.data = (unsigned long)0;
+	dev->readtimer.data = data;
 	dev->readtimer.expires = jiffies + msecs_to_jiffies(50);
 	add_timer(&dev->readtimer);
 }
 
+static void cadet_start_rds(struct cadet *dev)
+{
+	dev->rdsstat = 1;
+	outb(0x80, dev->io);        /* Select RDS fifo */
+	init_timer(&dev->readtimer);
+	dev->readtimer.function = cadet_handler;
+	dev->readtimer.data = (unsigned long)dev;
+	dev->readtimer.expires = jiffies + msecs_to_jiffies(50);
+	add_timer(&dev->readtimer);
+}
 
 static ssize_t cadet_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
 {
@@ -291,26 +304,21 @@ static ssize_t cadet_read(struct file *file, char __user *data, size_t count, lo
 	int i = 0;
 
 	mutex_lock(&dev->lock);
-	if (dev->rdsstat == 0) {
-		dev->rdsstat = 1;
-		outb(0x80, dev->io);        /* Select RDS fifo */
-		init_timer(&dev->readtimer);
-		dev->readtimer.function = cadet_handler;
-		dev->readtimer.data = (unsigned long)dev;
-		dev->readtimer.expires = jiffies + msecs_to_jiffies(50);
-		add_timer(&dev->readtimer);
-	}
+	if (dev->rdsstat == 0)
+		cadet_start_rds(dev);
 	if (dev->rdsin == dev->rdsout) {
 		if (file->f_flags & O_NONBLOCK) {
 			i = -EWOULDBLOCK;
 			goto unlock;
 		}
+		mutex_unlock(&dev->lock);
 		interruptible_sleep_on(&dev->read_queue);
+		mutex_lock(&dev->lock);
 	}
 	while (i < count && dev->rdsin != dev->rdsout)
 		readbuf[i++] = dev->rdsbuf[dev->rdsout++];
 
-	if (copy_to_user(data, readbuf, i))
+	if (i && copy_to_user(data, readbuf, i))
 		i = -EFAULT;
 unlock:
 	mutex_unlock(&dev->lock);
@@ -345,7 +353,12 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 		v->rangehigh = 1728000;    /* 108.0 MHz */
 		v->rxsubchans = cadet_getstereo(dev);
 		v->audmode = V4L2_TUNER_MODE_STEREO;
-		v->rxsubchans |= V4L2_TUNER_SUB_RDS;
+		outb(3, dev->io);
+		outb(inb(dev->io + 1) & 0x7f, dev->io + 1);
+		mdelay(100);
+		outb(3, dev->io);
+		if (inb(dev->io + 1) & 0x80)
+			v->rxsubchans |= V4L2_TUNER_SUB_RDS;
 		break;
 	case 1:
 		strlcpy(v->name, "AM", sizeof(v->name));
@@ -455,9 +468,16 @@ static int cadet_release(struct file *file)
 static unsigned int cadet_poll(struct file *file, struct poll_table_struct *wait)
 {
 	struct cadet *dev = video_drvdata(file);
+	unsigned long req_events = poll_requested_events(wait);
 	unsigned int res = v4l2_ctrl_poll(file, wait);
 
 	poll_wait(file, &dev->read_queue, wait);
+	if (dev->rdsstat == 0 && (req_events & (POLLIN | POLLRDNORM))) {
+		mutex_lock(&dev->lock);
+		if (dev->rdsstat == 0)
+			cadet_start_rds(dev);
+		mutex_unlock(&dev->lock);
+	}
 	if (dev->rdsin != dev->rdsout)
 		res |= POLLIN | POLLRDNORM;
 	return res;
@@ -628,6 +648,8 @@ static void __exit cadet_exit(void)
 	video_unregister_device(&dev->vdev);
 	v4l2_ctrl_handler_free(&dev->ctrl_handler);
 	v4l2_device_unregister(&dev->v4l2_dev);
+	outb(7, dev->io);	/* Mute */
+	outb(0x00, dev->io + 1);
 	release_region(dev->io, 2);
 	pnp_unregister_driver(&cadet_pnp_driver);
 }
-- 
1.7.10

