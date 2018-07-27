Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37668 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbeG0EW3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 00:22:29 -0400
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] media: i2c: vs6624: Replace mdelay() with msleep() and usleep_range() in vs6624_probe()
Date: Fri, 27 Jul 2018 11:02:40 +0800
Message-Id: <20180727030240.2558-1-baijiaju1990@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vs6624_probe() is never called in atomic context.
It calls mdelay() to busily wait, which is not necessary.
mdelay() can be replaced with msleep() and usleep_range().

This is found by a static analysis tool named DCNS written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/media/i2c/vs6624.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/vs6624.c b/drivers/media/i2c/vs6624.c
index 1658816a9844..bc9825f4a73d 100644
--- a/drivers/media/i2c/vs6624.c
+++ b/drivers/media/i2c/vs6624.c
@@ -770,7 +770,7 @@ static int vs6624_probe(struct i2c_client *client,
 		return ret;
 	}
 	/* wait 100ms before any further i2c writes are performed */
-	mdelay(100);
+	msleep(100);
 
 	sensor = devm_kzalloc(&client->dev, sizeof(*sensor), GFP_KERNEL);
 	if (sensor == NULL)
@@ -782,7 +782,7 @@ static int vs6624_probe(struct i2c_client *client,
 	vs6624_writeregs(sd, vs6624_p1);
 	vs6624_write(sd, VS6624_MICRO_EN, 0x2);
 	vs6624_write(sd, VS6624_DIO_EN, 0x1);
-	mdelay(10);
+	usleep_range(10000, 11000);
 	vs6624_writeregs(sd, vs6624_p2);
 
 	vs6624_writeregs(sd, vs6624_default);
-- 
2.17.0
