Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:50878 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab2AVKqg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Jan 2012 05:46:36 -0500
Received: by wics10 with SMTP id s10so1469369wic.19
        for <linux-media@vger.kernel.org>; Sun, 22 Jan 2012 02:46:35 -0800 (PST)
Message-ID: <1327229189.2540.9.camel@tvbox>
Subject: [PATCH 2/3] lmedm04 ver 1.95 support m88rs2000 demodulator/tuner
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Sun, 22 Jan 2012 10:46:29 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Support for m88rs2000 module.

Driver also defaults PID filter to off due to problems.

The driver also attempts to overcome problems with occasional
lock problems.

 Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/media/dvb/dvb-usb/lmedm04.c |  218 +++++++++++++++++++++++++----------
 1 files changed, 158 insertions(+), 60 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index 767c87f..6c46ca7 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -77,6 +77,7 @@
 #include "stv0299.h"
 #include "dvb-pll.h"
 #include "z0194a.h"
+#include "m88rs2000.h"
 


@@ -104,7 +105,7 @@ MODULE_PARM_DESC(firmware, "set default firmware 0=Sharp7395 1=LG");
 
 static int pid_filter;
 module_param_named(pid, pid_filter, int, 0644);
-MODULE_PARM_DESC(pid, "set default 0=on 1=off");
+MODULE_PARM_DESC(pid, "set default 0=default 1=off 2=on");
 

 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
@@ -113,6 +114,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 #define TUNER_LG	0x1
 #define TUNER_S7395	0x2
 #define TUNER_S0194	0x3
+#define TUNER_RS2000	0x4
 
 struct lme2510_state {
 	u8 id;
@@ -121,6 +123,8 @@ struct lme2510_state {
 	u8 signal_level;
 	u8 signal_sn;
 	u8 time_key;
+	u8 last_key;
+	u8 key_timeout;
 	u8 i2c_talk_onoff;
 	u8 i2c_gate;
 	u8 i2c_tuner_gate_w;
@@ -308,6 +312,14 @@ static void lme2510_int_response(struct urb *lme_urb)
 						((ibuf[2] & 0x01) << 0x03);
 				}
 				break;
+			case TUNER_RS2000:
+				if (ibuf[2] > 0)
+					st->signal_lock = 0xff;
+				else
+					st->signal_lock = 0xf0;
+				st->signal_level = ibuf[5];
+				st->signal_sn = ibuf[4];
+				st->time_key = ibuf[7];
 			default:
 				break;
 			}
@@ -389,11 +401,11 @@ static int lme2510_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid,
 		pid, index, onoff);
 
 	if (onoff) {
-			ret = mutex_lock_interruptible(&adap->dev->i2c_mutex);
-			if (ret < 0)
-				return -EAGAIN;
-			ret |= lme2510_enable_pid(adap->dev, index, pid);
-			mutex_unlock(&adap->dev->i2c_mutex);
+		ret = mutex_lock_interruptible(&adap->dev->i2c_mutex);
+		if (ret < 0)
+			return -EAGAIN;
+		ret |= lme2510_enable_pid(adap->dev, index, pid);
+		mutex_unlock(&adap->dev->i2c_mutex);
 	}
 

@@ -472,10 +484,24 @@ static int lme2510_msg(struct dvb_usb_device *d,
 				}
 			}
 			break;
