Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.bendigoit.com.au ([203.16.224.4]:45749 "EHLO
	smtp1.bendigoit.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932878AbaFLKMh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 06:12:37 -0400
Received: from [203.193.205.129] (helo=server.meadowcourt.local)
	by smtp1.bendigoit.com.au with esmtp (Exim 4.80)
	(envelope-from <root@meadowcourt.org>)
	id 1Wv203-00024B-SC
	for linux-media@vger.kernel.org; Thu, 12 Jun 2014 20:12:52 +1000
Received: from root by server.meadowcourt.local with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <root@meadowcourt.org>)
	id 1Wv1zm-0001SD-Rm
	for linux-media@vger.kernel.org; Thu, 12 Jun 2014 20:12:34 +1000
From: James Harper <james.harper@ejbdigital.com.au>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] Add support for DViCO FusionHDTV DVB-T Dual Express2
Date: Thu, 12 Jun 2014 20:12:24 +1000
Message-Id: <1402567944-5550-1-git-send-email-james.harper@ejbdigital.com.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DViCO FusionHDTV DVB-T Dual Express2 is cx23885 + dib7070

Signed-off-by: James Harper <james.harper@ejbdigital.com.au>
---
 drivers/media/pci/cx23885/cx23885-cards.c |  15 +++-
 drivers/media/pci/cx23885/cx23885-dvb.c   | 123 ++++++++++++++++++++++++++++++
 drivers/media/pci/cx23885/cx23885.h       |   1 +
 3 files changed, 138 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index 79f20c8..9ca8855 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -649,7 +649,12 @@ struct cx23885_board cx23885_boards[] = {
 				  CX25840_NONE1_CH3,
 			.amux   = CX25840_AUDIO6,
 		} },
-	}
+	},
+	[CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP2] = {
+		.name		= "DViCO FusionHDTV DVB-T Dual Express2",
+		.portb		= CX23885_MPEG_DVB,
+		.portc		= CX23885_MPEG_DVB,
+	},
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
 
@@ -897,6 +902,10 @@ struct cx23885_subid cx23885_subids[] = {
 		.subvendor = 0x1461,
 		.subdevice = 0xd939,
 		.card      = CX23885_BOARD_AVERMEDIA_HC81R,
+	}, {
+		.subvendor = 0x18ac,
+		.subdevice = 0xdb98,
+		.card      = CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP2,
 	},
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -1137,6 +1146,7 @@ int cx23885_tuner_callback(void *priv, int component, int command, int arg)
 		break;
 	case CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP:
 	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
+	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP2:
 		/* Two identical tuners on two different i2c buses,
 		 * we need to reset the correct gpio. */
 		if (port->nr == 1)
@@ -1280,6 +1290,7 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
 		cx_set(GP0_IO, 0x000f000f);
 		break;
 	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
+	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP2:
 		/* GPIO-0 portb xc3028 reset */
 		/* GPIO-1 portb zl10353 reset */
 		/* GPIO-2 portc xc3028 reset */
@@ -1585,6 +1596,7 @@ int cx23885_ir_init(struct cx23885_dev *dev)
 				 ir_rxtx_pin_cfg_count, ir_rxtx_pin_cfg);
 		break;
 	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
+	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP2:
 		request_module("ir-kbd-i2c");
 		break;
 	}
@@ -1720,6 +1732,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 		break;
 	case CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP:
 	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
+	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP2:
 		ts2->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
 		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
 		ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index d037459..5c627e6 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -44,6 +44,7 @@
 #include "tuner-xc2028.h"
 #include "tuner-simple.h"
 #include "dib7000p.h"
+#include "dib0070.h"
 #include "dibx000_common.h"
 #include "zl10353.h"
 #include "stv0900.h"
@@ -746,6 +747,104 @@ static int netup_altera_fpga_rw(void *device, int flag, int data, int read)
 	return 0;
 };
 
