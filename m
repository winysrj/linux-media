Return-path: <mchehab@pedra>
Received: from blu0-omc1-s10.blu0.hotmail.com ([65.55.116.21]:57876 "EHLO
	blu0-omc1-s10.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974Ab0JJPO6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Oct 2010 11:14:58 -0400
Message-ID: <BLU0-SMTP58AB09E7C9178301416281D8520@phx.gbl>
Subject: [PATCH v2] V4L/DVB: faster DVB-S lock for mantis cards using stb0899 demod
To: linux-media@vger.kernel.org
CC: manu@linuxtv.org
From: SE <tuxoholic@hotmail.de>
Date: Sun, 10 Oct 2010 17:08:27 +0200
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary-00=_rbdsM8Zzc3BKKA+"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_rbdsM8Zzc3BKKA+
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

hi list

This is a modified version of my previous patch [1] to improve the tuning a=
lgo=20
of stb0899 cards using the mantis bridge.

With the kind help of Bj=F8rn Mork I was able to keep it minimally invasive=
 with=20
the same effect.

Over the last month many testers in vdr-portal.de [2] reported positive=20
results using the patch.

This should run fine with all sort of cards using the stb0899 demodulator.

[1] http://www.spinics.net/lists/linux-media/msg23181.html
[2] http://www.vdr-portal.de/board/thread.php?threadid=3D99603

Signed-off-by: SE <tuxoholic@hotmail.de>

--Boundary-00=_rbdsM8Zzc3BKKA+
Content-Type: text/x-patch; charset="iso-8859-1";
	name="V4L-DVB-faster-DVB-S-lock-with-cards-using-stb0899-demod_V2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename=
	"V4L-DVB-faster-DVB-S-lock-with-cards-using-stb0899-demod_V2.patch"

diff --git a/drivers/media/dvb/frontends/stb0899_algo.c b/drivers/media/dvb/frontends/stb0899_algo.c
index 2da55ec..3efde1e 100644
--- a/drivers/media/dvb/frontends/stb0899_algo.c
+++ b/drivers/media/dvb/frontends/stb0899_algo.c
@@ -206,7 +206,6 @@ static enum stb0899_status stb0899_check_tmg(struct stb0899_state *state)
 static enum stb0899_status stb0899_search_tmg(struct stb0899_state *state)
 {
 	struct stb0899_internal *internal = &state->internal;
-	struct stb0899_params *params = &state->params;
 
 	short int derot_step, derot_freq = 0, derot_limit, next_loop = 3;
 	int index = 0;
@@ -216,10 +215,9 @@ static enum stb0899_status stb0899_search_tmg(struct stb0899_state *state)
 
 	/* timing loop computation & symbol rate optimisation	*/
 	derot_limit = (internal->sub_range / 2L) / internal->mclk;
-	derot_step = (params->srate / 2L) / internal->mclk;
+	derot_step = internal->derot_step * 4;				/* dertot_step = decreasing delta */
 
 	while ((stb0899_check_tmg(state) != TIMINGOK) && next_loop) {
-		index++;
 		derot_freq += index * internal->direction * derot_step;	/* next derot zig zag position	*/
 
 		if (abs(derot_freq) > derot_limit)
@@ -230,6 +228,7 @@ static enum stb0899_status stb0899_search_tmg(struct stb0899_state *state)
 			STB0899_SETFIELD_VAL(CFRL, cfr[1], LSB(state->config->inversion * derot_freq));
 			stb0899_write_regs(state, STB0899_CFRM, cfr, 2); /* derotator frequency		*/
 		}
+		index++;
 		internal->direction = -internal->direction;	/* Change zigzag direction		*/
 	}
 
@@ -278,14 +277,18 @@ static enum stb0899_status stb0899_search_carrier(struct stb0899_state *state)
 {
 	struct stb0899_internal *internal = &state->internal;
 
-	short int derot_freq = 0, last_derot_freq = 0, derot_limit, next_loop = 3;
+	short int derot_freq = 0, last_derot_freq = 0, derot_limit, derot_step, next_loop = 3;
 	int index = 0;
+	int base_freq;
 	u8 cfr[2];
 	u8 reg;
 
 	internal->status = NOCARRIER;
 	derot_limit = (internal->sub_range / 2L) / internal->mclk;
 	derot_freq = internal->derot_freq;
+	derot_step = internal->derot_step * 2;
+	last_derot_freq = internal->derot_freq;
+	base_freq = internal->derot_freq;
 
 	reg = stb0899_read_reg(state, STB0899_CFD);
 	STB0899_SETFIELD_VAL(CFD_ON, reg, 1);
@@ -294,11 +297,10 @@ static enum stb0899_status stb0899_search_carrier(struct stb0899_state *state)
 	do {
 		dprintk(state->verbose, FE_DEBUG, 1, "Derot Freq=%d, mclk=%d", derot_freq, internal->mclk);
 		if (stb0899_check_carrier(state) == NOCARRIER) {
-			index++;
 			last_derot_freq = derot_freq;
-			derot_freq += index * internal->direction * internal->derot_step; /* next zig zag derotator position */
+			derot_freq += index * internal->direction * derot_step; /* next zig zag derotator position	*/
 
-			if(abs(derot_freq) > derot_limit)
+			if (derot_freq > base_freq + derot_limit || derot_freq < base_freq - derot_limit)
 				next_loop--;
 
 			if (next_loop) {
@@ -310,9 +312,10 @@ static enum stb0899_status stb0899_search_carrier(struct stb0899_state *state)
 				STB0899_SETFIELD_VAL(CFRL, cfr[1], LSB(state->config->inversion * derot_freq));
 				stb0899_write_regs(state, STB0899_CFRM, cfr, 2); /* derotator frequency	*/
 			}
+			index++;
+			internal->direction = -internal->direction; /* Change zigzag direction */
 		}
 
-		internal->direction = -internal->direction; /* Change zigzag direction */
 	} while ((internal->status != CARRIEROK) && next_loop);
 
 	if (internal->status == CARRIEROK) {
@@ -338,6 +341,7 @@ static enum stb0899_status stb0899_check_data(struct stb0899_state *state)
 	int lock = 0, index = 0, dataTime = 500, loop;
 	u8 reg;
 
+	msleep(1);
 	internal->status = NODATA;
 
 	/* RESET FEC	*/
@@ -348,6 +352,7 @@ static enum stb0899_status stb0899_check_data(struct stb0899_state *state)
 	reg = stb0899_read_reg(state, STB0899_TSTRES);
 	STB0899_SETFIELD_VAL(FRESACS, reg, 0);
 	stb0899_write_reg(state, STB0899_TSTRES, reg);
+	msleep(1);
 
 	if (params->srate <= 2000000)
 		dataTime = 2000;
@@ -360,6 +365,7 @@ static enum stb0899_status stb0899_check_data(struct stb0899_state *state)
 
 	stb0899_write_reg(state, STB0899_DSTATUS2, 0x00); /* force search loop	*/
 	while (1) {
+		msleep(1); 		// Alex: added 1 mSec
 		/* WARNING! VIT LOCKED has to be tested before VIT_END_LOOOP	*/
 		reg = stb0899_read_reg(state, STB0899_VSTATUS);
 		lock = STB0899_GETFIELD(VSTATUS_LOCKEDVIT, reg);
@@ -387,20 +393,21 @@ static enum stb0899_status stb0899_search_data(struct stb0899_state *state)
 	short int derot_freq, derot_step, derot_limit, next_loop = 3;
 	u8 cfr[2];
 	u8 reg;
-	int index = 1;
+	int index = 0;
+	int base_freq;
 
 	struct stb0899_internal *internal = &state->internal;
-	struct stb0899_params *params = &state->params;
 
-	derot_step = (params->srate / 4L) / internal->mclk;
+	derot_step = internal->derot_step;
 	derot_limit = (internal->sub_range / 2L) / internal->mclk;
 	derot_freq = internal->derot_freq;
+	base_freq = internal->derot_freq;
 
 	do {
 		if ((internal->status != CARRIEROK) || (stb0899_check_data(state) != DATAOK)) {
 
 			derot_freq += index * internal->direction * derot_step;	/* next zig zag derotator position */
-			if (abs(derot_freq) > derot_limit)
+			if (derot_freq > base_freq + derot_limit || derot_freq < base_freq - derot_limit)
 				next_loop--;
 
 			if (next_loop) {
@@ -414,9 +421,9 @@ static enum stb0899_status stb0899_search_data(struct stb0899_state *state)
 				stb0899_write_regs(state, STB0899_CFRM, cfr, 2); /* derotator frequency	*/
 
 				stb0899_check_carrier(state);
-				index++;
 			}
 		}
+		index++;
 		internal->direction = -internal->direction; /* change zig zag direction */
 	} while ((internal->status != DATAOK) && next_loop);
 
-- 
1.7.1

--Boundary-00=_rbdsM8Zzc3BKKA+--
