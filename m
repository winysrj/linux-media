Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:60001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756436Ab1CAPic (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Mar 2011 10:38:32 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p21FcWMq023891
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 1 Mar 2011 10:38:32 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] mceusb: don't claim multifunction device non-IR parts
Date: Tue,  1 Mar 2011 10:38:28 -0500
Message-Id: <1298993908-26828-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

There's a Realtek combo card reader and IR receiver device with multiple
usb interfaces on it. The mceusb driver is incorrectly grabbing all of
them. This change should make it bind to only interface 2 (patch based
on lsusb output on the linux-media list from Lucian Muresan).

Tested regression-free with the six mceusb devices I have myself.

Reported-by: Patrick Boettcher <pboettcher@kernellabs.com>
Reported-by: Lucian Muresan <lucianm@users.sourceforge.net>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/mceusb.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 6df0a49..e4f8eac 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -148,6 +148,7 @@ enum mceusb_model_type {
 	MCE_GEN2_TX_INV,
 	POLARIS_EVK,
 	CX_HYBRID_TV,
+	MULTIFUNCTION,
 };
 
 struct mceusb_model {
@@ -155,9 +156,10 @@ struct mceusb_model {
 	u32 mce_gen2:1;
 	u32 mce_gen3:1;
 	u32 tx_mask_normal:1;
-	u32 is_polaris:1;
 	u32 no_tx:1;
 
+	int ir_intfnum;
+
 	const char *rc_map;	/* Allow specify a per-board map */
 	const char *name;	/* per-board name */
 };
@@ -179,7 +181,6 @@ static const struct mceusb_model mceusb_model[] = {
 		.tx_mask_normal = 1,
 	},
 	[POLARIS_EVK] = {
-		.is_polaris = 1,
 		/*
 		 * In fact, the EVK is shipped without
 		 * remotes, but we should have something handy,
@@ -189,10 +190,13 @@ static const struct mceusb_model mceusb_model[] = {
 		.name = "Conexant Hybrid TV (cx231xx) MCE IR",
 	},
 	[CX_HYBRID_TV] = {
-		.is_polaris = 1,
 		.no_tx = 1, /* tx isn't wired up at all */
 		.name = "Conexant Hybrid TV (cx231xx) MCE IR",
 	},
+	[MULTIFUNCTION] = {
+		.mce_gen2 = 1,
+		.ir_intfnum = 2,
+	},
 };
 
 static struct usb_device_id mceusb_dev_table[] = {
@@ -216,8 +220,9 @@ static struct usb_device_id mceusb_dev_table[] = {
 	{ USB_DEVICE(VENDOR_PHILIPS, 0x206c) },
 	/* Philips/Spinel plus IR transceiver for ASUS */
 	{ USB_DEVICE(VENDOR_PHILIPS, 0x2088) },
-	/* Realtek MCE IR Receiver */
-	{ USB_DEVICE(VENDOR_REALTEK, 0x0161) },
+	/* Realtek MCE IR Receiver and card reader */
+	{ USB_DEVICE(VENDOR_REALTEK, 0x0161),
+	  .driver_info = MULTIFUNCTION },
 	/* SMK/Toshiba G83C0004D410 */
 	{ USB_DEVICE(VENDOR_SMK, 0x031d),
 	  .driver_info = MCE_GEN2_TX_INV },
@@ -1101,7 +1106,7 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	bool is_gen3;
 	bool is_microsoft_gen1;
 	bool tx_mask_normal;
-	bool is_polaris;
+	int ir_intfnum;
 
 	dev_dbg(&intf->dev, "%s called\n", __func__);
 
@@ -1110,13 +1115,11 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	is_gen3 = mceusb_model[model].mce_gen3;
 	is_microsoft_gen1 = mceusb_model[model].mce_gen1;
 	tx_mask_normal = mceusb_model[model].tx_mask_normal;
-	is_polaris = mceusb_model[model].is_polaris;
+	ir_intfnum = mceusb_model[model].ir_intfnum;
 
-	if (is_polaris) {
-		/* Interface 0 is IR */
-		if (idesc->desc.bInterfaceNumber)
-			return -ENODEV;
-	}
+	/* There are multi-function devices with non-IR interfaces */
+	if (idesc->desc.bInterfaceNumber != ir_intfnum)
+		return -ENODEV;
 
 	/* step through the endpoints to find first bulk in and out endpoint */
 	for (i = 0; i < idesc->desc.bNumEndpoints; ++i) {
-- 
1.7.1

