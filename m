Return-path: <linux-media-owner@vger.kernel.org>
Received: from 25.mail-out.ovh.net ([91.121.27.228]:52356 "HELO
	25.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753742Ab0EELe7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 May 2010 07:34:59 -0400
Message-ID: <ab0e35f363ecb2b5daa9146745330ef6.squirrel@webmail.ovh.net>
Date: Wed, 5 May 2010 06:34:57 -0500 (GMT+5)
Subject: [PATCH] tda10048: fix the uncomplete function tda10048_read_ber
From: "Guillaume Audirac" <guillaume.audirac@webag.fr>
To: linux-media@vger.kernel.org
Reply-To: guillaume.audirac@webag.fr
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,


Completes the bit-error-rate read function with the CBER register (before
Viterbi decoder). The returned value is 1e8*actual_ber to be positive.
Also includes some typo mistakes.

Signed-off-by: Guillaume Audirac <guillaume.audirac@webag.fr>
---
 drivers/media/dvb/frontends/tda10048.c |   30 ++++++++++++++++++++++++------
 1 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb/frontends/tda10048.c
b/drivers/media/dvb/frontends/tda10048.c
index 4e2a7c8..9006107 100644
--- a/drivers/media/dvb/frontends/tda10048.c
+++ b/drivers/media/dvb/frontends/tda10048.c
@@ -25,6 +25,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/math64.h>
 #include <asm/div64.h>
 #include "dvb_frontend.h"
 #include "dvb_math.h"
@@ -112,7 +113,7 @@
 #define TDA10048_FREE_REG_1        0xB2
 #define TDA10048_FREE_REG_2        0xB3
 #define TDA10048_CONF_C3_1         0xC0
-#define TDA10048_CYBER_CTRL        0xC2
+#define TDA10048_CVBER_CTRL        0xC2
 #define TDA10048_CBER_NMAX_LSB     0xC4
 #define TDA10048_CBER_NMAX_MSB     0xC5
 #define TDA10048_CBER_LSB          0xC6
@@ -120,7 +121,7 @@
 #define TDA10048_VBER_LSB          0xC8
 #define TDA10048_VBER_MID          0xC9
 #define TDA10048_VBER_MSB          0xCA
-#define TDA10048_CYBER_LUT         0xCC
+#define TDA10048_CVBER_LUT         0xCC
 #define TDA10048_UNCOR_CTRL        0xCD
 #define TDA10048_UNCOR_CPT_LSB     0xCE
 #define TDA10048_UNCOR_CPT_MSB     0xCF
@@ -183,7 +184,7 @@ static struct init_tab {
 	{ TDA10048_AGC_IF_MAX, 0xff },
 	{ TDA10048_AGC_THRESHOLD_MSB, 0x00 },
 	{ TDA10048_AGC_THRESHOLD_LSB, 0x70 },
-	{ TDA10048_CYBER_CTRL, 0x38 },
+	{ TDA10048_CVBER_CTRL, 0x38 },
 	{ TDA10048_AGC_GAINS, 0x12 },
 	{ TDA10048_CONF_XO, 0x00 },
 	{ TDA10048_CONF_TS1, 0x07 },
@@ -765,6 +766,8 @@ static int tda10048_set_frontend(struct dvb_frontend *fe,

 	/* Enable demod TPS auto detection and begin acquisition */
 	tda10048_writereg(state, TDA10048_AUTO, 0x57);
+	/* trigger cber and vber acquisition */
+	tda10048_writereg(state, TDA10048_CVBER_CTRL, 0x3B);

 	return 0;
 }
@@ -830,12 +833,27 @@ static int tda10048_read_status(struct dvb_frontend
*fe, fe_status_t *status)
 static int tda10048_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
 	struct tda10048_state *state = fe->demodulator_priv;
+	static u32 cber_current;
+	u32 cber_nmax;
+	u64 cber_tmp;

 	dprintk(1, "%s()\n", __func__);

-	/* TODO: A reset may be required here */
-	*ber = tda10048_readreg(state, TDA10048_CBER_MSB) << 8 |
-		tda10048_readreg(state, TDA10048_CBER_LSB);
+	/* update cber on interrupt */
+	if (tda10048_readreg(state, TDA10048_SOFT_IT_C3) & 0x01) {
+		cber_tmp = tda10048_readreg(state, TDA10048_CBER_MSB) << 8 |
+			tda10048_readreg(state, TDA10048_CBER_LSB);
+		cber_nmax = tda10048_readreg(state, TDA10048_CBER_NMAX_MSB) << 8 |
+			tda10048_readreg(state, TDA10048_CBER_NMAX_LSB);
+		cber_tmp *= 100000000;
+		cber_tmp *= 2;
+		cber_tmp = div_u64(cber_tmp, (cber_nmax * 32) + 1);
+		cber_current = (u32)cber_tmp;
+		/* retrigger cber acquisition */
+		tda10048_writereg(state, TDA10048_CVBER_CTRL, 0x39);
+	}
+	/* actual cber is (*ber)/1e8 */
+	*ber = cber_current;

 	return 0;
 }
-- 
1.6.3.3

-- 
Guillaume

