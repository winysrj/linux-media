Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:63008 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751474AbeAWM5T (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Jan 2018 07:57:19 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH] media: dw9714: annotate a __be16 integer value
Date: Tue, 23 Jan 2018 07:57:14 -0500
Message-Id: <e139bd217bdb250b63e6359bf16e67fb232c9aa2.1516712231.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned:
   drivers/media/i2c/dw9714.c: warning: incorrect type in initializer (different base types):  => 64:19

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/dw9714.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/dw9714.c b/drivers/media/i2c/dw9714.c
index 57460dadddd1..8dbbf0f917df 100644
--- a/drivers/media/i2c/dw9714.c
+++ b/drivers/media/i2c/dw9714.c
@@ -60,7 +60,7 @@ static inline struct dw9714_device *sd_to_dw9714_vcm(struct v4l2_subdev *subdev)
 static int dw9714_i2c_write(struct i2c_client *client, u16 data)
 {
 	int ret;
-	u16 val = cpu_to_be16(data);
+	__be16 val = cpu_to_be16(data);
 
 	ret = i2c_master_send(client, (const char *)&val, sizeof(val));
 	if (ret != sizeof(val)) {
-- 
2.14.3
