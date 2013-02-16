Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3000 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab3BPJ25 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 04:28:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 09/18] s5p-tv: add dv_timings support for hdmi.
Date: Sat, 16 Feb 2013 10:28:12 +0100
Message-Id: <92ae3c7595637957ef1894921b9a451ffd458d16.1361006882.git.hans.verkuil@cisco.com>
In-Reply-To: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl>
References: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a9599acc7829c431d88b547de87c500968ccb86a.1361006882.git.hans.verkuil@cisco.com>
References: <a9599acc7829c431d88b547de87c500968ccb86a.1361006882.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This just adds dv_timings support without modifying existing dv_preset
support.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-tv/hdmi_drv.c |   92 +++++++++++++++++++++++++-----
 1 file changed, 79 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index 8de1b3d..716d0e4 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -31,6 +31,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/clk.h>
 #include <linux/regulator/consumer.h>
+#include <linux/v4l2-dv-timings.h>
 
 #include <media/s5p_hdmi.h>
 #include <media/v4l2-common.h>
@@ -93,6 +94,8 @@ struct hdmi_device {
 	int cur_conf_dirty;
 	/** current preset */
 	u32 cur_preset;
+	/** current timings */
+	struct v4l2_dv_timings cur_timings;
 	/** other resources */
 	struct hdmi_resources res;
 };
@@ -477,19 +480,21 @@ static const struct hdmi_timings hdmi_timings_1080p50 = {
 
 static const struct {
 	u32 preset;
-	const struct hdmi_timings *timings;
+	bool reduced_fps;
+	const struct v4l2_dv_timings dv_timings;
+	const struct hdmi_timings *hdmi_timings;
 } hdmi_timings[] = {
-	{ V4L2_DV_480P59_94, &hdmi_timings_480p },
-	{ V4L2_DV_576P50, &hdmi_timings_576p50 },
-	{ V4L2_DV_720P50, &hdmi_timings_720p50 },
-	{ V4L2_DV_720P59_94, &hdmi_timings_720p60 },
-	{ V4L2_DV_720P60, &hdmi_timings_720p60 },
-	{ V4L2_DV_1080P24, &hdmi_timings_1080p24 },
-	{ V4L2_DV_1080P30, &hdmi_timings_1080p60 },
-	{ V4L2_DV_1080P50, &hdmi_timings_1080p50 },
-	{ V4L2_DV_1080I50, &hdmi_timings_1080i50 },
-	{ V4L2_DV_1080I60, &hdmi_timings_1080i60 },
-	{ V4L2_DV_1080P60, &hdmi_timings_1080p60 },
+	{ V4L2_DV_480P59_94, false, V4L2_DV_BT_CEA_720X480P59_94, &hdmi_timings_480p },
+	{ V4L2_DV_576P50, false, V4L2_DV_BT_CEA_720X576P50, &hdmi_timings_576p50 },
+	{ V4L2_DV_720P50, false, V4L2_DV_BT_CEA_1280X720P50, &hdmi_timings_720p50 },
+	{ V4L2_DV_720P59_94, true, V4L2_DV_BT_CEA_1280X720P60, &hdmi_timings_720p60 },
+	{ V4L2_DV_720P60, false, V4L2_DV_BT_CEA_1280X720P60, &hdmi_timings_720p60 },
+	{ V4L2_DV_1080P24, false, V4L2_DV_BT_CEA_1920X1080P24, &hdmi_timings_1080p24 },
+	{ V4L2_DV_1080P30, false, V4L2_DV_BT_CEA_1920X1080P30, &hdmi_timings_1080p60 },
+	{ V4L2_DV_1080P50, false, V4L2_DV_BT_CEA_1920X1080P50, &hdmi_timings_1080p50 },
+	{ V4L2_DV_1080I50, false, V4L2_DV_BT_CEA_1920X1080I50, &hdmi_timings_1080i50 },
+	{ V4L2_DV_1080I60, false, V4L2_DV_BT_CEA_1920X1080I60, &hdmi_timings_1080i60 },
+	{ V4L2_DV_1080P60, false, V4L2_DV_BT_CEA_1920X1080P60, &hdmi_timings_1080p60 },
 };
 
 static const struct hdmi_timings *hdmi_preset2timings(u32 preset)
@@ -498,7 +503,7 @@ static const struct hdmi_timings *hdmi_preset2timings(u32 preset)
 
 	for (i = 0; i < ARRAY_SIZE(hdmi_timings); ++i)
 		if (hdmi_timings[i].preset == preset)
-			return  hdmi_timings[i].timings;
+			return  hdmi_timings[i].hdmi_timings;
 	return NULL;
 }
 
