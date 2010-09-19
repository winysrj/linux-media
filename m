Return-path: <mchehab@pedra>
Received: from blu0-omc3-s15.blu0.hotmail.com ([65.55.116.90]:39457 "EHLO
	blu0-omc3-s15.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752685Ab0ISJqd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Sep 2010 05:46:33 -0400
Message-ID: <BLU0-SMTP1574ECDF1FB4B418ACB34CED87D0@phx.gbl>
Subject: RE: [PATCH] faster DVB-S lock with cards using stb0899 demod
To: linux-media@vger.kernel.org
From: SE <tuxoholic@hotmail.de>
CC: manu@linuxtv.org
Date: Sun, 19 Sep 2010 11:46:23 +0200
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary-00=_vvdlM3B0ev+ewby"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_vvdlM3B0ev+ewby
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

hi list

v4l-dvb still lacks fast and reliable dvb-s lock for stb08899 chipsets. This 
problem was adressed by Alex Betis two years ago [1]+[2]resulting in a patch 
[3] that made its way into s2-liplianin, not v4l-dvb.

With minor adjustments by me this patch now offers reliable dvb-s/dvb-s2 lock 
for v4l-dvb, most of them will lock in less than a second. Without the patch 
many QPSK channels won't lock at all or within a 5-20 second delay.

The algo can be tested with a modified version of szap-s2 [4], introducing:

* process a channel list sequentially (-e [number] -n [number])
* DiSEqC repetition (-s [number] - the default is 1 sequence + 1 repetition)
* faster status polling (poll instantly after tuning, then poll every 10ms
  instead of 1 poll per second)
* some statistics about the tuning success while processing the list

Here are the new features of szap2-s2 explained:

## channel lock with instant status poll [last raw still is 0]
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f|signal 27948|noise 56032|ber 0|unc -2|tim 0|FE_HAS_LOCK| 0

## channel lock with the first status poll [last raw is 1]
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 0b|signal 23200|noise 40413|ber 0|unc -2|tim 0|
status 1b|signal 23200|noise 37136|ber 0|unc -2|tim 1|FE_HAS_LOCK| 1

## channel lock with the second status poll [last raw is 2]
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00|signal   245|noise    21|ber 0|unc -2|tim 0|
status 1f|signal 17347|noise 45219|ber 0|unc -2|tim 2|FE_HAS_LOCK| 2

## no channel lock - try to lock for 10 seconds, then give up and increase 
lok_errs +1
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal 0 | noise 4 | ber 0 | unc -2 | tim    0 |
status 00 | signal 0 | noise 4 | ber 0 | unc -2 | tim  100 |
status 00 | signal 0 | noise 4 | ber 0 | unc -2 | tim  200 |
status 00 | signal 0 | noise 4 | ber 0 | unc -2 | tim  300 |
status 00 | signal 0 | noise 4 | ber 0 | unc -2 | tim  400 |
status 00 | signal 0 | noise 4 | ber 0 | unc -2 | tim  500 |
status 00 | signal 0 | noise 4 | ber 0 | unc -2 | tim  600 |
status 00 | signal 0 | noise 4 | ber 0 | unc -2 | tim  700 |
status 00 | signal 0 | noise 4 | ber 0 | unc -2 | tim  800 |
status 00 | signal 0 | noise 4 | ber 0 | unc -2 | tim  900 |

## the tuning statistics look like this:
lok_errs =0, runs=3035 of sequ=1207, multi=139, multi_max=2

* lok_errs = amount of lock errors
* runs = current channel number while processing the list
* sequ = the amount of channels to process you specified with "-e [number]"
* multi = amount of multiple polls
* multi_max =  the highest status poll of a channel is stored in here


Here are the results from ezap2 with an Astra 19.2E list and improved algo:

TOT: lok_errs =0, runs=1207 of sequ=1207, multi=48, multi_max=47

real    22m52.883s
user    0m0.004s
sys     0m20.297s


Here are the results from ezap2 with the same list and v4l-dvb mercurial algo:

TOT: lok_errs =233, runs=1207 of sequ=1207, multi=113361, multi_max=987

real    135m34.236s
user    0m0.344s
sys     7m52.322s


Similar results where reported by testers in vdr-portal.de [5]

Feel free to test the improved algo yourself like this:

time ./ezap2 -a0 -xHc Astra_only.txt -e 1207 -n 1 >> zap.log

Change adapter to 1 or higher in case stb0899 is a different adapter in your 
multi card setup.

Attachments are stb0899_algo.c.patch, szap-s2-to-ezap2.patch, Astra_only.txt 
(Astra 19.2E channels list in zap format)

Inline posted patches get word wrapped again and again in kmail, even after I 
followed the suggestions in email-clients.txt


[1] http://www.linuxtv.org/pipermail/linux-dvb/2008-September/029361.html
[2] http://www.linuxtv.org/pipermail/linux-dvb/2008-October/029455.html
[3] http://mercurial.intuxication.org/hg/s2-liplianin/rev/d423b7887ec8
[4] http://mercurial.intuxication.org/hg/szap-s2
[5] http://www.vdr-portal.de/board/thread.php?threadid=99603

Signed-off-by: SE <tuxoholic@hotmail.de>

--Boundary-00=_vvdlM3B0ev+ewby
Content-Type: text/x-patch; charset="us-ascii"; name="stb0899_algo.c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="stb0899_algo.c.patch"

--- a/linux/drivers/media/dvb/frontends/stb0899_algo.c	2010-09-15 15:01:55.000000000 +0200
+++ b/linux/drivers/media/dvb/frontends/stb0899_algo.c	2010-09-17 16:05:01.000000000 +0200
@@ -1,7 +1,7 @@
 /*
 	STB0899 Multistandard Frontend driver
+	Copyright (C) Hans Ellenberger for Modifications Aug. 27, 2010 HE:
 	Copyright (C) Manu Abraham (abraham.manu@gmail.com)
-
 	Copyright (C) ST Microelectronics
 
 	This program is free software; you can redistribute it and/or modify
@@ -31,8 +31,6 @@
 	return n;
 }
 
-#if 0 /* keep */
-/* These functions are currently unused */
 /*
  * stb0899_calc_srate
  * Compute symbol rate
@@ -56,7 +54,7 @@
  * stb0899_get_srate
  * Get the current symbol rate
  */
-static u32 stb0899_get_srate(struct stb0899_state *state)
+u32 stb0899_get_srate(struct stb0899_state *state)
 {
 	struct stb0899_internal *internal = &state->internal;
 	u8 sfr[3];
@@ -65,7 +63,6 @@
 
 	return stb0899_calc_srate(internal->master_clk, sfr);
 }
-#endif
 
 /*
  * stb0899_set_srate
@@ -167,7 +164,7 @@
 
 /*
  * stb0899_check_tmg
- * check for timing lock
+ * check for timing lock for high rates (MCPC)
  * internal.Ttiming: time to wait for loop lock
  */
 static enum stb0899_status stb0899_check_tmg(struct stb0899_state *state)
@@ -201,39 +198,46 @@
 
 /*
  * stb0899_search_tmg
- * perform a fs/2 zig-zag to find timing
+ * perform a fs/2 zig-zag to find timing, called once only from below stb0899_dvbs_algo for low rates (SCPC)
+ * HE: In case this single attempt fails, the tuner gives up
  */
 static enum stb0899_status stb0899_search_tmg(struct stb0899_state *state)
 {
 	struct stb0899_internal *internal = &state->internal;
-	struct stb0899_params *params = &state->params;
-
-	short int derot_step, derot_freq = 0, derot_limit, next_loop = 3;
-	int index = 0;
+	short int derot_step, derot_freq = 0, derot_limit, next_loop = 3; /* HE: 3 trials, then give up */
+	int index = 0; /* HE: First trial at the exact frequency? */
 	u8 cfr[2];
 
 	internal->status = NOTIMING;
 
 	/* timing loop computation & symbol rate optimisation	*/
 	derot_limit = (internal->sub_range / 2L) / internal->mclk;
-	derot_step = (params->srate / 2L) / internal->mclk;
+	derot_step = internal->derot_step * 4;				/* dertot_step = decreasing delta */
 
-	while ((stb0899_check_tmg(state) != TIMINGOK) && next_loop) {
-		index++;
-		derot_freq += index * internal->direction * derot_step;	/* next derot zig zag position	*/
+	dprintk(state->verbose, FE_DEBUG, 1, "search_tmg limit= %d, initial step= %d, mclk= %d", 
+		derot_limit, derot_step, internal->mclk);
+
+	while ((stb0899_check_tmg(state) != TIMINGOK) && next_loop) {	/* Terminate when ok or when exhausted */
+
+		derot_freq += index * internal->direction * derot_step;	/* next zigzag position, initially no delta */
+
+		dprintk(state->verbose, FE_DEBUG, 1, "index= %d, derot_freq= %d, limit= %d, direction= %d, step= %d",
+			index, derot_freq, derot_limit, internal->direction, derot_step);
 
 		if (abs(derot_freq) > derot_limit)
-			next_loop--;
+			next_loop--;			/* HE: Funny - Why decrease only if above limit ??? */
 
-		if (next_loop) {
+		if (next_loop) {			/* Setup tuner hardware frequency */
 			STB0899_SETFIELD_VAL(CFRM, cfr[0], MSB(state->config->inversion * derot_freq));
 			STB0899_SETFIELD_VAL(CFRL, cfr[1], LSB(state->config->inversion * derot_freq));
 			stb0899_write_regs(state, STB0899_CFRM, cfr, 2); /* derotator frequency		*/
 		}
+
+		index++;
 		internal->direction = -internal->direction;	/* Change zigzag direction		*/
 	}
 
-	if (internal->status == TIMINGOK) {
+	if (internal->status == TIMINGOK) {			/* We got it 				*/
 		stb0899_read_regs(state, STB0899_CFRM, cfr, 2); /* get derotator frequency		*/
 		internal->derot_freq = state->config->inversion * MAKEWORD16(cfr[0], cfr[1]);
 		dprintk(state->verbose, FE_DEBUG, 1, "------->TIMING OK ! Derot Freq = %d", internal->derot_freq);
@@ -278,14 +282,21 @@
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
+
+	dprintk(state->verbose, FE_DEBUG, 1, "search_carrier freq= %d, limit= %d, step= %d, mclk = %d", 
+		derot_freq, derot_limit, derot_step, internal->mclk);
 
 	reg = stb0899_read_reg(state, STB0899_CFD);
 	STB0899_SETFIELD_VAL(CFD_ON, reg, 1);
@@ -294,13 +305,17 @@
 	do {
 		dprintk(state->verbose, FE_DEBUG, 1, "Derot Freq=%d, mclk=%d", derot_freq, internal->mclk);
 		if (stb0899_check_carrier(state) == NOCARRIER) {
-			index++;
+
 			last_derot_freq = derot_freq;
-			derot_freq += index * internal->direction * internal->derot_step; /* next zig zag derotator position */
+			derot_freq += index * internal->direction * derot_step; /* next zig zag derotator position	*/
 
-			if(abs(derot_freq) > derot_limit)
-				next_loop--;
 
+			dprintk(state->verbose, FE_DEBUG, 1, "index = %d, derot_freq = %d, limit = %d, step = %d", 
+		index, derot_freq, derot_limit, derot_step);
+
+			// Alex: should limit based on initial base freq
+			if(derot_freq > base_freq + derot_limit || derot_freq < base_freq - derot_limit)
+				next_loop--;
 			if (next_loop) {
 				reg = stb0899_read_reg(state, STB0899_CFD);
 				STB0899_SETFIELD_VAL(CFD_ON, reg, 1);
@@ -310,9 +325,9 @@
 				STB0899_SETFIELD_VAL(CFRL, cfr[1], LSB(state->config->inversion * derot_freq));
 				stb0899_write_regs(state, STB0899_CFRM, cfr, 2); /* derotator frequency	*/
 			}
-		}
-
+			index++;
 		internal->direction = -internal->direction; /* Change zigzag direction */
+		}
 	} while ((internal->status != CARRIEROK) && next_loop);
 
 	if (internal->status == CARRIEROK) {
@@ -328,7 +342,7 @@
 
 /*
  * stb0899_check_data
- * Check for data found
+ * Check for data found. Called only from stb0899_search_data
  */
 static enum stb0899_status stb0899_check_data(struct stb0899_state *state)
 {
@@ -337,18 +351,18 @@
 
 	int lock = 0, index = 0, dataTime = 500, loop;
 	u8 reg;
-
+	msleep(1); 	// Alex: added sleep 5 mSec HE: 1ms
 	internal->status = NODATA;
 
 	/* RESET FEC	*/
 	reg = stb0899_read_reg(state, STB0899_TSTRES);
 	STB0899_SETFIELD_VAL(FRESACS, reg, 1);
 	stb0899_write_reg(state, STB0899_TSTRES, reg);
-	msleep(1);
+	msleep(1); 	// Alex: changed from 1 to 5 mSec HE: 1ms
 	reg = stb0899_read_reg(state, STB0899_TSTRES);
 	STB0899_SETFIELD_VAL(FRESACS, reg, 0);
 	stb0899_write_reg(state, STB0899_TSTRES, reg);
-
+	msleep(1); 	// Alex: added 5 mSec HE: 1ms
 	if (params->srate <= 2000000)
 		dataTime = 2000;
 	else if (params->srate <= 5000000)
@@ -360,6 +374,7 @@
 
 	stb0899_write_reg(state, STB0899_DSTATUS2, 0x00); /* force search loop	*/
 	while (1) {
+		msleep(1); 		// Alex: added 1 mSec
 		/* WARNING! VIT LOCKED has to be tested before VIT_END_LOOOP	*/
 		reg = stb0899_read_reg(state, STB0899_VSTATUS);
 		lock = STB0899_GETFIELD(VSTATUS_LOCKEDVIT, reg);
@@ -380,27 +395,36 @@
 
 /*
  * stb0899_search_data
- * Search for a QPSK carrier with the derotator
+ * Search for a QPSK carrier with the derotator, called from stb0899_dvbs_algo for S1 only
  */
 static enum stb0899_status stb0899_search_data(struct stb0899_state *state)
 {
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
+
+	dprintk(state->verbose, FE_DEBUG, 1, "limit = %d, step = %d, mclk = %d", 
+		derot_limit, derot_step, internal->mclk);
 
 	do {
 		if ((internal->status != CARRIEROK) || (stb0899_check_data(state) != DATAOK)) {
 
 			derot_freq += index * internal->direction * derot_step;	/* next zig zag derotator position */
-			if (abs(derot_freq) > derot_limit)
+
+			dprintk(state->verbose, FE_DEBUG, 1, "index = %d, derot_freq = %d, limit = %d, direction = %d, step = %d", 
+			index, derot_freq, derot_limit, internal->direction, derot_step);
+
+			// Alex: should limit based on initial base freq
+			if(derot_freq > base_freq + derot_limit || derot_freq < base_freq - derot_limit)
 				next_loop--;
 
 			if (next_loop) {
@@ -414,9 +438,10 @@
 				stb0899_write_regs(state, STB0899_CFRM, cfr, 2); /* derotator frequency	*/
 
 				stb0899_check_carrier(state);
-				index++;
 			}
 		}
+
+		index++;
 		internal->direction = -internal->direction; /* change zig zag direction */
 	} while ((internal->status != DATAOK) && next_loop);
 
@@ -481,7 +506,7 @@
 	internal->sub_dir = -internal->sub_dir;
 }
 
-/*
+/**** Main S1 tuning code. S2 is at the end ***********************************************************************
  * stb0899_dvbs_algo
  * Search for a signal, timing, carrier and data for a
  * given frequency in a given range
@@ -538,7 +563,7 @@
 		clnI = 3;
 	}
 
-	dprintk(state->verbose, FE_DEBUG, 1, "Set the timing loop to acquisition");
+	dprintk(state->verbose, FE_DEBUG, 1, "S1: 27.8. Set the timing loop to acquisition");
 	/* Set the timing loop to acquisition	*/
 	stb0899_write_reg(state, STB0899_RTC, 0x46);
 	stb0899_write_reg(state, STB0899_CFD, 0xee);
@@ -554,7 +579,11 @@
 
 	/* Initial calculations	*/
 	internal->derot_step = internal->derot_percent * (params->srate / 1000L) / internal->mclk; /* DerotStep/1000 * Fsymbol	*/
-	internal->t_derot = stb0899_calc_derot_time(params->srate);
+
+	dprintk(state->verbose, FE_DEBUG, 1, "Derot step=%d",
+		internal->derot_step);
+
+	internal->t_derot = stb0899_calc_derot_time(params->srate);		/* Calc time according to srate */
 	internal->t_data = 500;
 
 	dprintk(state->verbose, FE_DEBUG, 1, "RESET stream merger");
@@ -617,8 +646,8 @@
 
 		if (internal->status == TIMINGOK) {
 			dprintk(state->verbose, FE_DEBUG, 1,
-				"TIMING OK ! Derot freq=%d, mclk=%d",
-				internal->derot_freq, internal->mclk);
+				"TIMING OK ! Derot freq=%d, mclk=%d, srate=%d",
+				internal->derot_freq, internal->mclk, params->srate);
 
 			if (stb0899_search_carrier(state) == CARRIEROK) {	/* Search for carrier	*/
 				dprintk(state->verbose, FE_DEBUG, 1,
@@ -719,7 +748,7 @@
 	return internal->status;
 }
 
-/*
+/*** S2 codel below **************************************************************************************************
  * stb0899_dvbs2_config_uwp
  * Configure UWP state machine
  */
@@ -766,7 +795,7 @@
 	stb0899_write_s2reg(state, STB0899_S2DEMOD, STB0899_BASE_CSM_CNTRL1, STB0899_OFF0_CSM_CNTRL1, reg);
 }
 
-static long Log2Int(int number)
+long Log2Int(int number)
 {
 	int i;
 
@@ -954,8 +983,13 @@
 	s32 crl_nom_freq;
 	u32 reg;
 
+	dprintk(state->verbose, FE_DEBUG, 1, "carr_freq = %d, master_clk = %d", carr_freq, master_clk);
+
 	crl_nom_freq = (1 << config->crl_nco_bits) / master_clk;
 	crl_nom_freq *= carr_freq;
+
+	dprintk(state->verbose, FE_DEBUG, 1, "crl_nom_freq = %d", crl_nom_freq);
+
 	reg = STB0899_READ_S2REG(STB0899_S2DEMOD, CRL_NOM_FREQ);
 	STB0899_SETFIELD_VAL(CRL_NOM_FREQ, reg, crl_nom_freq);
 	stb0899_write_s2reg(state, STB0899_S2DEMOD, STB0899_BASE_CRL_NOM_FREQ, STB0899_OFF0_CRL_NOM_FREQ, reg);
@@ -1080,7 +1114,7 @@
 
 /*
  * stb0899_dvbs2_get_dmd_status
- * get DVB-S2 Demod LOCK status
+ * get DVB-S2 Demod LOCK status, wait max. timeout ms
  */
 static enum stb0899_status stb0899_dvbs2_get_dmd_status(struct stb0899_state *state, int timeout)
 {
@@ -1139,6 +1173,8 @@
 {
 	int time = 0, Locked;
 
+	dprintk(state->verbose, FE_DEBUG, 1, "timeout = %d", timeout);
+
 	do {
 		Locked = stb0899_dvbs2_get_data_lock(state, 1);
 		time++;
@@ -1345,6 +1381,9 @@
 		FecLockTime	= 20;	/* 20 ms max time to lock FEC, 20Mbs< SYMB <= 25Mbs		*/
 	}
 
+	dprintk(state->verbose, FE_DEBUG, 1, "S2: srate= %d, searchTime= %d, FecLockTime= %d", 
+		internal->srate, searchTime, FecLockTime);
+
 	/* Maintain Stream Merger in reset during acquisition	*/
 	reg = stb0899_read_reg(state, STB0899_TSTRES);
 	STB0899_SETFIELD_VAL(FRESRS, reg, 1);

--Boundary-00=_vvdlM3B0ev+ewby
Content-Type: text/x-patch; charset="us-ascii";
	name="szap-s2-to-ezap2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="szap-s2-to-ezap2.patch"

diff -NaurwB szap-s2/Makefile ezap2/Makefile
--- szap-s2/Makefile	2010-09-17 19:10:14.000000000 +0200
+++ ezap2/Makefile	2010-09-17 19:35:21.000000000 +0200
@@ -7,7 +7,7 @@
 BIND=/usr/local/bin/
 INCLUDE=-I../s2/linux/include
 
-TARGET=szap-s2
+TARGET=ezap2
 
 all: $(TARGET)
 
diff -NaurwB szap-s2/README ezap2/README
--- szap-s2/README	2010-09-17 19:10:14.000000000 +0200
+++ ezap2/README	2010-09-17 19:54:42.000000000 +0200
@@ -56,5 +56,7 @@
      -M        : modulation 1=BPSK 2=QPSK 5=8PSK
      -C        : fec 0=NONE 12=1/2 23=2/3 34=3/4 35=3/5 45=4/5 56=5/6 67=6/7 89=8/9 910=9/10 999=AUTO
      -O        : rolloff 35=0.35 25=0.25 20=0.20 0=UNKNOWN
+     -e number : examine number channels sequentially, requires starting number '-n xxx'
+     -s number : number of DiSEqC sequences, default 2
 
 Igor M. Liplianin (liplianin@me.by)
diff -NaurwB szap-s2/szap-s2.c ezap2/szap-s2.c
--- szap-s2/szap-s2.c	2010-09-17 19:10:14.000000000 +0200
+++ ezap2/szap-s2.c	2010-09-05 12:06:49.000000000 +0200
@@ -1,7 +1,8 @@
 /* szap-s2 -- simple zapping tool for the Linux DVB S2 API
  *
  * Copyright (C) 2008 Igor M. Liplianin (liplianin@me.by)
- *
+ * HE: 19.8.2010 Added diseq repetition
+ 
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -23,7 +23,6 @@
 #include <limits.h>
 #include <string.h>
 #include <errno.h>
-#include <signal.h>
 #include <sys/ioctl.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -73,16 +68,16 @@
   int driver_value;
   const char *user_string;
   };
-/* --- Channel Parameter Maps From VDR---*/
 
-static struct t_channel_parameter_map inversion_values[] = {
+  /* --- Channel Parameter Maps From VDR---*/
+struct t_channel_parameter_map inversion_values[] = {
   {   0, INVERSION_OFF, "off" },
   {   1, INVERSION_ON,  "on" },
   { 999, INVERSION_AUTO },
   { -1 }
   };
 
-static struct t_channel_parameter_map coderate_values[] = {
+struct t_channel_parameter_map coderate_values[] = {
   {   0, FEC_NONE, "none" },
   {  12, FEC_1_2,  "1/2" },
 //  {  13, FEC_1_3,  "1/3" },
@@ -101,7 +96,7 @@
   { -1 }
   };
 
-static struct t_channel_parameter_map modulation_values[] = {
+struct t_channel_parameter_map modulation_values[] = {
  // {   0, NONE,    "none" },
  // {   4, QAM_4,    "QAM4" },
   {  16, QAM_16,   "QAM16" },
@@ -126,14 +121,13 @@
   { -1 }
   };
 
-static struct t_channel_parameter_map system_values[] = {
+struct t_channel_parameter_map system_values[] = {
   {   0, SYS_DVBS,  "DVB-S" },
   {   1, SYS_DVBS2, "DVB-S2" },
   { -1 }
   };
 
-
-static struct t_channel_parameter_map rolloff_values[] = {
+struct t_channel_parameter_map rolloff_values[] = {
  // {   0, ROLLOFF_AUTO, "auto"},
   {  20, ROLLOFF_20, "0.20" },
   {  25, ROLLOFF_25, "0.25" },
@@ -141,7 +135,7 @@
   { -1 }
   };
 
-static int user_index(int value, const struct t_channel_parameter_map * map)
+int user_index(int value, const struct t_channel_parameter_map * map)
 {
   const struct t_channel_parameter_map *umap = map;
   while (umap && umap->user_value != -1) {
@@ -152,7 +146,7 @@
   return -1;
 };
 
-static int driver_index(int value, const struct t_channel_parameter_map *map)
+int driver_index(int value, const struct t_channel_parameter_map *map)
 {
   const struct t_channel_parameter_map *umap = map;
   while (umap && umap->user_value != -1) {
@@ -163,7 +157,7 @@
   return -1;
 };
 
-static int map_to_user(int value, const struct t_channel_parameter_map *map, char **string)
+int map_to_user(int value, const struct t_channel_parameter_map *map, char **string)
 {
   int n = driver_index(value, map);
   if (n >= 0) {
@@ -174,7 +168,7 @@
   return -1;
 }
 
-static int map_to_driver(int value, const struct t_channel_parameter_map *map)
+int map_to_driver(int value, const struct t_channel_parameter_map *map)
 {
   int n = user_index(value, map);
   if (n >= 0)
@@ -182,16 +176,22 @@
   return -1;
 }
 
-static struct lnb_types_st lnb_type;
-
-static int exit_after_tuning;
-static int interactive;
+static struct lnb_types_st lnb_type;	// HE: ????????
 
-static char *usage_str =
-    "\nusage: szap-s2 -q\n"
-    "         list known channels\n"
-    "       szap-s2 [options] {-n channel-number|channel_name}\n"
-    "         zap to channel via number or full name (case insensitive)\n"
+int exit_after_tuning=0;
+int interactive=0;
+int sequ=0;						/* -e 0=none, 1...n sequential zapping of n channels */ 
+int multi=0;					/* No of retries required */
+int multi_max=0;				/* Highest value of mutli with lock */
+int lock_errs=0;				/* No of failed lockings */
+int runs=0;						/* For multiple loops */
+int dis_seq=2;					/* Number of diseq sequences, settable by -s number */
+	
+char *usage_str =
+	 "\nusage: ezap2 HE: 31.8.2010:\n"
+	 "      -q       : list known channels\n"
+    "       ezap2 [options] {-n channel-number|channel_name}\n"
+    "                 zap to channel via number or _full_ name (case insensitive)\n"
     "     -a number : use given adapter (default 0)\n"
     "     -f number : use given frontend (default 0)\n"
     "     -d number : use given demux (default 0)\n"
@@ -211,9 +211,11 @@
     "     -S        : delivery system type DVB-S=0, DVB-S2=1\n"
     "     -M        : modulation 1=BPSK 2=QPSK 5=8PSK\n"
     "     -C        : fec 0=NONE 12=1/2 23=2/3 34=3/4 35=3/5 45=4/5 56=5/6 67=6/7 89=8/9 910=9/10 999=AUTO\n"
-    "     -O        : rolloff 35=0.35 25=0.25 20=0.20 0=UNKNOWN\n";
+    "     -O        : rolloff 35=0.35 25=0.25 20=0.20 0=UNKNOWN\n"
+    "     -e number : examine number channels sequentially, requires starting number '-n xxx' \n"
+	 "     -s number : number of diseq sequences, default 2\n";
 
-static int set_demux(int dmxfd, int pid, int pes_type, int dvr)
+int set_demux(int dmxfd, int pid, int pes_type, int dvr)
 {
 	struct dmx_pes_filter_params pesfilter;
 
@@ -309,34 +309,36 @@
 void diseqc_send_msg(int fd, fe_sec_voltage_t v, struct diseqc_cmd *cmd,
 		     fe_sec_tone_mode_t t, fe_sec_mini_cmd_t b)
 {
-	if (ioctl(fd, FE_SET_TONE, SEC_TONE_OFF) == -1)
-		perror("FE_SET_TONE failed");
-	if (ioctl(fd, FE_SET_VOLTAGE, v) == -1)
-		perror("FE_SET_VOLTAGE failed");
+int err=0;	
+	if (ioctl(fd, FE_SET_TONE, SEC_TONE_OFF) == -1){
+		perror("FE_SET_TONE failed"); err=1;
+	}
+	if (ioctl(fd, FE_SET_VOLTAGE, v) == -1){
+		perror("FE_SET_VOLTAGE failed");err=1;
+	}	
 		usleep(15 * 1000);
-	if (ioctl(fd, FE_DISEQC_SEND_MASTER_CMD, &cmd->cmd) == -1)
-		perror("FE_DISEQC_SEND_MASTER_CMD failed");
-		usleep(cmd->wait * 1000);
+	if (ioctl(fd, FE_DISEQC_SEND_MASTER_CMD, &cmd->cmd) == -1){
+		perror("FE_DISEQC_SEND_MASTER_CMD failed");err=1;
+	}
+//HE:	usleep(cmd->wait * 1000);
 		usleep(15 * 1000);
-	if (ioctl(fd, FE_DISEQC_SEND_BURST, b) == -1)
-		perror("FE_DISEQC_SEND_BURST failed");
+	if (ioctl(fd, FE_DISEQC_SEND_BURST, b) == -1){
+		perror("FE_DISEQC_SEND_BURST failed");err=1;
+	}
 		usleep(15 * 1000);
-	if (ioctl(fd, FE_SET_TONE, t) == -1)
-		perror("FE_SET_TONE failed");
-
+	if (ioctl(fd, FE_SET_TONE, t) == -1){
+		perror("FE_SET_TONE failed");err=1;
 }
-
-
-
-
-/* digital satellite equipment control,
+	if (err) exit (3);															/* Terminate status 3 when diseqc error */
+}
+/* Diseqc digital satellite equipment control,
  * specification is available from http://www.eutelsat.com/
  */
-static int diseqc(int secfd, int sat_no, int pol_vert, int hi_band)
+int diseqc(int secfd, int sat_no, int pol_vert, int hi_band)
 {
+	if (dis_seq-- == 0) return TRUE;
 	struct diseqc_cmd cmd =
 		{ {{0xe0, 0x10, 0x38, 0xf0, 0x00, 0x00}, 4}, 0 };
-
 	/**
 	 * param: high nibble: reset bits, low nibble set bits,
 	 * bits are: option, position, polarizaion, band
@@ -347,11 +348,23 @@
 	diseqc_send_msg(secfd, pol_vert ? SEC_VOLTAGE_13 : SEC_VOLTAGE_18,
 			&cmd, hi_band ? SEC_TONE_ON : SEC_TONE_OFF,
 			(sat_no / 4) % 2 ? SEC_MINI_B : SEC_MINI_A);
+	while (dis_seq-- > 0) {
+		usleep(15000);
+		struct diseqc_cmd cmd2 =
+			{ {{0xe1, 0x10, 0x38, 0xf0, 0x00, 0x00}, 4}, 0 };
+		cmd2.cmd.msg[3] =
+			0xf0 | (((sat_no * 4) & 0x0f) | (hi_band ? 1 : 0) | (pol_vert ? 0 : 2));
 
+		diseqc_send_msg(secfd, pol_vert ? SEC_VOLTAGE_13 : SEC_VOLTAGE_18,
+				&cmd2, hi_band ? SEC_TONE_ON : SEC_TONE_OFF,
+				(sat_no / 4) % 2 ? SEC_MINI_B : SEC_MINI_A);
+	}
 	return TRUE;
 }
 
-static int do_tune(int fefd, unsigned int ifreq, unsigned int sr, enum fe_delivery_system delsys,
+/* Set the tuner and wait for response, called from zap_to */
+
+int do_tune(int fefd, unsigned int ifreq, unsigned int sr, enum fe_delivery_system delsys,
 		   int modulation, int fec, int rolloff)
 {
 	struct dvb_frontend_event ev;
@@ -370,16 +383,14 @@
 		.num = 9,
 		.props = p
 	};
-
-	/* discard stale QPSK events */
-	while (1) {
+	while (1) {							/* discard stale QPSK events */
 		if (ioctl(fefd, FE_GET_EVENT, &ev) == -1)
 		break;
 	}
-
-	if ((delsys != SYS_DVBS) && (delsys != SYS_DVBS2))
+	if ((delsys != SYS_DVBS) && (delsys != SYS_DVBS2)){
+		printf("do_tune wrong delsys=%i\n", delsys);
 		return -EINVAL;
-
+	}
 	if ((ioctl(fefd, FE_SET_PROPERTY, &cmdseq)) == -1) {
 		perror("FE_SET_PROPERTY failed");
 		return FALSE;
@@ -388,8 +398,7 @@
 	return TRUE;
 }
 
-
-static
+/* Periodically check frontend and evt. print results, exit when lock or when exhausted. Called from zap_to */
 int check_frontend (int fe_fd, int dvr, int human_readable)
 {
 	(void)dvr;
@@ -401,9 +410,7 @@
 	do {
 		if (ioctl(fe_fd, FE_READ_STATUS, &status) == -1)
 			perror("FE_READ_STATUS failed");
-		/* some frontends might not support all these ioctls, thus we
-		 * avoid printing errors
-		 */
+		/* some frontends might not support all these ioctls, thus we avoid printing errors */
 		if (ioctl(fe_fd, FE_READ_SIGNAL_STRENGTH, &signal) == -1)
 			signal = -2;
 		if (ioctl(fe_fd, FE_READ_SNR, &snr) == -1)
@@ -413,23 +420,32 @@
 		if (ioctl(fe_fd, FE_READ_UNCORRECTED_BLOCKS, &uncorrected_blocks) == -1)
 			uncorrected_blocks = -2;
 
+		if (((timeout % 100) == 0) || (status & FE_HAS_LOCK)) {
 		if (human_readable) {
-			printf ("status %02x | signal %3u%% | snr %3u%% | ber %d | unc %d | ",
-				status, (signal * 100) / 0xffff, (snr * 100) / 0xffff, ber, uncorrected_blocks);
+				printf ("status %02x | signal %5u | noise %5u | ber %7d | unc %d | tim %4i |",
+					status, signal, snr , ber, uncorrected_blocks, timeout);
 		} else {
 			printf ("status %02x | signal %04x | snr %04x | ber %08x | unc %08x | ",
 				status, signal, snr, ber, uncorrected_blocks);
 		}
-		if (status & FE_HAS_LOCK)
-			printf("FE_HAS_LOCK");
+			if (status & FE_HAS_LOCK){
+				printf("FE_HAS_LOCK | %2i", timeout);
+			}
 		printf("\n");
-
-		if (exit_after_tuning && ((status & FE_HAS_LOCK) || (++timeout >= 10)))
-			break;
-
-		usleep(1000000);
+		}
+		if (exit_after_tuning){
+			if (status & FE_HAS_LOCK) {
+				if (timeout > multi_max) multi_max = timeout;			/* Remember slowest lock */
+				multi+= timeout; break;
+			}
+			if (++timeout >= 1000) {
+				lock_errs++; break;
+			}
+			usleep(10*1000);													/* 10ms delay */
+		} else {
+			usleep(1000*1000);												/* Non exiting -> 1s delay */
+		}
 	} while (1);
-
 	return 0;
 }
 
@@ -433,7 +449,6 @@
 	return 0;
 }
 
-static
 int zap_to(unsigned int adapter, unsigned int frontend, unsigned int demux,
 	   unsigned int sat_no, unsigned int freq, unsigned int pol,
 	   unsigned int sr, unsigned int vpid, unsigned int apid,
@@ -449,9 +463,8 @@
 		.num = 1,
 		.props = p
 	};
-
 	char fedev[128], dmxdev[128], auddev[128];
-	static int fefd, dmxfda, dmxfdv, dmxfdt = -1, audiofd = -1, patfd, pmtfd;
+	int fefd=0, dmxfda=0, dmxfdv=0, dmxfdt = -1, audiofd = -1, patfd, pmtfd;
 	int pmtpid;
 	uint32_t ifreq;
 	int hiband, result;
@@ -466,7 +478,6 @@
 			perror("opening frontend failed");
 			return FALSE;
 		}
-		
 		if ((dmxfdv = open(dmxdev, O_RDWR)) < 0) {
 			perror("opening video demux failed");
 			close(fefd);
@@ -527,15 +530,13 @@
 		ifreq = freq - lnb_type.low_val;
 	}
 	result = FALSE;
-
-	if ((ioctl(fefd, FE_SET_PROPERTY, &cmdseq)) == -1) {
+	if ((ioctl(fefd, FE_SET_PROPERTY, &cmdseq)) == -1) {						/* Clear DTV */
 		perror("FE_SET_PROPERTY DTV_CLEAR failed");
 		return FALSE;
 	}
-
-	if (diseqc(fefd, sat_no, pol, hiband))
-		if (do_tune(fefd, ifreq, sr, delivery, modulation, fec, rolloff))
-			if (set_demux(dmxfdv, vpid, DMX_PES_VIDEO, dvr))
+	if (diseqc(fefd, sat_no, pol, hiband))											/* Send diseqc */
+		if (do_tune(fefd, ifreq, sr, delivery, modulation, fec, rolloff))	/* Tune to freq */
+			if (set_demux(dmxfdv, vpid, DMX_PES_VIDEO, dvr))					/* Set Demux */
 				if (audiofd >= 0)
 					(void)ioctl(audiofd, AUDIO_SET_BYPASS_MODE, bypass);
 	if (set_demux(dmxfda, apid, DMX_PES_AUDIO, dvr)) {
@@ -555,13 +556,10 @@
 			result = TRUE;
 		}
 	}
-
-	if (tpid != -1 && !set_demux(dmxfdt, tpid, DMX_PES_TELETEXT, dvr)) {
+	if (tpid != -1 && !set_demux(dmxfdt, tpid, DMX_PES_TELETEXT, dvr)) {		/* Evt. teletext */
 		fprintf(stderr, "set_demux DMX_PES_TELETEXT failed\n");
 	}
-
-	check_frontend (fefd, dvr, human_readable);
-
+	check_frontend (fefd, dvr, human_readable);					/* Check frontend */
 	if (!interactive) {
 		close(patfd);
 		close(pmtfd);
@@ -572,10 +570,9 @@
 		close(dmxfdt);
 		close(fefd);
 	}
-
-	return result;
+	return result;														/* TRUE = success */
 }
-static char *parse_parameter(const char *s, int *value, const struct t_channel_parameter_map *map)
+char *parse_parameter(const char *s, int *value, const struct t_channel_parameter_map *map)
 {
 	if (*++s) {
 		char *p = NULL;
@@ -591,7 +588,8 @@
         return NULL;
 }
 
-static int read_channels(const char *filename, int list_channels,
+/* Read file and find entry, then zap_to. Called once from main */
+int read_channels(const char *filename, int list_channels,
 			uint32_t chan_no, const char *chan_name,
 			unsigned int adapter, unsigned int frontend,
 			unsigned int demux, int dvr, int rec_psi,
@@ -608,6 +606,7 @@
 	unsigned int freq, pol, sat_no, sr, vpid, apid, tpid, sid;
 	int ret;
 	int trash;
+	runs=0;
 again:
 	line = 0;
 	if (!(cfp = fopen(filename, "r"))) {
@@ -615,8 +614,7 @@
 			filename, errno);
 		return FALSE;
 	}
-
-	if (interactive) {
+	if (interactive) {														/* Process interactive */
 		fprintf(stderr, "\n>>> ");
 		if (!fgets(inp, sizeof(inp), stdin)) {
 			printf("\n");
@@ -637,20 +635,17 @@
 			chan_no = 0;
 		}
 	}
-
-	while (!feof(cfp)) {
+	while (!feof(cfp)) {																	/* Main loop through file */
 		if (fgets(buf, sizeof(buf), cfp)) {
 			line++;
-
-		if (chan_no && chan_no != line)
+			if (chan_no && (chan_no > line)){										/* When chan_no given, seek it */
+//			printf("READ2: %i, %i\n", line, chan_no);
 			continue;
-
+			}
 		tmp = buf;
-		field = strsep(&tmp, ":");
-
+			field = strsep(&tmp, ":");													/* Get 1st field channel name */
 		if (!field)
 			goto syntax_err;
-
 		if (list_channels) {
 			printf("%03u %s\n", line, field);
 			continue;
@@ -655,21 +650,15 @@
 			printf("%03u %s\n", line, field);
 			continue;
 		}
-
-		if (chan_name && strcasecmp(chan_name, field) != 0)
+			if (chan_name && strcasecmp(chan_name, field) != 0)				/* When chan_name given, seek it */
 			continue;
-
-		printf("zapping to %d '%s':\n", line, field);
-
+			printf("*** Zapping to %d '%s':\n", line, field);					/* We no have the right one */
 		if (!(field = strsep(&tmp, ":")))
 			goto syntax_err;
-
-		freq = strtoul(field, NULL, 0);
-
+			freq = strtoul(field, NULL, 0);											/* 2nd field = frequ */
 		if (!(field = strsep(&tmp, ":")))
 			goto syntax_err;
-
-		while (field && *field) {
+			while (field && *field) {													/* Scan all remaining fields */
 			switch (toupper(*field)) {
 			case 'C':
 				if (fec == -1)
@@ -677,7 +666,7 @@
 				else
 					field = parse_parameter(field, &trash, coderate_values);
 				break;
-			case 'H':
+				case 'H':																	/* H horizontal pol=0 */
 				pol = 0; 
 				*field++;
 				break;
@@ -711,7 +700,7 @@
 				else
 					field = parse_parameter(field, &trash, system_values);
 				break;
-			case 'V':
+				case 'V':																	/* V vertical pol=1 */
 				pol = 1; 
 				*field++;
 				break;
@@ -719,83 +708,72 @@
 				goto syntax_err;
 			}
 		}
-		/* default values for empty parameters */
-		if (fec == -1)
+			if (fec == -1)																	/* default values for empty parameters */
 			fec = FEC_AUTO;
-
 		if (modulation == -1)
 			modulation = QPSK;
-
 		if (delsys == -1)
 			delsys = SYS_DVBS;
-
 		if (rolloff == -1)
 			rolloff = ROLLOFF_35;
-
-		if (!(field = strsep(&tmp, ":")))
+			if (!(field = strsep(&tmp, ":")))										/* Nxt field */
 			goto syntax_err;
-
-		sat_no = strtoul(field, NULL, 0);
-
+			sat_no = strtoul(field, NULL, 0);										/* Sat no. */
 		if (!(field = strsep(&tmp, ":")))
 			goto syntax_err;
-
-		sr = strtoul(field, NULL, 0) * 1000;
-
+			sr = strtoul(field, NULL, 0) * 1000;									/* Symbol rate */
 		if (!(field = strsep(&tmp, ":")))
 			goto syntax_err;
-
-		vpid = strtoul(field, NULL, 0);
+			vpid = strtoul(field, NULL, 0);											/* vpid */
 		if (!vpid)
 			vpid = 0x1fff;
-
 		if (!(field = strsep(&tmp, ":")))
 			goto syntax_err;
-
 		p = strchr(field, ';');
-
 		if (p) {
-			*p = '\0';
-			p++;
+				*p = '\0'; p++;
 			if (bypass) {
 				if (!p || !*p)
 					goto syntax_err;
 				field = p;
 			}
 		}
-
-		apid = strtoul(field, NULL, 0);
+			apid = strtoul(field, NULL, 0);										/* apid */
 		if (!apid)
 			apid = 0x1fff;
-
 		tpid = -1;
-		if (use_vdr_format) {
+			if (use_vdr_format) {													/* VDR-Format */
 			if (!(field = strsep(&tmp, ":")))
 				goto syntax_err;
-
 			if (use_tpid)
-				tpid = strtoul(field, NULL, 0);
-
+					tpid = strtoul(field, NULL, 0);								/* VDR tpid */
 			if (!(field = strsep(&tmp, ":")))
 				goto syntax_err;
-
-			strtoul(field, NULL, 0);
+				strtoul(field, NULL, 0);											/* VDR discard one */
 		}
-
+			if (!(field = strsep(&tmp, ":")))
+				goto syntax_err;
+			sid = strtoul(field, NULL, 0);										/* sid */
 		if (!(field = strsep(&tmp, ":")))
 			goto syntax_err;
 
-		sid = strtoul(field, NULL, 0);
-
-		fclose(cfp);
+			if (use_vdr_format) {													/* VDR-Format S1/S2 */
 		if (params_debug){
 			printf("delivery 0x%x, ", delsys);
 		} else {
 			field = NULL;
 			map_to_user(delsys, system_values, &field);
-			printf("delivery %s, ", field);
+				}
+			} else {	
+				int api = strtoul(field, NULL, 0);								/* api 5/6 */
+//				printf("api= %3i ", api);
+				if (api==5) delsys=5;
+				else if (api==6) delsys=6;
+				else goto syntax_err;
+				
 		}
 
+			printf("Delivery %i, ", delsys);
 		if (params_debug){
 			printf("modulation 0x%x\n", modulation);	
 		} else {
@@ -828,15 +802,19 @@
 		ret = zap_to(adapter, frontend, demux, sat_no, freq * 1000,
 				pol, sr, vpid, apid, tpid, sid, dvr, rec_psi, bypass,
 				delsys, modulation, fec, rolloff, human_readable);
-
+			if (sequ && (runs++ < sequ)){
+				fprintf(stderr, "\nlok_errs=%i, runs=%i of sequ=%i, multi=%i, multi_max=%i\n",
+									lock_errs,runs,sequ,multi,multi_max);
+				chan_no++; 
+				delsys=-1;																/* Activate next individual setting */
+				continue;
+			}
+			fclose(cfp);
 		if (interactive)
 			goto again;
-
-		if (ret)
+			if (ret)																		/* On success */
 			return TRUE;
-
 		return FALSE;
-
 syntax_err:
 		fprintf(stderr, "syntax error in line %u: '%s'\n", line, buf);
 	} else if (ferror(cfp)) {
@@ -844,15 +822,14 @@
 		filename, errno);
 		fclose(cfp);
 		return FALSE;
-	} else
+	} else {
+		printf ("EOF !!!!!!\n");
 		break;
 	}
-
+	}
 	fclose(cfp);
-
 	if (!list_channels) {
 		fprintf(stderr, "channel not found\n");
-
 	if (!interactive)
 		return FALSE;
 	}
@@ -858,18 +835,9 @@
 	}
 	if (interactive)
 		goto again;
-
 	return TRUE;
 }
-
-static void handle_sigint(int sig)
-{
-	fprintf(stderr, "Interrupted by SIGINT!\n");
-	exit(2);
-}
-
-void
-bad_usage(char *pname, int prlnb)
+void bad_usage(char *pname, int prlnb)
 {
 	int i;
 	struct lnb_types_st *lnbp;
@@ -910,9 +876,9 @@
 	int modulation	= -1;
 	int fec		= -1;
 	int rolloff	= -1;
-	
 	lnb_type = *lnb_enum(0);
-	while ((opt = getopt(argc, argv, "M:C:O:HDVhqrpn:a:f:d:S:c:l:xibt")) != -1) {
+	
+	while ((opt = getopt(argc, argv, "M:C:O:HDVhqrpn:a:f:d:S:c:l:xibte:s:")) != -1) {
 		switch (opt) {
 		case '?':
 		case 'h':
@@ -981,6 +947,12 @@
 		case 't':
 			use_tpid = 1;
 			break;
+		case 'e':
+			sequ = strtoul(optarg, NULL, 0);
+			break;
+		case 's':
+			dis_seq = strtoul(optarg, NULL, 0);
+			break;
 		case 'i':
 			interactive = 1;
 			exit_after_tuning = 1;
@@ -1021,14 +993,13 @@
 	if (rec_psi)
 		dvr=1;
 
-	signal(SIGINT, handle_sigint);
-
-	if (!read_channels(chanfile, list_channels, chan_no, chan_name,
+	int retv = read_channels(chanfile, list_channels, chan_no, chan_name,
 	    adapter, frontend, demux, dvr, rec_psi, bypass, delsys,
 	    modulation, fec, rolloff, human_readable, params_debug,
-	    use_vdr_format, use_tpid))
-
-		return TRUE;
-
-	return FALSE;
+	    use_vdr_format, use_tpid);
+	printf("\nTOT: lok_errs =%i, runs=%i of sequ=%i, multi=%i, multi_max=%i\n",
+			 lock_errs,runs,sequ,multi,multi_max);
+	fprintf(stderr, "lok_errs =%i, runs=%i of sequ=%i, multi=%i, multi_max=%i\n",
+			 lock_errs,runs,sequ,multi,multi_max);
+	return retv;
 }

--Boundary-00=_vvdlM3B0ev+ewby
Content-Type: text/plain; charset="us-ascii"; name="Astra_only.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="Astra_only.txt"

Maennersache TV:12633:h:0:22000:222:322:12622:5
Bremen Eins:12265:h:0:27500:0:701:28448:5
BD 4:12148:h:0:27500:2047:2048:773:5
TNT Serie:12070:h:0:27500:2559:2560:50:5
Das Erste:11836:h:0:27500:101:102:28106:5
radio top40:12633:h:0:22000:0:353:12653:5
SR2 KulturRadio:12265:h:0:27500:0:911:28462:5
Hallmark:12304:h:0:27500:451:460:20308:5
Sky Cinema Hits:11719:h:0:27500:1023:1024:41:5
Cartoon Network (S):11875:h:0:27500:1279:1280:64:5
SAT.1 Bayern:12544:h:0:22000:255:256:17507:5
1LIVE diggi:12265:h:0:27500:0:1161:28481:5
KIRAKA:12265:h:0:27500:0:1171:28482:5
NDR 2:12265:h:0:27500:0:601:28437:5
Radio 1:12721:h:0:22000:0:928:12778:5
Disney Cinemagic HD:11023:h:0:22000:255:260:126:6
SWR 2:12265:h:0:27500:0:1021:28467:5
Travel:10920:h:0:22000:451:459:20348:5
SWR 4 RP:12265:h:0:27500:0:1051:28470:5
ORANGE CINE MAX HD:11170:h:0:22000:231:431:11031:6
HirTV:11670:h:0:22000:101:110:20354:5
Lustkanal.TV:12633:h:0:22000:206:306:12606:5
History HD:11875:h:0:27500:3071:3072:84:5
ORF2 W:12692:h:0:22000:500:501:13003:5
JML Shop:12148:h:0:27500:2303:2304:514:5
Sky Select 2:11797:h:0:27500:3327:3328:261:5
HBO2:11992:h:0:27500:151:160:20328:5
Rundum Sex TV:12633:h:0:22000:228:328:12628:5
=46EM3:11670:h:0:22000:301:310:20358:5
BELSAT TV:10861:h:0:22000:520:730:7108:5
ProSieben HD:11464:h:0:22000:511:515:61301:6
Beauty TV:12148:h:0:27500:3071:3072:54:5
Press TV:12460:h:0:27500:1279:1280:74:5
=46ilm1.2:12515:h:0:22000:514:104:4007:5
TA3:10920:h:0:22000:401:414:20347:5
Sky Select 3:11719:h:0:27500:2559:2560:271:5
ANIXE SD:12460:h:0:27500:3311:3312:764:5
RTL5:12343:h:0:27500:513:92:2005:5
DAS VIERTE:12460:h:0:27500:2047:2048:1793:5
RTL 1440:12343:h:0:27500:0:105:2052:5
Bel RTL:12343:h:0:27500:0:110:2081:5
VIJFtv:12721:h:0:22000:949:934:12784:5
Dreamgirls.TV:12633:h:0:22000:218:318:12618:5
Sky Sport 1:12031:h:0:27500:2047:2048:221:5
OE1:12662:h:0:22000:0:421:13121:5
ZDFtheaterkanal:11953:h:0:27500:1110:1120:28016:5
egoFM:12460:h:0:27500:0:384:172:5
Bayern 1:12265:h:0:27500:0:101:28400:5
RnB/Hip Hop:11758:h:0:27500:0:352:155:5
Bayerisches FS S=EF=BF=BDd:11836:h:0:27500:201:202:28107:5
Eurosport 2 HUN:12382:h:0:27500:751:760:20367:5
Viasat History:10920:h:0:22000:301:310:20345:5
Romance TV:11875:h:0:27500:1023:1024:63:5
Radio Horeb:12603:h:0:22000:0:1289:7289:5
Alpengl=EF=BF=BDhen TVX:12148:h:0:27500:255:256:70:5
VTM:12721:h:0:22000:941:921:12771:5
imusic TV:12460:h:0:27500:495:496:772:5
een:12721:h:0:22000:945:925:12775:5
WDR Duisburg:12603:h:0:22000:3301:3302:28537:5
Super RTL CH:12187:h:0:27500:172:145:12041:5
=46ilmmuzeum:12382:h:0:27500:601:610:20325:5
ORF1:12692:h:0:22000:160:161:13001:5
13th Street:12070:h:0:27500:767:768:42:5
Dr.Dish TV:12460:h:0:27500:255:256:73:5
OE2 T:12662:h:0:22000:0:428:13128:5
ORF1 HD:11302:h:0:22000:1920:1921:4911:6
CT24:12382:h:0:27500:151:161:20316:5
NED1:12515:h:0:22000:517:88:4011:5
VT4:12721:h:0:22000:943:923:12773:5
RTL7:12343:h:0:27500:518:90:2006:5
NL-3FM:12574:h:0:22000:0:233:5033:5
ARD-TEST-1:12109:h:0:27500:601:602:28221:5
WDR Bonn:12603:h:0:22000:3301:3302:28536:5
Disney Cinemagic:11719:h:0:27500:1279:1280:25:5
Supreme Master TV:12633:h:0:22000:234:334:12634:5
Kamasutra TV:12633:h:0:22000:227:327:12627:5
Sky Select 4:11719:h:0:27500:2815:2816:281:5
MDR KLASSIK:12265:h:0:27500:0:571:28435:5
TVP Historia:10861:h:0:22000:517:700:7105:5
MGM:11719:h:0:27500:511:512:515:5
MediaShop- Meine Einkaufswelt:12148:h:0:27500:1279:1280:775:5
Country:11758:h:0:27500:0:368:156:5
MEHRKANALTEST:12421:h:0:27500:0:2001:28397:5
hr-fernsehen:11836:h:0:27500:301:302:28108:5
Blue Movie 3:12070:h:0:27500:2815:2816:365:5
Bayern 2:12265:h:0:27500:0:111:28401:5
=46otohandy:12633:h:0:22000:224:324:12624:5
Sky Select 8:11758:h:0:27500:3327:3328:321:5
RTL FS:12187:h:0:27500:163:104:12006:5
hr4:12265:h:0:27500:0:431:28422:5
RTL Austria:12226:h:0:27500:201:202:28800:5
LT1-OOE:12662:h:0:22000:1040:1041:13104:5
Inselradio:12633:h:0:22000:0:702:12651:5
Petofi Radio - MR2:11670:h:0:22000:0:760:20451:5
NDR FS HH:12109:h:0:27500:2601:2602:28225:5
WDR 4:12265:h:0:27500:0:1131:28478:5
WDR Essen:12421:h:0:27500:101:102:28309:5
Servus TV HD:11302:h:0:22000:3583:3584:4913:6
NL-Radio 5:12574:h:0:22000:0:235:5035:5
Test2:11170:h:0:22000:202:0:11002:6
Mint:12343:h:0:27500:0:109:2080:5
Antenne Brandenburg:12265:h:0:27500:0:821:28454:5
WDR 3:12265:h:0:27500:0:1121:28477:5
ALL FUN TV:12662:h:0:22000:1030:1031:13103:5
HBO:11992:h:0:27500:251:261:20330:5
TVP Sport:10861:h:0:22000:515:680:7103:5
N24:12544:h:0:22000:1023:1024:17503:5
NatGeo HD:11875:h:0:27500:3071:3072:83:5
Sky News Intl:12603:h:0:22000:1290:2290:7290:5
kabel eins classics:12544:h:0:22000:1791:1792:17506:5
Boomerang:11875:h:0:27500:1791:1792:66:5
B5 plus:12265:h:0:27500:0:181:28408:5
Blue Movie 1:12070:h:0:27500:2047:2048:345:5
NL-Radio 2:12574:h:0:22000:0:232:5032:5
WDR Event:12265:h:0:27500:0:1181:28483:5
Eurosport:12226:h:0:27500:101:103:31200:5
Sky Cinema +24:11797:h:0:27500:2303:2304:43:5
JAMBA! TV:12460:h:0:27500:2303:2304:1794:5
MNM:12721:h:0:22000:0:930:12780:5
DRadio Wissen:11953:h:0:27500:0:410:28017:5
Date Line:12633:h:0:22000:223:323:12623:5
MTV AUSTRIA:12226:h:0:27500:515:662:28641:5
Radio neue Hoffnung:12603:h:0:22000:0:1292:7292:5
Einsfestival HD:12421:h:0:27500:1601:1602:28396:5
NDR Kultur:12265:h:0:27500:0:611:28438:5
WRN Deutsch:12633:h:0:22000:0:356:12656:5
JUMP:12265:h:0:27500:0:541:28432:5
HOPE Channel deutsch:12148:h:0:27500:511:512:71:5
CFN/RFC:12603:h:0:22000:0:1291:7291:5
ORANGE CINE NOVO:11170:h:0:22000:205:305:11005:6
SEX-Kontakte:12633:h:0:22000:226:326:12626:5
Sky Select 7:11758:h:0:27500:3071:3072:311:5
Heimatkanal:11758:h:0:27500:1535:1536:22:5
Discovery HD:11875:h:0:27500:3071:3072:79:5
Nickelodeon/Comedy Central:12515:h:0:22000:520:98:4014:5
TV Paprika:11992:h:0:27500:351:360:20332:5
NET5:12574:h:0:22000:513:100:5004:5
planet radio:12633:h:0:22000:0:1030:12661:5
hr1:12265:h:0:27500:0:401:28419:5
SIXX:12460:h:0:27500:767:768:776:5
TVP HD:10861:h:0:22000:532:851:7120:5
Bayerisches FS Nord:11836:h:0:27500:201:202:28110:5
Etalage Kanaal:12574:h:0:22000:521:108:5029:5
arte:10743:h:0:22000:401:402:28724:5
Man-X:12721:h:0:22000:940:924:12788:5
Vitaya:12721:h:0:22000:947:927:12777:5
KidsCo:11170:h:0:22000:209:309:11009:6
WDR K=EF=BF=BDln:11836:h:0:27500:601:602:28111:5
National Geographic:12304:h:0:27500:351:360:20306:5
VOX Austria:12226:h:0:27500:301:302:28805:5
deko:11992:h:0:27500:501:510:20335:5
3sat:11953:h:0:27500:210:220:28007:5
Spass im TV:12662:h:0:22000:1080:1081:13108:5
MDR S-Anhalt:12109:h:0:27500:2901:2902:28229:5
HSE24 EXTRA:12226:h:0:27500:512:660:31210:5
TV Markiza:12382:h:0:27500:301:314:20319:5
tv.gusto:12460:h:0:27500:3071:3072:659:5
U1 Tirol:12662:h:0:22000:0:436:13136:5
RTL HB NDS:12187:h:0:27500:163:104:12005:5
Sky Select 1:11797:h:0:27500:3071:3072:251:5
OE2 V:12662:h:0:22000:0:429:13129:5
NGC:12515:h:0:22000:523:116:4015:5
N-JOY:12265:h:0:27500:0:631:28440:5
ORANGE SPORT HD:11170:h:0:22000:230:330:11030:6
ORF2 V:12692:h:0:22000:500:501:13009:5
BR Verkehr:12265:h:0:27500:0:171:28407:5
Sky Sport Austria:12148:h:0:27500:2559:2560:53:5
RTL HH SH:12187:h:0:27500:163:104:12004:5
OE2 St:12662:h:0:22000:0:430:13130:5
Disney XD:11758:h:0:27500:1279:1280:28:5
MDR Sachsen:12109:h:0:27500:2901:2902:28228:5
Classic FM:12515:h:0:22000:0:118:4040:5
SR3 Saarlandwelle:12265:h:0:27500:0:921:28463:5
NDR Info Spez.:12265:h:0:27500:0:681:28445:5
Junior:11758:h:0:27500:255:256:19:5
Duna TV:11992:h:0:27500:301:310:20331:5
Cartoon/TCM:12343:h:0:27500:520:116:2030:5
ZDF:11953:h:0:27500:110:120:28006:5
TV TRWAM:10861:h:0:22000:519:720:7107:5
ServusTV:12662:h:0:22000:2110:2111:13111:5
SWR Fernsehen RP:12109:h:0:27500:3101:3102:28231:5
Sky Select 9:11758:h:0:27500:3583:3584:331:5
Inforadio:12265:h:0:27500:0:801:28452:5
NL-Radio 6:12574:h:0:22000:0:228:5080:5
dhd24 plus:12633:h:0:22000:236:336:12636:5
WDR M=EF=BF=BDnster:12421:h:0:27500:101:102:28310:5
Sky Action:11797:h:0:27500:767:768:9:5
Rock Hymnen:11758:h:0:27500:0:288:151:5
ROCK ANTENNE:12148:h:0:27500:0:304:160:5
YOU FM:12265:h:0:27500:0:451:28423:5
TV Barrandov:12382:h:0:27500:551:561:20324:5
MDR1 TH=EF=BF=BDRINGEN:12265:h:0:27500:0:521:28430:5
AXN Action:11875:h:0:27500:767:768:62:5
RTL Television:12187:h:0:27500:163:104:12003:5
ORF2E:12692:h:0:22000:170:171:13014:5
NOVA Cinema:12382:h:0:27500:201:211:20317:5
NatGeo Wild:12031:h:0:27500:511:512:12:5
Sky Cinema Hits HD:10773:h:0:22000:767:772:124:6
Sky Cinema:11797:h:0:27500:511:512:10:5
WDR Dortmund:12421:h:0:27500:101:102:28307:5
Radio Regenbogen:12633:h:0:22000:0:363:12663:5
RADIO MARIA:12662:h:0:22000:0:440:13140:5
NED3:12515:h:0:22000:519:96:4013:5
ORANGE SPORT INFO:11170:h:0:22000:208:308:11008:6
zdf_neo:11953:h:0:27500:660:670:28014:5
Echo TV:11992:h:0:27500:101:110:20327:5
RNW2:12574:h:0:22000:0:226:5061:5
1LIVE:12265:h:0:27500:0:1101:28475:5
NDR 90,3:12265:h:0:27500:0:641:28441:5
TV2 :11670:h:0:22000:551:560:20363:5
Channel 21:12187:h:0:27500:168:137:12080:5
National Geographic:12031:h:0:27500:3327:3328:13:5
rbb Brandenburg:12109:h:0:27500:601:602:28205:5
Sport1:12515:h:0:22000:513:84:4006:5
9Live:12544:h:0:22000:1279:1280:17504:5
Klara:12721:h:0:22000:0:932:12782:5
NL-Radio 1:12574:h:0:22000:0:231:5031:5
80er/90er:11758:h:0:27500:0:336:154:5
ORF2 B:12692:h:0:22000:500:501:13005:5
NDR1WelleNord:12265:h:0:27500:0:651:28442:5
Ketnet/Canvas:12721:h:0:22000:946:926:12776:5
VOX HD:10832:h:0:22000:511:515:61201:6
Disney Channel:12304:h:0:27500:301:310:20305:5
2BE:12721:h:0:22000:942:922:12772:5
TVP INFO:10861:h:0:22000:514:670:7102:5
Erotik 24:12633:h:0:22000:212:312:12612:5
Sky Cinema Hits HD:11875:h:0:27500:3071:3072:87:5
Das Erotische TV:12633:h:0:22000:230:330:12630:5
Nostalgie:12721:h:0:22000:0:939:12789:5
WDR 5:12265:h:0:27500:0:1141:28479:5
Kinowelt TV:11875:h:0:27500:255:256:60:5
123Damenwahl:12633:h:0:22000:220:320:12620:5
Viasat Explorer:10920:h:0:22000:251:260:20344:5
OE2 N:12662:h:0:22000:0:424:13124:5
NDR 1 Nieders.:12265:h:0:27500:0:671:28444:5
KiKa:11953:h:0:27500:310:320:28008:5
EinsExtra:10743:h:0:22000:101:102:28721:5
vtmKazoom:12721:h:0:22000:950:935:12785:5
TV JOJ:12382:h:0:27500:351:364:20320:5
TVP1:10861:h:0:22000:512:650:7100:5
AXN:10920:h:0:22000:651:660:20352:5
Sat.1 Comedy:12544:h:0:22000:1535:1536:17505:5
HOPE Channel Radio:12460:h:0:27500:0:400:175:5
Kossuth Radio - MR1:11670:h:0:22000:0:810:20452:5
BR-alpha:12265:h:0:27500:1401:1402:28487:5
domradio:12460:h:0:27500:0:368:171:5
SPORT1 HD DEMO:10832:h:0:22000:1279:1280:61204:6
EuroNews:12226:h:0:27500:2432:2433:31220:5
ORANGE CINE GEANTS:11170:h:0:22000:206:306:11006:6
OE3:12662:h:0:22000:0:433:13133:5
Sport 1 CZE :11670:h:0:22000:601:611:20364:5
RTL HD:10832:h:0:22000:255:259:61200:6
STV1:10920:h:0:22000:351:364:20346:5
Discovery:12343:h:0:27500:515:88:2015:5
ZDFinfokanal:11953:h:0:27500:610:620:28011:5
OE2 S:12662:h:0:22000:0:427:13127:5
MDR INFO:12265:h:0:27500:0:561:28434:5
Minimax / Animax:11992:h:0:27500:651:660:20338:5
kabel eins:12544:h:0:22000:767:768:17502:5
Classic21:12343:h:0:27500:0:136:2086:5
kabel eins HD:11464:h:0:22000:767:771:61302:6
Disney Channel:11758:h:0:27500:2559:2560:34:5
ORF2 St:12692:h:0:22000:500:501:13010:5
KINK FM:12574:h:0:22000:0:220:5055:5
BAYERN plus:12265:h:0:27500:0:151:28405:5
Arrow Classic Rock:12574:h:0:22000:0:222:5050:5
bebe tv:10920:h:0:22000:551:564:20350:5
Prima TV:12382:h:0:27500:501:511:20323:5
CT2:12382:h:0:27500:251:261:20318:5
SR Fernsehen:12265:h:0:27500:1301:1302:28486:5
arte HD:11361:h:0:22000:6210:6221:11120:6
SWR 4 BW:12265:h:0:27500:0:1041:28469:5
GoTV:12662:h:0:22000:1020:1021:13102:5
Arrow Jazz:12574:h:0:22000:0:221:5051:5
RTL Klub:11670:h:0:22000:351:360:20359:5
RNW3:12574:h:0:22000:0:240:5062:5
Acht:12721:h:0:22000:944:938:12790:5
Klassik Radio:12460:h:0:27500:0:336:173:5
=46ilm1.3:12574:h:0:22000:519:86:5028:5
Radio Gloria:12633:h:0:22000:0:359:12659:5
Radio Bremen TV:12421:h:0:27500:1201:1202:28385:5
Sky Cinema +1:11797:h:0:27500:1791:1792:11:5
BR-KLASSIK:12265:h:0:27500:0:131:28403:5
Radio538:12574:h:0:22000:0:230:5072:5
Bremen Vier:12265:h:0:27500:0:721:28450:5
Studio Brussel:12721:h:0:22000:0:931:12781:5
ANTENNE BAYERN:12148:h:0:27500:0:352:170:5
SexySat:12633:h:0:22000:221:321:12621:5
NOVA SPORT:12304:h:0:27500:101:111:20301:5
ORF2 O:12692:h:0:22000:500:501:13006:5
Sky Radio:12574:h:0:22000:0:227:5070:5
SBS6:12574:h:0:22000:514:80:5005:5
Radio 2:12721:h:0:22000:0:929:12779:5
EinsPlus:10743:h:0:22000:301:302:28723:5
BAYERN 3:12265:h:0:27500:0:121:28402:5
SWR cont.ra:12265:h:0:27500:0:1071:28472:5
RTL2:12187:h:0:27500:166:128:12020:5
JOEfm:12721:h:0:22000:0:937:12787:5
Erotik Sat:12633:h:0:22000:219:319:12619:5
Sky Sport 2:12031:h:0:27500:2303:2304:222:5
Comedy Central:10920:h:0:22000:601:610:20351:5
Sky Nostalgie:11719:h:0:27500:1535:1536:516:5
OE2 O:12662:h:0:22000:0:426:13126:5
Cinemax:11670:h:0:22000:251:260:20357:5
Radio Paloma:12633:h:0:22000:0:355:12655:5
NL-Radio 4:12574:h:0:22000:0:234:5034:5
Sport 2:11992:h:0:27500:701:710:20339:5
Cartoon Network/TCM:10920:h:0:22000:101:110:20341:5
Preisfuchs TV:12633:h:0:22000:233:333:12633:5
MGM:10920:h:0:22000:501:510:20349:5
CT4 Sport:12382:h:0:27500:651:661:20326:5
Pure FM:12343:h:0:27500:0:135:2085:5
Kulturradio:12265:h:0:27500:0:811:28453:5
Super RTL A:12226:h:0:27500:501:502:28815:5
Disney Cinemagic HD:11875:h:0:27500:3071:3072:82:5
Playhouse Disney:11758:h:0:27500:2047:2048:26:5
Radio Veronica:12574:h:0:22000:0:239:5095:5
Cool:11992:h:0:27500:451:460:20334:5
Sky Sport HD 2:11875:h:0:27500:3071:3072:85:5
ORF2 S:12692:h:0:22000:500:501:13007:5
RV info:12343:h:0:27500:0:100:2070:5
TMF:12574:h:0:22000:516:88:5015:5
Sport Klub:11670:h:0:22000:451:460:20361:5
radioeins:12265:h:0:27500:0:841:28456:5
JAM FM:12460:h:0:27500:0:528:177:5
DKULTUR:11953:h:0:27500:0:710:28012:5
Goldstar TV:11758:h:0:27500:767:768:518:5
Spektrum:11670:h:0:22000:401:410:20360:5
MDR Th=EF=BF=BDringen:12109:h:0:27500:2901:2902:28230:5
Radio Contact:12343:h:0:27500:0:111:2082:5
La Premiere:12343:h:0:27500:0:139:2089:5
Eredivisielive 1:12574:h:0:22000:517:104:5030:5
HBO:11992:h:0:27500:201:210:20329:5
m2:11992:h:0:27500:601:610:20337:5
AKTIV DIREKT TV:12662:h:0:22000:1050:1051:13112:5
60er/70er:11758:h:0:27500:0:320:153:5
NDR FS SH:12109:h:0:27500:2601:2602:28227:5
TNT Film (TCM):11875:h:0:27500:511:512:61:5
Q-music:12721:h:0:22000:0:936:12786:5
Einsfestival:10743:h:0:22000:201:202:28722:5
MTV Hungary:11670:h:0:22000:201:212:20356:5
MDR1 SA-ANHALT:12265:h:0:27500:0:511:28429:5
Radio Vlaanderen:12343:h:0:27500:0:101:2075:5
Sky Sport HD 2:10773:h:0:22000:255:260:122:6
BVN:12574:h:0:22000:515:96:5025:5
Spiegel Geschichte:12031:h:0:27500:1023:1024:52:5
LoveSongs:11758:h:0:27500:0:304:152:5
SWR 3:12265:h:0:27500:0:1031:28468:5
CT1:12382:h:0:27500:101:111:20315:5
Viasat 3:10920:h:0:22000:151:160:20342:5
Nordwestradio:12265:h:0:27500:0:711:28449:5
NDR FS MV:12109:h:0:27500:2601:2602:28224:5
Animal Planet:12304:h:0:27500:151:160:20302:5
Sky Action HD:10773:h:0:22000:511:516:123:6
RTL4:12343:h:0:27500:512:80:2004:5
TV FESTIVAL:11170:h:0:22000:210:310:11010:6
Magyar ATV:11992:h:0:27500:401:410:20333:5
ESPN America:12662:h:0:22000:1090:1091:13109:5
Eurosport  2:12382:h:0:27500:701:712:20366:5
OE2 W:12662:h:0:22000:0:423:13123:5
RNW1:12574:h:0:22000:0:225:5060:5
MDR1 SACHSEN:12265:h:0:27500:0:501:28428:5
Sky Bundesliga:12031:h:0:27500:767:768:223:5
WDR Siegen:12421:h:0:27500:101:102:28311:5
=46unX:12515:h:0:22000:0:120:4035:5
Deutsche Girls 2:12633:h:0:22000:215:315:12615:5
NDR 1 Radio MV:12265:h:0:27500:0:661:28443:5
WDR 2:12265:h:0:27500:0:1111:28476:5
Sky Sport HD 1:11914:h:0:27500:767:772:129:6
WDR Bielefeld:12421:h:0:27500:101:102:28306:5
DLF:11953:h:0:27500:0:810:28013:5
MDR FIGARO:12265:h:0:27500:0:531:28431:5
ERF Radio:12148:h:0:27500:0:320:161:5
rbb Berlin:12109:h:0:27500:601:602:28206:5
m1 :11670:h:0:22000:151:160:20355:5
538 Juize:12574:h:0:22000:0:229:5071:5
NDR Info:12265:h:0:27500:0:621:28439:5
ORANGE CINE CHOC:11170:h:0:22000:204:304:11004:6
SAT.1 NRW:12544:h:0:22000:255:256:17508:5
sportdigital:11875:h:0:27500:2559:2560:69:5
rhein main tv:12633:h:0:22000:208:308:12614:5
ffn digital:12633:h:0:22000:0:354:12654:5
Bizarr24:12633:h:0:22000:235:335:12635:5
Sky Sport Info:11719:h:0:27500:255:256:17:5
=46ilm+:11992:h:0:27500:751:760:20340:5
DORCEL TV:12343:h:0:27500:522:124:2045:5
XXX Xtreme:12382:h:0:27500:451:462:20322:5
Discovery Channel:12031:h:0:27500:3071:3072:14:5
YAVIDO:12148:h:0:27500:239:240:765:5
WDR D=EF=BF=BDsseldorf:12421:h:0:27500:101:102:28308:5
RNF:12148:h:0:27500:1104:1105:768:5
ORF2 N:12692:h:0:22000:500:501:13004:5
n-tv:12187:h:0:27500:169:73:12090:5
Phoenix:10743:h:0:22000:501:502:28725:5
DASDING:12265:h:0:27500:0:1061:28471:5
WDR Aachen:12603:h:0:22000:3301:3302:28534:5
TV Nova:12382:h:0:27500:401:411:20321:5
NED2:12515:h:0:22000:518:92:4012:5
Das Erste HD:11361:h:0:22000:6010:6020:11100:6
ProSieben:12544:h:0:22000:511:512:17501:5
Sky Comedy:11797:h:0:27500:2559:2560:8:5
Sport HD:11875:h:0:27500:3071:3072:78:5
SR1 Europawelle:12265:h:0:27500:0:901:28461:5
RTL RADIO:12343:h:0:27500:0:104:2051:5
=46ilm1.1:12515:h:0:22000:512:80:4005:5
RTL Crime:12070:h:0:27500:1791:1792:27:5
Test1:11170:h:0:22000:201:0:11001:6
Mobile Sex:12633:h:0:22000:225:325:12625:5
JIM:12721:h:0:22000:948:933:12783:5
ORF2 HD:11302:h:0:22000:2920:2921:4912:6
TV Oranje:12343:h:0:27500:516:84:2010:5
VOX:12187:h:0:27500:167:136:12060:5
Veronica/DisneyXD:12574:h:0:22000:518:92:5020:5
dhd24.tv:12633:h:0:22000:53:54:12604:5
Sky Select:12031:h:0:27500:2815:2816:18:5
Radio Maryja:10861:h:0:22000:0:637:7207:5
OE2 B:12662:h:0:22000:0:425:13125:5
ZDF HD:11361:h:0:22000:6110:6120:11110:6
Sky Cinema HD:11914:h:0:27500:1279:1284:131:6
Super RTL:12187:h:0:27500:165:120:12040:5
B5 aktuell:12265:h:0:27500:0:141:28404:5
harmony.fm:12633:h:0:22000:0:1036:12662:5
hr-iNFO:12265:h:0:27500:0:461:28424:5
ESPN America (S):12662:h:0:22000:1090:1091:13105:5
Sport 1:11992:h:0:27500:551:560:20336:5
ERF eins:12460:h:0:27500:511:512:48:5
NICK AUSTRIA:12226:h:0:27500:513:661:28640:5
Channel 21:12187:h:0:27500:168:137:12095:5
Boomerang:10920:h:0:22000:201:210:20343:5
AUSTRIA 9 TV:12662:h:0:22000:1060:1061:13106:5
ORANGE CINE HAPPY:11170:h:0:22000:203:303:11003:6
ASTRA HD:10832:h:0:22000:1023:1027:61203:6
Motorvision TV:12070:h:0:27500:1023:1024:168:5
Visit-X.TV:12662:h:0:22000:1070:1071:13107:5
Sky Select 5:11719:h:0:27500:3071:3072:291:5
Blue Movie:12031:h:0:27500:1279:1280:513:5
=46ilm+ :11670:h:0:22000:501:511:20362:5
VivaCite:12343:h:0:27500:0:137:2087:5
SciFi:11758:h:0:27500:1023:1024:36:5
Channel21 Express:12148:h:0:27500:1023:1024:769:5
History HD:11023:h:0:22000:767:772:128:6
SWR 1 BW:12265:h:0:27500:0:1001:28465:5
Extreme Sports:12304:h:0:27500:601:610:20311:5
HITRADIO OE3:12692:h:0:22000:130:131:13013:5
NatGeo HD:11023:h:0:22000:511:516:127:6
K-TV:12633:h:0:22000:202:302:12601:5
Cinema HD:11875:h:0:27500:3071:3072:80:5
Bartok Radio - MR3:11670:h:0:22000:0:710:20450:5
HIT RADIO FFH:12633:h:0:22000:0:1024:12660:5
Juwelo TV:12633:h:0:22000:1041:1042:12616:5
VOX CH:12187:h:0:27500:173:146:12061:5
TV Polonia:10861:h:0:22000:516:690:7104:5
Hustler TV:12304:h:0:27500:501:512:20309:5
RTL Passion:12070:h:0:27500:255:256:29:5
BunnyClub24:12633:h:0:22000:240:340:12640:5
1-2-3.tv:12460:h:0:27500:2815:2816:662:5
TW1:12662:h:0:22000:1010:1011:13101:5
ORF2 T:12692:h:0:22000:500:501:13008:5
Test-R:10743:h:0:22000:401:402:28726:5
SWR Fernsehen BW:11836:h:0:27500:801:802:28113:5
ORF2:12692:h:0:22000:500:501:13002:5
SWR 1 RP:12265:h:0:27500:0:1011:28466:5
Q-Music:12515:h:0:22000:0:114:4045:5
MGM:12574:h:0:22000:512:102:5023:5
WDR Test A:12421:h:0:27500:101:102:28395:5
GOD Channel:12148:h:0:27500:767:768:774:5
=46M4:12662:h:0:22000:0:434:13134:5
ATV:12692:h:0:22000:506:507:13012:5
Discovery Channel:12304:h:0:27500:201:210:20303:5
Musiq 3:12343:h:0:27500:0:138:2088:5
hr2:12265:h:0:27500:0:411:28420:5
sunshine live:12148:h:0:27500:0:336:169:5
Sky Emotion:11797:h:0:27500:2815:2816:20:5
Boing:11170:h:0:22000:207:307:11007:6
Viva TV:11670:h:0:22000:651:662:20365:5
Clipmobile:12633:h:0:22000:241:341:12641:5
NDR FS NDS:12109:h:0:27500:2601:2602:28226:5
Deutsche Charts:11758:h:0:27500:0:272:150:5
=46ritz:12265:h:0:27500:0:851:28457:5
SAT.1 HD:11464:h:0:22000:255:259:61300:6
Animal Planet:12343:h:0:27500:514:96:2020:5
Blue Movie 2:12070:h:0:27500:2303:2304:355:5
Radio10Gold:12574:h:0:22000:0:236:5085:5
TVP2:10861:h:0:22000:513:660:7101:5
Zone Reality:12304:h:0:27500:551:560:20310:5
WDR Funkhaus Europa:12265:h:0:27500:0:1151:28480:5
TVP Kultura:10861:h:0:22000:518:710:7106:5
WDR Wuppertal:12603:h:0:22000:3301:3302:28535:5
Eurosport HD:11914:h:0:27500:1535:1539:132:6
HBO Comedy:12304:h:0:27500:401:410:20307:5
SAT.1:12544:h:0:22000:255:256:17500:5
Traumgirls.TV:12633:h:0:22000:229:329:12629:5
radioBERLIN 88,8:12265:h:0:27500:0:831:28455:5
Sky Select 6:11719:h:0:27500:767:768:301:5
=46ox Serie:12070:h:0:27500:1279:1280:16:5
on3-radio:12265:h:0:27500:0:161:28406:5
EROTIKA TV - NEU!:12633:h:0:22000:239:339:12639:5
Eurosport HD:11875:h:0:27500:3071:3072:81:5
Daystar Television Network:12460:h:0:27500:3567:3568:658:5
Discovery HD:11914:h:0:27500:1023:1027:130:6
Hallmark:12343:h:0:27500:523:118:2041:5
Kanaal Z:12721:h:0:22000:919:920:12792:5
ORF2 K:12692:h:0:22000:500:501:13011:5
MDR SPUTNIK:12265:h:0:27500:0:551:28433:5
EUROSPORT:12343:h:0:27500:517:112:2025:5
History:11875:h:0:27500:2303:2304:68:5
OE2 K:12662:h:0:22000:0:431:13131:5
hr3:12265:h:0:27500:0:421:28421:5
RTL2 Austria:12226:h:0:27500:401:402:28810:5
Sky Krimi:12070:h:0:27500:511:512:23:5
RTL8:12343:h:0:27500:519:108:2035:5
Sky Action HD:11875:h:0:27500:3071:3072:86:5
JimJam:12304:h:0:27500:251:260:20304:5
VH1:11739:v:0:27500:3061:3062:28656:5
NICKELODEON France.:11739:v:0:27500:3081:3082:28658:5
=46R3 AMIENS:12699:v:0:22000:160:80:9701:5
C+ DEPORTES:10876:v:0:22000:172:128:30621:5
CUATRO:10979:v:0:22000:173:132:30663:5
NATIONAL GEO HD:12363:v:0:27500:2047:0:9103:5
RedeRecord:11508:v:0:22000:710:730:7010:5
SAT Erotiktreff.TV:12246:v:0:27500:719:720:10166:5
C+COMEDIA HD:10847:v:0:22000:175:0:30114:5
BEUR FM:12207:v:0:27500:0:1945:8558:5
toute L'HISTOIRE:12285:v:0:27500:166:104:17026:5
CANAL SUR RADIO:11597:v:0:22000:0:2001:10074:5
CANAL+ 3D:10847:v:0:22000:175:0:30112:5
NOSTALGIE:12207:v:0:27500:0:246:8533:5
LokalSAT:12246:v:0:27500:1535:1536:10105:5
C+ ACCI=EF=BF=BDN:11317:v:0:22000:162:88:29810:5
=46R3 REIMS:12728:v:0:22000:166:104:9807:5
TAQUILLA XX:11097:v:0:22000:164:96:30057:5
13EME RUE HD:12580:v:0:22000:161:86:9302:6
=46RANCE 2 HD:12522:v:0:22000:162:90:9203:6
[03a-76c1]:11038:v:0:22000:161:84:30401:5
TAQUILLA 4:10788:v:0:22000:167:108:30353:5
A LA CARTE:12012:v:0:27500:168:112:8810:5
MOSAIQUE:12324:v:0:27500:162:1904:8624:5
EXTREME SPORTS:12168:v:0:27500:167:108:9508:5
MTV BASE FRANCE:11739:v:0:27500:3111:3112:28661:5
C+ DCINE:11317:v:0:22000:170:120:29806:5
CANAL COCINA:11038:v:0:22000:169:116:30414:5
A LA CARTE 12:12207:v:0:27500:170:120:8515:5
=46R3 CAEN:12728:v:0:22000:160:80:9801:5
[00c-75aa]:10847:v:0:22000:163:400:30122:5
RADIOS 2:12207:v:0:27500:0:251:8510:5
PMU sur Canal+:11856:v:0:27500:160:80:8210:5
JAZZ RADIO:12207:v:0:27500:0:254:8535:5
DT5:12363:v:0:27500:162:108:9154:5
MEZZO LIVEHD:11626:v:0:22000:160:80:30700:6
TMC:11934:v:0:27500:161:84:8152:5
VH1 Classic.:11739:v:0:27500:3071:3072:28667:5
PIWI:12168:v:0:27500:166:104:9507:5
[042-7737]:11156:v:0:22000:172:128:30519:5
Cartoon Network (a/S):12441:v:0:27500:2040:2041:13204:5
SPORT+:11817:v:0:27500:168:112:8009:5
SAT.1 A:12051:v:0:27500:800:801:20005:5
=46RENCH LOVER:11479:v:0:22000:166:104:6407:5
Playboy TV (a):12441:v:0:27500:2110:0:13210:5
ANIMAUX:12285:v:0:27500:162:88:17022:5
ARTE HD:12580:v:0:22000:163:95:9304:6
P*rnMe.TV:12246:v:0:27500:463:464:10165:5
[016-759a]:10847:v:0:22000:0:257:30106:5
[071-2165]:12207:v:0:27500:0:250:8549:5
MULTI-X (3):11097:v:0:22000:176:144:30066:5
=46RANCE 2 HD:12363:v:0:27500:2047:0:9128:5
=46R3 PARIS:12699:v:0:22000:165:100:9706:5
A LA CARTE 3:12129:v:0:27500:163:92:8404:5
TF1:11895:v:0:27500:171:124:8371:5
=46R3 RENNES:12699:v:0:22000:166:104:9707:5
MCM POP:11895:v:0:27500:164:96:8354:5
RIRE & CHANSONS:12207:v:0:27500:0:1913:8529:5
SEASONS:11817:v:0:27500:160:80:8001:5
Yes Italia:12246:v:0:27500:4351:4352:10113:5
VIVA Germany:11973:v:0:27500:4061:4062:28676:5
TV GALICIA:11508:v:0:22000:718:738:7018:5
MOSAIQUE C+:12324:v:0:27500:170:1891:8640:5
=46R3 TOULOUSE:12699:v:0:22000:171:124:9712:5
TAQUILLA X:10788:v:0:22000:174:136:30359:5
GU=EF=BF=BDA DIGITAL+:10847:v:0:22000:163:400:30121:5
BRAVA HD:12669:v:0:22000:163:94:9904:6
ANDALUCIA TV:11597:v:0:22000:1601:1602:10070:5
[024-75ce]:10847:v:0:22000:163:400:30158:5
AXN:11317:v:0:22000:171:124:29815:5
MOSA 2:12324:v:0:27500:163:1921:8642:5
BFM:12207:v:0:27500:0:1918:8534:5
C+ ACCI=EF=BF=BDN:11317:v:0:22000:162:88:29804:5
JIMMY:11817:v:0:27500:165:100:8006:5
NICK/COMEDY:11973:v:0:27500:4101:4102:28680:5
eUrotic:12551:v:0:22000:460:470:12123:5
[040-756c]:11097:v:0:22000:173:132:30060:5
Beate Uhse Sexy Sat:12246:v:0:27500:1759:1760:10155:5
Hot Girls TV:12246:v:0:27500:751:752:10116:5
[00f-75a6]:10847:v:0:22000:0:264:30118:5
m=EF=BF=BDnchen.tv/RFO:12246:v:0:27500:1791:1792:10106:5
MCE:12551:v:0:22000:101:102:12130:5
Liebesgl=EF=BF=BDck.TV:12246:v:0:27500:479:480:10150:5
Bloomberg Europe TV:11597:v:0:22000:1360:1320:10067:5
MULTIPANT.6:11097:v:0:22000:4010:4011:30068:5
C+ DEMANDE:12363:v:0:27500:2047:0:9105:5
TELE 5:12480:v:0:27500:1535:1536:51:5
PENTHOUSE HD:12669:v:0:22000:164:98:9925:6
CANALSAT RADIOS:12207:v:0:27500:0:1911:8507:5
=46R3 GRENOBLE:12728:v:0:22000:167:108:9808:5
DMAX:12246:v:0:27500:511:512:10101:5
MOSAIQUE:12324:v:0:27500:162:1901:8641:5
DISNEY CH.:11038:v:0:22000:163:92:30403:5
BFM TV:12551:v:0:22000:2171:2172:12171:5
HISTORIA:11156:v:0:22000:171:124:30513:5
Direct 8:11538:v:0:22000:601:621:6911:5
=46RANCE =EF=BF=BD:12012:v:0:27500:166:104:8807:5
CANAL+ SPORT HD:12610:v:0:22000:170:123:9621:5
PENTHOUSE HD:12669:v:0:22000:164:98:9905:6
TIJI:11934:v:0:27500:170:120:8162:5
RFI MULTILINGUE:12207:v:0:27500:0:1947:8560:5
A LA CARTE 11:12012:v:0:27500:171:124:8804:5
C CINEMA STAR:12090:v:0:27500:164:96:9405:5
Direct 8:11538:v:0:22000:601:621:6901:5
Elette:11597:v:0:22000:2201:2202:10075:5
13EME RUE HD:12363:v:0:27500:2047:0:9116:5
DT20:12363:v:0:27500:0:1992:9169:5
CANAL+ HD:12363:v:0:27500:2047:0:9102:5
MULTIPANT.2:10788:v:0:22000:166:104:30365:5
RADIO CLASSIQUE:12207:v:0:27500:0:1909:8525:5
[047-7476]:11317:v:0:22000:166:104:29814:5
L'EQUIPE TV:12402:v:0:27500:165:100:8706:5
CHERIE FM:12207:v:0:27500:0:249:8548:5
GULLI:12012:v:0:27500:167:108:8808:5
CNBC Europe:11597:v:0:22000:307:308:10030:5
C+ DCINE HD:10817:v:0:22000:164:107:29954:6
=46R3 NANTES:12728:v:0:22000:161:84:9802:5
MULTIPANT.3:10788:v:0:22000:169:116:30364:5
ACHTUNG Erotik.TV:12246:v:0:27500:4063:4064:10164:5
MediaShop- Neuheiten:12480:v:0:27500:255:256:898:5
A LA CARTE 10:12012:v:0:27500:170:120:8811:5
TV5MONDE:11479:v:0:22000:160:80:6401:5
C+ DCINE HD:10847:v:0:22000:175:0:30181:5
Nick Jr France:11973:v:0:27500:4071:4072:28677:5
HSE24:12480:v:0:27500:1279:1280:40:5
[018-75f4]:10847:v:0:22000:163:400:30196:5
S3X Girls:12246:v:0:27500:2287:2288:10122:5
RADIO 3:12207:v:0:27500:0:236:8583:5
MOSA 3:12324:v:0:27500:164:1941:8605:5
=2E.:12246:v:0:27500:2815:0:10110:5
SAT.1 HH/SH:12051:v:0:27500:2047:2048:20008:5
A LA CARTE 2:12129:v:0:27500:162:88:8403:5
CDN12:12324:v:0:27500:0:2046:8616:5
[032-7788]:10876:v:0:22000:165:100:30600:5
Cubavision Internacional:11508:v:0:22000:708:728:7008:5
USHUAIA TV HD:12669:v:0:22000:160:80:9921:6
ADO:12207:v:0:27500:0:253:8552:5
TAQUILLA 7:11097:v:0:22000:168:112:30055:5
Telegirls TV:12246:v:0:27500:991:2272:10157:5
MOSA 3:12324:v:0:27500:164:1941:8643:5
OUI FM:12207:v:0:27500:0:252:8551:5
A LA CARTE 5:12129:v:0:27500:165:100:8406:5
DISNEY MAGIC HD:12580:v:0:22000:162:91:9323:6
Kabel 1 Austria:12051:v:0:27500:166:167:20004:5
SERIE CLUB:12090:v:0:27500:161:84:9402:5
OLTV:12207:v:0:27500:171:124:8517:5
Telesur:11538:v:0:22000:612:632:6912:5
QVC PLUS:12551:v:0:22000:168:144:3394:5
NRJ 12:11817:v:0:27500:163:92:8004:5
RF:12207:v:0:27500:0:1906:8518:5
RADIO NOTRE-DAME:12207:v:0:27500:0:1942:8555:5
MULTIDEPORTE:10788:v:0:22000:172:82:30354:5
C CINEMA CLASSIC:12402:v:0:27500:168:112:8709:5
SYFY UNIVERSAL:11934:v:0:27500:163:92:8158:5
=46R3 NICE:12728:v:0:22000:162:88:9803:5
CAZA Y PESCA:11156:v:0:22000:169:116:30507:5
CANAL+...30:11317:v:0:22000:174:136:29817:5
CLAN  TVE:10979:v:0:22000:160:80:30654:5
A LA CARTE 9:12129:v:0:27500:169:116:8410:5
COSMOPOLITAN:11156:v:0:22000:170:120:30512:5
TEST_CSD1:10847:v:0:22000:163:0:30174:5
TEVA:12640:v:0:22000:164:96:8905:5
[07c-23a2]:12363:v:0:27500:0:2046:9122:5
TSF JAZZ:12207:v:0:27500:0:1916:8532:5
LCI:11934:v:0:27500:166:104:8156:5
MTV Hits:11739:v:0:27500:3041:3042:28654:5
ProSieben Schweiz:12051:v:0:27500:289:290:20001:5
TAQ XXHARD:11097:v:0:22000:161:84:30058:5
=46OX HD:10817:v:0:22000:160:80:29950:6
MOSAIQUE C+:12324:v:0:27500:170:1891:8620:5
=46RANCE CULTURE:12207:v:0:27500:0:1906:8563:5
TEST_CSD3:10847:v:0:22000:163:0:30176:5
Kabel 1 Schweiz:12051:v:0:27500:162:163:20003:5
[01f-75e3]:10847:v:0:22000:163:0:30179:5
TELEMAISON:12402:v:0:27500:160:80:8701:5
=46R3 ROUEN:12699:v:0:22000:167:108:9708:5
CINEMAGIC HD:10729:v:0:22000:162:92:30802:6
NRJ:12207:v:0:27500:0:236:8536:5
TRACE TV:12402:v:0:27500:171:124:8710:5
NRJ HITS:11479:v:0:22000:165:100:6406:5
[07f-23a6]:12363:v:0:27500:0:2046:9126:5
=46R3 MONTPELLIER:12728:v:0:22000:170:120:9811:5
=46OX HD:10847:v:0:22000:175:0:30100:5
CNN Int.:11778:v:0:27500:165:100:28522:5
TELECINCO:10979:v:0:22000:165:100:30659:5
NT1:12285:v:0:27500:168:112:17028:5
Russia Today:11538:v:0:22000:604:624:6904:5
[04f-74cf]:11435:v:0:22000:160:81:29903:6
ANTENA 3:11685:v:0:22000:170:120:30212:5
[009-75af]:10847:v:0:22000:163:400:30127:5
RFI INT:12207:v:0:27500:0:1908:8524:5
Al Jazeera English:11508:v:0:22000:712:732:7012:5
[015-759b]:10847:v:0:22000:0:260:30107:5
DISNEY CH. +1:11317:v:0:22000:164:96:29802:5
CANAL+ CINEMA:11856:v:0:27500:162:88:8203:5
DT4:12363:v:0:27500:165:108:9153:5
TAQUILLA 2:10788:v:0:22000:170:120:30351:5
CANAL+ LIGA:10876:v:0:22000:160:80:30610:5
BIO:11156:v:0:22000:162:88:30509:5
DISNEY CHANNEL+1:12640:v:0:22000:165:100:8906:5
!flirtline.tv:12246:v:0:27500:1743:1744:10170:5
=46RANCE BLEU IDF:12207:v:0:27500:0:1907:8523:5
TELEDEPORTE:11038:v:0:22000:170:120:30412:5
ARTE HD:12580:v:0:22000:163:95:9324:6
LCP:11934:v:0:27500:171:124:8154:5
COMEDIE !:12402:v:0:27500:161:84:8702:5
Boomerang:11778:v:0:27500:166:102:28527:5
=46OX CRIME:11317:v:0:22000:160:80:29800:5
DISNEY XD:11156:v:0:22000:163:92:30506:5
EUROSPORT HD:12669:v:0:22000:162:90:9903:6
40 LATINO:11317:v:0:22000:172:128:29808:5
C+ COMEDIA...30:11685:v:0:22000:167:108:30222:5
=46R3 ORLEANS:12728:v:0:22000:163:92:9804:5
=46RANCE 5:12012:v:0:27500:165:100:8806:5
C CINEMA FAMIZ:12402:v:0:27500:170:120:8711:5
Kosmica TV:12480:v:0:27500:2815:2816:76:5
TV BREIZH:12207:v:0:27500:161:84:8502:5
M6 HD:12580:v:0:22000:170:123:9310:6
ANIMAX:11685:v:0:22000:171:124:30207:5
=46IP:12207:v:0:27500:0:1903:8520:5
BFM TV:12551:v:0:22000:2171:2172:12170:5
EUROSPORT HD:10847:v:0:22000:175:0:30163:5
ODYSSEE:12285:v:0:27500:177:148:17037:5
[026-75ca]:10847:v:0:22000:163:400:30154:5
TVE 1:10979:v:0:22000:170:120:30656:5
TNT:10979:v:0:22000:163:92:30665:5
TF1 HD:12522:v:0:22000:163:95:9204:6
MULTI-X (1):11097:v:0:22000:165:100:30065:5
A LA CARTE 14:12129:v:0:27500:167:108:8412:5
Scharfe Girls TV:12246:v:0:27500:3567:3568:10127:5
TF1 HD:12522:v:0:22000:163:95:9224:6
CANAL+:11856:v:0:27500:170:120:8211:5
M6:11895:v:0:27500:163:92:8372:5
NHK World TV:11508:v:0:22000:714:734:7014:5
[01b-75f1]:10847:v:0:22000:163:400:30193:5
Voyeur TV:12246:v:0:27500:3583:3584:10130:5
LUXE.TV SD:12551:v:0:22000:98:4451:3992:5
BABYFIRST:11156:v:0:22000:167:108:30510:5
=46RANCE INTER:12207:v:0:27500:0:1905:8522:5
[049-7469]:11317:v:0:22000:161:84:29801:5
Cartoon Network:11778:v:0:27500:161:84:28521:5
[051-1905]:11479:v:0:22000:164:96:6405:5
C+ TOROS:10788:v:0:22000:4020:4021:30368:5
[076-21a7]:12324:v:0:27500:2047:0:8615:5
CANAL+ HD:12522:v:0:22000:160:83:9231:6
C+ COMEDIA:11317:v:0:22000:163:92:29805:5
=46ranken SAT:12246:v:0:27500:1279:1280:10104:5
PLAYIN'Tvi:11479:v:0:22000:0:1988:6431:5
USHUAIA TV HD:12363:v:0:27500:2047:0:9129:5
MMD:12324:v:0:27500:840:0:8609:5
MCM TOP:11895:v:0:27500:162:88:8365:5
TAQUILLA HD:11626:v:0:22000:161:87:30701:6
BBC World:11597:v:0:22000:163:92:10050:5
A LA DEMANDE:12168:v:0:27500:163:92:9504:5
[008-75ae]:10847:v:0:22000:163:400:30126:5
CANAL+ SPORT:11856:v:0:27500:167:108:8208:5
=46OX:11317:v:0:22000:169:116:29807:5
EHS:11685:v:0:22000:162:88:30202:5
E! ENTERTAINMENT:12640:v:0:22000:170:120:8911:5
A LA CARTE 7:12129:v:0:27500:167:108:8408:5
MTV ESP:11739:v:0:27500:3011:3012:28651:5
[01c-75ef]:10847:v:0:22000:163:400:30191:5
TF6:12168:v:0:27500:160:80:9501:5
[006-74ff]:10817:v:0:22000:161:86:29951:6
40 TV:11038:v:0:22000:165:100:30405:5
GULLI:12012:v:0:27500:167:108:8825:5
[033-77bb]:10979:v:0:22000:161:84:30651:5
[080-23bc]:12363:v:0:27500:2049:2048:9148:5
DT13:12363:v:0:27500:0:108:9162:5
SPORT1:12480:v:0:27500:1023:1024:900:5
A LA CARTE 1:12129:v:0:27500:161:84:8402:5
CINE PREMIER HD:12580:v:0:22000:160:83:9301:6
Heisse S=EF=BF=BDnde TV:12246:v:0:27500:3807:3808:10163:5
HISTORY:12441:v:0:27500:2010:2011:13201:5
MOSA 4:12324:v:0:27500:166:1961:8644:5
PLAYBOY TV:10876:v:0:22000:173:132:30603:5
MOSAIQUE C+:12324:v:0:27500:170:0:8621:5
CINE FX:12285:v:0:27500:174:136:17034:5
Tele6.tv:12246:v:0:27500:2799:2800:10124:5
CANALPLAY:12363:v:0:27500:2047:0:9131:5
ETB Radio 1:11508:v:0:22000:0:743:7022:5
SUD RADIO:12207:v:0:27500:0:1914:8530:5
C+ DCINE:11317:v:0:22000:170:120:29812:5
PAR. COMEDY:11038:v:0:22000:171:124:30408:5
=46RANCE 2:12012:v:0:27500:160:80:8821:5
[04e-74ce]:11435:v:0:22000:171:124:29902:6
=46R3 LIMOGES:12699:v:0:22000:168:112:9709:5
A LA CARTE:12012:v:0:27500:0:224:8809:5
MEDI 1:12207:v:0:27500:0:1949:8562:5
C+ F=EF=BF=BDTBOL:10876:v:0:22000:161:84:30620:5
HISTOIRE:11817:v:0:27500:171:124:8011:5
VH1 Classic:11739:v:0:27500:3071:3072:28657:5
Club1 TV:12246:v:0:27500:2015:2016:10156:5
CANAL+:11856:v:0:27500:160:80:8204:5
=46R3 POITIERS:12728:v:0:22000:165:100:9806:5
CANAL+:11856:v:0:27500:160:80:8221:5
=46RANCE 2 HD:12522:v:0:22000:162:90:9223:6
[001-769f]:10788:v:0:22000:4010:4011:30367:5
NAT GEO HD:11626:v:0:22000:163:98:30704:6
PLANETE NO LIMIT:12402:v:0:27500:166:104:8707:5
MTV NL:11973:v:0:27500:4091:4092:28679:5
MTV ESP:11739:v:0:27500:3011:3012:28691:5
A LA CARTE 13:12129:v:0:27500:166:104:8411:5
MTV ROCKS.:11739:v:0:27500:3091:3092:28669:5
C+ ACCI=EF=BF=BDN HD:10847:v:0:22000:175:0:30160:5
SAT.1 CH:12051:v:0:27500:1535:1536:20006:5
=46RANCE MUSIQUE:12207:v:0:27500:0:1901:8519:5
MULTIPANT.4:10788:v:0:22000:164:96:30363:5
AXN HD:10847:v:0:22000:175:0:30113:5
EQUIDIA:11856:v:0:27500:168:112:8209:5
C CINEMA PREMIER:11856:v:0:27500:165:100:8206:5
VIRGIN 17:11895:v:0:27500:168:112:8374:5
Nick:11739:v:0:27500:3101:3102:28660:5
=46RANCE 4:12012:v:0:27500:162:88:8823:5
C. ESTRELLAS:11685:v:0:22000:168:112:30206:5
=46RANCE INFO:12207:v:0:27500:0:1904:8521:5
TF1 HD:12363:v:0:27500:2047:0:9113:5
[01d-75ee]:10847:v:0:22000:163:400:30190:5
VOLTAGE:12207:v:0:27500:0:251:8550:5
RTL9:12285:v:0:27500:175:140:17035:5
CANAL+ FAMILY:11856:v:0:27500:164:96:8205:5
GayBoys LIVE:12246:v:0:27500:975:976:10167:5
auto motor und sport:12441:v:0:27500:2120:2121:13212:5
Venusclub.TV:12246:v:0:27500:1247:1248:10153:5
ETB Sat:11508:v:0:22000:703:723:7002:5
MCM:11895:v:0:27500:161:84:8352:5
HSE24 TREND:12480:v:0:27500:3071:3072:77:5
EUROSPORT 2:12168:v:0:27500:162:88:9503:5
TV5MONDE EUROPE:11538:v:0:22000:615:635:6915:5
TAQUILLA:10847:v:0:22000:163:400:30128:5
DELUXE RADIO:12246:v:0:27500:0:336:10140:5
RADIOS 3:12207:v:0:27500:0:1941:8511:5
MTVNHD:10847:v:0:22000:175:0:30172:5
13EME RUE HD:12580:v:0:22000:161:86:9322:6
[01a-75f2]:10847:v:0:22000:163:400:30194:5
TAQUILLA 1:10788:v:0:22000:168:112:30350:5
M6 REPLAY:12363:v:0:27500:2047:0:9130:5
NICKELODEON France:11739:v:0:27500:3081:3082:28668:5
[010-75a5]:10847:v:0:22000:0:266:30117:5
NCMESS:11817:v:0:27500:2047:0:8013:5
[079-2394]:12363:v:0:27500:2047:0:9108:5
MULTI-X (2):11097:v:0:22000:174:136:30051:5
[000-76a1]:10788:v:0:22000:4030:4031:30369:5
gl=EF=BF=BDck TV:12480:v:0:27500:1791:1792:46:5
CANAL+ HD:10847:v:0:22000:175:0:30162:5
CANAL J:11934:v:0:27500:167:108:8157:5
[03d-7575]:11097:v:0:22000:4020:4021:30069:5
LibertyTV FR:12551:v:0:22000:941:943:12120:5
EUROSPORT:10979:v:0:22000:168:112:30680:5
C+ ACCI=EF=BF=BDN HD:10817:v:0:22000:162:93:29952:6
M6:11895:v:0:27500:163:92:8367:5
A LA CARTE:12012:v:0:27500:0:224:8812:5
ANIMAX:12441:v:0:27500:2030:2031:13203:5
[020-75f5]:10847:v:0:22000:163:400:30197:5
DISNEY CINEMAGIC:12640:v:0:22000:167:108:8908:5
DISNEY MAGIC HD:12580:v:0:22000:162:91:9303:6
MOSAIQUE:12324:v:0:27500:162:1904:8622:5
=46RANCE 3:12012:v:0:27500:161:84:8822:5
CANAL ODISEA:11156:v:0:22000:176:144:30522:5
RTL 2:12207:v:0:27500:0:238:8538:5
VH1.:11739:v:0:27500:3061:3062:28666:5
[030-778c]:10876:v:0:22000:165:100:30604:5
TELEMADRID SAT:11597:v:0:22000:1501:1502:10069:5
GAME ONE:11739:v:0:27500:3031:3032:28663:5
TAQUILLA XY:10788:v:0:22000:160:80:30357:5
24 HORAS:11156:v:0:22000:173:132:30520:5
DECASA:10876:v:0:22000:164:96:30613:5
XXL:12285:v:0:27500:164:96:17024:5
RTL:12207:v:0:27500:0:1910:8528:5
EUROSPORT HD:10817:v:0:22000:163:98:29953:6
LA 2:10979:v:0:22000:167:108:30658:5
MEZZO.:11817:v:0:27500:166:104:8012:5
DISCOVERY:12090:v:0:27500:167:108:9408:5
RADIO COURTOISIE:12207:v:0:27500:0:1952:8566:5
Die Neue Zeit TV:12246:v:0:27500:3327:3328:10112:5
SKYROCK:12207:v:0:27500:0:239:8539:5
DISCOVERY HD:12522:v:0:22000:164:98:9225:6
[07a-239d]:12363:v:0:27500:0:2046:9117:5
TCM MODERNO:11038:v:0:22000:167:108:30407:5
PLAYHOUSE:11317:v:0:22000:165:100:29803:5
ENCYCLOPEDIA:12285:v:0:27500:163:92:17023:5
Russia Today Espa=EF=BF=BDol:11597:v:0:22000:2101:2102:10077:5
maennerwelt.tv:12246:v:0:27500:2543:2544:10123:5
SPORTMAN=EF=BF=BDA:11038:v:0:22000:164:96:30404:5
Amore TV:12246:v:0:27500:1775:1776:10120:5
=2E6live:12246:v:0:27500:1519:1520:10119:5
SOPHIA TV:12246:v:0:27500:3071:3072:10111:5
TPS STAR:12090:v:0:27500:160:80:9401:5
TAQUILLA 8:11097:v:0:22000:170:120:30063:5
Kinowelt:12441:v:0:27500:2060:2061:13206:5
DT1:12363:v:0:27500:165:108:9150:5
YACHT AND SAIL:12324:v:0:27500:171:124:8607:5
HOGARUTIL:10876:v:0:22000:171:124:30616:5
MTV Music:11973:v:0:27500:4011:4012:28671:5
C+ ACCI=EF=BF=BDN...30:11685:v:0:22000:163:92:30203:5
TEDDY:12246:v:0:27500:0:368:10142:5
=46R3 VIA STELLA:12728:v:0:22000:171:124:9812:5
=46R3 DIJON:12728:v:0:22000:164:96:9805:5
C+COMEDIA HD:10729:v:0:22000:161:87:30801:6
CARTOON NET.:10788:v:0:22000:161:84:30358:5
A LA CARTE 4:12129:v:0:27500:164:96:8405:5
VIBRATION:12207:v:0:27500:0:244:8544:5
LCP:11934:v:0:27500:171:124:8173:5
DISCOVERY HD:12522:v:0:22000:164:98:9205:6
=46OX:12441:v:0:27500:2090:2091:13209:5
DT2:12363:v:0:27500:0:1992:9151:5
CALLE 13:10876:v:0:22000:163:92:30608:5
TAQUILLA 5:11097:v:0:22000:160:80:30053:5
MOSAIQUE:12324:v:0:27500:162:1906:8603:5
PLAYIN'TV:11479:v:0:22000:0:1207:6433:5
[059-20ab]:11895:v:0:27500:2047:0:8363:5
GU=EF=BF=BDA DIGITAL+:10847:v:0:22000:163:400:30129:5
SYFY HD:12669:v:0:22000:161:87:9902:6
DT9:12363:v:0:27500:165:108:9158:5
MOSA 2:12324:v:0:27500:163:1921:8604:5
MTVNHD:11778:v:0:27500:2000:2001:28601:5
CANAL+:11038:v:0:22000:160:80:30400:5
M6 MUSIC CLUB:12610:v:0:22000:164:96:9605:5
MTV PULSE:11973:v:0:27500:4041:4042:28674:5
VIAJAR:11038:v:0:22000:162:88:30409:5
OM'TV:12207:v:0:27500:167:108:8516:5
CINE POLAR:12285:v:0:27500:173:132:17033:5
A LA CARTE 6:12129:v:0:27500:166:104:8407:5
AXN HD:10729:v:0:22000:160:80:30800:6
CANAL+:11856:v:0:27500:160:80:8201:5
SONY TV:11317:v:0:22000:167:108:29809:5
[034-77bc]:10979:v:0:22000:171:124:30652:5
MTV FRANCE:11739:v:0:27500:3021:3022:28652:5
[019-75f3]:10847:v:0:22000:163:400:30195:5
M6 MUSIC HITS:12090:v:0:27500:166:104:9407:5
QVC Deutschland:12551:v:0:22000:165:166:12100:5
[021-75d9]:10847:v:0:22000:163:400:30169:5
C+ DEPORTES:10876:v:0:22000:172:128:30607:5
TAQUILLA 141:11685:v:0:22000:160:80:30217:5
CUATRO:10979:v:0:22000:173:132:30662:5
infoLIGA:11097:v:0:22000:166:104:30061:5
[017-7599]:10847:v:0:22000:0:262:30105:5
[023-75cf]:10847:v:0:22000:163:400:30159:5
TV3 CAT:11597:v:0:22000:1701:1702:10071:5
ESPN CLASSIC:12207:v:0:27500:165:100:8505:5
C+ COMEDIA:11317:v:0:22000:163:92:29811:5
NATIONAL GEO:12402:v:0:27500:169:116:8708:5
DELUXE LOUNGE:12246:v:0:27500:0:352:10141:5
MTVNHD:11778:v:0:27500:2000:2001:28600:5
Guter Sex.TV:12246:v:0:27500:3039:3040:10160:5
TAQUILLA X:10788:v:0:22000:173:132:30355:5
tirol tv:12246:v:0:27500:2559:2560:10109:5
WRN:12207:v:0:27500:0:1932:8564:5
M6 BOUTIQUE LA CHAINE:11597:v:0:22000:1120:1130:10063:5
BABY FIRST:11156:v:0:22000:167:108:30511:5
NAT GEO WILD:12168:v:0:27500:165:100:9506:5
MOSAIQUE:12324:v:0:27500:168:0:8608:5
=46RANCE 5:12012:v:0:27500:165:100:8824:5
[07d-23a4]:12363:v:0:27500:0:2046:9124:5
DT16:12363:v:0:27500:165:80:9165:5
ACTION:12285:v:0:27500:170:120:17030:5
TELETOON+1:12090:v:0:27500:169:116:9410:5
GIRONDINS TV:11479:v:0:22000:167:108:6408:5
CINEMAGIC:11156:v:0:22000:166:104:30505:5
MULTIPANT.5:11097:v:0:22000:4000:4001:30067:5
DISCOVERY:10876:v:0:22000:169:116:30615:5
MTV ROCKS:11739:v:0:27500:3091:3092:28659:5
=46RANCE 3:12012:v:0:27500:161:84:8802:5
SYFY:10876:v:0:22000:162:88:30614:5
PLANETE:11934:v:0:27500:162:88:8153:5
MOSA 4:12324:v:0:27500:166:1961:8614:5
TAQUILLA:10847:v:0:22000:163:400:30130:5
=46rance 24 (in English):11538:v:0:22000:606:626:6906:5
RADIO LATINA:12207:v:0:27500:0:247:8546:5
VIRGIN 17:11895:v:0:27500:168:112:8358:5
KTO:11538:v:0:22000:602:622:6902:5
ETB Radio 2:11508:v:0:22000:0:744:7023:5
[012-759e]:10847:v:0:22000:0:259:30110:5
CANAL+ GOLF:10876:v:0:22000:166:104:30601:5
CANAL+ 3D:11626:v:0:22000:165:111:30702:6
SYFY HD:12669:v:0:22000:161:87:9922:6
BAR=EF=BF=BDA TV:10788:v:0:22000:4000:4001:30366:5
C CINEMA EMOTION:11817:v:0:27500:161:84:8002:5
[013-759d]:10847:v:0:22000:0:258:30109:5
M6 HD:12580:v:0:22000:170:123:9330:6
TRACE TROPICAL:12640:v:0:22000:160:80:8901:5
A VOIR CE SOIR:11895:v:0:27500:169:116:8355:5
PLANETE THALASSA:12207:v:0:27500:163:92:8504:5
DT15:12363:v:0:27500:165:80:9164:5
EUROSPORT:11934:v:0:27500:160:80:8151:5
REGIO TV:12480:v:0:27500:2047:2048:47:5
LE MOUV':12207:v:0:27500:0:241:8541:5
CINE PREMIER HD:12363:v:0:27500:2047:0:9115:5
BBCW SERVICE:12207:v:0:27500:0:1951:8565:5
=46R3 CLERMONT FD:12699:v:0:22000:164:96:9705:5
NATIONAL GEO HD:12522:v:0:22000:161:86:9222:6
=46R3 LILLE:12728:v:0:22000:168:112:9809:5
NT1:12285:v:0:27500:168:112:17040:5
DCINE ESPA=EF=BF=BDOL:11156:v:0:22000:160:80:30518:5
=46R3 LYON:12699:v:0:22000:169:116:9710:5
Renault TV:11508:v:0:22000:706:726:7006:5
EWTN Europe:11538:v:0:22000:607:627:6907:5
CE SOIR:12363:v:0:27500:0:2046:9120:5
MC DOUALIYA:12207:v:0:27500:0:1915:8531:5
PRIVATE SPICE:12324:v:0:27500:167:108:8613:5
CANAL+ SPORT HD:12610:v:0:22000:170:123:9611:5
MULTIPANT.7:11097:v:0:22000:4030:4031:30070:5
MOSAIQUE C+:12324:v:0:27500:170:0:8623:5
Traumkontakt.tv:12246:v:0:27500:3055:3056:10125:5
=46OX NEWS:11685:v:0:22000:161:84:30201:5
Bibel TV:12551:v:0:22000:33:34:12122:5
TVM/WWTV:12246:v:0:27500:2303:2304:10108:5
BBC ARABIC:12207:v:0:27500:0:1946:8559:5
RADIOS:10847:v:0:22000:163:400:30102:5
USHUAIA TV:12168:v:0:27500:161:84:9502:5
Zack Erotik TV:12246:v:0:27500:1007:1008:10117:5
TELETOON:12090:v:0:27500:165:100:9406:5
DORCEL TV :12285:v:0:27500:169:116:17059:5
DISNEY MAGIC HD:12324:v:0:27500:2047:0:8618:5
=46rance 24 (en Fran=EF=BF=BDais):11538:v:0:22000:605:625:6905:5
arenaSAT Home:12441:v:0:27500:2110:0:13211:5
National Geographic Channel:12441:v:0:27500:2020:2021:13202:5
MANGAS:12285:v:0:27500:171:124:17031:5
CINE PREMIER HD:12580:v:0:22000:160:83:9321:6
[053-77ef]:11626:v:0:22000:162:93:30703:6
LA CHAINE METEO:11817:v:0:27500:167:108:8008:5
SAT.1 RhlPf/Hessen:12051:v:0:27500:2047:2048:20010:5
EUROPE 1:12207:v:0:27500:0:1911:8526:5
AB MOTEURS:12285:v:0:27500:160:80:17020:5
BRAVA HD:12669:v:0:22000:163:94:9924:6
TAQUILLA HD:10847:v:0:22000:175:0:30182:5
CANAL+ DOS:11038:v:0:22000:168:112:30410:5
EXTREMADURA TV:11597:v:0:22000:1401:1402:10068:5
USHUAIA TV HD:12669:v:0:22000:160:80:9901:6
TEST_CSD4:10847:v:0:22000:163:400:30177:5
MTV Dance:11739:v:0:27500:3051:3052:28655:5
[025-75cc]:10847:v:0:22000:163:400:30156:5
[005-7504]:10817:v:0:22000:166:104:29956:6
TEST_CSD2:10847:v:0:22000:163:400:30175:5
ARTE:11934:v:0:27500:168:112:8159:5
TAQUILLA 3:10788:v:0:22000:171:124:30352:5
MTV ENTERTAINMENT (S):11973:v:0:27500:4111:4112:28681:5
[03f-7570]:11097:v:0:22000:172:130:30064:5
RADIO FG:12207:v:0:27500:0:243:8543:5
[052-77f1]:11626:v:0:22000:166:118:30705:6
NOVA:12207:v:0:27500:0:242:8542:5
=46UN RADIO:12207:v:0:27500:0:240:8540:5
SexyGirls.TV:12246:v:0:27500:2527:2528:10158:5
MOSA 5:12324:v:0:27500:172:1990:8610:5
A LA CARTE 8:12129:v:0:27500:168:112:8409:5
MOSA 5:12324:v:0:27500:172:1981:8645:5
Biography Channel:12441:v:0:27500:2080:2081:13208:5
[011-759f]:10847:v:0:22000:0:261:30111:5
CANAL+ HD:12522:v:0:22000:160:83:9221:6
NATIONAL GEO HD:12522:v:0:22000:161:86:9202:6
VOYAGE:11934:v:0:27500:164:96:8155:5
DISNEY XD:12402:v:0:27500:164:96:8705:5
PLAYHOUSE DISNEY:12640:v:0:22000:166:104:8907:5
Best of shopping:11597:v:0:22000:225:245:10062:5
M6 MUSIC BLACK:12610:v:0:22000:163:92:9604:5
CANALSAT RADIOS:12207:v:0:27500:0:1920:8509:5
CONTACT FM:12207:v:0:27500:0:245:8545:5
BABY FIRST:11479:v:0:22000:163:92:6404:5
SAT.1 NS/Bremen:12051:v:0:27500:2047:2048:20009:5
EroticDome:12246:v:0:27500:3551:3552:10162:5
meinTVshop:12480:v:0:27500:511:512:899:5
=46R3 BORDEAUX:12699:v:0:22000:162:88:9703:5
TELEREALITE:11479:v:0:22000:162:88:6403:5
TAQUILLA 6:11097:v:0:22000:171:124:30054:5
ONZEO:12324:v:0:27500:161:84:8602:5
AB1:12285:v:0:27500:161:84:17021:5
INFOSPORT:12090:v:0:27500:163:92:9404:5
I>TELE:11817:v:0:27500:169:116:8010:5
=46R3 NANCY:12699:v:0:22000:163:92:9704:5
Nicktoons (S):11973:v:0:27500:4121:4122:28682:5
Pro Erotik TV:12246:v:0:27500:3295:3296:10161:5
W9:11895:v:0:27500:165:100:8373:5
CASH TV:12324:v:0:27500:169:116:8611:5
MEZZO:11817:v:0:27500:166:104:8007:5
[003-7694]:10788:v:0:22000:165:100:30356:5
RTL Living:12441:v:0:27500:2070:2071:13207:5
[03b-76c6]:11038:v:0:22000:166:104:30406:5
Po6:12246:v:0:27500:3311:3312:10126:5
CATALUNYA RADIO:11597:v:0:22000:0:1801:10072:5
MTV Hits.:11739:v:0:27500:3041:3042:28664:5
RCJ / SHALOM:12207:v:0:27500:0:1944:8557:5
C CINEMA FRISSON:11817:v:0:27500:162:88:8003:5
MEZZO LIVEHD:10847:v:0:22000:175:0:30116:5
EUROSPORT HD:12669:v:0:22000:162:90:9923:6
C+ F=EF=BF=BDTBOL:10876:v:0:22000:161:84:30606:5
TAQUILLA 140:11685:v:0:22000:164:96:30204:5
MULTI-X:11097:v:0:22000:167:108:30050:5
13EME RUE:12402:v:0:27500:162:88:8703:5
TELE MELODY:12207:v:0:27500:160:80:8501:5
Sonnenklar TV:12480:v:0:27500:2303:2304:32:5
R. MADRID TV:11685:v:0:22000:173:132:30209:5
CUISINE TV:11934:v:0:27500:165:100:8160:5
=46R3 MARSEILLE:12699:v:0:22000:170:120:9711:5
JUNE:11934:v:0:27500:169:116:8161:5
[031-7793]:10876:v:0:22000:168:112:30611:5
TELETOON AFRICA:12168:v:0:27500:169:116:9510:5
DAF-AnlegerTV:12246:v:0:27500:767:768:10102:5
PULS 4 Austria:12051:v:0:27500:1791:1792:20007:5
[07e-23a5]:12363:v:0:27500:0:2046:9125:5
PORTADA:10847:v:0:22000:171:124:30150:5
DT8:12363:v:0:27500:165:108:9157:5
Eros TV:12246:v:0:27500:3551:496:10115:5
Arirang TV:11508:v:0:22000:711:731:7011:5
TMC:11934:v:0:27500:161:84:8171:5
TAQUILLA X:11097:v:0:22000:163:92:30056:5
MULTIPANT.1:10788:v:0:22000:162:88:30362:5
DT18:12363:v:0:27500:165:108:9167:5
BOOMERANG:10788:v:0:22000:163:92:30361:5
DT6:12363:v:0:27500:162:108:9155:5
MOTORS TV:12168:v:0:27500:168:112:9509:5
CATALUNYA INFORMACIO:11597:v:0:22000:0:1901:10073:5
PLANETE JUSTICE:12610:v:0:22000:167:108:9608:5
CNN+:11685:v:0:22000:169:116:30210:5
NAT GEOGRAPH:10876:v:0:22000:170:120:30605:5
DELUXE MUSIC:12246:v:0:27500:255:256:10100:5
C+ DEPORT HD:10729:v:0:22000:163:99:30803:6
[078-2393]:12363:v:0:27500:2047:0:9107:5
VIRGIN RADIO:12207:v:0:27500:0:237:8537:5
[073-216a]:12207:v:0:27500:0:1941:8554:5
[02d-778a]:10876:v:0:22000:167:108:30602:5
CANARIAS:11508:v:0:22000:717:737:7017:5
DORCEL TV:12285:v:0:27500:169:116:17029:5
CODE DOWN:12363:v:0:27500:2047:0:9141:5
CCTV 9:11538:v:0:22000:614:634:6914:5
C+ LIGA HD:10847:v:0:22000:175:0:30183:5
[03e-756b]:11097:v:0:22000:162:88:30059:5
NRJ 12:11817:v:0:27500:163:92:8022:5
CANAL CLUB:11685:v:0:22000:166:104:30205:5
RFM:12207:v:0:27500:0:248:8547:5
XXL :12285:v:0:27500:164:96:17054:5
CHASSE et PECHE:12285:v:0:27500:178:152:17036:5
NAT GEO HD:10847:v:0:22000:175:0:30124:5
RADIO ALFA:12207:v:0:27500:0:1943:8556:5
[01e-75ed]:10847:v:0:22000:163:400:30189:5
PINK TV/PINK X:12090:v:0:27500:168:112:9409:5
CANAL+ HD:11435:v:0:22000:164:97:29900:6
RADIO FRANCE:12207:v:0:27500:0:241:8584:5
RADIO 2:12207:v:0:27500:0:1908:8582:5
ESCALES:12285:v:0:27500:165:100:17025:5
MA CHAINE SPORT:12610:v:0:22000:162:88:9603:5
CANAL+ DECALE:11856:v:0:27500:161:84:8202:5
INFOMETEO:11156:v:0:22000:164:96:30514:5
GUIDE TV:12363:v:0:27500:2047:0:9101:5
PLAYBOY TV:12207:v:0:27500:164:96:8506:5
W9:11895:v:0:27500:165:100:8356:5
=46R3 BESANCON:12699:v:0:22000:161:84:9702:5
Telefonsex.TV:12246:v:0:27500:991:992:10152:5
=46R3 STRASBOURG:12728:v:0:22000:169:116:9810:5
TCM CL=EF=BF=BDSICO:11685:v:0:22000:165:100:30220:5
[027-75c7]:10847:v:0:22000:163:400:30151:5
EuroSport 2 (a/S):12441:v:0:27500:2050:2051:13205:5
TCM:11778:v:0:27500:169:64:28525:5
TF1:11895:v:0:27500:171:124:8366:5
40 LATINO:11317:v:0:22000:172:128:29816:5
RMC:12207:v:0:27500:0:1912:8527:5
[072-2169]:12207:v:0:27500:0:1948:8553:5
=46RANCE 2:12012:v:0:27500:160:80:8801:5
Sexy Amateure:12246:v:0:27500:2031:2032:10121:5
=2E:12246:v:0:27500:2255:0:10172:5
=46RANCE 4:12012:v:0:27500:162:88:8803:5
DISNEY CHANNEL:11856:v:0:27500:166:104:8207:5
LA SEXTA:10979:v:0:22000:162:88:30655:5
C+ DEPORT HD:10847:v:0:22000:175:0:30180:5
TEST_CSD5:10847:v:0:22000:161:84:30178:5
CINEMAGIC HD:10847:v:0:22000:175:0:30115:5
C+ LIGA HD:11435:v:0:22000:161:86:29901:6
ProSieben Austria:12051:v:0:27500:161:84:20002:5
Super Sexy.TV:12246:v:0:27500:1263:1264:10118:5
M6 HD:12363:v:0:27500:2047:0:9114:5
HOLLYWOOD:10979:v:0:22000:166:104:30657:5
[05a-226e]:12012:v:0:27500:0:2046:8814:5
TEST CDN 8:11895:v:0:27500:2047:0:8360:5
PARIS PREMIERE:11817:v:0:27500:164:96:8005:5
[043-7735]:11156:v:0:22000:168:112:30517:5
MTV IDOL:11973:v:0:27500:4051:4052:28675:5
CINECINEMA CLUB:11895:v:0:27500:166:104:8351:5
ARTE:11934:v:0:27500:168:112:8172:5
[00b-75ab]:10847:v:0:22000:163:400:30123:5
AstroTV:12480:v:0:27500:2559:2560:661:5
RADIO 1:12207:v:0:27500:0:1932:8581:5
equi8:12480:v:0:27500:767:768:897:5
[075-2199]:12324:v:0:27500:0:2046:8601:5
MTV Germany:11973:v:0:27500:4031:4032:28673:5
Al Jazeera Channel:11508:v:0:22000:709:729:7009:5
CCTV F:11538:v:0:22000:613:633:6913:5
CANAL+ HD:12522:v:0:22000:160:83:9201:6
RADIOS ESP:10847:v:0:22000:0:400:30104:5
Deutsches Erotik.TV:12246:v:0:27500:1503:1504:10154:5
VIVOLTA:12610:v:0:22000:165:100:9606:5
ONTV Regional:12246:v:0:27500:1023:1024:10103:5
[038-77c5]:10979:v:0:22000:164:96:30661:5
DISNEY MAGIC+1:12640:v:0:22000:168:112:8909:5
I>TELE:11817:v:0:27500:169:116:8021:5
[014-759c]:10847:v:0:22000:0:256:30108:5

--Boundary-00=_vvdlM3B0ev+ewby--
