Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:49824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753Ab1GKB7c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 21:59:32 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xVWd023439
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:31 -0400
Received: from pedra (vpn-225-29.phx2.redhat.com [10.3.225.29])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xKKU030664
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:30 -0400
Date: Sun, 10 Jul 2011 22:58:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 03/21] [media] drxk: Add debug printk's
Message-ID: <20110710225850.18b66db3@pedra>
In-Reply-To: <cover.1310347962.git.mchehab@redhat.com>
References: <cover.1310347962.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

This is a complex driver. Adding support for other devices with drxk
requires to be able to debug it and see where it is failing. So, add
optional printk messages to allow debugging it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index f550332..fe94459 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -173,6 +173,16 @@ bool IsA1WithRomCode(struct drxk_state *state)
 #define DRXK_QAM_SL_SIG_POWER_QAM128      (20992)
 #define DRXK_QAM_SL_SIG_POWER_QAM256      (43520)
 
+static unsigned int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "enable debug messages");
+
+#define dprintk(level, fmt, arg...) do {			\
+if (debug >= level)						\
+	printk(KERN_DEBUG "drxk: %s" fmt, __func__, ## arg);	\
+} while (0)
+
+
 static inline u32 MulDiv32(u32 a, u32 b, u32 c)
 {
 	u64 tmp64;
@@ -316,6 +326,13 @@ static int i2c_write(struct i2c_adapter *adap, u8 adr, u8 *data, int len)
 	struct i2c_msg msg = {
 	    .addr = adr, .flags = 0, .buf = data, .len = len };
 
+	dprintk(3, ":");
+	if (debug > 2) {
+		int i;
+		for (i = 0; i < len; i++)
+			printk(KERN_CONT " %02x", data[i]);
+		printk(KERN_CONT "\n");
+	}
 	if (i2c_transfer(adap, &msg, 1) != 1) {
 		printk(KERN_ERR "drxk: i2c write error at addr 0x%02x\n", adr);
 		return -1;
@@ -331,10 +348,27 @@ static int i2c_read(struct i2c_adapter *adap,
 	{.addr = adr, .flags = I2C_M_RD,
 	 .buf = answ, .len = alen}
 	};
+	dprintk(3, ":");
+	if (debug > 2) {
+		int i;
+		for (i = 0; i < len; i++)
+			printk(KERN_CONT " %02x", msg[i]);
+		printk(KERN_CONT "\n");
+	}
 	if (i2c_transfer(adap, msgs, 2) != 2) {
+		if (debug > 2)
+			printk(KERN_CONT ": ERROR!\n");
+
 		printk(KERN_ERR "drxk: i2c read error at addr 0x%02x\n", adr);
 		return -1;
 	}
+	if (debug > 2) {
+		int i;
+		printk(KERN_CONT ": Read ");
+		for (i = 0; i < len; i++)
+			printk(KERN_CONT " %02x", msg[i]);
+		printk(KERN_CONT "\n");
+	}
 	return 0;
 }
 
@@ -355,10 +389,12 @@ static int Read16(struct drxk_state *state, u32 reg, u16 *data, u8 flags)
 		mm1[1] = (((reg >> 16) & 0x0F) | ((reg >> 18) & 0xF0));
 		len = 2;
 	}
+	dprintk(2, "(0x%08x, 0x%02x)\n", reg, flags);
 	if (i2c_read(state->i2c, adr, mm1, len, mm2, 2) < 0)
 		return -1;
 	if (data)
 		*data = mm2[0] | (mm2[1] << 8);
+
 	return 0;
 }
 
@@ -384,11 +420,13 @@ static int Read32(struct drxk_state *state, u32 reg, u32 *data, u8 flags)
 		mm1[1] = (((reg >> 16) & 0x0F) | ((reg >> 18) & 0xF0));
 		len = 2;
 	}
+	dprintk(2, "(0x%08x, 0x%02x)\n", reg, flags);
 	if (i2c_read(state->i2c, adr, mm1, len, mm2, 4) < 0)
 		return -1;
 	if (data)
 		*data = mm2[0] | (mm2[1] << 8) |
 		    (mm2[2] << 16) | (mm2[3] << 24);
+
 	return 0;
 }
 
@@ -411,6 +449,8 @@ static int Write16(struct drxk_state *state, u32 reg, u16 data, u8 flags)
 	}
 	mm[len] = data & 0xff;
 	mm[len + 1] = (data >> 8) & 0xff;
