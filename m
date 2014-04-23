Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53727 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620AbaDWCBW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Apr 2014 22:01:22 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] em28xx: PCTV tripleStick (292e) LNA support
Date: Wed, 23 Apr 2014 05:01:02 +0300
Message-Id: <1398218462-29539-2-git-send-email-crope@iki.fi>
In-Reply-To: <1398218462-29539-1-git-send-email-crope@iki.fi>
References: <1398218462-29539-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

External LNA between antenna connector and RF tuner is controlled
by EM28178 GPIO 0. GPIO value 1 is LNA active and value 0 is LNA
disabled.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index b79e08b..a121ed9 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -746,6 +746,21 @@ static int em28xx_pctv_290e_set_lna(struct dvb_frontend *fe)
 #endif
 }
 
+static int em28xx_pctv_292e_set_lna(struct dvb_frontend *fe)
+{
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	struct em28xx_i2c_bus *i2c_bus = fe->dvb->priv;
+	struct em28xx *dev = i2c_bus->dev;
+	u8 lna;
+
+	if (c->lna == 1)
+		lna = 0x01;
+	else
+		lna = 0x00;
+
+	return em28xx_write_reg_bits(dev, EM2874_R80_GPIO_P0_CTRL, lna, 0x01);
+}
+
 static int em28xx_mt352_terratec_xs_init(struct dvb_frontend *fe)
 {
 	/* Values extracted from a USB trace of the Terratec Windows driver */
@@ -1553,6 +1568,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			}
 
 			dvb->i2c_client_tuner = client;
+			dvb->fe[0]->ops.set_lna = em28xx_pctv_292e_set_lna;
 		}
 		break;
 	default:
-- 
1.9.0

