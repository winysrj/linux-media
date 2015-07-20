Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-2.cisco.com ([72.163.197.26]:17434 "EHLO
	bgl-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262AbbGTJAB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 05:00:01 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [PATCH] v4l2-ctl-modes: use reduced fps only with reduced blanking v2
Date: Mon, 20 Jul 2015 14:29:58 +0530
Message-Id: <1437382798-16061-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the absence of reduced blanking v2, the clock granularity is not
sufficient enough to allow pixel clock reduction done by factor of
1000 / 1001 in case of reduced fps.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 utils/v4l2-ctl/v4l2-ctl-modes.cpp | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-modes.cpp b/utils/v4l2-ctl/v4l2-ctl-modes.cpp
index e44b229..236f19f 100644
--- a/utils/v4l2-ctl/v4l2-ctl-modes.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-modes.cpp
@@ -336,7 +336,7 @@ bool calc_cvt_modeline(int image_width, int image_height,
 	} else {
 		cvt->polarities = V4L2_DV_VSYNC_POS_POL;
 	}
-	if (reduced_fps && v_refresh % 6 == 0)
+	if (rb_v2 && reduced_fps && v_refresh % 6 == 0)
 		cvt->flags |= V4L2_DV_FL_REDUCED_FPS;
 
 	return true;
-- 
1.9.1

