Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Sat, 9 Aug 2008 14:18:48 +1000
From: Anton Blanchard <anton@samba.org>
To: Michael Krufky <mkrufky@linuxtv.org>
Message-ID: <20080809041847.GA5045@kryten>
References: <20080804131051.GA7241@kryten>
	<37219a840808040935o3cf613bdvd644bb0e592c8430@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <37219a840808040935o3cf613bdvd644bb0e592c8430@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: [linux-dvb] [PATCH] DViCO FusionHDTV DVB-T Dual Digital 4 (rev 2)
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
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


Add support for revision 2 of the DViCO FusionHDTV DVB-T Dual Digital 4
which has new tuners and demodulators (2 x DIB7070p). With this patch
both DVB reception and IR works.

The dib7000p driver currently hardwires the output mode to
OUTMODE_MPEG2_SERIAL regardless of what we ask for. Modify it to allow
OUTMODE_MPEG2_PAR_GATED_CLK to be set. Longer term we should remove the
check completely and set the output mode correctly in all the callers.

Add Kconfig bits to ensure the dib7000p and dib0070 modules are enabled.
It would be nice to only do this for the !DVB_FE_CUSTOMISE case, but
this is what the other DIB7070 module does (there are a number of
module dependencies in the attach code).

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2008-08-09 09:53:09.000000000 +1000
+++ v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2008-08-09 09:54:00.000000000 +1000
@@ -170,6 +170,7 @@
 #define USB_PID_DVICO_BLUEBIRD_DUAL_2_COLD		0xdb58
 #define USB_PID_DVICO_BLUEBIRD_DUAL_2_WARM		0xdb59
 #define USB_PID_DVICO_BLUEBIRD_DUAL_4			0xdb78
+#define USB_PID_DVICO_BLUEBIRD_DUAL_4_REV_2		0xdb98
 #define USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2		0xdb70
 #define USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2_NFW_WARM	0xdb71
 #define USB_PID_DIGITALNOW_BLUEBIRD_DUAL_1_COLD		0xdb54
Index: v4l-dvb/linux/drivers/media/dvb/dvb-usb/cxusb.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/cxusb.c	2008-08-09 09:53:09.000000000 +1000
+++ v4l-dvb/linux/drivers/media/dvb/dvb-usb/cxusb.c	2008-08-09 10:53:24.000000000 +1000
@@ -36,6 +36,8 @@
 #include "tuner-xc2028.h"
 #include "tuner-simple.h"
 #include "mxl5005s.h"
+#include "dib7000p.h"
+#include "dib0070.h"
 
 /* debug */
 static int dvb_usb_cxusb_debug;
@@ -726,6 +728,157 @@
 	return 0;
 }
 
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
+static struct dib7000p_config cxusb_dualdig4_rev2_config = {
+	.output_mode = OUTMODE_MPEG2_PAR_GATED_CLK,
+	.output_mpeg2_in_188_bytes = 1,
+
+	.agc_config_count = 1,
+	.agc = &dib7070_agc_config,
+	.bw  = &dib7070_bw_config_12_mhz,
+	.tuner_is_baseband = 1,
+	.spur_protect = 1,
+
+	.gpio_dir = 0xfcef,
+	.gpio_val = 0x0110,
+
+	.gpio_pwm_pos = DIB7000P_GPIO_DEFAULT_PWM_POS,
+
+	.hostbus_diversity = 1,
+};
+
+static int cxusb_dualdig4_rev2_frontend_attach(struct dvb_usb_adapter *adap)
+{
+	if (usb_set_interface(adap->dev->udev, 0, 1) < 0)
+		err("set interface failed");
+
+	cxusb_ctrl_msg(adap->dev, CMD_DIGITAL, NULL, 0, NULL, 0);
+
+	cxusb_bluebird_gpio_pulse(adap->dev, 0x02, 1);
+
+	dib7000p_i2c_enumeration(&adap->dev->i2c_adap, 1, 18,
+				 &cxusb_dualdig4_rev2_config);
+
+	if ((adap->fe = dvb_attach(dib7000p_attach,
+				   &adap->dev->i2c_adap, 0x80,
+				   &cxusb_dualdig4_rev2_config)) == NULL)
+		return -EIO;
+
+	return 0;
+}
+
+static int dib7070_tuner_reset(struct dvb_frontend *fe, int onoff)
+{
+	return dib7000p_set_gpio(fe, 8, 0, !onoff);
+}
+
+static int dib7070_tuner_sleep(struct dvb_frontend *fe, int onoff)
+{
+        return 0;
+}
+
+static struct dib0070_config dib7070p_dib0070_config = {
+	.i2c_address = DEFAULT_DIB0070_I2C_ADDRESS,
+	.reset = dib7070_tuner_reset,
+	.sleep = dib7070_tuner_sleep,
+	.clock_khz = 12000,
+};
+
+struct dib0700_adapter_state {
+        int (*set_param_save) (struct dvb_frontend *,
+			       struct dvb_frontend_parameters *);
+};
+
+static int dib7070_set_param_override(struct dvb_frontend *fe,
+				      struct dvb_frontend_parameters *fep)
+{
+	struct dvb_usb_adapter *adap = fe->dvb->priv;
+	struct dib0700_adapter_state *state = adap->priv;
+
+	u16 offset;
+	u8 band = BAND_OF_FREQUENCY(fep->frequency/1000);
+	switch (band) {
+		case BAND_VHF: offset = 950; break;
+		case BAND_UHF:
+		default: offset = 550; break;
+	}
+
+	dib7000p_set_wbd_ref(fe, offset + dib0070_wbd_offset(fe));
+
+	return state->set_param_save(fe, fep);
+}
+
+static int cxusb_dualdig4_rev2_tuner_attach(struct dvb_usb_adapter *adap)
+{
+        struct dib0700_adapter_state *st = adap->priv;
+        struct i2c_adapter *tun_i2c = dib7000p_get_i2c_master(adap->fe, DIBX000_I2C_INTERFACE_TUNER, 1);
+
+	if (dvb_attach(dib0070_attach, adap->fe, tun_i2c,
+	    &dib7070p_dib0070_config) == NULL)
+		return -ENODEV;
+
+	st->set_param_save = adap->fe->ops.tuner_ops.set_params;
+	adap->fe->ops.tuner_ops.set_params = dib7070_set_param_override;
+	return 0;
+}
+
 static int cxusb_nano2_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	if (usb_set_interface(adap->dev->udev, 0, 1) < 0)
