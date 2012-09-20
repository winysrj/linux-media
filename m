Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54606 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab2ITBGd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 21:06:33 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 2/3] em28xx: PCTV 290e sleep tda18271 after attach
Date: Thu, 20 Sep 2012 04:05:29 +0300
Message-Id: <1348103130-1777-2-git-send-email-crope@iki.fi>
In-Reply-To: <1348103130-1777-1-git-send-email-crope@iki.fi>
References: <1348103130-1777-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reduces device IDLE power consumption 180mA (260mA => 80mA).

I would like to see solution where tda18271 driver puts chips on
sleep by default and leaves it powered according to driver config
option. Michael declined it, as it could cause regression, and
asked to sleep explicitly after attach.

Cc: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index be242ac..c97ffc6 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1002,6 +1002,16 @@ static int em28xx_dvb_init(struct em28xx *dev)
 				goto out_free;
 			}
 
+			/*
+			 * We should put tda18271 explicitly sleep in order to
+			 * reduce IDLE power consumption 180mA
+			 */
+			result = dvb->fe[0]->ops.tuner_ops.sleep(dvb->fe[0]);
+			if (result) {
+				dvb_frontend_detach(dvb->fe[0]);
+				goto out_free;
+			}
+
 #ifdef CONFIG_GPIOLIB
 			/* enable LNA for DVB-T, DVB-T2 and DVB-C */
 			result = gpio_request_one(dvb->gpio,
-- 
1.7.11.4

