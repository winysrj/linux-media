Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:41534 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751614AbeETGuq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 May 2018 02:50:46 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] media: dvb-usb: don't check number of messages in the driver
Date: Sun, 20 May 2018 08:50:38 +0200
Message-Id: <20180520065039.7989-8-wsa@the-dreams.de>
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

 drivers/media/usb/dvb-usb/m920x.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/m920x.c b/drivers/media/usb/dvb-usb/m920x.c
index 32081c2ce0da..a6ab6688cbb3 100644
--- a/drivers/media/usb/dvb-usb/m920x.c
+++ b/drivers/media/usb/dvb-usb/m920x.c
@@ -255,9 +255,6 @@ static int m920x_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[], int nu
 	int i, j;
 	int ret = 0;
 
-	if (!num)
-		return -EINVAL;
-
 	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
 		return -EAGAIN;
 
-- 
2.11.0
