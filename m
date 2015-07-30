Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:34798 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897AbbG3RJN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2015 13:09:13 -0400
Received: by wibud3 with SMTP id ud3so29102497wib.1
        for <linux-media@vger.kernel.org>; Thu, 30 Jul 2015 10:09:11 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com,
	m.krufky@samsung.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org,
	hugues.fruchet@st.com, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, joe@perches.com
Subject: [PATCH v2 03/11] dvb-pll: Convert struct dvb_pll_desc uses to const.
Date: Thu, 30 Jul 2015 18:08:53 +0100
Message-Id: <1438276141-16902-4-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1438276141-16902-1-git-send-email-peter.griffin@linaro.org>
References: <1438276141-16902-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Joe Perches <joe@perches.com>

Convert the struct dvb_pll_desc uses to const and
change the "entries" fixed array size from 12 to []

It saves a couple KB overall and remove ~5KB of data.

$ size drivers/media/dvb-frontends/dvb-pll.o*
   text        data     bss     dec     hex filename
   8520        1552    2120   12192    2fa0 drivers/media/dvb-frontends/dvb-pll.o.new
   5624        6363    2120   14107    371b drivers/media/dvb-frontends/dvb-pll.o.old

[PG] Patch taken from https://lkml.org/lkml/2015/6/24/721 with
commit message updated.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Reviewed-by: Michael Ira Krufky <m.krufky@samsung.com>
---
 drivers/media/dvb-frontends/dvb-pll.c | 50 +++++++++++++++++------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/media/dvb-frontends/dvb-pll.c b/drivers/media/dvb-frontends/dvb-pll.c
index 6d8fe88..53089e1 100644
--- a/drivers/media/dvb-frontends/dvb-pll.c
+++ b/drivers/media/dvb-frontends/dvb-pll.c
@@ -34,7 +34,7 @@ struct dvb_pll_priv {
 	struct i2c_adapter *i2c;
 
 	/* the PLL descriptor */
-	struct dvb_pll_desc *pll_desc;
+	const struct dvb_pll_desc *pll_desc;
 
 	/* cached frequency/bandwidth */
 	u32 frequency;
@@ -57,7 +57,7 @@ MODULE_PARM_DESC(id, "force pll id to use (DEBUG ONLY)");
 /* ----------------------------------------------------------- */
 
 struct dvb_pll_desc {
-	char *name;
+	const char *name;
 	u32  min;
 	u32  max;
 	u32  iffreq;
@@ -71,13 +71,13 @@ struct dvb_pll_desc {
 		u32 stepsize;
 		u8  config;
 		u8  cb;
-	} entries[12];
+	} entries[];
 };
 
 /* ----------------------------------------------------------- */
 /* descriptions                                                */
 
