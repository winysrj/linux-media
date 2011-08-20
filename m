Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm4.bt.bullet.mail.ird.yahoo.com ([212.82.108.235]:43110 "HELO
	nm4.bt.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752389Ab1HTLqS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Aug 2011 07:46:18 -0400
Message-ID: <4E4F9E86.7030001@yahoo.com>
Date: Sat, 20 Aug 2011 12:46:14 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] EM28xx - fix deadlock when unplugging and replugging
 a DVB adapter
References: <4E4D5157.2080406@yahoo.com> <CAGoCfiwk4vy1V7T=Hdz1CsywgWVpWEis0eDoh2Aqju3LYqcHfA@mail.gmail.com> <CAGoCfiw4v-ZsUPmVgOhARwNqjCVK458EV79djD625Sf+8Oghag@mail.gmail.com> <4E4D8DFD.5060800@yahoo.com> <4E4DFA65.4090508@redhat.com>
In-Reply-To: <4E4DFA65.4090508@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------080105000203040004080606"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080105000203040004080606
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The final patch removes the unplug/replug deadlock by not holding the device 
mutex during dvb_init(). However, this mutex has already been locked during 
device initialisation by em28xx_usb_probe() and is not released again until all 
extensions have been initialised successfully.

The device mutex is not held during either em28xx_register_extension() or 
em28xx_unregister_extension() any more. More importantly, I don't believe it can 
safely be held by these functions because they must both - by their nature - 
acquire the device list mutex before they can iterate through the device list. 
In other words, while usb_probe() and usb_disconnect() acquire the device mutex 
followed by the device list mutex, the register/unregister_extension() functions 
would need to acquire these mutexes in the opposite order. And that sounds like 
a potential deadlock.

On the other hand, the new situation is a definite improvement :-).

Signed-off-by: Chris Rankin <rankincj@yahoo.com>


--------------080105000203040004080606
Content-Type: text/x-patch;
 name="EM28xx-replug-deadlock.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="EM28xx-replug-deadlock.diff"

--- linux-3.0/drivers/media/video/em28xx/em28xx-dvb.c.orig	2011-08-19 00:50:41.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-dvb.c	2011-08-19 00:51:03.000000000 +0100
@@ -542,7 +542,6 @@
 	dev->dvb = dvb;
 	dvb->fe[0] = dvb->fe[1] = NULL;
 
-	mutex_lock(&dev->lock);
 	em28xx_set_mode(dev, EM28XX_DIGITAL_MODE);
 	/* init frontend */
 	switch (dev->model) {
@@ -711,7 +710,6 @@
 	em28xx_info("Successfully loaded em28xx-dvb\n");
 ret:
 	em28xx_set_mode(dev, EM28XX_SUSPEND);
-	mutex_unlock(&dev->lock);
 	return result;
 
 out_free:

--------------080105000203040004080606--
