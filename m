Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <hfvogt@gmx.net>) id 1JOg7y-0006mh-Df
	for linux-dvb@linuxtv.org; Mon, 11 Feb 2008 22:23:50 +0100
From: Hans-Frieder Vogt <hfvogt@gmx.net>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Mon, 11 Feb 2008 22:23:10 +0100
Message-Id: <200802112223.11129.hfvogt@gmx.net>
Subject: [linux-dvb] [PATCH] support Cinergy HT USB XE (0ccd:0058)
Reply-To: hfvogt@gmx.net
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi List,

attached is a patch that extends the dib0700 driver to support the DVB-part of the Cinergy HT USB XE (USB-ID: 0ccd:0058).
Analogue part not tested (and probably also not supported). Remote Control seems to work (tested with mini remote from
pinnacle).
I use the driver with the standard dvb-usb-dib0700-1.10.fw firmware (which is identical with the firmware in Mod7700.sys
version 3.3.1.0) and with the firmware from driver version 3.10.0.0.
The W*-Driver loads SCODE, which is not possible with xc3028-v27.fw. However, changing the id of firmware 64 from
Firmware 64, type: SCODE FW  DTV8 CHINA HAS IF (0x64000200), IF = 5.40 MHz id: (0000000000000000), size: 192
to
Firmware 64, type: SCODE FW  DTV8 HAS IF (0x60000200), IF = 5.40 MHz id: (0000000000000000), size: 192
which enables to load this SCODE firmware seems not to have an effect on the functioning of the device (BTW: why is
this firmware marked "CHINA"?).

The patch is based on some hints from Patrick Boettcher issued on this list
(see http://www.linuxtv.org/pipermail/linux-dvb/2008-January/022962.html).
It is against v4l-dvb of 9 Feb 2008.

Please test and report success (or failure).

Hans-Frieder

Signed-off-by: Hans-Frieder Vogt <hfvogt at gmx.net>

--- v4l-dvb-cvs-20080209.orig/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2008-02-09 15:58:32.947414000 +0100
+++ v4l-dvb-cvs-20080209/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2008-02-09 16:00:46.881406462 +0100
@@ -135,6 +135,7 @@
 #define USB_PID_AVERMEDIA_VOLAR				0xa807
 #define USB_PID_AVERMEDIA_VOLAR_2			0xb808
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY	0x005a
+#define USB_PID_TERRATEC_CINERGY_HT_USB_XE		0x0058
 #define USB_PID_PINNACLE_PCTV2000E			0x022c
 #define USB_PID_PINNACLE_PCTV_DVB_T_FLASH		0x0228
 #define USB_PID_PINNACLE_PCTV_DUAL_DIVERSITY_DVB_T	0x0229
--- v4l-dvb-cvs-20080209.orig/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	2008-02-09 15:58:32.862404000 +0100
+++ v4l-dvb-cvs-20080209/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	2008-02-10 23:15:59.541826174 +0100
@@ -13,6 +13,7 @@
 #include "dib7000p.h"
 #include "mt2060.h"
 #include "mt2266.h"
+#include "tuner-xc2028.h"
 #include "dib0070.h"
 
 static int force_lna_activation;
@@ -297,6 +298,149 @@ static int stk7700d_tuner_attach(struct 
 		&stk7700d_mt2266_config[adap->id]) == NULL ? -ENODEV : 0;;
 }
 
