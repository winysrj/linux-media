Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:53694 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727183AbeJDSPc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Oct 2018 14:15:32 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Jacopo Mondi <jacopo@jmondi.org>
Subject: [PATCH] media: ov5640: fix framerate update
Date: Thu, 4 Oct 2018 13:21:57 +0200
Message-ID: <1538652117-4210-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changing framerate right before streamon had no effect,
the new framerate value was taken into account only at
next streamon, fix this.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/i2c/ov5640.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 664ffac..8599e17 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2573,8 +2573,6 @@ static int ov5640_s_frame_interval(struct v4l2_subdev *sd,
 	if (frame_rate < 0)
 		frame_rate = OV5640_15_FPS;
 
-	sensor->current_fr = frame_rate;
-	sensor->frame_interval = fi->interval;
 	mode = ov5640_find_mode(sensor, frame_rate, mode->hact,
 				mode->vact, true);
 	if (!mode) {
@@ -2582,7 +2580,10 @@ static int ov5640_s_frame_interval(struct v4l2_subdev *sd,
 		goto out;
 	}
 
-	if (mode != sensor->current_mode) {
+	if (mode != sensor->current_mode ||
+	    frame_rate != sensor->current_fr) {
+		sensor->current_fr = frame_rate;
+		sensor->frame_interval = fi->interval;
 		sensor->current_mode = mode;
 		sensor->pending_mode_change = true;
 	}
-- 
2.7.4
