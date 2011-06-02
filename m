Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:35447 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab1FBE6U (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Jun 2011 00:58:20 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QRzz8-0007wY-HU
	for linux-media@vger.kernel.org; Thu, 02 Jun 2011 06:58:18 +0200
Received: from 60.52.205.105 ([60.52.205.105])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 02 Jun 2011 06:58:18 +0200
Received: from bahathir by 60.52.205.105 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 02 Jun 2011 06:58:18 +0200
To: linux-media@vger.kernel.org
From: Mohammad Bahathir Hashim <bahathir@gmail.com>
Subject: Re: [linux-dvb] XC4000 patches for kernel 2.6.37.2
Date: Thu, 2 Jun 2011 04:58:04 +0000 (UTC)
Message-ID: <is758r$g25$1@dough.gmane.org>
References: <4D764337.6050109@email.cz>
 <20110531124843.377a2a80@glory.local>
 <BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>
Reply-To: Mohammad Bahathir Hashim <bahathir@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-dvb@linuxtv.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I am a Pinnacle PCTV 340e user for 2 years. Since the release of
"Christmast Gift" in kernellabs.org, I privately made patches to ports
the driver until the latest vanilla 2.6.39. I have no problem using
the driver for my daily DVB-T viewing usage. 

Since it is open sourced, I also want to publish my patches here too.
Please consider to incluge it in main-line V4L2.  It is up to users or
maintainers to acceept it or not. 

Anyway, thank you Devin for your initial driver.

TQ

### 
### thi patch is NOT includes the xv4000.[ch]. 
diff -urw a/drivers/media/common/tuners/Kconfig b/drivers/media/common/tuners/Kconfig
--- a/drivers/media/common/tuners/Kconfig	2011-05-19 12:06:34.000000000 +0800
+++ b/drivers/media/common/tuners/Kconfig	2011-05-20 16:53:26.900999684 +0800
@@ -23,6 +23,7 @@
 	depends on VIDEO_MEDIA && I2C
 	select MEDIA_TUNER_XC2028 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_XC5000 if !MEDIA_TUNER_CUSTOMISE
+	select MEDIA_TUNER_XC4000 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_MT20XX if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_TDA8290 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_TEA5761 if !MEDIA_TUNER_CUSTOMISE
@@ -152,6 +153,15 @@
 	  This device is only used inside a SiP called together with a
 	  demodulator for now.
 
+config MEDIA_TUNER_XC4000
+	tristate "Xceive XC4000 silicon tuner"
+	depends on VIDEO_MEDIA && I2C
+	default m if MEDIA_TUNER_CUSTOMISE
+	help
+	  A driver for the silicon tuner XC4000 from Xceive.
+	  This device is only used inside a SiP called together with a
+	  demodulator for now.
+
 config MEDIA_TUNER_MXL5005S
 	tristate "MaxLinear MSL5005S silicon tuner"
 	depends on VIDEO_MEDIA && I2C
diff -urw a/drivers/media/common/tuners/Makefile b/drivers/media/common/tuners/Makefile
--- a/drivers/media/common/tuners/Makefile	2011-05-19 12:06:34.000000000 +0800
+++ b/drivers/media/common/tuners/Makefile	2011-05-20 17:28:57.357999207 +0800
@@ -16,6 +16,7 @@
 obj-$(CONFIG_MEDIA_TUNER_TDA827X) += tda827x.o
 obj-$(CONFIG_MEDIA_TUNER_TDA18271) += tda18271.o
 obj-$(CONFIG_MEDIA_TUNER_XC5000) += xc5000.o
+obj-$(CONFIG_MEDIA_TUNER_XC4000) += xc4000.o
 obj-$(CONFIG_MEDIA_TUNER_MT2060) += mt2060.o
 obj-$(CONFIG_MEDIA_TUNER_MT2266) += mt2266.o
 obj-$(CONFIG_MEDIA_TUNER_QT1010) += qt1010.o
diff -urw a/drivers/media/common/tuners/tuner-types.c b/drivers/media/common/tuners/tuner-types.c
--- a/drivers/media/common/tuners/tuner-types.c	2011-05-19 12:06:34.000000000 +0800
+++ b/drivers/media/common/tuners/tuner-types.c	2011-05-20 16:53:26.923999684 +0800
@@ -1805,6 +1805,10 @@
 		.name   = "Xceive 5000 tuner",
 		/* see xc5000.c for details */
 	},
