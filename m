Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:46599 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752826AbeGDM7R (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Jul 2018 08:59:17 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH 4/5] media: ov5640: fix auto controls values when switching to manual mode
Date: Wed, 4 Jul 2018 14:58:42 +0200
Message-ID: <1530709123-12445-5-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1530709123-12445-1-git-send-email-hugues.fruchet@st.com>
References: <1530709123-12445-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When switching from auto to manual mode, V4L2 core is calling
g_volatile_ctrl() in manual mode in order to get the manual initial value.
Remove the manual mode check/return to not break this behaviour.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/i2c/ov5640.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index f9b256e..a307f1e 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2277,16 +2277,12 @@ static int ov5640_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUTOGAIN:
-		if (!ctrl->val)
-			return 0;
 		val = ov5640_get_gain(sensor);
 		if (val < 0)
 			return val;
 		sensor->ctrls.gain->val = val;
 		break;
 	case V4L2_CID_EXPOSURE_AUTO:
-		if (ctrl->val == V4L2_EXPOSURE_MANUAL)
-			return 0;
 		val = ov5640_get_exposure(sensor);
 		if (val < 0)
 			return val;
-- 
1.9.1
