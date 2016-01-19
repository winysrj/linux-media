Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:35747 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbcASMTV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2016 07:19:21 -0500
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: linux-media@vger.kernel.org, hans.verkuil@cisco.com
Cc: linux-renesas-soc@vger.kernel.org, magnus.damm@gmail.com,
	laurent.pinchart@ideasonboard.com, ian.molton@codethink.co.uk,
	lars@metafoo.de, william.towle@codethink.co.uk,
	niklas.soderlund+renesas@ragnatech.se,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [RESEND PATCH] media: adv7180: increase delay after reset to 5ms
Date: Tue, 19 Jan 2016 13:19:16 +0100
Message-Id: <1453205956-9103-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Initialization of the ADV7180 chip fails on the Renesas R8A7790-based
Lager board about 50% of the time.  This patch resolves the issue by
increasing the minimum delay after reset from 2 ms to 5 ms, following the
recommendation in the ADV7180 datasheet:

"Executing a software reset takes approximately 2 ms. However, it is
recommended to wait 5 ms before any further I2C writes are performed."

Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
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
2.6.4

