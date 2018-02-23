Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:53612 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750879AbeBWIWZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Feb 2018 03:22:25 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH] ov13858: fix endiannes warnings
Date: Fri, 23 Feb 2018 03:22:19 -0500
Message-Id: <a7bc5773cd166032e35e343dfb6067a93d8402d1.1519374137.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

3 warning regressions:
  + drivers/media/i2c/ov13858.c: warning: cast to restricted __be32:  => 1093:16
  + drivers/media/i2c/ov13858.c: warning: incorrect type in assignment (different base types):  => 1111:13
  + drivers/media/i2c/ov13858.c: warning: incorrect type in initializer (different base types):  => 1071:27

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/ov13858.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ov13858.c b/drivers/media/i2c/ov13858.c
index 1f260d346a29..d4156eb62dab 100644
--- a/drivers/media/i2c/ov13858.c
+++ b/drivers/media/i2c/ov13858.c
@@ -1061,14 +1061,15 @@ struct ov13858 {
 #define to_ov13858(_sd)	container_of(_sd, struct ov13858, sd)
 
 /* Read registers up to 4 at a time */
-static int ov13858_read_reg(struct ov13858 *ov13858, u16 reg, u32 len, u32 *val)
+static int ov13858_read_reg(struct ov13858 *ov13858, u16 reg, u32 len,
+			    u32 *val)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&ov13858->sd);
 	struct i2c_msg msgs[2];
 	u8 *data_be_p;
 	int ret;
-	u32 data_be = 0;
-	u16 reg_addr_be = cpu_to_be16(reg);
+	__be32 data_be = 0;
+	__be16 reg_addr_be = cpu_to_be16(reg);
 
 	if (len > 4)
 		return -EINVAL;
@@ -1096,11 +1097,13 @@ static int ov13858_read_reg(struct ov13858 *ov13858, u16 reg, u32 len, u32 *val)
 }
 
 /* Write registers up to 4 at a time */
-static int ov13858_write_reg(struct ov13858 *ov13858, u16 reg, u32 len, u32 val)
+static int ov13858_write_reg(struct ov13858 *ov13858, u16 reg, u32 len,
+			     u32 __val)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&ov13858->sd);
 	int buf_i, val_i;
 	u8 buf[6], *val_p;
+	__be32 val;
 
 	if (len > 4)
 		return -EINVAL;
@@ -1108,7 +1111,7 @@ static int ov13858_write_reg(struct ov13858 *ov13858, u16 reg, u32 len, u32 val)
 	buf[0] = reg >> 8;
 	buf[1] = reg & 0xff;
 
-	val = cpu_to_be32(val);
+	val = cpu_to_be32(__val);
 	val_p = (u8 *)&val;
 	buf_i = 2;
 	val_i = 4 - len;
-- 
2.14.3
