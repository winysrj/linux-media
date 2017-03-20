Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:15060 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753623AbdCTOmE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 10:42:04 -0400
Subject: [PATCH 15/24] staging/atomisp: fix empty-body warning
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 20 Mar 2017 14:41:20 +0000
Message-ID: <149002087846.17109.1315819106851426964.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
References: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Arnd Bergmann <arnd@arndb.de>

Defining a debug function to nothing causes a warning with an empty block
after if()/else():

drivers/staging/media/atomisp/i2c/ov2680.c: In function 'ov2680_s_stream':
drivers/staging/media/atomisp/i2c/ov2680.c:1208:55: error: suggest braces around empty body in an 'else' statement [-Werror=empty-body]

This changes the empty debug statement to dev_dbg(), which by default also
does nothing, but avoids this warning and also checks the format string.
As a side-effect, we can now use dynamic debugging to turn on the
output at runtime.

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/staging/media/atomisp/i2c/ov2680.c |   37 ++++++++++++++--------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/ov2680.c b/drivers/staging/media/atomisp/i2c/ov2680.c
index 58d2a07..c08dd0b 100644
--- a/drivers/staging/media/atomisp/i2c/ov2680.c
+++ b/drivers/staging/media/atomisp/i2c/ov2680.c
@@ -35,7 +35,6 @@
 
 #include "ov2680.h"
 
-#define ov2680_debug(...) //dev_err(__VA_ARGS__)
 static int h_flag = 0;
 static int v_flag = 0;
 static enum atomisp_bayer_order ov2680_bayer_order_mapping[] = {
@@ -99,7 +98,7 @@ static int ov2680_read_reg(struct i2c_client *client,
 		*val = be16_to_cpu(*(u16 *)&data[0]);
 	else
 		*val = be32_to_cpu(*(u32 *)&data[0]);
-	//ov2680_debug(&client->dev,  "++++i2c read adr%x = %x\n", reg,*val);
+	//dev_dbg(&client->dev,  "++++i2c read adr%x = %x\n", reg,*val);
 	return 0;
 }
 
@@ -114,7 +113,7 @@ static int ov2680_i2c_write(struct i2c_client *client, u16 len, u8 *data)
 	msg.len = len;
 	msg.buf = data;
 	ret = i2c_transfer(client->adapter, &msg, 1);
-	//ov2680_debug(&client->dev,  "+++i2c write reg=%x->%x\n", data[0]*256 +data[1],data[2]);
+	//dev_dbg(&client->dev,  "+++i2c write reg=%x->%x\n", data[0]*256 +data[1],data[2]);
 	return ret == num_msg ? 0 : -EIO;
 }
 
