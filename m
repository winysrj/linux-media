Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:34146 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab3KIAYU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Nov 2013 19:24:20 -0500
Received: by mail-bk0-f44.google.com with SMTP id mx12so60088bkb.31
        for <linux-media@vger.kernel.org>; Fri, 08 Nov 2013 16:24:19 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 9 Nov 2013 08:24:18 +0800
Message-ID: <CAPgLHd8kCHgx2h=hjEwvge5F3ZyUzyhaXKoxKm6O8mcxnqTC4w@mail.gmail.com>
Subject: [PATCH -next] [media] media: i2c: lm3560: use correct clientdata in lm3560_remove()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: m.chehab@samsung.com, gshark.jeong@gmail.com
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

We had set the i2c clientdata to &flash->subdev_led[LM3560_LED1]
after call lm3560_subdev_init(flash, LM3560_LED1, "lm3560-led1"),
but the container_of() in lm3560_remove() return the wrong pointer
to flash.(should be container_of(subdev, struct lm3560_flash,
subdev_led[LM3560_LED_MAX-1])
This patch fix to set i2c clientdata to flash so we can get flash
from clientdata directly.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/i2c/lm3560.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/lm3560.c b/drivers/media/i2c/lm3560.c
index 3317a9a..5a70d71 100644
--- a/drivers/media/i2c/lm3560.c
+++ b/drivers/media/i2c/lm3560.c
@@ -444,14 +444,14 @@ static int lm3560_probe(struct i2c_client *client,
 	if (rval < 0)
 		return rval;
 
+	i2c_set_clientdata(client, flash);
+
 	return 0;
 }
 
 static int lm3560_remove(struct i2c_client *client)
 {
-	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
-	struct lm3560_flash *flash = container_of(subdev, struct lm3560_flash,
-						  subdev_led[LM3560_LED_MAX]);
+	struct lm3560_flash *flash = i2c_get_clientdata(client);
 	unsigned int i;
 
 	for (i = LM3560_LED0; i < LM3560_LED_MAX; i++) {

