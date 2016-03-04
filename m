Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:35735 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760201AbcCDVfA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2016 16:35:00 -0500
From: Matthieu Rogez <matthieu.rogez@gmail.com>
To: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Matthieu Rogez <matthieu.rogez@gmail.com>
Subject: [PATCH] [media] em28xx: fix Terratec Grabby AC97 codec detection
Date: Fri,  4 Mar 2016 22:33:08 +0100
Message-Id: <1457127188-7574-2-git-send-email-matthieu.rogez@gmail.com>
In-Reply-To: <1457127188-7574-1-git-send-email-matthieu.rogez@gmail.com>
References: <20160303142621.62325571@recife.lan>
 <1457127188-7574-1-git-send-email-matthieu.rogez@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

EMP202 chip inside Terratec Grabby (hw rev 2) seems to require some time
before accessing reliably its registers. Otherwise it returns some values
previously put on the I2C bus.

To account for that period, we delay card setup until we have a proof that
accessing AC97 registers is reliable. We get this proof by polling
AC97_RESET until the expected value is read. We also check that unrelated
registers don't return the same value. This second check handles the case
where the expected value is constantly returned no matter which register
is accessed.

Signed-off-by: Matthieu Rogez <matthieu.rogez@gmail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 38 +++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 5e127e4..930e3e3 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -37,6 +37,7 @@
 #include <media/i2c-addr.h>
 #include <media/tveeprom.h>
 #include <media/v4l2-common.h>
+#include <sound/ac97_codec.h>
 
 #include "em28xx.h"
 
@@ -2563,6 +2564,36 @@ static inline void em28xx_set_model(struct em28xx *dev)
 	dev->def_i2c_bus = dev->board.def_i2c_bus;
 }
 
+/* Wait until AC97_RESET reports the expected value reliably before proceeding.
+ * We also check that two unrelated registers accesses don't return the same
+ * value to avoid premature return.
+ * This procedure helps ensuring AC97 register accesses are reliable.
+ */
+static int em28xx_wait_until_ac97_features_equals(struct em28xx *dev,
+						  int expected_feat)
+{
+	unsigned long timeout = jiffies + msecs_to_jiffies(2000);
+	int feat, powerdown;
+
+	while (time_is_after_jiffies(timeout)) {
+		feat = em28xx_read_ac97(dev, AC97_RESET);
+		if (feat < 0)
+			return feat;
+
+		powerdown = em28xx_read_ac97(dev, AC97_POWERDOWN);
+		if (powerdown < 0)
+			return powerdown;
+
+		if (feat == expected_feat && feat != powerdown)
+			return 0;
+
+		msleep(50);
+	}
+
+	em28xx_warn("AC97 registers access is not reliable !\n");
+	return -ETIMEDOUT;
+}
+
 /* Since em28xx_pre_card_setup() requires a proper dev->model,
  * this won't work for boards with generic PCI IDs
  */
@@ -2668,6 +2699,13 @@ static void em28xx_pre_card_setup(struct em28xx *dev)
 		em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xfd);
 		msleep(70);
 		break;
+
+	case EM2860_BOARD_TERRATEC_GRABBY:
+		/* HACK?: Ensure AC97 register reading is reliable before
+		 * proceeding. In practice, this will wait about 1.6 seconds.
+		 */
+		em28xx_wait_until_ac97_features_equals(dev, 0x6a90);
+		break;
 	}
 
 	em28xx_gpio_set(dev, dev->board.tuner_gpio);
-- 
2.7.2

