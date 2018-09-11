Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:24414 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726670AbeIKSsf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 14:48:35 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v3 3/5] media: ov5640: fix wrong binning value in exposure calculation
Date: Tue, 11 Sep 2018 15:48:19 +0200
Message-ID: <1536673701-32165-4-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1536673701-32165-1-git-send-email-hugues.fruchet@st.com>
References: <1536673701-32165-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ov5640_set_mode_exposure_calc() is checking binning value but
binning value read is buggy, fix this.
Rename ov5640_binning_on() to ov5640_get_binning() as per other
similar functions.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/ov5640.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 7c569de..9fb17b5 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1349,7 +1349,7 @@ static int ov5640_set_ae_target(struct ov5640_dev *sensor, int target)
 	return ov5640_write_reg(sensor, OV5640_REG_AEC_CTRL1F, fast_low);
 }
 
-static int ov5640_binning_on(struct ov5640_dev *sensor)
+static int ov5640_get_binning(struct ov5640_dev *sensor)
 {
 	u8 temp;
 	int ret;
@@ -1357,8 +1357,8 @@ static int ov5640_binning_on(struct ov5640_dev *sensor)
 	ret = ov5640_read_reg(sensor, OV5640_REG_TIMING_TC_REG21, &temp);
 	if (ret)
 		return ret;
-	temp &= 0xfe;
-	return temp ? 1 : 0;
+
+	return temp & BIT(0);
 }
 
 static int ov5640_set_binning(struct ov5640_dev *sensor, bool enable)
@@ -1468,7 +1468,7 @@ static int ov5640_set_mode_exposure_calc(struct ov5640_dev *sensor,
 	if (ret < 0)
 		return ret;
 	prev_shutter = ret;
-	ret = ov5640_binning_on(sensor);
+	ret = ov5640_get_binning(sensor);
 	if (ret < 0)
 		return ret;
 	if (ret && mode->id != OV5640_MODE_720P_1280_720 &&
-- 
2.7.4
