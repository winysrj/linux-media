Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49510 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbaCCKIR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:17 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 56/79] [media] drx-j: comment or remove unused code
Date: Mon,  3 Mar 2014 07:06:50 -0300
Message-Id: <1393841233-24840-57-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to avoid warnings and to remove dead code, remove
the functions that don't make sense to happen, while commenting
the others that might still be useful some day.

That reduced a lot the text size:

Before:

   text	   data	    bss	    dec	    hex	filename
  58419	   2916	      4	  61339	   ef9b	drivers/media/dvb-frontends/drx39xyj/drx39xyj.ko

After:
   text	   data	    bss	    dec	    hex	filename
  78331	   2916	      4	  81251	  13d63	drivers/media/dvb-frontends/drx39xyj/drx39xyj.ko

Without any functional changes.

It could be make sense latter to remove those drivers or to
move them into an analog-specific part of the driver.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 362 ++++++----------------------
 1 file changed, 72 insertions(+), 290 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 66a83b83f70e..0dfb338731a4 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -1083,12 +1083,12 @@ ctrl_power_mode(struct drx_demod_instance *demod, enum drx_power_mode *mode);
 
 static int power_down_aud(struct drx_demod_instance *demod);
 
-#ifndef DRXJ_DIGITAL_ONLY
+#if 0
 static int power_up_aud(struct drx_demod_instance *demod, bool set_standard);
-#endif
 
 static int
 aud_ctrl_set_standard(struct drx_demod_instance *demod, enum drx_aud_standard *standard);
+#endif
 
 static int
 ctrl_set_cfg_pre_saw(struct drx_demod_instance *demod, struct drxj_cfg_pre_saw *pre_saw);
@@ -1102,6 +1102,7 @@ ctrl_set_cfg_afe_gain(struct drx_demod_instance *demod, struct drxj_cfg_afe_gain
 /*============================================================================*/
 /*============================================================================*/
 
+#if 0
 /**
 * \fn void mult32(u32 a, u32 b, u32 *h, u32 *l)
 * \brief 32bitsx32bits signed multiplication
@@ -1191,6 +1192,7 @@ static void mult32(u32 a, u32 b, u32 *h, u32 *l)
 		}
 	}
 }
+#endif
 
 /*============================================================================*/
 
@@ -1384,6 +1386,7 @@ static u32 frac_times1e6(u32 N, u32 D)
 
 /*============================================================================*/
 
+#if 0
 /**
 * \brief Compute: 100 * 10^( gd_b / 200 ).
 * \param  u32   gd_b      Gain in 0.1dB
@@ -1425,7 +1428,6 @@ static u32 d_b2lin_times100(u32 gd_b)
 	return (result + 50) / 100;
 }
 
-#ifndef DRXJ_DIGITAL_ONLY
 #define FRAC_FLOOR    0
 #define FRAC_CEIL     1
 #define FRAC_ROUND    2
@@ -3194,6 +3196,7 @@ rw_error:
 
 /*----------------------------------------------------------------------------*/
 
+#if 0
 /**
 * \fn int ctrl_get_cfg_mpeg_output()
 * \brief Get MPEG output configuration of the device.
@@ -3253,6 +3256,7 @@ ctrl_get_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
 rw_error:
 	return -EIO;
 }
+#endif
 
 /*----------------------------------------------------------------------------*/
 /* MPEG Output Configuration Functions - end                                  */
@@ -3387,6 +3391,7 @@ rw_error:
 * This routine should be called during a set channel of QAM/VSB
 *
 */
+#if 0
 static int set_mpeg_output_clock_rate(struct drx_demod_instance *demod)
 {
 	struct drxj_data *ext_attr = (struct drxj_data *) (NULL);
@@ -3408,6 +3413,7 @@ static int set_mpeg_output_clock_rate(struct drx_demod_instance *demod)
 rw_error:
 	return -EIO;
 }
+#endif
 
 /*----------------------------------------------------------------------------*/
 /**
@@ -3453,6 +3459,7 @@ rw_error:
 	return -EIO;
 }
 
+#if 0
 /*----------------------------------------------------------------------------*/
 /**
 * \fn int ctrl_set_cfg_mpeg_output_misc()
@@ -3609,6 +3616,7 @@ ctrl_get_cfg_hw_cfg(struct drx_demod_instance *demod, struct drxj_cfg_hw_cfg *cf
 rw_error:
 	return -EIO;
 }
+#endif
 
 /*----------------------------------------------------------------------------*/
 /* miscellaneous configuartions - end                             */
@@ -3754,6 +3762,7 @@ rw_error:
 	return -EIO;
 }
 
+#if 0
 /*============================================================================*/
 /**
 * \fn int ctrl_getuio_cfg()
@@ -3794,6 +3803,7 @@ static int ctrl_getuio_cfg(struct drx_demod_instance *demod, struct drxuio_cfg *
 
 	return 0;
 }
+#endif
 
 /**
 * \fn int ctrl_uio_write()
@@ -3997,6 +4007,7 @@ rw_error:
 	return -EIO;
 }
 
+#if 0
 /**
 *\fn int ctrl_uio_read
 *\brief Read from a UIO.
@@ -4174,6 +4185,7 @@ static int ctrl_uio_read(struct drx_demod_instance *demod, struct drxuio_data *u
 rw_error:
 	return -EIO;
 }
+#endif
 
 /*---------------------------------------------------------------------------*/
 /* UIO Configuration Functions - end                                         */
@@ -4290,6 +4302,7 @@ rw_error:
 	return -EIO;
 }
 
