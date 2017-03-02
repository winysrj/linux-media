Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35914 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751027AbdCBTxQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 14:53:16 -0500
From: simran singhal <singhalsimran0@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com
Subject: [PATCH 7/7] staging: media: Do not use multiple blank lines
Date: Fri,  3 Mar 2017 01:22:02 +0530
Message-Id: <1488484322-5928-7-git-send-email-singhalsimran0@gmail.com>
In-Reply-To: <1488484322-5928-1-git-send-email-singhalsimran0@gmail.com>
References: <1488484322-5928-1-git-send-email-singhalsimran0@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove multiple blank lines. Problem found using checkpatch.pl
"CHECK: Please don't use multiple blank lines".

Signed-off-by: simran singhal <singhalsimran0@gmail.com>
---
 drivers/staging/media/atomisp/i2c/gc2235.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/gc2235.c b/drivers/staging/media/atomisp/i2c/gc2235.c
index 40a5a2f..b97a74b 100644
--- a/drivers/staging/media/atomisp/i2c/gc2235.c
+++ b/drivers/staging/media/atomisp/i2c/gc2235.c
@@ -244,7 +244,6 @@ static int gc2235_g_fnumber_range(struct v4l2_subdev *sd, s32 *val)
 	return 0;
 }
 
-
 static int gc2235_get_intg_factor(struct i2c_client *client,
 				struct camera_mipi_info *info,
 				const struct gc2235_resolution *res)
@@ -388,7 +387,6 @@ static long __gc2235_set_exposure(struct v4l2_subdev *sd, int coarse_itg,
 	return ret;
 }
 
-
 static int gc2235_set_exposure(struct v4l2_subdev *sd, int exposure,
 	int gain, int digitgain)
 {
@@ -909,7 +907,6 @@ static int gc2235_s_stream(struct v4l2_subdev *sd, int enable)
 	return ret;
 }
 
-
 static int gc2235_s_config(struct v4l2_subdev *sd,
 			   int irq, void *platform_data)
 {
-- 
2.7.4
