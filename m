Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-3.cisco.com ([72.163.197.27]:38895 "EHLO
	bgl-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757574AbbIVO1g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 10:27:36 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [RFC v2 4/4] vivid: add support for reduced frame rate in video capture
Date: Tue, 22 Sep 2015 19:57:31 +0530
Message-Id: <1442932051-24972-5-git-send-email-prladdha@cisco.com>
In-Reply-To: <1442932051-24972-1-git-send-email-prladdha@cisco.com>
References: <1442932051-24972-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With this patch, vivid capture thread can now generate a video with
frame rate reduced by a factor of 1000 / 1001. This option can be
selected using a control Reduced Framerate from gui.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 drivers/media/platform/vivid/vivid-vid-cap.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index ed0b878..74ba98f 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -401,6 +401,7 @@ void vivid_update_format_cap(struct vivid_dev *dev, bool keep_controls)
 {
 	struct v4l2_bt_timings *bt = &dev->dv_timings_cap.bt;
 	unsigned size;
+	u64 pixelclock;
 
 	switch (dev->input_type[dev->input]) {
 	case WEBCAM:
@@ -430,8 +431,15 @@ void vivid_update_format_cap(struct vivid_dev *dev, bool keep_controls)
 		dev->src_rect.width = bt->width;
 		dev->src_rect.height = bt->height;
 		size = V4L2_DV_BT_FRAME_WIDTH(bt) * V4L2_DV_BT_FRAME_HEIGHT(bt);
+		if (dev->reduced_fps && can_reduce_fps(bt)) {
+			pixelclock = div_u64(bt->pixelclock * 1000, 1001);
+			bt->flags |= V4L2_DV_FL_REDUCED_FPS;
+		} else {
+			pixelclock = bt->pixelclock;
+			bt->flags &= ~V4L2_DV_FL_REDUCED_FPS;
+		}
 		dev->timeperframe_vid_cap = (struct v4l2_fract) {
-			size / 100, (u32)bt->pixelclock / 100
+			size / 100, (u32)pixelclock / 100
 		};
 		if (bt->interlaced)
 			dev->field_cap = V4L2_FIELD_ALTERNATE;
-- 
1.9.1

