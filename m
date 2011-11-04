Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52214 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab1KDMqU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 08:46:20 -0400
Received: from localhost.localdomain (unknown [91.178.160.144])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 1173835A00
	for <linux-media@vger.kernel.org>; Fri,  4 Nov 2011 12:46:19 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 6/6] uvcvideo: Ignore GET_RES error for XU controls
Date: Fri,  4 Nov 2011 13:46:17 +0100
Message-Id: <1320410777-14108-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1320410777-14108-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1320410777-14108-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

GET_RES request support is mandatory for extension units, but some
cameras still choke on it (one example is the Logitech QuickCam PTZ that
returns a single byte for the PTZ relative control instead of four).

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_ctrl.c |   17 +++++++++++++++--
 drivers/media/video/uvc/uvcvideo.h |    1 +
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index 254d326..3e849d9 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -878,8 +878,21 @@ static int uvc_ctrl_populate_cache(struct uvc_video_chain *chain,
 				     chain->dev->intfnum, ctrl->info.selector,
 				     uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES),
 				     ctrl->info.size);
-		if (ret < 0)
-			return ret;
+		if (ret < 0) {
+			if (UVC_ENTITY_TYPE(ctrl->entity) !=
+			    UVC_VC_EXTENSION_UNIT)
+				return ret;
+
+			/* GET_RES is mandatory for XU controls, but some
+			 * cameras still choke on it. Ignore errors and set the
+			 * resolution value to zero.
+			 */
+			uvc_warn_once(chain->dev, UVC_WARN_XU_GET_RES,
+				      "UVC non compliance - GET_RES failed on "
+				      "an XU control. Enabling workaround.\n");
+			memset(uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES), 0,
+			       ctrl->info.size);
+		}
 	}
 
 	ctrl->cached = 1;
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 882159a..2b84cbb 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -477,6 +477,7 @@ struct uvc_driver {
 
 #define UVC_WARN_MINMAX		0
 #define UVC_WARN_PROBE_DEF	1
+#define UVC_WARN_XU_GET_RES	2
 
 extern unsigned int uvc_clock_param;
 extern unsigned int uvc_no_drop_param;
-- 
1.7.3.4

