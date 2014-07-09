Return-path: <linux-media-owner@vger.kernel.org>
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:55248 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751979AbaGIUg0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Jul 2014 16:36:26 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: em28xx - add error handling for KWORLD dvb_attach failures
Date: Wed,  9 Jul 2014 14:36:23 -0600
Message-Id: <1404938183-29535-1-git-send-email-shuah.kh@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add error hanlding when EM2870_BOARD_KWORLD_A340 dvb_attach()
for fe and tuner fail in em28xx_dvb_init().

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-dvb.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index d381861..8314f51 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1213,9 +1213,17 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		dvb->fe[0] = dvb_attach(lgdt3305_attach,
 					   &em2870_lgdt3304_dev,
 					   &dev->i2c_adap[dev->def_i2c_bus]);
-		if (dvb->fe[0] != NULL)
-			dvb_attach(tda18271_attach, dvb->fe[0], 0x60,
-				   &dev->i2c_adap[dev->def_i2c_bus], &kworld_a340_config);
+		if (!dvb->fe[0]) {
+			result = -EINVAL;
+			goto out_free;
+		}
+		if (!dvb_attach(tda18271_attach, dvb->fe[0], 0x60,
+			&dev->i2c_adap[dev->def_i2c_bus],
+			&kworld_a340_config)) {
+				dvb_frontend_detach(dvb->fe[0]);
+				result = -EINVAL;
+				goto out_free;
+		}
 		break;
 	case EM28174_BOARD_PCTV_290E:
 		/* set default GPIO0 for LNA, used if GPIOLIB is undefined */
-- 
1.7.10.4

