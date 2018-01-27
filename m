Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:63443 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753144AbeA0QYm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 27 Jan 2018 11:24:42 -0500
From: "Yeh, Andy" <andy.yeh@intel.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH v3 1/1] imx258: Fix sparse warnings
Date: Sat, 27 Jan 2018 16:24:39 +0000
Message-ID: <8E0971CCB6EA9D41AF58191A2D3978B61D4F3064@PGSMSX111.gar.corp.intel.com>
References: <20180122212542.26474-1-sakari.ailus@linux.intel.com>
In-Reply-To: <20180122212542.26474-1-sakari.ailus@linux.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a few sparse warnings related to conversion between CPU and big endian. Also simplify the code in the process.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Andy Yeh <andy.yeh@intel.com>
---
since v2:

- Count loop downwards, not up.

 drivers/media/i2c/imx258.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c index a7e58bd23de7..213429cca8b5 100644
--- a/drivers/media/i2c/imx258.c
+++ b/drivers/media/i2c/imx258.c
@@ -440,10 +440,10 @@ static int imx258_read_reg(struct imx258 *imx258, u16 reg, u32 len, u32 *val)  {
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
@@ -474,24 +474,19 @@ static int imx258_read_reg(struct imx258 *imx258, u16 reg, u32 len, u32 *val)  static int imx258_write_reg(struct imx258 *imx258, u16 reg, u32 len, u32 val)  {
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
+	for (i = len - 1; i >= 0; i--)
+		*buf++ = (u8)(val >> (i << 3));
 
-	while (val_i < 4)
-		buf[buf_i++] = val_p[val_i++];
-
-	if (i2c_master_send(client, buf, len + 2) != len + 2)
+	if (i2c_master_send(client, __buf, len + 2) != len + 2)
 		return -EIO;
 
 	return 0;
--
2.11.0
