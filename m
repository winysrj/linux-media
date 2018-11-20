Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58646 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbeKTUsd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 15:48:33 -0500
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Akihiro Tsukada <tskd08@gmail.com>, Michael Buesch <m@bues.ch>
Subject: [PATCH 3/3] media: dvb-pll: fix tuner frequency ranges
Date: Tue, 20 Nov 2018 08:19:36 -0200
Message-Id: <3ce0f6d4125bc6a3720c4954ad1540a26590ea11.1542709160.git.mchehab+samsung@kernel.org>
In-Reply-To: <dc0f3b757454e974eefe7795fbafc7b5cd0f5431.1542709160.git.mchehab+samsung@kernel.org>
References: <dc0f3b757454e974eefe7795fbafc7b5cd0f5431.1542709160.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tuners should report frequencies in Hz. That works fine on most
drivers, but, in the case of dvb-pll, some settings are for
satellite tuners, while others are for terrestrial/cable ones.

The code was trying to solve it at probing time, but that doesn't
work, as, when _attach is called, the delivery system may be wrong.

Fix it by ensuring that all frequencies are in Hz at the per-tuner
max/min values.

While here, add a debug message, as this would help to debug any
issues there.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/dvb-frontends/dvb-pll.c | 103 ++++++++++++--------------
 1 file changed, 48 insertions(+), 55 deletions(-)

