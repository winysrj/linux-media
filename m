Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34744 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752552AbdDITih (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Apr 2017 15:38:37 -0400
Received: by mail-wm0-f65.google.com with SMTP id x75so6393384wma.1
        for <linux-media@vger.kernel.org>; Sun, 09 Apr 2017 12:38:36 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: aospan@netup.ru, serjk@netup.ru, mchehab@kernel.org,
        linux-media@vger.kernel.org
Cc: rjkm@metzlerbros.de
Subject: [PATCH 05/19] [media] dvb-frontends/cxd2841er: replace IFFREQ calc macros into functions
Date: Sun,  9 Apr 2017 21:38:14 +0200
Message-Id: <20170409193828.18458-6-d.scheller.oss@gmail.com>
In-Reply-To: <20170409193828.18458-1-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

The way the MAKE_IFFREQ_CONFIG macros are written make it impossible to
pass regular integers for iffreq calculation, since this will cause "SSE
register return with SSE disabled" compile errors. This changes the
calculation into C functions which also might help when debugging. Also,
expand all passed frequencies from MHz to Hz scale.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/cxd2841er.c | 48 ++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 19 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 72a27cc..6648bd1 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -201,11 +201,6 @@ static const struct cxd2841er_cnr_data s2_cn_data[] = {
 	{ 0x0016, 19700 }, { 0x0015, 19900 }, { 0x0014, 20000 },
 };
 
-#define MAKE_IFFREQ_CONFIG(iffreq) ((u32)(((iffreq)/41.0)*16777216.0 + 0.5))
-#define MAKE_IFFREQ_CONFIG_XTAL(xtal, iffreq) ((xtal == SONY_XTAL_24000) ? \
-		(u32)(((iffreq)/48.0)*16777216.0 + 0.5) : \
-		(u32)(((iffreq)/41.0)*16777216.0 + 0.5))
-
 static int cxd2841er_freeze_regs(struct cxd2841er_priv *priv);
 static int cxd2841er_unfreeze_regs(struct cxd2841er_priv *priv);
 
@@ -316,6 +311,21 @@ static int cxd2841er_set_reg_bits(struct cxd2841er_priv *priv,
 	return cxd2841er_write_reg(priv, addr, reg, data);
 }
 
