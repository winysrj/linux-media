Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:56539 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752051AbdHZIbX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 04:31:23 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/3] media: rc: gpio-ir-tx: use ktime accessor functions
Date: Sat, 26 Aug 2017 09:31:21 +0100
Message-Id: <20170826083122.25812-2-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prefer using accessor functions so we are not dependent on the ktime_t
type.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/gpio-ir-tx.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/rc/gpio-ir-tx.c b/drivers/media/rc/gpio-ir-tx.c
index 0b83408a2e18..cd476cab9782 100644
--- a/drivers/media/rc/gpio-ir-tx.c
+++ b/drivers/media/rc/gpio-ir-tx.c
@@ -98,15 +98,17 @@ static int gpio_ir_tx(struct rc_dev *dev, unsigned int *txbuf,
 			// pulse
 			ktime_t last = ktime_add_us(edge, txbuf[i]);
 
-			while (ktime_get() < last) {
+			while (ktime_before(ktime_get(), last)) {
 				gpiod_set_value(gpio_ir->gpio, 1);
-				edge += pulse;
-				delta = edge - ktime_get();
+				edge = ktime_add_ns(edge, pulse);
+				delta = ktime_to_ns(ktime_sub(edge,
+							      ktime_get()));
 				if (delta > 0)
 					ndelay(delta);
 				gpiod_set_value(gpio_ir->gpio, 0);
-				edge += space;
-				delta = edge - ktime_get();
+				edge = ktime_add_ns(edge, space);
+				delta = ktime_to_ns(ktime_sub(edge,
+							      ktime_get()));
 				if (delta > 0)
 					ndelay(delta);
 			}
-- 
2.13.5
