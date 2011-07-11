Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:20124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756415Ab1GKB7g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 21:59:36 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xas0023449
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:36 -0400
Received: from pedra (vpn-225-29.phx2.redhat.com [10.3.225.29])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xKKV030664
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:32 -0400
Date: Sun, 10 Jul 2011 22:58:51 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 04/21] [media] drxk: remove _0 from read/write routines
Message-ID: <20110710225851.79b11240@pedra>
In-Reply-To: <cover.1310347962.git.mchehab@redhat.com>
References: <cover.1310347962.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

The normal 16-bits read routine is called as "Read16_0". This is
due to a flags that could optionally be passed. Yet, on no places
at the code, a flag is passed there.

The same happens with 16-bits write and 32-read/write routines,
and with WriteBlock.

Also, using flags, is an exception: there's no place currently using
flags, except for an #ifdef at WriteBlock.

Rename the function as just "read16", and the one that requires flags,
as "read16_flags".

This helps to see where the flags are used, and also avoid using
CamelCase on Kernel.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index fe94459..8b2e06e 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -372,7 +372,7 @@ static int i2c_read(struct i2c_adapter *adap,
 	return 0;
 }
 
-static int Read16(struct drxk_state *state, u32 reg, u16 *data, u8 flags)
+static int read16_flags(struct drxk_state *state, u32 reg, u16 *data, u8 flags)
 {
 	u8 adr = state->demod_address, mm1[4], mm2[2], len;
 #ifdef I2C_LONG_ADR
@@ -398,12 +398,12 @@ static int Read16(struct drxk_state *state, u32 reg, u16 *data, u8 flags)
 	return 0;
 }
 
-static int Read16_0(struct drxk_state *state, u32 reg, u16 *data)
+static int read16(struct drxk_state *state, u32 reg, u16 *data)
 {
-	return Read16(state, reg, data, 0);
+	return read16_flags(state, reg, data, 0);
 }
 
-static int Read32(struct drxk_state *state, u32 reg, u32 *data, u8 flags)
+static int read32_flags(struct drxk_state *state, u32 reg, u32 *data, u8 flags)
 {
 	u8 adr = state->demod_address, mm1[4], mm2[4], len;
 #ifdef I2C_LONG_ADR
@@ -430,7 +430,12 @@ static int Read32(struct drxk_state *state, u32 reg, u32 *data, u8 flags)
 	return 0;
 }
 
-static int Write16(struct drxk_state *state, u32 reg, u16 data, u8 flags)
+static int read32(struct drxk_state *state, u32 reg, u32 *data)
+{
+	return read32_flags(state, reg, data, 0);
+}
+
+static int write16_flags(struct drxk_state *state, u32 reg, u16 data, u8 flags)
 {
 	u8 adr = state->demod_address, mm[6], len;
 #ifdef I2C_LONG_ADR
@@ -456,12 +461,12 @@ static int Write16(struct drxk_state *state, u32 reg, u16 data, u8 flags)
 	return 0;
 }
 
-static int Write16_0(struct drxk_state *state, u32 reg, u16 data)
+static int write16(struct drxk_state *state, u32 reg, u16 data)
 {
-	return Write16(state, reg, data, 0);
+	return write16_flags(state, reg, data, 0);
 }
 
-static int Write32(struct drxk_state *state, u32 reg, u32 data, u8 flags)
+static int write32_flags(struct drxk_state *state, u32 reg, u32 data, u8 flags)
 {
 	u8 adr = state->demod_address, mm[8], len;
 #ifdef I2C_LONG_ADR
@@ -488,10 +493,16 @@ static int Write32(struct drxk_state *state, u32 reg, u32 data, u8 flags)
 	return 0;
 }
 
-static int WriteBlock(struct drxk_state *state, u32 Address,
-		      const int BlockSize, const u8 pBlock[], u8 Flags)
+static int write32(struct drxk_state *state, u32 reg, u32 data)
+{
+	return write32_flags(state, reg, data, 0);
+}
+
+static int write_block(struct drxk_state *state, u32 Address,
+		      const int BlockSize, const u8 pBlock[])
 {
 	int status = 0, BlkSize = BlockSize;
+	u8 Flags = 0;
 #ifdef I2C_LONG_ADR
 	Flags |= 0xC0;
 #endif
@@ -567,14 +578,14 @@ int PowerUpDevice(struct drxk_state *state)
 		return -1;
 	do {
 		/* Make sure all clk domains are active */
-		status = Write16_0(state, SIO_CC_PWD_MODE__A, SIO_CC_PWD_MODE_LEVEL_NONE);
+		status = write16(state, SIO_CC_PWD_MODE__A, SIO_CC_PWD_MODE_LEVEL_NONE);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SIO_CC_UPDATE__A, SIO_CC_UPDATE_KEY);
+		status = write16(state, SIO_CC_UPDATE__A, SIO_CC_UPDATE_KEY);
 		if (status < 0)
 			break;
 		/* Enable pll lock tests */
-		status = Write16_0(state, SIO_CC_PLL_LOCK__A, 1);
+		status = write16(state, SIO_CC_PLL_LOCK__A, 1);
 		if (status < 0)
 			break;
 		state->m_currentPowerMode = DRX_POWER_UP;
@@ -850,23 +861,23 @@ static int DRXX_Open(struct drxk_state *state)
 	dprintk(1, "\n");
 	do {
 		/* stop lock indicator process */
-		status = Write16_0(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
+		status = write16(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
 		if (status < 0)
 			break;
 		/* Check device id */
-		status = Read16(state, SIO_TOP_COMM_KEY__A, &key, 0);
+		status = read16(state, SIO_TOP_COMM_KEY__A, &key);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SIO_TOP_COMM_KEY__A, SIO_TOP_COMM_KEY_KEY);
+		status = write16(state, SIO_TOP_COMM_KEY__A, SIO_TOP_COMM_KEY_KEY);
 		if (status < 0)
 			break;
-		status = Read32(state, SIO_TOP_JTAGID_LO__A, &jtag, 0);
+		status = read32(state, SIO_TOP_JTAGID_LO__A, &jtag);
 		if (status < 0)
 			break;
-		status = Read16(state, SIO_PDR_UIO_IN_HI__A, &bid, 0);
+		status = read16(state, SIO_PDR_UIO_IN_HI__A, &bid);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SIO_TOP_COMM_KEY__A, key);
+		status = write16(state, SIO_TOP_COMM_KEY__A, key);
 		if (status < 0)
 			break;
 	} while (0);
@@ -883,17 +894,17 @@ static int GetDeviceCapabilities(struct drxk_state *state)
 	do {
 		/* driver 0.9.0 */
 		/* stop lock indicator process */
-		status = Write16_0(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
+		status = write16(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, SIO_TOP_COMM_KEY__A, 0xFABA);
+		status = write16(state, SIO_TOP_COMM_KEY__A, 0xFABA);
 		if (status < 0)
 			break;
-		status = Read16(state, SIO_PDR_OHW_CFG__A, &sioPdrOhwCfg, 0);
+		status = read16(state, SIO_PDR_OHW_CFG__A, &sioPdrOhwCfg);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SIO_TOP_COMM_KEY__A, 0x0000);
+		status = write16(state, SIO_TOP_COMM_KEY__A, 0x0000);
 		if (status < 0)
 			break;
 
@@ -920,7 +931,7 @@ static int GetDeviceCapabilities(struct drxk_state *state)
 		   Determine device capabilities
 		   Based on pinning v14
 		 */
-		status = Read32(state, SIO_TOP_JTAGID_LO__A, &sioTopJtagidLo, 0);
+		status = read32(state, SIO_TOP_JTAGID_LO__A, &sioTopJtagidLo);
 		if (status < 0)
 			break;
 		/* driver 0.9.0 */
@@ -1062,7 +1073,7 @@ static int HI_Command(struct drxk_state *state, u16 cmd, u16 *pResult)
 	dprintk(1, "\n");
 
 	/* Write command */
-	status = Write16_0(state, SIO_HI_RA_RAM_CMD__A, cmd);
+	status = write16(state, SIO_HI_RA_RAM_CMD__A, cmd);
 	if (status < 0)
 		return status;
 	if (cmd == SIO_HI_RA_RAM_CMD_RESET)
@@ -1081,14 +1092,14 @@ static int HI_Command(struct drxk_state *state, u16 cmd, u16 *pResult)
 		do {
 			msleep(1);
 			retryCount += 1;
-			status = Read16(state, SIO_HI_RA_RAM_CMD__A,
-					&waitCmd, 0);
+			status = read16(state, SIO_HI_RA_RAM_CMD__A,
+					  &waitCmd);
 		} while ((status < 0) && (retryCount < DRXK_MAX_RETRIES)
 			 && (waitCmd != 0));
 
 		if (status == 0)
-			status = Read16(state, SIO_HI_RA_RAM_RES__A,
-					pResult, 0);
+			status = read16(state, SIO_HI_RA_RAM_RES__A,
+					pResult);
 	}
 	return status;
 }
@@ -1101,22 +1112,22 @@ static int HI_CfgCommand(struct drxk_state *state)
 
 	mutex_lock(&state->mutex);
 	do {
-		status = Write16_0(state, SIO_HI_RA_RAM_PAR_6__A, state->m_HICfgTimeout);
+		status = write16(state, SIO_HI_RA_RAM_PAR_6__A, state->m_HICfgTimeout);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SIO_HI_RA_RAM_PAR_5__A, state->m_HICfgCtrl);
+		status = write16(state, SIO_HI_RA_RAM_PAR_5__A, state->m_HICfgCtrl);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SIO_HI_RA_RAM_PAR_4__A, state->m_HICfgWakeUpKey);
+		status = write16(state, SIO_HI_RA_RAM_PAR_4__A, state->m_HICfgWakeUpKey);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SIO_HI_RA_RAM_PAR_3__A, state->m_HICfgBridgeDelay);
+		status = write16(state, SIO_HI_RA_RAM_PAR_3__A, state->m_HICfgBridgeDelay);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SIO_HI_RA_RAM_PAR_2__A, state->m_HICfgTimingDiv);
+		status = write16(state, SIO_HI_RA_RAM_PAR_2__A, state->m_HICfgTimingDiv);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SIO_HI_RA_RAM_PAR_1__A, SIO_HI_RA_RAM_PAR_1_PAR1_SEC_KEY);
+		status = write16(state, SIO_HI_RA_RAM_PAR_1__A, SIO_HI_RA_RAM_PAR_1_PAR1_SEC_KEY);
 		if (status < 0)
 			break;
 		status = HI_Command(state, SIO_HI_RA_RAM_CMD_CONFIG, 0);
@@ -1149,51 +1160,51 @@ static int MPEGTSConfigurePins(struct drxk_state *state, bool mpegEnable)
 	dprintk(1, "\n");
 	do {
 		/* stop lock indicator process */
-		status = Write16_0(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
+		status = write16(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
 		if (status < 0)
 			break;
 
 		/*  MPEG TS pad configuration */
-		status = Write16_0(state, SIO_TOP_COMM_KEY__A, 0xFABA);
+		status = write16(state, SIO_TOP_COMM_KEY__A, 0xFABA);
 		if (status < 0)
 			break;
 
 		if (mpegEnable == false) {
 			/*  Set MPEG TS pads to inputmode */
-			status = Write16_0(state, SIO_PDR_MSTRT_CFG__A, 0x0000);
+			status = write16(state, SIO_PDR_MSTRT_CFG__A, 0x0000);
 			if (status < 0)
 				break;
-			status = Write16_0(state, SIO_PDR_MERR_CFG__A, 0x0000);
+			status = write16(state, SIO_PDR_MERR_CFG__A, 0x0000);
 			if (status < 0)
 				break;
-			status = Write16_0(state, SIO_PDR_MCLK_CFG__A, 0x0000);
+			status = write16(state, SIO_PDR_MCLK_CFG__A, 0x0000);
 			if (status < 0)
 				break;
-			status = Write16_0(state, SIO_PDR_MVAL_CFG__A, 0x0000);
+			status = write16(state, SIO_PDR_MVAL_CFG__A, 0x0000);
 			if (status < 0)
 				break;
-			status = Write16_0(state, SIO_PDR_MD0_CFG__A, 0x0000);
+			status = write16(state, SIO_PDR_MD0_CFG__A, 0x0000);
 			if (status < 0)
 				break;
-			status = Write16_0(state, SIO_PDR_MD1_CFG__A, 0x0000);
+			status = write16(state, SIO_PDR_MD1_CFG__A, 0x0000);
 			if (status < 0)
 				break;
-			status = Write16_0(state, SIO_PDR_MD2_CFG__A, 0x0000);
+			status = write16(state, SIO_PDR_MD2_CFG__A, 0x0000);
 			if (status < 0)
 				break;
-			status = Write16_0(state, SIO_PDR_MD3_CFG__A, 0x0000);
+			status = write16(state, SIO_PDR_MD3_CFG__A, 0x0000);
 			if (status < 0)
 				break;
-			status = Write16_0(state, SIO_PDR_MD4_CFG__A, 0x0000);
+			status = write16(state, SIO_PDR_MD4_CFG__A, 0x0000);
 			if (status < 0)
 				break;
-			status = Write16_0(state, SIO_PDR_MD5_CFG__A, 0x0000);
+			status = write16(state, SIO_PDR_MD5_CFG__A, 0x0000);
 			if (status < 0)
 				break;
-			status = Write16_0(state, SIO_PDR_MD6_CFG__A, 0x0000);
+			status = write16(state, SIO_PDR_MD6_CFG__A, 0x0000);
 			if (status < 0)
 				break;
-			status = Write16_0(state, SIO_PDR_MD7_CFG__A, 0x0000);
+			status = write16(state, SIO_PDR_MD7_CFG__A, 0x0000);
 			if (status < 0)
 				break;
 		} else {
@@ -1205,36 +1216,36 @@ static int MPEGTSConfigurePins(struct drxk_state *state, bool mpegEnable)
 					  SIO_PDR_MCLK_CFG_DRIVE__B) |
 					 0x0003);
 
-			status = Write16_0(state, SIO_PDR_MSTRT_CFG__A, sioPdrMdxCfg);
+			status = write16(state, SIO_PDR_MSTRT_CFG__A, sioPdrMdxCfg);
 			if (status < 0)
 				break;
-			status = Write16_0(state, SIO_PDR_MERR_CFG__A, 0x0000);	/* Disable */
+			status = write16(state, SIO_PDR_MERR_CFG__A, 0x0000);	/* Disable */
 			if (status < 0)
 				break;
-			status = Write16_0(state, SIO_PDR_MVAL_CFG__A, 0x0000);	/* Disable */
+			status = write16(state, SIO_PDR_MVAL_CFG__A, 0x0000);	/* Disable */
 			if (status < 0)
 				break;
 			if (state->m_enableParallel == true) {
 				/* paralel -> enable MD1 to MD7 */
-				status = Write16_0(state, SIO_PDR_MD1_CFG__A, sioPdrMdxCfg);
+				status = write16(state, SIO_PDR_MD1_CFG__A, sioPdrMdxCfg);
 				if (status < 0)
 					break;
-				status = Write16_0(state, SIO_PDR_MD2_CFG__A, sioPdrMdxCfg);
+				status = write16(state, SIO_PDR_MD2_CFG__A, sioPdrMdxCfg);
 				if (status < 0)
 					break;
-				status = Write16_0(state, SIO_PDR_MD3_CFG__A, sioPdrMdxCfg);
+				status = write16(state, SIO_PDR_MD3_CFG__A, sioPdrMdxCfg);
 				if (status < 0)
 					break;
-				status = Write16_0(state, SIO_PDR_MD4_CFG__A, sioPdrMdxCfg);
+				status = write16(state, SIO_PDR_MD4_CFG__A, sioPdrMdxCfg);
 				if (status < 0)
 					break;
-				status = Write16_0(state, SIO_PDR_MD5_CFG__A, sioPdrMdxCfg);
+				status = write16(state, SIO_PDR_MD5_CFG__A, sioPdrMdxCfg);
 				if (status < 0)
 					break;
-				status = Write16_0(state, SIO_PDR_MD6_CFG__A, sioPdrMdxCfg);
+				status = write16(state, SIO_PDR_MD6_CFG__A, sioPdrMdxCfg);
 				if (status < 0)
 					break;
-				status = Write16_0(state, SIO_PDR_MD7_CFG__A, sioPdrMdxCfg);
+				status = write16(state, SIO_PDR_MD7_CFG__A, sioPdrMdxCfg);
 				if (status < 0)
 					break;
 			} else {
@@ -1242,41 +1253,41 @@ static int MPEGTSConfigurePins(struct drxk_state *state, bool mpegEnable)
 						 SIO_PDR_MD0_CFG_DRIVE__B)
 						| 0x0003);
 				/* serial -> disable MD1 to MD7 */
-				status = Write16_0(state, SIO_PDR_MD1_CFG__A, 0x0000);
+				status = write16(state, SIO_PDR_MD1_CFG__A, 0x0000);
 				if (status < 0)
 					break;
-				status = Write16_0(state, SIO_PDR_MD2_CFG__A, 0x0000);
+				status = write16(state, SIO_PDR_MD2_CFG__A, 0x0000);
 				if (status < 0)
 					break;
-				status = Write16_0(state, SIO_PDR_MD3_CFG__A, 0x0000);
+				status = write16(state, SIO_PDR_MD3_CFG__A, 0x0000);
 				if (status < 0)
 					break;
-				status = Write16_0(state, SIO_PDR_MD4_CFG__A, 0x0000);
+				status = write16(state, SIO_PDR_MD4_CFG__A, 0x0000);
 				if (status < 0)
 					break;
-				status = Write16_0(state, SIO_PDR_MD5_CFG__A, 0x0000);
+				status = write16(state, SIO_PDR_MD5_CFG__A, 0x0000);
 				if (status < 0)
 					break;
-				status = Write16_0(state, SIO_PDR_MD6_CFG__A, 0x0000);
+				status = write16(state, SIO_PDR_MD6_CFG__A, 0x0000);
 				if (status < 0)
 					break;
-				status = Write16_0(state, SIO_PDR_MD7_CFG__A, 0x0000);
+				status = write16(state, SIO_PDR_MD7_CFG__A, 0x0000);
 				if (status < 0)
 					break;
 			}
