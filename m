Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35886 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752427AbdDITis (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Apr 2017 15:38:48 -0400
Received: by mail-wm0-f66.google.com with SMTP id q125so6399736wmd.3
        for <linux-media@vger.kernel.org>; Sun, 09 Apr 2017 12:38:47 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: aospan@netup.ru, serjk@netup.ru, mchehab@kernel.org,
        linux-media@vger.kernel.org
Cc: rjkm@metzlerbros.de
Subject: [PATCH 10/19] [media] dvb-frontends/cxd2841er: make ASCOT use optional
Date: Sun,  9 Apr 2017 21:38:19 +0200
Message-Id: <20170409193828.18458-11-d.scheller.oss@gmail.com>
In-Reply-To: <20170409193828.18458-1-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

The Sony CXD28xx demods may have other tuner types attached to them (e.g.
NXP TDA18212), so don't mandatorily configure and enable the ASCOT
functionality, but make this conditional by a config flag.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/cxd2841er.c            | 70 ++++++++++++++--------
 drivers/media/dvb-frontends/cxd2841er.h            |  1 +
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |  2 +-
 3 files changed, 46 insertions(+), 27 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 1df95c4..7ca589a 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -2277,7 +2277,8 @@ static int cxd2841er_sleep_tc_to_active_t2_band(struct cxd2841er_priv *priv,
 		/* Group delay equaliser settings for
 		 * ASCOT2D, ASCOT2E and ASCOT3 tuners
 		 */
-		cxd2841er_write_regs(priv, I2C_SLVT,
+		if (priv->flags & CXD2841ER_ASCOT)
+			cxd2841er_write_regs(priv, I2C_SLVT,
 				0xA6, itbCoef8bw[priv->xtal], 14);
 		/* <IF freq setting> */
 		ifhz = cxd2841er_get_if_hz(priv, 4800000);
@@ -2306,7 +2307,8 @@ static int cxd2841er_sleep_tc_to_active_t2_band(struct cxd2841er_priv *priv,
 		/* Group delay equaliser settings for
 		 * ASCOT2D, ASCOT2E and ASCOT3 tuners
 		 */
-		cxd2841er_write_regs(priv, I2C_SLVT,
+		if (priv->flags & CXD2841ER_ASCOT)
+			cxd2841er_write_regs(priv, I2C_SLVT,
 				0xA6, itbCoef7bw[priv->xtal], 14);
 		/* <IF freq setting> */
 		ifhz = cxd2841er_get_if_hz(priv, 4200000);
@@ -2335,7 +2337,8 @@ static int cxd2841er_sleep_tc_to_active_t2_band(struct cxd2841er_priv *priv,
 		/* Group delay equaliser settings for
 		 * ASCOT2D, ASCOT2E and ASCOT3 tuners
 		 */
-		cxd2841er_write_regs(priv, I2C_SLVT,
+		if (priv->flags & CXD2841ER_ASCOT)
+			cxd2841er_write_regs(priv, I2C_SLVT,
 				0xA6, itbCoef6bw[priv->xtal], 14);
 		/* <IF freq setting> */
 		ifhz = cxd2841er_get_if_hz(priv, 3600000);
@@ -2364,7 +2367,8 @@ static int cxd2841er_sleep_tc_to_active_t2_band(struct cxd2841er_priv *priv,
 		/* Group delay equaliser settings for
 		 * ASCOT2D, ASCOT2E and ASCOT3 tuners
 		 */
-		cxd2841er_write_regs(priv, I2C_SLVT,
+		if (priv->flags & CXD2841ER_ASCOT)
+			cxd2841er_write_regs(priv, I2C_SLVT,
 				0xA6, itbCoef5bw[priv->xtal], 14);
 		/* <IF freq setting> */
 		ifhz = cxd2841er_get_if_hz(priv, 3600000);
@@ -2393,7 +2397,8 @@ static int cxd2841er_sleep_tc_to_active_t2_band(struct cxd2841er_priv *priv,
 		/* Group delay equaliser settings for
 		 * ASCOT2D, ASCOT2E and ASCOT3 tuners
 		 */
-		cxd2841er_write_regs(priv, I2C_SLVT,
+		if (priv->flags & CXD2841ER_ASCOT)
+			cxd2841er_write_regs(priv, I2C_SLVT,
 				0xA6, itbCoef17bw[priv->xtal], 14);
 		/* <IF freq setting> */
 		ifhz = cxd2841er_get_if_hz(priv, 3500000);
@@ -2493,7 +2498,8 @@ static int cxd2841er_sleep_tc_to_active_t_band(
 		/* Group delay equaliser settings for
 		 * ASCOT2D, ASCOT2E and ASCOT3 tuners
 		*/
-		cxd2841er_write_regs(priv, I2C_SLVT,
+		if (priv->flags & CXD2841ER_ASCOT)
+			cxd2841er_write_regs(priv, I2C_SLVT,
 				0xA6, itbCoef8bw[priv->xtal], 14);
 		/* <IF freq setting> */
 		ifhz = cxd2841er_get_if_hz(priv, 4800000);
@@ -2529,7 +2535,8 @@ static int cxd2841er_sleep_tc_to_active_t_band(
 		/* Group delay equaliser settings for
 		 * ASCOT2D, ASCOT2E and ASCOT3 tuners
 		*/
-		cxd2841er_write_regs(priv, I2C_SLVT,
+		if (priv->flags & CXD2841ER_ASCOT)
+			cxd2841er_write_regs(priv, I2C_SLVT,
 				0xA6, itbCoef7bw[priv->xtal], 14);
 		/* <IF freq setting> */
 		ifhz = cxd2841er_get_if_hz(priv, 4200000);
@@ -2565,7 +2572,8 @@ static int cxd2841er_sleep_tc_to_active_t_band(
 		/* Group delay equaliser settings for
 		 * ASCOT2D, ASCOT2E and ASCOT3 tuners
 		*/
-		cxd2841er_write_regs(priv, I2C_SLVT,
+		if (priv->flags & CXD2841ER_ASCOT)
+			cxd2841er_write_regs(priv, I2C_SLVT,
 				0xA6, itbCoef6bw[priv->xtal], 14);
 		/* <IF freq setting> */
 		ifhz = cxd2841er_get_if_hz(priv, 3600000);
@@ -2601,7 +2609,8 @@ static int cxd2841er_sleep_tc_to_active_t_band(
 		/* Group delay equaliser settings for
 		 * ASCOT2D, ASCOT2E and ASCOT3 tuners
 		*/
-		cxd2841er_write_regs(priv, I2C_SLVT,
+		if (priv->flags & CXD2841ER_ASCOT)
+			cxd2841er_write_regs(priv, I2C_SLVT,
 				0xA6, itbCoef5bw[priv->xtal], 14);
 		/* <IF freq setting> */
 		ifhz = cxd2841er_get_if_hz(priv, 3600000);
@@ -2703,7 +2712,8 @@ static int cxd2841er_sleep_tc_to_active_i_band(
 		cxd2841er_write_regs(priv, I2C_SLVT,
 				0x9F, nominalRate8bw[priv->xtal], 5);
 		/*  Group delay equaliser settings for ASCOT tuners optimized */
-		cxd2841er_write_regs(priv, I2C_SLVT,
+		if (priv->flags & CXD2841ER_ASCOT)
+			cxd2841er_write_regs(priv, I2C_SLVT,
 				0xA6, itbCoef8bw[priv->xtal], 14);
 
 		/* IF freq setting */
@@ -2733,7 +2743,8 @@ static int cxd2841er_sleep_tc_to_active_i_band(
 		cxd2841er_write_regs(priv, I2C_SLVT,
 				0x9F, nominalRate7bw[priv->xtal], 5);
 		/*  Group delay equaliser settings for ASCOT tuners optimized */
-		cxd2841er_write_regs(priv, I2C_SLVT,
+		if (priv->flags & CXD2841ER_ASCOT)
+			cxd2841er_write_regs(priv, I2C_SLVT,
 				0xA6, itbCoef7bw[priv->xtal], 14);
 
 		/* IF freq setting */
@@ -2763,7 +2774,8 @@ static int cxd2841er_sleep_tc_to_active_i_band(
 		cxd2841er_write_regs(priv, I2C_SLVT,
 				0x9F, nominalRate6bw[priv->xtal], 5);
 		/*  Group delay equaliser settings for ASCOT tuners optimized */
-		cxd2841er_write_regs(priv, I2C_SLVT,
+		if (priv->flags & CXD2841ER_ASCOT)
+			cxd2841er_write_regs(priv, I2C_SLVT,
 				0xA6, itbCoef6bw[priv->xtal], 14);
 
 		/* IF freq setting */
@@ -2826,16 +2838,18 @@ static int cxd2841er_sleep_tc_to_active_c_band(struct cxd2841er_priv *priv,
 	switch (bandwidth) {
 	case 8000000:
 	case 7000000:
-		cxd2841er_write_regs(
-			priv, I2C_SLVT, 0xa6,
-			bw7_8mhz_b10_a6, sizeof(bw7_8mhz_b10_a6));
+		if (priv->flags & CXD2841ER_ASCOT)
+			cxd2841er_write_regs(
+				priv, I2C_SLVT, 0xa6,
+				bw7_8mhz_b10_a6, sizeof(bw7_8mhz_b10_a6));
 		ifhz = cxd2841er_get_if_hz(priv, 4900000);
 		iffreq = cxd2841er_calc_iffreq(ifhz);
 		break;
 	case 6000000:
-		cxd2841er_write_regs(
-			priv, I2C_SLVT, 0xa6,
-			bw6mhz_b10_a6, sizeof(bw6mhz_b10_a6));
+		if (priv->flags & CXD2841ER_ASCOT)
+			cxd2841er_write_regs(
+				priv, I2C_SLVT, 0xa6,
+				bw6mhz_b10_a6, sizeof(bw6mhz_b10_a6));
 		ifhz = cxd2841er_get_if_hz(priv, 3700000);
 		iffreq = cxd2841er_calc_iffreq(ifhz);
 		break;
@@ -2924,8 +2938,9 @@ static int cxd2841er_sleep_tc_to_active_t(struct cxd2841er_priv *priv,
 	cxd2841er_write_reg(priv, I2C_SLVT, 0x6a, 0x50);
 	/* Set SLV-T Bank : 0x10 */
 	cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0x10);
-	/* ASCOT setting ON */
-	cxd2841er_set_reg_bits(priv, I2C_SLVT, 0xa5, 0x01, 0x01);
+	/* ASCOT setting */
+	cxd2841er_set_reg_bits(priv, I2C_SLVT, 0xa5,
+		((priv->flags & CXD2841ER_ASCOT) ? 0x01 : 0x00), 0x01);
 	/* Set SLV-T Bank : 0x18 */
 	cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0x18);
 	/* Pre-RS BER moniter setting */
@@ -3002,8 +3017,9 @@ static int cxd2841er_sleep_tc_to_active_t2(struct cxd2841er_priv *priv,
 	cxd2841er_write_reg(priv, I2C_SLVT, 0x6a, 0x50);
 	/* Set SLV-T Bank : 0x10 */
 	cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0x10);
-	/* ASCOT setting ON */
-	cxd2841er_set_reg_bits(priv, I2C_SLVT, 0xa5, 0x01, 0x01);
+	/* ASCOT setting */
+	cxd2841er_set_reg_bits(priv, I2C_SLVT, 0xa5,
+		((priv->flags & CXD2841ER_ASCOT) ? 0x01 : 0x00), 0x01);
 	/* Set SLV-T Bank : 0x20 */
 	cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0x20);
 	/* Acquisition optimization setting */
@@ -3140,8 +3156,9 @@ static int cxd2841er_sleep_tc_to_active_i(struct cxd2841er_priv *priv,
 	cxd2841er_write_regs(priv, I2C_SLVT, 0x43, data, 2);
 	/* Enable ADC 4 */
 	cxd2841er_write_reg(priv, I2C_SLVX, 0x18, 0x00);
-	/* ASCOT setting ON */
-	cxd2841er_set_reg_bits(priv, I2C_SLVT, 0xa5, 0x01, 0x01);
+	/* ASCOT setting */
+	cxd2841er_set_reg_bits(priv, I2C_SLVT, 0xa5,
+		((priv->flags & CXD2841ER_ASCOT) ? 0x01 : 0x00), 0x01);
 	/* FEC Auto Recovery setting */
 	cxd2841er_set_reg_bits(priv, I2C_SLVT, 0x30, 0x01, 0x01);
 	cxd2841er_set_reg_bits(priv, I2C_SLVT, 0x31, 0x00, 0x01);
@@ -3225,8 +3242,9 @@ static int cxd2841er_sleep_tc_to_active_c(struct cxd2841er_priv *priv,
 	cxd2841er_write_reg(priv, I2C_SLVT, 0x6a, 0x48);
 	/* Set SLV-T Bank : 0x10 */
 	cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0x10);
-	/* ASCOT setting ON */
-	cxd2841er_set_reg_bits(priv, I2C_SLVT, 0xa5, 0x01, 0x01);
+	/* ASCOT setting */
+	cxd2841er_set_reg_bits(priv, I2C_SLVT, 0xa5,
+		((priv->flags & CXD2841ER_ASCOT) ? 0x01 : 0x00), 0x01);
 	/* Set SLV-T Bank : 0x40 */
 	cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0x40);
 	/* Demod setting */
diff --git a/drivers/media/dvb-frontends/cxd2841er.h b/drivers/media/dvb-frontends/cxd2841er.h
index 58fbd98..90ced97 100644
--- a/drivers/media/dvb-frontends/cxd2841er.h
+++ b/drivers/media/dvb-frontends/cxd2841er.h
@@ -27,6 +27,7 @@
 #define CXD2841ER_USE_GATECTRL	1	/* bit 0 */
 #define CXD2841ER_AUTO_IFHZ	2	/* bit 1 */
 #define CXD2841ER_TS_SERIAL	4	/* bit 2 */
+#define CXD2841ER_ASCOT		8	/* bit 3 */
 
 enum cxd2841er_xtal {
 	SONY_XTAL_20500, /* 20.5 MHz */
diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
index 5e6553f..8b389b3 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
@@ -123,7 +123,7 @@ static void netup_unidvb_queue_cleanup(struct netup_dma *dma);
 static struct cxd2841er_config demod_config = {
 	.i2c_addr = 0xc8,
 	.xtal = SONY_XTAL_24000,
-	.flags = CXD2841ER_USE_GATECTRL
+	.flags = CXD2841ER_USE_GATECTRL | CXD2841ER_ASCOT
 };
 
 static struct horus3a_config horus3a_conf = {
-- 
2.10.2
