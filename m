Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:40864 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753987AbeCWL51 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 07:57:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sebastian Reichel <sre@kernel.org>,
        kbuild test robot <lkp@intel.com>
Subject: [PATCH 06/30] media: ov5670: get rid of a series of __be warnings
Date: Fri, 23 Mar 2018 07:56:52 -0400
Message-Id: <baa6f19b37cc1aebf6e84ed4c451f1078693bb4b.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are some troubles on this driver with respect to the usage
of __be16 and __b32 macros:

	drivers/media/i2c/ov5670.c:1857:27: warning: incorrect type in initializer (different base types)
	drivers/media/i2c/ov5670.c:1857:27:    expected unsigned short [unsigned] [usertype] reg_addr_be
	drivers/media/i2c/ov5670.c:1857:27:    got restricted __be16 [usertype] <noident>
	drivers/media/i2c/ov5670.c:1880:16: warning: cast to restricted __be32
	drivers/media/i2c/ov5670.c:1880:16: warning: cast to restricted __be32
	drivers/media/i2c/ov5670.c:1880:16: warning: cast to restricted __be32
	drivers/media/i2c/ov5670.c:1880:16: warning: cast to restricted __be32
	drivers/media/i2c/ov5670.c:1880:16: warning: cast to restricted __be32
	drivers/media/i2c/ov5670.c:1880:16: warning: cast to restricted __be32
	drivers/media/i2c/ov5670.c:1901:13: warning: incorrect type in assignment (different base types)
	drivers/media/i2c/ov5670.c:1901:13:    expected unsigned int [unsigned] [usertype] val
	drivers/media/i2c/ov5670.c:1901:13:    got restricted __be32 [usertype] <noident>

Fix them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/ov5670.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ov5670.c b/drivers/media/i2c/ov5670.c
index 556a95c30781..d2db480da1b9 100644
--- a/drivers/media/i2c/ov5670.c
+++ b/drivers/media/i2c/ov5670.c
@@ -1853,8 +1853,8 @@ static int ov5670_read_reg(struct ov5670 *ov5670, u16 reg, unsigned int len,
 	struct i2c_client *client = v4l2_get_subdevdata(&ov5670->sd);
 	struct i2c_msg msgs[2];
 	u8 *data_be_p;
-	u32 data_be = 0;
-	u16 reg_addr_be = cpu_to_be16(reg);
+	__be32 data_be = 0;
+	__be16 reg_addr_be = cpu_to_be16(reg);
 	int ret;
 
 	if (len > 4)
@@ -1891,6 +1891,7 @@ static int ov5670_write_reg(struct ov5670 *ov5670, u16 reg, unsigned int len,
 	int val_i;
 	u8 buf[6];
 	u8 *val_p;
+	__be32 tmp;
 
 	if (len > 4)
 		return -EINVAL;
@@ -1898,8 +1899,8 @@ static int ov5670_write_reg(struct ov5670 *ov5670, u16 reg, unsigned int len,
 	buf[0] = reg >> 8;
 	buf[1] = reg & 0xff;
 
-	val = cpu_to_be32(val);
-	val_p = (u8 *)&val;
+	tmp = cpu_to_be32(val);
+	val_p = (u8 *)&tmp;
 	buf_i = 2;
 	val_i = 4 - len;
 
-- 
2.14.3
