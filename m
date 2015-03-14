Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52883 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbbCNQtN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2015 12:49:13 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] rtl2832: disable regmap register cache
Date: Sat, 14 Mar 2015 18:48:53 +0200
Message-Id: <1426351734-30836-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Caching register reads causes some random I/O errors on channel
change. Disable caching now in order to avoid those errors.

Reverts partly commit dcadb82

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 5d2d8f4..67faa8d 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -1240,7 +1240,7 @@ static int rtl2832_probe(struct i2c_client *client,
 	dev->regmap_config.max_register = 5 * 0x100,
 	dev->regmap_config.ranges = regmap_range_cfg,
 	dev->regmap_config.num_ranges = ARRAY_SIZE(regmap_range_cfg),
-	dev->regmap_config.cache_type = REGCACHE_RBTREE,
+	dev->regmap_config.cache_type = REGCACHE_NONE,
 	dev->regmap = regmap_init(&client->dev, &regmap_bus, client,
 				  &dev->regmap_config);
 	if (IS_ERR(dev->regmap)) {
-- 
http://palosaari.fi/

