Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:51327 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754085AbeFUIy3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 04:54:29 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v4] media: ov5640: fix frame interval enumeration
Date: Thu, 21 Jun 2018 10:53:39 +0200
Message-ID: <1529571219-7599-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Driver must reject frame interval enumeration of unsupported resolution.
This was detected by v4l2-compliance format ioctl test:
v4l2-compliance Format ioctls:
    info: found 2 frameintervals for pixel format 4745504a and size 176x144
  fail: v4l2-test-formats.cpp(123):
                           found frame intervals for invalid size 177x144
    test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: FAIL

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
version 2:
  - revisit patch according to Mauro comments:
    See https://www.mail-archive.com/linux-media@vger.kernel.org/msg127380.html

version 3:
  - revisit patch using v4l2_find_nearest_size() helper as per Sakari suggestion:
    See https://www.mail-archive.com/linux-media@vger.kernel.org/msg128186.html

version 4:
  - fix sparse warning:
    See https://www.mail-archive.com/linux-media@vger.kernel.org/msg132925.html

 drivers/media/i2c/ov5640.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index f6e40cc..4257ca6 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1389,24 +1389,16 @@ static int ov5640_set_timings(struct ov5640_dev *sensor,
 ov5640_find_mode(struct ov5640_dev *sensor, enum ov5640_frame_rate fr,
 		 int width, int height, bool nearest)
 {
-	const struct ov5640_mode_info *mode = NULL;
-	int i;
-
-	for (i = OV5640_NUM_MODES - 1; i >= 0; i--) {
-		mode = &ov5640_mode_data[fr][i];
-
-		if (!mode->reg_data)
-			continue;
+	const struct ov5640_mode_info *mode;
 
-		if ((nearest && mode->hact <= width &&
-		     mode->vact <= height) ||
-		    (!nearest && mode->hact == width &&
-		     mode->vact == height))
-			break;
-	}
+	mode = v4l2_find_nearest_size(&ov5640_mode_data[fr][0],
+				      ARRAY_SIZE(ov5640_mode_data[fr]),
+				      hact, vact,
+				      width, height);
 
-	if (nearest && i < 0)
-		mode = &ov5640_mode_data[fr][0];
+	if (!mode ||
+	    (!nearest && (mode->hact != width || mode->vact != height)))
+		return NULL;
 
 	return mode;
 }
@@ -2435,8 +2427,14 @@ static int ov5640_s_frame_interval(struct v4l2_subdev *sd,
 
 	sensor->current_fr = frame_rate;
 	sensor->frame_interval = fi->interval;
-	sensor->current_mode = ov5640_find_mode(sensor, frame_rate, mode->hact,
-						mode->vact, true);
+	mode = ov5640_find_mode(sensor, frame_rate, mode->hact,
+				mode->vact, true);
+	if (!mode) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	sensor->current_mode = mode;
 	sensor->pending_mode_change = true;
 out:
 	mutex_unlock(&sensor->lock);
-- 
1.9.1
