Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58873 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbaLTWfa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Dec 2014 17:35:30 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCHv2 1/2] regmap: add configurable lock class key for lockdep
Date: Sun, 21 Dec 2014 00:34:51 +0200
Message-Id: <1419114892-4550-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lockdep validator complains recursive locking and deadlock when two
different regmap instances are called in a nested order, as regmap
groups locks by default. That happens easily for example when both
I2C client and I2C adapter are using regmap. As a solution, add
configuration option to pass custom lock class key for lockdep
validator.

Here is example schema, where nested regmap calls are issued, when
more than 1 block uses regmap.
 __________         ___________         ___________
|  USB IF  |       |   demod   |       |   tuner   |
|----------|       |-----------|       |-----------|
|          |--I2C--|-----/ ----|--I2C--|           |
|I2C master|       |  I2C mux  |       | I2C slave |
|__________|       |___________|       |___________|

Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/base/regmap/regmap.c | 3 +++
 include/linux/regmap.h       | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index d2f8a81..56064d3 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -559,6 +559,9 @@ struct regmap *regmap_init(struct device *dev,
 			mutex_init(&map->mutex);
 			map->lock = regmap_lock_mutex;
 			map->unlock = regmap_unlock_mutex;
+			if (config->lockdep_lock_class_key)
+				lockdep_set_class(&map->mutex,
+						  config->lockdep_lock_class_key);
 		}
 		map->lock_arg = map;
 	}
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index c5ed83f..f930370 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -134,6 +134,10 @@ typedef void (*regmap_unlock)(void *);
  * @lock_arg:	  this field is passed as the only argument of lock/unlock
  *		  functions (ignored in case regular lock/unlock functions
  *		  are not overridden).
+ * @lock_class_key: Custom lock class key for lockdep validator. Use that when
+ *                regmap in question is used for bus master IO in order to avoid
+ *                false lockdep nested locking warning. Valid only when regmap
+ *                default mutex locking is used.
  * @reg_read:	  Optional callback that if filled will be used to perform
  *           	  all the reads from the registers. Should only be provided for
  *		  devices whose read operation cannot be represented as a simple
@@ -197,6 +201,7 @@ struct regmap_config {
 	regmap_lock lock;
 	regmap_unlock unlock;
 	void *lock_arg;
+	struct lock_class_key *lockdep_lock_class_key;
 
 	int (*reg_read)(void *context, unsigned int reg, unsigned int *val);
 	int (*reg_write)(void *context, unsigned int reg, unsigned int val);
-- 
http://palosaari.fi/