+static u32 cxd2841er_calc_iffreq_xtal(enum cxd2841er_xtal xtal, u32 ifhz)
+{
+	u64 tmp;
+
+	tmp = (u64) ifhz * 16777216;
+	do_div(tmp, ((xtal == SONY_XTAL_24000) ? 48000000 : 41000000));
+
+	return (u32) tmp;
+}
+
+static u32 cxd2841er_calc_iffreq(u32 ifhz)
+{
+	return cxd2841er_calc_iffreq_xtal(SONY_XTAL_20500, ifhz);
+}
+
 static int cxd2841er_dvbs2_set_symbol_rate(struct cxd2841er_priv *priv,
 					   u32 symbol_rate)
 {
@@ -2228,7 +2238,7 @@ static int cxd2841er_sleep_tc_to_active_t2_band(struct cxd2841er_priv *priv,
 		cxd2841er_write_regs(priv, I2C_SLVT,
 				0xA6, itbCoef8bw[priv->xtal], 14);
 		/* <IF freq setting> */
-		iffreq = MAKE_IFFREQ_CONFIG_XTAL(priv->xtal, 4.80);
+		iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, 4800000);
 		data[0] = (u8) ((iffreq >> 16) & 0xff);
 		data[1] = (u8)((iffreq >> 8) & 0xff);
 		data[2] = (u8)(iffreq & 0xff);
@@ -2256,7 +2266,7 @@ static int cxd2841er_sleep_tc_to_active_t2_band(struct cxd2841er_priv *priv,
 		cxd2841er_write_regs(priv, I2C_SLVT,
 				0xA6, itbCoef7bw[priv->xtal], 14);
 		/* <IF freq setting> */
-		iffreq = MAKE_IFFREQ_CONFIG_XTAL(priv->xtal, 4.20);
+		iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, 4200000);
 		data[0] = (u8) ((iffreq >> 16) & 0xff);
 		data[1] = (u8)((iffreq >> 8) & 0xff);
 		data[2] = (u8)(iffreq & 0xff);
@@ -2284,7 +2294,7 @@ static int cxd2841er_sleep_tc_to_active_t2_band(struct cxd2841er_priv *priv,
 		cxd2841er_write_regs(priv, I2C_SLVT,
 				0xA6, itbCoef6bw[priv->xtal], 14);
 		/* <IF freq setting> */
-		iffreq = MAKE_IFFREQ_CONFIG_XTAL(priv->xtal, 3.60);
+		iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, 3600000);
 		data[0] = (u8) ((iffreq >> 16) & 0xff);
 		data[1] = (u8)((iffreq >> 8) & 0xff);
 		data[2] = (u8)(iffreq & 0xff);
@@ -2312,7 +2322,7 @@ static int cxd2841er_sleep_tc_to_active_t2_band(struct cxd2841er_priv *priv,
 		cxd2841er_write_regs(priv, I2C_SLVT,
 				0xA6, itbCoef5bw[priv->xtal], 14);
 		/* <IF freq setting> */
-		iffreq = MAKE_IFFREQ_CONFIG_XTAL(priv->xtal, 3.60);
+		iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, 3600000);
 		data[0] = (u8) ((iffreq >> 16) & 0xff);
 		data[1] = (u8)((iffreq >> 8) & 0xff);
 		data[2] = (u8)(iffreq & 0xff);
@@ -2340,7 +2350,7 @@ static int cxd2841er_sleep_tc_to_active_t2_band(struct cxd2841er_priv *priv,
 		cxd2841er_write_regs(priv, I2C_SLVT,
 				0xA6, itbCoef17bw[priv->xtal], 14);
 		/* <IF freq setting> */
-		iffreq = MAKE_IFFREQ_CONFIG_XTAL(priv->xtal, 3.50);
+		iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, 3500000);
 		data[0] = (u8) ((iffreq >> 16) & 0xff);
 		data[1] = (u8)((iffreq >> 8) & 0xff);
 		data[2] = (u8)(iffreq & 0xff);
@@ -2439,7 +2449,7 @@ static int cxd2841er_sleep_tc_to_active_t_band(
 		cxd2841er_write_regs(priv, I2C_SLVT,
 				0xA6, itbCoef8bw[priv->xtal], 14);
 		/* <IF freq setting> */
-		iffreq = MAKE_IFFREQ_CONFIG_XTAL(priv->xtal, 4.80);
+		iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, 4800000);
 		data[0] = (u8) ((iffreq >> 16) & 0xff);
 		data[1] = (u8)((iffreq >> 8) & 0xff);
 		data[2] = (u8)(iffreq & 0xff);
@@ -2474,7 +2484,7 @@ static int cxd2841er_sleep_tc_to_active_t_band(
 		cxd2841er_write_regs(priv, I2C_SLVT,
 				0xA6, itbCoef7bw[priv->xtal], 14);
 		/* <IF freq setting> */
-		iffreq = MAKE_IFFREQ_CONFIG_XTAL(priv->xtal, 4.20);
+		iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, 4200000);
 		data[0] = (u8) ((iffreq >> 16) & 0xff);
 		data[1] = (u8)((iffreq >> 8) & 0xff);
 		data[2] = (u8)(iffreq & 0xff);
@@ -2509,7 +2519,7 @@ static int cxd2841er_sleep_tc_to_active_t_band(
 		cxd2841er_write_regs(priv, I2C_SLVT,
 				0xA6, itbCoef6bw[priv->xtal], 14);
 		/* <IF freq setting> */
-		iffreq = MAKE_IFFREQ_CONFIG_XTAL(priv->xtal, 3.60);
+		iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, 3600000);
 		data[0] = (u8) ((iffreq >> 16) & 0xff);
 		data[1] = (u8)((iffreq >> 8) & 0xff);
 		data[2] = (u8)(iffreq & 0xff);
@@ -2544,7 +2554,7 @@ static int cxd2841er_sleep_tc_to_active_t_band(
 		cxd2841er_write_regs(priv, I2C_SLVT,
 				0xA6, itbCoef5bw[priv->xtal], 14);
 		/* <IF freq setting> */
-		iffreq = MAKE_IFFREQ_CONFIG_XTAL(priv->xtal, 3.60);
+		iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, 3600000);
 		data[0] = (u8) ((iffreq >> 16) & 0xff);
 		data[1] = (u8)((iffreq >> 8) & 0xff);
 		data[2] = (u8)(iffreq & 0xff);
@@ -2646,7 +2656,7 @@ static int cxd2841er_sleep_tc_to_active_i_band(
 				0xA6, itbCoef8bw[priv->xtal], 14);
 
 		/* IF freq setting */
-		iffreq = MAKE_IFFREQ_CONFIG_XTAL(priv->xtal, 4.75);
+		iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, 4750000);
 		data[0] = (u8) ((iffreq >> 16) & 0xff);
 		data[1] = (u8)((iffreq >> 8) & 0xff);
 		data[2] = (u8)(iffreq & 0xff);
@@ -2675,7 +2685,7 @@ static int cxd2841er_sleep_tc_to_active_i_band(
 				0xA6, itbCoef7bw[priv->xtal], 14);
 
 		/* IF freq setting */
-		iffreq = MAKE_IFFREQ_CONFIG_XTAL(priv->xtal, 4.15);
+		iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, 4150000);
 		data[0] = (u8) ((iffreq >> 16) & 0xff);
 		data[1] = (u8)((iffreq >> 8) & 0xff);
 		data[2] = (u8)(iffreq & 0xff);
@@ -2704,7 +2714,7 @@ static int cxd2841er_sleep_tc_to_active_i_band(
 				0xA6, itbCoef6bw[priv->xtal], 14);
 
 		/* IF freq setting */
-		iffreq = MAKE_IFFREQ_CONFIG_XTAL(priv->xtal, 3.55);
+		iffreq = cxd2841er_calc_iffreq_xtal(priv->xtal, 3550000);
 		data[0] = (u8) ((iffreq >> 16) & 0xff);
 		data[1] = (u8)((iffreq >> 8) & 0xff);
 		data[2] = (u8)(iffreq & 0xff);
@@ -2765,13 +2775,13 @@ static int cxd2841er_sleep_tc_to_active_c_band(struct cxd2841er_priv *priv,
 		cxd2841er_write_regs(
 			priv, I2C_SLVT, 0xa6,
 			bw7_8mhz_b10_a6, sizeof(bw7_8mhz_b10_a6));
-		iffreq = MAKE_IFFREQ_CONFIG(4.9);
+		iffreq = cxd2841er_calc_iffreq(4900000);
 		break;
 	case 6000000:
 		cxd2841er_write_regs(
 			priv, I2C_SLVT, 0xa6,
 			bw6mhz_b10_a6, sizeof(bw6mhz_b10_a6));
-		iffreq = MAKE_IFFREQ_CONFIG(3.7);
+		iffreq = cxd2841er_calc_iffreq(3700000);
 		break;
 	default:
 		dev_err(&priv->i2c->dev, "%s(): unsupported bandwidth %d\n",
-- 
2.10.2
