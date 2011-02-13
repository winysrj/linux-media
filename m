Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59585 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab1BMBfP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Feb 2011 20:35:15 -0500
Received: by wwa36 with SMTP id 36so3814484wwa.1
        for <linux-media@vger.kernel.org>; Sat, 12 Feb 2011 17:35:13 -0800 (PST)
Subject: [PATCH 1/2] v180 - DM04/QQBOX added support for BS2F7HZ0194
 versions
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Feb 2011 01:35:08 +0000
Message-ID: <1297560908.24985.5.camel@tvboxspy>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Old versions of these boxes have the BS2F7HZ0194 tuner module on
both the LME2510 and LME2510C.

Firmware dvb-usb-lme2510-s0194.fw  and/or dvb-usb-lme2510c-s0194.fw
files are required.

See Documentation/dvb/lmedm04.txt

Patch 535181 is also required.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/lmedm04.c |  230 ++++++++++++++++++++++++++---------
 1 files changed, 170 insertions(+), 60 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index c58d3fc..cd26e7c 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -2,7 +2,9 @@
  *
  * DM04/QQBOX DVB-S USB BOX	LME2510C + SHARP:BS2F7HZ7395
  *				LME2510C + LG TDQY-P001F
+ *				LME2510C + BS2F7HZ0194
  *				LME2510 + LG TDQY-P001F
+ *				LME2510 + BS2F7HZ0194
  *
  * MVB7395 (LME2510C+SHARP:BS2F7HZ7395)
  * SHARP:BS2F7HZ7395 = (STV0288+Sharp IX2505V)
@@ -12,20 +14,22 @@
  *
  * MVB0001F (LME2510C+LGTDQT-P001F)
  *
+ * MV0194 (LME2510+SHARP:BS2F7HZ0194)
+ * SHARP:BS2F7HZ0194 = (STV0299+IX2410)
+ *
+ * MVB0194 (LME2510C+SHARP0194)
+ *
  * For firmware see Documentation/dvb/lmedm04.txt
  *
  * I2C addresses:
  * 0xd0 - STV0288	- Demodulator
  * 0xc0 - Sharp IX2505V	- Tuner
- * --or--
+ * --
  * 0x1c - TDA10086   - Demodulator
  * 0xc0 - TDA8263    - Tuner
- *
- * ***Please Note***
- *		There are other variants of the DM04
- *		***NOT SUPPORTED***
- *		MV0194 (LME2510+SHARP0194)
- *		MVB0194 (LME2510C+SHARP0194)
+ * --
+ * 0xd0 - STV0299	- Demodulator
+ * 0xc0 - IX2410	- Tuner
  *
  *
  * VID = 3344  PID LME2510=1122 LME2510C=1120
@@ -55,6 +59,9 @@
  *
  * QQbox suffers from noise on LNB voltage.
  *
+ *	LME2510: SHARP:BS2F7HZ0194(MV0194) cannot cold reset and share system
+ * with other tuners. After a cold reset streaming will not start.
+ *
  *	PID functions have been removed from this driver version due to
  * problems with different firmware and application versions.
  */
@@ -69,6 +76,9 @@
 #include "tda10086.h"
 #include "stv0288.h"
 #include "ix2505v.h"
+#include "stv0299.h"
+#include "dvb-pll.h"
+#include "z0194a.h"
 
 
 
@@ -96,8 +106,11 @@ MODULE_PARM_DESC(firmware, "set default firmware 0=Sharp7395 1=LG");
 
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
+#define TUNER_DEFAULT	0x0
 #define TUNER_LG	0x1
 #define TUNER_S7395	0x2
