Return-path: <linux-media-owner@vger.kernel.org>
Received: from mrsl.grasp.upenn.edu ([158.130.53.11]:38351 "EHLO morwong"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754429Ab2EBW2r (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 May 2012 18:28:47 -0400
From: Kartik Mohta <kartikmohta@gmail.com>
To: linux-media@vger.kernel.org
Cc: Kartik Mohta <kartikmohta@gmail.com>
Subject: [PATCH] mt9v032: Correct the logic for the auto-exposure setting
Date: Wed,  2 May 2012 18:19:08 -0400
Message-Id: <1335997148-4915-1-git-send-email-kartikmohta@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver uses the ctrl value passed in as a bool to determine whether
to enable auto-exposure, but the auto-exposure setting is defined as an
enum where AUTO has a value of 0 and MANUAL has a value of 1. This leads
to a reversed logic where if you send in AUTO, it actually sets manual
exposure and vice-versa.

Signed-off-by: Kartik Mohta <kartikmohta@gmail.com>
---
 drivers/media/video/mt9v032.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/video/mt9v032.c b/drivers/media/video/mt9v032.c
index 75e253a..8ea8737 100644
--- a/drivers/media/video/mt9v032.c
+++ b/drivers/media/video/mt9v032.c
@@ -470,6 +470,7 @@ static int mt9v032_s_ctrl(struct v4l2_ctrl *ctrl)
 			container_of(ctrl->handler, struct mt9v032, ctrls);
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9v032->subdev);
 	u16 data;
+	int aec_value;
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUTOGAIN:
@@ -480,8 +481,13 @@ static int mt9v032_s_ctrl(struct v4l2_ctrl *ctrl)
 		return mt9v032_write(client, MT9V032_ANALOG_GAIN, ctrl->val);
 
 	case V4L2_CID_EXPOSURE_AUTO:
+		if(ctrl->val == V4L2_EXPOSURE_MANUAL)
+			aec_value = 0;
+		else
+			aec_value = 1;
+
 		return mt9v032_update_aec_agc(mt9v032, MT9V032_AEC_ENABLE,
-					      ctrl->val);
+					      aec_value);
 
 	case V4L2_CID_EXPOSURE:
 		return mt9v032_write(client, MT9V032_TOTAL_SHUTTER_WIDTH,
-- 
1.7.10.1

