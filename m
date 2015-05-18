Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47106 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbbERFJa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2015 01:09:30 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 6/8] m88ds3103: use jiffies when polling DiSEqC TX ready
Date: Mon, 18 May 2015 08:08:49 +0300
Message-Id: <1431925731-7499-6-git-send-email-crope@iki.fi>
In-Reply-To: <1431925731-7499-1-git-send-email-crope@iki.fi>
References: <1431925731-7499-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use jiffies to set timeout for DiSEqC TX ready polling. Using jiffies
is more elegant solution than looping N times with sleep.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.c | 53 +++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 19 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index 33d8c19..e45641f 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -1195,7 +1195,8 @@ static int m88ds3103_diseqc_send_master_cmd(struct dvb_frontend *fe,
 		struct dvb_diseqc_master_cmd *diseqc_cmd)
 {
 	struct m88ds3103_priv *priv = fe->demodulator_priv;
-	int ret, i;
+	int ret;
+	unsigned long timeout;
 	u8 u8tmp;
 
 	dev_dbg(&priv->i2c->dev, "%s: msg=%*ph\n", __func__,
@@ -1226,21 +1227,24 @@ static int m88ds3103_diseqc_send_master_cmd(struct dvb_frontend *fe,
 	if (ret)
 		goto err;
 
-	/* DiSEqC message typical period is 54 ms */
-	usleep_range(40000, 60000);
-
 	/* wait DiSEqC TX ready */
-	for (i = 20, u8tmp = 1; i && u8tmp; i--) {
-		usleep_range(5000, 10000);
+	#define SEND_MASTER_CMD_TIMEOUT 120
+	timeout = jiffies + msecs_to_jiffies(SEND_MASTER_CMD_TIMEOUT);
+
+	/* DiSEqC message typical period is 54 ms */
+	usleep_range(50000, 54000);
 
+	for (u8tmp = 1; !time_after(jiffies, timeout) && u8tmp;) {
 		ret = m88ds3103_rd_reg_mask(priv, 0xa1, &u8tmp, 0x40);
 		if (ret)
 			goto err;
 	}
 
-	dev_dbg(&priv->i2c->dev, "%s: loop=%d\n", __func__, i);
-
-	if (i == 0) {
+	if (u8tmp == 0) {
+		dev_dbg(&priv->i2c->dev, "%s: diseqc tx took %u ms\n", __func__,
+			jiffies_to_msecs(jiffies) -
+			(jiffies_to_msecs(timeout) - SEND_MASTER_CMD_TIMEOUT));
+	} else {
 		dev_dbg(&priv->i2c->dev, "%s: diseqc tx timeout\n", __func__);
 
 		ret = m88ds3103_wr_reg_mask(priv, 0xa1, 0x40, 0xc0);
@@ -1252,7 +1256,7 @@ static int m88ds3103_diseqc_send_master_cmd(struct dvb_frontend *fe,
 	if (ret)
 		goto err;
 
-	if (i == 0) {
+	if (u8tmp == 1) {
 		ret = -ETIMEDOUT;
 		goto err;
 	}
@@ -1267,7 +1271,8 @@ static int m88ds3103_diseqc_send_burst(struct dvb_frontend *fe,
 	fe_sec_mini_cmd_t fe_sec_mini_cmd)
 {
 	struct m88ds3103_priv *priv = fe->demodulator_priv;
-	int ret, i;
+	int ret;
+	unsigned long timeout;
 	u8 u8tmp, burst;
 
 	dev_dbg(&priv->i2c->dev, "%s: fe_sec_mini_cmd=%d\n", __func__,
@@ -1301,26 +1306,36 @@ static int m88ds3103_diseqc_send_burst(struct dvb_frontend *fe,
 	if (ret)
 		goto err;
 
-	/* DiSEqC ToneBurst period is 12.5 ms */
-	usleep_range(11000, 20000);
-
 	/* wait DiSEqC TX ready */
-	for (i = 5, u8tmp = 1; i && u8tmp; i--) {
-		usleep_range(800, 2000);
+	#define SEND_BURST_TIMEOUT 40
+	timeout = jiffies + msecs_to_jiffies(SEND_BURST_TIMEOUT);
+
+	/* DiSEqC ToneBurst period is 12.5 ms */
+	usleep_range(8500, 12500);
 
+	for (u8tmp = 1; !time_after(jiffies, timeout) && u8tmp;) {
 		ret = m88ds3103_rd_reg_mask(priv, 0xa1, &u8tmp, 0x40);
 		if (ret)
 			goto err;
 	}
 
-	dev_dbg(&priv->i2c->dev, "%s: loop=%d\n", __func__, i);
+	if (u8tmp == 0) {
+		dev_dbg(&priv->i2c->dev, "%s: diseqc tx took %u ms\n", __func__,
+			jiffies_to_msecs(jiffies) -
+			(jiffies_to_msecs(timeout) - SEND_BURST_TIMEOUT));
+	} else {
+		dev_dbg(&priv->i2c->dev, "%s: diseqc tx timeout\n", __func__);
+
+		ret = m88ds3103_wr_reg_mask(priv, 0xa1, 0x40, 0xc0);
+		if (ret)
+			goto err;
+	}
 
 	ret = m88ds3103_wr_reg_mask(priv, 0xa2, 0x80, 0xc0);
 	if (ret)
 		goto err;
 
-	if (i == 0) {
-		dev_dbg(&priv->i2c->dev, "%s: diseqc tx timeout\n", __func__);
+	if (u8tmp == 1) {
 		ret = -ETIMEDOUT;
 		goto err;
 	}
-- 
http://palosaari.fi/

