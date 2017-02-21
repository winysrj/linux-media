Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:45641 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753546AbdBUUnr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 15:43:47 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 04/19] [media] winbond: allow timeout to be set
Date: Tue, 21 Feb 2017 20:43:28 +0000
Message-Id: <7b1e8b828cd15d12a68eeb930c87cd9851e502c9.1487709384.git.sean@mess.org>
In-Reply-To: <cover.1487709384.git.sean@mess.org>
References: <cover.1487709384.git.sean@mess.org>
In-Reply-To: <cover.1487709384.git.sean@mess.org>
References: <cover.1487709384.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The drivers sets the hardware to idle when a timeout occurs. This can
be any reasonable value.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/winbond-cir.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index dc1c830..5a4d4a6 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -1082,7 +1082,9 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 	data->dev->tx_ir = wbcir_tx;
 	data->dev->priv = data;
 	data->dev->dev.parent = &device->dev;
-	data->dev->timeout = MS_TO_NS(100);
+	data->dev->min_timeout = 1;
+	data->dev->timeout = IR_DEFAULT_TIMEOUT;
+	data->dev->max_timeout = 10 * IR_DEFAULT_TIMEOUT;
 	data->dev->rx_resolution = US_TO_NS(2);
 	data->dev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
 	data->dev->allowed_wakeup_protocols = RC_BIT_NEC | RC_BIT_NECX |
-- 
2.9.3
