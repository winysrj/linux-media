Return-path: <linux-media-owner@vger.kernel.org>
Received: from auth-1.ukservers.net ([217.10.138.153]:42030 "EHLO
	auth-1.ukservers.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbZKLQUI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2009 11:20:08 -0500
Received: from hades.syntheticmoon.co.uk (82-71-38-22.dsl.in-addr.zen.co.uk [82.71.38.22])
	by auth-1.ukservers.net (Postfix smtp) with ESMTP id 6342036F979F
	for <linux-media@vger.kernel.org>; Thu, 12 Nov 2009 16:20:13 +0000 (GMT)
Message-ID: <4AFC34CC.1060204@tangobravo.co.uk>
Date: Thu, 12 Nov 2009 16:16:12 +0000
From: Tim Borgeaud <tim@tangobravo.co.uk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] Locking in Siano driver (untested)
Content-Type: multipart/mixed;
 boundary="------------070204020805050401040602"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070204020805050401040602
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This is a simple but completely untested patch for 
linux/drivers/media/dvb/siano/smscoreapi.c

This patch addresses the apparent possible invocation of schedule while 
holding a spin lock. In the smscore_getbuffer function, the spin lock is 
simply dropped around the schedule call and in the accompanying 
smscore_putbuffer function the spin lock is used to synchronize both the 
wake up and addition of a new buffer.

Note that there is no explicit use of memory barriers so I am not certain 
as to whether this patch will address all possible locking issues with the 
smscore_getbuffer and smscore_putbuffer functions.

Since I don't actually use git to follow the development of Linux drivers 
and I don't actually have the relevant hardware, I can't easily test the 
change to the source. Perhaps this will be useful to someone who might 
want to look at and modifiy the siano code.

I've attached a simple unified diff.

I.e. in linux/drivers/media/dvb/siano:

% diff -u smscoreapi.c smscoreapi.c.orig

Tim

--------------070204020805050401040602
Content-Type: text/plain;
 name="smscoreapi.c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="smscoreapi.c.patch"

--- smscoreapi.c.orig	2009-11-11 11:22:44.000000000 +0000
+++ smscoreapi.c	2009-11-12 16:02:25.000000000 +0000
@@ -1120,8 +1120,11 @@
 
 	prepare_to_wait(&coredev->buffer_mng_waitq, &wait, TASK_INTERRUPTIBLE);
 
-	if (list_empty(&coredev->buffers))
+	if (list_empty(&coredev->buffers)) {
+		spin_unlock_irqrestore(&coredev->bufferslock, flags);
 		schedule();
+		spin_lock_irqsave(&coredev->bufferslock, flags);
+	}
 
 	finish_wait(&coredev->buffer_mng_waitq, &wait);
 
@@ -1144,8 +1147,14 @@
  */
 void smscore_putbuffer(struct smscore_device_t *coredev,
 		struct smscore_buffer_t *cb) {
+	unsigned long flags;
+
+	spin_lock_irqsave(&coredev->bufferslock, flags);
+
+	list_add(&cb->entry, &coredev->buffers);
 	wake_up_interruptible(&coredev->buffer_mng_waitq);
-	list_add_locked(&cb->entry, &coredev->buffers, &coredev->bufferslock);
+
+	spin_unlock_irqrestore(&coredev->bufferslock, flags);
 }
 EXPORT_SYMBOL_GPL(smscore_putbuffer);
 

--------------070204020805050401040602--
