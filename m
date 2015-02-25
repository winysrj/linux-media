Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51541 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752880AbbBYMeL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2015 07:34:11 -0500
Received: from valkosipuli.retiisi.org.uk (vihersipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::84:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 97AA06009F
	for <linux-media@vger.kernel.org>; Wed, 25 Feb 2015 14:34:08 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH 3/3] smiapp: Use __v4l2_ctrl_grab() to grab controls
Date: Wed, 25 Feb 2015 14:33:27 +0200
Message-Id: <1424867607-4082-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1424867607-4082-1-git-send-email-sakari.ailus@iki.fi>
References: <1424867607-4082-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Instead of returning -EBUSY in s_ctrl(), use __v4l2_ctrl_grab() to mark the
controls grabbed.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index e534f1b..6658f61 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -423,9 +423,6 @@ static int smiapp_set_ctrl(struct v4l2_ctrl *ctrl)
 
 	case V4L2_CID_HFLIP:
 	case V4L2_CID_VFLIP:
-		if (sensor->streaming)
-			return -EBUSY;
-
 		if (sensor->hflip->val)
 			orient |= SMIAPP_IMAGE_ORIENTATION_HFLIP;
 
@@ -469,9 +466,6 @@ static int smiapp_set_ctrl(struct v4l2_ctrl *ctrl)
 			+ ctrl->val);
 
 	case V4L2_CID_LINK_FREQ:
-		if (sensor->streaming)
-			return -EBUSY;
-
 		return smiapp_pll_update(sensor);
 
 	case V4L2_CID_TEST_PATTERN: {
@@ -1535,15 +1529,15 @@ static int smiapp_set_stream(struct v4l2_subdev *subdev, int enable)
 	if (sensor->streaming == enable)
 		goto out;
 
-	if (enable) {
-		sensor->streaming = true;
+	if (enable)
 		rval = smiapp_start_streaming(sensor);
-		if (rval < 0)
-			sensor->streaming = false;
-	} else {
+	else
 		rval = smiapp_stop_streaming(sensor);
-		sensor->streaming = false;
-	}
+
+	sensor->streaming = enable;
+	__v4l2_ctrl_grab(sensor->hflip, enable);
+	__v4l2_ctrl_grab(sensor->vflip, enable);
+	__v4l2_ctrl_grab(sensor->link_freq, enable);
 
 out:
 	mutex_unlock(&sensor->mutex);
-- 
1.7.10.4

