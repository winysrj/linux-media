Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-3.cisco.com ([72.163.197.27]:47578 "EHLO
	bgl-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbbFXJVV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 05:21:21 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [PATCH] v4l2-utils: use boolean for interlaced flag
Date: Wed, 24 Jun 2015 14:51:19 +0530
Message-Id: <1435137679-10874-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This change does not affect functionality. A minor change so that
the options that flags are captured as booleans and look consistent
with other flags.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 utils/v4l2-ctl/v4l2-ctl-stds.cpp | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-stds.cpp b/utils/v4l2-ctl/v4l2-ctl-stds.cpp
index 3987ba1..26cb08b 100644
--- a/utils/v4l2-ctl/v4l2-ctl-stds.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-stds.cpp
@@ -214,7 +214,7 @@ static void get_cvt_gtf_timings(char *subopt, int standard,
 	int height = 0;
 	int fps = 0;
 	int r_blank = 0;
-	int interlaced = 0;
+	bool interlaced = false;
 	bool reduced_fps = false;
 	bool timings_valid = false;
 
@@ -239,7 +239,7 @@ static void get_cvt_gtf_timings(char *subopt, int standard,
 			r_blank = opt_val;
 			break;
 		case INTERLACED:
-			interlaced = opt_val;
+			interlaced = (opt_val == 1) ? true : false;
 			break;
 		case REDUCED_FPS:
 			reduced_fps = (opt_val == 1) ? true : false;
@@ -249,13 +249,12 @@ static void get_cvt_gtf_timings(char *subopt, int standard,
 		}
 	}
 
-	if (standard == V4L2_DV_BT_STD_CVT) {
+	if (standard == V4L2_DV_BT_STD_CVT)
 		timings_valid = calc_cvt_modeline(width, height, fps, r_blank,
-						  interlaced == 1 ? true : false, reduced_fps, bt);
-	} else {
+						  interlaced, reduced_fps, bt);
+	else
 		timings_valid = calc_gtf_modeline(width, height, fps, r_blank,
-						  interlaced == 1 ? true : false, bt);
-	}
+						  interlaced, bt);
 
 	if (!timings_valid) {
 		stds_usage();
-- 
1.9.1

