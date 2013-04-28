Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584Ab3D1PsG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Apr 2013 11:48:06 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3SFm5Gm013745
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 28 Apr 2013 11:48:05 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 9/9] [media] drxk_hard: Remove most 80-cols checkpatch warnings
Date: Sun, 28 Apr 2013 12:47:51 -0300
Message-Id: <1367164071-11468-10-git-send-email-mchehab@redhat.com>
In-Reply-To: <1367164071-11468-1-git-send-email-mchehab@redhat.com>
References: <1367164071-11468-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are a few cases where breaking the code into separate
lines make it worse to read. However, on several places,
breaking it to make checkpatch.pl happier is OK and improves
code readability.

So, break longer lines where that won't cause harm.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/drxk_hard.c | 406 +++++++++++++++++++++-----------
 1 file changed, 275 insertions(+), 131 deletions(-)

diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index 7f4b514..afdac10 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -189,8 +189,10 @@ static inline u32 Frac28a(u32 a, u32 c)
 	u32 R0 = 0;
 
 	R0 = (a % c) << 4;	/* 32-28 == 4 shifts possible at max */
-	Q1 = a / c;		/* integer part, only the 4 least significant bits
-				   will be visible in the result */
+	Q1 = a / c;		/*
+				 * integer part, only the 4 least significant
+				 * bits will be visible in the result
+				 */
 
 	/* division using radix 16, 7 nibbles in the result */
 	for (i = 0; i < 7; i++) {
@@ -783,7 +785,8 @@ static int drxx_open(struct drxk_state *state)
 
 	dprintk(1, "\n");
 	/* stop lock indicator process */
-	status = write16(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
+	status = write16(state, SCU_RAM_GPIO__A,
+			 SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
 	if (status < 0)
 		goto error;
 	/* Check device id */
@@ -817,7 +820,8 @@ static int get_device_capabilities(struct drxk_state *state)
 
 	/* driver 0.9.0 */
 	/* stop lock indicator process */
-	status = write16(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
+	status = write16(state, SCU_RAM_GPIO__A,
+			 SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
 	if (status < 0)
 		goto error;
 	status = write16(state, SIO_TOP_COMM_KEY__A, SIO_TOP_COMM_KEY_KEY);
@@ -1055,22 +1059,28 @@ static int hi_cfg_command(struct drxk_state *state)
 
 	mutex_lock(&state->mutex);
 
-	status = write16(state, SIO_HI_RA_RAM_PAR_6__A, state->m_hi_cfg_timeout);
+	status = write16(state, SIO_HI_RA_RAM_PAR_6__A,
+			 state->m_hi_cfg_timeout);
 	if (status < 0)
 		goto error;
-	status = write16(state, SIO_HI_RA_RAM_PAR_5__A, state->m_hi_cfg_ctrl);
+	status = write16(state, SIO_HI_RA_RAM_PAR_5__A,
+			 state->m_hi_cfg_ctrl);
 	if (status < 0)
 		goto error;
-	status = write16(state, SIO_HI_RA_RAM_PAR_4__A, state->m_hi_cfg_wake_up_key);
+	status = write16(state, SIO_HI_RA_RAM_PAR_4__A,
+			 state->m_hi_cfg_wake_up_key);
 	if (status < 0)
 		goto error;
-	status = write16(state, SIO_HI_RA_RAM_PAR_3__A, state->m_hi_cfg_bridge_delay);
+	status = write16(state, SIO_HI_RA_RAM_PAR_3__A,
+			 state->m_hi_cfg_bridge_delay);
 	if (status < 0)
 		goto error;
-	status = write16(state, SIO_HI_RA_RAM_PAR_2__A, state->m_hi_cfg_timing_div);
+	status = write16(state, SIO_HI_RA_RAM_PAR_2__A,
+			 state->m_hi_cfg_timing_div);
 	if (status < 0)
 		goto error;
-	status = write16(state, SIO_HI_RA_RAM_PAR_1__A, SIO_HI_RA_RAM_PAR_1_PAR1_SEC_KEY);
+	status = write16(state, SIO_HI_RA_RAM_PAR_1__A,
+			 SIO_HI_RA_RAM_PAR_1_PAR1_SEC_KEY);
 	if (status < 0)
 		goto error;
 	status = hi_command(state, SIO_HI_RA_RAM_CMD_CONFIG, 0);
@@ -1109,7 +1119,8 @@ static int mpegts_configure_pins(struct drxk_state *state, bool mpeg_enable)
 		state->m_enable_parallel ? "parallel" : "serial");
 
 	/* stop lock indicator process */
-	status = write16(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
+	status = write16(state, SCU_RAM_GPIO__A,
+			 SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
 	if (status < 0)
 		goto error;
 
@@ -1181,25 +1192,32 @@ static int mpegts_configure_pins(struct drxk_state *state, bool mpeg_enable)
 
 		if (state->m_enable_parallel == true) {
 			/* paralel -> enable MD1 to MD7 */
-			status = write16(state, SIO_PDR_MD1_CFG__A, sio_pdr_mdx_cfg);
+			status = write16(state, SIO_PDR_MD1_CFG__A,
+					 sio_pdr_mdx_cfg);
 			if (status < 0)
 				goto error;
-			status = write16(state, SIO_PDR_MD2_CFG__A, sio_pdr_mdx_cfg);
+			status = write16(state, SIO_PDR_MD2_CFG__A,
+					 sio_pdr_mdx_cfg);
 			if (status < 0)
 				goto error;
-			status = write16(state, SIO_PDR_MD3_CFG__A, sio_pdr_mdx_cfg);
+			status = write16(state, SIO_PDR_MD3_CFG__A,
+					 sio_pdr_mdx_cfg);
 			if (status < 0)
 				goto error;
-			status = write16(state, SIO_PDR_MD4_CFG__A, sio_pdr_mdx_cfg);
+			status = write16(state, SIO_PDR_MD4_CFG__A,
+					 sio_pdr_mdx_cfg);
 			if (status < 0)
 				goto error;
-			status = write16(state, SIO_PDR_MD5_CFG__A, sio_pdr_mdx_cfg);
+			status = write16(state, SIO_PDR_MD5_CFG__A,
+					 sio_pdr_mdx_cfg);
 			if (status < 0)
 				goto error;
-			status = write16(state, SIO_PDR_MD6_CFG__A, sio_pdr_mdx_cfg);
+			status = write16(state, SIO_PDR_MD6_CFG__A,
+					 sio_pdr_mdx_cfg);
 			if (status < 0)
 				goto error;
-			status = write16(state, SIO_PDR_MD7_CFG__A, sio_pdr_mdx_cfg);
+			status = write16(state, SIO_PDR_MD7_CFG__A,
+					 sio_pdr_mdx_cfg);
 			if (status < 0)
 				goto error;
 		} else {
@@ -1390,7 +1408,8 @@ static int dvbt_enable_ofdm_token_ring(struct drxk_state *state, bool enable)
 	end = jiffies + msecs_to_jiffies(DRXK_OFDM_TR_SHUTDOWN_TIMEOUT);
 	do {
 		status = read16(state, SIO_OFDM_SH_OFDM_RING_STATUS__A, &data);
-		if ((status >= 0 && data == desired_status) || time_is_after_jiffies(end))
+		if ((status >= 0 && data == desired_status)
+		    || time_is_after_jiffies(end))
 			break;
 		usleep_range(1000, 2000);
 	} while (1);
@@ -1487,7 +1506,8 @@ static int scu_command(struct drxk_state *state,
 		int ii;
 
 		for (ii = result_len - 1; ii >= 0; ii -= 1) {
-			status = read16(state, SCU_RAM_PARAM_0__A - ii, &result[ii]);
+			status = read16(state, SCU_RAM_PARAM_0__A - ii,
+					&result[ii]);
 			if (status < 0)
 				goto error;
 		}
@@ -1683,11 +1703,17 @@ static int power_down_dvbt(struct drxk_state *state, bool set_power_mode)
 		goto error;
 	if (data == SCU_COMM_EXEC_ACTIVE) {
 		/* Send OFDM stop command */
-		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_STOP, 0, NULL, 1, &cmd_result);
+		status = scu_command(state,
+				     SCU_RAM_COMMAND_STANDARD_OFDM
+				     | SCU_RAM_COMMAND_CMD_DEMOD_STOP,
+				     0, NULL, 1, &cmd_result);
 		if (status < 0)
 			goto error;
 		/* Send OFDM reset command */
-		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_RESET, 0, NULL, 1, &cmd_result);
+		status = scu_command(state,
+				     SCU_RAM_COMMAND_STANDARD_OFDM
+				     | SCU_RAM_COMMAND_CMD_DEMOD_RESET,
+				     0, NULL, 1, &cmd_result);
 		if (status < 0)
 			goto error;
 	}
@@ -1733,7 +1759,8 @@ static int setoperation_mode(struct drxk_state *state,
 	 */
 
 	/* disable HW lock indicator */
-	status = write16(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
+	status = write16(state, SCU_RAM_GPIO__A,
+			 SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
 	if (status < 0)
 		goto error;
 
@@ -2083,7 +2110,8 @@ static int mpegts_dto_setup(struct drxk_state *state,
 	status = write32(state, FEC_OC_RCN_CTL_RATE_LO__A, fec_oc_rcn_ctl_rate);
 	if (status < 0)
 		goto error;
-	status = write16(state, FEC_OC_TMD_INT_UPD_RATE__A, fec_oc_tmd_int_upd_rate);
+	status = write16(state, FEC_OC_TMD_INT_UPD_RATE__A,
+			 fec_oc_tmd_int_upd_rate);
 	if (status < 0)
 		goto error;
 	status = write16(state, FEC_OC_TMD_MODE__A, fec_oc_tmd_mode);
@@ -2193,17 +2221,21 @@ static int set_agc_rf(struct drxk_state *state,
 
 		/* Set TOP, only if IF-AGC is in AUTO mode */
 		if (p_if_agc_settings->ctrl_mode == DRXK_AGC_CTRL_AUTO)
-			status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A, p_agc_cfg->top);
+			status = write16(state,
+					 SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A,
+					 p_agc_cfg->top);
 			if (status < 0)
 				goto error;
 
 		/* Cut-Off current */
-		status = write16(state, SCU_RAM_AGC_RF_IACCU_HI_CO__A, p_agc_cfg->cut_off_current);
+		status = write16(state, SCU_RAM_AGC_RF_IACCU_HI_CO__A,
+				 p_agc_cfg->cut_off_current);
 		if (status < 0)
 			goto error;
 
 		/* Max. output level */
-		status = write16(state, SCU_RAM_AGC_RF_MAX__A, p_agc_cfg->max_output_level);
+		status = write16(state, SCU_RAM_AGC_RF_MAX__A,
+				 p_agc_cfg->max_output_level);
 		if (status < 0)
 			goto error;
 
@@ -2238,7 +2270,8 @@ static int set_agc_rf(struct drxk_state *state,
 			goto error;
 
 		/* Write value to output pin */
-		status = write16(state, SCU_RAM_AGC_RF_IACCU_HI__A, p_agc_cfg->output_level);
+		status = write16(state, SCU_RAM_AGC_RF_IACCU_HI__A,
+				 p_agc_cfg->output_level);
 		if (status < 0)
 			goto error;
 		break;
@@ -2332,7 +2365,8 @@ static int set_agc_if(struct drxk_state *state,
 		if (p_rf_agc_settings == NULL)
 			return -1;
 		/* Restore TOP */
-		status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A, p_rf_agc_settings->top);
+		status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A,
+				 p_rf_agc_settings->top);
 		if (status < 0)
 			goto error;
 		break;
@@ -2365,7 +2399,8 @@ static int set_agc_if(struct drxk_state *state,
 			goto error;
 
 		/* Write value to output pin */
-		status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A, p_agc_cfg->output_level);
+		status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A,
+				 p_agc_cfg->output_level);
 		if (status < 0)
 			goto error;
 		break;
@@ -2470,16 +2505,20 @@ static int get_dvbt_signal_to_noise(struct drxk_state *state,
 
 	dprintk(1, "\n");
 
-	status = read16(state, OFDM_EQ_TOP_TD_TPS_PWR_OFS__A, &eq_reg_td_tps_pwr_ofs);
+	status = read16(state, OFDM_EQ_TOP_TD_TPS_PWR_OFS__A,
+			&eq_reg_td_tps_pwr_ofs);
 	if (status < 0)
 		goto error;
-	status = read16(state, OFDM_EQ_TOP_TD_REQ_SMB_CNT__A, &eq_reg_td_req_smb_cnt);
+	status = read16(state, OFDM_EQ_TOP_TD_REQ_SMB_CNT__A,
+			&eq_reg_td_req_smb_cnt);
 	if (status < 0)
 		goto error;
-	status = read16(state, OFDM_EQ_TOP_TD_SQR_ERR_EXP__A, &eq_reg_td_sqr_err_exp);
+	status = read16(state, OFDM_EQ_TOP_TD_SQR_ERR_EXP__A,
+			&eq_reg_td_sqr_err_exp);
 	if (status < 0)
 		goto error;
-	status = read16(state, OFDM_EQ_TOP_TD_SQR_ERR_I__A, &reg_data);
+	status = read16(state, OFDM_EQ_TOP_TD_SQR_ERR_I__A,
+			&reg_data);
 	if (status < 0)
 		goto error;
 	/* Extend SQR_ERR_I operational range */
@@ -2497,7 +2536,8 @@ static int get_dvbt_signal_to_noise(struct drxk_state *state,
 		(eq_reg_td_sqr_err_q < 0x00000FFFUL))
 		eq_reg_td_sqr_err_q += 0x00010000UL;
 
-	status = read16(state, OFDM_SC_RA_RAM_OP_PARAM__A, &transmission_params);
+	status = read16(state, OFDM_SC_RA_RAM_OP_PARAM__A,
+			&transmission_params);
 	if (status < 0)
 		goto error;
 
@@ -2604,12 +2644,14 @@ static int get_dvbt_quality(struct drxk_state *state, s32 *p_quality)
 		status = get_dvbt_signal_to_noise(state, &signal_to_noise);
 		if (status < 0)
 			break;
-		status = read16(state, OFDM_EQ_TOP_TD_TPS_CONST__A, &constellation);
+		status = read16(state, OFDM_EQ_TOP_TD_TPS_CONST__A,
+				&constellation);
 		if (status < 0)
 			break;
 		constellation &= OFDM_EQ_TOP_TD_TPS_CONST__M;
 
-		status = read16(state, OFDM_EQ_TOP_TD_TPS_CODE_HP__A, &code_rate);
+		status = read16(state, OFDM_EQ_TOP_TD_TPS_CODE_HP__A,
+				&code_rate);
 		if (status < 0)
 			break;
 		code_rate &= OFDM_EQ_TOP_TD_TPS_CODE_HP__M;
@@ -2723,15 +2765,18 @@ static int ConfigureI2CBridge(struct drxk_state *state, bool b_enable_bridge)
 	if (state->no_i2c_bridge)
 		return 0;
 
-	status = write16(state, SIO_HI_RA_RAM_PAR_1__A, SIO_HI_RA_RAM_PAR_1_PAR1_SEC_KEY);
+	status = write16(state, SIO_HI_RA_RAM_PAR_1__A,
+			 SIO_HI_RA_RAM_PAR_1_PAR1_SEC_KEY);
 	if (status < 0)
 		goto error;
 	if (b_enable_bridge) {
-		status = write16(state, SIO_HI_RA_RAM_PAR_2__A, SIO_HI_RA_RAM_PAR_2_BRD_CFG_CLOSED);
+		status = write16(state, SIO_HI_RA_RAM_PAR_2__A,
+				 SIO_HI_RA_RAM_PAR_2_BRD_CFG_CLOSED);
 		if (status < 0)
 			goto error;
 	} else {
-		status = write16(state, SIO_HI_RA_RAM_PAR_2__A, SIO_HI_RA_RAM_PAR_2_BRD_CFG_OPEN);
+		status = write16(state, SIO_HI_RA_RAM_PAR_2__A,
+				 SIO_HI_RA_RAM_PAR_2_BRD_CFG_OPEN);
 		if (status < 0)
 			goto error;
 	}
@@ -3013,7 +3058,8 @@ static int init_agc(struct drxk_state *state, bool is_dtv)
 	ingain_tgt_max = 5119;
 	fast_clp_ctrl_delay = state->m_qam_if_agc_cfg.fast_clip_ctrl_delay;
 
-	status = write16(state, SCU_RAM_AGC_FAST_CLP_CTRL_DELAY__A, fast_clp_ctrl_delay);
+	status = write16(state, SCU_RAM_AGC_FAST_CLP_CTRL_DELAY__A,
+			 fast_clp_ctrl_delay);
 	if (status < 0)
 		goto error;
 
@@ -3029,10 +3075,12 @@ static int init_agc(struct drxk_state *state, bool is_dtv)
 	status = write16(state, SCU_RAM_AGC_INGAIN_TGT_MAX__A, ingain_tgt_max);
 	if (status < 0)
 		goto error;
-	status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MIN__A, if_iaccu_hi_tgt_min);
+	status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MIN__A,
+			 if_iaccu_hi_tgt_min);
 	if (status < 0)
 		goto error;
-	status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A, if_iaccu_hi_tgt_max);
+	status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A,
+			 if_iaccu_hi_tgt_max);
 	if (status < 0)
 		goto error;
 	status = write16(state, SCU_RAM_AGC_IF_IACCU_HI__A, 0);
@@ -3054,10 +3102,12 @@ static int init_agc(struct drxk_state *state, bool is_dtv)
 	if (status < 0)
 		goto error;
 
-	status = write16(state, SCU_RAM_AGC_KI_INNERGAIN_MIN__A, ki_innergain_min);
+	status = write16(state, SCU_RAM_AGC_KI_INNERGAIN_MIN__A,
+			 ki_innergain_min);
 	if (status < 0)
 		goto error;
-	status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT__A, if_iaccu_hi_tgt);
+	status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT__A,
+			 if_iaccu_hi_tgt);
 	if (status < 0)
 		goto error;
 	status = write16(state, SCU_RAM_AGC_CLP_CYCLEN__A, clp_cyclen);
@@ -3158,7 +3208,8 @@ static int dvbtqam_get_acc_pkt_err(struct drxk_state *state, u16 *packet_err)
 	if (packet_err == NULL)
 		status = write16(state, SCU_RAM_FEC_ACCUM_PKT_FAILURES__A, 0);
 	else
-		status = read16(state, SCU_RAM_FEC_ACCUM_PKT_FAILURES__A, packet_err);
+		status = read16(state, SCU_RAM_FEC_ACCUM_PKT_FAILURES__A,
+				packet_err);
 	if (status < 0)
 		pr_err("Error %d on %s\n", status, __func__);
 	return status;
@@ -3332,7 +3383,7 @@ static int dvbt_ctrl_set_fr_enable(struct drxk_state *state, bool *enabled)
 }
 
 static int dvbt_ctrl_set_echo_threshold(struct drxk_state *state,
-				    struct drxk_cfg_dvbt_echo_thres_t *echo_thres)
+				struct drxk_cfg_dvbt_echo_thres_t *echo_thres)
 {
 	u16 data = 0;
 	int status;
@@ -3421,7 +3472,8 @@ static int dvbt_activate_presets(struct drxk_state *state)
 	status = dvbt_ctrl_set_echo_threshold(state, &echo_thres8k);
 	if (status < 0)
 		goto error;
-	status = write16(state, SCU_RAM_AGC_INGAIN_TGT_MAX__A, state->m_dvbt_if_agc_cfg.ingain_tgt_max);
+	status = write16(state, SCU_RAM_AGC_INGAIN_TGT_MAX__A,
+			 state->m_dvbt_if_agc_cfg.ingain_tgt_max);
 error:
 	if (status < 0)
 		pr_err("Error %d on %s\n", status, __func__);
@@ -3451,12 +3503,17 @@ static int set_dvbt_standard(struct drxk_state *state,
 	/* added antenna switch */
 	switch_antenna_to_dvbt(state);
 	/* send OFDM reset command */
-	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_RESET, 0, NULL, 1, &cmd_result);
+	status = scu_command(state,
+			     SCU_RAM_COMMAND_STANDARD_OFDM
+			     | SCU_RAM_COMMAND_CMD_DEMOD_RESET,
+			     0, NULL, 1, &cmd_result);
 	if (status < 0)
 		goto error;
 
 	/* send OFDM setenv command */
-	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_SET_ENV, 0, NULL, 1, &cmd_result);
+	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM
+			     | SCU_RAM_COMMAND_CMD_DEMOD_SET_ENV,
+			     0, NULL, 1, &cmd_result);
 	if (status < 0)
 		goto error;
 
@@ -3510,7 +3567,7 @@ static int set_dvbt_standard(struct drxk_state *state,
 	status = write16(state, IQM_RC_STRETCH__A, 16);
 	if (status < 0)
 		goto error;
-	status = write16(state, IQM_CF_OUT_ENA__A, 0x4);	/* enable output 2 */
+	status = write16(state, IQM_CF_OUT_ENA__A, 0x4); /* enable output 2 */
 	if (status < 0)
 		goto error;
 	status = write16(state, IQM_CF_DS_ENA__A, 0x4);	/* decimate output 2 */
@@ -3531,7 +3588,8 @@ static int set_dvbt_standard(struct drxk_state *state,
 	if (status < 0)
 		goto error;
 
-	status = bl_chain_cmd(state, DRXK_BL_ROM_OFFSET_TAPS_DVBT, DRXK_BLCC_NR_ELEMENTS_TAPS, DRXK_BLC_TIMEOUT);
+	status = bl_chain_cmd(state, DRXK_BL_ROM_OFFSET_TAPS_DVBT,
+			      DRXK_BLCC_NR_ELEMENTS_TAPS, DRXK_BLC_TIMEOUT);
 	if (status < 0)
 		goto error;
 
@@ -3585,7 +3643,8 @@ static int set_dvbt_standard(struct drxk_state *state,
 
 	if (!state->m_drxk_a3_rom_code) {
 		/* AGCInit() is not done for DVBT, so set agcfast_clip_ctrl_delay  */
-		status = write16(state, SCU_RAM_AGC_FAST_CLP_CTRL_DELAY__A, state->m_dvbt_if_agc_cfg.fast_clip_ctrl_delay);
+		status = write16(state, SCU_RAM_AGC_FAST_CLP_CTRL_DELAY__A,
+				 state->m_dvbt_if_agc_cfg.fast_clip_ctrl_delay);
 		if (status < 0)
 			goto error;
 	}
@@ -3650,7 +3709,9 @@ static int dvbt_start(struct drxk_state *state)
 	/* start correct processes to get in lock */
 	/* DRXK: OFDM_SC_RA_RAM_PROC_LOCKTRACK is no longer in mapfile! */
 	param1 = OFDM_SC_RA_RAM_LOCKTRACK_MIN;
-	status = dvbt_sc_command(state, OFDM_SC_RA_RAM_CMD_PROC_START, 0, OFDM_SC_RA_RAM_SW_EVENT_RUN_NMASK__M, param1, 0, 0, 0);
+	status = dvbt_sc_command(state, OFDM_SC_RA_RAM_CMD_PROC_START, 0,
+				 OFDM_SC_RA_RAM_SW_EVENT_RUN_NMASK__M, param1,
+				 0, 0, 0);
 	if (status < 0)
 		goto error;
 	/* start FEC OC */
@@ -3686,9 +3747,12 @@ static int set_dvbt(struct drxk_state *state, u16 intermediate_freqk_hz,
 	u16 param1;
 	int status;
 
-	dprintk(1, "IF =%d, TFO = %d\n", intermediate_freqk_hz, tuner_freq_offset);
+	dprintk(1, "IF =%d, TFO = %d\n",
+		intermediate_freqk_hz, tuner_freq_offset);
 
-	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_STOP, 0, NULL, 1, &cmd_result);
+	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM
+			    | SCU_RAM_COMMAND_CMD_DEMOD_STOP,
+			    0, NULL, 1, &cmd_result);
 	if (status < 0)
 		goto error;
 
@@ -3711,7 +3775,7 @@ static int set_dvbt(struct drxk_state *state, u16 intermediate_freqk_hz,
 	if (status < 0)
 		goto error;
 
-	/*== Write channel settings to device =====================================*/
+	/*== Write channel settings to device ================================*/
 
 	/* mode */
 	switch (state->props.transmission_mode) {
@@ -3834,71 +3898,92 @@ static int set_dvbt(struct drxk_state *state, u16 intermediate_freqk_hz,
 		break;
 	}
 
-	/* SAW filter selection: normaly not necesarry, but if wanted
-		the application can select a SAW filter via the driver by using UIOs */
+	/*
+	 * SAW filter selection: normaly not necesarry, but if wanted
+	 * the application can select a SAW filter via the driver by
+	 * using UIOs
+	 */
+
 	/* First determine real bandwidth (Hz) */
 	/* Also set delay for impulse noise cruncher */
-	/* Also set parameters for EC_OC fix, note EC_OC_REG_TMD_HIL_MAR is changed
-		by SC for fix for some 8K,1/8 guard but is restored by InitEC and ResetEC
-		functions */
+	/*
+	 * Also set parameters for EC_OC fix, note EC_OC_REG_TMD_HIL_MAR is
+	 * changed by SC for fix for some 8K,1/8 guard but is restored by
+	 * InitEC and ResetEC functions
+	 */
 	switch (state->props.bandwidth_hz) {
 	case 0:
 		state->props.bandwidth_hz = 8000000;
 		/* fall though */
 	case 8000000:
 		bandwidth = DRXK_BANDWIDTH_8MHZ_IN_HZ;
-		status = write16(state, OFDM_SC_RA_RAM_SRMM_FIX_FACT_8K__A, 3052);
+		status = write16(state, OFDM_SC_RA_RAM_SRMM_FIX_FACT_8K__A,
+				 3052);
 		if (status < 0)
 			goto error;
 		/* cochannel protection for PAL 8 MHz */
-		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_LEFT__A, 7);
+		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_LEFT__A,
+				 7);
 		if (status < 0)
 			goto error;
-		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_RIGHT__A, 7);
+		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_RIGHT__A,
+				 7);
 		if (status < 0)
 			goto error;
-		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_LEFT__A, 7);
+		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_LEFT__A,
+				 7);
 		if (status < 0)
 			goto error;
