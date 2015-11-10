Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:36835 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbbKJNjJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2015 08:39:09 -0500
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org, magnus.damm@gmail.com,
	laurent.pinchart@ideasonboard.com,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH] media: adv7180: increase delay after reset to 5ms
Date: Tue, 10 Nov 2015 14:39:00 +0100
Message-Id: <1447162740-28096-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Initialization of the ADV7180 chip fails on the Renesas R8A7790-based
Lager board about 50% of the time.  This patch resolves the issue by
increasing the minimum delay after reset from 2 ms to 5 ms, following the
recommendation in the ADV7180 datasheet:

"Executing a software reset takes approximately 2 ms. However, it is
recommended to wait 5 ms before any further I2C writes are performed."

Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
 drivers/media/i2c/adv7180.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index f82c8aa..3c3c4bf 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -1112,7 +1112,7 @@ static int init_device(struct adv7180_state *state)
 	mutex_lock(&state->mutex);
 
 	adv7180_write(state, ADV7180_REG_PWR_MAN, ADV7180_PWR_MAN_RES);
-	usleep_range(2000, 10000);
+	usleep_range(5000, 10000);
 
 	ret = state->chip_info->init(state);
 	if (ret)
-- 
2.6.1

