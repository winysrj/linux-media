Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:64216 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbaAMWBJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 17:01:09 -0500
Received: by mail-ee0-f53.google.com with SMTP id t10so455998eei.26
        for <linux-media@vger.kernel.org>; Mon, 13 Jan 2014 14:01:08 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 1/2] em28xx: fix usb alternate setting for analog and digital video endpoints > 0
Date: Mon, 13 Jan 2014 23:02:06 +0100
Message-Id: <1389650527-3962-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current code assumes that the analog + digital video endpoints are always at
interface number 0 when changing the alternate setting.
This seems to work fine for most existing devices.
However, at least the SpeedLink VAD Laplace webcam has the video endpoint on
interface number 3 (which fortunately doesn't cause any trouble because ist uses
bulk transfers only).
We already consider the actual interface number for audio endpoints, so
rename the the audio_ifnum variable and use it for all device types.
Also get get rid of a pointless (ifnum < 0) in em28xx-audio.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c |   18 +++++++++---------
 drivers/media/usb/em28xx/em28xx-cards.c |    2 +-
 drivers/media/usb/em28xx/em28xx-dvb.c   |    2 +-
 drivers/media/usb/em28xx/em28xx-video.c |    2 +-
 drivers/media/usb/em28xx/em28xx.h       |    3 +--
 5 Dateien geändert, 13 Zeilen hinzugefügt(+), 14 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index f3e3200..f80c3533 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -266,7 +266,7 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
 	dprintk("opening device and trying to acquire exclusive lock\n");
 
 	runtime->hw = snd_em28xx_hw_capture;
-	if ((dev->alt == 0 || dev->audio_ifnum) && dev->adev.users == 0) {
+	if ((dev->alt == 0 || dev->ifnum) && dev->adev.users == 0) {
 		int nonblock = !!(substream->f_flags & O_NONBLOCK);
 
 		if (nonblock) {
@@ -274,14 +274,14 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
 				return -EAGAIN;
 		} else
 			mutex_lock(&dev->lock);
-		if (dev->audio_ifnum)
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
@@ -728,16 +728,16 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
 	int		    urb_size, bytes_per_transfer;
 	u8 alt;
 
-	if (dev->audio_ifnum)
+	if (dev->ifnum)
 		alt = 1;
 	else
 		alt = 7;
 
-	intf = usb_ifnum_to_if(dev->udev, dev->audio_ifnum);
+	intf = usb_ifnum_to_if(dev->udev, dev->ifnum);
 
 	if (intf->num_altsetting <= alt) {
 		em28xx_errdev("alt %d doesn't exist on interface %d\n",
-			      dev->audio_ifnum, alt);
+			      dev->ifnum, alt);
 		return -ENODEV;
 	}
 
@@ -761,7 +761,7 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
 
 	em28xx_info("Endpoint 0x%02x %s on intf %d alt %d interval = %d, size %d\n",
 		     EM28XX_EP_AUDIO, usb_speed_string(dev->udev->speed),
-		     dev->audio_ifnum, alt,
+		     dev->ifnum, alt,
 		     interval,
 		     ep_size);
 
@@ -869,7 +869,7 @@ static int em28xx_audio_init(struct em28xx *dev)
 	static int          devnr;
 	int		    err;
 
-	if (!dev->has_alsa_audio || dev->audio_ifnum < 0) {
+	if (!dev->has_alsa_audio) {
 		/* This device does not support the extension (in this case
 		   the device is expecting the snd-usb-audio module or
 		   doesn't have analog audio support at all) */
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 6efb902..c7e3667 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3273,7 +3273,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	dev->has_alsa_audio = has_audio;
 	dev->audio_mode.has_audio = has_audio;
 	dev->has_video = has_video;
-	dev->audio_ifnum = ifnum;
+	dev->ifnum = ifnum;
 
 	/* Checks if audio is provided by some interface */
 	for (i = 0; i < udev->config->desc.bNumInterfaces; i++) {
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 7dba175..4c0338b 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -203,7 +203,7 @@ static int em28xx_start_streaming(struct em28xx_dvb *dvb)
 		dvb_alt = dev->dvb_alt_isoc;
 	}
 
-	usb_set_interface(dev->udev, 0, dvb_alt);
+	usb_set_interface(dev->udev, dev->ifnum, dvb_alt);
 	rc = em28xx_set_mode(dev, EM28XX_DIGITAL_MODE);
 	if (rc < 0)
 		return rc;
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index a1dcceb..9c1916a 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -382,7 +382,7 @@ set_alt:
 	}
 	em28xx_videodbg("setting alternate %d with wMaxPacketSize=%u\n",
 		       dev->alt, dev->max_pkt_size);
-	errCode = usb_set_interface(dev->udev, 0, dev->alt);
+	errCode = usb_set_interface(dev->udev, dev->ifnum, dev->alt);
 	if (errCode < 0) {
 		em28xx_errdev("cannot change alternate number to %d (error=%i)\n",
 			      dev->alt, errCode);
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 5d5d1b6..f5e7da6 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -547,8 +547,6 @@ struct em28xx {
 	unsigned int has_alsa_audio:1;
 	unsigned int is_audio_only:1;
 
-	int audio_ifnum;
-
 	struct v4l2_device v4l2_dev;
 	struct v4l2_ctrl_handler ctrl_handler;
 	struct v4l2_clk *clk;
@@ -662,6 +660,7 @@ struct em28xx {
 
 	/* usb transfer */
 	struct usb_device *udev;	/* the usb device */
+	u8 ifnum;		/* number of the assigned usb interface */
 	u8 analog_ep_isoc;	/* address of isoc endpoint for analog */
 	u8 analog_ep_bulk;	/* address of bulk endpoint for analog */
 	u8 dvb_ep_isoc;		/* address of isoc endpoint for DVB */
-- 
1.7.10.4