-		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_RIGHT__A, 1);
+		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_RIGHT__A,
+				 1);
 		if (status < 0)
 			goto error;
 		break;
 	case 7000000:
 		bandwidth = DRXK_BANDWIDTH_7MHZ_IN_HZ;
-		status = write16(state, OFDM_SC_RA_RAM_SRMM_FIX_FACT_8K__A, 3491);
+		status = write16(state, OFDM_SC_RA_RAM_SRMM_FIX_FACT_8K__A,
+				 3491);
 		if (status < 0)
 			goto error;
 		/* cochannel protection for PAL 7 MHz */
-		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_LEFT__A, 8);
+		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_LEFT__A,
+				 8);
 		if (status < 0)
 			goto error;
-		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_RIGHT__A, 8);
+		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_RIGHT__A,
+				 8);
 		if (status < 0)
 			goto error;
-		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_LEFT__A, 4);
+		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_LEFT__A,
+				 4);
 		if (status < 0)
 			goto error;
-		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_RIGHT__A, 1);
+		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_RIGHT__A,
+				 1);
 		if (status < 0)
 			goto error;
 		break;
 	case 6000000:
 		bandwidth = DRXK_BANDWIDTH_6MHZ_IN_HZ;
-		status = write16(state, OFDM_SC_RA_RAM_SRMM_FIX_FACT_8K__A, 4073);
+		status = write16(state, OFDM_SC_RA_RAM_SRMM_FIX_FACT_8K__A,
+				 4073);
 		if (status < 0)
 			goto error;
 		/* cochannel protection for NTSC 6 MHz */
