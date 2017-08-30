Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:57614 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751357AbdH3R4o (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 13:56:44 -0400
From: Rajmohan Mani <rajmohan.mani@intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@kernel.org, hverkuil@xs4all.nl, tfiga@chromium.org,
        sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        tuukka.toivonen@intel.com, Rajmohan Mani <rajmohan.mani@intel.com>
Subject: [PATCH] [media] dw9714: Set the v4l2 focus ctrl step as 1
Date: Wed, 30 Aug 2017 10:48:52 -0700
Message-Id: <1504115332-26651-1-git-send-email-rajmohan.mani@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Current v4l2 focus ctrl step value of 16, limits
the minimum granularity of focus positions to 16.
Setting this value as 1, enables more accurate
focus positions.

Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
---
 drivers/media/i2c/dw9714.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/dw9714.c b/drivers/media/i2c/dw9714.c
index 6a607d7..f9212a8 100644
--- a/drivers/media/i2c/dw9714.c
+++ b/drivers/media/i2c/dw9714.c
@@ -22,6 +22,11 @@
 #define DW9714_NAME		"dw9714"
 #define DW9714_MAX_FOCUS_POS	1023
 /*
+ * This sets the minimum granularity for the focus positions.
+ * A value of 1 gives maximum accuracy for a desired focus position
+ */
+#define DW9714_FOCUS_STEPS	1
+/*
  * This acts as the minimum granularity of lens movement.
  * Keep this value power of 2, so the control steps can be
  * uniformly adjusted for gradual lens movement, with desired
@@ -138,7 +143,7 @@ static int dw9714_init_controls(struct dw9714_device *dev_vcm)
 	v4l2_ctrl_handler_init(hdl, 1);
 
 	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_FOCUS_ABSOLUTE,
-			  0, DW9714_MAX_FOCUS_POS, DW9714_CTRL_STEPS, 0);
+			  0, DW9714_MAX_FOCUS_POS, DW9714_FOCUS_STEPS, 0);
 
 	if (hdl->error)
 		dev_err(&client->dev, "%s fail error: 0x%x\n",
-- 
1.9.1
