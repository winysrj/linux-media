Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49567 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab3KVHz4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Nov 2013 02:55:56 -0500
Date: Fri, 22 Nov 2013 10:55:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] cxusb: unlock on error in cxusb_i2c_xfer()
Message-ID: <20131122075543.GC15726@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We recently introduced some new error paths which are missing their
unlocks.

Fixes: 64f7ef8afbf8 ('[media] cxusb: Don't use dynamic static allocation')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 20e345d9fe8f..a1c641e18362 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -149,6 +149,7 @@ static int cxusb_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			  int num)
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
+	int ret;
 	int i;
 
 	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
@@ -173,7 +174,8 @@ static int cxusb_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			if (1 + msg[i].len > sizeof(ibuf)) {
 				warn("i2c rd: len=%d is too big!\n",
 				     msg[i].len);
-				return -EOPNOTSUPP;
+				ret = -EOPNOTSUPP;
+				goto unlock;
 			}
 			obuf[0] = 0;
 			obuf[1] = msg[i].len;
@@ -193,12 +195,14 @@ static int cxusb_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			if (3 + msg[i].len > sizeof(obuf)) {
 				warn("i2c wr: len=%d is too big!\n",
 				     msg[i].len);
-				return -EOPNOTSUPP;
+				ret = -EOPNOTSUPP;
+				goto unlock;
 			}
 			if (1 + msg[i + 1].len > sizeof(ibuf)) {
 				warn("i2c rd: len=%d is too big!\n",
 				     msg[i + 1].len);
-				return -EOPNOTSUPP;
+				ret = -EOPNOTSUPP;
+				goto unlock;
 			}
 			obuf[0] = msg[i].len;
 			obuf[1] = msg[i+1].len;
@@ -223,7 +227,8 @@ static int cxusb_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			if (2 + msg[i].len > sizeof(obuf)) {
 				warn("i2c wr: len=%d is too big!\n",
 				     msg[i].len);
-				return -EOPNOTSUPP;
+				ret = -EOPNOTSUPP;
+				goto unlock;
 			}
 			obuf[0] = msg[i].addr;
 			obuf[1] = msg[i].len;
@@ -237,8 +242,14 @@ static int cxusb_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		}
 	}
 
+	if (i == num)
+		ret = num;
+	else
+		ret = -EREMOTEIO;
+
+unlock:
 	mutex_unlock(&d->i2c_mutex);
-	return i == num ? num : -EREMOTEIO;
+	return ret;
 }
 
 static u32 cxusb_i2c_func(struct i2c_adapter *adapter)
