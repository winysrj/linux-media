Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49119 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758011AbaGWO5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 10:57:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 2/3] omap3isp: resizer: Remove slow debugging message from interrupt handler
Date: Wed, 23 Jul 2014 16:57:10 +0200
Message-Id: <1406127431-9503-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1406127431-9503-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1406127431-9503-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The resizer_set_input_size() function prints a debugging message with
the input width and height values. As the function is called from
interrupt context, printing that message to the serial console could
slow down the interrupt handler and cause it to miss the start of the
next frame, causing image corruption.

Fix this by reorganizing the resizer debug messages. The driver now
prints the input size, the crop rectangle and the output size in the set
selection handler instead of scattering debug messages in various
places.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispresizer.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispresizer.c b/drivers/media/platform/omap3isp/ispresizer.c
index 8515793..c8676e1 100644
--- a/drivers/media/platform/omap3isp/ispresizer.c
+++ b/drivers/media/platform/omap3isp/ispresizer.c
@@ -367,7 +367,6 @@ static void resizer_set_output_size(struct isp_res_device *res,
 	struct isp_device *isp = to_isp_device(res);
 	u32 rgval;
 
-	dev_dbg(isp->dev, "Output size[w/h]: %dx%d\n", width, height);
 	rgval  = (width << ISPRSZ_OUT_SIZE_HORZ_SHIFT)
 		 & ISPRSZ_OUT_SIZE_HORZ_MASK;
 	rgval |= (height << ISPRSZ_OUT_SIZE_VERT_SHIFT)
@@ -431,8 +430,6 @@ static void resizer_set_input_size(struct isp_res_device *res,
 	struct isp_device *isp = to_isp_device(res);
 	u32 rgval;
 
-	dev_dbg(isp->dev, "Input size[w/h]: %dx%d\n", width, height);
-
 	rgval = (width << ISPRSZ_IN_SIZE_HORZ_SHIFT)
 		& ISPRSZ_IN_SIZE_HORZ_MASK;
 	rgval |= (height << ISPRSZ_IN_SIZE_VERT_SHIFT)
@@ -1302,12 +1299,10 @@ static int resizer_set_selection(struct v4l2_subdev *sd,
 	format_source = __resizer_get_format(res, fh, RESZ_PAD_SOURCE,
 					     sel->which);
 
-	dev_dbg(isp->dev, "%s: L=%d,T=%d,W=%d,H=%d,which=%d\n", __func__,
-		sel->r.left, sel->r.top, sel->r.width, sel->r.height,
-		sel->which);
-
-	dev_dbg(isp->dev, "%s: input=%dx%d, output=%dx%d\n", __func__,
+	dev_dbg(isp->dev, "%s(%s): req %ux%u -> (%d,%d)/%ux%u -> %ux%u\n",
+		__func__, sel->which == V4L2_SUBDEV_FORMAT_TRY ? "try" : "act",
 		format_sink->width, format_sink->height,
+		sel->r.left, sel->r.top, sel->r.width, sel->r.height,
 		format_source->width, format_source->height);
 
 	/* Clamp the crop rectangle to the bounds, and then mangle it further to
@@ -1322,6 +1317,12 @@ static int resizer_set_selection(struct v4l2_subdev *sd,
 	*__resizer_get_crop(res, fh, sel->which) = sel->r;
 	resizer_calc_ratios(res, &sel->r, format_source, &ratio);
 
+	dev_dbg(isp->dev, "%s(%s): got %ux%u -> (%d,%d)/%ux%u -> %ux%u\n",
+		__func__, sel->which == V4L2_SUBDEV_FORMAT_TRY ? "try" : "act",
+		format_sink->width, format_sink->height,
+		sel->r.left, sel->r.top, sel->r.width, sel->r.height,
+		format_source->width, format_source->height);
+
 	if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
 		return 0;
 
-- 
1.8.5.5

