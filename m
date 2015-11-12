Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:54170 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbbKLMou (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2015 07:44:50 -0500
From: matrandg@cisco.com
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>
Subject: [PATCH] v4l2-dv-timings: Compare horizontal blanking
Date: Thu, 12 Nov 2015 13:34:55 +0100
Message-Id: <1447331695-22322-1-git-send-email-matrandg@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

hsync and hbackporch must also be compared

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 6a83d61..edb4125 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -239,6 +239,8 @@ bool v4l2_match_dv_timings(const struct v4l2_dv_timings *t1,
 	    t1->bt.pixelclock >= t2->bt.pixelclock - pclock_delta &&
 	    t1->bt.pixelclock <= t2->bt.pixelclock + pclock_delta &&
 	    t1->bt.hfrontporch == t2->bt.hfrontporch &&
+	    t1->bt.hsync == t2->bt.hsync &&
+	    t1->bt.hbackporch == t2->bt.hbackporch &&
 	    t1->bt.vfrontporch == t2->bt.vfrontporch &&
 	    t1->bt.vsync == t2->bt.vsync &&
 	    t1->bt.vbackporch == t2->bt.vbackporch &&
-- 
2.5.0