-static struct dvb_pll_desc dvb_pll_thomson_dtt7579 = {
+static const struct dvb_pll_desc dvb_pll_thomson_dtt7579 = {
 	.name  = "Thomson dtt7579",
 	.min   = 177000000,
 	.max   = 858000000,
@@ -99,7 +99,7 @@ static void thomson_dtt759x_bw(struct dvb_frontend *fe, u8 *buf)
 		buf[3] |= 0x10;
 }
 
-static struct dvb_pll_desc dvb_pll_thomson_dtt759x = {
+static const struct dvb_pll_desc dvb_pll_thomson_dtt759x = {
 	.name  = "Thomson dtt759x",
 	.min   = 177000000,
 	.max   = 896000000,
@@ -123,7 +123,7 @@ static void thomson_dtt7520x_bw(struct dvb_frontend *fe, u8 *buf)
 		buf[3] ^= 0x10;
 }
 
-static struct dvb_pll_desc dvb_pll_thomson_dtt7520x = {
+static const struct dvb_pll_desc dvb_pll_thomson_dtt7520x = {
 	.name  = "Thomson dtt7520x",
 	.min   = 185000000,
 	.max   = 900000000,
@@ -141,7 +141,7 @@ static struct dvb_pll_desc dvb_pll_thomson_dtt7520x = {
 	},
 };
 
-static struct dvb_pll_desc dvb_pll_lg_z201 = {
+static const struct dvb_pll_desc dvb_pll_lg_z201 = {
 	.name  = "LG z201",
 	.min   = 174000000,
 	.max   = 862000000,
@@ -157,7 +157,7 @@ static struct dvb_pll_desc dvb_pll_lg_z201 = {
 	},
 };
 
-static struct dvb_pll_desc dvb_pll_unknown_1 = {
+static const struct dvb_pll_desc dvb_pll_unknown_1 = {
 	.name  = "unknown 1", /* used by dntv live dvb-t */
 	.min   = 174000000,
 	.max   = 862000000,
@@ -179,7 +179,7 @@ static struct dvb_pll_desc dvb_pll_unknown_1 = {
 /* Infineon TUA6010XS
  * used in Thomson Cable Tuner
  */
-static struct dvb_pll_desc dvb_pll_tua6010xs = {
+static const struct dvb_pll_desc dvb_pll_tua6010xs = {
 	.name  = "Infineon TUA6010XS",
 	.min   =  44250000,
 	.max   = 858000000,
@@ -193,7 +193,7 @@ static struct dvb_pll_desc dvb_pll_tua6010xs = {
 };
 
 /* Panasonic env57h1xd5 (some Philips PLL ?) */
-static struct dvb_pll_desc dvb_pll_env57h1xd5 = {
+static const struct dvb_pll_desc dvb_pll_env57h1xd5 = {
 	.name  = "Panasonic ENV57H1XD5",
 	.min   =  44250000,
 	.max   = 858000000,
@@ -217,7 +217,7 @@ static void tda665x_bw(struct dvb_frontend *fe, u8 *buf)
 		buf[3] |= 0x08;
 }
 
-static struct dvb_pll_desc dvb_pll_tda665x = {
+static const struct dvb_pll_desc dvb_pll_tda665x = {
 	.name  = "Philips TDA6650/TDA6651",
 	.min   =  44250000,
 	.max   = 858000000,
@@ -251,7 +251,7 @@ static void tua6034_bw(struct dvb_frontend *fe, u8 *buf)
 		buf[3] |= 0x08;
 }
 
-static struct dvb_pll_desc dvb_pll_tua6034 = {
+static const struct dvb_pll_desc dvb_pll_tua6034 = {
 	.name  = "Infineon TUA6034",
 	.min   =  44250000,
 	.max   = 858000000,
@@ -275,7 +275,7 @@ static void tded4_bw(struct dvb_frontend *fe, u8 *buf)
 		buf[3] |= 0x04;
 }
 
-static struct dvb_pll_desc dvb_pll_tded4 = {
+static const struct dvb_pll_desc dvb_pll_tded4 = {
 	.name = "ALPS TDED4",
 	.min = 47000000,
 	.max = 863000000,
@@ -293,7 +293,7 @@ static struct dvb_pll_desc dvb_pll_tded4 = {
 /* ALPS TDHU2
  * used in AverTVHD MCE A180
  */
-static struct dvb_pll_desc dvb_pll_tdhu2 = {
+static const struct dvb_pll_desc dvb_pll_tdhu2 = {
 	.name = "ALPS TDHU2",
 	.min = 54000000,
 	.max = 864000000,
@@ -310,7 +310,7 @@ static struct dvb_pll_desc dvb_pll_tdhu2 = {
 /* Samsung TBMV30111IN / TBMV30712IN1
  * used in Air2PC ATSC - 2nd generation (nxt2002)
  */
-static struct dvb_pll_desc dvb_pll_samsung_tbmv = {
+static const struct dvb_pll_desc dvb_pll_samsung_tbmv = {
 	.name = "Samsung TBMV30111IN / TBMV30712IN1",
 	.min = 54000000,
 	.max = 860000000,
@@ -329,7 +329,7 @@ static struct dvb_pll_desc dvb_pll_samsung_tbmv = {
 /*
  * Philips SD1878 Tuner.
  */
-static struct dvb_pll_desc dvb_pll_philips_sd1878_tda8261 = {
+static const struct dvb_pll_desc dvb_pll_philips_sd1878_tda8261 = {
 	.name  = "Philips SD1878",
 	.min   =  950000,
 	.max   = 2150000,
@@ -395,7 +395,7 @@ static void opera1_bw(struct dvb_frontend *fe, u8 *buf)
 	return;
 }
 
-static struct dvb_pll_desc dvb_pll_opera1 = {
+static const struct dvb_pll_desc dvb_pll_opera1 = {
 	.name  = "Opera Tuner",
 	.min   =  900000,
 	.max   = 2250000,
@@ -442,7 +442,7 @@ static void samsung_dtos403ih102a_set(struct dvb_frontend *fe, u8 *buf)
 }
 
 /* unknown pll used in Samsung DTOS403IH102A DVB-C tuner */
-static struct dvb_pll_desc dvb_pll_samsung_dtos403ih102a = {
+static const struct dvb_pll_desc dvb_pll_samsung_dtos403ih102a = {
 	.name   = "Samsung DTOS403IH102A",
 	.min    =  44250000,
 	.max    = 858000000,
@@ -462,7 +462,7 @@ static struct dvb_pll_desc dvb_pll_samsung_dtos403ih102a = {
 };
 
 /* Samsung TDTC9251DH0 DVB-T NIM, as used on AirStar 2 */
-static struct dvb_pll_desc dvb_pll_samsung_tdtc9251dh0 = {
+static const struct dvb_pll_desc dvb_pll_samsung_tdtc9251dh0 = {
 	.name	= "Samsung TDTC9251DH0",
 	.min	=  48000000,
 	.max	= 863000000,
@@ -476,7 +476,7 @@ static struct dvb_pll_desc dvb_pll_samsung_tdtc9251dh0 = {
 };
 
 /* Samsung TBDU18132 DVB-S NIM with TSA5059 PLL, used in SkyStar2 DVB-S 2.3 */
-static struct dvb_pll_desc dvb_pll_samsung_tbdu18132 = {
+static const struct dvb_pll_desc dvb_pll_samsung_tbdu18132 = {
 	.name = "Samsung TBDU18132",
 	.min	=  950000,
 	.max	= 2150000, /* guesses */
@@ -497,7 +497,7 @@ static struct dvb_pll_desc dvb_pll_samsung_tbdu18132 = {
 };
 
 /* Samsung TBMU24112 DVB-S NIM with SL1935 zero-IF tuner */
-static struct dvb_pll_desc dvb_pll_samsung_tbmu24112 = {
+static const struct dvb_pll_desc dvb_pll_samsung_tbmu24112 = {
 	.name = "Samsung TBMU24112",
 	.min	=  950000,
 	.max	= 2150000, /* guesses */
@@ -518,7 +518,7 @@ static struct dvb_pll_desc dvb_pll_samsung_tbmu24112 = {
  * 153 - 430   0  *  0   0   0   0   1   0   0x02
  * 430 - 822   0  *  0   0   1   0   0   0   0x08
  * 822 - 862   1  *  0   0   1   0   0   0   0x88 */
-static struct dvb_pll_desc dvb_pll_alps_tdee4 = {
+static const struct dvb_pll_desc dvb_pll_alps_tdee4 = {
 	.name = "ALPS TDEE4",
 	.min	=  47000000,
 	.max	= 862000000,
@@ -534,7 +534,7 @@ static struct dvb_pll_desc dvb_pll_alps_tdee4 = {
 
 /* ----------------------------------------------------------- */
 
-static struct dvb_pll_desc *pll_list[] = {
+static const struct dvb_pll_desc *pll_list[] = {
 	[DVB_PLL_UNDEFINED]              = NULL,
 	[DVB_PLL_THOMSON_DTT7579]        = &dvb_pll_thomson_dtt7579,
 	[DVB_PLL_THOMSON_DTT759X]        = &dvb_pll_thomson_dtt759x,
@@ -564,7 +564,7 @@ static int dvb_pll_configure(struct dvb_frontend *fe, u8 *buf,
 			     const u32 frequency)
 {
 	struct dvb_pll_priv *priv = fe->tuner_priv;
-	struct dvb_pll_desc *desc = priv->pll_desc;
+	const struct dvb_pll_desc *desc = priv->pll_desc;
 	u32 div;
 	int i;
 
@@ -758,7 +758,7 @@ struct dvb_frontend *dvb_pll_attach(struct dvb_frontend *fe, int pll_addr,
 			       .buf = b1, .len = 1 };
 	struct dvb_pll_priv *priv = NULL;
 	int ret;
-	struct dvb_pll_desc *desc;
+	const struct dvb_pll_desc *desc;
 
 	if ((id[dvb_pll_devcount] > DVB_PLL_UNDEFINED) &&
 	    (id[dvb_pll_devcount] < ARRAY_SIZE(pll_list)))
-- 
1.9.1

