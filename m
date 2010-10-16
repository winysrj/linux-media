Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63572 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab0JPTpD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Oct 2010 15:45:03 -0400
Received: by wyb28 with SMTP id 28so1762491wyb.19
        for <linux-media@vger.kernel.org>; Sat, 16 Oct 2010 12:45:01 -0700 (PDT)
Subject: [PATCH][UPDATE for 2.6.37] LME2510(C) DM04/QQBOX USB DVB-S BOXES
From: tvbox <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Oct 2010 20:44:43 +0100
Message-ID: <1287258283.494.10.camel@canaries-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Updated driver for DM04/QQBOX USB DVB-S BOXES to version 1.60

These include
-later kill of usb_buffer to avoid kernel crash on hot unplugging.
-DiSEqC functions.
-LNB Power switch
-Faster channel change.
-support for LG tuner on LME2510C.
-firmware switching for LG tuner.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>



diff --git a/Documentation/dvb/lmedm04.txt b/Documentation/dvb/lmedm04.txt
index 4bde457..e175784 100644
--- a/Documentation/dvb/lmedm04.txt
+++ b/Documentation/dvb/lmedm04.txt
@@ -45,10 +45,13 @@ and run
 
 Other LG firmware can be extracted manually from US280D.sys
 only found in windows/system32/driver.
-However, this firmware does not run very well under Windows
-or with the Linux driver.
 
-dd if=US280D.sys ibs=1 skip=36856 count=3976 of=dvb-usb-lme2510-lg.fw
+dd if=US280D.sys ibs=1 skip=42616 count=3668 of=dvb-usb-lme2510-lg.fw
+
+for DM04 LME2510C (LG Tuner)
+---------------------------
+
+dd if=US280D.sys ibs=1 skip=35200 count=3850 of=dvb-usb-lme2510c-lg.fw
 
 ---------------------------------------------------------------------
 
diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index ce60c1e..2525d3b 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -356,6 +356,5 @@ config DVB_USB_LME2510
 	select DVB_TDA826X if !DVB_FE_CUSTOMISE
 	select DVB_STV0288 if !DVB_FE_CUSTOMISE
 	select DVB_IX2505V if !DVB_FE_CUSTOMISE
-	depends on IR_CORE
 	help
 	  Say Y here to support the LME DM04/QQBOX DVB-S USB2.0 .
diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index d5374ac..d939fbb 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -1,14 +1,17 @@
 /* DVB USB compliant linux driver for
  *
  * DM04/QQBOX DVB-S USB BOX	LME2510C + SHARP:BS2F7HZ7395
- *				LME2510 + LGTDQT-P001F
+ *				LME2510C + LG TDQY-P001F
+ *				LME2510 + LG TDQY-P001F
  *
  * MVB7395 (LME2510C+SHARP:BS2F7HZ7395)
  * SHARP:BS2F7HZ7395 = (STV0288+Sharp IX2505V)
  *
- * MV001F (LME2510 +LGTDQY-P001F)
+ * MV001F (LME2510+LGTDQY-P001F)
  * LG TDQY - P001F =(TDA8263 + TDA10086H)
  *
+ * MVB0001F (LME2510C+LGTDQT-P001F)
+ *
  * For firmware see Documentation/dvb/lmedm04.txt
  *
  * I2C addresses:
@@ -21,7 +24,6 @@
  * ***Please Note***
  *		There are other variants of the DM04
  *		***NOT SUPPORTED***
- *		MVB0001F (LME2510C+LGTDQT-P001F)
  *		MV0194 (LME2510+SHARP0194)
  *		MVB0194 (LME2510C+SHARP0194)
  *
@@ -51,10 +53,7 @@
  *	LME2510: Non Intel USB chipsets fail to maintain High Speed on
  * Boot or Hot Plug.
  *
- *	DiSEqC functions are not fully supported in this driver. The main
- * reason is the frontend is cut off during streaming. Allowing frontend
- * access will stall the driver. Applications that attempt to this, the
- * commands are ignored.
+ * QQbox suffers from noise on LNB voltage.
  *
  *	PID functions have been removed from this driver version due to
  * problems with different firmware and application versions.
@@ -91,9 +90,14 @@ module_param_named(debug, dvb_usb_lme2510_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=info (or-able))."
 			DVB_USB_DEBUG_STATUS);
 
+static int dvb_usb_lme2510_firmware;
+module_param_named(firmware, dvb_usb_lme2510_firmware, int, 0644);
+MODULE_PARM_DESC(firmware, "set default firmware 0=Sharp7395 1=LG");
+
+
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
-#define TUNER_LG 0x1
-#define TUNER_S7395 0x2
+#define TUNER_LG	0x1
+#define TUNER_S7395	0x2
 
 struct lme2510_state {
 	u8 id;
@@ -107,6 +111,8 @@ struct lme2510_state {
 	u8 i2c_tuner_gate_w;
 	u8 i2c_tuner_gate_r;
 	u8 i2c_tuner_addr;
+	u8 stream_on;
+	u8 one_tune;
 	void *buffer;
 	struct urb *lme_urb;
 	void *usb_buffer;
@@ -117,6 +123,7 @@ static int lme2510_bulk_write(struct usb_device *dev,
 				u8 *snd, int len, u8 pipe)
 {
 	int ret, actual_l;
+
 	ret = usb_bulk_msg(dev, usb_sndbulkpipe(dev, pipe),
 				snd, len , &actual_l, 500);
 	return ret;
@@ -151,22 +158,21 @@ static int lme2510_usb_talk(struct dvb_usb_device *d,
 	/* the read/write capped at 512 */
 	memcpy(buff, wbuf, (wlen > 512) ? 512 : wlen);
 
