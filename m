Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59990 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756611AbaLWUue (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:34 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 41/66] rtl2832: use regmap reg cache
Date: Tue, 23 Dec 2014 22:49:34 +0200
Message-Id: <1419367799-14263-41-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable regmap register cache in order to reduce IO.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index b8e7971..4b6e6e0 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -986,6 +986,22 @@ static struct dvb_frontend_ops rtl2832_ops = {
 	.read_ber = rtl2832_read_ber,
 };
 
+static bool rtl2832_volatile_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case 0x305:
+	case 0x33c:
+	case 0x34e:
+	case 0x351:
+	case 0x40c ... 0x40d:
+		return true;
+	default:
+		break;
+	}
+
+	return false;
+}
+
 /*
  * We implement own I2C access routines for regmap in order to get manual access
  * to I2C adapter lock, which is needed for I2C mux adapter.
@@ -1240,9 +1256,11 @@ static int rtl2832_probe(struct i2c_client *client,
 	static const struct regmap_config regmap_config = {
 		.reg_bits    =  8,
 		.val_bits    =  8,
+		.volatile_reg = rtl2832_volatile_reg,
 		.max_register = 5 * 0x100,
 		.ranges = regmap_range_cfg,
 		.num_ranges = ARRAY_SIZE(regmap_range_cfg),
+		.cache_type = REGCACHE_RBTREE,
 	};
 
 	dev_dbg(&client->dev, "\n");
-- 
http://palosaari.fi/

