Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1745 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab2DWLvj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 07:51:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	"Igor M. Liplianin" <liplianin@me.by>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 1/8] dw2102: fix compile warnings
Date: Mon, 23 Apr 2012 13:51:21 +0200
Message-Id: <100836b0eeed3d802c1ce4f7645d8beefe26df25.1335181658.git.hans.verkuil@cisco.com>
In-Reply-To: <1335181888-4917-1-git-send-email-hverkuil@xs4all.nl>
References: <1335181888-4917-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

media_build/v4l/dw2102.c:151:13: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
media_build/v4l/dw2102.c:224:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
media_build/v4l/dw2102.c:279:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
media_build/v4l/dw2102.c:352:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
media_build/v4l/dw2102.c:435:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
media_build/v4l/dw2102.c:499:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/dvb/dvb-usb/dw2102.c |   76 +++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 40 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dw2102.c b/drivers/media/dvb/dvb-usb/dw2102.c
index 451c5a7..9382895 100644
--- a/drivers/media/dvb/dvb-usb/dw2102.c
+++ b/drivers/media/dvb/dvb-usb/dw2102.c
@@ -148,7 +148,7 @@ static int dw2102_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		int num)
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
-	int i = 0, ret = 0;
+	int i = 0;
 	u8 buf6[] = {0x2c, 0x05, 0xc0, 0, 0, 0, 0};
 	u16 value;
 