+#if 0
 /**
 * \fn int ctrl_set_cfg_smart_ant()
 * \brief Set Smart Antenna.
@@ -4400,6 +4413,7 @@ ctrl_set_cfg_smart_ant(struct drx_demod_instance *demod, struct drxj_cfg_smart_a
 rw_error:
 	return -EIO;
 }
+#endif
 
 static int scu_command(struct i2c_device_addr *dev_addr, struct drxjscu_cmd *cmd)
 {
@@ -4659,12 +4673,6 @@ int drxj_dap_scu_atomic_write_reg16(struct i2c_device_addr *dev_addr,
 	return rc;
 }
 
-static int
-ctrl_i2c_write_read(struct drx_demod_instance *demod, struct drxi2c_data *i2c_data)
-{
-	return -ENOTSUPP;
-}
-
 /* -------------------------------------------------------------------------- */
 /**
 * \brief Measure result of ADC synchronisation
@@ -4789,6 +4797,7 @@ rw_error:
 	return -EIO;
 }
 
+#if 0
 /**
 * \brief Configure IQM AF registers
 * \param demod instance of demodulator.
@@ -5101,43 +5110,7 @@ ctrl_get_cfg_pdr_safe_mode(struct drx_demod_instance *demod, bool *enabled)
 
 	return 0;
 }
-
-/**
-* \brief Verifies whether microcode can be loaded.
-* \param demod Demodulator instance.
-* \return int.
-*/
-static int ctrl_validate_u_code(struct drx_demod_instance *demod)
-{
-	u32 mc_dev, mc_patch;
-	u16 ver_type;
-
-	/* Check device.
-	 *  Disallow microcode if:
-	 *   - MC has version record AND
-	 *   - device ID in version record is not 0 AND
-	 *   - product ID in version record's device ID does not
-	 *     match DRXJ1 product IDs - 0x393 or 0x394
-	 */
-	ver_type = DRX_ATTR_MCRECORD(demod).aux_type;
-	mc_dev = DRX_ATTR_MCRECORD(demod).mc_dev_type;
-	mc_patch = DRX_ATTR_MCRECORD(demod).mc_base_version;
-
-	if (DRX_ISMCVERTYPE(ver_type)) {
-		if ((mc_dev != 0) &&
-		    (((mc_dev >> 16) & 0xFFF) != 0x393) &&
-		    (((mc_dev >> 16) & 0xFFF) != 0x394)) {
-			/* Microcode is marked for another device - error */
-			return -EINVAL;
-		} else if (mc_patch != 0) {
-			/* Patch not allowed because there is no ROM */
-			return -EINVAL;
-		}
-	}
-
-	/* Everything else: OK */
-	return 0;
-}
+#endif
 
 /*============================================================================*/
 /*==                      END AUXILIARY FUNCTIONS                           ==*/
@@ -5350,7 +5323,7 @@ static int init_agc(struct drx_demod_instance *demod)
 		}
 		break;
 #endif
-#ifndef DRXJ_DIGITAL_ONLY
+#if 0
 	case DRX_STANDARD_FM:
 		clp_sum_max = 1023;
 		sns_sum_max = 1023;
@@ -5687,6 +5660,7 @@ rw_error:
 	return -EIO;
 }
 
+#if 0
 /**
 * \fn int get_sig_strength()
 * \brief Retrieve signal strength for VSB and QAM.
@@ -5763,6 +5737,7 @@ static int get_sig_strength(struct drx_demod_instance *demod, u16 *sig_strength)
 rw_error:
 	return -EIO;
 }
+#endif
 
 /**
 * \fn int get_acc_pkt_err()
@@ -5813,6 +5788,7 @@ rw_error:
 }
 #endif
 
+#if 0
 /**
 * \fn int ResetAccPktErr()
 * \brief Reset Accumulating packet error count.
@@ -5823,7 +5799,6 @@ rw_error:
 */
 static int ctrl_set_cfg_reset_pkt_err(struct drx_demod_instance *demod)
 {
-#ifdef DRXJ_SIGNAL_ACCUM_ERR
 	struct drxj_data *ext_attr = NULL;
 	int rc;
 	u16 packet_error = 0;
@@ -5839,7 +5814,6 @@ static int ctrl_set_cfg_reset_pkt_err(struct drx_demod_instance *demod)
 
 	return 0;
 rw_error:
-#endif
 	return -EIO;
 }
 
@@ -5937,6 +5911,7 @@ static int get_ctl_freq_offset(struct drx_demod_instance *demod, s32 *ctl_freq)
 rw_error:
 	return -EIO;
 }
+#endif
 
 /*============================================================================*/
 
@@ -6145,7 +6120,7 @@ set_agc_rf(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings,
 		ext_attr->qam_rf_agc_cfg = *agc_settings;
 		break;
 #endif
-#ifndef DRXJ_DIGITAL_ONLY
+#if 0
 	case DRX_STANDARD_PAL_SECAM_BG:
 	case DRX_STANDARD_PAL_SECAM_DK:
 	case DRX_STANDARD_PAL_SECAM_I:
@@ -6165,6 +6140,7 @@ rw_error:
 	return -EIO;
 }
 
