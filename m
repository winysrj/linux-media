Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60091 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759291AbaJ3KxT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 06:53:19 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Clemens Ladisch <clemens@ladisch.de>,
	Eduard Gilmutdinov <edgilmutdinov@gmail.com>,
	Daniel Mack <zonque@gmail.com>,
	Vlad Catoi <vladcatoi@gmail.com>, alsa-devel@alsa-project.org,
	stable@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 1/2] [media] sound: simplify au0828 quirk table
Date: Thu, 30 Oct 2014 08:53:04 -0200
Message-Id: <63287e8b3f1e449376666b55f9174df7d827b5b0.1414666159.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414666159.git.mchehab@osg.samsung.com>
References: <cover.1414666159.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414666159.git.mchehab@osg.samsung.com>
References: <cover.1414666159.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

Add a macro to simplify au0828 quirk table. That makes easier
to check it against the USB IDs at drivers/media/usb/au0828-card.c

Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index c657752a420c..5ae1d02d17a3 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2804,133 +2804,37 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	}
 },
 
-/* Hauppauge HVR-950Q and HVR-850 */
-{
-	USB_DEVICE_VENDOR_SPEC(0x2040, 0x7200),
-	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
-		       USB_DEVICE_ID_MATCH_INT_CLASS |
-		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
-	.bInterfaceClass = USB_CLASS_AUDIO,
-	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL,
-	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
-		.vendor_name = "Hauppauge",
-		.product_name = "HVR-950Q",
-		.ifnum = QUIRK_ANY_INTERFACE,
-		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
-	}
-},
-{
-	USB_DEVICE_VENDOR_SPEC(0x2040, 0x7210),
-	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
-		       USB_DEVICE_ID_MATCH_INT_CLASS |
-		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
-	.bInterfaceClass = USB_CLASS_AUDIO,
-	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL,
-	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
-		.vendor_name = "Hauppauge",
-		.product_name = "HVR-950Q",
-		.ifnum = QUIRK_ANY_INTERFACE,
-		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
-	}
-},
-{
-	USB_DEVICE_VENDOR_SPEC(0x2040, 0x7217),
-	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
-		       USB_DEVICE_ID_MATCH_INT_CLASS |
-		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
-	.bInterfaceClass = USB_CLASS_AUDIO,
-	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL,
-	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
-		.vendor_name = "Hauppauge",
-		.product_name = "HVR-950Q",
-		.ifnum = QUIRK_ANY_INTERFACE,
-		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
-	}
-},
-{
-	USB_DEVICE_VENDOR_SPEC(0x2040, 0x721b),
-	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
-		       USB_DEVICE_ID_MATCH_INT_CLASS |
-		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
-	.bInterfaceClass = USB_CLASS_AUDIO,
-	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL,
-	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
-		.vendor_name = "Hauppauge",
-		.product_name = "HVR-950Q",
-		.ifnum = QUIRK_ANY_INTERFACE,
-		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
-	}
-},
-{
-	USB_DEVICE_VENDOR_SPEC(0x2040, 0x721e),
-	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
-		       USB_DEVICE_ID_MATCH_INT_CLASS |
-		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
-	.bInterfaceClass = USB_CLASS_AUDIO,
-	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL,
-	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
-		.vendor_name = "Hauppauge",
-		.product_name = "HVR-950Q",
-		.ifnum = QUIRK_ANY_INTERFACE,
-		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
-	}
-},
-{
-	USB_DEVICE_VENDOR_SPEC(0x2040, 0x721f),
-	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
-		       USB_DEVICE_ID_MATCH_INT_CLASS |
-		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
-	.bInterfaceClass = USB_CLASS_AUDIO,
-	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL,
-	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
-		.vendor_name = "Hauppauge",
-		.product_name = "HVR-950Q",
-		.ifnum = QUIRK_ANY_INTERFACE,
-		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
-	}
-},
-{
-	USB_DEVICE_VENDOR_SPEC(0x2040, 0x7240),
-	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
-		       USB_DEVICE_ID_MATCH_INT_CLASS |
-		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
-	.bInterfaceClass = USB_CLASS_AUDIO,
-	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL,
-	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
-		.vendor_name = "Hauppauge",
-		.product_name = "HVR-850",
-		.ifnum = QUIRK_ANY_INTERFACE,
-		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
-	}
-},
-{
-	USB_DEVICE_VENDOR_SPEC(0x2040, 0x7280),
-	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
-		       USB_DEVICE_ID_MATCH_INT_CLASS |
-		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
-	.bInterfaceClass = USB_CLASS_AUDIO,
-	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL,
-	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
-		.vendor_name = "Hauppauge",
-		.product_name = "HVR-950Q",
-		.ifnum = QUIRK_ANY_INTERFACE,
-		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
-	}
-},
-{
-	USB_DEVICE_VENDOR_SPEC(0x0fd9, 0x0008),
-	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
-		       USB_DEVICE_ID_MATCH_INT_CLASS |
-		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
-	.bInterfaceClass = USB_CLASS_AUDIO,
-	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL,
-	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
-		.vendor_name = "Hauppauge",
-		.product_name = "HVR-950Q",
-		.ifnum = QUIRK_ANY_INTERFACE,
-		.type = QUIRK_AUDIO_ALIGN_TRANSFER,
-	}
-},
+/*
+ * Auvitek au0828 devices with audio interface.
+ * This should be kept in sync with drivers/media/usb/au0828-card.c
+ * Please notice that some drivers are DVB only, and don't need to be
+ * here. That's the case, for example, of DVICO_FUSIONHDTV7.
+ */
+
+#define AU0828_DEVICE(vid, pid, vname, pname) { \
+	USB_DEVICE_VENDOR_SPEC(vid, pid), \
+	.match_flags = USB_DEVICE_ID_MATCH_DEVICE | \
+		       USB_DEVICE_ID_MATCH_INT_CLASS | \
+		       USB_DEVICE_ID_MATCH_INT_SUBCLASS, \
+	.bInterfaceClass = USB_CLASS_AUDIO, \
+	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL, \
+	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) { \
+		.vendor_name = vname, \
+		.product_name = pname, \
+		.ifnum = QUIRK_ANY_INTERFACE, \
+		.type = QUIRK_AUDIO_ALIGN_TRANSFER, \
+	} \
+}
+
+AU0828_DEVICE(0x2040, 0x7200, "Hauppauge", "HVR-950Q"),
+AU0828_DEVICE(0x2040, 0x7210, "Hauppauge", "HVR-950Q"),
+AU0828_DEVICE(0x2040, 0x7217, "Hauppauge", "HVR-950Q"),
+AU0828_DEVICE(0x2040, 0x721b, "Hauppauge", "HVR-950Q"),
+AU0828_DEVICE(0x2040, 0x721e, "Hauppauge", "HVR-950Q"),
+AU0828_DEVICE(0x2040, 0x721f, "Hauppauge", "HVR-950Q"),
+AU0828_DEVICE(0x2040, 0x7240, "Hauppauge", "HVR-850"),
+AU0828_DEVICE(0x2040, 0x7280, "Hauppauge", "HVR-950Q"),
+AU0828_DEVICE(0x0fd9, 0x0008, "Hauppauge", "HVR-950Q"),
 
 /* Digidesign Mbox */
 {
-- 
1.9.3