-			status = Write16_0(state, SIO_PDR_MCLK_CFG__A, sioPdrMclkCfg);
+			status = write16(state, SIO_PDR_MCLK_CFG__A, sioPdrMclkCfg);
 			if (status < 0)
 				break;
-			status = Write16_0(state, SIO_PDR_MD0_CFG__A, sioPdrMdxCfg);
+			status = write16(state, SIO_PDR_MD0_CFG__A, sioPdrMdxCfg);
 			if (status < 0)
 				break;
 		}
 		/*  Enable MB output over MPEG pads and ctl input */
-		status = Write16_0(state, SIO_PDR_MON_CFG__A, 0x0000);
+		status = write16(state, SIO_PDR_MON_CFG__A, 0x0000);
 		if (status < 0)
 			break;
 		/*  Write nomagic word to enable pdr reg write */
-		status = Write16_0(state, SIO_TOP_COMM_KEY__A, 0x0000);
+		status = write16(state, SIO_TOP_COMM_KEY__A, 0x0000);
 		if (status < 0)
 			break;
 	} while (0);
@@ -1301,23 +1312,23 @@ static int BLChainCmd(struct drxk_state *state,
 
 	mutex_lock(&state->mutex);
 	do {
-		status = Write16_0(state, SIO_BL_MODE__A, SIO_BL_MODE_CHAIN);
+		status = write16(state, SIO_BL_MODE__A, SIO_BL_MODE_CHAIN);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SIO_BL_CHAIN_ADDR__A, romOffset);
+		status = write16(state, SIO_BL_CHAIN_ADDR__A, romOffset);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SIO_BL_CHAIN_LEN__A, nrOfElements);
+		status = write16(state, SIO_BL_CHAIN_LEN__A, nrOfElements);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SIO_BL_ENABLE__A, SIO_BL_ENABLE_ON);
+		status = write16(state, SIO_BL_ENABLE__A, SIO_BL_ENABLE_ON);
 		if (status < 0)
 			break;
 		end = jiffies + msecs_to_jiffies(timeOut);
 
 		do {
 			msleep(1);
-			status = Read16(state, SIO_BL_STATUS__A, &blStatus, 0);
+			status = read16(state, SIO_BL_STATUS__A, &blStatus);
 			if (status < 0)
 				break;
 		} while ((blStatus == 0x1) &&
@@ -1374,7 +1385,7 @@ static int DownloadMicrocode(struct drxk_state *state,
 		BlockCRC = (pSrc[0] << 8) | pSrc[1];
 		pSrc += sizeof(u16);
 		offset += sizeof(u16);
-		status = WriteBlock(state, Address, BlockSize, pSrc, 0);
+		status = write_block(state, Address, BlockSize, pSrc);
 		if (status < 0)
 			break;
 		pSrc += BlockSize;
@@ -1398,7 +1409,7 @@ static int DVBTEnableOFDMTokenRing(struct drxk_state *state, bool enable)
 		desiredStatus = SIO_OFDM_SH_OFDM_RING_STATUS_DOWN;
 	}
 
-	status = (Read16_0(state, SIO_OFDM_SH_OFDM_RING_STATUS__A, &data));
+	status = (read16(state, SIO_OFDM_SH_OFDM_RING_STATUS__A, &data));
 
 	if (data == desiredStatus) {
 		/* tokenring already has correct status */
@@ -1406,11 +1417,11 @@ static int DVBTEnableOFDMTokenRing(struct drxk_state *state, bool enable)
 	}
 	/* Disable/enable dvbt tokenring bridge   */
 	status =
-	    Write16_0(state, SIO_OFDM_SH_OFDM_RING_ENABLE__A, desiredCtrl);
+	    write16(state, SIO_OFDM_SH_OFDM_RING_ENABLE__A, desiredCtrl);
 
 	end = jiffies + msecs_to_jiffies(DRXK_OFDM_TR_SHUTDOWN_TIMEOUT);
 	do {
-		status = Read16_0(state, SIO_OFDM_SH_OFDM_RING_STATUS__A, &data);
+		status = read16(state, SIO_OFDM_SH_OFDM_RING_STATUS__A, &data);
 		if (status < 0)
 			break;
 	} while ((data != desiredStatus) && ((time_is_after_jiffies(end))));
@@ -1431,20 +1442,20 @@ static int MPEGTSStop(struct drxk_state *state)
 
 	do {
 		/* Gracefull shutdown (byte boundaries) */
-		status = Read16_0(state, FEC_OC_SNC_MODE__A, &fecOcSncMode);
+		status = read16(state, FEC_OC_SNC_MODE__A, &fecOcSncMode);
 		if (status < 0)
 			break;
 		fecOcSncMode |= FEC_OC_SNC_MODE_SHUTDOWN__M;
-		status = Write16_0(state, FEC_OC_SNC_MODE__A, fecOcSncMode);
+		status = write16(state, FEC_OC_SNC_MODE__A, fecOcSncMode);
 		if (status < 0)
 			break;
 
 		/* Suppress MCLK during absence of data */
-		status = Read16_0(state, FEC_OC_IPR_MODE__A, &fecOcIprMode);
+		status = read16(state, FEC_OC_IPR_MODE__A, &fecOcIprMode);
 		if (status < 0)
 			break;
 		fecOcIprMode |= FEC_OC_IPR_MODE_MCLK_DIS_DAT_ABS__M;
-		status = Write16_0(state, FEC_OC_IPR_MODE__A, fecOcIprMode);
+		status = write16(state, FEC_OC_IPR_MODE__A, fecOcIprMode);
 		if (status < 0)
 			break;
 	} while (0);
@@ -1482,13 +1493,13 @@ static int scu_command(struct drxk_state *state,
 		buffer[cnt++] = (cmd & 0xFF);
 		buffer[cnt++] = ((cmd >> 8) & 0xFF);
 
-		WriteBlock(state, SCU_RAM_PARAM_0__A -
-			   (parameterLen - 1), cnt, buffer, 0x00);
+		write_block(state, SCU_RAM_PARAM_0__A -
+			   (parameterLen - 1), cnt, buffer);
 		/* Wait until SCU has processed command */
 		end = jiffies + msecs_to_jiffies(DRXK_MAX_WAITTIME);
 		do {
 			msleep(1);
-			status = Read16_0(state, SCU_RAM_COMMAND__A, &curCmd);
+			status = read16(state, SCU_RAM_COMMAND__A, &curCmd);
 			if (status < 0)
 				break;
 		} while (!(curCmd == DRX_SCU_READY)
@@ -1504,7 +1515,7 @@ static int scu_command(struct drxk_state *state,
 			int ii;
 
 			for (ii = resultLen - 1; ii >= 0; ii -= 1) {
-				status = Read16_0(state, SCU_RAM_PARAM_0__A - ii, &result[ii]);
+				status = read16(state, SCU_RAM_PARAM_0__A - ii, &result[ii]);
 				if (status < 0)
 					break;
 			}
@@ -1547,7 +1558,7 @@ static int SetIqmAf(struct drxk_state *state, bool active)
 
 	do {
 		/* Configure IQM */
-		status = Read16_0(state, IQM_AF_STDBY__A, &data);
+		status = read16(state, IQM_AF_STDBY__A, &data);
 		if (status < 0)
 			break;
 		if (!active) {
@@ -1565,7 +1576,7 @@ static int SetIqmAf(struct drxk_state *state, bool active)
 				 & (~IQM_AF_STDBY_STDBY_TAGC_RF_STANDBY)
 			    );
 		}
-		status = Write16_0(state, IQM_AF_STDBY__A, data);
+		status = write16(state, IQM_AF_STDBY__A, data);
 		if (status < 0)
 			break;
 	} while (0);
@@ -1658,10 +1669,10 @@ static int CtrlPowerMode(struct drxk_state *state, enum DRXPowerMode *mode)
 			status = DVBTEnableOFDMTokenRing(state, false);
 			if (status < 0)
 				break;
-			status = Write16_0(state, SIO_CC_PWD_MODE__A, sioCcPwdMode);
+			status = write16(state, SIO_CC_PWD_MODE__A, sioCcPwdMode);
 			if (status < 0)
 				break;
-			status = Write16_0(state, SIO_CC_UPDATE__A, SIO_CC_UPDATE_KEY);
+			status = write16(state, SIO_CC_UPDATE__A, SIO_CC_UPDATE_KEY);
 			if (status < 0)
 				break;
 
@@ -1688,7 +1699,7 @@ static int PowerDownDVBT(struct drxk_state *state, bool setPowerMode)
 	dprintk(1, "\n");
 
 	do {
-		status = Read16_0(state, SCU_COMM_EXEC__A, &data);
+		status = read16(state, SCU_COMM_EXEC__A, &data);
 		if (status < 0)
 			break;
 		if (data == SCU_COMM_EXEC_ACTIVE) {
@@ -1703,13 +1714,13 @@ static int PowerDownDVBT(struct drxk_state *state, bool setPowerMode)
 		}
 
 		/* Reset datapath for OFDM, processors first */
-		status = Write16_0(state, OFDM_SC_COMM_EXEC__A, OFDM_SC_COMM_EXEC_STOP);
+		status = write16(state, OFDM_SC_COMM_EXEC__A, OFDM_SC_COMM_EXEC_STOP);
 		if (status < 0)
 			break;
-		status = Write16_0(state, OFDM_LC_COMM_EXEC__A, OFDM_LC_COMM_EXEC_STOP);
+		status = write16(state, OFDM_LC_COMM_EXEC__A, OFDM_LC_COMM_EXEC_STOP);
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_COMM_EXEC__A, IQM_COMM_EXEC_B_STOP);
+		status = write16(state, IQM_COMM_EXEC__A, IQM_COMM_EXEC_B_STOP);
 		if (status < 0)
 			break;
 
@@ -1741,7 +1752,7 @@ static int SetOperationMode(struct drxk_state *state,
 	 */
 	do {
 		/* disable HW lock indicator */
-		status = Write16_0(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
+		status = write16(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
 		if (status < 0)
 			break;
 
@@ -1907,14 +1918,14 @@ static int MPEGTSStart(struct drxk_state *state)
 
 	do {
 		/* Allow OC to sync again */
-		status = Read16_0(state, FEC_OC_SNC_MODE__A, &fecOcSncMode);
+		status = read16(state, FEC_OC_SNC_MODE__A, &fecOcSncMode);
 		if (status < 0)
 			break;
 		fecOcSncMode &= ~FEC_OC_SNC_MODE_SHUTDOWN__M;
-		status = Write16_0(state, FEC_OC_SNC_MODE__A, fecOcSncMode);
+		status = write16(state, FEC_OC_SNC_MODE__A, fecOcSncMode);
 		if (status < 0)
 			break;
-		status = Write16_0(state, FEC_OC_SNC_UNLOCK__A, 1);
+		status = write16(state, FEC_OC_SNC_UNLOCK__A, 1);
 		if (status < 0)
 			break;
 	} while (0);
@@ -1929,39 +1940,39 @@ static int MPEGTSDtoInit(struct drxk_state *state)
 
 	do {
 		/* Rate integration settings */
-		status = Write16_0(state, FEC_OC_RCN_CTL_STEP_LO__A, 0x0000);
+		status = write16(state, FEC_OC_RCN_CTL_STEP_LO__A, 0x0000);
 		if (status < 0)
 			break;
-		status = Write16_0(state, FEC_OC_RCN_CTL_STEP_HI__A, 0x000C);
+		status = write16(state, FEC_OC_RCN_CTL_STEP_HI__A, 0x000C);
 		if (status < 0)
 			break;
-		status = Write16_0(state, FEC_OC_RCN_GAIN__A, 0x000A);
+		status = write16(state, FEC_OC_RCN_GAIN__A, 0x000A);
 		if (status < 0)
 			break;
-		status = Write16_0(state, FEC_OC_AVR_PARM_A__A, 0x0008);
+		status = write16(state, FEC_OC_AVR_PARM_A__A, 0x0008);
 		if (status < 0)
 			break;
-		status = Write16_0(state, FEC_OC_AVR_PARM_B__A, 0x0006);
+		status = write16(state, FEC_OC_AVR_PARM_B__A, 0x0006);
 		if (status < 0)
 			break;
-		status = Write16_0(state, FEC_OC_TMD_HI_MARGIN__A, 0x0680);
+		status = write16(state, FEC_OC_TMD_HI_MARGIN__A, 0x0680);
 		if (status < 0)
 			break;
-		status = Write16_0(state, FEC_OC_TMD_LO_MARGIN__A, 0x0080);
+		status = write16(state, FEC_OC_TMD_LO_MARGIN__A, 0x0080);
 		if (status < 0)
 			break;
-		status = Write16_0(state, FEC_OC_TMD_COUNT__A, 0x03F4);
+		status = write16(state, FEC_OC_TMD_COUNT__A, 0x03F4);
 		if (status < 0)
 			break;
 
 		/* Additional configuration */
-		status = Write16_0(state, FEC_OC_OCR_INVERT__A, 0);
+		status = write16(state, FEC_OC_OCR_INVERT__A, 0);
 		if (status < 0)
 			break;
-		status = Write16_0(state, FEC_OC_SNC_LWM__A, 2);
+		status = write16(state, FEC_OC_SNC_LWM__A, 2);
 		if (status < 0)
 			break;
-		status = Write16_0(state, FEC_OC_SNC_HWM__A, 12);
+		status = write16(state, FEC_OC_SNC_HWM__A, 12);
 		if (status < 0)
 			break;
 	} while (0);
@@ -1989,10 +2000,10 @@ static int MPEGTSDtoSetup(struct drxk_state *state,
 
 	do {
 		/* Check insertion of the Reed-Solomon parity bytes */
-		status = Read16_0(state, FEC_OC_MODE__A, &fecOcRegMode);
+		status = read16(state, FEC_OC_MODE__A, &fecOcRegMode);
 		if (status < 0)
 			break;
-		status = Read16_0(state, FEC_OC_IPR_MODE__A, &fecOcRegIprMode);
+		status = read16(state, FEC_OC_IPR_MODE__A, &fecOcRegIprMode);
 		if (status < 0)
 			break;
 		fecOcRegMode &= (~FEC_OC_MODE_PARITY__M);
@@ -2073,33 +2084,33 @@ static int MPEGTSDtoSetup(struct drxk_state *state,
 		}
 
 		/* Write appropriate registers with requested configuration */
-		status = Write16_0(state, FEC_OC_DTO_BURST_LEN__A, fecOcDtoBurstLen);
+		status = write16(state, FEC_OC_DTO_BURST_LEN__A, fecOcDtoBurstLen);
 		if (status < 0)
 			break;
-		status = Write16_0(state, FEC_OC_DTO_PERIOD__A, fecOcDtoPeriod);
+		status = write16(state, FEC_OC_DTO_PERIOD__A, fecOcDtoPeriod);
 		if (status < 0)
 			break;
-		status = Write16_0(state, FEC_OC_DTO_MODE__A, fecOcDtoMode);
+		status = write16(state, FEC_OC_DTO_MODE__A, fecOcDtoMode);
 		if (status < 0)
 			break;
-		status = Write16_0(state, FEC_OC_FCT_MODE__A, fecOcFctMode);
+		status = write16(state, FEC_OC_FCT_MODE__A, fecOcFctMode);
 		if (status < 0)
 			break;
-		status = Write16_0(state, FEC_OC_MODE__A, fecOcRegMode);
+		status = write16(state, FEC_OC_MODE__A, fecOcRegMode);
 		if (status < 0)
 			break;
-		status = Write16_0(state, FEC_OC_IPR_MODE__A, fecOcRegIprMode);
+		status = write16(state, FEC_OC_IPR_MODE__A, fecOcRegIprMode);
 		if (status < 0)
 			break;
 
 		/* Rate integration settings */
-		status = Write32(state, FEC_OC_RCN_CTL_RATE_LO__A, fecOcRcnCtlRate, 0);
+		status = write32(state, FEC_OC_RCN_CTL_RATE_LO__A, fecOcRcnCtlRate);
 		if (status < 0)
 			break;
-		status = Write16_0(state, FEC_OC_TMD_INT_UPD_RATE__A, fecOcTmdIntUpdRate);
+		status = write16(state, FEC_OC_TMD_INT_UPD_RATE__A, fecOcTmdIntUpdRate);
 		if (status < 0)
 			break;
-		status = Write16_0(state, FEC_OC_TMD_MODE__A, fecOcTmdMode);
+		status = write16(state, FEC_OC_TMD_MODE__A, fecOcTmdMode);
 		if (status < 0)
 			break;
 	} while (0);
@@ -2136,7 +2147,7 @@ static int MPEGTSConfigurePolarity(struct drxk_state *state)
 	fecOcRegIprInvert &= (~(FEC_OC_IPR_INVERT_MCLK__M));
 	if (state->m_invertCLK == true)
 		fecOcRegIprInvert |= FEC_OC_IPR_INVERT_MCLK__M;
-	status = Write16_0(state, FEC_OC_IPR_INVERT__A, fecOcRegIprInvert);
+	status = write16(state, FEC_OC_IPR_INVERT__A, fecOcRegIprInvert);
 	return status;
 }
 
@@ -2160,15 +2171,15 @@ static int SetAgcRf(struct drxk_state *state,
 		case DRXK_AGC_CTRL_AUTO:
 
 			/* Enable RF AGC DAC */
-			status = Read16_0(state, IQM_AF_STDBY__A, &data);
+			status = read16(state, IQM_AF_STDBY__A, &data);
 			if (status < 0)
 				break;
 			data &= ~IQM_AF_STDBY_STDBY_TAGC_RF_STANDBY;
-			status = Write16_0(state, IQM_AF_STDBY__A, data);
+			status = write16(state, IQM_AF_STDBY__A, data);
 			if (status < 0)
 				break;
 
-			status = Read16(state, SCU_RAM_AGC_CONFIG__A, &data, 0);
+			status = read16(state, SCU_RAM_AGC_CONFIG__A, &data);
 			if (status < 0)
 				break;
 
@@ -2180,12 +2191,12 @@ static int SetAgcRf(struct drxk_state *state,
 				data |= SCU_RAM_AGC_CONFIG_INV_RF_POL__M;
 			else
 				data &= ~SCU_RAM_AGC_CONFIG_INV_RF_POL__M;
-			status = Write16_0(state, SCU_RAM_AGC_CONFIG__A, data);
+			status = write16(state, SCU_RAM_AGC_CONFIG__A, data);
 			if (status < 0)
 				break;
 
 			/* Set speed (using complementary reduction value) */
-			status = Read16(state, SCU_RAM_AGC_KI_RED__A, &data, 0);
+			status = read16(state, SCU_RAM_AGC_KI_RED__A, &data);
 			if (status < 0)
 				break;
 
@@ -2194,7 +2205,7 @@ static int SetAgcRf(struct drxk_state *state,
 				   SCU_RAM_AGC_KI_RED_RAGC_RED__B)
 				 & SCU_RAM_AGC_KI_RED_RAGC_RED__M);
 
-			status = Write16_0(state, SCU_RAM_AGC_KI_RED__A, data);
+			status = write16(state, SCU_RAM_AGC_KI_RED__A, data);
 			if (status < 0)
 				break;
 
@@ -2209,17 +2220,17 @@ static int SetAgcRf(struct drxk_state *state,
 
 			/* Set TOP, only if IF-AGC is in AUTO mode */
 			if (pIfAgcSettings->ctrlMode == DRXK_AGC_CTRL_AUTO)
-				status = Write16_0(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A, pAgcCfg->top);
+				status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A, pAgcCfg->top);
 				if (status < 0)
 					break;
 
 			/* Cut-Off current */
-			status = Write16_0(state, SCU_RAM_AGC_RF_IACCU_HI_CO__A, pAgcCfg->cutOffCurrent);
+			status = write16(state, SCU_RAM_AGC_RF_IACCU_HI_CO__A, pAgcCfg->cutOffCurrent);
 			if (status < 0)
 				break;
 
 			/* Max. output level */
-			status = Write16_0(state, SCU_RAM_AGC_RF_MAX__A, pAgcCfg->maxOutputLevel);
+			status = write16(state, SCU_RAM_AGC_RF_MAX__A, pAgcCfg->maxOutputLevel);
 			if (status < 0)
 				break;
 
@@ -2227,16 +2238,16 @@ static int SetAgcRf(struct drxk_state *state,
 
 		case DRXK_AGC_CTRL_USER:
 			/* Enable RF AGC DAC */
-			status = Read16_0(state, IQM_AF_STDBY__A, &data);
+			status = read16(state, IQM_AF_STDBY__A, &data);
 			if (status < 0)
 				break;
 			data &= ~IQM_AF_STDBY_STDBY_TAGC_RF_STANDBY;
-			status = Write16_0(state, IQM_AF_STDBY__A, data);
+			status = write16(state, IQM_AF_STDBY__A, data);
 			if (status < 0)
 				break;
 
 			/* Disable SCU RF AGC loop */
-			status = Read16_0(state, SCU_RAM_AGC_CONFIG__A, &data);
+			status = read16(state, SCU_RAM_AGC_CONFIG__A, &data);
 			if (status < 0)
 				break;
 			data |= SCU_RAM_AGC_CONFIG_DISABLE_RF_AGC__M;
@@ -2244,37 +2255,37 @@ static int SetAgcRf(struct drxk_state *state,
 				data |= SCU_RAM_AGC_CONFIG_INV_RF_POL__M;
 			else
 				data &= ~SCU_RAM_AGC_CONFIG_INV_RF_POL__M;
-			status = Write16_0(state, SCU_RAM_AGC_CONFIG__A, data);
+			status = write16(state, SCU_RAM_AGC_CONFIG__A, data);
 			if (status < 0)
 				break;
 
 			/* SCU c.o.c. to 0, enabling full control range */
-			status = Write16_0(state, SCU_RAM_AGC_RF_IACCU_HI_CO__A, 0);
+			status = write16(state, SCU_RAM_AGC_RF_IACCU_HI_CO__A, 0);
 			if (status < 0)
 				break;
 
 			/* Write value to output pin */
-			status = Write16_0(state, SCU_RAM_AGC_RF_IACCU_HI__A, pAgcCfg->outputLevel);
+			status = write16(state, SCU_RAM_AGC_RF_IACCU_HI__A, pAgcCfg->outputLevel);
 			if (status < 0)
 				break;
 			break;
 
 		case DRXK_AGC_CTRL_OFF:
 			/* Disable RF AGC DAC */
-			status = Read16_0(state, IQM_AF_STDBY__A, &data);
+			status = read16(state, IQM_AF_STDBY__A, &data);
 			if (status < 0)
 				break;
 			data |= IQM_AF_STDBY_STDBY_TAGC_RF_STANDBY;
-			status = Write16_0(state, IQM_AF_STDBY__A, data);
+			status = write16(state, IQM_AF_STDBY__A, data);
 			if (status < 0)
 				break;
 
 			/* Disable SCU RF AGC loop */
-			status = Read16_0(state, SCU_RAM_AGC_CONFIG__A, &data);
+			status = read16(state, SCU_RAM_AGC_CONFIG__A, &data);
 			if (status < 0)
 				break;
 			data |= SCU_RAM_AGC_CONFIG_DISABLE_RF_AGC__M;
-			status = Write16_0(state, SCU_RAM_AGC_CONFIG__A, data);
+			status = write16(state, SCU_RAM_AGC_CONFIG__A, data);
 			if (status < 0)
 				break;
 			break;
@@ -2303,15 +2314,15 @@ static int SetAgcIf(struct drxk_state *state,
 		case DRXK_AGC_CTRL_AUTO:
 
 			/* Enable IF AGC DAC */
-			status = Read16_0(state, IQM_AF_STDBY__A, &data);
+			status = read16(state, IQM_AF_STDBY__A, &data);
 			if (status < 0)
 				break;
 			data &= ~IQM_AF_STDBY_STDBY_TAGC_IF_STANDBY;
-			status = Write16_0(state, IQM_AF_STDBY__A, data);
+			status = write16(state, IQM_AF_STDBY__A, data);
 			if (status < 0)
 				break;
 
-			status = Read16_0(state, SCU_RAM_AGC_CONFIG__A, &data);
+			status = read16(state, SCU_RAM_AGC_CONFIG__A, &data);
 			if (status < 0)
 				break;
 
@@ -2323,12 +2334,12 @@ static int SetAgcIf(struct drxk_state *state,
 				data |= SCU_RAM_AGC_CONFIG_INV_IF_POL__M;
 			else
 				data &= ~SCU_RAM_AGC_CONFIG_INV_IF_POL__M;
-			status = Write16_0(state, SCU_RAM_AGC_CONFIG__A, data);
+			status = write16(state, SCU_RAM_AGC_CONFIG__A, data);
 			if (status < 0)
 				break;
 
 			/* Set speed (using complementary reduction value) */
-			status = Read16_0(state, SCU_RAM_AGC_KI_RED__A, &data);
+			status = read16(state, SCU_RAM_AGC_KI_RED__A, &data);
 			if (status < 0)
 				break;
 			data &= ~SCU_RAM_AGC_KI_RED_IAGC_RED__M;
@@ -2336,7 +2347,7 @@ static int SetAgcIf(struct drxk_state *state,
 				   SCU_RAM_AGC_KI_RED_IAGC_RED__B)
 				 & SCU_RAM_AGC_KI_RED_IAGC_RED__M);
 
-			status = Write16_0(state, SCU_RAM_AGC_KI_RED__A, data);
+			status = write16(state, SCU_RAM_AGC_KI_RED__A, data);
 			if (status < 0)
 				break;
 
@@ -2347,7 +2358,7 @@ static int SetAgcIf(struct drxk_state *state,
 			if (pRfAgcSettings == NULL)
 				return -1;
 			/* Restore TOP */
-			status = Write16_0(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A, pRfAgcSettings->top);
+			status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A, pRfAgcSettings->top);
 			if (status < 0)
 				break;
 			break;
@@ -2355,15 +2366,15 @@ static int SetAgcIf(struct drxk_state *state,
 		case DRXK_AGC_CTRL_USER:
 
 			/* Enable IF AGC DAC */
-			status = Read16_0(state, IQM_AF_STDBY__A, &data);
+			status = read16(state, IQM_AF_STDBY__A, &data);
 			if (status < 0)
 				break;
 			data &= ~IQM_AF_STDBY_STDBY_TAGC_IF_STANDBY;
-			status = Write16_0(state, IQM_AF_STDBY__A, data);
+			status = write16(state, IQM_AF_STDBY__A, data);
 			if (status < 0)
 				break;
 
-			status = Read16_0(state, SCU_RAM_AGC_CONFIG__A, &data);
+			status = read16(state, SCU_RAM_AGC_CONFIG__A, &data);
 			if (status < 0)
 				break;
 
@@ -2375,12 +2386,12 @@ static int SetAgcIf(struct drxk_state *state,
 				data |= SCU_RAM_AGC_CONFIG_INV_IF_POL__M;
 			else
 				data &= ~SCU_RAM_AGC_CONFIG_INV_IF_POL__M;
-			status = Write16_0(state, SCU_RAM_AGC_CONFIG__A, data);
+			status = write16(state, SCU_RAM_AGC_CONFIG__A, data);
 			if (status < 0)
 				break;
 
 			/* Write value to output pin */
-			status = Write16_0(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A, pAgcCfg->outputLevel);
+			status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A, pAgcCfg->outputLevel);
 			if (status < 0)
 				break;
 			break;
@@ -2388,20 +2399,20 @@ static int SetAgcIf(struct drxk_state *state,
 		case DRXK_AGC_CTRL_OFF:
 
 			/* Disable If AGC DAC */
-			status = Read16_0(state, IQM_AF_STDBY__A, &data);
+			status = read16(state, IQM_AF_STDBY__A, &data);
 			if (status < 0)
 				break;
 			data |= IQM_AF_STDBY_STDBY_TAGC_IF_STANDBY;
-			status = Write16_0(state, IQM_AF_STDBY__A, data);
+			status = write16(state, IQM_AF_STDBY__A, data);
 			if (status < 0)
 				break;
 
 			/* Disable SCU IF AGC loop */
-			status = Read16_0(state, SCU_RAM_AGC_CONFIG__A, &data);
+			status = read16(state, SCU_RAM_AGC_CONFIG__A, &data);
 			if (status < 0)
 				break;
 			data |= SCU_RAM_AGC_CONFIG_DISABLE_IF_AGC__M;
-			status = Write16_0(state, SCU_RAM_AGC_CONFIG__A, data);
+			status = write16(state, SCU_RAM_AGC_CONFIG__A, data);
 			if (status < 0)
 				break;
 			break;
@@ -2409,7 +2420,7 @@ static int SetAgcIf(struct drxk_state *state,
 
 		/* always set the top to support
 		   configurations without if-loop */
-		status = Write16_0(state, SCU_RAM_AGC_INGAIN_TGT_MIN__A, pAgcCfg->top);
+		status = write16(state, SCU_RAM_AGC_INGAIN_TGT_MIN__A, pAgcCfg->top);
 		if (status < 0)
 			break;
 
@@ -2421,7 +2432,7 @@ static int SetAgcIf(struct drxk_state *state,
 static int ReadIFAgc(struct drxk_state *state, u32 *pValue)
 {
 	u16 agcDacLvl;
-	int status = Read16_0(state, IQM_AF_AGC_IF__A, &agcDacLvl);
+	int status = read16(state, IQM_AF_AGC_IF__A, &agcDacLvl);
 
 	dprintk(1, "\n");
 
@@ -2455,7 +2466,7 @@ static int GetQAMSignalToNoise(struct drxk_state *state,
 		u32 qamSlMer = 0;	/* QAM MER */
 
 		/* get the register value needed for MER */
-		status = Read16_0(state, QAM_SL_ERR_POWER__A, &qamSlErrPower);
+		status = read16(state, QAM_SL_ERR_POWER__A, &qamSlErrPower);
 		if (status < 0)
 			break;
 
@@ -2508,16 +2519,16 @@ static int GetDVBTSignalToNoise(struct drxk_state *state,
 
 	dprintk(1, "\n");
 	do {
-		status = Read16_0(state, OFDM_EQ_TOP_TD_TPS_PWR_OFS__A, &EqRegTdTpsPwrOfs);
+		status = read16(state, OFDM_EQ_TOP_TD_TPS_PWR_OFS__A, &EqRegTdTpsPwrOfs);
 		if (status < 0)
 			break;
-		status = Read16_0(state, OFDM_EQ_TOP_TD_REQ_SMB_CNT__A, &EqRegTdReqSmbCnt);
+		status = read16(state, OFDM_EQ_TOP_TD_REQ_SMB_CNT__A, &EqRegTdReqSmbCnt);
 		if (status < 0)
 			break;
-		status = Read16_0(state, OFDM_EQ_TOP_TD_SQR_ERR_EXP__A, &EqRegTdSqrErrExp);
+		status = read16(state, OFDM_EQ_TOP_TD_SQR_ERR_EXP__A, &EqRegTdSqrErrExp);
 		if (status < 0)
 			break;
-		status = Read16_0(state, OFDM_EQ_TOP_TD_SQR_ERR_I__A, &regData);
+		status = read16(state, OFDM_EQ_TOP_TD_SQR_ERR_I__A, &regData);
 		if (status < 0)
 			break;
 		/* Extend SQR_ERR_I operational range */
@@ -2526,7 +2537,7 @@ static int GetDVBTSignalToNoise(struct drxk_state *state,
 		    (EqRegTdSqrErrI < 0x00000FFFUL)) {
 			EqRegTdSqrErrI += 0x00010000UL;
 		}
-		status = Read16_0(state, OFDM_EQ_TOP_TD_SQR_ERR_Q__A, &regData);
+		status = read16(state, OFDM_EQ_TOP_TD_SQR_ERR_Q__A, &regData);
 		if (status < 0)
 			break;
 		/* Extend SQR_ERR_Q operational range */
@@ -2535,7 +2546,7 @@ static int GetDVBTSignalToNoise(struct drxk_state *state,
 		    (EqRegTdSqrErrQ < 0x00000FFFUL))
 			EqRegTdSqrErrQ += 0x00010000UL;
 
-		status = Read16_0(state, OFDM_SC_RA_RAM_OP_PARAM__A, &transmissionParams);
+		status = read16(state, OFDM_SC_RA_RAM_OP_PARAM__A, &transmissionParams);
 		if (status < 0)
 			break;
 
@@ -2645,12 +2656,12 @@ static int GetDVBTQuality(struct drxk_state *state, s32 *pQuality)
 		status = GetDVBTSignalToNoise(state, &SignalToNoise);
 		if (status < 0)
 			break;
-		status = Read16_0(state, OFDM_EQ_TOP_TD_TPS_CONST__A, &Constellation);
+		status = read16(state, OFDM_EQ_TOP_TD_TPS_CONST__A, &Constellation);
 		if (status < 0)
 			break;
 		Constellation &= OFDM_EQ_TOP_TD_TPS_CONST__M;
 
-		status = Read16_0(state, OFDM_EQ_TOP_TD_TPS_CODE_HP__A, &CodeRate);
+		status = read16(state, OFDM_EQ_TOP_TD_TPS_CODE_HP__A, &CodeRate);
 		if (status < 0)
 			break;
 		CodeRate &= OFDM_EQ_TOP_TD_TPS_CODE_HP__M;
@@ -2762,15 +2773,15 @@ static int ConfigureI2CBridge(struct drxk_state *state, bool bEnableBridge)
 		return -1;
 
 	do {
-		status = Write16_0(state, SIO_HI_RA_RAM_PAR_1__A, SIO_HI_RA_RAM_PAR_1_PAR1_SEC_KEY);
+		status = write16(state, SIO_HI_RA_RAM_PAR_1__A, SIO_HI_RA_RAM_PAR_1_PAR1_SEC_KEY);
 		if (status < 0)
 			break;
 		if (bEnableBridge) {
-			status = Write16_0(state, SIO_HI_RA_RAM_PAR_2__A, SIO_HI_RA_RAM_PAR_2_BRD_CFG_CLOSED);
+			status = write16(state, SIO_HI_RA_RAM_PAR_2__A, SIO_HI_RA_RAM_PAR_2_BRD_CFG_CLOSED);
 			if (status < 0)
 				break;
 		} else {
-			status = Write16_0(state, SIO_HI_RA_RAM_PAR_2__A, SIO_HI_RA_RAM_PAR_2_BRD_CFG_OPEN);
+			status = write16(state, SIO_HI_RA_RAM_PAR_2__A, SIO_HI_RA_RAM_PAR_2_BRD_CFG_OPEN);
 			if (status < 0)
 				break;
 		}
@@ -2793,7 +2804,7 @@ static int SetPreSaw(struct drxk_state *state,
 	    || (pPreSawCfg->reference > IQM_AF_PDREF__M))
 		return -1;
 
-	status = Write16_0(state, IQM_AF_PDREF__A, pPreSawCfg->reference);
+	status = write16(state, IQM_AF_PDREF__A, pPreSawCfg->reference);
 	return status;
 }
 
@@ -2810,28 +2821,28 @@ static int BLDirectCmd(struct drxk_state *state, u32 targetAddr,
 
 	mutex_lock(&state->mutex);
 	do {
-		status = Write16_0(state, SIO_BL_MODE__A, SIO_BL_MODE_DIRECT);
+		status = write16(state, SIO_BL_MODE__A, SIO_BL_MODE_DIRECT);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SIO_BL_TGT_HDR__A, blockbank);
+		status = write16(state, SIO_BL_TGT_HDR__A, blockbank);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SIO_BL_TGT_ADDR__A, offset);
+		status = write16(state, SIO_BL_TGT_ADDR__A, offset);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SIO_BL_SRC_ADDR__A, romOffset);
+		status = write16(state, SIO_BL_SRC_ADDR__A, romOffset);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SIO_BL_SRC_LEN__A, nrOfElements);
+		status = write16(state, SIO_BL_SRC_LEN__A, nrOfElements);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SIO_BL_ENABLE__A, SIO_BL_ENABLE_ON);
+		status = write16(state, SIO_BL_ENABLE__A, SIO_BL_ENABLE_ON);
 		if (status < 0)
 			break;
 
 		end = jiffies + msecs_to_jiffies(timeOut);
 		do {
-			status = Read16_0(state, SIO_BL_STATUS__A, &blStatus);
+			status = read16(state, SIO_BL_STATUS__A, &blStatus);
 			if (status < 0)
 				break;
 		} while ((blStatus == 0x1) && time_is_after_jiffies(end));
@@ -2855,25 +2866,25 @@ static int ADCSyncMeasurement(struct drxk_state *state, u16 *count)
 
 	do {
 		/* Start measurement */
-		status = Write16_0(state, IQM_AF_COMM_EXEC__A, IQM_AF_COMM_EXEC_ACTIVE);
+		status = write16(state, IQM_AF_COMM_EXEC__A, IQM_AF_COMM_EXEC_ACTIVE);
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_AF_START_LOCK__A, 1);
+		status = write16(state, IQM_AF_START_LOCK__A, 1);
 		if (status < 0)
 			break;
 
 		*count = 0;
-		status = Read16_0(state, IQM_AF_PHASE0__A, &data);
+		status = read16(state, IQM_AF_PHASE0__A, &data);
 		if (status < 0)
 			break;
 		if (data == 127)
 			*count = *count + 1;
-		status = Read16_0(state, IQM_AF_PHASE1__A, &data);
+		status = read16(state, IQM_AF_PHASE1__A, &data);
 		if (status < 0)
 			break;
 		if (data == 127)
 			*count = *count + 1;
-		status = Read16_0(state, IQM_AF_PHASE2__A, &data);
+		status = read16(state, IQM_AF_PHASE2__A, &data);
 		if (status < 0)
 			break;
 		if (data == 127)
@@ -2898,7 +2909,7 @@ static int ADCSynchronization(struct drxk_state *state)
 			/* Try sampling on a diffrent edge */
 			u16 clkNeg = 0;
 
-			status = Read16_0(state, IQM_AF_CLKNEG__A, &clkNeg);
+			status = read16(state, IQM_AF_CLKNEG__A, &clkNeg);
 			if (status < 0)
 				break;
 			if ((clkNeg | IQM_AF_CLKNEG_CLKNEGDATA__M) ==
@@ -2911,7 +2922,7 @@ static int ADCSynchronization(struct drxk_state *state)
 				clkNeg |=
 				    IQM_AF_CLKNEG_CLKNEGDATA_CLK_ADC_DATA_POS;
 			}
-			status = Write16_0(state, IQM_AF_CLKNEG__A, clkNeg);
+			status = write16(state, IQM_AF_CLKNEG__A, clkNeg);
 			if (status < 0)
 				break;
 			status = ADCSyncMeasurement(state, &count);
@@ -2984,8 +2995,8 @@ static int SetFrequencyShifter(struct drxk_state *state,
 
 	/* Program frequency shifter with tuner offset compensation */
 	/* frequencyShift += tunerFreqOffset; TODO */
-	status = Write32(state, IQM_FS_RATE_OFS_LO__A,
-			 state->m_IqmFsRateOfs, 0);
+	status = write32(state, IQM_FS_RATE_OFS_LO__A,
+			 state->m_IqmFsRateOfs);
 	return status;
 }
 
@@ -3049,127 +3060,127 @@ static int InitAGC(struct drxk_state *state, bool isDTV)
 			fastClpCtrlDelay =
 			    state->m_dvbtIfAgcCfg.FastClipCtrlDelay;
 		}
-		status = Write16_0(state, SCU_RAM_AGC_FAST_CLP_CTRL_DELAY__A, fastClpCtrlDelay);
+		status = write16(state, SCU_RAM_AGC_FAST_CLP_CTRL_DELAY__A, fastClpCtrlDelay);
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, SCU_RAM_AGC_CLP_CTRL_MODE__A, clpCtrlMode);
+		status = write16(state, SCU_RAM_AGC_CLP_CTRL_MODE__A, clpCtrlMode);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_INGAIN_TGT__A, ingainTgt);
+		status = write16(state, SCU_RAM_AGC_INGAIN_TGT__A, ingainTgt);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_INGAIN_TGT_MIN__A, ingainTgtMin);
+		status = write16(state, SCU_RAM_AGC_INGAIN_TGT_MIN__A, ingainTgtMin);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_INGAIN_TGT_MAX__A, ingainTgtMax);
+		status = write16(state, SCU_RAM_AGC_INGAIN_TGT_MAX__A, ingainTgtMax);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MIN__A, ifIaccuHiTgtMin);
+		status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MIN__A, ifIaccuHiTgtMin);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A, ifIaccuHiTgtMax);
+		status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A, ifIaccuHiTgtMax);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_IF_IACCU_HI__A, 0);
+		status = write16(state, SCU_RAM_AGC_IF_IACCU_HI__A, 0);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_IF_IACCU_LO__A, 0);
+		status = write16(state, SCU_RAM_AGC_IF_IACCU_LO__A, 0);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_RF_IACCU_HI__A, 0);
+		status = write16(state, SCU_RAM_AGC_RF_IACCU_HI__A, 0);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_RF_IACCU_LO__A, 0);
+		status = write16(state, SCU_RAM_AGC_RF_IACCU_LO__A, 0);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_CLP_SUM_MAX__A, clpSumMax);
+		status = write16(state, SCU_RAM_AGC_CLP_SUM_MAX__A, clpSumMax);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_SNS_SUM_MAX__A, snsSumMax);
+		status = write16(state, SCU_RAM_AGC_SNS_SUM_MAX__A, snsSumMax);
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, SCU_RAM_AGC_KI_INNERGAIN_MIN__A, kiInnergainMin);
+		status = write16(state, SCU_RAM_AGC_KI_INNERGAIN_MIN__A, kiInnergainMin);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_IF_IACCU_HI_TGT__A, ifIaccuHiTgt);
+		status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT__A, ifIaccuHiTgt);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_CLP_CYCLEN__A, clpCyclen);
+		status = write16(state, SCU_RAM_AGC_CLP_CYCLEN__A, clpCyclen);
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, SCU_RAM_AGC_RF_SNS_DEV_MAX__A, 1023);
+		status = write16(state, SCU_RAM_AGC_RF_SNS_DEV_MAX__A, 1023);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_RF_SNS_DEV_MIN__A, (u16) -1023);
+		status = write16(state, SCU_RAM_AGC_RF_SNS_DEV_MIN__A, (u16) -1023);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_FAST_SNS_CTRL_DELAY__A, 50);
+		status = write16(state, SCU_RAM_AGC_FAST_SNS_CTRL_DELAY__A, 50);
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, SCU_RAM_AGC_KI_MAXMINGAIN_TH__A, 20);
+		status = write16(state, SCU_RAM_AGC_KI_MAXMINGAIN_TH__A, 20);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_CLP_SUM_MIN__A, clpSumMin);
+		status = write16(state, SCU_RAM_AGC_CLP_SUM_MIN__A, clpSumMin);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_SNS_SUM_MIN__A, snsSumMin);
+		status = write16(state, SCU_RAM_AGC_SNS_SUM_MIN__A, snsSumMin);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_CLP_DIR_TO__A, clpDirTo);
+		status = write16(state, SCU_RAM_AGC_CLP_DIR_TO__A, clpDirTo);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_SNS_DIR_TO__A, snsDirTo);
+		status = write16(state, SCU_RAM_AGC_SNS_DIR_TO__A, snsDirTo);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_KI_MINGAIN__A, 0x7fff);
+		status = write16(state, SCU_RAM_AGC_KI_MINGAIN__A, 0x7fff);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_KI_MAXGAIN__A, 0x0);
+		status = write16(state, SCU_RAM_AGC_KI_MAXGAIN__A, 0x0);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_KI_MIN__A, 0x0117);
+		status = write16(state, SCU_RAM_AGC_KI_MIN__A, 0x0117);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_KI_MAX__A, 0x0657);
+		status = write16(state, SCU_RAM_AGC_KI_MAX__A, 0x0657);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_CLP_SUM__A, 0);
+		status = write16(state, SCU_RAM_AGC_CLP_SUM__A, 0);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_CLP_CYCCNT__A, 0);
+		status = write16(state, SCU_RAM_AGC_CLP_CYCCNT__A, 0);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_CLP_DIR_WD__A, 0);
+		status = write16(state, SCU_RAM_AGC_CLP_DIR_WD__A, 0);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_CLP_DIR_STP__A, 1);
+		status = write16(state, SCU_RAM_AGC_CLP_DIR_STP__A, 1);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_SNS_SUM__A, 0);
+		status = write16(state, SCU_RAM_AGC_SNS_SUM__A, 0);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_SNS_CYCCNT__A, 0);
+		status = write16(state, SCU_RAM_AGC_SNS_CYCCNT__A, 0);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_SNS_DIR_WD__A, 0);
+		status = write16(state, SCU_RAM_AGC_SNS_DIR_WD__A, 0);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_SNS_DIR_STP__A, 1);
+		status = write16(state, SCU_RAM_AGC_SNS_DIR_STP__A, 1);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_SNS_CYCLEN__A, 500);
+		status = write16(state, SCU_RAM_AGC_SNS_CYCLEN__A, 500);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_KI_CYCLEN__A, 500);
+		status = write16(state, SCU_RAM_AGC_KI_CYCLEN__A, 500);
 		if (status < 0)
 			break;
 
 		/* Initialize inner-loop KI gain factors */
