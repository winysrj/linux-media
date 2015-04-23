Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-3.cisco.com ([72.163.197.27]:7200 "EHLO
	bgl-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbbD2RHS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 13:07:18 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Martin Bugge <marbugge@cisco.com>,
	Mats Randgaard <matrandg@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [RFC PATCH 4/4] adv7842: Use interlaced info for cvt/gtf timing detection
Date: Thu, 23 Apr 2015 14:29:51 +0530
Message-Id: <1429779591-26134-5-git-send-email-prladdha@cisco.com>
In-Reply-To: <1429779591-26134-1-git-send-email-prladdha@cisco.com>
References: <1429779591-26134-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The interlaced information from stdi is passed to detect_cvt/gtf().

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Martin Bugge <marbugge@cisco.com>
Cc: Mats Randgaard <matrandg@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 drivers/media/i2c/adv7842.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 90cbead..698fe38 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -1333,12 +1333,12 @@ static int stdi2dv_timings(struct v4l2_subdev *sd,
 	if (v4l2_detect_cvt(stdi->lcf + 1, hfreq, stdi->lcvs,
 			(stdi->hs_pol == '+' ? V4L2_DV_HSYNC_POS_POL : 0) |
 			(stdi->vs_pol == '+' ? V4L2_DV_VSYNC_POS_POL : 0),
-			false, timings))
+			stdi->interlaced, timings))
 		return 0;
 	if (v4l2_detect_gtf(stdi->lcf + 1, hfreq, stdi->lcvs,
 			(stdi->hs_pol == '+' ? V4L2_DV_HSYNC_POS_POL : 0) |
 			(stdi->vs_pol == '+' ? V4L2_DV_VSYNC_POS_POL : 0),
-			false, state->aspect_ratio, timings))
+			stdi->interlaced, state->aspect_ratio, timings))
 		return 0;
 
 	v4l2_dbg(2, debug, sd,
-- 
1.9.1

