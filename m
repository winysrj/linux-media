Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49314 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbaCCKHv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:51 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 17/79] [media] drx-j: Remove a bunch of unused but assigned vars
Date: Mon,  3 Mar 2014 07:06:11 -0300
Message-Id: <1393841233-24840-18-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

None of those vars are used on those functions. Just remove them.

After this patch, there's just one of such warnings:

	drivers/media/dvb-frontends/drx39xyj/drxj.c: In function 'ctrl_get_qam_sig_quality':
	drivers/media/dvb-frontends/drx39xyj/drxj.c:7872:6: warning: variable 'ber_cnt' set but not used [-Wunused-but-set-variable]
	  u32 ber_cnt = 0; /* BER count */

We'll keep it, as BER count will be useful when converting the
frontend to report statistics via DVBv5 API

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 136 ++++++----------------------
 1 file changed, 29 insertions(+), 107 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 5bf215e33f2f..24f84e5d5bd0 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -3341,13 +3341,10 @@ static int
 ctrl_get_cfg_hw_cfg(pdrx_demod_instance_t demod, p_drxj_cfg_hw_cfg_t cfg_data)
 {
 	u16 data = 0;
-	pdrxj_data_t ext_attr = (pdrxj_data_t) (NULL);
 
-	if (cfg_data == NULL) {
+	if (cfg_data == NULL)
 		return (DRX_STS_INVALID_ARG);
-	}
 
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
 	WR16(demod->my_i2c_dev_addr, SIO_TOP_COMM_KEY__A, 0xFABA);
 	RR16(demod->my_i2c_dev_addr, SIO_PDR_OHW_CFG__A, &data);
 	WR16(demod->my_i2c_dev_addr, SIO_TOP_COMM_KEY__A, 0x0000);
@@ -4299,11 +4296,7 @@ rw_error:
 static int iqm_set_af(pdrx_demod_instance_t demod, bool active)
 {
 	u16 data = 0;
-	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
-
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
-	dev_addr = demod->my_i2c_dev_addr;
+	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
 
 	/* Configure IQM */
 	RR16(dev_addr, IQM_AF_STDBY__A, &data);
@@ -4315,7 +4308,6 @@ static int iqm_set_af(pdrx_demod_instance_t demod, bool active)
 			 & (~IQM_AF_STDBY_STDBY_TAGC_RF_A2_ACTIVE)
 		    );
 	} else {		/* active */
-
 		data |= (IQM_AF_STDBY_STDBY_ADC_A2_ACTIVE
 			 | IQM_AF_STDBY_STDBY_AMP_A2_ACTIVE
 			 | IQM_AF_STDBY_STDBY_PD_A2_ACTIVE
@@ -4342,17 +4334,14 @@ ctrl_set_cfg_atv_output(pdrx_demod_instance_t demod, p_drxj_cfg_atv_output_t out
 static int
 ctrl_set_cfg_pdr_safe_mode(pdrx_demod_instance_t demod, bool *enable)
 {
-	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
-	pdrx_common_attr_t common_attr = (pdrx_common_attr_t) NULL;
+	pdrxj_data_t ext_attr = NULL;
+	struct i2c_device_addr *dev_addr = NULL;
 
-	if (enable == NULL) {
+	if (enable == NULL)
 		return (DRX_STS_INVALID_ARG);
-	}
 
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
-	common_attr = demod->my_common_attr;
 
 	/*  Write magic word to enable pdr reg write  */
 	WR16(dev_addr, SIO_TOP_COMM_KEY__A, SIO_TOP_COMM_KEY_KEY);
@@ -4744,27 +4733,22 @@ static int
 set_frequency(pdrx_demod_instance_t demod,
 	      pdrx_channel_t channel, s32 tuner_freq_offset)
 {
-	struct i2c_device_addr *dev_addr = NULL;
-	pdrx_common_attr_t common_attr = NULL;
+	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
+	pdrxj_data_t ext_attr = demod->my_ext_attr;
 	s32 sampling_frequency = 0;
 	s32 frequency_shift = 0;
 	s32 if_freq_actual = 0;
-	s32 rf_freq_residual = 0;
+	s32 rf_freq_residual = -1 * tuner_freq_offset;
 	s32 adc_freq = 0;
 	s32 intermediate_freq = 0;
 	u32 iqm_fs_rate_ofs = 0;
-	pdrxj_data_t ext_attr = NULL;
 	bool adc_flip = true;
 	bool select_pos_image = false;
-	bool rf_mirror = false;
-	bool tuner_mirror = true;
+	bool rf_mirror;
+	bool tuner_mirror;
 	bool image_to_select = true;
 	s32 fm_frequency_shift = 0;
 
-	dev_addr = demod->my_i2c_dev_addr;
-	common_attr = (pdrx_common_attr_t) demod->my_common_attr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
-	rf_freq_residual = -1 * tuner_freq_offset;
 	rf_mirror = (ext_attr->mirror == DRX_MIRROR_YES) ? true : false;
 	tuner_mirror = demod->my_common_attr->mirror_freq_spect ? false : true;
 	/*
@@ -4851,17 +4835,13 @@ rw_error:
 
 static int get_sig_strength(pdrx_demod_instance_t demod, u16 *sig_strength)
 {
+	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
 	u16 rf_gain = 0;
 	u16 if_gain = 0;
 	u16 if_agc_sns = 0;
 	u16 if_agc_top = 0;
 	u16 rf_agc_max = 0;
 	u16 rf_agc_min = 0;
-	pdrxj_data_t ext_attr = NULL;
-	struct i2c_device_addr *dev_addr = NULL;
-
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
-	dev_addr = demod->my_i2c_dev_addr;
 
 	RR16(dev_addr, IQM_AF_AGC_IF__A, &if_gain);
 	if_gain &= IQM_AF_AGC_IF__M;
@@ -4976,13 +4956,8 @@ static int get_str_freq_offset(pdrx_demod_instance_t demod, s32 *str_freq)
 	u32 symbol_frequency_ratio = 0;
 	u32 symbol_nom_frequency_ratio = 0;
 
-	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
-	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
-
-	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
-	standard = ext_attr->standard;
+	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
+	pdrxj_data_t ext_attr = demod->my_ext_attr;
 
 	ARR32(dev_addr, IQM_RC_RATE_LO__A, &symbol_frequency_ratio);
 	symbol_nom_frequency_ratio = ext_attr->iqm_rc_rate_ofs;
@@ -5607,7 +5582,7 @@ rw_error:
 */
 static int power_down_vsb(pdrx_demod_instance_t demod, bool primary)
 {
-	struct i2c_device_addr *dev_addr = NULL;
+	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
 	drxjscu_cmd_t cmd_scu = { /* command     */ 0,
 		/* parameter_len */ 0,
 		/* result_len    */ 0,
@@ -5615,11 +5590,8 @@ static int power_down_vsb(pdrx_demod_instance_t demod, bool primary)
 		/* *result      */ NULL
 	};
 	u16 cmd_result = 0;
-	pdrxj_data_t ext_attr = NULL;
 	drx_cfg_mpeg_output_t cfg_mpeg_output;
 
-	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
 	/*
 	   STOP demodulator
 	   reset of FEC and VSB HW
@@ -6303,13 +6275,9 @@ static int power_down_qam(pdrx_demod_instance_t demod, bool primary)
 		/* *result      */ NULL
 	};
 	u16 cmd_result = 0;
-	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
+	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
 	drx_cfg_mpeg_output_t cfg_mpeg_output;
 
-	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
-
 	/*
 	   STOP demodulator
 	   resets IQM, QAM and FEC HW blocks
@@ -8626,17 +8594,14 @@ ctrl_get_cfg_atv_agc_status(pdrx_demod_instance_t demod,
 			    p_drxj_cfg_atv_agc_status_t agc_status)
 {
 	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
 	u16 data = 0;
 	u32 tmp = 0;
 
 	/* Check arguments */
-	if (agc_status == NULL) {
+	if (agc_status == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
 	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
 
 	/*
 	   RFgain = (IQM_AF_AGC_RF__A * 26.75)/1000 (uA)
@@ -8728,11 +8693,7 @@ rw_error:
 */
 static int power_up_atv(pdrx_demod_instance_t demod, enum drx_standard standard)
 {
-	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
-
-	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
 
 	/* ATV NTSC */
 	WR16(dev_addr, ATV_COMM_EXEC__A, ATV_COMM_EXEC_ACTIVE);
@@ -8766,7 +8727,7 @@ rw_error:
 static int
 power_down_atv(pdrx_demod_instance_t demod, enum drx_standard standard, bool primary)
 {
-	struct i2c_device_addr *dev_addr = NULL;
+	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
 	drxjscu_cmd_t cmd_scu = { /* command      */ 0,
 		/* parameter_len */ 0,
 		/* result_len    */ 0,
@@ -8774,10 +8735,7 @@ power_down_atv(pdrx_demod_instance_t demod, enum drx_standard standard, bool pri
 		/* *result      */ NULL
 	};
 	u16 cmd_result = 0;
-	pdrxj_data_t ext_attr = NULL;
 
-	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
 	/* ATV NTSC */
 
 	/* Stop ATV SCU (will reset ATV and IQM hardware */
@@ -9511,11 +9469,7 @@ get_atv_channel(pdrx_demod_instance_t demod,
 		pdrx_channel_t channel, enum drx_standard standard)
 {
 	s32 offset = 0;
-	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
-
-	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
 
 	/* Bandwidth */
 	channel->bandwidth = ((pdrxj_data_t) demod->my_ext_attr)->curr_bandwidth;
@@ -10580,16 +10534,12 @@ static int
 aud_ctrl_get_cfg_auto_sound(pdrx_demod_instance_t demod,
 			    pdrx_cfg_aud_auto_sound_t auto_sound)
 {
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
-	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
-
+	pdrxj_data_t ext_attr = NULL;
 	u16 r_modus = 0;
 
-	if (auto_sound == NULL) {
+	if (auto_sound == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
 
-	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
 
 	/* power up */
@@ -11315,17 +11265,10 @@ rw_error:
 static int
 aud_ctrl_get_cfg_dev(pdrx_demod_instance_t demod, pdrx_cfg_aud_deviation_t dev)
 {
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)NULL;
-	pdrxj_data_t ext_attr = (pdrxj_data_t) NULL;
-
 	u16 r_modus = 0;
 
-	if (dev == NULL) {
+	if (dev == NULL)
 		return DRX_STS_INVALID_ARG;
-	}
-
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
-	dev_addr = demod->my_i2c_dev_addr;
 
 	CHK_ERROR(aud_get_modus(demod, &r_modus));
 
@@ -12395,11 +12338,7 @@ rw_error:
 static int set_orx_nsu_aox(pdrx_demod_instance_t demod, bool active)
 {
 	u16 data = 0;
-	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
-
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
-	dev_addr = demod->my_i2c_dev_addr;
+	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
 
 	/* Configure NSU_AOX */
 	RR16(dev_addr, ORX_NSU_AOX_STDBY_W__A, &data);
@@ -12458,7 +12397,6 @@ rw_error:
 static int ctrl_set_oob(pdrx_demod_instance_t demod, p_drxoob_t oob_param)
 {
 #ifndef DRXJ_DIGITAL_ONLY
-	drxoob_downstream_standard_t standard = DRX_OOB_MODE_A;
 	s32 freq = 0;	/* KHz */
 	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
@@ -12503,8 +12441,6 @@ static int ctrl_set_oob(pdrx_demod_instance_t demod, p_drxoob_t oob_param)
 		return (DRX_STS_OK);
 	}
 
-	standard = oob_param->standard;
-
 	freq = oob_param->frequency;
 	if ((freq < 70000) || (freq > 130000))
 		return (DRX_STS_ERROR);
@@ -13931,15 +13867,12 @@ static int
 ctrl_get_cfg_symbol_clock_offset(pdrx_demod_instance_t demod, s32 *rate_offset)
 {
 	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
-	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
 
 	/* check arguments */
-	if (rate_offset == NULL) {
+	if (rate_offset == NULL)
 		return (DRX_STS_INVALID_ARG);
-	}
 
-	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
 	standard = ext_attr->standard;
 
@@ -15111,15 +15044,12 @@ rw_error:
 static int
 ctrl_get_cfg_pre_saw(pdrx_demod_instance_t demod, p_drxj_cfg_pre_saw_t pre_saw)
 {
-	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
 
 	/* check arguments */
-	if (pre_saw == NULL) {
+	if (pre_saw == NULL)
 		return (DRX_STS_INVALID_ARG);
-	}
 
-	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
 
 	switch (pre_saw->standard) {
@@ -15171,16 +15101,13 @@ ctrl_get_cfg_pre_saw(pdrx_demod_instance_t demod, p_drxj_cfg_pre_saw_t pre_saw)
 static int
 ctrl_get_cfg_afe_gain(pdrx_demod_instance_t demod, p_drxj_cfg_afe_gain_t afe_gain)
 {
-	struct i2c_device_addr *dev_addr = NULL;
 	pdrxj_data_t ext_attr = NULL;
 
 	/* check arguments */
-	if (afe_gain == NULL) {
+	if (afe_gain == NULL)
 		return (DRX_STS_INVALID_ARG);
-	}
 
-	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
+	ext_attr = demod->my_ext_attr;
 
 	switch (afe_gain->standard) {
 	case DRX_STANDARD_8VSB:
@@ -15724,15 +15651,10 @@ rw_error:
 */
 int drxj_close(pdrx_demod_instance_t demod)
 {
-	struct i2c_device_addr *dev_addr = NULL;
-	pdrxj_data_t ext_attr = NULL;
-	pdrx_common_attr_t common_attr = NULL;
+	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
+	pdrx_common_attr_t common_attr = demod->my_common_attr;
 	drx_power_mode_t power_mode = DRX_POWER_UP;
 
-	common_attr = (pdrx_common_attr_t) demod->my_common_attr;
-	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (pdrxj_data_t) demod->my_ext_attr;
-
 	/* power up */
 	CHK_ERROR(ctrl_power_mode(demod, &power_mode));
 
-- 
1.8.5.3

