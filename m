Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37850 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755614AbaIDChD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:03 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 26/37] af9035: few small I2C master xfer changes
Date: Thu,  4 Sep 2014 05:36:34 +0300
Message-Id: <1409798205-25645-26-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Biggest problem of that function is complexity. Try reduce complexity:

* define macros to detect all 3 supported xfers
* remove duplicate message maximum size checks

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 37 +++++++++++++----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 6534e44..ec62133 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -319,8 +319,14 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 	 * bus, having same slave address. Due to that we reuse demod address,
 	 * shifted by one bit, on that case.
 	 */
-	if (num == 2 && !(msg[0].flags & I2C_M_RD) &&
-			(msg[1].flags & I2C_M_RD)) {
+#define AF9035_IS_I2C_XFER_WRITE_READ(_msg, _num) \
+	(_num == 2 && !(_msg[0].flags & I2C_M_RD) && (_msg[1].flags & I2C_M_RD))
+#define AF9035_IS_I2C_XFER_WRITE(_msg, _num) \
+	(_num == 1 && !(_msg[0].flags & I2C_M_RD))
+#define AF9035_IS_I2C_XFER_READ(_msg, _num) \
+	(_num == 1 && (_msg[0].flags & I2C_M_RD))
+
+	if (AF9035_IS_I2C_XFER_WRITE_READ(msg, num)) {
 		if (msg[0].len > 40 || msg[1].len > 40) {
 			/* TODO: correct limits > 40 */
 			ret = -EOPNOTSUPP;
@@ -338,18 +344,11 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 			ret = af9035_rd_regs(d, reg, &msg[1].buf[0],
 					msg[1].len);
 		} else {
-			/* I2C */
+			/* I2C write + read */
 			u8 buf[MAX_XFER_SIZE];
 			struct usb_req req = { CMD_I2C_RD, 0, 5 + msg[0].len,
 					buf, msg[1].len, msg[1].buf };
 
-			if (5 + msg[0].len > sizeof(buf)) {
-				dev_warn(&d->udev->dev,
-					 "%s: i2c xfer: len=%d is too big!\n",
-					 KBUILD_MODNAME, msg[0].len);
-				ret = -EOPNOTSUPP;
-				goto unlock;
-			}
 			req.mbox |= ((msg[0].addr & 0x80)  >>  3);
 			buf[0] = msg[1].len;
 			buf[1] = msg[0].addr << 1;
@@ -359,7 +358,7 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 			memcpy(&buf[5], msg[0].buf, msg[0].len);
 			ret = af9035_ctrl_msg(d, &req);
 		}
-	} else if (num == 1 && !(msg[0].flags & I2C_M_RD)) {
+	} else if (AF9035_IS_I2C_XFER_WRITE(msg, num)) {
 		if (msg[0].len > 40) {
 			/* TODO: correct limits > 40 */
 			ret = -EOPNOTSUPP;
@@ -377,18 +376,11 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 			ret = af9035_wr_regs(d, reg, &msg[0].buf[3],
 					msg[0].len - 3);
 		} else {
-			/* I2C */
+			/* I2C write */
 			u8 buf[MAX_XFER_SIZE];
 			struct usb_req req = { CMD_I2C_WR, 0, 5 + msg[0].len,
 					buf, 0, NULL };
 
-			if (5 + msg[0].len > sizeof(buf)) {
-				dev_warn(&d->udev->dev,
-					 "%s: i2c xfer: len=%d is too big!\n",
-					 KBUILD_MODNAME, msg[0].len);
-				ret = -EOPNOTSUPP;
-				goto unlock;
-			}
 			req.mbox |= ((msg[0].addr & 0x80)  >>  3);
 			buf[0] = msg[0].len;
 			buf[1] = msg[0].addr << 1;
@@ -398,12 +390,12 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 			memcpy(&buf[5], msg[0].buf, msg[0].len);
 			ret = af9035_ctrl_msg(d, &req);
 		}
-	} else if (num == 1 && (msg[0].flags & I2C_M_RD)) {
+	} else if (AF9035_IS_I2C_XFER_READ(msg, num)) {
 		if (msg[0].len > 40) {
 			/* TODO: correct limits > 40 */
 			ret = -EOPNOTSUPP;
 		} else {
-			/* I2C */
+			/* I2C read */
 			u8 buf[5];
 			struct usb_req req = { CMD_I2C_RD, 0, sizeof(buf),
 					buf, msg[0].len, msg[0].buf };
@@ -418,14 +410,13 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 	} else {
 		/*
 		 * We support only three kind of I2C transactions:
-		 * 1) 1 x read + 1 x write (repeated start)
+		 * 1) 1 x write + 1 x read (repeated start)
 		 * 2) 1 x write
 		 * 3) 1 x read
 		 */
 		ret = -EOPNOTSUPP;
 	}
 
-unlock:
 	mutex_unlock(&d->i2c_mutex);
 
 	if (ret < 0)
-- 
http://palosaari.fi/

