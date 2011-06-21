Return-path: <mchehab@pedra>
Received: from cmsout01.mbox.net ([165.212.64.31]:59092 "EHLO
	cmsout01.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab1FUV70 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2011 17:59:26 -0400
Message-ID: <4E011418.7040601@usa.net>
Date: Tue, 21 Jun 2011 23:58:48 +0200
From: Issa Gorissen <flop.m@usa.net>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Oliver Endriss <o.endriss@gmx.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Ralph Metzler <rjkm@metzlerbros.de>
Subject: Re: Fwd: [PATCH] ngene: blocking and nonblocking io for sec0
References: <4DE6A8C0.4060603@redhat.com> <201106181307.32895@orion.escape-edv.de>
In-Reply-To: <201106181307.32895@orion.escape-edv.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Haven't fully understood the usage of wake_event_interruptible, now I have read its description. Sorry for the lame patch.

Please find a fixed version below.


Patch allows for blocking or nonblocking io on the ngene sec0 device.
It also enforces one reader and one writer at a time.

Signed-off-by: Issa Gorissen <flop.m@usa.net>
--

--- a/linux/drivers/media/dvb/ngene/ngene-dvb.c	2011-05-10 19:11:21.000000000 +0200
+++ b/linux/drivers/media/dvb/ngene/ngene-dvb.c	2011-06-21 23:46:09.000000000 +0200
@@ -53,15 +53,30 @@ static ssize_t ts_write(struct file *fil
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
+		avail = dvb_ringbuffer_free(&dev->tsout_rbuf);
+		if (!avail)
+			return -EAGAIN;
+		if (count < avail)
+			avail = count;
+	} else {
+		if (wait_event_interruptible(dev->tsout_rbuf.queue,
+					     dvb_ringbuffer_free
+					     (&dev->tsout_rbuf) >= count) < 0)
+			return -EINTR;
+
+		avail = count;
+	}
+
+	dvb_ringbuffer_write(&dev->tsout_rbuf, buf, avail);
+	return avail;
 
-	return count;
 }
 
 static ssize_t ts_read(struct file *file, char *buf,
@@ -70,22 +85,29 @@ static ssize_t ts_read(struct file *file
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
+		if (!avail)
+			return -EAGAIN;
+		if (avail > count)
+			avail = count;
+	} else {
+		if (wait_event_interruptible(dev->tsin_rbuf.queue,
+					     dvb_ringbuffer_avail
+					     (&dev->tsin_rbuf) >= count) < 0)
+			return -EINTR;
+
+		avail = count;
 	}
-	return count;
+
+	dvb_ringbuffer_read_user(&dev->tsin_rbuf, buf, avail);
+	return avail;
 }
 
 static const struct file_operations ci_fops = {
@@ -98,9 +120,9 @@ static const struct file_operations ci_f
 
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
 


