Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:51447 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbeLCIos (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Dec 2018 03:44:48 -0500
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
        Jacopo Mondi <jacopo@jmondi.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v6 09/12] media: ov5640: Make the return rate type more explicit
Date: Mon,  3 Dec 2018 09:44:24 +0100
Message-Id: <0f291e65286bbf7ec5e2a59f63f9791c4e526405.1543826654.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <cover.b1632e0c1a10c3f9f674e00142a554fa79eac762.1543826654.git-series.maxime.ripard@bootlin.com>
References: <cover.b1632e0c1a10c3f9f674e00142a554fa79eac762.1543826654.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the ov5640_try_frame_interval function, the ret variable actually holds
the frame rate index to use, which is represented by the enum
ov5640_frame_rate in the driver.

Make it more obvious.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Tested-by: Adam Ford <aford173@gmail.com> #imx6dq
---
 drivers/media/i2c/ov5640.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index abca08d669be..6cdf5ee0e4fa 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2052,8 +2052,8 @@ static int ov5640_try_frame_interval(struct ov5640_dev *sensor,
 				     u32 width, u32 height)
 {
 	const struct ov5640_mode_info *mode;
+	enum ov5640_frame_rate rate = OV5640_30_FPS;
 	u32 minfps, maxfps, fps;
-	int ret;
 
 	minfps = ov5640_framerates[OV5640_15_FPS];
 	maxfps = ov5640_framerates[OV5640_30_FPS];
@@ -2076,10 +2076,10 @@ static int ov5640_try_frame_interval(struct ov5640_dev *sensor,
 	else
 		fi->denominator = minfps;
 
-	ret = (fi->denominator == minfps) ? OV5640_15_FPS : OV5640_30_FPS;
+	rate = (fi->denominator == minfps) ? OV5640_15_FPS : OV5640_30_FPS;
 
-	mode = ov5640_find_mode(sensor, ret, width, height, false);
-	return mode ? ret : -EINVAL;
+	mode = ov5640_find_mode(sensor, rate, width, height, false);
+	return mode ? rate : -EINVAL;
 }
 
 static int ov5640_get_fmt(struct v4l2_subdev *sd,
-- 
git-series 0.9.1