-		status = Read16_0(state, SCU_RAM_AGC_KI__A, &data);
+		status = read16(state, SCU_RAM_AGC_KI__A, &data);
 		if (status < 0)
 			break;
 		if (IsQAM(state)) {
@@ -3179,7 +3190,7 @@ static int InitAGC(struct drxk_state *state, bool isDTV)
 			data &= ~SCU_RAM_AGC_KI_IF__M;
 			data |= (DRXK_KI_IAGC_QAM << SCU_RAM_AGC_KI_IF__B);
 		}
-		status = Write16_0(state, SCU_RAM_AGC_KI__A, data);
+		status = write16(state, SCU_RAM_AGC_KI__A, data);
 		if (status < 0)
 			break;
 	} while (0);
@@ -3193,11 +3204,11 @@ static int DVBTQAMGetAccPktErr(struct drxk_state *state, u16 *packetErr)
 	dprintk(1, "\n");
 	do {
 		if (packetErr == NULL) {
-			status = Write16_0(state, SCU_RAM_FEC_ACCUM_PKT_FAILURES__A, 0);
+			status = write16(state, SCU_RAM_FEC_ACCUM_PKT_FAILURES__A, 0);
 			if (status < 0)
 				break;
 		} else {
-			status = Read16_0(state, SCU_RAM_FEC_ACCUM_PKT_FAILURES__A, packetErr);
+			status = read16(state, SCU_RAM_FEC_ACCUM_PKT_FAILURES__A, packetErr);
 			if (status < 0)
 				break;
 		}
@@ -3217,7 +3228,7 @@ static int DVBTScCommand(struct drxk_state *state,
 	int status;
 
 	dprintk(1, "\n");
-	status = Read16_0(state, OFDM_SC_COMM_EXEC__A, &scExec);
+	status = read16(state, OFDM_SC_COMM_EXEC__A, &scExec);
 	if (scExec != 1) {
 		/* SC is not running */
 		return -1;
@@ -3227,7 +3238,7 @@ static int DVBTScCommand(struct drxk_state *state,
 	retryCnt = 0;
 	do {
 		msleep(1);
-		status = Read16_0(state, OFDM_SC_RA_RAM_CMD__A, &curCmd);
+		status = read16(state, OFDM_SC_RA_RAM_CMD__A, &curCmd);
 		retryCnt++;
 	} while ((curCmd != 0) && (retryCnt < DRXK_MAX_RETRIES));
 	if (retryCnt >= DRXK_MAX_RETRIES)
@@ -3239,7 +3250,7 @@ static int DVBTScCommand(struct drxk_state *state,
 	case OFDM_SC_RA_RAM_CMD_SET_PREF_PARAM:
 	case OFDM_SC_RA_RAM_CMD_PROGRAM_PARAM:
 		status =
-		    Write16_0(state, OFDM_SC_RA_RAM_CMD_ADDR__A, subcmd);
+		    write16(state, OFDM_SC_RA_RAM_CMD_ADDR__A, subcmd);
 		break;
 	default:
 		/* Do nothing */
@@ -3256,17 +3267,17 @@ static int DVBTScCommand(struct drxk_state *state,
 	case OFDM_SC_RA_RAM_CMD_SET_PREF_PARAM:
 	case OFDM_SC_RA_RAM_CMD_PROGRAM_PARAM:
 		status =
-		    Write16_0(state, OFDM_SC_RA_RAM_PARAM1__A, param1);
+		    write16(state, OFDM_SC_RA_RAM_PARAM1__A, param1);
 		/* All commands using 1 parameters */
 	case OFDM_SC_RA_RAM_CMD_SET_ECHO_TIMING:
 	case OFDM_SC_RA_RAM_CMD_USER_IO:
 		status =
-		    Write16_0(state, OFDM_SC_RA_RAM_PARAM0__A, param0);
+		    write16(state, OFDM_SC_RA_RAM_PARAM0__A, param0);
 		/* All commands using 0 parameters */
 	case OFDM_SC_RA_RAM_CMD_GET_OP_PARAM:
 	case OFDM_SC_RA_RAM_CMD_NULL:
 		/* Write command */
-		status = Write16_0(state, OFDM_SC_RA_RAM_CMD__A, cmd);
+		status = write16(state, OFDM_SC_RA_RAM_CMD__A, cmd);
 		break;
 	default:
 		/* Unknown command */
@@ -3277,14 +3288,14 @@ static int DVBTScCommand(struct drxk_state *state,
 	retryCnt = 0;
 	do {
 		msleep(1);
-		status = Read16_0(state, OFDM_SC_RA_RAM_CMD__A, &curCmd);
+		status = read16(state, OFDM_SC_RA_RAM_CMD__A, &curCmd);
 		retryCnt++;
 	} while ((curCmd != 0) && (retryCnt < DRXK_MAX_RETRIES));
 	if (retryCnt >= DRXK_MAX_RETRIES)
 		return -1;
 
 	/* Check for illegal cmd */
-	status = Read16_0(state, OFDM_SC_RA_RAM_CMD_ADDR__A, &errCode);
+	status = read16(state, OFDM_SC_RA_RAM_CMD_ADDR__A, &errCode);
 	if (errCode == 0xFFFF) {
 		/* illegal command */
 		return -EINVAL;
@@ -3300,7 +3311,7 @@ static int DVBTScCommand(struct drxk_state *state,
 	case OFDM_SC_RA_RAM_CMD_USER_IO:
 	case OFDM_SC_RA_RAM_CMD_GET_OP_PARAM:
 		status =
-		    Read16_0(state, OFDM_SC_RA_RAM_PARAM0__A, &(param0));
+		    read16(state, OFDM_SC_RA_RAM_PARAM0__A, &(param0));
 		/* All commands yielding 0 results */
 	case OFDM_SC_RA_RAM_CMD_SET_ECHO_TIMING:
 	case OFDM_SC_RA_RAM_CMD_SET_TIMER:
@@ -3337,9 +3348,9 @@ static int DVBTCtrlSetIncEnable(struct drxk_state *state, bool *enabled)
 
 	dprintk(1, "\n");
 	if (*enabled == true)
-		status = Write16_0(state, IQM_CF_BYPASSDET__A, 0);
+		status = write16(state, IQM_CF_BYPASSDET__A, 0);
 	else
-		status = Write16_0(state, IQM_CF_BYPASSDET__A, 1);
+		status = write16(state, IQM_CF_BYPASSDET__A, 1);
 
 	return status;
 }
@@ -3353,11 +3364,11 @@ static int DVBTCtrlSetFrEnable(struct drxk_state *state, bool *enabled)
 	dprintk(1, "\n");
 	if (*enabled == true) {
 		/* write mask to 1 */
-		status = Write16_0(state, OFDM_SC_RA_RAM_FR_THRES_8K__A,
+		status = write16(state, OFDM_SC_RA_RAM_FR_THRES_8K__A,
 				   DEFAULT_FR_THRES_8K);
 	} else {
 		/* write mask to 0 */
-		status = Write16_0(state, OFDM_SC_RA_RAM_FR_THRES_8K__A, 0);
+		status = write16(state, OFDM_SC_RA_RAM_FR_THRES_8K__A, 0);
 	}
 
 	return status;
@@ -3371,7 +3382,7 @@ static int DVBTCtrlSetEchoThreshold(struct drxk_state *state,
 
 	dprintk(1, "\n");
 	do {
-		status = Read16_0(state, OFDM_SC_RA_RAM_ECHO_THRES__A, &data);
+		status = read16(state, OFDM_SC_RA_RAM_ECHO_THRES__A, &data);
 		if (status < 0)
 			break;
 
@@ -3395,7 +3406,7 @@ static int DVBTCtrlSetEchoThreshold(struct drxk_state *state,
 			break;
 		}
 
-		status = Write16_0(state, OFDM_SC_RA_RAM_ECHO_THRES__A, data);
+		status = write16(state, OFDM_SC_RA_RAM_ECHO_THRES__A, data);
 		if (status < 0)
 			break;
 	} while (0);
@@ -3418,7 +3429,7 @@ static int DVBTCtrlSetSqiSpeed(struct drxk_state *state,
 	default:
 		return -EINVAL;
 	}
-	status = Write16_0(state, SCU_RAM_FEC_PRE_RS_BER_FILTER_SH__A,
+	status = write16(state, SCU_RAM_FEC_PRE_RS_BER_FILTER_SH__A,
 			   (u16) *speed);
 	return status;
 }
@@ -3456,7 +3467,7 @@ static int DVBTActivatePresets(struct drxk_state *state)
 		status = DVBTCtrlSetEchoThreshold(state, &echoThres8k);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_AGC_INGAIN_TGT_MAX__A, state->m_dvbtIfAgcCfg.IngainTgtMax);
+		status = write16(state, SCU_RAM_AGC_INGAIN_TGT_MAX__A, state->m_dvbtIfAgcCfg.IngainTgtMax);
 		if (status < 0)
 			break;
 	} while (0);
@@ -3498,73 +3509,73 @@ static int SetDVBTStandard(struct drxk_state *state,
 			break;
 
 		/* reset datapath for OFDM, processors first */
-		status = Write16_0(state, OFDM_SC_COMM_EXEC__A, OFDM_SC_COMM_EXEC_STOP);
+		status = write16(state, OFDM_SC_COMM_EXEC__A, OFDM_SC_COMM_EXEC_STOP);
 		if (status < 0)
 			break;
-		status = Write16_0(state, OFDM_LC_COMM_EXEC__A, OFDM_LC_COMM_EXEC_STOP);
+		status = write16(state, OFDM_LC_COMM_EXEC__A, OFDM_LC_COMM_EXEC_STOP);
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_COMM_EXEC__A, IQM_COMM_EXEC_B_STOP);
+		status = write16(state, IQM_COMM_EXEC__A, IQM_COMM_EXEC_B_STOP);
 		if (status < 0)
 			break;
 
 		/* IQM setup */
 		/* synchronize on ofdstate->m_festart */
-		status = Write16_0(state, IQM_AF_UPD_SEL__A, 1);
+		status = write16(state, IQM_AF_UPD_SEL__A, 1);
 		if (status < 0)
 			break;
 		/* window size for clipping ADC detection */
-		status = Write16_0(state, IQM_AF_CLP_LEN__A, 0);
+		status = write16(state, IQM_AF_CLP_LEN__A, 0);
 		if (status < 0)
 			break;
 		/* window size for for sense pre-SAW detection */
-		status = Write16_0(state, IQM_AF_SNS_LEN__A, 0);
+		status = write16(state, IQM_AF_SNS_LEN__A, 0);
 		if (status < 0)
 			break;
 		/* sense threshold for sense pre-SAW detection */
-		status = Write16_0(state, IQM_AF_AMUX__A, IQM_AF_AMUX_SIGNAL2ADC);
+		status = write16(state, IQM_AF_AMUX__A, IQM_AF_AMUX_SIGNAL2ADC);
 		if (status < 0)
 			break;
 		status = SetIqmAf(state, true);
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, IQM_AF_AGC_RF__A, 0);
+		status = write16(state, IQM_AF_AGC_RF__A, 0);
 		if (status < 0)
 			break;
 
 		/* Impulse noise cruncher setup */
-		status = Write16_0(state, IQM_AF_INC_LCT__A, 0);	/* crunch in IQM_CF */
+		status = write16(state, IQM_AF_INC_LCT__A, 0);	/* crunch in IQM_CF */
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_CF_DET_LCT__A, 0);	/* detect in IQM_CF */
+		status = write16(state, IQM_CF_DET_LCT__A, 0);	/* detect in IQM_CF */
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_CF_WND_LEN__A, 3);	/* peak detector window length */
+		status = write16(state, IQM_CF_WND_LEN__A, 3);	/* peak detector window length */
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, IQM_RC_STRETCH__A, 16);
+		status = write16(state, IQM_RC_STRETCH__A, 16);
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_CF_OUT_ENA__A, 0x4);	/* enable output 2 */
+		status = write16(state, IQM_CF_OUT_ENA__A, 0x4);	/* enable output 2 */
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_CF_DS_ENA__A, 0x4);	/* decimate output 2 */
+		status = write16(state, IQM_CF_DS_ENA__A, 0x4);	/* decimate output 2 */
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_CF_SCALE__A, 1600);
+		status = write16(state, IQM_CF_SCALE__A, 1600);
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_CF_SCALE_SH__A, 0);
+		status = write16(state, IQM_CF_SCALE_SH__A, 0);
 		if (status < 0)
 			break;
 
 		/* virtual clipping threshold for clipping ADC detection */
