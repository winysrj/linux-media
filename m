Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656Ab3D1PsT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Apr 2013 11:48:19 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3SFmIrK005824
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 28 Apr 2013 11:48:18 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/9] [media] drxk_hard: Don't use CamelCase
Date: Sun, 28 Apr 2013 12:47:44 -0300
Message-Id: <1367164071-11468-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1367164071-11468-1-git-send-email-mchehab@redhat.com>
References: <1367164071-11468-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thare are lots of CamelCase warnings produced by checkpatch.pl.
This weren't fixed at the time the driver got submitted due
to the lack of manpower do to such cleanup.

Now that I have one script that automates this task, cleans
it. That makes the driver almost checkpatch-compliant,
except for 80 column warnings.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/drxk.h      |    2 +-
 drivers/media/dvb-frontends/drxk_hard.c | 2558 +++++++++++++++----------------
 drivers/media/dvb-frontends/drxk_hard.h |  248 +--
 3 files changed, 1404 insertions(+), 1404 deletions(-)

diff --git a/drivers/media/dvb-frontends/drxk.h b/drivers/media/dvb-frontends/drxk.h
index e666718..f22eb9f 100644
--- a/drivers/media/dvb-frontends/drxk.h
+++ b/drivers/media/dvb-frontends/drxk.h
@@ -8,7 +8,7 @@
 /**
  * struct drxk_config - Configure the initial parameters for DRX-K
  *
- * @adr:		I2C Address of the DRX-K
+ * @adr:		I2C address of the DRX-K
  * @parallel_ts:	True means that the device uses parallel TS,
  * 			Serial otherwise.
  * @dynamic_clk:	True means that the clock will be dynamically
diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index 41b6375..d2b331a 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -36,34 +36,34 @@
 #include "drxk_hard.h"
 #include "dvb_math.h"
 
-static int PowerDownDVBT(struct drxk_state *state, bool setPowerMode);
-static int PowerDownQAM(struct drxk_state *state);
-static int SetDVBTStandard(struct drxk_state *state,
-			   enum OperationMode oMode);
-static int SetQAMStandard(struct drxk_state *state,
-			  enum OperationMode oMode);
-static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
-		  s32 tunerFreqOffset);
-static int SetDVBTStandard(struct drxk_state *state,
-			   enum OperationMode oMode);
-static int DVBTStart(struct drxk_state *state);
-static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
-		   s32 tunerFreqOffset);
-static int GetQAMLockStatus(struct drxk_state *state, u32 *pLockStatus);
-static int GetDVBTLockStatus(struct drxk_state *state, u32 *pLockStatus);
-static int SwitchAntennaToQAM(struct drxk_state *state);
-static int SwitchAntennaToDVBT(struct drxk_state *state);
-
-static bool IsDVBT(struct drxk_state *state)
+static int power_down_dvbt(struct drxk_state *state, bool set_power_mode);
+static int power_down_qam(struct drxk_state *state);
+static int set_dvbt_standard(struct drxk_state *state,
+			   enum operation_mode o_mode);
+static int set_qam_standard(struct drxk_state *state,
+			  enum operation_mode o_mode);
+static int set_qam(struct drxk_state *state, u16 intermediate_freqk_hz,
+		  s32 tuner_freq_offset);
+static int set_dvbt_standard(struct drxk_state *state,
+			   enum operation_mode o_mode);
+static int dvbt_start(struct drxk_state *state);
+static int set_dvbt(struct drxk_state *state, u16 intermediate_freqk_hz,
+		   s32 tuner_freq_offset);
+static int get_qam_lock_status(struct drxk_state *state, u32 *p_lock_status);
+static int get_dvbt_lock_status(struct drxk_state *state, u32 *p_lock_status);
+static int switch_antenna_to_qam(struct drxk_state *state);
+static int switch_antenna_to_dvbt(struct drxk_state *state);
+
+static bool is_dvbt(struct drxk_state *state)
 {
-	return state->m_OperationMode == OM_DVBT;
+	return state->m_operation_mode == OM_DVBT;
 }
 
-static bool IsQAM(struct drxk_state *state)
+static bool is_qam(struct drxk_state *state)
 {
-	return state->m_OperationMode == OM_QAM_ITU_A ||
-	    state->m_OperationMode == OM_QAM_ITU_B ||
-	    state->m_OperationMode == OM_QAM_ITU_C;
+	return state->m_operation_mode == OM_QAM_ITU_A ||
+	    state->m_operation_mode == OM_QAM_ITU_B ||
+	    state->m_operation_mode == OM_QAM_ITU_C;
 }
 
 #define NOA1ROM 0
@@ -432,55 +432,55 @@ static int write32(struct drxk_state *state, u32 reg, u32 data)
 	return write32_flags(state, reg, data, 0);
 }
 
-static int write_block(struct drxk_state *state, u32 Address,
-		      const int BlockSize, const u8 pBlock[])
+static int write_block(struct drxk_state *state, u32 address,
+		      const int block_size, const u8 p_block[])
 {
-	int status = 0, BlkSize = BlockSize;
-	u8 Flags = 0;
+	int status = 0, blk_size = block_size;
+	u8 flags = 0;
 
 	if (state->single_master)
-		Flags |= 0xC0;
-
-	while (BlkSize > 0) {
-		int Chunk = BlkSize > state->m_ChunkSize ?
-		    state->m_ChunkSize : BlkSize;
-		u8 *AdrBuf = &state->Chunk[0];
-		u32 AdrLength = 0;
-
-		if (DRXDAP_FASI_LONG_FORMAT(Address) || (Flags != 0)) {
-			AdrBuf[0] = (((Address << 1) & 0xFF) | 0x01);
-			AdrBuf[1] = ((Address >> 16) & 0xFF);
-			AdrBuf[2] = ((Address >> 24) & 0xFF);
-			AdrBuf[3] = ((Address >> 7) & 0xFF);
-			AdrBuf[2] |= Flags;
-			AdrLength = 4;
-			if (Chunk == state->m_ChunkSize)
-				Chunk -= 2;
+		flags |= 0xC0;
+
+	while (blk_size > 0) {
+		int chunk = blk_size > state->m_chunk_size ?
+		    state->m_chunk_size : blk_size;
+		u8 *adr_buf = &state->chunk[0];
+		u32 adr_length = 0;
+
+		if (DRXDAP_FASI_LONG_FORMAT(address) || (flags != 0)) {
+			adr_buf[0] = (((address << 1) & 0xFF) | 0x01);
+			adr_buf[1] = ((address >> 16) & 0xFF);
+			adr_buf[2] = ((address >> 24) & 0xFF);
+			adr_buf[3] = ((address >> 7) & 0xFF);
+			adr_buf[2] |= flags;
+			adr_length = 4;
+			if (chunk == state->m_chunk_size)
+				chunk -= 2;
 		} else {
-			AdrBuf[0] = ((Address << 1) & 0xFF);
-			AdrBuf[1] = (((Address >> 16) & 0x0F) |
-				     ((Address >> 18) & 0xF0));
-			AdrLength = 2;
+			adr_buf[0] = ((address << 1) & 0xFF);
+			adr_buf[1] = (((address >> 16) & 0x0F) |
+				     ((address >> 18) & 0xF0));
+			adr_length = 2;
 		}
-		memcpy(&state->Chunk[AdrLength], pBlock, Chunk);
-		dprintk(2, "(0x%08x, 0x%02x)\n", Address, Flags);
+		memcpy(&state->chunk[adr_length], p_block, chunk);
+		dprintk(2, "(0x%08x, 0x%02x)\n", address, flags);
 		if (debug > 1) {
 			int i;
-			if (pBlock)
-				for (i = 0; i < Chunk; i++)
-					printk(KERN_CONT " %02x", pBlock[i]);
+			if (p_block)
+				for (i = 0; i < chunk; i++)
+					printk(KERN_CONT " %02x", p_block[i]);
 			printk(KERN_CONT "\n");
 		}
 		status = i2c_write(state, state->demod_address,
-				   &state->Chunk[0], Chunk + AdrLength);
+				   &state->chunk[0], chunk + adr_length);
 		if (status < 0) {
 			printk(KERN_ERR "drxk: %s: i2c write error at addr 0x%02x\n",
-			       __func__, Address);
+			       __func__, address);
 			break;
 		}
-		pBlock += Chunk;
-		Address += (Chunk >> 1);
-		BlkSize -= Chunk;
+		p_block += chunk;
+		address += (chunk >> 1);
+		blk_size -= chunk;
 	}
 	return status;
 }
@@ -489,11 +489,11 @@ static int write_block(struct drxk_state *state, u32 Address,
 #define DRXK_MAX_RETRIES_POWERUP 20
 #endif
 
-static int PowerUpDevice(struct drxk_state *state)
+static int power_up_device(struct drxk_state *state)
 {
 	int status;
 	u8 data = 0;
-	u16 retryCount = 0;
+	u16 retry_count = 0;
 
 	dprintk(1, "\n");
 
@@ -504,14 +504,14 @@ static int PowerUpDevice(struct drxk_state *state)
 			status = i2c_write(state, state->demod_address,
 					   &data, 1);
 			msleep(10);
-			retryCount++;
+			retry_count++;
 			if (status < 0)
 				continue;
 			status = i2c_read1(state, state->demod_address,
 					   &data);
 		} while (status < 0 &&
-			 (retryCount < DRXK_MAX_RETRIES_POWERUP));
-		if (status < 0 && retryCount >= DRXK_MAX_RETRIES_POWERUP)
+			 (retry_count < DRXK_MAX_RETRIES_POWERUP));
+		if (status < 0 && retry_count >= DRXK_MAX_RETRIES_POWERUP)
 			goto error;
 	}
 
@@ -527,7 +527,7 @@ static int PowerUpDevice(struct drxk_state *state)
 	if (status < 0)
 		goto error;
 
-	state->m_currentPowerMode = DRX_POWER_UP;
+	state->m_current_power_mode = DRX_POWER_UP;
 
 error:
 	if (status < 0)
@@ -543,106 +543,106 @@ static int init_state(struct drxk_state *state)
 	 * FIXME: most (all?) of the values bellow should be moved into
 	 * struct drxk_config, as they are probably board-specific
 	 */
-	u32 ulVSBIfAgcMode = DRXK_AGC_CTRL_AUTO;
-	u32 ulVSBIfAgcOutputLevel = 0;
-	u32 ulVSBIfAgcMinLevel = 0;
-	u32 ulVSBIfAgcMaxLevel = 0x7FFF;
-	u32 ulVSBIfAgcSpeed = 3;
-
-	u32 ulVSBRfAgcMode = DRXK_AGC_CTRL_AUTO;
-	u32 ulVSBRfAgcOutputLevel = 0;
-	u32 ulVSBRfAgcMinLevel = 0;
-	u32 ulVSBRfAgcMaxLevel = 0x7FFF;
-	u32 ulVSBRfAgcSpeed = 3;
-	u32 ulVSBRfAgcTop = 9500;
-	u32 ulVSBRfAgcCutOffCurrent = 4000;
-
-	u32 ulATVIfAgcMode = DRXK_AGC_CTRL_AUTO;
-	u32 ulATVIfAgcOutputLevel = 0;
-	u32 ulATVIfAgcMinLevel = 0;
-	u32 ulATVIfAgcMaxLevel = 0;
-	u32 ulATVIfAgcSpeed = 3;
-
-	u32 ulATVRfAgcMode = DRXK_AGC_CTRL_OFF;
-	u32 ulATVRfAgcOutputLevel = 0;
-	u32 ulATVRfAgcMinLevel = 0;
-	u32 ulATVRfAgcMaxLevel = 0;
-	u32 ulATVRfAgcTop = 9500;
-	u32 ulATVRfAgcCutOffCurrent = 4000;
-	u32 ulATVRfAgcSpeed = 3;
+	u32 ul_vsb_if_agc_mode = DRXK_AGC_CTRL_AUTO;
+	u32 ul_vsb_if_agc_output_level = 0;
+	u32 ul_vsb_if_agc_min_level = 0;
+	u32 ul_vsb_if_agc_max_level = 0x7FFF;
+	u32 ul_vsb_if_agc_speed = 3;
+
+	u32 ul_vsb_rf_agc_mode = DRXK_AGC_CTRL_AUTO;
+	u32 ul_vsb_rf_agc_output_level = 0;
+	u32 ul_vsb_rf_agc_min_level = 0;
+	u32 ul_vsb_rf_agc_max_level = 0x7FFF;
+	u32 ul_vsb_rf_agc_speed = 3;
+	u32 ul_vsb_rf_agc_top = 9500;
+	u32 ul_vsb_rf_agc_cut_off_current = 4000;
+
+	u32 ul_atv_if_agc_mode = DRXK_AGC_CTRL_AUTO;
+	u32 ul_atv_if_agc_output_level = 0;
+	u32 ul_atv_if_agc_min_level = 0;
+	u32 ul_atv_if_agc_max_level = 0;
+	u32 ul_atv_if_agc_speed = 3;
+
+	u32 ul_atv_rf_agc_mode = DRXK_AGC_CTRL_OFF;
+	u32 ul_atv_rf_agc_output_level = 0;
+	u32 ul_atv_rf_agc_min_level = 0;
+	u32 ul_atv_rf_agc_max_level = 0;
+	u32 ul_atv_rf_agc_top = 9500;
+	u32 ul_atv_rf_agc_cut_off_current = 4000;
+	u32 ul_atv_rf_agc_speed = 3;
 
 	u32 ulQual83 = DEFAULT_MER_83;
 	u32 ulQual93 = DEFAULT_MER_93;
 
-	u32 ulMpegLockTimeOut = DEFAULT_DRXK_MPEG_LOCK_TIMEOUT;
-	u32 ulDemodLockTimeOut = DEFAULT_DRXK_DEMOD_LOCK_TIMEOUT;
+	u32 ul_mpeg_lock_time_out = DEFAULT_DRXK_MPEG_LOCK_TIMEOUT;
+	u32 ul_demod_lock_time_out = DEFAULT_DRXK_DEMOD_LOCK_TIMEOUT;
 
 	/* io_pad_cfg register (8 bit reg.) MSB bit is 1 (default value) */
 	/* io_pad_cfg_mode output mode is drive always */
 	/* io_pad_cfg_drive is set to power 2 (23 mA) */
-	u32 ulGPIOCfg = 0x0113;
-	u32 ulInvertTSClock = 0;
-	u32 ulTSDataStrength = DRXK_MPEG_SERIAL_OUTPUT_PIN_DRIVE_STRENGTH;
-	u32 ulDVBTBitrate = 50000000;
-	u32 ulDVBCBitrate = DRXK_QAM_SYMBOLRATE_MAX * 8;
+	u32 ul_gpio_cfg = 0x0113;
+	u32 ul_invert_ts_clock = 0;
+	u32 ul_ts_data_strength = DRXK_MPEG_SERIAL_OUTPUT_PIN_DRIVE_STRENGTH;
+	u32 ul_dvbt_bitrate = 50000000;
+	u32 ul_dvbc_bitrate = DRXK_QAM_SYMBOLRATE_MAX * 8;
 
-	u32 ulInsertRSByte = 0;
+	u32 ul_insert_rs_byte = 0;
 
-	u32 ulRfMirror = 1;
-	u32 ulPowerDown = 0;
+	u32 ul_rf_mirror = 1;
+	u32 ul_power_down = 0;
 
 	dprintk(1, "\n");
 
-	state->m_hasLNA = false;
-	state->m_hasDVBT = false;
-	state->m_hasDVBC = false;
-	state->m_hasATV = false;
-	state->m_hasOOB = false;
-	state->m_hasAudio = false;
+	state->m_has_lna = false;
+	state->m_has_dvbt = false;
+	state->m_has_dvbc = false;
+	state->m_has_atv = false;
+	state->m_has_oob = false;
+	state->m_has_audio = false;
 
-	if (!state->m_ChunkSize)
-		state->m_ChunkSize = 124;
+	if (!state->m_chunk_size)
+		state->m_chunk_size = 124;
 
-	state->m_oscClockFreq = 0;
-	state->m_smartAntInverted = false;
-	state->m_bPDownOpenBridge = false;
+	state->m_osc_clock_freq = 0;
+	state->m_smart_ant_inverted = false;
+	state->m_b_p_down_open_bridge = false;
 
 	/* real system clock frequency in kHz */
-	state->m_sysClockFreq = 151875;
+	state->m_sys_clock_freq = 151875;
 	/* Timing div, 250ns/Psys */
 	/* Timing div, = (delay (nano seconds) * sysclk (kHz))/ 1000 */
-	state->m_HICfgTimingDiv = ((state->m_sysClockFreq / 1000) *
+	state->m_hi_cfg_timing_div = ((state->m_sys_clock_freq / 1000) *
 				   HI_I2C_DELAY) / 1000;
 	/* Clipping */
-	if (state->m_HICfgTimingDiv > SIO_HI_RA_RAM_PAR_2_CFG_DIV__M)
-		state->m_HICfgTimingDiv = SIO_HI_RA_RAM_PAR_2_CFG_DIV__M;
-	state->m_HICfgWakeUpKey = (state->demod_address << 1);
+	if (state->m_hi_cfg_timing_div > SIO_HI_RA_RAM_PAR_2_CFG_DIV__M)
+		state->m_hi_cfg_timing_div = SIO_HI_RA_RAM_PAR_2_CFG_DIV__M;
+	state->m_hi_cfg_wake_up_key = (state->demod_address << 1);
 	/* port/bridge/power down ctrl */
-	state->m_HICfgCtrl = SIO_HI_RA_RAM_PAR_5_CFG_SLV0_SLAVE;
+	state->m_hi_cfg_ctrl = SIO_HI_RA_RAM_PAR_5_CFG_SLV0_SLAVE;
 
-	state->m_bPowerDown = (ulPowerDown != 0);
+	state->m_b_power_down = (ul_power_down != 0);
 
-	state->m_DRXK_A3_PATCH_CODE = false;
+	state->m_drxk_a3_patch_code = false;
 
 	/* Init AGC and PGA parameters */
 	/* VSB IF */
-	state->m_vsbIfAgcCfg.ctrlMode = (ulVSBIfAgcMode);
-	state->m_vsbIfAgcCfg.outputLevel = (ulVSBIfAgcOutputLevel);
-	state->m_vsbIfAgcCfg.minOutputLevel = (ulVSBIfAgcMinLevel);
-	state->m_vsbIfAgcCfg.maxOutputLevel = (ulVSBIfAgcMaxLevel);
-	state->m_vsbIfAgcCfg.speed = (ulVSBIfAgcSpeed);
-	state->m_vsbPgaCfg = 140;
+	state->m_vsb_if_agc_cfg.ctrl_mode = (ul_vsb_if_agc_mode);
+	state->m_vsb_if_agc_cfg.output_level = (ul_vsb_if_agc_output_level);
+	state->m_vsb_if_agc_cfg.min_output_level = (ul_vsb_if_agc_min_level);
+	state->m_vsb_if_agc_cfg.max_output_level = (ul_vsb_if_agc_max_level);
+	state->m_vsb_if_agc_cfg.speed = (ul_vsb_if_agc_speed);
+	state->m_vsb_pga_cfg = 140;
 
 	/* VSB RF */
-	state->m_vsbRfAgcCfg.ctrlMode = (ulVSBRfAgcMode);
-	state->m_vsbRfAgcCfg.outputLevel = (ulVSBRfAgcOutputLevel);
-	state->m_vsbRfAgcCfg.minOutputLevel = (ulVSBRfAgcMinLevel);
-	state->m_vsbRfAgcCfg.maxOutputLevel = (ulVSBRfAgcMaxLevel);
-	state->m_vsbRfAgcCfg.speed = (ulVSBRfAgcSpeed);
-	state->m_vsbRfAgcCfg.top = (ulVSBRfAgcTop);
-	state->m_vsbRfAgcCfg.cutOffCurrent = (ulVSBRfAgcCutOffCurrent);
-	state->m_vsbPreSawCfg.reference = 0x07;
-	state->m_vsbPreSawCfg.usePreSaw = true;
+	state->m_vsb_rf_agc_cfg.ctrl_mode = (ul_vsb_rf_agc_mode);
+	state->m_vsb_rf_agc_cfg.output_level = (ul_vsb_rf_agc_output_level);
+	state->m_vsb_rf_agc_cfg.min_output_level = (ul_vsb_rf_agc_min_level);
+	state->m_vsb_rf_agc_cfg.max_output_level = (ul_vsb_rf_agc_max_level);
+	state->m_vsb_rf_agc_cfg.speed = (ul_vsb_rf_agc_speed);
+	state->m_vsb_rf_agc_cfg.top = (ul_vsb_rf_agc_top);
+	state->m_vsb_rf_agc_cfg.cut_off_current = (ul_vsb_rf_agc_cut_off_current);
+	state->m_vsb_pre_saw_cfg.reference = 0x07;
+	state->m_vsb_pre_saw_cfg.use_pre_saw = true;
 
 	state->m_Quality83percent = DEFAULT_MER_83;
 	state->m_Quality93percent = DEFAULT_MER_93;
@@ -652,127 +652,127 @@ static int init_state(struct drxk_state *state)
 	}
 
 	/* ATV IF */
-	state->m_atvIfAgcCfg.ctrlMode = (ulATVIfAgcMode);
-	state->m_atvIfAgcCfg.outputLevel = (ulATVIfAgcOutputLevel);
-	state->m_atvIfAgcCfg.minOutputLevel = (ulATVIfAgcMinLevel);
-	state->m_atvIfAgcCfg.maxOutputLevel = (ulATVIfAgcMaxLevel);
-	state->m_atvIfAgcCfg.speed = (ulATVIfAgcSpeed);
+	state->m_atv_if_agc_cfg.ctrl_mode = (ul_atv_if_agc_mode);
+	state->m_atv_if_agc_cfg.output_level = (ul_atv_if_agc_output_level);
+	state->m_atv_if_agc_cfg.min_output_level = (ul_atv_if_agc_min_level);
+	state->m_atv_if_agc_cfg.max_output_level = (ul_atv_if_agc_max_level);
+	state->m_atv_if_agc_cfg.speed = (ul_atv_if_agc_speed);
 
 	/* ATV RF */
-	state->m_atvRfAgcCfg.ctrlMode = (ulATVRfAgcMode);
-	state->m_atvRfAgcCfg.outputLevel = (ulATVRfAgcOutputLevel);
-	state->m_atvRfAgcCfg.minOutputLevel = (ulATVRfAgcMinLevel);
-	state->m_atvRfAgcCfg.maxOutputLevel = (ulATVRfAgcMaxLevel);
-	state->m_atvRfAgcCfg.speed = (ulATVRfAgcSpeed);
-	state->m_atvRfAgcCfg.top = (ulATVRfAgcTop);
-	state->m_atvRfAgcCfg.cutOffCurrent = (ulATVRfAgcCutOffCurrent);
-	state->m_atvPreSawCfg.reference = 0x04;
-	state->m_atvPreSawCfg.usePreSaw = true;
+	state->m_atv_rf_agc_cfg.ctrl_mode = (ul_atv_rf_agc_mode);
+	state->m_atv_rf_agc_cfg.output_level = (ul_atv_rf_agc_output_level);
+	state->m_atv_rf_agc_cfg.min_output_level = (ul_atv_rf_agc_min_level);
+	state->m_atv_rf_agc_cfg.max_output_level = (ul_atv_rf_agc_max_level);
+	state->m_atv_rf_agc_cfg.speed = (ul_atv_rf_agc_speed);
+	state->m_atv_rf_agc_cfg.top = (ul_atv_rf_agc_top);
+	state->m_atv_rf_agc_cfg.cut_off_current = (ul_atv_rf_agc_cut_off_current);
+	state->m_atv_pre_saw_cfg.reference = 0x04;
+	state->m_atv_pre_saw_cfg.use_pre_saw = true;
 
 
 	/* DVBT RF */
-	state->m_dvbtRfAgcCfg.ctrlMode = DRXK_AGC_CTRL_OFF;
-	state->m_dvbtRfAgcCfg.outputLevel = 0;
-	state->m_dvbtRfAgcCfg.minOutputLevel = 0;
-	state->m_dvbtRfAgcCfg.maxOutputLevel = 0xFFFF;
-	state->m_dvbtRfAgcCfg.top = 0x2100;
-	state->m_dvbtRfAgcCfg.cutOffCurrent = 4000;
-	state->m_dvbtRfAgcCfg.speed = 1;
+	state->m_dvbt_rf_agc_cfg.ctrl_mode = DRXK_AGC_CTRL_OFF;
+	state->m_dvbt_rf_agc_cfg.output_level = 0;
+	state->m_dvbt_rf_agc_cfg.min_output_level = 0;
+	state->m_dvbt_rf_agc_cfg.max_output_level = 0xFFFF;
+	state->m_dvbt_rf_agc_cfg.top = 0x2100;
+	state->m_dvbt_rf_agc_cfg.cut_off_current = 4000;
+	state->m_dvbt_rf_agc_cfg.speed = 1;
 
 
 	/* DVBT IF */
-	state->m_dvbtIfAgcCfg.ctrlMode = DRXK_AGC_CTRL_AUTO;
-	state->m_dvbtIfAgcCfg.outputLevel = 0;
-	state->m_dvbtIfAgcCfg.minOutputLevel = 0;
-	state->m_dvbtIfAgcCfg.maxOutputLevel = 9000;
-	state->m_dvbtIfAgcCfg.top = 13424;
-	state->m_dvbtIfAgcCfg.cutOffCurrent = 0;
-	state->m_dvbtIfAgcCfg.speed = 3;
-	state->m_dvbtIfAgcCfg.FastClipCtrlDelay = 30;
-	state->m_dvbtIfAgcCfg.IngainTgtMax = 30000;
+	state->m_dvbt_if_agc_cfg.ctrl_mode = DRXK_AGC_CTRL_AUTO;
+	state->m_dvbt_if_agc_cfg.output_level = 0;
+	state->m_dvbt_if_agc_cfg.min_output_level = 0;
+	state->m_dvbt_if_agc_cfg.max_output_level = 9000;
+	state->m_dvbt_if_agc_cfg.top = 13424;
+	state->m_dvbt_if_agc_cfg.cut_off_current = 0;
+	state->m_dvbt_if_agc_cfg.speed = 3;
+	state->m_dvbt_if_agc_cfg.fast_clip_ctrl_delay = 30;
+	state->m_dvbt_if_agc_cfg.ingain_tgt_max = 30000;
 	/* state->m_dvbtPgaCfg = 140; */
 
-	state->m_dvbtPreSawCfg.reference = 4;
-	state->m_dvbtPreSawCfg.usePreSaw = false;
+	state->m_dvbt_pre_saw_cfg.reference = 4;
+	state->m_dvbt_pre_saw_cfg.use_pre_saw = false;
 
 	/* QAM RF */
-	state->m_qamRfAgcCfg.ctrlMode = DRXK_AGC_CTRL_OFF;
-	state->m_qamRfAgcCfg.outputLevel = 0;
-	state->m_qamRfAgcCfg.minOutputLevel = 6023;
-	state->m_qamRfAgcCfg.maxOutputLevel = 27000;
-	state->m_qamRfAgcCfg.top = 0x2380;
-	state->m_qamRfAgcCfg.cutOffCurrent = 4000;
-	state->m_qamRfAgcCfg.speed = 3;
+	state->m_qam_rf_agc_cfg.ctrl_mode = DRXK_AGC_CTRL_OFF;
+	state->m_qam_rf_agc_cfg.output_level = 0;
+	state->m_qam_rf_agc_cfg.min_output_level = 6023;
+	state->m_qam_rf_agc_cfg.max_output_level = 27000;
+	state->m_qam_rf_agc_cfg.top = 0x2380;
+	state->m_qam_rf_agc_cfg.cut_off_current = 4000;
+	state->m_qam_rf_agc_cfg.speed = 3;
 
 	/* QAM IF */
-	state->m_qamIfAgcCfg.ctrlMode = DRXK_AGC_CTRL_AUTO;
-	state->m_qamIfAgcCfg.outputLevel = 0;
-	state->m_qamIfAgcCfg.minOutputLevel = 0;
-	state->m_qamIfAgcCfg.maxOutputLevel = 9000;
-	state->m_qamIfAgcCfg.top = 0x0511;
-	state->m_qamIfAgcCfg.cutOffCurrent = 0;
-	state->m_qamIfAgcCfg.speed = 3;
-	state->m_qamIfAgcCfg.IngainTgtMax = 5119;
-	state->m_qamIfAgcCfg.FastClipCtrlDelay = 50;
-
-	state->m_qamPgaCfg = 140;
-	state->m_qamPreSawCfg.reference = 4;
-	state->m_qamPreSawCfg.usePreSaw = false;
-
-	state->m_OperationMode = OM_NONE;
-	state->m_DrxkState = DRXK_UNINITIALIZED;
+	state->m_qam_if_agc_cfg.ctrl_mode = DRXK_AGC_CTRL_AUTO;
+	state->m_qam_if_agc_cfg.output_level = 0;
+	state->m_qam_if_agc_cfg.min_output_level = 0;
+	state->m_qam_if_agc_cfg.max_output_level = 9000;
+	state->m_qam_if_agc_cfg.top = 0x0511;
+	state->m_qam_if_agc_cfg.cut_off_current = 0;
+	state->m_qam_if_agc_cfg.speed = 3;
+	state->m_qam_if_agc_cfg.ingain_tgt_max = 5119;
+	state->m_qam_if_agc_cfg.fast_clip_ctrl_delay = 50;
+
+	state->m_qam_pga_cfg = 140;
+	state->m_qam_pre_saw_cfg.reference = 4;
+	state->m_qam_pre_saw_cfg.use_pre_saw = false;
+
+	state->m_operation_mode = OM_NONE;
+	state->m_drxk_state = DRXK_UNINITIALIZED;
 
 	/* MPEG output configuration */
-	state->m_enableMPEGOutput = true;	/* If TRUE; enable MPEG ouput */
-	state->m_insertRSByte = false;	/* If TRUE; insert RS byte */
-	state->m_invertDATA = false;	/* If TRUE; invert DATA signals */
-	state->m_invertERR = false;	/* If TRUE; invert ERR signal */
-	state->m_invertSTR = false;	/* If TRUE; invert STR signals */
-	state->m_invertVAL = false;	/* If TRUE; invert VAL signals */
-	state->m_invertCLK = (ulInvertTSClock != 0);	/* If TRUE; invert CLK signals */
+	state->m_enable_mpeg_output = true;	/* If TRUE; enable MPEG ouput */
+	state->m_insert_rs_byte = false;	/* If TRUE; insert RS byte */
+	state->m_invert_data = false;	/* If TRUE; invert DATA signals */
+	state->m_invert_err = false;	/* If TRUE; invert ERR signal */
+	state->m_invert_str = false;	/* If TRUE; invert STR signals */
+	state->m_invert_val = false;	/* If TRUE; invert VAL signals */
+	state->m_invert_clk = (ul_invert_ts_clock != 0);	/* If TRUE; invert CLK signals */
 
 	/* If TRUE; static MPEG clockrate will be used;
 	   otherwise clockrate will adapt to the bitrate of the TS */
 
-	state->m_DVBTBitrate = ulDVBTBitrate;
-	state->m_DVBCBitrate = ulDVBCBitrate;
+	state->m_dvbt_bitrate = ul_dvbt_bitrate;
+	state->m_dvbc_bitrate = ul_dvbc_bitrate;
 
-	state->m_TSDataStrength = (ulTSDataStrength & 0x07);
+	state->m_ts_data_strength = (ul_ts_data_strength & 0x07);
 
 	/* Maximum bitrate in b/s in case static clockrate is selected */
