Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50087 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab3KVH5U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Nov 2013 02:57:20 -0500
Date: Fri, 22 Nov 2013 10:56:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: "Igor M. Liplianin" <liplianin@me.by>,
	Andrey Pavlenko <andrey.a.pavlenko@gmail.com>,
	Antti Palosaari <crope@iki.fi>,
	Stephan Hilb <stephan@ecshi.net>,
	Konstantin Dimitrov <kosio.dimitrov@gmail.com>,
	John Horan <knasher@gmail.com>,
	=?iso-8859-1?Q?R=E9mi?= Cardona <remi.cardona@smartjog.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] dw2102: some missing unlocks on error
Message-ID: <20131122075632.GD15726@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We recently introduced some new error paths but the unlocks are missing.

Fixes: 0065a79a8698 ('[media] dw2102: Don't use dynamic static allocation')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index c1a63b2a6baa..f272ed86d467 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -301,6 +301,7 @@ static int dw2102_serit_i2c_transfer(struct i2c_adapter *adap,
 static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], int num)
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
+	int ret;
 
 	if (!d)
 		return -ENODEV;
@@ -316,7 +317,8 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
 		if (2 + msg[1].len > sizeof(ibuf)) {
 			warn("i2c rd: len=%d is too big!\n",
 			     msg[1].len);
-			return -EOPNOTSUPP;
+			ret = -EOPNOTSUPP;
+			goto unlock;
 		}
 
 		obuf[0] = msg[0].addr << 1;
@@ -340,7 +342,8 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
 			if (2 + msg[0].len > sizeof(obuf)) {
 				warn("i2c wr: len=%d is too big!\n",
 				     msg[1].len);
-				return -EOPNOTSUPP;
+				ret = -EOPNOTSUPP;
+				goto unlock;
 			}
 
 			obuf[0] = msg[0].addr << 1;
@@ -357,7 +360,8 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
 			if (2 + msg[0].len > sizeof(obuf)) {
 				warn("i2c wr: len=%d is too big!\n",
 				     msg[1].len);
-				return -EOPNOTSUPP;
+				ret = -EOPNOTSUPP;
+				goto unlock;
 			}
 
 			obuf[0] = msg[0].addr << 1;
@@ -386,15 +390,17 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
 
 		break;
 	}
+	ret = num;
 
+unlock:
 	mutex_unlock(&d->i2c_mutex);
-	return num;
+	return ret;
 }
 
 static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], int num)
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
-	int len, i, j;
+	int len, i, j, ret;
 
 	if (!d)
 		return -ENODEV;
@@ -430,7 +436,8 @@ static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], i
 				if (2 + msg[j].len > sizeof(ibuf)) {
 					warn("i2c rd: len=%d is too big!\n",
 					     msg[j].len);
-					return -EOPNOTSUPP;
+					ret = -EOPNOTSUPP;
+					goto unlock;
 				}
 
 				dw210x_op_rw(d->udev, 0xc3,
@@ -466,7 +473,8 @@ static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], i
 				if (2 + msg[j].len > sizeof(obuf)) {
 					warn("i2c wr: len=%d is too big!\n",
 					     msg[j].len);
-					return -EOPNOTSUPP;
+					ret = -EOPNOTSUPP;
+					goto unlock;
 				}
 
 				obuf[0] = msg[j].addr << 1;
@@ -481,15 +489,18 @@ static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], i
 		}
 
 	}
+	ret = num;
 
+unlock:
 	mutex_unlock(&d->i2c_mutex);
-	return num;
+	return ret;
 }
 
 static int dw3101_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 								int num)
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
+	int ret;
 	int i;
 
 	if (!d)
@@ -506,7 +517,8 @@ static int dw3101_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		if (2 + msg[1].len > sizeof(ibuf)) {
 			warn("i2c rd: len=%d is too big!\n",
 			     msg[1].len);
-			return -EOPNOTSUPP;
+			ret = -EOPNOTSUPP;
+			goto unlock;
 		}
 		obuf[0] = msg[0].addr << 1;
 		obuf[1] = msg[0].len;
@@ -530,7 +542,8 @@ static int dw3101_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			if (2 + msg[0].len > sizeof(obuf)) {
 				warn("i2c wr: len=%d is too big!\n",
 				     msg[0].len);
-				return -EOPNOTSUPP;
+				ret = -EOPNOTSUPP;
+				goto unlock;
 			}
 			obuf[0] = msg[0].addr << 1;
 			obuf[1] = msg[0].len;
@@ -556,9 +569,11 @@ static int dw3101_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 				msg[i].flags == 0 ? ">>>" : "<<<");
 		debug_dump(msg[i].buf, msg[i].len, deb_xfer);
 	}
+	ret = num;
 
+unlock:
 	mutex_unlock(&d->i2c_mutex);
-	return num;
+	return ret;
 }
 
 static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
@@ -566,7 +581,7 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
 	struct usb_device *udev;
-	int len, i, j;
+	int len, i, j, ret;
 
 	if (!d)
 		return -ENODEV;
@@ -618,7 +633,8 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 				if (msg[j].len > sizeof(ibuf)) {
 					warn("i2c rd: len=%d is too big!\n",
 					     msg[j].len);
-					return -EOPNOTSUPP;
+					ret = -EOPNOTSUPP;
+					goto unlock;
 				}
 
 				dw210x_op_rw(d->udev, 0x91, 0, 0,
@@ -652,7 +668,8 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 				if (2 + msg[j].len > sizeof(obuf)) {
 					warn("i2c wr: len=%d is too big!\n",
 					     msg[j].len);
-					return -EOPNOTSUPP;
+					ret = -EOPNOTSUPP;
+					goto unlock;
 				}
 
 				obuf[0] = msg[j + 1].len;
@@ -671,7 +688,8 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 				if (2 + msg[j].len > sizeof(obuf)) {
 					warn("i2c wr: len=%d is too big!\n",
 					     msg[j].len);
-					return -EOPNOTSUPP;
+					ret = -EOPNOTSUPP;
+					goto unlock;
 				}
 				obuf[0] = msg[j].len + 1;
 				obuf[1] = (msg[j].addr << 1);
@@ -685,9 +703,11 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		}
 		}
 	}
+	ret = num;
 
+unlock:
 	mutex_unlock(&d->i2c_mutex);
-	return num;
+	return ret;
 }
 
 static int su3000_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
