Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64160 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3ARRZX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jan 2013 12:25:23 -0500
Received: by mail-ee0-f46.google.com with SMTP id e49so1845482eek.5
        for <linux-media@vger.kernel.org>; Fri, 18 Jan 2013 09:25:22 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] em28xx: fix usb alternate setting for analog and digital video endpoints > 0
Date: Fri, 18 Jan 2013 18:25:48 +0100
Message-Id: <1358529948-2260-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While the current code handles sound interfaces with a number > 0 correctly, it
assumes that the interface number for analog + digital video is always 0 when
changing the alternate setting.

(NOTE: the "SpeedLink VAD Laplace webcam" (EM2765) uses interface number 3 for video)

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c |   10 +++++-----
 drivers/media/usb/em28xx/em28xx-cards.c |    2 +-
 drivers/media/usb/em28xx/em28xx-core.c  |    2 +-
 drivers/media/usb/em28xx/em28xx-dvb.c   |    2 +-
 drivers/media/usb/em28xx/em28xx.h       |    3 +--
 5 Dateien geändert, 9 Zeilen hinzugefügt(+), 10 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 2fdb66e..cdbfe0a 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -283,15 +283,15 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
 	}
 
 	runtime->hw = snd_em28xx_hw_capture;
-	if ((dev->alt == 0 || dev->audio_ifnum) && dev->adev.users == 0) {
-		if (dev->audio_ifnum)
+	if ((dev->alt == 0 || dev->ifnum) && dev->adev.users == 0) {
+		if (dev->ifnum)
 			dev->alt = 1;
 		else
 			dev->alt = 7;
 
 		dprintk("changing alternate number on interface %d to %d\n",
-			dev->audio_ifnum, dev->alt);
-		usb_set_interface(dev->udev, dev->audio_ifnum, dev->alt);
+			dev->ifnum, dev->alt);
+		usb_set_interface(dev->udev, dev->ifnum, dev->alt);
 
 		/* Sets volume, mute, etc */
 		dev->mute = 0;
@@ -642,7 +642,7 @@ static int em28xx_audio_init(struct em28xx *dev)
 	static int          devnr;
 	int                 err;
 
-	if (!dev->has_alsa_audio || dev->audio_ifnum < 0) {
+	if (!dev->has_alsa_audio) {
 		/* This device does not support the extension (in this case
 		   the device is expecting the snd-usb-audio module or
 		   doesn't have analog audio support at all) */
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 0a5aa62..553db17 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3376,7 +3376,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	dev->alt   = -1;
 	dev->is_audio_only = has_audio && !(has_video || has_dvb);
 	dev->has_alsa_audio = has_audio;
-	dev->audio_ifnum = ifnum;
+	dev->ifnum = ifnum;
 
 	/* Checks if audio is provided by some interface */
 	for (i = 0; i < udev->config->desc.bNumInterfaces; i++) {
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index ce4f252..210859a 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -862,7 +862,7 @@ set_alt:
 	}
 	em28xx_coredbg("setting alternate %d with wMaxPacketSize=%u\n",
 		       dev->alt, dev->max_pkt_size);
-	errCode = usb_set_interface(dev->udev, 0, dev->alt);
+	errCode = usb_set_interface(dev->udev, dev->ifnum, dev->alt);
 	if (errCode < 0) {
 		em28xx_errdev("cannot change alternate number to %d (error=%i)\n",
 				dev->alt, errCode);
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index a81ec2e..dbeed6c 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -196,7 +196,7 @@ static int em28xx_start_streaming(struct em28xx_dvb *dvb)
 		dvb_alt = dev->dvb_alt_isoc;
 	}
 
-	usb_set_interface(dev->udev, 0, dvb_alt);
+	usb_set_interface(dev->udev, dev->ifnum, dvb_alt);
 	rc = em28xx_set_mode(dev, EM28XX_DIGITAL_MODE);
 	if (rc < 0)
 		return rc;
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 5f0b2c5..0dc5b73 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -487,8 +487,6 @@ struct em28xx {
 
 	unsigned char disconnected:1;	/* device has been diconnected */
 
-	int audio_ifnum;
-
 	struct v4l2_device v4l2_dev;
 	struct v4l2_ctrl_handler ctrl_handler;
 	/* provides ac97 mute and volume overrides */
@@ -597,6 +595,7 @@ struct em28xx {
 
 	/* usb transfer */
 	struct usb_device *udev;	/* the usb device */
+	int ifnum;			/* usb interface number */
 	u8 analog_ep_isoc;	/* address of isoc endpoint for analog */
 	u8 analog_ep_bulk;	/* address of bulk endpoint for analog */
 	u8 dvb_ep_isoc;		/* address of isoc endpoint for DVB */
-- 
1.7.10.4

