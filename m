Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm4-vm0.bt.bullet.mail.ukl.yahoo.com ([217.146.182.229]:39179
	"HELO nm4-vm0.bt.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755153Ab1HTWiG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Aug 2011 18:38:06 -0400
Message-ID: <4E503748.1090309@yahoo.com>
Date: Sat, 20 Aug 2011 23:38:00 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/1] EM28xx - fix deadlock when unplugging and replugging
 a DVB adapter
References: <1313851233.95109.YahooMailClassic@web121704.mail.ne1.yahoo.com> <4E4FCC8D.3070305@redhat.com>
In-Reply-To: <4E4FCC8D.3070305@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------070004080902090503070209"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070004080902090503070209
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Here's the new patch for the deadlock problem, which releases the device mutex 
before calling em28xx_init_extension() and then reacquires it afterwards. The 
locking in dvb_init() is now left alone.

Signed-off-by: Chris Rankin <rankincj@yahoo.com>


--------------070004080902090503070209
Content-Type: text/x-patch;
 name="EM28xx-replug-deadlock.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="EM28xx-replug-deadlock.diff"

--- linux-3.0/drivers/media/video/em28xx/em28xx-cards.c.orig	2011-08-19 00:45:48.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-cards.c	2011-08-20 23:28:39.000000000 +0100
@@ -2929,7 +2929,9 @@
 		goto fail_reg_analog_devices;
 	}
 
+	mutex_unlock(&dev->lock);
 	em28xx_init_extension(dev);
+	mutex_lock(&dev->lock);
 
 	/* Save some power by putting tuner to sleep */
 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);

--------------070004080902090503070209--
