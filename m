Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:13045 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab2DWLtB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 07:49:01 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	"Igor M. Liplianin" <liplianin@me.by>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Manu Abraham <abraham.manu@gmail.com>
Subject: [RFC PATCH 8/8] v4l/dvb: fix compiler warnings
Date: Mon, 23 Apr 2012 13:38:26 +0200
Message-Id: <8cbe216ba6c5236a1d8179c3339100fd6ccfac9e.1335180844.git.hans.verkuil@cisco.com>
In-Reply-To: <1335181106-19342-1-git-send-email-hans.verkuil@cisco.com>
References: <1335181106-19342-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <100836b0eeed3d802c1ce4f7645d8beefe26df25.1335180844.git.hans.verkuil@cisco.com>
References: <100836b0eeed3d802c1ce4f7645d8beefe26df25.1335180844.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

media_build/v4l/stb6100.c: In function 'stb6100_read_reg':
media_build/v4l/stb6100.c:161:6: warning: variable 'rc' set but not used [-Wunused-but-set-variable]
media_build/v4l/cx24110.c: In function 'cx24110_read_ucblocks':
media_build/v4l/cx24110.c:515:6: warning: variable 'lastbyer' set but not used [-Wunused-but-set-variable]
media_build/v4l/dib9000.c: In function 'dib9000_mbx_process':
media_build/v4l/dib9000.c:711:6: warning: variable 'tmp' set but not used [-Wunused-but-set-variable]
media_build/v4l/zl10353.c: In function 'zl10353_init':
media_build/v4l/zl10353.c:562:6: warning: variable 'rc' set but not used [-Wunused-but-set-variable]
media_build/v4l/stv0297.c: In function 'stv0297_set_frontend':
media_build/v4l/stv0297.c:417:16: warning: variable 'starttime' set but not used [-Wunused-but-set-variable]
media_build/v4l/lgs8gxx.c: In function 'lgs8gxx_set_mode_manual':
media_build/v4l/lgs8gxx.c:265:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
media_build/v4l/af9013.c: In function 'af9013_statistics_work':
media_build/v4l/af9013.c:517:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
media_build/v4l/stv090x.c: In function 'stv090x_optimize_track':
media_build/v4l/stv090x.c:2845:23: warning: variable 'rolloff' set but not used [-Wunused-but-set-variable]
media_build/v4l/stv090x.c: In function 'stv090x_algo':
media_build/v4l/stv090x.c:3177:28: warning: variable 'no_signal' set but not used [-Wunused-but-set-variable]
media_build/v4l/it913x-fe.c: In function 'it913x_fe_read_ber':
media_build/v4l/it913x-fe.c:636:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
media_build/v4l/it913x-fe.c: In function 'it913x_fe_get_frontend':
media_build/v4l/it913x-fe.c:661:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
media_build/v4l/it913x-fe.c: In function 'it913x_fe_set_frontend':
media_build/v4l/it913x-fe.c:694:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
media_build/v4l/m88rs2000.c: In function 'm88rs2000_set_fec':
media_build/v4l/m88rs2000.c:657:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
media_build/v4l/dst_ca.c: In function 'ca_send_message':
media_build/v4l/dst_ca.c:480:15: warning: variable 'ca_message_header_len' set but not used [-Wunused-but-set-variable]
media_build/v4l/smssdio.c: In function 'smssdio_interrupt':
media_build/v4l/smssdio.c:117:11: warning: variable 'isr' set but not used [-Wunused-but-set-variable]

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/dvb/bt8xx/dst_ca.c        |    2 --
 drivers/media/dvb/frontends/af9013.c    |   13 +++++--------
 drivers/media/dvb/frontends/cx24110.c   |    7 +++----
 drivers/media/dvb/frontends/dib9000.c   |    3 +--
 drivers/media/dvb/frontends/it913x-fe.c |   26 ++++++++++++--------------
 drivers/media/dvb/frontends/lgs8gxx.c   |    3 +--
 drivers/media/dvb/frontends/m88rs2000.c |    3 +--
 drivers/media/dvb/frontends/stb6100.c   |    3 +--
 drivers/media/dvb/frontends/stv0297.c   |    2 --
 drivers/media/dvb/frontends/stv090x.c   |    2 --
 drivers/media/dvb/frontends/zl10353.c   |    3 +--
 drivers/media/dvb/siano/smssdio.c       |    4 ++--
 12 files changed, 27 insertions(+), 44 deletions(-)

