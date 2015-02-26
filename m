Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:37691 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbbBZSTq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2015 13:19:46 -0500
Received: by wesw55 with SMTP id w55so13482418wes.4
        for <linux-media@vger.kernel.org>; Thu, 26 Feb 2015 10:19:45 -0800 (PST)
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-media@vger.kernel.org,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: i2c: adv7180: unregister the subdev in remove callback
Date: Thu, 26 Feb 2015 18:19:29 +0000
Message-Id: <1424974769-27095-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch makes sure we unregister the subdev by calling
v4l2_device_unregister_subdev() on remove callback.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/i2c/adv7180.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index b75878c..734d84a 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -1270,6 +1270,7 @@ static int adv7180_remove(struct i2c_client *client)
 	if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2)
 		i2c_unregister_device(state->csi_client);
 
+	v4l2_device_unregister_subdev(sd);
 	mutex_destroy(&state->mutex);
 
 	return 0;
-- 
1.9.1

