Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:36527 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751379AbdGRKYT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 06:24:19 -0400
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: linux-i2c@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-input@vger.kernel.org, linux-iio@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH v3 4/4] i2c: rcar: check for DMA-capable buffers
Date: Tue, 18 Jul 2017 12:23:39 +0200
Message-Id: <20170718102339.28726-5-wsa+renesas@sang-engineering.com>
In-Reply-To: <20170718102339.28726-1-wsa+renesas@sang-engineering.com>
References: <20170718102339.28726-1-wsa+renesas@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Handling this is special for this driver. Because the hardware needs to
initialize the next message in interrupt context, we cannot use the
i2c_check_msg_for_dma() directly. This helper only works reliably in
process context. So, we need to check during initial preparation of the
whole transfer and need to disable DMA completely for the whole transfer
once a message with a not-DMA-capable buffer is found.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 drivers/i2c/busses/i2c-rcar.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index 93c1a54981df08..5d0e820d708853 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -111,8 +111,11 @@
 #define ID_ARBLOST	(1 << 3)
 #define ID_NACK		(1 << 4)
 /* persistent flags */
+#define ID_P_NODMA	(1 << 30)
 #define ID_P_PM_BLOCKED	(1 << 31)
-#define ID_P_MASK	ID_P_PM_BLOCKED
+#define ID_P_MASK	(ID_P_PM_BLOCKED | ID_P_NODMA)
+
+#define RCAR_DMA_THRESHOLD 8
 
 enum rcar_i2c_type {
 	I2C_RCAR_GEN1,
@@ -358,8 +361,7 @@ static void rcar_i2c_dma(struct rcar_i2c_priv *priv)
 	unsigned char *buf;
 	int len;
 
-	/* Do not use DMA if it's not available or for messages < 8 bytes */
-	if (IS_ERR(chan) || msg->len < 8)
+	if (IS_ERR(chan) || msg->len < RCAR_DMA_THRESHOLD || priv->flags & ID_P_NODMA)
 		return;
 
 	if (read) {
@@ -657,11 +659,15 @@ static void rcar_i2c_request_dma(struct rcar_i2c_priv *priv,
 				 struct i2c_msg *msg)
 {
 	struct device *dev = rcar_i2c_priv_to_dev(priv);
-	bool read;
+	bool read = msg->flags & I2C_M_RD;
 	struct dma_chan *chan;
 	enum dma_transfer_direction dir;
 
-	read = msg->flags & I2C_M_RD;
+	/* we need to check here because we need the 'current' context */
+	if (i2c_check_msg_for_dma(msg, RCAR_DMA_THRESHOLD, NULL) == -EFAULT) {
+		dev_dbg(dev, "skipping DMA for this whole transfer\n");
+		priv->flags |= ID_P_NODMA;
+	}
 
 	chan = read ? priv->dma_rx : priv->dma_tx;
 	if (PTR_ERR(chan) != -EPROBE_DEFER)
@@ -740,6 +746,8 @@ static int rcar_i2c_master_xfer(struct i2c_adapter *adap,
 	if (ret < 0 && ret != -ENXIO)
 		dev_err(dev, "error %d : %x\n", ret, priv->flags);
 
+	priv->flags &= ~ID_P_NODMA;
+
 	return ret;
 }
 
-- 
2.11.0