+	[TUNER_XC4000] = { /* Xceive 4000 */
+		.name   = "Xceive 4000 tuner",
+		/* see xc4000.c for details */
+	},
 	[TUNER_TCL_MF02GIP_5N] = { /* TCL tuner MF02GIP-5N-E */
 		.name   = "TCL tuner MF02GIP-5N-E",
 		.params = tuner_tcl_mf02gip_5n_params,
diff -urw a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
--- a/drivers/media/dvb/dvb-usb/Kconfig	2011-05-19 12:06:34.000000000 +0800
+++ b/drivers/media/dvb/dvb-usb/Kconfig	2011-05-20 16:53:26.936999686 +0800
@@ -81,6 +81,7 @@
 	select MEDIA_TUNER_MT2266 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_XC2028 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_XC5000 if !MEDIA_TUNER_CUSTOMISE
+	select MEDIA_TUNER_XC4000 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_MXL5007T if !MEDIA_TUNER_CUSTOMISE
 	help
 	  Support for USB2.0/1.1 DVB receivers based on the DiB0700 USB bridge. The
diff -urw a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c	2011-05-19 12:06:34.000000000 +0800
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c	2011-05-20 22:25:28.653000410 +0800
@@ -17,6 +17,7 @@
 #include "mt2266.h"
 #include "tuner-xc2028.h"
 #include "xc5000.h"
+#include "xc4000.h"
 #include "s5h1411.h"
 #include "dib0070.h"
 #include "dib0090.h"
@@ -2656,6 +2657,146 @@
 		== NULL ? -ENODEV : 0;
 }
 
