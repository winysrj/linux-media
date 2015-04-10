Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:62181 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbbDJU30 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2015 16:29:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-kernel@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
	Olli Salonen <olli.salonen@iki.fi>,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH] [media] dvb-usb/dvb-usb-v2: use IS_REACHABLE
Date: Fri, 10 Apr 2015 22:28:40 +0200
Message-ID: <2280698.HtVfESyfme@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tha ARM randconfig builds came up with another rare build
failure for the dib3000mc driver, when dibusb is built-in
and dib3000mc is a loadable module:

ERROR: "dibusb_dib3000mc_frontend_attach" [drivers/media/usb/dvb-usb/dvb-usb-nova-t-usb2.ko] undefined!
ERROR: "dibusb_dib3000mc_tuner_attach" [drivers/media/usb/dvb-usb/dvb-usb-nova-t-usb2.ko] undefined!

Apparently this used to be a valid configuration (build-time,
not run-time), but broke as part of a cleanup.
I tried reverting the cleanup, but saw that the code was still
wrong then. This tries to fix the code properly, by moving the
problematic functions into a new file that now is built as a
loadable module or built-in, whichever is correct for a particular
configuration. It fixes the regression as well as the run-time
problem that already existed before.

I have also checked the two other files that were changed in
the original cleanup, and found them to be correct in either
version, so I do not touch that part.

As this is a rather obscure bug, there is no need for backports.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 028c70ff42783 ("[media] dvb-usb/dvb-usb-v2: use IS_ENABLED")
---
 drivers/media/usb/dvb-usb/Kconfig            |  20 +++-
 drivers/media/usb/dvb-usb/Makefile           |   3 +
 drivers/media/usb/dvb-usb/dibusb-common.c    | 158 -------------------------
 drivers/media/usb/dvb-usb/dibusb-mc-common.c | 168 +++++++++++++++++++++++++++
 4 files changed, 186 insertions(+), 163 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/Kconfig b/drivers/media/usb/dvb-usb/Kconfig
index 128eee61570d..8b662b3f8ac1 100644
--- a/drivers/media/usb/dvb-usb/Kconfig
+++ b/drivers/media/usb/dvb-usb/Kconfig
@@ -20,10 +20,20 @@ config DVB_USB_DEBUG
 	  Say Y if you want to enable debugging. See modinfo dvb-usb (and the
 	  appropriate drivers) for debug levels.
 
+config DVB_USB_DIB3000MC
+	tristate
+	depends on DVB_USB
+	select DVB_DIB3000MC
+	help
+	  This is a module with helper functions for accessing the
+	  DIB3000MC from USB DVB devices. It must be a separate module
+	  in case DVB_USB is built-in and DVB_DIB3000MC is a module,
+	  and gets selected automatically when needed.
+
 config DVB_USB_A800
 	tristate "AVerMedia AverTV DVB-T USB 2.0 (A800)"
 	depends on DVB_USB
-	select DVB_DIB3000MC
+	select DVB_USB_DIB3000MC
 	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_MT2060 if MEDIA_SUBDRV_AUTOSELECT
 	help
@@ -54,7 +64,7 @@ config DVB_USB_DIBUSB_MB_FAULTY
 config DVB_USB_DIBUSB_MC
 	tristate "DiBcom USB DVB-T devices (based on the DiB3000M-C/P) (see help for device list)"
 	depends on DVB_USB
-	select DVB_DIB3000MC
+	select DVB_USB_DIB3000MC
 	select MEDIA_TUNER_MT2060 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Support for USB2.0 DVB-T receivers based on reference designs made by
@@ -72,7 +82,7 @@ config DVB_USB_DIB0700
 	select DVB_DIB7000P if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_DIB7000M if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_DIB8000 if MEDIA_SUBDRV_AUTOSELECT
-	select DVB_DIB3000MC if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_USB_DIB3000MC if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_S5H1411 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_LGDT3305 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_TUNER_DIB0070 if MEDIA_SUBDRV_AUTOSELECT
@@ -99,7 +109,7 @@ config DVB_USB_UMT_010
 	tristate "HanfTek UMT-010 DVB-T USB2.0 support"
 	depends on DVB_USB
 	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
