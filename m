Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:35498 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933976AbeCHPHe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Mar 2018 10:07:34 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v2] media: ov5640: fix frame interval enumeration
Date: Thu, 8 Mar 2018 16:07:14 +0100
Message-ID: <1520521634-29089-1-git-send-email-hugues.fruchet@st.com>
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

 drivers/media/i2c/ov5640.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 676f635..5c08124 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1397,8 +1397,12 @@ static int ov5640_set_virtual_channel(struct ov5640_dev *sensor)
 			break;
 	}
 
-	if (nearest && i < 0)
+	if (i < 0) {
+		/* no match */
+		if (!nearest)
+			return NULL;
 		mode = &ov5640_mode_data[fr][0];
+	}
 
 	return mode;
 }
@@ -2381,8 +2385,14 @@ static int ov5640_s_frame_interval(struct v4l2_subdev *sd,
 
 	sensor->current_fr = frame_rate;
 	sensor->frame_interval = fi->interval;
-	sensor->current_mode = ov5640_find_mode(sensor, frame_rate, mode->width,
-						mode->height, true);
+	mode = ov5640_find_mode(sensor, frame_rate, mode->width,
+				mode->height, true);
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
