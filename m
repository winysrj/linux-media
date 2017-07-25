Return-path: <linux-media-owner@vger.kernel.org>
Received: from sender-of-o52.zoho.com ([135.84.80.217]:21398 "EHLO
        sender-of-o52.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750743AbdGYGFa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Jul 2017 02:05:30 -0400
From: Stephen Brennan <stephen@brennan.io>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Stephen Brennan <stephen@brennan.io>
Subject: [PATCH] staging: atomisp: remove trailing whitespace
Date: Mon, 24 Jul 2017 23:04:10 -0700
Message-Id: <20170725060410.28012-1-stephen@brennan.io>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Stephen Brennan <stephen@brennan.io>
---
 drivers/staging/media/atomisp/i2c/ov2680.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/ov2680.c b/drivers/staging/media/atomisp/i2c/ov2680.c
index 8daf81dfabb7..51b7d61df0f5 100644
--- a/drivers/staging/media/atomisp/i2c/ov2680.c
+++ b/drivers/staging/media/atomisp/i2c/ov2680.c
@@ -89,7 +89,7 @@ static int ov2680_read_reg(struct i2c_client *client,
 			"read from offset 0x%x error %d", reg, err);
 		return err;
 	}
-	
+
 	*val = 0;
 	/* high byte comes first */
 	if (data_length == OV2680_8BIT)
@@ -285,7 +285,6 @@ static int ov2680_g_fnumber(struct v4l2_subdev *sd, s32 *val)
 
 static int ov2680_g_fnumber_range(struct v4l2_subdev *sd, s32 *val)
 {
-	
 	*val = (OV2680_F_NUMBER_DEFAULT_NUM << 24) |
 		(OV2680_F_NUMBER_DEM << 16) |
 		(OV2680_F_NUMBER_DEFAULT_NUM << 8) | OV2680_F_NUMBER_DEM;
@@ -306,7 +305,7 @@ static int ov2680_g_bin_factor_y(struct v4l2_subdev *sd, s32 *val)
 {
 	struct ov2680_device *dev = to_ov2680_sensor(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	
+
 	*val = ov2680_res[dev->fmt_idx].bin_factor_y;
 	dev_dbg(&client->dev,  "++++ov2680_g_bin_factor_y\n");
 	return 0;
@@ -399,7 +398,7 @@ static long __ov2680_set_exposure(struct v4l2_subdev *sd, int coarse_itg,
 	struct ov2680_device *dev = to_ov2680_sensor(sd);
 	u16 vts,hts;
 	int ret,exp_val;
-	
+
        dev_dbg(&client->dev, "+++++++__ov2680_set_exposure coarse_itg %d, gain %d, digitgain %d++\n",coarse_itg, gain, digitgain);
 
 	hts = ov2680_res[dev->fmt_idx].pixels_per_line;
@@ -542,7 +541,7 @@ static long ov2680_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
 	switch (cmd) {
 	case ATOMISP_IOC_S_EXPOSURE:
 		return ov2680_s_exposure(sd, arg);
-	
+
 	default:
 		return -EINVAL;
 	}
@@ -983,7 +982,7 @@ static int ov2680_s_power(struct v4l2_subdev *sd, int on)
 	if (on == 0){
 		ret = power_down(sd);
 	} else {
-		ret = power_up(sd);	
+		ret = power_up(sd);
 		if (!ret)
 			return ov2680_init(sd);
 	}
@@ -1207,7 +1206,7 @@ static int ov2680_s_stream(struct v4l2_subdev *sd, int enable)
 		dev_dbg(&client->dev, "ov2680_s_stream one \n");
 	else
 		dev_dbg(&client->dev, "ov2680_s_stream off \n");
-	
+
 	ret = ov2680_write_reg(client, OV2680_8BIT, OV2680_SW_STREAM,
 				enable ? OV2680_START_STREAMING :
 				OV2680_STOP_STREAMING);
@@ -1267,7 +1266,7 @@ static int ov2680_s_config(struct v4l2_subdev *sd,
 		dev_err(&client->dev, "ov2680_detect err s_config.\n");
 		goto fail_csi_cfg;
 	}
-	
+
 	/* turn off sensor, after probed */
 	ret = power_down(sd);
 	if (ret) {
@@ -1385,7 +1384,7 @@ static int ov2680_enum_frame_size(struct v4l2_subdev *sd,
 static int ov2680_g_skip_frames(struct v4l2_subdev *sd, u32 *frames)
 {
 	struct ov2680_device *dev = to_ov2680_sensor(sd);
-	
+
 	mutex_lock(&dev->input_lock);
 	*frames = ov2680_res[dev->fmt_idx].skip_frames;
 	mutex_unlock(&dev->input_lock);
-- 
2.13.3
