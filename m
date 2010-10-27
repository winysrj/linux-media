Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63211 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab0J0Wur (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 18:50:47 -0400
Received: by wyf28 with SMTP id 28so1256991wyf.19
        for <linux-media@vger.kernel.org>; Wed, 27 Oct 2010 15:50:46 -0700 (PDT)
Subject: [PATCH] [UPDATE_for_2.6.37] DM04/QQBOX USB DVB-S BOXES to version
 1.70
From: tvbox <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Oct 2010 23:50:36 +0100
Message-ID: <1288219836.2422.29.camel@canaries-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Updated driver for DM04/QQBOX USB DVB-S BOXES to version 1.70

Improved frontend handling.

Frontend now remains open at all times, with signal lock, snr & signal level
polled from Interupt.


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index d939fbb..3a32c65 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -112,7 +112,6 @@ struct lme2510_state {
 	u8 i2c_tuner_gate_r;
 	u8 i2c_tuner_addr;
 	u8 stream_on;
-	u8 one_tune;
 	void *buffer;
 	struct urb *lme_urb;
 	void *usb_buffer;
@@ -182,15 +181,13 @@ static int lme2510_usb_talk(struct dvb_usb_device *d,
 	return (ret < 0) ? -ENODEV : 0;
 }
 
-static int lme2510_usb_talk_restart(struct dvb_usb_device *d,
-		u8 *wbuf, int wlen, u8 *rbuf, int rlen) {
+static int lme2510_stream_restart(struct dvb_usb_device *d)
+{
 	static u8 stream_on[] = LME_ST_ON_W;
 	int ret;
 	u8 rbuff[10];
-	/*Send Normal Command*/
-	ret = lme2510_usb_talk(d, wbuf, wlen, rbuf, rlen);
 	/*Restart Stream Command*/
-	ret |= lme2510_usb_talk(d, stream_on, sizeof(stream_on),
+	ret = lme2510_usb_talk(d, stream_on, sizeof(stream_on),
 			rbuff, sizeof(rbuff));
 	return ret;
 }
@@ -254,11 +251,16 @@ static void lme2510_int_response(struct urb *lme_urb)
 			case TUNER_S7395:
 				/* Tweak for earlier firmware*/
 				if (ibuf[1] == 0x03) {
+					if (ibuf[2] > 1)
+						st->signal_lock = ibuf[2];
 					st->signal_level = ibuf[3];
 					st->signal_sn = ibuf[4];
 				} else {
 					st->signal_level = ibuf[4];
 					st->signal_sn = ibuf[5];
+					st->signal_lock =
+						(st->signal_lock & 0xf7) +
+						((ibuf[2] & 0x01) << 0x03);
 				}
 				break;
 			default:
@@ -341,11 +343,10 @@ static int lme2510_msg(struct dvb_usb_device *d,
 					st->signal_lock = rbuf[1];
 					if ((st->stream_on & 1) &&
 						(st->signal_lock & 0x10)) {
-						lme2510_usb_talk_restart(d,
-							wbuf, wlen, rbuf, rlen);
+						lme2510_stream_restart(d);
 						st->i2c_talk_onoff = 0;
 					}
-				msleep(80);
+					msleep(80);
 				}
 			}
 			break;
@@ -355,15 +356,12 @@ static int lme2510_msg(struct dvb_usb_device *d,
 					st->signal_lock = rbuf[1];
 					if ((st->stream_on & 1) &&
 						(st->signal_lock & 0x8)) {
-						lme2510_usb_talk_restart(d,
-							wbuf, wlen, rbuf, rlen);
+						lme2510_stream_restart(d);
 						st->i2c_talk_onoff = 0;
 					}
 				}
 				if ((wbuf[3] != 0x6) & (wbuf[3] != 0x5))
 					msleep(5);
-
-
 			}
 			break;
 		default:
@@ -385,18 +383,16 @@ static int lme2510_msg(struct dvb_usb_device *d,
 				rbuf[0] = 0x55;
 				rbuf[1] = st->signal_sn;
 				break;
-			/*DiSEqC functions as per TDA10086*/
-			case 0x36:
-			case 0x48:
-			case 0x49:
-			case 0x4a:
-			case 0x4b:
-			case 0x4c:
-			case 0x4d:
-			if (wbuf[2] == 0x1c)
-					lme2510_usb_talk_restart(d,
-						wbuf, wlen, rbuf, rlen);
+			case 0x15:
+			case 0x16:
+			case 0x17:
+			case 0x18:
+				rbuf[0] = 0x55;
+				rbuf[1] = 0x00;
+				break;
 			default:
+				lme2510_usb_talk(d, wbuf, wlen, rbuf, rlen);
+				st->i2c_talk_onoff = 1;
 				break;
 			}
 			break;
@@ -413,39 +409,22 @@ static int lme2510_msg(struct dvb_usb_device *d,
 				break;
 			case 0x24:
 				rbuf[0] = 0x55;
-				rbuf[1] = (st->signal_level & 0x80)
-						? 0 : st->signal_lock;
-				break;
-			case 0x6:
-				if (wbuf[2] == 0xd0)
-					lme2510_usb_talk(d,
-						wbuf, wlen, rbuf, rlen);
-				break;
-			case 0x1:
-				if (st->one_tune > 0)
-					break;
-				st->one_tune++;
-				st->i2c_talk_onoff = 1;
-			/*DiSEqC functions as per STV0288*/
-			case 0x5:
-			case 0x7:
-			case 0x8:
-			case 0x9:
-			case 0xa:
-			case 0xb:
-				if (wbuf[2] == 0xd0)
-					lme2510_usb_talk_restart(d,
-						wbuf, wlen, rbuf, rlen);
+				rbuf[1] = st->signal_lock;
 				break;
-			default:
+			case 0x2e:
+			case 0x26:
+			case 0x27:
 				rbuf[0] = 0x55;
 				rbuf[1] = 0x00;
 				break;
+			default:
+				lme2510_usb_talk(d, wbuf, wlen, rbuf, rlen);
+				st->i2c_talk_onoff = 1;
+				break;
 			}
 			break;
 		default:
 			break;
-
 		}
 
 		deb_info(4, "I2C From Interupt Message out(%02x) in(%02x)",
@@ -548,35 +527,26 @@ static int lme2510_identify_state(struct usb_device *udev,
 static int lme2510_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
 	struct lme2510_state *st = adap->dev->priv;
-	static u8 stream_on[] = LME_ST_ON_W;
 	static u8 clear_reg_3[] =  LME_CLEAR_PID;
 	static u8 rbuf[1];
-	static u8 timeout;
-	int ret = 0, len = 2, rlen = sizeof(rbuf);
+	int ret = 0, rlen = sizeof(rbuf);
 
 	deb_info(1, "STM  (%02x)", onoff);
 
-	if (onoff == 1)	{
-		st->i2c_talk_onoff = 0;
-		timeout = 0;
-		/* wait for i2C to be free */
-		while (mutex_lock_interruptible(&adap->dev->i2c_mutex) < 0) {
-			timeout++;
-			if (timeout > 5)
-				return -ENODEV;
-		}
-		msleep(100);
-		ret |= lme2510_usb_talk(adap->dev,
-				 stream_on,  len, rbuf, rlen);
+	/* Streaming is started by FE_HAS_LOCK */
+	if (onoff == 1)
 		st->stream_on = 1;
-		st->one_tune = 0;
-		mutex_unlock(&adap->dev->i2c_mutex);
-	} else {
+	else {
 		deb_info(1, "STM Steam Off");
+		/* mutex is here only to avoid collision with I2C */
+		ret = mutex_lock_interruptible(&adap->dev->i2c_mutex);
+
 		ret |= lme2510_usb_talk(adap->dev, clear_reg_3,
 				sizeof(clear_reg_3), rbuf, rlen);
 		st->stream_on = 0;
 		st->i2c_talk_onoff = 1;
+
+		mutex_unlock(&adap->dev->i2c_mutex);
 	}
 
 	return (ret < 0) ? -ENODEV : 0;
@@ -619,6 +589,7 @@ static int lme2510_int_service(struct dvb_usb_adapter *adap)
 		ir_input_unregister(input_dev);
 		input_free_device(input_dev);
 	}
+
 	return (ret < 0) ? -ENODEV : 0;
 }
 
@@ -668,6 +639,7 @@ static int lme2510_download_firmware(struct usb_device *dev,
 		ret |= (data[0] == 0x88) ? 0 : -1;
 		}
 	}
+
 	usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
 			0x06, 0x80, 0x0200, 0x00, data, 0x0109, 1000);
 
