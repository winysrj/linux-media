Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45969 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab2ITBGF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 21:06:05 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/3] em28xx: do not set PCTV 290e LNA handler if fe attach fail
Date: Thu, 20 Sep 2012 04:05:28 +0300
Message-Id: <1348103130-1777-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It was a bug that could cause oops if demodulator attach was
failed.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index e0128b3..be242ac 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1001,19 +1001,22 @@ static int em28xx_dvb_init(struct em28xx *dev)
 				result = -EINVAL;
 				goto out_free;
 			}
-		}
 
 #ifdef CONFIG_GPIOLIB
-		/* enable LNA for DVB-T, DVB-T2 and DVB-C */
-		result = gpio_request_one(dvb->gpio, GPIOF_OUT_INIT_LOW, NULL);
-		if (result)
-			em28xx_errdev("gpio request failed %d\n", result);
-		else
-			gpio_free(dvb->gpio);
-
-		result = 0; /* continue even set LNA fails */
+			/* enable LNA for DVB-T, DVB-T2 and DVB-C */
+			result = gpio_request_one(dvb->gpio,
+					GPIOF_OUT_INIT_LOW, NULL);
+			if (result)
+				em28xx_errdev("gpio request failed %d\n",
+						result);
+			else
+				gpio_free(dvb->gpio);
+
+			result = 0; /* continue even set LNA fails */
 #endif
-		dvb->fe[0]->ops.set_lna = em28xx_pctv_290e_set_lna;
+			dvb->fe[0]->ops.set_lna = em28xx_pctv_290e_set_lna;
+		}
+
 		break;
 	case EM2884_BOARD_HAUPPAUGE_WINTV_HVR_930C:
 	{
-- 
1.7.11.4

