Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm3.bt.bullet.mail.ukl.yahoo.com ([217.146.183.201]:37551 "HELO
	nm3.bt.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751295Ab1IXUm1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Sep 2011 16:42:27 -0400
Message-ID: <4E7E40AD.5060206@yahoo.com>
Date: Sat, 24 Sep 2011 21:42:21 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Michael Hughes <marynya@compuserve.com>
CC: linux-media@vger.kernel.org
Subject: [PATCH v2] EM28xx - fix deadlock when unplugging and replugging a
 DVB adapter
Content-Type: multipart/mixed;
 boundary="------------010803040101070609080701"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010803040101070609080701
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Mauro,

Pending the complete rethink about how USB devices manage their resources, I am 
resubmitting my fix for the PCTV 290e deadlock that occurs with either multiple 
adapters or when an adapter is replugged.

For DVB devices, the device lock must now *not* be held when adding/removing 
either a device or an extension to the respective lists. (Because 
em28xx_init_dvb() will want to take the lock instead).

Conversely, for Audio-Only devices, the device lock *must* be held when 
adding/removing either a device or an extension to the respective lists.

Signed-off-by: Chris Rankin <rankincj@yahoo.com>

Cheers,
Chris

--------------010803040101070609080701
Content-Type: text/x-patch;
 name="EM28xx-replug-deadlock-2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="EM28xx-replug-deadlock-2.diff"

--- linux/drivers/media/video/em28xx/em28xx-cards.c.orig	2011-09-24 21:25:01.000000000 +0100
+++ linux/drivers/media/video/em28xx/em28xx-cards.c	2011-09-24 21:37:42.000000000 +0100
@@ -3005,9 +3005,7 @@
 		goto fail;
 	}
 
-	mutex_unlock(&dev->lock);
 	em28xx_init_extension(dev);
-	mutex_lock(&dev->lock);
 
 	/* Save some power by putting tuner to sleep */
 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
@@ -3303,10 +3301,10 @@
 		em28xx_release_resources(dev);
 	}
 
-	mutex_unlock(&dev->lock);
-
 	em28xx_close_extension(dev);
 
+	mutex_unlock(&dev->lock);
+
 	if (!dev->users) {
 		kfree(dev->alt_max_pkt_size);
 		kfree(dev);

--------------010803040101070609080701--
