Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:37524 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752096AbeCZVLE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 17:11:04 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Luis Oliveira <Luis.Oliveira@synopsys.com>,
        Aishwarya Pant <aishpant@gmail.com>,
        Riccardo Schirone <sirmy15@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, devel@driverdev.osuosl.org
Subject: [PATCH 07/18] media: staging: atomisp: fix endianess issues
Date: Mon, 26 Mar 2018 17:10:40 -0400
Message-Id: <cc521a255756c0241572816f96e3b97126ac16de.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are lots of be-related warnings there, as it doesn't properly
mark what data uses bigendian.

Warnings fixed:

    drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c:134:15: warning: incorrect type in assignment (different base types)
    drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c:134:15:    expected unsigned short [unsigned] [short] [usertype] <noident>
    drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c:134:15:    got restricted __be16 [usertype] <noident>
    drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c:140:26: warning: cast to restricted __be16
    drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c:140:26: warning: cast to restricted __be16
    drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c:140:26: warning: cast to restricted __be16
    drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c:140:26: warning: cast to restricted __be16
    drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c:144:26: warning: cast to restricted __be32
    drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c:144:26: warning: cast to restricted __be32
    drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c:144:26: warning: cast to restricted __be32
    drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c:144:26: warning: cast to restricted __be32
    drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c:144:26: warning: cast to restricted __be32
    drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c:144:26: warning: cast to restricted __be32
    drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c:256:27: warning: incorrect type in assignment (different base types)
    drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c:256:27:    expected unsigned short [unsigned] [usertype] addr
    drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c:256:27:    got restricted __be16 [usertype] <noident>
    drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c:302:25: warning: incorrect type in assignment (different base types)
    drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c:302:25:    expected unsigned short [unsigned] [short] [usertype] <noident>
    drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c:302:25:    got restricted __be16 [usertype] <noident>
    drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c:306:25: warning: incorrect type in assignment (different base types)
    drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c:306:25:    expected unsigned int [unsigned] [usertype] <noident>
    drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c:306:25:    got restricted __be32 [usertype] <noident>
    drivers/staging/media/atomisp/i2c/atomisp-ov2680.c:97:24: warning: cast to restricted __be16
    drivers/staging/media/atomisp/i2c/atomisp-ov2680.c:97:24: warning: cast to restricted __be16
    drivers/staging/media/atomisp/i2c/atomisp-ov2680.c:97:24: warning: cast to restricted __be16
    drivers/staging/media/atomisp/i2c/atomisp-ov2680.c:97:24: warning: cast to restricted __be16
    drivers/staging/media/atomisp/i2c/atomisp-ov2680.c:99:24: warning: cast to restricted __be32
    drivers/staging/media/atomisp/i2c/atomisp-ov2680.c:99:24: warning: cast to restricted __be32
    drivers/staging/media/atomisp/i2c/atomisp-ov2680.c:99:24: warning: cast to restricted __be32
    drivers/staging/media/atomisp/i2c/atomisp-ov2680.c:99:24: warning: cast to restricted __be32
    drivers/staging/media/atomisp/i2c/atomisp-ov2680.c:99:24: warning: cast to restricted __be32
    drivers/staging/media/atomisp/i2c/atomisp-ov2680.c:99:24: warning: cast to restricted __be32
    drivers/staging/media/atomisp/i2c/atomisp-ov2680.c:134:15: warning: incorrect type in assignment (different base types)
    drivers/staging/media/atomisp/i2c/atomisp-ov2680.c:134:15:    expected unsigned short [unsigned] [short] [usertype] <noident>
    drivers/staging/media/atomisp/i2c/atomisp-ov2680.c:134:15:    got restricted __be16 [usertype] <noident>
    drivers/staging/media/atomisp/i2c/atomisp-ov2680.c:141:24: warning: incorrect type in assignment (different base types)
    drivers/staging/media/atomisp/i2c/atomisp-ov2680.c:141:24:    expected unsigned short [unsigned] [short] [usertype] <noident>
    drivers/staging/media/atomisp/i2c/atomisp-ov2680.c:141:24:    got restricted __be16 [usertype] <noident>
    drivers/staging/media/atomisp/i2c/atomisp-ov2680.c:177:27: warning: incorrect type in assignment (different base types)
    drivers/staging/media/atomisp/i2c/atomisp-ov2680.c:177:27:    expected unsigned short [unsigned] [usertype] addr
    drivers/staging/media/atomisp/i2c/atomisp-ov2680.c:177:27:    got restricted __be16 [usertype] <noident>
    drivers/staging/media/atomisp/i2c/atomisp-ov2680.c:198:25: warning: incorrect type in assignment (different base types)
    drivers/staging/media/atomisp/i2c/atomisp-ov2680.c:198:25:    expected unsigned short [unsigned] [short] [usertype] <noident>
    drivers/staging/media/atomisp/i2c/atomisp-ov2680.c:198:25:    got restricted __be16 [usertype] <noident>
    drivers/staging/media/atomisp/i2c/atomisp-ov2722.c:88:24: warning: cast to restricted __be16
    drivers/staging/media/atomisp/i2c/atomisp-ov2722.c:88:24: warning: cast to restricted __be16
    drivers/staging/media/atomisp/i2c/atomisp-ov2722.c:88:24: warning: cast to restricted __be16
    drivers/staging/media/atomisp/i2c/atomisp-ov2722.c:88:24: warning: cast to restricted __be16
    drivers/staging/media/atomisp/i2c/atomisp-ov2722.c:90:24: warning: cast to restricted __be32
    drivers/staging/media/atomisp/i2c/atomisp-ov2722.c:90:24: warning: cast to restricted __be32
    drivers/staging/media/atomisp/i2c/atomisp-ov2722.c:90:24: warning: cast to restricted __be32
    drivers/staging/media/atomisp/i2c/atomisp-ov2722.c:90:24: warning: cast to restricted __be32
    drivers/staging/media/atomisp/i2c/atomisp-ov2722.c:90:24: warning: cast to restricted __be32
    drivers/staging/media/atomisp/i2c/atomisp-ov2722.c:90:24: warning: cast to restricted __be32
    drivers/staging/media/atomisp/i2c/atomisp-ov2722.c:125:15: warning: incorrect type in assignment (different base types)
    drivers/staging/media/atomisp/i2c/atomisp-ov2722.c:125:15:    expected unsigned short [unsigned] [short] [usertype] <noident>
    drivers/staging/media/atomisp/i2c/atomisp-ov2722.c:125:15:    got restricted __be16 [usertype] <noident>
    drivers/staging/media/atomisp/i2c/atomisp-ov2722.c:132:24: warning: incorrect type in assignment (different base types)
    drivers/staging/media/atomisp/i2c/atomisp-ov2722.c:132:24:    expected unsigned short [unsigned] [short] [usertype] <noident>
    drivers/staging/media/atomisp/i2c/atomisp-ov2722.c:132:24:    got restricted __be16 [usertype] <noident>
    drivers/staging/media/atomisp/i2c/atomisp-ov2722.c:168:27: warning: incorrect type in assignment (different base types)
    drivers/staging/media/atomisp/i2c/atomisp-ov2722.c:168:27:    expected unsigned short [unsigned] [usertype] addr
    drivers/staging/media/atomisp/i2c/atomisp-ov2722.c:168:27:    got restricted __be16 [usertype] <noident>
    drivers/staging/media/atomisp/i2c/atomisp-ov2722.c:189:25: warning: incorrect type in assignment (different base types)
    drivers/staging/media/atomisp/i2c/atomisp-ov2722.c:189:25:    expected unsigned short [unsigned] [short] [usertype] <noident>
    drivers/staging/media/atomisp/i2c/atomisp-ov2722.c:189:25:    got restricted __be16 [usertype] <noident>
    drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:176:24: warning: cast to restricted __be16
    drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:176:24: warning: cast to restricted __be16
    drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:176:24: warning: cast to restricted __be16
    drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:176:24: warning: cast to restricted __be16
    drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:178:24: warning: cast to restricted __be32
    drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:178:24: warning: cast to restricted __be32
    drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:178:24: warning: cast to restricted __be32
    drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:178:24: warning: cast to restricted __be32
    drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:178:24: warning: cast to restricted __be32
    drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:178:24: warning: cast to restricted __be32
    drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:205:13: warning: incorrect type in assignment (different base types)
    drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:205:13:    expected unsigned short [unsigned] [usertype] val
    drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:205:13:    got restricted __be16 [usertype] <noident>
    drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:276:15: warning: incorrect type in assignment (different base types)
    drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:276:15:    expected unsigned short [unsigned] [short] [usertype] <noident>
    drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:276:15:    got restricted __be16 [usertype] <noident>
    drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:283:24: warning: incorrect type in assignment (different base types)
    drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:283:24:    expected unsigned short [unsigned] [short] [usertype] <noident>
    drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:283:24:    got restricted __be16 [usertype] <noident>
    drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:319:27: warning: incorrect type in assignment (different base types)
    drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:319:27:    expected unsigned short [unsigned] [usertype] addr
    drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:319:27:    got restricted __be16 [usertype] <noident>
    drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:340:25: warning: incorrect type in assignment (different base types)
    drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:340:25:    expected unsigned short [unsigned] [short] [usertype] <noident>
    drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c:340:25:    got restricted __be16 [usertype] <noident>

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../staging/media/atomisp/i2c/atomisp-mt9m114.c    | 25 ++++++++++++----------
 drivers/staging/media/atomisp/i2c/atomisp-ov2680.c | 16 ++++++++------
 drivers/staging/media/atomisp/i2c/atomisp-ov2722.c | 16 ++++++++------
 .../media/atomisp/i2c/ov5693/atomisp-ov5693.c      | 24 ++++++++++++---------
 4 files changed, 46 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c b/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c
