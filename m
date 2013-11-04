Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48333 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab3KDAG0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Nov 2013 19:06:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 07/18] v4l: omap4iss: Don't use v4l2_g_ext_ctrls() internally
Date: Mon,  4 Nov 2013 01:06:32 +0100
Message-Id: <1383523603-3907-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using the extended control API internally to get the sensor
pixel rate, use the dedicated in-kernel APIs (find the control with
v4l2_ctrl_find() and get its value with v4l2_ctrl_g_ctrl_int64()).

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index d054d9b..1a5cac9 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -121,8 +121,7 @@ int omap4iss_get_external_info(struct iss_pipeline *pipe,
 	struct iss_device *iss =
 		container_of(pipe, struct iss_video, pipe)->iss;
 	struct v4l2_subdev_format fmt;
-	struct v4l2_ext_controls ctrls;
-	struct v4l2_ext_control ctrl;
+	struct v4l2_ctrl *ctrl;
 	int ret;
 
 	if (!pipe->external)
@@ -142,23 +141,15 @@ int omap4iss_get_external_info(struct iss_pipeline *pipe,
 
 	pipe->external_bpp = omap4iss_video_format_info(fmt.format.code)->bpp;
 
-	memset(&ctrls, 0, sizeof(ctrls));
-	memset(&ctrl, 0, sizeof(ctrl));
-
-	ctrl.id = V4L2_CID_PIXEL_RATE;
-
-	ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(ctrl.id);
-	ctrls.count = 1;
-	ctrls.controls = &ctrl;
-
-	ret = v4l2_g_ext_ctrls(pipe->external->ctrl_handler, &ctrls);
-	if (ret < 0) {
+	ctrl = v4l2_ctrl_find(pipe->external->ctrl_handler,
+			      V4L2_CID_PIXEL_RATE);
+	if (ctrl == NULL) {
 		dev_warn(iss->dev, "no pixel rate control in subdev %s\n",
 			 pipe->external->name);
-		return ret;
+		return -EPIPE;
 	}
 
-	pipe->external_rate = ctrl.value64;
+	pipe->external_rate = v4l2_ctrl_g_ctrl_int64(ctrl);
 
 	return 0;
 }
-- 
1.8.1.5