-		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_LEFT__A, 19);
+		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_LEFT__A,
+				 19);
 		if (status < 0)
 			goto error;
-		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_RIGHT__A, 19);
+		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_RIGHT__A,
+				 19);
 		if (status < 0)
 			goto error;
-		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_LEFT__A, 14);
+		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_LEFT__A,
+				 14);
 		if (status < 0)
 			goto error;
-		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_RIGHT__A, 1);
+		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_RIGHT__A,
+				 1);
 		if (status < 0)
 			goto error;
 		break;
@@ -3914,13 +3999,16 @@ static int set_dvbt(struct drxk_state *state, u16 intermediate_freqk_hz,
 			((SysFreq / BandWidth) * (2^21)) - (2^23)
 			*/
 		/* (SysFreq / BandWidth) * (2^28)  */
-		/* assert (MAX(sysClk)/MIN(bandwidth) < 16)
-			=> assert(MAX(sysClk) < 16*MIN(bandwidth))
-			=> assert(109714272 > 48000000) = true so Frac 28 can be used  */
+		/*
+		 * assert (MAX(sysClk)/MIN(bandwidth) < 16)
+		 * 	=> assert(MAX(sysClk) < 16*MIN(bandwidth))
+		 * 	=> assert(109714272 > 48000000) = true
+		 * so Frac 28 can be used
+		 */
 		iqm_rc_rate_ofs = Frac28a((u32)
 					((state->m_sys_clock_freq *
 						1000) / 3), bandwidth);
-		/* (SysFreq / BandWidth) * (2^21), rounding before truncating  */
+		/* (SysFreq / BandWidth) * (2^21), rounding before truncating */
 		if ((iqm_rc_rate_ofs & 0x7fL) >= 0x40)
 			iqm_rc_rate_ofs += 0x80L;
 		iqm_rc_rate_ofs = iqm_rc_rate_ofs >> 7;
@@ -3942,11 +4030,12 @@ static int set_dvbt(struct drxk_state *state, u16 intermediate_freqk_hz,
 	if (status < 0)
 		goto error;
 #endif
-	status = set_frequency_shifter(state, intermediate_freqk_hz, tuner_freq_offset, true);
+	status = set_frequency_shifter(state, intermediate_freqk_hz,
+				       tuner_freq_offset, true);
 	if (status < 0)
 		goto error;
 
-	/*== start SC, write channel settings to SC ===============================*/
+	/*== start SC, write channel settings to SC ==========================*/
 
 	/* Activate SCU to enable SCU commands */
 	status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_ACTIVE);
@@ -3962,7 +4051,9 @@ static int set_dvbt(struct drxk_state *state, u16 intermediate_freqk_hz,
 		goto error;
 
 
-	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_START, 0, NULL, 1, &cmd_result);
+	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM
+			     | SCU_RAM_COMMAND_CMD_DEMOD_START,
+			     0, NULL, 1, &cmd_result);
 	if (status < 0)
 		goto error;
 