index 834fba8c4fa0..44db9f9f1fc5 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c
@@ -107,7 +107,7 @@ mt9m114_write_reg(struct i2c_client *client, u16 data_length, u16 reg, u32 val)
 	int num_msg;
 	struct i2c_msg msg;
 	unsigned char data[6] = {0};
-	u16 *wreg;
+	__be16 *wreg;
 	int retry = 0;
 
 	if (!client->adapter) {
@@ -130,18 +130,20 @@ mt9m114_write_reg(struct i2c_client *client, u16 data_length, u16 reg, u32 val)
 	msg.buf = data;
 
 	/* high byte goes out first */
-	wreg = (u16 *)data;
+	wreg = (void *)data;
 	*wreg = cpu_to_be16(reg);
 
 	if (data_length == MISENSOR_8BIT) {
 		data[2] = (u8)(val);
 	} else if (data_length == MISENSOR_16BIT) {
-		u16 *wdata = (u16 *)&data[2];
-		*wdata = be16_to_cpu((u16)val);
+		u16 *wdata = (void *)&data[2];
+
+		*wdata = be16_to_cpu(*(__be16 *)&data[2]);
 	} else {
 		/* MISENSOR_32BIT */
-		u32 *wdata = (u32 *)&data[2];
-		*wdata = be32_to_cpu(val);
+		u32 *wdata = (void *)&data[2];
+
+		*wdata = be32_to_cpu(*(__be32 *)&data[2]);
 	}
 
 	num_msg = i2c_transfer(client->adapter, &msg, 1);
@@ -245,6 +247,7 @@ static int __mt9m114_flush_reg_array(struct i2c_client *client,
 	const int num_msg = 1;
 	int ret;
 	int retry = 0;
+	__be16 *data16 = (void *)&ctrl->buffer.addr;
 
 	if (ctrl->index == 0)
 		return 0;
@@ -253,7 +256,7 @@ static int __mt9m114_flush_reg_array(struct i2c_client *client,
 	msg.addr = client->addr;
 	msg.flags = 0;
 	msg.len = 2 + ctrl->index;
-	ctrl->buffer.addr = cpu_to_be16(ctrl->buffer.addr);
+	*data16 = cpu_to_be16(ctrl->buffer.addr);
 	msg.buf = (u8 *)&ctrl->buffer;
 
 	ret = i2c_transfer(client->adapter, &msg, num_msg);
@@ -282,8 +285,8 @@ static int __mt9m114_buf_reg_array(struct i2c_client *client,
 				   struct mt9m114_write_ctrl *ctrl,
 				   const struct misensor_reg *next)
 {
-	u16 *data16;
-	u32 *data32;
+	__be16 *data16;
+	__be32 *data32;
 	int err;
 
 	/* Insufficient buffer? Let's flush and get more free space. */
@@ -298,11 +301,11 @@ static int __mt9m114_buf_reg_array(struct i2c_client *client,
 		ctrl->buffer.data[ctrl->index] = (u8)next->val;
 		break;
 	case MISENSOR_16BIT:
-		data16 = (u16 *)&ctrl->buffer.data[ctrl->index];
+		data16 = (__be16 *)&ctrl->buffer.data[ctrl->index];
 		*data16 = cpu_to_be16((u16)next->val);
 		break;
 	case MISENSOR_32BIT:
-		data32 = (u32 *)&ctrl->buffer.data[ctrl->index];
+		data32 = (__be32 *)&ctrl->buffer.data[ctrl->index];
 		*data32 = cpu_to_be32(next->val);
 		break;
 	default:
diff --git a/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c b/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c
index 11412061c40e..1d814bcb18b8 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c
@@ -94,9 +94,9 @@ static int ov2680_read_reg(struct i2c_client *client,
 	if (data_length == OV2680_8BIT)
 		*val = (u8)data[0];
 	else if (data_length == OV2680_16BIT)
-		*val = be16_to_cpu(*(u16 *)&data[0]);
+		*val = be16_to_cpu(*(__be16 *)&data[0]);
 	else
-		*val = be32_to_cpu(*(u32 *)&data[0]);
+		*val = be32_to_cpu(*(__be32 *)&data[0]);
 	//dev_dbg(&client->dev,  "++++i2c read adr%x = %x\n", reg,*val);
 	return 0;
 }
@@ -121,7 +121,7 @@ static int ov2680_write_reg(struct i2c_client *client, u16 data_length,
 {
 	int ret;
 	unsigned char data[4] = {0};
-	u16 *wreg = (u16 *)data;
+	__be16 *wreg = (void *)data;
 	const u16 len = data_length + sizeof(u16); /* 16-bit address + data */
 
 	if (data_length != OV2680_8BIT && data_length != OV2680_16BIT) {
@@ -137,7 +137,8 @@ static int ov2680_write_reg(struct i2c_client *client, u16 data_length,
 		data[2] = (u8)(val);
 	} else {
 		/* OV2680_16BIT */
-		u16 *wdata = (u16 *)&data[2];
+		__be16 *wdata = (void *)&data[2];
+
 		*wdata = cpu_to_be16(val);
 	}
 
@@ -169,12 +170,13 @@ static int __ov2680_flush_reg_array(struct i2c_client *client,
 				    struct ov2680_write_ctrl *ctrl)
 {
 	u16 size;
+	__be16 *data16 = (void *)&ctrl->buffer.addr;
 
 	if (ctrl->index == 0)
 		return 0;
 
 	size = sizeof(u16) + ctrl->index; /* 16-bit address + data */
-	ctrl->buffer.addr = cpu_to_be16(ctrl->buffer.addr);
+	*data16 = cpu_to_be16(ctrl->buffer.addr);
 	ctrl->index = 0;
 
 	return ov2680_i2c_write(client, size, (u8 *)&ctrl->buffer);
@@ -185,7 +187,7 @@ static int __ov2680_buf_reg_array(struct i2c_client *client,
 				  const struct ov2680_reg *next)
 {
 	int size;
-	u16 *data16;
+	__be16 *data16;
 
 	switch (next->type) {
 	case OV2680_8BIT:
@@ -194,7 +196,7 @@ static int __ov2680_buf_reg_array(struct i2c_client *client,
 		break;
 	case OV2680_16BIT:
 		size = 2;
-		data16 = (u16 *)&ctrl->buffer.data[ctrl->index];
+		data16 = (void *)&ctrl->buffer.data[ctrl->index];
 		*data16 = cpu_to_be16((u16)next->val);
 		break;
 	default:
diff --git a/drivers/staging/media/atomisp/i2c/atomisp-ov2722.c b/drivers/staging/media/atomisp/i2c/atomisp-ov2722.c
index e59358ac89ce..dc9a6d4f1824 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-ov2722.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-ov2722.c
@@ -85,9 +85,9 @@ static int ov2722_read_reg(struct i2c_client *client,
 	if (data_length == OV2722_8BIT)
 		*val = (u8)data[0];
 	else if (data_length == OV2722_16BIT)
-		*val = be16_to_cpu(*(u16 *)&data[0]);
+		*val = be16_to_cpu(*(__be16 *)&data[0]);
 	else
-		*val = be32_to_cpu(*(u32 *)&data[0]);
+		*val = be32_to_cpu(*(__be32 *)&data[0]);
 
 	return 0;
 }
@@ -112,7 +112,7 @@ static int ov2722_write_reg(struct i2c_client *client, u16 data_length,
 {
 	int ret;
 	unsigned char data[4] = {0};
-	u16 *wreg = (u16 *)data;
+	__be16 *wreg = (__be16 *)data;
 	const u16 len = data_length + sizeof(u16); /* 16-bit address + data */
 
 	if (data_length != OV2722_8BIT && data_length != OV2722_16BIT) {
@@ -128,7 +128,8 @@ static int ov2722_write_reg(struct i2c_client *client, u16 data_length,
 		data[2] = (u8)(val);
 	} else {
 		/* OV2722_16BIT */
-		u16 *wdata = (u16 *)&data[2];
+		__be16 *wdata = (__be16 *)&data[2];
+
 		*wdata = cpu_to_be16(val);
 	}
 
@@ -160,12 +161,13 @@ static int __ov2722_flush_reg_array(struct i2c_client *client,
 				    struct ov2722_write_ctrl *ctrl)
 {
 	u16 size;
+	__be16 *data16 = (void *)&ctrl->buffer.addr;
 
 	if (ctrl->index == 0)
 		return 0;
 
 	size = sizeof(u16) + ctrl->index; /* 16-bit address + data */
-	ctrl->buffer.addr = cpu_to_be16(ctrl->buffer.addr);
+	*data16 = cpu_to_be16(ctrl->buffer.addr);
 	ctrl->index = 0;
 
 	return ov2722_i2c_write(client, size, (u8 *)&ctrl->buffer);
@@ -176,7 +178,7 @@ static int __ov2722_buf_reg_array(struct i2c_client *client,
 				  const struct ov2722_reg *next)
 {
 	int size;
-	u16 *data16;
+	__be16 *data16;
 
 	switch (next->type) {
 	case OV2722_8BIT:
@@ -185,7 +187,7 @@ static int __ov2722_buf_reg_array(struct i2c_client *client,
 		break;
 	case OV2722_16BIT:
 		size = 2;
-		data16 = (u16 *)&ctrl->buffer.data[ctrl->index];
+		data16 = (void *)&ctrl->buffer.data[ctrl->index];
 		*data16 = cpu_to_be16((u16)next->val);
 		break;
 	default:
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c b/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
index 30a735e59e54..e3a2a63c52cb 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
+++ b/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
@@ -173,9 +173,9 @@ static int ov5693_read_reg(struct i2c_client *client,
 	if (data_length == OV5693_8BIT)
 		*val = (u8)data[0];
 	else if (data_length == OV5693_16BIT)
-		*val = be16_to_cpu(*(u16 *)&data[0]);
+		*val = be16_to_cpu(*(__be16 *)&data[0]);
 	else
-		*val = be32_to_cpu(*(u32 *)&data[0]);
+		*val = be32_to_cpu(*(__be32 *)&data[0]);
 
 	return 0;
 }
@@ -200,13 +200,13 @@ static int vcm_dw_i2c_write(struct i2c_client *client, u16 data)
 	struct i2c_msg msg;
 	const int num_msg = 1;
 	int ret;
-	u16 val;
+	__be16 val;
 
 	val = cpu_to_be16(data);
 	msg.addr = VCM_ADDR;
 	msg.flags = 0;
 	msg.len = OV5693_16BIT;
-	msg.buf = (u8 *)&val;
+	msg.buf = (void *)&val;
 
 	ret = i2c_transfer(client->adapter, &msg, 1);
 
@@ -263,7 +263,7 @@ static int ov5693_write_reg(struct i2c_client *client, u16 data_length,
 {
 	int ret;
 	unsigned char data[4] = {0};
-	u16 *wreg = (u16 *)data;
+	__be16 *wreg = (void *)data;
 	const u16 len = data_length + sizeof(u16); /* 16-bit address + data */
 
 	if (data_length != OV5693_8BIT && data_length != OV5693_16BIT) {
@@ -279,7 +279,8 @@ static int ov5693_write_reg(struct i2c_client *client, u16 data_length,
 		data[2] = (u8)(val);
 	} else {
 		/* OV5693_16BIT */
-		u16 *wdata = (u16 *)&data[2];
+		__be16 *wdata = (void *)&data[2];
+
 		*wdata = cpu_to_be16(val);
 	}
 
@@ -311,15 +312,17 @@ static int __ov5693_flush_reg_array(struct i2c_client *client,
 				    struct ov5693_write_ctrl *ctrl)
 {
 	u16 size;
+	__be16 *reg = (void *)&ctrl->buffer.addr;
 
 	if (ctrl->index == 0)
 		return 0;
 
 	size = sizeof(u16) + ctrl->index; /* 16-bit address + data */
-	ctrl->buffer.addr = cpu_to_be16(ctrl->buffer.addr);
+
+	*reg = cpu_to_be16(ctrl->buffer.addr);
 	ctrl->index = 0;
 
-	return ov5693_i2c_write(client, size, (u8 *)&ctrl->buffer);
+	return ov5693_i2c_write(client, size, (u8 *)reg);
 }
 
 static int __ov5693_buf_reg_array(struct i2c_client *client,
@@ -327,7 +330,7 @@ static int __ov5693_buf_reg_array(struct i2c_client *client,
 				  const struct ov5693_reg *next)
 {
 	int size;
-	u16 *data16;
+	__be16 *data16;
 
 	switch (next->type) {
 	case OV5693_8BIT:
@@ -336,7 +339,8 @@ static int __ov5693_buf_reg_array(struct i2c_client *client,
 		break;
 	case OV5693_16BIT:
 		size = 2;
-		data16 = (u16 *)&ctrl->buffer.data[ctrl->index];
+
+		data16 = (void *)&ctrl->buffer.data[ctrl->index];
 		*data16 = cpu_to_be16((u16)next->val);
 		break;
 	default:
-- 
2.14.3