+static int dib7070_tuner_reset(struct dvb_frontend *fe, int onoff) {
+	struct dib7000p_ops *dib7000p_ops = fe->sec_priv;
+	return dib7000p_ops->set_gpio(fe, 8, 0, !onoff);
+}
+
+static int
+dib7070_tuner_sleep(struct dvb_frontend *fe, int onoff) {
+	return 0;
+}
+
+static struct dib0070_config dib7070p_dib0070_config = {
+	.i2c_address = DEFAULT_DIB0070_I2C_ADDRESS,
+	.reset = dib7070_tuner_reset,
+	.sleep = dib7070_tuner_sleep,
+	.clock_khz = 12000,
+	.freq_offset_khz_vhf = 950,
+	.freq_offset_khz_vhf = 550,
+	//.flip_chip = 1,
+};
+
+/* DIB7070 generic */
+static struct dibx000_agc_config dib7070_agc_config = {
+	.band_caps = BAND_UHF | BAND_VHF | BAND_LBAND | BAND_SBAND,
+
+	/*
+	 * P_agc_use_sd_mod1=0, P_agc_use_sd_mod2=0, P_agc_freq_pwm_div=5,
+	 * P_agc_inv_pwm1=0, P_agc_inv_pwm2=0, P_agc_inh_dc_rv_est=0,
+	 * P_agc_time_est=3, P_agc_freeze=0, P_agc_nb_est=5, P_agc_write=0
+	 */
+	.setup = (0 << 15) | (0 << 14) | (5 << 11) | (0 << 10) | (0 << 9) |
+		 (0 << 8) | (3 << 5) | (0 << 4) | (5 << 1) | (0 << 0),
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
+};
+
+static struct dibx000_bandwidth_config dib7070_bw_config_12_mhz = {
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
+	/* refsel, sel, freq_15k */
+	.sad_cfg = (3 << 14) | (1 << 12) | (524 << 0),
+	.ifreq = (0 << 25) | 0,
+	.timf = 20452225,
+	.xtal_hz = 12000000,
+};
+
+static struct dib7000p_config dib7070p_dib7000p_config = {
+	//.output_mode = OUTMODE_MPEG2_FIFO,
+	.output_mode = OUTMODE_MPEG2_SERIAL,
+	//.output_mode = OUTMODE_MPEG2_PAR_GATED_CLK,
+	.output_mpeg2_in_188_bytes = 1,
+
+	.agc_config_count = 1,
+	.agc = &dib7070_agc_config,
+	.bw  = &dib7070_bw_config_12_mhz,
+	.tuner_is_baseband = 1,
+	.spur_protect = 1,
+
+	.gpio_dir = 0xfcef, //DIB7000P_GPIO_DEFAULT_DIRECTIONS,
+	.gpio_val = 0x0110, //DIB7000P_GPIO_DEFAULT_VALUES,
+	.gpio_pwm_pos = DIB7000P_GPIO_DEFAULT_PWM_POS,
+
+	.hostbus_diversity = 1,
+};
+
 static int dvb_register(struct cx23885_tsport *port)
 {
 	struct dib7000p_ops dib7000p_ops;
@@ -993,6 +1092,30 @@ static int dvb_register(struct cx23885_tsport *port)
 		}
 		break;
 	}
+	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP2: {
+		i2c_bus = &dev->i2c_bus[port->nr - 1];
+		//cxusb_ctrl_msg(adap->dev, CMD_DIGITAL, NULL, 0, NULL, 0);
+		//cxusb_bluebird_gpio_pulse(adap->dev, 0x02, 1);
+
+		if (!dvb_attach(dib7000p_attach, &dib7000p_ops))
+			return -ENODEV;
+
+		if (dib7000p_ops.i2c_enumeration(&i2c_bus->i2c_adap, 1, 0x12, &dib7070p_dib7000p_config) < 0) {
+			printk(KERN_WARNING "Unable to enumerate dib7000p\n");
+			return -ENODEV;
+		}
+		fe0->dvb.frontend = dib7000p_ops.init(&i2c_bus->i2c_adap, 0x80, &dib7070p_dib7000p_config);
+		if (fe0->dvb.frontend != NULL) {
+			struct i2c_adapter *tun_i2c;
+			fe0->dvb.frontend->sec_priv = kmalloc(sizeof(dib7000p_ops), GFP_KERNEL);
+			memcpy(fe0->dvb.frontend->sec_priv, &dib7000p_ops, sizeof(dib7000p_ops));
+			tun_i2c = dib7000p_ops.get_i2c_master(fe0->dvb.frontend, DIBX000_I2C_INTERFACE_TUNER, 1);
+			if (!dvb_attach(dib0070_attach, fe0->dvb.frontend, tun_i2c, &dib7070p_dib0070_config)) {
+				return -ENODEV;
+			}
+		}
+		break;
+	}
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index 0fa4048..8eb7330 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -96,6 +96,7 @@
 #define CX23885_BOARD_TBS_6981                 40
 #define CX23885_BOARD_TBS_6980                 41
 #define CX23885_BOARD_LEADTEK_WINFAST_PXPVR2200 42
+#define CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP2 43
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
-- 
2.0.0

