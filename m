Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45760 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760036Ab3LHWb4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Dec 2013 17:31:56 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH REVIEW 16/18] m88ds3103: I/O optimize inittab write
Date: Mon,  9 Dec 2013 00:31:33 +0200
Message-Id: <1386541895-8634-17-git-send-email-crope@iki.fi>
In-Reply-To: <1386541895-8634-1-git-send-email-crope@iki.fi>
References: <1386541895-8634-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Write inittab using reg address auto-increment in order to reduce
I/O a little bit.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.c | 43 +++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index f9d8967..76bd85a 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -157,6 +157,38 @@ static int m88ds3103_rd_reg_mask(struct m88ds3103_priv *priv,
 	return 0;
 }
 
+/* write reg val table using reg addr auto increment */
+static int m88ds3103_wr_reg_val_tab(struct m88ds3103_priv *priv,
+		const struct m88ds3103_reg_val *tab, int tab_len)
+{
+	int ret, i, j;
+	u8 buf[83];
+	dev_dbg(&priv->i2c->dev, "%s: tab_len=%d\n", __func__, tab_len);
+
+	if (tab_len > 83) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	for (i = 0, j = 0; i < tab_len; i++, j++) {
+		buf[j] = tab[i].val;
+
+		if (i == tab_len - 1 || tab[i].reg != tab[i + 1].reg - 1 ||
+				!((j + 1) % (priv->cfg->i2c_wr_max - 1))) {
+			ret = m88ds3103_wr_regs(priv, tab[i].reg - j, buf, j + 1);
+			if (ret)
+				goto err;
+
+			j = -1;
+		}
+	}
+
+	return 0;
+err:
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
 static int m88ds3103_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
 	struct m88ds3103_priv *priv = fe->demodulator_priv;
@@ -214,7 +246,7 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 {
 	struct m88ds3103_priv *priv = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret, i, len;
+	int ret, len;
 	const struct m88ds3103_reg_val *init;
 	u8 u8tmp, u8tmp1, u8tmp2;
 	u8 buf[2];
@@ -308,12 +340,9 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 
 	/* program init table */
 	if (c->delivery_system != priv->delivery_system) {
-		dev_dbg(&priv->i2c->dev, "%s: program init\n", __func__);
-		for (i = 0; i < len; i++) {
-			ret = m88ds3103_wr_reg(priv, init[i].reg, init[i].val);
-			if (ret)
-				goto err;
-		}
+		ret = m88ds3103_wr_reg_val_tab(priv, init, len);
+		if (ret)
+			goto err;
 	}
 
 	u8tmp1 = 0; /* silence compiler warning */
-- 
1.8.4.2

