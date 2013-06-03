Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44494 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758856Ab3FCWzY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Jun 2013 18:55:24 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/4] af9035: implement I2C adapter read operation
Date: Tue,  4 Jun 2013 01:54:23 +0300
Message-Id: <1370300066-13964-2-git-send-email-crope@iki.fi>
In-Reply-To: <1370300066-13964-1-git-send-email-crope@iki.fi>
References: <1370300066-13964-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index b638fc1..cfcf79b 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -268,11 +268,29 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 			memcpy(&buf[5], msg[0].buf, msg[0].len);
 			ret = af9035_ctrl_msg(d, &req);
 		}
+	} else if (num == 1 && (msg[0].flags & I2C_M_RD)) {
+		if (msg[0].len > 40) {
+			/* TODO: correct limits > 40 */
+			ret = -EOPNOTSUPP;
+		} else {
+			/* I2C */
+			u8 buf[5];
+			struct usb_req req = { CMD_I2C_RD, 0, sizeof(buf),
+					buf, msg[0].len, msg[0].buf };
+			req.mbox |= ((msg[0].addr & 0x80)  >>  3);
+			buf[0] = msg[0].len;
+			buf[1] = msg[0].addr << 1;
+			buf[2] = 0x00; /* reg addr len */
+			buf[3] = 0x00; /* reg addr MSB */
+			buf[4] = 0x00; /* reg addr LSB */
+			ret = af9035_ctrl_msg(d, &req);
+		}
 	} else {
 		/*
-		 * We support only two kind of I2C transactions:
-		 * 1) 1 x read + 1 x write
+		 * We support only three kind of I2C transactions:
+		 * 1) 1 x read + 1 x write (repeated start)
 		 * 2) 1 x write
+		 * 3) 1 x read
 		 */
 		ret = -EOPNOTSUPP;
 	}
-- 
1.7.11.7

