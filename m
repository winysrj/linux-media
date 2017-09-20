Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:38847 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751572AbdITTAG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 15:00:06 -0400
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [RFC PATCH v5 5/6] i2c: rcar: skip DMA if buffer is not safe
Date: Wed, 20 Sep 2017 20:59:55 +0200
Message-Id: <20170920185956.13874-6-wsa+renesas@sang-engineering.com>
In-Reply-To: <20170920185956.13874-1-wsa+renesas@sang-engineering.com>
References: <20170920185956.13874-1-wsa+renesas@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This HW is prone to races, so it needs to setup new messages in irq
context. That means we can't alloc bounce buffers if a message buffer is
not DMA safe. So, in that case, simply fall back to PIO.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 drivers/i2c/busses/i2c-rcar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index 15d764afec3b29..8a2ae3e6c561c4 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -359,7 +359,7 @@ static void rcar_i2c_dma(struct rcar_i2c_priv *priv)
 	int len;
 
 	/* Do not use DMA if it's not available or for messages < 8 bytes */
-	if (IS_ERR(chan) || msg->len < 8)
+	if (IS_ERR(chan) || msg->len < 8 || !(msg->flags & I2C_M_DMA_SAFE))
 		return;
 
 	if (read) {
-- 
2.11.0
