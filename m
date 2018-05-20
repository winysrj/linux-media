Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:41518 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751021AbeETGuo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 May 2018 02:50:44 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] media: em28xx: don't check number of messages in the driver
Date: Sun, 20 May 2018 08:50:35 +0200
Message-Id: <20180520065039.7989-5-wsa@the-dreams.de>
In-Reply-To: <20180520065039.7989-1-wsa@the-dreams.de>
References: <20180520065039.7989-1-wsa@the-dreams.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit 1eace8344c02 ("i2c: add param sanity check to
i2c_transfer()"), the I2C core does this check now. We can remove it
from drivers.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---

Only build tested.

 drivers/media/usb/em28xx/em28xx-i2c.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 6458682bc6e2..e19d6342e0d0 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -559,10 +559,6 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 		dev->cur_i2c_bus = bus;
 	}
 
-	if (num <= 0) {
-		rt_mutex_unlock(&dev->i2c_bus_lock);
-		return 0;
-	}
 	for (i = 0; i < num; i++) {
 		addr = msgs[i].addr << 1;
 		if (!msgs[i].len) {
-- 
2.11.0
