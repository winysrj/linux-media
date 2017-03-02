Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:32929 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750787AbdCBTxQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 14:53:16 -0500
From: simran singhal <singhalsimran0@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com
Subject: [PATCH 4/7] staging: media: Remove blank line before '}' and after '{' braces
Date: Fri,  3 Mar 2017 01:21:59 +0530
Message-Id: <1488484322-5928-4-git-send-email-singhalsimran0@gmail.com>
In-Reply-To: <1488484322-5928-1-git-send-email-singhalsimran0@gmail.com>
References: <1488484322-5928-1-git-send-email-singhalsimran0@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unneeded blank lines preceding/following '}' and '{' braces, as
pointed out by checkpatch.

This patch addresses the following checkpatch checks:

CHECK: Blank lines aren't necessary before a close brace '}'
CHECK: Blank lines aren't necessary after an open brace '{'

Signed-off-by: simran singhal <singhalsimran0@gmail.com>
---
 drivers/staging/media/atomisp/i2c/gc2235.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/gc2235.c b/drivers/staging/media/atomisp/i2c/gc2235.c
index 2ef876a..198df22 100644
--- a/drivers/staging/media/atomisp/i2c/gc2235.c
+++ b/drivers/staging/media/atomisp/i2c/gc2235.c
@@ -788,7 +788,6 @@ static int gc2235_set_fmt(struct v4l2_subdev *sd,
 			  struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *format)
 {
-
 	struct v4l2_mbus_framefmt *fmt = &format->format;
 	struct gc2235_device *dev = to_gc2235_sensor(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -1070,7 +1069,6 @@ static int gc2235_enum_frame_size(struct v4l2_subdev *sd,
 	fse->max_height = gc2235_res[index].height;
 
 	return 0;
-
 }
 
 static int gc2235_g_skip_frames(struct v4l2_subdev *sd, u32 *frames)
@@ -1228,7 +1226,6 @@ static int init_gc2235(void)
 
 static void exit_gc2235(void)
 {
-
 	i2c_del_driver(&gc2235_driver);
 }
 
-- 
2.7.4