-	select DVB_DIB3000MC
+	select DVB_USB_DIB3000MC
 	select MEDIA_TUNER_MT2060 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_MT352 if MEDIA_SUBDRV_AUTOSELECT
 	help
@@ -192,7 +202,7 @@ config DVB_USB_GP8PSK
 config DVB_USB_NOVA_T_USB2
 	tristate "Hauppauge WinTV-NOVA-T usb2 DVB-T USB2.0 support"
 	depends on DVB_USB
-	select DVB_DIB3000MC
+	select DVB_USB_DIB3000MC
 	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_MT2060 if MEDIA_SUBDRV_AUTOSELECT
 	help
diff --git a/drivers/media/usb/dvb-usb/Makefile b/drivers/media/usb/dvb-usb/Makefile
index acdd1efd4e74..8da26352f73b 100644
--- a/drivers/media/usb/dvb-usb/Makefile
+++ b/drivers/media/usb/dvb-usb/Makefile
@@ -16,6 +16,9 @@ obj-$(CONFIG_DVB_USB_DTT200U) += dvb-usb-dtt200u.o
 
 dvb-usb-dibusb-common-objs := dibusb-common.o
 
+dvb-usb-dibusb-mc-common-objs := dibusb-mc-common.o
+obj-$(CONFIG_DVB_USB_DIB3000MC)	+= dvb-usb-dibusb-mc-common.o
+
 dvb-usb-a800-objs := a800.o
 obj-$(CONFIG_DVB_USB_A800) += dvb-usb-dibusb-common.o dvb-usb-a800.o
 
diff --git a/drivers/media/usb/dvb-usb/dibusb-common.c b/drivers/media/usb/dvb-usb/dibusb-common.c
index ef3a8f75f82e..7617ba8ac698 100644
--- a/drivers/media/usb/dvb-usb/dibusb-common.c
+++ b/drivers/media/usb/dvb-usb/dibusb-common.c
@@ -184,164 +184,6 @@ int dibusb_read_eeprom_byte(struct dvb_usb_device *d, u8 offs, u8 *val)
 }
 EXPORT_SYMBOL(dibusb_read_eeprom_byte);
 
