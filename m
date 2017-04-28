Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21568 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2993681AbdD1Mxx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 08:53:53 -0400
Date: Fri, 28 Apr 2017 15:53:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Sean Young <sean@mess.org>, Johan Hovold <johan@kernel.org>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] [media] dib0700: fix error handling in
 dib0700_i2c_xfer_legacy()
Message-ID: <20170428125331.hjosazb5hs5nzynl@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mostly this adds some unlocks to error paths.  But, if you see where
there were "break;" statements before, I changed those paths to return
error codes instead of returning success.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index 4dea79718827..bea1b4764a66 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -287,7 +287,7 @@ static int dib0700_i2c_xfer_legacy(struct i2c_adapter *adap,
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
 	struct dib0700_state *st = d->priv;
-	int i,len;
+	int i, len, result;
 
 	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
 		return -EINTR;
@@ -304,7 +304,8 @@ static int dib0700_i2c_xfer_legacy(struct i2c_adapter *adap,
 		if (msg[i].len > sizeof(st->buf) - 2) {
 			deb_info("i2c xfer to big: %d\n",
 				msg[i].len);
-			return -EIO;
+			result = -EIO;
+			goto unlock;
 		}
 		memcpy(&st->buf[2], msg[i].buf, msg[i].len);
 
@@ -319,13 +320,15 @@ static int dib0700_i2c_xfer_legacy(struct i2c_adapter *adap,
 			if (len <= 0) {
 				deb_info("I2C read failed on address 0x%02x\n",
 						msg[i].addr);
-				break;
+				result = -EIO;
+				goto unlock;
 			}
 
 			if (msg[i + 1].len > sizeof(st->buf)) {
 				deb_info("i2c xfer buffer to small for %d\n",
 					msg[i].len);
-				return -EIO;
+				result = -EIO;
+				goto unlock;
 			}
 			memcpy(msg[i + 1].buf, st->buf, msg[i + 1].len);
 
@@ -334,14 +337,17 @@ static int dib0700_i2c_xfer_legacy(struct i2c_adapter *adap,
 			i++;
 		} else {
 			st->buf[0] = REQUEST_I2C_WRITE;
-			if (dib0700_ctrl_wr(d, st->buf, msg[i].len + 2) < 0)
-				break;
+			result = dib0700_ctrl_wr(d, st->buf, msg[i].len + 2);
+			if (result < 0)
+				goto unlock;
 		}
 	}
+	result = i;
+unlock:
 	mutex_unlock(&d->usb_mutex);
 	mutex_unlock(&d->i2c_mutex);
 
-	return i;
+	return result;
 }
 
 static int dib0700_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msg,