+static int dib0700_xc4000_tuner_callback(void *priv, int component,
+					 int command, int arg)
+{
+	struct dvb_usb_adapter *adap = priv;
+
+	if (command == XC4000_TUNER_RESET) {
+		/* Reset the tuner */
+		dib7000p_set_gpio(adap->fe, 8, 0, 0);
+		msleep(10);
+		dib7000p_set_gpio(adap->fe, 8, 0, 1);
+	} else {
+		err("xc4000: unknown tuner callback command: %d\n", command);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct dibx000_agc_config stk7700p_7000p_xc4000_agc_config = {
+	.band_caps = BAND_UHF | BAND_VHF,
+	.setup = 0x64,
+	.inv_gain = 0x02c8,
+	.time_stabiliz = 0x15,
+	.alpha_level = 0x00,
+	.thlock = 0x76,
+	.wbd_inv = 0x01,
+	.wbd_ref = 0x0b33,
+	.wbd_sel = 0x00,
+	.wbd_alpha = 0x02,
+	.agc1_max = 0x00,
+	.agc1_slope2 = 0x00,
+	.agc2_pt1 = 0x00,
+	.agc2_pt2 = 0x80,
+	.agc2_slope1 = 0x1d,
+	.agc2_slope2 = 0x1d,
+	.alpha_mant = 0x11,
+	.alpha_exp = 0x1b,
+	.beta_mant = 0x17,
+	.beta_exp = 0x33,
+	.perform_agc_softsplit = 0x00,
+};
+
+static struct dibx000_bandwidth_config stk7700p_xc4000_pll_config = {
+	60000, 30000, // internal, sampling
+	1, 8, 3, 1, 0, // pll_cfg: prediv, ratio, range, reset, bypass
+	0, 0, 1, 1, 0, // misc: refdiv, bypclk_div, IO_CLK_en_core, ADClkSrc, modulo
+	(3 << 14) | (1 << 12) | (524 << 0), // sad_cfg: refsel, sel, freq_15k
+	39370534, // ifreq
+	20452225, // timf
+	30000000, // xtal
+};
+
+/* FIXME: none of these inputs are validated yet */
+static struct dib7000p_config pctv_340e_config = {
+	.output_mpeg2_in_188_bytes = 1,
+
+	.agc_config_count = 1,
+	.agc = &stk7700p_7000p_xc4000_agc_config,
+	.bw  = &stk7700p_xc4000_pll_config,
+
+	.gpio_dir = DIB7000M_GPIO_DEFAULT_DIRECTIONS,
+	.gpio_val = DIB7000M_GPIO_DEFAULT_VALUES,
+	.gpio_pwm_pos = DIB7000M_GPIO_DEFAULT_PWM_POS,
+};
+
+/* PCTV 340e GPIOs map:
+   dib0700:
+   GPIO2  - CX25843 sleep
+   GPIO3  - CS5340 reset
+   GPIO5  - IRD
+   GPIO6  - Power Supply
+   GPIO8  - LNA (1=off 0=on)
+   GPIO10 - CX25843 reset
+   dib7000:
+   GPIO8  - xc4000 reset
+ */
+static int pctv340e_frontend_attach(struct dvb_usb_adapter *adap)
+{
+	struct dib0700_state *st = adap->dev->priv;
+
+	/* Power Supply on */
+	dib0700_set_gpio(adap->dev, GPIO6,  GPIO_OUT, 0);
+	msleep(50);
+	dib0700_set_gpio(adap->dev, GPIO6,  GPIO_OUT, 1);
+	msleep(100); /* Allow power supply to settle before probing */
+
+	/* cx25843 reset */
+	dib0700_set_gpio(adap->dev, GPIO10,  GPIO_OUT, 0);
+	msleep(1); /* cx25843 datasheet say 350us required */
+	dib0700_set_gpio(adap->dev, GPIO10,  GPIO_OUT, 1);
+
+	/* LNA off for now */
+	dib0700_set_gpio(adap->dev, GPIO8,  GPIO_OUT, 1);
+
+	/* Put the CX25843 to sleep for now since we're in digital mode */
+	dib0700_set_gpio(adap->dev, GPIO2, GPIO_OUT, 1);
+
+	/* FIXME: not verified yet */
+	dib0700_ctrl_clock(adap->dev, 72, 1);
+
+	msleep(500);
+
+	if (dib7000pc_detection(&adap->dev->i2c_adap) == 0) {
+		/* Demodulator not found for some reason? */
+		return -ENODEV;
+	}
+
+	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x12,
+			      &pctv_340e_config);
+	st->is_dib7000pc = 1;
+
+	return adap->fe == NULL ? -ENODEV : 0;
+}
+
+
+static struct xc4000_config dib7000p_xc4000_tunerconfig = {
+	.i2c_address      = 0x61,
+	.if_khz           = 5400,
+};
+
+static int xc4000_tuner_attach(struct dvb_usb_adapter *adap)
+{
+	struct i2c_adapter *tun_i2c;
+
+	/* The xc4000 is not on the main i2c bus */
+	tun_i2c = dib7000p_get_i2c_master(adap->fe,
+					  DIBX000_I2C_INTERFACE_TUNER, 1);
+	if (tun_i2c == NULL) {
+		printk("Could not reach tuner i2c bus\n");
+		return 0;
+	}
+
+	/* Setup the reset callback */
+	adap->fe->callback = dib0700_xc4000_tuner_callback;
+
+	return dvb_attach(xc4000_attach, adap->fe, tun_i2c,
+			  &dib7000p_xc4000_tunerconfig)
+		== NULL ? -ENODEV : 0;
+}
+
 static struct lgdt3305_config hcw_lgdt3305_config = {
 	.i2c_addr           = 0x0e,
 	.mpeg_mode          = LGDT3305_MPEG_PARALLEL,
@@ -2802,6 +2943,8 @@
 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_NIM7090) },
 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_TFE7090PVR) },
 	{ USB_DEVICE(USB_VID_TECHNISAT, USB_PID_TECHNISAT_AIRSTAR_TELESTICK_2) },
+	{ USB_DEVICE(USB_VID_PINNACLE,  USB_PID_PINNACLE_PCTV340E) },
+	{ USB_DEVICE(USB_VID_PINNACLE,  USB_PID_PINNACLE_PCTV340E_SE) },
 	{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -3768,6 +3911,42 @@
 					    RC_TYPE_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
+	},{ DIB0700_DEFAULT_DEVICE_PROPERTIES,
+		.num_adapters = 1,
+		.adapter = {
+			{
+				.frontend_attach  = pctv340e_frontend_attach,
+				.tuner_attach     = xc4000_tuner_attach,
+
+				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
+
+				.size_of_priv = sizeof(struct
+						dib0700_adapter_state),
+			},
+		},
+
+		.num_device_descs = 2,
+		.devices = {
+			{   "Pinnacle PCTV 340e HD Pro USB Stick",
+				{ &dib0700_usb_id_table[75], NULL },
+				{ NULL },
+			},
+			{   "Pinnacle PCTV Hybrid Stick Solo",
+				{ &dib0700_usb_id_table[76], NULL },
+				{ NULL },
+			},
+		},
+
+		.rc.core = {
+			.rc_interval      = DEFAULT_RC_INTERVAL,
+			.rc_codes         = RC_MAP_DIB0700_RC5_TABLE,
+			.module_name	  = "dib0700",
+			.rc_query         = dib0700_rc_query_old_firmware,
+			.allowed_protos = RC_TYPE_RC5 |
+					  RC_TYPE_RC6 |
+					  RC_TYPE_NEC,
+				.change_protocol = dib0700_change_protocol,
+	  	},
 	},
 };
 
