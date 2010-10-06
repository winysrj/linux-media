Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61972 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759452Ab0JFT6O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 15:58:14 -0400
Received: by wyb28 with SMTP id 28so7594530wyb.19
        for <linux-media@vger.kernel.org>; Wed, 06 Oct 2010 12:58:13 -0700 (PDT)
Subject: [PATCH]UPDATE for LME2510(C) DM04/QQBOX USB DVB-S BOXES.
From: tvbox <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 20:58:06 +0100
Message-ID: <1286395086.28238.17.camel@canaries-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Updated driver for DM04/QQBOX USB DVB-S BOXES to version 1.50

These include
-later kill of usb_buffer to avoid kernel crash on hot unplugging.
-DiSEqC functions.
-LNB Power switch
-Faster channel change.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

http://mercurial.intuxication.org/hg/tvboxspy/summary

---

diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index 794b16d..3569e34 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -51,10 +51,7 @@
  * 	LME2510: Non Intel USB chipsets fail to maintain High Speed on
  * Boot or Hot Plug.
  *
- *	DiSEqC functions are not fully supported in this driver. The main
- * reason is the frontend is cut off during streaming. Allowing frontend
- * access will stall the driver. Applications that attempt to this, the
- * commands are ignored.
+ * QQbox suffers from noise on LNB voltage.
  *
  *	PID functions mave been removed from this driver version due to
  * problems with different firmware and application versions.
