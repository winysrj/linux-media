Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:55220 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933813AbeBLNCG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 08:02:06 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Wenyou Yang <wenyou.yang@microchip.com>
Subject: [PATCH] media: ov7740: return error code at ov7740_get_register
Date: Mon, 12 Feb 2018 08:02:00 -0500
Message-Id: <bd1cd1a21feeead0ccbc0f600038f6a6907b49ae.1518440517.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If v4l2_subdev_core_ops.g_register fails, it should be
returning an error code to userspace, instead of zero.

Fixes:
	 drivers/media/i2c/ov7740.c: warning: variable 'ret' set but not used [-Wunused-but-set-variable]:  => 276:6

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/ov7740.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov7740.c b/drivers/media/i2c/ov7740.c
index fc9dbbcae56e..3947accf97e6 100644
--- a/drivers/media/i2c/ov7740.c
+++ b/drivers/media/i2c/ov7740.c
@@ -279,7 +279,7 @@ static int ov7740_get_register(struct v4l2_subdev *sd,
 	reg->val = val;
 	reg->size = 1;
 
-	return 0;
+	return ret;
 }
 
 static int ov7740_set_register(struct v4l2_subdev *sd,
-- 
2.14.3
