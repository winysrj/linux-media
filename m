Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:33334 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932519AbcHIVls (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Aug 2016 17:41:48 -0400
Subject: [PATCH 05/12] [media] dvb_frontend: merge duplicate
 dvb_tuner_ops.release implementations
From: Max Kellermann <max.kellermann@gmail.com>
To: linux-media@vger.kernel.org, shuahkh@osg.samsung.com,
	mchehab@osg.samsung.com
Cc: linux-kernel@vger.kernel.org
Date: Tue, 09 Aug 2016 23:32:26 +0200
Message-ID: <147077834639.21835.9626267699459771690.stgit@woodpecker.blarg.de>
In-Reply-To: <147077832610.21835.743840405297289081.stgit@woodpecker.blarg.de>
References: <147077832610.21835.743840405297289081.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most release callback functions are identical: free the "tuner_priv"
and clear it.  Let's eliminate some bloat by providing this simple
implementation in the dvb_frontend library.

Signed-off-by: Max Kellermann <max.kellermann@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c      |    9 +++++++++
 drivers/media/dvb-core/dvb_frontend.h      |    7 +++++++
 drivers/media/dvb-frontends/dib0070.c      |    9 +--------
 drivers/media/dvb-frontends/dib0090.c      |   11 ++---------
 drivers/media/dvb-frontends/dvb-pll.c      |    9 +--------
 drivers/media/dvb-frontends/itd1000.c      |    9 +--------
 drivers/media/dvb-frontends/ix2505v.c      |   12 +-----------
 drivers/media/dvb-frontends/stb6000.c      |    9 +--------
 drivers/media/dvb-frontends/stb6100.c      |   14 +-------------
 drivers/media/dvb-frontends/stv6110.c      |    9 +--------
 drivers/media/dvb-frontends/stv6110x.c     |   12 +-----------
 drivers/media/dvb-frontends/tda18271c2dd.c |   10 +---------
 drivers/media/dvb-frontends/tda665x.c      |   11 +----------
 drivers/media/dvb-frontends/tda8261.c      |   11 +----------
 drivers/media/dvb-frontends/tda826x.c      |    9 +--------
 drivers/media/dvb-frontends/tua6100.c      |    9 +--------
 drivers/media/dvb-frontends/zl10036.c      |   12 +-----------
 drivers/media/tuners/fc0011.c              |   10 +---------
 drivers/media/tuners/fc0012.c              |    9 +--------
 drivers/media/tuners/fc0013.c              |    9 +--------
 drivers/media/tuners/mc44s803.c            |   12 +-----------
 drivers/media/tuners/mt2060.c              |    9 +--------
 drivers/media/tuners/mt20xx.c              |   12 ++----------
 drivers/media/tuners/mt2266.c              |    9 +--------
 drivers/media/tuners/qt1010.c              |    9 +--------
 drivers/media/tuners/tda18218.c            |    9 +--------
 drivers/media/tuners/tda827x.c             |   11 ++---------
 drivers/media/tuners/tea5761.c             |   10 +---------
 drivers/media/tuners/tea5767.c             |   10 +---------
 29 files changed, 46 insertions(+), 245 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index be99c8d..ed9686b 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -169,6 +169,15 @@ static bool has_get_frontend(struct dvb_frontend *fe)
 	return fe->ops.get_frontend != NULL;
 }
 
