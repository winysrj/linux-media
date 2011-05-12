Return-path: <mchehab@gaivota>
Received: from cmsout01.mbox.net ([165.212.64.31]:46399 "EHLO
	cmsout01.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571Ab1ELNrg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2011 09:47:36 -0400
Received: from cmsout01.mbox.net (cmsout01-lo [127.0.0.1])
	by cmsout01.mbox.net (Postfix) with ESMTP id 08C773AC0DB
	for <linux-media@vger.kernel.org>; Thu, 12 May 2011 13:47:35 +0000 (GMT)
Message-ID: <4DCBE4DD.1040202@usa.net>
Date: Thu, 12 May 2011 15:47:09 +0200
From: Issa Gorissen <flop.m@usa.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] ngene: blocking and nonblocking io for sec0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Patch allows for blocking or nonblocking io on the ngene sec0 device.
It also enforces one reader and one writer at a time.

Signed-off-by: Issa Gorissen <flop.m@usa.net>
--

--- a/linux/drivers/media/dvb/ngene/ngene-dvb.c	2011-05-10 19:11:21.000000000 +0200
+++ b/linux/drivers/media/dvb/ngene/ngene-dvb.c	2011-05-12 15:28:53.573185365 +0200
@@ -53,15 +53,29 @@ static ssize_t ts_write(struct file *fil
 	struct dvb_device *dvbdev = file->private_data;
 	struct ngene_channel *chan = dvbdev->priv;
 	struct ngene *dev = chan->dev;
+	int avail = 0;
+	char nonblock = file->f_flags & O_NONBLOCK;
 
-	if (wait_event_interruptible(dev->tsout_rbuf.queue,
-				     dvb_ringbuffer_free
-				     (&dev->tsout_rbuf) >= count) < 0)
+	if (!count)
 		return 0;
 
-	dvb_ringbuffer_write(&dev->tsout_rbuf, buf, count);
+	if (nonblock) {
+		avail = dvb_ringbuffer_avail(&dev->tsout_rbuf);
+		if (!avail)
+			return -EAGAIN;
+	} else {
+		while (1) {
+			if (wait_event_interruptible(dev->tsout_rbuf.queue,
+						     dvb_ringbuffer_free
+						     (&dev->tsout_rbuf) >= count) >= 0)
+				break;
+		}
+		avail = count;
+	}
+
+	dvb_ringbuffer_write(&dev->tsout_rbuf, buf, avail);
+	return avail;
 
-	return count;
 }
 
 static ssize_t ts_read(struct file *file, char *buf,
@@ -70,22 +84,35 @@ static ssize_t ts_read(struct file *file
 	struct dvb_device *dvbdev = file->private_data;
 	struct ngene_channel *chan = dvbdev->priv;
 	struct ngene *dev = chan->dev;
-	int left, avail;
+	int avail = 0;
+	char nonblock = file->f_flags & O_NONBLOCK;
 
-	left = count;
-	while (left) {
-		if (wait_event_interruptible(
-			    dev->tsin_rbuf.queue,
-			    dvb_ringbuffer_avail(&dev->tsin_rbuf) > 0) < 0)
-			return -EAGAIN;
+	if (!count)
+		return 0;
+
+	if (nonblock) {
 		avail = dvb_ringbuffer_avail(&dev->tsin_rbuf);
-		if (avail > left)
-			avail = left;
-		dvb_ringbuffer_read_user(&dev->tsin_rbuf, buf, avail);
-		left -= avail;
-		buf += avail;
+	} else {
+		while (!avail) {
+			if (wait_event_interruptible(
+				    dev->tsin_rbuf.queue,
+				    dvb_ringbuffer_avail(&dev->tsin_rbuf) > 0) < 0)
+				continue;
+
+			avail = dvb_ringbuffer_avail(&dev->tsin_rbuf);
+		}
 	}
-	return count;
+
+	if (avail > count)
+		avail = count;
+	if (avail > 0)
+		dvb_ringbuffer_read_user(&dev->tsin_rbuf, buf, avail);
+
+	if (!avail)
+		return -EAGAIN;
+	else
+		return avail;
+
 }
 
 static const struct file_operations ci_fops = {
@@ -98,9 +125,9 @@ static const struct file_operations ci_f
 
 struct dvb_device ngene_dvbdev_ci = {
 	.priv    = 0,
-	.readers = -1,
-	.writers = -1,
-	.users   = -1,
+	.readers = 1,
+	.writers = 1,
+	.users   = 2,
 	.fops    = &ci_fops,
 };
 