+#define TUNER_S0194	0x3
 
 struct lme2510_state {
 	u8 id;
@@ -250,6 +263,7 @@ static void lme2510_int_response(struct urb *lme_urb)
 				st->time_key = ibuf[7];
 				break;
 			case TUNER_S7395:
+			case TUNER_S0194:
 				/* Tweak for earlier firmware*/
 				if (ibuf[1] == 0x03) {
 					if (ibuf[2] > 1)
@@ -365,6 +379,18 @@ static int lme2510_msg(struct dvb_usb_device *d,
 					msleep(5);
 			}
 			break;
+		case TUNER_S0194:
+			if (wbuf[2] == 0xd0) {
+				if (wbuf[3] == 0x1b) {
+					st->signal_lock = rbuf[1];
+					if ((st->stream_on & 1) &&
+						(st->signal_lock & 0x8)) {
+						lme2510_stream_restart(d);
+						st->i2c_talk_onoff = 0;
+					}
+				}
+			}
+			break;
 		default:
 			break;
 		}
@@ -424,6 +450,34 @@ static int lme2510_msg(struct dvb_usb_device *d,
 				break;
 			}
 			break;
+		case TUNER_S0194:
+			switch (wbuf[3]) {
+			case 0x18:
+				rbuf[0] = 0x55;
+				rbuf[1] = (st->signal_level & 0x80)
+						? 0 : (st->signal_level * 2);
+				break;
+			case 0x24:
+				rbuf[0] = 0x55;
+				rbuf[1] = st->signal_sn;
+				break;
+			case 0x1b:
+				rbuf[0] = 0x55;
+				rbuf[1] = st->signal_lock;
+				break;
+			case 0x19:
+			case 0x25:
+			case 0x1e:
+			case 0x1d:
+				rbuf[0] = 0x55;
+				rbuf[1] = 0x00;
+				break;
+			default:
+				lme2510_usb_talk(d, wbuf, wlen, rbuf, rlen);
+				st->i2c_talk_onoff = 1;
+				break;
+			}
+			break;
 		default:
 			break;
 		}
@@ -518,17 +572,14 @@ static int lme2510_identify_state(struct usb_device *udev,
 		struct dvb_usb_device_description **desc,
 		int *cold)
 {
-	if (lme2510_return_status(udev) == 0x44)
-		*cold = 1;
-	else
-		*cold = 0;
+	*cold = 0;
 	return 0;
 }
 
 static int lme2510_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
 	struct lme2510_state *st = adap->dev->priv;
-	static u8 clear_reg_3[] =  LME_CLEAR_PID;
+	static u8 clear_reg_3[] = LME_CLEAR_PID;
 	static u8 rbuf[1];
 	int ret = 0, rlen = sizeof(rbuf);
 
@@ -659,9 +710,6 @@ static int lme2510_download_firmware(struct usb_device *dev,
 	return (ret < 0) ? -ENODEV : 0;
 }
 