@@ -154,15 +151,15 @@ static int lme2510_usb_talk(struct dvb_usb_device *d,
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
@@ -172,6 +169,19 @@ static int lme2510_usb_talk(struct dvb_usb_device *d,
 	return (ret < 0) ? -ENODEV : 0;
 }
 
+static int lme2510_usb_talk_restart(struct dvb_usb_device *d,
+		u8 *wbuf, int wlen, u8 *rbuf, int rlen) {
+	static u8 stream_on[] = LME_ST_ON_W;
+	int ret;
+	u8 rbuff[1];
+	/*Send Normal Command*/
+	ret = lme2510_usb_talk(d, wbuf, wlen, rbuf, rlen);
+	/*Restart Stream Command*/
+	ret |= lme2510_usb_talk(d, stream_on, sizeof(stream_on),
+			rbuff, sizeof(rbuff));
+	return ret;
+}
+
 static int lme2510_remote_keypress(struct dvb_usb_adapter *adap, u16 keypress)
 {
 	struct dvb_usb_device *d = adap->dev;
@@ -233,7 +243,7 @@ static void lme2510_int_response(struct urb *lme_urb)
 				/* Tweak for earlier firmware*/
 				if (ibuf[1] == 0x03) {
 					st->signal_level = ibuf[3];
-					st->signal_sn = ibuf[2];
+					st->signal_sn = ibuf[4];
 				} else {
 					st->signal_level = ibuf[4];
 					st->signal_sn = ibuf[5];
@@ -318,6 +328,7 @@ static int lme2510_msg(struct dvb_usb_device *d,
 		case TUNER_S7395:
 			if (wbuf[3] == 0x24)
 				st->signal_lock = rbuf[1];
+			msleep(5);
 			break;
 		default:
 			break;
@@ -358,6 +369,18 @@ static int lme2510_msg(struct dvb_usb_device *d,
 				rbuf[0] = 0x55;
 				rbuf[1] = (st->signal_level & 0x80)
 						? 0 : st->signal_lock;
+				break;
+			/*DiSEqC functions as per STV0288*/
+			case 0x5:
+			case 0x6:
+			case 0x7:
+			case 0x8:
+			case 0x9:
+			case 0xa:
+			case 0xb:
+				if (wbuf[2] == 0xd0)
+					lme2510_usb_talk_restart(d,
+						wbuf, wlen, rbuf, rlen);
 			default:
 				break;
 			}
@@ -472,7 +495,6 @@ static int lme2510_identify_state(struct usb_device *udev,
 static int lme2510_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
 	struct lme2510_state *st = adap->dev->priv;
-	static u8 reset[] =  LME_RESET;
 	static u8 stream_on[] = LME_ST_ON_W;
 	static u8 clear_reg_3[] =  LME_CLEAR_PID;
 	static u8 rbuf[1];
@@ -481,19 +503,14 @@ static int lme2510_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 
 	if (onoff == 1)	{
 		st->i2c_talk_onoff = 0;
-		msleep(400); /* give enough time for i2c to stop */
+		msleep(40); /* give enough time for i2c to stop */
 		ret |= lme2510_usb_talk(adap->dev,
 				 stream_on,  len, rbuf, rlen);
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
+		msleep(40);
 		st->i2c_talk_onoff = 1;
 	}
 
@@ -640,7 +657,6 @@ static struct ix2505v_config lme_tuner = {
 	.tuner_chargepump = 0x3,
 };
 
-
 static int dm04_lme2510_set_voltage(struct dvb_frontend *fe,
 					fe_sec_voltage_t voltage)
 {
@@ -648,19 +664,12 @@ static int dm04_lme2510_set_voltage(struct dvb_frontend *fe,
 	struct lme2510_state *st = adap->dev->priv;
 	static u8 voltage_low[]	= LME_VOLTAGE_L;
 	static u8 voltage_high[] = LME_VOLTAGE_H;
-	static u8 reset[] = LME_RESET;
-	static u8 clear_reg_3[] =  LME_CLEAR_PID;
+	static u8 lnb_on[] = LNB_ON;
+	static u8 lnb_off[] = LNB_OFF;
 	static u8 rbuf[1];
 	int ret = 0, len = 3, rlen = 1;
 	msleep(100);
 
-	if  (st->tuner_config == TUNER_LG)
-		ret |= lme2510_usb_talk(adap->dev, clear_reg_3,
-			sizeof(clear_reg_3), rbuf, rlen);
-	else
-		ret |= lme2510_usb_talk(adap->dev,
-			 reset, sizeof(reset), rbuf, rlen);
-
 	/*always check & stop streaming*/
 	lme2510_kill_urb(&adap->stream);
 	adap->feedcount = 0;
@@ -668,13 +677,24 @@ static int dm04_lme2510_set_voltage(struct dvb_frontend *fe,
 		switch (voltage) {
 
 		case SEC_VOLTAGE_18:
+			if  (st->tuner_config == TUNER_S7395)
+				ret |= lme2510_usb_talk(adap->dev,
+					lnb_on, len, rbuf, rlen);
 			ret |= lme2510_usb_talk(adap->dev,
 				voltage_high, len, rbuf, rlen);
 		break;
 
 		case SEC_VOLTAGE_OFF:
+			if  (st->tuner_config == TUNER_S7395) {
+				ret |= lme2510_usb_talk(adap->dev,
+					lnb_off, len, rbuf, rlen);
+				break;
+			}
 		case SEC_VOLTAGE_13:
 		default:
+			if  (st->tuner_config == TUNER_S7395)
+				ret |= lme2510_usb_talk(adap->dev,
+					lnb_on, len, rbuf, rlen);
 			ret |= lme2510_usb_talk(adap->dev,
 				voltage_low, len, rbuf, rlen);
 		break;
@@ -873,15 +893,23 @@ static struct dvb_usb_device_properties lme2510c_properties = {
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
 		usb_buffer_free(d->udev, 5000, st->buffer,
 				st->lme_urb->transfer_dma);
@@ -889,18 +917,19 @@ void lme2510_exit_int(struct dvb_usb_device *d)
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
@@ -933,5 +962,5 @@ module_exit(lme2510_module_exit);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("LM2510(C) DVB-S USB2.0");
-MODULE_VERSION("1.4");
+MODULE_VERSION("1.50");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb/dvb-usb/lmedm04.h b/drivers/media/dvb/dvb-usb/lmedm04.h
index da7947f..cd8299a 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.h
+++ b/drivers/media/dvb/dvb-usb/lmedm04.h
@@ -1,12 +1,12 @@
 /* DVB USB compliant linux driver for
  *
  * DM04/QQBOX DVB-S USB BOX	LME2510C + SHARP:BS2F7HZ7395
- * 				LME2510C + LGTDQT-P001F
+ * 				LME2510 + LGTDQT-P001F
  *
  * MVB7395 (LME2510C+SHARP:BS2F7HZ7395)
  * SHARP:BS2F7HZ7395 = (STV0288+Sharp IX2505V)
  *
- * MVB0001F (LME2510C+LGTDQT-P001F)
+ * MVB001F (LME2510+LGTDQT-P001F)
  * LG TDQY - P001F =(TDA8263 + TDA10086H)
  *
  *
@@ -35,35 +35,33 @@
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
@@ -71,7 +69,6 @@ static u8 s7395_inittab[] = {
 	0x0d, 0x00,
 	0x0e, 0xc1,
 	0x0f, 0x54,
-	0x10, 0x40,
 	0x11, 0x7a,
 	0x12, 0x03,
 	0x13, 0x48,
@@ -84,23 +81,15 @@ static u8 s7395_inittab[] = {
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
@@ -115,8 +104,6 @@ static u8 s7395_inittab[] = {
 	0x3b, 0x13,
 	0x3c, 0x11,
 	0x3d, 0x30,
-	0x3e, 0x00,
-	0x3f, 0x00,
 	0x40, 0x63,
 	0x41, 0x04,
 	0x42, 0x60,
@@ -126,8 +113,6 @@ static u8 s7395_inittab[] = {
 	0x46, 0x00,
 	0x47, 0x00,
 	0x4a, 0x00,
-	0x4b, 0xd1,
-	0x4c, 0x33,
 	0x50, 0x12,
 	0x51, 0x36,
 	0x52, 0x21,
@@ -183,5 +168,4 @@ static u8 s7395_inittab[] = {
 	0xf2, 0xc0,
 	0xff, 0xff,
 };
-
 #endif

