Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:43806 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751274AbeEQIyH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 04:54:07 -0400
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Samuel Bobrowicz <sam@elite-embedded.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Daniel Mack <daniel@zonque.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v3 01/12] media: ov5640: Fix timings setup code
Date: Thu, 17 May 2018 10:53:54 +0200
Message-Id: <20180517085405.10104-2-maxime.ripard@bootlin.com>
In-Reply-To: <20180517085405.10104-1-maxime.ripard@bootlin.com>
References: <20180517085405.10104-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Samuel Bobrowicz <sam@elite-embedded.com>

The current code, when changing the mode and changing the scaling or
sampling parameters, will look at the horizontal and vertical total size,
which, since 5999f381e023 ("media: ov5640: Add horizontal and vertical
totals") has been moved from the static register initialization to after
the mode change.

That means that the values are no longer set up before the code retrieves
them, which is obviously a bug.

Fixes: 5999f381e023 ("media: ov5640: Add horizontal and vertical totals")
Signed-off-by: Samuel Bobrowicz <sam@elite-embedded.com>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/i2c/ov5640.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index e480e53b369b..4bd968b478db 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1462,6 +1462,10 @@ static int ov5640_set_mode_exposure_calc(struct ov5640_dev *sensor,
 	if (ret < 0)
 		return ret;
 
+	ret = ov5640_set_timings(sensor, mode);
+	if (ret < 0)
+		return ret;
+
 	/* read capture VTS */
 	ret = ov5640_get_vts(sensor);
 	if (ret < 0)
@@ -1589,6 +1593,10 @@ static int ov5640_set_mode_direct(struct ov5640_dev *sensor,
 	if (ret < 0)
 		return ret;
 
+	ret = ov5640_set_timings(sensor, mode);
+	if (ret < 0)
+		return ret;
+
 	/* turn auto gain/exposure back on for direct mode */
 	ret = __v4l2_ctrl_s_ctrl(sensor->ctrls.auto_gain, 1);
 	if (ret)
@@ -1633,10 +1641,6 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
 		ret = ov5640_set_mode_direct(sensor, mode, exposure);
 	}
 
-	if (ret < 0)
-		return ret;
-
-	ret = ov5640_set_timings(sensor, mode);
 	if (ret < 0)
 		return ret;
 
-- 
2.17.0
