Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-3.cisco.com ([72.163.197.27]:12276 "EHLO
	bgl-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbbEVF1h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2015 01:27:37 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [RFC PATCH v2 2/4] vivid: Use interlaced info for cvt/gtf timing detection
Date: Fri, 22 May 2015 10:57:35 +0530
Message-Id: <1432272457-709-3-git-send-email-prladdha@cisco.com>
In-Reply-To: <1432272457-709-1-git-send-email-prladdha@cisco.com>
References: <1432272457-709-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The detect_cvt/gtf() now supports timing calculations for interlaced
format.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 drivers/media/platform/vivid/vivid-vid-cap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index a99362d..60298c7 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -1619,7 +1619,7 @@ static bool valid_cvt_gtf_timings(struct v4l2_dv_timings *timings)
 
 	if (bt->standards == 0 || (bt->standards & V4L2_DV_BT_STD_CVT)) {
 		if (v4l2_detect_cvt(total_v_lines, h_freq, bt->vsync,
-				    bt->polarities, false, timings))
+				    bt->polarities, bt->interlaced, timings))
 			return true;
 	}
 
@@ -1630,7 +1630,7 @@ static bool valid_cvt_gtf_timings(struct v4l2_dv_timings *timings)
 				  &aspect_ratio.numerator,
 				  &aspect_ratio.denominator);
 		if (v4l2_detect_gtf(total_v_lines, h_freq, bt->vsync,
-				    bt->polarities, false,
+				    bt->polarities, bt->interlaced,
 				    aspect_ratio, timings))
 			return true;
 	}
-- 
1.9.1

