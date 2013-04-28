Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265Ab3D1PsD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Apr 2013 11:48:03 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3SFm2Q4013736
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 28 Apr 2013 11:48:03 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 6/9] [media] drxk_hard.h: Remove some alien comment markups
Date: Sun, 28 Apr 2013 12:47:48 -0300
Message-Id: <1367164071-11468-7-git-send-email-mchehab@redhat.com>
In-Reply-To: <1367164071-11468-1-git-send-email-mchehab@redhat.com>
References: <1367164071-11468-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The comments markup language used on Kernel is defined at:
	Documentation/kernel-doc-nano-HOWTO.txt

Remove invalid markups from the header file.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/drxk_hard.h | 106 ++++++++++++++++----------------
 1 file changed, 53 insertions(+), 53 deletions(-)

diff --git a/drivers/media/dvb-frontends/drxk_hard.h b/drivers/media/dvb-frontends/drxk_hard.h
index db87a6d..e77d9f0 100644
--- a/drivers/media/dvb-frontends/drxk_hard.h
+++ b/drivers/media/dvb-frontends/drxk_hard.h
@@ -77,17 +77,17 @@ enum drx_power_mode {
 };
 
 
-/** /brief Intermediate power mode for DRXK, power down OFDM clock domain */
+/* Intermediate power mode for DRXK, power down OFDM clock domain */
 #ifndef DRXK_POWER_DOWN_OFDM
 #define DRXK_POWER_DOWN_OFDM        DRX_POWER_MODE_1
 #endif
 
-/** /brief Intermediate power mode for DRXK, power down core (sysclk) */
+/* Intermediate power mode for DRXK, power down core (sysclk) */
 #ifndef DRXK_POWER_DOWN_CORE
 #define DRXK_POWER_DOWN_CORE        DRX_POWER_MODE_9
 #endif
 
-/** /brief Intermediate power mode for DRXK, power down pll (only osc runs) */
+/* Intermediate power mode for DRXK, power down pll (only osc runs) */
 #ifndef DRXK_POWER_DOWN_PLL
 #define DRXK_POWER_DOWN_PLL         DRX_POWER_MODE_10
 #endif
