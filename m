Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34234 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757300AbcB1L0l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2016 06:26:41 -0500
From: Matthieu Rogez <matthieu.rogez@gmail.com>
To: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Matthieu Rogez <matthieu.rogez@gmail.com>
Subject: [PATCH 3/3] [media] em28xx: fix Terratec Grabby AC97 codec detection
Date: Sun, 28 Feb 2016 12:26:23 +0100
Message-Id: <1456658783-32345-4-git-send-email-matthieu.rogez@gmail.com>
In-Reply-To: <1456658783-32345-1-git-send-email-matthieu.rogez@gmail.com>
References: <1456658783-32345-1-git-send-email-matthieu.rogez@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

EMP202 chip inside Terratec Grabby (hw rev 2) seems to require some time before
accessing reliably its registers. Otherwise it returns some values previously
put on the I2C bus.

To account for that period, we delay card setup until we have a proof that
accessing AC97 registers is reliable. We get this proof by polling AC97_RESET
until the expected value is read.

Signed-off-by: Matthieu Rogez <matthieu.rogez@gmail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 5e127e4..2e04902 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -37,6 +37,7 @@
 #include <media/i2c-addr.h>
 #include <media/tveeprom.h>
 #include <media/v4l2-common.h>
+#include <sound/ac97_codec.h>
 
 #include "em28xx.h"
 
@@ -2563,6 +2564,24 @@ static inline void em28xx_set_model(struct em28xx *dev)
 	dev->def_i2c_bus = dev->board.def_i2c_bus;
 }
 
+/* Wait until AC97_RESET reports the expected value (or reading error)
+ * before proceeding.
+ * This can help ensuring AC97 register accesses are reliable.
+ */
+static int em28xx_wait_until_ac97_features_equals(struct em28xx *dev,
+						  int expected_feat)
+{
+	int feat;
+
+	do {
+		feat = em28xx_read_ac97(dev, AC97_RESET);
+		if (feat < 0)
+			return feat;
+	} while (feat != expected_feat);
+
+	return 0;
+}
+
 /* Since em28xx_pre_card_setup() requires a proper dev->model,
  * this won't work for boards with generic PCI IDs
  */
@@ -2668,6 +2687,13 @@ static void em28xx_pre_card_setup(struct em28xx *dev)
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
2.7.1

