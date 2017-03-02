Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35740 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750941AbdCBTxQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 14:53:16 -0500
From: simran singhal <singhalsimran0@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com
Subject: [PATCH 6/7] staging: media: Use x instead of x != NULL
Date: Fri,  3 Mar 2017 01:22:01 +0530
Message-Id: <1488484322-5928-6-git-send-email-singhalsimran0@gmail.com>
In-Reply-To: <1488484322-5928-1-git-send-email-singhalsimran0@gmail.com>
References: <1488484322-5928-1-git-send-email-singhalsimran0@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use x instead of x != NULL .
This patch removes the explicit NULL comparisons.This issue is found by
checkpatch.pl script.

Signed-off-by: simran singhal <singhalsimran0@gmail.com>
---
 drivers/staging/media/atomisp/i2c/gc2235.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/gc2235.c b/drivers/staging/media/atomisp/i2c/gc2235.c
index 165dcb3..40a5a2f 100644
--- a/drivers/staging/media/atomisp/i2c/gc2235.c
+++ b/drivers/staging/media/atomisp/i2c/gc2235.c
@@ -255,7 +255,7 @@ static int gc2235_get_intg_factor(struct i2c_client *client,
 	u16 reg_val, reg_val_h, dummy;
 	int ret;
 
-	if (info == NULL)
+	if (!info)
 		return -EINVAL;
 
 	/* pixel clock calculattion */
@@ -797,7 +797,7 @@ static int gc2235_set_fmt(struct v4l2_subdev *sd,
 	int idx;
 
 	gc2235_info = v4l2_get_subdev_hostdata(sd);
-	if (gc2235_info == NULL)
+	if (!gc2235_info)
 		return -EINVAL;
 	if (format->pad)
 		return -EINVAL;
@@ -917,7 +917,7 @@ static int gc2235_s_config(struct v4l2_subdev *sd,
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	int ret = 0;
 
-	if (platform_data == NULL)
+	if (!platform_data)
 		return -ENODEV;
 
 	dev->platform_data =
-- 
2.7.4