-		status = Write16_0(state, IQM_AF_CLP_TH__A, 448);
+		status = write16(state, IQM_AF_CLP_TH__A, 448);
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_CF_DATATH__A, 495);	/* crunching threshold */
+		status = write16(state, IQM_CF_DATATH__A, 495);	/* crunching threshold */
 		if (status < 0)
 			break;
 
@@ -3572,17 +3583,17 @@ static int SetDVBTStandard(struct drxk_state *state,
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, IQM_CF_PKDTH__A, 2);	/* peak detector threshold */
+		status = write16(state, IQM_CF_PKDTH__A, 2);	/* peak detector threshold */
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_CF_POW_MEAS_LEN__A, 2);
+		status = write16(state, IQM_CF_POW_MEAS_LEN__A, 2);
 		if (status < 0)
 			break;
 		/* enable power measurement interrupt */
-		status = Write16_0(state, IQM_CF_COMM_INT_MSK__A, 1);
+		status = write16(state, IQM_CF_COMM_INT_MSK__A, 1);
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_COMM_EXEC__A, IQM_COMM_EXEC_B_ACTIVE);
+		status = write16(state, IQM_COMM_EXEC__A, IQM_COMM_EXEC_B_ACTIVE);
 		if (status < 0)
 			break;
 
@@ -3595,7 +3606,7 @@ static int SetDVBTStandard(struct drxk_state *state,
 			break;
 
 		/* Halt SCU to enable safe non-atomic accesses */
-		status = Write16_0(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_HOLD);
+		status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_HOLD);
 		if (status < 0)
 			break;
 