+#if 0
 /**
 * \fn int get_agc_rf ()
 * \brief get configuration of RF AGC
@@ -6196,7 +6172,7 @@ get_agc_rf(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings)
 		*agc_settings = ext_attr->qam_rf_agc_cfg;
 		break;
 #endif
-#ifndef DRXJ_DIGITAL_ONLY
+#if 0
 	case DRX_STANDARD_PAL_SECAM_BG:
 	case DRX_STANDARD_PAL_SECAM_DK:
 	case DRX_STANDARD_PAL_SECAM_I:
@@ -6229,6 +6205,7 @@ get_agc_rf(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings)
 rw_error:
 	return -EIO;
 }
+#endif
 
 /**
 * \fn int set_agc_if ()
@@ -6450,7 +6427,7 @@ set_agc_if(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings,
 		ext_attr->qam_if_agc_cfg = *agc_settings;
 		break;
 #endif
-#ifndef DRXJ_DIGITAL_ONLY
+#if 0
 	case DRX_STANDARD_PAL_SECAM_BG:
 	case DRX_STANDARD_PAL_SECAM_DK:
 	case DRX_STANDARD_PAL_SECAM_I:
@@ -6470,6 +6447,7 @@ rw_error:
 	return -EIO;
 }
 
+#if 0
 /**
 * \fn int get_agc_if ()
 * \brief get configuration of If AGC
@@ -6501,7 +6479,6 @@ get_agc_if(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings)
 		*agc_settings = ext_attr->qam_if_agc_cfg;
 		break;
 #endif
-#ifndef DRXJ_DIGITAL_ONLY
 	case DRX_STANDARD_PAL_SECAM_BG:
 	case DRX_STANDARD_PAL_SECAM_DK:
 	case DRX_STANDARD_PAL_SECAM_I:
@@ -6511,7 +6488,6 @@ get_agc_if(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings)
 	case DRX_STANDARD_FM:
 		*agc_settings = ext_attr->atv_if_agc_cfg;
 		break;
-#endif
 	default:
 		return -EIO;
 	}
@@ -6535,6 +6511,7 @@ get_agc_if(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_settings)
 rw_error:
 	return -EIO;
 }
+#endif
 
 /**
 * \fn int set_iqm_af ()
@@ -7518,6 +7495,7 @@ rw_error:
 	return -EIO;
 }
 
+#if 0
 /**
 * \fn static short get_vsb_symb_err(struct i2c_device_addr *dev_addr, u32 *ber)
 * \brief Get the values of ber in VSB mode
@@ -7555,6 +7533,7 @@ static int get_vsb_symb_err(struct i2c_device_addr *dev_addr, u32 *ser)
 rw_error:
 	return -EIO;
 }
+#endif
 
 /**
 * \fn static int get_vsbmer(struct i2c_device_addr *dev_addr, u16 *mer)
@@ -7579,6 +7558,7 @@ rw_error:
 	return -EIO;
 }
 
+#if 0
 /*============================================================================*/
 /**
 * \fn int ctrl_get_vsb_constel()
@@ -7659,6 +7639,7 @@ ctrl_get_vsb_constel(struct drx_demod_instance *demod, struct drx_complex *compl
 rw_error:
 	return -EIO;
 }
+#endif
 
 /*============================================================================*/
 /*==                     END 8VSB DATAPATH FUNCTIONS                        ==*/
@@ -10870,6 +10851,7 @@ rw_error:
 	return -EIO;
 }
 
+#if 0
 /**
 * \fn int ctrl_get_qam_constel()
 * \brief Retreive a QAM constellation point via I2C.
@@ -10974,6 +10956,7 @@ ctrl_get_qam_constel(struct drx_demod_instance *demod, struct drx_complex *compl
 rw_error:
 	return -EIO;
 }
+#endif /* #if 0 */
 #endif /* #ifndef DRXJ_VSB_ONLY */
 
 /*============================================================================*/
@@ -11042,6 +11025,7 @@ rw_error:
 */
 /* -------------------------------------------------------------------------- */
 
+#if 0
 /**
 * \brief Get array index for atv coef (ext_attr->atvTopCoefX[index])
 * \param standard
@@ -11297,7 +11281,6 @@ rw_error:
 }
 
 /* -------------------------------------------------------------------------- */
-#ifndef DRXJ_DIGITAL_ONLY
 /**
 * \fn int ctrl_set_cfg_atv_equ_coef()
 * \brief Set ATV equalizer coefficients
@@ -11687,7 +11670,7 @@ static int power_up_atv(struct drx_demod_instance *demod, enum drx_standard stan
 rw_error:
 	return -EIO;
 }
-#endif /* #ifndef DRXJ_DIGITAL_ONLY */
+#endif
 
 /* -------------------------------------------------------------------------- */
 
@@ -11802,7 +11785,7 @@ rw_error:
 * Assuming that IQM, ATV and AUD blocks have been reset and are in STOP mode
 *
 */
-#ifndef DRXJ_DIGITAL_ONLY
+#if 0
 #define SCU_RAM_ATV_ENABLE_IIR_WA__A 0x831F6D	/* TODO remove after done with reg import */
 static int
 set_atv_standard(struct drx_demod_instance *demod, enum drx_standard *standard)
@@ -12861,11 +12844,9 @@ trouble ?
 rw_error:
 	return -EIO;
 }
-#endif
 
 /* -------------------------------------------------------------------------- */
 
-#ifndef DRXJ_DIGITAL_ONLY
 /**
 * \fn int set_atv_channel ()
 * \brief Set ATV channel.
@@ -12939,7 +12920,6 @@ set_atv_channel(struct drx_demod_instance *demod,
 rw_error:
 	return -EIO;
 }
-#endif
 
 /* -------------------------------------------------------------------------- */
 
@@ -12956,7 +12936,6 @@ rw_error:
 * channel->frequency. Determines the value for channel->bandwidth.
 *
 */
-#ifndef DRXJ_DIGITAL_ONLY
 static int
 get_atv_channel(struct drx_demod_instance *demod,
 		struct drx_channel *channel, enum drx_standard standard)
@@ -13213,13 +13192,11 @@ atv_sig_quality(struct drx_demod_instance *demod, struct drx_sig_quality *sig_qu
 rw_error:
 	return -EIO;
 }
