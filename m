Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ozlabs.org ([203.10.76.45])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <anton@ozlabs.org>) id 1KPzqu-0004zd-UJ
	for linux-dvb@linuxtv.org; Mon, 04 Aug 2008 15:11:59 +0200
Date: Mon, 4 Aug 2008 23:10:51 +1000
From: Anton Blanchard <anton@samba.org>
To: linux-dvb@linuxtv.org
Message-ID: <20080804131051.GA7241@kryten>
MIME-Version: 1.0
Content-Disposition: inline
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


Hi,

A number of people in Australia have bought the dual digital 4 only to
find revision 2 contains a completely different chipset (DIBCOM DIB7070P).

I took a look at one this weekend. It has two Cypress FX2's hooked up to
two DIB7070P's; I guess they took the previous design and bolted on the
DIBCOM chips. This means it shares a lot with the cxusb driver as well as
the dib0700 driver.

After some reverse engineering I've come up with the patch below which
works for me (DVB-T reception and remote control). Right now I've copied
bits of the dib0700 driver, I wonder if we need to consolidate that code
in a shared dib7070 driver.

While I'm not downloading any firmware to the DIBCOM chips, I wonder if
the dvb-usb-dib0700-1.10.fw firmware would be usable in this setup. I'm
not even sure how Id go about downloading it yet (the Windows driver
doesn't download any firmware).

Anton

Index: v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2008-08-04 18:10:30.000000000 +1000
+++ v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2008-08-04 18:10:46.000000000 +1000
@@ -172,6 +172,7 @@
 #define USB_PID_DVICO_BLUEBIRD_DUAL_4			0xdb78
 #define USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2		0xdb70
 #define USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2_NFW_WARM	0xdb71
+#define USB_PID_DVICO_BLUEBIRD_DUAL_5			0xdb98
 #define USB_PID_DIGITALNOW_BLUEBIRD_DUAL_1_COLD		0xdb54
 #define USB_PID_DIGITALNOW_BLUEBIRD_DUAL_1_WARM		0xdb55
 #define USB_PID_MEDION_MD95700				0x0932
Index: v4l-dvb/linux/drivers/media/dvb/dvb-usb/cxusb.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/cxusb.c	2008-08-04 18:10:30.000000000 +1000
+++ v4l-dvb/linux/drivers/media/dvb/dvb-usb/cxusb.c	2008-08-04 21:30:20.000000000 +1000
@@ -36,6 +36,8 @@
 #include "tuner-xc2028.h"
 #include "tuner-simple.h"
 #include "mxl5005s.h"
+#include "dib7000p.h"
+#include "dib0070.h"
 
 /* debug */
 static int dvb_usb_cxusb_debug;
@@ -725,6 +727,155 @@
 	return 0;
 }
 
