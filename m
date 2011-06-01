Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756988Ab1FAVbb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jun 2011 17:31:31 -0400
Message-ID: <4DE6A8C0.4060603@redhat.com>
Date: Wed, 01 Jun 2011 18:01:52 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Oliver Endriss <o.endriss@gmx.de>,
	Ralph Metzler <rjkm@metzlerbros.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Fwd: [PATCH] ngene: blocking and nonblocking io for sec0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Oliver/Ralph,

Could you please review this patch? On a quick look, it looks
fine on my eyes, but I don't have any ngene hardware here for testing.

Thanks!
Mauro

-------- Mensagem original --------
Date: Thu, 12 May 2011 15:47:09 +0200
From: Issa Gorissen <flop.m@usa.net>
To: linux-media@vger.kernel.org
Subject: [PATCH] ngene: blocking and nonblocking io for sec0

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
 


--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
