Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49391 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab1AGQAC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 11:00:02 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/5] uvcvideo: Rename UVC_CONTROL_* flags to UVC_CTRL_FLAG_*
Date: Fri,  7 Jan 2011 17:00:38 +0100
Message-Id: <1294416040-28371-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1294416040-28371-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1294416040-28371-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This makes the public driver API more uniform, in preparation of moving
uvcvideo.h to include/linux.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_ctrl.c |  252 ++++++++++++++++++++----------------
 drivers/media/video/uvc/uvcvideo.h |   23 ++--
 2 files changed, 155 insertions(+), 120 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index 47175cc..d6fe13d 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -42,281 +42,313 @@ static struct uvc_control_info uvc_ctrls[] = {
 		.selector	= UVC_PU_BRIGHTNESS_CONTROL,
 		.index		= 0,
 		.size		= 2,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
-				| UVC_CONTROL_RESTORE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR
+				| UVC_CTRL_FLAG_GET_RANGE
+				| UVC_CTRL_FLAG_RESTORE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_CONTRAST_CONTROL,
 		.index		= 1,
 		.size		= 2,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
-				| UVC_CONTROL_RESTORE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR
+				| UVC_CTRL_FLAG_GET_RANGE
+				| UVC_CTRL_FLAG_RESTORE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_HUE_CONTROL,
 		.index		= 2,
 		.size		= 2,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
-				| UVC_CONTROL_RESTORE | UVC_CONTROL_AUTO_UPDATE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR
+				| UVC_CTRL_FLAG_GET_RANGE
+				| UVC_CTRL_FLAG_RESTORE
+				| UVC_CTRL_FLAG_AUTO_UPDATE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_SATURATION_CONTROL,
 		.index		= 3,
 		.size		= 2,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
-				| UVC_CONTROL_RESTORE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR
+				| UVC_CTRL_FLAG_GET_RANGE
+				| UVC_CTRL_FLAG_RESTORE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_SHARPNESS_CONTROL,
 		.index		= 4,
 		.size		= 2,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
-				| UVC_CONTROL_RESTORE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR
+				| UVC_CTRL_FLAG_GET_RANGE
+				| UVC_CTRL_FLAG_RESTORE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_GAMMA_CONTROL,
 		.index		= 5,
 		.size		= 2,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
-				| UVC_CONTROL_RESTORE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR
+				| UVC_CTRL_FLAG_GET_RANGE
+				| UVC_CTRL_FLAG_RESTORE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_WHITE_BALANCE_TEMPERATURE_CONTROL,
 		.index		= 6,
 		.size		= 2,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
-				| UVC_CONTROL_RESTORE | UVC_CONTROL_AUTO_UPDATE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR
+				| UVC_CTRL_FLAG_GET_RANGE
+				| UVC_CTRL_FLAG_RESTORE
+				| UVC_CTRL_FLAG_AUTO_UPDATE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_WHITE_BALANCE_COMPONENT_CONTROL,
 		.index		= 7,
 		.size		= 4,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
-				| UVC_CONTROL_RESTORE | UVC_CONTROL_AUTO_UPDATE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR
+				| UVC_CTRL_FLAG_GET_RANGE
+				| UVC_CTRL_FLAG_RESTORE
+				| UVC_CTRL_FLAG_AUTO_UPDATE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_BACKLIGHT_COMPENSATION_CONTROL,
 		.index		= 8,
 		.size		= 2,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
-				| UVC_CONTROL_RESTORE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR
+				| UVC_CTRL_FLAG_GET_RANGE
+				| UVC_CTRL_FLAG_RESTORE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_GAIN_CONTROL,
 		.index		= 9,
 		.size		= 2,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
-				| UVC_CONTROL_RESTORE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR
+				| UVC_CTRL_FLAG_GET_RANGE
+				| UVC_CTRL_FLAG_RESTORE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_POWER_LINE_FREQUENCY_CONTROL,
 		.index		= 10,
 		.size		= 1,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_CUR
-				| UVC_CONTROL_GET_DEF | UVC_CONTROL_RESTORE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_CUR
+				| UVC_CTRL_FLAG_GET_DEF | UVC_CTRL_FLAG_RESTORE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_HUE_AUTO_CONTROL,
 		.index		= 11,
 		.size		= 1,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_CUR
-				| UVC_CONTROL_GET_DEF | UVC_CONTROL_RESTORE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_CUR
+				| UVC_CTRL_FLAG_GET_DEF | UVC_CTRL_FLAG_RESTORE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_WHITE_BALANCE_TEMPERATURE_AUTO_CONTROL,
 		.index		= 12,
 		.size		= 1,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_CUR
-				| UVC_CONTROL_GET_DEF | UVC_CONTROL_RESTORE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_CUR
+				| UVC_CTRL_FLAG_GET_DEF | UVC_CTRL_FLAG_RESTORE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_WHITE_BALANCE_COMPONENT_AUTO_CONTROL,
 		.index		= 13,
 		.size		= 1,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_CUR
-				| UVC_CONTROL_GET_DEF | UVC_CONTROL_RESTORE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_CUR
+				| UVC_CTRL_FLAG_GET_DEF | UVC_CTRL_FLAG_RESTORE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_DIGITAL_MULTIPLIER_CONTROL,
 		.index		= 14,
 		.size		= 2,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
-				| UVC_CONTROL_RESTORE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR
+				| UVC_CTRL_FLAG_GET_RANGE
+				| UVC_CTRL_FLAG_RESTORE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_DIGITAL_MULTIPLIER_LIMIT_CONTROL,
 		.index		= 15,
 		.size		= 2,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
-				| UVC_CONTROL_RESTORE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR
+				| UVC_CTRL_FLAG_GET_RANGE
+				| UVC_CTRL_FLAG_RESTORE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_ANALOG_VIDEO_STANDARD_CONTROL,
 		.index		= 16,
 		.size		= 1,
-		.flags		= UVC_CONTROL_GET_CUR,
+		.flags		= UVC_CTRL_FLAG_GET_CUR,
 	},
 	{
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_ANALOG_LOCK_STATUS_CONTROL,
 		.index		= 17,
 		.size		= 1,
-		.flags		= UVC_CONTROL_GET_CUR,
+		.flags		= UVC_CTRL_FLAG_GET_CUR,
 	},
 	{
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_SCANNING_MODE_CONTROL,
 		.index		= 0,
 		.size		= 1,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_CUR
-				| UVC_CONTROL_RESTORE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_CUR
+				| UVC_CTRL_FLAG_RESTORE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_AE_MODE_CONTROL,
 		.index		= 1,
 		.size		= 1,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_CUR
-				| UVC_CONTROL_GET_DEF | UVC_CONTROL_GET_RES
-				| UVC_CONTROL_RESTORE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_CUR
+				| UVC_CTRL_FLAG_GET_DEF | UVC_CTRL_FLAG_GET_RES
+				| UVC_CTRL_FLAG_RESTORE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_AE_PRIORITY_CONTROL,
 		.index		= 2,
 		.size		= 1,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_CUR
-				| UVC_CONTROL_RESTORE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_CUR
+				| UVC_CTRL_FLAG_RESTORE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_EXPOSURE_TIME_ABSOLUTE_CONTROL,
 		.index		= 3,
 		.size		= 4,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
-				| UVC_CONTROL_RESTORE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR
+				| UVC_CTRL_FLAG_GET_RANGE
+				| UVC_CTRL_FLAG_RESTORE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_EXPOSURE_TIME_RELATIVE_CONTROL,
 		.index		= 4,
 		.size		= 1,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_RESTORE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_RESTORE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_FOCUS_ABSOLUTE_CONTROL,
 		.index		= 5,
 		.size		= 2,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
-				| UVC_CONTROL_RESTORE | UVC_CONTROL_AUTO_UPDATE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR
+				| UVC_CTRL_FLAG_GET_RANGE
+				| UVC_CTRL_FLAG_RESTORE
+				| UVC_CTRL_FLAG_AUTO_UPDATE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_FOCUS_RELATIVE_CONTROL,
 		.index		= 6,
 		.size		= 2,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_MIN
-				| UVC_CONTROL_GET_MAX | UVC_CONTROL_GET_RES
-				| UVC_CONTROL_GET_DEF | UVC_CONTROL_AUTO_UPDATE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_MIN
+				| UVC_CTRL_FLAG_GET_MAX | UVC_CTRL_FLAG_GET_RES
+				| UVC_CTRL_FLAG_GET_DEF
+				| UVC_CTRL_FLAG_AUTO_UPDATE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_IRIS_ABSOLUTE_CONTROL,
 		.index		= 7,
 		.size		= 2,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
-				| UVC_CONTROL_RESTORE | UVC_CONTROL_AUTO_UPDATE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR
+				| UVC_CTRL_FLAG_GET_RANGE
+				| UVC_CTRL_FLAG_RESTORE
+				| UVC_CTRL_FLAG_AUTO_UPDATE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_IRIS_RELATIVE_CONTROL,
 		.index		= 8,
 		.size		= 1,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_AUTO_UPDATE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR
+				| UVC_CTRL_FLAG_AUTO_UPDATE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_ZOOM_ABSOLUTE_CONTROL,
 		.index		= 9,
 		.size		= 2,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
-				| UVC_CONTROL_RESTORE | UVC_CONTROL_AUTO_UPDATE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR
+				| UVC_CTRL_FLAG_GET_RANGE
+				| UVC_CTRL_FLAG_RESTORE
+				| UVC_CTRL_FLAG_AUTO_UPDATE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_ZOOM_RELATIVE_CONTROL,
 		.index		= 10,
 		.size		= 3,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_MIN
-				| UVC_CONTROL_GET_MAX | UVC_CONTROL_GET_RES
-				| UVC_CONTROL_GET_DEF | UVC_CONTROL_AUTO_UPDATE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_MIN
+				| UVC_CTRL_FLAG_GET_MAX | UVC_CTRL_FLAG_GET_RES
+				| UVC_CTRL_FLAG_GET_DEF
+				| UVC_CTRL_FLAG_AUTO_UPDATE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_PANTILT_ABSOLUTE_CONTROL,
 		.index		= 11,
 		.size		= 8,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
-				| UVC_CONTROL_RESTORE | UVC_CONTROL_AUTO_UPDATE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR
+				| UVC_CTRL_FLAG_GET_RANGE
+				| UVC_CTRL_FLAG_RESTORE
+				| UVC_CTRL_FLAG_AUTO_UPDATE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_PANTILT_RELATIVE_CONTROL,
 		.index		= 12,
 		.size		= 4,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_MIN
-				| UVC_CONTROL_GET_MAX | UVC_CONTROL_GET_RES
-				| UVC_CONTROL_GET_DEF | UVC_CONTROL_AUTO_UPDATE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_MIN
+				| UVC_CTRL_FLAG_GET_MAX | UVC_CTRL_FLAG_GET_RES
+				| UVC_CTRL_FLAG_GET_DEF
+				| UVC_CTRL_FLAG_AUTO_UPDATE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_ROLL_ABSOLUTE_CONTROL,
 		.index		= 13,
 		.size		= 2,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_RANGE
-				| UVC_CONTROL_RESTORE | UVC_CONTROL_AUTO_UPDATE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR
+				| UVC_CTRL_FLAG_GET_RANGE
+				| UVC_CTRL_FLAG_RESTORE
+				| UVC_CTRL_FLAG_AUTO_UPDATE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_ROLL_RELATIVE_CONTROL,
 		.index		= 14,
 		.size		= 2,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_MIN
-				| UVC_CONTROL_GET_MAX | UVC_CONTROL_GET_RES
-				| UVC_CONTROL_GET_DEF | UVC_CONTROL_AUTO_UPDATE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_MIN
+				| UVC_CTRL_FLAG_GET_MAX | UVC_CTRL_FLAG_GET_RES
+				| UVC_CTRL_FLAG_GET_DEF
+				| UVC_CTRL_FLAG_AUTO_UPDATE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_FOCUS_AUTO_CONTROL,
 		.index		= 17,
 		.size		= 1,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_CUR
-				| UVC_CONTROL_GET_DEF | UVC_CONTROL_RESTORE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_CUR
+				| UVC_CTRL_FLAG_GET_DEF | UVC_CTRL_FLAG_RESTORE,
 	},
 	{
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_PRIVACY_CONTROL,
 		.index		= 18,
 		.size		= 1,
-		.flags		= UVC_CONTROL_SET_CUR | UVC_CONTROL_GET_CUR
-				| UVC_CONTROL_RESTORE | UVC_CONTROL_AUTO_UPDATE,
+		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_CUR
+				| UVC_CTRL_FLAG_RESTORE
+				| UVC_CTRL_FLAG_AUTO_UPDATE,
 	},
 };
 
