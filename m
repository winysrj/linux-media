Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm3-vm0.bt.bullet.mail.ird.yahoo.com ([212.82.108.88]:34460
	"HELO nm3-vm0.bt.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754307Ab1HUMcN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Aug 2011 08:32:13 -0400
Message-ID: <4E50FAC7.6080807@yahoo.com>
Date: Sun, 21 Aug 2011 13:32:07 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH 1/1] EM28xx - fix deadlock when unplugging and replugging
 a DVB adapter
References: <1313851233.95109.YahooMailClassic@web121704.mail.ne1.yahoo.com> <4E4FCC8D.3070305@redhat.com>
In-Reply-To: <4E4FCC8D.3070305@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------060703020508020303040009"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060703020508020303040009
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

It occurred to me this morning that since we're no longer supposed to be holding 
the device lock when taking the device list lock, then the 
em28xx_usb_disconnect() function needs changing too.

Signed-off-by: Chris Rankin <rankincj@yahoo.com>


--------------060703020508020303040009
Content-Type: text/x-patch;
 name="EM28xx-replug-deadlock.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="EM28xx-replug-deadlock.diff"

--- linux-3.0/drivers/media/video/em28xx/em28xx-cards.c.orig	2011-08-19 00:45:48.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-cards.c	2011-08-21 13:16:43.000000000 +0100
@@ -2929,7 +2929,9 @@
 		goto fail_reg_analog_devices;
 	}
 
+	mutex_unlock(&dev->lock);
 	em28xx_init_extension(dev);
+	mutex_lock(&dev->lock);
 
 	/* Save some power by putting tuner to sleep */
 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
@@ -3191,10 +3193,10 @@
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

--------------060703020508020303040009--
