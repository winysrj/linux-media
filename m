Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42691 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbaIVWCY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 18:02:24 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	=?UTF-8?q?=5C=22David=20H=C3=A4rdeman=5C=22?= <david@hardeman.nu>,
	James Harper <james.harper@ejbdigital.com.au>
Subject: [PATCH] [media] dib0700_devices: Use c99 initializers for structures.
Date: Mon, 22 Sep 2014 19:02:09 -0300
Message-Id: <09628b2c2105722e61b8c799531304a1cd317b2e.1411423318.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@decl@
identifier i1,fld;
type T;
field list[n] fs;
@@

struct i1 {
 fs
 T fld;
 ...};

@bad@
identifier decl.i1,i2;
expression e;
initializer list[decl.n] is;
@@

struct i1 i2 = { is,
+ .fld = e
- e
 ,...};
// </smpl>

Not sure why, but some tables are still using the old way,
but at least several of them got fixed.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index ce47d3f1c850..e1757b8f5f5d 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -220,12 +220,21 @@ static struct dibx000_agc_config stk7700d_7000p_mt2266_agc_config[2] = {
 };
 
 static struct dibx000_bandwidth_config stk7700d_mt2266_pll_config = {
-	60000, 30000,
-	1, 8, 3, 1, 0,
-	0, 0, 1, 1, 2,
-	(3 << 14) | (1 << 12) | (524 << 0),
-	0,
-	20452225,
+	.internal = 60000,
+	.sampling = 30000,
+	.pll_prediv = 1,
+	.pll_ratio = 8,
+	.pll_range = 3,
+	.pll_reset = 1,
+	.pll_bypass = 0,
+	.enable_refdiv = 0,
+	.bypclk_div = 0,
+	.IO_CLK_en_core = 1,
+	.ADClkSrc = 1,
+	.modulo = 2,
+	.sad_cfg = (3 << 14) | (1 << 12) | (524 << 0),
+	.ifreq = 0,
+	.timf = 20452225,
 };
 
 static struct dib7000p_config stk7700d_dib7000p_mt2266_config[] = {
@@ -342,57 +351,57 @@ static int stk7700d_tuner_attach(struct dvb_usb_adapter *adap)
 
 /* STK7700-PH: Digital/Analog Hybrid Tuner, e.h. Cinergy HT USB HE */
 static struct dibx000_agc_config xc3028_agc_config = {
-	BAND_VHF | BAND_UHF,       /* band_caps */
-
+	.band_caps = BAND_VHF | BAND_UHF,
 	/* P_agc_use_sd_mod1=0, P_agc_use_sd_mod2=0, P_agc_freq_pwm_div=0,
 	 * P_agc_inv_pwm1=0, P_agc_inv_pwm2=0, P_agc_inh_dc_rv_est=0,
 	 * P_agc_time_est=3, P_agc_freeze=0, P_agc_nb_est=2, P_agc_write=0 */
-	(0 << 15) | (0 << 14) | (0 << 11) | (0 << 10) | (0 << 9) | (0 << 8) |
-	(3 << 5) | (0 << 4) | (2 << 1) | (0 << 0), /* setup */
-
-	712,	/* inv_gain */
-	21,	/* time_stabiliz */
-
-	0,	/* alpha_level */
-	118,	/* thlock */
-
-	0,	/* wbd_inv */
-	2867,	/* wbd_ref */
-	0,	/* wbd_sel */
-	2,	/* wbd_alpha */
-
-	0,	/* agc1_max */
-	0,	/* agc1_min */
-	39718,	/* agc2_max */
-	9930,	/* agc2_min */
-	0,	/* agc1_pt1 */
-	0,	/* agc1_pt2 */
-	0,	/* agc1_pt3 */
-	0,	/* agc1_slope1 */
-	0,	/* agc1_slope2 */
-	0,	/* agc2_pt1 */
-	128,	/* agc2_pt2 */
-	29,	/* agc2_slope1 */
-	29,	/* agc2_slope2 */
-
-	17,	/* alpha_mant */
-	27,	/* alpha_exp */
-	23,	/* beta_mant */
-	51,	/* beta_exp */
-
-	1,	/* perform_agc_softsplit */
+	.setup = (0 << 15) | (0 << 14) | (0 << 11) | (0 << 10) | (0 << 9) | (0 << 8) | (3 << 5) | (0 << 4) | (2 << 1) | (0 << 0),
+	.inv_gain = 712,
+	.time_stabiliz = 21,
+	.alpha_level = 0,
+	.thlock = 118,
+	.wbd_inv = 0,
+	.wbd_ref = 2867,
+	.wbd_sel = 0,
+	.wbd_alpha = 2,
+	.agc1_max = 0,
+	.agc1_min = 0,
+	.agc2_max = 39718,
+	.agc2_min = 9930,
+	.agc1_pt1 = 0,
+	.agc1_pt2 = 0,
+	.agc1_pt3 = 0,
+	.agc1_slope1 = 0,
+	.agc1_slope2 = 0,
+	.agc2_pt1 = 0,
+	.agc2_pt2 = 128,
+	.agc2_slope1 = 29,
+	.agc2_slope2 = 29,
+	.alpha_mant = 17,
+	.alpha_exp = 27,
+	.beta_mant = 23,
+	.beta_exp = 51,
+	.perform_agc_softsplit = 1,
 };
 
 /* PLL Configuration for COFDM BW_MHz = 8.00 with external clock = 30.00 */
 static struct dibx000_bandwidth_config xc3028_bw_config = {
-	60000, 30000, /* internal, sampling */
-	1, 8, 3, 1, 0, /* pll_cfg: prediv, ratio, range, reset, bypass */
-	0, 0, 1, 1, 0, /* misc: refdiv, bypclk_div, IO_CLK_en_core, ADClkSrc,
-			  modulo */
-	(3 << 14) | (1 << 12) | (524 << 0), /* sad_cfg: refsel, sel, freq_15k */
-	(1 << 25) | 5816102, /* ifreq = 5.200000 MHz */
-	20452225, /* timf */
-	30000000, /* xtal_hz */
+	.internal = 60000,
+	.sampling = 30000,
+	.pll_prediv = 1,
+	.pll_ratio = 8,
+	.pll_range = 3,
+	.pll_reset = 1,
+	.pll_bypass = 0,
+	.enable_refdiv = 0,
+	.bypclk_div = 0,
+	.IO_CLK_en_core = 1,
+	.ADClkSrc = 1,
+	.modulo = 0,
+	.sad_cfg = (3 << 14) | (1 << 12) | (524 << 0), /* sad_cfg: refsel, sel, freq_15k */
+	.ifreq = (1 << 25) | 5816102,  /* ifreq = 5.200000 MHz */
+	.timf = 20452225,
+	.xtal_hz = 30000000,
 };
 
 static struct dib7000p_config stk7700ph_dib7700_xc3028_config = {
@@ -614,59 +623,55 @@ static struct dibx000_agc_config stk7700p_7000m_mt2060_agc_config = {
 };
 
 static struct dibx000_agc_config stk7700p_7000p_mt2060_agc_config = {
-	BAND_UHF | BAND_VHF,
-
+	.band_caps = BAND_UHF | BAND_VHF,
 	/* P_agc_use_sd_mod1=0, P_agc_use_sd_mod2=0, P_agc_freq_pwm_div=5, P_agc_inv_pwm1=0, P_agc_inv_pwm2=0,
 	 * P_agc_inh_dc_rv_est=0, P_agc_time_est=3, P_agc_freeze=0, P_agc_nb_est=2, P_agc_write=0 */
-	(0 << 15) | (0 << 14) | (5 << 11) | (0 << 10) | (0 << 9) | (0 << 8)
-	| (3 << 5) | (0 << 4) | (2 << 1) | (0 << 0),
-
-	712,
-	41,
-
-	0,
-	118,
-
-	0,
-	4095,
-	0,
-	0,
-
-	42598,
-	16384,
-	42598,
-	    0,
-
-	  0,
-	137,
-	255,
-
-	  0,
-	255,
-
-	0,
-	0,
-
-	 0,
-	41,
-
-	15,
-	25,
-
-	28,
-	48,
-
-	0,
+	.setup = (0 << 15) | (0 << 14) | (5 << 11) | (0 << 10) | (0 << 9) | (0 << 8) | (3 << 5) | (0 << 4) | (2 << 1) | (0 << 0),
+	.inv_gain = 712,
+	.time_stabiliz = 41,
+	.alpha_level = 0,
+	.thlock = 118,
+	.wbd_inv = 0,
+	.wbd_ref = 4095,
+	.wbd_sel = 0,
+	.wbd_alpha = 0,
+	.agc1_max = 42598,
+	.agc1_min = 16384,
+	.agc2_max = 42598,
+	.agc2_min = 0,
+	.agc1_pt1 = 0,
+	.agc1_pt2 = 137,
+	.agc1_pt3 = 255,
+	.agc1_slope1 = 0,
+	.agc1_slope2 = 255,
+	.agc2_pt1 = 0,
+	.agc2_pt2 = 0,
+	.agc2_slope1 = 0,
+	.agc2_slope2 = 41,
+	.alpha_mant = 15,
+	.alpha_exp = 25,
+	.beta_mant = 28,
+	.beta_exp = 48,
+	.perform_agc_softsplit = 0,
 };
 
 static struct dibx000_bandwidth_config stk7700p_pll_config = {
-	60000, 30000,
-	1, 8, 3, 1, 0,
-	0, 0, 1, 1, 0,
-	(3 << 14) | (1 << 12) | (524 << 0),
-	60258167,
-	20452225,
-	30000000,
+	.internal = 60000,
+	.sampling = 30000,
+	.pll_prediv = 1,
+	.pll_ratio = 8,
+	.pll_range = 3,
+	.pll_reset = 1,
+	.pll_bypass = 0,
+	.enable_refdiv = 0,
+	.bypclk_div = 0,
+	.IO_CLK_en_core = 1,
+	.ADClkSrc = 1,
+	.modulo = 0,
+	.sad_cfg = (3 << 14) | (1 << 12) | (524 << 0),
+	.ifreq = 60258167,
+	.timf = 20452225,
+	.xtal_hz = 30000000,
 };
 
 static struct dib7000m_config stk7700p_dib7000m_config = {
@@ -758,45 +763,36 @@ static int stk7700p_tuner_attach(struct dvb_usb_adapter *adap)
 
 /* DIB7070 generic */
 static struct dibx000_agc_config dib7070_agc_config = {
-	BAND_UHF | BAND_VHF | BAND_LBAND | BAND_SBAND,
+	.band_caps = BAND_UHF | BAND_VHF | BAND_LBAND | BAND_SBAND,
 	/* P_agc_use_sd_mod1=0, P_agc_use_sd_mod2=0, P_agc_freq_pwm_div=5, P_agc_inv_pwm1=0, P_agc_inv_pwm2=0,
 	 * P_agc_inh_dc_rv_est=0, P_agc_time_est=3, P_agc_freeze=0, P_agc_nb_est=5, P_agc_write=0 */
-	(0 << 15) | (0 << 14) | (5 << 11) | (0 << 10) | (0 << 9) | (0 << 8)
-	| (3 << 5) | (0 << 4) | (5 << 1) | (0 << 0),
-
-	600,
-	10,
-
-	0,
-	118,
-
-	0,
-	3530,
-	1,
-	5,
-
-	65535,
-		0,
-
-	65535,
-	0,
-
-	0,
-	40,
-	183,
-	206,
-	255,
-	72,
-	152,
-	88,
-	90,
-
-	17,
-	27,
-	23,
-	51,
-
-	0,
+	.setup = (0 << 15) | (0 << 14) | (5 << 11) | (0 << 10) | (0 << 9) | (0 << 8) | (3 << 5) | (0 << 4) | (5 << 1) | (0 << 0),
+	.inv_gain = 600,
+	.time_stabiliz = 10,
+	.alpha_level = 0,
+	.thlock = 118,
+	.wbd_inv = 0,
+	.wbd_ref = 3530,
+	.wbd_sel = 1,
+	.wbd_alpha = 5,
+	.agc1_max = 65535,
+	.agc1_min = 0,
+	.agc2_max = 65535,
+	.agc2_min = 0,
+	.agc1_pt1 = 0,
+	.agc1_pt2 = 40,
+	.agc1_pt3 = 183,
+	.agc1_slope1 = 206,
+	.agc1_slope2 = 255,
+	.agc2_pt1 = 72,
+	.agc2_pt2 = 152,
+	.agc2_slope1 = 88,
+	.agc2_slope2 = 90,
+	.alpha_mant = 17,
+	.alpha_exp = 27,
+	.beta_mant = 23,
+	.beta_exp = 51,
+	.perform_agc_softsplit = 0,
 };
 
 static int dib7070_tuner_reset(struct dvb_frontend *fe, int onoff)
@@ -952,13 +948,22 @@ static int stk70x0p_pid_filter_ctrl(struct dvb_usb_adapter *adapter, int onoff)
 }
 
 static struct dibx000_bandwidth_config dib7070_bw_config_12_mhz = {
-	60000, 15000,
-	1, 20, 3, 1, 0,
-	0, 0, 1, 1, 2,
-	(3 << 14) | (1 << 12) | (524 << 0),
-	(0 << 25) | 0,
-	20452225,
-	12000000,
+	.internal = 60000,
+	.sampling = 15000,
+	.pll_prediv = 1,
+	.pll_ratio = 20,
+	.pll_range = 3,
+	.pll_reset = 1,
+	.pll_bypass = 0,
+	.enable_refdiv = 0,
+	.bypclk_div = 0,
+	.IO_CLK_en_core = 1,
+	.ADClkSrc = 1,
+	.modulo = 2,
+	.sad_cfg = (3 << 14) | (1 << 12) | (524 << 0),
+	.ifreq = (0 << 25) | 0,
+	.timf = 20452225,
+	.xtal_hz = 12000000,
 };
 
 static struct dib7000p_config dib7070p_dib7000p_config = {
@@ -1169,14 +1174,22 @@ static struct dibx000_agc_config dib807x_agc_config[2] = {
 };
 
 static struct dibx000_bandwidth_config dib807x_bw_config_12_mhz = {
-	60000, 15000, /* internal, sampling*/
-	1, 20, 3, 1, 0, /* pll_cfg: prediv, ratio, range, reset, bypass*/
-	0, 0, 1, 1, 2, /* misc: refdiv, bypclk_div, IO_CLK_en_core,
-			  ADClkSrc, modulo */
-	(3 << 14) | (1 << 12) | (599 << 0), /* sad_cfg: refsel, sel, freq_15k*/
-	(0 << 25) | 0, /* ifreq = 0.000000 MHz*/
-	18179755, /* timf*/
-	12000000, /* xtal_hz*/
+	.internal = 60000,
+	.sampling = 15000,
+	.pll_prediv = 1,
+	.pll_ratio = 20,
+	.pll_range = 3,
+	.pll_reset = 1,
+	.pll_bypass = 0,
+	.enable_refdiv = 0,
+	.bypclk_div = 0,
+	.IO_CLK_en_core = 1,
+	.ADClkSrc = 1,
+	.modulo = 2,
+	.sad_cfg = (3 << 14) | (1 << 12) | (599 << 0),	/* sad_cfg: refsel, sel, freq_15k*/
+	.ifreq = (0 << 25) | 0,				/* ifreq = 0.000000 MHz*/
+	.timf = 18179755,
+	.xtal_hz = 12000000,
 };
 
 static struct dib8000_config dib807x_dib8000_config[2] = {
@@ -1921,13 +1934,22 @@ static struct dibx000_agc_config dib8096p_agc_config[2] = {
 };
 
 static struct dibx000_bandwidth_config dib8096p_clock_config_12_mhz = {
-	108000, 13500,
-	1, 9, 1, 0, 0,
-	0, 0, 0, 0, 2,
-	(3 << 14) | (1 << 12) | (524 << 0),
-	(0 << 25) | 0,
-	20199729,
-	12000000,
+	.internal = 108000,
+	.sampling = 13500,
+	.pll_prediv = 1,
+	.pll_ratio = 9,
+	.pll_range = 1,
+	.pll_reset = 0,
+	.pll_bypass = 0,
+	.enable_refdiv = 0,
+	.bypclk_div = 0,
+	.IO_CLK_en_core = 0,
+	.ADClkSrc = 0,
+	.modulo = 2,
+	.sad_cfg = (3 << 14) | (1 << 12) | (524 << 0),
+	.ifreq = (0 << 25) | 0,
+	.timf = 20199729,
+	.xtal_hz = 12000000,
 };
 
 static struct dib8000_config tfe8096p_dib8000_config = {
@@ -2724,13 +2746,22 @@ static struct dibx000_agc_config dib7090_agc_config[2] = {
 };
 
 static struct dibx000_bandwidth_config dib7090_clock_config_12_mhz = {
-	60000, 15000,
-	1, 5, 0, 0, 0,
-	0, 0, 1, 1, 2,
-	(3 << 14) | (1 << 12) | (524 << 0),
-	(0 << 25) | 0,
-	20452225,
-	15000000,
+	.internal = 60000,
+	.sampling = 15000,
+	.pll_prediv = 1,
+	.pll_ratio = 5,
+	.pll_range = 0,
+	.pll_reset = 0,
+	.pll_bypass = 0,
+	.enable_refdiv = 0,
+	.bypclk_div = 0,
+	.IO_CLK_en_core = 1,
+	.ADClkSrc = 1,
+	.modulo = 2,
+	.sad_cfg = (3 << 14) | (1 << 12) | (524 << 0),
+	.ifreq = (0 << 25) | 0,
+	.timf = 20452225,
+	.xtal_hz = 15000000,
 };
 
 static struct dib7000p_config nim7090_dib7000p_config = {
@@ -3498,14 +3529,22 @@ static struct dibx000_agc_config stk7700p_7000p_xc4000_agc_config = {
 };
 
 static struct dibx000_bandwidth_config stk7700p_xc4000_pll_config = {
-	60000, 30000,	/* internal, sampling */
-	1, 8, 3, 1, 0,	/* pll_cfg: prediv, ratio, range, reset, bypass */
-	0, 0, 1, 1, 0,	/* misc: refdiv, bypclk_div, IO_CLK_en_core, */
-			/* ADClkSrc, modulo */
-	(3 << 14) | (1 << 12) | 524,	/* sad_cfg: refsel, sel, freq_15k */
-	39370534,	/* ifreq */
-	20452225,	/* timf */
-	30000000	/* xtal */
+	.internal = 60000,
+	.sampling = 30000,
+	.pll_prediv = 1,
+	.pll_ratio = 8,
+	.pll_range = 3,
+	.pll_reset = 1,
+	.pll_bypass = 0,
+	.enable_refdiv = 0,
+	.bypclk_div = 0,
+	.IO_CLK_en_core = 1,
+	.ADClkSrc = 1,
+	.modulo = 0,
+	.sad_cfg = (3 << 14) | (1 << 12) | 524, /* sad_cfg: refsel, sel, freq_15k */
+	.ifreq = 39370534,
+	.timf = 20452225,
+	.xtal_hz = 30000000
 };
 
 /* FIXME: none of these inputs are validated yet */
-- 
1.9.3

