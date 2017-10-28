Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.220.in.ua ([89.184.67.205]:42448 "EHLO smtp.220.in.ua"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751269AbdJ1Nij (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Oct 2017 09:38:39 -0400
From: Oleh Kravchenko <oleg@kaa.org.ua>
To: linux-media@vger.kernel.org
Cc: Oleh Kravchenko <oleg@kaa.org.ua>
Subject: [PATCH 3/5] [media] mceusb: add support for 15f4:0135
Date: Sat, 28 Oct 2017 16:38:18 +0300
Message-Id: <20171028133820.18246-3-oleg@kaa.org.ua>
In-Reply-To: <20171028133820.18246-1-oleg@kaa.org.ua>
References: <20171028133820.18246-1-oleg@kaa.org.ua>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Astrometa T2hybrid (15f4:0135) has IR on Interface 0.

Signed-off-by: Oleh Kravchenko <oleg@kaa.org.ua>
---
 drivers/media/rc/mceusb.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index a12941d2f4f0..091d492f6cd2 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -189,6 +189,7 @@ enum mceusb_model_type {
 	MCE_GEN2_NO_TX,
 	HAUPPAUGE_CX_HYBRID_TV,
 	EVROMEDIA_FULL_HYBRID_FULLHD,
+	ASTROMETA_T2HYBRID,
 };
 
 struct mceusb_model {
@@ -253,6 +254,11 @@ static const struct mceusb_model mceusb_model[] = {
 		.no_tx = 1,
 		.rc_map = RC_MAP_MSI_DIGIVOX_III,
 	},
+	[ASTROMETA_T2HYBRID] = {
+		.name = "Astrometa T2Hybrid",
+		.no_tx = 1,
+		.rc_map = RC_MAP_ASTROMETA_T2HYBRID,
+	}
 };
 
 static struct usb_device_id mceusb_dev_table[] = {
@@ -407,6 +413,9 @@ static struct usb_device_id mceusb_dev_table[] = {
 	/* Evromedia USB Full Hybrid Full HD */
 	{ USB_DEVICE(0x1b80, 0xd3b2),
 	  .driver_info = EVROMEDIA_FULL_HYBRID_FULLHD },
+	/* Astrometa T2hybrid */
+	{ USB_DEVICE(0x15f4, 0x0135),
+	  .driver_info = ASTROMETA_T2HYBRID },
 
 	/* Terminating entry */
 	{ }
-- 
2.13.6
