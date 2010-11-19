Return-path: <mchehab@gaivota>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:33749 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492Ab0KSXom (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 18:44:42 -0500
Subject: [PATCH 09/10] mceusb: int to bool conversion
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@wilsonet.com, mchehab@infradead.org
Date: Sat, 20 Nov 2010 00:43:22 +0100
Message-ID: <20101119234322.3511.37384.stgit@localhost.localdomain>
In-Reply-To: <20101119233959.3511.91287.stgit@localhost.localdomain>
References: <20101119233959.3511.91287.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Convert boolean variables to use the corresponding data type.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/mceusb.c |   62 +++++++++++++++++++--------------------------
 1 files changed, 26 insertions(+), 36 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index ef9bddc..bb6e2dc 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -103,9 +103,9 @@
 
 /* module parameters */
 #ifdef CONFIG_USB_DEBUG
-static int debug = 1;
+static bool debug = true;
 #else
-static int debug;
+static bool debug;
 #endif
 
 /* general constants */
@@ -151,12 +151,12 @@ enum mceusb_model_type {
 };
 
 struct mceusb_model {
-	u32 mce_gen1:1;
-	u32 mce_gen2:1;
-	u32 mce_gen3:1;
-	u32 tx_mask_inverted:1;
-	u32 is_polaris:1;
-	u32 no_tx:1;
+	bool mce_gen1:1;
+	bool mce_gen2:1;
+	bool mce_gen3:1;
+	bool tx_mask_inverted:1;
+	bool is_polaris:1;
+	bool no_tx:1;
 
 	const char *rc_map;	/* Allow specify a per-board map */
 	const char *name;	/* per-board name */
@@ -164,22 +164,22 @@ struct mceusb_model {
 
 static const struct mceusb_model mceusb_model[] = {
 	[MCE_GEN1] = {
-		.mce_gen1 = 1,
-		.tx_mask_inverted = 1,
+		.mce_gen1 = true,
+		.tx_mask_inverted = true,
 	},
 	[MCE_GEN2] = {
-		.mce_gen2 = 1,
+		.mce_gen2 = true,
 	},
 	[MCE_GEN2_TX_INV] = {
-		.mce_gen2 = 1,
-		.tx_mask_inverted = 1,
+		.mce_gen2 = true,
+		.tx_mask_inverted = true,
 	},
 	[MCE_GEN3] = {
-		.mce_gen3 = 1,
-		.tx_mask_inverted = 1,
+		.mce_gen3 = true,
+		.tx_mask_inverted = true,
 	},
 	[POLARIS_EVK] = {
-		.is_polaris = 1,
+		.is_polaris = true,
 		/*
 		 * In fact, the EVK is shipped without
 		 * remotes, but we should have something handy,
@@ -189,8 +189,8 @@ static const struct mceusb_model mceusb_model[] = {
 		.name = "Conexant Hybrid TV (cx231xx) MCE IR",
 	},
 	[CX_HYBRID_TV] = {
-		.is_polaris = 1,
-		.no_tx = 1, /* tx isn't wired up at all */
+		.is_polaris = true,
+		.no_tx = true, /* tx isn't wired up at all */
 		.name = "Conexant Hybrid TV (cx231xx) MCE IR",
 	},
 };
@@ -344,10 +344,10 @@ struct mceusb_dev {
 	u8 cmd, rem;		/* Remaining IR data bytes in packet */
 
 	struct {
-		u32 connected:1;
-		u32 tx_mask_inverted:1;
-		u32 microsoft_gen1:1;
-		u32 no_tx:1;
+		bool connected:1;
+		bool tx_mask_inverted:1;
+		bool microsoft_gen1:1;
+		bool no_tx:1;
 	} flags;
 
 	/* transmit support */
@@ -1090,21 +1090,11 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	int pipe, maxp, i;
 	char buf[63], name[128] = "";
 	enum mceusb_model_type model = id->driver_info;
-	bool is_gen3;
-	bool is_microsoft_gen1;
-	bool tx_mask_inverted;
-	bool is_polaris;
 
 	dev_dbg(&intf->dev, "%s called\n", __func__);
-
 	idesc  = intf->cur_altsetting;
 
-	is_gen3 = mceusb_model[model].mce_gen3;
-	is_microsoft_gen1 = mceusb_model[model].mce_gen1;
-	tx_mask_inverted = mceusb_model[model].tx_mask_inverted;
-	is_polaris = mceusb_model[model].is_polaris;
-
-	if (is_polaris) {
+	if (mceusb_model[model].is_polaris) {
 		/* Interface 0 is IR */
 		if (idesc->desc.bInterfaceNumber)
 			return -ENODEV;
@@ -1167,8 +1157,8 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	ir->usbdev = dev;
 	ir->dev = &intf->dev;
 	ir->len_in = maxp;
-	ir->flags.microsoft_gen1 = is_microsoft_gen1;
-	ir->flags.tx_mask_inverted = tx_mask_inverted;
+	ir->flags.microsoft_gen1 = mceusb_model[model].mce_gen1;
+	ir->flags.tx_mask_inverted = mceusb_model[model].tx_mask_inverted;
 	ir->flags.no_tx = mceusb_model[model].no_tx;
 	ir->model = model;
 
@@ -1203,7 +1193,7 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	/* initialize device */
 	if (ir->flags.microsoft_gen1)
 		mceusb_gen1_init(ir);
-	else if (!is_gen3)
+	else if (!mceusb_model[model].mce_gen3)
 		mceusb_gen2_init(ir);
 
 	mceusb_get_parameters(ir);

