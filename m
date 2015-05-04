Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-3.cisco.com ([72.163.197.27]:55664 "EHLO
	bgl-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbbEDLSB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 07:18:01 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [PATCH 1/2] v4l2-ctl-modes: fix hblank, hsync rounding in gtf calculation
Date: Mon,  4 May 2015 16:18:58 +0530
Message-Id: <1430736539-28469-2-git-send-email-prladdha@cisco.com>
In-Reply-To: <1430736539-28469-1-git-send-email-prladdha@cisco.com>
References: <1430736539-28469-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In gtf modeline calculations, currently hblank and hsync are rounded
down. hblank needs to be rounded to nearest multiple of twice the
cell granularity. hsync needs to be rounded to nearest multiple of
cell granularity. Changed the rounding calculation to match it with
the equations in standards.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 utils/v4l2-ctl/v4l2-ctl-modes.cpp | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-modes.cpp b/utils/v4l2-ctl/v4l2-ctl-modes.cpp
index c775bda..4689006 100644
--- a/utils/v4l2-ctl/v4l2-ctl-modes.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-modes.cpp
@@ -457,12 +457,13 @@ bool calc_gtf_modeline(int image_width, int image_height,
 
 	h_blank = active_h_pixel * ideal_blank_duty_cycle /
 			 (100 * HV_FACTOR - ideal_blank_duty_cycle);
-	h_blank -= h_blank % (2 * GTF_CELL_GRAN);
+	h_blank = ((h_blank + GTF_CELL_GRAN) / (2 * GTF_CELL_GRAN))
+			  * (2 * GTF_CELL_GRAN);
 
 	total_h_pixel = active_h_pixel + h_blank;
 
-	h_sync  = (total_h_pixel * GTF_HSYNC_PERCENT) / 100;
-	h_sync -= h_sync % GTF_CELL_GRAN;
+	h_sync = (total_h_pixel * GTF_HSYNC_PERCENT) / 100;
+	h_sync = ((h_sync + GTF_CELL_GRAN / 2) / GTF_CELL_GRAN) * GTF_CELL_GRAN;
 
 	h_fp = h_blank / 2 - h_sync;
 	h_bp = h_fp + h_sync;
@@ -509,6 +510,5 @@ bool calc_gtf_modeline(int image_width, int image_height,
 		gtf->flags |= V4L2_DV_FL_REDUCED_BLANKING;
 	} else
 		gtf->polarities = V4L2_DV_VSYNC_POS_POL;
-
 	return true;
 }
-- 
1.9.1