-#endif /* DRXJ_DIGITAL_ONLY */
 
 /*============================================================================*/
 /*==                     END ATV DATAPATH FUNCTIONS                         ==*/
 /*============================================================================*/
 
-#ifndef DRXJ_EXCLUDE_AUDIO
 /*===========================================================================*/
 /*===========================================================================*/
 /*==                      AUDIO DATAPATH FUNCTIONS                         ==*/
@@ -13269,6 +13246,7 @@ static int power_up_aud(struct drx_demod_instance *demod, bool set_standard)
 rw_error:
 	return -EIO;
 }
+#endif
 
 /*============================================================================*/
 
@@ -13300,6 +13278,7 @@ rw_error:
 	return -EIO;
 }
 
+#if 0
 /*============================================================================*/
 /**
 * \brief Get Modus data from audio RAM
@@ -15785,8 +15764,6 @@ rw_error:
 	return -EIO;
 }
 
-#endif
-
 /*===========================================================================*/
 /*==                    END AUDIO DATAPATH FUNCTIONS                       ==*/
 /*===========================================================================*/
@@ -15796,7 +15773,6 @@ rw_error:
 /*==                       OOB DATAPATH FUNCTIONS                           ==*/
 /*============================================================================*/
 /*============================================================================*/
-#ifndef DRXJ_DIGITAL_ONLY
 /**
 * \fn int get_oob_lock_status ()
 * \brief Get OOB lock status.
@@ -16254,7 +16230,7 @@ static int get_oobmer(struct i2c_device_addr *dev_addr, u32 *mer)
 rw_error:
 	return -EIO;
 }
-#endif /*#ifndef DRXJ_DIGITAL_ONLY */
+#endif
 
 /**
 * \fn int set_orx_nsu_aox()
@@ -16314,9 +16290,9 @@ rw_error:
 /* Coefficients for the nyquist fitler (total: 27 taps) */
 #define NYQFILTERLEN 27
 
+#if 0
 static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_param)
 {
-#ifndef DRXJ_DIGITAL_ONLY
 	int rc;
 	s32 freq = 0;	/* KHz */
 	struct i2c_device_addr *dev_addr = NULL;
@@ -16812,7 +16788,6 @@ static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_par
 
 	return 0;
 rw_error:
-#endif
 	return -EIO;
 }
 
@@ -16826,7 +16801,6 @@ rw_error:
 static int
 ctrl_get_oob(struct drx_demod_instance *demod, struct drxoob_status *oob_status)
 {
-#ifndef DRXJ_DIGITAL_ONLY
 	int rc;
 	struct i2c_device_addr *dev_addr = NULL;
 	struct drxj_data *ext_attr = NULL;
@@ -16891,7 +16865,6 @@ ctrl_get_oob(struct drx_demod_instance *demod, struct drxoob_status *oob_status)
 
 	return 0;
 rw_error:
-#endif
 	return -EIO;
 }
 
@@ -16901,7 +16874,6 @@ rw_error:
 * \param cfg_data Pointer to configuration parameter
 * \return Error code
 */
-#ifndef DRXJ_DIGITAL_ONLY
 static int
 ctrl_set_cfg_oob_pre_saw(struct drx_demod_instance *demod, u16 *cfg_data)
 {
@@ -16925,7 +16897,6 @@ ctrl_set_cfg_oob_pre_saw(struct drx_demod_instance *demod, u16 *cfg_data)
 rw_error:
 	return -EIO;
 }
-#endif
 
 /**
 * \fn int ctrl_get_cfg_oob_pre_saw()
@@ -16933,7 +16904,6 @@ rw_error:
 * \param cfg_data Pointer to configuration parameter
 * \return Error code
 */
-#ifndef DRXJ_DIGITAL_ONLY
 static int
 ctrl_get_cfg_oob_pre_saw(struct drx_demod_instance *demod, u16 *cfg_data)
 {
@@ -16948,14 +16918,12 @@ ctrl_get_cfg_oob_pre_saw(struct drx_demod_instance *demod, u16 *cfg_data)
 
 	return 0;
 }
-#endif
 
 /**
 * \fn int ctrl_set_cfg_oob_lo_power()
 * \brief Configure LO Power value
 * \param cfg_data Pointer to enum drxj_cfg_oob_lo_power ** \return Error code
 */
-#ifndef DRXJ_DIGITAL_ONLY
 static int
 ctrl_set_cfg_oob_lo_power(struct drx_demod_instance *demod, enum drxj_cfg_oob_lo_power *cfg_data)
 {
@@ -16979,14 +16947,12 @@ ctrl_set_cfg_oob_lo_power(struct drx_demod_instance *demod, enum drxj_cfg_oob_lo
 rw_error:
 	return -EIO;
 }
-#endif
 
 /**
 * \fn int ctrl_get_cfg_oob_lo_power()
 * \brief Configure LO Power value
 * \param cfg_data Pointer to enum drxj_cfg_oob_lo_power ** \return Error code
 */
-#ifndef DRXJ_DIGITAL_ONLY
 static int
 ctrl_get_cfg_oob_lo_power(struct drx_demod_instance *demod, enum drxj_cfg_oob_lo_power *cfg_data)
 {
@@ -17061,7 +17027,7 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 	case DRX_STANDARD_ITU_B:
 	case DRX_STANDARD_ITU_C:
 #endif /* DRXJ_VSB_ONLY */
-#ifndef DRXJ_DIGITAL_ONLY
+#if 0
 	case DRX_STANDARD_NTSC:
 	case DRX_STANDARD_FM:
 	case DRX_STANDARD_PAL_SECAM_BG:
@@ -17069,7 +17035,7 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 	case DRX_STANDARD_PAL_SECAM_I:
 	case DRX_STANDARD_PAL_SECAM_L:
 	case DRX_STANDARD_PAL_SECAM_LP:
-#endif /* DRXJ_DIGITAL_ONLY */
+#endif
 		break;
 	case DRX_STANDARD_UNKNOWN:
 	default:
@@ -17091,7 +17057,7 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 			return -EINVAL;
 		}
 	}
