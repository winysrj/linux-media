Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40933 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757904Ab2HUQNM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 12:13:12 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] tda18218: re-implement tda18218_wr_regs()
Date: Tue, 21 Aug 2012 19:12:50 +0300
Message-Id: <1345565570-30887-2-git-send-email-crope@iki.fi>
In-Reply-To: <1345565570-30887-1-git-send-email-crope@iki.fi>
References: <1345565570-30887-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Old i2c message length splitting logic was faulty. Make it better.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/tda18218.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/media/tuners/tda18218.c b/drivers/media/tuners/tda18218.c
index ffbec9e..1819853 100644
--- a/drivers/media/tuners/tda18218.c
+++ b/drivers/media/tuners/tda18218.c
@@ -23,8 +23,8 @@
 /* write multiple registers */
 static int tda18218_wr_regs(struct tda18218_priv *priv, u8 reg, u8 *val, u8 len)
 {
-	int ret = 0;
-	u8 buf[1+len], quotient, remainder, i, msg_len, msg_len_max;
+	int ret = 0, len2, remaining;
+	u8 buf[1 + len];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = priv->cfg->i2c_address,
@@ -33,17 +33,15 @@ static int tda18218_wr_regs(struct tda18218_priv *priv, u8 reg, u8 *val, u8 len)
 		}
 	};
 
-	msg_len_max = priv->cfg->i2c_wr_max - 1;
-	quotient = len / msg_len_max;
-	remainder = len % msg_len_max;
-	msg_len = msg_len_max;
-	for (i = 0; (i <= quotient && remainder); i++) {
-		if (i == quotient)  /* set len of the last msg */
-			msg_len = remainder;
-
-		msg[0].len = msg_len + 1;
-		buf[0] = reg + i * msg_len_max;
-		memcpy(&buf[1], &val[i * msg_len_max], msg_len);
+	for (remaining = len; remaining > 0;
+			remaining -= (priv->cfg->i2c_wr_max - 1)) {
+		len2 = remaining;
+		if (len2 > (priv->cfg->i2c_wr_max - 1))
+			len2 = (priv->cfg->i2c_wr_max - 1);
+
+		msg[0].len = 1 + len2;
+		buf[0] = reg + len - remaining;
+		memcpy(&buf[1], &val[len - remaining], len2);
 
 		ret = i2c_transfer(priv->i2c, msg, 1);
 		if (ret != 1)
-- 
1.7.11.4

