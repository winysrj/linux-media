Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab1L3PJ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:27 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9ROW024167
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:27 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 26/94] [media] drxk: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:23 -0200
Message-Id: <1325257711-12274-27-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using dvb_frontend_parameters struct, that were
designed for a subset of the supported standards, use the DVBv5
cache information.

Also, fill the supported delivery systems at dvb_frontend_ops
struct.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/drxk_hard.c |  127 +++++++++++--------------------
 drivers/media/dvb/frontends/drxk_hard.h |    2 +-
 2 files changed, 44 insertions(+), 85 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 2299e1d3..36e1c82 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -1885,7 +1885,7 @@ static int Start(struct drxk_state *state, s32 offsetFreq,
 		state->m_DrxkState != DRXK_DTV_STARTED)
 		goto error;
 
-	state->m_bMirrorFreqSpect = (state->param.inversion == INVERSION_ON);
+	state->m_bMirrorFreqSpect = (state->props.inversion == INVERSION_ON);
 
 	if (IntermediateFrequency < 0) {
 		state->m_bMirrorFreqSpect = !state->m_bMirrorFreqSpect;
@@ -2507,7 +2507,7 @@ static int GetQAMSignalToNoise(struct drxk_state *state,
 	u16 qamSlErrPower = 0;	/* accum. error between
 					raw and sliced symbols */
 	u32 qamSlSigPower = 0;	/* used for MER, depends of
-					QAM constellation */
+					QAM modulation */
 	u32 qamSlMer = 0;	/* QAM MER */
 
 	dprintk(1, "\n");
@@ -2521,7 +2521,7 @@ static int GetQAMSignalToNoise(struct drxk_state *state,
 		return -EINVAL;
 	}
 
-	switch (state->param.u.qam.modulation) {
+	switch (state->props.modulation) {
 	case QAM_16:
 		qamSlSigPower = DRXK_QAM_SL_SIG_POWER_QAM16 << 2;
 		break;
@@ -2752,7 +2752,7 @@ static int GetDVBCQuality(struct drxk_state *state, s32 *pQuality)
 		if (status < 0)
 			break;
 
-		switch (state->param.u.qam.modulation) {
+		switch (state->props.modulation) {
 		case QAM_16:
 			SignalToNoiseRel = SignalToNoise - 200;
 			break;
@@ -3817,7 +3817,7 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 	/*== Write channel settings to device =====================================*/
 
 	/* mode */
-	switch (state->param.u.ofdm.transmission_mode) {
+	switch (state->props.transmission_mode) {
 	case TRANSMISSION_MODE_AUTO:
 	default:
 		operationMode |= OFDM_SC_RA_RAM_OP_AUTO_MODE__M;
@@ -3831,7 +3831,7 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 	}
 
 	/* guard */
-	switch (state->param.u.ofdm.guard_interval) {
+	switch (state->props.guard_interval) {
 	default:
 	case GUARD_INTERVAL_AUTO:
 		operationMode |= OFDM_SC_RA_RAM_OP_AUTO_GUARD__M;
@@ -3851,7 +3851,7 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 	}
 
 	/* hierarchy */
-	switch (state->param.u.ofdm.hierarchy_information) {
+	switch (state->props.hierarchy) {
 	case HIERARCHY_AUTO:
 	case HIERARCHY_NONE:
 	default:
@@ -3871,8 +3871,8 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 	}
 
 
-	/* constellation */
-	switch (state->param.u.ofdm.constellation) {
+	/* modulation */
+	switch (state->props.modulation) {
 	case QAM_AUTO:
 	default:
 		operationMode |= OFDM_SC_RA_RAM_OP_AUTO_CONST__M;
@@ -3915,7 +3915,7 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 #endif
 
 	/* coderate */
-	switch (state->param.u.ofdm.code_rate_HP) {
+	switch (state->props.code_rate_HP) {
 	case FEC_AUTO:
 	default:
 		operationMode |= OFDM_SC_RA_RAM_OP_AUTO_RATE__M;
@@ -3944,9 +3944,11 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 	/* Also set parameters for EC_OC fix, note EC_OC_REG_TMD_HIL_MAR is changed
 		by SC for fix for some 8K,1/8 guard but is restored by InitEC and ResetEC
 		functions */
-	switch (state->param.u.ofdm.bandwidth) {
-	case BANDWIDTH_AUTO:
-	case BANDWIDTH_8_MHZ:
+	switch (state->props.bandwidth_hz) {
+	case 0:
+		state->props.bandwidth_hz = 8000000;
+		/* fall though */
+	case 8000000:
 		bandwidth = DRXK_BANDWIDTH_8MHZ_IN_HZ;
 		status = write16(state, OFDM_SC_RA_RAM_SRMM_FIX_FACT_8K__A, 3052);
 		if (status < 0)
@@ -3965,7 +3967,7 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 		if (status < 0)
 			goto error;
 		break;
-	case BANDWIDTH_7_MHZ:
+	case 7000000:
 		bandwidth = DRXK_BANDWIDTH_7MHZ_IN_HZ;
 		status = write16(state, OFDM_SC_RA_RAM_SRMM_FIX_FACT_8K__A, 3491);
 		if (status < 0)
@@ -3984,7 +3986,7 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 		if (status < 0)
 			goto error;
 		break;
-	case BANDWIDTH_6_MHZ:
+	case 6000000:
 		bandwidth = DRXK_BANDWIDTH_6MHZ_IN_HZ;
 		status = write16(state, OFDM_SC_RA_RAM_SRMM_FIX_FACT_8K__A, 4073);
 		if (status < 0)
@@ -4191,7 +4193,7 @@ error:
 /**
 * \brief Setup of the QAM Measurement intervals for signal quality
 * \param demod instance of demod.
-* \param constellation current constellation.
+* \param modulation current modulation.
 * \return DRXStatus_t.
 *
 *  NOTE:
@@ -4200,7 +4202,7 @@ error:
 *
 */
 static int SetQAMMeasurement(struct drxk_state *state,
-			     enum EDrxkConstellation constellation,
+			     enum EDrxkConstellation modulation,
 			     u32 symbolRate)
 {
 	u32 fecBitsDesired = 0;	/* BER accounting period */
@@ -4214,11 +4216,11 @@ static int SetQAMMeasurement(struct drxk_state *state,
 	fecRsPrescale = 1;
 	/* fecBitsDesired = symbolRate [kHz] *
 		FrameLenght [ms] *
-		(constellation + 1) *
+		(modulation + 1) *
 		SyncLoss (== 1) *
 		ViterbiLoss (==1)
 		*/
-	switch (constellation) {
+	switch (modulation) {
 	case DRX_CONSTELLATION_QAM16:
 		fecBitsDesired = 4 * symbolRate;
 		break;
@@ -5285,12 +5287,12 @@ static int QAMSetSymbolrate(struct drxk_state *state)
 	/* Select & calculate correct IQM rate */
 	adcFrequency = (state->m_sysClockFreq * 1000) / 3;
 	ratesel = 0;
-	/* printk(KERN_DEBUG "drxk: SR %d\n", state->param.u.qam.symbol_rate); */
-	if (state->param.u.qam.symbol_rate <= 1188750)
+	/* printk(KERN_DEBUG "drxk: SR %d\n", state->props.symbol_rate); */
+	if (state->props.symbol_rate <= 1188750)
 		ratesel = 3;
-	else if (state->param.u.qam.symbol_rate <= 2377500)
+	else if (state->props.symbol_rate <= 2377500)
 		ratesel = 2;
-	else if (state->param.u.qam.symbol_rate <= 4755000)
+	else if (state->props.symbol_rate <= 4755000)
 		ratesel = 1;
 	status = write16(state, IQM_FD_RATESEL__A, ratesel);
 	if (status < 0)
@@ -5299,7 +5301,7 @@ static int QAMSetSymbolrate(struct drxk_state *state)
 	/*
 		IqmRcRate = ((Fadc / (symbolrate * (4<<ratesel))) - 1) * (1<<23)
 		*/
-	symbFreq = state->param.u.qam.symbol_rate * (1 << ratesel);
+	symbFreq = state->props.symbol_rate * (1 << ratesel);
 	if (symbFreq == 0) {
 		/* Divide by zero */
 		status = -EINVAL;
@@ -5315,7 +5317,7 @@ static int QAMSetSymbolrate(struct drxk_state *state)
 	/*
 		LcSymbFreq = round (.125 *  symbolrate / adcFreq * (1<<15))
 		*/
-	symbFreq = state->param.u.qam.symbol_rate;
+	symbFreq = state->props.symbol_rate;
 	if (adcFrequency == 0) {
 		/* Divide by zero */
 		status = -EINVAL;
@@ -5416,7 +5418,7 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 		goto error;
 
 	/* Set params */
-	switch (state->param.u.qam.modulation) {
+	switch (state->props.modulation) {
 	case QAM_256:
 		state->m_Constellation = DRX_CONSTELLATION_QAM256;
 		break;
@@ -5439,7 +5441,7 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 	}
 	if (status < 0)
 		goto error;
-	setParamParameters[0] = state->m_Constellation;	/* constellation     */
+	setParamParameters[0] = state->m_Constellation;	/* modulation     */
 	setParamParameters[1] = DRXK_QAM_I12_J17;	/* interleave mode   */
 	if (state->m_OperationMode == OM_QAM_ITU_C)
 		setParamParameters[2] = QAM_TOP_ANNEX_C;
@@ -5461,7 +5463,7 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 		if (status < 0)
 			goto error;
 
-		setParamParameters[0] = state->m_Constellation; /* constellation     */
+		setParamParameters[0] = state->m_Constellation; /* modulation     */
 		setParamParameters[1] = DRXK_QAM_I12_J17;       /* interleave mode   */
 		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_PARAM, 2, setParamParameters, 1, &cmdResult);
 	}
@@ -5470,7 +5472,7 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 
 	/*
 	 * STEP 3: enable the system in a mode where the ADC provides valid
-	 * signal setup constellation independent registers
+	 * signal setup modulation independent registers
 	 */
 #if 0
 	status = SetFrequency(channel, tunerFreqOffset));
@@ -5482,7 +5484,7 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 		goto error;
 
 	/* Setup BER measurement */
-	status = SetQAMMeasurement(state, state->m_Constellation, state->param.u. qam.symbol_rate);
+	status = SetQAMMeasurement(state, state->m_Constellation, state->props.symbol_rate);
 	if (status < 0)
 		goto error;
 
@@ -5564,8 +5566,8 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 	if (status < 0)
 		goto error;
 
-	/* STEP 4: constellation specific setup */
-	switch (state->param.u.qam.modulation) {
+	/* STEP 4: modulation specific setup */
+	switch (state->props.modulation) {
 	case QAM_16:
 		status = SetQAM16(state);
 		break;
@@ -5595,7 +5597,7 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 		goto error;
 
 	/* Re-configure MPEG output, requires knowledge of channel bitrate */
-	/* extAttr->currentChannel.constellation = channel->constellation; */
+	/* extAttr->currentChannel.modulation = channel->modulation; */
 	/* extAttr->currentChannel.symbolrate    = channel->symbolrate; */
 	status = MPEGTSDtoSetup(state, state->m_OperationMode);
 	if (status < 0)
@@ -6211,11 +6213,11 @@ static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
 	return ConfigureI2CBridge(state, enable ? true : false);
 }
 
-static int drxk_set_parameters(struct dvb_frontend *fe,
-			       struct dvb_frontend_parameters *p)
+static int drxk_set_parameters(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	u32 delsys  = p->delivery_system;
 	struct drxk_state *state = fe->demodulator_priv;
-	u32 delsys  = fe->dtv_property_cache.delivery_system;
 	u32 IF;
 
 	dprintk(1, "\n");
@@ -6243,7 +6245,7 @@ static int drxk_set_parameters(struct dvb_frontend *fe,
 		fe->ops.tuner_ops.set_params(fe);
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
-	state->param = *p;
+	state->props = *p;
 	fe->ops.tuner_ops.get_if_frequency(fe, &IF);
 	Start(state, 0, IF);
 
@@ -6252,13 +6254,6 @@ static int drxk_set_parameters(struct dvb_frontend *fe,
 	return 0;
 }
 
-static int drxk_c_get_frontend(struct dvb_frontend *fe,
-			       struct dvb_frontend_parameters *p)
-{
-	dprintk(1, "\n");
-	return 0;
-}
-
 static int drxk_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
 	struct drxk_state *state = fe->demodulator_priv;
@@ -6356,41 +6351,8 @@ static int drxk_t_sleep(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int drxk_t_get_frontend(struct dvb_frontend *fe,
-			       struct dvb_frontend_parameters *p)
-{
-	dprintk(1, "\n");
-
-	return 0;
-}
-
-static int drxk_c_get_property(struct dvb_frontend *fe, struct dtv_property *p)
-{
-	switch (p->cmd) {
-	case DTV_ENUM_DELSYS:
-		p->u.buffer.data[0] = SYS_DVBC_ANNEX_A;
-		p->u.buffer.data[1] = SYS_DVBC_ANNEX_C;
-		p->u.buffer.len = 2;
-		break;
-	default:
-		break;
-	}
-	return 0;
-}
-static int drxk_t_get_property(struct dvb_frontend *fe, struct dtv_property *p)
-{
-	switch (p->cmd) {
-	case DTV_ENUM_DELSYS:
-		p->u.buffer.data[0] = SYS_DVBT;
-		p->u.buffer.len = 1;
-		break;
-	default:
-		break;
-	}
-	return 0;
-}
-
 static struct dvb_frontend_ops drxk_c_ops = {
+	.delsys = { SYS_DVBC_ANNEX_A, SYS_DVBC_ANNEX_C },
 	.info = {
 		 .name = "DRXK DVB-C",
 		 .type = FE_QAM,
@@ -6406,9 +6368,7 @@ static struct dvb_frontend_ops drxk_c_ops = {
 	.sleep = drxk_c_sleep,
 	.i2c_gate_ctrl = drxk_gate_ctrl,
 
-	.set_frontend_legacy = drxk_set_parameters,
-	.get_frontend_legacy = drxk_c_get_frontend,
-	.get_property = drxk_c_get_property,
+	.set_frontend = drxk_set_parameters,
 	.get_tune_settings = drxk_c_get_tune_settings,
 
 	.read_status = drxk_read_status,
@@ -6419,6 +6379,7 @@ static struct dvb_frontend_ops drxk_c_ops = {
 };
 
 static struct dvb_frontend_ops drxk_t_ops = {
+	.delsys = { SYS_DVBT },
 	.info = {
 		 .name = "DRXK DVB-T",
 		 .type = FE_OFDM,
@@ -6439,9 +6400,7 @@ static struct dvb_frontend_ops drxk_t_ops = {
 	.sleep = drxk_t_sleep,
 	.i2c_gate_ctrl = drxk_gate_ctrl,
 
-	.set_frontend_legacy = drxk_set_parameters,
-	.get_frontend_legacy = drxk_t_get_frontend,
-	.get_property = drxk_t_get_property,
+	.set_frontend = drxk_set_parameters,
 
 	.read_status = drxk_read_status,
 	.read_ber = drxk_read_ber,
diff --git a/drivers/media/dvb/frontends/drxk_hard.h b/drivers/media/dvb/frontends/drxk_hard.h
index 85a423f..60bcd61 100644
--- a/drivers/media/dvb/frontends/drxk_hard.h
+++ b/drivers/media/dvb/frontends/drxk_hard.h
@@ -197,7 +197,7 @@ struct DRXKOfdmScCmd_t {
 struct drxk_state {
 	struct dvb_frontend c_frontend;
 	struct dvb_frontend t_frontend;
-	struct dvb_frontend_parameters param;
+	struct dtv_frontend_properties props;
 	struct device *dev;
 
 	struct i2c_adapter *i2c;
-- 
1.7.8.352.g876a6

