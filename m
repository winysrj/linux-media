Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43125 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbaLRVGG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 16:06:06 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 1/2] regmap: pass map name to lockdep
Date: Thu, 18 Dec 2014 23:05:16 +0200
Message-Id: <1418936717-2806-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

lockdep complains recursive locking and deadlock when two different
regmap instances are called in a nested order. That happen easily
for example when both I2C client and muxed/repeater I2C adapter are
using regmap. As a solution, pass regmap name for lockdep in order
to force lockdep validate regmap mutex per driver - not as all regmap
instances grouped together.

Here is example connection, where nested regmap is used to control
I2C mux.
 __________         ___________         ___________
|  USB IF  |       |   demod   |       |   tuner   |
|----------|       |-----------|       |-----------|
|          |--I2C--|-----/ ----|--I2C--|           |
|I2C master|       |  I2C mux  |       | I2C slave |
|__________|       |___________|       |___________|

Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/base/regmap/regmap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index d2f8a81..8d8ad37 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -559,6 +559,12 @@ struct regmap *regmap_init(struct device *dev,
 			mutex_init(&map->mutex);
 			map->lock = regmap_lock_mutex;
 			map->unlock = regmap_unlock_mutex;
+			if (config->name) {
+				static struct lock_class_key key;
+
+				lockdep_set_class_and_name(&map->mutex, &key,
+							   config->name);
+			}
 		}
 		map->lock_arg = map;
 	}
-- 
http://palosaari.fi/