@@ -235,7 +234,7 @@ static int ov2680_write_reg_array(struct i2c_client *client,
 	const struct ov2680_reg *next = reglist;
 	struct ov2680_write_ctrl ctrl;
 	int err;
-	ov2680_debug(&client->dev,  "++++write reg array\n");
+	dev_dbg(&client->dev,  "++++write reg array\n");
 	ctrl.index = 0;
 	for (; next->type != OV2680_TOK_TERM; next++) {
 		switch (next->type & OV2680_TOK_MASK) {
@@ -250,7 +249,7 @@ static int ov2680_write_reg_array(struct i2c_client *client,
 			 * If next address is not consecutive, data needs to be
 			 * flushed before proceed.
 			 */
-			 ov2680_debug(&client->dev,  "+++ov2680_write_reg_array reg=%x->%x\n", next->reg,next->val);
+			 dev_dbg(&client->dev,  "+++ov2680_write_reg_array reg=%x->%x\n", next->reg,next->val);
 			if (!__ov2680_write_reg_is_consecutive(client, &ctrl,
 								next)) {
 				err = __ov2680_flush_reg_array(client, &ctrl);
@@ -296,7 +295,8 @@ static int ov2680_g_fnumber_range(struct v4l2_subdev *sd, s32 *val)
 static int ov2680_g_bin_factor_x(struct v4l2_subdev *sd, s32 *val)
 {
 	struct ov2680_device *dev = to_ov2680_sensor(sd);
-	ov2680_debug(dev,  "++++ov2680_g_bin_factor_x\n");
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	dev_dbg(&client->dev,  "++++ov2680_g_bin_factor_x\n");
 	*val = ov2680_res[dev->fmt_idx].bin_factor_x;
 
 	return 0;
@@ -305,9 +305,10 @@ static int ov2680_g_bin_factor_x(struct v4l2_subdev *sd, s32 *val)
 static int ov2680_g_bin_factor_y(struct v4l2_subdev *sd, s32 *val)
 {
 	struct ov2680_device *dev = to_ov2680_sensor(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	
 	*val = ov2680_res[dev->fmt_idx].bin_factor_y;
-	ov2680_debug(dev,  "++++ov2680_g_bin_factor_y\n");
+	dev_dbg(&client->dev,  "++++ov2680_g_bin_factor_y\n");
 	return 0;
 }
 
@@ -322,7 +323,7 @@ static int ov2680_get_intg_factor(struct i2c_client *client,
 	unsigned int pix_clk_freq_hz;
 	u16 reg_val;
 	int ret;
-	ov2680_debug(dev,  "++++ov2680_get_intg_factor\n");
+	dev_dbg(&client->dev,  "++++ov2680_get_intg_factor\n");
 	if (!info)
 		return -EINVAL;
 
@@ -399,7 +400,7 @@ static long __ov2680_set_exposure(struct v4l2_subdev *sd, int coarse_itg,
 	u16 vts,hts;
 	int ret,exp_val;
 	
-       ov2680_debug(dev, "+++++++__ov2680_set_exposure coarse_itg %d, gain %d, digitgain %d++\n",coarse_itg, gain, digitgain);
+       dev_dbg(&client->dev, "+++++++__ov2680_set_exposure coarse_itg %d, gain %d, digitgain %d++\n",coarse_itg, gain, digitgain);
 
 	hts = ov2680_res[dev->fmt_idx].pixels_per_line;
 	vts = ov2680_res[dev->fmt_idx].lines_per_frame;
@@ -605,7 +606,7 @@ static int ov2680_v_flip(struct v4l2_subdev *sd, s32 value)
 	int ret;
 	u16 val;
 	u8 index;
-	ov2680_debug(&client->dev, "@%s: value:%d\n", __func__, value);
+	dev_dbg(&client->dev, "@%s: value:%d\n", __func__, value);
 	ret = ov2680_read_reg(client, OV2680_8BIT, OV2680_FLIP_REG, &val);
 	if (ret)
 		return ret;
@@ -636,7 +637,7 @@ static int ov2680_h_flip(struct v4l2_subdev *sd, s32 value)
 	int ret;
 	u16 val;
 	u8 index;
-	ov2680_debug(&client->dev, "@%s: value:%d\n", __func__, value);
+	dev_dbg(&client->dev, "@%s: value:%d\n", __func__, value);
 
 	ret = ov2680_read_reg(client, OV2680_8BIT, OV2680_MIRROR_REG, &val);
 	if (ret)
@@ -1069,7 +1070,7 @@ static int ov2680_set_fmt(struct v4l2_subdev *sd,
 	struct camera_mipi_info *ov2680_info = NULL;
 	int ret = 0;
 	int idx = 0;
-	ov2680_debug(&client->dev, "+++++ov2680_s_mbus_fmt+++++l\n");
+	dev_dbg(&client->dev, "+++++ov2680_s_mbus_fmt+++++l\n");
 	if (format->pad)
 		return -EINVAL;
 
@@ -1097,7 +1098,7 @@ static int ov2680_set_fmt(struct v4l2_subdev *sd,
 		return 0;
 		}
 	dev->fmt_idx = get_resolution_index(fmt->width, fmt->height);
-	ov2680_debug(&client->dev, "+++++get_resolution_index=%d+++++l\n",
+	dev_dbg(&client->dev, "+++++get_resolution_index=%d+++++l\n",
 		     dev->fmt_idx);
 	if (dev->fmt_idx == -1) {
 		dev_err(&client->dev, "get resolution fail\n");
@@ -1106,7 +1107,7 @@ static int ov2680_set_fmt(struct v4l2_subdev *sd,
 	}
 	v4l2_info(client, "__s_mbus_fmt i=%d, w=%d, h=%d\n", dev->fmt_idx,
 		  fmt->width, fmt->height);
-	ov2680_debug(&client->dev, "__s_mbus_fmt i=%d, w=%d, h=%d\n",
+	dev_dbg(&client->dev, "__s_mbus_fmt i=%d, w=%d, h=%d\n",
 		     dev->fmt_idx, fmt->width, fmt->height);
 
 	ret = ov2680_write_reg_array(client, ov2680_res[dev->fmt_idx].regs);
@@ -1203,9 +1204,9 @@ static int ov2680_s_stream(struct v4l2_subdev *sd, int enable)
 
 	mutex_lock(&dev->input_lock);
 	if(enable )
-		ov2680_debug(&client->dev, "ov2680_s_stream one \n");
+		dev_dbg(&client->dev, "ov2680_s_stream one \n");
 	else
-		ov2680_debug(&client->dev, "ov2680_s_stream off \n");
+		dev_dbg(&client->dev, "ov2680_s_stream off \n");
 	
 	ret = ov2680_write_reg(client, OV2680_8BIT, OV2680_SW_STREAM,
 				enable ? OV2680_START_STREAMING :
@@ -1508,11 +1509,11 @@ static int ov2680_probe(struct i2c_client *client,
 	if (ret)
 	{
 		ov2680_remove(client);
-		ov2680_debug(&client->dev, "+++ remove ov2680 \n");
+		dev_dbg(&client->dev, "+++ remove ov2680 \n");
 	}
 	return ret;
 out_free:
-	ov2680_debug(&client->dev, "+++ out free \n");
+	dev_dbg(&client->dev, "+++ out free \n");
 	v4l2_device_unregister_subdev(&dev->sd);
 	kfree(dev);
 	return ret;
