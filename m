Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35983 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752444AbcKRW7v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 17:59:51 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Michael Buesch <m@bues.ch>, Antti Palosaari <crope@iki.fi>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>
Subject: [PATCH] Revert "[media] dvb_frontend: merge duplicate dvb_tuner_ops.release implementations"
Date: Fri, 18 Nov 2016 20:59:27 -0200
Message-Id: <f2709c206d8a3e11729e68d80c57e7470bbe8e5e.1479509885.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While this patch sounded a good idea, unfortunately, it causes
bad dependencies, as drivers that would otherwise work without
the DVB core will now break:

ERROR: "dvb_tuner_simple_release" [drivers/media/tuners/tea5767.ko] undefined!
ERROR: "dvb_tuner_simple_release" [drivers/media/tuners/tea5761.ko] undefined!
ERROR: "dvb_tuner_simple_release" [drivers/media/tuners/tda827x.ko] undefined!
ERROR: "dvb_tuner_simple_release" [drivers/media/tuners/tda18218.ko] undefined!
ERROR: "dvb_tuner_simple_release" [drivers/media/tuners/qt1010.ko] undefined!
ERROR: "dvb_tuner_simple_release" [drivers/media/tuners/mt2266.ko] undefined!
ERROR: "dvb_tuner_simple_release" [drivers/media/tuners/mt20xx.ko] undefined!
ERROR: "dvb_tuner_simple_release" [drivers/media/tuners/mt2060.ko] undefined!
ERROR: "dvb_tuner_simple_release" [drivers/media/tuners/mc44s803.ko] undefined!
ERROR: "dvb_tuner_simple_release" [drivers/media/tuners/fc0013.ko] undefined!
ERROR: "dvb_tuner_simple_release" [drivers/media/tuners/fc0012.ko] undefined!
ERROR: "dvb_tuner_simple_release" [drivers/media/tuners/fc0011.ko] undefined!

So, we have to revert it.

Note: as the argument for the release ops changed from "int"
to "void", we needed to change it at the revert patch, to
avoid compilation issues like:
	drivers/media/tuners/tea5767.c:437:23: error: initialization from incompatible pointer type [-Werror=incompatible-pointer-types]
	  .release           = tea5767_release,
	                       ^~~~~~~~~~~~~~~

This reverts commit 22a613e89825ea7a3984a968463cc6d425bd8856.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_frontend.c      |  8 --------
 drivers/media/dvb-core/dvb_frontend.h      |  7 -------
 drivers/media/dvb-frontends/dib0070.c      |  8 +++++++-
 drivers/media/dvb-frontends/dib0090.c      | 10 ++++++++--
 drivers/media/dvb-frontends/dvb-pll.c      |  8 +++++++-
 drivers/media/dvb-frontends/itd1000.c      |  8 +++++++-
 drivers/media/dvb-frontends/ix2505v.c      | 11 ++++++++++-
 drivers/media/dvb-frontends/stb6000.c      |  8 +++++++-
 drivers/media/dvb-frontends/stb6100.c      | 12 +++++++++++-
 drivers/media/dvb-frontends/stv6110.c      |  8 +++++++-
 drivers/media/dvb-frontends/stv6110x.c     | 10 +++++++++-
 drivers/media/dvb-frontends/tda18271c2dd.c |  9 ++++++++-
 drivers/media/dvb-frontends/tda665x.c      | 10 +++++++++-
 drivers/media/dvb-frontends/tda8261.c      | 10 +++++++++-
 drivers/media/dvb-frontends/tda826x.c      |  8 +++++++-
 drivers/media/dvb-frontends/tua6100.c      |  8 +++++++-
 drivers/media/dvb-frontends/zl10036.c      | 10 +++++++++-
 drivers/media/tuners/fc0011.c              |  8 +++++++-
 drivers/media/tuners/fc0012.c              |  8 +++++++-
 drivers/media/tuners/fc0013.c              |  8 +++++++-
 drivers/media/tuners/mc44s803.c            | 10 +++++++++-
 drivers/media/tuners/mt2060.c              |  8 +++++++-
 drivers/media/tuners/mt20xx.c              | 10 ++++++++--
 drivers/media/tuners/mt2266.c              |  8 +++++++-
 drivers/media/tuners/qt1010.c              |  8 +++++++-
 drivers/media/tuners/tda18218.c            |  8 +++++++-
 drivers/media/tuners/tda827x.c             | 10 ++++++++--
 drivers/media/tuners/tea5761.c             |  8 +++++++-
 drivers/media/tuners/tea5767.c             |  8 +++++++-
 29 files changed, 210 insertions(+), 45 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 87f1346e1fec..db74cb74d271 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -181,14 +181,6 @@ static bool has_get_frontend(struct dvb_frontend *fe)
 	return fe->ops.get_frontend != NULL;
 }
 
