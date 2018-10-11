Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:46678 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728353AbeJKQrz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Oct 2018 12:47:55 -0400
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
Subject: [PATCH v4 08/12] media: ov5640: Make the return rate type more explicit
Date: Thu, 11 Oct 2018 11:21:03 +0200
Message-Id: <20181011092107.30715-9-maxime.ripard@bootlin.com>
In-Reply-To: <20181011092107.30715-1-maxime.ripard@bootlin.com>
References: <20181011092107.30715-1-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the ov5640_try_frame_interval function, the ret variable actually holds
the frame rate index to use, which is represented by the enum
ov5640_frame_rate in the driver.

Make it more obvious.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/i2c/ov5640.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 84c0aae74420..d7a1e1928baf 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1975,8 +1975,8 @@ static int ov5640_try_frame_interval(struct ov5640_dev *sensor,
 				     u32 width, u32 height)
 {
 	const struct ov5640_mode_info *mode;
+	enum ov5640_frame_rate rate = OV5640_30_FPS;
 	u32 minfps, maxfps, fps;
-	int ret;
 
 	minfps = ov5640_framerates[OV5640_15_FPS];
 	maxfps = ov5640_framerates[OV5640_30_FPS];
@@ -1999,10 +1999,10 @@ static int ov5640_try_frame_interval(struct ov5640_dev *sensor,
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
2.19.1