+
+	dprintk(2, "(0x%08x, 0x%04x, 0x%02x)\n", reg, data, flags);
 	if (i2c_write(state->i2c, adr, mm, len + 2) < 0)
 		return -1;
 	return 0;
@@ -442,6 +482,7 @@ static int Write32(struct drxk_state *state, u32 reg, u32 data, u8 flags)
 	mm[len + 1] = (data >> 8) & 0xff;
 	mm[len + 2] = (data >> 16) & 0xff;
 	mm[len + 3] = (data >> 24) & 0xff;
+	dprintk(2, "(0x%08x, 0x%08x, 0x%02x)\n", reg, data, flags);
 	if (i2c_write(state->i2c, adr, mm, len + 4) < 0)
 		return -1;
 	return 0;
@@ -476,6 +517,14 @@ static int WriteBlock(struct drxk_state *state, u32 Address,
 			AdrLength = 2;
 		}
 		memcpy(&state->Chunk[AdrLength], pBlock, Chunk);
+		dprintk(2, "(0x%08x, 0x%02x)\n", Address, Flags);
+		if (debug > 1) {
+			int i;
+			if (pBlock)
+				for (i = 0; i < Chunk; i++)
+					printk(KERN_CONT " %02x", pBlock[i]);
+			printk(KERN_CONT "\n");
+		}
 		status = i2c_write(state->i2c, state->demod_address,
 				   &state->Chunk[0], Chunk + AdrLength);
 		if (status < 0) {
@@ -500,6 +549,8 @@ int PowerUpDevice(struct drxk_state *state)
 	u8 data = 0;
 	u16 retryCount = 0;
 
+	dprintk(1, "\n");
+
 	status = i2c_read1(state->i2c, state->demod_address, &data);
 	if (status < 0)
 		do {
@@ -592,6 +643,8 @@ static int init_state(struct drxk_state *state)
 	u32 ulAntennaDVBC = 0;
 	u32 ulAntennaSwitchDVBTDVBC = 0;
 
+	dprintk(1, "\n");
+
 	state->m_hasLNA = false;
 	state->m_hasDVBT = false;
 	state->m_hasDVBC = false;
@@ -794,6 +847,7 @@ static int DRXX_Open(struct drxk_state *state)
 	u16 bid = 0;
 	u16 key = 0;
 
+	dprintk(1, "\n");
 	do {
 		/* stop lock indicator process */
 		status = Write16_0(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
@@ -825,6 +879,7 @@ static int GetDeviceCapabilities(struct drxk_state *state)
 	u32 sioTopJtagidLo = 0;
 	int status;
 
+	dprintk(1, "\n");
 	do {
 		/* driver 0.9.0 */
 		/* stop lock indicator process */
@@ -1004,6 +1059,8 @@ static int HI_Command(struct drxk_state *state, u16 cmd, u16 *pResult)
 	int status;
 	bool powerdown_cmd;
 
+	dprintk(1, "\n");
+
 	/* Write command */
 	status = Write16_0(state, SIO_HI_RA_RAM_CMD__A, cmd);
 	if (status < 0)
@@ -1040,6 +1097,8 @@ static int HI_CfgCommand(struct drxk_state *state)
 {
 	int status;
 
+	dprintk(1, "\n");
+
 	mutex_lock(&state->mutex);
 	do {
 		status = Write16_0(state, SIO_HI_RA_RAM_PAR_6__A, state->m_HICfgTimeout);
@@ -1072,6 +1131,8 @@ static int HI_CfgCommand(struct drxk_state *state)
 
 static int InitHI(struct drxk_state *state)
 {
+	dprintk(1, "\n");
+
 	state->m_HICfgWakeUpKey = (state->demod_address << 1);
 	state->m_HICfgTimeout = 0x96FF;
 	/* port/bridge/power down ctrl */
@@ -1085,6 +1146,7 @@ static int MPEGTSConfigurePins(struct drxk_state *state, bool mpegEnable)
 	u16 sioPdrMclkCfg = 0;
 	u16 sioPdrMdxCfg = 0;
 
+	dprintk(1, "\n");
 	do {
 		/* stop lock indicator process */
 		status = Write16_0(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
@@ -1223,6 +1285,8 @@ static int MPEGTSConfigurePins(struct drxk_state *state, bool mpegEnable)
 
 static int MPEGTSDisable(struct drxk_state *state)
 {
+	dprintk(1, "\n");
+
 	return MPEGTSConfigurePins(state, false);
 }
 
@@ -1233,6 +1297,8 @@ static int BLChainCmd(struct drxk_state *state,
 	int status;
 	unsigned long end;
 
+	dprintk(1, "\n");
+
 	mutex_lock(&state->mutex);
 	do {
 		status = Write16_0(state, SIO_BL_MODE__A, SIO_BL_MODE_CHAIN);
@@ -1281,6 +1347,8 @@ static int DownloadMicrocode(struct drxk_state *state,
 	u32 i;
 	int status = 0;
 
+	dprintk(1, "\n");
+
 	/* down the drain (we don care about MAGIC_WORD) */
 	Drain = (pSrc[0] << 8) | pSrc[1];
 	pSrc += sizeof(u16);
@@ -1323,6 +1391,8 @@ static int DVBTEnableOFDMTokenRing(struct drxk_state *state, bool enable)
 	u16 desiredStatus = SIO_OFDM_SH_OFDM_RING_STATUS_ENABLED;
 	unsigned long end;
 
+	dprintk(1, "\n");
+
 	if (enable == false) {
 		desiredCtrl = SIO_OFDM_SH_OFDM_RING_ENABLE_OFF;
 		desiredStatus = SIO_OFDM_SH_OFDM_RING_STATUS_DOWN;
@@ -1357,6 +1427,8 @@ static int MPEGTSStop(struct drxk_state *state)
 	u16 fecOcSncMode = 0;
 	u16 fecOcIprMode = 0;
 
+	dprintk(1, "\n");
+
 	do {
 		/* Gracefull shutdown (byte boundaries) */
 		status = Read16_0(state, FEC_OC_SNC_MODE__A, &fecOcSncMode);
@@ -1390,6 +1462,8 @@ static int scu_command(struct drxk_state *state,
 	int status;
 	unsigned long end;
 
+	dprintk(1, "\n");
+
 	if ((cmd == 0) || ((parameterLen > 0) && (parameter == NULL)) ||
 	    ((resultLen > 0) && (result == NULL)))
 		return -1;
@@ -1469,6 +1543,8 @@ static int SetIqmAf(struct drxk_state *state, bool active)
 	u16 data = 0;
 	int status;
 
+	dprintk(1, "\n");
+
 	do {
 		/* Configure IQM */
 		status = Read16_0(state, IQM_AF_STDBY__A, &data);
@@ -1501,6 +1577,8 @@ static int CtrlPowerMode(struct drxk_state *state, enum DRXPowerMode *mode)
 	int status = 0;
 	u16 sioCcPwdMode = 0;
 
+	dprintk(1, "\n");
+
 	/* Check arguments */
 	if (mode == NULL)
 		return -1;
@@ -1607,6 +1685,8 @@ static int PowerDownDVBT(struct drxk_state *state, bool setPowerMode)
 	u16 data = 0;
 	int status;
 
+	dprintk(1, "\n");
+
 	do {
 		status = Read16_0(state, SCU_COMM_EXEC__A, &data);
 		if (status < 0)
@@ -1653,6 +1733,7 @@ static int SetOperationMode(struct drxk_state *state,
 {
 	int status = 0;
 
+	dprintk(1, "\n");
 	/*
 	   Stop and power down previous standard
 	   TODO investigate total power down instead of partial
@@ -1734,6 +1815,7 @@ static int Start(struct drxk_state *state, s32 offsetFreq,
 {
 	int status = 0;
 
+	dprintk(1, "\n");
 	do {
 		u16 IFreqkHz;
 		s32 OffsetkHz = offsetFreq / 1000;
@@ -1783,6 +1865,8 @@ static int Start(struct drxk_state *state, s32 offsetFreq,
 
 static int ShutDown(struct drxk_state *state)
 {
+	dprintk(1, "\n");
+
 	MPEGTSStop(state);
 	return 0;
 }
@@ -1792,6 +1876,8 @@ static int GetLockStatus(struct drxk_state *state, u32 *pLockStatus,
 {
 	int status = 0;
 
+	dprintk(1, "\n");
+
 	if (pLockStatus == NULL)
 		return -1;
 
@@ -1839,6 +1925,8 @@ static int MPEGTSDtoInit(struct drxk_state *state)
 {
 	int status = -1;
 
+	dprintk(1, "\n");
+
 	do {
 		/* Rate integration settings */
 		status = Write16_0(state, FEC_OC_RCN_CTL_STEP_LO__A, 0x0000);
@@ -1897,6 +1985,8 @@ static int MPEGTSDtoSetup(struct drxk_state *state,
 	u32 maxBitRate = 0;
 	bool staticCLK = false;
 
+	dprintk(1, "\n");
+
 	do {
 		/* Check insertion of the Reed-Solomon parity bytes */
 		status = Read16_0(state, FEC_OC_MODE__A, &fecOcRegMode);
@@ -2021,6 +2111,8 @@ static int MPEGTSConfigurePolarity(struct drxk_state *state)
 	int status;
 	u16 fecOcRegIprInvert = 0;
 
+	dprintk(1, "\n");
+
 	/* Data mask for the output data byte */
 	u16 InvertDataMask =
 	    FEC_OC_IPR_INVERT_MD7__M | FEC_OC_IPR_INVERT_MD6__M |
@@ -2056,6 +2148,8 @@ static int SetAgcRf(struct drxk_state *state,
 	int status = 0;
 	struct SCfgAgc *pIfAgcSettings;
 
+	dprintk(1, "\n");
+
 	if (pAgcCfg == NULL)
 		return -1;
 
@@ -2202,6 +2296,8 @@ static int SetAgcIf(struct drxk_state *state,
 	int status = 0;
 	struct SCfgAgc *pRfAgcSettings;
 
+	dprintk(1, "\n");
+
 	do {
 		switch (pAgcCfg->ctrlMode) {
 		case DRXK_AGC_CTRL_AUTO:
@@ -2327,6 +2423,8 @@ static int ReadIFAgc(struct drxk_state *state, u32 *pValue)
 	u16 agcDacLvl;
 	int status = Read16_0(state, IQM_AF_AGC_IF__A, &agcDacLvl);
 
+	dprintk(1, "\n");
+
 	*pValue = 0;
 
 	if (status == 0) {
@@ -2346,6 +2444,8 @@ static int GetQAMSignalToNoise(struct drxk_state *state,
 {
 	int status = 0;
 
+	dprintk(1, "\n");
+
 	do {
 		/* MER calculation */
 		u16 qamSlErrPower = 0;	/* accum. error between
@@ -2406,6 +2506,7 @@ static int GetDVBTSignalToNoise(struct drxk_state *state,
 	u32 iMER = 0;
 	u16 transmissionParams = 0;
 
+	dprintk(1, "\n");
 	do {
 		status = Read16_0(state, OFDM_EQ_TOP_TD_TPS_PWR_OFS__A, &EqRegTdTpsPwrOfs);
 		if (status < 0)
@@ -2491,6 +2592,8 @@ static int GetDVBTSignalToNoise(struct drxk_state *state,
 
 static int GetSignalToNoise(struct drxk_state *state, s32 *pSignalToNoise)
 {
+	dprintk(1, "\n");
+
 	*pSignalToNoise = 0;
 	switch (state->m_OperationMode) {
 	case OM_DVBT:
@@ -2510,6 +2613,8 @@ static int GetDVBTQuality(struct drxk_state *state, s32 *pQuality)
 	/* SNR Values for quasi errorfree reception rom Nordig 2.2 */
 	int status = 0;
 
+	dprintk(1, "\n");
+
 	static s32 QE_SN[] = {
 		51,		/* QPSK 1/2 */
 		69,		/* QPSK 2/3 */
@@ -2573,6 +2678,8 @@ static int GetDVBCQuality(struct drxk_state *state, s32 *pQuality)
 	int status = 0;
 	*pQuality = 0;
 
+	dprintk(1, "\n");
+
 	do {
 		u32 SignalToNoise = 0;
 		u32 BERQuality = 100;
@@ -2615,6 +2722,8 @@ static int GetDVBCQuality(struct drxk_state *state, s32 *pQuality)
 
 static int GetQuality(struct drxk_state *state, s32 *pQuality)
 {
+	dprintk(1, "\n");
+
 	switch (state->m_OperationMode) {
 	case OM_DVBT:
 		return GetDVBTQuality(state, pQuality);
@@ -2645,6 +2754,8 @@ static int ConfigureI2CBridge(struct drxk_state *state, bool bEnableBridge)
 {
 	int status;
 
+	dprintk(1, "\n");
+
 	if (state->m_DrxkState == DRXK_UNINITIALIZED)
 		return -1;
 	if (state->m_DrxkState == DRXK_POWERED_DOWN)
@@ -2676,6 +2787,8 @@ static int SetPreSaw(struct drxk_state *state,
 {
 	int status;
 
+	dprintk(1, "\n");
+
 	if ((pPreSawCfg == NULL)
 	    || (pPreSawCfg->reference > IQM_AF_PDREF__M))
 		return -1;
@@ -2693,6 +2806,8 @@ static int BLDirectCmd(struct drxk_state *state, u32 targetAddr,
 	int status;
 	unsigned long end;
 
+	dprintk(1, "\n");
+
 	mutex_lock(&state->mutex);
 	do {
 		status = Write16_0(state, SIO_BL_MODE__A, SIO_BL_MODE_DIRECT);
@@ -2736,6 +2851,8 @@ static int ADCSyncMeasurement(struct drxk_state *state, u16 *count)
 	u16 data = 0;
 	int status;
 
+	dprintk(1, "\n");
+
 	do {
 		/* Start measurement */
 		status = Write16_0(state, IQM_AF_COMM_EXEC__A, IQM_AF_COMM_EXEC_ACTIVE);
@@ -2770,6 +2887,8 @@ static int ADCSynchronization(struct drxk_state *state)
 	u16 count = 0;
 	int status;
 
+	dprintk(1, "\n");
+
 	do {
 		status = ADCSyncMeasurement(state, &count);
 		if (status < 0)
@@ -2822,6 +2941,8 @@ static int SetFrequencyShifter(struct drxk_state *state,
 	u32 frequencyShift;
 	bool imageToSelect;
 
+	dprintk(1, "\n");
+
 	/*
 	   Program frequency shifter
 	   No need to account for mirroring on RF
@@ -2889,6 +3010,8 @@ static int InitAGC(struct drxk_state *state, bool isDTV)
 	u16 clpCtrlMode = 0;
 	int status = 0;
 
+	dprintk(1, "\n");
+
 	do {
 		/* Common settings */
 		snsSumMax = 1023;
@@ -3067,6 +3190,7 @@ static int DVBTQAMGetAccPktErr(struct drxk_state *state, u16 *packetErr)
 {
 	int status;
 
+	dprintk(1, "\n");
 	do {
 		if (packetErr == NULL) {
 			status = Write16_0(state, SCU_RAM_FEC_ACCUM_PKT_FAILURES__A, 0);
@@ -3092,6 +3216,7 @@ static int DVBTScCommand(struct drxk_state *state,
 	u16 scExec = 0;
 	int status;
 
+	dprintk(1, "\n");
 	status = Read16_0(state, OFDM_SC_COMM_EXEC__A, &scExec);
 	if (scExec != 1) {
 		/* SC is not running */
@@ -3197,6 +3322,7 @@ static int PowerUpDVBT(struct drxk_state *state)
 	enum DRXPowerMode powerMode = DRX_POWER_UP;
 	int status;
 
+	dprintk(1, "\n");
 	do {
 		status = CtrlPowerMode(state, &powerMode);
 		if (status < 0)
@@ -3209,6 +3335,7 @@ static int DVBTCtrlSetIncEnable(struct drxk_state *state, bool *enabled)
 {
 	int status;
 
+	dprintk(1, "\n");
 	if (*enabled == true)
 		status = Write16_0(state, IQM_CF_BYPASSDET__A, 0);
 	else
@@ -3223,6 +3350,7 @@ static int DVBTCtrlSetFrEnable(struct drxk_state *state, bool *enabled)
 
 	int status;
 
+	dprintk(1, "\n");
 	if (*enabled == true) {
 		/* write mask to 1 */
 		status = Write16_0(state, OFDM_SC_RA_RAM_FR_THRES_8K__A,
@@ -3241,6 +3369,7 @@ static int DVBTCtrlSetEchoThreshold(struct drxk_state *state,
 	u16 data = 0;
 	int status;
 
+	dprintk(1, "\n");
 	do {
 		status = Read16_0(state, OFDM_SC_RA_RAM_ECHO_THRES__A, &data);
 		if (status < 0)
@@ -3279,6 +3408,8 @@ static int DVBTCtrlSetSqiSpeed(struct drxk_state *state,
 {
 	int status;
 
+	dprintk(1, "\n");
+
 	switch (*speed) {
 	case DRXK_DVBT_SQI_SPEED_FAST:
 	case DRXK_DVBT_SQI_SPEED_MEDIUM:
@@ -3309,6 +3440,7 @@ static int DVBTActivatePresets(struct drxk_state *state)
 	struct DRXKCfgDvbtEchoThres_t echoThres2k = { 0, DRX_FFTMODE_2K };
 	struct DRXKCfgDvbtEchoThres_t echoThres8k = { 0, DRX_FFTMODE_8K };
 
+	dprintk(1, "\n");
 	do {
 		bool setincenable = false;
 		bool setfrenable = true;
@@ -3349,8 +3481,9 @@ static int SetDVBTStandard(struct drxk_state *state,
 	u16 data = 0;
 	int status;
 
+	dprintk(1, "\n");
+
 	PowerUpDVBT(state);
-
 	do {
 		/* added antenna switch */
 		SwitchAntennaToDVBT(state);
@@ -3552,6 +3685,7 @@ static int DVBTStart(struct drxk_state *state)
 	int status;
 	/* DRXKOfdmScCmd_t scCmd; */
 
+	dprintk(1, "\n");
 	/* Start correct processes to get in lock */
 	/* DRXK: OFDM_SC_RA_RAM_PROC_LOCKTRACK is no longer in mapfile! */
 	do {
@@ -3590,6 +3724,7 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 	u16 param1;
 	int status;
 
+	dprintk(1, "\n");
 	/* printk(KERN_DEBUG "drxk: %s IF =%d, TFO = %d\n", __func__, IntermediateFreqkHz, tunerFreqOffset); */
 	do {
 		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_STOP, 0, NULL, 1, &cmdResult);
@@ -3926,6 +4061,8 @@ static int GetDVBTLockStatus(struct drxk_state *state, u32 *pLockStatus)
 	u16 ScRaRamLock = 0;
 	u16 ScCommExec = 0;
 
+	dprintk(1, "\n");
+
 	/* driver 0.9.0 */
 	/* Check if SC is running */
 	status = Read16_0(state, OFDM_SC_COMM_EXEC__A, &ScCommExec);
@@ -3956,6 +4093,7 @@ static int PowerUpQAM(struct drxk_state *state)
 	enum DRXPowerMode powerMode = DRXK_POWER_DOWN_OFDM;
 	int status = 0;
 
+	dprintk(1, "\n");
 	do {
 		status = CtrlPowerMode(state, &powerMode);
 		if (status < 0)
@@ -3974,6 +4112,7 @@ static int PowerDownQAM(struct drxk_state *state)
 	u16 cmdResult;
 	int status = 0;
 
+	dprintk(1, "\n");
 	do {
 		status = Read16_0(state, SCU_COMM_EXEC__A, &data);
 		if (status < 0)
@@ -4023,8 +4162,9 @@ static int SetQAMMeasurement(struct drxk_state *state,
 	u16 fecRsPeriod = 0;	/* Value for corresponding I2C register */
 	int status = 0;
 
+	dprintk(1, "\n");
+
 	fecRsPrescale = 1;
-
 	do {
 
 		/* fecBitsDesired = symbolRate [kHz] *
@@ -4099,6 +4239,7 @@ static int SetQAM16(struct drxk_state *state)
 {
 	int status = 0;
 
+	dprintk(1, "\n");
 	do {
 		/* QAM Equalizer Setup */
 		/* Equalizer */
@@ -4290,6 +4431,7 @@ static int SetQAM32(struct drxk_state *state)
 {
 	int status = 0;
 
+	dprintk(1, "\n");
 	do {
 		/* QAM Equalizer Setup */
 		/* Equalizer */
@@ -4485,6 +4627,7 @@ static int SetQAM64(struct drxk_state *state)
 {
 	int status = 0;
 
+	dprintk(1, "\n");
 	do {
 		/* QAM Equalizer Setup */
 		/* Equalizer */
@@ -4679,6 +4822,7 @@ static int SetQAM128(struct drxk_state *state)
 {
 	int status = 0;
 
+	dprintk(1, "\n");
 	do {
 		/* QAM Equalizer Setup */
 		/* Equalizer */
@@ -4875,6 +5019,7 @@ static int SetQAM256(struct drxk_state *state)
 {
 	int status = 0;
 
+	dprintk(1, "\n");
 	do {
 		/* QAM Equalizer Setup */
 		/* Equalizer */
@@ -5072,6 +5217,7 @@ static int QAMResetQAM(struct drxk_state *state)
 	int status;
 	u16 cmdResult;
 
+	dprintk(1, "\n");
 	do {
 		/* Stop QAM comstate->m_exec */
 		status = Write16_0(state, QAM_COMM_EXEC__A, QAM_COMM_EXEC_STOP);
@@ -5104,6 +5250,7 @@ static int QAMSetSymbolrate(struct drxk_state *state)
 	u32 lcSymbRate = 0;
 	int status;
 
+	dprintk(1, "\n");
 	do {
 		/* Select & calculate correct IQM rate */
 		adcFrequency = (state->m_sysClockFreq * 1000) / 3;
@@ -5169,6 +5316,7 @@ static int GetQAMLockStatus(struct drxk_state *state, u32 *pLockStatus)
 	int status;
 	u16 Result[2] = { 0, 0 };
 
+	dprintk(1, "\n");
 	status =
 	    scu_command(state,
 			SCU_RAM_COMMAND_STANDARD_QAM |
@@ -5212,6 +5360,7 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 	u16 setParamParameters[4] = { 0, 0, 0, 0 };
 	u16 cmdResult;
 
+	dprintk(1, "\n");
 	do {
 		/*
 		   STEP 1: reset demodulator
@@ -5461,6 +5610,7 @@ static int SetQAMStandard(struct drxk_state *state,
 	int status;
 #endif
 
+	dprintk(1, "\n");
 	do {
 		/* added antenna switch */
 		SwitchAntennaToQAM(state);
@@ -5622,6 +5772,7 @@ static int WriteGPIO(struct drxk_state *state)
 	int status;
 	u16 value = 0;
 
+	dprintk(1, "\n");
 	do {
 		/* stop lock indicator process */
 		status = Write16_0(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
@@ -5665,6 +5816,7 @@ static int SwitchAntennaToQAM(struct drxk_state *state)
 {
 	int status = -1;
 
+	dprintk(1, "\n");
 	if (state->m_AntennaSwitchDVBTDVBC != 0) {
 		if (state->m_GPIO != state->m_AntennaDVBC) {
 			state->m_GPIO = state->m_AntennaDVBC;
@@ -5678,6 +5830,7 @@ static int SwitchAntennaToDVBT(struct drxk_state *state)
 {
 	int status = -1;
 
+	dprintk(1, "\n");
 	if (state->m_AntennaSwitchDVBTDVBC != 0) {
 		if (state->m_GPIO != state->m_AntennaDVBT) {
 			state->m_GPIO = state->m_AntennaDVBT;
@@ -5697,6 +5850,8 @@ static int PowerDownDevice(struct drxk_state *state)
 	/* ADC power down */
 	/* Power down device */
 	int status;
+
+	dprintk(1, "\n");
 	do {
 		if (state->m_bPDownOpenBridge) {
 			/* Open I2C bridge before power down of DRXK */
@@ -5732,6 +5887,8 @@ static int load_microcode(struct drxk_state *state, char *mc_name)
 	const struct firmware *fw = NULL;
 	int err = 0;
 
+	dprintk(1, "\n");
+
 	err = request_firmware(&fw, mc_name, state->i2c->dev.parent);
 	if (err < 0) {
 		printk(KERN_ERR
@@ -5751,6 +5908,7 @@ static int init_drxk(struct drxk_state *state)
 	enum DRXPowerMode powerMode = DRXK_POWER_DOWN_OFDM;
 	u16 driverVersion;
 
+	dprintk(1, "\n");
 	if ((state->m_DrxkState == DRXK_UNINITIALIZED)) {
 		do {
 			status = PowerUpDevice(state);
@@ -5945,6 +6103,7 @@ static void drxk_c_release(struct dvb_frontend *fe)
 {
 	struct drxk_state *state = fe->demodulator_priv;
 
+	dprintk(1, "\n");
 	kfree(state);
 }
 
@@ -5952,6 +6111,7 @@ static int drxk_c_init(struct dvb_frontend *fe)
 {
 	struct drxk_state *state = fe->demodulator_priv;
 
+	dprintk(1, "\n");
 	if (mutex_trylock(&state->ctlock) == 0)
 		return -EBUSY;
 	SetOperationMode(state, OM_QAM_ITU_A);
@@ -5962,6 +6122,7 @@ static int drxk_c_sleep(struct dvb_frontend *fe)
 {
 	struct drxk_state *state = fe->demodulator_priv;
 
+	dprintk(1, "\n");
 	ShutDown(state);
 	mutex_unlock(&state->ctlock);
 	return 0;
@@ -5971,7 +6132,7 @@ static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	struct drxk_state *state = fe->demodulator_priv;
 
-	/* printk(KERN_DEBUG "drxk: drxk_gate %d\n", enable); */
+	dprintk(1, "%s\n", enable ? "enable" : "disable");
 	return ConfigureI2CBridge(state, enable ? true : false);
 }
 
@@ -5981,6 +6142,7 @@ static int drxk_set_parameters(struct dvb_frontend *fe,
 	struct drxk_state *state = fe->demodulator_priv;
 	u32 IF;
 
+	dprintk(1, "\n");
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 	if (fe->ops.tuner_ops.set_params)
@@ -5999,6 +6161,7 @@ static int drxk_set_parameters(struct dvb_frontend *fe,
 static int drxk_c_get_frontend(struct dvb_frontend *fe,
 			       struct dvb_frontend_parameters *p)
 {
+	dprintk(1, "\n");
 	return 0;
 }
 
@@ -6007,6 +6170,7 @@ static int drxk_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	struct drxk_state *state = fe->demodulator_priv;
 	u32 stat;
 
+	dprintk(1, "\n");
 	*status = 0;
 	GetLockStatus(state, &stat, 0);
 	if (stat == MPEG_LOCK)
@@ -6020,6 +6184,8 @@ static int drxk_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 static int drxk_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
+	dprintk(1, "\n");
+
 	*ber = 0;
 	return 0;
 }
@@ -6030,6 +6196,7 @@ static int drxk_read_signal_strength(struct dvb_frontend *fe,
 	struct drxk_state *state = fe->demodulator_priv;
 	u32 val;
 
+	dprintk(1, "\n");
 	ReadIFAgc(state, &val);
 	*strength = val & 0xffff;
 	return 0;
@@ -6040,6 +6207,7 @@ static int drxk_read_snr(struct dvb_frontend *fe, u16 *snr)
 	struct drxk_state *state = fe->demodulator_priv;
 	s32 snr2;
 
+	dprintk(1, "\n");
 	GetSignalToNoise(state, &snr2);
 	*snr = snr2 & 0xffff;
 	return 0;
@@ -6050,6 +6218,7 @@ static int drxk_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 	struct drxk_state *state = fe->demodulator_priv;
 	u16 err;
 
+	dprintk(1, "\n");
 	DVBTQAMGetAccPktErr(state, &err);
 	*ucblocks = (u32) err;
 	return 0;
@@ -6058,6 +6227,7 @@ static int drxk_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 static int drxk_c_get_tune_settings(struct dvb_frontend *fe, struct dvb_frontend_tune_settings
 				    *sets)
 {
+	dprintk(1, "\n");
 	sets->min_delay_ms = 3000;
 	sets->max_drift = 0;
 	sets->step_size = 0;
@@ -6069,7 +6239,7 @@ static void drxk_t_release(struct dvb_frontend *fe)
 #if 0
 	struct drxk_state *state = fe->demodulator_priv;
 
-	printk(KERN_DEBUG "drxk: %s\n", __func__);
+	dprintk(1, "\n");
 	kfree(state);
 #endif
 }
@@ -6077,6 +6247,8 @@ static void drxk_t_release(struct dvb_frontend *fe)
 static int drxk_t_init(struct dvb_frontend *fe)
 {
 	struct drxk_state *state = fe->demodulator_priv;
+
+	dprintk(1, "\n");
 	if (mutex_trylock(&state->ctlock) == 0)
 		return -EBUSY;
 	SetOperationMode(state, OM_DVBT);
@@ -6086,6 +6258,8 @@ static int drxk_t_init(struct dvb_frontend *fe)
 static int drxk_t_sleep(struct dvb_frontend *fe)
 {
 	struct drxk_state *state = fe->demodulator_priv;
+
+	dprintk(1, "\n");
 	mutex_unlock(&state->ctlock);
 	return 0;
 }
@@ -6093,6 +6267,8 @@ static int drxk_t_sleep(struct dvb_frontend *fe)
 static int drxk_t_get_frontend(struct dvb_frontend *fe,
 			       struct dvb_frontend_parameters *p)
 {
+	dprintk(1, "\n");
+
 	return 0;
 }
 
@@ -6159,6 +6335,7 @@ struct dvb_frontend *drxk_attach(struct i2c_adapter *i2c, u8 adr,
 {
 	struct drxk_state *state = NULL;
 
+	dprintk(1, "\n");
 	state = kzalloc(sizeof(struct drxk_state), GFP_KERNEL);
 	if (!state)
 		return NULL;
-- 
1.7.1


