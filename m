Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-1.cisco.com ([72.163.197.25]:34056 "EHLO
	bgl-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396AbbIVO1e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 10:27:34 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [RFC v2 2/4] vivid: add support for reduced fps in video out
Date: Tue, 22 Sep 2015 19:57:29 +0530
Message-Id: <1442932051-24972-3-git-send-email-prladdha@cisco.com>
In-Reply-To: <1442932051-24972-1-git-send-email-prladdha@cisco.com>
References: <1442932051-24972-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If reduced fps flag is set then check if other necessary conditions
are true for the given bt timing. If yes, then reduce the frame rate.
For vivid transmitter, timeperframe_vid_out controls the frame rate.
Adjusting the timeperframe_vid_out by scaling down pixel clock by
factor of 1000 / 1001.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 drivers/media/platform/vivid/vivid-vid-out.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index c404e27..e860347 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -220,6 +220,7 @@ void vivid_update_format_out(struct vivid_dev *dev)
 {
 	struct v4l2_bt_timings *bt = &dev->dv_timings_out.bt;
 	unsigned size, p;
+	u64 pixelclock;
 
 	switch (dev->output_type[dev->output]) {
 	case SVID:
@@ -241,8 +242,14 @@ void vivid_update_format_out(struct vivid_dev *dev)
 		dev->sink_rect.width = bt->width;
 		dev->sink_rect.height = bt->height;
 		size = V4L2_DV_BT_FRAME_WIDTH(bt) * V4L2_DV_BT_FRAME_HEIGHT(bt);
+
+		if (can_reduce_fps(bt) && (bt->flags & V4L2_DV_FL_REDUCED_FPS))
+			pixelclock = div_u64(bt->pixelclock * 1000, 1001);
+		else
+			pixelclock = bt->pixelclock;
+
 		dev->timeperframe_vid_out = (struct v4l2_fract) {
-			size / 100, (u32)bt->pixelclock / 100
+			size / 100, (u32)pixelclock / 100
 		};
 		if (bt->interlaced)
 			dev->field_out = V4L2_FIELD_ALTERNATE;
-- 
1.9.1

