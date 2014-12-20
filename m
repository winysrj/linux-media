Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46850 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbaLTWfa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Dec 2014 17:35:30 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCHv2 2/2] rtl2832: use custom lock class key for regmap
Date: Sun, 21 Dec 2014 00:34:52 +0200
Message-Id: <1419114892-4550-2-git-send-email-crope@iki.fi>
In-Reply-To: <1419114892-4550-1-git-send-email-crope@iki.fi>
References: <1419114892-4550-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There was nested locking error shown by lockdep validator when both
demod and tuner drivers were using regmap. That is false positive
coming from the reason lockdep groups mutexes to 'classes'. That
leads situation both tuner driver and demod driver regmap mutex is
seen as a same mutex, even those are different ones in a real life.
Lockdep uses keys to separate these clock classes. Use custom class
key to demod regmap in order to separate it from mutex used by tuner
regmap, thus seen it as a different lock also from lockdep point of
view.

Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index f44dc50..6cfe5b6 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -1186,6 +1186,7 @@ static int rtl2832_probe(struct i2c_client *client,
 			.range_max        = 5 * 0x100,
 		},
 	};
+	static struct lock_class_key key;
 	static const struct regmap_config regmap_config = {
 		.reg_bits    =  8,
 		.val_bits    =  8,
@@ -1194,6 +1195,7 @@ static int rtl2832_probe(struct i2c_client *client,
 		.ranges = regmap_range_cfg,
 		.num_ranges = ARRAY_SIZE(regmap_range_cfg),
 		.cache_type = REGCACHE_RBTREE,
+		.lockdep_lock_class_key = &key,
 	};
 
 	dev_dbg(&client->dev, "\n");
-- 
http://palosaari.fi/

