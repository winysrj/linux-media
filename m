Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:20839 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752653AbeGDM7o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Jul 2018 08:59:44 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH 5/5] media: ov5640: fix restore of last mode set
Date: Wed, 4 Jul 2018 14:58:43 +0200
Message-ID: <1530709123-12445-6-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1530709123-12445-1-git-send-email-hugues.fruchet@st.com>
References: <1530709123-12445-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mode setting depends on last mode set, in particular
because of exposure calculation when downscale mode
change between subsampling and scaling.
At stream on the last mode was wrongly set to current mode,
so no change was detected and exposure calculation
was not made, fix this.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/i2c/ov5640.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index a307f1e..f3fb140 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -225,6 +225,7 @@ struct ov5640_dev {
 	struct v4l2_mbus_framefmt fmt;
 
 	const struct ov5640_mode_info *current_mode;
+	const struct ov5640_mode_info *last_mode;
 	enum ov5640_frame_rate current_fr;
 	struct v4l2_fract frame_interval;
 
@@ -1628,6 +1629,9 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
 	bool auto_exp =  sensor->ctrls.auto_exp->val == V4L2_EXPOSURE_AUTO;
 	int ret;
 
+	if (!orig_mode)
+		orig_mode = mode;
+
 	dn_mode = mode->dn_mode;
 	orig_dn_mode = orig_mode->dn_mode;
 
@@ -1688,6 +1692,7 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
 		return ret;
 
 	sensor->pending_mode_change = false;
+	sensor->last_mode = mode;
 
 	return 0;
 
@@ -2551,7 +2556,8 @@ static int ov5640_s_stream(struct v4l2_subdev *sd, int enable)
 
 	if (sensor->streaming == !enable) {
 		if (enable && sensor->pending_mode_change) {
-			ret = ov5640_set_mode(sensor, sensor->current_mode);
+			ret = ov5640_set_mode(sensor, sensor->last_mode);
+
 			if (ret)
 				goto out;
 
-- 
1.9.1
