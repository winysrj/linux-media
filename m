Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37819 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab3KGUhr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Nov 2013 15:37:47 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] m88ts2022: do not use dynamic stack allocation
Date: Thu,  7 Nov 2013 22:37:28 +0200
Message-Id: <1383856649-21592-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I2C transfer were using dynamic stack allocation. Get rid of it.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/m88ts2022.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/media/tuners/m88ts2022.c b/drivers/media/tuners/m88ts2022.c
index ef69db4..655b13a 100644
--- a/drivers/media/tuners/m88ts2022.c
+++ b/drivers/media/tuners/m88ts2022.c
@@ -24,17 +24,22 @@
 static int m88ts2022_wr_regs(struct m88ts2022_priv *priv,
 		u8 reg, const u8 *val, int len)
 {
+#define MAX_WR_LEN 3
+#define MAX_WR_XFER_LEN (MAX_WR_LEN + 1)
 	int ret;
-	u8 buf[1 + len];
+	u8 buf[MAX_WR_XFER_LEN];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = priv->cfg->i2c_addr,
 			.flags = 0,
-			.len = sizeof(buf),
+			.len = 1 + len,
 			.buf = buf,
 		}
 	};
 
+	if (WARN_ON(len > MAX_WR_LEN))
+		return -EINVAL;
+
 	buf[0] = reg;
 	memcpy(&buf[1], val, len);
 
@@ -55,8 +60,10 @@ static int m88ts2022_wr_regs(struct m88ts2022_priv *priv,
 static int m88ts2022_rd_regs(struct m88ts2022_priv *priv, u8 reg,
 		u8 *val, int len)
 {
+#define MAX_RD_LEN 1
+#define MAX_RD_XFER_LEN (MAX_RD_LEN)
 	int ret;
-	u8 buf[len];
+	u8 buf[MAX_RD_XFER_LEN];
 	struct i2c_msg msg[2] = {
 		{
 			.addr = priv->cfg->i2c_addr,
@@ -66,11 +73,14 @@ static int m88ts2022_rd_regs(struct m88ts2022_priv *priv, u8 reg,
 		}, {
 			.addr = priv->cfg->i2c_addr,
 			.flags = I2C_M_RD,
-			.len = sizeof(buf),
+			.len = len,
 			.buf = buf,
 		}
 	};
 
+	if (WARN_ON(len > MAX_RD_LEN))
+		return -EINVAL;
+
 	ret = i2c_transfer(priv->i2c, msg, 2);
 	if (ret == 2) {
 		memcpy(val, buf, len);
-- 
1.8.4.2

