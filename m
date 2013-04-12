Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35431 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910Ab3DLSAI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 14:00:08 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/3] em28xx: map remote for 1b80:e425
Date: Fri, 12 Apr 2013 20:59:03 +0300
Message-Id: <1365789544-18819-2-git-send-email-crope@iki.fi>
In-Reply-To: <1365789544-18819-1-git-send-email-crope@iki.fi>
References: <1365789544-18819-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Map RC_MAP_REDDO to that device.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 1d3866f..26ff1a7 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -1979,6 +1979,7 @@ struct em28xx_board em28xx_boards[] = {
 		.tuner_type    = TUNER_ABSENT,
 		.tuner_gpio    = maxmedia_ub425_tc,
 		.has_dvb       = 1,
+		.ir_codes      = RC_MAP_REDDO,
 		.def_i2c_bus   = 1,
 		.i2c_speed     = EM28XX_I2C_CLK_WAIT_ENABLE |
 				EM28XX_I2C_FREQ_400_KHZ,
-- 
1.7.11.7