@@ -193,13 +193,13 @@ struct s_cfg_pre_saw {
 };
 
 struct drxk_ofdm_sc_cmd_t {
-	u16 cmd;        /**< Command number */
-	u16 subcmd;     /**< Sub-command parameter*/
-	u16 param0;     /**< General purpous param */
-	u16 param1;     /**< General purpous param */
-	u16 param2;     /**< General purpous param */
-	u16 param3;     /**< General purpous param */
-	u16 param4;     /**< General purpous param */
+	u16 cmd;        /* Command number */
+	u16 subcmd;     /* Sub-command parameter*/
+	u16 param0;     /* General purpous param */
+	u16 param1;     /* General purpous param */
+	u16 param2;     /* General purpous param */
+	u16 param3;     /* General purpous param */
+	u16 param4;     /* General purpous param */
 };
 
 struct drxk_state {
@@ -213,7 +213,7 @@ struct drxk_state {
 
 	struct mutex mutex;
 
-	u32    m_instance;           /**< Channel 1,2,3 or 4 */
+	u32    m_instance;           /* Channel 1,2,3 or 4 */
 
 	int    m_chunk_size;
 	u8 chunk[256];
@@ -234,33 +234,33 @@ struct drxk_state {
 	u16    m_hi_cfg_wake_up_key;
 	u16    m_hi_cfg_timeout;
 	u16    m_hi_cfg_ctrl;
-	s32    m_sys_clock_freq;      /**< system clock frequency in kHz */
-
-	enum e_drxk_state    m_drxk_state;      /**< State of Drxk (init,stopped,started) */
-	enum operation_mode m_operation_mode;  /**< digital standards */
-	struct s_cfg_agc     m_vsb_rf_agc_cfg;    /**< settings for VSB RF-AGC */
-	struct s_cfg_agc     m_vsb_if_agc_cfg;    /**< settings for VSB IF-AGC */
-	u16                m_vsb_pga_cfg;      /**< settings for VSB PGA */
-	struct s_cfg_pre_saw  m_vsb_pre_saw_cfg;   /**< settings for pre SAW sense */
-	s32    m_Quality83percent;  /**< MER level (*0.1 dB) for 83% quality indication */
-	s32    m_Quality93percent;  /**< MER level (*0.1 dB) for 93% quality indication */
+	s32    m_sys_clock_freq;      /* system clock frequency in kHz */
+
+	enum e_drxk_state    m_drxk_state;      /* State of Drxk (init,stopped,started) */
+	enum operation_mode m_operation_mode;  /* digital standards */
+	struct s_cfg_agc     m_vsb_rf_agc_cfg;    /* settings for VSB RF-AGC */
+	struct s_cfg_agc     m_vsb_if_agc_cfg;    /* settings for VSB IF-AGC */
+	u16                m_vsb_pga_cfg;      /* settings for VSB PGA */
+	struct s_cfg_pre_saw  m_vsb_pre_saw_cfg;   /* settings for pre SAW sense */
+	s32    m_Quality83percent;  /* MER level (*0.1 dB) for 83% quality indication */
+	s32    m_Quality93percent;  /* MER level (*0.1 dB) for 93% quality indication */
 	bool   m_smart_ant_inverted;
 	bool   m_b_debug_enable_bridge;
-	bool   m_b_p_down_open_bridge;  /**< only open DRXK bridge before power-down once it has been accessed */
-	bool   m_b_power_down;        /**< Power down when not used */
-
-	u32    m_iqm_fs_rate_ofs;      /**< frequency shift as written to DRXK register (28bit fixpoint) */
-
-	bool   m_enable_mpeg_output;  /**< If TRUE, enable MPEG output */
-	bool   m_insert_rs_byte;      /**< If TRUE, insert RS byte */
-	bool   m_enable_parallel;    /**< If TRUE, parallel out otherwise serial */
-	bool   m_invert_data;        /**< If TRUE, invert DATA signals */
-	bool   m_invert_err;         /**< If TRUE, invert ERR signal */
-	bool   m_invert_str;         /**< If TRUE, invert STR signals */
-	bool   m_invert_val;         /**< If TRUE, invert VAL signals */
-	bool   m_invert_clk;         /**< If TRUE, invert CLK signals */
+	bool   m_b_p_down_open_bridge;  /* only open DRXK bridge before power-down once it has been accessed */
+	bool   m_b_power_down;        /* Power down when not used */
+
+	u32    m_iqm_fs_rate_ofs;      /* frequency shift as written to DRXK register (28bit fixpoint) */
+
+	bool   m_enable_mpeg_output;  /* If TRUE, enable MPEG output */
+	bool   m_insert_rs_byte;      /* If TRUE, insert RS byte */
+	bool   m_enable_parallel;    /* If TRUE, parallel out otherwise serial */
+	bool   m_invert_data;        /* If TRUE, invert DATA signals */
+	bool   m_invert_err;         /* If TRUE, invert ERR signal */
+	bool   m_invert_str;         /* If TRUE, invert STR signals */
+	bool   m_invert_val;         /* If TRUE, invert VAL signals */
+	bool   m_invert_clk;         /* If TRUE, invert CLK signals */
 	bool   m_dvbc_static_clk;
-	bool   m_dvbt_static_clk;     /**< If TRUE, static MPEG clockrate will
+	bool   m_dvbt_static_clk;     /* If TRUE, static MPEG clockrate will
 					 be used, otherwise clockrate will
 					 adapt to the bitrate of the TS */
 	u32    m_dvbt_bitrate;
@@ -271,22 +271,22 @@ struct drxk_state {
 
 	bool   m_itut_annex_c;      /* If true, uses ITU-T DVB-C Annex C, instead of Annex A */
 
-	enum drxmpeg_str_width_t  m_width_str;    /**< MPEG start width */
-	u32    m_mpeg_ts_static_bitrate;          /**< Maximum bitrate in b/s in case
+	enum drxmpeg_str_width_t  m_width_str;    /* MPEG start width */
+	u32    m_mpeg_ts_static_bitrate;          /* Maximum bitrate in b/s in case
 						    static clockrate is selected */
 
-	/* LARGE_INTEGER   m_startTime; */     /**< Contains the time of the last demod start */
-	s32    m_mpeg_lock_time_out;      /**< WaitForLockStatus Timeout (counts from start time) */
-	s32    m_demod_lock_time_out;     /**< WaitForLockStatus Timeout (counts from start time) */
+	/* LARGE_INTEGER   m_startTime; */     /* Contains the time of the last demod start */
+	s32    m_mpeg_lock_time_out;      /* WaitForLockStatus Timeout (counts from start time) */
+	s32    m_demod_lock_time_out;     /* WaitForLockStatus Timeout (counts from start time) */
 
 	bool   m_disable_te_ihandling;
 
 	bool   m_rf_agc_pol;
 	bool   m_if_agc_pol;
 
-	struct s_cfg_agc    m_atv_rf_agc_cfg;  /**< settings for ATV RF-AGC */
-	struct s_cfg_agc    m_atv_if_agc_cfg;  /**< settings for ATV IF-AGC */
-	struct s_cfg_pre_saw m_atv_pre_saw_cfg; /**< settings for ATV pre SAW sense */
+	struct s_cfg_agc    m_atv_rf_agc_cfg;  /* settings for ATV RF-AGC */
+	struct s_cfg_agc    m_atv_if_agc_cfg;  /* settings for ATV IF-AGC */
+	struct s_cfg_pre_saw m_atv_pre_saw_cfg; /* settings for ATV pre SAW sense */
 	bool              m_phase_correction_bypass;
 	s16               m_atv_top_vid_peak;
 	u16               m_atv_top_noise_th;
@@ -294,13 +294,13 @@ struct drxk_state {
 	bool              m_enable_cvbs_output;
 	bool              m_enable_sif_output;
 	bool              m_b_mirror_freq_spect;
-	enum e_drxk_constellation  m_constellation; /**< constellation type of the channel */
-	u32               m_curr_symbol_rate;       /**< Current QAM symbol rate */
-	struct s_cfg_agc    m_qam_rf_agc_cfg;          /**< settings for QAM RF-AGC */
-	struct s_cfg_agc    m_qam_if_agc_cfg;          /**< settings for QAM IF-AGC */
-	u16               m_qam_pga_cfg;            /**< settings for QAM PGA */
-	struct s_cfg_pre_saw m_qam_pre_saw_cfg;         /**< settings for QAM pre SAW sense */
-	enum e_drxk_interleave_mode m_qam_interleave_mode; /**< QAM Interleave mode */
+	enum e_drxk_constellation  m_constellation; /* constellation type of the channel */
+	u32               m_curr_symbol_rate;       /* Current QAM symbol rate */
+	struct s_cfg_agc    m_qam_rf_agc_cfg;          /* settings for QAM RF-AGC */
+	struct s_cfg_agc    m_qam_if_agc_cfg;          /* settings for QAM IF-AGC */
+	u16               m_qam_pga_cfg;            /* settings for QAM PGA */
+	struct s_cfg_pre_saw m_qam_pre_saw_cfg;         /* settings for QAM pre SAW sense */
+	enum e_drxk_interleave_mode m_qam_interleave_mode; /* QAM Interleave mode */
 	u16               m_fec_rs_plen;
 	u16               m_fec_rs_prescale;
 
@@ -309,9 +309,9 @@ struct drxk_state {
 	u16               m_gpio;
 	u16               m_gpio_cfg;
 
-	struct s_cfg_agc    m_dvbt_rf_agc_cfg;     /**< settings for QAM RF-AGC */
-	struct s_cfg_agc    m_dvbt_if_agc_cfg;     /**< settings for QAM IF-AGC */
-	struct s_cfg_pre_saw m_dvbt_pre_saw_cfg;    /**< settings for QAM pre SAW sense */
+	struct s_cfg_agc    m_dvbt_rf_agc_cfg;     /* settings for QAM RF-AGC */
+	struct s_cfg_agc    m_dvbt_if_agc_cfg;     /* settings for QAM IF-AGC */
+	struct s_cfg_pre_saw m_dvbt_pre_saw_cfg;    /* settings for QAM pre SAW sense */
 
 	u16               m_agcfast_clip_ctrl_delay;
 	bool              m_adc_comp_passed;
-- 
1.8.1.4