-/* 3000MC/P stuff */
-// Config Adjacent channels  Perf -cal22
-static struct dibx000_agc_config dib3000p_mt2060_agc_config = {
-	.band_caps = BAND_VHF | BAND_UHF,
-	.setup     = (1 << 8) | (5 << 5) | (1 << 4) | (1 << 3) | (0 << 2) | (2 << 0),
-
-	.agc1_max = 48497,
-	.agc1_min = 23593,
-	.agc2_max = 46531,
-	.agc2_min = 24904,
-
-	.agc1_pt1 = 0x65,
-	.agc1_pt2 = 0x69,
-
-	.agc1_slope1 = 0x51,
-	.agc1_slope2 = 0x27,
-
-	.agc2_pt1 = 0,
-	.agc2_pt2 = 0x33,
-
-	.agc2_slope1 = 0x35,
-	.agc2_slope2 = 0x37,
-};
-
-static struct dib3000mc_config stk3000p_dib3000p_config = {
-	&dib3000p_mt2060_agc_config,
-
-	.max_time     = 0x196,
-	.ln_adc_level = 0x1cc7,
-
-	.output_mpeg2_in_188_bytes = 1,
-
-	.agc_command1 = 1,
-	.agc_command2 = 1,
-};
-
-static struct dibx000_agc_config dib3000p_panasonic_agc_config = {
-	.band_caps = BAND_VHF | BAND_UHF,
-	.setup     = (1 << 8) | (5 << 5) | (1 << 4) | (1 << 3) | (0 << 2) | (2 << 0),
-
-	.agc1_max = 56361,
-	.agc1_min = 22282,
-	.agc2_max = 47841,
-	.agc2_min = 36045,
-
-	.agc1_pt1 = 0x3b,
-	.agc1_pt2 = 0x6b,
-
-	.agc1_slope1 = 0x55,
-	.agc1_slope2 = 0x1d,
-
-	.agc2_pt1 = 0,
-	.agc2_pt2 = 0x0a,
-
-	.agc2_slope1 = 0x95,
-	.agc2_slope2 = 0x1e,
-};
-
-#if IS_ENABLED(CONFIG_DVB_DIB3000MC)
-
-static struct dib3000mc_config mod3000p_dib3000p_config = {
-	&dib3000p_panasonic_agc_config,
-
-	.max_time     = 0x51,
-	.ln_adc_level = 0x1cc7,
-
-	.output_mpeg2_in_188_bytes = 1,
-
-	.agc_command1 = 1,
-	.agc_command2 = 1,
-};
-
-int dibusb_dib3000mc_frontend_attach(struct dvb_usb_adapter *adap)
-{
-	if (le16_to_cpu(adap->dev->udev->descriptor.idVendor) == USB_VID_LITEON &&
-	    le16_to_cpu(adap->dev->udev->descriptor.idProduct) ==
-			USB_PID_LITEON_DVB_T_WARM) {
-		msleep(1000);
-	}
-
-	adap->fe_adap[0].fe = dvb_attach(dib3000mc_attach,
-					 &adap->dev->i2c_adap,
-					 DEFAULT_DIB3000P_I2C_ADDRESS,
-					 &mod3000p_dib3000p_config);
-	if ((adap->fe_adap[0].fe) == NULL)
-		adap->fe_adap[0].fe = dvb_attach(dib3000mc_attach,
-						 &adap->dev->i2c_adap,
-						 DEFAULT_DIB3000MC_I2C_ADDRESS,
-						 &mod3000p_dib3000p_config);
-	if ((adap->fe_adap[0].fe) != NULL) {
-		if (adap->priv != NULL) {
-			struct dibusb_state *st = adap->priv;
-			st->ops.pid_parse = dib3000mc_pid_parse;
-			st->ops.pid_ctrl  = dib3000mc_pid_control;
-		}
-		return 0;
-	}
-	return -ENODEV;
-}
-EXPORT_SYMBOL(dibusb_dib3000mc_frontend_attach);
-
-static struct mt2060_config stk3000p_mt2060_config = {
-	0x60
-};
-
-int dibusb_dib3000mc_tuner_attach(struct dvb_usb_adapter *adap)
-{
-	struct dibusb_state *st = adap->priv;
-	u8 a,b;
-	u16 if1 = 1220;
-	struct i2c_adapter *tun_i2c;
-
-	// First IF calibration for Liteon Sticks
-	if (le16_to_cpu(adap->dev->udev->descriptor.idVendor) == USB_VID_LITEON &&
-	    le16_to_cpu(adap->dev->udev->descriptor.idProduct) == USB_PID_LITEON_DVB_T_WARM) {
-
-		dibusb_read_eeprom_byte(adap->dev,0x7E,&a);
-		dibusb_read_eeprom_byte(adap->dev,0x7F,&b);
-
-		if (a == 0x00)
-			if1 += b;
-		else if (a == 0x80)
-			if1 -= b;
-		else
-			warn("LITE-ON DVB-T: Strange IF1 calibration :%2X %2X\n", a, b);
-
-	} else if (le16_to_cpu(adap->dev->udev->descriptor.idVendor) == USB_VID_DIBCOM &&
-		   le16_to_cpu(adap->dev->udev->descriptor.idProduct) == USB_PID_DIBCOM_MOD3001_WARM) {
-		u8 desc;
-		dibusb_read_eeprom_byte(adap->dev, 7, &desc);
-		if (desc == 2) {
-			a = 127;
-			do {
-				dibusb_read_eeprom_byte(adap->dev, a, &desc);
-				a--;
-			} while (a > 7 && (desc == 0xff || desc == 0x00));
-			if (desc & 0x80)
-				if1 -= (0xff - desc);
-			else
-				if1 += desc;
-		}
-	}
-
-	tun_i2c = dib3000mc_get_tuner_i2c_master(adap->fe_adap[0].fe, 1);
-	if (dvb_attach(mt2060_attach, adap->fe_adap[0].fe, tun_i2c, &stk3000p_mt2060_config, if1) == NULL) {
-		/* not found - use panasonic pll parameters */
-		if (dvb_attach(dvb_pll_attach, adap->fe_adap[0].fe, 0x60, tun_i2c, DVB_PLL_ENV57H1XD5) == NULL)
-			return -ENOMEM;
-	} else {
-		st->mt2060_present = 1;
-		/* set the correct parameters for the dib3000p */
-		dib3000mc_set_config(adap->fe_adap[0].fe, &stk3000p_dib3000p_config);
-	}
-	return 0;
-}
-EXPORT_SYMBOL(dibusb_dib3000mc_tuner_attach);
-#endif
-
 /*
  * common remote control stuff
  */