+int
+dvb_tuner_simple_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+	return 0;
+}
+EXPORT_SYMBOL(dvb_tuner_simple_release);
+
 /*
  * Due to DVBv3 API calls, a delivery system should be mapped into one of
  * the 4 DVBv3 delivery systems (FE_QPSK, FE_QAM, FE_OFDM or FE_ATSC),
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index fb6e848..6b675a8 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -267,6 +267,13 @@ struct dvb_tuner_ops {
 };
 
 /**
+ * A common default implementation for dvb_tuner_ops.release.  All it
+ * does is kfree() the tuner_priv and assign NULL to it.
+ */
+int
+dvb_tuner_simple_release(struct dvb_frontend *fe);
+
+/**
  * struct analog_demod_info - Information struct for analog TV part of the demod
  *
  * @name:	Name of the analog TV demodulator
diff --git a/drivers/media/dvb-frontends/dib0070.c b/drivers/media/dvb-frontends/dib0070.c
index ee7d669..8e31f12 100644
--- a/drivers/media/dvb-frontends/dib0070.c
+++ b/drivers/media/dvb-frontends/dib0070.c
@@ -722,13 +722,6 @@ static int dib0070_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-static int dib0070_release(struct dvb_frontend *fe)
-{
-	kfree(fe->tuner_priv);
-	fe->tuner_priv = NULL;
-	return 0;
-}
-
 static const struct dvb_tuner_ops dib0070_ops = {
 	.info = {
 		.name           = "DiBcom DiB0070",
@@ -736,7 +729,7 @@ static const struct dvb_tuner_ops dib0070_ops = {
 		.frequency_max  = 860000000,
 		.frequency_step =      1000,
 	},
-	.release       = dib0070_release,
+	.release       = dvb_tuner_simple_release,
 
 	.init          = dib0070_wakeup,
 	.sleep         = dib0070_sleep,
diff --git a/drivers/media/dvb-frontends/dib0090.c b/drivers/media/dvb-frontends/dib0090.c
index 14c4032..7780df2 100644
--- a/drivers/media/dvb-frontends/dib0090.c
+++ b/drivers/media/dvb-frontends/dib0090.c
@@ -2524,13 +2524,6 @@ static int dib0090_tune(struct dvb_frontend *fe)
 	return ret;
 }
 
-static int dib0090_release(struct dvb_frontend *fe)
-{
-	kfree(fe->tuner_priv);
-	fe->tuner_priv = NULL;
-	return 0;
-}
-
 enum frontend_tune_state dib0090_get_tune_state(struct dvb_frontend *fe)
 {
 	struct dib0090_state *state = fe->tuner_priv;
@@ -2592,7 +2585,7 @@ static const struct dvb_tuner_ops dib0090_ops = {
 		 .frequency_max = 860000000,
 		 .frequency_step = 1000,
 		 },
-	.release = dib0090_release,
+	.release = dvb_tuner_simple_release,
 
 	.init = dib0090_wakeup,
 	.sleep = dib0090_sleep,
@@ -2607,7 +2600,7 @@ static const struct dvb_tuner_ops dib0090_fw_ops = {
 		 .frequency_max = 860000000,
 		 .frequency_step = 1000,
 		 },
-	.release = dib0090_release,
+	.release = dvb_tuner_simple_release,
 
 	.init = NULL,
 	.sleep = NULL,
diff --git a/drivers/media/dvb-frontends/dvb-pll.c b/drivers/media/dvb-frontends/dvb-pll.c
index 735a966..7065806 100644
--- a/drivers/media/dvb-frontends/dvb-pll.c
+++ b/drivers/media/dvb-frontends/dvb-pll.c
@@ -601,13 +601,6 @@ static int dvb_pll_configure(struct dvb_frontend *fe, u8 *buf,
 	return (div * desc->entries[i].stepsize) - desc->iffreq;
 }
 
-static int dvb_pll_release(struct dvb_frontend *fe)
-{
-	kfree(fe->tuner_priv);
-	fe->tuner_priv = NULL;
-	return 0;
-}
-
 static int dvb_pll_sleep(struct dvb_frontend *fe)
 {
 	struct dvb_pll_priv *priv = fe->tuner_priv;
@@ -740,7 +733,7 @@ static int dvb_pll_init(struct dvb_frontend *fe)
 }
 
 static const struct dvb_tuner_ops dvb_pll_tuner_ops = {
-	.release = dvb_pll_release,
+	.release = dvb_tuner_simple_release,
 	.sleep = dvb_pll_sleep,
 	.init = dvb_pll_init,
 	.set_params = dvb_pll_set_params,
diff --git a/drivers/media/dvb-frontends/itd1000.c b/drivers/media/dvb-frontends/itd1000.c
index cadcae4..d09f718 100644
--- a/drivers/media/dvb-frontends/itd1000.c
+++ b/drivers/media/dvb-frontends/itd1000.c
@@ -348,13 +348,6 @@ static int itd1000_sleep(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int itd1000_release(struct dvb_frontend *fe)
-{
-	kfree(fe->tuner_priv);
-	fe->tuner_priv = NULL;
-	return 0;
-}
-
 static const struct dvb_tuner_ops itd1000_tuner_ops = {
 	.info = {
 		.name           = "Integrant ITD1000",
@@ -363,7 +356,7 @@ static const struct dvb_tuner_ops itd1000_tuner_ops = {
 		.frequency_step = 125,     /* kHz for QPSK frontends */
 	},
 
