Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2127 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758060Ab3CDNCf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 08:02:35 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 5/6] s5p-tv: remove the dv_preset API from hdmi.
Date: Mon,  4 Mar 2013 14:02:05 +0100
Message-Id: <3e77e42bf2a893a3c83c755a7ab1e7c585ea056f.1362401530.git.hans.verkuil@cisco.com>
In-Reply-To: <1362402126-13149-1-git-send-email-hverkuil@xs4all.nl>
References: <1362402126-13149-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <2b361dfb4359134806e6b6d741d9286968c49df6.1362401530.git.hans.verkuil@cisco.com>
References: <2b361dfb4359134806e6b6d741d9286968c49df6.1362401530.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The dv_preset API is deprecated and is replaced by the much improved dv_timings
API. Remove the dv_preset support from this driver as this will allow us to
remove the dv_preset API altogether (s5p-tv being the last user of this code).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-tv/hdmi_drv.c |   95 +++++++-----------------------
 1 file changed, 22 insertions(+), 73 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index 1376577..119603f 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -44,9 +44,6 @@ MODULE_AUTHOR("Tomasz Stanislawski, <t.stanislaws@samsung.com>");
 MODULE_DESCRIPTION("Samsung HDMI");
 MODULE_LICENSE("GPL");
 
-/* default preset configured on probe */
-#define HDMI_DEFAULT_PRESET V4L2_DV_480P59_94
-
 struct hdmi_pulse {
 	u32 beg;
 	u32 end;
@@ -92,8 +89,6 @@ struct hdmi_device {
 	const struct hdmi_timings *cur_conf;
 	/** flag indicating that timings are dirty */
 	int cur_conf_dirty;
-	/** current preset */
-	u32 cur_preset;
 	/** current timings */
 	struct v4l2_dv_timings cur_timings;
 	/** other resources */
@@ -255,7 +250,6 @@ static int hdmi_conf_apply(struct hdmi_device *hdmi_dev)
 {
 	struct device *dev = hdmi_dev->dev;
 	const struct hdmi_timings *conf = hdmi_dev->cur_conf;
-	struct v4l2_dv_preset preset;
 	int ret;
 
 	dev_dbg(dev, "%s\n", __func__);
@@ -270,11 +264,11 @@ static int hdmi_conf_apply(struct hdmi_device *hdmi_dev)
 	hdmi_write_mask(hdmi_dev, HDMI_PHY_RSTOUT,  0, HDMI_PHY_SW_RSTOUT);
 	mdelay(10);
 
-	/* configure presets */
-	preset.preset = hdmi_dev->cur_preset;
-	ret = v4l2_subdev_call(hdmi_dev->phy_sd, video, s_dv_preset, &preset);
+	/* configure timings */
+	ret = v4l2_subdev_call(hdmi_dev->phy_sd, video, s_dv_timings,
+				&hdmi_dev->cur_timings);
 	if (ret) {
-		dev_err(dev, "failed to set preset (%u)\n", preset.preset);
+		dev_err(dev, "failed to set timings\n");
 		return ret;
 	}
 
@@ -478,35 +472,26 @@ static const struct hdmi_timings hdmi_timings_1080p50 = {
 	.vsyn[0] = { .beg = 0 + 4, .end = 5 + 4},
 };
 
+/* default hdmi_timings index of the timings configured on probe */
+#define HDMI_DEFAULT_TIMINGS_IDX (0)
+
 static const struct {
-	u32 preset;
 	bool reduced_fps;
 	const struct v4l2_dv_timings dv_timings;
 	const struct hdmi_timings *hdmi_timings;
 } hdmi_timings[] = {
-	{ V4L2_DV_480P59_94, false, V4L2_DV_BT_CEA_720X480P59_94, &hdmi_timings_480p },
-	{ V4L2_DV_576P50, false, V4L2_DV_BT_CEA_720X576P50, &hdmi_timings_576p50 },
-	{ V4L2_DV_720P50, false, V4L2_DV_BT_CEA_1280X720P50, &hdmi_timings_720p50 },
-	{ V4L2_DV_720P59_94, true, V4L2_DV_BT_CEA_1280X720P60, &hdmi_timings_720p60 },
-	{ V4L2_DV_720P60, false, V4L2_DV_BT_CEA_1280X720P60, &hdmi_timings_720p60 },
-	{ V4L2_DV_1080P24, false, V4L2_DV_BT_CEA_1920X1080P24, &hdmi_timings_1080p24 },
-	{ V4L2_DV_1080P30, false, V4L2_DV_BT_CEA_1920X1080P30, &hdmi_timings_1080p60 },
-	{ V4L2_DV_1080P50, false, V4L2_DV_BT_CEA_1920X1080P50, &hdmi_timings_1080p50 },
-	{ V4L2_DV_1080I50, false, V4L2_DV_BT_CEA_1920X1080I50, &hdmi_timings_1080i50 },
-	{ V4L2_DV_1080I60, false, V4L2_DV_BT_CEA_1920X1080I60, &hdmi_timings_1080i60 },
-	{ V4L2_DV_1080P60, false, V4L2_DV_BT_CEA_1920X1080P60, &hdmi_timings_1080p60 },
+	{ false, V4L2_DV_BT_CEA_720X480P59_94, &hdmi_timings_480p    },
+	{ false, V4L2_DV_BT_CEA_720X576P50,    &hdmi_timings_576p50  },
+	{ false, V4L2_DV_BT_CEA_1280X720P50,   &hdmi_timings_720p50  },
+	{ true,  V4L2_DV_BT_CEA_1280X720P60,   &hdmi_timings_720p60  },
+	{ false, V4L2_DV_BT_CEA_1920X1080P24,  &hdmi_timings_1080p24 },
+	{ false, V4L2_DV_BT_CEA_1920X1080P30,  &hdmi_timings_1080p60 },
+	{ false, V4L2_DV_BT_CEA_1920X1080P50,  &hdmi_timings_1080p50 },
+	{ false, V4L2_DV_BT_CEA_1920X1080I50,  &hdmi_timings_1080i50 },
+	{ false, V4L2_DV_BT_CEA_1920X1080I60,  &hdmi_timings_1080i60 },
+	{ false, V4L2_DV_BT_CEA_1920X1080P60,  &hdmi_timings_1080p60 },
 };
 
-static const struct hdmi_timings *hdmi_preset2timings(u32 preset)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(hdmi_timings); ++i)
-		if (hdmi_timings[i].preset == preset)
-			return  hdmi_timings[i].hdmi_timings;
-	return NULL;
-}
-
 static int hdmi_streamon(struct hdmi_device *hdev)
 {
 	struct device *dev = hdev->dev;
@@ -626,32 +611,6 @@ static int hdmi_s_power(struct v4l2_subdev *sd, int on)
 	return IS_ERR_VALUE(ret) ? ret : 0;
 }
 
-static int hdmi_s_dv_preset(struct v4l2_subdev *sd,
-	struct v4l2_dv_preset *preset)
-{
-	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
-	struct device *dev = hdev->dev;
-	const struct hdmi_timings *conf;
-
-	conf = hdmi_preset2timings(preset->preset);
-	if (conf == NULL) {
-		dev_err(dev, "preset (%u) not supported\n", preset->preset);
-		return -EINVAL;
-	}
-	hdev->cur_conf = conf;
-	hdev->cur_conf_dirty = 1;
-	hdev->cur_preset = preset->preset;
-	return 0;
-}
-
-static int hdmi_g_dv_preset(struct v4l2_subdev *sd,
-	struct v4l2_dv_preset *preset)
-{
-	memset(preset, 0, sizeof(*preset));
-	preset->preset = sd_to_hdmi_dev(sd)->cur_preset;
-	return 0;
-}
-
 static int hdmi_s_dv_timings(struct v4l2_subdev *sd,
 	struct v4l2_dv_timings *timings)
 {
@@ -705,15 +664,6 @@ static int hdmi_g_mbus_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int hdmi_enum_dv_presets(struct v4l2_subdev *sd,
-	struct v4l2_dv_enum_preset *preset)
-{
-	if (preset->index >= ARRAY_SIZE(hdmi_timings))
-		return -EINVAL;
-	return v4l_fill_dv_preset_info(hdmi_timings[preset->index].preset,
-		preset);
-}
-
 static int hdmi_enum_dv_timings(struct v4l2_subdev *sd,
 	struct v4l2_enum_dv_timings *timings)
 {
@@ -748,9 +698,6 @@ static const struct v4l2_subdev_core_ops hdmi_sd_core_ops = {
 };
 
 static const struct v4l2_subdev_video_ops hdmi_sd_video_ops = {
-	.s_dv_preset = hdmi_s_dv_preset,
-	.g_dv_preset = hdmi_g_dv_preset,
-	.enum_dv_presets = hdmi_enum_dv_presets,
 	.s_dv_timings = hdmi_s_dv_timings,
 	.g_dv_timings = hdmi_g_dv_timings,
 	.enum_dv_timings = hdmi_enum_dv_timings,
@@ -1024,9 +971,11 @@ static int hdmi_probe(struct platform_device *pdev)
 	sd->owner = THIS_MODULE;
 
 	strlcpy(sd->name, "s5p-hdmi", sizeof(sd->name));
-	hdmi_dev->cur_preset = HDMI_DEFAULT_PRESET;
-	/* FIXME: missing fail preset is not supported */
-	hdmi_dev->cur_conf = hdmi_preset2timings(hdmi_dev->cur_preset);
+	hdmi_dev->cur_timings =
+		hdmi_timings[HDMI_DEFAULT_TIMINGS_IDX].dv_timings;
+	/* FIXME: missing fail timings is not supported */
+	hdmi_dev->cur_conf =
+		hdmi_timings[HDMI_DEFAULT_TIMINGS_IDX].hdmi_timings;
 	hdmi_dev->cur_conf_dirty = 1;
 
 	/* storing subdev for call that have only access to struct device */
-- 
1.7.10.4