@@ -3607,52 +3618,52 @@ static int SetDVBTStandard(struct drxk_state *state,
 			break;
 
 		/* Set Noise Estimation notch width and enable DC fix */
-		status = Read16_0(state, OFDM_SC_RA_RAM_CONFIG__A, &data);
+		status = read16(state, OFDM_SC_RA_RAM_CONFIG__A, &data);
 		if (status < 0)
 			break;
 		data |= OFDM_SC_RA_RAM_CONFIG_NE_FIX_ENABLE__M;
-		status = Write16_0(state, OFDM_SC_RA_RAM_CONFIG__A, data);
+		status = write16(state, OFDM_SC_RA_RAM_CONFIG__A, data);
 		if (status < 0)
 			break;
 
 		/* Activate SCU to enable SCU commands */
-		status = Write16_0(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_ACTIVE);
+		status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_ACTIVE);
 		if (status < 0)
 			break;
 
 		if (!state->m_DRXK_A3_ROM_CODE) {
 			/* AGCInit() is not done for DVBT, so set agcFastClipCtrlDelay  */
-			status = Write16_0(state, SCU_RAM_AGC_FAST_CLP_CTRL_DELAY__A, state->m_dvbtIfAgcCfg.FastClipCtrlDelay);
+			status = write16(state, SCU_RAM_AGC_FAST_CLP_CTRL_DELAY__A, state->m_dvbtIfAgcCfg.FastClipCtrlDelay);
 			if (status < 0)
 				break;
 		}
 
 		/* OFDM_SC setup */
 #ifdef COMPILE_FOR_NONRT
-		status = Write16_0(state, OFDM_SC_RA_RAM_BE_OPT_DELAY__A, 1);
+		status = write16(state, OFDM_SC_RA_RAM_BE_OPT_DELAY__A, 1);
 		if (status < 0)
 			break;
-		status = Write16_0(state, OFDM_SC_RA_RAM_BE_OPT_INIT_DELAY__A, 2);
+		status = write16(state, OFDM_SC_RA_RAM_BE_OPT_INIT_DELAY__A, 2);
 		if (status < 0)
 			break;
 #endif
 
 		/* FEC setup */
-		status = Write16_0(state, FEC_DI_INPUT_CTL__A, 1);	/* OFDM input */
+		status = write16(state, FEC_DI_INPUT_CTL__A, 1);	/* OFDM input */
 		if (status < 0)
 			break;
 
 
 #ifdef COMPILE_FOR_NONRT
-		status = Write16_0(state, FEC_RS_MEASUREMENT_PERIOD__A, 0x400);
+		status = write16(state, FEC_RS_MEASUREMENT_PERIOD__A, 0x400);
 		if (status < 0)
 			break;
 #else
-		status = Write16_0(state, FEC_RS_MEASUREMENT_PERIOD__A, 0x1000);
+		status = write16(state, FEC_RS_MEASUREMENT_PERIOD__A, 0x1000);
 		if (status < 0)
 			break;
 #endif
-		status = Write16_0(state, FEC_RS_MEASUREMENT_PRESCALE__A, 0x0001);
+		status = write16(state, FEC_RS_MEASUREMENT_PRESCALE__A, 0x0001);
 		if (status < 0)
 			break;
 
@@ -3697,7 +3708,7 @@ static int DVBTStart(struct drxk_state *state)
 		status = MPEGTSStart(state);
 		if (status < 0)
 			break;
-		status = Write16_0(state, FEC_COMM_EXEC__A, FEC_COMM_EXEC_ACTIVE);
+		status = write16(state, FEC_COMM_EXEC__A, FEC_COMM_EXEC_ACTIVE);
 		if (status < 0)
 			break;
 	} while (0);
@@ -3732,21 +3743,21 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 			break;
 
 		/* Halt SCU to enable safe non-atomic accesses */
-		status = Write16_0(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_HOLD);
+		status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_HOLD);
 		if (status < 0)
 			break;
 
 		/* Stop processors */
-		status = Write16_0(state, OFDM_SC_COMM_EXEC__A, OFDM_SC_COMM_EXEC_STOP);
+		status = write16(state, OFDM_SC_COMM_EXEC__A, OFDM_SC_COMM_EXEC_STOP);
 		if (status < 0)
 			break;
-		status = Write16_0(state, OFDM_LC_COMM_EXEC__A, OFDM_LC_COMM_EXEC_STOP);
+		status = write16(state, OFDM_LC_COMM_EXEC__A, OFDM_LC_COMM_EXEC_STOP);
 		if (status < 0)
 			break;
 
 		/* Mandatory fix, always stop CP, required to set spl offset back to
 		   hardware default (is set to 0 by ucode during pilot detection */
-		status = Write16_0(state, OFDM_CP_COMM_EXEC__A, OFDM_CP_COMM_EXEC_STOP);
+		status = write16(state, OFDM_CP_COMM_EXEC__A, OFDM_CP_COMM_EXEC_STOP);
 		if (status < 0)
 			break;
 
@@ -3859,7 +3870,7 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 #else
 		/* Set Priorty high */
 		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_PRIO_HI;
-		status = Write16_0(state, OFDM_EC_SB_PRIOR__A, OFDM_EC_SB_PRIOR_HI);
+		status = write16(state, OFDM_EC_SB_PRIOR__A, OFDM_EC_SB_PRIOR_HI);
 		if (status < 0)
 			break;
 #endif
@@ -3903,58 +3914,58 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 		case BANDWIDTH_AUTO:
 		case BANDWIDTH_8_MHZ:
 			bandwidth = DRXK_BANDWIDTH_8MHZ_IN_HZ;
-			status = Write16_0(state, OFDM_SC_RA_RAM_SRMM_FIX_FACT_8K__A, 3052);
+			status = write16(state, OFDM_SC_RA_RAM_SRMM_FIX_FACT_8K__A, 3052);
 			if (status < 0)
 				break;
 			/* cochannel protection for PAL 8 MHz */
-			status = Write16_0(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_LEFT__A, 7);
+			status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_LEFT__A, 7);
 			if (status < 0)
 				break;
-			status = Write16_0(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_RIGHT__A, 7);
+			status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_RIGHT__A, 7);
 			if (status < 0)
 				break;
-			status = Write16_0(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_LEFT__A, 7);
+			status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_LEFT__A, 7);
 			if (status < 0)
 				break;
-			status = Write16_0(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_RIGHT__A, 1);
+			status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_RIGHT__A, 1);
 			if (status < 0)
 				break;
 			break;
 		case BANDWIDTH_7_MHZ:
 			bandwidth = DRXK_BANDWIDTH_7MHZ_IN_HZ;
-			status = Write16_0(state, OFDM_SC_RA_RAM_SRMM_FIX_FACT_8K__A, 3491);
+			status = write16(state, OFDM_SC_RA_RAM_SRMM_FIX_FACT_8K__A, 3491);
 			if (status < 0)
 				break;
 			/* cochannel protection for PAL 7 MHz */
-			status = Write16_0(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_LEFT__A, 8);
+			status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_LEFT__A, 8);
 			if (status < 0)
 				break;
-			status = Write16_0(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_RIGHT__A, 8);
+			status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_RIGHT__A, 8);
 			if (status < 0)
 				break;
-			status = Write16_0(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_LEFT__A, 4);
+			status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_LEFT__A, 4);
 			if (status < 0)
 				break;
-			status = Write16_0(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_RIGHT__A, 1);
+			status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_RIGHT__A, 1);
 			if (status < 0)
 				break;
 			break;
 		case BANDWIDTH_6_MHZ:
 			bandwidth = DRXK_BANDWIDTH_6MHZ_IN_HZ;
-			status = Write16_0(state, OFDM_SC_RA_RAM_SRMM_FIX_FACT_8K__A, 4073);
+			status = write16(state, OFDM_SC_RA_RAM_SRMM_FIX_FACT_8K__A, 4073);
 			if (status < 0)
 				break;
 			/* cochannel protection for NTSC 6 MHz */
-			status = Write16_0(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_LEFT__A, 19);
+			status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_LEFT__A, 19);
 			if (status < 0)
 				break;
-			status = Write16_0(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_RIGHT__A, 19);
+			status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_RIGHT__A, 19);
 			if (status < 0)
 				break;
-			status = Write16_0(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_LEFT__A, 14);
+			status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_LEFT__A, 14);
 			if (status < 0)
 				break;
-			status = Write16_0(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_RIGHT__A, 1);
+			status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_RIGHT__A, 1);
 			if (status < 0)
 				break;
 			break;
@@ -3986,7 +3997,7 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 		iqmRcRateOfs &=
 		    ((((u32) IQM_RC_RATE_OFS_HI__M) <<
 		      IQM_RC_RATE_OFS_LO__W) | IQM_RC_RATE_OFS_LO__M);
-		status = Write32(state, IQM_RC_RATE_OFS_LO__A, iqmRcRateOfs, 0);
+		status = write32(state, IQM_RC_RATE_OFS_LO__A, iqmRcRateOfs);
 		if (status < 0)
 			break;
 
@@ -4004,15 +4015,15 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 		/*== Start SC, write channel settings to SC ===============================*/
 
 		/* Activate SCU to enable SCU commands */
-		status = Write16_0(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_ACTIVE);
+		status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_ACTIVE);
 		if (status < 0)
 			break;
 
 		/* Enable SC after setting all other parameters */
-		status = Write16_0(state, OFDM_SC_COMM_STATE__A, 0);
+		status = write16(state, OFDM_SC_COMM_STATE__A, 0);
 		if (status < 0)
 			break;
-		status = Write16_0(state, OFDM_SC_COMM_EXEC__A, 1);
+		status = write16(state, OFDM_SC_COMM_EXEC__A, 1);
 		if (status < 0)
 			break;
 
@@ -4065,14 +4076,14 @@ static int GetDVBTLockStatus(struct drxk_state *state, u32 *pLockStatus)
 
 	/* driver 0.9.0 */
 	/* Check if SC is running */
-	status = Read16_0(state, OFDM_SC_COMM_EXEC__A, &ScCommExec);
+	status = read16(state, OFDM_SC_COMM_EXEC__A, &ScCommExec);
 	if (ScCommExec == OFDM_SC_COMM_EXEC_STOP) {
 		/* SC not active; return DRX_NOT_LOCKED */
 		*pLockStatus = NOT_LOCKED;
 		return status;
 	}
 
-	status = Read16_0(state, OFDM_SC_RA_RAM_LOCK__A, &ScRaRamLock);
+	status = read16(state, OFDM_SC_RA_RAM_LOCK__A, &ScRaRamLock);
 
 	if ((ScRaRamLock & mpeg_lock_mask) == mpeg_lock_mask)
 		*pLockStatus = MPEG_LOCK;
@@ -4114,7 +4125,7 @@ static int PowerDownQAM(struct drxk_state *state)
 
 	dprintk(1, "\n");
 	do {
-		status = Read16_0(state, SCU_COMM_EXEC__A, &data);
+		status = read16(state, SCU_COMM_EXEC__A, &data);
 		if (status < 0)
 			break;
 		if (data == SCU_COMM_EXEC_ACTIVE) {
@@ -4123,7 +4134,7 @@ static int PowerDownQAM(struct drxk_state *state)
 			   QAM and HW blocks
 			 */
 			/* stop all comstate->m_exec */
-			status = Write16_0(state, QAM_COMM_EXEC__A, QAM_COMM_EXEC_STOP);
+			status = write16(state, QAM_COMM_EXEC__A, QAM_COMM_EXEC_STOP);
 			if (status < 0)
 				break;
 			status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_STOP, 0, NULL, 1, &cmdResult);
@@ -4217,13 +4228,13 @@ static int SetQAMMeasurement(struct drxk_state *state,
 		     (fecRsPrescale >> 1)) / fecRsPrescale;
 
 		/* write corresponding registers */
-		status = Write16_0(state, FEC_RS_MEASUREMENT_PERIOD__A, fecRsPeriod);
+		status = write16(state, FEC_RS_MEASUREMENT_PERIOD__A, fecRsPeriod);
 		if (status < 0)
 			break;
-		status = Write16_0(state, FEC_RS_MEASUREMENT_PRESCALE__A, fecRsPrescale);
+		status = write16(state, FEC_RS_MEASUREMENT_PRESCALE__A, fecRsPrescale);
 		if (status < 0)
 			break;
-		status = Write16_0(state, FEC_OC_SNC_FAIL_PERIOD__A, fecRsPeriod);
+		status = write16(state, FEC_OC_SNC_FAIL_PERIOD__A, fecRsPeriod);
 		if (status < 0)
 			break;
 
@@ -4243,176 +4254,176 @@ static int SetQAM16(struct drxk_state *state)
 	do {
 		/* QAM Equalizer Setup */
 		/* Equalizer */
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD0__A, 13517);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD0__A, 13517);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD1__A, 13517);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD1__A, 13517);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD2__A, 13517);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD2__A, 13517);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD3__A, 13517);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD3__A, 13517);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD4__A, 13517);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD4__A, 13517);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD5__A, 13517);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD5__A, 13517);
 		if (status < 0)
 			break;
 		/* Decision Feedback Equalizer */
