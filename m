Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43020 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab1DEH5N (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 03:57:13 -0400
Received: from localhost.localdomain (unknown [91.178.236.143])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id C3C4E35B6B
	for <linux-media@vger.kernel.org>; Tue,  5 Apr 2011 07:57:10 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 04/14] omap3isp: resizer: Improved resizer rsz factor formula
Date: Tue,  5 Apr 2011 09:57:26 +0200
Message-Id: <1301990256-6963-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1301990256-6963-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1301990256-6963-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>

Round properly the rsz factor so that we get highest rsz so that the input
width (or height) is highest possible smaller or equal to what the user
asks.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/ispresizer.c |   40 +++++++++++++++++++++-------
 1 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispresizer.c b/drivers/media/video/omap3isp/ispresizer.c
index 40b2db8..70897ce 100644
--- a/drivers/media/video/omap3isp/ispresizer.c
+++ b/drivers/media/video/omap3isp/ispresizer.c
@@ -714,16 +714,36 @@ static void resizer_print_status(struct isp_res_device *res)
  * iw and ih are the input width and height after cropping. Those equations need
  * to be satisfied exactly for the resizer to work correctly.
  *
- * Reverting the equations, we can compute the resizing ratios with
+ * The equations can't be easily reverted, as the >> 8 operation is not linear.
+ * In addition, not all input sizes can be achieved for a given output size. To
+ * get the highest input size lower than or equal to the requested input size,
+ * we need to compute the highest resizing ratio that satisfies the following
+ * inequality (taking the 4-tap mode width equation as an example)
+ *
+ *	iw >= (32 * sph + (ow - 1) * hrsz + 16) >> 8 - 7
+ *
+ * (where iw is the requested input width) which can be rewritten as
+ *
+ *	  iw - 7            >= (32 * sph + (ow - 1) * hrsz + 16) >> 8
+ *	 (iw - 7) << 8      >=  32 * sph + (ow - 1) * hrsz + 16 - b
+ *	((iw - 7) << 8) + b >=  32 * sph + (ow - 1) * hrsz + 16
+ *
+ * where b is the value of the 8 least significant bits of the right hand side
+ * expression of the last inequality. The highest resizing ratio value will be
+ * achieved when b is equal to its maximum value of 255. That resizing ratio
+ * value will still satisfy the original inequality, as b will disappear when
+ * the expression will be shifted right by 8.
+ *
+ * The reverted the equations thus become
  *
  * - 8-phase, 4-tap mode
- *	hrsz = ((iw - 7) * 256 - 16 - 32 * sph) / (ow - 1)
- *	vrsz = ((ih - 4) * 256 - 16 - 32 * spv) / (oh - 1)
+ *	hrsz = ((iw - 7) * 256 + 255 - 16 - 32 * sph) / (ow - 1)
+ *	vrsz = ((ih - 4) * 256 + 255 - 16 - 32 * spv) / (oh - 1)
  * - 4-phase, 7-tap mode
- *	hrsz = ((iw - 7) * 256 - 32 - 64 * sph) / (ow - 1)
- *	vrsz = ((ih - 7) * 256 - 32 - 64 * spv) / (oh - 1)
+ *	hrsz = ((iw - 7) * 256 + 255 - 32 - 64 * sph) / (ow - 1)
+ *	vrsz = ((ih - 7) * 256 + 255 - 32 - 64 * spv) / (oh - 1)
  *
- * The ratios are integer values, and must be rounded down to ensure that the
+ * The ratios are integer values, and are rounded down to ensure that the
  * cropped input size is not bigger than the uncropped input size.
  *
  * As the number of phases/taps, used to select the correct equations to compute
@@ -799,10 +819,10 @@ static void resizer_calc_ratios(struct isp_res_device *res,
 	max_height = min_t(unsigned int, max_height, MAX_OUT_HEIGHT);
 	output->height = clamp(output->height, min_height, max_height);
 
-	ratio->vert = ((input->height - 4) * 256 - 16 - 32 * spv)
+	ratio->vert = ((input->height - 4) * 256 + 255 - 16 - 32 * spv)
 		    / (output->height - 1);
 	if (ratio->vert > MID_RESIZE_VALUE)
-		ratio->vert = ((input->height - 7) * 256 - 32 - 64 * spv)
+		ratio->vert = ((input->height - 7) * 256 + 255 - 32 - 64 * spv)
 			    / (output->height - 1);
 	ratio->vert = clamp_t(unsigned int, ratio->vert,
 			      MIN_RESIZE_VALUE, MAX_RESIZE_VALUE);
@@ -870,10 +890,10 @@ static void resizer_calc_ratios(struct isp_res_device *res,
 			      max_width & ~(width_alignment - 1));
 	output->width = ALIGN(output->width, width_alignment);
 
-	ratio->horz = ((input->width - 7) * 256 - 16 - 32 * sph)
+	ratio->horz = ((input->width - 7) * 256 + 255 - 16 - 32 * sph)
 		    / (output->width - 1);
 	if (ratio->horz > MID_RESIZE_VALUE)
-		ratio->horz = ((input->width - 7) * 256 - 32 - 64 * sph)
+		ratio->horz = ((input->width - 7) * 256 + 255 - 32 - 64 * sph)
 			    / (output->width - 1);
 	ratio->horz = clamp_t(unsigned int, ratio->horz,
 			      MIN_RESIZE_VALUE, MAX_RESIZE_VALUE);
-- 
1.7.3.4