@@ -162,7 +162,7 @@ static int dw2102_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		/* read stv0299 register */
 		value = msg[0].buf[0];/* register */
 		for (i = 0; i < msg[1].len; i++) {
-			ret = dw210x_op_rw(d->udev, 0xb5, value + i, 0,
+			dw210x_op_rw(d->udev, 0xb5, value + i, 0,
 					buf6, 2, DW210X_READ_MSG);
 			msg[1].buf[i] = buf6[0];
 		}
@@ -174,7 +174,7 @@ static int dw2102_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			buf6[0] = 0x2a;
 			buf6[1] = msg[0].buf[0];
 			buf6[2] = msg[0].buf[1];
-			ret = dw210x_op_rw(d->udev, 0xb2, 0, 0,
+			dw210x_op_rw(d->udev, 0xb2, 0, 0,
 					buf6, 3, DW210X_WRITE_MSG);
 			break;
 		case 0x60:
@@ -187,17 +187,17 @@ static int dw2102_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 				buf6[4] = msg[0].buf[1];
 				buf6[5] = msg[0].buf[2];
 				buf6[6] = msg[0].buf[3];
-				ret = dw210x_op_rw(d->udev, 0xb2, 0, 0,
+				dw210x_op_rw(d->udev, 0xb2, 0, 0,
 						buf6, 7, DW210X_WRITE_MSG);
 			} else {
 			/* read from tuner */
-				ret = dw210x_op_rw(d->udev, 0xb5, 0, 0,
+				dw210x_op_rw(d->udev, 0xb5, 0, 0,
 						buf6, 1, DW210X_READ_MSG);
 				msg[0].buf[0] = buf6[0];
 			}
 			break;
 		case (DW2102_RC_QUERY):
-			ret  = dw210x_op_rw(d->udev, 0xb8, 0, 0,
+			dw210x_op_rw(d->udev, 0xb8, 0, 0,
 					buf6, 2, DW210X_READ_MSG);
 			msg[0].buf[0] = buf6[0];
 			msg[0].buf[1] = buf6[1];
@@ -205,7 +205,7 @@ static int dw2102_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		case (DW2102_VOLTAGE_CTRL):
 			buf6[0] = 0x30;
 			buf6[1] = msg[0].buf[0];
-			ret = dw210x_op_rw(d->udev, 0xb2, 0, 0,
+			dw210x_op_rw(d->udev, 0xb2, 0, 0,
 					buf6, 2, DW210X_WRITE_MSG);
 			break;
 		}
@@ -221,7 +221,6 @@ static int dw2102_serit_i2c_transfer(struct i2c_adapter *adap,
 						struct i2c_msg msg[], int num)
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
-	int ret = 0;
 	u8 buf6[] = {0, 0, 0, 0, 0, 0, 0};
 
 	if (!d)
@@ -235,10 +234,10 @@ static int dw2102_serit_i2c_transfer(struct i2c_adapter *adap,
 		buf6[0] = msg[0].addr << 1;
 		buf6[1] = msg[0].len;
 		buf6[2] = msg[0].buf[0];
-		ret = dw210x_op_rw(d->udev, 0xc2, 0, 0,
+		dw210x_op_rw(d->udev, 0xc2, 0, 0,
 				buf6, msg[0].len + 2, DW210X_WRITE_MSG);
 		/* read si2109 register */
-		ret = dw210x_op_rw(d->udev, 0xc3, 0xd0, 0,
+		dw210x_op_rw(d->udev, 0xc3, 0xd0, 0,
 				buf6, msg[1].len + 2, DW210X_READ_MSG);
 		memcpy(msg[1].buf, buf6 + 2, msg[1].len);
 
@@ -250,11 +249,11 @@ static int dw2102_serit_i2c_transfer(struct i2c_adapter *adap,
 			buf6[0] = msg[0].addr << 1;
 			buf6[1] = msg[0].len;
 			memcpy(buf6 + 2, msg[0].buf, msg[0].len);
-			ret = dw210x_op_rw(d->udev, 0xc2, 0, 0, buf6,
+			dw210x_op_rw(d->udev, 0xc2, 0, 0, buf6,
 					msg[0].len + 2, DW210X_WRITE_MSG);
 			break;
 		case(DW2102_RC_QUERY):
-			ret  = dw210x_op_rw(d->udev, 0xb8, 0, 0,
+			dw210x_op_rw(d->udev, 0xb8, 0, 0,
 					buf6, 2, DW210X_READ_MSG);
 			msg[0].buf[0] = buf6[0];
 			msg[0].buf[1] = buf6[1];
@@ -262,7 +261,7 @@ static int dw2102_serit_i2c_transfer(struct i2c_adapter *adap,
 		case(DW2102_VOLTAGE_CTRL):
 			buf6[0] = 0x30;
 			buf6[1] = msg[0].buf[0];
-			ret = dw210x_op_rw(d->udev, 0xb2, 0, 0,
+			dw210x_op_rw(d->udev, 0xb2, 0, 0,
 					buf6, 2, DW210X_WRITE_MSG);
 			break;
 		}
@@ -276,7 +275,6 @@ static int dw2102_serit_i2c_transfer(struct i2c_adapter *adap,
 static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], int num)
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
-	int ret = 0;
 
 	if (!d)
 		return -ENODEV;
@@ -291,10 +289,10 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
 		obuf[0] = msg[0].addr << 1;
 		obuf[1] = msg[0].len;
 		obuf[2] = msg[0].buf[0];
-		ret = dw210x_op_rw(d->udev, 0xc2, 0, 0,
+		dw210x_op_rw(d->udev, 0xc2, 0, 0,
 				obuf, msg[0].len + 2, DW210X_WRITE_MSG);
 		/* second read registers */
-		ret = dw210x_op_rw(d->udev, 0xc3, 0xd1 , 0,
+		dw210x_op_rw(d->udev, 0xc3, 0xd1 , 0,
 				ibuf, msg[1].len + 2, DW210X_READ_MSG);
 		memcpy(msg[1].buf, ibuf + 2, msg[1].len);
 
@@ -308,7 +306,7 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
 			obuf[0] = msg[0].addr << 1;
 			obuf[1] = msg[0].len;
 			memcpy(obuf + 2, msg[0].buf, msg[0].len);
-			ret = dw210x_op_rw(d->udev, 0xc2, 0, 0,
+			dw210x_op_rw(d->udev, 0xc2, 0, 0,
 					obuf, msg[0].len + 2, DW210X_WRITE_MSG);
 			break;
 		}
@@ -318,13 +316,13 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
 			obuf[0] = msg[0].addr << 1;
 			obuf[1] = msg[0].len;
 			memcpy(obuf + 2, msg[0].buf, msg[0].len);
-			ret = dw210x_op_rw(d->udev, 0xc2, 0, 0,
+			dw210x_op_rw(d->udev, 0xc2, 0, 0,
 					obuf, msg[0].len + 2, DW210X_WRITE_MSG);
 			break;
 		}
 		case(DW2102_RC_QUERY): {
 			u8 ibuf[2];
-			ret  = dw210x_op_rw(d->udev, 0xb8, 0, 0,
+			dw210x_op_rw(d->udev, 0xb8, 0, 0,
 					ibuf, 2, DW210X_READ_MSG);
 			memcpy(msg[0].buf, ibuf , 2);
 			break;
@@ -333,7 +331,7 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
 			u8 obuf[2];
 			obuf[0] = 0x30;
 			obuf[1] = msg[0].buf[0];
-			ret = dw210x_op_rw(d->udev, 0xb2, 0, 0,
+			dw210x_op_rw(d->udev, 0xb2, 0, 0,
 					obuf, 2, DW210X_WRITE_MSG);
 			break;
 		}
@@ -349,7 +347,6 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
 static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], int num)
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
-	int ret = 0;
 	int len, i, j;
 
 	if (!d)
@@ -361,7 +358,7 @@ static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], i
 		switch (msg[j].addr) {
 		case(DW2102_RC_QUERY): {
 			u8 ibuf[2];
-			ret  = dw210x_op_rw(d->udev, 0xb8, 0, 0,
+			dw210x_op_rw(d->udev, 0xb8, 0, 0,
 					ibuf, 2, DW210X_READ_MSG);
 			memcpy(msg[j].buf, ibuf , 2);
 			break;
@@ -370,7 +367,7 @@ static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], i
 			u8 obuf[2];
 			obuf[0] = 0x30;
 			obuf[1] = msg[j].buf[0];
-			ret = dw210x_op_rw(d->udev, 0xb2, 0, 0,
+			dw210x_op_rw(d->udev, 0xb2, 0, 0,
 					obuf, 2, DW210X_WRITE_MSG);
 			break;
 		}
@@ -382,7 +379,7 @@ static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], i
 			if (msg[j].flags == I2C_M_RD) {
 				/* read registers */
 				u8  ibuf[msg[j].len + 2];
-				ret = dw210x_op_rw(d->udev, 0xc3,
+				dw210x_op_rw(d->udev, 0xc3,
 						(msg[j].addr << 1) + 1, 0,
 						ibuf, msg[j].len + 2,
 						DW210X_READ_MSG);
@@ -402,7 +399,7 @@ static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], i
 				do {
 					memcpy(obuf + 3, msg[j].buf + i,
 							(len > 16 ? 16 : len));
-					ret = dw210x_op_rw(d->udev, 0xc2, 0, 0,
+					dw210x_op_rw(d->udev, 0xc2, 0, 0,
 						obuf, (len > 16 ? 16 : len) + 3,
 						DW210X_WRITE_MSG);
 					i += 16;
@@ -414,7 +411,7 @@ static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], i
 				obuf[0] = msg[j].addr << 1;
 				obuf[1] = msg[j].len;
 				memcpy(obuf + 2, msg[j].buf, msg[j].len);
-				ret = dw210x_op_rw(d->udev, 0xc2, 0, 0,
+				dw210x_op_rw(d->udev, 0xc2, 0, 0,
 						obuf, msg[j].len + 2,
 						DW210X_WRITE_MSG);
 			}
@@ -432,7 +429,7 @@ static int dw3101_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 								int num)
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
-	int ret = 0, i;
+	int i;
 
 	if (!d)
 		return -ENODEV;
@@ -447,10 +444,10 @@ static int dw3101_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		obuf[0] = msg[0].addr << 1;
 		obuf[1] = msg[0].len;
 		obuf[2] = msg[0].buf[0];
-		ret = dw210x_op_rw(d->udev, 0xc2, 0, 0,
+		dw210x_op_rw(d->udev, 0xc2, 0, 0,
 				obuf, msg[0].len + 2, DW210X_WRITE_MSG);
 		/* second read registers */
-		ret = dw210x_op_rw(d->udev, 0xc3, 0x19 , 0,
+		dw210x_op_rw(d->udev, 0xc3, 0x19 , 0,
 				ibuf, msg[1].len + 2, DW210X_READ_MSG);
 		memcpy(msg[1].buf, ibuf + 2, msg[1].len);
 
@@ -465,13 +462,13 @@ static int dw3101_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			obuf[0] = msg[0].addr << 1;
 			obuf[1] = msg[0].len;
 			memcpy(obuf + 2, msg[0].buf, msg[0].len);
-			ret = dw210x_op_rw(d->udev, 0xc2, 0, 0,
+			dw210x_op_rw(d->udev, 0xc2, 0, 0,
 					obuf, msg[0].len + 2, DW210X_WRITE_MSG);
 			break;
 		}
 		case(DW2102_RC_QUERY): {
 			u8 ibuf[2];
-			ret  = dw210x_op_rw(d->udev, 0xb8, 0, 0,
+			dw210x_op_rw(d->udev, 0xb8, 0, 0,
 					ibuf, 2, DW210X_READ_MSG);
 			memcpy(msg[0].buf, ibuf , 2);
 			break;
@@ -496,7 +493,6 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
 	struct usb_device *udev;
-	int ret = 0;
 	int len, i, j;
 
 	if (!d)
@@ -509,7 +505,7 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		switch (msg[j].addr) {
 		case (DW2102_RC_QUERY): {
 			u8 ibuf[5];
-			ret  = dw210x_op_rw(d->udev, 0xb8, 0, 0,
+			dw210x_op_rw(d->udev, 0xb8, 0, 0,
 					ibuf, 5, DW210X_READ_MSG);
 			memcpy(msg[j].buf, ibuf + 3, 2);
 			break;
@@ -519,11 +515,11 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 
 			obuf[0] = 1;
 			obuf[1] = msg[j].buf[1];/* off-on */
-			ret = dw210x_op_rw(d->udev, 0x8a, 0, 0,
+			dw210x_op_rw(d->udev, 0x8a, 0, 0,
 					obuf, 2, DW210X_WRITE_MSG);
 			obuf[0] = 3;
 			obuf[1] = msg[j].buf[0];/* 13v-18v */
-			ret = dw210x_op_rw(d->udev, 0x8a, 0, 0,
+			dw210x_op_rw(d->udev, 0x8a, 0, 0,
 					obuf, 2, DW210X_WRITE_MSG);
 			break;
 		}
@@ -532,7 +528,7 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 
 			obuf[0] = 5;
 			obuf[1] = msg[j].buf[0];
-			ret = dw210x_op_rw(d->udev, 0x8a, 0, 0,
+			dw210x_op_rw(d->udev, 0x8a, 0, 0,
 					obuf, 2, DW210X_WRITE_MSG);
 			break;
 		}
@@ -545,7 +541,7 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			if (msg[j].flags == I2C_M_RD) {
 				/* read registers */
 				u8 ibuf[msg[j].len];
-				ret = dw210x_op_rw(d->udev, 0x91, 0, 0,
+				dw210x_op_rw(d->udev, 0x91, 0, 0,
 						ibuf, msg[j].len,
 						DW210X_READ_MSG);
 				memcpy(msg[j].buf, ibuf, msg[j].len);
@@ -563,7 +559,7 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 				do {
 					memcpy(obuf + 3, msg[j].buf + i,
 							(len > 16 ? 16 : len));
-					ret = dw210x_op_rw(d->udev, 0x80, 0, 0,
+					dw210x_op_rw(d->udev, 0x80, 0, 0,
 						obuf, (len > 16 ? 16 : len) + 3,
 						DW210X_WRITE_MSG);
 					i += 16;
@@ -575,7 +571,7 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 				obuf[0] = msg[j + 1].len;
 				obuf[1] = (msg[j].addr << 1);
 				memcpy(obuf + 2, msg[j].buf, msg[j].len);
-				ret = dw210x_op_rw(d->udev,
+				dw210x_op_rw(d->udev,
 						udev->descriptor.idProduct ==
 						0x7500 ? 0x92 : 0x90, 0, 0,
 						obuf, msg[j].len + 2,
@@ -587,7 +583,7 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 				obuf[0] = msg[j].len + 1;
 				obuf[1] = (msg[j].addr << 1);
 				memcpy(obuf + 2, msg[j].buf, msg[j].len);
-				ret = dw210x_op_rw(d->udev, 0x80, 0, 0,
+				dw210x_op_rw(d->udev, 0x80, 0, 0,
 						obuf, msg[j].len + 2,
 						DW210X_WRITE_MSG);
 				break;
-- 
1.7.10

