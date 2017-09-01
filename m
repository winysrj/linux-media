Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:41371 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752400AbdIAWKC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Sep 2017 18:10:02 -0400
From: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: tfiga@chromium.org, jian.xu.zheng@intel.com,
        tian.shu.qiu@intel.com, rajmohan.mani@intel.com,
        hyungwoo.yang@intel.com,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Subject: [PATCH v1] media: ov5670: Fix not streaming issue after resume.
Date: Fri,  1 Sep 2017 15:08:31 -0700
Message-Id: <1504303711-16227-1-git-send-email-chiranjeevi.rapolu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Previously, the sensor was not streaming after resume from suspend,
i.e. on S0->S3->S0 transition. Due to this, camera app preview appeared
as stuck.

Now, handle streaming state correctly in case of suspend-resume.

Signed-off-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
---
 drivers/media/i2c/ov5670.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ov5670.c b/drivers/media/i2c/ov5670.c
index 6f7a1d6..bdfb5b9 100644
--- a/drivers/media/i2c/ov5670.c
+++ b/drivers/media/i2c/ov5670.c
@@ -2323,8 +2323,6 @@ static int ov5670_start_streaming(struct ov5670 *ov5670)
 		return ret;
 	}
 
-	ov5670->streaming = true;
-
 	return 0;
 }
 
@@ -2338,8 +2336,6 @@ static int ov5670_stop_streaming(struct ov5670 *ov5670)
 	if (ret)
 		dev_err(&client->dev, "%s failed to set stream\n", __func__);
 
-	ov5670->streaming = false;
-
 	/* Return success even if it was an error, as there is nothing the
 	 * caller can do about it.
 	 */
@@ -2370,6 +2366,7 @@ static int ov5670_set_stream(struct v4l2_subdev *sd, int enable)
 		ret = ov5670_stop_streaming(ov5670);
 		pm_runtime_put(&client->dev);
 	}
+	ov5670->streaming = enable;
 	goto unlock_and_return;
 
 error:
-- 
1.9.1
