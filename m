Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50262 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbcF2Xj7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 19:39:59 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/5] m88ds3103: remove useless most significant bit clear
Date: Thu, 30 Jun 2016 02:39:44 +0300
Message-Id: <1467243588-26204-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No need to clear negative msb bits as those were dropped in any
case when data is written to register.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index 5557ef8..7c19601 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -605,9 +605,6 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 
 	s32tmp = 0x10000 * (tuner_frequency - c->frequency);
 	s32tmp = DIV_ROUND_CLOSEST(s32tmp, dev->mclk_khz);
-	if (s32tmp < 0)
-		s32tmp += 0x10000;
-
 	buf[0] = (s32tmp >> 0) & 0xff;
 	buf[1] = (s32tmp >> 8) & 0xff;
 	ret = regmap_bulk_write(dev->regmap, 0x5e, buf, 2);
-- 
http://palosaari.fi/

