Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55640 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaG0UNT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jul 2014 16:13:19 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] cx231xx: add support for newer cx231xx devices
Date: Sun, 27 Jul 2014 17:13:12 -0300
Message-Id: <1406491992-5404-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for the si2165-based cx231xx devices:
	[2013:025e] PCTV QuatroStick 522e
	[2013:0259] PCTV QuatroStick 521e
	[2040:b131] Hauppauge WinTV 930C-HD (model 1114xx)

They're similar to the already supported:
	[2040:b130] Hauppauge WinTV 930C-HD (model 1113xx)

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/rc/mceusb.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index b1be81fc6bd7..48a6a0826a77 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -187,6 +187,7 @@
 #define VENDOR_CONEXANT		0x0572
 #define VENDOR_TWISTEDMELON	0x2596
 #define VENDOR_HAUPPAUGE	0x2040
+#define VENDOR_PCTV		0x2013
 
 enum mceusb_model_type {
 	MCE_GEN2 = 0,		/* Most boards */
@@ -396,6 +397,13 @@ static struct usb_device_id mceusb_dev_table[] = {
 	/* Hauppauge WINTV-HVR-HVR 930C-HD - based on cx231xx */
 	{ USB_DEVICE(VENDOR_HAUPPAUGE, 0xb130),
 	  .driver_info = HAUPPAUGE_CX_HYBRID_TV },
+	{ USB_DEVICE(VENDOR_HAUPPAUGE, 0xb131),
+	  .driver_info = HAUPPAUGE_CX_HYBRID_TV },
+	{ USB_DEVICE(VENDOR_PCTV, 0x0259),
+	  .driver_info = HAUPPAUGE_CX_HYBRID_TV },
+	{ USB_DEVICE(VENDOR_PCTV, 0x025e),
+	  .driver_info = HAUPPAUGE_CX_HYBRID_TV },
+
 	/* Terminating entry */
 	{ }
 };
-- 
1.9.3

