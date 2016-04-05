Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:38336 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbcDEWXw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2016 18:23:52 -0400
Received: by mail-wm0-f50.google.com with SMTP id u206so21978582wme.1
        for <linux-media@vger.kernel.org>; Tue, 05 Apr 2016 15:23:50 -0700 (PDT)
From: Alessandro Radicati <alessandro@radicati.net>
To: crope@iki.fi
Cc: linux-media@vger.kernel.org
Subject: [PATCH] media: af9035 I2C combined write + read transaction fix
Date: Wed,  6 Apr 2016 00:23:43 +0200
Message-Id: <1459895023-9593-1-git-send-email-alessandro@radicati.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch will modify the af9035 driver to use the register address
fields of the I2C read command for the combined write/read transaction
case.  Without this change, the firmware issues just a I2C read transaction
without the preceding write transaction to select the register.

Signed-off-by: Alessandro Radicati <alessandro@radicati.net>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 2638e32..09a549b 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -367,10 +367,25 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 				memcpy(&buf[3], msg[0].buf, msg[0].len);
 			} else {
 				buf[1] = msg[0].addr << 1;
-				buf[2] = 0x00; /* reg addr len */
 				buf[3] = 0x00; /* reg addr MSB */
 				buf[4] = 0x00; /* reg addr LSB */
-				memcpy(&buf[5], msg[0].buf, msg[0].len);
+
+				/* Keep prev behavior for write req len > 2*/
+				if (msg[0].len > 2) {
+					buf[2] = 0x00; /* reg addr len */
+					memcpy(&buf[5], msg[0].buf, msg[0].len);
+
+				/* Use reg addr fields if write req len <= 2 */
+				} else {
+					req.wlen = 5;
+					buf[2] = msg[0].len;
+					if (msg[0].len == 2) {
+						buf[3] = msg[0].buf[0];
+						buf[4] = msg[0].buf[1];
+					} else if (msg[0].len == 1) {
+						buf[4] = msg[0].buf[0];
+					}
+				}
 			}
 			ret = af9035_ctrl_msg(d, &req);
 		}
-- 
2.5.0

