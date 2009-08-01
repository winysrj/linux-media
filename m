Return-path: <linux-media-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:54034 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbZHATsq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Aug 2009 15:48:46 -0400
Date: Sat, 1 Aug 2009 21:48:41 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: mchehab@infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/5] drivers/media: Use DIV_ROUND_CLOSEST
Message-ID: <Pine.LNX.4.64.0908012148100.25693@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_CLOSEST performs the computation (x + d/2)/d
but is perhaps more readable.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression x,__divisor;
@@

- (((x) + ((__divisor) / 2)) / (__divisor))
+ DIV_ROUND_CLOSEST(x,__divisor)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/dvb/frontends/dib7000p.c |    2 +-
 drivers/media/dvb/frontends/stb6100.c  |    4 +++-
 drivers/media/dvb/frontends/tda10021.c |    2 +-
 drivers/media/dvb/frontends/ves1820.c  |    2 +-
 drivers/media/dvb/pluto2/pluto2.c      |    2 +-
 drivers/media/video/tuner-core.c       |    4 ++--
 drivers/media/video/v4l1-compat.c      |    5 ++---
 7 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb/frontends/dib7000p.c b/drivers/media/dvb/frontends/dib7000p.c
index 8217e5b..d99ac65 100644
--- a/drivers/media/dvb/frontends/dib7000p.c
+++ b/drivers/media/dvb/frontends/dib7000p.c
@@ -883,7 +883,7 @@ static void dib7000p_spur_protect(struct dib7000p_state *state, u32 rf_khz, u32
 	255, 255, 255, 255, 255, 255};
 
 	u32 xtal = state->cfg.bw->xtal_hz / 1000;
-	int f_rel = ( (rf_khz + xtal/2) / xtal) * xtal - rf_khz;
+	int f_rel = DIV_ROUND_CLOSEST(rf_khz, xtal) * xtal - rf_khz;
 	int k;
 	int coef_re[8],coef_im[8];
 	int bw_khz = bw;
diff --git a/drivers/media/dvb/frontends/stb6100.c b/drivers/media/dvb/frontends/stb6100.c
index 1ed5a7d..60ee18a 100644
--- a/drivers/media/dvb/frontends/stb6100.c
+++ b/drivers/media/dvb/frontends/stb6100.c
@@ -367,7 +367,9 @@ static int stb6100_set_frequency(struct dvb_frontend *fe, u32 frequency)
 	/* N(I) = floor(f(VCO) / (f(XTAL) * (PSD2 ? 2 : 1)))	*/
 	nint = fvco / (state->reference << psd2);
 	/* N(F) = round(f(VCO) / f(XTAL) * (PSD2 ? 2 : 1) - N(I)) * 2 ^ 9	*/
-	nfrac = (((fvco - (nint * state->reference << psd2)) << (9 - psd2)) + state->reference / 2) / state->reference;
+	nfrac = DIV_ROUND_CLOSEST((fvco - (nint * state->reference << psd2))
+					 << (9 - psd2),
+				  state->reference);
 	dprintk(verbose, FE_DEBUG, 1,
 		"frequency = %u, srate = %u, g = %u, odiv = %u, psd2 = %u, fxtal = %u, osm = %u, fvco = %u, N(I) = %u, N(F) = %u",
 		frequency, srate, (unsigned int)g, (unsigned int)odiv,
diff --git a/drivers/media/dvb/frontends/tda10021.c b/drivers/media/dvb/frontends/tda10021.c
index f648fdb..03fc6e7 100644
--- a/drivers/media/dvb/frontends/tda10021.c
+++ b/drivers/media/dvb/frontends/tda10021.c
@@ -176,7 +176,7 @@ static int tda10021_set_symbolrate (struct tda10021_state* state, u32 symbolrate
 	tmp =  ((symbolrate << 4) % FIN) << 8;
 	ratio = (ratio << 8) + tmp / FIN;
 	tmp = (tmp % FIN) << 8;
-	ratio = (ratio << 8) + (tmp + FIN/2) / FIN;
+	ratio = (ratio << 8) + DIV_ROUND_CLOSEST(tmp, FIN);
 
 	BDR = ratio;
 	BDRI = (((XIN << 5) / symbolrate) + 1) / 2;
diff --git a/drivers/media/dvb/frontends/ves1820.c b/drivers/media/dvb/frontends/ves1820.c
index a184597..c62a3ba 100644
--- a/drivers/media/dvb/frontends/ves1820.c
+++ b/drivers/media/dvb/frontends/ves1820.c
@@ -165,7 +165,7 @@ static int ves1820_set_symbolrate(struct ves1820_state *state, u32 symbolrate)
 	tmp = ((symbolrate << 4) % fin) << 8;
 	ratio = (ratio << 8) + tmp / fin;
 	tmp = (tmp % fin) << 8;
-	ratio = (ratio << 8) + (tmp + fin / 2) / fin;
+	ratio = (ratio << 8) + DIV_ROUND_CLOSEST(tmp, fin);
 
 	BDR = ratio;
 	BDRI = (((state->config->xin << 5) / symbolrate) + 1) / 2;
diff --git a/drivers/media/dvb/pluto2/pluto2.c b/drivers/media/dvb/pluto2/pluto2.c
index 598eaf8..852f2b7 100644
--- a/drivers/media/dvb/pluto2/pluto2.c
+++ b/drivers/media/dvb/pluto2/pluto2.c
@@ -439,7 +439,7 @@ static inline u32 divide(u32 numerator, u32 denominator)
 	if (denominator == 0)
 		return ~0;
 
-	return (numerator + denominator / 2) / denominator;
+	return DIV_ROUND_CLOSEST(numerator, denominator);
 }
 
 /* LG Innotek TDTE-E001P (Infineon TUA6034) */
diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 5375942..2801cdc 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -819,8 +819,8 @@ static int tuner_g_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
 
 		fe_tuner_ops->get_frequency(&t->fe, &abs_freq);
 		f->frequency = (V4L2_TUNER_RADIO == t->mode) ?
-			(abs_freq * 2 + 125/2) / 125 :
-			(abs_freq + 62500/2) / 62500;
+			DIV_ROUND_CLOSEST(abs_freq * 2, 125) :
+			DIV_ROUND_CLOSEST(abs_freq, 62500);
 		return 0;
 	}
 	f->frequency = (V4L2_TUNER_RADIO == t->mode) ?
diff --git a/drivers/media/video/v4l1-compat.c b/drivers/media/video/v4l1-compat.c
index 02f2a6d..761fbd6 100644
--- a/drivers/media/video/v4l1-compat.c
+++ b/drivers/media/video/v4l1-compat.c
@@ -76,9 +76,8 @@ get_v4l_control(struct file             *file,
 			dprintk("VIDIOC_G_CTRL: %d\n", err);
 			return 0;
 		}
-		return ((ctrl2.value - qctrl2.minimum) * 65535
-			 + (qctrl2.maximum - qctrl2.minimum) / 2)
-			/ (qctrl2.maximum - qctrl2.minimum);
+		return DIV_ROUND_CLOSEST((ctrl2.value-qctrl2.minimum) * 65535,
+					 qctrl2.maximum - qctrl2.minimum);
 	}
 	return 0;
 }