@@ -816,7 +848,7 @@ static int uvc_ctrl_populate_cache(struct uvc_video_chain *chain,
 {
 	int ret;
 
-	if (ctrl->info.flags & UVC_CONTROL_GET_DEF) {
+	if (ctrl->info.flags & UVC_CTRL_FLAG_GET_DEF) {
 		ret = uvc_query_ctrl(chain->dev, UVC_GET_DEF, ctrl->entity->id,
 				     chain->dev->intfnum, ctrl->info.selector,
 				     uvc_ctrl_data(ctrl, UVC_CTRL_DATA_DEF),
@@ -825,7 +857,7 @@ static int uvc_ctrl_populate_cache(struct uvc_video_chain *chain,
 			return ret;
 	}
 
-	if (ctrl->info.flags & UVC_CONTROL_GET_MIN) {
+	if (ctrl->info.flags & UVC_CTRL_FLAG_GET_MIN) {
 		ret = uvc_query_ctrl(chain->dev, UVC_GET_MIN, ctrl->entity->id,
 				     chain->dev->intfnum, ctrl->info.selector,
 				     uvc_ctrl_data(ctrl, UVC_CTRL_DATA_MIN),
@@ -833,7 +865,7 @@ static int uvc_ctrl_populate_cache(struct uvc_video_chain *chain,
 		if (ret < 0)
 			return ret;
 	}
-	if (ctrl->info.flags & UVC_CONTROL_GET_MAX) {
+	if (ctrl->info.flags & UVC_CTRL_FLAG_GET_MAX) {
 		ret = uvc_query_ctrl(chain->dev, UVC_GET_MAX, ctrl->entity->id,
 				     chain->dev->intfnum, ctrl->info.selector,
 				     uvc_ctrl_data(ctrl, UVC_CTRL_DATA_MAX),
@@ -841,7 +873,7 @@ static int uvc_ctrl_populate_cache(struct uvc_video_chain *chain,
 		if (ret < 0)
 			return ret;
 	}
-	if (ctrl->info.flags & UVC_CONTROL_GET_RES) {
+	if (ctrl->info.flags & UVC_CTRL_FLAG_GET_RES) {
 		ret = uvc_query_ctrl(chain->dev, UVC_GET_RES, ctrl->entity->id,
 				     chain->dev->intfnum, ctrl->info.selector,
 				     uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES),
@@ -879,9 +911,9 @@ int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 	strlcpy(v4l2_ctrl->name, mapping->name, sizeof v4l2_ctrl->name);
 	v4l2_ctrl->flags = 0;
 
-	if (!(ctrl->info.flags & UVC_CONTROL_GET_CUR))
+	if (!(ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR))
 		v4l2_ctrl->flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
-	if (!(ctrl->info.flags & UVC_CONTROL_SET_CUR))
+	if (!(ctrl->info.flags & UVC_CTRL_FLAG_SET_CUR))
 		v4l2_ctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 
 	if (!ctrl->cached) {
@@ -890,7 +922,7 @@ int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 			goto done;
 	}
 
-	if (ctrl->info.flags & UVC_CONTROL_GET_DEF) {
+	if (ctrl->info.flags & UVC_CTRL_FLAG_GET_DEF) {
 		v4l2_ctrl->default_value = mapping->get(mapping, UVC_GET_DEF,
 				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_DEF));
 	}
@@ -927,15 +959,15 @@ int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 		break;
 	}
 
-	if (ctrl->info.flags & UVC_CONTROL_GET_MIN)
+	if (ctrl->info.flags & UVC_CTRL_FLAG_GET_MIN)
 		v4l2_ctrl->minimum = mapping->get(mapping, UVC_GET_MIN,
 				     uvc_ctrl_data(ctrl, UVC_CTRL_DATA_MIN));
 
-	if (ctrl->info.flags & UVC_CONTROL_GET_MAX)
+	if (ctrl->info.flags & UVC_CTRL_FLAG_GET_MAX)
 		v4l2_ctrl->maximum = mapping->get(mapping, UVC_GET_MAX,
 				     uvc_ctrl_data(ctrl, UVC_CTRL_DATA_MAX));
 
-	if (ctrl->info.flags & UVC_CONTROL_GET_RES)
+	if (ctrl->info.flags & UVC_CTRL_FLAG_GET_RES)
 		v4l2_ctrl->step = mapping->get(mapping, UVC_GET_RES,
 				  uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES));
 
@@ -1039,7 +1071,7 @@ static int uvc_ctrl_commit_entity(struct uvc_device *dev,
 		 * marked as loaded in uvc_ctrl_get/uvc_ctrl_set to prevent
 		 * uvc_ctrl_get from using the cached value.
 		 */
-		if (ctrl->info.flags & UVC_CONTROL_AUTO_UPDATE)
+		if (ctrl->info.flags & UVC_CTRL_FLAG_AUTO_UPDATE)
 			ctrl->loaded = 0;
 
 		if (!ctrl->dirty)
@@ -1094,7 +1126,7 @@ int uvc_ctrl_get(struct uvc_video_chain *chain,
 	int ret;
 
 	ctrl = uvc_find_control(chain, xctrl->id, &mapping);
-	if (ctrl == NULL || (ctrl->info.flags & UVC_CONTROL_GET_CUR) == 0)
+	if (ctrl == NULL || (ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR) == 0)
 		return -EINVAL;
 
 	if (!ctrl->loaded) {
@@ -1136,7 +1168,7 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
 	int ret;
 
 	ctrl = uvc_find_control(chain, xctrl->id, &mapping);
-	if (ctrl == NULL || (ctrl->info.flags & UVC_CONTROL_SET_CUR) == 0)
+	if (ctrl == NULL || (ctrl->info.flags & UVC_CTRL_FLAG_SET_CUR) == 0)
 		return -EINVAL;
 
 	/* Clamp out of range values. */
@@ -1183,7 +1215,7 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
 	 * operation.
 	 */
 	if (!ctrl->loaded && (ctrl->info.size * 8) != mapping->size) {
-		if ((ctrl->info.flags & UVC_CONTROL_GET_CUR) == 0) {
+		if ((ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR) == 0) {
 			memset(uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
 				0, ctrl->info.size);
 		} else {
@@ -1230,17 +1262,17 @@ static void uvc_ctrl_fixup_xu_info(struct uvc_device *dev,
 
 	static const struct uvc_ctrl_fixup fixups[] = {
 		{ { USB_DEVICE(0x046d, 0x08c2) }, 9, 1,
-			UVC_CONTROL_GET_MIN | UVC_CONTROL_GET_MAX |
-			UVC_CONTROL_GET_DEF | UVC_CONTROL_SET_CUR |
-			UVC_CONTROL_AUTO_UPDATE },
+			UVC_CTRL_FLAG_GET_MIN | UVC_CTRL_FLAG_GET_MAX |
+			UVC_CTRL_FLAG_GET_DEF | UVC_CTRL_FLAG_SET_CUR |
+			UVC_CTRL_FLAG_AUTO_UPDATE },
 		{ { USB_DEVICE(0x046d, 0x08cc) }, 9, 1,
-			UVC_CONTROL_GET_MIN | UVC_CONTROL_GET_MAX |
-			UVC_CONTROL_GET_DEF | UVC_CONTROL_SET_CUR |
-			UVC_CONTROL_AUTO_UPDATE },
+			UVC_CTRL_FLAG_GET_MIN | UVC_CTRL_FLAG_GET_MAX |
+			UVC_CTRL_FLAG_GET_DEF | UVC_CTRL_FLAG_SET_CUR |
+			UVC_CTRL_FLAG_AUTO_UPDATE },
 		{ { USB_DEVICE(0x046d, 0x0994) }, 9, 1,
-			UVC_CONTROL_GET_MIN | UVC_CONTROL_GET_MAX |
-			UVC_CONTROL_GET_DEF | UVC_CONTROL_SET_CUR |
-			UVC_CONTROL_AUTO_UPDATE },
+			UVC_CTRL_FLAG_GET_MIN | UVC_CTRL_FLAG_GET_MAX |
+			UVC_CTRL_FLAG_GET_DEF | UVC_CTRL_FLAG_SET_CUR |
+			UVC_CTRL_FLAG_AUTO_UPDATE },
 	};
 
 	unsigned int i;
@@ -1297,21 +1329,23 @@ static int uvc_ctrl_fill_xu_info(struct uvc_device *dev,
 		goto done;
 	}
 
-	info->flags = UVC_CONTROL_GET_MIN | UVC_CONTROL_GET_MAX
-		    | UVC_CONTROL_GET_RES | UVC_CONTROL_GET_DEF
-		    | (data[0] & UVC_CONTROL_CAP_GET ? UVC_CONTROL_GET_CUR : 0)
-		    | (data[0] & UVC_CONTROL_CAP_SET ? UVC_CONTROL_SET_CUR : 0)
+	info->flags = UVC_CTRL_FLAG_GET_MIN | UVC_CTRL_FLAG_GET_MAX
+		    | UVC_CTRL_FLAG_GET_RES | UVC_CTRL_FLAG_GET_DEF
+		    | (data[0] & UVC_CONTROL_CAP_GET ?
+		       UVC_CTRL_FLAG_GET_CUR : 0)
+		    | (data[0] & UVC_CONTROL_CAP_SET ?
+		       UVC_CTRL_FLAG_SET_CUR : 0)
 		    | (data[0] & UVC_CONTROL_CAP_AUTOUPDATE ?
-		       UVC_CONTROL_AUTO_UPDATE : 0);
+		       UVC_CTRL_FLAG_AUTO_UPDATE : 0);
 
 	uvc_ctrl_fixup_xu_info(dev, ctrl, info);
 
 	uvc_trace(UVC_TRACE_CONTROL, "XU control %pUl/%u queried: len %u, "
 		  "flags { get %u set %u auto %u }.\n",
 		  info->entity, info->selector, info->size,
-		  (info->flags & UVC_CONTROL_GET_CUR) ? 1 : 0,
-		  (info->flags & UVC_CONTROL_SET_CUR) ? 1 : 0,
-		  (info->flags & UVC_CONTROL_AUTO_UPDATE) ? 1 : 0);
+		  (info->flags & UVC_CTRL_FLAG_GET_CUR) ? 1 : 0,
+		  (info->flags & UVC_CTRL_FLAG_SET_CUR) ? 1 : 0,
+		  (info->flags & UVC_CTRL_FLAG_AUTO_UPDATE) ? 1 : 0);
 
 done:
 	kfree(data);
@@ -1397,22 +1431,22 @@ int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
 
 	switch (xqry->query) {
 	case UVC_GET_CUR:
-		reqflags = UVC_CONTROL_GET_CUR;
+		reqflags = UVC_CTRL_FLAG_GET_CUR;
 		break;
 	case UVC_GET_MIN:
-		reqflags = UVC_CONTROL_GET_MIN;
+		reqflags = UVC_CTRL_FLAG_GET_MIN;
 		break;
 	case UVC_GET_MAX:
-		reqflags = UVC_CONTROL_GET_MAX;
+		reqflags = UVC_CTRL_FLAG_GET_MAX;
 		break;
 	case UVC_GET_DEF:
-		reqflags = UVC_CONTROL_GET_DEF;
+		reqflags = UVC_CTRL_FLAG_GET_DEF;
 		break;
 	case UVC_GET_RES:
-		reqflags = UVC_CONTROL_GET_RES;
+		reqflags = UVC_CTRL_FLAG_GET_RES;
 		break;
 	case UVC_SET_CUR:
-		reqflags = UVC_CONTROL_SET_CUR;
+		reqflags = UVC_CTRL_FLAG_SET_CUR;
 		break;
 	case UVC_GET_LEN:
 		size = 2;
@@ -1488,7 +1522,7 @@ int uvc_ctrl_resume_device(struct uvc_device *dev)
 			ctrl = &entity->controls[i];
 
 			if (!ctrl->initialized || !ctrl->modified ||
-			    (ctrl->info.flags & UVC_CONTROL_RESTORE) == 0)
+			    (ctrl->info.flags & UVC_CTRL_FLAG_RESTORE) == 0)
 				continue;
 
 			printk(KERN_INFO "restoring control %pUl/%u/%u\n",
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 8933b2a..b98bbd3 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -17,20 +17,21 @@
 #define UVC_CTRL_DATA_TYPE_BITMASK	5
 
 /* Control flags */
-#define UVC_CONTROL_SET_CUR	(1 << 0)
-#define UVC_CONTROL_GET_CUR	(1 << 1)
-#define UVC_CONTROL_GET_MIN	(1 << 2)
-#define UVC_CONTROL_GET_MAX	(1 << 3)
-#define UVC_CONTROL_GET_RES	(1 << 4)
-#define UVC_CONTROL_GET_DEF	(1 << 5)
+#define UVC_CTRL_FLAG_SET_CUR		(1 << 0)
+#define UVC_CTRL_FLAG_GET_CUR		(1 << 1)
+#define UVC_CTRL_FLAG_GET_MIN		(1 << 2)
+#define UVC_CTRL_FLAG_GET_MAX		(1 << 3)
+#define UVC_CTRL_FLAG_GET_RES		(1 << 4)
+#define UVC_CTRL_FLAG_GET_DEF		(1 << 5)
 /* Control should be saved at suspend and restored at resume. */
-#define UVC_CONTROL_RESTORE	(1 << 6)
+#define UVC_CTRL_FLAG_RESTORE		(1 << 6)
 /* Control can be updated by the camera. */
-#define UVC_CONTROL_AUTO_UPDATE	(1 << 7)
+#define UVC_CTRL_FLAG_AUTO_UPDATE	(1 << 7)
 
-#define UVC_CONTROL_GET_RANGE	(UVC_CONTROL_GET_CUR | UVC_CONTROL_GET_MIN | \
-				 UVC_CONTROL_GET_MAX | UVC_CONTROL_GET_RES | \
-				 UVC_CONTROL_GET_DEF)
+#define UVC_CTRL_FLAG_GET_RANGE \
+	(UVC_CTRL_FLAG_GET_CUR | UVC_CTRL_FLAG_GET_MIN | \
+	 UVC_CTRL_FLAG_GET_MAX | UVC_CTRL_FLAG_GET_RES | \
+	 UVC_CTRL_FLAG_GET_DEF)
 
 struct uvc_xu_control_info {
 	__u8 entity[16];
-- 
1.7.2.2

