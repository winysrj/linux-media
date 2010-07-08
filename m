Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756545Ab0GHPpm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Jul 2010 11:45:42 -0400
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o68FjfJK032567
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 8 Jul 2010 11:45:42 -0400
Received: from xavier.bos.redhat.com (xavier.bos.redhat.com [10.16.16.50])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o68FjfnV019570
	for <linux-media@vger.kernel.org>; Thu, 8 Jul 2010 11:45:41 -0400
Date: Thu, 8 Jul 2010 11:38:57 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] IR/mceusb: more streamlining of device init
Message-ID: <20100708153857.GC10999@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Spent a while last night getting device initialization packet captures
under Windows for all generations of devices. There are a few places
where we were doing things differently, and few things we were doing
that we don't need to do, particularly on gen3 hardware, and I *think*
one of those things is what was locking up my pinnacle hw from time to
time -- at least, its been perfectly well behaved every time its been
plugged in since making this change.

First up, we're adding a bit more to the gen1 init routine here. Its
not absolutely necessary, the hardware works the same both with and
without it, but I'd like to be consistent w/Windows here.

Second, DEVICE_RESET is never called when initializing either of my
gen3 devices, its only called for gen1 and gen2. The bits in the gen3
init after removing that, are safe (and interesting) to run on all
hardware, so there's no more gen3-specific init done, there's instead
a generic mceusb_get_parameters() that is run for all hardware.

Third, the gen3 flag isn't needed. We only care if hardware is gen3
during probe, so I've dropped that from the device flags struct.

Successfully tested on all three generations of mceusb hardware.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/mceusb.c |   34 ++++++++++++++++++----------------
 1 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
index e368b82..78bf7f7 100644
--- a/drivers/media/IR/mceusb.c
+++ b/drivers/media/IR/mceusb.c
@@ -254,8 +254,7 @@ struct mceusb_dev {
 		u32 connected:1;
 		u32 tx_mask_inverted:1;
 		u32 microsoft_gen1:1;
-		u32 gen3:1;
-		u32 reserved:28;
+		u32 reserved:29;
 	} flags;
 
 	/* transmit support */
@@ -292,6 +291,7 @@ struct mceusb_dev {
 static char DEVICE_RESET[]	= {0x00, 0xff, 0xaa};
 static char GET_REVISION[]	= {0xff, 0x0b};
 static char GET_UNKNOWN[]	= {0xff, 0x18};
+static char GET_UNKNOWN2[]	= {0x9f, 0x05};
 static char GET_CARRIER_FREQ[]	= {0x9f, 0x07};
 static char GET_RX_TIMEOUT[]	= {0x9f, 0x0d};
 static char GET_TX_BITMASK[]	= {0x9f, 0x13};
@@ -766,6 +766,7 @@ static void mceusb_dev_recv(struct urb *urb, struct pt_regs *regs)
 static void mceusb_gen1_init(struct mceusb_dev *ir)
 {
 	int ret;
+	int maxp = ir->len_in;
 	struct device *dev = ir->dev;
 	char *data;
 
@@ -805,6 +806,14 @@ static void mceusb_gen1_init(struct mceusb_dev *ir)
 			      0x0000, 0x0100, NULL, 0, HZ * 3);
 	dev_dbg(dev, "%s - retC = %d\n", __func__, ret);
 
+	/* device reset */
+	mce_async_out(ir, DEVICE_RESET, sizeof(DEVICE_RESET));
+	mce_sync_in(ir, NULL, maxp);
+
+	/* get hw/sw revision? */
+	mce_async_out(ir, GET_REVISION, sizeof(GET_REVISION));
+	mce_sync_in(ir, NULL, maxp);
+
 	kfree(data);
 };
 
@@ -820,19 +829,17 @@ static void mceusb_gen2_init(struct mceusb_dev *ir)
 	mce_async_out(ir, GET_REVISION, sizeof(GET_REVISION));
 	mce_sync_in(ir, NULL, maxp);
 
-	/* unknown what this actually returns... */
+	/* unknown what the next two actually return... */
 	mce_async_out(ir, GET_UNKNOWN, sizeof(GET_UNKNOWN));
 	mce_sync_in(ir, NULL, maxp);
+	mce_async_out(ir, GET_UNKNOWN2, sizeof(GET_UNKNOWN2));
+	mce_sync_in(ir, NULL, maxp);
 }
 
-static void mceusb_gen3_init(struct mceusb_dev *ir)
+static void mceusb_get_parameters(struct mceusb_dev *ir)
 {
 	int maxp = ir->len_in;
 
-	/* device reset */
-	mce_async_out(ir, DEVICE_RESET, sizeof(DEVICE_RESET));
-	mce_sync_in(ir, NULL, maxp);
-
 	/* get the carrier and frequency */
 	mce_async_out(ir, GET_CARRIER_FREQ, sizeof(GET_CARRIER_FREQ));
 	mce_sync_in(ir, NULL, maxp);
@@ -999,7 +1006,6 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	ir->usbdev = dev;
 	ir->dev = &intf->dev;
 	ir->len_in = maxp;
-	ir->flags.gen3 = is_gen3;
 	ir->flags.microsoft_gen1 = is_microsoft_gen1;
 	ir->flags.tx_mask_inverted = tx_mask_inverted;
 
@@ -1032,16 +1038,12 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	ir->urb_in->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
 	/* initialize device */
-	if (ir->flags.gen3)
-		mceusb_gen3_init(ir);
-
-	else if (ir->flags.microsoft_gen1)
+	if (ir->flags.microsoft_gen1)
 		mceusb_gen1_init(ir);
-
-	else
+	else if (!is_gen3)
 		mceusb_gen2_init(ir);
 
-	mce_sync_in(ir, NULL, maxp);
+	mceusb_get_parameters(ir);
 
 	mceusb_set_tx_mask(ir, MCE_DEFAULT_TX_MASK);
 
-- 
1.7.1

-- 
Jarod Wilson
jarod@redhat.com

