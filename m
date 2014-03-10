Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48726 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbaCJXOn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 19:14:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH v2 21/48] s5p-tv: hdmi: Remove deprecated video-level DV timings operations
Date: Tue, 11 Mar 2014 00:15:32 +0100
Message-Id: <1394493359-14115-22-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video enum_dv_timings and dv_timings_cap operations are deprecated
and unused. Remove them.

Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/s5p-tv/hdmi_drv.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index 3db496c..754740f 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -693,7 +693,7 @@ static int hdmi_dv_timings_cap(struct v4l2_subdev *sd,
 		return -EINVAL;
 
 	/* Let the phy fill in the pixelclock range */
-	v4l2_subdev_call(hdev->phy_sd, video, dv_timings_cap, cap);
+	v4l2_subdev_call(hdev->phy_sd, pad, dv_timings_cap, cap);
 	cap->type = V4L2_DV_BT_656_1120;
 	cap->bt.min_width = 720;
 	cap->bt.max_width = 1920;
@@ -712,8 +712,6 @@ static const struct v4l2_subdev_core_ops hdmi_sd_core_ops = {
 static const struct v4l2_subdev_video_ops hdmi_sd_video_ops = {
 	.s_dv_timings = hdmi_s_dv_timings,
 	.g_dv_timings = hdmi_g_dv_timings,
-	.enum_dv_timings = hdmi_enum_dv_timings,
-	.dv_timings_cap = hdmi_dv_timings_cap,
 	.g_mbus_fmt = hdmi_g_mbus_fmt,
 	.s_stream = hdmi_s_stream,
 };
-- 
1.8.3.2

