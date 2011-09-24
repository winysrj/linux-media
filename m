Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm3.bt.bullet.mail.ukl.yahoo.com ([217.146.183.201]:42543 "HELO
	nm3.bt.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752015Ab1IXUzC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Sep 2011 16:55:02 -0400
Message-ID: <4E7E43A2.3020905@yahoo.com>
Date: Sat, 24 Sep 2011 21:54:58 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: [PATCH v3] EM28xx - fix deadlock when unplugging and replugging a
 DVB adapter
Content-Type: multipart/mixed;
 boundary="------------020807060000050501050004"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020807060000050501050004
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Mauro,

Excuse me - I put my brain in backwards today and sent you a reverse diff by 
accident! Reresending...

----------------------------------------------------------------------------
This fixes the deadlock that occurs with either multiple PCTV 290e adapters or 
when a single PCTV 290e adapter is replugged.

For DVB devices, the device lock must now *not* be held when adding/removing 
either a device or an extension to the respective lists. (Because 
em28xx_init_dvb() will want to take the lock instead).

Conversely, for Audio-Only devices, the device lock *must* be held when 
adding/removing either a device or an extension to the respective lists.

Signed-off-by: Chris Rankin <ranki...@yahoo.com>

Cheers,
Chris

--------------020807060000050501050004
Content-Type: text/x-patch;
 name="EM28xx-replug-deadlock-3.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="EM28xx-replug-deadlock-3.diff"

--- linux/drivers/media/video/em28xx/em28xx-cards.c.orig	2011-09-24 21:42:43.000000000 +0100
+++ linux/drivers/media/video/em28xx/em28xx-cards.c	2011-09-24 21:48:56.000000000 +0100
@@ -3005,7 +3005,9 @@
 		goto fail;
 	}
 
+	mutex_unlock(&dev->lock);
 	em28xx_init_extension(dev);
+	mutex_lock(&dev->lock);
 
 	/* Save some power by putting tuner to sleep */
 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
@@ -3301,10 +3303,10 @@
 		em28xx_release_resources(dev);
 	}
 
-	em28xx_close_extension(dev);
-
 	mutex_unlock(&dev->lock);
 
+	em28xx_close_extension(dev);
+
 	if (!dev->users) {
 		kfree(dev->alt_max_pkt_size);
 		kfree(dev);

--------------020807060000050501050004--