-		status = Write16_0(state, QAM_DQ_QUAL_FUN0__A, 2);
+		status = write16(state, QAM_DQ_QUAL_FUN0__A, 2);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_DQ_QUAL_FUN1__A, 2);
+		status = write16(state, QAM_DQ_QUAL_FUN1__A, 2);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_DQ_QUAL_FUN2__A, 2);
+		status = write16(state, QAM_DQ_QUAL_FUN2__A, 2);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_DQ_QUAL_FUN3__A, 2);
+		status = write16(state, QAM_DQ_QUAL_FUN3__A, 2);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_DQ_QUAL_FUN4__A, 2);
+		status = write16(state, QAM_DQ_QUAL_FUN4__A, 2);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_DQ_QUAL_FUN5__A, 0);
+		status = write16(state, QAM_DQ_QUAL_FUN5__A, 0);
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, QAM_SY_SYNC_HWM__A, 5);
+		status = write16(state, QAM_SY_SYNC_HWM__A, 5);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_SY_SYNC_AWM__A, 4);
+		status = write16(state, QAM_SY_SYNC_AWM__A, 4);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_SY_SYNC_LWM__A, 3);
+		status = write16(state, QAM_SY_SYNC_LWM__A, 3);
 		if (status < 0)
 			break;
 
 		/* QAM Slicer Settings */
-		status = Write16_0(state, SCU_RAM_QAM_SL_SIG_POWER__A, DRXK_QAM_SL_SIG_POWER_QAM16);
+		status = write16(state, SCU_RAM_QAM_SL_SIG_POWER__A, DRXK_QAM_SL_SIG_POWER_QAM16);
 		if (status < 0)
 			break;
 
 		/* QAM Loop Controller Coeficients */
-		status = Write16_0(state, SCU_RAM_QAM_LC_CA_FINE__A, 15);
+		status = write16(state, SCU_RAM_QAM_LC_CA_FINE__A, 15);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CA_COARSE__A, 40);
+		status = write16(state, SCU_RAM_QAM_LC_CA_COARSE__A, 40);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EP_FINE__A, 12);
+		status = write16(state, SCU_RAM_QAM_LC_EP_FINE__A, 12);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EP_MEDIUM__A, 24);
+		status = write16(state, SCU_RAM_QAM_LC_EP_MEDIUM__A, 24);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EP_COARSE__A, 24);
+		status = write16(state, SCU_RAM_QAM_LC_EP_COARSE__A, 24);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EI_FINE__A, 12);
+		status = write16(state, SCU_RAM_QAM_LC_EI_FINE__A, 12);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EI_MEDIUM__A, 16);
+		status = write16(state, SCU_RAM_QAM_LC_EI_MEDIUM__A, 16);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EI_COARSE__A, 16);
+		status = write16(state, SCU_RAM_QAM_LC_EI_COARSE__A, 16);
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, SCU_RAM_QAM_LC_CP_FINE__A, 5);
+		status = write16(state, SCU_RAM_QAM_LC_CP_FINE__A, 5);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CP_MEDIUM__A, 20);
+		status = write16(state, SCU_RAM_QAM_LC_CP_MEDIUM__A, 20);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CP_COARSE__A, 80);
+		status = write16(state, SCU_RAM_QAM_LC_CP_COARSE__A, 80);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CI_FINE__A, 5);
+		status = write16(state, SCU_RAM_QAM_LC_CI_FINE__A, 5);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CI_MEDIUM__A, 20);
+		status = write16(state, SCU_RAM_QAM_LC_CI_MEDIUM__A, 20);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CI_COARSE__A, 50);
+		status = write16(state, SCU_RAM_QAM_LC_CI_COARSE__A, 50);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF_FINE__A, 16);
+		status = write16(state, SCU_RAM_QAM_LC_CF_FINE__A, 16);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF_MEDIUM__A, 16);
+		status = write16(state, SCU_RAM_QAM_LC_CF_MEDIUM__A, 16);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF_COARSE__A, 32);
+		status = write16(state, SCU_RAM_QAM_LC_CF_COARSE__A, 32);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF1_FINE__A, 5);
+		status = write16(state, SCU_RAM_QAM_LC_CF1_FINE__A, 5);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF1_MEDIUM__A, 10);
+		status = write16(state, SCU_RAM_QAM_LC_CF1_MEDIUM__A, 10);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF1_COARSE__A, 10);
+		status = write16(state, SCU_RAM_QAM_LC_CF1_COARSE__A, 10);
 		if (status < 0)
 			break;
 
 
 		/* QAM State Machine (FSM) Thresholds */
 
-		status = Write16_0(state, SCU_RAM_QAM_FSM_RTH__A, 140);
+		status = write16(state, SCU_RAM_QAM_FSM_RTH__A, 140);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_FTH__A, 50);
+		status = write16(state, SCU_RAM_QAM_FSM_FTH__A, 50);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_CTH__A, 95);
+		status = write16(state, SCU_RAM_QAM_FSM_CTH__A, 95);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_PTH__A, 120);
+		status = write16(state, SCU_RAM_QAM_FSM_PTH__A, 120);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_QTH__A, 230);
+		status = write16(state, SCU_RAM_QAM_FSM_QTH__A, 230);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_MTH__A, 105);
+		status = write16(state, SCU_RAM_QAM_FSM_MTH__A, 105);
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, SCU_RAM_QAM_FSM_RATE_LIM__A, 40);
+		status = write16(state, SCU_RAM_QAM_FSM_RATE_LIM__A, 40);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_COUNT_LIM__A, 4);
+		status = write16(state, SCU_RAM_QAM_FSM_COUNT_LIM__A, 4);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_FREQ_LIM__A, 24);
+		status = write16(state, SCU_RAM_QAM_FSM_FREQ_LIM__A, 24);
 		if (status < 0)
 			break;
 
 
 		/* QAM FSM Tracking Parameters */
 
-		status = Write16_0(state, SCU_RAM_QAM_FSM_MEDIAN_AV_MULT__A, (u16) 16);
+		status = write16(state, SCU_RAM_QAM_FSM_MEDIAN_AV_MULT__A, (u16) 16);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_RADIUS_AV_LIMIT__A, (u16) 220);
+		status = write16(state, SCU_RAM_QAM_FSM_RADIUS_AV_LIMIT__A, (u16) 220);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET1__A, (u16) 25);
+		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET1__A, (u16) 25);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET2__A, (u16) 6);
+		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET2__A, (u16) 6);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, (u16) -24);
+		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, (u16) -24);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET4__A, (u16) -65);
+		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET4__A, (u16) -65);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) -127);
+		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) -127);
 		if (status < 0)
 			break;
 	} while (0);
@@ -4435,180 +4446,180 @@ static int SetQAM32(struct drxk_state *state)
 	do {
 		/* QAM Equalizer Setup */
 		/* Equalizer */
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD0__A, 6707);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD0__A, 6707);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD1__A, 6707);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD1__A, 6707);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD2__A, 6707);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD2__A, 6707);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD3__A, 6707);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD3__A, 6707);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD4__A, 6707);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD4__A, 6707);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD5__A, 6707);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD5__A, 6707);
 		if (status < 0)
 			break;
 
 		/* Decision Feedback Equalizer */
-		status = Write16_0(state, QAM_DQ_QUAL_FUN0__A, 3);
+		status = write16(state, QAM_DQ_QUAL_FUN0__A, 3);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_DQ_QUAL_FUN1__A, 3);
+		status = write16(state, QAM_DQ_QUAL_FUN1__A, 3);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_DQ_QUAL_FUN2__A, 3);
+		status = write16(state, QAM_DQ_QUAL_FUN2__A, 3);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_DQ_QUAL_FUN3__A, 3);
+		status = write16(state, QAM_DQ_QUAL_FUN3__A, 3);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_DQ_QUAL_FUN4__A, 3);
+		status = write16(state, QAM_DQ_QUAL_FUN4__A, 3);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_DQ_QUAL_FUN5__A, 0);
+		status = write16(state, QAM_DQ_QUAL_FUN5__A, 0);
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, QAM_SY_SYNC_HWM__A, 6);
+		status = write16(state, QAM_SY_SYNC_HWM__A, 6);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_SY_SYNC_AWM__A, 5);
+		status = write16(state, QAM_SY_SYNC_AWM__A, 5);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_SY_SYNC_LWM__A, 3);
+		status = write16(state, QAM_SY_SYNC_LWM__A, 3);
 		if (status < 0)
 			break;
 
 		/* QAM Slicer Settings */
 
-		status = Write16_0(state, SCU_RAM_QAM_SL_SIG_POWER__A, DRXK_QAM_SL_SIG_POWER_QAM32);
+		status = write16(state, SCU_RAM_QAM_SL_SIG_POWER__A, DRXK_QAM_SL_SIG_POWER_QAM32);
 		if (status < 0)
 			break;
 
 
 		/* QAM Loop Controller Coeficients */
 
-		status = Write16_0(state, SCU_RAM_QAM_LC_CA_FINE__A, 15);
+		status = write16(state, SCU_RAM_QAM_LC_CA_FINE__A, 15);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CA_COARSE__A, 40);
+		status = write16(state, SCU_RAM_QAM_LC_CA_COARSE__A, 40);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EP_FINE__A, 12);
+		status = write16(state, SCU_RAM_QAM_LC_EP_FINE__A, 12);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EP_MEDIUM__A, 24);
+		status = write16(state, SCU_RAM_QAM_LC_EP_MEDIUM__A, 24);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EP_COARSE__A, 24);
+		status = write16(state, SCU_RAM_QAM_LC_EP_COARSE__A, 24);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EI_FINE__A, 12);
+		status = write16(state, SCU_RAM_QAM_LC_EI_FINE__A, 12);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EI_MEDIUM__A, 16);
+		status = write16(state, SCU_RAM_QAM_LC_EI_MEDIUM__A, 16);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EI_COARSE__A, 16);
+		status = write16(state, SCU_RAM_QAM_LC_EI_COARSE__A, 16);
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, SCU_RAM_QAM_LC_CP_FINE__A, 5);
+		status = write16(state, SCU_RAM_QAM_LC_CP_FINE__A, 5);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CP_MEDIUM__A, 20);
+		status = write16(state, SCU_RAM_QAM_LC_CP_MEDIUM__A, 20);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CP_COARSE__A, 80);
+		status = write16(state, SCU_RAM_QAM_LC_CP_COARSE__A, 80);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CI_FINE__A, 5);
+		status = write16(state, SCU_RAM_QAM_LC_CI_FINE__A, 5);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CI_MEDIUM__A, 20);
+		status = write16(state, SCU_RAM_QAM_LC_CI_MEDIUM__A, 20);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CI_COARSE__A, 50);
+		status = write16(state, SCU_RAM_QAM_LC_CI_COARSE__A, 50);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF_FINE__A, 16);
+		status = write16(state, SCU_RAM_QAM_LC_CF_FINE__A, 16);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF_MEDIUM__A, 16);
+		status = write16(state, SCU_RAM_QAM_LC_CF_MEDIUM__A, 16);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF_COARSE__A, 16);
+		status = write16(state, SCU_RAM_QAM_LC_CF_COARSE__A, 16);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF1_FINE__A, 5);
+		status = write16(state, SCU_RAM_QAM_LC_CF1_FINE__A, 5);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF1_MEDIUM__A, 10);
+		status = write16(state, SCU_RAM_QAM_LC_CF1_MEDIUM__A, 10);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF1_COARSE__A, 0);
+		status = write16(state, SCU_RAM_QAM_LC_CF1_COARSE__A, 0);
 		if (status < 0)
 			break;
 
 
 		/* QAM State Machine (FSM) Thresholds */
 
-		status = Write16_0(state, SCU_RAM_QAM_FSM_RTH__A, 90);
+		status = write16(state, SCU_RAM_QAM_FSM_RTH__A, 90);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_FTH__A, 50);
+		status = write16(state, SCU_RAM_QAM_FSM_FTH__A, 50);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_CTH__A, 80);
+		status = write16(state, SCU_RAM_QAM_FSM_CTH__A, 80);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_PTH__A, 100);
+		status = write16(state, SCU_RAM_QAM_FSM_PTH__A, 100);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_QTH__A, 170);
+		status = write16(state, SCU_RAM_QAM_FSM_QTH__A, 170);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_MTH__A, 100);
+		status = write16(state, SCU_RAM_QAM_FSM_MTH__A, 100);
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, SCU_RAM_QAM_FSM_RATE_LIM__A, 40);
+		status = write16(state, SCU_RAM_QAM_FSM_RATE_LIM__A, 40);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_COUNT_LIM__A, 4);
+		status = write16(state, SCU_RAM_QAM_FSM_COUNT_LIM__A, 4);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_FREQ_LIM__A, 10);
+		status = write16(state, SCU_RAM_QAM_FSM_FREQ_LIM__A, 10);
 		if (status < 0)
 			break;
 
 
 		/* QAM FSM Tracking Parameters */
 
-		status = Write16_0(state, SCU_RAM_QAM_FSM_MEDIAN_AV_MULT__A, (u16) 12);
+		status = write16(state, SCU_RAM_QAM_FSM_MEDIAN_AV_MULT__A, (u16) 12);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_RADIUS_AV_LIMIT__A, (u16) 140);
+		status = write16(state, SCU_RAM_QAM_FSM_RADIUS_AV_LIMIT__A, (u16) 140);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET1__A, (u16) -8);
+		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET1__A, (u16) -8);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET2__A, (u16) -16);
+		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET2__A, (u16) -16);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, (u16) -26);
+		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, (u16) -26);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET4__A, (u16) -56);
+		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET4__A, (u16) -56);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) -86);
+		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) -86);
 		if (status < 0)
 			break;
 	} while (0);
@@ -4631,179 +4642,179 @@ static int SetQAM64(struct drxk_state *state)
 	do {
 		/* QAM Equalizer Setup */
 		/* Equalizer */
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD0__A, 13336);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD0__A, 13336);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD1__A, 12618);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD1__A, 12618);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD2__A, 11988);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD2__A, 11988);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD3__A, 13809);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD3__A, 13809);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD4__A, 13809);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD4__A, 13809);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD5__A, 15609);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD5__A, 15609);
 		if (status < 0)
 			break;
 
 		/* Decision Feedback Equalizer */
-		status = Write16_0(state, QAM_DQ_QUAL_FUN0__A, 4);
+		status = write16(state, QAM_DQ_QUAL_FUN0__A, 4);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_DQ_QUAL_FUN1__A, 4);
+		status = write16(state, QAM_DQ_QUAL_FUN1__A, 4);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_DQ_QUAL_FUN2__A, 4);
+		status = write16(state, QAM_DQ_QUAL_FUN2__A, 4);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_DQ_QUAL_FUN3__A, 4);
+		status = write16(state, QAM_DQ_QUAL_FUN3__A, 4);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_DQ_QUAL_FUN4__A, 3);
+		status = write16(state, QAM_DQ_QUAL_FUN4__A, 3);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_DQ_QUAL_FUN5__A, 0);
+		status = write16(state, QAM_DQ_QUAL_FUN5__A, 0);
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, QAM_SY_SYNC_HWM__A, 5);
+		status = write16(state, QAM_SY_SYNC_HWM__A, 5);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_SY_SYNC_AWM__A, 4);
+		status = write16(state, QAM_SY_SYNC_AWM__A, 4);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_SY_SYNC_LWM__A, 3);
+		status = write16(state, QAM_SY_SYNC_LWM__A, 3);
 		if (status < 0)
 			break;
 
 		/* QAM Slicer Settings */
-		status = Write16_0(state, SCU_RAM_QAM_SL_SIG_POWER__A, DRXK_QAM_SL_SIG_POWER_QAM64);
+		status = write16(state, SCU_RAM_QAM_SL_SIG_POWER__A, DRXK_QAM_SL_SIG_POWER_QAM64);
 		if (status < 0)
 			break;
 
 
 		/* QAM Loop Controller Coeficients */
 
-		status = Write16_0(state, SCU_RAM_QAM_LC_CA_FINE__A, 15);
+		status = write16(state, SCU_RAM_QAM_LC_CA_FINE__A, 15);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CA_COARSE__A, 40);
+		status = write16(state, SCU_RAM_QAM_LC_CA_COARSE__A, 40);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EP_FINE__A, 12);
+		status = write16(state, SCU_RAM_QAM_LC_EP_FINE__A, 12);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EP_MEDIUM__A, 24);
+		status = write16(state, SCU_RAM_QAM_LC_EP_MEDIUM__A, 24);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EP_COARSE__A, 24);
+		status = write16(state, SCU_RAM_QAM_LC_EP_COARSE__A, 24);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EI_FINE__A, 12);
+		status = write16(state, SCU_RAM_QAM_LC_EI_FINE__A, 12);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EI_MEDIUM__A, 16);
+		status = write16(state, SCU_RAM_QAM_LC_EI_MEDIUM__A, 16);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EI_COARSE__A, 16);
+		status = write16(state, SCU_RAM_QAM_LC_EI_COARSE__A, 16);
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, SCU_RAM_QAM_LC_CP_FINE__A, 5);
+		status = write16(state, SCU_RAM_QAM_LC_CP_FINE__A, 5);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CP_MEDIUM__A, 30);
+		status = write16(state, SCU_RAM_QAM_LC_CP_MEDIUM__A, 30);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CP_COARSE__A, 100);
+		status = write16(state, SCU_RAM_QAM_LC_CP_COARSE__A, 100);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CI_FINE__A, 5);
+		status = write16(state, SCU_RAM_QAM_LC_CI_FINE__A, 5);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CI_MEDIUM__A, 30);
+		status = write16(state, SCU_RAM_QAM_LC_CI_MEDIUM__A, 30);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CI_COARSE__A, 50);
+		status = write16(state, SCU_RAM_QAM_LC_CI_COARSE__A, 50);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF_FINE__A, 16);
+		status = write16(state, SCU_RAM_QAM_LC_CF_FINE__A, 16);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF_MEDIUM__A, 25);
+		status = write16(state, SCU_RAM_QAM_LC_CF_MEDIUM__A, 25);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF_COARSE__A, 48);
+		status = write16(state, SCU_RAM_QAM_LC_CF_COARSE__A, 48);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF1_FINE__A, 5);
+		status = write16(state, SCU_RAM_QAM_LC_CF1_FINE__A, 5);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF1_MEDIUM__A, 10);
+		status = write16(state, SCU_RAM_QAM_LC_CF1_MEDIUM__A, 10);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF1_COARSE__A, 10);
+		status = write16(state, SCU_RAM_QAM_LC_CF1_COARSE__A, 10);
 		if (status < 0)
 			break;
 
 
 		/* QAM State Machine (FSM) Thresholds */
 