diff --git a/drivers/media/dvb-frontends/dvb-pll.c b/drivers/media/dvb-frontends/dvb-pll.c
index 6d4b2eec67b4..fff5816f6ec4 100644
--- a/drivers/media/dvb-frontends/dvb-pll.c
+++ b/drivers/media/dvb-frontends/dvb-pll.c
@@ -80,8 +80,8 @@ struct dvb_pll_desc {
 
 static const struct dvb_pll_desc dvb_pll_thomson_dtt7579 = {
 	.name  = "Thomson dtt7579",
-	.min   = 177000000,
-	.max   = 858000000,
+	.min   = 177 * MHz,
+	.max   = 858 * MHz,
 	.iffreq= 36166667,
 	.sleepdata = (u8[]){ 2, 0xb4, 0x03 },
 	.count = 4,
@@ -102,8 +102,8 @@ static void thomson_dtt759x_bw(struct dvb_frontend *fe, u8 *buf)
 
 static const struct dvb_pll_desc dvb_pll_thomson_dtt759x = {
 	.name  = "Thomson dtt759x",
-	.min   = 177000000,
-	.max   = 896000000,
+	.min   = 177 * MHz,
+	.max   = 896 * MHz,
 	.set   = thomson_dtt759x_bw,
 	.iffreq= 36166667,
 	.sleepdata = (u8[]){ 2, 0x84, 0x03 },
@@ -126,8 +126,8 @@ static void thomson_dtt7520x_bw(struct dvb_frontend *fe, u8 *buf)
 
 static const struct dvb_pll_desc dvb_pll_thomson_dtt7520x = {
 	.name  = "Thomson dtt7520x",
-	.min   = 185000000,
-	.max   = 900000000,
+	.min   = 185 * MHz,
+	.max   = 900 * MHz,
 	.set   = thomson_dtt7520x_bw,
 	.iffreq = 36166667,
 	.count = 7,
@@ -144,8 +144,8 @@ static const struct dvb_pll_desc dvb_pll_thomson_dtt7520x = {
 
 static const struct dvb_pll_desc dvb_pll_lg_z201 = {
 	.name  = "LG z201",
-	.min   = 174000000,
-	.max   = 862000000,
+	.min   = 174 * MHz,
+	.max   = 862 * MHz,
 	.iffreq= 36166667,
 	.sleepdata = (u8[]){ 2, 0xbc, 0x03 },
 	.count = 5,
@@ -160,8 +160,8 @@ static const struct dvb_pll_desc dvb_pll_lg_z201 = {
 
 static const struct dvb_pll_desc dvb_pll_unknown_1 = {
 	.name  = "unknown 1", /* used by dntv live dvb-t */
-	.min   = 174000000,
-	.max   = 862000000,
+	.min   = 174 * MHz,
+	.max   = 862 * MHz,
 	.iffreq= 36166667,
 	.count = 9,
 	.entries = {
@@ -182,8 +182,8 @@ static const struct dvb_pll_desc dvb_pll_unknown_1 = {
  */
 static const struct dvb_pll_desc dvb_pll_tua6010xs = {
 	.name  = "Infineon TUA6010XS",
-	.min   =  44250000,
-	.max   = 858000000,
+	.min   = 44250 * kHz,
+	.max   = 858 * MHz,
 	.iffreq= 36125000,
 	.count = 3,
 	.entries = {
@@ -196,8 +196,8 @@ static const struct dvb_pll_desc dvb_pll_tua6010xs = {
 /* Panasonic env57h1xd5 (some Philips PLL ?) */
 static const struct dvb_pll_desc dvb_pll_env57h1xd5 = {
 	.name  = "Panasonic ENV57H1XD5",
-	.min   =  44250000,
-	.max   = 858000000,
+	.min   = 44250 * kHz,
+	.max   = 858 * MHz,
 	.iffreq= 36125000,
 	.count = 4,
 	.entries = {
@@ -220,8 +220,8 @@ static void tda665x_bw(struct dvb_frontend *fe, u8 *buf)
 
 static const struct dvb_pll_desc dvb_pll_tda665x = {
 	.name  = "Philips TDA6650/TDA6651",
-	.min   =  44250000,
-	.max   = 858000000,
+	.min   = 44250 * kHz,
+	.max   = 858 * MHz,
 	.set   = tda665x_bw,
 	.iffreq= 36166667,
 	.initdata = (u8[]){ 4, 0x0b, 0xf5, 0x85, 0xab },
@@ -254,8 +254,8 @@ static void tua6034_bw(struct dvb_frontend *fe, u8 *buf)
 
 static const struct dvb_pll_desc dvb_pll_tua6034 = {
 	.name  = "Infineon TUA6034",
-	.min   =  44250000,
-	.max   = 858000000,
+	.min   = 44250 * kHz,
+	.max   = 858 * MHz,
 	.iffreq= 36166667,
 	.count = 3,
 	.set   = tua6034_bw,
@@ -278,8 +278,8 @@ static void tded4_bw(struct dvb_frontend *fe, u8 *buf)
 
 static const struct dvb_pll_desc dvb_pll_tded4 = {
 	.name = "ALPS TDED4",
-	.min = 47000000,
-	.max = 863000000,
+	.min =  47 * MHz,
+	.max = 863 * MHz,
 	.iffreq= 36166667,
 	.set   = tded4_bw,
 	.count = 4,
@@ -296,8 +296,8 @@ static const struct dvb_pll_desc dvb_pll_tded4 = {
  */
 static const struct dvb_pll_desc dvb_pll_tdhu2 = {
 	.name = "ALPS TDHU2",
-	.min = 54000000,
-	.max = 864000000,
+	.min =  54 * MHz,
+	.max = 864 * MHz,
 	.iffreq= 44000000,
 	.count = 4,
 	.entries = {
@@ -313,8 +313,8 @@ static const struct dvb_pll_desc dvb_pll_tdhu2 = {
  */
 static const struct dvb_pll_desc dvb_pll_samsung_tbmv = {
 	.name = "Samsung TBMV30111IN / TBMV30712IN1",
-	.min = 54000000,
-	.max = 860000000,
+	.min =  54 * MHz,
+	.max = 860 * MHz,
 	.iffreq= 44000000,
 	.count = 6,
 	.entries = {
@@ -332,8 +332,8 @@ static const struct dvb_pll_desc dvb_pll_samsung_tbmv = {
  */
 static const struct dvb_pll_desc dvb_pll_philips_sd1878_tda8261 = {
 	.name  = "Philips SD1878",
-	.min   =  950000,
-	.max   = 2150000,
+	.min   =  950 * MHz,
+	.max   = 2150 * MHz,
 	.iffreq= 249, /* zero-IF, offset 249 is to round up */
 	.count = 4,
 	.entries = {
@@ -398,8 +398,8 @@ static void opera1_bw(struct dvb_frontend *fe, u8 *buf)
 
 static const struct dvb_pll_desc dvb_pll_opera1 = {
 	.name  = "Opera Tuner",
-	.min   =  900000,
-	.max   = 2250000,
+	.min   =  900 * MHz,
+	.max   = 2250 * MHz,
 	.initdata = (u8[]){ 4, 0x08, 0xe5, 0xe1, 0x00 },
 	.initdata2 = (u8[]){ 4, 0x08, 0xe5, 0xe5, 0x00 },
 	.iffreq= 0,
@@ -445,8 +445,8 @@ static void samsung_dtos403ih102a_set(struct dvb_frontend *fe, u8 *buf)
 /* unknown pll used in Samsung DTOS403IH102A DVB-C tuner */
 static const struct dvb_pll_desc dvb_pll_samsung_dtos403ih102a = {
 	.name   = "Samsung DTOS403IH102A",
-	.min    =  44250000,
-	.max    = 858000000,
+	.min    = 44250 * kHz,
+	.max    = 858 * MHz,
 	.iffreq =  36125000,
 	.count  = 8,
 	.set    = samsung_dtos403ih102a_set,
@@ -465,8 +465,8 @@ static const struct dvb_pll_desc dvb_pll_samsung_dtos403ih102a = {
 /* Samsung TDTC9251DH0 DVB-T NIM, as used on AirStar 2 */
 static const struct dvb_pll_desc dvb_pll_samsung_tdtc9251dh0 = {
 	.name	= "Samsung TDTC9251DH0",
-	.min	=  48000000,
-	.max	= 863000000,
+	.min	=  48 * MHz,
+	.max	= 863 * MHz,
 	.iffreq	=  36166667,
 	.count	= 3,
 	.entries = {
@@ -479,8 +479,8 @@ static const struct dvb_pll_desc dvb_pll_samsung_tdtc9251dh0 = {
 /* Samsung TBDU18132 DVB-S NIM with TSA5059 PLL, used in SkyStar2 DVB-S 2.3 */
 static const struct dvb_pll_desc dvb_pll_samsung_tbdu18132 = {
 	.name = "Samsung TBDU18132",
-	.min	=  950000,
-	.max	= 2150000, /* guesses */
+	.min	=  950 * MHz,
+	.max	= 2150 * MHz, /* guesses */
 	.iffreq = 0,
 	.count = 2,
 	.entries = {
@@ -500,8 +500,8 @@ static const struct dvb_pll_desc dvb_pll_samsung_tbdu18132 = {
 /* Samsung TBMU24112 DVB-S NIM with SL1935 zero-IF tuner */
 static const struct dvb_pll_desc dvb_pll_samsung_tbmu24112 = {
 	.name = "Samsung TBMU24112",
-	.min	=  950000,
-	.max	= 2150000, /* guesses */
+	.min	=  950 * MHz,
+	.max	= 2150 * MHz, /* guesses */
 	.iffreq = 0,
 	.count = 2,
 	.entries = {
@@ -521,8 +521,8 @@ static const struct dvb_pll_desc dvb_pll_samsung_tbmu24112 = {
  * 822 - 862   1  *  0   0   1   0   0   0   0x88 */
 static const struct dvb_pll_desc dvb_pll_alps_tdee4 = {
 	.name = "ALPS TDEE4",
-	.min	=  47000000,
-	.max	= 862000000,
+	.min	=  47 * MHz,
+	.max	= 862 * MHz,
 	.iffreq	=  36125000,
 	.count = 4,
 	.entries = {
@@ -537,8 +537,8 @@ static const struct dvb_pll_desc dvb_pll_alps_tdee4 = {
 /* CP cur. 50uA, AGC takeover: 103dBuV, PORT3 on */
 static const struct dvb_pll_desc dvb_pll_tua6034_friio = {
 	.name   = "Infineon TUA6034 ISDB-T (Friio)",
-	.min    =  90000000,
-	.max    = 770000000,
+	.min    =  90 * MHz,
+	.max    = 770 * MHz,
 	.iffreq =  57000000,
 	.initdata = (u8[]){ 4, 0x9a, 0x50, 0xb2, 0x08 },
 	.sleepdata = (u8[]){ 4, 0x9a, 0x70, 0xb3, 0x0b },
@@ -553,8 +553,8 @@ static const struct dvb_pll_desc dvb_pll_tua6034_friio = {
 /* Philips TDA6651 ISDB-T, used in Earthsoft PT1 */
 static const struct dvb_pll_desc dvb_pll_tda665x_earth_pt1 = {
 	.name   = "Philips TDA6651 ISDB-T (EarthSoft PT1)",
-	.min    =  90000000,
-	.max    = 770000000,
+	.min    =  90 * MHz,
+	.max    = 770 * MHz,
 	.iffreq =  57000000,
 	.initdata = (u8[]){ 5, 0x0e, 0x7f, 0xc1, 0x80, 0x80 },
 	.count = 10,
@@ -799,7 +799,6 @@ struct dvb_frontend *dvb_pll_attach(struct dvb_frontend *fe, int pll_addr,
 	struct dvb_pll_priv *priv = NULL;
 	int ret;
 	const struct dvb_pll_desc *desc;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
 	b1 = kmalloc(1, GFP_KERNEL);
 	if (!b1)
@@ -845,18 +844,12 @@ struct dvb_frontend *dvb_pll_attach(struct dvb_frontend *fe, int pll_addr,
 
 	strncpy(fe->ops.tuner_ops.info.name, desc->name,
 		sizeof(fe->ops.tuner_ops.info.name));
-	switch (c->delivery_system) {
-	case SYS_DVBS:
-	case SYS_DVBS2:
-	case SYS_TURBO:
-	case SYS_ISDBS:
-		fe->ops.tuner_ops.info.frequency_min_hz = desc->min * kHz;
-		fe->ops.tuner_ops.info.frequency_max_hz = desc->max * kHz;
-		break;
-	default:
-		fe->ops.tuner_ops.info.frequency_min_hz = desc->min;
-		fe->ops.tuner_ops.info.frequency_max_hz = desc->max;
-	}
+
+	fe->ops.tuner_ops.info.frequency_min_hz = desc->min;
+	fe->ops.tuner_ops.info.frequency_max_hz = desc->max;
+
+	dprintk("%s tuner, frequency range: %u...%u\n",
+		desc->name, desc->min, desc->max);
 
 	if (!desc->initdata)
 		fe->ops.tuner_ops.init = NULL;
-- 
2.19.1