@@ -647,6 +652,36 @@ static int hdmi_g_dv_preset(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int hdmi_s_dv_timings(struct v4l2_subdev *sd,
+	struct v4l2_dv_timings *timings)
+{
+	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
+	struct device *dev = hdev->dev;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(hdmi_timings); i++)
+		if (v4l_match_dv_timings(&hdmi_timings[i].dv_timings,
+					timings, 0))
+			break;
+	if (i == ARRAY_SIZE(hdmi_timings)) {
+		dev_err(dev, "timings not supported\n");
+		return -EINVAL;
+	}
+	hdev->cur_conf = hdmi_timings[i].hdmi_timings;
+	hdev->cur_conf_dirty = 1;
+	hdev->cur_timings = *timings;
+	if (!hdmi_timings[i].reduced_fps)
+		hdev->cur_timings.bt.flags &= ~V4L2_DV_FL_CAN_REDUCE_FPS;
+	return 0;
+}
+
+static int hdmi_g_dv_timings(struct v4l2_subdev *sd,
+	struct v4l2_dv_timings *timings)
+{
+	*timings = sd_to_hdmi_dev(sd)->cur_timings;
+	return 0;
+}
+
 static int hdmi_g_mbus_fmt(struct v4l2_subdev *sd,
 	  struct v4l2_mbus_framefmt *fmt)
 {
@@ -679,6 +714,33 @@ static int hdmi_enum_dv_presets(struct v4l2_subdev *sd,
 		preset);
 }
 
+static int hdmi_enum_dv_timings(struct v4l2_subdev *sd,
+	struct v4l2_enum_dv_timings *timings)
+{
+	if (timings->index >= ARRAY_SIZE(hdmi_timings))
+		return -EINVAL;
+	timings->timings = hdmi_timings[timings->index].dv_timings;
+	if (!hdmi_timings[timings->index].reduced_fps)
+		timings->timings.bt.flags &= ~V4L2_DV_FL_CAN_REDUCE_FPS;
+	return 0;
+}
+
+static int hdmi_dv_timings_cap(struct v4l2_subdev *sd,
+	struct v4l2_dv_timings_cap *cap)
+{
+	cap->type = V4L2_DV_BT_656_1120;
+	cap->bt.min_width = 640;
+	cap->bt.max_width = 1920;
+	cap->bt.min_height = 480;
+	cap->bt.max_height = 1080;
+	cap->bt.min_pixelclock = 27000000;
+	cap->bt.max_pixelclock = 148500000;
+	cap->bt.standards = V4L2_DV_BT_STD_CEA861;
+	cap->bt.capabilities = V4L2_DV_BT_CAP_INTERLACED |
+			       V4L2_DV_BT_CAP_PROGRESSIVE;
+	return 0;
+}
+
 static const struct v4l2_subdev_core_ops hdmi_sd_core_ops = {
 	.s_power = hdmi_s_power,
 };
@@ -687,6 +749,10 @@ static const struct v4l2_subdev_video_ops hdmi_sd_video_ops = {
 	.s_dv_preset = hdmi_s_dv_preset,
 	.g_dv_preset = hdmi_g_dv_preset,
 	.enum_dv_presets = hdmi_enum_dv_presets,
+	.s_dv_timings = hdmi_s_dv_timings,
+	.g_dv_timings = hdmi_g_dv_timings,
+	.enum_dv_timings = hdmi_enum_dv_timings,
+	.dv_timings_cap = hdmi_dv_timings_cap,
 	.g_mbus_fmt = hdmi_g_mbus_fmt,
 	.s_stream = hdmi_s_stream,
 };
-- 
1.7.10.4

