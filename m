Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:46715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755636Ab0JVNZq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Oct 2010 09:25:46 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9MDPk1B005796
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 22 Oct 2010 09:25:46 -0400
Date: Fri, 22 Oct 2010 11:25:26 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: jarod@redhat.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/3] mceusb: add a per-model structure
Message-ID: <20101022112526.5dadfc68@pedra>
In-Reply-To: <cover.1287753463.git.mchehab@redhat.com>
References: <cover.1287753463.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The previous logic needed duplicate USB table structs, one to store
the list of the devices, and 3 sets of other structs, to store the
quirks list.

With this change, devices that require expecial quirks just need to
have a .driver_info = <quirk entry>.

It also allows adding some extra quirks, like per-model RC tables.

As a bonus, this patch reduced in 10% the data segment size:

   text	   data	    bss	    dec	    hex	filename
  15487	   5008	      4	  20499	   5013	old/mceusb.ko
  15438	   4496	      4	  19938	   4de2	new/mceusb.ko

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
index ab11e6b..9143ab6 100644
--- a/drivers/media/IR/mceusb.c
+++ b/drivers/media/IR/mceusb.c
@@ -108,13 +108,62 @@ static int debug;
 #define VENDOR_TIVO		0x105a
 #define VENDOR_CONEXANT		0x0572
 