-		status = Write16_0(state, SCU_RAM_QAM_FSM_RTH__A, 100);
+		status = write16(state, SCU_RAM_QAM_FSM_RTH__A, 100);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_FTH__A, 60);
+		status = write16(state, SCU_RAM_QAM_FSM_FTH__A, 60);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_CTH__A, 80);
+		status = write16(state, SCU_RAM_QAM_FSM_CTH__A, 80);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_PTH__A, 110);
+		status = write16(state, SCU_RAM_QAM_FSM_PTH__A, 110);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_QTH__A, 200);
+		status = write16(state, SCU_RAM_QAM_FSM_QTH__A, 200);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_MTH__A, 95);
+		status = write16(state, SCU_RAM_QAM_FSM_MTH__A, 95);
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, SCU_RAM_QAM_FSM_RATE_LIM__A, 40);
+		status = write16(state, SCU_RAM_QAM_FSM_RATE_LIM__A, 40);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_COUNT_LIM__A, 4);
+		status = write16(state, SCU_RAM_QAM_FSM_COUNT_LIM__A, 4);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_FREQ_LIM__A, 15);
+		status = write16(state, SCU_RAM_QAM_FSM_FREQ_LIM__A, 15);
 		if (status < 0)
 			break;
 
 
 		/* QAM FSM Tracking Parameters */
 
-		status = Write16_0(state, SCU_RAM_QAM_FSM_MEDIAN_AV_MULT__A, (u16) 12);
+		status = write16(state, SCU_RAM_QAM_FSM_MEDIAN_AV_MULT__A, (u16) 12);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_RADIUS_AV_LIMIT__A, (u16) 141);
+		status = write16(state, SCU_RAM_QAM_FSM_RADIUS_AV_LIMIT__A, (u16) 141);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET1__A, (u16) 7);
+		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET1__A, (u16) 7);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET2__A, (u16) 0);
+		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET2__A, (u16) 0);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, (u16) -15);
+		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, (u16) -15);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET4__A, (u16) -45);
+		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET4__A, (u16) -45);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) -80);
+		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) -80);
 		if (status < 0)
 			break;
 	} while (0);
@@ -4826,181 +4837,181 @@ static int SetQAM128(struct drxk_state *state)
 	do {
 		/* QAM Equalizer Setup */
 		/* Equalizer */
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD0__A, 6564);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD0__A, 6564);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD1__A, 6598);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD1__A, 6598);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD2__A, 6394);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD2__A, 6394);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD3__A, 6409);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD3__A, 6409);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD4__A, 6656);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD4__A, 6656);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD5__A, 7238);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD5__A, 7238);
 		if (status < 0)
 			break;
 
 		/* Decision Feedback Equalizer */
-		status = Write16_0(state, QAM_DQ_QUAL_FUN0__A, 6);
+		status = write16(state, QAM_DQ_QUAL_FUN0__A, 6);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_DQ_QUAL_FUN1__A, 6);
+		status = write16(state, QAM_DQ_QUAL_FUN1__A, 6);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_DQ_QUAL_FUN2__A, 6);
+		status = write16(state, QAM_DQ_QUAL_FUN2__A, 6);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_DQ_QUAL_FUN3__A, 6);
+		status = write16(state, QAM_DQ_QUAL_FUN3__A, 6);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_DQ_QUAL_FUN4__A, 5);
+		status = write16(state, QAM_DQ_QUAL_FUN4__A, 5);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_DQ_QUAL_FUN5__A, 0);
+		status = write16(state, QAM_DQ_QUAL_FUN5__A, 0);
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, QAM_SY_SYNC_HWM__A, 6);
+		status = write16(state, QAM_SY_SYNC_HWM__A, 6);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_SY_SYNC_AWM__A, 5);
+		status = write16(state, QAM_SY_SYNC_AWM__A, 5);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_SY_SYNC_LWM__A, 3);
+		status = write16(state, QAM_SY_SYNC_LWM__A, 3);
 		if (status < 0)
 			break;
 
 
 		/* QAM Slicer Settings */
 
-		status = Write16_0(state, SCU_RAM_QAM_SL_SIG_POWER__A, DRXK_QAM_SL_SIG_POWER_QAM128);
+		status = write16(state, SCU_RAM_QAM_SL_SIG_POWER__A, DRXK_QAM_SL_SIG_POWER_QAM128);
 		if (status < 0)
 			break;
 
 
 		/* QAM Loop Controller Coeficients */
 
-		status = Write16_0(state, SCU_RAM_QAM_LC_CA_FINE__A, 15);
+		status = write16(state, SCU_RAM_QAM_LC_CA_FINE__A, 15);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CA_COARSE__A, 40);
+		status = write16(state, SCU_RAM_QAM_LC_CA_COARSE__A, 40);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EP_FINE__A, 12);
+		status = write16(state, SCU_RAM_QAM_LC_EP_FINE__A, 12);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EP_MEDIUM__A, 24);
+		status = write16(state, SCU_RAM_QAM_LC_EP_MEDIUM__A, 24);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EP_COARSE__A, 24);
+		status = write16(state, SCU_RAM_QAM_LC_EP_COARSE__A, 24);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EI_FINE__A, 12);
+		status = write16(state, SCU_RAM_QAM_LC_EI_FINE__A, 12);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EI_MEDIUM__A, 16);
+		status = write16(state, SCU_RAM_QAM_LC_EI_MEDIUM__A, 16);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EI_COARSE__A, 16);
+		status = write16(state, SCU_RAM_QAM_LC_EI_COARSE__A, 16);
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, SCU_RAM_QAM_LC_CP_FINE__A, 5);
+		status = write16(state, SCU_RAM_QAM_LC_CP_FINE__A, 5);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CP_MEDIUM__A, 40);
+		status = write16(state, SCU_RAM_QAM_LC_CP_MEDIUM__A, 40);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CP_COARSE__A, 120);
+		status = write16(state, SCU_RAM_QAM_LC_CP_COARSE__A, 120);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CI_FINE__A, 5);
+		status = write16(state, SCU_RAM_QAM_LC_CI_FINE__A, 5);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CI_MEDIUM__A, 40);
+		status = write16(state, SCU_RAM_QAM_LC_CI_MEDIUM__A, 40);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CI_COARSE__A, 60);
+		status = write16(state, SCU_RAM_QAM_LC_CI_COARSE__A, 60);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF_FINE__A, 16);
+		status = write16(state, SCU_RAM_QAM_LC_CF_FINE__A, 16);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF_MEDIUM__A, 25);
+		status = write16(state, SCU_RAM_QAM_LC_CF_MEDIUM__A, 25);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF_COARSE__A, 64);
+		status = write16(state, SCU_RAM_QAM_LC_CF_COARSE__A, 64);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF1_FINE__A, 5);
+		status = write16(state, SCU_RAM_QAM_LC_CF1_FINE__A, 5);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF1_MEDIUM__A, 10);
+		status = write16(state, SCU_RAM_QAM_LC_CF1_MEDIUM__A, 10);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF1_COARSE__A, 0);
+		status = write16(state, SCU_RAM_QAM_LC_CF1_COARSE__A, 0);
 		if (status < 0)
 			break;
 
 
 		/* QAM State Machine (FSM) Thresholds */
 
-		status = Write16_0(state, SCU_RAM_QAM_FSM_RTH__A, 50);
+		status = write16(state, SCU_RAM_QAM_FSM_RTH__A, 50);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_FTH__A, 60);
+		status = write16(state, SCU_RAM_QAM_FSM_FTH__A, 60);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_CTH__A, 80);
+		status = write16(state, SCU_RAM_QAM_FSM_CTH__A, 80);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_PTH__A, 100);
+		status = write16(state, SCU_RAM_QAM_FSM_PTH__A, 100);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_QTH__A, 140);
+		status = write16(state, SCU_RAM_QAM_FSM_QTH__A, 140);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_MTH__A, 100);
+		status = write16(state, SCU_RAM_QAM_FSM_MTH__A, 100);
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, SCU_RAM_QAM_FSM_RATE_LIM__A, 40);
+		status = write16(state, SCU_RAM_QAM_FSM_RATE_LIM__A, 40);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_COUNT_LIM__A, 5);
+		status = write16(state, SCU_RAM_QAM_FSM_COUNT_LIM__A, 5);
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, SCU_RAM_QAM_FSM_FREQ_LIM__A, 12);
+		status = write16(state, SCU_RAM_QAM_FSM_FREQ_LIM__A, 12);
 		if (status < 0)
 			break;
 
 		/* QAM FSM Tracking Parameters */
 
-		status = Write16_0(state, SCU_RAM_QAM_FSM_MEDIAN_AV_MULT__A, (u16) 8);
+		status = write16(state, SCU_RAM_QAM_FSM_MEDIAN_AV_MULT__A, (u16) 8);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_RADIUS_AV_LIMIT__A, (u16) 65);
+		status = write16(state, SCU_RAM_QAM_FSM_RADIUS_AV_LIMIT__A, (u16) 65);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET1__A, (u16) 5);
+		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET1__A, (u16) 5);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET2__A, (u16) 3);
+		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET2__A, (u16) 3);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, (u16) -1);
+		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, (u16) -1);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET4__A, (u16) -12);
+		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET4__A, (u16) -12);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) -23);
+		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) -23);
 		if (status < 0)
 			break;
 	} while (0);
@@ -5023,180 +5034,180 @@ static int SetQAM256(struct drxk_state *state)
 	do {
 		/* QAM Equalizer Setup */
 		/* Equalizer */
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD0__A, 11502);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD0__A, 11502);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD1__A, 12084);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD1__A, 12084);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD2__A, 12543);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD2__A, 12543);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD3__A, 12931);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD3__A, 12931);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD4__A, 13629);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD4__A, 13629);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_EQ_CMA_RAD5__A, 15385);
+		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD5__A, 15385);
 		if (status < 0)
 			break;
 
 		/* Decision Feedback Equalizer */
-		status = Write16_0(state, QAM_DQ_QUAL_FUN0__A, 8);
+		status = write16(state, QAM_DQ_QUAL_FUN0__A, 8);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_DQ_QUAL_FUN1__A, 8);
+		status = write16(state, QAM_DQ_QUAL_FUN1__A, 8);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_DQ_QUAL_FUN2__A, 8);
+		status = write16(state, QAM_DQ_QUAL_FUN2__A, 8);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_DQ_QUAL_FUN3__A, 8);
+		status = write16(state, QAM_DQ_QUAL_FUN3__A, 8);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_DQ_QUAL_FUN4__A, 6);
+		status = write16(state, QAM_DQ_QUAL_FUN4__A, 6);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_DQ_QUAL_FUN5__A, 0);
+		status = write16(state, QAM_DQ_QUAL_FUN5__A, 0);
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, QAM_SY_SYNC_HWM__A, 5);
+		status = write16(state, QAM_SY_SYNC_HWM__A, 5);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_SY_SYNC_AWM__A, 4);
+		status = write16(state, QAM_SY_SYNC_AWM__A, 4);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_SY_SYNC_LWM__A, 3);
+		status = write16(state, QAM_SY_SYNC_LWM__A, 3);
 		if (status < 0)
 			break;
 
 		/* QAM Slicer Settings */
 
-		status = Write16_0(state, SCU_RAM_QAM_SL_SIG_POWER__A, DRXK_QAM_SL_SIG_POWER_QAM256);
+		status = write16(state, SCU_RAM_QAM_SL_SIG_POWER__A, DRXK_QAM_SL_SIG_POWER_QAM256);
 		if (status < 0)
 			break;
 
 
 		/* QAM Loop Controller Coeficients */
 
-		status = Write16_0(state, SCU_RAM_QAM_LC_CA_FINE__A, 15);
+		status = write16(state, SCU_RAM_QAM_LC_CA_FINE__A, 15);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CA_COARSE__A, 40);
+		status = write16(state, SCU_RAM_QAM_LC_CA_COARSE__A, 40);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EP_FINE__A, 12);
+		status = write16(state, SCU_RAM_QAM_LC_EP_FINE__A, 12);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EP_MEDIUM__A, 24);
+		status = write16(state, SCU_RAM_QAM_LC_EP_MEDIUM__A, 24);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EP_COARSE__A, 24);
+		status = write16(state, SCU_RAM_QAM_LC_EP_COARSE__A, 24);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EI_FINE__A, 12);
+		status = write16(state, SCU_RAM_QAM_LC_EI_FINE__A, 12);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EI_MEDIUM__A, 16);
+		status = write16(state, SCU_RAM_QAM_LC_EI_MEDIUM__A, 16);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_EI_COARSE__A, 16);
+		status = write16(state, SCU_RAM_QAM_LC_EI_COARSE__A, 16);
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, SCU_RAM_QAM_LC_CP_FINE__A, 5);
+		status = write16(state, SCU_RAM_QAM_LC_CP_FINE__A, 5);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CP_MEDIUM__A, 50);
+		status = write16(state, SCU_RAM_QAM_LC_CP_MEDIUM__A, 50);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CP_COARSE__A, 250);
+		status = write16(state, SCU_RAM_QAM_LC_CP_COARSE__A, 250);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CI_FINE__A, 5);
+		status = write16(state, SCU_RAM_QAM_LC_CI_FINE__A, 5);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CI_MEDIUM__A, 50);
+		status = write16(state, SCU_RAM_QAM_LC_CI_MEDIUM__A, 50);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CI_COARSE__A, 125);
+		status = write16(state, SCU_RAM_QAM_LC_CI_COARSE__A, 125);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF_FINE__A, 16);
+		status = write16(state, SCU_RAM_QAM_LC_CF_FINE__A, 16);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF_MEDIUM__A, 25);
+		status = write16(state, SCU_RAM_QAM_LC_CF_MEDIUM__A, 25);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF_COARSE__A, 48);
+		status = write16(state, SCU_RAM_QAM_LC_CF_COARSE__A, 48);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF1_FINE__A, 5);
+		status = write16(state, SCU_RAM_QAM_LC_CF1_FINE__A, 5);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF1_MEDIUM__A, 10);
+		status = write16(state, SCU_RAM_QAM_LC_CF1_MEDIUM__A, 10);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_LC_CF1_COARSE__A, 10);
+		status = write16(state, SCU_RAM_QAM_LC_CF1_COARSE__A, 10);
 		if (status < 0)
 			break;
 
 
 		/* QAM State Machine (FSM) Thresholds */
 
-		status = Write16_0(state, SCU_RAM_QAM_FSM_RTH__A, 50);
+		status = write16(state, SCU_RAM_QAM_FSM_RTH__A, 50);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_FTH__A, 60);
+		status = write16(state, SCU_RAM_QAM_FSM_FTH__A, 60);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_CTH__A, 80);
+		status = write16(state, SCU_RAM_QAM_FSM_CTH__A, 80);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_PTH__A, 100);
+		status = write16(state, SCU_RAM_QAM_FSM_PTH__A, 100);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_QTH__A, 150);
+		status = write16(state, SCU_RAM_QAM_FSM_QTH__A, 150);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_MTH__A, 110);
+		status = write16(state, SCU_RAM_QAM_FSM_MTH__A, 110);
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, SCU_RAM_QAM_FSM_RATE_LIM__A, 40);
+		status = write16(state, SCU_RAM_QAM_FSM_RATE_LIM__A, 40);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_COUNT_LIM__A, 4);
+		status = write16(state, SCU_RAM_QAM_FSM_COUNT_LIM__A, 4);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_FREQ_LIM__A, 12);
+		status = write16(state, SCU_RAM_QAM_FSM_FREQ_LIM__A, 12);
 		if (status < 0)
 			break;
 
 
 		/* QAM FSM Tracking Parameters */
 
-		status = Write16_0(state, SCU_RAM_QAM_FSM_MEDIAN_AV_MULT__A, (u16) 8);
+		status = write16(state, SCU_RAM_QAM_FSM_MEDIAN_AV_MULT__A, (u16) 8);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_RADIUS_AV_LIMIT__A, (u16) 74);
+		status = write16(state, SCU_RAM_QAM_FSM_RADIUS_AV_LIMIT__A, (u16) 74);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET1__A, (u16) 18);
+		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET1__A, (u16) 18);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET2__A, (u16) 13);
+		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET2__A, (u16) 13);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, (u16) 7);
+		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, (u16) 7);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET4__A, (u16) 0);
+		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET4__A, (u16) 0);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) -8);
+		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) -8);
 		if (status < 0)
 			break;
 	} while (0);
@@ -5220,7 +5231,7 @@ static int QAMResetQAM(struct drxk_state *state)
 	dprintk(1, "\n");
 	do {
 		/* Stop QAM comstate->m_exec */
-		status = Write16_0(state, QAM_COMM_EXEC__A, QAM_COMM_EXEC_STOP);
+		status = write16(state, QAM_COMM_EXEC__A, QAM_COMM_EXEC_STOP);
 		if (status < 0)
 			break;
 
@@ -5262,7 +5273,7 @@ static int QAMSetSymbolrate(struct drxk_state *state)
 			ratesel = 2;
 		else if (state->param.u.qam.symbol_rate <= 4755000)
 			ratesel = 1;
-		status = Write16_0(state, IQM_FD_RATESEL__A, ratesel);
+		status = write16(state, IQM_FD_RATESEL__A, ratesel);
 		if (status < 0)
 			break;
 
@@ -5277,7 +5288,7 @@ static int QAMSetSymbolrate(struct drxk_state *state)
 		iqmRcRate = (adcFrequency / symbFreq) * (1 << 21) +
 		    (Frac28a((adcFrequency % symbFreq), symbFreq) >> 7) -
 		    (1 << 23);
-		status = Write32(state, IQM_RC_RATE_OFS_LO__A, iqmRcRate, 0);
+		status = write32(state, IQM_RC_RATE_OFS_LO__A, iqmRcRate);
 		if (status < 0)
 			break;
 		state->m_iqmRcRate = iqmRcRate;
@@ -5294,7 +5305,7 @@ static int QAMSetSymbolrate(struct drxk_state *state)
 		     16);
 		if (lcSymbRate > 511)
 			lcSymbRate = 511;
-		status = Write16_0(state, QAM_LC_SYMBOL_FREQ__A, (u16) lcSymbRate);
+		status = write16(state, QAM_LC_SYMBOL_FREQ__A, (u16) lcSymbRate);
 		if (status < 0)
 			break;
 	} while (0);
