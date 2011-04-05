Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43021 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab1DEH5N (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 03:57:13 -0400
Received: from localhost.localdomain (unknown [91.178.236.143])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 90B5935B6A
	for <linux-media@vger.kernel.org>; Tue,  5 Apr 2011 07:57:10 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 03/14] omap3isp: resizer: Use 4-tap mode equations when the ratio is <= 512
Date: Tue,  5 Apr 2011 09:57:25 +0200
Message-Id: <1301990256-6963-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1301990256-6963-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1301990256-6963-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

As the number of phases/taps, used to select the correct equations to
compute the ratio, depends on the ratio, start with the 7-tap mode
equations to compute an approximation of the ratio, and switch to the
4-tap mode equations if the approximation is lower than or equal to 512.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/ispresizer.c |   27 ++++++++++++++++++++++-----
 1 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispresizer.c b/drivers/media/video/omap3isp/ispresizer.c
index 829d7bf..40b2db8 100644
--- a/drivers/media/video/omap3isp/ispresizer.c
+++ b/drivers/media/video/omap3isp/ispresizer.c
@@ -724,9 +724,20 @@ static void resizer_print_status(struct isp_res_device *res)
  *	vrsz = ((ih - 7) * 256 - 32 - 64 * spv) / (oh - 1)
  *
  * The ratios are integer values, and must be rounded down to ensure that the
- * cropped input size is not bigger than the uncropped input size. As the ratio
- * in 7-tap mode is always smaller than the ratio in 4-tap mode, we can use the
- * 7-tap mode equations to compute a ratio approximation.
+ * cropped input size is not bigger than the uncropped input size.
+ *
+ * As the number of phases/taps, used to select the correct equations to compute
+ * the ratio, depends on the ratio, we start with the 4-tap mode equations to
+ * compute an approximation of the ratio, and switch to the 7-tap mode equations
+ * if the approximation is higher than the ratio threshold.
+ *
+ * As the 7-tap mode equations will return a ratio smaller than or equal to the
+ * 4-tap mode equations, the resulting ratio could become lower than or equal to
+ * the ratio threshold. This 'equations loop' isn't an issue as long as the
+ * correct equations are used to compute the final input size. Starting with the
+ * 4-tap mode equations ensure that, in case of values resulting in a 'ratio
+ * loop', the smallest of the ratio values will be used, never exceeding the
+ * requested input size.
  *
  * We first clamp the output size according to the hardware capabilitie to avoid
  * auto-cropping the input more than required to satisfy the TRM equations. The
@@ -788,8 +799,11 @@ static void resizer_calc_ratios(struct isp_res_device *res,
 	max_height = min_t(unsigned int, max_height, MAX_OUT_HEIGHT);
 	output->height = clamp(output->height, min_height, max_height);
 
-	ratio->vert = ((input->height - 7) * 256 - 32 - 64 * spv)
+	ratio->vert = ((input->height - 4) * 256 - 16 - 32 * spv)
 		    / (output->height - 1);
+	if (ratio->vert > MID_RESIZE_VALUE)
+		ratio->vert = ((input->height - 7) * 256 - 32 - 64 * spv)
+			    / (output->height - 1);
 	ratio->vert = clamp_t(unsigned int, ratio->vert,
 			      MIN_RESIZE_VALUE, MAX_RESIZE_VALUE);
 
@@ -856,8 +870,11 @@ static void resizer_calc_ratios(struct isp_res_device *res,
 			      max_width & ~(width_alignment - 1));
 	output->width = ALIGN(output->width, width_alignment);
 
-	ratio->horz = ((input->width - 7) * 256 - 32 - 64 * sph)
+	ratio->horz = ((input->width - 7) * 256 - 16 - 32 * sph)
 		    / (output->width - 1);
+	if (ratio->horz > MID_RESIZE_VALUE)
+		ratio->horz = ((input->width - 7) * 256 - 32 - 64 * sph)
+			    / (output->width - 1);
 	ratio->horz = clamp_t(unsigned int, ratio->horz,
 			      MIN_RESIZE_VALUE, MAX_RESIZE_VALUE);
 
-- 
1.7.3.4

