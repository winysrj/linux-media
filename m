Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39622 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbaGDRRH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jul 2014 13:17:07 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [[PATCH v2] 08/14] dib0700: better document struct init
Date: Fri,  4 Jul 2014 14:15:34 -0300
Message-Id: <1404494140-17777-9-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1404494140-17777-1-git-send-email-m.chehab@samsung.com>
References: <1404494140-17777-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using anonymous initialization for dib0896 structs,
identify each field by name. That helps to understand what's
being initialized.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/dvb-usb/dib0700_devices.c | 148 +++++++++++++++-------------
 1 file changed, 81 insertions(+), 67 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index d067bb77534f..501947eaacfe 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -1412,99 +1412,113 @@ static int stk807xpvr_frontend_attach1(struct dvb_usb_adapter *adap)
 /* STK8096GP */
 static struct dibx000_agc_config dib8090_agc_config[2] = {
 	{
-	BAND_UHF | BAND_VHF | BAND_LBAND | BAND_SBAND,
+	.band_caps = BAND_UHF | BAND_VHF | BAND_LBAND | BAND_SBAND,
 	/* P_agc_use_sd_mod1=0, P_agc_use_sd_mod2=0, P_agc_freq_pwm_div=1,
 	 * P_agc_inv_pwm1=0, P_agc_inv_pwm2=0, P_agc_inh_dc_rv_est=0,
 	 * P_agc_time_est=3, P_agc_freeze=0, P_agc_nb_est=5, P_agc_write=0 */
-	(0 << 15) | (0 << 14) | (5 << 11) | (0 << 10) | (0 << 9) | (0 << 8)
+	.setup = (0 << 15) | (0 << 14) | (5 << 11) | (0 << 10) | (0 << 9) | (0 << 8)
 	| (3 << 5) | (0 << 4) | (5 << 1) | (0 << 0),
 
-	787,
-	10,
+	.inv_gain = 787,
+	.time_stabiliz = 10,
 
-	0,
-	118,
+	.alpha_level = 0,
+	.thlock = 118,
 
-	0,
-	3530,
-	1,
-	5,
+	.wbd_inv = 0,
+	.wbd_ref = 3530,
+	.wbd_sel = 1,
+	.wbd_alpha = 5,
 
-	65535,
-	0,
+	.agc1_max = 65535,
+	.agc1_min = 0,
 
-	65535,
-	0,
-
-	0,
-	32,
-	114,
-	143,
-	144,
-	114,
-	227,
-	116,
-	117,
-
-	28,
-	26,
-	31,
-	51,
+	.agc2_max = 65535,
+	.agc2_min = 0,
 
-	0,
+	.agc1_pt1 = 0,
+	.agc1_pt2 = 32,
+	.agc1_pt3 = 114,
+	.agc1_slope1 = 143,
+	.agc1_slope2 = 144,
+	.agc2_pt1 = 114,
+	.agc2_pt2 = 227,
+	.agc2_slope1 = 116,
+	.agc2_slope2 = 117,
+
+	.alpha_mant = 28,
+	.alpha_exp = 26,
+	.beta_mant = 31,
+	.beta_exp = 51,
+
+	.perform_agc_softsplit = 0,
 	},
 	{
-	BAND_CBAND,
+	.band_caps = BAND_CBAND,
 	/* P_agc_use_sd_mod1=0, P_agc_use_sd_mod2=0, P_agc_freq_pwm_div=1,
 	 * P_agc_inv_pwm1=0, P_agc_inv_pwm2=0, P_agc_inh_dc_rv_est=0,
 	 * P_agc_time_est=3, P_agc_freeze=0, P_agc_nb_est=5, P_agc_write=0 */
-	(0 << 15) | (0 << 14) | (5 << 11) | (0 << 10) | (0 << 9) | (0 << 8)
+	.setup = (0 << 15) | (0 << 14) | (5 << 11) | (0 << 10) | (0 << 9) | (0 << 8)
 	| (3 << 5) | (0 << 4) | (5 << 1) | (0 << 0),
 
-	787,
-	10,
+	.inv_gain = 787,
+	.time_stabiliz = 10,
 
-	0,
-	118,
+	.alpha_level = 0,
+	.thlock = 118,
 
-	0,
-	3530,
-	1,
-	5,
-
-	0,
-	0,
-
-	65535,
-	0,
+	.wbd_inv = 0,
+	.wbd_ref = 3530,
+	.wbd_sel = 1,
+	.wbd_alpha = 5,
 
-	0,
-	32,
-	114,
-	143,
-	144,
-	114,
-	227,
-	116,
-	117,
+	.agc1_max = 0,
+	.agc1_min = 0,
 
-	28,
-	26,
-	31,
-	51,
+	.agc2_max = 65535,
+	.agc2_min = 0,
 
-	0,
+	.agc1_pt1 = 0,
+	.agc1_pt2 = 32,
+	.agc1_pt3 = 114,
+	.agc1_slope1 = 143,
+	.agc1_slope2 = 144,
+	.agc2_pt1 = 114,
+	.agc2_pt2 = 227,
+	.agc2_slope1 = 116,
+	.agc2_slope2 = 117,
+
+	.alpha_mant = 28,
+	.alpha_exp = 26,
+	.beta_mant = 31,
+	.beta_exp = 51,
+
+	.perform_agc_softsplit = 0,
 	}
 };
 
 static struct dibx000_bandwidth_config dib8090_pll_config_12mhz = {
-	54000, 13500,
-	1, 18, 3, 1, 0,
-	0, 0, 1, 1, 2,
-	(3 << 14) | (1 << 12) | (599 << 0),
-	(0 << 25) | 0,
-	20199727,
-	12000000,
+	.internal = 54000,
+	.sampling = 13500,
+
+	.pll_prediv = 1,
+	.pll_ratio = 18,
+	.pll_range = 3,
+	.pll_reset = 1,
+	.pll_bypass = 0,
+
+	.enable_refdiv = 0,
+	.bypclk_div = 0,
+	.IO_CLK_en_core = 1,
+	.ADClkSrc = 1,
+	.modulo = 2,
+
+	.sad_cfg = (3 << 14) | (1 << 12) | (599 << 0),
+
+	.ifreq = (0 << 25) | 0,
+	.timf = 20199727,
+
+	.xtal_hz = 12000000,
 };
 
 static int dib8090_get_adc_power(struct dvb_frontend *fe)
-- 
1.9.3

