Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm1-vm0.bt.bullet.mail.ukl.yahoo.com ([217.146.182.223]:41184
	"HELO nm1-vm0.bt.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752119Ab1IYWnR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Sep 2011 18:43:17 -0400
Message-ID: <4E7FAE80.50802@yahoo.com>
Date: Sun, 25 Sep 2011 23:43:12 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: [PATCH] EM28xx - replug locking cleanup
Content-Type: multipart/mixed;
 boundary="------------040304050901090103050107"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040304050901090103050107
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Mauro,

This patch simplifies the locking by moving the em28xx_init_extension() call 
until em28xx_usb_probe() has finished with the dev->lock mutex. It therefore 
makes the second and subsequent "plugging" events logically identical to the 
first "plugging" event when the em28xx-dvb and em28xx-alsa modules must be 
loaded (i.e. registered).

Basically, em28xx_usb_probe() requests that em28xx-dvb be loaded and also 
triggers udev to initialise the V4L2 devices. These two events are serialised by 
the dev->lock mutex but the order that they happen in is undefined. But this has 
always been the case anyway.

Signed-off-by: Chris Rankin <rankincj@yahoo.com>

Cheers,
Chris

--------------040304050901090103050107
Content-Type: text/x-patch;
 name="EM28xx-replug-deadlock-cleanup.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="EM28xx-replug-deadlock-cleanup.diff"

--- linux/drivers/media/video/em28xx/em28xx-cards.c.orig	2011-09-25 22:51:59.000000000 +0100
+++ linux/drivers/media/video/em28xx/em28xx-cards.c	2011-09-25 23:24:06.000000000 +0100
@@ -3005,10 +3005,6 @@
 		goto fail;
 	}
 
-	mutex_unlock(&dev->lock);
-	em28xx_init_extension(dev);
-	mutex_lock(&dev->lock);
-
 	/* Save some power by putting tuner to sleep */
 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
 
@@ -3243,6 +3239,13 @@
 	 */
 	mutex_unlock(&dev->lock);
 
+	/*
+	 * These extensions can be modules. If the modules are already
+	 * loaded then we can initialise the device now, otherwise we
+	 * will initialise it when the modules load instead.
+	 */
+	em28xx_init_extension(dev);
+
 	return 0;
 
 err:

--------------040304050901090103050107--
