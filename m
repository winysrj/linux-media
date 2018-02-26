Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:64378 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751530AbeBZNkQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 08:40:16 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Wenyou Yang <wenyou.yang@microchip.com>
Subject: [PATCH 1/3] media: ov7740: remove an unused var
Date: Mon, 26 Feb 2018 08:40:08 -0500
Message-Id: <00d9da502565e97fcca3805eec98db6df3594ec0.1519652405.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix this warning regression:
   drivers/media/i2c/ov7740.c: warning: variable 'ret' set but not used [-Wunused-but-set-variable]:  => 276:6

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/ov7740.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov7740.c b/drivers/media/i2c/ov7740.c
index e1a44a18d9a8..01f578785e79 100644
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