@@ -826,6 +979,7 @@
 static struct dvb_usb_device_properties cxusb_bluebird_lgz201_properties;
 static struct dvb_usb_device_properties cxusb_bluebird_dtt7579_properties;
 static struct dvb_usb_device_properties cxusb_bluebird_dualdig4_properties;
+static struct dvb_usb_device_properties cxusb_bluebird_dualdig4_rev2_properties;
 static struct dvb_usb_device_properties cxusb_bluebird_nano2_properties;
 static struct dvb_usb_device_properties cxusb_bluebird_nano2_needsfirmware_properties;
 static struct dvb_usb_device_properties cxusb_aver_a868r_properties;
@@ -845,6 +999,9 @@
 				     THIS_MODULE, NULL, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &cxusb_bluebird_dualdig4_properties,
 				     THIS_MODULE, NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf,
+				     &cxusb_bluebird_dualdig4_rev2_properties,
+				     THIS_MODULE, NULL, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &cxusb_bluebird_nano2_properties,
 				     THIS_MODULE, NULL, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf,
@@ -876,6 +1033,7 @@
 	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2) },
 	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2_NFW_WARM) },
 	{ USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_VOLAR_A868R) },
+	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DUAL_4_REV_2) },
 	{}		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE (usb, cxusb_table);
@@ -1181,6 +1339,54 @@
 	}
 };
 
+static struct dvb_usb_device_properties cxusb_bluebird_dualdig4_rev2_properties = {
+	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
+
+	.usb_ctrl         = CYPRESS_FX2,
+
+	.size_of_priv     = sizeof(struct cxusb_state),
+
+	.num_adapters = 1,
+	.adapter = {
+		{
+			.streaming_ctrl   = cxusb_streaming_ctrl,
+			.frontend_attach  = cxusb_dualdig4_rev2_frontend_attach,
+			.tuner_attach     = cxusb_dualdig4_rev2_tuner_attach,
+			.size_of_priv     = sizeof(struct dib0700_adapter_state),
+			/* parameter for the MPEG2-data transfer */
+			.stream = {
+				.type = USB_BULK,
+				.count = 7,
+				.endpoint = 0x02,
+				.u = {
+					.bulk = {
+						.buffersize = 4096,
+					}
+				}
+			},
+		},
+	},
+
+	.power_ctrl       = cxusb_bluebird_power_ctrl,
+
+	.i2c_algo         = &cxusb_i2c_algo,
+
+	.generic_bulk_ctrl_endpoint = 0x01,
+
+	.rc_interval      = 100,
+	.rc_key_map       = dvico_mce_rc_keys,
+	.rc_key_map_size  = ARRAY_SIZE(dvico_mce_rc_keys),
+	.rc_query         = cxusb_rc_query,
+
+	.num_device_descs = 1,
+	.devices = {
+		{   "DViCO FusionHDTV DVB-T Dual Digital 4 (rev 2)",
+			{ NULL },
+			{ &cxusb_table[17], NULL },
+		},
+	}
+};
+
 static struct dvb_usb_device_properties cxusb_bluebird_nano2_properties = {
 	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
 
Index: v4l-dvb/linux/drivers/media/dvb/frontends/dib7000p.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/dib7000p.c	2008-08-09 09:53:09.000000000 +1000
+++ v4l-dvb/linux/drivers/media/dvb/frontends/dib7000p.c	2008-08-09 09:54:00.000000000 +1000
@@ -1359,7 +1359,8 @@
 	/* Ensure the output mode remains at the previous default if it's
 	 * not specifically set by the caller.
 	 */
-	if (st->cfg.output_mode != OUTMODE_MPEG2_SERIAL)
+	if ((st->cfg.output_mode != OUTMODE_MPEG2_SERIAL) &&
+	    (st->cfg.output_mode != OUTMODE_MPEG2_PAR_GATED_CLK))
 		st->cfg.output_mode = OUTMODE_MPEG2_FIFO;
 
 	demod                   = &st->demod;
Index: v4l-dvb/linux/drivers/media/dvb/dvb-usb/Kconfig
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/Kconfig	2008-08-09 14:04:49.000000000 +1000
+++ v4l-dvb/linux/drivers/media/dvb/dvb-usb/Kconfig	2008-08-09 14:09:44.000000000 +1000
@@ -108,6 +108,8 @@
 	select MEDIA_TUNER_SIMPLE if !DVB_FE_CUSTOMISE
 	select MEDIA_TUNER_XC2028 if !DVB_FE_CUSTOMISE
 	select MEDIA_TUNER_MXL5005S if !DVB_FE_CUSTOMISE
+	select DVB_DIB7000P
+	select DVB_TUNER_DIB0070
 	help
 	  Say Y here to support the Conexant USB2.0 hybrid reference design.
 	  Currently, only DVB and ATSC modes are supported, analog mode

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