-
 	ret = mutex_lock_interruptible(&d->usb_mutex);
 
 	if (ret < 0)
 		return -EAGAIN;
 
 	ret |= usb_clear_halt(d->udev, usb_sndbulkpipe(d->udev, 0x01));
-	msleep(5);
-	ret |= lme2510_bulk_write(d->udev, buff, wlen , 0x1);
 
-	msleep(5);
-	ret |= usb_clear_halt(d->udev, usb_rcvbulkpipe(d->udev, 0x1));
+	ret |= lme2510_bulk_write(d->udev, buff, wlen , 0x01);
+
+	msleep(12);
+
+	ret |= usb_clear_halt(d->udev, usb_rcvbulkpipe(d->udev, 0x01));
 
-	msleep(5);
 	ret |= lme2510_bulk_read(d->udev, buff, (rlen > 512) ?
-			512 : rlen , 0x1);
+			512 : rlen , 0x01);
 
 	if (rlen > 0)
 		memcpy(rbuf, buff, rlen);
@@ -176,6 +182,18 @@ static int lme2510_usb_talk(struct dvb_usb_device *d,
 	return (ret < 0) ? -ENODEV : 0;
 }
 
+static int lme2510_usb_talk_restart(struct dvb_usb_device *d,
+		u8 *wbuf, int wlen, u8 *rbuf, int rlen) {
+	static u8 stream_on[] = LME_ST_ON_W;
+	int ret;
+	u8 rbuff[10];
+	/*Send Normal Command*/
+	ret = lme2510_usb_talk(d, wbuf, wlen, rbuf, rlen);
+	/*Restart Stream Command*/
+	ret |= lme2510_usb_talk(d, stream_on, sizeof(stream_on),
+			rbuff, sizeof(rbuff));
+	return ret;
+}
 static int lme2510_remote_keypress(struct dvb_usb_adapter *adap, u16 keypress)
 {
 	struct dvb_usb_device *d = adap->dev;
@@ -213,7 +231,6 @@ static void lme2510_int_response(struct urb *lme_urb)
 	offset = ((lme_urb->actual_length/8) > 4)
 			? 4 : (lme_urb->actual_length/8) ;
 
-
 	for (i = 0; i < offset; ++i) {
 		ibuf = (u8 *)&rbuf[i*8];
 		deb_info(5, "INT O/S C =%02x C/O=%02x Type =%02x%02x",
@@ -228,7 +245,8 @@ static void lme2510_int_response(struct urb *lme_urb)
 		case 0xbb:
 			switch (st->tuner_config) {
 			case TUNER_LG:
-				st->signal_lock = ibuf[2];
+				if (ibuf[2] > 0)
+					st->signal_lock = ibuf[2];
 				st->signal_level = ibuf[4];
 				st->signal_sn = ibuf[3];
 				st->time_key = ibuf[7];
@@ -237,7 +255,7 @@ static void lme2510_int_response(struct urb *lme_urb)
 				/* Tweak for earlier firmware*/
 				if (ibuf[1] == 0x03) {
 					st->signal_level = ibuf[3];
-					st->signal_sn = ibuf[2];
+					st->signal_sn = ibuf[4];
 				} else {
 					st->signal_level = ibuf[4];
 					st->signal_sn = ibuf[5];
@@ -295,6 +313,7 @@ static int lme2510_return_status(struct usb_device *dev)
 {
 	int ret = 0;
 	u8 data[10] = {0};
+
 	ret |= usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
 			0x06, 0x80, 0x0302, 0x00, data, 0x0006, 200);
 	info("Firmware Status: %x (%x)", ret , data[2]);
@@ -308,25 +327,48 @@ static int lme2510_msg(struct dvb_usb_device *d,
 	int ret = 0;
 	struct lme2510_state *st = d->priv;
 
-	if (st->i2c_talk_onoff == 1) {
-		if ((wbuf[2] == 0x1c) & (wbuf[3] == 0x0e))
-			msleep(80); /*take your time when waiting for tune*/
-
-		if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
+	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
 			return -EAGAIN;
 
+	if (st->i2c_talk_onoff == 1) {
+
 		ret = lme2510_usb_talk(d, wbuf, wlen, rbuf, rlen);
 
-		mutex_unlock(&d->i2c_mutex);
 		switch (st->tuner_config) {
+		case TUNER_LG:
+			if (wbuf[2] == 0x1c) {
+				if (wbuf[3] == 0x0e) {
+					st->signal_lock = rbuf[1];
+					if ((st->stream_on & 1) &&
+						(st->signal_lock & 0x10)) {
+						lme2510_usb_talk_restart(d,
+							wbuf, wlen, rbuf, rlen);
+						st->i2c_talk_onoff = 0;
+					}
+				msleep(80);
+				}
+			}
+			break;
 		case TUNER_S7395:
-			if (wbuf[3] == 0x24)
-				st->signal_lock = rbuf[1];
+			if (wbuf[2] == 0xd0) {
+				if (wbuf[3] == 0x24) {
+					st->signal_lock = rbuf[1];
+					if ((st->stream_on & 1) &&
+						(st->signal_lock & 0x8)) {
+						lme2510_usb_talk_restart(d,
+							wbuf, wlen, rbuf, rlen);
+						st->i2c_talk_onoff = 0;
+					}
+				}
+				if ((wbuf[3] != 0x6) & (wbuf[3] != 0x5))
+					msleep(5);
+
+
+			}
 			break;
 		default:
 			break;
 		}
-
 	} else {
 		switch (st->tuner_config) {
 		case TUNER_LG:
@@ -343,6 +385,17 @@ static int lme2510_msg(struct dvb_usb_device *d,
 				rbuf[0] = 0x55;
 				rbuf[1] = st->signal_sn;
 				break;
+			/*DiSEqC functions as per TDA10086*/
+			case 0x36:
+			case 0x48:
+			case 0x49:
+			case 0x4a:
+			case 0x4b:
+			case 0x4c:
+			case 0x4d:
+			if (wbuf[2] == 0x1c)
+					lme2510_usb_talk_restart(d,
+						wbuf, wlen, rbuf, rlen);
 			default:
 				break;
 			}
@@ -362,7 +415,31 @@ static int lme2510_msg(struct dvb_usb_device *d,
 				rbuf[0] = 0x55;
 				rbuf[1] = (st->signal_level & 0x80)
 						? 0 : st->signal_lock;
+				break;
+			case 0x6:
+				if (wbuf[2] == 0xd0)
+					lme2510_usb_talk(d,
+						wbuf, wlen, rbuf, rlen);
+				break;
+			case 0x1:
+				if (st->one_tune > 0)
+					break;
+				st->one_tune++;
+				st->i2c_talk_onoff = 1;
+			/*DiSEqC functions as per STV0288*/
+			case 0x5:
+			case 0x7:
+			case 0x8:
+			case 0x9:
+			case 0xa:
+			case 0xb:
+				if (wbuf[2] == 0xd0)
+					lme2510_usb_talk_restart(d,
+						wbuf, wlen, rbuf, rlen);
+				break;
 			default:
+				rbuf[0] = 0x55;
+				rbuf[1] = 0x00;
 				break;
 			}
 			break;
@@ -376,6 +453,8 @@ static int lme2510_msg(struct dvb_usb_device *d,
 
 	}
 
+	mutex_unlock(&d->i2c_mutex);
+
 	return ret;
 }
 
@@ -469,29 +548,34 @@ static int lme2510_identify_state(struct usb_device *udev,
 static int lme2510_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
 	struct lme2510_state *st = adap->dev->priv;
-	static u8 reset[] =  LME_RESET;
 	static u8 stream_on[] = LME_ST_ON_W;
 	static u8 clear_reg_3[] =  LME_CLEAR_PID;
 	static u8 rbuf[1];
+	static u8 timeout;
 	int ret = 0, len = 2, rlen = sizeof(rbuf);
 
 	deb_info(1, "STM  (%02x)", onoff);
 
 	if (onoff == 1)	{
 		st->i2c_talk_onoff = 0;
-		msleep(400); /* give enough time for i2c to stop */
+		timeout = 0;
+		/* wait for i2C to be free */
+		while (mutex_lock_interruptible(&adap->dev->i2c_mutex) < 0) {
+			timeout++;
+			if (timeout > 5)
+				return -ENODEV;
+		}
+		msleep(100);
 		ret |= lme2510_usb_talk(adap->dev,
 				 stream_on,  len, rbuf, rlen);
+		st->stream_on = 1;
+		st->one_tune = 0;
+		mutex_unlock(&adap->dev->i2c_mutex);
 	} else {
 		deb_info(1, "STM Steam Off");
-		if  (st->tuner_config == TUNER_LG)
-			ret |= lme2510_usb_talk(adap->dev, clear_reg_3,
+		ret |= lme2510_usb_talk(adap->dev, clear_reg_3,
 				sizeof(clear_reg_3), rbuf, rlen);
-		else
-			ret |= lme2510_usb_talk(adap->dev,
-				 reset, sizeof(reset), rbuf, rlen);
-
-		msleep(400);
+		st->stream_on = 0;
 		st->i2c_talk_onoff = 1;
 	}
 
@@ -604,6 +688,63 @@ static int lme2510_download_firmware(struct usb_device *dev,
 	return (ret < 0) ? -ENODEV : 0;
 }
 
+/* Default firmware for LME2510C */
+const char lme_firmware[50] = "dvb-usb-lme2510c-s7395.fw";
+
+static void lme_coldreset(struct usb_device *dev)
+{
+	int ret = 0, len_in;
+	u8 data[512] = {0};
+
+	data[0] = 0x0a;
+	len_in = 1;
+	info("FRM Firmware Cold Reset");
+	ret |= lme2510_bulk_write(dev, data , len_in, 1); /*Cold Resetting*/
+	ret |= lme2510_bulk_read(dev, data, len_in, 1);
+	return;
+}
+
+static void lme_firmware_switch(struct usb_device *udev, int cold)
+{
+	const struct firmware *fw = NULL;
+	char lme2510c_s7395[] = "dvb-usb-lme2510c-s7395.fw";
+	char lme2510c_lg[] = "dvb-usb-lme2510c-lg.fw";
+	char *firm_msg[] = {"Loading", "Switching to"};
+	int ret;
+
+	if (udev->descriptor.idProduct == 0x1122)
+		return;
+
+	switch (dvb_usb_lme2510_firmware) {
+	case 0:
+	default:
+		memcpy(&lme_firmware, lme2510c_s7395, sizeof(lme2510c_s7395));
+		ret = request_firmware(&fw, lme_firmware, &udev->dev);
+		if (ret == 0) {
+			info("FRM %s S7395 Firmware", firm_msg[cold]);
+			break;
+		}
+		if (cold == 0)
+			dvb_usb_lme2510_firmware = 1;
+		else
+			cold = 0;
+	case 1:
+		memcpy(&lme_firmware, lme2510c_lg, sizeof(lme2510c_lg));
+		ret = request_firmware(&fw, lme_firmware, &udev->dev);
+		if (ret == 0) {
+			info("FRM %s LG Firmware", firm_msg[cold]);
+			break;
+		}
+		info("FRM No Firmware Found - please install");
+		dvb_usb_lme2510_firmware = 0;
+		cold = 0;
+		break;
+	}
+	release_firmware(fw);
+	if (cold)
+		lme_coldreset(udev);
+	return;
+}
 
 static int lme2510_kill_urb(struct usb_data_stream *stream)
 {
@@ -638,7 +779,6 @@ static struct ix2505v_config lme_tuner = {
 	.tuner_chargepump = 0x3,
 };
 
-
 static int dm04_lme2510_set_voltage(struct dvb_frontend *fe,
 					fe_sec_voltage_t voltage)
 {
@@ -646,35 +786,28 @@ static int dm04_lme2510_set_voltage(struct dvb_frontend *fe,
 	struct lme2510_state *st = adap->dev->priv;
 	static u8 voltage_low[]	= LME_VOLTAGE_L;
 	static u8 voltage_high[] = LME_VOLTAGE_H;
-	static u8 reset[] = LME_RESET;
-	static u8 clear_reg_3[] =  LME_CLEAR_PID;
+	static u8 lnb_on[] = LNB_ON;
+	static u8 lnb_off[] = LNB_OFF;
 	static u8 rbuf[1];
 	int ret = 0, len = 3, rlen = 1;
 
-	msleep(100);
-
-	if  (st->tuner_config == TUNER_LG)
-		ret |= lme2510_usb_talk(adap->dev, clear_reg_3,
-			sizeof(clear_reg_3), rbuf, rlen);
-	else
-		ret |= lme2510_usb_talk(adap->dev,
-			 reset, sizeof(reset), rbuf, rlen);
-
-	/*always check & stop streaming*/
-	lme2510_kill_urb(&adap->stream);
-	adap->feedcount = 0;
+	if (st->stream_on == 1)
+		return 0;
 
-		switch (voltage) {
+	ret |= lme2510_usb_talk(adap->dev, lnb_on, len, rbuf, rlen);
 
-		case SEC_VOLTAGE_18:
-			ret |= lme2510_usb_talk(adap->dev,
-				voltage_high, len, rbuf, rlen);
+	switch (voltage) {
+	case SEC_VOLTAGE_18:
+		ret |= lme2510_usb_talk(adap->dev,
+			voltage_high, len, rbuf, rlen);
 		break;
 
-		case SEC_VOLTAGE_OFF:
-		case SEC_VOLTAGE_13:
-		default:
-			ret |= lme2510_usb_talk(adap->dev,
+	case SEC_VOLTAGE_OFF:
+		ret |= lme2510_usb_talk(adap->dev,
+					lnb_off, len, rbuf, rlen);
+	case SEC_VOLTAGE_13:
+	default:
+		ret |= lme2510_usb_talk(adap->dev,
 				voltage_low, len, rbuf, rlen);
 		break;
 
@@ -714,6 +847,10 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
 			&adap->dev->i2c_adap, 1)) {
 			info("TUN TDA8263 Found");
 			st->tuner_config = TUNER_LG;
+			if (dvb_usb_lme2510_firmware != 1) {
+				dvb_usb_lme2510_firmware = 1;
+				lme_firmware_switch(adap->dev->udev, 1);
+			}
 			return 0;
 		}
 		kfree(adap->fe);
@@ -735,6 +872,10 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
 					&adap->dev->i2c_adap)) {
 			st->tuner_config = TUNER_S7395;
 			info("TUN Sharp IX2505V silicon tuner");
+			if (dvb_usb_lme2510_firmware != 0) {
+				dvb_usb_lme2510_firmware = 0;
+				lme_firmware_switch(adap->dev->udev, 1);
+			}
 			return 0;
 		}
 		kfree(adap->fe);
@@ -772,6 +913,8 @@ static int lme2510_probe(struct usb_interface *intf,
 		return -ENODEV;
 	}
 
+	lme_firmware_switch(udev, 0);
+
 	if (0 == dvb_usb_device_init(intf, &lme2510_properties,
 				     THIS_MODULE, NULL, adapter_nr)) {
 		info("DEV registering device driver");
@@ -839,7 +982,7 @@ static struct dvb_usb_device_properties lme2510c_properties = {
 	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
 	.usb_ctrl = DEVICE_SPECIFIC,
 	.download_firmware = lme2510_download_firmware,
-	.firmware = "dvb-usb-lme2510c-s7395.fw",
+	.firmware = lme_firmware,
 	.size_of_priv = sizeof(struct lme2510_state),
 	.num_adapters = 1,
 	.adapter = {
@@ -849,7 +992,7 @@ static struct dvb_usb_device_properties lme2510c_properties = {
 			/* parameter for the MPEG2-data transfer */
 			.stream = {
 				.type = USB_BULK,
-				.count = 8,
+				.count = 10,
 				.endpoint = 0x8,
 				.u = {
 					.bulk = {
@@ -872,15 +1015,23 @@ static struct dvb_usb_device_properties lme2510c_properties = {
 	}
 };
 
-void lme2510_exit_int(struct dvb_usb_device *d)
+void *lme2510_exit_int(struct dvb_usb_device *d)
 {
 	struct lme2510_state *st = d->priv;
+	struct dvb_usb_adapter *adap = &d->adapter[0];
+	void *buffer = NULL;
+
+	if (adap != NULL) {
+		lme2510_kill_urb(&adap->stream);
+		adap->feedcount = 0;
+	}
+
 	if (st->lme_urb != NULL) {
-		st->i2c_talk_onoff = 0;
+		st->i2c_talk_onoff = 1;
 		st->signal_lock = 0;
 		st->signal_level = 0;
 		st->signal_sn = 0;
-		kfree(st->usb_buffer);
+		buffer = st->usb_buffer;
 		usb_kill_urb(st->lme_urb);
 		usb_free_coherent(d->udev, 5000, st->buffer,
 				  st->lme_urb->transfer_dma);
@@ -888,18 +1039,19 @@ void lme2510_exit_int(struct dvb_usb_device *d)
 		ir_input_unregister(d->rc_input_dev);
 		info("Remote Stopped");
 	}
-	return;
+	return buffer;
 }
 
 void lme2510_exit(struct usb_interface *intf)
 {
 	struct dvb_usb_device *d = usb_get_intfdata(intf);
+	void *usb_buffer;
+
 	if (d != NULL) {
-		d->adapter[0].feedcount = 0;
-		lme2510_exit_int(d);
+		usb_buffer = lme2510_exit_int(d);
 		dvb_usb_device_exit(intf);
+		kfree(usb_buffer);
 	}
-
 }
 
 static struct usb_driver lme2510_driver = {
@@ -932,5 +1084,5 @@ module_exit(lme2510_module_exit);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("LM2510(C) DVB-S USB2.0");
-MODULE_VERSION("1.4");
+MODULE_VERSION("1.60");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb/dvb-usb/lmedm04.h b/drivers/media/dvb/dvb-usb/lmedm04.h
index 5a66c7e..e6af16c 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.h
+++ b/drivers/media/dvb/dvb-usb/lmedm04.h
@@ -1,14 +1,16 @@
 /* DVB USB compliant linux driver for
  *
  * DM04/QQBOX DVB-S USB BOX	LME2510C + SHARP:BS2F7HZ7395
- *				LME2510C + LGTDQT-P001F
+ *				LME2510C + LG TDQY-P001F
+ *				LME2510 + LG TDQY-P001F
  *
  * MVB7395 (LME2510C+SHARP:BS2F7HZ7395)
  * SHARP:BS2F7HZ7395 = (STV0288+Sharp IX2505V)
  *
- * MVB0001F (LME2510C+LGTDQT-P001F)
+ * MVB001F (LME2510+LGTDQT-P001F)
  * LG TDQY - P001F =(TDA8263 + TDA10086H)
  *
+ * MVB0001F (LME2510C+LGTDQT-P001F)
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
@@ -35,35 +37,33 @@
  *  end byte -1 = 20
  *  end byte = clear pid always a0, other wise 9c, 9a ??
  *
- *  RESET (also clears PID filter)
- *  3a 01 00
 */
 #define LME_ST_ON_W	{0x06, 0x00}
-#define LME_RESET   {0x3a, 0x01, 0x00}
 #define LME_CLEAR_PID   {0x03, 0x02, 0x20, 0xa0}
 
-
-/* LME Power Control
+/*  LNB Voltage
  *  07 XX XX
- *  offset 1 = 01  Power? my device cannot be powered down
+ *  offset 1 = 01
  *  offset 2 = 00=Voltage low 01=Voltage high
+ *
+ *  LNB Power
+ *  03 01 XX
+ *  offset 2 = 00=ON 01=OFF
  */
 
 #define LME_VOLTAGE_L	{0x07, 0x01, 0x00}
 #define LME_VOLTAGE_H	{0x07, 0x01, 0x01}
-
+#define LNB_ON		{0x3a, 0x01, 0x00}
+#define LNB_OFF		{0x3a, 0x01, 0x01}
 
 /* Initial stv0288 settings for 7395 Frontend */
 static u8 s7395_inittab[] = {
-	0x00, 0x11,
 	0x01, 0x15,
 	0x02, 0x20,
-	0x03, 0x8e,
-	0x04, 0x8e,
+	0x03, 0xa0,
+	0x04, 0xa0,
 	0x05, 0x12,
-	0x06, 0xff,
-	0x07, 0x20,
-	0x08, 0x00,
+	0x06, 0x00,
 	0x09, 0x00,
 	0x0a, 0x04,
 	0x0b, 0x00,
@@ -71,7 +71,6 @@ static u8 s7395_inittab[] = {
 	0x0d, 0x00,
 	0x0e, 0xc1,
 	0x0f, 0x54,
-	0x10, 0x40,
 	0x11, 0x7a,
 	0x12, 0x03,
 	0x13, 0x48,
@@ -84,23 +83,15 @@ static u8 s7395_inittab[] = {
 	0x1a, 0x88,
 	0x1b, 0x8f,
 	0x1c, 0xf0,
-	0x1e, 0x80,
 	0x20, 0x0b,
 	0x21, 0x54,
 	0x22, 0xff,
 	0x23, 0x01,
-	0x24, 0x9a,
-	0x25, 0x7f,
-	0x26, 0x00,
-	0x27, 0x00,
 	0x28, 0x46,
 	0x29, 0x66,
 	0x2a, 0x90,
 	0x2b, 0xfa,
 	0x2c, 0xd9,
-	0x2d, 0x02,
-	0x2e, 0xb1,
-	0x2f, 0x00,
 	0x30, 0x0,
 	0x31, 0x1e,
 	0x32, 0x14,
@@ -115,8 +106,6 @@ static u8 s7395_inittab[] = {
 	0x3b, 0x13,
 	0x3c, 0x11,
 	0x3d, 0x30,
-	0x3e, 0x00,
-	0x3f, 0x00,
 	0x40, 0x63,
 	0x41, 0x04,
 	0x42, 0x60,
@@ -126,8 +115,6 @@ static u8 s7395_inittab[] = {
 	0x46, 0x00,
 	0x47, 0x00,
 	0x4a, 0x00,
-	0x4b, 0xd1,
-	0x4c, 0x33,
 	0x50, 0x12,
 	0x51, 0x36,
 	0x52, 0x21,
@@ -183,5 +170,4 @@ static u8 s7395_inittab[] = {
 	0xf2, 0xc0,
 	0xff, 0xff,
 };
-
 #endif