+enum mceusb_model_type {
+	MCE_GEN2 = 0,		/* Most boards */
+	MCE_GEN1,
+	MCE_GEN3,
+	MCE_GEN1_TX_INV,
+	MCE_GEN2_TX_INV,
+	MCE_GEN3_TX_INV,
+	POLARIS_EVK,
+};
+
+struct mceusb_model {
+	u32 mce_gen1:1;
+	u32 mce_gen2:1;
+	u32 mce_gen3:1;
+	u32 tx_mask_inverted:1;
+	u32 is_polaris:1;
+
+	/*
+	 * Allow specify a per-board extra data, like
+	 * device names, and per-device rc_maps
+	 */
+};
+
+static const struct mceusb_model mceusb_model[] = {
+	[MCE_GEN1] = {
+		.mce_gen1 = 1,
+	},
+	[MCE_GEN1_TX_INV] = {
+		.mce_gen1 = 1,
+		.tx_mask_inverted = 1,
+	},
+	[MCE_GEN2] = {
+		.mce_gen2 = 1,
+	},
+	[MCE_GEN2_TX_INV] = {
+		.mce_gen2 = 1,
+		.tx_mask_inverted = 1,
+	},
+	[MCE_GEN3_TX_INV] = {
+		.mce_gen3 = 1,
+		.tx_mask_inverted = 1,
+	},
+	[POLARIS_EVK] = {
+		.is_polaris = 1,
+	},
+};
+
 static struct usb_device_id mceusb_dev_table[] = {
 	/* Original Microsoft MCE IR Transceiver (often HP-branded) */
-	{ USB_DEVICE(VENDOR_MICROSOFT, 0x006d) },
+	{ USB_DEVICE(VENDOR_MICROSOFT, 0x006d),
+	  .driver_info = MCE_GEN1_TX_INV },
 	/* Philips Infrared Transceiver - Sahara branded */
 	{ USB_DEVICE(VENDOR_PHILIPS, 0x0608) },
 	/* Philips Infrared Transceiver - HP branded */
-	{ USB_DEVICE(VENDOR_PHILIPS, 0x060c) },
+	{ USB_DEVICE(VENDOR_PHILIPS, 0x060c),
+	  .driver_info = MCE_GEN2_TX_INV },
 	/* Philips SRM5100 */
 	{ USB_DEVICE(VENDOR_PHILIPS, 0x060d) },
 	/* Philips Infrared Transceiver - Omaura */
@@ -130,11 +179,14 @@ static struct usb_device_id mceusb_dev_table[] = {
 	/* Realtek MCE IR Receiver */
 	{ USB_DEVICE(VENDOR_REALTEK, 0x0161) },
 	/* SMK/Toshiba G83C0004D410 */
-	{ USB_DEVICE(VENDOR_SMK, 0x031d) },
+	{ USB_DEVICE(VENDOR_SMK, 0x031d),
+	  .driver_info = MCE_GEN2_TX_INV },
 	/* SMK eHome Infrared Transceiver (Sony VAIO) */
-	{ USB_DEVICE(VENDOR_SMK, 0x0322) },
+	{ USB_DEVICE(VENDOR_SMK, 0x0322),
+	  .driver_info = MCE_GEN2_TX_INV },
 	/* bundled with Hauppauge PVR-150 */
-	{ USB_DEVICE(VENDOR_SMK, 0x0334) },
+	{ USB_DEVICE(VENDOR_SMK, 0x0334),
+	  .driver_info = MCE_GEN2_TX_INV },
 	/* SMK eHome Infrared Transceiver */
 	{ USB_DEVICE(VENDOR_SMK, 0x0338) },
 	/* Tatung eHome Infrared Transceiver */
@@ -148,17 +200,23 @@ static struct usb_device_id mceusb_dev_table[] = {
 	/* Mitsumi */
 	{ USB_DEVICE(VENDOR_MITSUMI, 0x2501) },
 	/* Topseed eHome Infrared Transceiver */
-	{ USB_DEVICE(VENDOR_TOPSEED, 0x0001) },
+	{ USB_DEVICE(VENDOR_TOPSEED, 0x0001),
+	  .driver_info = MCE_GEN2_TX_INV },
 	/* Topseed HP eHome Infrared Transceiver */
-	{ USB_DEVICE(VENDOR_TOPSEED, 0x0006) },
+	{ USB_DEVICE(VENDOR_TOPSEED, 0x0006),
+	  .driver_info = MCE_GEN2_TX_INV },
 	/* Topseed eHome Infrared Transceiver */
-	{ USB_DEVICE(VENDOR_TOPSEED, 0x0007) },
+	{ USB_DEVICE(VENDOR_TOPSEED, 0x0007),
+	  .driver_info = MCE_GEN2_TX_INV },
 	/* Topseed eHome Infrared Transceiver */
-	{ USB_DEVICE(VENDOR_TOPSEED, 0x0008) },
+	{ USB_DEVICE(VENDOR_TOPSEED, 0x0008),
+	  .driver_info = MCE_GEN3_TX_INV },
 	/* Topseed eHome Infrared Transceiver */
-	{ USB_DEVICE(VENDOR_TOPSEED, 0x000a) },
+	{ USB_DEVICE(VENDOR_TOPSEED, 0x000a),
+	  .driver_info = MCE_GEN2_TX_INV },
 	/* Topseed eHome Infrared Transceiver */
-	{ USB_DEVICE(VENDOR_TOPSEED, 0x0011) },
+	{ USB_DEVICE(VENDOR_TOPSEED, 0x0011),
+	  .driver_info = MCE_GEN2_TX_INV },
 	/* Ricavision internal Infrared Transceiver */
 	{ USB_DEVICE(VENDOR_RICAVISION, 0x0010) },
 	/* Itron ione Libra Q-11 */
@@ -188,7 +246,8 @@ static struct usb_device_id mceusb_dev_table[] = {
 	/* Fintek eHome Infrared Transceiver (in the AOpen MP45) */
 	{ USB_DEVICE(VENDOR_FINTEK, 0x0702) },
 	/* Pinnacle Remote Kit */
-	{ USB_DEVICE(VENDOR_PINNACLE, 0x0225) },
+	{ USB_DEVICE(VENDOR_PINNACLE, 0x0225),
+	  .driver_info = MCE_GEN3_TX_INV },
 	/* Elitegroup Computer Systems IR */
 	{ USB_DEVICE(VENDOR_ECS, 0x0f38) },
 	/* Wistron Corp. eHome Infrared Receiver */
@@ -202,43 +261,12 @@ static struct usb_device_id mceusb_dev_table[] = {
 	/* TiVo PC IR Receiver */
 	{ USB_DEVICE(VENDOR_TIVO, 0x2000) },
 	/* Conexant SDK */
-	{ USB_DEVICE(VENDOR_CONEXANT, 0x58a1) },
+	{ USB_DEVICE(VENDOR_CONEXANT, 0x58a1),
+	  .driver_info = POLARIS_EVK },
 	/* Terminating entry */
 	{ }
 };
 
-static struct usb_device_id gen3_list[] = {
-	{ USB_DEVICE(VENDOR_PINNACLE, 0x0225) },
-	{ USB_DEVICE(VENDOR_TOPSEED, 0x0008) },
-	{}
-};
-
-static struct usb_device_id microsoft_gen1_list[] = {
-	{ USB_DEVICE(VENDOR_MICROSOFT, 0x006d) },
-	{}
-};
-
-static struct usb_device_id std_tx_mask_list[] = {
-	{ USB_DEVICE(VENDOR_MICROSOFT, 0x006d) },
-	{ USB_DEVICE(VENDOR_PHILIPS, 0x060c) },
-	{ USB_DEVICE(VENDOR_SMK, 0x031d) },
-	{ USB_DEVICE(VENDOR_SMK, 0x0322) },
-	{ USB_DEVICE(VENDOR_SMK, 0x0334) },
-	{ USB_DEVICE(VENDOR_TOPSEED, 0x0001) },
-	{ USB_DEVICE(VENDOR_TOPSEED, 0x0006) },
-	{ USB_DEVICE(VENDOR_TOPSEED, 0x0007) },
-	{ USB_DEVICE(VENDOR_TOPSEED, 0x0008) },
-	{ USB_DEVICE(VENDOR_TOPSEED, 0x000a) },
-	{ USB_DEVICE(VENDOR_TOPSEED, 0x0011) },
-	{ USB_DEVICE(VENDOR_PINNACLE, 0x0225) },
-	{}
-};
-
-static struct usb_device_id cx_polaris_list[] = {
-	{ USB_DEVICE(VENDOR_CONEXANT, 0x58a1) },
-	{}
-};
-
 /* data structure for each usb transceiver */
 struct mceusb_dev {
 	/* ir-core bits */
@@ -274,7 +302,6 @@ struct mceusb_dev {
 		u32 connected:1;
 		u32 tx_mask_inverted:1;
 		u32 microsoft_gen1:1;
-		u32 reserved:29;
 	} flags;
 
 	/* transmit support */
@@ -284,6 +311,7 @@ struct mceusb_dev {
 
 	char name[128];
 	char phys[64];
+	enum mceusb_model_type model;
 };
 
 /*
@@ -989,6 +1017,7 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	struct mceusb_dev *ir = NULL;
 	int pipe, maxp, i;
 	char buf[63], name[128] = "";
+	enum mceusb_model_type model = id->driver_info;
 	bool is_gen3;
 	bool is_microsoft_gen1;
 	bool tx_mask_inverted;
@@ -998,10 +1027,10 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 
 	idesc  = intf->cur_altsetting;
 
-	is_gen3 = usb_match_id(intf, gen3_list) ? 1 : 0;
-	is_microsoft_gen1 = usb_match_id(intf, microsoft_gen1_list) ? 1 : 0;
-	tx_mask_inverted = usb_match_id(intf, std_tx_mask_list) ? 0 : 1;
-	is_polaris = usb_match_id(intf, cx_polaris_list) ? 1 : 0;
+	is_gen3 = mceusb_model[model].mce_gen3;
+	is_microsoft_gen1 = mceusb_model[model].mce_gen1;
+	tx_mask_inverted = mceusb_model[model].tx_mask_inverted;
+	is_polaris = mceusb_model[model].is_polaris;
 
 	if (is_polaris) {
 		/* Interface 0 is IR */
@@ -1068,6 +1097,8 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	ir->len_in = maxp;
 	ir->flags.microsoft_gen1 = is_microsoft_gen1;
 	ir->flags.tx_mask_inverted = tx_mask_inverted;
+	ir->model = model;
+
 	init_ir_raw_event(&ir->rawir);
 
 	/* Saving usb interface data for use by the transmitter routine */
-- 
1.7.1


