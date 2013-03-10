Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37076 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244Ab3CJCEo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:44 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 38/41] af9033: implement i/o optimized reg table writer
Date: Sun, 10 Mar 2013 04:03:30 +0200
Message-Id: <1362881013-5271-38-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use register address auto increment to reduce I/O when large
register / values tables are written.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 47 ++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 2dba516..a777b4b 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -156,6 +156,37 @@ static int af9033_rd_reg_mask(struct af9033_state *state, u32 reg, u8 *val,
 	return 0;
 }
 
+/* write reg val table using reg addr auto increment */
+static int af9033_wr_reg_val_tab(struct af9033_state *state,
+		const struct reg_val *tab, int tab_len)
+{
+	int ret, i, j;
+	u8 buf[tab_len];
+
+	dev_dbg(&state->i2c->dev, "%s: tab_len=%d\n", __func__, tab_len);
+
+	for (i = 0, j = 0; i < tab_len; i++) {
+		buf[j] = tab[i].val;
+
+		if (i == tab_len - 1 || tab[i].reg != tab[i + 1].reg - 1) {
+			ret = af9033_wr_regs(state, tab[i].reg - j, buf, j + 1);
+			if (ret < 0)
+				goto err;
+
+			j = 0;
+		} else {
+			j++;
+		}
+	}
+
+	return 0;
+
+err:
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
+
+	return ret;
+}
+
 static u32 af9033_div(struct af9033_state *state, u32 a, u32 b, u32 x)
 {
 	u32 r = 0, c = 0, i;
@@ -306,11 +337,9 @@ static int af9033_init(struct dvb_frontend *fe)
 		break;
 	}
 
-	for (i = 0; i < len; i++) {
-		ret = af9033_wr_reg(state, init[i].reg, init[i].val);
-		if (ret < 0)
-			goto err;
-	}
+	ret = af9033_wr_reg_val_tab(state, init, len);
+	if (ret < 0)
+		goto err;
 
 	/* load tuner specific settings */
 	dev_dbg(&state->i2c->dev, "%s: load tuner specific settings\n",
@@ -371,11 +400,9 @@ static int af9033_init(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	for (i = 0; i < len; i++) {
-		ret = af9033_wr_reg(state, init[i].reg, init[i].val);
-		if (ret < 0)
-			goto err;
-	}
+	ret = af9033_wr_reg_val_tab(state, init, len);
+	if (ret < 0)
+		goto err;
 
 	if (state->cfg.ts_mode == AF9033_TS_MODE_SERIAL) {
 		ret = af9033_wr_reg_mask(state, 0x00d91c, 0x01, 0x01);
-- 
1.7.11.7