-#ifndef DRXJ_DIGITAL_ONLY
+#if 0
 	if (standard == DRX_STANDARD_PAL_SECAM_BG) {
 		switch (channel->bandwidth) {
 		case DRX_BANDWIDTH_7MHZ:	/* fall through */
@@ -17248,7 +17214,7 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 	if (demod->my_tuner != NULL) {
 		/* Determine tuner mode and freq to tune to ... */
 		switch (standard) {
-#ifndef DRXJ_DIGITAL_ONLY
+#if 0
 		case DRX_STANDARD_NTSC:	/* fallthrough */
 		case DRX_STANDARD_PAL_SECAM_BG:	/* fallthrough */
 		case DRX_STANDARD_PAL_SECAM_DK:	/* fallthrough */
@@ -17365,7 +17331,7 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 			goto rw_error;
 		}
 		break;
-#ifndef DRXJ_DIGITAL_ONLY
+#if 0
 	case DRX_STANDARD_NTSC:	/* fallthrough */
 	case DRX_STANDARD_FM:	/* fallthrough */
 	case DRX_STANDARD_PAL_SECAM_BG:	/* fallthrough */
@@ -17442,6 +17408,7 @@ rw_error:
 	return -EIO;
 }
 
+#if 0
 /*=============================================================================
   ===== ctrl_get_channel() ==========================================================
   ===========================================================================*/
@@ -17646,7 +17613,6 @@ ctrl_get_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 			}
 			break;
 #endif
-#ifndef DRXJ_DIGITAL_ONLY
 		case DRX_STANDARD_NTSC:	/* fall trough */
 		case DRX_STANDARD_PAL_SECAM_BG:
 		case DRX_STANDARD_PAL_SECAM_DK:
@@ -17660,7 +17626,6 @@ ctrl_get_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 				goto rw_error;
 			}
 			break;
-#endif
 		case DRX_STANDARD_UNKNOWN:	/* fall trough */
 		default:
 			return -EIO;
@@ -17674,6 +17639,7 @@ ctrl_get_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 rw_error:
 	return -EIO;
 }
+#endif
 
 /*=============================================================================
   ===== SigQuality() ==========================================================
@@ -17839,7 +17805,7 @@ ctrl_sig_quality(struct drx_demod_instance *demod, struct drx_sig_quality *sig_q
 				  max_mer);
 		break;
 #endif
-#ifndef DRXJ_DIGITAL_ONLY
+#if 0
 	case DRX_STANDARD_PAL_SECAM_BG:
 	case DRX_STANDARD_PAL_SECAM_DK:
 	case DRX_STANDARD_PAL_SECAM_I:
@@ -17920,7 +17886,7 @@ ctrl_lock_status(struct drx_demod_instance *demod, enum drx_lock_status *lock_st
 		    SCU_RAM_COMMAND_CMD_DEMOD_GET_LOCK;
 		break;
 #endif
-#ifndef DRXJ_DIGITAL_ONLY
+#if 0
 	case DRX_STANDARD_NTSC:
 	case DRX_STANDARD_PAL_SECAM_BG:
 	case DRX_STANDARD_PAL_SECAM_DK:
@@ -17972,6 +17938,7 @@ rw_error:
 
 /*============================================================================*/
 
+#if 0
 /**
 * \fn int ctrl_constel()
 * \brief Retreive a constellation point via I2C.
@@ -18023,6 +17990,7 @@ ctrl_constel(struct drx_demod_instance *demod, struct drx_complex *complex_nr)
 rw_error:
 	return -EIO;
 }
+#endif
 
 /*============================================================================*/
 
@@ -18072,7 +18040,7 @@ ctrl_set_standard(struct drx_demod_instance *demod, enum drx_standard *standard)
 			goto rw_error;
 		}
 		break;
-#ifndef DRXJ_DIGITAL_ONLY
+#if 0
 	case DRX_STANDARD_NTSC:	/* fallthrough */
 	case DRX_STANDARD_FM:	/* fallthrough */
 	case DRX_STANDARD_PAL_SECAM_BG:	/* fallthrough */
@@ -18123,7 +18091,7 @@ ctrl_set_standard(struct drx_demod_instance *demod, enum drx_standard *standard)
 			goto rw_error;
 		}
 		break;
-#ifndef DRXJ_DIGITAL_ONLY
+#if 0
 	case DRX_STANDARD_NTSC:	/* fallthrough */
 	case DRX_STANDARD_FM:	/* fallthrough */
 	case DRX_STANDARD_PAL_SECAM_BG:	/* fallthrough */
@@ -18156,6 +18124,7 @@ rw_error:
 	return -EIO;
 }
 
+#if 0
 /*============================================================================*/
 
 /**
@@ -18239,6 +18208,7 @@ ctrl_get_cfg_symbol_clock_offset(struct drx_demod_instance *demod, s32 *rate_off
 rw_error:
 	return -EIO;
 }
+#endif
 
 /*============================================================================*/
 
@@ -18300,7 +18270,7 @@ static void drxj_reset_mode(struct drxj_data *ext_attr)
 	ext_attr->vsb_pre_saw_cfg.reference = 0x07;
 	ext_attr->vsb_pre_saw_cfg.use_pre_saw = true;
 
