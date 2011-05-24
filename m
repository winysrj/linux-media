Return-path: <mchehab@pedra>
Received: from mailfe06.c2i.net ([212.247.154.162]:54942 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932724Ab1EXTxx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 15:53:53 -0400
Received: from [188.126.198.129] (account mc467741@c2i.net HELO laptop002.hselasky.homeunix.org)
  by mailfe06.swip.net (CommuniGate Pro SMTP 5.2.19)
  with ESMTPA id 130260248 for linux-media@vger.kernel.org; Tue, 24 May 2011 21:53:51 +0200
From: Hans Petter Selasky <hselasky@c2i.net>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] Fix the derot zig-zag to work with TT-USB2.0 TechnoTrend hardware.
Date: Tue, 24 May 2011 21:52:38 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105242152.38319.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

(This time without any word wrappings)

>From 83224b9c4b5402332589139549b387066bff8277 Mon Sep 17 00:00:00 2001
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Tue, 24 May 2011 21:44:53 +0200
Subject: [PATCH] Fix the derot zig-zag to work with TT-USB2.0 TechnoTrend hardware.

Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
---
 drivers/media/dvb/frontends/stb0899_algo.c |  113 ++++++++++++---------------
 1 files changed, 50 insertions(+), 63 deletions(-)

diff --git a/drivers/media/dvb/frontends/stb0899_algo.c b/drivers/media/dvb/frontends/stb0899_algo.c
index d70eee0..1dbd9be 100644
--- a/drivers/media/dvb/frontends/stb0899_algo.c
+++ b/drivers/media/dvb/frontends/stb0899_algo.c
@@ -23,6 +23,13 @@
 #include "stb0899_priv.h"
 #include "stb0899_reg.h"
 
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+static int derot_max = 8192;
+module_param(derot_max, int, 0644);
+MODULE_PARM_DESC(derot_max, "Set Maximum Derot Value (0..32767)");
+
 static inline u32 stb0899_do_div(u64 n, u32 d)
 {
 	/* wrap do_div() for ease of use */
@@ -117,7 +124,7 @@ static u32 stb0899_set_srate(struct stb0899_state *state, u32 master_clk, u32 sr
  */
 static long stb0899_calc_derot_time(long srate)
 {
-	if (srate > 0)
+	if (srate > 999)
 		return (100000 / (srate / 1000));
 	else
 		return 0;
@@ -207,30 +214,22 @@ static enum stb0899_status stb0899_search_tmg(struct stb0899_state *state)
 {
 	struct stb0899_internal *internal = &state->internal;
 	struct stb0899_params *params = &state->params;
-
-	short int derot_step, derot_freq = 0, derot_limit, next_loop = 3;
+	int derot_freq = 0;
 	int index = 0;
 	u8 cfr[2];
 
 	internal->status = NOTIMING;
+	internal->direction = 1;
 
-	/* timing loop computation & symbol rate optimisation	*/
-	derot_limit = (internal->sub_range / 2L) / internal->mclk;
-	derot_step = (params->srate / 2L) / internal->mclk;
+	while ((stb0899_check_tmg(state) != TIMINGOK) && (abs(derot_freq) <= derot_max)) {
+		derot_freq += index * (index - 1) * internal->direction;	/* next derot zig zag position	*/
 
-	while ((stb0899_check_tmg(state) != TIMINGOK) && next_loop) {
-		index++;
-		derot_freq += index * internal->direction * derot_step;	/* next derot zig zag position	*/
+		STB0899_SETFIELD_VAL(CFRM, cfr[0], MSB(state->config->inversion * derot_freq));
+		STB0899_SETFIELD_VAL(CFRL, cfr[1], LSB(state->config->inversion * derot_freq));
+		stb0899_write_regs(state, STB0899_CFRM, cfr, 2); /* derotator frequency		*/
 
-		if (abs(derot_freq) > derot_limit)
-			next_loop--;
-
-		if (next_loop) {
-			STB0899_SETFIELD_VAL(CFRM, cfr[0], MSB(state->config->inversion * derot_freq));
-			STB0899_SETFIELD_VAL(CFRL, cfr[1], LSB(state->config->inversion * derot_freq));
-			stb0899_write_regs(state, STB0899_CFRM, cfr, 2); /* derotator frequency		*/
-		}
 		internal->direction = -internal->direction;	/* Change zigzag direction		*/
+		index++;
 	}
 
 	if (internal->status == TIMINGOK) {
@@ -277,50 +276,41 @@ static enum stb0899_status stb0899_check_carrier(struct stb0899_state *state)
 static enum stb0899_status stb0899_search_carrier(struct stb0899_state *state)
 {
 	struct stb0899_internal *internal = &state->internal;
-
-	short int derot_freq = 0, last_derot_freq = 0, derot_limit, next_loop = 3;
+	int derot_freq;
 	int index = 0;
 	u8 cfr[2];
 	u8 reg;
 
 	internal->status = NOCARRIER;
-	derot_limit = (internal->sub_range / 2L) / internal->mclk;
+	internal->direction = 1;
 	derot_freq = internal->derot_freq;
 
 	reg = stb0899_read_reg(state, STB0899_CFD);
 	STB0899_SETFIELD_VAL(CFD_ON, reg, 1);
 	stb0899_write_reg(state, STB0899_CFD, reg);
 
-	do {
+	while ((stb0899_check_carrier(state) == NOCARRIER) && (abs(derot_freq) <= derot_max)) {
+
+		derot_freq += index * (index - 1) * internal->direction;	/* next derot zig zag position	*/
+
 		dprintk(state->verbose, FE_DEBUG, 1, "Derot Freq=%d, mclk=%d", derot_freq, internal->mclk);
-		if (stb0899_check_carrier(state) == NOCARRIER) {
-			index++;
-			last_derot_freq = derot_freq;
-			derot_freq += index * internal->direction * internal->derot_step; /* next zig zag derotator 
position */
-
-			if(abs(derot_freq) > derot_limit)
-				next_loop--;
-
-			if (next_loop) {
-				reg = stb0899_read_reg(state, STB0899_CFD);
-				STB0899_SETFIELD_VAL(CFD_ON, reg, 1);
-				stb0899_write_reg(state, STB0899_CFD, reg);
-
-				STB0899_SETFIELD_VAL(CFRM, cfr[0], MSB(state->config->inversion * derot_freq));
-				STB0899_SETFIELD_VAL(CFRL, cfr[1], LSB(state->config->inversion * derot_freq));
-				stb0899_write_regs(state, STB0899_CFRM, cfr, 2); /* derotator frequency	*/
-			}
-		}
+
+		reg = stb0899_read_reg(state, STB0899_CFD);
+		STB0899_SETFIELD_VAL(CFD_ON, reg, 1);
+		stb0899_write_reg(state, STB0899_CFD, reg);
+
+		STB0899_SETFIELD_VAL(CFRM, cfr[0], MSB(state->config->inversion * derot_freq));
+		STB0899_SETFIELD_VAL(CFRL, cfr[1], LSB(state->config->inversion * derot_freq));
+		stb0899_write_regs(state, STB0899_CFRM, cfr, 2); /* derotator frequency	*/
 
 		internal->direction = -internal->direction; /* Change zigzag direction */
-	} while ((internal->status != CARRIEROK) && next_loop);
+		index++;
+	}
 
 	if (internal->status == CARRIEROK) {
 		stb0899_read_regs(state, STB0899_CFRM, cfr, 2); /* get derotator frequency */
 		internal->derot_freq = state->config->inversion * MAKEWORD16(cfr[0], cfr[1]);
 		dprintk(state->verbose, FE_DEBUG, 1, "----> CARRIER OK !, Derot Freq=%d", internal->derot_freq);
-	} else {
-		internal->derot_freq = last_derot_freq;
 	}
 
 	return internal->status;
@@ -384,7 +374,7 @@ static enum stb0899_status stb0899_check_data(struct stb0899_state *state)
  */
 static enum stb0899_status stb0899_search_data(struct stb0899_state *state)
 {
-	short int derot_freq, derot_step, derot_limit, next_loop = 3;
+	int derot_freq;
 	u8 cfr[2];
 	u8 reg;
 	int index = 1;
@@ -392,33 +382,30 @@ static enum stb0899_status stb0899_search_data(struct stb0899_state *state)
 	struct stb0899_internal *internal = &state->internal;
 	struct stb0899_params *params = &state->params;
 
-	derot_step = (params->srate / 4L) / internal->mclk;
-	derot_limit = (internal->sub_range / 2L) / internal->mclk;
+	internal->direction = 1;
+
 	derot_freq = internal->derot_freq;
 
-	do {
-		if ((internal->status != CARRIEROK) || (stb0899_check_data(state) != DATAOK)) {
+	while (((internal->status != CARRIEROK) ||
+	    (stb0899_check_data(state) != DATAOK)) && (abs(derot_freq) <= derot_max)) {
 
-			derot_freq += index * internal->direction * derot_step;	/* next zig zag derotator position 
*/
-			if (abs(derot_freq) > derot_limit)
-				next_loop--;
+		derot_freq += index * (index - 1) * internal->direction;	/* next zig zag derotator position */
 
-			if (next_loop) {
-				dprintk(state->verbose, FE_DEBUG, 1, "Derot freq=%d, mclk=%d", derot_freq, internal-
>mclk);
-				reg = stb0899_read_reg(state, STB0899_CFD);
-				STB0899_SETFIELD_VAL(CFD_ON, reg, 1);
-				stb0899_write_reg(state, STB0899_CFD, reg);
+		dprintk(state->verbose, FE_DEBUG, 1, "Derot freq=%d, mclk=%d", derot_freq, internal->mclk);
 
-				STB0899_SETFIELD_VAL(CFRM, cfr[0], MSB(state->config->inversion * derot_freq));
-				STB0899_SETFIELD_VAL(CFRL, cfr[1], LSB(state->config->inversion * derot_freq));
-				stb0899_write_regs(state, STB0899_CFRM, cfr, 2); /* derotator frequency	*/
+		reg = stb0899_read_reg(state, STB0899_CFD);
+		STB0899_SETFIELD_VAL(CFD_ON, reg, 1);
+		stb0899_write_reg(state, STB0899_CFD, reg);
+
+		STB0899_SETFIELD_VAL(CFRM, cfr[0], MSB(state->config->inversion * derot_freq));
+		STB0899_SETFIELD_VAL(CFRL, cfr[1], LSB(state->config->inversion * derot_freq));
+		stb0899_write_regs(state, STB0899_CFRM, cfr, 2); /* derotator frequency	*/
+
+		stb0899_check_carrier(state);
 
-				stb0899_check_carrier(state);
-				index++;
-			}
-		}
 		internal->direction = -internal->direction; /* change zig zag direction */
-	} while ((internal->status != DATAOK) && next_loop);
+		index++;
+	}
 
 	if (internal->status == DATAOK) {
 		stb0899_read_regs(state, STB0899_CFRM, cfr, 2); /* get derotator frequency */
-- 
1.7.1.1

