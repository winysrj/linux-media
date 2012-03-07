Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:47335 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030251Ab2CGWIU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2012 17:08:20 -0500
Received: by wgbds11 with SMTP id ds11so1000414wgb.1
        for <linux-media@vger.kernel.org>; Wed, 07 Mar 2012 14:08:18 -0800 (PST)
Message-ID: <1331158090.11482.33.camel@tvbox>
Subject: [PATCH 2/4] lmedm04 ver 1.99 support for m88rs2000 v2
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Wed, 07 Mar 2012 22:08:10 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support for m88rs2000 module.

The driver also attempts to overcome occasional lock problems.

Call backs are now used for read_status, signal level and SNR.


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/lmedm04.c |  274 +++++++++++++++++++++++++----------
 drivers/media/dvb/dvb-usb/lmedm04.h |    1 +
 2 files changed, 197 insertions(+), 78 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index a251583..5dde06d 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -77,6 +77,7 @@
 #include "stv0299.h"
 #include "dvb-pll.h"
 #include "z0194a.h"
+#include "m88rs2000.h"
 


@@ -106,12 +107,14 @@ static int pid_filter;
 module_param_named(pid, pid_filter, int, 0644);
 MODULE_PARM_DESC(pid, "set default 0=default 1=off 2=on");
 
+
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 #define TUNER_DEFAULT	0x0
 #define TUNER_LG	0x1
 #define TUNER_S7395	0x2
 #define TUNER_S0194	0x3
