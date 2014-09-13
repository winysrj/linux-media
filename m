Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:50191 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbaIMIvA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Sep 2014 04:51:00 -0400
Received: by mail-lb0-f178.google.com with SMTP id c11so2141450lbj.9
        for <linux-media@vger.kernel.org>; Sat, 13 Sep 2014 01:50:58 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 2/4] em28xx: simplify usb audio class handling
Date: Sat, 13 Sep 2014 10:52:20 +0200
Message-Id: <1410598342-31094-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1410598342-31094-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1410598342-31094-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As far as we know devices can either have audio class or vendor class usb
interfaces but not both at the same time. Even if both interface types could be
provided by devices at the same time, the current code is totally broken for
that case.

So clean up and simplify the usb audio class handling by replacing fields
"has_audio_class" (device has usb audio class compliant interface) and
"has_alsa_audio" (device has vendor audio interface) in struct em28xx with a
single enum em28xx_usb_audio_type.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c |  8 ++++----
 drivers/media/usb/em28xx/em28xx-cards.c | 30 ++++++++++++++++--------------
 drivers/media/usb/em28xx/em28xx-core.c  |  8 ++++----
 drivers/media/usb/em28xx/em28xx.h       |  9 +++++++--
 4 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index e881ef7..90c7a83 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -893,7 +893,7 @@ static int em28xx_audio_init(struct em28xx *dev)
 	static int          devnr;
 	int		    err;
 
