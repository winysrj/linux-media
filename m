Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:47163 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752715AbeGDNFA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Jul 2018 09:05:00 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH] media: ov5640: do not change mode if format or frame interval is unchanged
Date: Wed, 4 Jul 2018 15:04:38 +0200
Message-ID: <1530709478-23420-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Save load of mode registers array when V4L2 client sets a format or a
frame interval which selects the same mode than the current one.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/i2c/ov5640.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 1ecbb7a..071f4bc 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1966,9 +1966,11 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
 		goto out;
 	}
 
-	sensor->current_mode = new_mode;
-	sensor->fmt = *mbus_fmt;
-	sensor->pending_mode_change = true;
+	if (new_mode != sensor->current_mode) {
+		sensor->current_mode = new_mode;
+		sensor->fmt = *mbus_fmt;
+		sensor->pending_mode_change = true;
+	}
 out:
 	mutex_unlock(&sensor->lock);
 	return ret;
@@ -2508,8 +2510,10 @@ static int ov5640_s_frame_interval(struct v4l2_subdev *sd,
 		goto out;
 	}
 
-	sensor->current_mode = mode;
-	sensor->pending_mode_change = true;
+	if (mode != sensor->current_mode) {
+		sensor->current_mode = mode;
+		sensor->pending_mode_change = true;
+	}
 out:
 	mutex_unlock(&sensor->lock);
 	return ret;
-- 
1.9.1
