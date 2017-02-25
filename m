Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:51669 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751810AbdBYLvp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Feb 2017 06:51:45 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 04/19] [media] winbond: allow timeout to be set
Date: Sat, 25 Feb 2017 11:51:19 +0000
Message-Id: <e92e7d1bc799a549296b52dac2aef18ce63e77b1.1488023302.git.sean@mess.org>
In-Reply-To: <cover.1488023302.git.sean@mess.org>
References: <cover.1488023302.git.sean@mess.org>
In-Reply-To: <cover.1488023302.git.sean@mess.org>
References: <cover.1488023302.git.sean@mess.org>
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
