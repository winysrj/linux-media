Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:59279 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753113AbeDHVTt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 8 Apr 2018 17:19:49 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Matthias Reichl <hias@horus.com>
Cc: Carlo Caione <carlo@caione.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Alex Deryskyba <alex@codesnake.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        linux-amlogic@lists.infradead.org
Subject: [PATCH v2 7/7] media: rc: mceusb: allow the timeout to be configurable
Date: Sun,  8 Apr 2018 22:19:42 +0100
Message-Id: <02b5dac3b27169c6e6a4a070a2569b33fef47bbe.1523221902.git.sean@mess.org>
In-Reply-To: <cover.1523221902.git.sean@mess.org>
References: <cover.1523221902.git.sean@mess.org>
In-Reply-To: <cover.1523221902.git.sean@mess.org>
References: <cover.1523221902.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

mceusb devices have a default timeout of 100ms, but this can be changed.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/mceusb.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 69ba57372c05..c97cb2eb1c5f 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -982,6 +982,25 @@ static int mceusb_set_tx_carrier(struct rc_dev *dev, u32 carrier)
 	return 0;
 }
 
+static int mceusb_set_timeout(struct rc_dev *dev, unsigned int timeout)
+{
+	u8 cmdbuf[4] = { MCE_CMD_PORT_IR, MCE_CMD_SETIRTIMEOUT, 0, 0 };
+	struct mceusb_dev *ir = dev->priv;
+	unsigned int units;
+
+	units = DIV_ROUND_CLOSEST(timeout, US_TO_NS(MCE_TIME_UNIT));
+
+	cmdbuf[2] = units >> 8;
+	cmdbuf[3] = units;
+
+	mce_async_out(ir, cmdbuf, sizeof(cmdbuf));
+
+	/* get receiver timeout value */
+	mce_async_out(ir, GET_RX_TIMEOUT, sizeof(GET_RX_TIMEOUT));
+
+	return 0;
+}
+
 /*
  * Select or deselect the 2nd receiver port.
  * Second receiver is learning mode, wide-band, short-range receiver.
@@ -1415,7 +1434,10 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
 	rc->dev.parent = dev;
 	rc->priv = ir;
 	rc->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
+	rc->min_timeout = US_TO_NS(MCE_TIME_UNIT);
 	rc->timeout = MS_TO_NS(100);
+	rc->max_timeout = 10 * IR_DEFAULT_TIMEOUT;
+	rc->s_timeout = mceusb_set_timeout;
 	if (!ir->flags.no_tx) {
 		rc->s_tx_mask = mceusb_set_tx_mask;
 		rc->s_tx_carrier = mceusb_set_tx_carrier;
-- 
2.14.3
