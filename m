Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39183 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbbJJNgQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 09:36:16 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 03/26] [media] DocBook: convert struct tuner_parms to doc-nano format
Date: Sat, 10 Oct 2015 10:35:46 -0300
Message-Id: <65fc64090ed3dc750d40474b07a6f8ad734440cc.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The struct tuner_params is almost fully documented, but
using a non-standard way. Convert it to doc-nano format,
and add descriptions for the parameters that aren't
documented yet.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/tuner-types.h b/include/media/tuner-types.h
index ab03c5344209..011b4a20ee22 100644
--- a/include/media/tuner-types.h
+++ b/include/media/tuner-types.h
@@ -19,91 +19,119 @@ struct tuner_range {
 	unsigned char cb;
 };
 
+/**
+ * struct tuner_params - Parameters to be used to setup the tuner. Those
+ *			 are used by drivers/media/tuners/tuner-types.c in
+ *			 order to specify the tuner properties. Most of
+ *			 the parameters are for tuners based on tda9887 IF-PLL
+ *			 multi-standard analog TV/Radio demodulator, with is
+ *			 very common on legacy analog tuners.
+ *
+ * @type:			Type of the tuner parameters, as defined at
+ *				enum param_type. If the tuner supports multiple
+ *				standards, an array should be used, with one
+ *				row per different standard.
+ * @cb_first_if_lower_freq:	Many Philips-based tuners have a comment in
+ *				their datasheet like
+ *				"For channel selection involving band
+ *				switching, and to ensure smooth tuning to the
+ *				desired channel without causing unnecessary
+ *				charge pump action, it is recommended to
+ *				consider the difference between wanted channel
+ *				frequency and the current channel frequency.
+ *				Unnecessary charge pump action will result
+ *				in very low tuning voltage which may drive the
+ *				oscillator to extreme conditions".
+ *				Set cb_first_if_lower_freq to 1, if this check
+ *				is required for this tuner. I tested this for
+ *				PAL by first setting the TV frequency to
+ *				203 MHz and then switching to 96.6 MHz FM
+ *				radio. The result was static unless the
+ *				control byte was sent first.
+ * @has_tda9887:		Set to 1 if this tuner uses a tda9887
+ * @port1_fm_high_sensitivity:	Many Philips tuners use tda9887 PORT1 to select
+ *				the FM radio sensitivity. If this setting is 1,
+ *				then set PORT1 to 1 to get proper FM reception.
+ * @port2_fm_high_sensitivity:	Some Philips tuners use tda9887 PORT2 to select
+ *				the FM radio sensitivity. If this setting is 1,
+ *				then set PORT2 to 1 to get proper FM reception.
+ * @fm_gain_normal:		Some Philips tuners use tda9887 cGainNormal to
+ *				select the FM radio sensitivity. If this
+ *				setting is 1, e register will use cGainNormal
+ *				instead of cGainLow.
+ * @intercarrier_mode:		Most tuners with a tda9887 use QSS mode.
+ *				Some (cheaper) tuners use Intercarrier mode.
+ *				If this setting is 1, then the tuner needs to
+ *				be set to intercarrier mode.
+ * @port1_active:		This setting sets the default value for PORT1.
+ *				0 means inactive, 1 means active. Note: the
+ *				actual bit value written to the tda9887 is
+ *				inverted. So a 0 here means a 1 in the B6 bit.
+ * @port2_active:		This setting sets the default value for PORT2.
+ *				0 means inactive, 1 means active. Note: the
+ *				actual bit value written to the tda9887 is
+ *				inverted. So a 0 here means a 1 in the B7 bit.
+ * @port1_invert_for_secam_lc:	Sometimes PORT1 is inverted when the SECAM-L'
+ *				standard is selected. Set this bit to 1 if this
+ *				is needed.
+ * @port2_invert_for_secam_lc:	Sometimes PORT2 is inverted when the SECAM-L'
+ *				standard is selected. Set this bit to 1 if this
+ *				is needed.
+ * @port1_set_for_fm_mono:	Some cards require PORT1 to be 1 for mono Radio
+ *				FM and 0 for stereo.
+ * @default_pll_gating_18:	Select 18% (or according to datasheet 0%)
+ *				L standard PLL gating, vs the driver default
+ *				of 36%.
+ * @radio_if:			IF to use in radio mode.  Tuners with a
+ *				separate radio IF filter seem to use 10.7,
+ *				while those without use 33.3 for PAL/SECAM
+ *				tuners and 41.3 for NTSC tuners.
+ *				0 = 10.7, 1 = 33.3, 2 = 41.3
+ * @default_top_low:		Default tda9887 TOP value in dB for the low
+ *				band. Default is 0. Range: -16:+15
+ * @default_top_mid:		Default tda9887 TOP value in dB for the mid
+ *				band. Default is 0. Range: -16:+15
+ * @default_top_high:		Default tda9887 TOP value in dB for the high
+ *				band. Default is 0. Range: -16:+15
+ * @default_top_secam_low:	Default tda9887 TOP value in dB for SECAM-L/L'
+ *				for the low band. Default is 0. Several tuners
+ *				require a different TOP value for the
+ *				SECAM-L/L' standards. Range: -16:+15
+ * @default_top_secam_mid:	Default tda9887 TOP value in dB for SECAM-L/L'
+ *				for the mid band. Default is 0. Several tuners
+ *				require a different TOP value for the
+ *				SECAM-L/L' standards. Range: -16:+15
+ * @default_top_secam_high:	Default tda9887 TOP value in dB for SECAM-L/L'
+ *				for the high band. Default is 0. Several tuners
+ *				require a different TOP value for the
+ *				SECAM-L/L' standards. Range: -16:+15
+ * @iffreq:			Intermediate frequency (IF) used by the tuner
+ *				on digital mode.
+ * @count:			Size of the ranges array.
+ * @ranges:			Array with the frequency ranges supported by
+ *				the tuner.
+ */
 struct tuner_params {
 	enum param_type type;
 
-	/* Many Philips based tuners have a comment like this in their
-	 * datasheet:
-	 *
-	 *   For channel selection involving band switching, and to ensure
-	 *   smooth tuning to the desired channel without causing
-	 *   unnecessary charge pump action, it is recommended to consider
-	 *   the difference between wanted channel frequency and the
-	 *   current channel frequency.  Unnecessary charge pump action
-	 *   will result in very low tuning voltage which may drive the
-	 *   oscillator to extreme conditions.
-	 *
-	 * Set cb_first_if_lower_freq to 1, if this check is
-	 * required for this tuner.
-	 *
-	 * I tested this for PAL by first setting the TV frequency to
-	 * 203 MHz and then switching to 96.6 MHz FM radio. The result was
-	 * static unless the control byte was sent first.
-	 */
 	unsigned int cb_first_if_lower_freq:1;
-	/* Set to 1 if this tuner uses a tda9887 */
 	unsigned int has_tda9887:1;
-	/* Many Philips tuners use tda9887 PORT1 to select the FM radio
-	   sensitivity. If this setting is 1, then set PORT1 to 1 to
-	   get proper FM reception. */
 	unsigned int port1_fm_high_sensitivity:1;
-	/* Some Philips tuners use tda9887 PORT2 to select the FM radio
-	   sensitivity. If this setting is 1, then set PORT2 to 1 to
-	   get proper FM reception. */
 	unsigned int port2_fm_high_sensitivity:1;
-	/* Some Philips tuners use tda9887 cGainNormal to select the FM radio
-	   sensitivity. If this setting is 1, e register will use cGainNormal
-	   instead of cGainLow. */
 	unsigned int fm_gain_normal:1;
-	/* Most tuners with a tda9887 use QSS mode. Some (cheaper) tuners
-	   use Intercarrier mode. If this setting is 1, then the tuner
-	   needs to be set to intercarrier mode. */
 	unsigned int intercarrier_mode:1;
-	/* This setting sets the default value for PORT1.
-	   0 means inactive, 1 means active. Note: the actual bit
-	   value written to the tda9887 is inverted. So a 0 here
-	   means a 1 in the B6 bit. */
 	unsigned int port1_active:1;
-	/* This setting sets the default value for PORT2.
-	   0 means inactive, 1 means active. Note: the actual bit
-	   value written to the tda9887 is inverted. So a 0 here
-	   means a 1 in the B7 bit. */
 	unsigned int port2_active:1;
-	/* Sometimes PORT1 is inverted when the SECAM-L' standard is selected.
-	   Set this bit to 1 if this is needed. */
 	unsigned int port1_invert_for_secam_lc:1;
-	/* Sometimes PORT2 is inverted when the SECAM-L' standard is selected.
-	   Set this bit to 1 if this is needed. */
 	unsigned int port2_invert_for_secam_lc:1;
-	/* Some cards require PORT1 to be 1 for mono Radio FM and 0 for stereo. */
 	unsigned int port1_set_for_fm_mono:1;
-	/* Select 18% (or according to datasheet 0%) L standard PLL gating,
-	   vs the driver default of 36%. */
 	unsigned int default_pll_gating_18:1;
-	/* IF to use in radio mode.  Tuners with a separate radio IF filter
-	   seem to use 10.7, while those without use 33.3 for PAL/SECAM tuners
-	   and 41.3 for NTSC tuners. 0 = 10.7, 1 = 33.3, 2 = 41.3 */
 	unsigned int radio_if:2;
-	/* Default tda9887 TOP value in dB for the low band. Default is 0.
-	   Range: -16:+15 */
 	signed int default_top_low:5;
-	/* Default tda9887 TOP value in dB for the mid band. Default is 0.
-	   Range: -16:+15 */
 	signed int default_top_mid:5;
-	/* Default tda9887 TOP value in dB for the high band. Default is 0.
-	   Range: -16:+15 */
 	signed int default_top_high:5;
-	/* Default tda9887 TOP value in dB for SECAM-L/L' for the low band.
-	   Default is 0. Several tuners require a different TOP value for
-	   the SECAM-L/L' standards. Range: -16:+15 */
 	signed int default_top_secam_low:5;
-	/* Default tda9887 TOP value in dB for SECAM-L/L' for the mid band.
-	   Default is 0. Several tuners require a different TOP value for
-	   the SECAM-L/L' standards. Range: -16:+15 */
 	signed int default_top_secam_mid:5;
-	/* Default tda9887 TOP value in dB for SECAM-L/L' for the high band.
-	   Default is 0. Several tuners require a different TOP value for
-	   the SECAM-L/L' standards. Range: -16:+15 */
 	signed int default_top_secam_high:5;
 
 	u16 iffreq;
-- 
2.4.3


