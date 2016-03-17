Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34059 "EHLO
	mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933880AbcCQNLT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Mar 2016 09:11:19 -0400
Received: by mail-lf0-f68.google.com with SMTP id i75so2931359lfb.1
        for <linux-media@vger.kernel.org>; Thu, 17 Mar 2016 06:11:18 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 1/2] mceusb: add support for Adaptec eHome receiver
Date: Thu, 17 Mar 2016 15:11:09 +0200
Message-Id: <1458220270-1650-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

New USB ID for Adaptec eHome receiver in some HP laptops.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/rc/mceusb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 35155ae..09ca9f6 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -188,6 +188,7 @@
 #define VENDOR_TWISTEDMELON	0x2596
 #define VENDOR_HAUPPAUGE	0x2040
 #define VENDOR_PCTV		0x2013
+#define VENDOR_ADAPTEC		0x03f3
 
 enum mceusb_model_type {
 	MCE_GEN2 = 0,		/* Most boards */
@@ -405,6 +406,8 @@ static struct usb_device_id mceusb_dev_table[] = {
 	  .driver_info = HAUPPAUGE_CX_HYBRID_TV },
 	{ USB_DEVICE(VENDOR_PCTV, 0x025e),
 	  .driver_info = HAUPPAUGE_CX_HYBRID_TV },
+	/* Adaptec / HP eHome Receiver */
+	{ USB_DEVICE(VENDOR_ADAPTEC, 0x0094) },
 
 	/* Terminating entry */
 	{ }
-- 
1.9.1

