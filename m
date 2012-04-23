Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37598 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab2DWL3j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 07:29:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 1/4] omap3isp: preview: Rename last occurences of *_rgb_to_ycbcr to *_csc
Date: Mon, 23 Apr 2012 13:29:52 +0200
Message-Id: <1335180595-27931-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1335180595-27931-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1335180595-27931-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For consistency reasons, rename the last remaining occurences of
rgb_to_ycbcr to csc (color space conversion).

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/isppreview.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index 5bdf9e7..f839cf8 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -608,12 +608,12 @@ preview_config_rgb_blending(struct isp_prev_device *prev, const void *rgb2rgb)
 }
 
 /*
- * Configures the RGB-YCbYCr conversion matrix
+ * Configures the color space conversion (RGB toYCbYCr) matrix
  * @prev_csc: Structure containing the RGB to YCbYCr matrix and the
  *            YCbCr offset.
  */
 static void
-preview_config_rgb_to_ycbcr(struct isp_prev_device *prev, const void *prev_csc)
+preview_config_csc(struct isp_prev_device *prev, const void *prev_csc)
 {
 	struct isp_device *isp = to_isp_device(prev);
 	const struct omap3isp_prev_csc *csc = prev_csc;
@@ -860,7 +860,7 @@ static const struct preview_update update_attrs[] = {
 		FIELD_SIZEOF(struct prev_params, rgb2rgb),
 		offsetof(struct omap3isp_prev_update_config, rgb2rgb),
 	}, /* OMAP3ISP_PREV_COLOR_CONV */ {
-		preview_config_rgb_to_ycbcr,
+		preview_config_csc,
 		NULL,
 		offsetof(struct prev_params, csc),
 		FIELD_SIZEOF(struct prev_params, csc),
-- 
1.7.3.4