@@ -5368,10 +5379,10 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 		   resets QAM block
 		   resets SCU variables
 		 */
-		status = Write16_0(state, FEC_DI_COMM_EXEC__A, FEC_DI_COMM_EXEC_STOP);
+		status = write16(state, FEC_DI_COMM_EXEC__A, FEC_DI_COMM_EXEC_STOP);
 		if (status < 0)
 			break;
-		status = Write16_0(state, FEC_RS_COMM_EXEC__A, FEC_RS_COMM_EXEC_STOP);
+		status = write16(state, FEC_RS_COMM_EXEC__A, FEC_RS_COMM_EXEC_STOP);
 		if (status < 0)
 			break;
 		status = QAMResetQAM(state);
@@ -5446,80 +5457,80 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 			break;
 
 		/* Reset default values */
-		status = Write16_0(state, IQM_CF_SCALE_SH__A, IQM_CF_SCALE_SH__PRE);
+		status = write16(state, IQM_CF_SCALE_SH__A, IQM_CF_SCALE_SH__PRE);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_SY_TIMEOUT__A, QAM_SY_TIMEOUT__PRE);
+		status = write16(state, QAM_SY_TIMEOUT__A, QAM_SY_TIMEOUT__PRE);
 		if (status < 0)
 			break;
 
 		/* Reset default LC values */
-		status = Write16_0(state, QAM_LC_RATE_LIMIT__A, 3);
+		status = write16(state, QAM_LC_RATE_LIMIT__A, 3);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_LC_LPF_FACTORP__A, 4);
+		status = write16(state, QAM_LC_LPF_FACTORP__A, 4);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_LC_LPF_FACTORI__A, 4);
+		status = write16(state, QAM_LC_LPF_FACTORI__A, 4);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_LC_MODE__A, 7);
+		status = write16(state, QAM_LC_MODE__A, 7);
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, QAM_LC_QUAL_TAB0__A, 1);
+		status = write16(state, QAM_LC_QUAL_TAB0__A, 1);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_LC_QUAL_TAB1__A, 1);
+		status = write16(state, QAM_LC_QUAL_TAB1__A, 1);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_LC_QUAL_TAB2__A, 1);
+		status = write16(state, QAM_LC_QUAL_TAB2__A, 1);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_LC_QUAL_TAB3__A, 1);
+		status = write16(state, QAM_LC_QUAL_TAB3__A, 1);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_LC_QUAL_TAB4__A, 2);
+		status = write16(state, QAM_LC_QUAL_TAB4__A, 2);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_LC_QUAL_TAB5__A, 2);
+		status = write16(state, QAM_LC_QUAL_TAB5__A, 2);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_LC_QUAL_TAB6__A, 2);
+		status = write16(state, QAM_LC_QUAL_TAB6__A, 2);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_LC_QUAL_TAB8__A, 2);
+		status = write16(state, QAM_LC_QUAL_TAB8__A, 2);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_LC_QUAL_TAB9__A, 2);
+		status = write16(state, QAM_LC_QUAL_TAB9__A, 2);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_LC_QUAL_TAB10__A, 2);
+		status = write16(state, QAM_LC_QUAL_TAB10__A, 2);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_LC_QUAL_TAB12__A, 2);
+		status = write16(state, QAM_LC_QUAL_TAB12__A, 2);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_LC_QUAL_TAB15__A, 3);
+		status = write16(state, QAM_LC_QUAL_TAB15__A, 3);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_LC_QUAL_TAB16__A, 3);
+		status = write16(state, QAM_LC_QUAL_TAB16__A, 3);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_LC_QUAL_TAB20__A, 4);
+		status = write16(state, QAM_LC_QUAL_TAB20__A, 4);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_LC_QUAL_TAB25__A, 4);
+		status = write16(state, QAM_LC_QUAL_TAB25__A, 4);
 		if (status < 0)
 			break;
 
 		/* Mirroring, QAM-block starting point not inverted */
-		status = Write16_0(state, QAM_SY_SP_INV__A, QAM_SY_SP_INV_SPECTRUM_INV_DIS);
+		status = write16(state, QAM_SY_SP_INV__A, QAM_SY_SP_INV_SPECTRUM_INV_DIS);
 		if (status < 0)
 			break;
 
 		/* Halt SCU to enable safe non-atomic accesses */
-		status = Write16_0(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_HOLD);
+		status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_HOLD);
 		if (status < 0)
 			break;
 
@@ -5556,7 +5567,7 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 			break;
 		}		/* switch */
 		/* Activate SCU to enable SCU commands */
-		status = Write16_0(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_ACTIVE);
+		status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_ACTIVE);
 		if (status < 0)
 			break;
 
@@ -5572,13 +5583,13 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 		status = MPEGTSStart(state);
 		if (status < 0)
 			break;
-		status = Write16_0(state, FEC_COMM_EXEC__A, FEC_COMM_EXEC_ACTIVE);
+		status = write16(state, FEC_COMM_EXEC__A, FEC_COMM_EXEC_ACTIVE);
 		if (status < 0)
 			break;
-		status = Write16_0(state, QAM_COMM_EXEC__A, QAM_COMM_EXEC_ACTIVE);
+		status = write16(state, QAM_COMM_EXEC__A, QAM_COMM_EXEC_ACTIVE);
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_COMM_EXEC__A, IQM_COMM_EXEC_B_ACTIVE);
+		status = write16(state, IQM_COMM_EXEC__A, IQM_COMM_EXEC_B_ACTIVE);
 		if (status < 0)
 			break;
 
@@ -5626,10 +5637,10 @@ static int SetQAMStandard(struct drxk_state *state,
 
 		/* Setup IQM */
 
-		status = Write16_0(state, IQM_COMM_EXEC__A, IQM_COMM_EXEC_B_STOP);
+		status = write16(state, IQM_COMM_EXEC__A, IQM_COMM_EXEC_B_STOP);
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_AF_AMUX__A, IQM_AF_AMUX_SIGNAL2ADC);
+		status = write16(state, IQM_AF_AMUX__A, IQM_AF_AMUX_SIGNAL2ADC);
 		if (status < 0)
 			break;
 
@@ -5656,65 +5667,65 @@ static int SetQAMStandard(struct drxk_state *state,
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, IQM_CF_OUT_ENA__A, (1 << IQM_CF_OUT_ENA_QAM__B));
+		status = write16(state, IQM_CF_OUT_ENA__A, (1 << IQM_CF_OUT_ENA_QAM__B));
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_CF_SYMMETRIC__A, 0);
+		status = write16(state, IQM_CF_SYMMETRIC__A, 0);
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_CF_MIDTAP__A, ((1 << IQM_CF_MIDTAP_RE__B) | (1 << IQM_CF_MIDTAP_IM__B)));
+		status = write16(state, IQM_CF_MIDTAP__A, ((1 << IQM_CF_MIDTAP_RE__B) | (1 << IQM_CF_MIDTAP_IM__B)));
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, IQM_RC_STRETCH__A, 21);
+		status = write16(state, IQM_RC_STRETCH__A, 21);
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_AF_CLP_LEN__A, 0);
+		status = write16(state, IQM_AF_CLP_LEN__A, 0);
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_AF_CLP_TH__A, 448);
+		status = write16(state, IQM_AF_CLP_TH__A, 448);
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_AF_SNS_LEN__A, 0);
+		status = write16(state, IQM_AF_SNS_LEN__A, 0);
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_CF_POW_MEAS_LEN__A, 0);
+		status = write16(state, IQM_CF_POW_MEAS_LEN__A, 0);
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, IQM_FS_ADJ_SEL__A, 1);
+		status = write16(state, IQM_FS_ADJ_SEL__A, 1);
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_RC_ADJ_SEL__A, 1);
+		status = write16(state, IQM_RC_ADJ_SEL__A, 1);
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_CF_ADJ_SEL__A, 1);
+		status = write16(state, IQM_CF_ADJ_SEL__A, 1);
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_AF_UPD_SEL__A, 0);
+		status = write16(state, IQM_AF_UPD_SEL__A, 0);
 		if (status < 0)
 			break;
 
 		/* IQM Impulse Noise Processing Unit */
-		status = Write16_0(state, IQM_CF_CLP_VAL__A, 500);
+		status = write16(state, IQM_CF_CLP_VAL__A, 500);
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_CF_DATATH__A, 1000);
+		status = write16(state, IQM_CF_DATATH__A, 1000);
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_CF_BYPASSDET__A, 1);
+		status = write16(state, IQM_CF_BYPASSDET__A, 1);
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_CF_DET_LCT__A, 0);
+		status = write16(state, IQM_CF_DET_LCT__A, 0);
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_CF_WND_LEN__A, 1);
+		status = write16(state, IQM_CF_WND_LEN__A, 1);
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_CF_PKDTH__A, 1);
+		status = write16(state, IQM_CF_PKDTH__A, 1);
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_AF_INC_BYPASS__A, 1);
+		status = write16(state, IQM_AF_INC_BYPASS__A, 1);
 		if (status < 0)
 			break;
 
@@ -5722,7 +5733,7 @@ static int SetQAMStandard(struct drxk_state *state,
 		status = SetIqmAf(state, true);
 		if (status < 0)
 			break;
-		status = Write16_0(state, IQM_AF_START_LOCK__A, 0x01);
+		status = write16(state, IQM_AF_START_LOCK__A, 0x01);
 		if (status < 0)
 			break;
 
@@ -5732,12 +5743,12 @@ static int SetQAMStandard(struct drxk_state *state,
 			break;
 
 		/* Set the FSM step period */
-		status = Write16_0(state, SCU_RAM_QAM_FSM_STEP_PERIOD__A, 2000);
+		status = write16(state, SCU_RAM_QAM_FSM_STEP_PERIOD__A, 2000);
 		if (status < 0)
 			break;
 
 		/* Halt SCU to enable safe non-atomic accesses */
-		status = Write16_0(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_HOLD);
+		status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_HOLD);
 		if (status < 0)
 			break;
 
@@ -5760,7 +5771,7 @@ static int SetQAMStandard(struct drxk_state *state,
 			break;
 
 		/* Activate SCU to enable SCU commands */
-		status = Write16_0(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_ACTIVE);
+		status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_ACTIVE);
 		if (status < 0)
 			break;
 	} while (0);
@@ -5775,23 +5786,23 @@ static int WriteGPIO(struct drxk_state *state)
 	dprintk(1, "\n");
 	do {
 		/* stop lock indicator process */
-		status = Write16_0(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
+		status = write16(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
 		if (status < 0)
 			break;
 
 		/*  Write magic word to enable pdr reg write               */
-		status = Write16_0(state, SIO_TOP_COMM_KEY__A, SIO_TOP_COMM_KEY_KEY);
+		status = write16(state, SIO_TOP_COMM_KEY__A, SIO_TOP_COMM_KEY_KEY);
 		if (status < 0)
 			break;
 
 		if (state->m_hasSAWSW) {
 			/* write to io pad configuration register - output mode */
-			status = Write16_0(state, SIO_PDR_SMA_TX_CFG__A, state->m_GPIOCfg);
+			status = write16(state, SIO_PDR_SMA_TX_CFG__A, state->m_GPIOCfg);
 			if (status < 0)
 				break;
 
 			/* use corresponding bit in io data output registar */
-			status = Read16_0(state, SIO_PDR_UIO_OUT_LO__A, &value);
+			status = read16(state, SIO_PDR_UIO_OUT_LO__A, &value);
 			if (status < 0)
 				break;
 			if (state->m_GPIO == 0)
@@ -5799,13 +5810,13 @@ static int WriteGPIO(struct drxk_state *state)
 			else
 				value |= 0x8000;	/* write one to 15th bit - 1st UIO */
 			/* write back to io data output register */
-			status = Write16_0(state, SIO_PDR_UIO_OUT_LO__A, value);
+			status = write16(state, SIO_PDR_UIO_OUT_LO__A, value);
 			if (status < 0)
 				break;
 
 		}
 		/*  Write magic word to disable pdr reg write               */
-		status = Write16_0(state, SIO_TOP_COMM_KEY__A, 0x0000);
+		status = write16(state, SIO_TOP_COMM_KEY__A, 0x0000);
 		if (status < 0)
 			break;
 	} while (0);
@@ -5864,10 +5875,10 @@ static int PowerDownDevice(struct drxk_state *state)
 		if (status < 0)
 			break;
 
-		status = Write16_0(state, SIO_CC_PWD_MODE__A, SIO_CC_PWD_MODE_LEVEL_CLOCK);
+		status = write16(state, SIO_CC_PWD_MODE__A, SIO_CC_PWD_MODE_LEVEL_CLOCK);
 		if (status < 0)
 			break;
-		status = Write16_0(state, SIO_CC_UPDATE__A, SIO_CC_UPDATE_KEY);
+		status = write16(state, SIO_CC_UPDATE__A, SIO_CC_UPDATE_KEY);
 		if (status < 0)
 			break;
 		state->m_HICfgCtrl |= SIO_HI_RA_RAM_PAR_5_CFG_SLEEP_ZZZ;
@@ -5918,10 +5929,10 @@ static int init_drxk(struct drxk_state *state)
 			if (status < 0)
 				break;
 			/* Soft reset of OFDM-, sys- and osc-clockdomain */
-			status = Write16_0(state, SIO_CC_SOFT_RST__A, SIO_CC_SOFT_RST_OFDM__M | SIO_CC_SOFT_RST_SYS__M | SIO_CC_SOFT_RST_OSC__M);
+			status = write16(state, SIO_CC_SOFT_RST__A, SIO_CC_SOFT_RST_OFDM__M | SIO_CC_SOFT_RST_SYS__M | SIO_CC_SOFT_RST_OSC__M);
 			if (status < 0)
 				break;
-			status = Write16_0(state, SIO_CC_UPDATE__A, SIO_CC_UPDATE_KEY);
+			status = write16(state, SIO_CC_UPDATE__A, SIO_CC_UPDATE_KEY);
 			if (status < 0)
 				break;
 			/* TODO is this needed, if yes how much delay in worst case scenario */
@@ -5957,7 +5968,7 @@ static int init_drxk(struct drxk_state *state)
 			    && !(state->m_DRXK_A2_ROM_CODE))
 #endif
 			{
-				status = Write16_0(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
+				status = write16(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
 				if (status < 0)
 					break;
 			}
@@ -5968,20 +5979,20 @@ static int init_drxk(struct drxk_state *state)
 				break;
 
 			/* Stop AUD and SCU */
-			status = Write16_0(state, AUD_COMM_EXEC__A, AUD_COMM_EXEC_STOP);
+			status = write16(state, AUD_COMM_EXEC__A, AUD_COMM_EXEC_STOP);
 			if (status < 0)
 				break;
-			status = Write16_0(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_STOP);
+			status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_STOP);
 			if (status < 0)
 				break;
 
 			/* enable token-ring bus through OFDM block for possible ucode upload */
-			status = Write16_0(state, SIO_OFDM_SH_OFDM_RING_ENABLE__A, SIO_OFDM_SH_OFDM_RING_ENABLE_ON);
+			status = write16(state, SIO_OFDM_SH_OFDM_RING_ENABLE__A, SIO_OFDM_SH_OFDM_RING_ENABLE_ON);
 			if (status < 0)
 				break;
 
 			/* include boot loader section */
-			status = Write16_0(state, SIO_BL_COMM_EXEC__A, SIO_BL_COMM_EXEC_ACTIVE);
+			status = write16(state, SIO_BL_COMM_EXEC__A, SIO_BL_COMM_EXEC_ACTIVE);
 			if (status < 0)
 				break;
 			status = BLChainCmd(state, 0, 6, 100);
@@ -6003,12 +6014,12 @@ static int init_drxk(struct drxk_state *state)
 					break;
 #endif
 			/* disable token-ring bus through OFDM block for possible ucode upload */
-			status = Write16_0(state, SIO_OFDM_SH_OFDM_RING_ENABLE__A, SIO_OFDM_SH_OFDM_RING_ENABLE_OFF);
+			status = write16(state, SIO_OFDM_SH_OFDM_RING_ENABLE__A, SIO_OFDM_SH_OFDM_RING_ENABLE_OFF);
 			if (status < 0)
 				break;
 
 			/* Run SCU for a little while to initialize microcode version numbers */
-			status = Write16_0(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_ACTIVE);
+			status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_ACTIVE);
 			if (status < 0)
 				break;
 			status = DRXX_Open(state);
@@ -6033,7 +6044,7 @@ static int init_drxk(struct drxk_state *state)
 			    (((DRXK_VERSION_MAJOR / 10) % 10) << 8) +
 			    ((DRXK_VERSION_MAJOR % 10) << 4) +
 			    (DRXK_VERSION_MINOR % 10);
-			status = Write16_0(state, SCU_RAM_DRIVER_VER_HI__A, driverVersion);
+			status = write16(state, SCU_RAM_DRIVER_VER_HI__A, driverVersion);
 			if (status < 0)
 				break;
 			driverVersion =
@@ -6041,7 +6052,7 @@ static int init_drxk(struct drxk_state *state)
 			    (((DRXK_VERSION_PATCH / 100) % 10) << 8) +
 			    (((DRXK_VERSION_PATCH / 10) % 10) << 4) +
 			    (DRXK_VERSION_PATCH % 10);
-			status = Write16_0(state, SCU_RAM_DRIVER_VER_LO__A, driverVersion);
+			status = write16(state, SCU_RAM_DRIVER_VER_LO__A, driverVersion);
 			if (status < 0)
 				break;
 
@@ -6057,13 +6068,13 @@ static int init_drxk(struct drxk_state *state)
 			/* m_dvbtRfAgcCfg.speed = 3; */
 
 			/* Reset driver debug flags to 0 */
-			status = Write16_0(state, SCU_RAM_DRIVER_DEBUG__A, 0);
+			status = write16(state, SCU_RAM_DRIVER_DEBUG__A, 0);
 			if (status < 0)
 				break;
 			/* driver 0.9.0 */
 			/* Setup FEC OC:
 			   NOTE: No more full FEC resets allowed afterwards!! */
-			status = Write16_0(state, FEC_COMM_EXEC__A, FEC_COMM_EXEC_STOP);
+			status = write16(state, FEC_COMM_EXEC__A, FEC_COMM_EXEC_STOP);
 			if (status < 0)
 				break;
 			/* MPEGTS functions are still the same */
-- 
1.7.1