-	.release       = itd1000_release,
+	.release       = dvb_tuner_simple_release,
 
 	.init          = itd1000_init,
 	.sleep         = itd1000_sleep,
diff --git a/drivers/media/dvb-frontends/ix2505v.c b/drivers/media/dvb-frontends/ix2505v.c
index 2826bbb..7742a7a 100644
--- a/drivers/media/dvb-frontends/ix2505v.c
+++ b/drivers/media/dvb-frontends/ix2505v.c
@@ -94,16 +94,6 @@ static int ix2505v_write(struct ix2505v_state *state, u8 buf[], u8 count)
 	return 0;
 }
 
-static int ix2505v_release(struct dvb_frontend *fe)
-{
-	struct ix2505v_state *state = fe->tuner_priv;
-
-	fe->tuner_priv = NULL;
-	kfree(state);
-
-	return 0;
-}
-
 /**
  *  Data write format of the Sharp IX2505V B0017
  *
@@ -264,7 +254,7 @@ static const struct dvb_tuner_ops ix2505v_tuner_ops = {
 		.frequency_min = 950000,
 		.frequency_max = 2175000
 	},
-	.release = ix2505v_release,
+	.release = dvb_tuner_simple_release,
 	.set_params = ix2505v_set_params,
 	.get_frequency = ix2505v_get_frequency,
 };
diff --git a/drivers/media/dvb-frontends/stb6000.c b/drivers/media/dvb-frontends/stb6000.c
index 73347d5..5252d48 100644
--- a/drivers/media/dvb-frontends/stb6000.c
+++ b/drivers/media/dvb-frontends/stb6000.c
@@ -41,13 +41,6 @@ struct stb6000_priv {
 	u32 frequency;
 };
 
-static int stb6000_release(struct dvb_frontend *fe)
-{
-	kfree(fe->tuner_priv);
-	fe->tuner_priv = NULL;
-	return 0;
-}
-
 static int stb6000_sleep(struct dvb_frontend *fe)
 {
 	struct stb6000_priv *priv = fe->tuner_priv;
@@ -192,7 +185,7 @@ static const struct dvb_tuner_ops stb6000_tuner_ops = {
 		.frequency_min = 950000,
 		.frequency_max = 2150000
 	},
-	.release = stb6000_release,
+	.release = dvb_tuner_simple_release,
 	.sleep = stb6000_sleep,
 	.set_params = stb6000_set_params,
 	.get_frequency = stb6000_get_frequency,
diff --git a/drivers/media/dvb-frontends/stb6100.c b/drivers/media/dvb-frontends/stb6100.c
index 5add118..befd26b 100644
--- a/drivers/media/dvb-frontends/stb6100.c
+++ b/drivers/media/dvb-frontends/stb6100.c
@@ -61,8 +61,6 @@ struct stb6100_lkup {
 	u8   reg;
 };
 
-static int stb6100_release(struct dvb_frontend *fe);
-
 static const struct stb6100_lkup lkup[] = {
 	{       0,  950000, 0x0a },
 	{  950000, 1000000, 0x0a },
@@ -536,7 +534,7 @@ static const struct dvb_tuner_ops stb6100_ops = {
 	.set_params	= stb6100_set_params,
 	.get_frequency  = stb6100_get_frequency,
 	.get_bandwidth  = stb6100_get_bandwidth,
-	.release	= stb6100_release
+	.release	= dvb_tuner_simple_release
 };
 
 struct dvb_frontend *stb6100_attach(struct dvb_frontend *fe,
@@ -560,16 +558,6 @@ struct dvb_frontend *stb6100_attach(struct dvb_frontend *fe,
 	return fe;
 }
 
-static int stb6100_release(struct dvb_frontend *fe)
-{
-	struct stb6100_state *state = fe->tuner_priv;
-
-	fe->tuner_priv = NULL;
-	kfree(state);
-
-	return 0;
-}
-
 EXPORT_SYMBOL(stb6100_attach);
 MODULE_PARM_DESC(verbose, "Set Verbosity level");
 
diff --git a/drivers/media/dvb-frontends/stv6110.c b/drivers/media/dvb-frontends/stv6110.c
index 66a5a7f..d9a88ad 100644
--- a/drivers/media/dvb-frontends/stv6110.c
+++ b/drivers/media/dvb-frontends/stv6110.c
@@ -59,13 +59,6 @@ static s32 abssub(s32 a, s32 b)
 		return b - a;
 };
 
-static int stv6110_release(struct dvb_frontend *fe)
-{
-	kfree(fe->tuner_priv);
-	fe->tuner_priv = NULL;
-	return 0;
-}
-
 static int stv6110_write_regs(struct dvb_frontend *fe, u8 buf[],
 							int start, int len)
 {
@@ -390,7 +383,7 @@ static const struct dvb_tuner_ops stv6110_tuner_ops = {
 		.frequency_step = 1000,
 	},
 	.init = stv6110_init,
-	.release = stv6110_release,
+	.release = dvb_tuner_simple_release,
 	.sleep = stv6110_sleep,
 	.set_params = stv6110_set_params,
 	.get_frequency = stv6110_get_frequency,
diff --git a/drivers/media/dvb-frontends/stv6110x.c b/drivers/media/dvb-frontends/stv6110x.c
index c611ad2..70d5641 100644
--- a/drivers/media/dvb-frontends/stv6110x.c
+++ b/drivers/media/dvb-frontends/stv6110x.c
@@ -335,16 +335,6 @@ static int stv6110x_get_status(struct dvb_frontend *fe, u32 *status)
 }
 
 
-static int stv6110x_release(struct dvb_frontend *fe)
-{
-	struct stv6110x_state *stv6110x = fe->tuner_priv;
-
-	fe->tuner_priv = NULL;
-	kfree(stv6110x);
-
-	return 0;
-}
-
 static const struct dvb_tuner_ops stv6110x_ops = {
 	.info = {
 		.name		= "STV6110(A) Silicon Tuner",
@@ -352,7 +342,7 @@ static const struct dvb_tuner_ops stv6110x_ops = {
 		.frequency_max	= 2150000,
 		.frequency_step	= 0,
 	},
-	.release		= stv6110x_release
+	.release		= dvb_tuner_simple_release,
 };
 
 static const struct stv6110x_devctl stv6110x_ctl = {
diff --git a/drivers/media/dvb-frontends/tda18271c2dd.c b/drivers/media/dvb-frontends/tda18271c2dd.c
index bc247f9..a324f30 100644
--- a/drivers/media/dvb-frontends/tda18271c2dd.c
+++ b/drivers/media/dvb-frontends/tda18271c2dd.c
@@ -1126,14 +1126,6 @@ static int init(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int release(struct dvb_frontend *fe)
-{
-	kfree(fe->tuner_priv);
-	fe->tuner_priv = NULL;
-	return 0;
-}
-
-
 static int set_params(struct dvb_frontend *fe)
 {
 	struct tda_state *state = fe->tuner_priv;
@@ -1227,7 +1219,7 @@ static const struct dvb_tuner_ops tuner_ops = {
 	.init              = init,
 	.sleep             = sleep,
 	.set_params        = set_params,
-	.release           = release,
+	.release           = dvb_tuner_simple_release,
 	.get_if_frequency  = get_if_frequency,
 	.get_bandwidth     = get_bandwidth,
 };
diff --git a/drivers/media/dvb-frontends/tda665x.c b/drivers/media/dvb-frontends/tda665x.c
index 7ca9659..39a1eb2 100644
--- a/drivers/media/dvb-frontends/tda665x.c
+++ b/drivers/media/dvb-frontends/tda665x.c
@@ -197,20 +197,11 @@ static int tda665x_set_params(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int tda665x_release(struct dvb_frontend *fe)
-{
-	struct tda665x_state *state = fe->tuner_priv;
-
-	fe->tuner_priv = NULL;
-	kfree(state);
-	return 0;
-}
-
 static const struct dvb_tuner_ops tda665x_ops = {
 	.get_status	= tda665x_get_status,
 	.set_params	= tda665x_set_params,
 	.get_frequency	= tda665x_get_frequency,
-	.release	= tda665x_release
+	.release	= dvb_tuner_simple_release,
 };
 
 struct dvb_frontend *tda665x_attach(struct dvb_frontend *fe,
diff --git a/drivers/media/dvb-frontends/tda8261.c b/drivers/media/dvb-frontends/tda8261.c
index e0df931..65f729f 100644
--- a/drivers/media/dvb-frontends/tda8261.c
+++ b/drivers/media/dvb-frontends/tda8261.c
@@ -152,15 +152,6 @@ static int tda8261_set_params(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int tda8261_release(struct dvb_frontend *fe)
-{
-	struct tda8261_state *state = fe->tuner_priv;
-
-	fe->tuner_priv = NULL;
-	kfree(state);
-	return 0;
-}
-
 static const struct dvb_tuner_ops tda8261_ops = {
 
 	.info = {
@@ -173,7 +164,7 @@ static const struct dvb_tuner_ops tda8261_ops = {
 	.set_params	= tda8261_set_params,
 	.get_frequency	= tda8261_get_frequency,
 	.get_status	= tda8261_get_status,
-	.release	= tda8261_release
+	.release	= dvb_tuner_simple_release,
 };
 
 struct dvb_frontend *tda8261_attach(struct dvb_frontend *fe,
diff --git a/drivers/media/dvb-frontends/tda826x.c b/drivers/media/dvb-frontends/tda826x.c
index 2ec671d..bf8946c 100644
--- a/drivers/media/dvb-frontends/tda826x.c
+++ b/drivers/media/dvb-frontends/tda826x.c
@@ -41,13 +41,6 @@ struct tda826x_priv {
 	u32 frequency;
 };
 
-static int tda826x_release(struct dvb_frontend *fe)
-{
-	kfree(fe->tuner_priv);
-	fe->tuner_priv = NULL;
-	return 0;
-}
-
 static int tda826x_sleep(struct dvb_frontend *fe)
 {
 	struct tda826x_priv *priv = fe->tuner_priv;
@@ -135,7 +128,7 @@ static const struct dvb_tuner_ops tda826x_tuner_ops = {
 		.frequency_min = 950000,
 		.frequency_max = 2175000
 	},
-	.release = tda826x_release,
+	.release = dvb_tuner_simple_release,
 	.sleep = tda826x_sleep,
 	.set_params = tda826x_set_params,
 	.get_frequency = tda826x_get_frequency,
diff --git a/drivers/media/dvb-frontends/tua6100.c b/drivers/media/dvb-frontends/tua6100.c
index 6da12b9..9e9a8ad 100644
--- a/drivers/media/dvb-frontends/tua6100.c
+++ b/drivers/media/dvb-frontends/tua6100.c
@@ -42,13 +42,6 @@ struct tua6100_priv {
 	u32 frequency;
 };
 
-static int tua6100_release(struct dvb_frontend *fe)
-{
-	kfree(fe->tuner_priv);
-	fe->tuner_priv = NULL;
-	return 0;
-}
-
 static int tua6100_sleep(struct dvb_frontend *fe)
 {
 	struct tua6100_priv *priv = fe->tuner_priv;
@@ -164,7 +157,7 @@ static const struct dvb_tuner_ops tua6100_tuner_ops = {
 		.frequency_max = 2150000,
 		.frequency_step = 1000,
 	},
-	.release = tua6100_release,
+	.release = dvb_tuner_simple_release,
 	.sleep = tua6100_sleep,
 	.set_params = tua6100_set_params,
 	.get_frequency = tua6100_get_frequency,
diff --git a/drivers/media/dvb-frontends/zl10036.c b/drivers/media/dvb-frontends/zl10036.c
index 7ed8131..2368188 100644
--- a/drivers/media/dvb-frontends/zl10036.c
+++ b/drivers/media/dvb-frontends/zl10036.c
@@ -134,16 +134,6 @@ static int zl10036_write(struct zl10036_state *state, u8 buf[], u8 count)
 	return 0;
 }
 
-static int zl10036_release(struct dvb_frontend *fe)
-{
-	struct zl10036_state *state = fe->tuner_priv;
-
-	fe->tuner_priv = NULL;
-	kfree(state);
-
-	return 0;
-}
-
 static int zl10036_sleep(struct dvb_frontend *fe)
 {
 	struct zl10036_state *state = fe->tuner_priv;
@@ -453,7 +443,7 @@ static const struct dvb_tuner_ops zl10036_tuner_ops = {
 		.frequency_max = 2175000
 	},
 	.init = zl10036_init,
-	.release = zl10036_release,
+	.release = dvb_tuner_simple_release,
 	.sleep = zl10036_sleep,
 	.set_params = zl10036_set_params,
 	.get_frequency = zl10036_get_frequency,
diff --git a/drivers/media/tuners/fc0011.c b/drivers/media/tuners/fc0011.c
index 3932aa8..a7c6df2 100644
--- a/drivers/media/tuners/fc0011.c
+++ b/drivers/media/tuners/fc0011.c
@@ -112,14 +112,6 @@ static int fc0011_readreg(struct fc0011_priv *priv, u8 reg, u8 *val)
 	return 0;
 }
 
-static int fc0011_release(struct dvb_frontend *fe)
-{
-	kfree(fe->tuner_priv);
-	fe->tuner_priv = NULL;
-
-	return 0;
-}
-
 static int fc0011_init(struct dvb_frontend *fe)
 {
 	struct fc0011_priv *priv = fe->tuner_priv;
@@ -486,7 +478,7 @@ static const struct dvb_tuner_ops fc0011_tuner_ops = {
 		.frequency_max	= 1000000000,
 	},
 
-	.release		= fc0011_release,
+	.release		= dvb_tuner_simple_release,
 	.init			= fc0011_init,
 
 	.set_params		= fc0011_set_params,
diff --git a/drivers/media/tuners/fc0012.c b/drivers/media/tuners/fc0012.c
index d74e920..7faff84 100644
--- a/drivers/media/tuners/fc0012.c
+++ b/drivers/media/tuners/fc0012.c
@@ -55,13 +55,6 @@ static int fc0012_readreg(struct fc0012_priv *priv, u8 reg, u8 *val)
 	return 0;
 }
 
-static int fc0012_release(struct dvb_frontend *fe)
-{
-	kfree(fe->tuner_priv);
-	fe->tuner_priv = NULL;
-	return 0;
-}
-
 static int fc0012_init(struct dvb_frontend *fe)
 {
 	struct fc0012_priv *priv = fe->tuner_priv;
@@ -427,7 +420,7 @@ static const struct dvb_tuner_ops fc0012_tuner_ops = {
 		.frequency_step = 0,
 	},
 
-	.release	= fc0012_release,
+	.release	= dvb_tuner_simple_release,
 
 	.init		= fc0012_init,
 
diff --git a/drivers/media/tuners/fc0013.c b/drivers/media/tuners/fc0013.c
index 522690d..b068b97 100644
--- a/drivers/media/tuners/fc0013.c
+++ b/drivers/media/tuners/fc0013.c
@@ -52,13 +52,6 @@ static int fc0013_readreg(struct fc0013_priv *priv, u8 reg, u8 *val)
 	return 0;
 }
 
-static int fc0013_release(struct dvb_frontend *fe)
-{
-	kfree(fe->tuner_priv);
-	fe->tuner_priv = NULL;
-	return 0;
-}
-
 static int fc0013_init(struct dvb_frontend *fe)
 {
 	struct fc0013_priv *priv = fe->tuner_priv;
@@ -586,7 +579,7 @@ static const struct dvb_tuner_ops fc0013_tuner_ops = {
 		.frequency_step	= 0,
 	},
 
-	.release	= fc0013_release,
+	.release	= dvb_tuner_simple_release,
 
 	.init		= fc0013_init,
 	.sleep		= fc0013_sleep,
diff --git a/drivers/media/tuners/mc44s803.c b/drivers/media/tuners/mc44s803.c
index f1b7640..c6c8113 100644
--- a/drivers/media/tuners/mc44s803.c
+++ b/drivers/media/tuners/mc44s803.c
@@ -80,16 +80,6 @@ static int mc44s803_readreg(struct mc44s803_priv *priv, u8 reg, u32 *val)
 	return 0;
 }
 
-static int mc44s803_release(struct dvb_frontend *fe)
-{
-	struct mc44s803_priv *priv = fe->tuner_priv;
-
-	fe->tuner_priv = NULL;
-	kfree(priv);
-
-	return 0;
-}
-
 static int mc44s803_init(struct dvb_frontend *fe)
 {
 	struct mc44s803_priv *priv = fe->tuner_priv;
@@ -312,7 +302,7 @@ static const struct dvb_tuner_ops mc44s803_tuner_ops = {
 		.frequency_step =     100000,
 	},
 
-	.release       = mc44s803_release,
+	.release       = dvb_tuner_simple_release,
 	.init          = mc44s803_init,
 	.set_params    = mc44s803_set_params,
 	.get_frequency = mc44s803_get_frequency,
diff --git a/drivers/media/tuners/mt2060.c b/drivers/media/tuners/mt2060.c
index b87b254..14e7b64 100644
--- a/drivers/media/tuners/mt2060.c
+++ b/drivers/media/tuners/mt2060.c
@@ -332,13 +332,6 @@ static int mt2060_sleep(struct dvb_frontend *fe)
 	return ret;
 }
 
-static int mt2060_release(struct dvb_frontend *fe)
-{
-	kfree(fe->tuner_priv);
-	fe->tuner_priv = NULL;
-	return 0;
-}
-
 static const struct dvb_tuner_ops mt2060_tuner_ops = {
 	.info = {
 		.name           = "Microtune MT2060",
@@ -347,7 +340,7 @@ static const struct dvb_tuner_ops mt2060_tuner_ops = {
 		.frequency_step =     50000,
 	},
 
-	.release       = mt2060_release,
+	.release       = dvb_tuner_simple_release,
 
 	.init          = mt2060_init,
 	.sleep         = mt2060_sleep,
diff --git a/drivers/media/tuners/mt20xx.c b/drivers/media/tuners/mt20xx.c
index 52da467..72a6a97 100644
--- a/drivers/media/tuners/mt20xx.c
+++ b/drivers/media/tuners/mt20xx.c
@@ -49,14 +49,6 @@ struct microtune_priv {
 	u32 frequency;
 };
 
-static int microtune_release(struct dvb_frontend *fe)
-{
-	kfree(fe->tuner_priv);
-	fe->tuner_priv = NULL;
-
-	return 0;
-}
-
 static int microtune_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct microtune_priv *priv = fe->tuner_priv;
@@ -365,7 +357,7 @@ static int mt2032_set_params(struct dvb_frontend *fe,
 
 static const struct dvb_tuner_ops mt2032_tuner_ops = {
 	.set_analog_params = mt2032_set_params,
-	.release           = microtune_release,
+	.release           = dvb_tuner_simple_release,
 	.get_frequency     = microtune_get_frequency,
 };
 
@@ -565,7 +557,7 @@ static int mt2050_set_params(struct dvb_frontend *fe,
 
 static const struct dvb_tuner_ops mt2050_tuner_ops = {
 	.set_analog_params = mt2050_set_params,
-	.release           = microtune_release,
+	.release           = dvb_tuner_simple_release,
 	.get_frequency     = microtune_get_frequency,
 };
 
diff --git a/drivers/media/tuners/mt2266.c b/drivers/media/tuners/mt2266.c
index bca4d75..35ea5e7 100644
--- a/drivers/media/tuners/mt2266.c
+++ b/drivers/media/tuners/mt2266.c
@@ -296,13 +296,6 @@ static int mt2266_sleep(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int mt2266_release(struct dvb_frontend *fe)
-{
-	kfree(fe->tuner_priv);
-	fe->tuner_priv = NULL;
-	return 0;
-}
-
 static const struct dvb_tuner_ops mt2266_tuner_ops = {
 	.info = {
 		.name           = "Microtune MT2266",
@@ -310,7 +303,7 @@ static const struct dvb_tuner_ops mt2266_tuner_ops = {
 		.frequency_max  = 862000000,
 		.frequency_step =     50000,
 	},
-	.release       = mt2266_release,
+	.release       = dvb_tuner_simple_release,
 	.init          = mt2266_init,
 	.sleep         = mt2266_sleep,
 	.set_params    = mt2266_set_params,
diff --git a/drivers/media/tuners/qt1010.c b/drivers/media/tuners/qt1010.c
index ae8cbec..5a1662a 100644
--- a/drivers/media/tuners/qt1010.c
+++ b/drivers/media/tuners/qt1010.c
@@ -377,13 +377,6 @@ static int qt1010_init(struct dvb_frontend *fe)
 	return qt1010_set_params(fe);
 }
 
-static int qt1010_release(struct dvb_frontend *fe)
-{
-	kfree(fe->tuner_priv);
-	fe->tuner_priv = NULL;
-	return 0;
-}
-
 static int qt1010_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct qt1010_priv *priv = fe->tuner_priv;
@@ -405,7 +398,7 @@ static const struct dvb_tuner_ops qt1010_tuner_ops = {
 		.frequency_step = QT1010_STEP,
 	},
 
-	.release       = qt1010_release,
+	.release       = dvb_tuner_simple_release,
 	.init          = qt1010_init,
 	/* TODO: implement sleep */
 
