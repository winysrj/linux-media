Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56252 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932387AbaBAUog (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Feb 2014 15:44:36 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Robert Schlabbach <Robert.Schlabbach@gmx.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/4] m88ds3103: remove dead code 2nd part
Date: Sat,  1 Feb 2014 22:44:16 +0200
Message-Id: <1391287458-11939-2-git-send-email-crope@iki.fi>
In-Reply-To: <1391287458-11939-1-git-send-email-crope@iki.fi>
References: <1391287458-11939-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Coverity CID 1166051: Logically dead code (DEADCODE)

TS clock calculation could be more accurate, but as it is not,
remove those unused clock speeds.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index e261bf9..c0a78d9 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -428,18 +428,10 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 		goto err;
 
 	switch (target_mclk) {
-	case 72000:
-		u8tmp1 = 0x00; /* 0b00 */
-		u8tmp2 = 0x03; /* 0b11 */
-		break;
 	case 96000:
 		u8tmp1 = 0x02; /* 0b10 */
 		u8tmp2 = 0x01; /* 0b01 */
 		break;
-	case 115200:
-		u8tmp1 = 0x01; /* 0b01 */
-		u8tmp2 = 0x01; /* 0b01 */
-		break;
 	case 144000:
 		u8tmp1 = 0x00; /* 0b00 */
 		u8tmp2 = 0x01; /* 0b01 */
@@ -448,10 +440,6 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 		u8tmp1 = 0x03; /* 0b11 */
 		u8tmp2 = 0x00; /* 0b00 */
 		break;
-	default:
-		dev_dbg(&priv->i2c->dev, "%s: invalid target_mclk\n", __func__);
-		ret = -EINVAL;
-		goto err;
 	}
 
 	ret = m88ds3103_wr_reg_mask(priv, 0x22, u8tmp1 << 6, 0xc0);
-- 
1.8.5.3

