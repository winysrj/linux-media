Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:39818 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751489AbeCHJCS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Mar 2018 04:02:18 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH] media: ov5640: fix frame interval enumeration
Date: Thu, 8 Mar 2018 10:01:59 +0100
Message-ID: <1520499719-23955-1-git-send-email-hugues.fruchet@st.com>
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
 drivers/media/i2c/ov5640.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 676f635..28dc687 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1400,6 +1400,9 @@ static int ov5640_set_virtual_channel(struct ov5640_dev *sensor)
 	if (nearest && i < 0)
 		mode = &ov5640_mode_data[fr][0];
 
+	if (!nearest && i < 0)
+		return NULL;
+
 	return mode;
 }
 
-- 
1.9.1
