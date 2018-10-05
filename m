Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:52120 "EHLO
        homiemail-a58.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727572AbeJEWTY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 18:19:24 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH] mceusb: Include three Hauppauge USB dvb device with IR rx
Date: Fri,  5 Oct 2018 10:19:49 -0500
Message-Id: <1538752789-3403-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The three following Hauppauge USB DVB devices have IR receivers, but
lacked the support in mceusb to enable it:
- WinTV-HVR-935C
- WinTV-HVR-955Q
- WinTV-HVR-975

Tested HVR-955Q and HVR-975 plus RC5 remote and irw, works as intended.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/rc/mceusb.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 4c0c800..b6db968 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -432,6 +432,15 @@ static const struct usb_device_id mceusb_dev_table[] = {
 	  .driver_info = HAUPPAUGE_CX_HYBRID_TV },
 	{ USB_DEVICE(VENDOR_HAUPPAUGE, 0xb139),
 	  .driver_info = HAUPPAUGE_CX_HYBRID_TV },
+	/* Hauppauge WinTV-HVR-935C - based on cx231xx */
+	{ USB_DEVICE(VENDOR_HAUPPAUGE, 0xb151),
+	  .driver_info = HAUPPAUGE_CX_HYBRID_TV },
+	/* Hauppauge WinTV-HVR-955Q - based on cx231xx */
+	{ USB_DEVICE(VENDOR_HAUPPAUGE, 0xb123),
+	  .driver_info = HAUPPAUGE_CX_HYBRID_TV },
+	/* Hauppauge WinTV-HVR-975 - based on cx231xx */
+	{ USB_DEVICE(VENDOR_HAUPPAUGE, 0xb150),
+	  .driver_info = HAUPPAUGE_CX_HYBRID_TV },
 	{ USB_DEVICE(VENDOR_PCTV, 0x0259),
 	  .driver_info = HAUPPAUGE_CX_HYBRID_TV },
 	{ USB_DEVICE(VENDOR_PCTV, 0x025e),
-- 
2.7.4