-#ifndef DRXJ_DIGITAL_ONLY
+#if 0
 	/* Initialize default AFE configuartion for ATV */
 	ext_attr->atv_rf_agc_cfg.standard = DRX_STANDARD_NTSC;
 	ext_attr->atv_rf_agc_cfg.ctrl_mode = DRX_AGC_CTRL_AUTO;
@@ -18469,191 +18439,7 @@ rw_error:
 	return -EIO;
 }
 
-/*============================================================================*/
-
-/**
-* \fn int ctrl_version()
-* \brief Report version of microcode and if possible version of device
-* \param demod Pointer to demodulator instance.
-* \param version_list Pointer to pointer of linked list of versions.
-* \return int.
-*
-* Using static structures so no allocation of memory is needed.
-* Filling in all the fields each time, cause you don't know if they are
-* changed by the application.
-*
-* For device:
-* Major version number will be last two digits of family number.
-* Minor number will be full respin number
-* Patch will be metal fix number+1
-* Examples:
-* DRX3942J A2 => number: 42.1.2 text: "DRX3942J:A2"
-* DRX3933J B1 => number: 33.2.1 text: "DRX3933J:B1"
-*
-*/
-static int
-ctrl_version(struct drx_demod_instance *demod, struct drx_version_list **version_list)
-{
-	struct drxj_data *ext_attr = (struct drxj_data *) (NULL);
-	struct i2c_device_addr *dev_addr = (struct i2c_device_addr *)(NULL);
-	struct drx_common_attr *common_attr = (struct drx_common_attr *) (NULL);
-	int rc;
-	u16 ucode_major_minor = 0;	/* BCD Ma:Ma:Ma:Mi */
-	u16 ucode_patch = 0;	/* BCD Pa:Pa:Pa:Pa */
-	u16 major = 0;
-	u16 minor = 0;
-	u16 patch = 0;
-	u16 idx = 0;
-	u32 jtag = 0;
-	u16 subtype = 0;
-	u16 mfx = 0;
-	u16 bid = 0;
-	u16 key = 0;
-	static char ucode_name[] = "Microcode";
-	static char device_name[] = "Device";
-
-	dev_addr = demod->my_i2c_dev_addr;
-	ext_attr = (struct drxj_data *) demod->my_ext_attr;
-	common_attr = (struct drx_common_attr *) demod->my_common_attr;
-
-	/* Microcode version *************************************** */
-
-	ext_attr->v_version[0].module_type = DRX_MODULE_MICROCODE;
-	ext_attr->v_version[0].module_name = ucode_name;
-	ext_attr->v_version[0].v_string = ext_attr->v_text[0];
-
-	if (common_attr->is_opened == true) {
-		rc = drxj_dap_scu_atomic_read_reg16(dev_addr, SCU_RAM_VERSION_HI__A, &ucode_major_minor, 0);
-		if (rc != 0) {
-			pr_err("error %d\n", rc);
-			goto rw_error;
-		}
-		rc = drxj_dap_scu_atomic_read_reg16(dev_addr, SCU_RAM_VERSION_LO__A, &ucode_patch, 0);
-		if (rc != 0) {
-			pr_err("error %d\n", rc);
-			goto rw_error;
-		}
-
-		/* Translate BCD to numbers and string */
-		/* TODO: The most significant Ma and Pa will be ignored, check with spec */
-		minor = (ucode_major_minor & 0xF);
-		ucode_major_minor >>= 4;
-		major = (ucode_major_minor & 0xF);
-		ucode_major_minor >>= 4;
-		major += (10 * (ucode_major_minor & 0xF));
-		patch = (ucode_patch & 0xF);
-		ucode_patch >>= 4;
-		patch += (10 * (ucode_patch & 0xF));
-		ucode_patch >>= 4;
-		patch += (100 * (ucode_patch & 0xF));
-	} else {
-		/* No microcode uploaded, No Rom existed, set version to 0.0.0 */
-		patch = 0;
-		minor = 0;
-		major = 0;
-	}
-	ext_attr->v_version[0].v_major = major;
-	ext_attr->v_version[0].v_minor = minor;
-	ext_attr->v_version[0].v_patch = patch;
-
-	if (major / 10 != 0) {
-		ext_attr->v_version[0].v_string[idx++] =
-		    ((char)(major / 10)) + '0';
-		major %= 10;
-	}
-	ext_attr->v_version[0].v_string[idx++] = ((char)major) + '0';
-	ext_attr->v_version[0].v_string[idx++] = '.';
-	ext_attr->v_version[0].v_string[idx++] = ((char)minor) + '0';
-	ext_attr->v_version[0].v_string[idx++] = '.';
-	if (patch / 100 != 0) {
-		ext_attr->v_version[0].v_string[idx++] =
-		    ((char)(patch / 100)) + '0';
-		patch %= 100;
-	}
-	if (patch / 10 != 0) {
-		ext_attr->v_version[0].v_string[idx++] =
-		    ((char)(patch / 10)) + '0';
-		patch %= 10;
-	}
-	ext_attr->v_version[0].v_string[idx++] = ((char)patch) + '0';
-	ext_attr->v_version[0].v_string[idx] = '\0';
-
-	ext_attr->v_list_elements[0].version = &(ext_attr->v_version[0]);
-	ext_attr->v_list_elements[0].next = &(ext_attr->v_list_elements[1]);
-
-	/* Device version *************************************** */
-	/* Check device id */
-	rc = DRXJ_DAP.read_reg16func(dev_addr, SIO_TOP_COMM_KEY__A, &key, 0);
-	if (rc != 0) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
-	}
-	rc = DRXJ_DAP.write_reg16func(dev_addr, SIO_TOP_COMM_KEY__A, 0xFABA, 0);
-	if (rc != 0) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
-	}
-	rc = DRXJ_DAP.read_reg32func(dev_addr, SIO_TOP_JTAGID_LO__A, &jtag, 0);
-	if (rc != 0) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
-	}
-	rc = DRXJ_DAP.read_reg16func(dev_addr, SIO_PDR_UIO_IN_HI__A, &bid, 0);
-	if (rc != 0) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
-	}
-	rc = DRXJ_DAP.write_reg16func(dev_addr, SIO_TOP_COMM_KEY__A, key, 0);
-	if (rc != 0) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
-	}
-
-	ext_attr->v_version[1].module_type = DRX_MODULE_DEVICE;
-	ext_attr->v_version[1].module_name = device_name;
-	ext_attr->v_version[1].v_string = ext_attr->v_text[1];
-	ext_attr->v_version[1].v_string[0] = 'D';
-	ext_attr->v_version[1].v_string[1] = 'R';
-	ext_attr->v_version[1].v_string[2] = 'X';
-	ext_attr->v_version[1].v_string[3] = '3';
-	ext_attr->v_version[1].v_string[4] = '9';
-	ext_attr->v_version[1].v_string[7] = 'J';
-	ext_attr->v_version[1].v_string[8] = ':';
-	ext_attr->v_version[1].v_string[11] = '\0';
-
-	/* DRX39xxJ type Ax */
-	/* TODO semantics of mfx and spin are unclear */
-	subtype = (u16) ((jtag >> 12) & 0xFF);
-	mfx = (u16) (jtag >> 29);
-	ext_attr->v_version[1].v_minor = 1;
-	if (mfx == 0x03)
-		ext_attr->v_version[1].v_patch = mfx + 2;
-	else
-		ext_attr->v_version[1].v_patch = mfx + 1;
-	ext_attr->v_version[1].v_string[6] = ((char)(subtype & 0xF)) + '0';
-	ext_attr->v_version[1].v_major = (subtype & 0x0F);
-	subtype >>= 4;
-	ext_attr->v_version[1].v_string[5] = ((char)(subtype & 0xF)) + '0';
-	ext_attr->v_version[1].v_major += 10 * subtype;
-	ext_attr->v_version[1].v_string[9] = 'A';
-	if (mfx == 0x03)
-		ext_attr->v_version[1].v_string[10] = ((char)(mfx & 0xF)) + '2';
-	else
-		ext_attr->v_version[1].v_string[10] = ((char)(mfx & 0xF)) + '1';
-
-	ext_attr->v_list_elements[1].version = &(ext_attr->v_version[1]);
-	ext_attr->v_list_elements[1].next = (struct drx_version_list *) (NULL);
-
-	*version_list = &(ext_attr->v_list_elements[0]);
-
-	return 0;
-
-rw_error:
-	*version_list = (struct drx_version_list *) (NULL);
-	return -EIO;
-
-}
-
+#if 0
 /*============================================================================*/
 
 /**
@@ -18761,11 +18547,13 @@ rw_error:
 	common_attr->current_power_mode = org_power_mode;
 	return -EIO;
 }
+#endif
 
 /*============================================================================*/
 /*== CTRL Set/Get Config related functions ===================================*/
 /*============================================================================*/
 