+#define TUNER_RS2000	0x4
 
 struct lme2510_state {
 	u8 id;
@@ -120,6 +123,8 @@ struct lme2510_state {
 	u8 signal_level;
 	u8 signal_sn;
 	u8 time_key;
+	u8 last_key;
+	u8 key_timeout;
 	u8 i2c_talk_onoff;
 	u8 i2c_gate;
 	u8 i2c_tuner_gate_w;
@@ -127,6 +132,7 @@ struct lme2510_state {
 	u8 i2c_tuner_addr;
 	u8 stream_on;
 	u8 pid_size;
+	u8 pid_off;
 	void *buffer;
 	struct urb *lme_urb;
 	void *usb_buffer;
@@ -192,9 +198,14 @@ static int lme2510_usb_talk(struct dvb_usb_device *d,
 
 static int lme2510_stream_restart(struct dvb_usb_device *d)
 {
-	static u8 stream_on[] = LME_ST_ON_W;
+	struct lme2510_state *st = d->priv;
+	u8 all_pids[] = LME_ALL_PIDS;
+	u8 stream_on[] = LME_ST_ON_W;
 	int ret;
-	u8 rbuff[10];
+	u8 rbuff[1];
+	if (st->pid_off)
+		ret = lme2510_usb_talk(d, all_pids, sizeof(all_pids),
+			rbuff, sizeof(rbuff));
 	/*Restart Stream Command*/
 	ret = lme2510_usb_talk(d, stream_on, sizeof(stream_on),
 			rbuff, sizeof(rbuff));
@@ -301,6 +312,14 @@ static void lme2510_int_response(struct urb *lme_urb)
 						((ibuf[2] & 0x01) << 0x03);
 				}
 				break;
+			case TUNER_RS2000:
+				if (ibuf[2] > 0)
+					st->signal_lock = 0xff;
+				else
+					st->signal_lock = 0xf0;
+				st->signal_level = ibuf[4];
+				st->signal_sn = ibuf[5];
+				st->time_key = ibuf[7];
 			default:
 				break;
 			}
@@ -352,19 +371,20 @@ static int lme2510_int_read(struct dvb_usb_adapter *adap)
 static int lme2510_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
 	struct lme2510_state *st = adap->dev->priv;
-	static u8 clear_pid_reg[] = LME_CLEAR_PID;
+	static u8 clear_pid_reg[] = LME_ALL_PIDS;
 	static u8 rbuf[1];
 	int ret;
 
 	deb_info(1, "PID Clearing Filter");
 
-	ret = mutex_lock_interruptible(&adap->dev->i2c_mutex);
-	if (ret < 0)
-		return -EAGAIN;
+	mutex_lock(&adap->dev->i2c_mutex);
 
-	if (!onoff)
+	if (!onoff) {
 		ret |= lme2510_usb_talk(adap->dev, clear_pid_reg,
 			sizeof(clear_pid_reg), rbuf, sizeof(rbuf));
+		st->pid_off = true;
+	} else
+		st->pid_off = false;
 
 	st->pid_size = 0;
 
@@ -382,11 +402,9 @@ static int lme2510_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid,
 		pid, index, onoff);
 
 	if (onoff) {
-			ret = mutex_lock_interruptible(&adap->dev->i2c_mutex);
-			if (ret < 0)
-				return -EAGAIN;
-			ret |= lme2510_enable_pid(adap->dev, index, pid);
-			mutex_unlock(&adap->dev->i2c_mutex);
+		mutex_lock(&adap->dev->i2c_mutex);
+		ret |= lme2510_enable_pid(adap->dev, index, pid);
+		mutex_unlock(&adap->dev->i2c_mutex);
 	}
 

@@ -418,9 +436,6 @@ static int lme2510_msg(struct dvb_usb_device *d,
 	int ret = 0;
 	struct lme2510_state *st = d->priv;
 
-	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
-			return -EAGAIN;
-
 	if (st->i2c_talk_onoff == 1) {
 
 		ret = lme2510_usb_talk(d, wbuf, wlen, rbuf, rlen);
@@ -463,10 +478,12 @@ static int lme2510_msg(struct dvb_usb_device *d,
 				}
 			}
 			break;
+		case TUNER_RS2000:
 		default:
 			break;
 		}
 	} else {
+		/* TODO rewrite this section */
 		switch (st->tuner_config) {
 		case TUNER_LG:
 			switch (wbuf[3]) {
@@ -550,6 +567,24 @@ static int lme2510_msg(struct dvb_usb_device *d,
 				break;
 			}
 			break;
+		case TUNER_RS2000:
+			switch (wbuf[3]) {
+			case 0x8c:
+				rbuf[0] = 0x55;
+				rbuf[1] = 0xff;
+				if (st->last_key == st->time_key) {
+					st->key_timeout++;
+					if (st->key_timeout > 5)
+						rbuf[1] = 0;
+				} else
+					st->key_timeout = 0;
+				st->last_key = st->time_key;
+				break;
+			default:
+				lme2510_usb_talk(d, wbuf, wlen, rbuf, rlen);
+				st->i2c_talk_onoff = 1;
+				break;
+			}
 		default:
 			break;
 		}
@@ -559,8 +594,6 @@ static int lme2510_msg(struct dvb_usb_device *d,
 
 	}
 
-	mutex_unlock(&d->i2c_mutex);
-
 	return ret;
 }
 
@@ -575,6 +608,8 @@ static int lme2510_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 	u16 len;
 	u8 gate = st->i2c_gate;
 
+	mutex_lock(&d->i2c_mutex);
+
 	if (gate == 0)
 		gate = 5;
 
@@ -613,6 +648,7 @@ static int lme2510_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 
 		if (lme2510_msg(d, obuf, len, ibuf, 64) < 0) {
 			deb_info(1, "i2c transfer failed.");
+			mutex_unlock(&d->i2c_mutex);
 			return -EAGAIN;
 		}
 
@@ -625,6 +661,8 @@ static int lme2510_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			}
 		}
 	}
+
+	mutex_unlock(&d->i2c_mutex);
 	return i;
 }
 
