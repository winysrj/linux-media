Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:54739 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029Ab3K0Fje (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Nov 2013 00:39:34 -0500
Message-ID: <5295858E.6090108@gentoo.org>
Date: Wed, 27 Nov 2013 06:39:26 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, m.chehab@samsung.com
Subject: [PATCH] mceusb: Add RC support for Hauppauge WinTV-HVR-930C HD
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add usb id of Hauppauge WinTV-HVR-930C HD.
This device has no i2c transmitter (according to eeprom content decoded 
by tveeprom).
Set the rc mapping to Hauppauge, every key of the deliviered remote
control works correctly.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
  drivers/media/rc/mceusb.c | 10 ++++++++++
  1 file changed, 10 insertions(+)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 3c76101..a25bb15 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -199,6 +199,7 @@ static bool debug;
  #define VENDOR_TIVO            0x105a
  #define VENDOR_CONEXANT                0x0572
  #define VENDOR_TWISTEDMELON    0x2596
+#define VENDOR_HAUPPAUGE       0x2040

  enum mceusb_model_type {
         MCE_GEN2 = 0,           /* Most boards */
@@ -210,6 +211,7 @@ enum mceusb_model_type {
         MULTIFUNCTION,
         TIVO_KIT,
         MCE_GEN2_NO_TX,
+       HAUPPAUGE_CX_HYBRID_TV,
  };

  struct mceusb_model {
@@ -258,6 +260,11 @@ static const struct mceusb_model mceusb_model[] = {
                 .no_tx = 1, /* tx isn't wired up at all */
                 .name = "Conexant Hybrid TV (cx231xx) MCE IR",
         },
+       [HAUPPAUGE_CX_HYBRID_TV] = {
+               .rc_map = RC_MAP_HAUPPAUGE,
+               .no_tx = 1, /* eeprom says it has no tx */
+               .name = "Conexant Hybrid TV (cx231xx) MCE IR no TX",
+       },
         [MULTIFUNCTION] = {
                 .mce_gen2 = 1,
                 .ir_intfnum = 2,
@@ -399,6 +406,9 @@ static struct usb_device_id mceusb_dev_table[] = {
         { USB_DEVICE(VENDOR_TWISTEDMELON, 0x8016) },
         /* Twisted Melon Inc. - Manta Transceiver */
         { USB_DEVICE(VENDOR_TWISTEDMELON, 0x8042) },
+       /* Hauppauge WINTV-HVR-HVR 930C-HD - based on cx231xx */
+       { USB_DEVICE(VENDOR_HAUPPAUGE, 0xb130),
+         .driver_info = HAUPPAUGE_CX_HYBRID_TV },
         /* Terminating entry */
         { }
  };
-- 
1.8.4.3