diff --git a/drivers/media/usb/dvb-usb/dibusb-mc-common.c b/drivers/media/usb/dvb-usb/dibusb-mc-common.c
new file mode 100644
index 000000000000..d66f56cc46a5
--- /dev/null
+++ b/drivers/media/usb/dvb-usb/dibusb-mc-common.c
@@ -0,0 +1,168 @@
+/* Common methods for dibusb-based-receivers.
+ *
+ * Copyright (C) 2004-5 Patrick Boettcher (patrick.boettcher@desy.de)
+ *
+ *	This program is free software; you can redistribute it and/or modify it
+ *	under the terms of the GNU General Public License as published by the Free
+ *	Software Foundation, version 2.
+ *
+ * see Documentation/dvb/README.dvb-usb for more information
+ */
+
+#include <linux/kconfig.h>
+#include "dibusb.h"
+
+/* 3000MC/P stuff */
+// Config Adjacent channels  Perf -cal22
+static struct dibx000_agc_config dib3000p_mt2060_agc_config = {
+	.band_caps = BAND_VHF | BAND_UHF,
+	.setup     = (1 << 8) | (5 << 5) | (1 << 4) | (1 << 3) | (0 << 2) | (2 << 0),
+
+	.agc1_max = 48497,
+	.agc1_min = 23593,
+	.agc2_max = 46531,
+	.agc2_min = 24904,
+
+	.agc1_pt1 = 0x65,
+	.agc1_pt2 = 0x69,
+
+	.agc1_slope1 = 0x51,
+	.agc1_slope2 = 0x27,
+
+	.agc2_pt1 = 0,
+	.agc2_pt2 = 0x33,
+
+	.agc2_slope1 = 0x35,
+	.agc2_slope2 = 0x37,
+};
+
+static struct dib3000mc_config stk3000p_dib3000p_config = {
+	&dib3000p_mt2060_agc_config,
+
+	.max_time     = 0x196,
+	.ln_adc_level = 0x1cc7,
+
+	.output_mpeg2_in_188_bytes = 1,
+
+	.agc_command1 = 1,
+	.agc_command2 = 1,
+};
+
+static struct dibx000_agc_config dib3000p_panasonic_agc_config = {
+	.band_caps = BAND_VHF | BAND_UHF,
+	.setup     = (1 << 8) | (5 << 5) | (1 << 4) | (1 << 3) | (0 << 2) | (2 << 0),
+
+	.agc1_max = 56361,
+	.agc1_min = 22282,
+	.agc2_max = 47841,
+	.agc2_min = 36045,
+
+	.agc1_pt1 = 0x3b,
+	.agc1_pt2 = 0x6b,
+
+	.agc1_slope1 = 0x55,
+	.agc1_slope2 = 0x1d,
+
+	.agc2_pt1 = 0,
+	.agc2_pt2 = 0x0a,
+
+	.agc2_slope1 = 0x95,
+	.agc2_slope2 = 0x1e,
+};
+
+static struct dib3000mc_config mod3000p_dib3000p_config = {
+	&dib3000p_panasonic_agc_config,
+
+	.max_time     = 0x51,
+	.ln_adc_level = 0x1cc7,
+
+	.output_mpeg2_in_188_bytes = 1,
+
+	.agc_command1 = 1,
+	.agc_command2 = 1,
+};
+
+int dibusb_dib3000mc_frontend_attach(struct dvb_usb_adapter *adap)
+{
+	if (le16_to_cpu(adap->dev->udev->descriptor.idVendor) == USB_VID_LITEON &&
+	    le16_to_cpu(adap->dev->udev->descriptor.idProduct) ==
+			USB_PID_LITEON_DVB_T_WARM) {
+		msleep(1000);
+	}
+
+	adap->fe_adap[0].fe = dvb_attach(dib3000mc_attach,
+					 &adap->dev->i2c_adap,
+					 DEFAULT_DIB3000P_I2C_ADDRESS,
+					 &mod3000p_dib3000p_config);
+	if ((adap->fe_adap[0].fe) == NULL)
+		adap->fe_adap[0].fe = dvb_attach(dib3000mc_attach,
+						 &adap->dev->i2c_adap,
+						 DEFAULT_DIB3000MC_I2C_ADDRESS,
+						 &mod3000p_dib3000p_config);
+	if ((adap->fe_adap[0].fe) != NULL) {
+		if (adap->priv != NULL) {
+			struct dibusb_state *st = adap->priv;
+			st->ops.pid_parse = dib3000mc_pid_parse;
+			st->ops.pid_ctrl  = dib3000mc_pid_control;
+		}
+		return 0;
+	}
+	return -ENODEV;
+}
+EXPORT_SYMBOL(dibusb_dib3000mc_frontend_attach);
+
+static struct mt2060_config stk3000p_mt2060_config = {
+	0x60
+};
+
+int dibusb_dib3000mc_tuner_attach(struct dvb_usb_adapter *adap)
+{
+	struct dibusb_state *st = adap->priv;
+	u8 a,b;
+	u16 if1 = 1220;
+	struct i2c_adapter *tun_i2c;
+
+	// First IF calibration for Liteon Sticks
+	if (le16_to_cpu(adap->dev->udev->descriptor.idVendor) == USB_VID_LITEON &&
+	    le16_to_cpu(adap->dev->udev->descriptor.idProduct) == USB_PID_LITEON_DVB_T_WARM) {
+
+		dibusb_read_eeprom_byte(adap->dev,0x7E,&a);
+		dibusb_read_eeprom_byte(adap->dev,0x7F,&b);
+
+		if (a == 0x00)
+			if1 += b;
+		else if (a == 0x80)
+			if1 -= b;
+		else
+			warn("LITE-ON DVB-T: Strange IF1 calibration :%2X %2X\n", a, b);
+
+	} else if (le16_to_cpu(adap->dev->udev->descriptor.idVendor) == USB_VID_DIBCOM &&
+		   le16_to_cpu(adap->dev->udev->descriptor.idProduct) == USB_PID_DIBCOM_MOD3001_WARM) {
+		u8 desc;
+		dibusb_read_eeprom_byte(adap->dev, 7, &desc);
+		if (desc == 2) {
+			a = 127;
+			do {
+				dibusb_read_eeprom_byte(adap->dev, a, &desc);
+				a--;
+			} while (a > 7 && (desc == 0xff || desc == 0x00));
+			if (desc & 0x80)
+				if1 -= (0xff - desc);
+			else
+				if1 += desc;
+		}
+	}
+
+	tun_i2c = dib3000mc_get_tuner_i2c_master(adap->fe_adap[0].fe, 1);
+	if (dvb_attach(mt2060_attach, adap->fe_adap[0].fe, tun_i2c, &stk3000p_mt2060_config, if1) == NULL) {
+		/* not found - use panasonic pll parameters */
+		if (dvb_attach(dvb_pll_attach, adap->fe_adap[0].fe, 0x60, tun_i2c, DVB_PLL_ENV57H1XD5) == NULL)
+			return -ENOMEM;
+	} else {
+		st->mt2060_present = 1;
+		/* set the correct parameters for the dib3000p */
+		dib3000mc_set_config(adap->fe_adap[0].fe, &stk3000p_dib3000p_config);
+	}
+	return 0;
+}
+EXPORT_SYMBOL(dibusb_dib3000mc_tuner_attach);