@@ -654,7 +692,7 @@ static int lme2510_identify_state(struct usb_device *udev,
 static int lme2510_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
 	struct lme2510_state *st = adap->dev->priv;
-	static u8 clear_reg_3[] = LME_CLEAR_PID;
+	static u8 clear_reg_3[] = LME_ALL_PIDS;
 	static u8 rbuf[1];
 	int ret = 0, rlen = sizeof(rbuf);
 
@@ -666,8 +704,7 @@ static int lme2510_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 	else {
 		deb_info(1, "STM Steam Off");
 		/* mutex is here only to avoid collision with I2C */
-		if (mutex_lock_interruptible(&adap->dev->i2c_mutex) < 0)
-			return -EAGAIN;
+		mutex_lock(&adap->dev->i2c_mutex);
 
 		ret = lme2510_usb_talk(adap->dev, clear_reg_3,
 				sizeof(clear_reg_3), rbuf, rlen);
@@ -772,16 +809,18 @@ static int lme_firmware_switch(struct usb_device *udev, int cold)
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
@@ -804,7 +843,8 @@ static int lme_firmware_switch(struct usb_device *udev, int cold)
 			cold_fw = 0;
 			break;
 		}
-	} else {
+		break;
+	case 0x1120:
 		switch (dvb_usb_lme2510_firmware) {
 		default:
 			dvb_usb_lme2510_firmware = TUNER_S7395;
@@ -833,8 +873,17 @@ static int lme_firmware_switch(struct usb_device *udev, int cold)
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
@@ -897,6 +946,29 @@ static struct stv0299_config sharp_z0194_config = {
 	.set_symbol_rate = sharp_z0194a_set_symbol_rate,
 };
 
+static int dm04_rs2000_set_ts_param(struct dvb_frontend *fe,
+	int caller)
+{
+	struct dvb_usb_adapter *adap = fe->dvb->priv;
+	struct dvb_usb_device *d = adap->dev;
+	struct lme2510_state *st = d->priv;
+
+	mutex_lock(&d->i2c_mutex);
+	if ((st->i2c_talk_onoff == 1) && (st->stream_on & 1)) {
+		st->i2c_talk_onoff = 0;
+		lme2510_stream_restart(d);
+	}
+	mutex_unlock(&d->i2c_mutex);
+
+	return 0;
+}
+
+static struct m88rs2000_config m88rs2000_config = {
+	.demod_addr = 0xd0,
+	.tuner_addr = 0xc0,
+	.set_ts_params = dm04_rs2000_set_ts_param,
+};
+
 static int dm04_lme2510_set_voltage(struct dvb_frontend *fe,
 					fe_sec_voltage_t voltage)
 {
@@ -906,8 +978,7 @@ static int dm04_lme2510_set_voltage(struct dvb_frontend *fe,
 	static u8 rbuf[1];
 	int ret = 0, len = 3, rlen = 1;
 
-	if (mutex_lock_interruptible(&adap->dev->i2c_mutex) < 0)
-			return -EAGAIN;
+	mutex_lock(&adap->dev->i2c_mutex);
 
 	switch (voltage) {
 	case SEC_VOLTAGE_18:
@@ -928,12 +999,31 @@ static int dm04_lme2510_set_voltage(struct dvb_frontend *fe,
 	return (ret < 0) ? -ENODEV : 0;
 }
 
+static int dm04_rs2000_read_signal_strength(struct dvb_frontend *fe,
+	u16 *strength)
+{
+	struct dvb_usb_adapter *adap = fe->dvb->priv;
+	struct lme2510_state *st = adap->dev->priv;
+
+	*strength = (u16)((u32)st->signal_level * 0xffff / 0x7f);
+	return 0;
+}
+
+static int dm04_rs2000_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	struct dvb_usb_adapter *adap = fe->dvb->priv;
+	struct lme2510_state *st = adap->dev->priv;
+
+	*snr = (u16)((u32)st->signal_sn * 0xffff / 0xff);
+	return 0;
+}
+
 static int lme_name(struct dvb_usb_adapter *adap)
 {
 	struct lme2510_state *st = adap->dev->priv;
 	const char *desc = adap->dev->desc->name;
 	char *fe_name[] = {"", " LG TDQY-P001F", " SHARP:BS2F7HZ7395",
-				" SHARP:BS2F7HZ0194"};
+				" SHARP:BS2F7HZ0194", " RS2000"};
 	char *name = adap->fe_adap[0].fe->ops.info.name;
 
 	strlcpy(name, desc, 128);
@@ -949,60 +1039,82 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
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
+			adap->fe_adap[0].fe->ops.read_signal_strength =
+				dm04_rs2000_read_signal_strength;
+			adap->fe_adap[0].fe->ops.read_snr =
+				dm04_rs2000_read_snr;
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
@@ -1019,7 +1131,7 @@ end:	if (ret) {
 static int dm04_lme2510_tuner(struct dvb_usb_adapter *adap)
 {
 	struct lme2510_state *st = adap->dev->priv;
-	char *tun_msg[] = {"", "TDA8263", "IX2505V", "DVB_PLL_OPERA"};
+	char *tun_msg[] = {"", "TDA8263", "IX2505V", "DVB_PLL_OPERA", "RS2000"};
 	int ret = 0;
 
 	switch (st->tuner_config) {
@@ -1038,6 +1150,9 @@ static int dm04_lme2510_tuner(struct dvb_usb_adapter *adap)
 			&adap->dev->i2c_adap, DVB_PLL_OPERA1))
 			ret = st->tuner_config;
 		break;
+	case TUNER_RS2000:
+		ret = st->tuner_config;
+		break;
 	default:
 		break;
 	}
@@ -1066,10 +1181,9 @@ static int lme2510_powerup(struct dvb_usb_device *d, int onoff)
 	static u8 lnb_on[] = LNB_ON;
 	static u8 lnb_off[] = LNB_OFF;
 	static u8 rbuf[1];
-	int ret, len = 3, rlen = 1;
+	int ret = 0, len = 3, rlen = 1;
 
-	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
-		return -EAGAIN;
+	mutex_lock(&d->i2c_mutex);
 
 	if (onoff)
 		ret = lme2510_usb_talk(d, lnb_on, len, rbuf, rlen);
@@ -1127,6 +1241,7 @@ static int lme2510_probe(struct usb_interface *intf,
 static struct usb_device_id lme2510_table[] = {
 	{ USB_DEVICE(0x3344, 0x1122) },  /* LME2510 */
 	{ USB_DEVICE(0x3344, 0x1120) },  /* LME2510C */
+	{ USB_DEVICE(0x3344, 0x22f0) },  /* LME2510C RS2000 */
 	{}		/* Terminating entry */
 };
 
@@ -1144,7 +1259,7 @@ static struct dvb_usb_device_properties lme2510_properties = {
 				DVB_USB_ADAP_NEED_PID_FILTERING|
 				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
 			.streaming_ctrl   = lme2510_streaming_ctrl,
-			.pid_filter_count = 15,
+			.pid_filter_count = 32,
 			.pid_filter = lme2510_pid_filter,
 			.pid_filter_ctrl  = lme2510_pid_filter_ctrl,
 			.frontend_attach  = dm04_lme2510_frontend_attach,
@@ -1195,7 +1310,7 @@ static struct dvb_usb_device_properties lme2510c_properties = {
 				DVB_USB_ADAP_NEED_PID_FILTERING|
 				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
 			.streaming_ctrl   = lme2510_streaming_ctrl,
-			.pid_filter_count = 15,
+			.pid_filter_count = 32,
 			.pid_filter = lme2510_pid_filter,
 			.pid_filter_ctrl  = lme2510_pid_filter_ctrl,
 			.frontend_attach  = dm04_lme2510_frontend_attach,
@@ -1225,11 +1340,14 @@ static struct dvb_usb_device_properties lme2510c_properties = {
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
 
@@ -1286,5 +1404,5 @@ module_usb_driver(lme2510_driver);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("LME2510(C) DVB-S USB2.0");
-MODULE_VERSION("1.98");
+MODULE_VERSION("1.99");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb/dvb-usb/lmedm04.h b/drivers/media/dvb/dvb-usb/lmedm04.h
index ab21e2e..e9c2072 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.h
+++ b/drivers/media/dvb/dvb-usb/lmedm04.h
@@ -41,6 +41,7 @@
 #define LME_ST_ON_W	{0x06, 0x00}
 #define LME_CLEAR_PID   {0x03, 0x02, 0x20, 0xa0}
 #define LME_ZERO_PID	{0x03, 0x06, 0x00, 0x00, 0x01, 0x00, 0x20, 0x9c}
+#define LME_ALL_PIDS	{0x03, 0x06, 0x00, 0xff, 0x01, 0x1f, 0x20, 0x81}
 
 /*  LNB Voltage
  *  07 XX XX
-- 
1.7.9