+		case TUNER_RS2000:
+			if (wbuf[2] == 0xd0) {
+				if (wbuf[3] == 0x8c) {
+					st->signal_lock = rbuf[1];
+					if ((st->stream_on & 1) &&
+						(st->signal_lock & 0xee)) {
+						lme2510_stream_restart(d);
+						st->i2c_talk_onoff = 0;
+					}
+				}
+			}
+			break;
 		default:
 			break;
 		}
 	} else {
+		/* TODO rewrite this section */
+		msleep(50);
 		switch (st->tuner_config) {
 		case TUNER_LG:
 			switch (wbuf[3]) {
@@ -559,6 +585,36 @@ static int lme2510_msg(struct dvb_usb_device *d,
 				break;
 			}
 			break;
+		case TUNER_RS2000:
+			switch (wbuf[3]) {
+			case 0x8c:
+				rbuf[0] = 0x55;
+				rbuf[1] = st->signal_lock;
+				if (st->last_key == st->time_key) {
+					if (st->key_timeout > 10)
+						rbuf[1] = 0;
+					else if (st->key_timeout > 5)
+						lme2510_stream_restart(d);
+					st->key_timeout++;
+				} else
+					st->key_timeout = 0;
+				st->last_key = st->time_key;
+				break;
+			case 0x65:
+				rbuf[0] = 0x55;
+				rbuf[1] = st->signal_sn;
+				break;
+			case 0x21:
+				rbuf[0] = 0x55;
+				rbuf[1] = st->signal_level;
+				break;
+			case 0x22:
+				break;
+			default:
+				lme2510_usb_talk(d, wbuf, wlen, rbuf, rlen);
+				st->i2c_talk_onoff = 1;
+				break;
+			}
 		default:
 			break;
 		}
@@ -653,7 +709,7 @@ static int lme2510_identify_state(struct usb_device *udev,
 		struct dvb_usb_device_description **desc,
 		int *cold)
 {
-	if (pid_filter > 0)
+	if (pid_filter != 2)
 		props->adapter[0].fe[0].caps &=
 			~DVB_USB_ADAP_NEED_PID_FILTERING;
 	*cold = 0;
@@ -781,16 +837,18 @@ static int lme_firmware_switch(struct usb_device *udev, int cold)
 	const char fw_c_s7395[] = "dvb-usb-lme2510c-s7395.fw";
 	const char fw_c_lg[] = "dvb-usb-lme2510c-lg.fw";
 	const char fw_c_s0194[] = "dvb-usb-lme2510c-s0194.fw";
+	const char fw_c_rs2000[] = "dvb-usb-lme2510c-rs2000.fw";
 	const char fw_lg[] = "dvb-usb-lme2510-lg.fw";
 	const char fw_s0194[] = "dvb-usb-lme2510-s0194.fw";
 	const char *fw_lme;
-	int ret, cold_fw;
+	int ret = 0, cold_fw;
 
 	cold = (cold > 0) ? (cold & 1) : 0;
 
 	cold_fw = !cold;
 
-	if (le16_to_cpu(udev->descriptor.idProduct) == 0x1122) {
+	switch (le16_to_cpu(udev->descriptor.idProduct)) {
+	case 0x1122:
 		switch (dvb_usb_lme2510_firmware) {
 		default:
 			dvb_usb_lme2510_firmware = TUNER_S0194;
@@ -813,7 +871,8 @@ static int lme_firmware_switch(struct usb_device *udev, int cold)
 			cold_fw = 0;
 			break;
 		}
-	} else {
+		break;
+	case 0x1120:
 		switch (dvb_usb_lme2510_firmware) {
 		default:
 			dvb_usb_lme2510_firmware = TUNER_S7395;
@@ -842,8 +901,17 @@ static int lme_firmware_switch(struct usb_device *udev, int cold)
 			cold_fw = 0;
 			break;
 		}
+		break;
+	case 0x22f0:
+		fw_lme = fw_c_rs2000;
+		ret = request_firmware(&fw, fw_lme, &udev->dev);
+		dvb_usb_lme2510_firmware = TUNER_RS2000;
+		break;
+	default:
+		fw_lme = fw_c_s7395;
 	}
 
+
 	if (cold_fw) {
 		info("FRM Loading %s file", fw_lme);
 		ret = lme2510_download_firmware(udev, fw);
@@ -906,6 +974,11 @@ static struct stv0299_config sharp_z0194_config = {
 	.set_symbol_rate = sharp_z0194a_set_symbol_rate,
 };
 
+static struct m88rs2000_config m88rs2000_config = {
+	.demod_addr = 0xd0,
+	.tuner_addr = 0xc0,
+};
+
 static int dm04_lme2510_set_voltage(struct dvb_frontend *fe,
 					fe_sec_voltage_t voltage)
 {
@@ -942,7 +1015,7 @@ static int lme_name(struct dvb_usb_adapter *adap)
 	struct lme2510_state *st = adap->dev->priv;
 	const char *desc = adap->dev->desc->name;
 	char *fe_name[] = {"", " LG TDQY-P001F", " SHARP:BS2F7HZ7395",
-				" SHARP:BS2F7HZ0194"};
+				" SHARP:BS2F7HZ0194", " RS2000"};
 	char *name = adap->fe_adap[0].fe->ops.info.name;
 
 	strlcpy(name, desc, 128);
@@ -958,60 +1031,78 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
 	int ret = 0;
 
 	st->i2c_talk_onoff = 1;
+	switch (le16_to_cpu(adap->dev->udev->descriptor.idProduct)) {
+	case 0x1122:
+	case 0x1120:
+		st->i2c_gate = 4;
+		adap->fe_adap[0].fe = dvb_attach(tda10086_attach,
+			&tda10086_config, &adap->dev->i2c_adap);
+		if (adap->fe_adap[0].fe) {
+			info("TUN Found Frontend TDA10086");
+			st->i2c_tuner_gate_w = 4;
+			st->i2c_tuner_gate_r = 4;
+			st->i2c_tuner_addr = 0xc0;
+			st->tuner_config = TUNER_LG;
+			if (dvb_usb_lme2510_firmware != TUNER_LG) {
+				dvb_usb_lme2510_firmware = TUNER_LG;
+				ret = lme_firmware_switch(adap->dev->udev, 1);
+			}
+			break;
+		}
 
-	st->i2c_gate = 4;
-	adap->fe_adap[0].fe = dvb_attach(tda10086_attach, &tda10086_config,
-		&adap->dev->i2c_adap);
-
-	if (adap->fe_adap[0].fe) {
-		info("TUN Found Frontend TDA10086");
-		st->i2c_tuner_gate_w = 4;
-		st->i2c_tuner_gate_r = 4;
-		st->i2c_tuner_addr = 0xc0;
-		st->tuner_config = TUNER_LG;
-		if (dvb_usb_lme2510_firmware != TUNER_LG) {
-			dvb_usb_lme2510_firmware = TUNER_LG;
-			ret = lme_firmware_switch(adap->dev->udev, 1);
+		st->i2c_gate = 4;
+		adap->fe_adap[0].fe = dvb_attach(stv0299_attach,
+				&sharp_z0194_config, &adap->dev->i2c_adap);
+		if (adap->fe_adap[0].fe) {
+			info("FE Found Stv0299");
+			st->i2c_tuner_gate_w = 4;
+			st->i2c_tuner_gate_r = 5;
+			st->i2c_tuner_addr = 0xc0;
+			st->tuner_config = TUNER_S0194;
+			if (dvb_usb_lme2510_firmware != TUNER_S0194) {
+				dvb_usb_lme2510_firmware = TUNER_S0194;
+				ret = lme_firmware_switch(adap->dev->udev, 1);
+			}
+			break;
 		}
-		goto end;
-	}
 
-	st->i2c_gate = 4;
-	adap->fe_adap[0].fe = dvb_attach(stv0299_attach, &sharp_z0194_config,
+		st->i2c_gate = 5;
+		adap->fe_adap[0].fe = dvb_attach(stv0288_attach, &lme_config,
 			&adap->dev->i2c_adap);
-	if (adap->fe_adap[0].fe) {
-		info("FE Found Stv0299");
-		st->i2c_tuner_gate_w = 4;
-		st->i2c_tuner_gate_r = 5;
-		st->i2c_tuner_addr = 0xc0;
-		st->tuner_config = TUNER_S0194;
-		if (dvb_usb_lme2510_firmware != TUNER_S0194) {
-			dvb_usb_lme2510_firmware = TUNER_S0194;
-			ret = lme_firmware_switch(adap->dev->udev, 1);
+
+		if (adap->fe_adap[0].fe) {
+			info("FE Found Stv0288");
+			st->i2c_tuner_gate_w = 4;
+			st->i2c_tuner_gate_r = 5;
+			st->i2c_tuner_addr = 0xc0;
+			st->tuner_config = TUNER_S7395;
+			if (dvb_usb_lme2510_firmware != TUNER_S7395) {
+				dvb_usb_lme2510_firmware = TUNER_S7395;
+				ret = lme_firmware_switch(adap->dev->udev, 1);
+			}
+			break;
 		}
-		goto end;
-	}
+	case 0x22f0:
+		st->i2c_gate = 5;
+		adap->fe_adap[0].fe = dvb_attach(m88rs2000_attach,
+			&m88rs2000_config, &adap->dev->i2c_adap);
 
-	st->i2c_gate = 5;
-	adap->fe_adap[0].fe = dvb_attach(stv0288_attach, &lme_config,
-			&adap->dev->i2c_adap);
-	if (adap->fe_adap[0].fe) {
-		info("FE Found Stv0288");
-		st->i2c_tuner_gate_w = 4;
-		st->i2c_tuner_gate_r = 5;
-		st->i2c_tuner_addr = 0xc0;
-		st->tuner_config = TUNER_S7395;
-		if (dvb_usb_lme2510_firmware != TUNER_S7395) {
-			dvb_usb_lme2510_firmware = TUNER_S7395;
-			ret = lme_firmware_switch(adap->dev->udev, 1);
+		if (adap->fe_adap[0].fe) {
+			info("FE Found M88RS2000");
+			st->i2c_tuner_gate_w = 5;
+			st->i2c_tuner_gate_r = 5;
+			st->i2c_tuner_addr = 0xc0;
+			st->tuner_config = TUNER_RS2000;
 		}
-	} else {
-		info("DM04 Not Supported");
-		return -ENODEV;
+		break;
 	}
 
+	if (adap->fe_adap[0].fe == NULL) {
+			info("DM04/QQBOX Not Powered up or not Supported");
+			return -ENODEV;
+	}
 
-end:	if (ret) {
+	if (ret) {
 		if (adap->fe_adap[0].fe) {
 			dvb_frontend_detach(adap->fe_adap[0].fe);
 			adap->fe_adap[0].fe = NULL;
@@ -1028,7 +1119,7 @@ end:	if (ret) {
 static int dm04_lme2510_tuner(struct dvb_usb_adapter *adap)
 {
 	struct lme2510_state *st = adap->dev->priv;
-	char *tun_msg[] = {"", "TDA8263", "IX2505V", "DVB_PLL_OPERA"};
+	char *tun_msg[] = {"", "TDA8263", "IX2505V", "DVB_PLL_OPERA", "RS2000"};
 	int ret = 0;
 
 	switch (st->tuner_config) {
@@ -1047,6 +1138,9 @@ static int dm04_lme2510_tuner(struct dvb_usb_adapter *adap)
 			&adap->dev->i2c_adap, DVB_PLL_OPERA1))
 			ret = st->tuner_config;
 		break;
+	case TUNER_RS2000:
+		ret = st->tuner_config;
+		break;
 	default:
 		break;
 	}
@@ -1136,6 +1230,7 @@ static int lme2510_probe(struct usb_interface *intf,
 static struct usb_device_id lme2510_table[] = {
 	{ USB_DEVICE(0x3344, 0x1122) },  /* LME2510 */
 	{ USB_DEVICE(0x3344, 0x1120) },  /* LME2510C */
+	{ USB_DEVICE(0x3344, 0x22f0) },  /* LME2510C RS2000 */
 	{}		/* Terminating entry */
 };
 
@@ -1153,7 +1248,7 @@ static struct dvb_usb_device_properties lme2510_properties = {
 				DVB_USB_ADAP_NEED_PID_FILTERING|
 				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
 			.streaming_ctrl   = lme2510_streaming_ctrl,
-			.pid_filter_count = 15,
+			.pid_filter_count = 32,
 			.pid_filter = lme2510_pid_filter,
 			.pid_filter_ctrl  = lme2510_pid_filter_ctrl,
 			.frontend_attach  = dm04_lme2510_frontend_attach,
@@ -1204,7 +1299,7 @@ static struct dvb_usb_device_properties lme2510c_properties = {
 				DVB_USB_ADAP_NEED_PID_FILTERING|
 				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
 			.streaming_ctrl   = lme2510_streaming_ctrl,
-			.pid_filter_count = 15,
+			.pid_filter_count = 32,
 			.pid_filter = lme2510_pid_filter,
 			.pid_filter_ctrl  = lme2510_pid_filter_ctrl,
 			.frontend_attach  = dm04_lme2510_frontend_attach,
@@ -1234,11 +1329,14 @@ static struct dvb_usb_device_properties lme2510c_properties = {
 	.identify_state   = lme2510_identify_state,
 	.i2c_algo         = &lme2510_i2c_algo,
 	.generic_bulk_ctrl_endpoint = 0,
-	.num_device_descs = 1,
+	.num_device_descs = 2,
 	.devices = {
 		{   "DM04_LME2510C_DVB-S",
 			{ &lme2510_table[1], NULL },
 			},
+		{   "DM04_LME2510C_DVB-S RS2000",
+			{ &lme2510_table[2], NULL },
+			},
 	}
 };
 
@@ -1314,5 +1412,5 @@ module_exit(lme2510_module_exit);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("LME2510(C) DVB-S USB2.0");
-MODULE_VERSION("1.91");
+MODULE_VERSION("1.95");
 MODULE_LICENSE("GPL");
-- 
1.7.8.3