@@ -4071,7 +4162,9 @@ static int power_down_qam(struct drxk_state *state)
 		status = write16(state, QAM_COMM_EXEC__A, QAM_COMM_EXEC_STOP);
 		if (status < 0)
 			goto error;
-		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_STOP, 0, NULL, 1, &cmd_result);
+		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM
+				     | SCU_RAM_COMMAND_CMD_DEMOD_STOP,
+				     0, NULL, 1, &cmd_result);
 		if (status < 0)
 			goto error;
 	}
@@ -4139,7 +4232,7 @@ static int set_qam_measurement(struct drxk_state *state,
 	if (status < 0)
 		goto error;
 
-	fec_bits_desired /= 1000;	/* symbol_rate [Hz] -> symbol_rate [kHz]  */
+	fec_bits_desired /= 1000;	/* symbol_rate [Hz] -> symbol_rate [kHz] */
 	fec_bits_desired *= 500;	/* meas. period [ms] */
 
 	/* Annex A/C: bits/RsPeriod = 204 * 8 = 1632 */
@@ -4162,7 +4255,8 @@ static int set_qam_measurement(struct drxk_state *state,
 	status = write16(state, FEC_RS_MEASUREMENT_PERIOD__A, fec_rs_period);
 	if (status < 0)
 		goto error;
-	status = write16(state, FEC_RS_MEASUREMENT_PRESCALE__A, fec_rs_prescale);
+	status = write16(state, FEC_RS_MEASUREMENT_PRESCALE__A,
+			 fec_rs_prescale);
 	if (status < 0)
 		goto error;
 	status = write16(state, FEC_OC_SNC_FAIL_PERIOD__A, fec_rs_period);
@@ -4228,7 +4322,8 @@ static int set_qam16(struct drxk_state *state)
 		goto error;
 
 	/* QAM Slicer Settings */
-	status = write16(state, SCU_RAM_QAM_SL_SIG_POWER__A, DRXK_QAM_SL_SIG_POWER_QAM16);
+	status = write16(state, SCU_RAM_QAM_SL_SIG_POWER__A,
+			 DRXK_QAM_SL_SIG_POWER_QAM16);
 	if (status < 0)
 		goto error;
 
@@ -4424,7 +4519,8 @@ static int set_qam32(struct drxk_state *state)
 
 	/* QAM Slicer Settings */
 
-	status = write16(state, SCU_RAM_QAM_SL_SIG_POWER__A, DRXK_QAM_SL_SIG_POWER_QAM32);
+	status = write16(state, SCU_RAM_QAM_SL_SIG_POWER__A,
+			 DRXK_QAM_SL_SIG_POWER_QAM32);
 	if (status < 0)
 		goto error;
 
@@ -4617,7 +4713,8 @@ static int set_qam64(struct drxk_state *state)
 		goto error;
 
 	/* QAM Slicer Settings */
-	status = write16(state, SCU_RAM_QAM_SL_SIG_POWER__A, DRXK_QAM_SL_SIG_POWER_QAM64);
+	status = write16(state, SCU_RAM_QAM_SL_SIG_POWER__A,
+			 DRXK_QAM_SL_SIG_POWER_QAM64);
 	if (status < 0)
 		goto error;
 
@@ -4813,7 +4910,8 @@ static int set_qam128(struct drxk_state *state)
 
 	/* QAM Slicer Settings */
 
-	status = write16(state, SCU_RAM_QAM_SL_SIG_POWER__A, DRXK_QAM_SL_SIG_POWER_QAM128);
+	status = write16(state, SCU_RAM_QAM_SL_SIG_POWER__A,
+			 DRXK_QAM_SL_SIG_POWER_QAM128);
 	if (status < 0)
 		goto error;
 
@@ -5008,7 +5106,8 @@ static int set_qam256(struct drxk_state *state)
 
 	/* QAM Slicer Settings */
 
-	status = write16(state, SCU_RAM_QAM_SL_SIG_POWER__A, DRXK_QAM_SL_SIG_POWER_QAM256);
+	status = write16(state, SCU_RAM_QAM_SL_SIG_POWER__A,
+			 DRXK_QAM_SL_SIG_POWER_QAM256);
 	if (status < 0)
 		goto error;
 
@@ -5156,7 +5255,9 @@ static int qam_reset_qam(struct drxk_state *state)
 	if (status < 0)
 		goto error;
 
-	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_RESET, 0, NULL, 1, &cmd_result);
+	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM
+			     | SCU_RAM_COMMAND_CMD_DEMOD_RESET,
+			     0, NULL, 1, &cmd_result);
 error:
 	if (status < 0)
 		pr_err("Error %d on %s\n", status, __func__);
