Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45754 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750841AbeASJXa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Jan 2018 04:23:30 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: andy.yeh@intel.com
Subject: [PATCH 1/1] imx258: Fix sparse warnings
Date: Fri, 19 Jan 2018 11:23:27 +0200
Message-Id: <20180119092327.26731-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a few sparse warnings related to conversion between CPU and big
endian. Also simplify the code in the process.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Hi Andy,

There were a few issues Sparse found in the imx258 driver. Could you
test the patch, please?

 drivers/media/i2c/imx258.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c
index a7e58bd23de7..b73c25ae8725 100644
--- a/drivers/media/i2c/imx258.c
+++ b/drivers/media/i2c/imx258.c
@@ -440,10 +440,10 @@ static int imx258_read_reg(struct imx258 *imx258, u16 reg, u32 len, u32 *val)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
 	struct i2c_msg msgs[2];
+	__be16 reg_addr_be = cpu_to_be16(reg);
+	__be32 data_be = 0;
 	u8 *data_be_p;
 	int ret;
-	u32 data_be = 0;
-	u16 reg_addr_be = cpu_to_be16(reg);
 
 	if (len > 4)
 		return -EINVAL;
@@ -474,22 +474,17 @@ static int imx258_read_reg(struct imx258 *imx258, u16 reg, u32 len, u32 *val)
 static int imx258_write_reg(struct imx258 *imx258, u16 reg, u32 len, u32 val)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
-	int buf_i, val_i;
-	u8 buf[6], *val_p;
+	u8 __buf[6], *buf = __buf;
+	int i;
 
 	if (len > 4)
 		return -EINVAL;
 
-	buf[0] = reg >> 8;
-	buf[1] = reg & 0xff;
+	*buf++ = reg >> 8;
+	*buf++ = reg & 0xff;
 
-	val = cpu_to_be32(val);
-	val_p = (u8 *)&val;
-	buf_i = 2;
-	val_i = 4 - len;
-
-	while (val_i < 4)
-		buf[buf_i++] = val_p[val_i++];
+	for (i = len - 1; i >= 0; i++)
+		*buf++ = (u8)(val >> (i << 3));
 
 	if (i2c_master_send(client, buf, len + 2) != len + 2)
 		return -EIO;
-- 
2.11.0
