Return-path: <mchehab@pedra>
Received: from mailfe08.c2i.net ([212.247.154.226]:34136 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753272Ab1EYVwT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 17:52:19 -0400
Received: from [188.126.198.129] (account mc467741@c2i.net HELO laptop002.hselasky.homeunix.org)
  by mailfe08.swip.net (CommuniGate Pro SMTP 5.2.19)
  with ESMTPA id 131758065 for linux-media@vger.kernel.org; Wed, 25 May 2011 23:52:16 +0200
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH v3] Fix the derot zig-zag to work with TT-USB2.0 TechnoTrend.
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Wed, 25 May 2011 23:51:01 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201105252351.01888.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

(This patch needs testing and review.)

>From 5449f996bb340e4423b3146d1e0172dd635c0398 Mon Sep 17 00:00:00 2001
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Tue, 24 May 2011 21:44:53 +0200
Subject: [PATCH] Fix the derot zig-zag to work with TT-USB2.0 TechnoTrend.

Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
---
 drivers/media/dvb/frontends/stb0899_algo.c |  173 ++++++++++++----------------
 drivers/media/dvb/frontends/stb0899_drv.c  |    1 -
 drivers/media/dvb/frontends/stb0899_priv.h |    3 -
 3 files changed, 75 insertions(+), 102 deletions(-)