-	if (!dev->has_alsa_audio) {
+	if (dev->usb_audio_type != EM28XX_USB_AUDIO_VENDOR) {
 		/* This device does not support the extension (in this case
 		   the device is expecting the snd-usb-audio module or
 		   doesn't have analog audio support at all) */
@@ -975,7 +975,7 @@ static int em28xx_audio_fini(struct em28xx *dev)
 	if (dev == NULL)
 		return 0;
 
-	if (!dev->has_alsa_audio) {
+	if (dev->usb_audio_type != EM28XX_USB_AUDIO_VENDOR) {
 		/* This device does not support the extension (in this case
 		   the device is expecting the snd-usb-audio module or
 		   doesn't have analog audio support at all) */
@@ -1003,7 +1003,7 @@ static int em28xx_audio_suspend(struct em28xx *dev)
 	if (dev == NULL)
 		return 0;
 
-	if (!dev->has_alsa_audio)
+	if (dev->usb_audio_type != EM28XX_USB_AUDIO_VENDOR)
 		return 0;
 
 	em28xx_info("Suspending audio extension");
@@ -1017,7 +1017,7 @@ static int em28xx_audio_resume(struct em28xx *dev)
 	if (dev == NULL)
 		return 0;
 
-	if (!dev->has_alsa_audio)
+	if (dev->usb_audio_type != EM28XX_USB_AUDIO_VENDOR)
 		return 0;
 
 	em28xx_info("Resuming audio extension");
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 582c1e1..f142588 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2931,9 +2931,9 @@ static void request_module_async(struct work_struct *work)
 #if defined(CONFIG_MODULES) && defined(MODULE)
 	if (dev->has_video)
 		request_module("em28xx-v4l");
-	if (dev->has_audio_class)
+	if (dev->usb_audio_type == EM28XX_USB_AUDIO_CLASS)
 		request_module("snd-usb-audio");
-	else if (dev->has_alsa_audio)
+	else if (dev->usb_audio_type == EM28XX_USB_AUDIO_VENDOR)
 		request_module("em28xx-alsa");
 	if (dev->board.has_dvb)
 		request_module("em28xx-dvb");
@@ -3180,7 +3180,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	struct usb_device *udev;
 	struct em28xx *dev = NULL;
 	int retval;
-	bool has_audio = false, has_video = false, has_dvb = false;
+	bool has_vendor_audio = false, has_video = false, has_dvb = false;
 	int i, nr, try_bulk;
 	const int ifnum = interface->altsetting[0].desc.bInterfaceNumber;
 	char *speed;
@@ -3262,7 +3262,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 					break;
 				case 0x83:
 					if (usb_endpoint_xfer_isoc(e)) {
-						has_audio = true;
+						has_vendor_audio = true;
 					} else {
 						printk(KERN_INFO DRIVER_NAME
 						": error: skipping audio endpoint 0x83, because it uses bulk transfers !\n");
@@ -3318,7 +3318,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		}
 	}
 
-	if (!(has_audio || has_video || has_dvb)) {
+	if (!(has_vendor_audio || has_video || has_dvb)) {
 		retval = -ENODEV;
 		goto err_free;
 	}
@@ -3365,25 +3365,27 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	dev->devno = nr;
 	dev->model = id->driver_info;
 	dev->alt   = -1;
-	dev->is_audio_only = has_audio && !(has_video || has_dvb);
-	dev->has_alsa_audio = has_audio;
+	dev->is_audio_only = has_vendor_audio && !(has_video || has_dvb);
 	dev->has_video = has_video;
 	dev->ifnum = ifnum;
 
-	/* Checks if audio is provided by some interface */
+	if (has_vendor_audio) {
+		printk(KERN_INFO DRIVER_NAME ": Audio interface %i found %s\n",
+		       ifnum, "(Vendor Class)");
+		dev->usb_audio_type = EM28XX_USB_AUDIO_VENDOR;
+	}
+	/* Checks if audio is provided by a USB Audio Class interface */
 	for (i = 0; i < udev->config->desc.bNumInterfaces; i++) {
 		struct usb_interface *uif = udev->config->interface[i];
 		if (uif->altsetting[0].desc.bInterfaceClass == USB_CLASS_AUDIO) {
-			dev->has_audio_class = 1;
+			if (has_vendor_audio)
+				em28xx_err("em28xx: device seems to have vendor AND usb audio class interfaces !\n"
+					   "\t\tThe vendor interface will be ignored. Please contact the developers <linux-media@vger.kernel.org>\n");
+			dev->usb_audio_type = EM28XX_USB_AUDIO_CLASS;
 			break;
 		}
 	}
 
-	if (has_audio)
-		printk(KERN_INFO DRIVER_NAME
-		       ": Audio interface %i found %s\n",
-		       ifnum,
-		       dev->has_audio_class ? "(USB Audio Class)" : "(Vendor Class)");
 	if (has_video)
 		printk(KERN_INFO DRIVER_NAME
 		       ": Video interface %i found:%s%s\n",
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 0fe05ff..16747ca 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -513,8 +513,7 @@ int em28xx_audio_setup(struct em28xx *dev)
 	    dev->chip_id == CHIP_ID_EM28178) {
 		/* Digital only device - don't load any alsa module */
 		dev->audio_mode.has_audio = false;
-		dev->has_audio_class = false;
-		dev->has_alsa_audio = false;
+		dev->usb_audio_type = EM28XX_USB_AUDIO_NONE;
 		return 0;
 	}
 
@@ -528,8 +527,8 @@ int em28xx_audio_setup(struct em28xx *dev)
 		cfg = EM28XX_CHIPCFG_AC97; /* Be conservative */
 	} else if ((cfg & EM28XX_CHIPCFG_AUDIOMASK) == 0x00) {
 		/* The device doesn't have vendor audio at all */
-		dev->has_alsa_audio = false;
 		dev->audio_mode.has_audio = false;
+		dev->usb_audio_type = EM28XX_USB_AUDIO_NONE;
 		return 0;
 	} else if ((cfg & EM28XX_CHIPCFG_AUDIOMASK) != EM28XX_CHIPCFG_AC97) {
 		if (dev->chip_id < CHIP_ID_EM2860 &&
@@ -560,7 +559,8 @@ int em28xx_audio_setup(struct em28xx *dev)
 		 */
 		em28xx_warn("AC97 chip type couldn't be determined\n");
 		dev->audio_mode.ac97 = EM28XX_NO_AC97;
-		dev->has_alsa_audio = false;
+		if (dev->usb_audio_type == EM28XX_USB_AUDIO_VENDOR)
+			dev->usb_audio_type = EM28XX_USB_AUDIO_NONE;
 		dev->audio_mode.has_audio = false;
 		goto init_audio;
 	}
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 1f38163..3fd176f 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -312,6 +312,12 @@ struct em28xx_audio_mode {
 	unsigned int has_audio:1;
 };
 
+enum em28xx_usb_audio_type {
+	EM28XX_USB_AUDIO_NONE = 0,
+	EM28XX_USB_AUDIO_CLASS,
+	EM28XX_USB_AUDIO_VENDOR,
+};
+
 /* em28xx has two audio inputs: tuner and line in.
    However, on most devices, an auxiliary AC97 codec device is used.
    The AC97 device may have several different inputs and outputs,
@@ -601,9 +607,8 @@ struct em28xx {
 	unsigned int is_em25xx:1;	/* em25xx/em276x/7x/8x family bridge */
 	unsigned char disconnected:1;	/* device has been diconnected */
 	unsigned int has_video:1;
-	unsigned int has_audio_class:1;
-	unsigned int has_alsa_audio:1;
 	unsigned int is_audio_only:1;
+	enum em28xx_usb_audio_type usb_audio_type;
 
 	struct em28xx_board board;
 
-- 
1.8.4.5