+#if 0
 /*===== SigStrength() =========================================================*/
 /**
 * \fn int ctrl_sig_strength()
@@ -18807,7 +18595,6 @@ ctrl_sig_strength(struct drx_demod_instance *demod, u16 *sig_strength)
 			goto rw_error;
 		}
 		break;
-#ifndef DRXJ_DIGITAL_ONLY
 	case DRX_STANDARD_PAL_SECAM_BG:	/* fallthrough */
 	case DRX_STANDARD_PAL_SECAM_DK:	/* fallthrough */
 	case DRX_STANDARD_PAL_SECAM_I:	/* fallthrough */
@@ -18821,7 +18608,6 @@ ctrl_sig_strength(struct drx_demod_instance *demod, u16 *sig_strength)
 			goto rw_error;
 		}
 		break;
-#endif
 	case DRX_STANDARD_UNKNOWN:	/* fallthrough */
 	default:
 		return -EINVAL;
@@ -18842,7 +18628,6 @@ rw_error:
 * \return int.
 *
 */
-#ifndef DRXJ_DIGITAL_ONLY
 static int
 ctrl_get_cfg_oob_misc(struct drx_demod_instance *demod, struct drxj_cfg_oob_misc *misc)
 {
@@ -18907,7 +18692,6 @@ ctrl_get_cfg_oob_misc(struct drx_demod_instance *demod, struct drxj_cfg_oob_misc
 rw_error:
 	return -EIO;
 }
-#endif
 
 /**
 * \fn int ctrl_get_cfg_vsb_misc()
@@ -18976,7 +18760,7 @@ ctrl_set_cfg_agc_if(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_s
 	case DRX_STANDARD_ITU_B:	/* fallthrough */
 	case DRX_STANDARD_ITU_C:
 #endif
-#ifndef DRXJ_DIGITAL_ONLY
+#if 0
 	case DRX_STANDARD_PAL_SECAM_BG:	/* fallthrough */
 	case DRX_STANDARD_PAL_SECAM_DK:	/* fallthrough */
 	case DRX_STANDARD_PAL_SECAM_I:	/* fallthrough */
@@ -19022,7 +18806,7 @@ ctrl_get_cfg_agc_if(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_s
 	case DRX_STANDARD_ITU_B:	/* fallthrough */
 	case DRX_STANDARD_ITU_C:
 #endif
-#ifndef DRXJ_DIGITAL_ONLY
+#if 0
 	case DRX_STANDARD_PAL_SECAM_BG:	/* fallthrough */
 	case DRX_STANDARD_PAL_SECAM_DK:	/* fallthrough */
 	case DRX_STANDARD_PAL_SECAM_I:	/* fallthrough */
@@ -19077,7 +18861,6 @@ ctrl_set_cfg_agc_rf(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_s
 	case DRX_STANDARD_ITU_B:	/* fallthrough */
 	case DRX_STANDARD_ITU_C:
 #endif
-#ifndef DRXJ_DIGITAL_ONLY
 	case DRX_STANDARD_PAL_SECAM_BG:	/* fallthrough */
 	case DRX_STANDARD_PAL_SECAM_DK:	/* fallthrough */
 	case DRX_STANDARD_PAL_SECAM_I:	/* fallthrough */
@@ -19085,7 +18868,6 @@ ctrl_set_cfg_agc_rf(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_s
 	case DRX_STANDARD_PAL_SECAM_LP:	/* fallthrough */
 	case DRX_STANDARD_NTSC:	/* fallthrough */
 	case DRX_STANDARD_FM:
-#endif
 		return set_agc_rf(demod, agc_settings, true);
 	case DRX_STANDARD_UNKNOWN:
 	default:
@@ -19123,7 +18905,6 @@ ctrl_get_cfg_agc_rf(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_s
 	case DRX_STANDARD_ITU_B:	/* fallthrough */
 	case DRX_STANDARD_ITU_C:
 #endif
-#ifndef DRXJ_DIGITAL_ONLY
 	case DRX_STANDARD_PAL_SECAM_BG:	/* fallthrough */
 	case DRX_STANDARD_PAL_SECAM_DK:	/* fallthrough */
 	case DRX_STANDARD_PAL_SECAM_I:	/* fallthrough */
@@ -19131,7 +18912,6 @@ ctrl_get_cfg_agc_rf(struct drx_demod_instance *demod, struct drxj_cfg_agc *agc_s
 	case DRX_STANDARD_PAL_SECAM_LP:	/* fallthrough */
 	case DRX_STANDARD_NTSC:	/* fallthrough */
 	case DRX_STANDARD_FM:
-#endif
 		return get_agc_rf(demod, agc_settings);
 	case DRX_STANDARD_UNKNOWN:
 	default:
@@ -19241,6 +19021,7 @@ rw_error:
 }
 
 /*============================================================================*/
+#endif
 
 /**
 * \fn int ctrl_set_cfg_pre_saw()
@@ -19294,7 +19075,7 @@ ctrl_set_cfg_pre_saw(struct drx_demod_instance *demod, struct drxj_cfg_pre_saw *
 		ext_attr->qam_pre_saw_cfg = *pre_saw;
 		break;
 #endif
-#ifndef DRXJ_DIGITAL_ONLY
+#if 0
 	case DRX_STANDARD_PAL_SECAM_BG:	/* fallthrough */
 	case DRX_STANDARD_PAL_SECAM_DK:	/* fallthrough */
 	case DRX_STANDARD_PAL_SECAM_I:	/* fallthrough */
@@ -19397,6 +19178,7 @@ rw_error:
 
 /*============================================================================*/
 
+#if 0
 /**
 * \fn int ctrl_get_cfg_pre_saw()
 * \brief Get Pre-saw reference setting.
@@ -19430,7 +19212,6 @@ ctrl_get_cfg_pre_saw(struct drx_demod_instance *demod, struct drxj_cfg_pre_saw *
 		*pre_saw = ext_attr->qam_pre_saw_cfg;
 		break;
 #endif
-#ifndef DRXJ_DIGITAL_ONLY
 	case DRX_STANDARD_PAL_SECAM_BG:	/* fallthrough */
 	case DRX_STANDARD_PAL_SECAM_DK:	/* fallthrough */
 	case DRX_STANDARD_PAL_SECAM_I:	/* fallthrough */
@@ -19444,7 +19225,7 @@ ctrl_get_cfg_pre_saw(struct drx_demod_instance *demod, struct drxj_cfg_pre_saw *
 		ext_attr->atv_pre_saw_cfg.standard = DRX_STANDARD_FM;
 		*pre_saw = ext_attr->atv_pre_saw_cfg;
 		break;
-#endif
+
 	default:
 		return -EINVAL;
 	}
@@ -19603,7 +19384,7 @@ static int ctrl_set_cfg(struct drx_demod_instance *demod, struct drx_cfg *config
 								cfg_data));
 	case DRXJ_CFG_RESET_PACKET_ERR:
 		return ctrl_set_cfg_reset_pkt_err(demod);
-#ifndef DRXJ_DIGITAL_ONLY
+#if 0
 	case DRXJ_CFG_OOB_PRE_SAW:
 		return ctrl_set_cfg_oob_pre_saw(demod, (u16 *)(config->cfg_data));
 	case DRXJ_CFG_OOB_LO_POW:
@@ -19726,7 +19507,7 @@ static int ctrl_get_cfg(struct drx_demod_instance *demod, struct drx_cfg *config
 	case DRXJ_CFG_SYMBOL_CLK_OFFSET:
 		return ctrl_get_cfg_symbol_clock_offset(demod,
 						   (s32 *)config->cfg_data);
-#ifndef DRXJ_DIGITAL_ONLY
+#if 0
 	case DRXJ_CFG_OOB_MISC:
 		return ctrl_get_cfg_oob_misc(demod,
 					 (struct drxj_cfg_oob_misc *) config->cfg_data);
@@ -19809,6 +19590,7 @@ static int ctrl_get_cfg(struct drx_demod_instance *demod, struct drx_cfg *config
 rw_error:
 	return -EIO;
 }
+#endif
 
 /*=============================================================================
 ===== EXPORTED FUNCTIONS ====================================================*/
-- 
1.8.5.3

