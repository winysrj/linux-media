Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48727 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbaCJXOj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 19:14:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH v2 10/48] s5p-tv: hdmi: Add pad-level DV timings operations
Date: Tue, 11 Mar 2014 00:15:21 +0100
Message-Id: <1394493359-14115-11-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video enum_dv_timings and dv_timings_cap operations are deprecated.
Implement the pad-level version of those operations to prepare for the
removal of the video version.

Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/s5p-tv/hdmi_drv.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index 534722c..3db496c 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -674,6 +674,8 @@ static int hdmi_g_mbus_fmt(struct v4l2_subdev *sd,
 static int hdmi_enum_dv_timings(struct v4l2_subdev *sd,
 	struct v4l2_enum_dv_timings *timings)
 {
+	if (timings->pad != 0)
+		return -EINVAL;
 	if (timings->index >= ARRAY_SIZE(hdmi_timings))
 		return -EINVAL;
 	timings->timings = hdmi_timings[timings->index].dv_timings;
@@ -687,6 +689,9 @@ static int hdmi_dv_timings_cap(struct v4l2_subdev *sd,
 {
 	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
 
+	if (cap->pad != 0)
+		return -EINVAL;
+
 	/* Let the phy fill in the pixelclock range */
 	v4l2_subdev_call(hdev->phy_sd, video, dv_timings_cap, cap);
 	cap->type = V4L2_DV_BT_656_1120;
@@ -713,6 +718,11 @@ static const struct v4l2_subdev_video_ops hdmi_sd_video_ops = {
 	.s_stream = hdmi_s_stream,
 };
 
+static const struct v4l2_subdev_pad_ops hdmi_sd_pad_ops = {
+	.enum_dv_timings = hdmi_enum_dv_timings,
+	.dv_timings_cap = hdmi_dv_timings_cap,
+};
+
 static const struct v4l2_subdev_ops hdmi_sd_ops = {
 	.core = &hdmi_sd_core_ops,
 	.video = &hdmi_sd_video_ops,
-- 
1.8.3.2

