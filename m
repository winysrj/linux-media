Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49142 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab2DBXcx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Apr 2012 19:32:53 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Michael Buesch <m@bues.ch>,
	Hans-Frieder Vogt <hfvogt@gmx.net>,
	Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] af9035: fix and enhance I2C adapter
Date: Tue,  3 Apr 2012 02:32:35 +0300
Message-Id: <1333409555-679-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There was a bug I2C adapter writes and reads one byte too much.
As the most I2C clients has auto-increment register addressing
this leads next register from the target register overwritten by
garbage data.

As a change remove whole register address byte usage and write
data directly to the I2C bus without saying what are register
address bytes to firmware.

Signed-off-by: Antti Palosaari <crope@iki.fi>
Cc: Michael Buesch <m@bues.ch>
Cc: Hans-Frieder Vogt <hfvogt@gmx.net>
Cc: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/dvb/dvb-usb/af9035.c |   34 ++++++++++++++++++++++++++--------
 1 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9035.c b/drivers/media/dvb/dvb-usb/af9035.c
index 131ead2..83859c4 100644
--- a/drivers/media/dvb/dvb-usb/af9035.c
+++ b/drivers/media/dvb/dvb-usb/af9035.c
@@ -224,6 +224,22 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
 		return -EAGAIN;
 
+	/*
+	 * I2C sub header is 5 bytes long. Meaning of those bytes are:
+	 * 0: data len
+	 * 1: I2C addr << 1
+	 * 2: reg addr len
+	 *    byte 3 and 4 can be used as reg addr
+	 * 3: reg addr MSB
+	 *    used when reg addr len is set to 2
+	 * 4: reg addr LSB
+	 *    used when reg addr len is set to 1 or 2
+	 *
+	 * For the simplify we do not use register addr at all.
+	 * NOTE: As a firmware knows tuner type there is very small possibility
+	 * there could be some tuner I2C hacks done by firmware and this may
+	 * lead problems if firmware expects those bytes are used.
+	 */
 	if (num == 2 && !(msg[0].flags & I2C_M_RD) &&
 			(msg[1].flags & I2C_M_RD)) {
 		if (msg[0].len > 40 || msg[1].len > 40) {
@@ -237,14 +253,15 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 					msg[1].len);
 		} else {
 			/* I2C */
-			u8 buf[4 + msg[0].len];
+			u8 buf[5 + msg[0].len];
 			struct usb_req req = { CMD_I2C_RD, 0, sizeof(buf),
 					buf, msg[1].len, msg[1].buf };
 			buf[0] = msg[1].len;
 			buf[1] = msg[0].addr << 1;
-			buf[2] = 0x01;
-			buf[3] = 0x00;
-			memcpy(&buf[4], msg[0].buf, msg[0].len);
+			buf[2] = 0x00; /* reg addr len */
+			buf[3] = 0x00; /* reg addr MSB */
+			buf[4] = 0x00; /* reg addr LSB */
+			memcpy(&buf[5], msg[0].buf, msg[0].len);
 			ret = af9035_ctrl_msg(d->udev, &req);
 		}
 	} else if (num == 1 && !(msg[0].flags & I2C_M_RD)) {
@@ -259,14 +276,15 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 					msg[0].len - 3);
 		} else {
 			/* I2C */
-			u8 buf[4 + msg[0].len];
+			u8 buf[5 + msg[0].len];
 			struct usb_req req = { CMD_I2C_WR, 0, sizeof(buf), buf,
 					0, NULL };
 			buf[0] = msg[0].len;
 			buf[1] = msg[0].addr << 1;
-			buf[2] = 0x01;
-			buf[3] = 0x00;
-			memcpy(&buf[4], msg[0].buf, msg[0].len);
+			buf[2] = 0x00; /* reg addr len */
+			buf[3] = 0x00; /* reg addr MSB */
+			buf[4] = 0x00; /* reg addr LSB */
+			memcpy(&buf[5], msg[0].buf, msg[0].len);
 			ret = af9035_ctrl_msg(d->udev, &req);
 		}
 	} else {
-- 
1.7.7.6