-void
-dvb_tuner_simple_release(struct dvb_frontend *fe)
-{
-	kfree(fe->tuner_priv);
-	fe->tuner_priv = NULL;
-}
-EXPORT_SYMBOL(dvb_tuner_simple_release);
-
 /*
  * Due to DVBv3 API calls, a delivery system should be mapped into one of
  * the 4 DVBv3 delivery systems (FE_QPSK, FE_QAM, FE_OFDM or FE_ATSC),
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index f21b255c61de..482912d3b77a 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -267,13 +267,6 @@ struct dvb_tuner_ops {
 };
 
 /**
- * A common default implementation for dvb_tuner_ops.release.  All it
- * does is kfree() the tuner_priv and assign NULL to it.
- */
-void
-dvb_tuner_simple_release(struct dvb_frontend *fe);
-
-/**
  * struct analog_demod_info - Information struct for analog TV part of the demod
  *
  * @name:	Name of the analog TV demodulator
diff --git a/drivers/media/dvb-frontends/dib0070.c b/drivers/media/dvb-frontends/dib0070.c
index d9f1bc2f778c..befc8172159d 100644
--- a/drivers/media/dvb-frontends/dib0070.c
+++ b/drivers/media/dvb-frontends/dib0070.c
@@ -722,6 +722,12 @@ static int dib0070_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
+static void dib0070_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+}
+
 static const struct dvb_tuner_ops dib0070_ops = {
 	.info = {
 		.name           = "DiBcom DiB0070",
@@ -729,7 +735,7 @@ static const struct dvb_tuner_ops dib0070_ops = {
 		.frequency_max  = 860000000,
 		.frequency_step =      1000,
 	},
-	.release       = dvb_tuner_simple_release,
+	.release       = dib0070_release,
 
 	.init          = dib0070_wakeup,
 	.sleep         = dib0070_sleep,
diff --git a/drivers/media/dvb-frontends/dib0090.c b/drivers/media/dvb-frontends/dib0090.c
index 7b4bee5c8e34..fd3b33296b15 100644
--- a/drivers/media/dvb-frontends/dib0090.c
+++ b/drivers/media/dvb-frontends/dib0090.c
@@ -2526,6 +2526,12 @@ static int dib0090_tune(struct dvb_frontend *fe)
 	return ret;
 }
 
+static void dib0090_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+}
+
 enum frontend_tune_state dib0090_get_tune_state(struct dvb_frontend *fe)
 {
 	struct dib0090_state *state = fe->tuner_priv;
@@ -2587,7 +2593,7 @@ static const struct dvb_tuner_ops dib0090_ops = {
 		 .frequency_max = 860000000,
 		 .frequency_step = 1000,
 		 },
-	.release = dvb_tuner_simple_release,
+	.release = dib0090_release,
 
 	.init = dib0090_wakeup,
 	.sleep = dib0090_sleep,
@@ -2602,7 +2608,7 @@ static const struct dvb_tuner_ops dib0090_fw_ops = {
 		 .frequency_max = 860000000,
 		 .frequency_step = 1000,
 		 },
-	.release = dvb_tuner_simple_release,
+	.release = dib0090_release,
 
 	.init = NULL,
 	.sleep = NULL,
diff --git a/drivers/media/dvb-frontends/dvb-pll.c b/drivers/media/dvb-frontends/dvb-pll.c
index 56832d6f47ae..ef976eb23344 100644
--- a/drivers/media/dvb-frontends/dvb-pll.c
+++ b/drivers/media/dvb-frontends/dvb-pll.c
@@ -606,6 +606,12 @@ static int dvb_pll_configure(struct dvb_frontend *fe, u8 *buf,
 	return (div * desc->entries[i].stepsize) - desc->iffreq;
 }
 
+static void dvb_pll_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+}
+
 static int dvb_pll_sleep(struct dvb_frontend *fe)
 {
 	struct dvb_pll_priv *priv = fe->tuner_priv;
@@ -738,7 +744,7 @@ static int dvb_pll_init(struct dvb_frontend *fe)
 }
 
 static const struct dvb_tuner_ops dvb_pll_tuner_ops = {
-	.release = dvb_tuner_simple_release,
+	.release = dvb_pll_release,
 	.sleep = dvb_pll_sleep,
 	.init = dvb_pll_init,
 	.set_params = dvb_pll_set_params,
diff --git a/drivers/media/dvb-frontends/itd1000.c b/drivers/media/dvb-frontends/itd1000.c
index d09f718f8119..475525134327 100644
--- a/drivers/media/dvb-frontends/itd1000.c
+++ b/drivers/media/dvb-frontends/itd1000.c
@@ -348,6 +348,12 @@ static int itd1000_sleep(struct dvb_frontend *fe)
 	return 0;
 }
 
+static void itd1000_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+}
+
 static const struct dvb_tuner_ops itd1000_tuner_ops = {
 	.info = {
 		.name           = "Integrant ITD1000",
@@ -356,7 +362,7 @@ static const struct dvb_tuner_ops itd1000_tuner_ops = {
 		.frequency_step = 125,     /* kHz for QPSK frontends */
 	},
 
