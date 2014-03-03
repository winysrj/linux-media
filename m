Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49472 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223AbaCCKII (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:08 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 28/79] [media] drx-j: More CamelCase fixups
Date: Mon,  3 Mar 2014 07:06:22 -0300
Message-Id: <1393841233-24840-29-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 .../media/dvb-frontends/drx39xyj/drx_dap_fasi.c    |   6 +-
 drivers/media/dvb-frontends/drx39xyj/drx_driver.c  |  26 ++---
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h  |   8 +-
 drivers/media/dvb-frontends/drx39xyj/drxj.c        | 126 ++++++++++-----------
 drivers/media/dvb-frontends/drx39xyj/drxj.h        |   4 +-
 5 files changed, 85 insertions(+), 85 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
index 3f33b130cda0..6053878a637c 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
@@ -514,13 +514,13 @@ static int drxdap_fasi_write_block(struct i2c_device_addr *dev_addr,
 		 */
 		todo = (block_size < datasize ? block_size : datasize);
 		if (todo == 0) {
-			u16 overhead_sizeI2cAddr = 0;
+			u16 overhead_size_i2c_addr = 0;
 			u16 data_block_size = 0;
 
-			overhead_sizeI2cAddr =
+			overhead_size_i2c_addr =
 			    (IS_I2C_10BIT(dev_addr->i2c_addr) ? 2 : 1);
 			data_block_size =
-			    (DRXDAP_MAX_WCHUNKSIZE - overhead_sizeI2cAddr) & ~1;
+			    (DRXDAP_MAX_WCHUNKSIZE - overhead_size_i2c_addr) & ~1;
 
 			/* write device address */
 			st = drxbsp_i2c_write_read(dev_addr,
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
index 5974b7c12cbd..d1d9ded65407 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
@@ -294,7 +294,7 @@ scan_prepare_next_scan(struct drx_demod_instance *demod, s32 skip)
 		/* Search next frequency to scan */
 
 		/* always take at least one step */
-		(common_attr->scan_channelsScanned)++;
+		(common_attr->scan_channels_scanned)++;
 		next_frequency += frequency_plan[table_index].step;
 		skip -= frequency_plan[table_index].step;
 
@@ -302,7 +302,7 @@ scan_prepare_next_scan(struct drx_demod_instance *demod, s32 skip)
 		   without exceeding end of the band */
 		while ((skip > 0) &&
 		       (next_frequency <= frequency_plan[table_index].last)) {
-			(common_attr->scan_channelsScanned)++;
+			(common_attr->scan_channels_scanned)++;
 			next_frequency += frequency_plan[table_index].step;
 			skip -= frequency_plan[table_index].step;
 		}
@@ -528,7 +528,7 @@ ctrl_scan_init(struct drx_demod_instance *demod, struct drx_scan_param *scan_par
 	/* Store parameters */
 	common_attr->scan_ready = false;
 	common_attr->scan_max_channels = nr_channels_in_plan;
-	common_attr->scan_channelsScanned = 0;
+	common_attr->scan_channels_scanned = 0;
 	common_attr->scan_param = scan_param;	/* SCAN_NEXT is now allowed */
 
 	scan_context = get_scan_context(demod, scan_context);
@@ -626,7 +626,7 @@ static int ctrl_scan_next(struct drx_demod_instance *demod, u16 *scan_progress)
 		return DRX_STS_ERROR;
 	}
 
-	*scan_progress = (u16) (((common_attr->scan_channelsScanned) *
+	*scan_progress = (u16) (((common_attr->scan_channels_scanned) *
 				  ((u32) (max_progress))) /
 				 (common_attr->scan_max_channels));
 
@@ -682,7 +682,7 @@ static int ctrl_scan_next(struct drx_demod_instance *demod, u16 *scan_progress)
 
 			/* keep track of progress */
 			*scan_progress =
-			    (u16) (((common_attr->scan_channelsScanned) *
+			    (u16) (((common_attr->scan_channels_scanned) *
 				      ((u32) (max_progress))) /
 				     (common_attr->scan_max_channels));
 
@@ -1119,7 +1119,7 @@ ctrl_u_code(struct drx_demod_instance *demod,
 			case UCODE_VERIFY:
 				{
 					int result = 0;
-					u8 mc_dataBuffer
+					u8 mc_data_buffer
 					    [DRX_UCODE_MAX_BUF_SIZE];
 					u32 bytes_to_compare = 0;
 					u32 bytes_left_to_compare = 0;
@@ -1148,7 +1148,7 @@ ctrl_u_code(struct drx_demod_instance *demod,
 								  (u16)
 								  bytes_to_compare,
 								  (u8 *)
-								  mc_dataBuffer,
+								  mc_data_buffer,
 								  0x0000) !=
 						    DRX_STS_OK) {
 							return DRX_STS_ERROR;
@@ -1156,7 +1156,7 @@ ctrl_u_code(struct drx_demod_instance *demod,
 
 						result =
 						    drxbsp_hst_memcmp(curr_ptr,
-								      mc_dataBuffer,
+								      mc_data_buffer,
 								      bytes_to_compare);
 
 						if (result != 0) {
@@ -1209,7 +1209,7 @@ ctrl_version(struct drx_demod_instance *demod, struct drx_version_list **version
 	    DRX_VERSIONSTRING(VERSION_MAJOR, VERSION_MINOR, VERSION_PATCH);
 
 	static struct drx_version drx_driver_core_version;
-	static struct drx_version_list drx_driver_core_versionList;
+	static struct drx_version_list drx_driver_core_version_list;
 
 	struct drx_version_list *demod_version_list = (struct drx_version_list *) (NULL);
 	int return_status = DRX_STS_ERROR;
@@ -1233,8 +1233,8 @@ ctrl_version(struct drx_demod_instance *demod, struct drx_version_list **version
 	drx_driver_core_version.v_patch = VERSION_PATCH;
 	drx_driver_core_version.v_string = drx_driver_core_version_text;
 
-	drx_driver_core_versionList.version = &drx_driver_core_version;
-	drx_driver_core_versionList.next = (struct drx_version_list *) (NULL);
+	drx_driver_core_version_list.version = &drx_driver_core_version;
+	drx_driver_core_version_list.next = (struct drx_version_list *) (NULL);
 
 	if ((return_status == DRX_STS_OK) && (demod_version_list != NULL)) {
 		/* Append versioninfo from driver to versioninfo from demod  */
@@ -1244,12 +1244,12 @@ ctrl_version(struct drx_demod_instance *demod, struct drx_version_list **version
 		while (current_list_element->next != NULL) {
 			current_list_element = current_list_element->next;
 		}
-		current_list_element->next = &drx_driver_core_versionList;
+		current_list_element->next = &drx_driver_core_version_list;
 
 		*version_list = demod_version_list;
 	} else {
 		/* Just return versioninfo from driver */
-		*version_list = &drx_driver_core_versionList;
+		*version_list = &drx_driver_core_version_list;
 	}
 
 	return DRX_STS_OK;
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
index e0316f667f4c..975b3ba0c8e5 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
@@ -182,7 +182,7 @@ struct tuner_common {
 	s32 max_freq_rf;	/* Highest RF input frequency, in kHz */
 
 	u8 sub_mode;	/* Index to sub-mode in use */
-	char ***sub_modeDescriptions;	/* Pointer to description of sub-modes */
+	char ***sub_mode_descriptions;	/* Pointer to description of sub-modes */
 	u8 sub_modes;	/* Number of available sub-modes      */
 
 	/* The following fields will be either 0, NULL or false and do not need
@@ -192,7 +192,7 @@ struct tuner_common {
 	s32 r_ffrequency;	/* only valid if programmed       */
 	s32 i_ffrequency;	/* only valid if programmed       */
 
-	void *myUser_data;	/* pointer to associated demod instance */
+	void *my_user_data;	/* pointer to associated demod instance */
 	u16 my_capabilities;	/* value for storing application flags  */
 };
 
@@ -230,7 +230,7 @@ struct tuner_ops {
 	tuner_close_func_t close_func;
 	tuner_set_frequency_func_t set_frequency_func;
 	tuner_get_frequency_func_t get_frequency_func;
-	tuner_lock_status_func_t lock_statusFunc;
+	tuner_lock_status_func_t lock_status_func;
 	tune_ri2c_write_read_func_t i2c_write_read_func;
 
 };
@@ -1985,7 +1985,7 @@ struct drx_reg_dump {
 				      /**< next freq to scan                  */
 		bool scan_ready;     /**< scan ready flag                    */
 		u32 scan_max_channels;/**< number of channels in freqplan     */
-		u32 scan_channelsScanned;
+		u32 scan_channels_scanned;
 					/**< number of channels scanned       */
 		/* Channel scan - inner loop: demod related */
 		drx_scan_func_t scan_function;
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 6e7ce7501e70..f6361b669e67 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -661,7 +661,7 @@ struct drxj_data drxj_data_g = {
 	1,			/* fec_rs_prescale     */
 	FEC_RS_MEASUREMENT_PERIOD,	/* fec_rs_period     */
 	true,			/* reset_pkt_err_acc    */
-	0,			/* pkt_errAccStart    */
+	0,			/* pkt_err_acc_start    */
 
 	/* HI configuration */
 	0,			/* hi_cfg_timing_div    */
@@ -1114,7 +1114,7 @@ ctrl_set_cfg_afe_gain(struct drx_demod_instance *demod, struct drxj_cfg_afe_gain
 
 #ifdef DRXJ_SPLIT_UCODE_UPLOAD
 static int
-ctrl_u_codeUpload(struct drx_demod_instance *demod,
+ctrl_u_code_upload(struct drx_demod_instance *demod,
 		  struct drxu_code_info *mc_info,
 		enum drxu_code_actionaction, bool audio_mc_upload);
 #endif /* DRXJ_SPLIT_UCODE_UPLOAD */
@@ -3892,13 +3892,13 @@ rw_error:
 
 /*============================================================================*/
 /**
-* \fn int CtrlGetuio_cfg()
+* \fn int ctrl_getuio_cfg()
 * \brief Get modus oprandi UIO.
 * \param demod Pointer to demodulator instance.
 * \param uio_cfg Pointer to a configuration setting for a certain UIO.
 * \return int.
 */
-static int CtrlGetuio_cfg(struct drx_demod_instance *demod, struct drxuio_cfg *uio_cfg)
+static int ctrl_getuio_cfg(struct drx_demod_instance *demod, struct drxuio_cfg *uio_cfg)
 {
 
 	struct drxj_data *ext_attr = (struct drxj_data *) NULL;
@@ -5345,7 +5345,7 @@ static int init_agc(struct drx_demod_instance *demod)
 	u16 ki_max = 0;
 	u16 if_iaccu_hi_tgt_min = 0;
 	u16 data = 0;
-	u16 agc_kiDgain = 0;
+	u16 agc_ki_dgain = 0;
 	u16 ki_min = 0;
 	u16 clp_ctrl_mode = 0;
 	u16 agc_rf = 0;
@@ -5363,7 +5363,7 @@ static int init_agc(struct drx_demod_instance *demod)
 		sns_dir_to = (u16) (-9);
 		ki_innergain_min = (u16) (-32768);
 		ki_max = 0x032C;
-		agc_kiDgain = 0xC;
+		agc_ki_dgain = 0xC;
 		if_iaccu_hi_tgt_min = 2047;
 		ki_min = 0x0117;
 		ingain_tgt_max = 16383;
@@ -5448,7 +5448,7 @@ static int init_agc(struct drx_demod_instance *demod)
 		ki_innergain_min = 0;
 		ki_max = 0x0657;
 		if_iaccu_hi_tgt_min = 2047;
-		agc_kiDgain = 0x7;
+		agc_ki_dgain = 0x7;
 		ki_min = 0x0117;
 		clp_ctrl_mode = 0;
 		rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_AGC_KI_MINGAIN__A, 0x7fff, 0);
@@ -5528,7 +5528,7 @@ static int init_agc(struct drx_demod_instance *demod)
 		sns_sum_max = 1023;
 		ki_innergain_min = (u16) (-32768);
 		if_iaccu_hi_tgt_min = 2047;
-		agc_kiDgain = 0x7;
+		agc_ki_dgain = 0x7;
 		ki_min = 0x0225;
 		ki_max = 0x0547;
 		clp_dir_to = (u16) (-9);
@@ -5551,7 +5551,7 @@ static int init_agc(struct drx_demod_instance *demod)
 		sns_sum_max = 1023;
 		ki_innergain_min = (u16) (-32768);
 		if_iaccu_hi_tgt_min = 2047;
-		agc_kiDgain = 0x7;
+		agc_ki_dgain = 0x7;
 		ki_min = 0x0225;
 		ki_max = 0x0547;
 		clp_dir_to = (u16) (-9);
@@ -5572,7 +5572,7 @@ static int init_agc(struct drx_demod_instance *demod)
 		sns_sum_max = 1023;
 		ki_innergain_min = (u16) (-32768);
 		if_iaccu_hi_tgt_min = 2047;
-		agc_kiDgain = 0x7;
+		agc_ki_dgain = 0x7;
 		ki_min = 0x0225;
 		ki_max = 0x0547;
 		clp_dir_to = (u16) (-9);
@@ -5752,7 +5752,7 @@ static int init_agc(struct drx_demod_instance *demod)
 		goto rw_error;
 	}
 	data &= ~SCU_RAM_AGC_KI_DGAIN__M;
-	data |= (agc_kiDgain << SCU_RAM_AGC_KI_DGAIN__B);
+	data |= (agc_ki_dgain << SCU_RAM_AGC_KI_DGAIN__B);
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_RAM_AGC_KI__A, data, 0);
 	if (rc != DRX_STS_OK) {
 		pr_err("error %d\n", rc);
@@ -7616,16 +7616,16 @@ static int get_vsb_post_rs_pck_err(struct i2c_device_addr *dev_addr, u16 *pck_er
 	u16 data = 0;
 	u16 period = 0;
 	u16 prescale = 0;
-	u16 packet_errorsMant = 0;
-	u16 packet_errorsExp = 0;
+	u16 packet_errors_mant = 0;
+	u16 packet_errors_exp = 0;
 
 	rc = DRXJ_DAP.read_reg16func(dev_addr, FEC_RS_NR_FAILURES__A, &data, 0);
 	if (rc != DRX_STS_OK) {
 		pr_err("error %d\n", rc);
 		goto rw_error;
 	}
-	packet_errorsMant = data & FEC_RS_NR_FAILURES_FIXED_MANT__M;
-	packet_errorsExp = (data & FEC_RS_NR_FAILURES_EXP__M)
+	packet_errors_mant = data & FEC_RS_NR_FAILURES_FIXED_MANT__M;
+	packet_errors_exp = (data & FEC_RS_NR_FAILURES_EXP__M)
 	    >> FEC_RS_NR_FAILURES_EXP__B;
 	period = FEC_RS_MEASUREMENT_PERIOD;
 	prescale = FEC_RS_MEASUREMENT_PRESCALE;
@@ -7636,7 +7636,7 @@ static int get_vsb_post_rs_pck_err(struct i2c_device_addr *dev_addr, u16 *pck_er
 		return DRX_STS_ERROR;;
 	}
 	*pck_errs =
-	    (u16) frac_times1e6(packet_errorsMant * (1 << packet_errorsExp),
+	    (u16) frac_times1e6(packet_errors_mant * (1 << packet_errors_exp),
 				 (period * prescale * 77));
 
 	return DRX_STS_OK;
@@ -7791,7 +7791,7 @@ ctrl_get_vsb_constel(struct drx_demod_instance *demod, struct drx_complex *compl
 	int rc;
 				       /**< device address                    */
 	u16 vsb_top_comm_mb = 0;	       /**< VSB SL MB configuration           */
-	u16 vsb_top_comm_mbInit = 0;    /**< VSB SL MB intial configuration    */
+	u16 vsb_top_comm_mb_init = 0;    /**< VSB SL MB intial configuration    */
 	u16 re = 0;		       /**< constellation Re part             */
 	u32 data = 0;
 
@@ -7803,13 +7803,13 @@ ctrl_get_vsb_constel(struct drx_demod_instance *demod, struct drx_complex *compl
 	/* Needs to be checked when external interface PG is updated */
 
 	/* Configure MB (Monitor bus) */
-	rc = DRXJ_DAP.read_reg16func(dev_addr, VSB_TOP_COMM_MB__A, &vsb_top_comm_mbInit, 0);
+	rc = DRXJ_DAP.read_reg16func(dev_addr, VSB_TOP_COMM_MB__A, &vsb_top_comm_mb_init, 0);
 	if (rc != DRX_STS_OK) {
 		pr_err("error %d\n", rc);
 		goto rw_error;
 	}
 	/* set observe flag & MB mux */
-	vsb_top_comm_mb = (vsb_top_comm_mbInit |
+	vsb_top_comm_mb = (vsb_top_comm_mb_init |
 			VSB_TOP_COMM_MB_OBS_OBS_ON |
 			VSB_TOP_COMM_MB_MUX_OBS_VSB_TCMEQ_2);
 	rc = DRXJ_DAP.write_reg16func(dev_addr, VSB_TOP_COMM_MB__A, vsb_top_comm_mb, 0);
@@ -7846,7 +7846,7 @@ ctrl_get_vsb_constel(struct drx_demod_instance *demod, struct drx_complex *compl
 	complex_nr->im = 0;
 
 	/* Restore MB (Monitor bus) */
-	rc = DRXJ_DAP.write_reg16func(dev_addr, VSB_TOP_COMM_MB__A, vsb_top_comm_mbInit, 0);
+	rc = DRXJ_DAP.write_reg16func(dev_addr, VSB_TOP_COMM_MB__A, vsb_top_comm_mb_init, 0);
 	if (rc != DRX_STS_OK) {
 		pr_err("error %d\n", rc);
 		goto rw_error;
@@ -10612,14 +10612,14 @@ rw_error:
 }
 
 /**
-* \fn int set_qamChannel ()
+* \fn int set_qam_channel ()
 * \brief Set QAM channel according to the requested constellation.
 * \param demod:   instance of demod.
 * \param channel: pointer to channel data.
 * \return int.
 */
 static int
-set_qamChannel(struct drx_demod_instance *demod,
+set_qam_channel(struct drx_demod_instance *demod,
 	       struct drx_channel *channel, s32 tuner_freq_offset)
 {
 	struct drxj_data *ext_attr = NULL;
@@ -10802,7 +10802,7 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn static short GetQAMRSErr_count(struct i2c_device_addr *dev_addr)
+* \fn static short get_qamrs_err_count(struct i2c_device_addr *dev_addr)
 * \brief Get RS error count in QAM mode (used for post RS BER calculation)
 * \return Error code
 *
@@ -10810,7 +10810,7 @@ rw_error:
 *
 */
 static int
-GetQAMRSErr_count(struct i2c_device_addr *dev_addr, struct drxjrs_errors *rs_errors)
+get_qamrs_err_count(struct i2c_device_addr *dev_addr, struct drxjrs_errors *rs_errors)
 {
 	int rc;
 	u16 nr_bit_errors = 0,
@@ -10924,7 +10924,7 @@ ctrl_get_qam_sig_quality(struct drx_demod_instance *demod, struct drx_sig_qualit
 
 	/* read the physical registers */
 	/*   Get the RS error data */
-	rc = GetQAMRSErr_count(dev_addr, &measuredrs_errors);
+	rc = get_qamrs_err_count(dev_addr, &measuredrs_errors);
 	if (rc != DRX_STS_OK) {
 		pr_err("error %d\n", rc);
 		goto rw_error;
@@ -11096,7 +11096,7 @@ ctrl_get_qam_constel(struct drx_demod_instance *demod, struct drx_complex *compl
 	u16 fec_oc_ocr_mode = 0;
 			      /**< FEC OCR grabber configuration        */
 	u16 qam_sl_comm_mb = 0;/**< QAM SL MB configuration              */
-	u16 qam_sl_comm_mbInit = 0;
+	u16 qam_sl_comm_mb_init = 0;
 			      /**< QAM SL MB intial configuration       */
 	u16 im = 0;	      /**< constellation Im part                */
 	u16 re = 0;	      /**< constellation Re part                */
@@ -11110,13 +11110,13 @@ ctrl_get_qam_constel(struct drx_demod_instance *demod, struct drx_complex *compl
 	/* Needs to be checked when external interface PG is updated */
 
 	/* Configure MB (Monitor bus) */
-	rc = DRXJ_DAP.read_reg16func(dev_addr, QAM_SL_COMM_MB__A, &qam_sl_comm_mbInit, 0);
+	rc = DRXJ_DAP.read_reg16func(dev_addr, QAM_SL_COMM_MB__A, &qam_sl_comm_mb_init, 0);
 	if (rc != DRX_STS_OK) {
 		pr_err("error %d\n", rc);
 		goto rw_error;
 	}
 	/* set observe flag & MB mux */
-	qam_sl_comm_mb = qam_sl_comm_mbInit & (~(QAM_SL_COMM_MB_OBS__M +
+	qam_sl_comm_mb = qam_sl_comm_mb_init & (~(QAM_SL_COMM_MB_OBS__M +
 					   QAM_SL_COMM_MB_MUX_OBS__M));
 	qam_sl_comm_mb |= (QAM_SL_COMM_MB_OBS_ON +
 			QAM_SL_COMM_MB_MUX_OBS_CONST_CORR);
@@ -11175,7 +11175,7 @@ ctrl_get_qam_constel(struct drx_demod_instance *demod, struct drx_complex *compl
 	complex_nr->im = ((s16) im);
 
 	/* Restore MB (Monitor bus) */
-	rc = DRXJ_DAP.write_reg16func(dev_addr, QAM_SL_COMM_MB__A, qam_sl_comm_mbInit, 0);
+	rc = DRXJ_DAP.write_reg16func(dev_addr, QAM_SL_COMM_MB__A, qam_sl_comm_mb_init, 0);
 	if (rc != DRX_STS_OK) {
 		pr_err("error %d\n", rc);
 		goto rw_error;
@@ -12316,14 +12316,14 @@ trouble ?
 		ucode_info.mc_size = common_attr->microcode_size;
 
 		/* Upload only audio microcode */
-		rc = ctrl_u_codeUpload(demod, &ucode_info, UCODE_UPLOAD, true);
+		rc = ctrl_u_code_upload(demod, &ucode_info, UCODE_UPLOAD, true);
 		if (rc != DRX_STS_OK) {
 			pr_err("error %d\n", rc);
 			goto rw_error;
 		}
 
 		if (common_attr->verify_microcode == true) {
-			rc = ctrl_u_codeUpload(demod, &ucode_info, UCODE_VERIFY, true);
+			rc = ctrl_u_code_upload(demod, &ucode_info, UCODE_VERIFY, true);
 			if (rc != DRX_STS_OK) {
 				pr_err("error %d\n", rc);
 				goto rw_error;
@@ -13579,8 +13579,8 @@ static int aud_get_modus(struct drx_demod_instance *demod, u16 *modus)
 	int rc;
 
 	u16 r_modus = 0;
-	u16 r_modusHi = 0;
-	u16 r_modusLo = 0;
+	u16 r_modus_hi = 0;
+	u16 r_modus_lo = 0;
 
 	if (modus == NULL) {
 		return DRX_STS_INVALID_ARG;
@@ -13600,19 +13600,19 @@ static int aud_get_modus(struct drx_demod_instance *demod, u16 *modus)
 	}
 
 	/* Modus register is combined in to RAM location */
-	rc = DRXJ_DAP.read_reg16func(dev_addr, AUD_DEM_RAM_MODUS_HI__A, &r_modusHi, 0);
+	rc = DRXJ_DAP.read_reg16func(dev_addr, AUD_DEM_RAM_MODUS_HI__A, &r_modus_hi, 0);
 	if (rc != DRX_STS_OK) {
 		pr_err("error %d\n", rc);
 		goto rw_error;
 	}
-	rc = DRXJ_DAP.read_reg16func(dev_addr, AUD_DEM_RAM_MODUS_LO__A, &r_modusLo, 0);
+	rc = DRXJ_DAP.read_reg16func(dev_addr, AUD_DEM_RAM_MODUS_LO__A, &r_modus_lo, 0);
 	if (rc != DRX_STS_OK) {
 		pr_err("error %d\n", rc);
 		goto rw_error;
 	}
 
-	r_modus = ((r_modusHi << 12) & AUD_DEM_RAM_MODUS_HI__M)
-	    | (((r_modusLo & AUD_DEM_RAM_MODUS_LO__M)));
+	r_modus = ((r_modus_hi << 12) & AUD_DEM_RAM_MODUS_HI__M)
+	    | (((r_modus_lo & AUD_DEM_RAM_MODUS_LO__M)));
 
 	*modus = r_modus;
 
@@ -16305,7 +16305,7 @@ get_oob_freq_offset(struct drx_demod_instance *demod, s32 *freq_offset)
 	int rc;
 	u16 data = 0;
 	u16 rot = 0;
-	u16 symbol_rateReg = 0;
+	u16 symbol_rate_reg = 0;
 	u32 symbol_rate = 0;
 	s32 coarse_freq_offset = 0;
 	s32 fine_freq_offset = 0;
@@ -16351,12 +16351,12 @@ get_oob_freq_offset(struct drx_demod_instance *demod, s32 *freq_offset)
 	/* get value in KHz */
 	coarse_freq_offset = coarse_sign * frac(temp_freq_offset, 1000, FRAC_ROUND);	/* KHz */
 	/* read data rate */
-	rc = drxj_dap_scu_atomic_read_reg16(dev_addr, SCU_RAM_ORX_RF_RX_DATA_RATE__A, &symbol_rateReg, 0);
+	rc = drxj_dap_scu_atomic_read_reg16(dev_addr, SCU_RAM_ORX_RF_RX_DATA_RATE__A, &symbol_rate_reg, 0);
 	if (rc != DRX_STS_OK) {
 		pr_err("error %d\n", rc);
 		goto rw_error;
 	}
-	switch (symbol_rateReg & SCU_RAM_ORX_RF_RX_DATA_RATE__M) {
+	switch (symbol_rate_reg & SCU_RAM_ORX_RF_RX_DATA_RATE__M) {
 	case SCU_RAM_ORX_RF_RX_DATA_RATE_2048KBPS_REGSPEC:
 	case SCU_RAM_ORX_RF_RX_DATA_RATE_2048KBPS_INVSPEC:
 	case SCU_RAM_ORX_RF_RX_DATA_RATE_2048KBPS_REGSPEC_ALT:
@@ -16681,7 +16681,7 @@ static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_par
 	struct i2c_device_addr *dev_addr = NULL;
 	struct drxj_data *ext_attr = NULL;
 	u16 i = 0;
-	bool mirror_freq_spectOOB = false;
+	bool mirror_freq_spect_oob = false;
 	u16 trk_filter_value = 0;
 	struct drxjscu_cmd scu_cmd;
 	u16 set_param_parameters[3];
@@ -16703,7 +16703,7 @@ static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_par
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
-	mirror_freq_spectOOB = ext_attr->mirror_freq_spectOOB;
+	mirror_freq_spect_oob = ext_attr->mirror_freq_spect_oob;
 
 	/* Check parameters */
 	if (oob_param == NULL) {
@@ -16797,12 +16797,12 @@ static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_par
 			   /* signal is transmitted inverted */
 			   ((oob_param->spectrum_inverted == true) &
 			    /* and tuner is not mirroring the signal */
-			    (!mirror_freq_spectOOB)) |
+			    (!mirror_freq_spect_oob)) |
 			   /* or */
 			   /* signal is transmitted noninverted */
 			   ((oob_param->spectrum_inverted == false) &
 			    /* and tuner is mirroring the signal */
-			    (mirror_freq_spectOOB))
+			    (mirror_freq_spect_oob))
 		    )
 			set_param_parameters[0] =
 			    SCU_RAM_ORX_RF_RX_DATA_RATE_2048KBPS_INVSPEC;
@@ -16815,12 +16815,12 @@ static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_par
 			   /* signal is transmitted inverted */
 			   ((oob_param->spectrum_inverted == true) &
 			    /* and tuner is not mirroring the signal */
-			    (!mirror_freq_spectOOB)) |
+			    (!mirror_freq_spect_oob)) |
 			   /* or */
 			   /* signal is transmitted noninverted */
 			   ((oob_param->spectrum_inverted == false) &
 			    /* and tuner is mirroring the signal */
-			    (mirror_freq_spectOOB))
+			    (mirror_freq_spect_oob))
 		    )
 			set_param_parameters[0] =
 			    SCU_RAM_ORX_RF_RX_DATA_RATE_1544KBPS_INVSPEC;
@@ -16834,12 +16834,12 @@ static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_par
 			   /* signal is transmitted inverted */
 			   ((oob_param->spectrum_inverted == true) &
 			    /* and tuner is not mirroring the signal */
-			    (!mirror_freq_spectOOB)) |
+			    (!mirror_freq_spect_oob)) |
 			   /* or */
 			   /* signal is transmitted noninverted */
 			   ((oob_param->spectrum_inverted == false) &
 			    /* and tuner is mirroring the signal */
-			    (mirror_freq_spectOOB))
+			    (mirror_freq_spect_oob))
 		    )
 			set_param_parameters[0] =
 			    SCU_RAM_ORX_RF_RX_DATA_RATE_3088KBPS_INVSPEC;
@@ -17752,7 +17752,7 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 	case DRX_STANDARD_ITU_A:	/* fallthrough */
 	case DRX_STANDARD_ITU_B:	/* fallthrough */
 	case DRX_STANDARD_ITU_C:
-		rc = set_qamChannel(demod, channel, tuner_freq_offset);
+		rc = set_qam_channel(demod, channel, tuner_freq_offset);
 		if (rc != DRX_STS_OK) {
 			pr_err("error %d\n", rc);
 			goto rw_error;
@@ -17827,7 +17827,7 @@ ctrl_get_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 	struct drx_common_attr *common_attr = NULL;
 	s32 intermediate_freq = 0;
 	s32 ctl_freq_offset = 0;
-	u32 iqm_rc_rateLo = 0;
+	u32 iqm_rc_rate_lo = 0;
 	u32 adc_frequency = 0;
 #ifndef DRXJ_VSB_ONLY
 	int bandwidth_temp = 0;
@@ -17895,7 +17895,7 @@ ctrl_get_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 		goto rw_error;
 	}
 	if ((lock_status == DRX_LOCKED) || (lock_status == DRXJ_DEMOD_LOCK)) {
-		rc = drxj_dap_atomic_read_reg32(dev_addr, IQM_RC_RATE_LO__A, &iqm_rc_rateLo, 0);
+		rc = drxj_dap_atomic_read_reg32(dev_addr, IQM_RC_RATE_LO__A, &iqm_rc_rate_lo, 0);
 		if (rc != DRX_STS_OK) {
 			pr_err("error %d\n", rc);
 			goto rw_error;
@@ -17903,7 +17903,7 @@ ctrl_get_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 		adc_frequency = (common_attr->sys_clock_freq * 1000) / 3;
 
 		channel->symbolrate =
-		    frac28(adc_frequency, (iqm_rc_rateLo + (1 << 23))) >> 7;
+		    frac28(adc_frequency, (iqm_rc_rate_lo + (1 << 23))) >> 7;
 
 		switch (standard) {
 		case DRX_STANDARD_8VSB:
@@ -19095,7 +19095,7 @@ bool is_mc_block_audio(u32 addr)
 /*============================================================================*/
 
 /**
-* \fn int ctrl_u_codeUpload()
+* \fn int ctrl_u_code_upload()
 * \brief Handle Audio or !Audio part of microcode upload.
 * \param demod          Pointer to demodulator instance.
 * \param mc_info         Pointer to information about microcode data.
@@ -19105,7 +19105,7 @@ bool is_mc_block_audio(u32 addr)
 * \return int.
 */
 static int
-ctrl_u_codeUpload(struct drx_demod_instance *demod,
+ctrl_u_code_upload(struct drx_demod_instance *demod,
 		  struct drxu_code_info *mc_info,
 		enum drxu_code_actionaction, bool upload_audio_mc)
 {
@@ -19194,7 +19194,7 @@ ctrl_u_codeUpload(struct drx_demod_instance *demod,
 			case UCODE_VERIFY:
 				{
 					int result = 0;
-					u8 mc_dataBuffer
+					u8 mc_data_buffer
 					    [DRXJ_UCODE_MAX_BUF_SIZE];
 					u32 bytes_to_compare = 0;
 					u32 bytes_left_to_compare = 0;
@@ -19223,7 +19223,7 @@ ctrl_u_codeUpload(struct drx_demod_instance *demod,
 								  (u16)
 								  bytes_to_compare,
 								  (u8 *)
-								  mc_dataBuffer,
+								  mc_data_buffer,
 								  0x0000) !=
 						    DRX_STS_OK) {
 							return DRX_STS_ERROR;
@@ -19231,7 +19231,7 @@ ctrl_u_codeUpload(struct drx_demod_instance *demod,
 
 						result =
 						    drxbsp_hst_memcmp(curr_ptr,
-								      mc_dataBuffer,
+								      mc_data_buffer,
 								      bytes_to_compare);
 
 						if (result != 0) {
@@ -20444,7 +20444,7 @@ int drxj_open(struct drx_demod_instance *demod)
 
 #ifdef DRXJ_SPLIT_UCODE_UPLOAD
 		/* Upload microcode without audio part */
-		rc = ctrl_u_codeUpload(demod, &ucode_info, UCODE_UPLOAD, false);
+		rc = ctrl_u_code_upload(demod, &ucode_info, UCODE_UPLOAD, false);
 		if (rc != DRX_STS_OK) {
 			pr_err("error %d\n", rc);
 			goto rw_error;
@@ -20458,7 +20458,7 @@ int drxj_open(struct drx_demod_instance *demod)
 #endif /* DRXJ_SPLIT_UCODE_UPLOAD */
 		if (common_attr->verify_microcode == true) {
 #ifdef DRXJ_SPLIT_UCODE_UPLOAD
-			rc = ctrl_u_codeUpload(demod, &ucode_info, UCODE_VERIFY, false);
+			rc = ctrl_u_code_upload(demod, &ucode_info, UCODE_VERIFY, false);
 			if (rc != DRX_STS_OK) {
 				pr_err("error %d\n", rc);
 				goto rw_error;
@@ -20483,7 +20483,7 @@ int drxj_open(struct drx_demod_instance *demod)
 
 	/* Open tuner instance */
 	if (demod->my_tuner != NULL) {
-		demod->my_tuner->my_common_attr->myUser_data = (void *)demod;
+		demod->my_tuner->my_common_attr->my_user_data = (void *)demod;
 
 		if (common_attr->tuner_port_nr == 1) {
 			bool bridge_closed = true;
@@ -20819,7 +20819,7 @@ drxj_ctrl(struct drx_demod_instance *demod, u32 ctrl, void *ctrl_data)
       /*======================================================================*/
 	case DRX_CTRL_GET_UIO_CFG:
 		{
-			return CtrlGetuio_cfg(demod, (struct drxuio_cfg *)ctrl_data);
+			return ctrl_getuio_cfg(demod, (struct drxuio_cfg *)ctrl_data);
 		}
 		break;
       /*======================================================================*/
@@ -20872,14 +20872,14 @@ drxj_ctrl(struct drx_demod_instance *demod, u32 ctrl, void *ctrl_data)
 #ifdef DRXJ_SPLIT_UCODE_UPLOAD
 	case DRX_CTRL_LOAD_UCODE:
 		{
-			return ctrl_u_codeUpload(demod,
+			return ctrl_u_code_upload(demod,
 					       (p_drxu_code_info_t) ctrl_data,
 					       UCODE_UPLOAD, false);
 		}
 		break;
 	case DRX_CTRL_VERIFY_UCODE:
 		{
-			return ctrl_u_codeUpload(demod,
+			return ctrl_u_code_upload(demod,
 					       (p_drxu_code_info_t) ctrl_data,
 					       UCODE_VERIFY, false);
 		}
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.h b/drivers/media/dvb-frontends/drx39xyj/drxj.h
index f41a61e49594..c38245ee15ed 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.h
@@ -426,7 +426,7 @@ struct drxj_cfg_atv_output {
 		u8 mfx;		  /**< metal fix */
 
 		/* tuner settings */
-		bool mirror_freq_spectOOB;/**< tuner inversion (true = tuner mirrors the signal */
+		bool mirror_freq_spect_oob;/**< tuner inversion (true = tuner mirrors the signal */
 
 		/* standard/channel settings */
 		enum drx_standard standard;	  /**< current standard information                     */
@@ -446,7 +446,7 @@ struct drxj_cfg_atv_output {
 		u16 fec_rs_prescale;	  /**< ReedSolomon Measurement Prescale                 */
 		u16 fec_rs_period;	  /**< ReedSolomon Measurement period                   */
 		bool reset_pkt_err_acc;	  /**< Set a flag to reset accumulated packet error     */
-		u16 pkt_errAccStart;	  /**< Set a flag to reset accumulated packet error     */
+		u16 pkt_err_acc_start;	  /**< Set a flag to reset accumulated packet error     */
 
 		/* HI configuration */
 		u16 hi_cfg_timing_div;	  /**< HI Configure() parameter 2                       */
-- 
1.8.5.3