+/* STK7700-PH: Digital/Analog Hybrid Tuner, e.h. Cinergy HT USB HE */
+struct dibx000_agc_config xc3028_agc_config = {
+	BAND_VHF | BAND_UHF,       // band_caps
+
+	/* P_agc_use_sd_mod1=0, P_agc_use_sd_mod2=0, P_agc_freq_pwm_div=0, P_agc_inv_pwm1=0, P_agc_inv_pwm2=0,
+	 * P_agc_inh_dc_rv_est=0, P_agc_time_est=3, P_agc_freeze=0, P_agc_nb_est=2, P_agc_write=0 */
+	(0 << 15) | (0 << 14) | (0 << 11) | (0 << 10) | (0 << 9) | (0 << 8) | (3 << 5) | (0 << 4) | (2 << 1) | (0 << 0), // setup
+
+	712,  // inv_gain
+	21,  // time_stabiliz
+
+	0,  // alpha_level
+	118,  // thlock
+
+	0,     // wbd_inv
+	2867,  // wbd_ref
+	0,  // wbd_sel
+	2,  // wbd_alpha
+
+	0,  // agc1_max
+	0,  // agc1_min
+	39718,  // agc2_max
+	9930,  // agc2_min
+	0,  // agc1_pt1
+	0,  // agc1_pt2
+	0,  // agc1_pt3
+	0,  // agc1_slope1
+	0,  // agc1_slope2
+	0,  // agc2_pt1
+	128,  // agc2_pt2
+	29,  // agc2_slope1
+	29,  // agc2_slope2
+
+	17,  // alpha_mant
+	27,  // alpha_exp
+	23,  // beta_mant
+	51,  // beta_exp
+
+	1,  // perform_agc_softsplit
+};
+
+/* PLL Configuration for COFDM BW_MHz = 8.000000 With external clock = 30.000000 */
+struct dibx000_bandwidth_config xc3028_bw_config = {
+	60000, 30000, // internal, sampling
+	1, 8, 3, 1, 0, // pll_cfg: prediv, ratio, range, reset, bypass
+	0, 0, 1, 1, 0, // misc: refdiv, bypclk_div, IO_CLK_en_core, ADClkSrc, modulo
+	(3 << 14) | (1 << 12) | (524 << 0), // sad_cfg: refsel, sel, freq_15k
+	(1 << 25) | 5816102, // ifreq = 5.200000 MHz
+	20452225, // timf
+	30000000, // xtal_hz
+};
+
+struct dibx000_bandwidth_config xc3028_bw_config_12mhz = {
+	60000, 30000, // internal, sampling
+	1, 20, 3, 1, 0, // pll_cfg: prediv, ratio, range, reset, bypass
+	0, 0, 1, 1, 0, // misc: refdiv, bypclk_div, IO_CLK_en_core, ADClkSrc, modulo
+	(3 << 14) | (1 << 12) | (524 << 0), // sad_cfg: refsel, sel, freq_15k
+	(1 << 25) | 5816102, // ifreq = 5.200000 MHz
+	20452225, // timf
+};
+
+static struct dib7000p_config stk7700ph_dib7700_xc3028_config = {
+	.output_mpeg2_in_188_bytes = 1,
+	.tuner_is_baseband = 1,
+
+	.agc_config_count = 1,
+	.agc = &xc3028_agc_config,
+	.bw  = &xc3028_bw_config,
+
+	.gpio_dir = DIB7000P_GPIO_DEFAULT_DIRECTIONS,
+	.gpio_val = DIB7000P_GPIO_DEFAULT_VALUES,
+	.gpio_pwm_pos = DIB7000P_GPIO_DEFAULT_PWM_POS,
+};
+
+static int stk7700ph_xc3028_callback(void *ptr, int command, int arg)
+{
+	struct dvb_usb_adapter *adap = ptr;
+
+	switch (command) {
+	case XC2028_TUNER_RESET:
+		/* Send the tuner in then out of reset */
+		err("%s: XC2028_TUNER_RESET %d\n", __FUNCTION__, arg);
+		dib7000p_set_gpio(adap->fe, 8, 0, 0); msleep(10);
+		dib7000p_set_gpio(adap->fe, 8, 0, 1);
+		break;
+	case XC2028_RESET_CLK:
+		err("%s: XC2028_RESET_CLK %d\n", __FUNCTION__, arg);
+		break;
+	default:
+		err("%s: unknown command %d, arg %d\n", __FUNCTION__,
+			command, arg);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static struct xc2028_ctrl stk7700ph_xc3028_ctrl = {
+        .fname = XC2028_DEFAULT_FIRMWARE,
+	.max_len = 64,
+};
+
+static struct xc2028_config stk7700ph_xc3028_config = {
+	.i2c_addr = 0x61,
+	.callback = stk7700ph_xc3028_callback,
+	.ctrl = &stk7700ph_xc3028_ctrl,
+};
+
+static int stk7700ph_frontend_attach(struct dvb_usb_adapter *adap)
+{
+	/* this is at the moment just a copy of stk7700p_frontend_attach */
+	dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 0);
+	dib0700_set_gpio(adap->dev, GPIO6,  GPIO_OUT, 0); msleep(50);
+
+	dib0700_set_gpio(adap->dev, GPIO6,  GPIO_OUT, 1); msleep(10);
+	dib0700_set_gpio(adap->dev, GPIO9,  GPIO_OUT, 1);
+
+	dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 0); msleep(10);
+	dib0700_ctrl_clock(adap->dev, 72, 1);
+	dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 1); msleep(100);
+
+	dib0700_set_gpio(adap->dev,  GPIO0, GPIO_OUT, 1);
+
+	dib7000p_i2c_enumeration(&adap->dev->i2c_adap, 1, 18, &stk7700ph_dib7700_xc3028_config);
+
+	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80,
+				&stk7700ph_dib7700_xc3028_config);
+
+	return adap->fe == NULL ? -ENODEV : 0;
+}
+
+static int stk7700ph_tuner_attach(struct dvb_usb_adapter *adap)
+{
+	struct i2c_adapter *tun_i2c;
+
+	tun_i2c = dib7000p_get_i2c_master(adap->fe, DIBX000_I2C_INTERFACE_TUNER, 1);
+
+	stk7700ph_xc3028_config.i2c_adap = tun_i2c;
+	stk7700ph_xc3028_config.video_dev = adap;
+
+	return dvb_attach(xc2028_attach, adap->fe, &stk7700ph_xc3028_config) == NULL ?
+		-ENODEV : 0;
+}
+
 #define DEFAULT_RC_INTERVAL 150
 
 static u8 rc_request[] = { REQUEST_POLL_RC, 0 };
@@ -905,6 +1049,7 @@ struct usb_device_id dib0700_usb_id_tabl
 		{ USB_DEVICE(USB_VID_ASUS,      USB_PID_ASUS_U3100) },
 /* 25 */	{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_NOVA_T_STICK_3) },
 		{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_MYTV_T) },
+/* 27 */	{ USB_DEVICE(USB_VID_TERRATEC,  USB_PID_TERRATEC_CINERGY_HT_USB_XE) },
 		{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -1155,6 +1300,31 @@ struct dvb_usb_device_properties dib0700
 				{ NULL },
 			}
 		}
+	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
+
+		.num_adapters = 1,
+		.adapter = {
+			{
+				.frontend_attach  = stk7700ph_frontend_attach,
+				.tuner_attach     = stk7700ph_tuner_attach,
+
+				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
+
+				.size_of_priv     = sizeof(struct dib0700_adapter_state),
+			},
+		},
+
+		.num_device_descs = 1,
+		.devices = {
+			{   "Terratec Cinergy HT USB XE",
+				{ &dib0700_usb_id_table[27], NULL },
+				{ NULL },
+			},
+		},
+		.rc_interval      = DEFAULT_RC_INTERVAL,
+		.rc_key_map       = dib0700_rc_keys,
+		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
+		.rc_query         = dib0700_rc_query
 	},
 };
 


-- 
--
Hans-Frieder Vogt                 e-mail: hfvogt <at> gmx .dot. net


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