+/* XXX Copied from dib0700, need to share the original */
+/* DIB7070 generic */
+static struct dibx000_agc_config dib7070_agc_config = {
+	BAND_UHF | BAND_VHF | BAND_LBAND | BAND_SBAND,
+	/* P_agc_use_sd_mod1=0, P_agc_use_sd_mod2=0, P_agc_freq_pwm_div=5, P_agc_inv_pwm1=0, P_agc_inv_pwm2=0,
+	 * P_agc_inh_dc_rv_est=0, P_agc_time_est=3, P_agc_freeze=0, P_agc_nb_est=5, P_agc_write=0 */
+	(0 << 15) | (0 << 14) | (5 << 11) | (0 << 10) | (0 << 9) | (0 << 8) | (3 << 5) | (0 << 4) | (5 << 1) | (0 << 0), // setup
+
+	600, // inv_gain
+	10,  // time_stabiliz
+
+	0,  // alpha_level
+	118,  // thlock
+
+	0,     // wbd_inv
+	3530,  // wbd_ref
+	1,     // wbd_sel
+	5,     // wbd_alpha
+
+	65535,  // agc1_max
+		0,  // agc1_min
+
+	65535,  // agc2_max
+	0,      // agc2_min
+
+	0,      // agc1_pt1
+	40,     // agc1_pt2
+	183,    // agc1_pt3
+	206,    // agc1_slope1
+	255,    // agc1_slope2
+	72,     // agc2_pt1
+	152,    // agc2_pt2
+	88,     // agc2_slope1
+	90,     // agc2_slope2
+
+	17,  // alpha_mant
+	27,  // alpha_exp
+	23,  // beta_mant
+	51,  // beta_exp
+
+	0,  // perform_agc_softsplit
+};
+
+/* XXX Copied from dib0700, need to share the original */
+static struct dibx000_bandwidth_config dib7070_bw_config_12_mhz = {
+	60000, 15000, // internal, sampling
+	1, 20, 3, 1, 0, // pll_cfg: prediv, ratio, range, reset, bypass
+	0, 0, 1, 1, 2, // misc: refdiv, bypclk_div, IO_CLK_en_core, ADClkSrc, modulo
+	(3 << 14) | (1 << 12) | (524 << 0), // sad_cfg: refsel, sel, freq_15k
+	(0 << 25) | 0, // ifreq = 0.000000 MHz
+	20452225, // timf
+	12000000, // xtal_hz
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
+	/* XXX Needed? */
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
+	/* .clock_pad_drive = 4 */
+};
+
+struct dib0700_adapter_state {
+        int (*set_param_save) (struct dvb_frontend *, struct dvb_frontend_parameters *);
+};
+
+/* XXX Copied from dib0700, need to share the original */
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
+static int cxusb_dualdig4_tuner_attach(struct dvb_usb_adapter *adap)
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
@@ -825,6 +976,7 @@
 static struct dvb_usb_device_properties cxusb_bluebird_lgz201_properties;
 static struct dvb_usb_device_properties cxusb_bluebird_dtt7579_properties;
 static struct dvb_usb_device_properties cxusb_bluebird_dualdig4_properties;
+static struct dvb_usb_device_properties cxusb_bluebird_dualdig4_rev2_properties;
 static struct dvb_usb_device_properties cxusb_bluebird_nano2_properties;
 static struct dvb_usb_device_properties cxusb_bluebird_nano2_needsfirmware_properties;
 static struct dvb_usb_device_properties cxusb_aver_a868r_properties;
@@ -844,6 +996,9 @@
 				     THIS_MODULE, NULL, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &cxusb_bluebird_dualdig4_properties,
 				     THIS_MODULE, NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf,
+				     &cxusb_bluebird_dualdig4_rev2_properties,
+				     THIS_MODULE, NULL, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &cxusb_bluebird_nano2_properties,
 				     THIS_MODULE, NULL, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf,
@@ -875,6 +1030,7 @@
 	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2) },
 	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2_NFW_WARM) },
 	{ USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_VOLAR_A868R) },
+	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DUAL_5) },
 	{}		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE (usb, cxusb_table);
@@ -1180,6 +1336,54 @@
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
+			.tuner_attach     = cxusb_dualdig4_tuner_attach,
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
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/dib7000p.c	2008-08-04 18:10:30.000000000 +1000
+++ v4l-dvb/linux/drivers/media/dvb/frontends/dib7000p.c	2008-08-04 18:10:46.000000000 +1000
@@ -1359,7 +1359,8 @@
 	/* Ensure the output mode remains at the previous default if it's
 	 * not specifically set by the caller.
 	 */
-	if (st->cfg.output_mode != OUTMODE_MPEG2_SERIAL)
+	if ((st->cfg.output_mode != OUTMODE_MPEG2_SERIAL) &&
+	    (st->cfg.output_mode != OUTMODE_MPEG2_PAR_GATED_CLK))
 		st->cfg.output_mode = OUTMODE_MPEG2_FIFO;
 
 	demod                   = &st->demod;

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