-	.release       = dvb_tuner_simple_release,
+	.release       = itd1000_release,
 
 	.init          = itd1000_init,
 	.sleep         = itd1000_sleep,
diff --git a/drivers/media/dvb-frontends/ix2505v.c b/drivers/media/dvb-frontends/ix2505v.c
index 7742a7a8cdbb..ca371680a69f 100644
--- a/drivers/media/dvb-frontends/ix2505v.c
+++ b/drivers/media/dvb-frontends/ix2505v.c
@@ -94,6 +94,15 @@ static int ix2505v_write(struct ix2505v_state *state, u8 buf[], u8 count)
 	return 0;
 }
 
+static void ix2505v_release(struct dvb_frontend *fe)
+{
+	struct ix2505v_state *state = fe->tuner_priv;
+
+	fe->tuner_priv = NULL;
+	kfree(state);
+
+}
+
 /**
  *  Data write format of the Sharp IX2505V B0017
  *
@@ -254,7 +263,7 @@ static const struct dvb_tuner_ops ix2505v_tuner_ops = {
 		.frequency_min = 950000,
 		.frequency_max = 2175000
 	},
-	.release = dvb_tuner_simple_release,
+	.release = ix2505v_release,
 	.set_params = ix2505v_set_params,
 	.get_frequency = ix2505v_get_frequency,
 };
diff --git a/drivers/media/dvb-frontends/stb6000.c b/drivers/media/dvb-frontends/stb6000.c
index 5252d485439e..69c03892f2da 100644
--- a/drivers/media/dvb-frontends/stb6000.c
+++ b/drivers/media/dvb-frontends/stb6000.c
@@ -41,6 +41,12 @@ struct stb6000_priv {
 	u32 frequency;
 };
 
+static void stb6000_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+}
+
 static int stb6000_sleep(struct dvb_frontend *fe)
 {
 	struct stb6000_priv *priv = fe->tuner_priv;
@@ -185,7 +191,7 @@ static const struct dvb_tuner_ops stb6000_tuner_ops = {
 		.frequency_min = 950000,
 		.frequency_max = 2150000
 	},
-	.release = dvb_tuner_simple_release,
+	.release = stb6000_release,
 	.sleep = stb6000_sleep,
 	.set_params = stb6000_set_params,
 	.get_frequency = stb6000_get_frequency,
diff --git a/drivers/media/dvb-frontends/stb6100.c b/drivers/media/dvb-frontends/stb6100.c
index befd26bdfa0f..17a955d0031b 100644
--- a/drivers/media/dvb-frontends/stb6100.c
+++ b/drivers/media/dvb-frontends/stb6100.c
@@ -61,6 +61,8 @@ struct stb6100_lkup {
 	u8   reg;
 };
 
+static void stb6100_release(struct dvb_frontend *fe);
+
 static const struct stb6100_lkup lkup[] = {
 	{       0,  950000, 0x0a },
 	{  950000, 1000000, 0x0a },
@@ -534,7 +536,7 @@ static const struct dvb_tuner_ops stb6100_ops = {
 	.set_params	= stb6100_set_params,
 	.get_frequency  = stb6100_get_frequency,
 	.get_bandwidth  = stb6100_get_bandwidth,
-	.release	= dvb_tuner_simple_release
+	.release	= stb6100_release
 };
 
 struct dvb_frontend *stb6100_attach(struct dvb_frontend *fe,
@@ -558,6 +560,14 @@ struct dvb_frontend *stb6100_attach(struct dvb_frontend *fe,
 	return fe;
 }
 
+static void stb6100_release(struct dvb_frontend *fe)
+{
+	struct stb6100_state *state = fe->tuner_priv;
+
+	fe->tuner_priv = NULL;
+	kfree(state);
+}
+
 EXPORT_SYMBOL(stb6100_attach);
 MODULE_PARM_DESC(verbose, "Set Verbosity level");
 
diff --git a/drivers/media/dvb-frontends/stv6110.c b/drivers/media/dvb-frontends/stv6110.c
index d9a88adc4c10..6a72d0be2ec5 100644
--- a/drivers/media/dvb-frontends/stv6110.c
+++ b/drivers/media/dvb-frontends/stv6110.c
@@ -59,6 +59,12 @@ static s32 abssub(s32 a, s32 b)
 		return b - a;
 };
 
+static void stv6110_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+}
+
 static int stv6110_write_regs(struct dvb_frontend *fe, u8 buf[],
 							int start, int len)
 {
@@ -383,7 +389,7 @@ static const struct dvb_tuner_ops stv6110_tuner_ops = {
 		.frequency_step = 1000,
 	},
 	.init = stv6110_init,
-	.release = dvb_tuner_simple_release,
+	.release = stv6110_release,
 	.sleep = stv6110_sleep,
 	.set_params = stv6110_set_params,
 	.get_frequency = stv6110_get_frequency,
diff --git a/drivers/media/dvb-frontends/stv6110x.c b/drivers/media/dvb-frontends/stv6110x.c
index 70d5641453c2..66eba38f1014 100644
--- a/drivers/media/dvb-frontends/stv6110x.c
+++ b/drivers/media/dvb-frontends/stv6110x.c
@@ -335,6 +335,14 @@ static int stv6110x_get_status(struct dvb_frontend *fe, u32 *status)
 }
 
 
+static void stv6110x_release(struct dvb_frontend *fe)
+{
+	struct stv6110x_state *stv6110x = fe->tuner_priv;
+
+	fe->tuner_priv = NULL;
+	kfree(stv6110x);
+}
+
 static const struct dvb_tuner_ops stv6110x_ops = {
 	.info = {
 		.name		= "STV6110(A) Silicon Tuner",
@@ -342,7 +350,7 @@ static const struct dvb_tuner_ops stv6110x_ops = {
 		.frequency_max	= 2150000,
 		.frequency_step	= 0,
 	},
-	.release		= dvb_tuner_simple_release,
+	.release		= stv6110x_release
 };
 
 static const struct stv6110x_devctl stv6110x_ctl = {
diff --git a/drivers/media/dvb-frontends/tda18271c2dd.c b/drivers/media/dvb-frontends/tda18271c2dd.c
index a324f30f7224..6859fa5d5a85 100644
--- a/drivers/media/dvb-frontends/tda18271c2dd.c
+++ b/drivers/media/dvb-frontends/tda18271c2dd.c
@@ -1126,6 +1126,13 @@ static int init(struct dvb_frontend *fe)
 	return 0;
 }
 
+static void release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+}
+
+
 static int set_params(struct dvb_frontend *fe)
 {
 	struct tda_state *state = fe->tuner_priv;
@@ -1219,7 +1226,7 @@ static const struct dvb_tuner_ops tuner_ops = {
 	.init              = init,
 	.sleep             = sleep,
 	.set_params        = set_params,
-	.release           = dvb_tuner_simple_release,
+	.release           = release,
 	.get_if_frequency  = get_if_frequency,
 	.get_bandwidth     = get_bandwidth,
 };
diff --git a/drivers/media/dvb-frontends/tda665x.c b/drivers/media/dvb-frontends/tda665x.c
index 39a1eb23ad04..a63dec44295b 100644
--- a/drivers/media/dvb-frontends/tda665x.c
+++ b/drivers/media/dvb-frontends/tda665x.c
@@ -197,11 +197,19 @@ static int tda665x_set_params(struct dvb_frontend *fe)
 	return 0;
 }
 
+static void tda665x_release(struct dvb_frontend *fe)
+{
+	struct tda665x_state *state = fe->tuner_priv;
+
+	fe->tuner_priv = NULL;
+	kfree(state);
+}
+
 static const struct dvb_tuner_ops tda665x_ops = {
 	.get_status	= tda665x_get_status,
 	.set_params	= tda665x_set_params,
 	.get_frequency	= tda665x_get_frequency,
-	.release	= dvb_tuner_simple_release,
+	.release	= tda665x_release
 };
 
 struct dvb_frontend *tda665x_attach(struct dvb_frontend *fe,
diff --git a/drivers/media/dvb-frontends/tda8261.c b/drivers/media/dvb-frontends/tda8261.c
index 65f729ff27a9..4eb294f330bc 100644
--- a/drivers/media/dvb-frontends/tda8261.c
+++ b/drivers/media/dvb-frontends/tda8261.c
@@ -152,6 +152,14 @@ static int tda8261_set_params(struct dvb_frontend *fe)
 	return 0;
 }
 
+static void tda8261_release(struct dvb_frontend *fe)
+{
+	struct tda8261_state *state = fe->tuner_priv;
+
+	fe->tuner_priv = NULL;
+	kfree(state);
+}
+
 static const struct dvb_tuner_ops tda8261_ops = {
 
 	.info = {
@@ -164,7 +172,7 @@ static const struct dvb_tuner_ops tda8261_ops = {
 	.set_params	= tda8261_set_params,
 	.get_frequency	= tda8261_get_frequency,
 	.get_status	= tda8261_get_status,
-	.release	= dvb_tuner_simple_release,
+	.release	= tda8261_release
 };
 
 struct dvb_frontend *tda8261_attach(struct dvb_frontend *fe,
diff --git a/drivers/media/dvb-frontends/tda826x.c b/drivers/media/dvb-frontends/tda826x.c
index bf8946c2c04a..da427b4c2aaa 100644
--- a/drivers/media/dvb-frontends/tda826x.c
+++ b/drivers/media/dvb-frontends/tda826x.c
@@ -41,6 +41,12 @@ struct tda826x_priv {
 	u32 frequency;
 };
 
+static void tda826x_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+}
+
 static int tda826x_sleep(struct dvb_frontend *fe)
 {
 	struct tda826x_priv *priv = fe->tuner_priv;
@@ -128,7 +134,7 @@ static const struct dvb_tuner_ops tda826x_tuner_ops = {
 		.frequency_min = 950000,
 		.frequency_max = 2175000
 	},
-	.release = dvb_tuner_simple_release,
+	.release = tda826x_release,
 	.sleep = tda826x_sleep,
 	.set_params = tda826x_set_params,
 	.get_frequency = tda826x_get_frequency,
diff --git a/drivers/media/dvb-frontends/tua6100.c b/drivers/media/dvb-frontends/tua6100.c
index 9e9a8ad7f37c..05ee16d29851 100644
--- a/drivers/media/dvb-frontends/tua6100.c
+++ b/drivers/media/dvb-frontends/tua6100.c
@@ -42,6 +42,12 @@ struct tua6100_priv {
 	u32 frequency;
 };
 
+static void tua6100_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+}
+
 static int tua6100_sleep(struct dvb_frontend *fe)
 {
 	struct tua6100_priv *priv = fe->tuner_priv;
@@ -157,7 +163,7 @@ static const struct dvb_tuner_ops tua6100_tuner_ops = {
 		.frequency_max = 2150000,
 		.frequency_step = 1000,
 	},
-	.release = dvb_tuner_simple_release,
+	.release = tua6100_release,
 	.sleep = tua6100_sleep,
 	.set_params = tua6100_set_params,
 	.get_frequency = tua6100_get_frequency,
diff --git a/drivers/media/dvb-frontends/zl10036.c b/drivers/media/dvb-frontends/zl10036.c
index 0116557c0f10..a6d020fe9b8b 100644
--- a/drivers/media/dvb-frontends/zl10036.c
+++ b/drivers/media/dvb-frontends/zl10036.c
@@ -134,6 +134,14 @@ static int zl10036_write(struct zl10036_state *state, u8 buf[], u8 count)
 	return 0;
 }
 
+static void zl10036_release(struct dvb_frontend *fe)
+{
+	struct zl10036_state *state = fe->tuner_priv;
+
+	fe->tuner_priv = NULL;
+	kfree(state);
+}
+
 static int zl10036_sleep(struct dvb_frontend *fe)
 {
 	struct zl10036_state *state = fe->tuner_priv;
@@ -443,7 +451,7 @@ static const struct dvb_tuner_ops zl10036_tuner_ops = {
 		.frequency_max = 2175000
 	},
 	.init = zl10036_init,
-	.release = dvb_tuner_simple_release,
+	.release = zl10036_release,
 	.sleep = zl10036_sleep,
 	.set_params = zl10036_set_params,
 	.get_frequency = zl10036_get_frequency,
diff --git a/drivers/media/tuners/fc0011.c b/drivers/media/tuners/fc0011.c
index 5e9e2e694f98..00489a9df4e4 100644
--- a/drivers/media/tuners/fc0011.c
+++ b/drivers/media/tuners/fc0011.c
@@ -112,6 +112,12 @@ static int fc0011_readreg(struct fc0011_priv *priv, u8 reg, u8 *val)
 	return 0;
 }
 
+static void fc0011_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+}
+
 static int fc0011_init(struct dvb_frontend *fe)
 {
 	struct fc0011_priv *priv = fe->tuner_priv;
@@ -475,7 +481,7 @@ static const struct dvb_tuner_ops fc0011_tuner_ops = {
 		.frequency_max	= 1000000000,
 	},
 
-	.release		= dvb_tuner_simple_release,
+	.release		= fc0011_release,
 	.init			= fc0011_init,
 
 	.set_params		= fc0011_set_params,
diff --git a/drivers/media/tuners/fc0012.c b/drivers/media/tuners/fc0012.c
index 7faff84e5ea8..30508f44e5f9 100644
--- a/drivers/media/tuners/fc0012.c
+++ b/drivers/media/tuners/fc0012.c
@@ -55,6 +55,12 @@ static int fc0012_readreg(struct fc0012_priv *priv, u8 reg, u8 *val)
 	return 0;
 }
 
+static void fc0012_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+}
+
 static int fc0012_init(struct dvb_frontend *fe)
 {
 	struct fc0012_priv *priv = fe->tuner_priv;
@@ -420,7 +426,7 @@ static const struct dvb_tuner_ops fc0012_tuner_ops = {
 		.frequency_step = 0,
 	},
 
-	.release	= dvb_tuner_simple_release,
+	.release	= fc0012_release,
 
 	.init		= fc0012_init,
 
diff --git a/drivers/media/tuners/fc0013.c b/drivers/media/tuners/fc0013.c
index b068b9702cf7..f7cf0e9e7c99 100644
--- a/drivers/media/tuners/fc0013.c
+++ b/drivers/media/tuners/fc0013.c
@@ -52,6 +52,12 @@ static int fc0013_readreg(struct fc0013_priv *priv, u8 reg, u8 *val)
 	return 0;
 }
 
+static void fc0013_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+}
+
 static int fc0013_init(struct dvb_frontend *fe)
 {
 	struct fc0013_priv *priv = fe->tuner_priv;
@@ -579,7 +585,7 @@ static const struct dvb_tuner_ops fc0013_tuner_ops = {
 		.frequency_step	= 0,
 	},
 
-	.release	= dvb_tuner_simple_release,
+	.release	= fc0013_release,
 
 	.init		= fc0013_init,
 	.sleep		= fc0013_sleep,
diff --git a/drivers/media/tuners/mc44s803.c b/drivers/media/tuners/mc44s803.c
index 86542cbd73fb..aba580b4ac2c 100644
--- a/drivers/media/tuners/mc44s803.c
+++ b/drivers/media/tuners/mc44s803.c
@@ -80,6 +80,14 @@ static int mc44s803_readreg(struct mc44s803_priv *priv, u8 reg, u32 *val)
 	return 0;
 }
 
+static void mc44s803_release(struct dvb_frontend *fe)
+{
+	struct mc44s803_priv *priv = fe->tuner_priv;
+
+	fe->tuner_priv = NULL;
+	kfree(priv);
+}
+
 static int mc44s803_init(struct dvb_frontend *fe)
 {
 	struct mc44s803_priv *priv = fe->tuner_priv;
@@ -302,7 +310,7 @@ static const struct dvb_tuner_ops mc44s803_tuner_ops = {
 		.frequency_step =     100000,
 	},
 
-	.release       = dvb_tuner_simple_release,
+	.release       = mc44s803_release,
 	.init          = mc44s803_init,
 	.set_params    = mc44s803_set_params,
 	.get_frequency = mc44s803_get_frequency,
diff --git a/drivers/media/tuners/mt2060.c b/drivers/media/tuners/mt2060.c
index 14e7b64360cb..94077ea78dde 100644
--- a/drivers/media/tuners/mt2060.c
+++ b/drivers/media/tuners/mt2060.c
@@ -332,6 +332,12 @@ static int mt2060_sleep(struct dvb_frontend *fe)
 	return ret;
 }
 
+static void mt2060_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+}
+
 static const struct dvb_tuner_ops mt2060_tuner_ops = {
 	.info = {
 		.name           = "Microtune MT2060",
@@ -340,7 +346,7 @@ static const struct dvb_tuner_ops mt2060_tuner_ops = {
 		.frequency_step =     50000,
 	},
 
-	.release       = dvb_tuner_simple_release,
+	.release       = mt2060_release,
 
 	.init          = mt2060_init,
 	.sleep         = mt2060_sleep,
diff --git a/drivers/media/tuners/mt20xx.c b/drivers/media/tuners/mt20xx.c
index 4237d8f15919..129bf8e1aff8 100644
--- a/drivers/media/tuners/mt20xx.c
+++ b/drivers/media/tuners/mt20xx.c
@@ -49,6 +49,12 @@ struct microtune_priv {
 	u32 frequency;
 };
 
+static void microtune_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+}
+
 static int microtune_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct microtune_priv *priv = fe->tuner_priv;
@@ -357,7 +363,7 @@ static int mt2032_set_params(struct dvb_frontend *fe,
 
 static const struct dvb_tuner_ops mt2032_tuner_ops = {
 	.set_analog_params = mt2032_set_params,
-	.release           = dvb_tuner_simple_release,
+	.release           = microtune_release,
 	.get_frequency     = microtune_get_frequency,
 };
 
@@ -552,7 +558,7 @@ static int mt2050_set_params(struct dvb_frontend *fe,
 
 static const struct dvb_tuner_ops mt2050_tuner_ops = {
 	.set_analog_params = mt2050_set_params,
-	.release           = dvb_tuner_simple_release,
+	.release           = microtune_release,
 	.get_frequency     = microtune_get_frequency,
 };
 
diff --git a/drivers/media/tuners/mt2266.c b/drivers/media/tuners/mt2266.c
index 35ea5e7975ac..88edcc031e3c 100644
--- a/drivers/media/tuners/mt2266.c
+++ b/drivers/media/tuners/mt2266.c
@@ -296,6 +296,12 @@ static int mt2266_sleep(struct dvb_frontend *fe)
 	return 0;
 }
 
+static void mt2266_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+}
+
 static const struct dvb_tuner_ops mt2266_tuner_ops = {
 	.info = {
 		.name           = "Microtune MT2266",
@@ -303,7 +309,7 @@ static const struct dvb_tuner_ops mt2266_tuner_ops = {
 		.frequency_max  = 862000000,
 		.frequency_step =     50000,
 	},
-	.release       = dvb_tuner_simple_release,
+	.release       = mt2266_release,
 	.init          = mt2266_init,
 	.sleep         = mt2266_sleep,
 	.set_params    = mt2266_set_params,
diff --git a/drivers/media/tuners/qt1010.c b/drivers/media/tuners/qt1010.c
index 5a1662aeeb87..a2c6cd1c3923 100644
--- a/drivers/media/tuners/qt1010.c
+++ b/drivers/media/tuners/qt1010.c
@@ -377,6 +377,12 @@ static int qt1010_init(struct dvb_frontend *fe)
 	return qt1010_set_params(fe);
 }
 
+static void qt1010_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+}
+
 static int qt1010_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct qt1010_priv *priv = fe->tuner_priv;
@@ -398,7 +404,7 @@ static const struct dvb_tuner_ops qt1010_tuner_ops = {
 		.frequency_step = QT1010_STEP,
 	},
 
-	.release       = dvb_tuner_simple_release,
+	.release       = qt1010_release,
 	.init          = qt1010_init,
 	/* TODO: implement sleep */
 
