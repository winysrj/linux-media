Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:12487 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750877AbeBHMW2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Feb 2018 07:22:28 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v2] media: ov5640: fix framerate update
Date: Thu, 8 Feb 2018 13:22:14 +0100
Message-ID: <1518092534-7153-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After a framerate update through s_frame_interval(), the new
framerate was not taken into account when streaming,
but was taken into account on next session.
This was due to sensor->current_mode not updated accordingly to new
framerate setting in ov5640_s_frame_interval().

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/i2c/ov5640.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 3e7b43c..03940f0 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2374,6 +2374,8 @@ static int ov5640_s_frame_interval(struct v4l2_subdev *sd,
 
 	sensor->current_fr = frame_rate;
 	sensor->frame_interval = fi->interval;
+	sensor->current_mode = ov5640_find_mode(sensor, frame_rate, mode->width,
+						mode->height, true);
 	sensor->pending_mode_change = true;
 out:
 	mutex_unlock(&sensor->lock);
-- 
1.9.1