diff --git a/drivers/media/dvb/bt8xx/dst_ca.c b/drivers/media/dvb/bt8xx/dst_ca.c
index 48e48e8..66f52f1 100644
--- a/drivers/media/dvb/bt8xx/dst_ca.c
+++ b/drivers/media/dvb/bt8xx/dst_ca.c
@@ -477,7 +477,6 @@ static int dst_check_ca_pmt(struct dst_state *state, struct ca_msg *p_ca_message
 static int ca_send_message(struct dst_state *state, struct ca_msg *p_ca_message, void __user *arg)
 {
 	int i = 0;
-	unsigned int ca_message_header_len;
 
 	u32 command = 0;
 	struct ca_msg *hw_buffer;
@@ -496,7 +495,6 @@ static int ca_send_message(struct dst_state *state, struct ca_msg *p_ca_message,
 
 
 	if (p_ca_message->msg) {
-		ca_message_header_len = p_ca_message->length;	/*	Restore it back when you are done	*/
 		/*	EN50221 tag	*/
 		command = 0;
 
diff --git a/drivers/media/dvb/frontends/af9013.c b/drivers/media/dvb/frontends/af9013.c
index 6bcbcf5..5bc570d 100644
--- a/drivers/media/dvb/frontends/af9013.c
+++ b/drivers/media/dvb/frontends/af9013.c
@@ -514,7 +514,6 @@ err:
 
 static void af9013_statistics_work(struct work_struct *work)
 {
-	int ret;
 	struct af9013_state *state = container_of(work,
 		struct af9013_state, statistics_work.work);
 	unsigned int next_msec;
@@ -530,27 +529,27 @@ static void af9013_statistics_work(struct work_struct *work)
 	default:
 		state->statistics_step = 0;
 	case 0:
-		ret = af9013_statistics_signal_strength(&state->fe);
+		af9013_statistics_signal_strength(&state->fe);
 		state->statistics_step++;
 		next_msec = 300;
 		break;
 	case 1:
-		ret = af9013_statistics_snr_start(&state->fe);
+		af9013_statistics_snr_start(&state->fe);
 		state->statistics_step++;
 		next_msec = 200;
 		break;
 	case 2:
-		ret = af9013_statistics_ber_unc_start(&state->fe);
+		af9013_statistics_ber_unc_start(&state->fe);
 		state->statistics_step++;
 		next_msec = 1000;
 		break;
 	case 3:
-		ret = af9013_statistics_snr_result(&state->fe);
+		af9013_statistics_snr_result(&state->fe);
 		state->statistics_step++;
 		next_msec = 400;
 		break;
 	case 4:
-		ret = af9013_statistics_ber_unc_result(&state->fe);
+		af9013_statistics_ber_unc_result(&state->fe);
 		state->statistics_step++;
 		next_msec = 100;
 		break;
@@ -558,8 +557,6 @@ static void af9013_statistics_work(struct work_struct *work)
 
 	schedule_delayed_work(&state->statistics_work,
 		msecs_to_jiffies(next_msec));
-
-	return;
 }
 
 static int af9013_get_tune_settings(struct dvb_frontend *fe,
diff --git a/drivers/media/dvb/frontends/cx24110.c b/drivers/media/dvb/frontends/cx24110.c
index 5101f10..98ecaf0 100644
--- a/drivers/media/dvb/frontends/cx24110.c
+++ b/drivers/media/dvb/frontends/cx24110.c
@@ -512,14 +512,13 @@ static int cx24110_read_snr(struct dvb_frontend* fe, u16* snr)
 static int cx24110_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 {
 	struct cx24110_state *state = fe->demodulator_priv;
-	u32 lastbyer;
 
 	if(cx24110_readreg(state,0x10)&0x40) {
 		/* the RS error counter has finished one counting window */
 		cx24110_writereg(state,0x10,0x60); /* select the byer reg */
-		lastbyer=cx24110_readreg(state,0x12)|
-			(cx24110_readreg(state,0x13)<<8)|
-			(cx24110_readreg(state,0x14)<<16);
+		cx24110_readreg(state, 0x12) |
+			(cx24110_readreg(state, 0x13) << 8) |
+			(cx24110_readreg(state, 0x14) << 16);
 		cx24110_writereg(state,0x10,0x70); /* select the bler reg */
 		state->lastbler=cx24110_readreg(state,0x12)|
 			(cx24110_readreg(state,0x13)<<8)|
diff --git a/drivers/media/dvb/frontends/dib9000.c b/drivers/media/dvb/frontends/dib9000.c
index 80848b4..0661da9 100644
--- a/drivers/media/dvb/frontends/dib9000.c
+++ b/drivers/media/dvb/frontends/dib9000.c
@@ -708,7 +708,6 @@ static u8 dib9000_mbx_count(struct dib9000_state *state, u8 risc_id, u16 attr)
 static int dib9000_mbx_process(struct dib9000_state *state, u16 attr)
 {
 	int ret = 0;
-	u16 tmp;
 
 	if (!state->platform.risc.fw_is_running)
 		return -1;
@@ -721,7 +720,7 @@ static int dib9000_mbx_process(struct dib9000_state *state, u16 attr)
 	if (dib9000_mbx_count(state, 1, attr))	/* 1=RiscB */
 		ret = dib9000_mbx_fetch_to_cache(state, attr);
 
-	tmp = dib9000_read_word_attr(state, 1229, attr);	/* Clear the IRQ */
+	dib9000_read_word_attr(state, 1229, attr);	/* Clear the IRQ */
 /*      if (tmp) */
 /*              dprintk( "cleared IRQ: %x", tmp); */
 	DibReleaseLock(&state->platform.risc.mbx_lock);
diff --git a/drivers/media/dvb/frontends/it913x-fe.c b/drivers/media/dvb/frontends/it913x-fe.c
index 84df03c..708cbf1 100644
--- a/drivers/media/dvb/frontends/it913x-fe.c
+++ b/drivers/media/dvb/frontends/it913x-fe.c
@@ -633,10 +633,9 @@ static int it913x_fe_read_snr(struct dvb_frontend *fe, u16 *snr)
 static int it913x_fe_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
 	struct it913x_fe_state *state = fe->demodulator_priv;
-	int ret;
 	u8 reg[5];
 	/* Read Aborted Packets and Pre-Viterbi error rate 5 bytes */
-	ret = it913x_read_reg(state, RSD_ABORT_PKT_LSB, reg, sizeof(reg));
+	it913x_read_reg(state, RSD_ABORT_PKT_LSB, reg, sizeof(reg));
 	state->ucblocks += (u32)(reg[1] << 8) | reg[0];
 	*ber = (u32)(reg[4] << 16) | (reg[3] << 8) | reg[2];
 	return 0;
@@ -658,10 +657,9 @@ static int it913x_fe_get_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct it913x_fe_state *state = fe->demodulator_priv;
-	int ret;
 	u8 reg[8];
 
-	ret = it913x_read_reg(state, REG_TPSD_TX_MODE, reg, sizeof(reg));
+	it913x_read_reg(state, REG_TPSD_TX_MODE, reg, sizeof(reg));
 
 	if (reg[3] < 3)
 		p->modulation = fe_con[reg[3]];
@@ -691,25 +689,25 @@ static int it913x_fe_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct it913x_fe_state *state = fe->demodulator_priv;
-	int ret, i;
+	int i;
 	u8 empty_ch, last_ch;
 
 	state->it913x_status = 0;
 
 	/* Set bw*/
-	ret = it913x_fe_select_bw(state, p->bandwidth_hz,
+	it913x_fe_select_bw(state, p->bandwidth_hz,
 		state->adcFrequency);
 
 	/* Training Mode Off */
-	ret = it913x_write_reg(state, PRO_LINK, TRAINING_MODE, 0x0);
+	it913x_write_reg(state, PRO_LINK, TRAINING_MODE, 0x0);
 
 	/* Clear Empty Channel */
-	ret = it913x_write_reg(state, PRO_DMOD, EMPTY_CHANNEL_STATUS, 0x0);
+	it913x_write_reg(state, PRO_DMOD, EMPTY_CHANNEL_STATUS, 0x0);
 
 	/* Clear bits */
-	ret = it913x_write_reg(state, PRO_DMOD, MP2IF_SYNC_LK, 0x0);
+	it913x_write_reg(state, PRO_DMOD, MP2IF_SYNC_LK, 0x0);
 	/* LED on */
-	ret = it913x_write_reg(state, PRO_LINK, GPIOH3_O, 0x1);
+	it913x_write_reg(state, PRO_LINK, GPIOH3_O, 0x1);
 	/* Select Band*/
 	if ((p->frequency >= 51000000) && (p->frequency <= 230000000))
 		i = 0;
@@ -720,7 +718,7 @@ static int it913x_fe_set_frontend(struct dvb_frontend *fe)
 	else
 		return -EOPNOTSUPP;
 
-	ret = it913x_write_reg(state, PRO_DMOD, FREE_BAND, i);
+	it913x_write_reg(state, PRO_DMOD, FREE_BAND, i);
 
 	deb_info("Frontend Set Tuner Type %02x", state->tuner_type);
 	switch (state->tuner_type) {
@@ -730,7 +728,7 @@ static int it913x_fe_set_frontend(struct dvb_frontend *fe)
 	case IT9135_60:
 	case IT9135_61:
 	case IT9135_62:
-		ret = it9137_set_tuner(state,
+		it9137_set_tuner(state,
 			p->bandwidth_hz, p->frequency);
 		break;
 	default:
@@ -742,9 +740,9 @@ static int it913x_fe_set_frontend(struct dvb_frontend *fe)
 		break;
 	}
 	/* LED off */
-	ret = it913x_write_reg(state, PRO_LINK, GPIOH3_O, 0x0);
+	it913x_write_reg(state, PRO_LINK, GPIOH3_O, 0x0);
 	/* Trigger ofsm */
-	ret = it913x_write_reg(state, PRO_DMOD, TRIGGER_OFSM, 0x0);
+	it913x_write_reg(state, PRO_DMOD, TRIGGER_OFSM, 0x0);
 	last_ch = 2;
 	for (i = 0; i < 40; ++i) {
 		empty_ch = it913x_read_reg_u8(state, EMPTY_CHANNEL_STATUS);
diff --git a/drivers/media/dvb/frontends/lgs8gxx.c b/drivers/media/dvb/frontends/lgs8gxx.c
index 4de1d35..568363a 100644
--- a/drivers/media/dvb/frontends/lgs8gxx.c
+++ b/drivers/media/dvb/frontends/lgs8gxx.c
@@ -262,7 +262,6 @@ static int lgs8gxx_set_mode_auto(struct lgs8gxx_state *priv)
 
 static int lgs8gxx_set_mode_manual(struct lgs8gxx_state *priv)
 {
-	int ret = 0;
 	u8 t;
 
 	if (priv->config->prod == LGS8GXX_PROD_LGS8G75) {
@@ -296,7 +295,7 @@ static int lgs8gxx_set_mode_manual(struct lgs8gxx_state *priv)
 	if (priv->config->prod == LGS8GXX_PROD_LGS8913)
 		lgs8gxx_write_reg(priv, 0xC1, 0);
 
-	ret = lgs8gxx_read_reg(priv, 0xC5, &t);
+	lgs8gxx_read_reg(priv, 0xC5, &t);
 	t = (t & 0xE0) | 0x06;
 	lgs8gxx_write_reg(priv, 0xC5, t);
 
diff --git a/drivers/media/dvb/frontends/m88rs2000.c b/drivers/media/dvb/frontends/m88rs2000.c
index 045ee5a..82cc145 100644
--- a/drivers/media/dvb/frontends/m88rs2000.c
+++ b/drivers/media/dvb/frontends/m88rs2000.c
@@ -654,7 +654,6 @@ static int m88rs2000_set_tuner(struct dvb_frontend *fe, u16 *offset)
 static int m88rs2000_set_fec(struct m88rs2000_state *state,
 		fe_code_rate_t fec)
 {
-	int ret;
 	u16 fec_set;
 	switch (fec) {
 	/* This is not confirmed kept for reference */
@@ -677,7 +676,7 @@ static int m88rs2000_set_fec(struct m88rs2000_state *state,
 	default:
 		fec_set = 0x08;
 	}
-	ret = m88rs2000_demod_write(state, 0x76, fec_set);
+	m88rs2000_demod_write(state, 0x76, fec_set);
 
 	return 0;
 }
diff --git a/drivers/media/dvb/frontends/stb6100.c b/drivers/media/dvb/frontends/stb6100.c
index def88ab..2e93e65 100644
--- a/drivers/media/dvb/frontends/stb6100.c
+++ b/drivers/media/dvb/frontends/stb6100.c
@@ -158,7 +158,6 @@ static int stb6100_read_regs(struct stb6100_state *state, u8 regs[])
 static int stb6100_read_reg(struct stb6100_state *state, u8 reg)
 {
 	u8 regs[STB6100_NUMREGS];
-	int rc;
 
 	struct i2c_msg msg = {
 		.addr	= state->config->tuner_address + reg,
@@ -167,7 +166,7 @@ static int stb6100_read_reg(struct stb6100_state *state, u8 reg)
 		.len	= 1
 	};
 
-	rc = i2c_transfer(state->i2c, &msg, 1);
+	i2c_transfer(state->i2c, &msg, 1);
 
 	if (unlikely(reg >= STB6100_NUMREGS)) {
 		dprintk(verbose, FE_ERROR, 1, "Invalid register offset 0x%x", reg);
diff --git a/drivers/media/dvb/frontends/stv0297.c b/drivers/media/dvb/frontends/stv0297.c
index 85c157a..d40f226 100644
--- a/drivers/media/dvb/frontends/stv0297.c
+++ b/drivers/media/dvb/frontends/stv0297.c
@@ -414,7 +414,6 @@ static int stv0297_set_frontend(struct dvb_frontend *fe)
 	int delay;
 	int sweeprate;
 	int carrieroffset;
-	unsigned long starttime;
 	unsigned long timeout;
 	fe_spectral_inversion_t inversion;
 
@@ -543,7 +542,6 @@ static int stv0297_set_frontend(struct dvb_frontend *fe)
 	stv0297_writereg_mask(state, 0x43, 0x10, 0x10);
 
 	/* wait for WGAGC lock */
-	starttime = jiffies;
 	timeout = jiffies + msecs_to_jiffies(2000);
 	while (time_before(jiffies, timeout)) {
 		msleep(10);
diff --git a/drivers/media/dvb/frontends/stv090x.c b/drivers/media/dvb/frontends/stv090x.c
index 4aef187..d79e69f 100644
--- a/drivers/media/dvb/frontends/stv090x.c
+++ b/drivers/media/dvb/frontends/stv090x.c
@@ -2842,7 +2842,6 @@ static int stv090x_optimize_track(struct stv090x_state *state)
 {
 	struct dvb_frontend *fe = &state->frontend;
 
-	enum stv090x_rolloff rolloff;
 	enum stv090x_modcod modcod;
 
 	s32 srate, pilots, aclc, f_1, f_0, i = 0, blind_tune = 0;
@@ -2966,7 +2965,6 @@ static int stv090x_optimize_track(struct stv090x_state *state)
 	f_1 = STV090x_READ_DEMOD(state, CFR2);
 	f_0 = STV090x_READ_DEMOD(state, CFR1);
 	reg = STV090x_READ_DEMOD(state, TMGOBS);
-	rolloff = STV090x_GETFIELD_Px(reg, ROLLOFF_STATUS_FIELD);
 
 	if (state->algo == STV090x_BLIND_SEARCH) {
 		STV090x_WRITE_DEMOD(state, SFRSTEP, 0x00);
diff --git a/drivers/media/dvb/frontends/zl10353.c b/drivers/media/dvb/frontends/zl10353.c
index ac72378..4de3691 100644
--- a/drivers/media/dvb/frontends/zl10353.c
+++ b/drivers/media/dvb/frontends/zl10353.c
@@ -559,7 +559,6 @@ static int zl10353_init(struct dvb_frontend *fe)
 {
 	struct zl10353_state *state = fe->demodulator_priv;
 	u8 zl10353_reset_attach[6] = { 0x50, 0x03, 0x64, 0x46, 0x15, 0x0F };
-	int rc = 0;
 
 	if (debug_regs)
 		zl10353_dump_regs(fe);
@@ -573,7 +572,7 @@ static int zl10353_init(struct dvb_frontend *fe)
 	/* Do a "hard" reset if not already done */
 	if (zl10353_read_register(state, 0x50) != zl10353_reset_attach[1] ||
 	    zl10353_read_register(state, 0x51) != zl10353_reset_attach[2]) {
-		rc = zl10353_write(fe, zl10353_reset_attach,
+		zl10353_write(fe, zl10353_reset_attach,
 				   sizeof(zl10353_reset_attach));
 		if (debug_regs)
 			zl10353_dump_regs(fe);
diff --git a/drivers/media/dvb/siano/smssdio.c b/drivers/media/dvb/siano/smssdio.c
index 91f8c82..d6f3f10 100644
--- a/drivers/media/dvb/siano/smssdio.c
+++ b/drivers/media/dvb/siano/smssdio.c
@@ -114,7 +114,7 @@ out:
 
 static void smssdio_interrupt(struct sdio_func *func)
 {
-	int ret, isr;
+	int ret;
 
 	struct smssdio_device *smsdev;
 	struct smscore_buffer_t *cb;
@@ -127,7 +127,7 @@ static void smssdio_interrupt(struct sdio_func *func)
 	 * The interrupt register has no defined meaning. It is just
 	 * a way of turning of the level triggered interrupt.
 	 */
-	isr = sdio_readb(func, SMSSDIO_INT, &ret);
+	(void)sdio_readb(func, SMSSDIO_INT, &ret);
 	if (ret) {
 		sms_err("Unable to read interrupt register!\n");
 		return;
-- 
1.7.9.5