diff --git a/drivers/media/tuners/tda18218.c b/drivers/media/tuners/tda18218.c
index 9300e93..4d2916f 100644
--- a/drivers/media/tuners/tda18218.c
+++ b/drivers/media/tuners/tda18218.c
@@ -265,13 +265,6 @@ static int tda18218_init(struct dvb_frontend *fe)
 	return ret;
 }
 
-static int tda18218_release(struct dvb_frontend *fe)
-{
-	kfree(fe->tuner_priv);
-	fe->tuner_priv = NULL;
-	return 0;
-}
-
 static const struct dvb_tuner_ops tda18218_tuner_ops = {
 	.info = {
 		.name           = "NXP TDA18218",
@@ -281,7 +274,7 @@ static const struct dvb_tuner_ops tda18218_tuner_ops = {
 		.frequency_step =      1000,
 	},
 
-	.release       = tda18218_release,
+	.release       = dvb_tuner_simple_release,
 	.init          = tda18218_init,
 	.sleep         = tda18218_sleep,
 
diff --git a/drivers/media/tuners/tda827x.c b/drivers/media/tuners/tda827x.c
index 5050ce9..4befb81 100644
--- a/drivers/media/tuners/tda827x.c
+++ b/drivers/media/tuners/tda827x.c
@@ -767,13 +767,6 @@ static void tda827xa_agcf(struct dvb_frontend *fe)
 
 /* ------------------------------------------------------------------ */
 
-static int tda827x_release(struct dvb_frontend *fe)
-{
-	kfree(fe->tuner_priv);
-	fe->tuner_priv = NULL;
-	return 0;
-}
-
 static int tda827x_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct tda827x_priv *priv = fe->tuner_priv;
@@ -825,7 +818,7 @@ static const struct dvb_tuner_ops tda827xo_tuner_ops = {
 		.frequency_max  = 860000000,
 		.frequency_step =    250000
 	},
-	.release = tda827x_release,
+	.release = dvb_tuner_simple_release,
 	.init = tda827x_initial_init,
 	.sleep = tda827x_initial_sleep,
 	.set_params = tda827xo_set_params,
@@ -841,7 +834,7 @@ static const struct dvb_tuner_ops tda827xa_tuner_ops = {
 		.frequency_max  = 906000000,
 		.frequency_step =     62500
 	},
-	.release = tda827x_release,
+	.release = dvb_tuner_simple_release,
 	.init = tda827x_init,
 	.sleep = tda827xa_sleep,
 	.set_params = tda827xa_set_params,
diff --git a/drivers/media/tuners/tea5761.c b/drivers/media/tuners/tea5761.c
index 36b0b1e..be184c5 100644
--- a/drivers/media/tuners/tea5761.c
+++ b/drivers/media/tuners/tea5761.c
@@ -286,14 +286,6 @@ int tea5761_autodetection(struct i2c_adapter* i2c_adap, u8 i2c_addr)
 	return 0;
 }
 
-static int tea5761_release(struct dvb_frontend *fe)
-{
-	kfree(fe->tuner_priv);
-	fe->tuner_priv = NULL;
-
-	return 0;
-}
-
 static int tea5761_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct tea5761_priv *priv = fe->tuner_priv;
@@ -307,7 +299,7 @@ static const struct dvb_tuner_ops tea5761_tuner_ops = {
 	},
 	.set_analog_params = set_radio_freq,
 	.sleep		   = set_radio_sleep,
-	.release           = tea5761_release,
+	.release           = dvb_tuner_simple_release,
 	.get_frequency     = tea5761_get_frequency,
 	.get_status        = tea5761_get_status,
 	.get_rf_strength   = tea5761_get_rf_strength,
diff --git a/drivers/media/tuners/tea5767.c b/drivers/media/tuners/tea5767.c
index 6d86aa6..5edc4f9 100644
--- a/drivers/media/tuners/tea5767.c
+++ b/drivers/media/tuners/tea5767.c
@@ -398,14 +398,6 @@ int tea5767_autodetection(struct i2c_adapter* i2c_adap, u8 i2c_addr)
 	return 0;
 }
 
-static int tea5767_release(struct dvb_frontend *fe)
-{
-	kfree(fe->tuner_priv);
-	fe->tuner_priv = NULL;
-
-	return 0;
-}
-
 static int tea5767_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct tea5767_priv *priv = fe->tuner_priv;
@@ -431,7 +423,7 @@ static const struct dvb_tuner_ops tea5767_tuner_ops = {
 	.set_analog_params = set_radio_freq,
 	.set_config	   = tea5767_set_config,
 	.sleep             = tea5767_standby,
-	.release           = tea5767_release,
+	.release           = dvb_tuner_simple_release,
 	.get_frequency     = tea5767_get_frequency,
 	.get_status        = tea5767_get_status,
 	.get_rf_strength   = tea5767_get_rf_strength,

