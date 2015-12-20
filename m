Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:32912 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421AbbLTCDy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Dec 2015 21:03:54 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] rtl28xxu: return demod reg page from driver cache
Date: Sun, 20 Dec 2015 04:03:34 +0200
Message-Id: <1450577015-29465-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Return current active rtl2830/rtl2832 register page from the driver
cache in order to reduce I2C I/O. Register page is already cached
due to I2C write needs.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 5a503a6..eb5787a 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -181,11 +181,17 @@ static int rtl28xxu_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			goto err_mutex_unlock;
 		} else if (msg[0].addr == 0x10) {
 			/* method 1 - integrated demod */
-			req.value = (msg[0].buf[0] << 8) | (msg[0].addr << 1);
-			req.index = CMD_DEMOD_RD | dev->page;
-			req.size = msg[1].len;
-			req.data = &msg[1].buf[0];
-			ret = rtl28xxu_ctrl_msg(d, &req);
+			if (msg[0].buf[0] == 0x00) {
+				/* return demod page from driver cache */
+				msg[1].buf[0] = dev->page;
+				ret = 0;
+			} else {
+				req.value = (msg[0].buf[0] << 8) | (msg[0].addr << 1);
+				req.index = CMD_DEMOD_RD | dev->page;
+				req.size = msg[1].len;
+				req.data = &msg[1].buf[0];
+				ret = rtl28xxu_ctrl_msg(d, &req);
+			}
 		} else if (msg[0].len < 2) {
 			/* method 2 - old I2C */
 			req.value = (msg[0].buf[0] << 8) | (msg[0].addr << 1);
-- 
http://palosaari.fi/

