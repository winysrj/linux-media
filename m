Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33843 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253Ab3KGUhr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Nov 2013 15:37:47 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] m88ds3103: do not use dynamic stack allocation
Date: Thu,  7 Nov 2013 22:37:29 +0200
Message-Id: <1383856649-21592-2-git-send-email-crope@iki.fi>
In-Reply-To: <1383856649-21592-1-git-send-email-crope@iki.fi>
References: <1383856649-21592-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I2C transfer were using dynamic stack allocation. Get rid of it.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index fe4a67e..99eccca 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -26,17 +26,22 @@ static struct dvb_frontend_ops m88ds3103_ops;
 static int m88ds3103_wr_regs(struct m88ds3103_priv *priv,
 		u8 reg, const u8 *val, int len)
 {
+#define MAX_WR_LEN 32
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
 
@@ -59,8 +64,10 @@ static int m88ds3103_wr_regs(struct m88ds3103_priv *priv,
 static int m88ds3103_rd_regs(struct m88ds3103_priv *priv,
 		u8 reg, u8 *val, int len)
 {
+#define MAX_RD_LEN 3
+#define MAX_RD_XFER_LEN (MAX_RD_LEN)
 	int ret;
-	u8 buf[len];
+	u8 buf[MAX_RD_XFER_LEN];
 	struct i2c_msg msg[2] = {
 		{
 			.addr = priv->cfg->i2c_addr,
@@ -70,11 +77,14 @@ static int m88ds3103_rd_regs(struct m88ds3103_priv *priv,
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
 	mutex_lock(&priv->i2c_mutex);
 	ret = i2c_transfer(priv->i2c, msg, 2);
 	mutex_unlock(&priv->i2c_mutex);
-- 
1.8.4.2

