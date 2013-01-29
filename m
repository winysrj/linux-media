Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([46.65.169.142]:59622 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755349Ab3A2MTe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 07:19:34 -0500
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Subject: [PATCH 3/5] [media] mceusb: make transmit work on the Philips IR transceiver
Date: Tue, 29 Jan 2013 12:19:29 +0000
Message-Id: <1359461971-27492-3-git-send-email-sean@mess.org>
In-Reply-To: <1359461971-27492-1-git-send-email-sean@mess.org>
References: <1359461971-27492-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The GET_REVISION command puts the device in an unresponsive state,
although it continues to report any IR activity. Note that GET_REVISION
command is not documented, nor is any possible response to it parsed.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/mceusb.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 9afb933..14fea35 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -291,7 +291,8 @@ static struct usb_device_id mceusb_dev_table[] = {
 	/* Philips/Spinel plus IR transceiver for ASUS */
 	{ USB_DEVICE(VENDOR_PHILIPS, 0x2088) },
 	/* Philips IR transceiver (Dell branded) */
-	{ USB_DEVICE(VENDOR_PHILIPS, 0x2093) },
+	{ USB_DEVICE(VENDOR_PHILIPS, 0x2093),
+	  .driver_info = MCE_GEN2_TX_INV },
 	/* Realtek MCE IR Receiver and card reader */
 	{ USB_DEVICE(VENDOR_REALTEK, 0x0161),
 	  .driver_info = MULTIFUNCTION },
@@ -1121,16 +1122,13 @@ static void mceusb_gen1_init(struct mceusb_dev *ir)
 	mce_async_out(ir, GET_REVISION, sizeof(GET_REVISION));
 
 	kfree(data);
-};
+}
 
 static void mceusb_gen2_init(struct mceusb_dev *ir)
 {
 	/* device resume */
 	mce_async_out(ir, DEVICE_RESUME, sizeof(DEVICE_RESUME));
 
-	/* get hw/sw revision? */
-	mce_async_out(ir, GET_REVISION, sizeof(GET_REVISION));
-
 	/* get wake version (protocol, key, address) */
 	mce_async_out(ir, GET_WAKEVERSION, sizeof(GET_WAKEVERSION));
 
-- 
1.8.1