@@ -701,6 +673,7 @@ static void lme_coldreset(struct usb_device *dev)
 	info("FRM Firmware Cold Reset");
 	ret |= lme2510_bulk_write(dev, data , len_in, 1); /*Cold Resetting*/
 	ret |= lme2510_bulk_read(dev, data, len_in, 1);
+
 	return;
 }
 
@@ -712,6 +685,8 @@ static void lme_firmware_switch(struct usb_device *udev, int cold)
 	char *firm_msg[] = {"Loading", "Switching to"};
 	int ret;
 
+	cold = (cold > 0) ? (cold & 1) : 0;
+
 	if (udev->descriptor.idProduct == 0x1122)
 		return;
 
@@ -740,22 +715,26 @@ static void lme_firmware_switch(struct usb_device *udev, int cold)
 		cold = 0;
 		break;
 	}
+
 	release_firmware(fw);
+
 	if (cold)
 		lme_coldreset(udev);
+
 	return;
 }
 
 static int lme2510_kill_urb(struct usb_data_stream *stream)
 {
 	int i;
+
 	for (i = 0; i < stream->urbs_submitted; i++) {
 		deb_info(3, "killing URB no. %d.", i);
-
 		/* stop the URB */
 		usb_kill_urb(stream->urb_list[i]);
 	}
 	stream->urbs_submitted = 0;
+
 	return 0;
 }
 
