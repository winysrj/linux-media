Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43020 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab1DEH5M (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 03:57:12 -0400
Received: from localhost.localdomain (unknown [91.178.236.143])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5E53635B69
	for <linux-media@vger.kernel.org>; Tue,  5 Apr 2011 07:57:10 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 02/14] omap3isp: resizer: Center the crop rectangle
Date: Tue,  5 Apr 2011 09:57:24 +0200
Message-Id: <1301990256-6963-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1301990256-6963-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1301990256-6963-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

When the crop rectangle needs to be modified to match hardware
requirements, center the resulting rectangle on the requested rectangle
instead of removing pixels from the right and bottom sides only.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/ispresizer.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispresizer.c b/drivers/media/video/omap3isp/ispresizer.c
index 75d39b1..829d7bf 100644
--- a/drivers/media/video/omap3isp/ispresizer.c
+++ b/drivers/media/video/omap3isp/ispresizer.c
@@ -775,6 +775,8 @@ static void resizer_calc_ratios(struct isp_res_device *res,
 	unsigned int max_width;
 	unsigned int max_height;
 	unsigned int width_alignment;
+	unsigned int width;
+	unsigned int height;
 
 	/*
 	 * Clamp the output height based on the hardware capabilities and
@@ -794,11 +796,11 @@ static void resizer_calc_ratios(struct isp_res_device *res,
 	if (ratio->vert <= MID_RESIZE_VALUE) {
 		upscaled_height = (output->height - 1) * ratio->vert
 				+ 32 * spv + 16;
-		input->height = (upscaled_height >> 8) + 4;
+		height = (upscaled_height >> 8) + 4;
 	} else {
 		upscaled_height = (output->height - 1) * ratio->vert
 				+ 64 * spv + 32;
-		input->height = (upscaled_height >> 8) + 7;
+		height = (upscaled_height >> 8) + 7;
 	}
 
 	/*
@@ -862,12 +864,18 @@ static void resizer_calc_ratios(struct isp_res_device *res,
 	if (ratio->horz <= MID_RESIZE_VALUE) {
 		upscaled_width = (output->width - 1) * ratio->horz
 			       + 32 * sph + 16;
-		input->width = (upscaled_width >> 8) + 7;
+		width = (upscaled_width >> 8) + 7;
 	} else {
 		upscaled_width = (output->width - 1) * ratio->horz
 			       + 64 * sph + 32;
-		input->width = (upscaled_width >> 8) + 7;
+		width = (upscaled_width >> 8) + 7;
 	}
+
+	/* Center the new crop rectangle. */
+	input->left += (input->width - width) / 2;
+	input->top += (input->height - height) / 2;
+	input->width = width;
+	input->height = height;
 }
 
 /*
-- 
1.7.3.4

