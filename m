Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43555 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbbGIEGz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jul 2015 00:06:55 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 01/12] em28xx: remove unused a8293 SEC config
Date: Thu,  9 Jul 2015 07:06:21 +0300
Message-Id: <1436414792-9716-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devices that were using a8293 SEC are converted to I2C platform data
thus that old config structure is left unused.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index a382483..357be76 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -808,10 +808,6 @@ static struct tda18271_config em28xx_cxd2820r_tda18271_config = {
 	.gate = TDA18271_GATE_DIGITAL,
 };
 
-static const struct a8293_config em28xx_a8293_config = {
-	.i2c_addr = 0x08, /* (0x10 >> 1) */
-};
-
 static struct zl10353_config em28xx_zl10353_no_i2c_gate_dev = {
 	.demod_address = (0x1e >> 1),
 	.disable_i2c_gate_ctrl = 1,
-- 
http://palosaari.fi/

