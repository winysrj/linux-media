Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:41502 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751491AbeETGun (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 May 2018 02:50:43 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] media: si4713: don't check number of messages in the driver
Date: Sun, 20 May 2018 08:50:33 +0200
Message-Id: <20180520065039.7989-3-wsa@the-dreams.de>
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

 drivers/media/radio/si4713/radio-usb-si4713.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/radio/si4713/radio-usb-si4713.c b/drivers/media/radio/si4713/radio-usb-si4713.c
index 05c66701a899..1ebbf0217142 100644
--- a/drivers/media/radio/si4713/radio-usb-si4713.c
+++ b/drivers/media/radio/si4713/radio-usb-si4713.c
@@ -370,9 +370,6 @@ static int si4713_transfer(struct i2c_adapter *i2c_adapter,
 	int retval = -EINVAL;
 	int i;
 
-	if (num <= 0)
-		return 0;
-
 	for (i = 0; i < num; i++) {
 		if (msgs[i].flags & I2C_M_RD)
 			retval = si4713_i2c_read(radio, msgs[i].buf, msgs[i].len);
-- 
2.11.0
