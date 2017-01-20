Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:51959 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750946AbdATNIk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jan 2017 08:08:40 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/4] [media] lirc: fix transmit-only read features
Date: Fri, 20 Jan 2017 13:08:35 +0000
Message-Id: <1e51c10c4c458aa0a31f614e46570e881fa655c5.1484916689.git.sean@mess.org>
In-Reply-To: <cover.1484916689.git.sean@mess.org>
References: <cover.1484916689.git.sean@mess.org>
In-Reply-To: <cover.1484916689.git.sean@mess.org>
References: <cover.1484916689.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

An RC device which is transmit-only shouldn't have the
LIRC_CAN_REC_MODE2 feature.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 9e41305..e944507 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -347,7 +347,7 @@ static int ir_lirc_register(struct rc_dev *dev)
 	struct lirc_driver *drv;
 	struct lirc_buffer *rbuf;
 	int rc = -ENOMEM;
-	unsigned long features;
+	unsigned long features = 0;
 
 	drv = kzalloc(sizeof(struct lirc_driver), GFP_KERNEL);
 	if (!drv)
@@ -361,7 +361,8 @@ static int ir_lirc_register(struct rc_dev *dev)
 	if (rc)
 		goto rbuf_init_failed;
 
-	features = LIRC_CAN_REC_MODE2;
+	if (dev->driver_type != RC_DRIVER_IR_RAW_TX)
+		features |= LIRC_CAN_REC_MODE2;
 	if (dev->tx_ir) {
 		features |= LIRC_CAN_SEND_PULSE;
 		if (dev->s_tx_mask)
-- 
2.9.3