-/* Default firmware for LME2510C */
-char lme_firmware[50] = "dvb-usb-lme2510c-s7395.fw";
-
 static void lme_coldreset(struct usb_device *dev)
 {
 	int ret = 0, len_in;
@@ -679,49 +727,83 @@ static void lme_coldreset(struct usb_device *dev)
 static int lme_firmware_switch(struct usb_device *udev, int cold)
 {
 	const struct firmware *fw = NULL;
-	char lme2510c_s7395[] = "dvb-usb-lme2510c-s7395.fw";
-	char lme2510c_lg[] = "dvb-usb-lme2510c-lg.fw";
-	char *firm_msg[] = {"Loading", "Switching to"};
-	int ret;
+	const char fw_c_s7395[] = "dvb-usb-lme2510c-s7395.fw";
+	const char fw_c_lg[] = "dvb-usb-lme2510c-lg.fw";
+	const char fw_c_s0194[] = "dvb-usb-lme2510c-s0194.fw";
+	const char fw_lg[] = "dvb-usb-lme2510-lg.fw";
+	const char fw_s0194[] = "dvb-usb-lme2510-s0194.fw";
+	const char *fw_lme;
+	int ret, cold_fw;
 
 	cold = (cold > 0) ? (cold & 1) : 0;
 
-	if (udev->descriptor.idProduct == 0x1122)
-		return 0;
+	cold_fw = !cold;
 
-	switch (dvb_usb_lme2510_firmware) {
-	case 0:
-	default:
-		memcpy(&lme_firmware, lme2510c_s7395, sizeof(lme2510c_s7395));
-		ret = request_firmware(&fw, lme_firmware, &udev->dev);
-		if (ret == 0) {
-			info("FRM %s S7395 Firmware", firm_msg[cold]);
+	if (udev->descriptor.idProduct == 0x1122) {
+		switch (dvb_usb_lme2510_firmware) {
+		default:
+			dvb_usb_lme2510_firmware = TUNER_S0194;
+		case TUNER_S0194:
+			fw_lme = fw_s0194;
+			ret = request_firmware(&fw, fw_lme, &udev->dev);
+			if (ret == 0) {
+				cold = 0;/*lme2510-s0194 cannot cold reset*/
+				break;
+			}
+			dvb_usb_lme2510_firmware = TUNER_LG;
+		case TUNER_LG:
+			fw_lme = fw_lg;
+			ret = request_firmware(&fw, fw_lme, &udev->dev);
+			if (ret == 0)
+				break;
+			info("FRM No Firmware Found - please install");
+			dvb_usb_lme2510_firmware = TUNER_DEFAULT;
+			cold = 0;
+			cold_fw = 0;
 			break;
 		}
-		if (cold == 0)
-			dvb_usb_lme2510_firmware = 1;
-		else
+	} else {
+		switch (dvb_usb_lme2510_firmware) {
+		default:
+			dvb_usb_lme2510_firmware = TUNER_S7395;
+		case TUNER_S7395:
+			fw_lme = fw_c_s7395;
+			ret = request_firmware(&fw, fw_lme, &udev->dev);
+			if (ret == 0)
+				break;
+			dvb_usb_lme2510_firmware = TUNER_LG;
+		case TUNER_LG:
+			fw_lme = fw_c_lg;
+			ret = request_firmware(&fw, fw_lme, &udev->dev);
+			if (ret == 0)
+				break;
+			dvb_usb_lme2510_firmware = TUNER_S0194;
+		case TUNER_S0194:
+			fw_lme = fw_c_s0194;
+			ret = request_firmware(&fw, fw_lme, &udev->dev);
+			if (ret == 0)
+				break;
+			info("FRM No Firmware Found - please install");
+			dvb_usb_lme2510_firmware = TUNER_DEFAULT;
 			cold = 0;
-	case 1:
-		memcpy(&lme_firmware, lme2510c_lg, sizeof(lme2510c_lg));
-		ret = request_firmware(&fw, lme_firmware, &udev->dev);
-		if (ret == 0) {
-			info("FRM %s LG Firmware", firm_msg[cold]);
+			cold_fw = 0;
 			break;
 		}
-		info("FRM No Firmware Found - please install");
-		dvb_usb_lme2510_firmware = 0;
-		cold = 0;
-		break;
 	}
 
-	release_firmware(fw);
+	if (cold_fw) {
+		info("FRM Loading %s file", fw_lme);
+		ret = lme2510_download_firmware(udev, fw);
+	}
 
 	if (cold) {
+		info("FRM Changing to %s firmware", fw_lme);
 		lme_coldreset(udev);
 		return -ENODEV;
 	}
 
+	release_firmware(fw);
+
 	return ret;
 }
 
@@ -759,6 +841,18 @@ static struct ix2505v_config lme_tuner = {
 	.tuner_chargepump = 0x3,
 };
 
+static struct stv0299_config sharp_z0194_config = {
+	.demod_address = 0xd0,
+	.inittab = sharp_z0194a_inittab,
+	.mclk = 88000000UL,
+	.invert = 0,
+	.skip_reinit = 0,
+	.lock_output = STV0299_LOCKOUTPUT_1,
+	.volt13_op0_op1 = STV0299_VOLT13_OP1,
+	.min_delay_ms = 100,
+	.set_symbol_rate = sharp_z0194a_set_symbol_rate,
+};
+
 static int dm04_lme2510_set_voltage(struct dvb_frontend *fe,
 					fe_sec_voltage_t voltage)
 {
@@ -794,7 +888,8 @@ static int lme_name(struct dvb_usb_adapter *adap)
 {
 	struct lme2510_state *st = adap->dev->priv;
 	const char *desc = adap->dev->desc->name;
-	char *fe_name[] = {"", " LG TDQY-P001F", " SHARP:BS2F7HZ7395"};
+	char *fe_name[] = {"", " LG TDQY-P001F", " SHARP:BS2F7HZ7395",
+				" SHARP:BS2F7HZ0194"};
 	char *name = adap->fe->ops.info.name;
 
 	strlcpy(name, desc, 128);
@@ -821,26 +916,40 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
 		st->i2c_tuner_gate_r = 4;
 		st->i2c_tuner_addr = 0xc0;
 		st->tuner_config = TUNER_LG;
-		if (dvb_usb_lme2510_firmware != 1) {
-			dvb_usb_lme2510_firmware = 1;
+		if (dvb_usb_lme2510_firmware != TUNER_LG) {
+			dvb_usb_lme2510_firmware = TUNER_LG;
 			ret = lme_firmware_switch(adap->dev->udev, 1);
-		} else /*stops LG/Sharp multi tuner problems*/
-			dvb_usb_lme2510_firmware = 0;
+		}
+		goto end;
+	}
+
+	st->i2c_gate = 4;
+	adap->fe = dvb_attach(stv0299_attach, &sharp_z0194_config,
+			&adap->dev->i2c_adap);
+	if (adap->fe) {
+		info("FE Found Stv0299");
+		st->i2c_tuner_gate_w = 4;
+		st->i2c_tuner_gate_r = 5;
+		st->i2c_tuner_addr = 0xc0;
+		st->tuner_config = TUNER_S0194;
+		if (dvb_usb_lme2510_firmware != TUNER_S0194) {
+			dvb_usb_lme2510_firmware = TUNER_S0194;
+			ret = lme_firmware_switch(adap->dev->udev, 1);
+		}
 		goto end;
 	}
 
 	st->i2c_gate = 5;
 	adap->fe = dvb_attach(stv0288_attach, &lme_config,
 			&adap->dev->i2c_adap);
-
 	if (adap->fe) {
 		info("FE Found Stv0288");
 		st->i2c_tuner_gate_w = 4;
 		st->i2c_tuner_gate_r = 5;
 		st->i2c_tuner_addr = 0xc0;
 		st->tuner_config = TUNER_S7395;
-		if (dvb_usb_lme2510_firmware != 0) {
-			dvb_usb_lme2510_firmware = 0;
+		if (dvb_usb_lme2510_firmware != TUNER_S7395) {
+			dvb_usb_lme2510_firmware = TUNER_S7395;
 			ret = lme_firmware_switch(adap->dev->udev, 1);
 		}
 	} else {
@@ -848,6 +957,7 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
 		return -ENODEV;
 	}
 
+
 end:	if (ret) {
 		kfree(adap->fe);
 		adap->fe = NULL;
@@ -856,14 +966,13 @@ end:	if (ret) {
 
 	adap->fe->ops.set_voltage = dm04_lme2510_set_voltage;
 	ret = lme_name(adap);
-
 	return ret;
 }
 
 static int dm04_lme2510_tuner(struct dvb_usb_adapter *adap)
 {
 	struct lme2510_state *st = adap->dev->priv;
-	char *tun_msg[] = {"", "TDA8263", "IX2505V"};
+	char *tun_msg[] = {"", "TDA8263", "IX2505V", "DVB_PLL_OPERA"};
 	int ret = 0;
 
 	switch (st->tuner_config) {
@@ -877,6 +986,11 @@ static int dm04_lme2510_tuner(struct dvb_usb_adapter *adap)
 			&adap->dev->i2c_adap))
 			ret = st->tuner_config;
 		break;
+	case TUNER_S0194:
+		if (dvb_attach(dvb_pll_attach , adap->fe, 0xc0,
+			&adap->dev->i2c_adap, DVB_PLL_OPERA1))
+			ret = st->tuner_config;
+		break;
 	default:
 		break;
 	}
@@ -937,7 +1051,10 @@ static int lme2510_probe(struct usb_interface *intf,
 		return -ENODEV;
 	}
 
-	lme_firmware_switch(udev, 0);
+	if (lme2510_return_status(udev) == 0x44) {
+		lme_firmware_switch(udev, 0);
+		return -ENODEV;
+	}
 
 	if (0 == dvb_usb_device_init(intf, &lme2510_properties,
 				     THIS_MODULE, NULL, adapter_nr)) {
@@ -965,10 +1082,6 @@ MODULE_DEVICE_TABLE(usb, lme2510_table);
 
 static struct dvb_usb_device_properties lme2510_properties = {
 	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
-	.usb_ctrl = DEVICE_SPECIFIC,
-	.download_firmware = lme2510_download_firmware,
-	.firmware = "dvb-usb-lme2510-lg.fw",
-
 	.size_of_priv = sizeof(struct lme2510_state),
 	.num_adapters = 1,
 	.adapter = {
@@ -1005,9 +1118,6 @@ static struct dvb_usb_device_properties lme2510_properties = {
 
 static struct dvb_usb_device_properties lme2510c_properties = {
 	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
-	.usb_ctrl = DEVICE_SPECIFIC,
-	.download_firmware = lme2510_download_firmware,
-	.firmware = (const char *)&lme_firmware,
 	.size_of_priv = sizeof(struct lme2510_state),
 	.num_adapters = 1,
 	.adapter = {
@@ -1110,5 +1220,5 @@ module_exit(lme2510_module_exit);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("LME2510(C) DVB-S USB2.0");
-MODULE_VERSION("1.76");
+MODULE_VERSION("1.80");
 MODULE_LICENSE("GPL");
-- 
1.7.1