diff --git a/drivers/media/tuners/tda18218.c b/drivers/media/tuners/tda18218.c
index 4d2916fb9953..8357a3c08a70 100644
--- a/drivers/media/tuners/tda18218.c
+++ b/drivers/media/tuners/tda18218.c
@@ -265,6 +265,12 @@ static int tda18218_init(struct dvb_frontend *fe)
 	return ret;
 }
 
+static void tda18218_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+}
+
 static const struct dvb_tuner_ops tda18218_tuner_ops = {
 	.info = {
 		.name           = "NXP TDA18218",
@@ -274,7 +280,7 @@ static const struct dvb_tuner_ops tda18218_tuner_ops = {
 		.frequency_step =      1000,
 	},
 
-	.release       = dvb_tuner_simple_release,
+	.release       = tda18218_release,
 	.init          = tda18218_init,
 	.sleep         = tda18218_sleep,
 
diff --git a/drivers/media/tuners/tda827x.c b/drivers/media/tuners/tda827x.c
index 4befb81f0c1a..2137eadf30f1 100644
--- a/drivers/media/tuners/tda827x.c
+++ b/drivers/media/tuners/tda827x.c
@@ -767,6 +767,12 @@ static void tda827xa_agcf(struct dvb_frontend *fe)
 
 /* ------------------------------------------------------------------ */
 
+static void tda827x_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+}
+
 static int tda827x_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct tda827x_priv *priv = fe->tuner_priv;
@@ -818,7 +824,7 @@ static const struct dvb_tuner_ops tda827xo_tuner_ops = {
 		.frequency_max  = 860000000,
 		.frequency_step =    250000
 	},
-	.release = dvb_tuner_simple_release,
+	.release = tda827x_release,
 	.init = tda827x_initial_init,
 	.sleep = tda827x_initial_sleep,
 	.set_params = tda827xo_set_params,
@@ -834,7 +840,7 @@ static const struct dvb_tuner_ops tda827xa_tuner_ops = {
 		.frequency_max  = 906000000,
 		.frequency_step =     62500
 	},
-	.release = dvb_tuner_simple_release,
+	.release = tda827x_release,
 	.init = tda827x_init,
 	.sleep = tda827xa_sleep,
 	.set_params = tda827xa_set_params,
diff --git a/drivers/media/tuners/tea5761.c b/drivers/media/tuners/tea5761.c
index 82f25621d995..a9b1bb134409 100644
--- a/drivers/media/tuners/tea5761.c
+++ b/drivers/media/tuners/tea5761.c
@@ -284,6 +284,12 @@ int tea5761_autodetection(struct i2c_adapter* i2c_adap, u8 i2c_addr)
 	return 0;
 }
 