diff --git a/drivers/media/dvb/frontends/stb0899_algo.c b/drivers/media/dvb/frontends/stb0899_algo.c
index d70eee0..9156c3b 100644
--- a/drivers/media/dvb/frontends/stb0899_algo.c
+++ b/drivers/media/dvb/frontends/stb0899_algo.c
@@ -117,7 +117,7 @@ static u32 stb0899_set_srate(struct stb0899_state *state, u32 master_clk, u32 sr
  */
 static long stb0899_calc_derot_time(long srate)
 {
-	if (srate > 0)
+	if (srate > 999)
 		return (100000 / (srate / 1000));
 	else
 		return 0;
@@ -200,6 +200,39 @@ static enum stb0899_status stb0899_check_tmg(struct stb0899_state *state)
 }
 
 /*
+ * stb0899_set_derot
+ * set frequency derotor in HZ.
+ */
+static void
+stb0899_set_derot(struct stb0899_state *state, s16 derot)
+{
+	u8 cfr[2];
+
+	derot *= state->config->inversion;
+
+	cfr[0] = (u8)(derot >> 8);
+	cfr[1] = (u8)derot;
+
+	/* set derotator frequency in Hz */
+	stb0899_write_regs(state, STB0899_CFRM, cfr, 2);
+}
+
+/*
+ * stb0899_get_derot
+ * get frequency derotor in HZ.
+ */
+static s16
+stb0899_get_derot(struct stb0899_state *state)
+{
+	u8 cfr[2] = {0, 0};
+
+	/* get derotator frequency in Hz */
+	stb0899_read_regs(state, STB0899_CFRM, cfr, 2);
+
+	return (state->config->inversion * (s16)MAKEWORD16(cfr[0], cfr[1]));
+}
+
+/*
  * stb0899_search_tmg
  * perform a fs/2 zig-zag to find timing
  */
@@ -207,36 +240,22 @@ static enum stb0899_status stb0899_search_tmg(struct stb0899_state *state)
 {
 	struct stb0899_internal *internal = &state->internal;
 	struct stb0899_params *params = &state->params;
-
-	short int derot_step, derot_freq = 0, derot_limit, next_loop = 3;
-	int index = 0;
-	u8 cfr[2];
+	int index;
 
 	internal->status = NOTIMING;
 
-	/* timing loop computation & symbol rate optimisation	*/
-	derot_limit = (internal->sub_range / 2L) / internal->mclk;
-	derot_step = (params->srate / 2L) / internal->mclk;
+	/* let the hardware figure out derot frequency */
+	stb0899_set_derot(state, 0);
 
-	while ((stb0899_check_tmg(state) != TIMINGOK) && next_loop) {
-		index++;
-		derot_freq += index * internal->direction * derot_step;	/* next derot zig zag position	*/
-
-		if (abs(derot_freq) > derot_limit)
-			next_loop--;
+	for (index = 0; index < 8; index++) {
+		if (stb0899_check_tmg(state) == TIMINGOK) {
+			/* get derotator frequency */
+			internal->derot_freq = stb0899_get_derot(state);
 
-		if (next_loop) {
-			STB0899_SETFIELD_VAL(CFRM, cfr[0], MSB(state->config->inversion * derot_freq));
-			STB0899_SETFIELD_VAL(CFRL, cfr[1], LSB(state->config->inversion * derot_freq));
-			stb0899_write_regs(state, STB0899_CFRM, cfr, 2); /* derotator frequency		*/
+			dprintk(state->verbose, FE_DEBUG, 1, "------->TIMING OK ! "
+			    "Derot Freq = %d @ %d", internal->derot_freq, index);
+			break;
 		}
-		internal->direction = -internal->direction;	/* Change zigzag direction		*/
-	}
-
-	if (internal->status == TIMINGOK) {
-		stb0899_read_regs(state, STB0899_CFRM, cfr, 2); /* get derotator frequency		*/
-		internal->derot_freq = state->config->inversion * MAKEWORD16(cfr[0], cfr[1]);
-		dprintk(state->verbose, FE_DEBUG, 1, "------->TIMING OK ! Derot Freq = %d", internal->derot_freq);
 	}
 
 	return internal->status;
@@ -277,50 +296,26 @@ static enum stb0899_status stb0899_check_carrier(struct stb0899_state *state)
 static enum stb0899_status stb0899_search_carrier(struct stb0899_state *state)
 {
 	struct stb0899_internal *internal = &state->internal;
-
-	short int derot_freq = 0, last_derot_freq = 0, derot_limit, next_loop = 3;
-	int index = 0;
-	u8 cfr[2];
+	int index;
 	u8 reg;
 
 	internal->status = NOCARRIER;
-	derot_limit = (internal->sub_range / 2L) / internal->mclk;
-	derot_freq = internal->derot_freq;
+
+	/* let the hardware figure out derot frequency */
+	stb0899_set_derot(state, 0);
 
 	reg = stb0899_read_reg(state, STB0899_CFD);
 	STB0899_SETFIELD_VAL(CFD_ON, reg, 1);
 	stb0899_write_reg(state, STB0899_CFD, reg);
 
-	do {
-		dprintk(state->verbose, FE_DEBUG, 1, "Derot Freq=%d, mclk=%d", derot_freq, internal->mclk);
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
+	for (index = 0; index < 8; index++) {
+		if (stb0899_check_carrier(state) == CARRIEROK) {
+			/* get derotator frequency */
+			internal->derot_freq = stb0899_get_derot(state);
+			dprintk(state->verbose, FE_DEBUG, 1, "----> CARRIER OK !, "
+			    "Derot Freq=%d @ %d", internal->derot_freq, index);
+			break;
 		}
-
-		internal->direction = -internal->direction; /* Change zigzag direction */
-	} while ((internal->status != CARRIEROK) && next_loop);
-
-	if (internal->status == CARRIEROK) {
-		stb0899_read_regs(state, STB0899_CFRM, cfr, 2); /* get derotator frequency */
-		internal->derot_freq = state->config->inversion * MAKEWORD16(cfr[0], cfr[1]);
-		dprintk(state->verbose, FE_DEBUG, 1, "----> CARRIER OK !, Derot Freq=%d", internal->derot_freq);
-	} else {
-		internal->derot_freq = last_derot_freq;
 	}
 
 	return internal->status;
@@ -344,7 +339,7 @@ static enum stb0899_status stb0899_check_data(struct stb0899_state *state)
 	reg = stb0899_read_reg(state, STB0899_TSTRES);
 	STB0899_SETFIELD_VAL(FRESACS, reg, 1);
 	stb0899_write_reg(state, STB0899_TSTRES, reg);
-	msleep(1);
+	msleep(10);
 	reg = stb0899_read_reg(state, STB0899_TSTRES);
 	STB0899_SETFIELD_VAL(FRESACS, reg, 0);
 	stb0899_write_reg(state, STB0899_TSTRES, reg);
@@ -368,6 +363,7 @@ static enum stb0899_status stb0899_check_data(struct stb0899_state *state)
 		if (lock || loop || (index > dataTime))
 			break;
 		index++;
+		msleep(1);
 	}
 
 	if (lock) {	/* DATA LOCK indicator	*/
@@ -384,46 +380,30 @@ static enum stb0899_status stb0899_check_data(struct stb0899_state *state)
  */
 static enum stb0899_status stb0899_search_data(struct stb0899_state *state)
 {
-	short int derot_freq, derot_step, derot_limit, next_loop = 3;
-	u8 cfr[2];
 	u8 reg;
-	int index = 1;
+	int index;
 
 	struct stb0899_internal *internal = &state->internal;
 	struct stb0899_params *params = &state->params;
 
-	derot_step = (params->srate / 4L) / internal->mclk;
-	derot_limit = (internal->sub_range / 2L) / internal->mclk;
-	derot_freq = internal->derot_freq;
+	/* let the hardware figure out derot frequency */
+	stb0899_set_derot(state, 0);
 
-	do {
-		if ((internal->status != CARRIEROK) || (stb0899_check_data(state) != DATAOK)) {
-
-			derot_freq += index * internal->direction * derot_step;	/* next zig zag derotator position 
*/
-			if (abs(derot_freq) > derot_limit)
-				next_loop--;
-
-			if (next_loop) {
-				dprintk(state->verbose, FE_DEBUG, 1, "Derot freq=%d, mclk=%d", derot_freq, internal-
>mclk);
-				reg = stb0899_read_reg(state, STB0899_CFD);
-				STB0899_SETFIELD_VAL(CFD_ON, reg, 1);
-				stb0899_write_reg(state, STB0899_CFD, reg);
-
-				STB0899_SETFIELD_VAL(CFRM, cfr[0], MSB(state->config->inversion * derot_freq));
-				STB0899_SETFIELD_VAL(CFRL, cfr[1], LSB(state->config->inversion * derot_freq));
-				stb0899_write_regs(state, STB0899_CFRM, cfr, 2); /* derotator frequency	*/
-
-				stb0899_check_carrier(state);
-				index++;
-			}
+	for (index = 0; index < 8; index++) {
+		if ((internal->status == CARRIEROK) &&
+		    (stb0899_check_data(state) == DATAOK)) {
+			/* get derotator frequency */
+			internal->derot_freq = stb0899_get_derot(state);
+			dprintk(state->verbose, FE_DEBUG, 1, "------> DATAOK "
+			    "! Derot Freq=%d @ %d", internal->derot_freq, index);
+			break;
 		}
-		internal->direction = -internal->direction; /* change zig zag direction */
-	} while ((internal->status != DATAOK) && next_loop);
 
-	if (internal->status == DATAOK) {
-		stb0899_read_regs(state, STB0899_CFRM, cfr, 2); /* get derotator frequency */
-		internal->derot_freq = state->config->inversion * MAKEWORD16(cfr[0], cfr[1]);
-		dprintk(state->verbose, FE_DEBUG, 1, "------> DATAOK ! Derot Freq=%d", internal->derot_freq);
+		reg = stb0899_read_reg(state, STB0899_CFD);
+		STB0899_SETFIELD_VAL(CFD_ON, reg, 1);
+		stb0899_write_reg(state, STB0899_CFD, reg);
+
+		stb0899_check_carrier(state);
 	}
 
 	return internal->status;
@@ -508,8 +488,6 @@ enum stb0899_status stb0899_dvbs_algo(struct stb0899_state *state)
 		{ 37,  36,  33,	 32 }  /* QPSK 7/8	*/
 	};
 
-	internal->direction = 1;
-
 	stb0899_set_srate(state, internal->master_clk, params->srate);
 	/* Carrier loop optimization versus symbol rate for acquisition*/
 	if (params->srate <= 5000000) {
@@ -549,11 +527,10 @@ enum stb0899_status stb0899_dvbs_algo(struct stb0899_state *state)
 	 * querying status while acquiring causes the
 	 * acquisition to go bad and hence no locks.
 	 */
-	dprintk(state->verbose, FE_DEBUG, 1, "Derot Percent=%d Srate=%d mclk=%d",
-		internal->derot_percent, params->srate, internal->mclk);
+	dprintk(state->verbose, FE_DEBUG, 1, "Derot Srate=%d mclk=%d",
+		params->srate, internal->mclk);
 
 	/* Initial calculations	*/
-	internal->derot_step = internal->derot_percent * (params->srate / 1000L) / internal->mclk; /* 
DerotStep/1000 * Fsymbol	*/
 	internal->t_derot = stb0899_calc_derot_time(params->srate);
 	internal->t_data = 500;
 
diff --git a/drivers/media/dvb/frontends/stb0899_drv.c b/drivers/media/dvb/frontends/stb0899_drv.c
index ddb9141..0abaa96 100644
--- a/drivers/media/dvb/frontends/stb0899_drv.c
+++ b/drivers/media/dvb/frontends/stb0899_drv.c
@@ -1481,7 +1481,6 @@ static enum dvbfe_search stb0899_search(struct dvb_frontend *fe, struct dvb_fron
 			 *	    10% of the symbol rate
 			 */
 			internal->srch_range	= SearchRange + 1500000 + (i_params->srate / 5);
-			internal->derot_percent	= 30;
 
 			/* What to do for tuners having no bandwidth setup ?	*/
 			/* enable tuner I/O */
diff --git a/drivers/media/dvb/frontends/stb0899_priv.h b/drivers/media/dvb/frontends/stb0899_priv.h
index 82395b9..ad7c779 100644
--- a/drivers/media/dvb/frontends/stb0899_priv.h
+++ b/drivers/media/dvb/frontends/stb0899_priv.h
@@ -174,10 +174,7 @@ struct stb0899_internal {
 	s32			rolloff;		/* Current RollOff of the filter (x100)	*/
 
 	s16			derot_freq;		/* Current derotator frequency (Hz)	*/
-	s16			derot_percent;
 
-	s16			direction;		/* Current derotator search direction	*/
-	s16			derot_step;		/* Derotator step (binary value)	*/
 	s16			t_derot;		/* Derotator time constant (ms)		*/
 	s16			t_data;			/* Data recovery time constant (ms)	*/
 	s16			sub_dir;		/* Direction of the next sub range	*/
-- 
1.7.1.1

