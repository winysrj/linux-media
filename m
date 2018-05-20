Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:41522 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751537AbeETGup (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 May 2018 02:50:45 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] media: hdpvr: don't check number of messages in the driver
Date: Sun, 20 May 2018 08:50:36 +0200
Message-Id: <20180520065039.7989-6-wsa@the-dreams.de>
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

 drivers/media/usb/hdpvr/hdpvr-i2c.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-i2c.c b/drivers/media/usb/hdpvr/hdpvr-i2c.c
index 4720d79b0282..c97dcf981b3f 100644
--- a/drivers/media/usb/hdpvr/hdpvr-i2c.c
+++ b/drivers/media/usb/hdpvr/hdpvr-i2c.c
@@ -117,9 +117,6 @@ static int hdpvr_transfer(struct i2c_adapter *i2c_adapter, struct i2c_msg *msgs,
 	struct hdpvr_device *dev = i2c_get_adapdata(i2c_adapter);
 	int retval = 0, addr;
 
-	if (num <= 0)
-		return 0;
-
 	mutex_lock(&dev->i2c_mutex);
 
 	addr = msgs[0].addr << 1;
-- 
2.11.0
