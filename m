Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21049 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425861AbdD1Mww (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 08:52:52 -0400
Date: Fri, 28 Apr 2017 15:52:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Patrick Boettcher <patrick.boettcher@posteo.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sean Young <sean@mess.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Kees Cook <keescook@chromium.org>,
        Johan Hovold <johan@kernel.org>, linux-media@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] [media] dib0700: fix locking in dib0700_i2c_xfer_new()
Message-ID: <20170428125207.skjv7ak2nmwltxik@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch mostly adds unlocks to error paths.  But one additional small
change is that I made the first "break;" a "goto unlock;" which means
that now we return failure instead of success on that path.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index 08acdd32e412..4dea79718827 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -215,13 +215,14 @@ static int dib0700_i2c_xfer_new(struct i2c_adapter *adap, struct i2c_msg *msg,
 						 USB_CTRL_GET_TIMEOUT);
 			if (result < 0) {
 				deb_info("i2c read error (status = %d)\n", result);
-				break;
+				goto unlock;
 			}
 
 			if (msg[i].len > sizeof(st->buf)) {
 				deb_info("buffer too small to fit %d bytes\n",
 					 msg[i].len);
-				return -EIO;
+				result = -EIO;
+				goto unlock;
 			}
 
 			memcpy(msg[i].buf, st->buf, msg[i].len);
@@ -233,8 +234,8 @@ static int dib0700_i2c_xfer_new(struct i2c_adapter *adap, struct i2c_msg *msg,
 			/* Write request */
 			if (mutex_lock_interruptible(&d->usb_mutex) < 0) {
 				err("could not acquire lock");
-				mutex_unlock(&d->i2c_mutex);
-				return -EINTR;
+				result = -EINTR;
+				goto unlock;
 			}
 			st->buf[0] = REQUEST_NEW_I2C_WRITE;
 			st->buf[1] = msg[i].addr << 1;
@@ -247,7 +248,9 @@ static int dib0700_i2c_xfer_new(struct i2c_adapter *adap, struct i2c_msg *msg,
 			if (msg[i].len > sizeof(st->buf) - 4) {
 				deb_info("i2c message to big: %d\n",
 					 msg[i].len);
-				return -EIO;
+				mutex_unlock(&d->usb_mutex);
+				result = -EIO;
+				goto unlock;
 			}
 
 			/* The Actual i2c payload */
@@ -269,8 +272,11 @@ static int dib0700_i2c_xfer_new(struct i2c_adapter *adap, struct i2c_msg *msg,
 			}
 		}
 	}
+	result = i;
+
+unlock:
 	mutex_unlock(&d->i2c_mutex);
-	return i;
+	return result;
 }
 
 /*
