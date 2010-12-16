Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:43721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873Ab0LPTAy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Dec 2010 14:00:54 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBGJ0rlU004240
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 16 Dec 2010 14:00:53 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 1/4] mceusb: fix inverted mask inversion logic
Date: Thu, 16 Dec 2010 14:00:34 -0500
Message-Id: <1292526037-21491-2-git-send-email-jarod@redhat.com>
In-Reply-To: <1292526037-21491-1-git-send-email-jarod@redhat.com>
References: <1292526037-21491-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

As it turns out, somewhere along the way, we managed to invert the
meaning of the tx_mask_inverted flag. Looking back over the old lirc
driver, tx_mask_inverted was set to 0 if the device was in tx_mask_list.
Now we have a tx_mask_inverted flag set to 1 for all the devices that
were in the list, and set tx_mask_inverted to that flag value, which is
actually the opposite of what we used to set, causing set_tx_mask to use
the wrong mask setting option. Since there seem to be more devices with
inverted masks than not (using the original device as the baseline for
inverted vs. normal), lets just call the ones currently marked as
inverted normal instead, and flip the if/else actions that key off of
the inverted flag.

Note: the problem only cropped up if a call to set_tx_mask was made, if
no mask was set, the device would work just fine, which is why this
managed to slip though w/o getting noticed until now.

Tested successfully by myself and Dennis Gilmore.

Reported-by: Dennis Gilmore <dgilmore@redhat.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/mceusb.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 33c0147..0739dee 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -155,7 +155,7 @@ struct mceusb_model {
 	u32 mce_gen1:1;
 	u32 mce_gen2:1;
 	u32 mce_gen3:1;
-	u32 tx_mask_inverted:1;
+	u32 tx_mask_normal:1;
 	u32 is_polaris:1;
 	u32 no_tx:1;
 
@@ -166,18 +166,18 @@ struct mceusb_model {
 static const struct mceusb_model mceusb_model[] = {
 	[MCE_GEN1] = {
 		.mce_gen1 = 1,
-		.tx_mask_inverted = 1,
+		.tx_mask_normal = 1,
 	},
 	[MCE_GEN2] = {
 		.mce_gen2 = 1,
 	},
 	[MCE_GEN2_TX_INV] = {
 		.mce_gen2 = 1,
-		.tx_mask_inverted = 1,
+		.tx_mask_normal = 1,
 	},
 	[MCE_GEN3] = {
 		.mce_gen3 = 1,
-		.tx_mask_inverted = 1,
+		.tx_mask_normal = 1,
 	},
 	[POLARIS_EVK] = {
 		.is_polaris = 1,
@@ -346,7 +346,7 @@ struct mceusb_dev {
 
 	struct {
 		u32 connected:1;
-		u32 tx_mask_inverted:1;
+		u32 tx_mask_normal:1;
 		u32 microsoft_gen1:1;
 		u32 no_tx:1;
 	} flags;
@@ -749,11 +749,11 @@ static int mceusb_set_tx_mask(struct rc_dev *dev, u32 mask)
 {
 	struct mceusb_dev *ir = dev->priv;
 
-	if (ir->flags.tx_mask_inverted)
+	if (ir->flags.tx_mask_normal)
+		ir->tx_mask = mask;
+	else
 		ir->tx_mask = (mask != MCE_DEFAULT_TX_MASK ?
 				mask ^ MCE_DEFAULT_TX_MASK : mask) << 1;
-	else
-		ir->tx_mask = mask;
 
 	return 0;
 }
@@ -1095,7 +1095,7 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	enum mceusb_model_type model = id->driver_info;
 	bool is_gen3;
 	bool is_microsoft_gen1;
-	bool tx_mask_inverted;
+	bool tx_mask_normal;
 	bool is_polaris;
 
 	dev_dbg(&intf->dev, "%s called\n", __func__);
@@ -1104,7 +1104,7 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 
 	is_gen3 = mceusb_model[model].mce_gen3;
 	is_microsoft_gen1 = mceusb_model[model].mce_gen1;
-	tx_mask_inverted = mceusb_model[model].tx_mask_inverted;
+	tx_mask_normal = mceusb_model[model].tx_mask_normal;
 	is_polaris = mceusb_model[model].is_polaris;
 
 	if (is_polaris) {
@@ -1171,7 +1171,7 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	ir->dev = &intf->dev;
 	ir->len_in = maxp;
 	ir->flags.microsoft_gen1 = is_microsoft_gen1;
-	ir->flags.tx_mask_inverted = tx_mask_inverted;
+	ir->flags.tx_mask_normal = tx_mask_normal;
 	ir->flags.no_tx = mceusb_model[model].no_tx;
 	ir->model = model;
 
-- 
1.7.1

