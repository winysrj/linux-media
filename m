Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44051 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756555Ab2IMAYZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 20:24:25 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 07/16] rtl2830: use .get_if_frequency()
Date: Thu, 13 Sep 2012 03:23:48 +0300
Message-Id: <1347495837-3244-7-git-send-email-crope@iki.fi>
In-Reply-To: <1347495837-3244-1-git-send-email-crope@iki.fi>
References: <1347495837-3244-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use .get_if_frequency() as all used tuner drivers
(mt2060/qt1010/mxl5005s) supports it.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2830.c   | 57 +++++++++++++++++++--------------
 drivers/media/dvb-frontends/rtl2830.h   |  7 ----
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c |  3 --
 3 files changed, 33 insertions(+), 34 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index 5f53d0c..3954760 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -182,9 +182,6 @@ static int rtl2830_init(struct dvb_frontend *fe)
 {
 	struct rtl2830_priv *priv = fe->demodulator_priv;
 	int ret, i;
-	u64 num;
-	u8 buf[3], tmp;
-	u32 if_ctl;
 	struct rtl2830_reg_val_mask tab[] = {
 		{ 0x00d, 0x01, 0x03 },
 		{ 0x00d, 0x10, 0x10 },
@@ -240,26 +237,6 @@ static int rtl2830_init(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	num = priv->cfg.if_dvbt % priv->cfg.xtal;
-	num *= 0x400000;
-	num = div_u64(num, priv->cfg.xtal);
-	num = -num;
-	if_ctl = num & 0x3fffff;
-	dev_dbg(&priv->i2c->dev, "%s: if_ctl=%08x\n", __func__, if_ctl);
-
-	ret = rtl2830_rd_reg_mask(priv, 0x119, &tmp, 0xc0); /* b[7:6] */
-	if (ret)
-		goto err;
-
-	buf[0] = tmp << 6;
-	buf[0] |= (if_ctl >> 16) & 0x3f;
-	buf[1] = (if_ctl >>  8) & 0xff;
-	buf[2] = (if_ctl >>  0) & 0xff;
-
-	ret = rtl2830_wr_regs(priv, 0x119, buf, 3);
-	if (ret)
-		goto err;
-
 	/* TODO: spec init */
 
 	/* soft reset */
@@ -301,6 +278,9 @@ static int rtl2830_set_frontend(struct dvb_frontend *fe)
 	struct rtl2830_priv *priv = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
+	u64 num;
+	u8 buf[3], tmp;
+	u32 if_ctl, if_frequency;
 	static u8 bw_params1[3][34] = {
 		{
 		0x1f, 0xf0, 0x1f, 0xf0, 0x1f, 0xfa, 0x00, 0x17, 0x00, 0x41,
@@ -325,7 +305,6 @@ static int rtl2830_set_frontend(struct dvb_frontend *fe)
 		{0xae, 0xba, 0xf3, 0x26, 0x66, 0x64,}, /* 8 MHz */
 	};
 
-
 	dev_dbg(&priv->i2c->dev,
 			"%s: frequency=%d bandwidth_hz=%d inversion=%d\n",
 			__func__, c->frequency, c->bandwidth_hz, c->inversion);
@@ -353,6 +332,36 @@ static int rtl2830_set_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
+	/* program if frequency */
+	if (fe->ops.tuner_ops.get_if_frequency)
+		ret = fe->ops.tuner_ops.get_if_frequency(fe, &if_frequency);
+	else
+		ret = -EINVAL;
+
+	if (ret < 0)
+		goto err;
+
+	num = if_frequency % priv->cfg.xtal;
+	num *= 0x400000;
+	num = div_u64(num, priv->cfg.xtal);
+	num = -num;
+	if_ctl = num & 0x3fffff;
+	dev_dbg(&priv->i2c->dev, "%s: if_frequency=%d if_ctl=%08x\n",
+			__func__, if_frequency, if_ctl);
+
+	ret = rtl2830_rd_reg_mask(priv, 0x119, &tmp, 0xc0); /* b[7:6] */
+	if (ret)
+		goto err;
+
+	buf[0] = tmp << 6;
+	buf[0] |= (if_ctl >> 16) & 0x3f;
+	buf[1] = (if_ctl >>  8) & 0xff;
+	buf[2] = (if_ctl >>  0) & 0xff;
+
+	ret = rtl2830_wr_regs(priv, 0x119, buf, 3);
+	if (ret)
+		goto err;
+
 	/* 1/2 split I2C write */
 	ret = rtl2830_wr_regs(priv, 0x11c, &bw_params1[i][0], 17);
 	if (ret)
diff --git a/drivers/media/dvb-frontends/rtl2830.h b/drivers/media/dvb-frontends/rtl2830.h
index e125166..f4349a1 100644
--- a/drivers/media/dvb-frontends/rtl2830.h
+++ b/drivers/media/dvb-frontends/rtl2830.h
@@ -47,13 +47,6 @@ struct rtl2830_config {
 	bool spec_inv;
 
 	/*
-	 * IFs for all used modes.
-	 * Hz
-	 * 4570000, 4571429, 36000000, 36125000, 36166667, 44000000
-	 */
-	u32 if_dvbt;
-
-	/*
 	 */
 	u8 vtop;
 
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 31c9f44..c3e2602 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -259,7 +259,6 @@ static struct rtl2830_config rtl28xxu_rtl2830_mt2060_config = {
 	.xtal = 28800000,
 	.ts_mode = 0,
 	.spec_inv = 1,
-	.if_dvbt = 36150000,
 	.vtop = 0x20,
 	.krf = 0x04,
 	.agc_targ_val = 0x2d,
@@ -271,7 +270,6 @@ static struct rtl2830_config rtl28xxu_rtl2830_qt1010_config = {
 	.xtal = 28800000,
 	.ts_mode = 0,
 	.spec_inv = 1,
-	.if_dvbt = 36125000,
 	.vtop = 0x20,
 	.krf = 0x04,
 	.agc_targ_val = 0x2d,
@@ -282,7 +280,6 @@ static struct rtl2830_config rtl28xxu_rtl2830_mxl5005s_config = {
 	.xtal = 28800000,
 	.ts_mode = 0,
 	.spec_inv = 0,
-	.if_dvbt = 4570000,
 	.vtop = 0x3f,
 	.krf = 0x04,
 	.agc_targ_val = 0x3e,
-- 
1.7.11.4

