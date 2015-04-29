Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37639 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbbD2XG0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 19:06:26 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 01/27] qt1010: avoid going past array
Date: Wed, 29 Apr 2015 20:05:46 -0300
Message-Id: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:
	drivers/media/tuners/qt1010.c:357 qt1010_init() error: buffer overflow 'i2c_data' 34 <= 34

This should not happen with the current code, as the i2c_data array
doesn't end with a QT1010_M1, but it doesn't hurt add a BUG_ON
to notify if one modifies it and breaks.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/tuners/qt1010.c b/drivers/media/tuners/qt1010.c
index 74b6b17cdbaf..ae8cbece6d2b 100644
--- a/drivers/media/tuners/qt1010.c
+++ b/drivers/media/tuners/qt1010.c
@@ -354,13 +354,17 @@ static int qt1010_init(struct dvb_frontend *fe)
 				valptr = &priv->reg1f_init_val;
 			else
 				valptr = &tmpval;
+
+			BUG_ON(i >= ARRAY_SIZE(i2c_data) - 1);
+
 			err = qt1010_init_meas1(priv, i2c_data[i+1].reg,
 						i2c_data[i].reg,
 						i2c_data[i].val, valptr);
 			i++;
 			break;
 		}
-		if (err) return err;
+		if (err)
+			return err;
 	}
 
 	for (i = 0x31; i < 0x3a; i++) /* 0x31 - 0x39 */
-- 
2.1.0

