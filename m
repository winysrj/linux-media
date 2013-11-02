Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60751 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab3KBQdl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Nov 2013 12:33:41 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Igor M. Liplianin" <liplianin@me.by>,
	Andrey Pavlenko <andrey.a.pavlenko@gmail.com>,
	Antti Palosaari <crope@iki.fi>,
	Stephan Hilb <stephan@ecshi.net>
Subject: [PATCHv2 25/29] dw2102: Don't use dynamic static allocation
Date: Sat,  2 Nov 2013 11:31:33 -0200
Message-Id: <1383399097-11615-26-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dynamic static allocation is evil, as Kernel stack is too low, and
ompilation complains about it on some archs:

	drivers/media/usb/dvb-usb/dw2102.c:368:1: warning: 'dw2102_earda_i2c_transfer' uses dynamic stack allocation [enabled by default]
	drivers/media/usb/dvb-usb/dw2102.c:449:1: warning: 'dw2104_i2c_transfer' uses dynamic stack allocation [enabled by default]
	drivers/media/usb/dvb-usb/dw2102.c:512:1: warning: 'dw3101_i2c_transfer' uses dynamic stack allocation [enabled by default]
	drivers/media/usb/dvb-usb/dw2102.c:621:1: warning: 's6x0_i2c_transfer' uses dynamic stack allocation [enabled by default]

Instead, let's enforce a limit for the buffer to be the max size of
a control URB payload data (80 bytes).

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Igor M. Liplianin <liplianin@me.by>
Cc: Andrey Pavlenko <andrey.a.pavlenko@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Stephan Hilb <stephan@ecshi.net>
---
 drivers/media/usb/dvb-usb/dw2102.c | 87 +++++++++++++++++++++++++++++++++-----
 1 file changed, 77 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 6136a2c7dbfd..1907a242d93f 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -308,7 +308,14 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
 	case 2: {
 		/* read */
 		/* first write first register number */
-		u8 ibuf[msg[1].len + 2], obuf[3];
+		u8 ibuf[80], obuf[3];
+
+		if (2 + msg[1].len > sizeof(ibuf)) {
+			warn("i2c rd: len=%d is too big!\n",
+			     msg[1].len);
+			return -EREMOTEIO;
+		}
+
 		obuf[0] = msg[0].addr << 1;
 		obuf[1] = msg[0].len;
 		obuf[2] = msg[0].buf[0];
@@ -325,7 +332,14 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
 		switch (msg[0].addr) {
 		case 0x68: {
 			/* write to register */
-			u8 obuf[msg[0].len + 2];
+			u8 obuf[80];
+
+			if (2 + msg[0].len > sizeof(obuf)) {
+				warn("i2c wr: len=%d is too big!\n",
+				     msg[1].len);
+				return -EREMOTEIO;
+			}
+
 			obuf[0] = msg[0].addr << 1;
 			obuf[1] = msg[0].len;
 			memcpy(obuf + 2, msg[0].buf, msg[0].len);
@@ -335,7 +349,14 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
 		}
 		case 0x61: {
 			/* write to tuner */
-			u8 obuf[msg[0].len + 2];
+			u8 obuf[80];
+
+			if (2 + msg[0].len > sizeof(obuf)) {
+				warn("i2c wr: len=%d is too big!\n",
+				     msg[1].len);
+				return -EREMOTEIO;
+			}
+
 			obuf[0] = msg[0].addr << 1;
 			obuf[1] = msg[0].len;
 			memcpy(obuf + 2, msg[0].buf, msg[0].len);
@@ -401,7 +422,14 @@ static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], i
 		default: {
 			if (msg[j].flags == I2C_M_RD) {
 				/* read registers */
-				u8  ibuf[msg[j].len + 2];
+				u8  ibuf[80];
+
+				if (2 + msg[j].len > sizeof(ibuf)) {
+					warn("i2c rd: len=%d is too big!\n",
+					     msg[j].len);
+					return -EREMOTEIO;
+				}
+
 				dw210x_op_rw(d->udev, 0xc3,
 						(msg[j].addr << 1) + 1, 0,
 						ibuf, msg[j].len + 2,
@@ -430,7 +458,14 @@ static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], i
 				} while (len > 0);
 			} else {
 				/* write registers */
-				u8 obuf[msg[j].len + 2];
+				u8 obuf[80];
+
+				if (2 + msg[j].len > sizeof(obuf)) {
+					warn("i2c wr: len=%d is too big!\n",
+					     msg[j].len);
+					return -EREMOTEIO;
+				}
+
 				obuf[0] = msg[j].addr << 1;
 				obuf[1] = msg[j].len;
 				memcpy(obuf + 2, msg[j].buf, msg[j].len);
@@ -463,7 +498,13 @@ static int dw3101_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 	case 2: {
 		/* read */
 		/* first write first register number */
-		u8 ibuf[msg[1].len + 2], obuf[3];
+		u8 ibuf[80], obuf[3];
+
+		if (2 + msg[1].len > sizeof(ibuf)) {
+			warn("i2c rd: len=%d is too big!\n",
+			     msg[1].len);
+			return -EREMOTEIO;
+		}
 		obuf[0] = msg[0].addr << 1;
 		obuf[1] = msg[0].len;
 		obuf[2] = msg[0].buf[0];
@@ -481,7 +522,13 @@ static int dw3101_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		case 0x60:
 		case 0x0c: {
 			/* write to register */
-			u8 obuf[msg[0].len + 2];
+			u8 obuf[80];
+
+			if (2 + msg[0].len > sizeof(obuf)) {
+				warn("i2c wr: len=%d is too big!\n",
+				     msg[0].len);
+				return -EREMOTEIO;
+			}
 			obuf[0] = msg[0].addr << 1;
 			obuf[1] = msg[0].len;
 			memcpy(obuf + 2, msg[0].buf, msg[0].len);
@@ -563,7 +610,14 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		default: {
 			if (msg[j].flags == I2C_M_RD) {
 				/* read registers */
-				u8 ibuf[msg[j].len];
+				u8 ibuf[80];
+
+				if (msg[j].len > sizeof(ibuf)) {
+					warn("i2c rd: len=%d is too big!\n",
+					     msg[j].len);
+					return -EREMOTEIO;
+				}
+
 				dw210x_op_rw(d->udev, 0x91, 0, 0,
 						ibuf, msg[j].len,
 						DW210X_READ_MSG);
@@ -590,7 +644,14 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 				} while (len > 0);
 			} else if (j < (num - 1)) {
 				/* write register addr before read */
-				u8 obuf[msg[j].len + 2];
+				u8 obuf[80];
+
+				if (2 + msg[j].len > sizeof(obuf)) {
+					warn("i2c wr: len=%d is too big!\n",
+					     msg[j].len);
+					return -EREMOTEIO;
+				}
+
 				obuf[0] = msg[j + 1].len;
 				obuf[1] = (msg[j].addr << 1);
 				memcpy(obuf + 2, msg[j].buf, msg[j].len);
@@ -602,7 +663,13 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 				break;
 			} else {
 				/* write registers */
-				u8 obuf[msg[j].len + 2];
+				u8 obuf[80];
+
+				if (2 + msg[j].len > sizeof(obuf)) {
+					warn("i2c wr: len=%d is too big!\n",
+					     msg[j].len);
+					return -EREMOTEIO;
+				}
 				obuf[0] = msg[j].len + 1;
 				obuf[1] = (msg[j].addr << 1);
 				memcpy(obuf + 2, msg[j].buf, msg[j].len);
-- 
1.8.3.1

