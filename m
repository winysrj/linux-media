Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46999 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaKDUdx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Nov 2014 15:33:53 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH] [media] af0933: Don't go past to clock_adc_lut buffer
Date: Tue,  4 Nov 2014 18:33:41 -0200
Message-Id: <61ce848ee5667d448a6f890f1cc426fc077d5f5c.1415133218.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following sparse warnings:
	drivers/media/dvb-frontends/af9033.c:295 af9033_init() error: buffer overflow 'clock_adc_lut' 11 <= 11
	drivers/media/dvb-frontends/af9033.c:300 af9033_init() error: buffer overflow 'clock_adc_lut' 11 <= 11
	drivers/media/dvb-frontends/af9033.c:584 af9033_set_frontend() error: buffer overflow 'coeff_lut' 3 <= 3
	drivers/media/dvb-frontends/af9033.c:595 af9033_set_frontend() error: buffer overflow 'clock_adc_lut' 11 <= 11

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index c17e34fd0fb4..82ce47bdf5dc 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -291,6 +291,12 @@ static int af9033_init(struct dvb_frontend *fe)
 		if (clock_adc_lut[i].clock == dev->cfg.clock)
 			break;
 	}
+	if (i == ARRAY_SIZE(clock_adc_lut)) {
+		dev_err(&dev->client->dev,
+			"Couldn't find ADC config for clock=%d\n",
+			dev->cfg.clock);
+		goto err;
+	}
 
 	adc_cw = af9033_div(dev, clock_adc_lut[i].adc, 1000000ul, 19ul);
 	buf[0] = (adc_cw >>  0) & 0xff;
@@ -580,7 +586,15 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 				break;
 			}
 		}
-		ret =  af9033_wr_regs(dev, 0x800001,
+		if (i == ARRAY_SIZE(coeff_lut)) {
+			dev_err(&dev->client->dev,
+				"Couldn't find LUT config for clock=%d\n",
+				dev->cfg.clock);
+			ret = -EINVAL;
+			goto err;
+		}
+
+		ret = af9033_wr_regs(dev, 0x800001,
 				coeff_lut[i].val, sizeof(coeff_lut[i].val));
 	}
 
@@ -592,6 +606,13 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 			if (clock_adc_lut[i].clock == dev->cfg.clock)
 				break;
 		}
+		if (i == ARRAY_SIZE(clock_adc_lut)) {
+			dev_err(&dev->client->dev,
+				"Couldn't find ADC clock for clock=%d\n",
+				dev->cfg.clock);
+			ret = -EINVAL;
+			goto err;
+		}
 		adc_freq = clock_adc_lut[i].adc;
 
 		/* get used IF frequency */
-- 
1.9.3

