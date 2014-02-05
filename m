Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59504 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbaBEQlv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 11:41:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 11/47] s5p-tv: hdmiphy: Add pad-level DV timings operations
Date: Wed,  5 Feb 2014 17:42:02 +0100
Message-Id: <1391618558-5580-12-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video enum_dv_timings operation is deprecated. Implement the
pad-level version of the operation to prepare for the removal of the
video version.

Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/s5p-tv/hdmiphy_drv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/s5p-tv/hdmiphy_drv.c b/drivers/media/platform/s5p-tv/hdmiphy_drv.c
index e19a0af..ff22320 100644
--- a/drivers/media/platform/s5p-tv/hdmiphy_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmiphy_drv.c
@@ -225,6 +225,9 @@ static int hdmiphy_s_dv_timings(struct v4l2_subdev *sd,
 static int hdmiphy_dv_timings_cap(struct v4l2_subdev *sd,
 	struct v4l2_dv_timings_cap *cap)
 {
+	if (cap->pad != 0)
+		return -EINVAL;
+
 	cap->type = V4L2_DV_BT_656_1120;
 	/* The phy only determines the pixelclock, leave the other values
 	 * at 0 to signify that we have no information for them. */
@@ -263,9 +266,14 @@ static const struct v4l2_subdev_video_ops hdmiphy_video_ops = {
 	.s_stream =  hdmiphy_s_stream,
 };
 
+static const struct v4l2_subdev_pad_ops hdmiphy_pad_ops = {
+	.dv_timings_cap = hdmiphy_dv_timings_cap,
+};
+
 static const struct v4l2_subdev_ops hdmiphy_ops = {
 	.core = &hdmiphy_core_ops,
 	.video = &hdmiphy_video_ops,
+	.pad = &hdmiphy_pad_ops,
 };
 
 static int hdmiphy_probe(struct i2c_client *client,
-- 
1.8.3.2

