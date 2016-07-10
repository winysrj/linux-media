Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:35657 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933292AbcGJQeg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 12:34:36 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 1/5] [media] rc: make s_tx_mask consistent
Date: Sun, 10 Jul 2016 17:34:32 +0100
Message-Id: <1468168473-27499-2-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When s_tx_mask is given an invalid bitmask, the number of transmitters
should be returned. See the LIRC_SET_TRANSMITTER_MASK lirc ioctl
documentation.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/mceusb.c      | 6 ++++++
 drivers/media/rc/winbond-cir.c | 4 ++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 35155ae..0d1da2c 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -881,6 +881,12 @@ static int mceusb_set_tx_mask(struct rc_dev *dev, u32 mask)
 {
 	struct mceusb_dev *ir = dev->priv;
 
+	/* return number of transmitters */
+	int emitters = ir->num_txports ? ir->num_txports : 2;
+
+	if (mask >= (1 << emitters))
+		return emitters;
+
 	if (ir->flags.tx_mask_normal)
 		ir->tx_mask = mask;
 	else
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index d839f73..95ae60e 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -615,6 +615,10 @@ wbcir_txmask(struct rc_dev *dev, u32 mask)
 	unsigned long flags;
 	u8 val;
 
+	/* return the number of transmitters */
+	if (mask > 15)
+		return 4;
+
 	/* Four outputs, only one output can be enabled at a time */
 	switch (mask) {
 	case 0x1:
-- 
2.7.4

