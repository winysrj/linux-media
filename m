Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38020 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754305AbaCKJxv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 05:53:51 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Janne=20Kujanp=C3=A4=C3=A4?= <jikuja@iki.fi>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH] em28xx: fix PCTV 290e LNA oops
Date: Tue, 11 Mar 2014 11:53:16 +0200
Message-Id: <1394531596-19899-1-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pointer to device state has been moved to different location during
some change. PCTV 290e LNA function still uses old pointer, carried
over FE priv, and it crash.

Reported-by: Janne Kujanpää <jikuja@iki.fi>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 6638394..9b3f033 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -717,7 +717,8 @@ static void pctv_520e_init(struct em28xx *dev)
 static int em28xx_pctv_290e_set_lna(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	struct em28xx *dev = fe->dvb->priv;
+	struct em28xx_i2c_bus *i2c_bus = fe->dvb->priv;
+	struct em28xx *dev = i2c_bus->dev;
 #ifdef CONFIG_GPIOLIB
 	struct em28xx_dvb *dvb = dev->dvb;
 	int ret;
-- 
1.8.5.3