@@ -783,18 +762,13 @@ static int dm04_lme2510_set_voltage(struct dvb_frontend *fe,
 					fe_sec_voltage_t voltage)
 {
 	struct dvb_usb_adapter *adap = fe->dvb->priv;
-	struct lme2510_state *st = adap->dev->priv;
 	static u8 voltage_low[]	= LME_VOLTAGE_L;
 	static u8 voltage_high[] = LME_VOLTAGE_H;
-	static u8 lnb_on[] = LNB_ON;
-	static u8 lnb_off[] = LNB_OFF;
 	static u8 rbuf[1];
 	int ret = 0, len = 3, rlen = 1;
 
-	if (st->stream_on == 1)
-		return 0;
-
-	ret |= lme2510_usb_talk(adap->dev, lnb_on, len, rbuf, rlen);
+	if (mutex_lock_interruptible(&adap->dev->i2c_mutex) < 0)
+			return -EAGAIN;
 
 	switch (voltage) {
 	case SEC_VOLTAGE_18:
@@ -803,17 +777,15 @@ static int dm04_lme2510_set_voltage(struct dvb_frontend *fe,
 		break;
 
 	case SEC_VOLTAGE_OFF:
-		ret |= lme2510_usb_talk(adap->dev,
-					lnb_off, len, rbuf, rlen);
 	case SEC_VOLTAGE_13:
 	default:
 		ret |= lme2510_usb_talk(adap->dev,
 				voltage_low, len, rbuf, rlen);
 		break;
+	}
 
+	mutex_unlock(&adap->dev->i2c_mutex);
 
-	};
-	st->i2c_talk_onoff = 1;
 	return (ret < 0) ? -ENODEV : 0;
 }
 
@@ -850,12 +822,14 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
 			if (dvb_usb_lme2510_firmware != 1) {
 				dvb_usb_lme2510_firmware = 1;
 				lme_firmware_switch(adap->dev->udev, 1);
-			}
+			} else /*stops LG/Sharp multi tuner problems*/
+				dvb_usb_lme2510_firmware = 0;
 			return 0;
 		}
 		kfree(adap->fe);
 		adap->fe = NULL;
 	}
+
 	st->i2c_gate = 5;
 	adap->fe = dvb_attach(stv0288_attach, &lme_config,
 			&adap->dev->i2c_adap);
@@ -889,8 +863,23 @@ static int dm04_lme2510_frontend_attach(struct dvb_usb_adapter *adap)
 static int lme2510_powerup(struct dvb_usb_device *d, int onoff)
 {
 	struct lme2510_state *st = d->priv;
+	static u8 lnb_on[] = LNB_ON;
+	static u8 lnb_off[] = LNB_OFF;
+	static u8 rbuf[1];
+	int ret, len = 3, rlen = 1;
+
+	ret = mutex_lock_interruptible(&d->i2c_mutex);
+
+	if (onoff)
+		ret |= lme2510_usb_talk(d, lnb_on, len, rbuf, rlen);
+	else
+		ret |= lme2510_usb_talk(d, lnb_off, len, rbuf, rlen);
+
 	st->i2c_talk_onoff = 1;
-	return 0;
+
+	mutex_unlock(&d->i2c_mutex);
+
+	return ret;
 }
 
 /* DVB USB Driver stuff */
@@ -1084,5 +1073,5 @@ module_exit(lme2510_module_exit);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("LM2510(C) DVB-S USB2.0");
-MODULE_VERSION("1.60");
+MODULE_VERSION("1.70");
 MODULE_LICENSE("GPL");