-	state->m_mpegTsStaticBitrate = 19392658;
-	state->m_disableTEIhandling = false;
+	state->m_mpeg_ts_static_bitrate = 19392658;
+	state->m_disable_te_ihandling = false;
 
-	if (ulInsertRSByte)
-		state->m_insertRSByte = true;
+	if (ul_insert_rs_byte)
+		state->m_insert_rs_byte = true;
 
-	state->m_MpegLockTimeOut = DEFAULT_DRXK_MPEG_LOCK_TIMEOUT;
-	if (ulMpegLockTimeOut < 10000)
-		state->m_MpegLockTimeOut = ulMpegLockTimeOut;
-	state->m_DemodLockTimeOut = DEFAULT_DRXK_DEMOD_LOCK_TIMEOUT;
-	if (ulDemodLockTimeOut < 10000)
-		state->m_DemodLockTimeOut = ulDemodLockTimeOut;
+	state->m_mpeg_lock_time_out = DEFAULT_DRXK_MPEG_LOCK_TIMEOUT;
+	if (ul_mpeg_lock_time_out < 10000)
+		state->m_mpeg_lock_time_out = ul_mpeg_lock_time_out;
+	state->m_demod_lock_time_out = DEFAULT_DRXK_DEMOD_LOCK_TIMEOUT;
+	if (ul_demod_lock_time_out < 10000)
+		state->m_demod_lock_time_out = ul_demod_lock_time_out;
 
 	/* QAM defaults */
-	state->m_Constellation = DRX_CONSTELLATION_AUTO;
-	state->m_qamInterleaveMode = DRXK_QAM_I12_J17;
-	state->m_fecRsPlen = 204 * 8;	/* fecRsPlen  annex A */
-	state->m_fecRsPrescale = 1;
+	state->m_constellation = DRX_CONSTELLATION_AUTO;
+	state->m_qam_interleave_mode = DRXK_QAM_I12_J17;
+	state->m_fec_rs_plen = 204 * 8;	/* fecRsPlen  annex A */
+	state->m_fec_rs_prescale = 1;
 
-	state->m_sqiSpeed = DRXK_DVBT_SQI_SPEED_MEDIUM;
-	state->m_agcFastClipCtrlDelay = 0;
+	state->m_sqi_speed = DRXK_DVBT_SQI_SPEED_MEDIUM;
+	state->m_agcfast_clip_ctrl_delay = 0;
 
-	state->m_GPIOCfg = (ulGPIOCfg);
+	state->m_gpio_cfg = (ul_gpio_cfg);
 
-	state->m_bPowerDown = false;
-	state->m_currentPowerMode = DRX_POWER_DOWN;
+	state->m_b_power_down = false;
+	state->m_current_power_mode = DRX_POWER_DOWN;
 
-	state->m_rfmirror = (ulRfMirror == 0);
-	state->m_IfAgcPol = false;
+	state->m_rfmirror = (ul_rf_mirror == 0);
+	state->m_if_agc_pol = false;
 	return 0;
 }
 
-static int DRXX_Open(struct drxk_state *state)
+static int drxx_open(struct drxk_state *state)
 {
 	int status = 0;
 	u32 jtag = 0;
@@ -804,10 +804,10 @@ error:
 	return status;
 }
 
-static int GetDeviceCapabilities(struct drxk_state *state)
+static int get_device_capabilities(struct drxk_state *state)
 {
-	u16 sioPdrOhwCfg = 0;
-	u32 sioTopJtagidLo = 0;
+	u16 sio_pdr_ohw_cfg = 0;
+	u32 sio_top_jtagid_lo = 0;
 	int status;
 	const char *spin = "";
 
@@ -821,28 +821,28 @@ static int GetDeviceCapabilities(struct drxk_state *state)
 	status = write16(state, SIO_TOP_COMM_KEY__A, SIO_TOP_COMM_KEY_KEY);
 	if (status < 0)
 		goto error;
-	status = read16(state, SIO_PDR_OHW_CFG__A, &sioPdrOhwCfg);
+	status = read16(state, SIO_PDR_OHW_CFG__A, &sio_pdr_ohw_cfg);
 	if (status < 0)
 		goto error;
 	status = write16(state, SIO_TOP_COMM_KEY__A, 0x0000);
 	if (status < 0)
 		goto error;
 
-	switch ((sioPdrOhwCfg & SIO_PDR_OHW_CFG_FREF_SEL__M)) {
+	switch ((sio_pdr_ohw_cfg & SIO_PDR_OHW_CFG_FREF_SEL__M)) {
 	case 0:
 		/* ignore (bypass ?) */
 		break;
 	case 1:
 		/* 27 MHz */
-		state->m_oscClockFreq = 27000;
+		state->m_osc_clock_freq = 27000;
 		break;
 	case 2:
 		/* 20.25 MHz */
-		state->m_oscClockFreq = 20250;
+		state->m_osc_clock_freq = 20250;
 		break;
 	case 3:
 		/* 4 MHz */
-		state->m_oscClockFreq = 20250;
+		state->m_osc_clock_freq = 20250;
 		break;
 	default:
 		printk(KERN_ERR "drxk: Clock Frequency is unknown\n");
@@ -852,150 +852,150 @@ static int GetDeviceCapabilities(struct drxk_state *state)
 		Determine device capabilities
 		Based on pinning v14
 		*/
-	status = read32(state, SIO_TOP_JTAGID_LO__A, &sioTopJtagidLo);
+	status = read32(state, SIO_TOP_JTAGID_LO__A, &sio_top_jtagid_lo);
 	if (status < 0)
 		goto error;
 
-	printk(KERN_INFO "drxk: status = 0x%08x\n", sioTopJtagidLo);
+	printk(KERN_INFO "drxk: status = 0x%08x\n", sio_top_jtagid_lo);
 
 	/* driver 0.9.0 */
-	switch ((sioTopJtagidLo >> 29) & 0xF) {
+	switch ((sio_top_jtagid_lo >> 29) & 0xF) {
 	case 0:
-		state->m_deviceSpin = DRXK_SPIN_A1;
+		state->m_device_spin = DRXK_SPIN_A1;
 		spin = "A1";
 		break;
 	case 2:
-		state->m_deviceSpin = DRXK_SPIN_A2;
+		state->m_device_spin = DRXK_SPIN_A2;
 		spin = "A2";
 		break;
 	case 3:
-		state->m_deviceSpin = DRXK_SPIN_A3;
+		state->m_device_spin = DRXK_SPIN_A3;
 		spin = "A3";
 		break;
 	default:
-		state->m_deviceSpin = DRXK_SPIN_UNKNOWN;
+		state->m_device_spin = DRXK_SPIN_UNKNOWN;
 		status = -EINVAL;
 		printk(KERN_ERR "drxk: Spin %d unknown\n",
-		       (sioTopJtagidLo >> 29) & 0xF);
+		       (sio_top_jtagid_lo >> 29) & 0xF);
 		goto error2;
 	}
-	switch ((sioTopJtagidLo >> 12) & 0xFF) {
+	switch ((sio_top_jtagid_lo >> 12) & 0xFF) {
 	case 0x13:
 		/* typeId = DRX3913K_TYPE_ID */
-		state->m_hasLNA = false;
-		state->m_hasOOB = false;
-		state->m_hasATV = false;
-		state->m_hasAudio = false;
-		state->m_hasDVBT = true;
-		state->m_hasDVBC = true;
-		state->m_hasSAWSW = true;
-		state->m_hasGPIO2 = false;
-		state->m_hasGPIO1 = false;
-		state->m_hasIRQN = false;
+		state->m_has_lna = false;
+		state->m_has_oob = false;
+		state->m_has_atv = false;
+		state->m_has_audio = false;
+		state->m_has_dvbt = true;
+		state->m_has_dvbc = true;
+		state->m_has_sawsw = true;
+		state->m_has_gpio2 = false;
+		state->m_has_gpio1 = false;
+		state->m_has_irqn = false;
 		break;
 	case 0x15:
 		/* typeId = DRX3915K_TYPE_ID */
-		state->m_hasLNA = false;
-		state->m_hasOOB = false;
-		state->m_hasATV = true;
-		state->m_hasAudio = false;
-		state->m_hasDVBT = true;
-		state->m_hasDVBC = false;
-		state->m_hasSAWSW = true;
-		state->m_hasGPIO2 = true;
-		state->m_hasGPIO1 = true;
-		state->m_hasIRQN = false;
+		state->m_has_lna = false;
+		state->m_has_oob = false;
+		state->m_has_atv = true;
+		state->m_has_audio = false;
+		state->m_has_dvbt = true;
+		state->m_has_dvbc = false;
+		state->m_has_sawsw = true;
+		state->m_has_gpio2 = true;
+		state->m_has_gpio1 = true;
+		state->m_has_irqn = false;
 		break;
 	case 0x16:
 		/* typeId = DRX3916K_TYPE_ID */
-		state->m_hasLNA = false;
-		state->m_hasOOB = false;
-		state->m_hasATV = true;
-		state->m_hasAudio = false;
-		state->m_hasDVBT = true;
-		state->m_hasDVBC = false;
-		state->m_hasSAWSW = true;
-		state->m_hasGPIO2 = true;
-		state->m_hasGPIO1 = true;
-		state->m_hasIRQN = false;
+		state->m_has_lna = false;
+		state->m_has_oob = false;
+		state->m_has_atv = true;
+		state->m_has_audio = false;
+		state->m_has_dvbt = true;
+		state->m_has_dvbc = false;
+		state->m_has_sawsw = true;
+		state->m_has_gpio2 = true;
+		state->m_has_gpio1 = true;
+		state->m_has_irqn = false;
 		break;
 	case 0x18:
 		/* typeId = DRX3918K_TYPE_ID */
-		state->m_hasLNA = false;
-		state->m_hasOOB = false;
-		state->m_hasATV = true;
-		state->m_hasAudio = true;
-		state->m_hasDVBT = true;
-		state->m_hasDVBC = false;
-		state->m_hasSAWSW = true;
-		state->m_hasGPIO2 = true;
-		state->m_hasGPIO1 = true;
-		state->m_hasIRQN = false;
+		state->m_has_lna = false;
+		state->m_has_oob = false;
+		state->m_has_atv = true;
+		state->m_has_audio = true;
+		state->m_has_dvbt = true;
+		state->m_has_dvbc = false;
+		state->m_has_sawsw = true;
+		state->m_has_gpio2 = true;
+		state->m_has_gpio1 = true;
+		state->m_has_irqn = false;
 		break;
 	case 0x21:
 		/* typeId = DRX3921K_TYPE_ID */
-		state->m_hasLNA = false;
-		state->m_hasOOB = false;
-		state->m_hasATV = true;
-		state->m_hasAudio = true;
-		state->m_hasDVBT = true;
-		state->m_hasDVBC = true;
-		state->m_hasSAWSW = true;
-		state->m_hasGPIO2 = true;
-		state->m_hasGPIO1 = true;
-		state->m_hasIRQN = false;
+		state->m_has_lna = false;
+		state->m_has_oob = false;
+		state->m_has_atv = true;
+		state->m_has_audio = true;
+		state->m_has_dvbt = true;
+		state->m_has_dvbc = true;
+		state->m_has_sawsw = true;
+		state->m_has_gpio2 = true;
+		state->m_has_gpio1 = true;
+		state->m_has_irqn = false;
 		break;
 	case 0x23:
 		/* typeId = DRX3923K_TYPE_ID */
-		state->m_hasLNA = false;
-		state->m_hasOOB = false;
-		state->m_hasATV = true;
-		state->m_hasAudio = true;
-		state->m_hasDVBT = true;
-		state->m_hasDVBC = true;
-		state->m_hasSAWSW = true;
-		state->m_hasGPIO2 = true;
-		state->m_hasGPIO1 = true;
-		state->m_hasIRQN = false;
+		state->m_has_lna = false;
+		state->m_has_oob = false;
+		state->m_has_atv = true;
+		state->m_has_audio = true;
+		state->m_has_dvbt = true;
+		state->m_has_dvbc = true;
+		state->m_has_sawsw = true;
+		state->m_has_gpio2 = true;
+		state->m_has_gpio1 = true;
+		state->m_has_irqn = false;
 		break;
 	case 0x25:
 		/* typeId = DRX3925K_TYPE_ID */
-		state->m_hasLNA = false;
-		state->m_hasOOB = false;
-		state->m_hasATV = true;
-		state->m_hasAudio = true;
-		state->m_hasDVBT = true;
-		state->m_hasDVBC = true;
-		state->m_hasSAWSW = true;
-		state->m_hasGPIO2 = true;
-		state->m_hasGPIO1 = true;
-		state->m_hasIRQN = false;
+		state->m_has_lna = false;
+		state->m_has_oob = false;
+		state->m_has_atv = true;
+		state->m_has_audio = true;
+		state->m_has_dvbt = true;
+		state->m_has_dvbc = true;
+		state->m_has_sawsw = true;
+		state->m_has_gpio2 = true;
+		state->m_has_gpio1 = true;
+		state->m_has_irqn = false;
 		break;
 	case 0x26:
 		/* typeId = DRX3926K_TYPE_ID */
-		state->m_hasLNA = false;
-		state->m_hasOOB = false;
-		state->m_hasATV = true;
-		state->m_hasAudio = false;
-		state->m_hasDVBT = true;
-		state->m_hasDVBC = true;
-		state->m_hasSAWSW = true;
-		state->m_hasGPIO2 = true;
-		state->m_hasGPIO1 = true;
-		state->m_hasIRQN = false;
+		state->m_has_lna = false;
+		state->m_has_oob = false;
+		state->m_has_atv = true;
+		state->m_has_audio = false;
+		state->m_has_dvbt = true;
+		state->m_has_dvbc = true;
+		state->m_has_sawsw = true;
+		state->m_has_gpio2 = true;
+		state->m_has_gpio1 = true;
+		state->m_has_irqn = false;
 		break;
 	default:
 		printk(KERN_ERR "drxk: DeviceID 0x%02x not supported\n",
-			((sioTopJtagidLo >> 12) & 0xFF));
+			((sio_top_jtagid_lo >> 12) & 0xFF));
 		status = -EINVAL;
 		goto error2;
 	}
 
 	printk(KERN_INFO
 	       "drxk: detected a drx-39%02xk, spin %s, xtal %d.%03d MHz\n",
-	       ((sioTopJtagidLo >> 12) & 0xFF), spin,
-	       state->m_oscClockFreq / 1000,
-	       state->m_oscClockFreq % 1000);
+	       ((sio_top_jtagid_lo >> 12) & 0xFF), spin,
+	       state->m_osc_clock_freq / 1000,
+	       state->m_osc_clock_freq % 1000);
 
 error:
 	if (status < 0)
@@ -1005,7 +1005,7 @@ error2:
 	return status;
 }
 
-static int HI_Command(struct drxk_state *state, u16 cmd, u16 *pResult)
+static int hi_command(struct drxk_state *state, u16 cmd, u16 *p_result)
 {
 	int status;
 	bool powerdown_cmd;
@@ -1021,24 +1021,24 @@ static int HI_Command(struct drxk_state *state, u16 cmd, u16 *pResult)
 
 	powerdown_cmd =
 	    (bool) ((cmd == SIO_HI_RA_RAM_CMD_CONFIG) &&
-		    ((state->m_HICfgCtrl) &
+		    ((state->m_hi_cfg_ctrl) &
 		     SIO_HI_RA_RAM_PAR_5_CFG_SLEEP__M) ==
 		    SIO_HI_RA_RAM_PAR_5_CFG_SLEEP_ZZZ);
 	if (powerdown_cmd == false) {
 		/* Wait until command rdy */
-		u32 retryCount = 0;
-		u16 waitCmd;
+		u32 retry_count = 0;
+		u16 wait_cmd;
 
 		do {
 			msleep(1);
-			retryCount += 1;
+			retry_count += 1;
 			status = read16(state, SIO_HI_RA_RAM_CMD__A,
-					  &waitCmd);
-		} while ((status < 0) && (retryCount < DRXK_MAX_RETRIES)
-			 && (waitCmd != 0));
+					  &wait_cmd);
+		} while ((status < 0) && (retry_count < DRXK_MAX_RETRIES)
+			 && (wait_cmd != 0));
 		if (status < 0)
 			goto error;
-		status = read16(state, SIO_HI_RA_RAM_RES__A, pResult);
+		status = read16(state, SIO_HI_RA_RAM_RES__A, p_result);
 	}
 error:
 	if (status < 0)
@@ -1047,7 +1047,7 @@ error:
 	return status;
 }
 
-static int HI_CfgCommand(struct drxk_state *state)
+static int hi_cfg_command(struct drxk_state *state)
 {
 	int status;
 
@@ -1055,29 +1055,29 @@ static int HI_CfgCommand(struct drxk_state *state)
 
 	mutex_lock(&state->mutex);
 
-	status = write16(state, SIO_HI_RA_RAM_PAR_6__A, state->m_HICfgTimeout);
+	status = write16(state, SIO_HI_RA_RAM_PAR_6__A, state->m_hi_cfg_timeout);
 	if (status < 0)
 		goto error;
-	status = write16(state, SIO_HI_RA_RAM_PAR_5__A, state->m_HICfgCtrl);
+	status = write16(state, SIO_HI_RA_RAM_PAR_5__A, state->m_hi_cfg_ctrl);
 	if (status < 0)
 		goto error;
-	status = write16(state, SIO_HI_RA_RAM_PAR_4__A, state->m_HICfgWakeUpKey);
+	status = write16(state, SIO_HI_RA_RAM_PAR_4__A, state->m_hi_cfg_wake_up_key);
 	if (status < 0)
 		goto error;
-	status = write16(state, SIO_HI_RA_RAM_PAR_3__A, state->m_HICfgBridgeDelay);
+	status = write16(state, SIO_HI_RA_RAM_PAR_3__A, state->m_hi_cfg_bridge_delay);
 	if (status < 0)
 		goto error;
-	status = write16(state, SIO_HI_RA_RAM_PAR_2__A, state->m_HICfgTimingDiv);
+	status = write16(state, SIO_HI_RA_RAM_PAR_2__A, state->m_hi_cfg_timing_div);
 	if (status < 0)
 		goto error;
 	status = write16(state, SIO_HI_RA_RAM_PAR_1__A, SIO_HI_RA_RAM_PAR_1_PAR1_SEC_KEY);
 	if (status < 0)
 		goto error;
-	status = HI_Command(state, SIO_HI_RA_RAM_CMD_CONFIG, 0);
+	status = hi_command(state, SIO_HI_RA_RAM_CMD_CONFIG, 0);
 	if (status < 0)
 		goto error;
 
-	state->m_HICfgCtrl &= ~SIO_HI_RA_RAM_PAR_5_CFG_SLEEP_ZZZ;
+	state->m_hi_cfg_ctrl &= ~SIO_HI_RA_RAM_PAR_5_CFG_SLEEP_ZZZ;
 error:
 	mutex_unlock(&state->mutex);
 	if (status < 0)
@@ -1085,28 +1085,28 @@ error:
 	return status;
 }
 
-static int InitHI(struct drxk_state *state)
+static int init_hi(struct drxk_state *state)
 {
 	dprintk(1, "\n");
 
-	state->m_HICfgWakeUpKey = (state->demod_address << 1);
-	state->m_HICfgTimeout = 0x96FF;
+	state->m_hi_cfg_wake_up_key = (state->demod_address << 1);
+	state->m_hi_cfg_timeout = 0x96FF;
 	/* port/bridge/power down ctrl */
-	state->m_HICfgCtrl = SIO_HI_RA_RAM_PAR_5_CFG_SLV0_SLAVE;
+	state->m_hi_cfg_ctrl = SIO_HI_RA_RAM_PAR_5_CFG_SLV0_SLAVE;
 
-	return HI_CfgCommand(state);
+	return hi_cfg_command(state);
 }
 