diff -urw a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2011-05-19 12:06:34.000000000 +0800
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2011-05-20 16:53:26.948999687 +0800
@@ -233,6 +233,8 @@
 #define USB_PID_PINNACLE_PCTV73ESE			0x0245
 #define USB_PID_PINNACLE_PCTV74E			0x0246
 #define USB_PID_PINNACLE_PCTV282E			0x0248
+#define USB_PID_PINNACLE_PCTV340E			0x023d
+#define USB_PID_PINNACLE_PCTV340E_SE			0x023e
 #define USB_PID_PIXELVIEW_SBTVD				0x5010
 #define USB_PID_PCTV_200E				0x020e
 #define USB_PID_PCTV_400E				0x020f
diff -urw a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
--- a/drivers/media/video/tuner-core.c	2011-05-19 12:06:34.000000000 +0800
+++ b/drivers/media/video/tuner-core.c	2011-05-20 17:02:59.936999552 +0800
@@ -38,6 +38,7 @@
 #include "tuner-simple.h"
 #include "tda9887.h"
 #include "xc5000.h"
+#include "xc4000.h"
 #include "tda18271.h"
 
 #define UNSET (-1U)
@@ -377,6 +378,19 @@
 			goto attach_failed;
 		tune_now = 0;
 		break;
+	}
+	case TUNER_XC4000:
+	{
+		struct xc4000_config xc4000_cfg = {
+			.i2c_address = t->i2c->addr,
+		/* if_khz will be set when the digital dvb_attach() occurs */
+			.if_khz	  = 0,
+	};
+		if (!dvb_attach(xc4000_attach,
+				&t->fe, t->i2c->adapter, &xc4000_cfg))
+			goto attach_failed;
+		tune_now = 0;
+		break;
 	}
 	case TUNER_NXP_TDA18271:
 	{
diff -urw a/drivers/media/video/tveeprom.c b/drivers/media/video/tveeprom.c
--- a/drivers/media/video/tveeprom.c	2011-05-19 12:06:34.000000000 +0800
+++ b/drivers/media/video/tveeprom.c	2011-05-20 19:11:07.116999871 +0800
@@ -264,7 +264,7 @@
 	{ TUNER_XC5000,                 "Xceive XC5000"},
 	{ TUNER_ABSENT,                 "Xceive XC3028L"},
 	{ TUNER_ABSENT,                 "NXP 18271C2_716x"},
-	{ TUNER_ABSENT,                 "Xceive XC4000"},
+	{ TUNER_XC4000,                 "Xceive XC4000"},
 	{ TUNER_ABSENT,                 "Dibcom 7070"},
 	{ TUNER_PHILIPS_TDA8290,        "NXP 18271C2"},
 	{ TUNER_ABSENT,			"unknown"},

####




On 2011-05-31, Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
> On Mon, May 30, 2011 at 10:48 PM, Dmitri Belimov <d.belimov@gmail.com> wrote:
>> Hi
>>
>>> Hi Istvan
>>>
>>>       I am sending you modified patches for kernel 2.6.37.2, they
>>> works as expected.
>>>
>>> First apply kernel_xc4000.diff (your patch) then kernel_dtv3200h.diff
>>> for Leadtek DTV3200 XC4000 support.
>>
>> Can you resend your patches with right Signed-Off string for commit into kernel?
>>
>> With my best regards, Dmitry.
>
> He cannot offer a Signed-off-by for the entire patch - it's not his
> code.  The patches are based on the work that Davide Ferri and I did
> about 17 months ago:
>
> http://kernellabs.com/hg/~dheitmueller/pctv-340e-2/shortlog
>
> I'm not against seeing the xc4000 support going in, but the history
> needs to be preserved, which means it needs to be broken in to a patch
> series that properly credits my and Davide's work.
>
> Devin
>