@@ -5267,8 +5368,10 @@ static int get_qam_lock_status(struct drxk_state *state, u32 *p_lock_status)
 	} else {
 		/* 0xC000 NEVER LOCKED */
 		/* (system will never be able to lock to the signal) */
-		/* TODO: check this, intermediate & standard specific lock states are not
-		   taken into account here */
+		/*
+		 * TODO: check this, intermediate & standard specific lock
+		 * states are not taken into account here
+		 */
 		*p_lock_status = NEVER_LOCK;
 	}
 	return status;
@@ -5300,13 +5403,15 @@ static int qam_demodulator_command(struct drxk_state *state,
 			set_env_parameters[0] = QAM_TOP_ANNEX_A;
 
 		status = scu_command(state,
-				     SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_ENV,
+				     SCU_RAM_COMMAND_STANDARD_QAM
+				     | SCU_RAM_COMMAND_CMD_DEMOD_SET_ENV,
 				     1, set_env_parameters, 1, &cmd_result);
 		if (status < 0)
 			goto error;
 
 		status = scu_command(state,
-				     SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_PARAM,
+				     SCU_RAM_COMMAND_STANDARD_QAM
+				     | SCU_RAM_COMMAND_CMD_DEMOD_SET_PARAM,
 				     number_of_parameters, set_param_parameters,
 				     1, &cmd_result);
 	} else if (number_of_parameters == 4) {
@@ -5321,7 +5426,8 @@ static int qam_demodulator_command(struct drxk_state *state,
 		/* set_param_parameters[3] |= QAM_LOCKRANGE_NORMAL; */
 
 		status = scu_command(state,
-				     SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_PARAM,
+				     SCU_RAM_COMMAND_STANDARD_QAM
+				     | SCU_RAM_COMMAND_CMD_DEMOD_SET_PARAM,
 				     number_of_parameters, set_param_parameters,
 				     1, &cmd_result);
 	} else {
@@ -5439,12 +5545,14 @@ static int set_qam(struct drxk_state *state, u16 intermediate_freqk_hz,
 	if (status < 0)
 		goto error;
 #endif
-	status = set_frequency_shifter(state, intermediate_freqk_hz, tuner_freq_offset, true);
+	status = set_frequency_shifter(state, intermediate_freqk_hz,
+				       tuner_freq_offset, true);
 	if (status < 0)
 		goto error;
 
 	/* Setup BER measurement */
-	status = set_qam_measurement(state, state->m_constellation, state->props.symbol_rate);
+	status = set_qam_measurement(state, state->m_constellation,
+				     state->props.symbol_rate);
 	if (status < 0)
 		goto error;
 
@@ -5517,7 +5625,8 @@ static int set_qam(struct drxk_state *state, u16 intermediate_freqk_hz,
 		goto error;
 
 	/* Mirroring, QAM-block starting point not inverted */
-	status = write16(state, QAM_SY_SP_INV__A, QAM_SY_SP_INV_SPECTRUM_INV_DIS);
+	status = write16(state, QAM_SY_SP_INV__A,
+			 QAM_SY_SP_INV_SPECTRUM_INV_DIS);
 	if (status < 0)
 		goto error;
 
@@ -5578,7 +5687,9 @@ static int set_qam(struct drxk_state *state, u16 intermediate_freqk_hz,
 		goto error;
 
 	/* STEP 5: start QAM demodulator (starts FEC, QAM and IQM HW) */
-	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_START, 0, NULL, 1, &cmd_result);
+	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM
+			     | SCU_RAM_COMMAND_CMD_DEMOD_START,
+			     0, NULL, 1, &cmd_result);
 	if (status < 0)
 		goto error;
 
@@ -5628,13 +5739,22 @@ static int set_qam_standard(struct drxk_state *state,
 		boot loader from ROM table */
 	switch (o_mode) {
 	case OM_QAM_ITU_A:
-		status = bl_chain_cmd(state, DRXK_BL_ROM_OFFSET_TAPS_ITU_A, DRXK_BLCC_NR_ELEMENTS_TAPS, DRXK_BLC_TIMEOUT);
+		status = bl_chain_cmd(state, DRXK_BL_ROM_OFFSET_TAPS_ITU_A,
+				      DRXK_BLCC_NR_ELEMENTS_TAPS,
+			DRXK_BLC_TIMEOUT);
 		break;
 	case OM_QAM_ITU_C:
-		status = bl_direct_cmd(state, IQM_CF_TAP_RE0__A, DRXK_BL_ROM_OFFSET_TAPS_ITU_C, DRXK_BLDC_NR_ELEMENTS_TAPS, DRXK_BLC_TIMEOUT);
+		status = bl_direct_cmd(state, IQM_CF_TAP_RE0__A,
+				       DRXK_BL_ROM_OFFSET_TAPS_ITU_C,
+				       DRXK_BLDC_NR_ELEMENTS_TAPS,
+				       DRXK_BLC_TIMEOUT);
 		if (status < 0)
 			goto error;
-		status = bl_direct_cmd(state, IQM_CF_TAP_IM0__A, DRXK_BL_ROM_OFFSET_TAPS_ITU_C, DRXK_BLDC_NR_ELEMENTS_TAPS, DRXK_BLC_TIMEOUT);
+		status = bl_direct_cmd(state,
+				       IQM_CF_TAP_IM0__A,
+				       DRXK_BL_ROM_OFFSET_TAPS_ITU_C,
+				       DRXK_BLDC_NR_ELEMENTS_TAPS,
+				       DRXK_BLC_TIMEOUT);
 		break;
 	default:
 		status = -EINVAL;
@@ -5642,13 +5762,14 @@ static int set_qam_standard(struct drxk_state *state,
 	if (status < 0)
 		goto error;
 
-	status = write16(state, IQM_CF_OUT_ENA__A, (1 << IQM_CF_OUT_ENA_QAM__B));
+	status = write16(state, IQM_CF_OUT_ENA__A, 1 << IQM_CF_OUT_ENA_QAM__B);
 	if (status < 0)
 		goto error;
 	status = write16(state, IQM_CF_SYMMETRIC__A, 0);
 	if (status < 0)
 		goto error;
-	status = write16(state, IQM_CF_MIDTAP__A, ((1 << IQM_CF_MIDTAP_RE__B) | (1 << IQM_CF_MIDTAP_IM__B)));
+	status = write16(state, IQM_CF_MIDTAP__A,
+		     ((1 << IQM_CF_MIDTAP_RE__B) | (1 << IQM_CF_MIDTAP_IM__B)));
 	if (status < 0)
 		goto error;
 
@@ -5760,7 +5881,8 @@ static int write_gpio(struct drxk_state *state)
 
 	dprintk(1, "\n");
 	/* stop lock indicator process */
-	status = write16(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
+	status = write16(state, SCU_RAM_GPIO__A,
+			 SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
 	if (status < 0)
 		goto error;
 
@@ -5772,7 +5894,8 @@ static int write_gpio(struct drxk_state *state)
 	if (state->m_has_sawsw) {
 		if (state->uio_mask & 0x0001) { /* UIO-1 */
 			/* write to io pad configuration register - output mode */
-			status = write16(state, SIO_PDR_SMA_TX_CFG__A, state->m_gpio_cfg);
+			status = write16(state, SIO_PDR_SMA_TX_CFG__A,
+					 state->m_gpio_cfg);
 			if (status < 0)
 				goto error;
 
@@ -5791,7 +5914,8 @@ static int write_gpio(struct drxk_state *state)
 		}
 		if (state->uio_mask & 0x0002) { /* UIO-2 */
 			/* write to io pad configuration register - output mode */
-			status = write16(state, SIO_PDR_SMA_RX_CFG__A, state->m_gpio_cfg);
+			status = write16(state, SIO_PDR_SMA_RX_CFG__A,
+					 state->m_gpio_cfg);
 			if (status < 0)
 				goto error;
 
@@ -5810,7 +5934,8 @@ static int write_gpio(struct drxk_state *state)
 		}
 		if (state->uio_mask & 0x0004) { /* UIO-3 */
 			/* write to io pad configuration register - output mode */
-			status = write16(state, SIO_PDR_GPIO_CFG__A, state->m_gpio_cfg);
+			status = write16(state, SIO_PDR_GPIO_CFG__A,
+					 state->m_gpio_cfg);
 			if (status < 0)
 				goto error;
 
@@ -5909,7 +6034,8 @@ static int power_down_device(struct drxk_state *state)
 	if (status < 0)
 		goto error;
 
-	status = write16(state, SIO_CC_PWD_MODE__A, SIO_CC_PWD_MODE_LEVEL_CLOCK);
+	status = write16(state, SIO_CC_PWD_MODE__A,
+			 SIO_CC_PWD_MODE_LEVEL_CLOCK);
 	if (status < 0)
 		goto error;
 	status = write16(state, SIO_CC_UPDATE__A, SIO_CC_UPDATE_KEY);
@@ -5940,13 +6066,19 @@ static int init_drxk(struct drxk_state *state)
 		if (status < 0)
 			goto error;
 		/* Soft reset of OFDM-, sys- and osc-clockdomain */
-		status = write16(state, SIO_CC_SOFT_RST__A, SIO_CC_SOFT_RST_OFDM__M | SIO_CC_SOFT_RST_SYS__M | SIO_CC_SOFT_RST_OSC__M);
+		status = write16(state, SIO_CC_SOFT_RST__A,
+				 SIO_CC_SOFT_RST_OFDM__M
+				 | SIO_CC_SOFT_RST_SYS__M
+				 | SIO_CC_SOFT_RST_OSC__M);
 		if (status < 0)
 			goto error;
 		status = write16(state, SIO_CC_UPDATE__A, SIO_CC_UPDATE_KEY);
 		if (status < 0)
 			goto error;
-		/* TODO is this needed, if yes how much delay in worst case scenario */
+		/*
+		 * TODO is this needed? If yes, how much delay in
+		 * worst case scenario
+		 */
 		usleep_range(1000, 2000);
 		state->m_drxk_a3_patch_code = true;
 		status = get_device_capabilities(state);
@@ -5979,7 +6111,8 @@ static int init_drxk(struct drxk_state *state)
 			&& !(state->m_DRXK_A2_ROM_CODE))
 #endif
 		{
-			status = write16(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
+			status = write16(state, SCU_RAM_GPIO__A,
+					 SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
 			if (status < 0)
 				goto error;
 		}
@@ -5998,12 +6131,14 @@ static int init_drxk(struct drxk_state *state)
 			goto error;
 
 		/* enable token-ring bus through OFDM block for possible ucode upload */
-		status = write16(state, SIO_OFDM_SH_OFDM_RING_ENABLE__A, SIO_OFDM_SH_OFDM_RING_ENABLE_ON);
+		status = write16(state, SIO_OFDM_SH_OFDM_RING_ENABLE__A,
+				 SIO_OFDM_SH_OFDM_RING_ENABLE_ON);
 		if (status < 0)
 			goto error;
 
 		/* include boot loader section */
-		status = write16(state, SIO_BL_COMM_EXEC__A, SIO_BL_COMM_EXEC_ACTIVE);
+		status = write16(state, SIO_BL_COMM_EXEC__A,
+				 SIO_BL_COMM_EXEC_ACTIVE);
 		if (status < 0)
 			goto error;
 		status = bl_chain_cmd(state, 0, 6, 100);
@@ -6018,7 +6153,8 @@ static int init_drxk(struct drxk_state *state)
 		}
 
 		/* disable token-ring bus through OFDM block for possible ucode upload */
-		status = write16(state, SIO_OFDM_SH_OFDM_RING_ENABLE__A, SIO_OFDM_SH_OFDM_RING_ENABLE_OFF);
+		status = write16(state, SIO_OFDM_SH_OFDM_RING_ENABLE__A,
+				 SIO_OFDM_SH_OFDM_RING_ENABLE_OFF);
 		if (status < 0)
 			goto error;
 
@@ -6048,7 +6184,8 @@ static int init_drxk(struct drxk_state *state)
 			(((DRXK_VERSION_MAJOR / 10) % 10) << 8) +
 			((DRXK_VERSION_MAJOR % 10) << 4) +
 			(DRXK_VERSION_MINOR % 10);
-		status = write16(state, SCU_RAM_DRIVER_VER_HI__A, driver_version);
+		status = write16(state, SCU_RAM_DRIVER_VER_HI__A,
+				 driver_version);
 		if (status < 0)
 			goto error;
 		driver_version =
@@ -6056,7 +6193,8 @@ static int init_drxk(struct drxk_state *state)
 			(((DRXK_VERSION_PATCH / 100) % 10) << 8) +
 			(((DRXK_VERSION_PATCH / 10) % 10) << 4) +
 			(DRXK_VERSION_PATCH % 10);
-		status = write16(state, SCU_RAM_DRIVER_VER_LO__A, driver_version);
+		status = write16(state, SCU_RAM_DRIVER_VER_LO__A,
+				 driver_version);
 		if (status < 0)
 			goto error;
 
@@ -6064,10 +6202,13 @@ static int init_drxk(struct drxk_state *state)
 			DRXK_VERSION_MAJOR, DRXK_VERSION_MINOR,
 			DRXK_VERSION_PATCH);
 
-		/* Dirty fix of default values for ROM/PATCH microcode
-			Dirty because this fix makes it impossible to setup suitable values
-			before calling DRX_Open. This solution requires changes to RF AGC speed
-			to be done via the CTRL function after calling DRX_Open */
+		/*
+		 * Dirty fix of default values for ROM/PATCH microcode
+		 * Dirty because this fix makes it impossible to setup
+		 * suitable values before calling DRX_Open. This solution
+		 * requires changes to RF AGC speed to be done via the CTRL
+		 * function after calling DRX_Open
+		 */
 
 		/* m_dvbt_rf_agc_cfg.speed = 3; */
 
@@ -6238,7 +6379,8 @@ static int drxk_set_parameters(struct dvb_frontend *fe)
 		case SYS_DVBC_ANNEX_C:
 			if (!state->m_has_dvbc)
 				return -EINVAL;
-			state->m_itut_annex_c = (delsys == SYS_DVBC_ANNEX_C) ? true : false;
+			state->m_itut_annex_c = (delsys == SYS_DVBC_ANNEX_C) ?
+						true : false;
 			if (state->m_itut_annex_c)
 				setoperation_mode(state, OM_QAM_ITU_C);
 			else
@@ -6352,7 +6494,7 @@ static int get_strength(struct drxk_state *state, u64 *strength)
 		if (if_agc.output_level > if_agc.max_output_level)
 			if_agc.output_level = if_agc.max_output_level;
 
-		agc_range  = (u32) (if_agc.max_output_level - if_agc.min_output_level);
+		agc_range  = (u32)(if_agc.max_output_level - if_agc.min_output_level);
 		if (agc_range > 0) {
 			atten += 100UL *
 				((u32)(tuner_if_gain)) *
@@ -6433,9 +6575,11 @@ static int drxk_get_stats(struct dvb_frontend *fe)
 
 	/* BER measurement is valid if at least FEC lock is achieved */
 
-	/* OFDM_EC_VD_REQ_SMB_CNT__A and/or OFDM_EC_VD_REQ_BIT_CNT can be written
-		to set nr of symbols or bits over which
-		to measure EC_VD_REG_ERR_BIT_CNT__A . See CtrlSetCfg(). */
+	/*
+	 * OFDM_EC_VD_REQ_SMB_CNT__A and/or OFDM_EC_VD_REQ_BIT_CNT can be
+	 * written to set nr of symbols or bits over which to measure
+	 * EC_VD_REG_ERR_BIT_CNT__A . See CtrlSetCfg().
+	 */
 
 	/* Read registers for post/preViterbi BER calculation */
 	status = read16(state, OFDM_EC_VD_ERR_BIT_CNT__A, &reg16);
@@ -6566,8 +6710,8 @@ static int drxk_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 	return 0;
 }
 
-static int drxk_get_tune_settings(struct dvb_frontend *fe, struct dvb_frontend_tune_settings
-				    *sets)
+static int drxk_get_tune_settings(struct dvb_frontend *fe,
+				  struct dvb_frontend_tune_settings *sets)
 {
 	struct drxk_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
-- 
1.8.1.4