-static int MPEGTSConfigurePins(struct drxk_state *state, bool mpegEnable)
+static int mpegts_configure_pins(struct drxk_state *state, bool mpeg_enable)
 {
 	int status = -1;
-	u16 sioPdrMclkCfg = 0;
-	u16 sioPdrMdxCfg = 0;
+	u16 sio_pdr_mclk_cfg = 0;
+	u16 sio_pdr_mdx_cfg = 0;
 	u16 err_cfg = 0;
 
 	dprintk(1, ": mpeg %s, %s mode\n",
-		mpegEnable ? "enable" : "disable",
-		state->m_enableParallel ? "parallel" : "serial");
+		mpeg_enable ? "enable" : "disable",
+		state->m_enable_parallel ? "parallel" : "serial");
 
 	/* stop lock indicator process */
 	status = write16(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
@@ -1118,7 +1118,7 @@ static int MPEGTSConfigurePins(struct drxk_state *state, bool mpegEnable)
 	if (status < 0)
 		goto error;
 
-	if (mpegEnable == false) {
+	if (mpeg_enable == false) {
 		/*  Set MPEG TS pads to inputmode */
 		status = write16(state, SIO_PDR_MSTRT_CFG__A, 0x0000);
 		if (status < 0)
@@ -1158,19 +1158,19 @@ static int MPEGTSConfigurePins(struct drxk_state *state, bool mpegEnable)
 			goto error;
 	} else {
 		/* Enable MPEG output */
-		sioPdrMdxCfg =
-			((state->m_TSDataStrength <<
+		sio_pdr_mdx_cfg =
+			((state->m_ts_data_strength <<
 			SIO_PDR_MD0_CFG_DRIVE__B) | 0x0003);
-		sioPdrMclkCfg = ((state->m_TSClockkStrength <<
+		sio_pdr_mclk_cfg = ((state->m_ts_clockk_strength <<
 					SIO_PDR_MCLK_CFG_DRIVE__B) |
 					0x0003);
 
-		status = write16(state, SIO_PDR_MSTRT_CFG__A, sioPdrMdxCfg);
+		status = write16(state, SIO_PDR_MSTRT_CFG__A, sio_pdr_mdx_cfg);
 		if (status < 0)
 			goto error;
 
 		if (state->enable_merr_cfg)
-			err_cfg = sioPdrMdxCfg;
+			err_cfg = sio_pdr_mdx_cfg;
 
 		status = write16(state, SIO_PDR_MERR_CFG__A, err_cfg);
 		if (status < 0)
@@ -1179,31 +1179,31 @@ static int MPEGTSConfigurePins(struct drxk_state *state, bool mpegEnable)
 		if (status < 0)
 			goto error;
 
-		if (state->m_enableParallel == true) {
+		if (state->m_enable_parallel == true) {
 			/* paralel -> enable MD1 to MD7 */
-			status = write16(state, SIO_PDR_MD1_CFG__A, sioPdrMdxCfg);
+			status = write16(state, SIO_PDR_MD1_CFG__A, sio_pdr_mdx_cfg);
 			if (status < 0)
 				goto error;
-			status = write16(state, SIO_PDR_MD2_CFG__A, sioPdrMdxCfg);
+			status = write16(state, SIO_PDR_MD2_CFG__A, sio_pdr_mdx_cfg);
 			if (status < 0)
 				goto error;
-			status = write16(state, SIO_PDR_MD3_CFG__A, sioPdrMdxCfg);
+			status = write16(state, SIO_PDR_MD3_CFG__A, sio_pdr_mdx_cfg);
 			if (status < 0)
 				goto error;
-			status = write16(state, SIO_PDR_MD4_CFG__A, sioPdrMdxCfg);
+			status = write16(state, SIO_PDR_MD4_CFG__A, sio_pdr_mdx_cfg);
 			if (status < 0)
 				goto error;
-			status = write16(state, SIO_PDR_MD5_CFG__A, sioPdrMdxCfg);
+			status = write16(state, SIO_PDR_MD5_CFG__A, sio_pdr_mdx_cfg);
 			if (status < 0)
 				goto error;
-			status = write16(state, SIO_PDR_MD6_CFG__A, sioPdrMdxCfg);
+			status = write16(state, SIO_PDR_MD6_CFG__A, sio_pdr_mdx_cfg);
 			if (status < 0)
 				goto error;
-			status = write16(state, SIO_PDR_MD7_CFG__A, sioPdrMdxCfg);
+			status = write16(state, SIO_PDR_MD7_CFG__A, sio_pdr_mdx_cfg);
 			if (status < 0)
 				goto error;
 		} else {
-			sioPdrMdxCfg = ((state->m_TSDataStrength <<
+			sio_pdr_mdx_cfg = ((state->m_ts_data_strength <<
 						SIO_PDR_MD0_CFG_DRIVE__B)
 					| 0x0003);
 			/* serial -> disable MD1 to MD7 */
@@ -1229,10 +1229,10 @@ static int MPEGTSConfigurePins(struct drxk_state *state, bool mpegEnable)
 			if (status < 0)
 				goto error;
 		}
-		status = write16(state, SIO_PDR_MCLK_CFG__A, sioPdrMclkCfg);
+		status = write16(state, SIO_PDR_MCLK_CFG__A, sio_pdr_mclk_cfg);
 		if (status < 0)
 			goto error;
-		status = write16(state, SIO_PDR_MD0_CFG__A, sioPdrMdxCfg);
+		status = write16(state, SIO_PDR_MD0_CFG__A, sio_pdr_mdx_cfg);
 		if (status < 0)
 			goto error;
 	}
@@ -1248,17 +1248,17 @@ error:
 	return status;
 }
 
-static int MPEGTSDisable(struct drxk_state *state)
+static int mpegts_disable(struct drxk_state *state)
 {
 	dprintk(1, "\n");
 
-	return MPEGTSConfigurePins(state, false);
+	return mpegts_configure_pins(state, false);
 }
 
-static int BLChainCmd(struct drxk_state *state,
-		      u16 romOffset, u16 nrOfElements, u32 timeOut)
+static int bl_chain_cmd(struct drxk_state *state,
+		      u16 rom_offset, u16 nr_of_elements, u32 time_out)
 {
-	u16 blStatus = 0;
+	u16 bl_status = 0;
 	int status;
 	unsigned long end;
 
@@ -1267,26 +1267,26 @@ static int BLChainCmd(struct drxk_state *state,
 	status = write16(state, SIO_BL_MODE__A, SIO_BL_MODE_CHAIN);
 	if (status < 0)
 		goto error;
-	status = write16(state, SIO_BL_CHAIN_ADDR__A, romOffset);
+	status = write16(state, SIO_BL_CHAIN_ADDR__A, rom_offset);
 	if (status < 0)
 		goto error;
-	status = write16(state, SIO_BL_CHAIN_LEN__A, nrOfElements);
+	status = write16(state, SIO_BL_CHAIN_LEN__A, nr_of_elements);
 	if (status < 0)
 		goto error;
 	status = write16(state, SIO_BL_ENABLE__A, SIO_BL_ENABLE_ON);
 	if (status < 0)
 		goto error;
 
-	end = jiffies + msecs_to_jiffies(timeOut);
+	end = jiffies + msecs_to_jiffies(time_out);
 	do {
 		msleep(1);
-		status = read16(state, SIO_BL_STATUS__A, &blStatus);
+		status = read16(state, SIO_BL_STATUS__A, &bl_status);
 		if (status < 0)
 			goto error;
-	} while ((blStatus == 0x1) &&
+	} while ((bl_status == 0x1) &&
 			((time_is_after_jiffies(end))));
 
-	if (blStatus == 0x1) {
+	if (bl_status == 0x1) {
 		printk(KERN_ERR "drxk: SIO not ready\n");
 		status = -EINVAL;
 		goto error2;
@@ -1300,13 +1300,13 @@ error2:
 }
 
 
-static int DownloadMicrocode(struct drxk_state *state,
-			     const u8 pMCImage[], u32 Length)
+static int download_microcode(struct drxk_state *state,
+			     const u8 p_mc_image[], u32 length)
 {
-	const u8 *pSrc = pMCImage;
-	u32 Address;
-	u16 nBlocks;
-	u16 BlockSize;
+	const u8 *p_src = p_mc_image;
+	u32 address;
+	u16 n_blocks;
+	u16 block_size;
 	u32 offset = 0;
 	u32 i;
 	int status = 0;
@@ -1316,114 +1316,114 @@ static int DownloadMicrocode(struct drxk_state *state,
 	/* down the drain (we don't care about MAGIC_WORD) */
 #if 0
 	/* For future reference */
-	Drain = (pSrc[0] << 8) | pSrc[1];
+	drain = (p_src[0] << 8) | p_src[1];
 #endif
-	pSrc += sizeof(u16);
+	p_src += sizeof(u16);
 	offset += sizeof(u16);
-	nBlocks = (pSrc[0] << 8) | pSrc[1];
-	pSrc += sizeof(u16);
+	n_blocks = (p_src[0] << 8) | p_src[1];
+	p_src += sizeof(u16);
 	offset += sizeof(u16);
 
-	for (i = 0; i < nBlocks; i += 1) {
-		Address = (pSrc[0] << 24) | (pSrc[1] << 16) |
-		    (pSrc[2] << 8) | pSrc[3];
-		pSrc += sizeof(u32);
+	for (i = 0; i < n_blocks; i += 1) {
+		address = (p_src[0] << 24) | (p_src[1] << 16) |
+		    (p_src[2] << 8) | p_src[3];
+		p_src += sizeof(u32);
 		offset += sizeof(u32);
 
-		BlockSize = ((pSrc[0] << 8) | pSrc[1]) * sizeof(u16);
-		pSrc += sizeof(u16);
+		block_size = ((p_src[0] << 8) | p_src[1]) * sizeof(u16);
+		p_src += sizeof(u16);
 		offset += sizeof(u16);
 
 #if 0
 		/* For future reference */
-		Flags = (pSrc[0] << 8) | pSrc[1];
+		flags = (p_src[0] << 8) | p_src[1];
 #endif
-		pSrc += sizeof(u16);
+		p_src += sizeof(u16);
 		offset += sizeof(u16);
 
 #if 0
 		/* For future reference */
-		BlockCRC = (pSrc[0] << 8) | pSrc[1];
+		block_crc = (p_src[0] << 8) | p_src[1];
 #endif
-		pSrc += sizeof(u16);
+		p_src += sizeof(u16);
 		offset += sizeof(u16);
 
-		if (offset + BlockSize > Length) {
+		if (offset + block_size > length) {
 			printk(KERN_ERR "drxk: Firmware is corrupted.\n");
 			return -EINVAL;
 		}
 
-		status = write_block(state, Address, BlockSize, pSrc);
+		status = write_block(state, address, block_size, p_src);
 		if (status < 0) {
 			printk(KERN_ERR "drxk: Error %d while loading firmware\n", status);
 			break;
 		}
-		pSrc += BlockSize;
-		offset += BlockSize;
+		p_src += block_size;
+		offset += block_size;
 	}
 	return status;
 }
 
-static int DVBTEnableOFDMTokenRing(struct drxk_state *state, bool enable)
+static int dvbt_enable_ofdm_token_ring(struct drxk_state *state, bool enable)
 {
 	int status;
 	u16 data = 0;
-	u16 desiredCtrl = SIO_OFDM_SH_OFDM_RING_ENABLE_ON;
-	u16 desiredStatus = SIO_OFDM_SH_OFDM_RING_STATUS_ENABLED;
+	u16 desired_ctrl = SIO_OFDM_SH_OFDM_RING_ENABLE_ON;
+	u16 desired_status = SIO_OFDM_SH_OFDM_RING_STATUS_ENABLED;
 	unsigned long end;
 
 	dprintk(1, "\n");
 
 	if (enable == false) {
-		desiredCtrl = SIO_OFDM_SH_OFDM_RING_ENABLE_OFF;
-		desiredStatus = SIO_OFDM_SH_OFDM_RING_STATUS_DOWN;
+		desired_ctrl = SIO_OFDM_SH_OFDM_RING_ENABLE_OFF;
+		desired_status = SIO_OFDM_SH_OFDM_RING_STATUS_DOWN;
 	}
 
 	status = read16(state, SIO_OFDM_SH_OFDM_RING_STATUS__A, &data);
-	if (status >= 0 && data == desiredStatus) {
+	if (status >= 0 && data == desired_status) {
 		/* tokenring already has correct status */
 		return status;
 	}
 	/* Disable/enable dvbt tokenring bridge   */
-	status = write16(state, SIO_OFDM_SH_OFDM_RING_ENABLE__A, desiredCtrl);
+	status = write16(state, SIO_OFDM_SH_OFDM_RING_ENABLE__A, desired_ctrl);
 
 	end = jiffies + msecs_to_jiffies(DRXK_OFDM_TR_SHUTDOWN_TIMEOUT);
 	do {
 		status = read16(state, SIO_OFDM_SH_OFDM_RING_STATUS__A, &data);
-		if ((status >= 0 && data == desiredStatus) || time_is_after_jiffies(end))
+		if ((status >= 0 && data == desired_status) || time_is_after_jiffies(end))
 			break;
 		msleep(1);
 	} while (1);
-	if (data != desiredStatus) {
+	if (data != desired_status) {
 		printk(KERN_ERR "drxk: SIO not ready\n");
 		return -EINVAL;
 	}
 	return status;
 }
 
-static int MPEGTSStop(struct drxk_state *state)
+static int mpegts_stop(struct drxk_state *state)
 {
 	int status = 0;
-	u16 fecOcSncMode = 0;
-	u16 fecOcIprMode = 0;
+	u16 fec_oc_snc_mode = 0;
+	u16 fec_oc_ipr_mode = 0;
 
 	dprintk(1, "\n");
 
 	/* Gracefull shutdown (byte boundaries) */
-	status = read16(state, FEC_OC_SNC_MODE__A, &fecOcSncMode);
+	status = read16(state, FEC_OC_SNC_MODE__A, &fec_oc_snc_mode);
 	if (status < 0)
 		goto error;
-	fecOcSncMode |= FEC_OC_SNC_MODE_SHUTDOWN__M;
-	status = write16(state, FEC_OC_SNC_MODE__A, fecOcSncMode);
+	fec_oc_snc_mode |= FEC_OC_SNC_MODE_SHUTDOWN__M;
+	status = write16(state, FEC_OC_SNC_MODE__A, fec_oc_snc_mode);
 	if (status < 0)
 		goto error;
 
 	/* Suppress MCLK during absence of data */
-	status = read16(state, FEC_OC_IPR_MODE__A, &fecOcIprMode);
+	status = read16(state, FEC_OC_IPR_MODE__A, &fec_oc_ipr_mode);
 	if (status < 0)
 		goto error;
-	fecOcIprMode |= FEC_OC_IPR_MODE_MCLK_DIS_DAT_ABS__M;
-	status = write16(state, FEC_OC_IPR_MODE__A, fecOcIprMode);
+	fec_oc_ipr_mode |= FEC_OC_IPR_MODE_MCLK_DIS_DAT_ABS__M;
+	status = write16(state, FEC_OC_IPR_MODE__A, fec_oc_ipr_mode);
 
 error:
 	if (status < 0)
@@ -1433,13 +1433,13 @@ error:
 }
 
 static int scu_command(struct drxk_state *state,
-		       u16 cmd, u8 parameterLen,
-		       u16 *parameter, u8 resultLen, u16 *result)
+		       u16 cmd, u8 parameter_len,
+		       u16 *parameter, u8 result_len, u16 *result)
 {
 #if (SCU_RAM_PARAM_0__A - SCU_RAM_PARAM_15__A) != 15
 #error DRXK register mapping no longer compatible with this routine!
 #endif
-	u16 curCmd = 0;
+	u16 cur_cmd = 0;
 	int status = -EINVAL;
 	unsigned long end;
 	u8 buffer[34];
@@ -1449,8 +1449,8 @@ static int scu_command(struct drxk_state *state,
 
 	dprintk(1, "\n");
 
-	if ((cmd == 0) || ((parameterLen > 0) && (parameter == NULL)) ||
-	    ((resultLen > 0) && (result == NULL))) {
+	if ((cmd == 0) || ((parameter_len > 0) && (parameter == NULL)) ||
+	    ((result_len > 0) && (result == NULL))) {
 		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 		return status;
 	}
@@ -1459,7 +1459,7 @@ static int scu_command(struct drxk_state *state,
 
 	/* assume that the command register is ready
 		since it is checked afterwards */
-	for (ii = parameterLen - 1; ii >= 0; ii -= 1) {
+	for (ii = parameter_len - 1; ii >= 0; ii -= 1) {
 		buffer[cnt++] = (parameter[ii] & 0xFF);
 		buffer[cnt++] = ((parameter[ii] >> 8) & 0xFF);
 	}
@@ -1467,26 +1467,26 @@ static int scu_command(struct drxk_state *state,
 	buffer[cnt++] = ((cmd >> 8) & 0xFF);
 
 	write_block(state, SCU_RAM_PARAM_0__A -
-			(parameterLen - 1), cnt, buffer);
+			(parameter_len - 1), cnt, buffer);
 	/* Wait until SCU has processed command */
 	end = jiffies + msecs_to_jiffies(DRXK_MAX_WAITTIME);
 	do {
 		msleep(1);
-		status = read16(state, SCU_RAM_COMMAND__A, &curCmd);
+		status = read16(state, SCU_RAM_COMMAND__A, &cur_cmd);
 		if (status < 0)
 			goto error;
-	} while (!(curCmd == DRX_SCU_READY) && (time_is_after_jiffies(end)));
-	if (curCmd != DRX_SCU_READY) {
+	} while (!(cur_cmd == DRX_SCU_READY) && (time_is_after_jiffies(end)));
+	if (cur_cmd != DRX_SCU_READY) {
 		printk(KERN_ERR "drxk: SCU not ready\n");
 		status = -EIO;
 		goto error2;
 	}
 	/* read results */
-	if ((resultLen > 0) && (result != NULL)) {
+	if ((result_len > 0) && (result != NULL)) {
 		s16 err;
 		int ii;
 
-		for (ii = resultLen - 1; ii >= 0; ii -= 1) {
+		for (ii = result_len - 1; ii >= 0; ii -= 1) {
 			status = read16(state, SCU_RAM_PARAM_0__A - ii, &result[ii]);
 			if (status < 0)
 				goto error;
@@ -1529,7 +1529,7 @@ error2:
 	return status;
 }
 
-static int SetIqmAf(struct drxk_state *state, bool active)
+static int set_iqm_af(struct drxk_state *state, bool active)
 {
 	u16 data = 0;
 	int status;
@@ -1563,10 +1563,10 @@ error:
 	return status;
 }
 
-static int CtrlPowerMode(struct drxk_state *state, enum DRXPowerMode *mode)
+static int ctrl_power_mode(struct drxk_state *state, enum drx_power_mode *mode)
 {
 	int status = 0;
-	u16 sioCcPwdMode = 0;
+	u16 sio_cc_pwd_mode = 0;
 
 	dprintk(1, "\n");
 
@@ -1576,19 +1576,19 @@ static int CtrlPowerMode(struct drxk_state *state, enum DRXPowerMode *mode)
 
 	switch (*mode) {
 	case DRX_POWER_UP:
-		sioCcPwdMode = SIO_CC_PWD_MODE_LEVEL_NONE;
+		sio_cc_pwd_mode = SIO_CC_PWD_MODE_LEVEL_NONE;
 		break;
 	case DRXK_POWER_DOWN_OFDM:
-		sioCcPwdMode = SIO_CC_PWD_MODE_LEVEL_OFDM;
+		sio_cc_pwd_mode = SIO_CC_PWD_MODE_LEVEL_OFDM;
 		break;
 	case DRXK_POWER_DOWN_CORE:
-		sioCcPwdMode = SIO_CC_PWD_MODE_LEVEL_CLOCK;
+		sio_cc_pwd_mode = SIO_CC_PWD_MODE_LEVEL_CLOCK;
 		break;
 	case DRXK_POWER_DOWN_PLL:
-		sioCcPwdMode = SIO_CC_PWD_MODE_LEVEL_PLL;
+		sio_cc_pwd_mode = SIO_CC_PWD_MODE_LEVEL_PLL;
 		break;
 	case DRX_POWER_DOWN:
-		sioCcPwdMode = SIO_CC_PWD_MODE_LEVEL_OSC;
+		sio_cc_pwd_mode = SIO_CC_PWD_MODE_LEVEL_OSC;
 		break;
 	default:
 		/* Unknow sleep mode */
@@ -1596,15 +1596,15 @@ static int CtrlPowerMode(struct drxk_state *state, enum DRXPowerMode *mode)
 	}
 
 	/* If already in requested power mode, do nothing */
-	if (state->m_currentPowerMode == *mode)
+	if (state->m_current_power_mode == *mode)
 		return 0;
 
 	/* For next steps make sure to start from DRX_POWER_UP mode */
-	if (state->m_currentPowerMode != DRX_POWER_UP) {
-		status = PowerUpDevice(state);
+	if (state->m_current_power_mode != DRX_POWER_UP) {
+		status = power_up_device(state);
 		if (status < 0)
 			goto error;
-		status = DVBTEnableOFDMTokenRing(state, true);
+		status = dvbt_enable_ofdm_token_ring(state, true);
 		if (status < 0)
 			goto error;
 	}
@@ -1621,31 +1621,31 @@ static int CtrlPowerMode(struct drxk_state *state, enum DRXPowerMode *mode)
 		/* Power down device */
 		/* stop all comm_exec */
 		/* Stop and power down previous standard */
-		switch (state->m_OperationMode) {
+		switch (state->m_operation_mode) {
 		case OM_DVBT:
-			status = MPEGTSStop(state);
+			status = mpegts_stop(state);
 			if (status < 0)
 				goto error;
-			status = PowerDownDVBT(state, false);
+			status = power_down_dvbt(state, false);
 			if (status < 0)
 				goto error;
 			break;
 		case OM_QAM_ITU_A:
 		case OM_QAM_ITU_C:
-			status = MPEGTSStop(state);
+			status = mpegts_stop(state);
 			if (status < 0)
 				goto error;
-			status = PowerDownQAM(state);
+			status = power_down_qam(state);
 			if (status < 0)
 				goto error;
 			break;
 		default:
 			break;
 		}
-		status = DVBTEnableOFDMTokenRing(state, false);
+		status = dvbt_enable_ofdm_token_ring(state, false);
 		if (status < 0)
 			goto error;
-		status = write16(state, SIO_CC_PWD_MODE__A, sioCcPwdMode);
+		status = write16(state, SIO_CC_PWD_MODE__A, sio_cc_pwd_mode);
 		if (status < 0)
 			goto error;
 		status = write16(state, SIO_CC_UPDATE__A, SIO_CC_UPDATE_KEY);
@@ -1653,14 +1653,14 @@ static int CtrlPowerMode(struct drxk_state *state, enum DRXPowerMode *mode)
 			goto error;
 
 		if (*mode != DRXK_POWER_DOWN_OFDM) {
-			state->m_HICfgCtrl |=
+			state->m_hi_cfg_ctrl |=
 				SIO_HI_RA_RAM_PAR_5_CFG_SLEEP_ZZZ;
-			status = HI_CfgCommand(state);
+			status = hi_cfg_command(state);
 			if (status < 0)
 				goto error;
 		}
 	}
-	state->m_currentPowerMode = *mode;
+	state->m_current_power_mode = *mode;
 
 error:
 	if (status < 0)
@@ -1669,10 +1669,10 @@ error:
 	return status;
 }
 
-static int PowerDownDVBT(struct drxk_state *state, bool setPowerMode)
+static int power_down_dvbt(struct drxk_state *state, bool set_power_mode)
 {
-	enum DRXPowerMode powerMode = DRXK_POWER_DOWN_OFDM;
-	u16 cmdResult = 0;
+	enum drx_power_mode power_mode = DRXK_POWER_DOWN_OFDM;
+	u16 cmd_result = 0;
 	u16 data = 0;
 	int status;
 
@@ -1683,11 +1683,11 @@ static int PowerDownDVBT(struct drxk_state *state, bool setPowerMode)
 		goto error;
 	if (data == SCU_COMM_EXEC_ACTIVE) {
 		/* Send OFDM stop command */
-		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_STOP, 0, NULL, 1, &cmdResult);
+		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_STOP, 0, NULL, 1, &cmd_result);
 		if (status < 0)
 			goto error;
 		/* Send OFDM reset command */
-		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_RESET, 0, NULL, 1, &cmdResult);
+		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_RESET, 0, NULL, 1, &cmd_result);
 		if (status < 0)
 			goto error;
 	}
@@ -1704,13 +1704,13 @@ static int PowerDownDVBT(struct drxk_state *state, bool setPowerMode)
 		goto error;
 
 	/* powerdown AFE                   */
-	status = SetIqmAf(state, false);
+	status = set_iqm_af(state, false);
 	if (status < 0)
 		goto error;
 
 	/* powerdown to OFDM mode          */
-	if (setPowerMode) {
-		status = CtrlPowerMode(state, &powerMode);
+	if (set_power_mode) {
+		status = ctrl_power_mode(state, &power_mode);
 		if (status < 0)
 			goto error;
 	}
@@ -1720,8 +1720,8 @@ error:
 	return status;
 }
 
-static int SetOperationMode(struct drxk_state *state,
-			    enum OperationMode oMode)
+static int setoperation_mode(struct drxk_state *state,
+			    enum operation_mode o_mode)
 {
 	int status = 0;
 
@@ -1738,31 +1738,31 @@ static int SetOperationMode(struct drxk_state *state,
 		goto error;
 
 	/* Device is already at the required mode */
-	if (state->m_OperationMode == oMode)
+	if (state->m_operation_mode == o_mode)
 		return 0;
 
-	switch (state->m_OperationMode) {
+	switch (state->m_operation_mode) {
 		/* OM_NONE was added for start up */
 	case OM_NONE:
 		break;
 	case OM_DVBT:
-		status = MPEGTSStop(state);
+		status = mpegts_stop(state);
 		if (status < 0)
 			goto error;
-		status = PowerDownDVBT(state, true);
+		status = power_down_dvbt(state, true);
 		if (status < 0)
 			goto error;
-		state->m_OperationMode = OM_NONE;
+		state->m_operation_mode = OM_NONE;
 		break;
 	case OM_QAM_ITU_A:	/* fallthrough */
 	case OM_QAM_ITU_C:
-		status = MPEGTSStop(state);
+		status = mpegts_stop(state);
 		if (status < 0)
 			goto error;
-		status = PowerDownQAM(state);
+		status = power_down_qam(state);
 		if (status < 0)
 			goto error;
-		state->m_OperationMode = OM_NONE;
+		state->m_operation_mode = OM_NONE;
 		break;
 	case OM_QAM_ITU_B:
 	default:
@@ -1773,20 +1773,20 @@ static int SetOperationMode(struct drxk_state *state,
 	/*
 		Power up new standard
 		*/
-	switch (oMode) {
+	switch (o_mode) {
 	case OM_DVBT:
 		dprintk(1, ": DVB-T\n");
-		state->m_OperationMode = oMode;
-		status = SetDVBTStandard(state, oMode);
+		state->m_operation_mode = o_mode;
+		status = set_dvbt_standard(state, o_mode);
 		if (status < 0)
 			goto error;
 		break;
 	case OM_QAM_ITU_A:	/* fallthrough */
 	case OM_QAM_ITU_C:
 		dprintk(1, ": DVB-C Annex %c\n",
-			(state->m_OperationMode == OM_QAM_ITU_A) ? 'A' : 'C');
-		state->m_OperationMode = oMode;
-		status = SetQAMStandard(state, oMode);
+			(state->m_operation_mode == OM_QAM_ITU_A) ? 'A' : 'C');
+		state->m_operation_mode = o_mode;
+		status = set_qam_standard(state, o_mode);
 		if (status < 0)
 			goto error;
 		break;
@@ -1800,47 +1800,47 @@ error:
 	return status;
 }
 
-static int Start(struct drxk_state *state, s32 offsetFreq,
-		 s32 IntermediateFrequency)
+static int start(struct drxk_state *state, s32 offset_freq,
+		 s32 intermediate_frequency)
 {
 	int status = -EINVAL;
 
-	u16 IFreqkHz;
-	s32 OffsetkHz = offsetFreq / 1000;
+	u16 i_freqk_hz;
+	s32 offsetk_hz = offset_freq / 1000;
 
 	dprintk(1, "\n");
-	if (state->m_DrxkState != DRXK_STOPPED &&
-		state->m_DrxkState != DRXK_DTV_STARTED)
+	if (state->m_drxk_state != DRXK_STOPPED &&
+		state->m_drxk_state != DRXK_DTV_STARTED)
 		goto error;
 
-	state->m_bMirrorFreqSpect = (state->props.inversion == INVERSION_ON);
+	state->m_b_mirror_freq_spect = (state->props.inversion == INVERSION_ON);
 
-	if (IntermediateFrequency < 0) {
-		state->m_bMirrorFreqSpect = !state->m_bMirrorFreqSpect;
-		IntermediateFrequency = -IntermediateFrequency;
+	if (intermediate_frequency < 0) {
+		state->m_b_mirror_freq_spect = !state->m_b_mirror_freq_spect;
+		intermediate_frequency = -intermediate_frequency;
 	}
 
-	switch (state->m_OperationMode) {
+	switch (state->m_operation_mode) {
 	case OM_QAM_ITU_A:
 	case OM_QAM_ITU_C:
-		IFreqkHz = (IntermediateFrequency / 1000);
-		status = SetQAM(state, IFreqkHz, OffsetkHz);
+		i_freqk_hz = (intermediate_frequency / 1000);
+		status = set_qam(state, i_freqk_hz, offsetk_hz);
 		if (status < 0)
 			goto error;
-		state->m_DrxkState = DRXK_DTV_STARTED;
+		state->m_drxk_state = DRXK_DTV_STARTED;
 		break;
 	case OM_DVBT:
-		IFreqkHz = (IntermediateFrequency / 1000);
-		status = MPEGTSStop(state);
+		i_freqk_hz = (intermediate_frequency / 1000);
+		status = mpegts_stop(state);
 		if (status < 0)
 			goto error;
-		status = SetDVBT(state, IFreqkHz, OffsetkHz);
+		status = set_dvbt(state, i_freqk_hz, offsetk_hz);
 		if (status < 0)
 			goto error;
-		status = DVBTStart(state);
+		status = dvbt_start(state);
 		if (status < 0)
 			goto error;
-		state->m_DrxkState = DRXK_DTV_STARTED;
+		state->m_drxk_state = DRXK_DTV_STARTED;
 		break;
 	default:
 		break;
@@ -1851,34 +1851,34 @@ error:
 	return status;
 }
 
-static int ShutDown(struct drxk_state *state)
+static int shut_down(struct drxk_state *state)
 {
 	dprintk(1, "\n");
 
-	MPEGTSStop(state);
+	mpegts_stop(state);
 	return 0;
 }
 
-static int GetLockStatus(struct drxk_state *state, u32 *pLockStatus)
+static int get_lock_status(struct drxk_state *state, u32 *p_lock_status)
 {
 	int status = -EINVAL;
 
 	dprintk(1, "\n");
 
-	if (pLockStatus == NULL)
+	if (p_lock_status == NULL)
 		goto error;
 
-	*pLockStatus = NOT_LOCKED;
+	*p_lock_status = NOT_LOCKED;
 
 	/* define the SCU command code */
-	switch (state->m_OperationMode) {
+	switch (state->m_operation_mode) {
 	case OM_QAM_ITU_A:
 	case OM_QAM_ITU_B:
 	case OM_QAM_ITU_C:
-		status = GetQAMLockStatus(state, pLockStatus);
+		status = get_qam_lock_status(state, p_lock_status);
 		break;
 	case OM_DVBT:
-		status = GetDVBTLockStatus(state, pLockStatus);
+		status = get_dvbt_lock_status(state, p_lock_status);
 		break;
 	default:
 		break;
@@ -1889,18 +1889,18 @@ error:
 	return status;
 }
 
-static int MPEGTSStart(struct drxk_state *state)
+static int mpegts_start(struct drxk_state *state)
 {
 	int status;
 
-	u16 fecOcSncMode = 0;
+	u16 fec_oc_snc_mode = 0;
 
 	/* Allow OC to sync again */
-	status = read16(state, FEC_OC_SNC_MODE__A, &fecOcSncMode);
+	status = read16(state, FEC_OC_SNC_MODE__A, &fec_oc_snc_mode);
 	if (status < 0)
 		goto error;
-	fecOcSncMode &= ~FEC_OC_SNC_MODE_SHUTDOWN__M;
-	status = write16(state, FEC_OC_SNC_MODE__A, fecOcSncMode);
+	fec_oc_snc_mode &= ~FEC_OC_SNC_MODE_SHUTDOWN__M;
+	status = write16(state, FEC_OC_SNC_MODE__A, fec_oc_snc_mode);
 	if (status < 0)
 		goto error;
 	status = write16(state, FEC_OC_SNC_UNLOCK__A, 1);
@@ -1910,7 +1910,7 @@ error:
 	return status;
 }
 
-static int MPEGTSDtoInit(struct drxk_state *state)
+static int mpegts_dto_init(struct drxk_state *state)
 {
 	int status;
 
@@ -1957,63 +1957,63 @@ error:
 	return status;
 }
 
-static int MPEGTSDtoSetup(struct drxk_state *state,
-			  enum OperationMode oMode)
+static int mpegts_dto_setup(struct drxk_state *state,
+			  enum operation_mode o_mode)
 {
 	int status;
 
-	u16 fecOcRegMode = 0;	/* FEC_OC_MODE       register value */
-	u16 fecOcRegIprMode = 0;	/* FEC_OC_IPR_MODE   register value */
-	u16 fecOcDtoMode = 0;	/* FEC_OC_IPR_INVERT register value */
-	u16 fecOcFctMode = 0;	/* FEC_OC_IPR_INVERT register value */
-	u16 fecOcDtoPeriod = 2;	/* FEC_OC_IPR_INVERT register value */
-	u16 fecOcDtoBurstLen = 188;	/* FEC_OC_IPR_INVERT register value */
-	u32 fecOcRcnCtlRate = 0;	/* FEC_OC_IPR_INVERT register value */
-	u16 fecOcTmdMode = 0;
-	u16 fecOcTmdIntUpdRate = 0;
-	u32 maxBitRate = 0;
-	bool staticCLK = false;
+	u16 fec_oc_reg_mode = 0;	/* FEC_OC_MODE       register value */
+	u16 fec_oc_reg_ipr_mode = 0;	/* FEC_OC_IPR_MODE   register value */
+	u16 fec_oc_dto_mode = 0;	/* FEC_OC_IPR_INVERT register value */
+	u16 fec_oc_fct_mode = 0;	/* FEC_OC_IPR_INVERT register value */
+	u16 fec_oc_dto_period = 2;	/* FEC_OC_IPR_INVERT register value */
+	u16 fec_oc_dto_burst_len = 188;	/* FEC_OC_IPR_INVERT register value */
+	u32 fec_oc_rcn_ctl_rate = 0;	/* FEC_OC_IPR_INVERT register value */
+	u16 fec_oc_tmd_mode = 0;
+	u16 fec_oc_tmd_int_upd_rate = 0;
+	u32 max_bit_rate = 0;
+	bool static_clk = false;
 
 	dprintk(1, "\n");
 
 	/* Check insertion of the Reed-Solomon parity bytes */
-	status = read16(state, FEC_OC_MODE__A, &fecOcRegMode);
+	status = read16(state, FEC_OC_MODE__A, &fec_oc_reg_mode);
 	if (status < 0)
 		goto error;
-	status = read16(state, FEC_OC_IPR_MODE__A, &fecOcRegIprMode);
+	status = read16(state, FEC_OC_IPR_MODE__A, &fec_oc_reg_ipr_mode);
 	if (status < 0)
 		goto error;
-	fecOcRegMode &= (~FEC_OC_MODE_PARITY__M);
-	fecOcRegIprMode &= (~FEC_OC_IPR_MODE_MVAL_DIS_PAR__M);
-	if (state->m_insertRSByte == true) {
+	fec_oc_reg_mode &= (~FEC_OC_MODE_PARITY__M);
+	fec_oc_reg_ipr_mode &= (~FEC_OC_IPR_MODE_MVAL_DIS_PAR__M);
+	if (state->m_insert_rs_byte == true) {
 		/* enable parity symbol forward */
-		fecOcRegMode |= FEC_OC_MODE_PARITY__M;
+		fec_oc_reg_mode |= FEC_OC_MODE_PARITY__M;
 		/* MVAL disable during parity bytes */
-		fecOcRegIprMode |= FEC_OC_IPR_MODE_MVAL_DIS_PAR__M;
+		fec_oc_reg_ipr_mode |= FEC_OC_IPR_MODE_MVAL_DIS_PAR__M;
 		/* TS burst length to 204 */
-		fecOcDtoBurstLen = 204;
+		fec_oc_dto_burst_len = 204;
 	}
 
 	/* Check serial or parrallel output */
-	fecOcRegIprMode &= (~(FEC_OC_IPR_MODE_SERIAL__M));
-	if (state->m_enableParallel == false) {
+	fec_oc_reg_ipr_mode &= (~(FEC_OC_IPR_MODE_SERIAL__M));
+	if (state->m_enable_parallel == false) {
 		/* MPEG data output is serial -> set ipr_mode[0] */
-		fecOcRegIprMode |= FEC_OC_IPR_MODE_SERIAL__M;
+		fec_oc_reg_ipr_mode |= FEC_OC_IPR_MODE_SERIAL__M;
 	}
 
-	switch (oMode) {
+	switch (o_mode) {
 	case OM_DVBT:
-		maxBitRate = state->m_DVBTBitrate;
-		fecOcTmdMode = 3;
-		fecOcRcnCtlRate = 0xC00000;
-		staticCLK = state->m_DVBTStaticCLK;
+		max_bit_rate = state->m_dvbt_bitrate;
+		fec_oc_tmd_mode = 3;
+		fec_oc_rcn_ctl_rate = 0xC00000;
+		static_clk = state->m_dvbt_static_clk;
 		break;
 	case OM_QAM_ITU_A:	/* fallthrough */
 	case OM_QAM_ITU_C:
-		fecOcTmdMode = 0x0004;
-		fecOcRcnCtlRate = 0xD2B4EE;	/* good for >63 Mb/s */
-		maxBitRate = state->m_DVBCBitrate;
-		staticCLK = state->m_DVBCStaticCLK;
+		fec_oc_tmd_mode = 0x0004;
+		fec_oc_rcn_ctl_rate = 0xD2B4EE;	/* good for >63 Mb/s */
+		max_bit_rate = state->m_dvbc_bitrate;
+		static_clk = state->m_dvbc_static_clk;
 		break;
 	default:
 		status = -EINVAL;
@@ -2022,83 +2022,83 @@ static int MPEGTSDtoSetup(struct drxk_state *state,
 		goto error;
 
 	/* Configure DTO's */
-	if (staticCLK) {
-		u32 bitRate = 0;
+	if (static_clk) {
+		u32 bit_rate = 0;
 
 		/* Rational DTO for MCLK source (static MCLK rate),
 			Dynamic DTO for optimal grouping
 			(avoid intra-packet gaps),
 			DTO offset enable to sync TS burst with MSTRT */
-		fecOcDtoMode = (FEC_OC_DTO_MODE_DYNAMIC__M |
+		fec_oc_dto_mode = (FEC_OC_DTO_MODE_DYNAMIC__M |
 				FEC_OC_DTO_MODE_OFFSET_ENABLE__M);
-		fecOcFctMode = (FEC_OC_FCT_MODE_RAT_ENA__M |
+		fec_oc_fct_mode = (FEC_OC_FCT_MODE_RAT_ENA__M |
 				FEC_OC_FCT_MODE_VIRT_ENA__M);
 
 		/* Check user defined bitrate */
-		bitRate = maxBitRate;
-		if (bitRate > 75900000UL) {	/* max is 75.9 Mb/s */
-			bitRate = 75900000UL;
+		bit_rate = max_bit_rate;
+		if (bit_rate > 75900000UL) {	/* max is 75.9 Mb/s */
+			bit_rate = 75900000UL;
 		}
 		/* Rational DTO period:
 			dto_period = (Fsys / bitrate) - 2
 
-			Result should be floored,
+			result should be floored,
 			to make sure >= requested bitrate
 			*/
-		fecOcDtoPeriod = (u16) (((state->m_sysClockFreq)
-						* 1000) / bitRate);
-		if (fecOcDtoPeriod <= 2)
-			fecOcDtoPeriod = 0;
+		fec_oc_dto_period = (u16) (((state->m_sys_clock_freq)
+						* 1000) / bit_rate);
+		if (fec_oc_dto_period <= 2)
+			fec_oc_dto_period = 0;
 		else
-			fecOcDtoPeriod -= 2;
-		fecOcTmdIntUpdRate = 8;
+			fec_oc_dto_period -= 2;
+		fec_oc_tmd_int_upd_rate = 8;
 	} else {
-		/* (commonAttr->staticCLK == false) => dynamic mode */
-		fecOcDtoMode = FEC_OC_DTO_MODE_DYNAMIC__M;
-		fecOcFctMode = FEC_OC_FCT_MODE__PRE;
-		fecOcTmdIntUpdRate = 5;
+		/* (commonAttr->static_clk == false) => dynamic mode */
+		fec_oc_dto_mode = FEC_OC_DTO_MODE_DYNAMIC__M;
+		fec_oc_fct_mode = FEC_OC_FCT_MODE__PRE;
+		fec_oc_tmd_int_upd_rate = 5;
 	}
 
 	/* Write appropriate registers with requested configuration */
-	status = write16(state, FEC_OC_DTO_BURST_LEN__A, fecOcDtoBurstLen);
+	status = write16(state, FEC_OC_DTO_BURST_LEN__A, fec_oc_dto_burst_len);
 	if (status < 0)
 		goto error;
-	status = write16(state, FEC_OC_DTO_PERIOD__A, fecOcDtoPeriod);
+	status = write16(state, FEC_OC_DTO_PERIOD__A, fec_oc_dto_period);
 	if (status < 0)
 		goto error;
-	status = write16(state, FEC_OC_DTO_MODE__A, fecOcDtoMode);
+	status = write16(state, FEC_OC_DTO_MODE__A, fec_oc_dto_mode);
 	if (status < 0)
 		goto error;
-	status = write16(state, FEC_OC_FCT_MODE__A, fecOcFctMode);
+	status = write16(state, FEC_OC_FCT_MODE__A, fec_oc_fct_mode);
 	if (status < 0)
 		goto error;
-	status = write16(state, FEC_OC_MODE__A, fecOcRegMode);
+	status = write16(state, FEC_OC_MODE__A, fec_oc_reg_mode);
 	if (status < 0)
 		goto error;
-	status = write16(state, FEC_OC_IPR_MODE__A, fecOcRegIprMode);
+	status = write16(state, FEC_OC_IPR_MODE__A, fec_oc_reg_ipr_mode);
 	if (status < 0)
 		goto error;
 
 	/* Rate integration settings */
-	status = write32(state, FEC_OC_RCN_CTL_RATE_LO__A, fecOcRcnCtlRate);
+	status = write32(state, FEC_OC_RCN_CTL_RATE_LO__A, fec_oc_rcn_ctl_rate);
 	if (status < 0)
 		goto error;
-	status = write16(state, FEC_OC_TMD_INT_UPD_RATE__A, fecOcTmdIntUpdRate);
+	status = write16(state, FEC_OC_TMD_INT_UPD_RATE__A, fec_oc_tmd_int_upd_rate);
 	if (status < 0)
 		goto error;
-	status = write16(state, FEC_OC_TMD_MODE__A, fecOcTmdMode);
+	status = write16(state, FEC_OC_TMD_MODE__A, fec_oc_tmd_mode);
 error:
 	if (status < 0)
 		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
-static int MPEGTSConfigurePolarity(struct drxk_state *state)
+static int mpegts_configure_polarity(struct drxk_state *state)
 {
-	u16 fecOcRegIprInvert = 0;
+	u16 fec_oc_reg_ipr_invert = 0;
 
 	/* Data mask for the output data byte */
-	u16 InvertDataMask =
+	u16 invert_data_mask =
 	    FEC_OC_IPR_INVERT_MD7__M | FEC_OC_IPR_INVERT_MD6__M |
 	    FEC_OC_IPR_INVERT_MD5__M | FEC_OC_IPR_INVERT_MD4__M |
 	    FEC_OC_IPR_INVERT_MD3__M | FEC_OC_IPR_INVERT_MD2__M |
@@ -2107,40 +2107,40 @@ static int MPEGTSConfigurePolarity(struct drxk_state *state)
 	dprintk(1, "\n");
 
 	/* Control selective inversion of output bits */
-	fecOcRegIprInvert &= (~(InvertDataMask));
-	if (state->m_invertDATA == true)
-		fecOcRegIprInvert |= InvertDataMask;
-	fecOcRegIprInvert &= (~(FEC_OC_IPR_INVERT_MERR__M));
-	if (state->m_invertERR == true)
-		fecOcRegIprInvert |= FEC_OC_IPR_INVERT_MERR__M;
-	fecOcRegIprInvert &= (~(FEC_OC_IPR_INVERT_MSTRT__M));
-	if (state->m_invertSTR == true)
-		fecOcRegIprInvert |= FEC_OC_IPR_INVERT_MSTRT__M;
-	fecOcRegIprInvert &= (~(FEC_OC_IPR_INVERT_MVAL__M));
-	if (state->m_invertVAL == true)
-		fecOcRegIprInvert |= FEC_OC_IPR_INVERT_MVAL__M;
-	fecOcRegIprInvert &= (~(FEC_OC_IPR_INVERT_MCLK__M));
-	if (state->m_invertCLK == true)
-		fecOcRegIprInvert |= FEC_OC_IPR_INVERT_MCLK__M;
-
-	return write16(state, FEC_OC_IPR_INVERT__A, fecOcRegIprInvert);
+	fec_oc_reg_ipr_invert &= (~(invert_data_mask));
+	if (state->m_invert_data == true)
+		fec_oc_reg_ipr_invert |= invert_data_mask;
+	fec_oc_reg_ipr_invert &= (~(FEC_OC_IPR_INVERT_MERR__M));
+	if (state->m_invert_err == true)
+		fec_oc_reg_ipr_invert |= FEC_OC_IPR_INVERT_MERR__M;
+	fec_oc_reg_ipr_invert &= (~(FEC_OC_IPR_INVERT_MSTRT__M));
+	if (state->m_invert_str == true)
+		fec_oc_reg_ipr_invert |= FEC_OC_IPR_INVERT_MSTRT__M;
+	fec_oc_reg_ipr_invert &= (~(FEC_OC_IPR_INVERT_MVAL__M));
+	if (state->m_invert_val == true)
+		fec_oc_reg_ipr_invert |= FEC_OC_IPR_INVERT_MVAL__M;
+	fec_oc_reg_ipr_invert &= (~(FEC_OC_IPR_INVERT_MCLK__M));
+	if (state->m_invert_clk == true)
+		fec_oc_reg_ipr_invert |= FEC_OC_IPR_INVERT_MCLK__M;
+
+	return write16(state, FEC_OC_IPR_INVERT__A, fec_oc_reg_ipr_invert);
 }
 
 #define   SCU_RAM_AGC_KI_INV_RF_POL__M 0x4000
 
-static int SetAgcRf(struct drxk_state *state,
-		    struct SCfgAgc *pAgcCfg, bool isDTV)
+static int set_agc_rf(struct drxk_state *state,
+		    struct s_cfg_agc *p_agc_cfg, bool is_dtv)
 {
 	int status = -EINVAL;
 	u16 data = 0;
-	struct SCfgAgc *pIfAgcSettings;
+	struct s_cfg_agc *p_if_agc_settings;
 
 	dprintk(1, "\n");
 
-	if (pAgcCfg == NULL)
+	if (p_agc_cfg == NULL)
 		goto error;
 
-	switch (pAgcCfg->ctrlMode) {
+	switch (p_agc_cfg->ctrl_mode) {
 	case DRXK_AGC_CTRL_AUTO:
 		/* Enable RF AGC DAC */
 		status = read16(state, IQM_AF_STDBY__A, &data);
@@ -2158,7 +2158,7 @@ static int SetAgcRf(struct drxk_state *state,
 		data &= ~SCU_RAM_AGC_CONFIG_DISABLE_RF_AGC__M;
 
 		/* Polarity */
-		if (state->m_RfAgcPol)
+		if (state->m_rf_agc_pol)
 			data |= SCU_RAM_AGC_CONFIG_INV_RF_POL__M;
 		else
 			data &= ~SCU_RAM_AGC_CONFIG_INV_RF_POL__M;
@@ -2172,7 +2172,7 @@ static int SetAgcRf(struct drxk_state *state,
 			goto error;
 
 		data &= ~SCU_RAM_AGC_KI_RED_RAGC_RED__M;
-		data |= (~(pAgcCfg->speed <<
+		data |= (~(p_agc_cfg->speed <<
 				SCU_RAM_AGC_KI_RED_RAGC_RED__B)
 				& SCU_RAM_AGC_KI_RED_RAGC_RED__M);
 
@@ -2180,30 +2180,30 @@ static int SetAgcRf(struct drxk_state *state,
 		if (status < 0)
 			goto error;
 
-		if (IsDVBT(state))
-			pIfAgcSettings = &state->m_dvbtIfAgcCfg;
-		else if (IsQAM(state))
-			pIfAgcSettings = &state->m_qamIfAgcCfg;
+		if (is_dvbt(state))
+			p_if_agc_settings = &state->m_dvbt_if_agc_cfg;
+		else if (is_qam(state))
+			p_if_agc_settings = &state->m_qam_if_agc_cfg;
 		else
-			pIfAgcSettings = &state->m_atvIfAgcCfg;
-		if (pIfAgcSettings == NULL) {
+			p_if_agc_settings = &state->m_atv_if_agc_cfg;
+		if (p_if_agc_settings == NULL) {
 			status = -EINVAL;
 			goto error;
 		}
 
 		/* Set TOP, only if IF-AGC is in AUTO mode */
-		if (pIfAgcSettings->ctrlMode == DRXK_AGC_CTRL_AUTO)
-			status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A, pAgcCfg->top);
+		if (p_if_agc_settings->ctrl_mode == DRXK_AGC_CTRL_AUTO)
+			status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A, p_agc_cfg->top);
 			if (status < 0)
 				goto error;
 
 		/* Cut-Off current */
-		status = write16(state, SCU_RAM_AGC_RF_IACCU_HI_CO__A, pAgcCfg->cutOffCurrent);
+		status = write16(state, SCU_RAM_AGC_RF_IACCU_HI_CO__A, p_agc_cfg->cut_off_current);
 		if (status < 0)
 			goto error;
 
 		/* Max. output level */
-		status = write16(state, SCU_RAM_AGC_RF_MAX__A, pAgcCfg->maxOutputLevel);
+		status = write16(state, SCU_RAM_AGC_RF_MAX__A, p_agc_cfg->max_output_level);
 		if (status < 0)
 			goto error;
 
@@ -2224,7 +2224,7 @@ static int SetAgcRf(struct drxk_state *state,
 		if (status < 0)
 			goto error;
 		data |= SCU_RAM_AGC_CONFIG_DISABLE_RF_AGC__M;
-		if (state->m_RfAgcPol)
+		if (state->m_rf_agc_pol)
 			data |= SCU_RAM_AGC_CONFIG_INV_RF_POL__M;
 		else
 			data &= ~SCU_RAM_AGC_CONFIG_INV_RF_POL__M;
@@ -2238,7 +2238,7 @@ static int SetAgcRf(struct drxk_state *state,
 			goto error;
 
 		/* Write value to output pin */
-		status = write16(state, SCU_RAM_AGC_RF_IACCU_HI__A, pAgcCfg->outputLevel);
+		status = write16(state, SCU_RAM_AGC_RF_IACCU_HI__A, p_agc_cfg->output_level);
 		if (status < 0)
 			goto error;
 		break;
@@ -2275,16 +2275,16 @@ error:
 
 #define SCU_RAM_AGC_KI_INV_IF_POL__M 0x2000
 
-static int SetAgcIf(struct drxk_state *state,
-		    struct SCfgAgc *pAgcCfg, bool isDTV)
+static int set_agc_if(struct drxk_state *state,
+		    struct s_cfg_agc *p_agc_cfg, bool is_dtv)
 {
 	u16 data = 0;
 	int status = 0;
-	struct SCfgAgc *pRfAgcSettings;
+	struct s_cfg_agc *p_rf_agc_settings;
 
 	dprintk(1, "\n");
 
-	switch (pAgcCfg->ctrlMode) {
+	switch (p_agc_cfg->ctrl_mode) {
 	case DRXK_AGC_CTRL_AUTO:
 
 		/* Enable IF AGC DAC */
@@ -2304,7 +2304,7 @@ static int SetAgcIf(struct drxk_state *state,
 		data &= ~SCU_RAM_AGC_CONFIG_DISABLE_IF_AGC__M;
 
 		/* Polarity */
-		if (state->m_IfAgcPol)
+		if (state->m_if_agc_pol)
 			data |= SCU_RAM_AGC_CONFIG_INV_IF_POL__M;
 		else
 			data &= ~SCU_RAM_AGC_CONFIG_INV_IF_POL__M;
@@ -2317,7 +2317,7 @@ static int SetAgcIf(struct drxk_state *state,
 		if (status < 0)
 			goto error;
 		data &= ~SCU_RAM_AGC_KI_RED_IAGC_RED__M;
-		data |= (~(pAgcCfg->speed <<
+		data |= (~(p_agc_cfg->speed <<
 				SCU_RAM_AGC_KI_RED_IAGC_RED__B)
 				& SCU_RAM_AGC_KI_RED_IAGC_RED__M);
 
@@ -2325,14 +2325,14 @@ static int SetAgcIf(struct drxk_state *state,
 		if (status < 0)
 			goto error;
 
-		if (IsQAM(state))
-			pRfAgcSettings = &state->m_qamRfAgcCfg;
+		if (is_qam(state))
+			p_rf_agc_settings = &state->m_qam_rf_agc_cfg;
 		else
-			pRfAgcSettings = &state->m_atvRfAgcCfg;
-		if (pRfAgcSettings == NULL)
+			p_rf_agc_settings = &state->m_atv_rf_agc_cfg;
+		if (p_rf_agc_settings == NULL)
 			return -1;
 		/* Restore TOP */
-		status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A, pRfAgcSettings->top);
+		status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A, p_rf_agc_settings->top);
 		if (status < 0)
 			goto error;
 		break;
@@ -2356,7 +2356,7 @@ static int SetAgcIf(struct drxk_state *state,
 		data |= SCU_RAM_AGC_CONFIG_DISABLE_IF_AGC__M;
 
 		/* Polarity */
-		if (state->m_IfAgcPol)
+		if (state->m_if_agc_pol)
 			data |= SCU_RAM_AGC_CONFIG_INV_IF_POL__M;
 		else
 			data &= ~SCU_RAM_AGC_CONFIG_INV_IF_POL__M;
@@ -2365,7 +2365,7 @@ static int SetAgcIf(struct drxk_state *state,
 			goto error;
 
 		/* Write value to output pin */
-		status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A, pAgcCfg->outputLevel);
+		status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A, p_agc_cfg->output_level);
 		if (status < 0)
 			goto error;
 		break;
@@ -2390,33 +2390,33 @@ static int SetAgcIf(struct drxk_state *state,
 		if (status < 0)
 			goto error;
 		break;
-	}		/* switch (agcSettingsIf->ctrlMode) */
+	}		/* switch (agcSettingsIf->ctrl_mode) */
 
 	/* always set the top to support
 		configurations without if-loop */
-	status = write16(state, SCU_RAM_AGC_INGAIN_TGT_MIN__A, pAgcCfg->top);
+	status = write16(state, SCU_RAM_AGC_INGAIN_TGT_MIN__A, p_agc_cfg->top);
 error:
 	if (status < 0)
 		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
-static int GetQAMSignalToNoise(struct drxk_state *state,
-			       s32 *pSignalToNoise)
+static int get_qam_signal_to_noise(struct drxk_state *state,
+			       s32 *p_signal_to_noise)
 {
 	int status = 0;
-	u16 qamSlErrPower = 0;	/* accum. error between
+	u16 qam_sl_err_power = 0;	/* accum. error between
 					raw and sliced symbols */
-	u32 qamSlSigPower = 0;	/* used for MER, depends of
+	u32 qam_sl_sig_power = 0;	/* used for MER, depends of
 					QAM modulation */
-	u32 qamSlMer = 0;	/* QAM MER */
+	u32 qam_sl_mer = 0;	/* QAM MER */
 
 	dprintk(1, "\n");
 
 	/* MER calculation */
 
 	/* get the register value needed for MER */
-	status = read16(state, QAM_SL_ERR_POWER__A, &qamSlErrPower);
+	status = read16(state, QAM_SL_ERR_POWER__A, &qam_sl_err_power);
 	if (status < 0) {
 		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 		return -EINVAL;
@@ -2424,124 +2424,124 @@ static int GetQAMSignalToNoise(struct drxk_state *state,
 
 	switch (state->props.modulation) {
 	case QAM_16:
-		qamSlSigPower = DRXK_QAM_SL_SIG_POWER_QAM16 << 2;
+		qam_sl_sig_power = DRXK_QAM_SL_SIG_POWER_QAM16 << 2;
 		break;
 	case QAM_32:
-		qamSlSigPower = DRXK_QAM_SL_SIG_POWER_QAM32 << 2;
+		qam_sl_sig_power = DRXK_QAM_SL_SIG_POWER_QAM32 << 2;
 		break;
 	case QAM_64:
-		qamSlSigPower = DRXK_QAM_SL_SIG_POWER_QAM64 << 2;
+		qam_sl_sig_power = DRXK_QAM_SL_SIG_POWER_QAM64 << 2;
 		break;
 	case QAM_128:
-		qamSlSigPower = DRXK_QAM_SL_SIG_POWER_QAM128 << 2;
+		qam_sl_sig_power = DRXK_QAM_SL_SIG_POWER_QAM128 << 2;
 		break;
 	default:
 	case QAM_256:
-		qamSlSigPower = DRXK_QAM_SL_SIG_POWER_QAM256 << 2;
+		qam_sl_sig_power = DRXK_QAM_SL_SIG_POWER_QAM256 << 2;
 		break;
 	}
 
-	if (qamSlErrPower > 0) {
-		qamSlMer = log10times100(qamSlSigPower) -
-			log10times100((u32) qamSlErrPower);
+	if (qam_sl_err_power > 0) {
+		qam_sl_mer = log10times100(qam_sl_sig_power) -
+			log10times100((u32) qam_sl_err_power);
 	}
-	*pSignalToNoise = qamSlMer;
+	*p_signal_to_noise = qam_sl_mer;
 
 	return status;
 }
 
-static int GetDVBTSignalToNoise(struct drxk_state *state,
-				s32 *pSignalToNoise)
+static int get_dvbt_signal_to_noise(struct drxk_state *state,
+				s32 *p_signal_to_noise)
 {
 	int status;
-	u16 regData = 0;
-	u32 EqRegTdSqrErrI = 0;
-	u32 EqRegTdSqrErrQ = 0;
-	u16 EqRegTdSqrErrExp = 0;
-	u16 EqRegTdTpsPwrOfs = 0;
-	u16 EqRegTdReqSmbCnt = 0;
-	u32 tpsCnt = 0;
-	u32 SqrErrIQ = 0;
+	u16 reg_data = 0;
+	u32 eq_reg_td_sqr_err_i = 0;
+	u32 eq_reg_td_sqr_err_q = 0;
+	u16 eq_reg_td_sqr_err_exp = 0;
+	u16 eq_reg_td_tps_pwr_ofs = 0;
+	u16 eq_reg_td_req_smb_cnt = 0;
+	u32 tps_cnt = 0;
+	u32 sqr_err_iq = 0;
 	u32 a = 0;
 	u32 b = 0;
 	u32 c = 0;
-	u32 iMER = 0;
-	u16 transmissionParams = 0;
+	u32 i_mer = 0;
+	u16 transmission_params = 0;
 
 	dprintk(1, "\n");
 
-	status = read16(state, OFDM_EQ_TOP_TD_TPS_PWR_OFS__A, &EqRegTdTpsPwrOfs);
+	status = read16(state, OFDM_EQ_TOP_TD_TPS_PWR_OFS__A, &eq_reg_td_tps_pwr_ofs);
 	if (status < 0)
 		goto error;
-	status = read16(state, OFDM_EQ_TOP_TD_REQ_SMB_CNT__A, &EqRegTdReqSmbCnt);
+	status = read16(state, OFDM_EQ_TOP_TD_REQ_SMB_CNT__A, &eq_reg_td_req_smb_cnt);
 	if (status < 0)
 		goto error;
-	status = read16(state, OFDM_EQ_TOP_TD_SQR_ERR_EXP__A, &EqRegTdSqrErrExp);
+	status = read16(state, OFDM_EQ_TOP_TD_SQR_ERR_EXP__A, &eq_reg_td_sqr_err_exp);
 	if (status < 0)
 		goto error;
-	status = read16(state, OFDM_EQ_TOP_TD_SQR_ERR_I__A, &regData);
+	status = read16(state, OFDM_EQ_TOP_TD_SQR_ERR_I__A, &reg_data);
 	if (status < 0)
 		goto error;
 	/* Extend SQR_ERR_I operational range */
-	EqRegTdSqrErrI = (u32) regData;
-	if ((EqRegTdSqrErrExp > 11) &&
-		(EqRegTdSqrErrI < 0x00000FFFUL)) {
-		EqRegTdSqrErrI += 0x00010000UL;
+	eq_reg_td_sqr_err_i = (u32) reg_data;
+	if ((eq_reg_td_sqr_err_exp > 11) &&
+		(eq_reg_td_sqr_err_i < 0x00000FFFUL)) {
+		eq_reg_td_sqr_err_i += 0x00010000UL;
 	}
-	status = read16(state, OFDM_EQ_TOP_TD_SQR_ERR_Q__A, &regData);
+	status = read16(state, OFDM_EQ_TOP_TD_SQR_ERR_Q__A, &reg_data);
 	if (status < 0)
 		goto error;
 	/* Extend SQR_ERR_Q operational range */
-	EqRegTdSqrErrQ = (u32) regData;
-	if ((EqRegTdSqrErrExp > 11) &&
-		(EqRegTdSqrErrQ < 0x00000FFFUL))
-		EqRegTdSqrErrQ += 0x00010000UL;
+	eq_reg_td_sqr_err_q = (u32) reg_data;
+	if ((eq_reg_td_sqr_err_exp > 11) &&
+		(eq_reg_td_sqr_err_q < 0x00000FFFUL))
+		eq_reg_td_sqr_err_q += 0x00010000UL;
 
-	status = read16(state, OFDM_SC_RA_RAM_OP_PARAM__A, &transmissionParams);
+	status = read16(state, OFDM_SC_RA_RAM_OP_PARAM__A, &transmission_params);
 	if (status < 0)
 		goto error;
 
 	/* Check input data for MER */
 
 	/* MER calculation (in 0.1 dB) without math.h */
-	if ((EqRegTdTpsPwrOfs == 0) || (EqRegTdReqSmbCnt == 0))
-		iMER = 0;
-	else if ((EqRegTdSqrErrI + EqRegTdSqrErrQ) == 0) {
+	if ((eq_reg_td_tps_pwr_ofs == 0) || (eq_reg_td_req_smb_cnt == 0))
+		i_mer = 0;
+	else if ((eq_reg_td_sqr_err_i + eq_reg_td_sqr_err_q) == 0) {
 		/* No error at all, this must be the HW reset value
 			* Apparently no first measurement yet
 			* Set MER to 0.0 */
-		iMER = 0;
+		i_mer = 0;
 	} else {
-		SqrErrIQ = (EqRegTdSqrErrI + EqRegTdSqrErrQ) <<
-			EqRegTdSqrErrExp;
-		if ((transmissionParams &
+		sqr_err_iq = (eq_reg_td_sqr_err_i + eq_reg_td_sqr_err_q) <<
+			eq_reg_td_sqr_err_exp;
+		if ((transmission_params &
 			OFDM_SC_RA_RAM_OP_PARAM_MODE__M)
 			== OFDM_SC_RA_RAM_OP_PARAM_MODE_2K)
-			tpsCnt = 17;
+			tps_cnt = 17;
 		else
-			tpsCnt = 68;
+			tps_cnt = 68;
 
 		/* IMER = 100 * log10 (x)
-			where x = (EqRegTdTpsPwrOfs^2 *
-			EqRegTdReqSmbCnt * tpsCnt)/SqrErrIQ
+			where x = (eq_reg_td_tps_pwr_ofs^2 *
+			eq_reg_td_req_smb_cnt * tps_cnt)/sqr_err_iq
 
 			=> IMER = a + b -c
-			where a = 100 * log10 (EqRegTdTpsPwrOfs^2)
-			b = 100 * log10 (EqRegTdReqSmbCnt * tpsCnt)
-			c = 100 * log10 (SqrErrIQ)
+			where a = 100 * log10 (eq_reg_td_tps_pwr_ofs^2)
+			b = 100 * log10 (eq_reg_td_req_smb_cnt * tps_cnt)
+			c = 100 * log10 (sqr_err_iq)
 			*/
 
 		/* log(x) x = 9bits * 9bits->18 bits  */
-		a = log10times100(EqRegTdTpsPwrOfs *
-					EqRegTdTpsPwrOfs);
+		a = log10times100(eq_reg_td_tps_pwr_ofs *
+					eq_reg_td_tps_pwr_ofs);
 		/* log(x) x = 16bits * 7bits->23 bits  */
-		b = log10times100(EqRegTdReqSmbCnt * tpsCnt);
+		b = log10times100(eq_reg_td_req_smb_cnt * tps_cnt);
 		/* log(x) x = (16bits + 16bits) << 15 ->32 bits  */
-		c = log10times100(SqrErrIQ);
+		c = log10times100(sqr_err_iq);
 
-		iMER = a + b - c;
+		i_mer = a + b - c;
 	}
-	*pSignalToNoise = iMER;
+	*p_signal_to_noise = i_mer;
 
 error:
 	if (status < 0)
@@ -2549,17 +2549,17 @@ error:
 	return status;
 }
 
-static int GetSignalToNoise(struct drxk_state *state, s32 *pSignalToNoise)
+static int get_signal_to_noise(struct drxk_state *state, s32 *p_signal_to_noise)
 {
 	dprintk(1, "\n");
 
-	*pSignalToNoise = 0;
-	switch (state->m_OperationMode) {
+	*p_signal_to_noise = 0;
+	switch (state->m_operation_mode) {
 	case OM_DVBT:
-		return GetDVBTSignalToNoise(state, pSignalToNoise);
+		return get_dvbt_signal_to_noise(state, p_signal_to_noise);
 	case OM_QAM_ITU_A:
 	case OM_QAM_ITU_C:
-		return GetQAMSignalToNoise(state, pSignalToNoise);
+		return get_qam_signal_to_noise(state, p_signal_to_noise);
 	default:
 		break;
 	}
@@ -2567,7 +2567,7 @@ static int GetSignalToNoise(struct drxk_state *state, s32 *pSignalToNoise)
 }
 
 #if 0
-static int GetDVBTQuality(struct drxk_state *state, s32 *pQuality)
+static int get_dvbt_quality(struct drxk_state *state, s32 *p_quality)
 {
 	/* SNR Values for quasi errorfree reception rom Nordig 2.2 */
 	int status = 0;
@@ -2592,102 +2592,102 @@ static int GetDVBTQuality(struct drxk_state *state, s32 *pQuality)
 		225,		/* 64-QAM 7/8 */
 	};
 
-	*pQuality = 0;
+	*p_quality = 0;
 
 	do {
-		s32 SignalToNoise = 0;
-		u16 Constellation = 0;
-		u16 CodeRate = 0;
-		u32 SignalToNoiseRel;
-		u32 BERQuality;
+		s32 signal_to_noise = 0;
+		u16 constellation = 0;
+		u16 code_rate = 0;
+		u32 signal_to_noise_rel;
+		u32 ber_quality;
 
-		status = GetDVBTSignalToNoise(state, &SignalToNoise);
+		status = get_dvbt_signal_to_noise(state, &signal_to_noise);
 		if (status < 0)
 			break;
-		status = read16(state, OFDM_EQ_TOP_TD_TPS_CONST__A, &Constellation);
+		status = read16(state, OFDM_EQ_TOP_TD_TPS_CONST__A, &constellation);
 		if (status < 0)
 			break;
-		Constellation &= OFDM_EQ_TOP_TD_TPS_CONST__M;
+		constellation &= OFDM_EQ_TOP_TD_TPS_CONST__M;
 
-		status = read16(state, OFDM_EQ_TOP_TD_TPS_CODE_HP__A, &CodeRate);
+		status = read16(state, OFDM_EQ_TOP_TD_TPS_CODE_HP__A, &code_rate);
 		if (status < 0)
 			break;
-		CodeRate &= OFDM_EQ_TOP_TD_TPS_CODE_HP__M;
+		code_rate &= OFDM_EQ_TOP_TD_TPS_CODE_HP__M;
 
-		if (Constellation > OFDM_EQ_TOP_TD_TPS_CONST_64QAM ||
-		    CodeRate > OFDM_EQ_TOP_TD_TPS_CODE_LP_7_8)
+		if (constellation > OFDM_EQ_TOP_TD_TPS_CONST_64QAM ||
+		    code_rate > OFDM_EQ_TOP_TD_TPS_CODE_LP_7_8)
 			break;
-		SignalToNoiseRel = SignalToNoise -
-		    QE_SN[Constellation * 5 + CodeRate];
-		BERQuality = 100;
-
-		if (SignalToNoiseRel < -70)
-			*pQuality = 0;
-		else if (SignalToNoiseRel < 30)
-			*pQuality = ((SignalToNoiseRel + 70) *
-				     BERQuality) / 100;
+		signal_to_noise_rel = signal_to_noise -
+		    QE_SN[constellation * 5 + code_rate];
+		ber_quality = 100;
+
+		if (signal_to_noise_rel < -70)
+			*p_quality = 0;
+		else if (signal_to_noise_rel < 30)
+			*p_quality = ((signal_to_noise_rel + 70) *
+				     ber_quality) / 100;
 		else
-			*pQuality = BERQuality;
+			*p_quality = ber_quality;
 	} while (0);
 	return 0;
 };
 
-static int GetDVBCQuality(struct drxk_state *state, s32 *pQuality)
+static int get_dvbc_quality(struct drxk_state *state, s32 *p_quality)
 {
 	int status = 0;
-	*pQuality = 0;
+	*p_quality = 0;
 
 	dprintk(1, "\n");
 
 	do {
-		u32 SignalToNoise = 0;
-		u32 BERQuality = 100;
-		u32 SignalToNoiseRel = 0;
+		u32 signal_to_noise = 0;
+		u32 ber_quality = 100;
+		u32 signal_to_noise_rel = 0;
 
-		status = GetQAMSignalToNoise(state, &SignalToNoise);
+		status = get_qam_signal_to_noise(state, &signal_to_noise);
 		if (status < 0)
 			break;
 
 		switch (state->props.modulation) {
 		case QAM_16:
-			SignalToNoiseRel = SignalToNoise - 200;
+			signal_to_noise_rel = signal_to_noise - 200;
 			break;
 		case QAM_32:
-			SignalToNoiseRel = SignalToNoise - 230;
+			signal_to_noise_rel = signal_to_noise - 230;
 			break;	/* Not in NorDig */
 		case QAM_64:
-			SignalToNoiseRel = SignalToNoise - 260;
+			signal_to_noise_rel = signal_to_noise - 260;
 			break;
 		case QAM_128:
-			SignalToNoiseRel = SignalToNoise - 290;
+			signal_to_noise_rel = signal_to_noise - 290;
 			break;
 		default:
 		case QAM_256:
-			SignalToNoiseRel = SignalToNoise - 320;
+			signal_to_noise_rel = signal_to_noise - 320;
 			break;
 		}
 
-		if (SignalToNoiseRel < -70)
-			*pQuality = 0;
-		else if (SignalToNoiseRel < 30)
-			*pQuality = ((SignalToNoiseRel + 70) *
-				     BERQuality) / 100;
+		if (signal_to_noise_rel < -70)
+			*p_quality = 0;
+		else if (signal_to_noise_rel < 30)
+			*p_quality = ((signal_to_noise_rel + 70) *
+				     ber_quality) / 100;
 		else
-			*pQuality = BERQuality;
+			*p_quality = ber_quality;
 	} while (0);
 
 	return status;
 }
 
-static int GetQuality(struct drxk_state *state, s32 *pQuality)
+static int get_quality(struct drxk_state *state, s32 *p_quality)
 {
 	dprintk(1, "\n");
 
-	switch (state->m_OperationMode) {
+	switch (state->m_operation_mode) {
 	case OM_DVBT:
-		return GetDVBTQuality(state, pQuality);
+		return get_dvbt_quality(state, p_quality);
 	case OM_QAM_ITU_A:
-		return GetDVBCQuality(state, pQuality);
+		return get_dvbc_quality(state, p_quality);
 	default:
 		break;
 	}
@@ -2709,15 +2709,15 @@ static int GetQuality(struct drxk_state *state, s32 *pQuality)
 #define DRXDAP_FASI_ADDR2BANK(addr)   (((addr) >> 16) & 0x3F)
 #define DRXDAP_FASI_ADDR2OFFSET(addr) ((addr) & 0x7FFF)
 
-static int ConfigureI2CBridge(struct drxk_state *state, bool bEnableBridge)
+static int ConfigureI2CBridge(struct drxk_state *state, bool b_enable_bridge)
 {
 	int status = -EINVAL;
 
 	dprintk(1, "\n");
 
-	if (state->m_DrxkState == DRXK_UNINITIALIZED)
+	if (state->m_drxk_state == DRXK_UNINITIALIZED)
 		return 0;
-	if (state->m_DrxkState == DRXK_POWERED_DOWN)
+	if (state->m_drxk_state == DRXK_POWERED_DOWN)
 		goto error;
 
 	if (state->no_i2c_bridge)
@@ -2726,7 +2726,7 @@ static int ConfigureI2CBridge(struct drxk_state *state, bool bEnableBridge)
 	status = write16(state, SIO_HI_RA_RAM_PAR_1__A, SIO_HI_RA_RAM_PAR_1_PAR1_SEC_KEY);
 	if (status < 0)
 		goto error;
-	if (bEnableBridge) {
+	if (b_enable_bridge) {
 		status = write16(state, SIO_HI_RA_RAM_PAR_2__A, SIO_HI_RA_RAM_PAR_2_BRD_CFG_CLOSED);
 		if (status < 0)
 			goto error;
@@ -2736,7 +2736,7 @@ static int ConfigureI2CBridge(struct drxk_state *state, bool bEnableBridge)
 			goto error;
 	}
 
-	status = HI_Command(state, SIO_HI_RA_RAM_CMD_BRDCTRL, 0);
+	status = hi_command(state, SIO_HI_RA_RAM_CMD_BRDCTRL, 0);
 
 error:
 	if (status < 0)
@@ -2744,30 +2744,30 @@ error:
 	return status;
 }
 
-static int SetPreSaw(struct drxk_state *state,
-		     struct SCfgPreSaw *pPreSawCfg)
+static int set_pre_saw(struct drxk_state *state,
+		     struct s_cfg_pre_saw *p_pre_saw_cfg)
 {
 	int status = -EINVAL;
 
 	dprintk(1, "\n");
 
-	if ((pPreSawCfg == NULL)
-	    || (pPreSawCfg->reference > IQM_AF_PDREF__M))
+	if ((p_pre_saw_cfg == NULL)
+	    || (p_pre_saw_cfg->reference > IQM_AF_PDREF__M))
 		goto error;
 
-	status = write16(state, IQM_AF_PDREF__A, pPreSawCfg->reference);
+	status = write16(state, IQM_AF_PDREF__A, p_pre_saw_cfg->reference);
 error:
 	if (status < 0)
 		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
-static int BLDirectCmd(struct drxk_state *state, u32 targetAddr,
-		       u16 romOffset, u16 nrOfElements, u32 timeOut)
+static int bl_direct_cmd(struct drxk_state *state, u32 target_addr,
+		       u16 rom_offset, u16 nr_of_elements, u32 time_out)
 {
-	u16 blStatus = 0;
-	u16 offset = (u16) ((targetAddr >> 0) & 0x00FFFF);
-	u16 blockbank = (u16) ((targetAddr >> 16) & 0x000FFF);
+	u16 bl_status = 0;
+	u16 offset = (u16) ((target_addr >> 0) & 0x00FFFF);
+	u16 blockbank = (u16) ((target_addr >> 16) & 0x000FFF);
 	int status;
 	unsigned long end;
 
@@ -2783,23 +2783,23 @@ static int BLDirectCmd(struct drxk_state *state, u32 targetAddr,
 	status = write16(state, SIO_BL_TGT_ADDR__A, offset);
 	if (status < 0)
 		goto error;
-	status = write16(state, SIO_BL_SRC_ADDR__A, romOffset);
+	status = write16(state, SIO_BL_SRC_ADDR__A, rom_offset);
 	if (status < 0)
 		goto error;
-	status = write16(state, SIO_BL_SRC_LEN__A, nrOfElements);
+	status = write16(state, SIO_BL_SRC_LEN__A, nr_of_elements);
 	if (status < 0)
 		goto error;
 	status = write16(state, SIO_BL_ENABLE__A, SIO_BL_ENABLE_ON);
 	if (status < 0)
 		goto error;
 
-	end = jiffies + msecs_to_jiffies(timeOut);
+	end = jiffies + msecs_to_jiffies(time_out);
 	do {
-		status = read16(state, SIO_BL_STATUS__A, &blStatus);
+		status = read16(state, SIO_BL_STATUS__A, &bl_status);
 		if (status < 0)
 			goto error;
-	} while ((blStatus == 0x1) && time_is_after_jiffies(end));
-	if (blStatus == 0x1) {
+	} while ((bl_status == 0x1) && time_is_after_jiffies(end));
+	if (bl_status == 0x1) {
 		printk(KERN_ERR "drxk: SIO not ready\n");
 		status = -EINVAL;
 		goto error2;
@@ -2813,14 +2813,14 @@ error2:
 
 }
 
-static int ADCSyncMeasurement(struct drxk_state *state, u16 *count)
+static int adc_sync_measurement(struct drxk_state *state, u16 *count)
 {
 	u16 data = 0;
 	int status;
 
 	dprintk(1, "\n");
 
-	/* Start measurement */
+	/* start measurement */
 	status = write16(state, IQM_AF_COMM_EXEC__A, IQM_AF_COMM_EXEC_ACTIVE);
 	if (status < 0)
 		goto error;
@@ -2851,38 +2851,38 @@ error:
 	return status;
 }
 
-static int ADCSynchronization(struct drxk_state *state)
+static int adc_synchronization(struct drxk_state *state)
 {
 	u16 count = 0;
 	int status;
 
 	dprintk(1, "\n");
 
-	status = ADCSyncMeasurement(state, &count);
+	status = adc_sync_measurement(state, &count);
 	if (status < 0)
 		goto error;
 
 	if (count == 1) {
 		/* Try sampling on a diffrent edge */
-		u16 clkNeg = 0;
+		u16 clk_neg = 0;
 
-		status = read16(state, IQM_AF_CLKNEG__A, &clkNeg);
+		status = read16(state, IQM_AF_CLKNEG__A, &clk_neg);
 		if (status < 0)
 			goto error;
-		if ((clkNeg & IQM_AF_CLKNEG_CLKNEGDATA__M) ==
+		if ((clk_neg & IQM_AF_CLKNEG_CLKNEGDATA__M) ==
 			IQM_AF_CLKNEG_CLKNEGDATA_CLK_ADC_DATA_POS) {
-			clkNeg &= (~(IQM_AF_CLKNEG_CLKNEGDATA__M));
-			clkNeg |=
+			clk_neg &= (~(IQM_AF_CLKNEG_CLKNEGDATA__M));
+			clk_neg |=
 				IQM_AF_CLKNEG_CLKNEGDATA_CLK_ADC_DATA_NEG;
 		} else {
-			clkNeg &= (~(IQM_AF_CLKNEG_CLKNEGDATA__M));
-			clkNeg |=
+			clk_neg &= (~(IQM_AF_CLKNEG_CLKNEGDATA__M));
+			clk_neg |=
 				IQM_AF_CLKNEG_CLKNEGDATA_CLK_ADC_DATA_POS;
 		}
-		status = write16(state, IQM_AF_CLKNEG__A, clkNeg);
+		status = write16(state, IQM_AF_CLKNEG__A, clk_neg);
 		if (status < 0)
 			goto error;
-		status = ADCSyncMeasurement(state, &count);
+		status = adc_sync_measurement(state, &count);
 		if (status < 0)
 			goto error;
 	}
@@ -2895,21 +2895,21 @@ error:
 	return status;
 }
 
-static int SetFrequencyShifter(struct drxk_state *state,
-			       u16 intermediateFreqkHz,
-			       s32 tunerFreqOffset, bool isDTV)
+static int set_frequency_shifter(struct drxk_state *state,
+			       u16 intermediate_freqk_hz,
+			       s32 tuner_freq_offset, bool is_dtv)
 {
-	bool selectPosImage = false;
-	u32 rfFreqResidual = tunerFreqOffset;
-	u32 fmFrequencyShift = 0;
-	bool tunerMirror = !state->m_bMirrorFreqSpect;
-	u32 adcFreq;
-	bool adcFlip;
+	bool select_pos_image = false;
+	u32 rf_freq_residual = tuner_freq_offset;
+	u32 fm_frequency_shift = 0;
+	bool tuner_mirror = !state->m_b_mirror_freq_spect;
+	u32 adc_freq;
+	bool adc_flip;
 	int status;
-	u32 ifFreqActual;
-	u32 samplingFrequency = (u32) (state->m_sysClockFreq / 3);
-	u32 frequencyShift;
-	bool imageToSelect;
+	u32 if_freq_actual;
+	u32 sampling_frequency = (u32) (state->m_sys_clock_freq / 3);
+	u32 frequency_shift;
+	bool image_to_select;
 
 	dprintk(1, "\n");
 
@@ -2917,121 +2917,121 @@ static int SetFrequencyShifter(struct drxk_state *state,
 	   Program frequency shifter
 	   No need to account for mirroring on RF
 	 */
-	if (isDTV) {
-		if ((state->m_OperationMode == OM_QAM_ITU_A) ||
-		    (state->m_OperationMode == OM_QAM_ITU_C) ||
-		    (state->m_OperationMode == OM_DVBT))
-			selectPosImage = true;
+	if (is_dtv) {
+		if ((state->m_operation_mode == OM_QAM_ITU_A) ||
+		    (state->m_operation_mode == OM_QAM_ITU_C) ||
+		    (state->m_operation_mode == OM_DVBT))
+			select_pos_image = true;
 		else
-			selectPosImage = false;
+			select_pos_image = false;
 	}
-	if (tunerMirror)
+	if (tuner_mirror)
 		/* tuner doesn't mirror */
-		ifFreqActual = intermediateFreqkHz +
-		    rfFreqResidual + fmFrequencyShift;
+		if_freq_actual = intermediate_freqk_hz +
+		    rf_freq_residual + fm_frequency_shift;
 	else
 		/* tuner mirrors */
-		ifFreqActual = intermediateFreqkHz -
-		    rfFreqResidual - fmFrequencyShift;
-	if (ifFreqActual > samplingFrequency / 2) {
+		if_freq_actual = intermediate_freqk_hz -
+		    rf_freq_residual - fm_frequency_shift;
+	if (if_freq_actual > sampling_frequency / 2) {
 		/* adc mirrors */
-		adcFreq = samplingFrequency - ifFreqActual;
-		adcFlip = true;
+		adc_freq = sampling_frequency - if_freq_actual;
+		adc_flip = true;
 	} else {
 		/* adc doesn't mirror */
-		adcFreq = ifFreqActual;
-		adcFlip = false;
+		adc_freq = if_freq_actual;
+		adc_flip = false;
 	}
 
-	frequencyShift = adcFreq;
-	imageToSelect = state->m_rfmirror ^ tunerMirror ^
-	    adcFlip ^ selectPosImage;
-	state->m_IqmFsRateOfs =
-	    Frac28a((frequencyShift), samplingFrequency);
+	frequency_shift = adc_freq;
+	image_to_select = state->m_rfmirror ^ tuner_mirror ^
+	    adc_flip ^ select_pos_image;
+	state->m_iqm_fs_rate_ofs =
+	    Frac28a((frequency_shift), sampling_frequency);
 
-	if (imageToSelect)
-		state->m_IqmFsRateOfs = ~state->m_IqmFsRateOfs + 1;
+	if (image_to_select)
+		state->m_iqm_fs_rate_ofs = ~state->m_iqm_fs_rate_ofs + 1;
 
 	/* Program frequency shifter with tuner offset compensation */
-	/* frequencyShift += tunerFreqOffset; TODO */
+	/* frequency_shift += tuner_freq_offset; TODO */
 	status = write32(state, IQM_FS_RATE_OFS_LO__A,
-			 state->m_IqmFsRateOfs);
+			 state->m_iqm_fs_rate_ofs);
 	if (status < 0)
 		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
-static int InitAGC(struct drxk_state *state, bool isDTV)
+static int init_agc(struct drxk_state *state, bool is_dtv)
 {
-	u16 ingainTgt = 0;
-	u16 ingainTgtMin = 0;
-	u16 ingainTgtMax = 0;
-	u16 clpCyclen = 0;
-	u16 clpSumMin = 0;
-	u16 clpDirTo = 0;
-	u16 snsSumMin = 0;
-	u16 snsSumMax = 0;
-	u16 clpSumMax = 0;
-	u16 snsDirTo = 0;
-	u16 kiInnergainMin = 0;
-	u16 ifIaccuHiTgt = 0;
-	u16 ifIaccuHiTgtMin = 0;
-	u16 ifIaccuHiTgtMax = 0;
+	u16 ingain_tgt = 0;
+	u16 ingain_tgt_min = 0;
+	u16 ingain_tgt_max = 0;
+	u16 clp_cyclen = 0;
+	u16 clp_sum_min = 0;
+	u16 clp_dir_to = 0;
+	u16 sns_sum_min = 0;
+	u16 sns_sum_max = 0;
+	u16 clp_sum_max = 0;
+	u16 sns_dir_to = 0;
+	u16 ki_innergain_min = 0;
+	u16 if_iaccu_hi_tgt = 0;
+	u16 if_iaccu_hi_tgt_min = 0;
+	u16 if_iaccu_hi_tgt_max = 0;
 	u16 data = 0;
-	u16 fastClpCtrlDelay = 0;
-	u16 clpCtrlMode = 0;
+	u16 fast_clp_ctrl_delay = 0;
+	u16 clp_ctrl_mode = 0;
 	int status = 0;
 
 	dprintk(1, "\n");
 
 	/* Common settings */
-	snsSumMax = 1023;
-	ifIaccuHiTgtMin = 2047;
-	clpCyclen = 500;
-	clpSumMax = 1023;
+	sns_sum_max = 1023;
+	if_iaccu_hi_tgt_min = 2047;
+	clp_cyclen = 500;
+	clp_sum_max = 1023;
 
 	/* AGCInit() not available for DVBT; init done in microcode */
-	if (!IsQAM(state)) {
-		printk(KERN_ERR "drxk: %s: mode %d is not DVB-C\n", __func__, state->m_OperationMode);
+	if (!is_qam(state)) {
+		printk(KERN_ERR "drxk: %s: mode %d is not DVB-C\n", __func__, state->m_operation_mode);
 		return -EINVAL;
 	}
 
 	/* FIXME: Analog TV AGC require different settings */
 
 	/* Standard specific settings */
-	clpSumMin = 8;
-	clpDirTo = (u16) -9;
-	clpCtrlMode = 0;
-	snsSumMin = 8;
-	snsDirTo = (u16) -9;
-	kiInnergainMin = (u16) -1030;
-	ifIaccuHiTgtMax = 0x2380;
-	ifIaccuHiTgt = 0x2380;
-	ingainTgtMin = 0x0511;
-	ingainTgt = 0x0511;
-	ingainTgtMax = 5119;
-	fastClpCtrlDelay = state->m_qamIfAgcCfg.FastClipCtrlDelay;
+	clp_sum_min = 8;
+	clp_dir_to = (u16) -9;
+	clp_ctrl_mode = 0;
+	sns_sum_min = 8;
+	sns_dir_to = (u16) -9;
+	ki_innergain_min = (u16) -1030;
+	if_iaccu_hi_tgt_max = 0x2380;
+	if_iaccu_hi_tgt = 0x2380;
+	ingain_tgt_min = 0x0511;
+	ingain_tgt = 0x0511;
+	ingain_tgt_max = 5119;
+	fast_clp_ctrl_delay = state->m_qam_if_agc_cfg.fast_clip_ctrl_delay;
 
-	status = write16(state, SCU_RAM_AGC_FAST_CLP_CTRL_DELAY__A, fastClpCtrlDelay);
+	status = write16(state, SCU_RAM_AGC_FAST_CLP_CTRL_DELAY__A, fast_clp_ctrl_delay);
 	if (status < 0)
 		goto error;
 
-	status = write16(state, SCU_RAM_AGC_CLP_CTRL_MODE__A, clpCtrlMode);
+	status = write16(state, SCU_RAM_AGC_CLP_CTRL_MODE__A, clp_ctrl_mode);
 	if (status < 0)
 		goto error;
-	status = write16(state, SCU_RAM_AGC_INGAIN_TGT__A, ingainTgt);
+	status = write16(state, SCU_RAM_AGC_INGAIN_TGT__A, ingain_tgt);
 	if (status < 0)
 		goto error;
-	status = write16(state, SCU_RAM_AGC_INGAIN_TGT_MIN__A, ingainTgtMin);
+	status = write16(state, SCU_RAM_AGC_INGAIN_TGT_MIN__A, ingain_tgt_min);
 	if (status < 0)
 		goto error;
-	status = write16(state, SCU_RAM_AGC_INGAIN_TGT_MAX__A, ingainTgtMax);
+	status = write16(state, SCU_RAM_AGC_INGAIN_TGT_MAX__A, ingain_tgt_max);
 	if (status < 0)
 		goto error;
-	status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MIN__A, ifIaccuHiTgtMin);
+	status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MIN__A, if_iaccu_hi_tgt_min);
 	if (status < 0)
 		goto error;
-	status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A, ifIaccuHiTgtMax);
+	status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A, if_iaccu_hi_tgt_max);
 	if (status < 0)
 		goto error;
 	status = write16(state, SCU_RAM_AGC_IF_IACCU_HI__A, 0);
@@ -3046,20 +3046,20 @@ static int InitAGC(struct drxk_state *state, bool isDTV)
 	status = write16(state, SCU_RAM_AGC_RF_IACCU_LO__A, 0);
 	if (status < 0)
 		goto error;
-	status = write16(state, SCU_RAM_AGC_CLP_SUM_MAX__A, clpSumMax);
+	status = write16(state, SCU_RAM_AGC_CLP_SUM_MAX__A, clp_sum_max);
 	if (status < 0)
 		goto error;
-	status = write16(state, SCU_RAM_AGC_SNS_SUM_MAX__A, snsSumMax);
+	status = write16(state, SCU_RAM_AGC_SNS_SUM_MAX__A, sns_sum_max);
 	if (status < 0)
 		goto error;
 
-	status = write16(state, SCU_RAM_AGC_KI_INNERGAIN_MIN__A, kiInnergainMin);
+	status = write16(state, SCU_RAM_AGC_KI_INNERGAIN_MIN__A, ki_innergain_min);
 	if (status < 0)
 		goto error;
-	status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT__A, ifIaccuHiTgt);
+	status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT__A, if_iaccu_hi_tgt);
 	if (status < 0)
 		goto error;
-	status = write16(state, SCU_RAM_AGC_CLP_CYCLEN__A, clpCyclen);
+	status = write16(state, SCU_RAM_AGC_CLP_CYCLEN__A, clp_cyclen);
 	if (status < 0)
 		goto error;
 
@@ -3076,16 +3076,16 @@ static int InitAGC(struct drxk_state *state, bool isDTV)
 	status = write16(state, SCU_RAM_AGC_KI_MAXMINGAIN_TH__A, 20);
 	if (status < 0)
 		goto error;
-	status = write16(state, SCU_RAM_AGC_CLP_SUM_MIN__A, clpSumMin);
+	status = write16(state, SCU_RAM_AGC_CLP_SUM_MIN__A, clp_sum_min);
 	if (status < 0)
 		goto error;
-	status = write16(state, SCU_RAM_AGC_SNS_SUM_MIN__A, snsSumMin);
+	status = write16(state, SCU_RAM_AGC_SNS_SUM_MIN__A, sns_sum_min);
 	if (status < 0)
 		goto error;
-	status = write16(state, SCU_RAM_AGC_CLP_DIR_TO__A, clpDirTo);
+	status = write16(state, SCU_RAM_AGC_CLP_DIR_TO__A, clp_dir_to);
 	if (status < 0)
 		goto error;
-	status = write16(state, SCU_RAM_AGC_SNS_DIR_TO__A, snsDirTo);
+	status = write16(state, SCU_RAM_AGC_SNS_DIR_TO__A, sns_dir_to);
 	if (status < 0)
 		goto error;
 	status = write16(state, SCU_RAM_AGC_KI_MINGAIN__A, 0x7fff);
@@ -3149,34 +3149,34 @@ error:
 	return status;
 }
 
-static int DVBTQAMGetAccPktErr(struct drxk_state *state, u16 *packetErr)
+static int dvbtqam_get_acc_pkt_err(struct drxk_state *state, u16 *packet_err)
 {
 	int status;
 
 	dprintk(1, "\n");
-	if (packetErr == NULL)
+	if (packet_err == NULL)
 		status = write16(state, SCU_RAM_FEC_ACCUM_PKT_FAILURES__A, 0);
 	else
-		status = read16(state, SCU_RAM_FEC_ACCUM_PKT_FAILURES__A, packetErr);
+		status = read16(state, SCU_RAM_FEC_ACCUM_PKT_FAILURES__A, packet_err);
 	if (status < 0)
 		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
-static int DVBTScCommand(struct drxk_state *state,
+static int dvbt_sc_command(struct drxk_state *state,
 			 u16 cmd, u16 subcmd,
 			 u16 param0, u16 param1, u16 param2,
 			 u16 param3, u16 param4)
 {
-	u16 curCmd = 0;
-	u16 errCode = 0;
-	u16 retryCnt = 0;
-	u16 scExec = 0;
+	u16 cur_cmd = 0;
+	u16 err_code = 0;
+	u16 retry_cnt = 0;
+	u16 sc_exec = 0;
 	int status;
 
 	dprintk(1, "\n");
-	status = read16(state, OFDM_SC_COMM_EXEC__A, &scExec);
-	if (scExec != 1) {
+	status = read16(state, OFDM_SC_COMM_EXEC__A, &sc_exec);
+	if (sc_exec != 1) {
 		/* SC is not running */
 		status = -EINVAL;
 	}
@@ -3184,13 +3184,13 @@ static int DVBTScCommand(struct drxk_state *state,
 		goto error;
 
 	/* Wait until sc is ready to receive command */
-	retryCnt = 0;
+	retry_cnt = 0;
 	do {
 		msleep(1);
-		status = read16(state, OFDM_SC_RA_RAM_CMD__A, &curCmd);
-		retryCnt++;
-	} while ((curCmd != 0) && (retryCnt < DRXK_MAX_RETRIES));
-	if (retryCnt >= DRXK_MAX_RETRIES && (status < 0))
+		status = read16(state, OFDM_SC_RA_RAM_CMD__A, &cur_cmd);
+		retry_cnt++;
+	} while ((cur_cmd != 0) && (retry_cnt < DRXK_MAX_RETRIES));
+	if (retry_cnt >= DRXK_MAX_RETRIES && (status < 0))
 		goto error;
 
 	/* Write sub-command */
@@ -3236,18 +3236,18 @@ static int DVBTScCommand(struct drxk_state *state,
 		goto error;
 
 	/* Wait until sc is ready processing command */
-	retryCnt = 0;
+	retry_cnt = 0;
 	do {
 		msleep(1);
-		status = read16(state, OFDM_SC_RA_RAM_CMD__A, &curCmd);
-		retryCnt++;
-	} while ((curCmd != 0) && (retryCnt < DRXK_MAX_RETRIES));
-	if (retryCnt >= DRXK_MAX_RETRIES && (status < 0))
+		status = read16(state, OFDM_SC_RA_RAM_CMD__A, &cur_cmd);
+		retry_cnt++;
+	} while ((cur_cmd != 0) && (retry_cnt < DRXK_MAX_RETRIES));
+	if (retry_cnt >= DRXK_MAX_RETRIES && (status < 0))
 		goto error;
 
 	/* Check for illegal cmd */
-	status = read16(state, OFDM_SC_RA_RAM_CMD_ADDR__A, &errCode);
-	if (errCode == 0xFFFF) {
+	status = read16(state, OFDM_SC_RA_RAM_CMD_ADDR__A, &err_code);
+	if (err_code == 0xFFFF) {
 		/* illegal command */
 		status = -EINVAL;
 	}
@@ -3283,19 +3283,19 @@ error:
 	return status;
 }
 
-static int PowerUpDVBT(struct drxk_state *state)
+static int power_up_dvbt(struct drxk_state *state)
 {
-	enum DRXPowerMode powerMode = DRX_POWER_UP;
+	enum drx_power_mode power_mode = DRX_POWER_UP;
 	int status;
 
 	dprintk(1, "\n");
-	status = CtrlPowerMode(state, &powerMode);
+	status = ctrl_power_mode(state, &power_mode);
 	if (status < 0)
 		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
-static int DVBTCtrlSetIncEnable(struct drxk_state *state, bool *enabled)
+static int dvbt_ctrl_set_inc_enable(struct drxk_state *state, bool *enabled)
 {
 	int status;
 
@@ -3310,7 +3310,7 @@ static int DVBTCtrlSetIncEnable(struct drxk_state *state, bool *enabled)
 }
 
 #define DEFAULT_FR_THRES_8K     4000
-static int DVBTCtrlSetFrEnable(struct drxk_state *state, bool *enabled)
+static int dvbt_ctrl_set_fr_enable(struct drxk_state *state, bool *enabled)
 {
 
 	int status;
@@ -3330,8 +3330,8 @@ static int DVBTCtrlSetFrEnable(struct drxk_state *state, bool *enabled)
 	return status;
 }
 
-static int DVBTCtrlSetEchoThreshold(struct drxk_state *state,
-				    struct DRXKCfgDvbtEchoThres_t *echoThres)
+static int dvbt_ctrl_set_echo_threshold(struct drxk_state *state,
+				    struct drxk_cfg_dvbt_echo_thres_t *echo_thres)
 {
 	u16 data = 0;
 	int status;
@@ -3341,16 +3341,16 @@ static int DVBTCtrlSetEchoThreshold(struct drxk_state *state,
 	if (status < 0)
 		goto error;
 
-	switch (echoThres->fftMode) {
+	switch (echo_thres->fft_mode) {
 	case DRX_FFTMODE_2K:
 		data &= ~OFDM_SC_RA_RAM_ECHO_THRES_2K__M;
-		data |= ((echoThres->threshold <<
+		data |= ((echo_thres->threshold <<
 			OFDM_SC_RA_RAM_ECHO_THRES_2K__B)
 			& (OFDM_SC_RA_RAM_ECHO_THRES_2K__M));
 		break;
 	case DRX_FFTMODE_8K:
 		data &= ~OFDM_SC_RA_RAM_ECHO_THRES_8K__M;
-		data |= ((echoThres->threshold <<
+		data |= ((echo_thres->threshold <<
 			OFDM_SC_RA_RAM_ECHO_THRES_8K__B)
 			& (OFDM_SC_RA_RAM_ECHO_THRES_8K__M));
 		break;
@@ -3365,8 +3365,8 @@ error:
 	return status;
 }
 
-static int DVBTCtrlSetSqiSpeed(struct drxk_state *state,
-			       enum DRXKCfgDvbtSqiSpeed *speed)
+static int dvbt_ctrl_set_sqi_speed(struct drxk_state *state,
+			       enum drxk_cfg_dvbt_sqi_speed *speed)
 {
 	int status = -EINVAL;
 
@@ -3398,29 +3398,29 @@ error:
 * Called in DVBTSetStandard
 *
 */
-static int DVBTActivatePresets(struct drxk_state *state)
+static int dvbt_activate_presets(struct drxk_state *state)
 {
 	int status;
 	bool setincenable = false;
 	bool setfrenable = true;
 
-	struct DRXKCfgDvbtEchoThres_t echoThres2k = { 0, DRX_FFTMODE_2K };
-	struct DRXKCfgDvbtEchoThres_t echoThres8k = { 0, DRX_FFTMODE_8K };
+	struct drxk_cfg_dvbt_echo_thres_t echo_thres2k = { 0, DRX_FFTMODE_2K };
+	struct drxk_cfg_dvbt_echo_thres_t echo_thres8k = { 0, DRX_FFTMODE_8K };
 
 	dprintk(1, "\n");
-	status = DVBTCtrlSetIncEnable(state, &setincenable);
+	status = dvbt_ctrl_set_inc_enable(state, &setincenable);
 	if (status < 0)
 		goto error;
-	status = DVBTCtrlSetFrEnable(state, &setfrenable);
+	status = dvbt_ctrl_set_fr_enable(state, &setfrenable);
 	if (status < 0)
 		goto error;
-	status = DVBTCtrlSetEchoThreshold(state, &echoThres2k);
+	status = dvbt_ctrl_set_echo_threshold(state, &echo_thres2k);
 	if (status < 0)
 		goto error;
-	status = DVBTCtrlSetEchoThreshold(state, &echoThres8k);
+	status = dvbt_ctrl_set_echo_threshold(state, &echo_thres8k);
 	if (status < 0)
 		goto error;
-	status = write16(state, SCU_RAM_AGC_INGAIN_TGT_MAX__A, state->m_dvbtIfAgcCfg.IngainTgtMax);
+	status = write16(state, SCU_RAM_AGC_INGAIN_TGT_MAX__A, state->m_dvbt_if_agc_cfg.ingain_tgt_max);
 error:
 	if (status < 0)
 		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
@@ -3437,25 +3437,25 @@ error:
 * For ROM code channel filter taps are loaded from the bootloader. For microcode
 * the DVB-T taps from the drxk_filters.h are used.
 */
-static int SetDVBTStandard(struct drxk_state *state,
-			   enum OperationMode oMode)
+static int set_dvbt_standard(struct drxk_state *state,
+			   enum operation_mode o_mode)
 {
-	u16 cmdResult = 0;
+	u16 cmd_result = 0;
 	u16 data = 0;
 	int status;
 
 	dprintk(1, "\n");
 
-	PowerUpDVBT(state);
+	power_up_dvbt(state);
 	/* added antenna switch */
-	SwitchAntennaToDVBT(state);
+	switch_antenna_to_dvbt(state);
 	/* send OFDM reset command */
-	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_RESET, 0, NULL, 1, &cmdResult);
+	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_RESET, 0, NULL, 1, &cmd_result);
 	if (status < 0)
 		goto error;
 
 	/* send OFDM setenv command */
-	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_SET_ENV, 0, NULL, 1, &cmdResult);
+	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_SET_ENV, 0, NULL, 1, &cmd_result);
 	if (status < 0)
 		goto error;
 
@@ -3487,7 +3487,7 @@ static int SetDVBTStandard(struct drxk_state *state,
 	status = write16(state, IQM_AF_AMUX__A, IQM_AF_AMUX_SIGNAL2ADC);
 	if (status < 0)
 		goto error;
-	status = SetIqmAf(state, true);
+	status = set_iqm_af(state, true);
 	if (status < 0)
 		goto error;
 
@@ -3530,7 +3530,7 @@ static int SetDVBTStandard(struct drxk_state *state,
 	if (status < 0)
 		goto error;
 
-	status = BLChainCmd(state, DRXK_BL_ROM_OFFSET_TAPS_DVBT, DRXK_BLCC_NR_ELEMENTS_TAPS, DRXK_BLC_TIMEOUT);
+	status = bl_chain_cmd(state, DRXK_BL_ROM_OFFSET_TAPS_DVBT, DRXK_BLCC_NR_ELEMENTS_TAPS, DRXK_BLC_TIMEOUT);
 	if (status < 0)
 		goto error;
 
@@ -3549,10 +3549,10 @@ static int SetDVBTStandard(struct drxk_state *state,
 		goto error;
 
 	/* IQM will not be reset from here, sync ADC and update/init AGC */
-	status = ADCSynchronization(state);
+	status = adc_synchronization(state);
 	if (status < 0)
 		goto error;
-	status = SetPreSaw(state, &state->m_dvbtPreSawCfg);
+	status = set_pre_saw(state, &state->m_dvbt_pre_saw_cfg);
 	if (status < 0)
 		goto error;
 
@@ -3561,10 +3561,10 @@ static int SetDVBTStandard(struct drxk_state *state,
 	if (status < 0)
 		goto error;
 
-	status = SetAgcRf(state, &state->m_dvbtRfAgcCfg, true);
+	status = set_agc_rf(state, &state->m_dvbt_rf_agc_cfg, true);
 	if (status < 0)
 		goto error;
-	status = SetAgcIf(state, &state->m_dvbtIfAgcCfg, true);
+	status = set_agc_if(state, &state->m_dvbt_if_agc_cfg, true);
 	if (status < 0)
 		goto error;
 
@@ -3582,9 +3582,9 @@ static int SetDVBTStandard(struct drxk_state *state,
 	if (status < 0)
 		goto error;
 
-	if (!state->m_DRXK_A3_ROM_CODE) {
-		/* AGCInit() is not done for DVBT, so set agcFastClipCtrlDelay  */
-		status = write16(state, SCU_RAM_AGC_FAST_CLP_CTRL_DELAY__A, state->m_dvbtIfAgcCfg.FastClipCtrlDelay);
+	if (!state->m_drxk_a3_rom_code) {
+		/* AGCInit() is not done for DVBT, so set agcfast_clip_ctrl_delay  */
+		status = write16(state, SCU_RAM_AGC_FAST_CLP_CTRL_DELAY__A, state->m_dvbt_if_agc_cfg.fast_clip_ctrl_delay);
 		if (status < 0)
 			goto error;
 	}
@@ -3619,11 +3619,11 @@ static int SetDVBTStandard(struct drxk_state *state,
 		goto error;
 
 	/* Setup MPEG bus */
-	status = MPEGTSDtoSetup(state, OM_DVBT);
+	status = mpegts_dto_setup(state, OM_DVBT);
 	if (status < 0)
 		goto error;
 	/* Set DVBT Presets */
-	status = DVBTActivatePresets(state);
+	status = dvbt_activate_presets(state);
 	if (status < 0)
 		goto error;
 
@@ -3635,25 +3635,25 @@ error:
 
 /*============================================================================*/
 /**
-* \brief Start dvbt demodulating for channel.
+* \brief start dvbt demodulating for channel.
 * \param demod instance of demodulator.
 * \return DRXStatus_t.
 */
-static int DVBTStart(struct drxk_state *state)
+static int dvbt_start(struct drxk_state *state)
 {
 	u16 param1;
 	int status;
-	/* DRXKOfdmScCmd_t scCmd; */
+	/* drxk_ofdm_sc_cmd_t scCmd; */
 
 	dprintk(1, "\n");
-	/* Start correct processes to get in lock */
+	/* start correct processes to get in lock */
 	/* DRXK: OFDM_SC_RA_RAM_PROC_LOCKTRACK is no longer in mapfile! */
 	param1 = OFDM_SC_RA_RAM_LOCKTRACK_MIN;
-	status = DVBTScCommand(state, OFDM_SC_RA_RAM_CMD_PROC_START, 0, OFDM_SC_RA_RAM_SW_EVENT_RUN_NMASK__M, param1, 0, 0, 0);
+	status = dvbt_sc_command(state, OFDM_SC_RA_RAM_CMD_PROC_START, 0, OFDM_SC_RA_RAM_SW_EVENT_RUN_NMASK__M, param1, 0, 0, 0);
 	if (status < 0)
 		goto error;
-	/* Start FEC OC */
-	status = MPEGTSStart(state);
+	/* start FEC OC */
+	status = mpegts_start(state);
 	if (status < 0)
 		goto error;
 	status = write16(state, FEC_COMM_EXEC__A, FEC_COMM_EXEC_ACTIVE);
@@ -3674,20 +3674,20 @@ error:
 * \return DRXStatus_t.
 * // original DVBTSetChannel()
 */
-static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
-		   s32 tunerFreqOffset)
+static int set_dvbt(struct drxk_state *state, u16 intermediate_freqk_hz,
+		   s32 tuner_freq_offset)
 {
-	u16 cmdResult = 0;
-	u16 transmissionParams = 0;
-	u16 operationMode = 0;
-	u32 iqmRcRateOfs = 0;
+	u16 cmd_result = 0;
+	u16 transmission_params = 0;
+	u16 operation_mode = 0;
+	u32 iqm_rc_rate_ofs = 0;
 	u32 bandwidth = 0;
 	u16 param1;
 	int status;
 
-	dprintk(1, "IF =%d, TFO = %d\n", IntermediateFreqkHz, tunerFreqOffset);
+	dprintk(1, "IF =%d, TFO = %d\n", intermediate_freqk_hz, tuner_freq_offset);
 
-	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_STOP, 0, NULL, 1, &cmdResult);
+	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_STOP, 0, NULL, 1, &cmd_result);
 	if (status < 0)
 		goto error;
 
@@ -3716,13 +3716,13 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 	switch (state->props.transmission_mode) {
 	case TRANSMISSION_MODE_AUTO:
 	default:
-		operationMode |= OFDM_SC_RA_RAM_OP_AUTO_MODE__M;
+		operation_mode |= OFDM_SC_RA_RAM_OP_AUTO_MODE__M;
 		/* fall through , try first guess DRX_FFTMODE_8K */
 	case TRANSMISSION_MODE_8K:
-		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_MODE_8K;
+		transmission_params |= OFDM_SC_RA_RAM_OP_PARAM_MODE_8K;
 		break;
 	case TRANSMISSION_MODE_2K:
-		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_MODE_2K;
+		transmission_params |= OFDM_SC_RA_RAM_OP_PARAM_MODE_2K;
 		break;
 	}
 
@@ -3730,19 +3730,19 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 	switch (state->props.guard_interval) {
 	default:
 	case GUARD_INTERVAL_AUTO:
-		operationMode |= OFDM_SC_RA_RAM_OP_AUTO_GUARD__M;
+		operation_mode |= OFDM_SC_RA_RAM_OP_AUTO_GUARD__M;
 		/* fall through , try first guess DRX_GUARD_1DIV4 */
 	case GUARD_INTERVAL_1_4:
-		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_GUARD_4;
+		transmission_params |= OFDM_SC_RA_RAM_OP_PARAM_GUARD_4;
 		break;
 	case GUARD_INTERVAL_1_32:
-		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_GUARD_32;
+		transmission_params |= OFDM_SC_RA_RAM_OP_PARAM_GUARD_32;
 		break;
 	case GUARD_INTERVAL_1_16:
-		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_GUARD_16;
+		transmission_params |= OFDM_SC_RA_RAM_OP_PARAM_GUARD_16;
 		break;
 	case GUARD_INTERVAL_1_8:
-		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_GUARD_8;
+		transmission_params |= OFDM_SC_RA_RAM_OP_PARAM_GUARD_8;
 		break;
 	}
 
@@ -3751,18 +3751,18 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 	case HIERARCHY_AUTO:
 	case HIERARCHY_NONE:
 	default:
-		operationMode |= OFDM_SC_RA_RAM_OP_AUTO_HIER__M;
+		operation_mode |= OFDM_SC_RA_RAM_OP_AUTO_HIER__M;
 		/* fall through , try first guess SC_RA_RAM_OP_PARAM_HIER_NO */
-		/* transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_HIER_NO; */
+		/* transmission_params |= OFDM_SC_RA_RAM_OP_PARAM_HIER_NO; */
 		/* break; */
 	case HIERARCHY_1:
-		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_HIER_A1;
+		transmission_params |= OFDM_SC_RA_RAM_OP_PARAM_HIER_A1;
 		break;
 	case HIERARCHY_2:
-		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_HIER_A2;
+		transmission_params |= OFDM_SC_RA_RAM_OP_PARAM_HIER_A2;
 		break;
 	case HIERARCHY_4:
-		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_HIER_A4;
+		transmission_params |= OFDM_SC_RA_RAM_OP_PARAM_HIER_A4;
 		break;
 	}
 
@@ -3771,16 +3771,16 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 	switch (state->props.modulation) {
 	case QAM_AUTO:
 	default:
-		operationMode |= OFDM_SC_RA_RAM_OP_AUTO_CONST__M;
+		operation_mode |= OFDM_SC_RA_RAM_OP_AUTO_CONST__M;
 		/* fall through , try first guess DRX_CONSTELLATION_QAM64 */
 	case QAM_64:
-		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_CONST_QAM64;
+		transmission_params |= OFDM_SC_RA_RAM_OP_PARAM_CONST_QAM64;
 		break;
 	case QPSK:
-		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_CONST_QPSK;
+		transmission_params |= OFDM_SC_RA_RAM_OP_PARAM_CONST_QPSK;
 		break;
 	case QAM_16:
-		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_CONST_QAM16;
+		transmission_params |= OFDM_SC_RA_RAM_OP_PARAM_CONST_QAM16;
 		break;
 	}
 #if 0
@@ -3788,13 +3788,13 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 	/* Priority (only for hierarchical channels) */
 	switch (channel->priority) {
 	case DRX_PRIORITY_LOW:
-		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_PRIO_LO;
-		WR16(devAddr, OFDM_EC_SB_PRIOR__A,
+		transmission_params |= OFDM_SC_RA_RAM_OP_PARAM_PRIO_LO;
+		WR16(dev_addr, OFDM_EC_SB_PRIOR__A,
 			OFDM_EC_SB_PRIOR_LO);
 		break;
 	case DRX_PRIORITY_HIGH:
-		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_PRIO_HI;
-		WR16(devAddr, OFDM_EC_SB_PRIOR__A,
+		transmission_params |= OFDM_SC_RA_RAM_OP_PARAM_PRIO_HI;
+		WR16(dev_addr, OFDM_EC_SB_PRIOR__A,
 			OFDM_EC_SB_PRIOR_HI));
 		break;
 	case DRX_PRIORITY_UNKNOWN:	/* fall through */
@@ -3804,7 +3804,7 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 	}
 #else
 	/* Set Priorty high */
-	transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_PRIO_HI;
+	transmission_params |= OFDM_SC_RA_RAM_OP_PARAM_PRIO_HI;
 	status = write16(state, OFDM_EC_SB_PRIOR__A, OFDM_EC_SB_PRIOR_HI);
 	if (status < 0)
 		goto error;
@@ -3814,22 +3814,22 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 	switch (state->props.code_rate_HP) {
 	case FEC_AUTO:
 	default:
-		operationMode |= OFDM_SC_RA_RAM_OP_AUTO_RATE__M;
+		operation_mode |= OFDM_SC_RA_RAM_OP_AUTO_RATE__M;
 		/* fall through , try first guess DRX_CODERATE_2DIV3 */
 	case FEC_2_3:
-		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_RATE_2_3;
+		transmission_params |= OFDM_SC_RA_RAM_OP_PARAM_RATE_2_3;
 		break;
 	case FEC_1_2:
-		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_RATE_1_2;
+		transmission_params |= OFDM_SC_RA_RAM_OP_PARAM_RATE_1_2;
 		break;
 	case FEC_3_4:
-		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_RATE_3_4;
+		transmission_params |= OFDM_SC_RA_RAM_OP_PARAM_RATE_3_4;
 		break;
 	case FEC_5_6:
-		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_RATE_5_6;
+		transmission_params |= OFDM_SC_RA_RAM_OP_PARAM_RATE_5_6;
 		break;
 	case FEC_7_8:
-		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_RATE_7_8;
+		transmission_params |= OFDM_SC_RA_RAM_OP_PARAM_RATE_7_8;
 		break;
 	}
 
@@ -3906,7 +3906,7 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 		goto error;
 	}
 
-	if (iqmRcRateOfs == 0) {
+	if (iqm_rc_rate_ofs == 0) {
 		/* Now compute IQM_RC_RATE_OFS
 			(((SysFreq/BandWidth)/2)/2) -1) * 2^23)
 			=>
@@ -3916,36 +3916,36 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 		/* assert (MAX(sysClk)/MIN(bandwidth) < 16)
 			=> assert(MAX(sysClk) < 16*MIN(bandwidth))
 			=> assert(109714272 > 48000000) = true so Frac 28 can be used  */
-		iqmRcRateOfs = Frac28a((u32)
-					((state->m_sysClockFreq *
+		iqm_rc_rate_ofs = Frac28a((u32)
+					((state->m_sys_clock_freq *
 						1000) / 3), bandwidth);
 		/* (SysFreq / BandWidth) * (2^21), rounding before truncating  */
-		if ((iqmRcRateOfs & 0x7fL) >= 0x40)
-			iqmRcRateOfs += 0x80L;
-		iqmRcRateOfs = iqmRcRateOfs >> 7;
+		if ((iqm_rc_rate_ofs & 0x7fL) >= 0x40)
+			iqm_rc_rate_ofs += 0x80L;
+		iqm_rc_rate_ofs = iqm_rc_rate_ofs >> 7;
 		/* ((SysFreq / BandWidth) * (2^21)) - (2^23)  */
-		iqmRcRateOfs = iqmRcRateOfs - (1 << 23);
+		iqm_rc_rate_ofs = iqm_rc_rate_ofs - (1 << 23);
 	}
 
-	iqmRcRateOfs &=
+	iqm_rc_rate_ofs &=
 		((((u32) IQM_RC_RATE_OFS_HI__M) <<
 		IQM_RC_RATE_OFS_LO__W) | IQM_RC_RATE_OFS_LO__M);
-	status = write32(state, IQM_RC_RATE_OFS_LO__A, iqmRcRateOfs);
+	status = write32(state, IQM_RC_RATE_OFS_LO__A, iqm_rc_rate_ofs);
 	if (status < 0)
 		goto error;
 
 	/* Bandwidth setting done */
 
 #if 0
-	status = DVBTSetFrequencyShift(demod, channel, tunerOffset);
+	status = dvbt_set_frequency_shift(demod, channel, tuner_offset);
 	if (status < 0)
 		goto error;
 #endif
-	status = SetFrequencyShifter(state, IntermediateFreqkHz, tunerFreqOffset, true);
+	status = set_frequency_shifter(state, intermediate_freqk_hz, tuner_freq_offset, true);
 	if (status < 0)
 		goto error;
 
-	/*== Start SC, write channel settings to SC ===============================*/
+	/*== start SC, write channel settings to SC ===============================*/
 
 	/* Activate SCU to enable SCU commands */
 	status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_ACTIVE);
@@ -3961,7 +3961,7 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 		goto error;
 
 
-	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_START, 0, NULL, 1, &cmdResult);
+	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_START, 0, NULL, 1, &cmd_result);
 	if (status < 0)
 		goto error;
 
@@ -3971,13 +3971,13 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 			OFDM_SC_RA_RAM_OP_AUTO_CONST__M |
 			OFDM_SC_RA_RAM_OP_AUTO_HIER__M |
 			OFDM_SC_RA_RAM_OP_AUTO_RATE__M);
-	status = DVBTScCommand(state, OFDM_SC_RA_RAM_CMD_SET_PREF_PARAM,
-				0, transmissionParams, param1, 0, 0, 0);
+	status = dvbt_sc_command(state, OFDM_SC_RA_RAM_CMD_SET_PREF_PARAM,
+				0, transmission_params, param1, 0, 0, 0);
 	if (status < 0)
 		goto error;
 
-	if (!state->m_DRXK_A3_ROM_CODE)
-		status = DVBTCtrlSetSqiSpeed(state, &state->m_sqiSpeed);
+	if (!state->m_drxk_a3_rom_code)
+		status = dvbt_ctrl_set_sqi_speed(state, &state->m_sqi_speed);
 error:
 	if (status < 0)
 		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
@@ -3995,7 +3995,7 @@ error:
 * \return DRXStatus_t.
 *
 */
-static int GetDVBTLockStatus(struct drxk_state *state, u32 *pLockStatus)
+static int get_dvbt_lock_status(struct drxk_state *state, u32 *p_lock_status)
 {
 	int status;
 	const u16 mpeg_lock_mask = (OFDM_SC_RA_RAM_LOCK_MPEG__M |
@@ -4003,32 +4003,32 @@ static int GetDVBTLockStatus(struct drxk_state *state, u32 *pLockStatus)
 	const u16 fec_lock_mask = (OFDM_SC_RA_RAM_LOCK_FEC__M);
 	const u16 demod_lock_mask = OFDM_SC_RA_RAM_LOCK_DEMOD__M;
 
-	u16 ScRaRamLock = 0;
-	u16 ScCommExec = 0;
+	u16 sc_ra_ram_lock = 0;
+	u16 sc_comm_exec = 0;
 
 	dprintk(1, "\n");
 
-	*pLockStatus = NOT_LOCKED;
+	*p_lock_status = NOT_LOCKED;
 	/* driver 0.9.0 */
 	/* Check if SC is running */
-	status = read16(state, OFDM_SC_COMM_EXEC__A, &ScCommExec);
+	status = read16(state, OFDM_SC_COMM_EXEC__A, &sc_comm_exec);
 	if (status < 0)
 		goto end;
-	if (ScCommExec == OFDM_SC_COMM_EXEC_STOP)
+	if (sc_comm_exec == OFDM_SC_COMM_EXEC_STOP)
 		goto end;
 
-	status = read16(state, OFDM_SC_RA_RAM_LOCK__A, &ScRaRamLock);
+	status = read16(state, OFDM_SC_RA_RAM_LOCK__A, &sc_ra_ram_lock);
 	if (status < 0)
 		goto end;
 
-	if ((ScRaRamLock & mpeg_lock_mask) == mpeg_lock_mask)
-		*pLockStatus = MPEG_LOCK;
-	else if ((ScRaRamLock & fec_lock_mask) == fec_lock_mask)
-		*pLockStatus = FEC_LOCK;
-	else if ((ScRaRamLock & demod_lock_mask) == demod_lock_mask)
-		*pLockStatus = DEMOD_LOCK;
-	else if (ScRaRamLock & OFDM_SC_RA_RAM_LOCK_NODVBT__M)
-		*pLockStatus = NEVER_LOCK;
+	if ((sc_ra_ram_lock & mpeg_lock_mask) == mpeg_lock_mask)
+		*p_lock_status = MPEG_LOCK;
+	else if ((sc_ra_ram_lock & fec_lock_mask) == fec_lock_mask)
+		*p_lock_status = FEC_LOCK;
+	else if ((sc_ra_ram_lock & demod_lock_mask) == demod_lock_mask)
+		*p_lock_status = DEMOD_LOCK;
+	else if (sc_ra_ram_lock & OFDM_SC_RA_RAM_LOCK_NODVBT__M)
+		*p_lock_status = NEVER_LOCK;
 end:
 	if (status < 0)
 		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
@@ -4036,13 +4036,13 @@ end:
 	return status;
 }
 
-static int PowerUpQAM(struct drxk_state *state)
+static int power_up_qam(struct drxk_state *state)
 {
-	enum DRXPowerMode powerMode = DRXK_POWER_DOWN_OFDM;
+	enum drx_power_mode power_mode = DRXK_POWER_DOWN_OFDM;
 	int status;
 
 	dprintk(1, "\n");
-	status = CtrlPowerMode(state, &powerMode);
+	status = ctrl_power_mode(state, &power_mode);
 	if (status < 0)
 		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 
@@ -4051,10 +4051,10 @@ static int PowerUpQAM(struct drxk_state *state)
 
 
 /** Power Down QAM */
-static int PowerDownQAM(struct drxk_state *state)
+static int power_down_qam(struct drxk_state *state)
 {
 	u16 data = 0;
-	u16 cmdResult;
+	u16 cmd_result;
 	int status = 0;
 
 	dprintk(1, "\n");
@@ -4070,12 +4070,12 @@ static int PowerDownQAM(struct drxk_state *state)
 		status = write16(state, QAM_COMM_EXEC__A, QAM_COMM_EXEC_STOP);
 		if (status < 0)
 			goto error;
-		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_STOP, 0, NULL, 1, &cmdResult);
+		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_STOP, 0, NULL, 1, &cmd_result);
 		if (status < 0)
 			goto error;
 	}
 	/* powerdown AFE                   */
-	status = SetIqmAf(state, false);
+	status = set_iqm_af(state, false);
 
 error:
 	if (status < 0)
@@ -4097,20 +4097,20 @@ error:
 *  The implementation does not check this.
 *
 */
-static int SetQAMMeasurement(struct drxk_state *state,
-			     enum EDrxkConstellation modulation,
-			     u32 symbolRate)
+static int set_qam_measurement(struct drxk_state *state,
+			     enum e_drxk_constellation modulation,
+			     u32 symbol_rate)
 {
-	u32 fecBitsDesired = 0;	/* BER accounting period */
-	u32 fecRsPeriodTotal = 0;	/* Total period */
-	u16 fecRsPrescale = 0;	/* ReedSolomon Measurement Prescale */
-	u16 fecRsPeriod = 0;	/* Value for corresponding I2C register */
+	u32 fec_bits_desired = 0;	/* BER accounting period */
+	u32 fec_rs_period_total = 0;	/* Total period */
+	u16 fec_rs_prescale = 0;	/* ReedSolomon Measurement Prescale */
+	u16 fec_rs_period = 0;	/* Value for corresponding I2C register */
 	int status = 0;
 
 	dprintk(1, "\n");
 
-	fecRsPrescale = 1;
-	/* fecBitsDesired = symbolRate [kHz] *
+	fec_rs_prescale = 1;
+	/* fec_bits_desired = symbol_rate [kHz] *
 		FrameLenght [ms] *
 		(modulation + 1) *
 		SyncLoss (== 1) *
@@ -4118,19 +4118,19 @@ static int SetQAMMeasurement(struct drxk_state *state,
 		*/
 	switch (modulation) {
 	case DRX_CONSTELLATION_QAM16:
-		fecBitsDesired = 4 * symbolRate;
+		fec_bits_desired = 4 * symbol_rate;
 		break;
 	case DRX_CONSTELLATION_QAM32:
-		fecBitsDesired = 5 * symbolRate;
+		fec_bits_desired = 5 * symbol_rate;
 		break;
 	case DRX_CONSTELLATION_QAM64:
-		fecBitsDesired = 6 * symbolRate;
+		fec_bits_desired = 6 * symbol_rate;
 		break;
 	case DRX_CONSTELLATION_QAM128:
-		fecBitsDesired = 7 * symbolRate;
+		fec_bits_desired = 7 * symbol_rate;
 		break;
 	case DRX_CONSTELLATION_QAM256:
-		fecBitsDesired = 8 * symbolRate;
+		fec_bits_desired = 8 * symbol_rate;
 		break;
 	default:
 		status = -EINVAL;
@@ -4138,40 +4138,40 @@ static int SetQAMMeasurement(struct drxk_state *state,
 	if (status < 0)
 		goto error;
 
-	fecBitsDesired /= 1000;	/* symbolRate [Hz] -> symbolRate [kHz]  */
-	fecBitsDesired *= 500;	/* meas. period [ms] */
+	fec_bits_desired /= 1000;	/* symbol_rate [Hz] -> symbol_rate [kHz]  */
+	fec_bits_desired *= 500;	/* meas. period [ms] */
 
 	/* Annex A/C: bits/RsPeriod = 204 * 8 = 1632 */
-	/* fecRsPeriodTotal = fecBitsDesired / 1632 */
-	fecRsPeriodTotal = (fecBitsDesired / 1632UL) + 1;	/* roughly ceil */
+	/* fec_rs_period_total = fec_bits_desired / 1632 */
+	fec_rs_period_total = (fec_bits_desired / 1632UL) + 1;	/* roughly ceil */
 
-	/* fecRsPeriodTotal =  fecRsPrescale * fecRsPeriod  */
-	fecRsPrescale = 1 + (u16) (fecRsPeriodTotal >> 16);
-	if (fecRsPrescale == 0) {
+	/* fec_rs_period_total =  fec_rs_prescale * fec_rs_period  */
+	fec_rs_prescale = 1 + (u16) (fec_rs_period_total >> 16);
+	if (fec_rs_prescale == 0) {
 		/* Divide by zero (though impossible) */
 		status = -EINVAL;
 		if (status < 0)
 			goto error;
 	}
-	fecRsPeriod =
-		((u16) fecRsPeriodTotal +
-		(fecRsPrescale >> 1)) / fecRsPrescale;
+	fec_rs_period =
+		((u16) fec_rs_period_total +
+		(fec_rs_prescale >> 1)) / fec_rs_prescale;
 
 	/* write corresponding registers */
-	status = write16(state, FEC_RS_MEASUREMENT_PERIOD__A, fecRsPeriod);
+	status = write16(state, FEC_RS_MEASUREMENT_PERIOD__A, fec_rs_period);
 	if (status < 0)
 		goto error;
-	status = write16(state, FEC_RS_MEASUREMENT_PRESCALE__A, fecRsPrescale);
+	status = write16(state, FEC_RS_MEASUREMENT_PRESCALE__A, fec_rs_prescale);
 	if (status < 0)
 		goto error;
-	status = write16(state, FEC_OC_SNC_FAIL_PERIOD__A, fecRsPeriod);
+	status = write16(state, FEC_OC_SNC_FAIL_PERIOD__A, fec_rs_period);
 error:
 	if (status < 0)
 		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
-static int SetQAM16(struct drxk_state *state)
+static int set_qam16(struct drxk_state *state)
 {
 	int status = 0;
 
@@ -4364,7 +4364,7 @@ error:
 * \param demod instance of demod.
 * \return DRXStatus_t.
 */
-static int SetQAM32(struct drxk_state *state)
+static int set_qam32(struct drxk_state *state)
 {
 	int status = 0;
 
@@ -4559,7 +4559,7 @@ error:
 * \param demod instance of demod.
 * \return DRXStatus_t.
 */
-static int SetQAM64(struct drxk_state *state)
+static int set_qam64(struct drxk_state *state)
 {
 	int status = 0;
 
@@ -4753,7 +4753,7 @@ error:
 * \param demod: instance of demod.
 * \return DRXStatus_t.
 */
-static int SetQAM128(struct drxk_state *state)
+static int set_qam128(struct drxk_state *state)
 {
 	int status = 0;
 
@@ -4949,7 +4949,7 @@ error:
 * \param demod: instance of demod.
 * \return DRXStatus_t.
 */
-static int SetQAM256(struct drxk_state *state)
+static int set_qam256(struct drxk_state *state)
 {
 	int status = 0;
 
@@ -5144,10 +5144,10 @@ error:
 * \param channel: pointer to channel data.
 * \return DRXStatus_t.
 */
-static int QAMResetQAM(struct drxk_state *state)
+static int qam_reset_qam(struct drxk_state *state)
 {
 	int status;
-	u16 cmdResult;
+	u16 cmd_result;
 
 	dprintk(1, "\n");
 	/* Stop QAM comstate->m_exec */
@@ -5155,7 +5155,7 @@ static int QAMResetQAM(struct drxk_state *state)
 	if (status < 0)
 		goto error;
 
-	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_RESET, 0, NULL, 1, &cmdResult);
+	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_RESET, 0, NULL, 1, &cmd_result);
 error:
 	if (status < 0)
 		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
@@ -5170,18 +5170,18 @@ error:
 * \param channel: pointer to channel data.
 * \return DRXStatus_t.
 */
-static int QAMSetSymbolrate(struct drxk_state *state)
+static int qam_set_symbolrate(struct drxk_state *state)
 {
-	u32 adcFrequency = 0;
-	u32 symbFreq = 0;
-	u32 iqmRcRate = 0;
+	u32 adc_frequency = 0;
+	u32 symb_freq = 0;
+	u32 iqm_rc_rate = 0;
 	u16 ratesel = 0;
-	u32 lcSymbRate = 0;
+	u32 lc_symb_rate = 0;
 	int status;
 
 	dprintk(1, "\n");
 	/* Select & calculate correct IQM rate */
-	adcFrequency = (state->m_sysClockFreq * 1000) / 3;
+	adc_frequency = (state->m_sys_clock_freq * 1000) / 3;
 	ratesel = 0;
 	/* printk(KERN_DEBUG "drxk: SR %d\n", state->props.symbol_rate); */
 	if (state->props.symbol_rate <= 1188750)
@@ -5197,34 +5197,34 @@ static int QAMSetSymbolrate(struct drxk_state *state)
 	/*
 		IqmRcRate = ((Fadc / (symbolrate * (4<<ratesel))) - 1) * (1<<23)
 		*/
-	symbFreq = state->props.symbol_rate * (1 << ratesel);
-	if (symbFreq == 0) {
+	symb_freq = state->props.symbol_rate * (1 << ratesel);
+	if (symb_freq == 0) {
 		/* Divide by zero */
 		status = -EINVAL;
 		goto error;
 	}
-	iqmRcRate = (adcFrequency / symbFreq) * (1 << 21) +
-		(Frac28a((adcFrequency % symbFreq), symbFreq) >> 7) -
+	iqm_rc_rate = (adc_frequency / symb_freq) * (1 << 21) +
+		(Frac28a((adc_frequency % symb_freq), symb_freq) >> 7) -
 		(1 << 23);
-	status = write32(state, IQM_RC_RATE_OFS_LO__A, iqmRcRate);
+	status = write32(state, IQM_RC_RATE_OFS_LO__A, iqm_rc_rate);
 	if (status < 0)
 		goto error;
-	state->m_iqmRcRate = iqmRcRate;
+	state->m_iqm_rc_rate = iqm_rc_rate;
 	/*
-		LcSymbFreq = round (.125 *  symbolrate / adcFreq * (1<<15))
+		LcSymbFreq = round (.125 *  symbolrate / adc_freq * (1<<15))
 		*/
-	symbFreq = state->props.symbol_rate;
-	if (adcFrequency == 0) {
+	symb_freq = state->props.symbol_rate;
+	if (adc_frequency == 0) {
 		/* Divide by zero */
 		status = -EINVAL;
 		goto error;
 	}
-	lcSymbRate = (symbFreq / adcFrequency) * (1 << 12) +
-		(Frac28a((symbFreq % adcFrequency), adcFrequency) >>
+	lc_symb_rate = (symb_freq / adc_frequency) * (1 << 12) +
+		(Frac28a((symb_freq % adc_frequency), adc_frequency) >>
 		16);
-	if (lcSymbRate > 511)
-		lcSymbRate = 511;
-	status = write16(state, QAM_LC_SYMBOL_FREQ__A, (u16) lcSymbRate);
+	if (lc_symb_rate > 511)
+		lc_symb_rate = 511;
+	status = write16(state, QAM_LC_SYMBOL_FREQ__A, (u16) lc_symb_rate);
 
 error:
 	if (status < 0)
@@ -5241,34 +5241,34 @@ error:
 * \return DRXStatus_t.
 */
 
-static int GetQAMLockStatus(struct drxk_state *state, u32 *pLockStatus)
+static int get_qam_lock_status(struct drxk_state *state, u32 *p_lock_status)
 {
 	int status;
-	u16 Result[2] = { 0, 0 };
+	u16 result[2] = { 0, 0 };
 
 	dprintk(1, "\n");
-	*pLockStatus = NOT_LOCKED;
+	*p_lock_status = NOT_LOCKED;
 	status = scu_command(state,
 			SCU_RAM_COMMAND_STANDARD_QAM |
 			SCU_RAM_COMMAND_CMD_DEMOD_GET_LOCK, 0, NULL, 2,
-			Result);
+			result);
 	if (status < 0)
 		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 
-	if (Result[1] < SCU_RAM_QAM_LOCKED_LOCKED_DEMOD_LOCKED) {
+	if (result[1] < SCU_RAM_QAM_LOCKED_LOCKED_DEMOD_LOCKED) {
 		/* 0x0000 NOT LOCKED */
-	} else if (Result[1] < SCU_RAM_QAM_LOCKED_LOCKED_LOCKED) {
+	} else if (result[1] < SCU_RAM_QAM_LOCKED_LOCKED_LOCKED) {
 		/* 0x4000 DEMOD LOCKED */
-		*pLockStatus = DEMOD_LOCK;
-	} else if (Result[1] < SCU_RAM_QAM_LOCKED_LOCKED_NEVER_LOCK) {
+		*p_lock_status = DEMOD_LOCK;
+	} else if (result[1] < SCU_RAM_QAM_LOCKED_LOCKED_NEVER_LOCK) {
 		/* 0x8000 DEMOD + FEC LOCKED (system lock) */
-		*pLockStatus = MPEG_LOCK;
+		*p_lock_status = MPEG_LOCK;
 	} else {
 		/* 0xC000 NEVER LOCKED */
 		/* (system will never be able to lock to the signal) */
 		/* TODO: check this, intermediate & standard specific lock states are not
 		   taken into account here */
-		*pLockStatus = NEVER_LOCK;
+		*p_lock_status = NEVER_LOCK;
 	}
 	return status;
 }
@@ -5280,52 +5280,52 @@ static int GetQAMLockStatus(struct drxk_state *state, u32 *pLockStatus)
 #define QAM_LOCKRANGE__M      0x10
 #define QAM_LOCKRANGE_NORMAL  0x10
 
-static int QAMDemodulatorCommand(struct drxk_state *state,
-				 int numberOfParameters)
+static int qam_demodulator_command(struct drxk_state *state,
+				 int number_of_parameters)
 {
 	int status;
-	u16 cmdResult;
-	u16 setParamParameters[4] = { 0, 0, 0, 0 };
+	u16 cmd_result;
+	u16 set_param_parameters[4] = { 0, 0, 0, 0 };
 
-	setParamParameters[0] = state->m_Constellation;	/* modulation     */
-	setParamParameters[1] = DRXK_QAM_I12_J17;	/* interleave mode   */
+	set_param_parameters[0] = state->m_constellation;	/* modulation     */
+	set_param_parameters[1] = DRXK_QAM_I12_J17;	/* interleave mode   */
 
-	if (numberOfParameters == 2) {
-		u16 setEnvParameters[1] = { 0 };
+	if (number_of_parameters == 2) {
+		u16 set_env_parameters[1] = { 0 };
 
-		if (state->m_OperationMode == OM_QAM_ITU_C)
-			setEnvParameters[0] = QAM_TOP_ANNEX_C;
+		if (state->m_operation_mode == OM_QAM_ITU_C)
+			set_env_parameters[0] = QAM_TOP_ANNEX_C;
 		else
-			setEnvParameters[0] = QAM_TOP_ANNEX_A;
+			set_env_parameters[0] = QAM_TOP_ANNEX_A;
 
 		status = scu_command(state,
 				     SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_ENV,
-				     1, setEnvParameters, 1, &cmdResult);
+				     1, set_env_parameters, 1, &cmd_result);
 		if (status < 0)
 			goto error;
 
 		status = scu_command(state,
 				     SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_PARAM,
-				     numberOfParameters, setParamParameters,
-				     1, &cmdResult);
-	} else if (numberOfParameters == 4) {
-		if (state->m_OperationMode == OM_QAM_ITU_C)
-			setParamParameters[2] = QAM_TOP_ANNEX_C;
+				     number_of_parameters, set_param_parameters,
+				     1, &cmd_result);
+	} else if (number_of_parameters == 4) {
+		if (state->m_operation_mode == OM_QAM_ITU_C)
+			set_param_parameters[2] = QAM_TOP_ANNEX_C;
 		else
-			setParamParameters[2] = QAM_TOP_ANNEX_A;
+			set_param_parameters[2] = QAM_TOP_ANNEX_A;
 
-		setParamParameters[3] |= (QAM_MIRROR_AUTO_ON);
+		set_param_parameters[3] |= (QAM_MIRROR_AUTO_ON);
 		/* Env parameters */
 		/* check for LOCKRANGE Extented */
-		/* setParamParameters[3] |= QAM_LOCKRANGE_NORMAL; */
+		/* set_param_parameters[3] |= QAM_LOCKRANGE_NORMAL; */
 
 		status = scu_command(state,
 				     SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_PARAM,
-				     numberOfParameters, setParamParameters,
-				     1, &cmdResult);
+				     number_of_parameters, set_param_parameters,
+				     1, &cmd_result);
 	} else {
 		printk(KERN_WARNING "drxk: Unknown QAM demodulator parameter "
-			"count %d\n", numberOfParameters);
+			"count %d\n", number_of_parameters);
 		status = -EINVAL;
 	}
 
@@ -5336,12 +5336,12 @@ error:
 	return status;
 }
 
-static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
-		  s32 tunerFreqOffset)
+static int set_qam(struct drxk_state *state, u16 intermediate_freqk_hz,
+		  s32 tuner_freq_offset)
 {
 	int status;
-	u16 cmdResult;
-	int qamDemodParamCount = state->qam_demod_parameter_count;
+	u16 cmd_result;
+	int qam_demod_param_count = state->qam_demod_parameter_count;
 
 	dprintk(1, "\n");
 	/*
@@ -5356,7 +5356,7 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 	status = write16(state, FEC_RS_COMM_EXEC__A, FEC_RS_COMM_EXEC_STOP);
 	if (status < 0)
 		goto error;
-	status = QAMResetQAM(state);
+	status = qam_reset_qam(state);
 	if (status < 0)
 		goto error;
 
@@ -5365,27 +5365,27 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 	 *	-set params; resets IQM,QAM,FEC HW; initializes some
 	 *       SCU variables
 	 */
-	status = QAMSetSymbolrate(state);
+	status = qam_set_symbolrate(state);
 	if (status < 0)
 		goto error;
 
 	/* Set params */
 	switch (state->props.modulation) {
 	case QAM_256:
-		state->m_Constellation = DRX_CONSTELLATION_QAM256;
+		state->m_constellation = DRX_CONSTELLATION_QAM256;
 		break;
 	case QAM_AUTO:
 	case QAM_64:
-		state->m_Constellation = DRX_CONSTELLATION_QAM64;
+		state->m_constellation = DRX_CONSTELLATION_QAM64;
 		break;
 	case QAM_16:
-		state->m_Constellation = DRX_CONSTELLATION_QAM16;
+		state->m_constellation = DRX_CONSTELLATION_QAM16;
 		break;
 	case QAM_32:
-		state->m_Constellation = DRX_CONSTELLATION_QAM32;
+		state->m_constellation = DRX_CONSTELLATION_QAM32;
 		break;
 	case QAM_128:
-		state->m_Constellation = DRX_CONSTELLATION_QAM128;
+		state->m_constellation = DRX_CONSTELLATION_QAM128;
 		break;
 	default:
 		status = -EINVAL;
@@ -5398,8 +5398,8 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 	 * the correct command. */
 	if (state->qam_demod_parameter_count == 4
 		|| !state->qam_demod_parameter_count) {
-		qamDemodParamCount = 4;
-		status = QAMDemodulatorCommand(state, qamDemodParamCount);
+		qam_demod_param_count = 4;
+		status = qam_demodulator_command(state, qam_demod_param_count);
 	}
 
 	/* Use the 2-parameter command if it was requested or if we're
@@ -5407,8 +5407,8 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 	 * failed. */
 	if (state->qam_demod_parameter_count == 2
 		|| (!state->qam_demod_parameter_count && status < 0)) {
-		qamDemodParamCount = 2;
-		status = QAMDemodulatorCommand(state, qamDemodParamCount);
+		qam_demod_param_count = 2;
+		status = qam_demodulator_command(state, qam_demod_param_count);
 	}
 
 	if (status < 0) {
@@ -5421,13 +5421,13 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 	} else if (!state->qam_demod_parameter_count) {
 		dprintk(1, "Auto-probing the correct QAM demodulator command "
 			"parameters was successful - using %d parameters.\n",
-			qamDemodParamCount);
+			qam_demod_param_count);
 
 		/*
 		 * One of our commands was successful. We don't need to
 		 * auto-probe anymore, now that we got the correct command.
 		 */
-		state->qam_demod_parameter_count = qamDemodParamCount;
+		state->qam_demod_parameter_count = qam_demod_param_count;
 	}
 
 	/*
@@ -5435,16 +5435,16 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 	 * signal setup modulation independent registers
 	 */
 #if 0
-	status = SetFrequency(channel, tunerFreqOffset));
+	status = set_frequency(channel, tuner_freq_offset));
 	if (status < 0)
 		goto error;
 #endif
-	status = SetFrequencyShifter(state, IntermediateFreqkHz, tunerFreqOffset, true);
+	status = set_frequency_shifter(state, intermediate_freqk_hz, tuner_freq_offset, true);
 	if (status < 0)
 		goto error;
 
 	/* Setup BER measurement */
-	status = SetQAMMeasurement(state, state->m_Constellation, state->props.symbol_rate);
+	status = set_qam_measurement(state, state->m_constellation, state->props.symbol_rate);
 	if (status < 0)
 		goto error;
 
@@ -5529,20 +5529,20 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 	/* STEP 4: modulation specific setup */
 	switch (state->props.modulation) {
 	case QAM_16:
-		status = SetQAM16(state);
+		status = set_qam16(state);
 		break;
 	case QAM_32:
-		status = SetQAM32(state);
+		status = set_qam32(state);
 		break;
 	case QAM_AUTO:
 	case QAM_64:
-		status = SetQAM64(state);
+		status = set_qam64(state);
 		break;
 	case QAM_128:
-		status = SetQAM128(state);
+		status = set_qam128(state);
 		break;
 	case QAM_256:
-		status = SetQAM256(state);
+		status = set_qam256(state);
 		break;
 	default:
 		status = -EINVAL;
@@ -5559,12 +5559,12 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 	/* Re-configure MPEG output, requires knowledge of channel bitrate */
 	/* extAttr->currentChannel.modulation = channel->modulation; */
 	/* extAttr->currentChannel.symbolrate    = channel->symbolrate; */
-	status = MPEGTSDtoSetup(state, state->m_OperationMode);
+	status = mpegts_dto_setup(state, state->m_operation_mode);
 	if (status < 0)
 		goto error;
 
-	/* Start processes */
-	status = MPEGTSStart(state);
+	/* start processes */
+	status = mpegts_start(state);
 	if (status < 0)
 		goto error;
 	status = write16(state, FEC_COMM_EXEC__A, FEC_COMM_EXEC_ACTIVE);
@@ -5578,7 +5578,7 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 		goto error;
 
 	/* STEP 5: start QAM demodulator (starts FEC, QAM and IQM HW) */
-	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_START, 0, NULL, 1, &cmdResult);
+	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_START, 0, NULL, 1, &cmd_result);
 	if (status < 0)
 		goto error;
 
@@ -5591,8 +5591,8 @@ error:
 	return status;
 }
 
-static int SetQAMStandard(struct drxk_state *state,
-			  enum OperationMode oMode)
+static int set_qam_standard(struct drxk_state *state,
+			  enum operation_mode o_mode)
 {
 	int status;
 #ifdef DRXK_QAM_TAPS
@@ -5604,14 +5604,14 @@ static int SetQAMStandard(struct drxk_state *state,
 	dprintk(1, "\n");
 
 	/* added antenna switch */
-	SwitchAntennaToQAM(state);
+	switch_antenna_to_qam(state);
 
 	/* Ensure correct power-up mode */
-	status = PowerUpQAM(state);
+	status = power_up_qam(state);
 	if (status < 0)
 		goto error;
 	/* Reset QAM block */
-	status = QAMResetQAM(state);
+	status = qam_reset_qam(state);
 	if (status < 0)
 		goto error;
 
@@ -5626,15 +5626,15 @@ static int SetQAMStandard(struct drxk_state *state,
 
 	/* Upload IQM Channel Filter settings by
 		boot loader from ROM table */
-	switch (oMode) {
+	switch (o_mode) {
 	case OM_QAM_ITU_A:
-		status = BLChainCmd(state, DRXK_BL_ROM_OFFSET_TAPS_ITU_A, DRXK_BLCC_NR_ELEMENTS_TAPS, DRXK_BLC_TIMEOUT);
+		status = bl_chain_cmd(state, DRXK_BL_ROM_OFFSET_TAPS_ITU_A, DRXK_BLCC_NR_ELEMENTS_TAPS, DRXK_BLC_TIMEOUT);
 		break;
 	case OM_QAM_ITU_C:
-		status = BLDirectCmd(state, IQM_CF_TAP_RE0__A, DRXK_BL_ROM_OFFSET_TAPS_ITU_C, DRXK_BLDC_NR_ELEMENTS_TAPS, DRXK_BLC_TIMEOUT);
+		status = bl_direct_cmd(state, IQM_CF_TAP_RE0__A, DRXK_BL_ROM_OFFSET_TAPS_ITU_C, DRXK_BLDC_NR_ELEMENTS_TAPS, DRXK_BLC_TIMEOUT);
 		if (status < 0)
 			goto error;
-		status = BLDirectCmd(state, IQM_CF_TAP_IM0__A, DRXK_BL_ROM_OFFSET_TAPS_ITU_C, DRXK_BLDC_NR_ELEMENTS_TAPS, DRXK_BLC_TIMEOUT);
+		status = bl_direct_cmd(state, IQM_CF_TAP_IM0__A, DRXK_BL_ROM_OFFSET_TAPS_ITU_C, DRXK_BLDC_NR_ELEMENTS_TAPS, DRXK_BLC_TIMEOUT);
 		break;
 	default:
 		status = -EINVAL;
@@ -5705,7 +5705,7 @@ static int SetQAMStandard(struct drxk_state *state,
 		goto error;
 
 	/* turn on IQMAF. Must be done before setAgc**() */
-	status = SetIqmAf(state, true);
+	status = set_iqm_af(state, true);
 	if (status < 0)
 		goto error;
 	status = write16(state, IQM_AF_START_LOCK__A, 0x01);
@@ -5713,7 +5713,7 @@ static int SetQAMStandard(struct drxk_state *state,
 		goto error;
 
 	/* IQM will not be reset from here, sync ADC and update/init AGC */
-	status = ADCSynchronization(state);
+	status = adc_synchronization(state);
 	if (status < 0)
 		goto error;
 
@@ -5730,18 +5730,18 @@ static int SetQAMStandard(struct drxk_state *state,
 	/* No more resets of the IQM, current standard correctly set =>
 		now AGCs can be configured. */
 
-	status = InitAGC(state, true);
+	status = init_agc(state, true);
 	if (status < 0)
 		goto error;
-	status = SetPreSaw(state, &(state->m_qamPreSawCfg));
+	status = set_pre_saw(state, &(state->m_qam_pre_saw_cfg));
 	if (status < 0)
 		goto error;
 
 	/* Configure AGC's */
-	status = SetAgcRf(state, &(state->m_qamRfAgcCfg), true);
+	status = set_agc_rf(state, &(state->m_qam_rf_agc_cfg), true);
 	if (status < 0)
 		goto error;
-	status = SetAgcIf(state, &(state->m_qamIfAgcCfg), true);
+	status = set_agc_if(state, &(state->m_qam_if_agc_cfg), true);
 	if (status < 0)
 		goto error;
 
@@ -5753,7 +5753,7 @@ error:
 	return status;
 }
 
-static int WriteGPIO(struct drxk_state *state)
+static int write_gpio(struct drxk_state *state)
 {
 	int status;
 	u16 value = 0;
@@ -5769,10 +5769,10 @@ static int WriteGPIO(struct drxk_state *state)
 	if (status < 0)
 		goto error;
 
-	if (state->m_hasSAWSW) {
-		if (state->UIO_mask & 0x0001) { /* UIO-1 */
+	if (state->m_has_sawsw) {
+		if (state->uio_mask & 0x0001) { /* UIO-1 */
 			/* write to io pad configuration register - output mode */
-			status = write16(state, SIO_PDR_SMA_TX_CFG__A, state->m_GPIOCfg);
+			status = write16(state, SIO_PDR_SMA_TX_CFG__A, state->m_gpio_cfg);
 			if (status < 0)
 				goto error;
 
@@ -5780,7 +5780,7 @@ static int WriteGPIO(struct drxk_state *state)
 			status = read16(state, SIO_PDR_UIO_OUT_LO__A, &value);
 			if (status < 0)
 				goto error;
-			if ((state->m_GPIO & 0x0001) == 0)
+			if ((state->m_gpio & 0x0001) == 0)
 				value &= 0x7FFF;	/* write zero to 15th bit - 1st UIO */
 			else
 				value |= 0x8000;	/* write one to 15th bit - 1st UIO */
@@ -5789,9 +5789,9 @@ static int WriteGPIO(struct drxk_state *state)
 			if (status < 0)
 				goto error;
 		}
-		if (state->UIO_mask & 0x0002) { /* UIO-2 */
+		if (state->uio_mask & 0x0002) { /* UIO-2 */
 			/* write to io pad configuration register - output mode */
-			status = write16(state, SIO_PDR_SMA_RX_CFG__A, state->m_GPIOCfg);
+			status = write16(state, SIO_PDR_SMA_RX_CFG__A, state->m_gpio_cfg);
 			if (status < 0)
 				goto error;
 
@@ -5799,7 +5799,7 @@ static int WriteGPIO(struct drxk_state *state)
 			status = read16(state, SIO_PDR_UIO_OUT_LO__A, &value);
 			if (status < 0)
 				goto error;
-			if ((state->m_GPIO & 0x0002) == 0)
+			if ((state->m_gpio & 0x0002) == 0)
 				value &= 0xBFFF;	/* write zero to 14th bit - 2st UIO */
 			else
 				value |= 0x4000;	/* write one to 14th bit - 2st UIO */
@@ -5808,9 +5808,9 @@ static int WriteGPIO(struct drxk_state *state)
 			if (status < 0)
 				goto error;
 		}
-		if (state->UIO_mask & 0x0004) { /* UIO-3 */
+		if (state->uio_mask & 0x0004) { /* UIO-3 */
 			/* write to io pad configuration register - output mode */
-			status = write16(state, SIO_PDR_GPIO_CFG__A, state->m_GPIOCfg);
+			status = write16(state, SIO_PDR_GPIO_CFG__A, state->m_gpio_cfg);
 			if (status < 0)
 				goto error;
 
@@ -5818,7 +5818,7 @@ static int WriteGPIO(struct drxk_state *state)
 			status = read16(state, SIO_PDR_UIO_OUT_LO__A, &value);
 			if (status < 0)
 				goto error;
-			if ((state->m_GPIO & 0x0004) == 0)
+			if ((state->m_gpio & 0x0004) == 0)
 				value &= 0xFFFB;            /* write zero to 2nd bit - 3rd UIO */
 			else
 				value |= 0x0004;            /* write one to 2nd bit - 3rd UIO */
@@ -5836,7 +5836,7 @@ error:
 	return status;
 }
 
-static int SwitchAntennaToQAM(struct drxk_state *state)
+static int switch_antenna_to_qam(struct drxk_state *state)
 {
 	int status = 0;
 	bool gpio_state;
@@ -5846,22 +5846,22 @@ static int SwitchAntennaToQAM(struct drxk_state *state)
 	if (!state->antenna_gpio)
 		return 0;
 
-	gpio_state = state->m_GPIO & state->antenna_gpio;
+	gpio_state = state->m_gpio & state->antenna_gpio;
 
 	if (state->antenna_dvbt ^ gpio_state) {
 		/* Antenna is on DVB-T mode. Switch */
 		if (state->antenna_dvbt)
-			state->m_GPIO &= ~state->antenna_gpio;
+			state->m_gpio &= ~state->antenna_gpio;
 		else
-			state->m_GPIO |= state->antenna_gpio;
-		status = WriteGPIO(state);
+			state->m_gpio |= state->antenna_gpio;
+		status = write_gpio(state);
 	}
 	if (status < 0)
 		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
-static int SwitchAntennaToDVBT(struct drxk_state *state)
+static int switch_antenna_to_dvbt(struct drxk_state *state)
 {
 	int status = 0;
 	bool gpio_state;
@@ -5871,15 +5871,15 @@ static int SwitchAntennaToDVBT(struct drxk_state *state)
 	if (!state->antenna_gpio)
 		return 0;
 
-	gpio_state = state->m_GPIO & state->antenna_gpio;
+	gpio_state = state->m_gpio & state->antenna_gpio;
 
 	if (!(state->antenna_dvbt ^ gpio_state)) {
 		/* Antenna is on DVB-C mode. Switch */
 		if (state->antenna_dvbt)
-			state->m_GPIO |= state->antenna_gpio;
+			state->m_gpio |= state->antenna_gpio;
 		else
-			state->m_GPIO &= ~state->antenna_gpio;
-		status = WriteGPIO(state);
+			state->m_gpio &= ~state->antenna_gpio;
+		status = write_gpio(state);
 	}
 	if (status < 0)
 		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
@@ -5887,7 +5887,7 @@ static int SwitchAntennaToDVBT(struct drxk_state *state)
 }
 
 
-static int PowerDownDevice(struct drxk_state *state)
+static int power_down_device(struct drxk_state *state)
 {
 	/* Power down to requested mode */
 	/* Backup some register settings */
@@ -5898,14 +5898,14 @@ static int PowerDownDevice(struct drxk_state *state)
 	int status;
 
 	dprintk(1, "\n");
-	if (state->m_bPDownOpenBridge) {
+	if (state->m_b_p_down_open_bridge) {
 		/* Open I2C bridge before power down of DRXK */
 		status = ConfigureI2CBridge(state, true);
 		if (status < 0)
 			goto error;
 	}
 	/* driver 0.9.0 */
-	status = DVBTEnableOFDMTokenRing(state, false);
+	status = dvbt_enable_ofdm_token_ring(state, false);
 	if (status < 0)
 		goto error;
 
@@ -5915,8 +5915,8 @@ static int PowerDownDevice(struct drxk_state *state)
 	status = write16(state, SIO_CC_UPDATE__A, SIO_CC_UPDATE_KEY);
 	if (status < 0)
 		goto error;
-	state->m_HICfgCtrl |= SIO_HI_RA_RAM_PAR_5_CFG_SLEEP_ZZZ;
-	status = HI_CfgCommand(state);
+	state->m_hi_cfg_ctrl |= SIO_HI_RA_RAM_PAR_5_CFG_SLEEP_ZZZ;
+	status = hi_cfg_command(state);
 error:
 	if (status < 0)
 		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
@@ -5927,16 +5927,16 @@ error:
 static int init_drxk(struct drxk_state *state)
 {
 	int status = 0, n = 0;
-	enum DRXPowerMode powerMode = DRXK_POWER_DOWN_OFDM;
-	u16 driverVersion;
+	enum drx_power_mode power_mode = DRXK_POWER_DOWN_OFDM;
+	u16 driver_version;
 
 	dprintk(1, "\n");
-	if ((state->m_DrxkState == DRXK_UNINITIALIZED)) {
+	if ((state->m_drxk_state == DRXK_UNINITIALIZED)) {
 		drxk_i2c_lock(state);
-		status = PowerUpDevice(state);
+		status = power_up_device(state);
 		if (status < 0)
 			goto error;
-		status = DRXX_Open(state);
+		status = drxx_open(state);
 		if (status < 0)
 			goto error;
 		/* Soft reset of OFDM-, sys- and osc-clockdomain */
@@ -5948,29 +5948,29 @@ static int init_drxk(struct drxk_state *state)
 			goto error;
 		/* TODO is this needed, if yes how much delay in worst case scenario */
 		msleep(1);
-		state->m_DRXK_A3_PATCH_CODE = true;
-		status = GetDeviceCapabilities(state);
+		state->m_drxk_a3_patch_code = true;
+		status = get_device_capabilities(state);
 		if (status < 0)
 			goto error;
 
 		/* Bridge delay, uses oscilator clock */
 		/* Delay = (delay (nano seconds) * oscclk (kHz))/ 1000 */
 		/* SDA brdige delay */
-		state->m_HICfgBridgeDelay =
-			(u16) ((state->m_oscClockFreq / 1000) *
+		state->m_hi_cfg_bridge_delay =
+			(u16) ((state->m_osc_clock_freq / 1000) *
 				HI_I2C_BRIDGE_DELAY) / 1000;
 		/* Clipping */
-		if (state->m_HICfgBridgeDelay >
+		if (state->m_hi_cfg_bridge_delay >
 			SIO_HI_RA_RAM_PAR_3_CFG_DBL_SDA__M) {
-			state->m_HICfgBridgeDelay =
+			state->m_hi_cfg_bridge_delay =
 				SIO_HI_RA_RAM_PAR_3_CFG_DBL_SDA__M;
 		}
 		/* SCL bridge delay, same as SDA for now */
-		state->m_HICfgBridgeDelay +=
-			state->m_HICfgBridgeDelay <<
+		state->m_hi_cfg_bridge_delay +=
+			state->m_hi_cfg_bridge_delay <<
 			SIO_HI_RA_RAM_PAR_3_CFG_DBL_SCL__B;
 
-		status = InitHI(state);
+		status = init_hi(state);
 		if (status < 0)
 			goto error;
 		/* disable various processes */
@@ -5985,7 +5985,7 @@ static int init_drxk(struct drxk_state *state)
 		}
 
 		/* disable MPEG port */
-		status = MPEGTSDisable(state);
+		status = mpegts_disable(state);
 		if (status < 0)
 			goto error;
 
@@ -6006,12 +6006,12 @@ static int init_drxk(struct drxk_state *state)
 		status = write16(state, SIO_BL_COMM_EXEC__A, SIO_BL_COMM_EXEC_ACTIVE);
 		if (status < 0)
 			goto error;
-		status = BLChainCmd(state, 0, 6, 100);
+		status = bl_chain_cmd(state, 0, 6, 100);
 		if (status < 0)
 			goto error;
 
 		if (state->fw) {
-			status = DownloadMicrocode(state, state->fw->data,
+			status = download_microcode(state, state->fw->data,
 						   state->fw->size);
 			if (status < 0)
 				goto error;
@@ -6026,14 +6026,14 @@ static int init_drxk(struct drxk_state *state)
 		status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_ACTIVE);
 		if (status < 0)
 			goto error;
-		status = DRXX_Open(state);
+		status = drxx_open(state);
 		if (status < 0)
 			goto error;
 		/* added for test */
 		msleep(30);
 
-		powerMode = DRXK_POWER_DOWN_OFDM;
-		status = CtrlPowerMode(state, &powerMode);
+		power_mode = DRXK_POWER_DOWN_OFDM;
+		status = ctrl_power_mode(state, &power_mode);
 		if (status < 0)
 			goto error;
 
@@ -6043,20 +6043,20 @@ static int init_drxk(struct drxk_state *state)
 			Not using SCU command interface for SCU register access since no
 			microcode may be present.
 			*/
-		driverVersion =
+		driver_version =
 			(((DRXK_VERSION_MAJOR / 100) % 10) << 12) +
 			(((DRXK_VERSION_MAJOR / 10) % 10) << 8) +
 			((DRXK_VERSION_MAJOR % 10) << 4) +
 			(DRXK_VERSION_MINOR % 10);
-		status = write16(state, SCU_RAM_DRIVER_VER_HI__A, driverVersion);
+		status = write16(state, SCU_RAM_DRIVER_VER_HI__A, driver_version);
 		if (status < 0)
 			goto error;
-		driverVersion =
+		driver_version =
 			(((DRXK_VERSION_PATCH / 1000) % 10) << 12) +
 			(((DRXK_VERSION_PATCH / 100) % 10) << 8) +
 			(((DRXK_VERSION_PATCH / 10) % 10) << 4) +
 			(DRXK_VERSION_PATCH % 10);
-		status = write16(state, SCU_RAM_DRIVER_VER_LO__A, driverVersion);
+		status = write16(state, SCU_RAM_DRIVER_VER_LO__A, driver_version);
 		if (status < 0)
 			goto error;
 
@@ -6069,7 +6069,7 @@ static int init_drxk(struct drxk_state *state)
 			before calling DRX_Open. This solution requires changes to RF AGC speed
 			to be done via the CTRL function after calling DRX_Open */
 
-		/* m_dvbtRfAgcCfg.speed = 3; */
+		/* m_dvbt_rf_agc_cfg.speed = 3; */
 
 		/* Reset driver debug flags to 0 */
 		status = write16(state, SCU_RAM_DRIVER_DEBUG__A, 0);
@@ -6082,42 +6082,42 @@ static int init_drxk(struct drxk_state *state)
 		if (status < 0)
 			goto error;
 		/* MPEGTS functions are still the same */
-		status = MPEGTSDtoInit(state);
+		status = mpegts_dto_init(state);
 		if (status < 0)
 			goto error;
-		status = MPEGTSStop(state);
+		status = mpegts_stop(state);
 		if (status < 0)
 			goto error;
-		status = MPEGTSConfigurePolarity(state);
+		status = mpegts_configure_polarity(state);
 		if (status < 0)
 			goto error;
-		status = MPEGTSConfigurePins(state, state->m_enableMPEGOutput);
+		status = mpegts_configure_pins(state, state->m_enable_mpeg_output);
 		if (status < 0)
 			goto error;
 		/* added: configure GPIO */
-		status = WriteGPIO(state);
+		status = write_gpio(state);
 		if (status < 0)
 			goto error;
 
-		state->m_DrxkState = DRXK_STOPPED;
+		state->m_drxk_state = DRXK_STOPPED;
 
-		if (state->m_bPowerDown) {
-			status = PowerDownDevice(state);
+		if (state->m_b_power_down) {
+			status = power_down_device(state);
 			if (status < 0)
 				goto error;
-			state->m_DrxkState = DRXK_POWERED_DOWN;
+			state->m_drxk_state = DRXK_POWERED_DOWN;
 		} else
-			state->m_DrxkState = DRXK_STOPPED;
+			state->m_drxk_state = DRXK_STOPPED;
 
 		/* Initialize the supported delivery systems */
 		n = 0;
-		if (state->m_hasDVBC) {
+		if (state->m_has_dvbc) {
 			state->frontend.ops.delsys[n++] = SYS_DVBC_ANNEX_A;
 			state->frontend.ops.delsys[n++] = SYS_DVBC_ANNEX_C;
 			strlcat(state->frontend.ops.info.name, " DVB-C",
 				sizeof(state->frontend.ops.info.name));
 		}
-		if (state->m_hasDVBT) {
+		if (state->m_has_dvbt) {
 			state->frontend.ops.delsys[n++] = SYS_DVBT;
 			strlcat(state->frontend.ops.info.name, " DVB-T",
 				sizeof(state->frontend.ops.info.name));
@@ -6126,7 +6126,7 @@ static int init_drxk(struct drxk_state *state)
 	}
 error:
 	if (status < 0) {
-		state->m_DrxkState = DRXK_NO_DEV;
+		state->m_drxk_state = DRXK_NO_DEV;
 		drxk_i2c_unlock(state);
 		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	}
@@ -6182,12 +6182,12 @@ static int drxk_sleep(struct dvb_frontend *fe)
 
 	dprintk(1, "\n");
 
-	if (state->m_DrxkState == DRXK_NO_DEV)
+	if (state->m_drxk_state == DRXK_NO_DEV)
 		return -ENODEV;
-	if (state->m_DrxkState == DRXK_UNINITIALIZED)
+	if (state->m_drxk_state == DRXK_UNINITIALIZED)
 		return 0;
 
-	ShutDown(state);
+	shut_down(state);
 	return 0;
 }
 
@@ -6197,7 +6197,7 @@ static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
 
 	dprintk(1, ": %s\n", enable ? "enable" : "disable");
 
-	if (state->m_DrxkState == DRXK_NO_DEV)
+	if (state->m_drxk_state == DRXK_NO_DEV)
 		return -ENODEV;
 
 	return ConfigureI2CBridge(state, enable ? true : false);
@@ -6212,10 +6212,10 @@ static int drxk_set_parameters(struct dvb_frontend *fe)
 
 	dprintk(1, "\n");
 
-	if (state->m_DrxkState == DRXK_NO_DEV)
+	if (state->m_drxk_state == DRXK_NO_DEV)
 		return -ENODEV;
 
-	if (state->m_DrxkState == DRXK_UNINITIALIZED)
+	if (state->m_drxk_state == DRXK_UNINITIALIZED)
 		return -EAGAIN;
 
 	if (!fe->ops.tuner_ops.get_if_frequency) {
@@ -6235,22 +6235,22 @@ static int drxk_set_parameters(struct dvb_frontend *fe)
 	state->props = *p;
 
 	if (old_delsys != delsys) {
-		ShutDown(state);
+		shut_down(state);
 		switch (delsys) {
 		case SYS_DVBC_ANNEX_A:
 		case SYS_DVBC_ANNEX_C:
-			if (!state->m_hasDVBC)
+			if (!state->m_has_dvbc)
 				return -EINVAL;
 			state->m_itut_annex_c = (delsys == SYS_DVBC_ANNEX_C) ? true : false;
 			if (state->m_itut_annex_c)
-				SetOperationMode(state, OM_QAM_ITU_C);
+				setoperation_mode(state, OM_QAM_ITU_C);
 			else
-				SetOperationMode(state, OM_QAM_ITU_A);
+				setoperation_mode(state, OM_QAM_ITU_A);
 			break;
 		case SYS_DVBT:
-			if (!state->m_hasDVBT)
+			if (!state->m_has_dvbt)
 				return -EINVAL;
-			SetOperationMode(state, OM_DVBT);
+			setoperation_mode(state, OM_DVBT);
 			break;
 		default:
 			return -EINVAL;
@@ -6258,7 +6258,7 @@ static int drxk_set_parameters(struct dvb_frontend *fe)
 	}
 
 	fe->ops.tuner_ops.get_if_frequency(fe, &IF);
-	Start(state, 0, IF);
+	start(state, 0, IF);
 
 	/* After set_frontend, stats aren't avaliable */
 	p->strength.stat[0].scale = FE_SCALE_RELATIVE;
@@ -6278,31 +6278,31 @@ static int drxk_set_parameters(struct dvb_frontend *fe)
 static int get_strength(struct drxk_state *state, u64 *strength)
 {
 	int status;
-	struct SCfgAgc   rfAgc, ifAgc;
-	u32          totalGain  = 0;
+	struct s_cfg_agc   rf_agc, if_agc;
+	u32          total_gain  = 0;
 	u32          atten      = 0;
-	u32          agcRange   = 0;
+	u32          agc_range   = 0;
 	u16            scu_lvl  = 0;
 	u16            scu_coc  = 0;
 	/* FIXME: those are part of the tuner presets */
-	u16 tunerRfGain         = 50; /* Default value on az6007 driver */
-	u16 tunerIfGain         = 40; /* Default value on az6007 driver */
+	u16 tuner_rf_gain         = 50; /* Default value on az6007 driver */
+	u16 tuner_if_gain         = 40; /* Default value on az6007 driver */
 
 	*strength = 0;
 
-	if (IsDVBT(state)) {
-		rfAgc = state->m_dvbtRfAgcCfg;
-		ifAgc = state->m_dvbtIfAgcCfg;
-	} else if (IsQAM(state)) {
-		rfAgc = state->m_qamRfAgcCfg;
-		ifAgc = state->m_qamIfAgcCfg;
+	if (is_dvbt(state)) {
+		rf_agc = state->m_dvbt_rf_agc_cfg;
+		if_agc = state->m_dvbt_if_agc_cfg;
+	} else if (is_qam(state)) {
+		rf_agc = state->m_qam_rf_agc_cfg;
+		if_agc = state->m_qam_if_agc_cfg;
 	} else {
-		rfAgc = state->m_atvRfAgcCfg;
-		ifAgc = state->m_atvIfAgcCfg;
+		rf_agc = state->m_atv_rf_agc_cfg;
+		if_agc = state->m_atv_if_agc_cfg;
 	}
 
-	if (rfAgc.ctrlMode == DRXK_AGC_CTRL_AUTO) {
-		/* SCU outputLevel */
+	if (rf_agc.ctrl_mode == DRXK_AGC_CTRL_AUTO) {
+		/* SCU output_level */
 		status = read16(state, SCU_RAM_AGC_RF_IACCU_HI__A, &scu_lvl);
 		if (status < 0)
 			return status;
@@ -6313,54 +6313,54 @@ static int get_strength(struct drxk_state *state, u64 *strength)
 			return status;
 
 		if (((u32) scu_lvl + (u32) scu_coc) < 0xffff)
-			rfAgc.outputLevel = scu_lvl + scu_coc;
+			rf_agc.output_level = scu_lvl + scu_coc;
 		else
-			rfAgc.outputLevel = 0xffff;
+			rf_agc.output_level = 0xffff;
 
 		/* Take RF gain into account */
-		totalGain += tunerRfGain;
+		total_gain += tuner_rf_gain;
 
 		/* clip output value */
-		if (rfAgc.outputLevel < rfAgc.minOutputLevel)
-			rfAgc.outputLevel = rfAgc.minOutputLevel;
-		if (rfAgc.outputLevel > rfAgc.maxOutputLevel)
-			rfAgc.outputLevel = rfAgc.maxOutputLevel;
+		if (rf_agc.output_level < rf_agc.min_output_level)
+			rf_agc.output_level = rf_agc.min_output_level;
+		if (rf_agc.output_level > rf_agc.max_output_level)
+			rf_agc.output_level = rf_agc.max_output_level;
 
-		agcRange = (u32) (rfAgc.maxOutputLevel - rfAgc.minOutputLevel);
-		if (agcRange > 0) {
+		agc_range = (u32) (rf_agc.max_output_level - rf_agc.min_output_level);
+		if (agc_range > 0) {
 			atten += 100UL *
-				((u32)(tunerRfGain)) *
-				((u32)(rfAgc.outputLevel - rfAgc.minOutputLevel))
-				/ agcRange;
+				((u32)(tuner_rf_gain)) *
+				((u32)(rf_agc.output_level - rf_agc.min_output_level))
+				/ agc_range;
 		}
 	}
 
-	if (ifAgc.ctrlMode == DRXK_AGC_CTRL_AUTO) {
+	if (if_agc.ctrl_mode == DRXK_AGC_CTRL_AUTO) {
 		status = read16(state, SCU_RAM_AGC_IF_IACCU_HI__A,
-				&ifAgc.outputLevel);
+				&if_agc.output_level);
 		if (status < 0)
 			return status;
 
 		status = read16(state, SCU_RAM_AGC_INGAIN_TGT_MIN__A,
-				&ifAgc.top);
+				&if_agc.top);
 		if (status < 0)
 			return status;
 
 		/* Take IF gain into account */
-		totalGain += (u32) tunerIfGain;
+		total_gain += (u32) tuner_if_gain;
 
 		/* clip output value */
-		if (ifAgc.outputLevel < ifAgc.minOutputLevel)
-			ifAgc.outputLevel = ifAgc.minOutputLevel;
-		if (ifAgc.outputLevel > ifAgc.maxOutputLevel)
-			ifAgc.outputLevel = ifAgc.maxOutputLevel;
+		if (if_agc.output_level < if_agc.min_output_level)
+			if_agc.output_level = if_agc.min_output_level;
+		if (if_agc.output_level > if_agc.max_output_level)
+			if_agc.output_level = if_agc.max_output_level;
 
-		agcRange  = (u32) (ifAgc.maxOutputLevel - ifAgc.minOutputLevel);
-		if (agcRange > 0) {
+		agc_range  = (u32) (if_agc.max_output_level - if_agc.min_output_level);
+		if (agc_range > 0) {
 			atten += 100UL *
-				((u32)(tunerIfGain)) *
-				((u32)(ifAgc.outputLevel - ifAgc.minOutputLevel))
-				/ agcRange;
+				((u32)(tuner_if_gain)) *
+				((u32)(if_agc.output_level - if_agc.min_output_level))
+				/ agc_range;
 		}
 	}
 
@@ -6368,8 +6368,8 @@ static int get_strength(struct drxk_state *state, u64 *strength)
 	 * Convert to 0..65535 scale.
 	 * If it can't be measured (AGC is disabled), just show 100%.
 	 */
-	if (totalGain > 0)
-		*strength = (65535UL * atten / totalGain / 100);
+	if (total_gain > 0)
+		*strength = (65535UL * atten / total_gain / 100);
 	else
 		*strength = 65535;
 
@@ -6392,14 +6392,14 @@ static int drxk_get_stats(struct dvb_frontend *fe)
 	u32 pkt_error_count;
 	s32 cnr;
 
-	if (state->m_DrxkState == DRXK_NO_DEV)
+	if (state->m_drxk_state == DRXK_NO_DEV)
 		return -ENODEV;
-	if (state->m_DrxkState == DRXK_UNINITIALIZED)
+	if (state->m_drxk_state == DRXK_UNINITIALIZED)
 		return -EAGAIN;
 
 	/* get status */
 	state->fe_status = 0;
-	GetLockStatus(state, &stat);
+	get_lock_status(state, &stat);
 	if (stat == MPEG_LOCK)
 		state->fe_status |= 0x1f;
 	if (stat == FEC_LOCK)
@@ -6415,7 +6415,7 @@ static int drxk_get_stats(struct dvb_frontend *fe)
 
 
 	if (stat >= DEMOD_LOCK) {
-		GetSignalToNoise(state, &cnr);
+		get_signal_to_noise(state, &cnr);
 		c->cnr.stat[0].svalue = cnr * 100;
 		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
 	} else {
@@ -6522,9 +6522,9 @@ static int drxk_read_signal_strength(struct dvb_frontend *fe,
 
 	dprintk(1, "\n");
 
-	if (state->m_DrxkState == DRXK_NO_DEV)
+	if (state->m_drxk_state == DRXK_NO_DEV)
 		return -ENODEV;
-	if (state->m_DrxkState == DRXK_UNINITIALIZED)
+	if (state->m_drxk_state == DRXK_UNINITIALIZED)
 		return -EAGAIN;
 
 	*strength = c->strength.stat[0].uvalue;
@@ -6538,12 +6538,12 @@ static int drxk_read_snr(struct dvb_frontend *fe, u16 *snr)
 
 	dprintk(1, "\n");
 
-	if (state->m_DrxkState == DRXK_NO_DEV)
+	if (state->m_drxk_state == DRXK_NO_DEV)
 		return -ENODEV;
-	if (state->m_DrxkState == DRXK_UNINITIALIZED)
+	if (state->m_drxk_state == DRXK_UNINITIALIZED)
 		return -EAGAIN;
 
-	GetSignalToNoise(state, &snr2);
+	get_signal_to_noise(state, &snr2);
 
 	/* No negative SNR, clip to zero */
 	if (snr2 < 0)
@@ -6559,12 +6559,12 @@ static int drxk_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 
 	dprintk(1, "\n");
 
-	if (state->m_DrxkState == DRXK_NO_DEV)
+	if (state->m_drxk_state == DRXK_NO_DEV)
 		return -ENODEV;
-	if (state->m_DrxkState == DRXK_UNINITIALIZED)
+	if (state->m_drxk_state == DRXK_UNINITIALIZED)
 		return -EAGAIN;
 
-	DVBTQAMGetAccPktErr(state, &err);
+	dvbtqam_get_acc_pkt_err(state, &err);
 	*ucblocks = (u32) err;
 	return 0;
 }
@@ -6577,9 +6577,9 @@ static int drxk_get_tune_settings(struct dvb_frontend *fe, struct dvb_frontend_t
 
 	dprintk(1, "\n");
 
-	if (state->m_DrxkState == DRXK_NO_DEV)
+	if (state->m_drxk_state == DRXK_NO_DEV)
 		return -ENODEV;
-	if (state->m_DrxkState == DRXK_UNINITIALIZED)
+	if (state->m_drxk_state == DRXK_UNINITIALIZED)
 		return -EAGAIN;
 
 	switch (p->delivery_system) {
@@ -6649,36 +6649,36 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 	state->no_i2c_bridge = config->no_i2c_bridge;
 	state->antenna_gpio = config->antenna_gpio;
 	state->antenna_dvbt = config->antenna_dvbt;
-	state->m_ChunkSize = config->chunk_size;
+	state->m_chunk_size = config->chunk_size;
 	state->enable_merr_cfg = config->enable_merr_cfg;
 
 	if (config->dynamic_clk) {
-		state->m_DVBTStaticCLK = 0;
-		state->m_DVBCStaticCLK = 0;
+		state->m_dvbt_static_clk = 0;
+		state->m_dvbc_static_clk = 0;
 	} else {
-		state->m_DVBTStaticCLK = 1;
-		state->m_DVBCStaticCLK = 1;
+		state->m_dvbt_static_clk = 1;
+		state->m_dvbc_static_clk = 1;
 	}
 
 
 	if (config->mpeg_out_clk_strength)
-		state->m_TSClockkStrength = config->mpeg_out_clk_strength & 0x07;
+		state->m_ts_clockk_strength = config->mpeg_out_clk_strength & 0x07;
 	else
-		state->m_TSClockkStrength = 0x06;
+		state->m_ts_clockk_strength = 0x06;
 
 	if (config->parallel_ts)
-		state->m_enableParallel = true;
+		state->m_enable_parallel = true;
 	else
-		state->m_enableParallel = false;
+		state->m_enable_parallel = false;
 
 	/* NOTE: as more UIO bits will be used, add them to the mask */
-	state->UIO_mask = config->antenna_gpio;
+	state->uio_mask = config->antenna_gpio;
 
 	/* Default gpio to DVB-C */
 	if (!state->antenna_dvbt && state->antenna_gpio)
-		state->m_GPIO |= state->antenna_gpio;
+		state->m_gpio |= state->antenna_gpio;
 	else
-		state->m_GPIO &= ~state->antenna_gpio;
+		state->m_gpio &= ~state->antenna_gpio;
 
 	mutex_init(&state->mutex);
 
diff --git a/drivers/media/dvb-frontends/drxk_hard.h b/drivers/media/dvb-frontends/drxk_hard.h
index b8424f1..db87a6d 100644
--- a/drivers/media/dvb-frontends/drxk_hard.h
+++ b/drivers/media/dvb-frontends/drxk_hard.h
@@ -46,7 +46,7 @@
 #define     IQM_RC_ADJ_SEL_B_QAM                                            0x1
 #define     IQM_RC_ADJ_SEL_B_VSB                                            0x2
 
-enum OperationMode {
+enum operation_mode {
 	OM_NONE,
 	OM_QAM_ITU_A,
 	OM_QAM_ITU_B,
@@ -54,7 +54,7 @@ enum OperationMode {
 	OM_DVBT
 };
 
-enum DRXPowerMode {
+enum drx_power_mode {
 	DRX_POWER_UP = 0,
 	DRX_POWER_MODE_1,
 	DRX_POWER_MODE_2,
@@ -93,8 +93,8 @@ enum DRXPowerMode {
 #endif
 
 
-enum AGC_CTRL_MODE { DRXK_AGC_CTRL_AUTO = 0, DRXK_AGC_CTRL_USER, DRXK_AGC_CTRL_OFF };
-enum EDrxkState {
+enum agc_ctrl_mode { DRXK_AGC_CTRL_AUTO = 0, DRXK_AGC_CTRL_USER, DRXK_AGC_CTRL_OFF };
+enum e_drxk_state {
 	DRXK_UNINITIALIZED = 0,
 	DRXK_STOPPED,
 	DRXK_DTV_STARTED,
@@ -103,7 +103,7 @@ enum EDrxkState {
 	DRXK_NO_DEV			/* If drxk init failed */
 };
 
-enum EDrxkCoefArrayIndex {
+enum e_drxk_coef_array_index {
 	DRXK_COEF_IDX_MN = 0,
 	DRXK_COEF_IDX_FM    ,
 	DRXK_COEF_IDX_L     ,
@@ -113,13 +113,13 @@ enum EDrxkCoefArrayIndex {
 	DRXK_COEF_IDX_I     ,
 	DRXK_COEF_IDX_MAX
 };
-enum EDrxkSifAttenuation {
+enum e_drxk_sif_attenuation {
 	DRXK_SIF_ATTENUATION_0DB,
 	DRXK_SIF_ATTENUATION_3DB,
 	DRXK_SIF_ATTENUATION_6DB,
 	DRXK_SIF_ATTENUATION_9DB
 };
-enum EDrxkConstellation {
+enum e_drxk_constellation {
 	DRX_CONSTELLATION_BPSK = 0,
 	DRX_CONSTELLATION_QPSK,
 	DRX_CONSTELLATION_PSK8,
@@ -133,7 +133,7 @@ enum EDrxkConstellation {
 	DRX_CONSTELLATION_UNKNOWN = DRX_UNKNOWN,
 	DRX_CONSTELLATION_AUTO    = DRX_AUTO
 };
-enum EDrxkInterleaveMode {
+enum e_drxk_interleave_mode {
 	DRXK_QAM_I12_J17    = 16,
 	DRXK_QAM_I_UNKNOWN  = DRX_UNKNOWN
 };
@@ -144,14 +144,14 @@ enum {
 	DRXK_SPIN_UNKNOWN
 };
 
-enum DRXKCfgDvbtSqiSpeed {
+enum drxk_cfg_dvbt_sqi_speed {
 	DRXK_DVBT_SQI_SPEED_FAST = 0,
 	DRXK_DVBT_SQI_SPEED_MEDIUM,
 	DRXK_DVBT_SQI_SPEED_SLOW,
 	DRXK_DVBT_SQI_SPEED_UNKNOWN = DRX_UNKNOWN
 } ;
 
-enum DRXFftmode_t {
+enum drx_fftmode_t {
 	DRX_FFTMODE_2K = 0,
 	DRX_FFTMODE_4K,
 	DRX_FFTMODE_8K,
@@ -159,40 +159,40 @@ enum DRXFftmode_t {
 	DRX_FFTMODE_AUTO    = DRX_AUTO
 };
 
-enum DRXMPEGStrWidth_t {
+enum drxmpeg_str_width_t {
 	DRX_MPEG_STR_WIDTH_1,
 	DRX_MPEG_STR_WIDTH_8
 };
 
-enum DRXQamLockRange_t {
+enum drx_qam_lock_range_t {
 	DRX_QAM_LOCKRANGE_NORMAL,
 	DRX_QAM_LOCKRANGE_EXTENDED
 };
 
-struct DRXKCfgDvbtEchoThres_t {
+struct drxk_cfg_dvbt_echo_thres_t {
 	u16             threshold;
-	enum DRXFftmode_t      fftMode;
+	enum drx_fftmode_t      fft_mode;
 } ;
 
-struct SCfgAgc {
-	enum AGC_CTRL_MODE     ctrlMode;        /* off, user, auto */
-	u16            outputLevel;     /* range dependent on AGC */
-	u16            minOutputLevel;  /* range dependent on AGC */
-	u16            maxOutputLevel;  /* range dependent on AGC */
+struct s_cfg_agc {
+	enum agc_ctrl_mode     ctrl_mode;        /* off, user, auto */
+	u16            output_level;     /* range dependent on AGC */
+	u16            min_output_level;  /* range dependent on AGC */
+	u16            max_output_level;  /* range dependent on AGC */
 	u16            speed;           /* range dependent on AGC */
 	u16            top;             /* rf-agc take over point */
-	u16            cutOffCurrent;   /* rf-agc is accelerated if output current
+	u16            cut_off_current;   /* rf-agc is accelerated if output current
 					   is below cut-off current */
-	u16            IngainTgtMax;
-	u16            FastClipCtrlDelay;
+	u16            ingain_tgt_max;
+	u16            fast_clip_ctrl_delay;
 };
 
-struct SCfgPreSaw {
+struct s_cfg_pre_saw {
 	u16        reference; /* pre SAW reference value, range 0 .. 31 */
-	bool          usePreSaw; /* TRUE algorithms must use pre SAW sense */
+	bool          use_pre_saw; /* TRUE algorithms must use pre SAW sense */
 };
 
-struct DRXKOfdmScCmd_t {
+struct drxk_ofdm_sc_cmd_t {
 	u16 cmd;        /**< Command number */
 	u16 subcmd;     /**< Sub-command parameter*/
 	u16 param0;     /**< General purpous param */
@@ -213,121 +213,121 @@ struct drxk_state {
 
 	struct mutex mutex;
 
-	u32    m_Instance;           /**< Channel 1,2,3 or 4 */
-
-	int    m_ChunkSize;
-	u8 Chunk[256];
-
-	bool   m_hasLNA;
-	bool   m_hasDVBT;
-	bool   m_hasDVBC;
-	bool   m_hasAudio;
-	bool   m_hasATV;
-	bool   m_hasOOB;
-	bool   m_hasSAWSW;         /**< TRUE if mat_tx is available */
-	bool   m_hasGPIO1;         /**< TRUE if mat_rx is available */
-	bool   m_hasGPIO2;         /**< TRUE if GPIO is available */
-	bool   m_hasIRQN;          /**< TRUE if IRQN is available */
-	u16    m_oscClockFreq;
-	u16    m_HICfgTimingDiv;
-	u16    m_HICfgBridgeDelay;
-	u16    m_HICfgWakeUpKey;
-	u16    m_HICfgTimeout;
-	u16    m_HICfgCtrl;
-	s32    m_sysClockFreq;      /**< system clock frequency in kHz */
-
-	enum EDrxkState    m_DrxkState;      /**< State of Drxk (init,stopped,started) */
-	enum OperationMode m_OperationMode;  /**< digital standards */
-	struct SCfgAgc     m_vsbRfAgcCfg;    /**< settings for VSB RF-AGC */
-	struct SCfgAgc     m_vsbIfAgcCfg;    /**< settings for VSB IF-AGC */
-	u16                m_vsbPgaCfg;      /**< settings for VSB PGA */
-	struct SCfgPreSaw  m_vsbPreSawCfg;   /**< settings for pre SAW sense */
+	u32    m_instance;           /**< Channel 1,2,3 or 4 */
+
+	int    m_chunk_size;
+	u8 chunk[256];
+
+	bool   m_has_lna;
+	bool   m_has_dvbt;
+	bool   m_has_dvbc;
+	bool   m_has_audio;
+	bool   m_has_atv;
+	bool   m_has_oob;
+	bool   m_has_sawsw;         /* TRUE if mat_tx is available */
+	bool   m_has_gpio1;         /* TRUE if mat_rx is available */
+	bool   m_has_gpio2;         /* TRUE if GPIO is available */
+	bool   m_has_irqn;          /* TRUE if IRQN is available */
+	u16    m_osc_clock_freq;
+	u16    m_hi_cfg_timing_div;
+	u16    m_hi_cfg_bridge_delay;
+	u16    m_hi_cfg_wake_up_key;
+	u16    m_hi_cfg_timeout;
+	u16    m_hi_cfg_ctrl;
+	s32    m_sys_clock_freq;      /**< system clock frequency in kHz */
+
+	enum e_drxk_state    m_drxk_state;      /**< State of Drxk (init,stopped,started) */
+	enum operation_mode m_operation_mode;  /**< digital standards */
+	struct s_cfg_agc     m_vsb_rf_agc_cfg;    /**< settings for VSB RF-AGC */
+	struct s_cfg_agc     m_vsb_if_agc_cfg;    /**< settings for VSB IF-AGC */
+	u16                m_vsb_pga_cfg;      /**< settings for VSB PGA */
+	struct s_cfg_pre_saw  m_vsb_pre_saw_cfg;   /**< settings for pre SAW sense */
 	s32    m_Quality83percent;  /**< MER level (*0.1 dB) for 83% quality indication */
 	s32    m_Quality93percent;  /**< MER level (*0.1 dB) for 93% quality indication */
-	bool   m_smartAntInverted;
-	bool   m_bDebugEnableBridge;
-	bool   m_bPDownOpenBridge;  /**< only open DRXK bridge before power-down once it has been accessed */
-	bool   m_bPowerDown;        /**< Power down when not used */
-
-	u32    m_IqmFsRateOfs;      /**< frequency shift as written to DRXK register (28bit fixpoint) */
-
-	bool   m_enableMPEGOutput;  /**< If TRUE, enable MPEG output */
-	bool   m_insertRSByte;      /**< If TRUE, insert RS byte */
-	bool   m_enableParallel;    /**< If TRUE, parallel out otherwise serial */
-	bool   m_invertDATA;        /**< If TRUE, invert DATA signals */
-	bool   m_invertERR;         /**< If TRUE, invert ERR signal */
-	bool   m_invertSTR;         /**< If TRUE, invert STR signals */
-	bool   m_invertVAL;         /**< If TRUE, invert VAL signals */
-	bool   m_invertCLK;         /**< If TRUE, invert CLK signals */
-	bool   m_DVBCStaticCLK;
-	bool   m_DVBTStaticCLK;     /**< If TRUE, static MPEG clockrate will
+	bool   m_smart_ant_inverted;
+	bool   m_b_debug_enable_bridge;
+	bool   m_b_p_down_open_bridge;  /**< only open DRXK bridge before power-down once it has been accessed */
+	bool   m_b_power_down;        /**< Power down when not used */
+
+	u32    m_iqm_fs_rate_ofs;      /**< frequency shift as written to DRXK register (28bit fixpoint) */
+
+	bool   m_enable_mpeg_output;  /**< If TRUE, enable MPEG output */
+	bool   m_insert_rs_byte;      /**< If TRUE, insert RS byte */
+	bool   m_enable_parallel;    /**< If TRUE, parallel out otherwise serial */
+	bool   m_invert_data;        /**< If TRUE, invert DATA signals */
+	bool   m_invert_err;         /**< If TRUE, invert ERR signal */
+	bool   m_invert_str;         /**< If TRUE, invert STR signals */
+	bool   m_invert_val;         /**< If TRUE, invert VAL signals */
+	bool   m_invert_clk;         /**< If TRUE, invert CLK signals */
+	bool   m_dvbc_static_clk;
+	bool   m_dvbt_static_clk;     /**< If TRUE, static MPEG clockrate will
 					 be used, otherwise clockrate will
 					 adapt to the bitrate of the TS */
-	u32    m_DVBTBitrate;
-	u32    m_DVBCBitrate;
+	u32    m_dvbt_bitrate;
+	u32    m_dvbc_bitrate;
 
-	u8     m_TSDataStrength;
-	u8     m_TSClockkStrength;
+	u8     m_ts_data_strength;
+	u8     m_ts_clockk_strength;
 
 	bool   m_itut_annex_c;      /* If true, uses ITU-T DVB-C Annex C, instead of Annex A */
 
-	enum DRXMPEGStrWidth_t  m_widthSTR;    /**< MPEG start width */
-	u32    m_mpegTsStaticBitrate;          /**< Maximum bitrate in b/s in case
+	enum drxmpeg_str_width_t  m_width_str;    /**< MPEG start width */
+	u32    m_mpeg_ts_static_bitrate;          /**< Maximum bitrate in b/s in case
 						    static clockrate is selected */
 
-	/* LARGE_INTEGER   m_StartTime; */     /**< Contains the time of the last demod start */
-	s32    m_MpegLockTimeOut;      /**< WaitForLockStatus Timeout (counts from start time) */
-	s32    m_DemodLockTimeOut;     /**< WaitForLockStatus Timeout (counts from start time) */
-
-	bool   m_disableTEIhandling;
-
-	bool   m_RfAgcPol;
-	bool   m_IfAgcPol;
-
-	struct SCfgAgc    m_atvRfAgcCfg;  /**< settings for ATV RF-AGC */
-	struct SCfgAgc    m_atvIfAgcCfg;  /**< settings for ATV IF-AGC */
-	struct SCfgPreSaw m_atvPreSawCfg; /**< settings for ATV pre SAW sense */
-	bool              m_phaseCorrectionBypass;
-	s16               m_atvTopVidPeak;
-	u16               m_atvTopNoiseTh;
-	enum EDrxkSifAttenuation m_sifAttenuation;
-	bool              m_enableCVBSOutput;
-	bool              m_enableSIFOutput;
-	bool              m_bMirrorFreqSpect;
-	enum EDrxkConstellation  m_Constellation; /**< Constellation type of the channel */
-	u32               m_CurrSymbolRate;       /**< Current QAM symbol rate */
-	struct SCfgAgc    m_qamRfAgcCfg;          /**< settings for QAM RF-AGC */
-	struct SCfgAgc    m_qamIfAgcCfg;          /**< settings for QAM IF-AGC */
-	u16               m_qamPgaCfg;            /**< settings for QAM PGA */
-	struct SCfgPreSaw m_qamPreSawCfg;         /**< settings for QAM pre SAW sense */
-	enum EDrxkInterleaveMode m_qamInterleaveMode; /**< QAM Interleave mode */
-	u16               m_fecRsPlen;
-	u16               m_fecRsPrescale;
-
-	enum DRXKCfgDvbtSqiSpeed m_sqiSpeed;
-
-	u16               m_GPIO;
-	u16               m_GPIOCfg;
-
-	struct SCfgAgc    m_dvbtRfAgcCfg;     /**< settings for QAM RF-AGC */
-	struct SCfgAgc    m_dvbtIfAgcCfg;     /**< settings for QAM IF-AGC */
-	struct SCfgPreSaw m_dvbtPreSawCfg;    /**< settings for QAM pre SAW sense */
-
-	u16               m_agcFastClipCtrlDelay;
-	bool              m_adcCompPassed;
+	/* LARGE_INTEGER   m_startTime; */     /**< Contains the time of the last demod start */
+	s32    m_mpeg_lock_time_out;      /**< WaitForLockStatus Timeout (counts from start time) */
+	s32    m_demod_lock_time_out;     /**< WaitForLockStatus Timeout (counts from start time) */
+
+	bool   m_disable_te_ihandling;
+
+	bool   m_rf_agc_pol;
+	bool   m_if_agc_pol;
+
+	struct s_cfg_agc    m_atv_rf_agc_cfg;  /**< settings for ATV RF-AGC */
+	struct s_cfg_agc    m_atv_if_agc_cfg;  /**< settings for ATV IF-AGC */
+	struct s_cfg_pre_saw m_atv_pre_saw_cfg; /**< settings for ATV pre SAW sense */
+	bool              m_phase_correction_bypass;
+	s16               m_atv_top_vid_peak;
+	u16               m_atv_top_noise_th;
+	enum e_drxk_sif_attenuation m_sif_attenuation;
+	bool              m_enable_cvbs_output;
+	bool              m_enable_sif_output;
+	bool              m_b_mirror_freq_spect;
+	enum e_drxk_constellation  m_constellation; /**< constellation type of the channel */
+	u32               m_curr_symbol_rate;       /**< Current QAM symbol rate */
+	struct s_cfg_agc    m_qam_rf_agc_cfg;          /**< settings for QAM RF-AGC */
+	struct s_cfg_agc    m_qam_if_agc_cfg;          /**< settings for QAM IF-AGC */
+	u16               m_qam_pga_cfg;            /**< settings for QAM PGA */
+	struct s_cfg_pre_saw m_qam_pre_saw_cfg;         /**< settings for QAM pre SAW sense */
+	enum e_drxk_interleave_mode m_qam_interleave_mode; /**< QAM Interleave mode */
+	u16               m_fec_rs_plen;
+	u16               m_fec_rs_prescale;
+
+	enum drxk_cfg_dvbt_sqi_speed m_sqi_speed;
+
+	u16               m_gpio;
+	u16               m_gpio_cfg;
+
+	struct s_cfg_agc    m_dvbt_rf_agc_cfg;     /**< settings for QAM RF-AGC */
+	struct s_cfg_agc    m_dvbt_if_agc_cfg;     /**< settings for QAM IF-AGC */
+	struct s_cfg_pre_saw m_dvbt_pre_saw_cfg;    /**< settings for QAM pre SAW sense */
+
+	u16               m_agcfast_clip_ctrl_delay;
+	bool              m_adc_comp_passed;
 	u16               m_adcCompCoef[64];
-	u16               m_adcState;
+	u16               m_adc_state;
 
 	u8               *m_microcode;
 	int               m_microcode_length;
-	bool		  m_DRXK_A3_ROM_CODE;
-	bool              m_DRXK_A3_PATCH_CODE;
+	bool		  m_drxk_a3_rom_code;
+	bool              m_drxk_a3_patch_code;
 
 	bool              m_rfmirror;
-	u8                m_deviceSpin;
-	u32               m_iqmRcRate;
+	u8                m_device_spin;
+	u32               m_iqm_rc_rate;
 
-	enum DRXPowerMode m_currentPowerMode;
+	enum drx_power_mode m_current_power_mode;
 
 	/* when true, avoids other devices to use the I2C bus */
 	bool		  drxk_i2c_exclusive_lock;
@@ -337,7 +337,7 @@ struct drxk_state {
 	 * at struct drxk_config.
 	 */
 
-	u16	UIO_mask;	/* Bits used by UIO */
+	u16	uio_mask;	/* Bits used by UIO */
 
 	bool	enable_merr_cfg;
 	bool	single_master;
-- 
1.8.1.4

