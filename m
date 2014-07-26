Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.uli-eckhardt.de ([85.214.28.137]:43031 "EHLO
	mail.uli-eckhardt.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751819AbaGZSE1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jul 2014 14:04:27 -0400
Message-ID: <53D3EC6B.6020601@uli-eckhardt.de>
Date: Sat, 26 Jul 2014 19:59:07 +0200
From: Ulrich Eckhardt <uli@uli-eckhardt.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: jarod@wilsonet.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] [media] imon: Add internal key table for 15c2:0034
References: <53247996.7050303@uli-eckhardt.de> <20140723175537.0e9e5541.m.chehab@samsung.com> <53D3E991.9040006@uli-eckhardt.de>
In-Reply-To: <53D3E991.9040006@uli-eckhardt.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the key table for the Thermaltake DH-102 to the USB-Id 15c2:0034.

Signed-off-by: Ulrich Eckhardt <uli@uli-eckhardt.de>

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 74aa03e..c64acbf 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -307,6 +307,27 @@ static const struct imon_usb_dev_descr imon_OEM_VFD = {
 	}
 };
 
+/* imon receiver front panel/knob key table for DH102*/
+static const struct imon_usb_dev_descr imon_DH102 = {
+	.flags = IMON_NO_FLAGS,
+	.key_table = {
+		{ 0x000100000000ffeell, KEY_VOLUMEUP },
+		{ 0x010000000000ffeell, KEY_VOLUMEDOWN },
+		{ 0x000000010000ffeell, KEY_MUTE },
+		{ 0x0000000f0000ffeell, KEY_MEDIA },
+		{ 0x000000120000ffeell, KEY_UP },
+		{ 0x000000130000ffeell, KEY_DOWN },
+		{ 0x000000140000ffeell, KEY_LEFT },
+		{ 0x000000150000ffeell, KEY_RIGHT },
+		{ 0x000000160000ffeell, KEY_ENTER },
+		{ 0x000000170000ffeell, KEY_ESC },
+		{ 0x0000002b0000ffeell, KEY_EXIT },
+		{ 0x0000002c0000ffeell, KEY_SELECT },
+		{ 0x0000002d0000ffeell, KEY_MENU },
+		{ 0, KEY_RESERVED }
+	}
+};
+
 /*
  * USB Device ID for iMON USB Control Boards
  *
@@ -335,7 +356,7 @@ static struct usb_device_id imon_usb_id_table[] = {
 	 */
 	/* SoundGraph iMON OEM Touch LCD (IR & 7" VGA LCD) */
 	{ USB_DEVICE(0x15c2, 0x0034),
-	  .driver_info = (unsigned long)&imon_default_table },
+	  .driver_info = (unsigned long)&imon_DH102 },
 	/* SoundGraph iMON OEM Touch LCD (IR & 4.3" VGA LCD) */
 	{ USB_DEVICE(0x15c2, 0x0035),
 	  .driver_info = (unsigned long)&imon_default_table},


-- 
Ulrich Eckhardt                Web    : http://www.uli-eckhardt.de
Lebrecht Str.84	               E-Mail : mailto:uli@uli-eckhardt.de
64846 Groﬂ-Zimmern 	       Fax    : 06071/8269344
Tel: 06071/71921               Handy  : 0179/5090545 
