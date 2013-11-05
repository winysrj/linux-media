Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43304 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab3KENDv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 08:03:51 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 24/29] [media] dw2102: Don't use dynamic static allocation
Date: Tue,  5 Nov 2013 08:01:37 -0200
Message-Id: <1383645702-30636-25-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
References: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:
	drivers/media/usb/dvb-usb/dw2102.c:368:1: warning: 'dw2102_earda_i2c_transfer' uses dynamic stack allocation [enabled by default]
	drivers/media/usb/dvb-usb/dw2102.c:449:1: warning: 'dw2104_i2c_transfer' uses dynamic stack allocation [enabled by default]
	drivers/media/usb/dvb-usb/dw2102.c:512:1: warning: 'dw3101_i2c_transfer' uses dynamic stack allocation [enabled by default]
	drivers/media/usb/dvb-usb/dw2102.c:621:1: warning: 's6x0_i2c_transfer' uses dynamic stack allocation [enabled by default]

Instead, let's enforce a limit for the buffer to be the max size of
a control URB payload data (64 bytes).

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/dvb-usb/dw2102.c | 90 +++++++++++++++++++++++++++++++++-----
 1 file changed, 80 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 6136a2c7dbfd..c1a63b2a6baa 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -30,6 +30,9 @@
 #include "stb6100_proc.h"
 #include "m88rs2000.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 #ifndef USB_PID_DW2102
 #define USB_PID_DW2102 0x2102
 #endif
@@ -308,7 +311,14 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
 	case 2: {
 		/* read */
 		/* first write first register number */
-		u8 ibuf[msg[1].len + 2], obuf[3];
+		u8 ibuf[MAX_XFER_SIZE], obuf[3];
+
+		if (2 + msg[1].len > sizeof(ibuf)) {
+			warn("i2c rd: len=%d is too big!\n",
+			     msg[1].len);
+			return -EOPNOTSUPP;
+		}
+
 		obuf[0] = msg[0].addr << 1;
 		obuf[1] = msg[0].len;
 		obuf[2] = msg[0].buf[0];
@@ -325,7 +335,14 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
 		switch (msg[0].addr) {
 		case 0x68: {
 			/* write to register */
-			u8 obuf[msg[0].len + 2];
+			u8 obuf[MAX_XFER_SIZE];
+
+			if (2 + msg[0].len > sizeof(obuf)) {
+				warn("i2c wr: len=%d is too big!\n",
+				     msg[1].len);
+				return -EOPNOTSUPP;
+			}
+
 			obuf[0] = msg[0].addr << 1;
 			obuf[1] = msg[0].len;
 			memcpy(obuf + 2, msg[0].buf, msg[0].len);
@@ -335,7 +352,14 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
 		}
 		case 0x61: {
 			/* write to tuner */
-			u8 obuf[msg[0].len + 2];
+			u8 obuf[MAX_XFER_SIZE];
+
+			if (2 + msg[0].len > sizeof(obuf)) {
+				warn("i2c wr: len=%d is too big!\n",
+				     msg[1].len);
+				return -EOPNOTSUPP;
+			}
+
 			obuf[0] = msg[0].addr << 1;
 			obuf[1] = msg[0].len;
 			memcpy(obuf + 2, msg[0].buf, msg[0].len);
@@ -401,7 +425,14 @@ static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], i
 		default: {
 			if (msg[j].flags == I2C_M_RD) {
 				/* read registers */
-				u8  ibuf[msg[j].len + 2];
+				u8  ibuf[MAX_XFER_SIZE];
+
+				if (2 + msg[j].len > sizeof(ibuf)) {
+					warn("i2c rd: len=%d is too big!\n",
+					     msg[j].len);
+					return -EOPNOTSUPP;
+				}
+
 				dw210x_op_rw(d->udev, 0xc3,
 						(msg[j].addr << 1) + 1, 0,
 						ibuf, msg[j].len + 2,
@@ -430,7 +461,14 @@ static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], i
 				} while (len > 0);
 			} else {
 				/* write registers */
-				u8 obuf[msg[j].len + 2];
+				u8 obuf[MAX_XFER_SIZE];
+
+				if (2 + msg[j].len > sizeof(obuf)) {
+					warn("i2c wr: len=%d is too big!\n",
+					     msg[j].len);
+					return -EOPNOTSUPP;
+				}
+
 				obuf[0] = msg[j].addr << 1;
 				obuf[1] = msg[j].len;
 				memcpy(obuf + 2, msg[j].buf, msg[j].len);
@@ -463,7 +501,13 @@ static int dw3101_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 	case 2: {
 		/* read */
 		/* first write first register number */
-		u8 ibuf[msg[1].len + 2], obuf[3];
+		u8 ibuf[MAX_XFER_SIZE], obuf[3];
+
+		if (2 + msg[1].len > sizeof(ibuf)) {
+			warn("i2c rd: len=%d is too big!\n",
+			     msg[1].len);
+			return -EOPNOTSUPP;
+		}
 		obuf[0] = msg[0].addr << 1;
 		obuf[1] = msg[0].len;
 		obuf[2] = msg[0].buf[0];
@@ -481,7 +525,13 @@ static int dw3101_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		case 0x60:
 		case 0x0c: {
 			/* write to register */
-			u8 obuf[msg[0].len + 2];
+			u8 obuf[MAX_XFER_SIZE];
+
+			if (2 + msg[0].len > sizeof(obuf)) {
+				warn("i2c wr: len=%d is too big!\n",
+				     msg[0].len);
+				return -EOPNOTSUPP;
+			}
 			obuf[0] = msg[0].addr << 1;
 			obuf[1] = msg[0].len;
 			memcpy(obuf + 2, msg[0].buf, msg[0].len);
@@ -563,7 +613,14 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		default: {
 			if (msg[j].flags == I2C_M_RD) {
 				/* read registers */
-				u8 ibuf[msg[j].len];
+				u8 ibuf[MAX_XFER_SIZE];
+
+				if (msg[j].len > sizeof(ibuf)) {
+					warn("i2c rd: len=%d is too big!\n",
+					     msg[j].len);
+					return -EOPNOTSUPP;
+				}
+
 				dw210x_op_rw(d->udev, 0x91, 0, 0,
 						ibuf, msg[j].len,
 						DW210X_READ_MSG);
@@ -590,7 +647,14 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 				} while (len > 0);
 			} else if (j < (num - 1)) {
 				/* write register addr before read */
-				u8 obuf[msg[j].len + 2];
+				u8 obuf[MAX_XFER_SIZE];
+
+				if (2 + msg[j].len > sizeof(obuf)) {
+					warn("i2c wr: len=%d is too big!\n",
+					     msg[j].len);
+					return -EOPNOTSUPP;
+				}
+
 				obuf[0] = msg[j + 1].len;
 				obuf[1] = (msg[j].addr << 1);
 				memcpy(obuf + 2, msg[j].buf, msg[j].len);
@@ -602,7 +666,13 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 				break;
 			} else {
 				/* write registers */
-				u8 obuf[msg[j].len + 2];
+				u8 obuf[MAX_XFER_SIZE];
+
+				if (2 + msg[j].len > sizeof(obuf)) {
+					warn("i2c wr: len=%d is too big!\n",
+					     msg[j].len);
+					return -EOPNOTSUPP;
+				}
 				obuf[0] = msg[j].len + 1;
 				obuf[1] = (msg[j].addr << 1);
 				memcpy(obuf + 2, msg[j].buf, msg[j].len);
-- 
1.8.3.1

