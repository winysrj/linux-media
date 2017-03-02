Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36852 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750972AbdCBUYp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 15:24:45 -0500
From: simran singhal <singhalsimran0@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com
Subject: [PATCH 2/7] staging: media: Add blank line after a declaration
Date: Fri,  3 Mar 2017 01:21:57 +0530
Message-Id: <1488484322-5928-2-git-send-email-singhalsimran0@gmail.com>
In-Reply-To: <1488484322-5928-1-git-send-email-singhalsimran0@gmail.com>
References: <1488484322-5928-1-git-send-email-singhalsimran0@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add blank line after a declaration. Problem found
using checkpatch.

This patch fixes these warning messages found by checkpatch.pl:
WARNING : Missing a blank line after declarations.

Signed-off-by: simran singhal <singhalsimran0@gmail.com>
---
 drivers/staging/media/atomisp/i2c/gc2235.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/staging/media/atomisp/i2c/gc2235.c b/drivers/staging/media/atomisp/i2c/gc2235.c
index 3f2b11ec..7de7e24 100644
--- a/drivers/staging/media/atomisp/i2c/gc2235.c
+++ b/drivers/staging/media/atomisp/i2c/gc2235.c
@@ -359,6 +359,7 @@ static long __gc2235_set_exposure(struct v4l2_subdev *sd, int coarse_itg,
 	u16 coarse_integration = (u16)coarse_itg;
 	int ret = 0;
 	u16 expo_coarse_h, expo_coarse_l, gain_val = 0xF0, gain_val2 = 0xF0;
+
 	expo_coarse_h = coarse_integration>>8;
 	expo_coarse_l = coarse_integration & 0xff;
 
@@ -410,6 +411,7 @@ static long gc2235_s_exposure(struct v4l2_subdev *sd,
 	/* we should not accept the invalid value below. */
 	if (gain == 0) {
 		struct i2c_client *client = v4l2_get_subdevdata(sd);
+
 		v4l2_err(client, "%s: invalid value\n", __func__);
 		return -EINVAL;
 	}
@@ -546,6 +548,7 @@ static int is_init;
 static int gc2235_init(struct v4l2_subdev *sd)
 {
 	int ret = 0;
+
 	ret = __gc2235_init(sd);
 
 	return ret;
@@ -759,6 +762,7 @@ static int startup(struct v4l2_subdev *sd)
 	struct gc2235_device *dev = to_gc2235_sensor(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	int ret = 0;
+
 	if (is_init == 0) {
 		/* force gc2235 to do a reset in res change, otherwise it
 		* can not output normal after switching res. and it is not
@@ -893,6 +897,7 @@ static int gc2235_s_stream(struct v4l2_subdev *sd, int enable)
 	struct gc2235_device *dev = to_gc2235_sensor(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	int ret;
+
 	mutex_lock(&dev->input_lock);
 
 	if (enable)
@@ -1007,6 +1012,7 @@ static int gc2235_s_parm(struct v4l2_subdev *sd,
 			struct v4l2_streamparm *param)
 {
 	struct gc2235_device *dev = to_gc2235_sensor(sd);
+
 	dev->run_mode = param->parm.capture.capturemode;
 
 	mutex_lock(&dev->input_lock);
@@ -1112,6 +1118,7 @@ static int gc2235_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct gc2235_device *dev = to_gc2235_sensor(sd);
+
 	dev_dbg(&client->dev, "gc2235_remove...\n");
 
 	if (dev->platform_data->platform_deinit)
-- 
2.7.4
