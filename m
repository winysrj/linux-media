Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:36539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756106Ab0J2DHk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 23:07:40 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9T37etB018485
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 28 Oct 2010 23:07:40 -0400
Received: from xavier.bos.redhat.com (xavier.bos.redhat.com [10.16.16.50])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o9T37d0R007768
	for <linux-media@vger.kernel.org>; Thu, 28 Oct 2010 23:07:39 -0400
Date: Thu, 28 Oct 2010 23:07:39 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/3] mceusb: add support for Conexant Hybrid TV RDU253S
Message-ID: <20101029030739.GB17238@redhat.com>
References: <20101029030545.GA17238@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101029030545.GA17238@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Another multi-function Conexant device. Interface 0 is IR, though on
this model, TX isn't wired up at all, so I've mixed in support for
models without TX (and verified that lircd says TX isn't supported when
trying to send w/this device).

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/mceusb.c |   37 +++++++++++++++++++++++++++----------
 1 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
index 9dce684..e453c6b 100644
--- a/drivers/media/IR/mceusb.c
+++ b/drivers/media/IR/mceusb.c
@@ -146,6 +146,7 @@ enum mceusb_model_type {
 	MCE_GEN3,
 	MCE_GEN2_TX_INV,
 	POLARIS_EVK,
+	CX_HYBRID_TV,
 };
 
 struct mceusb_model {
@@ -154,6 +155,7 @@ struct mceusb_model {
 	u32 mce_gen3:1;
 	u32 tx_mask_inverted:1;
 	u32 is_polaris:1;
+	u32 no_tx:1;
 
 	const char *rc_map;	/* Allow specify a per-board map */
 	const char *name;	/* per-board name */
@@ -183,7 +185,12 @@ static const struct mceusb_model mceusb_model[] = {
 		 * to allow testing it
 		 */
 		.rc_map = RC_MAP_RC5_HAUPPAUGE_NEW,
-		.name = "cx231xx MCE IR",
+		.name = "Conexant Hybrid TV (cx231xx) MCE IR",
+	},
+	[CX_HYBRID_TV] = {
+		.is_polaris = 1,
+		.no_tx = 1, /* tx isn't wired up at all */
+		.name = "Conexant Hybrid TV (cx231xx) MCE IR",
 	},
 };
 
@@ -292,9 +299,12 @@ static struct usb_device_id mceusb_dev_table[] = {
 	{ USB_DEVICE(VENDOR_NORTHSTAR, 0xe004) },
 	/* TiVo PC IR Receiver */
 	{ USB_DEVICE(VENDOR_TIVO, 0x2000) },
-	/* Conexant SDK */
+	/* Conexant Hybrid TV "Shelby" Polaris SDK */
 	{ USB_DEVICE(VENDOR_CONEXANT, 0x58a1),
 	  .driver_info = POLARIS_EVK },
+	/* Conexant Hybrid TV RDU253S Polaris */
+	{ USB_DEVICE(VENDOR_CONEXANT, 0x58a5),
+	  .driver_info = CX_HYBRID_TV },
 	/* Terminating entry */
 	{ }
 };
@@ -334,6 +344,7 @@ struct mceusb_dev {
 		u32 connected:1;
 		u32 tx_mask_inverted:1;
 		u32 microsoft_gen1:1;
+		u32 no_tx:1;
 	} flags;
 
 	/* transmit support */
@@ -724,7 +735,7 @@ out:
 	return ret ? ret : n;
 }
 
-/* Sets active IR outputs -- mce devices typically (all?) have two */
+/* Sets active IR outputs -- mce devices typically have two */
 static int mceusb_set_tx_mask(void *priv, u32 mask)
 {
 	struct mceusb_dev *ir = priv;
@@ -984,9 +995,11 @@ static void mceusb_get_parameters(struct mceusb_dev *ir)
 	mce_async_out(ir, GET_CARRIER_FREQ, sizeof(GET_CARRIER_FREQ));
 	mce_sync_in(ir, NULL, maxp);
 
-	/* get the transmitter bitmask */
-	mce_async_out(ir, GET_TX_BITMASK, sizeof(GET_TX_BITMASK));
-	mce_sync_in(ir, NULL, maxp);
+	if (!ir->flags.no_tx) {
+		/* get the transmitter bitmask */
+		mce_async_out(ir, GET_TX_BITMASK, sizeof(GET_TX_BITMASK));
+		mce_sync_in(ir, NULL, maxp);
+	}
 
 	/* get receiver timeout value */
 	mce_async_out(ir, GET_RX_TIMEOUT, sizeof(GET_RX_TIMEOUT));
@@ -1035,9 +1048,11 @@ static struct input_dev *mceusb_init_input_dev(struct mceusb_dev *ir)
 	props->priv = ir;
 	props->driver_type = RC_DRIVER_IR_RAW;
 	props->allowed_protos = IR_TYPE_ALL;
-	props->s_tx_mask = mceusb_set_tx_mask;
-	props->s_tx_carrier = mceusb_set_tx_carrier;
-	props->tx_ir = mceusb_tx_ir;
+	if (!ir->flags.no_tx) {
+		props->s_tx_mask = mceusb_set_tx_mask;
+		props->s_tx_carrier = mceusb_set_tx_carrier;
+		props->tx_ir = mceusb_tx_ir;
+	}
 
 	ir->props = props;
 
@@ -1151,6 +1166,7 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	ir->len_in = maxp;
 	ir->flags.microsoft_gen1 = is_microsoft_gen1;
 	ir->flags.tx_mask_inverted = tx_mask_inverted;
+	ir->flags.no_tx = mceusb_model[model].no_tx;
 	ir->model = model;
 
 	init_ir_raw_event(&ir->rawir);
@@ -1191,7 +1207,8 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 
 	mceusb_get_parameters(ir);
 
-	mceusb_set_tx_mask(ir, MCE_DEFAULT_TX_MASK);
+	if (!ir->flags.no_tx)
+		mceusb_set_tx_mask(ir, MCE_DEFAULT_TX_MASK);
 
 	usb_set_intfdata(intf, ir);
 
-- 
1.7.1


-- 
Jarod Wilson
jarod@redhat.com