+static void tea5761_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+}
+
 static int tea5761_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct tea5761_priv *priv = fe->tuner_priv;
@@ -297,7 +303,7 @@ static const struct dvb_tuner_ops tea5761_tuner_ops = {
 	},
 	.set_analog_params = set_radio_freq,
 	.sleep		   = set_radio_sleep,
-	.release           = dvb_tuner_simple_release,
+	.release           = tea5761_release,
 	.get_frequency     = tea5761_get_frequency,
 	.get_status        = tea5761_get_status,
 	.get_rf_strength   = tea5761_get_rf_strength,
diff --git a/drivers/media/tuners/tea5767.c b/drivers/media/tuners/tea5767.c
index a33c97de8b8a..525b7ab90c80 100644
--- a/drivers/media/tuners/tea5767.c
+++ b/drivers/media/tuners/tea5767.c
@@ -401,6 +401,12 @@ int tea5767_autodetection(struct i2c_adapter* i2c_adap, u8 i2c_addr)
 	return 0;
 }
 
+static void tea5767_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+}
+
 static int tea5767_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct tea5767_priv *priv = fe->tuner_priv;
@@ -426,7 +432,7 @@ static const struct dvb_tuner_ops tea5767_tuner_ops = {
 	.set_analog_params = set_radio_freq,
 	.set_config	   = tea5767_set_config,
 	.sleep             = tea5767_standby,
-	.release           = dvb_tuner_simple_release,
+	.release           = tea5767_release,
 	.get_frequency     = tea5767_get_frequency,
 	.get_status        = tea5767_get_status,
 	.get_rf_strength   = tea5767_get_rf_strength,
-- 
2.7.4

