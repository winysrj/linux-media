Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34940 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752291AbdC0Kcx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 06:32:53 -0400
Received: by mail-pg0-f65.google.com with SMTP id g2so11725236pge.2
        for <linux-media@vger.kernel.org>; Mon, 27 Mar 2017 03:32:38 -0700 (PDT)
From: vaibhavddit@gmail.com
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        rvarsha016@gmail.com, Vaibhav Kothari <vaibhavddit@gmail.com>
Subject: [PATCH] Fixing Coding Style Errors & Warning
Date: Mon, 27 Mar 2017 16:02:26 +0530
Message-Id: <1490610746-28579-1-git-send-email-vaibhavddit@gmail.com>
In-Reply-To: <[PATCH 1/1] Correcting coding style errors & warnings>
References: <[PATCH 1/1] Correcting coding style errors & warnings>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Kothari <vaibhavddit@gmail.com>

- Removed white-space before comma in memset()
- Added blanck line between declaration and defination
  at various places

Signed-off-by: Vaibhav Kothari <vaibhavddit@gmail.com>
---
 drivers/staging/media/atomisp/i2c/gc2235.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/gc2235.c b/drivers/staging/media/atomisp/i2c/gc2235.c
index 9b41023..0df20ba 100644
--- a/drivers/staging/media/atomisp/i2c/gc2235.c
+++ b/drivers/staging/media/atomisp/i2c/gc2235.c
@@ -55,7 +55,7 @@ static int gc2235_read_reg(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	memset(msg, 0 , sizeof(msg));
+	memset(msg, 0, sizeof(msg));
 
 	msg[0].addr = client->addr;
 	msg[0].flags = 0;
@@ -354,6 +354,7 @@ static long __gc2235_set_exposure(struct v4l2_subdev *sd, int coarse_itg,
 	u16 coarse_integration = (u16)coarse_itg;
 	int ret = 0;
 	u16 expo_coarse_h, expo_coarse_l, gain_val = 0xF0, gain_val2 = 0xF0;
+
 	expo_coarse_h = coarse_integration >> 8;
 	expo_coarse_l = coarse_integration & 0xff;
 
@@ -405,6 +406,7 @@ static long gc2235_s_exposure(struct v4l2_subdev *sd,
 	/* we should not accept the invalid value below. */
 	if (gain == 0) {
 		struct i2c_client *client = v4l2_get_subdevdata(sd);
+
 		v4l2_err(client, "%s: invalid value\n", __func__);
 		return -EINVAL;
 	}
@@ -746,12 +748,13 @@ static int startup(struct v4l2_subdev *sd)
 	struct gc2235_device *dev = to_gc2235_sensor(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	int ret = 0;
+
 	if (is_init == 0) {
 		/* force gc2235 to do a reset in res change, otherwise it
-		* can not output normal after switching res. and it is not
-		* necessary for first time run up after power on, for the sack
-		* of performance
-		*/
+		 * can not output normal after switching res. and it is not
+		 * necessary for first time run up after power on, for the sack
+		 * of performance
+		 */
 		power_down(sd);
 		power_up(sd);
 		gc2235_write_reg_array(client, gc2235_init_settings);
@@ -880,6 +883,7 @@ static int gc2235_s_stream(struct v4l2_subdev *sd, int enable)
 	struct gc2235_device *dev = to_gc2235_sensor(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	int ret;
+
 	mutex_lock(&dev->input_lock);
 
 	if (enable)
@@ -994,6 +998,7 @@ static int gc2235_s_parm(struct v4l2_subdev *sd,
 			struct v4l2_streamparm *param)
 {
 	struct gc2235_device *dev = to_gc2235_sensor(sd);
+
 	dev->run_mode = param->parm.capture.capturemode;
 
 	mutex_lock(&dev->input_lock);
@@ -1099,6 +1104,7 @@ static int gc2235_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct gc2235_device *dev = to_gc2235_sensor(sd);
+
 	dev_dbg(&client->dev, "gc2235_remove...\n");
 
 	if (dev->platform_data->platform_deinit)
-- 
1.9.1
