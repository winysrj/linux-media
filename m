Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:39709 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728055AbeHMNBv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 09:01:51 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v2 5/5] media: ov5640: fix restore of last mode set
Date: Mon, 13 Aug 2018 12:19:46 +0200
Message-ID: <1534155586-26974-6-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1534155586-26974-1-git-send-email-hugues.fruchet@st.com>
References: <1534155586-26974-1-git-send-email-hugues.fruchet@st.com>
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
index c110a6a..923cc30 100644
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
2.7.4
