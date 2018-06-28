Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:42043 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967346AbeF1QWQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 12:22:16 -0400
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: p.zabel@pengutronix.de, afshin.nasser@gmail.com,
        javierm@redhat.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 09/22] [media] tvp5150: fix standard autodetection
Date: Thu, 28 Jun 2018 18:20:41 +0200
Message-Id: <20180628162054.25613-10-m.felsch@pengutronix.de>
In-Reply-To: <20180628162054.25613-1-m.felsch@pengutronix.de>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

Make sure to not overwrite decoder->norm when setting the standard
in hardware, but only when instructed by V4L2 API calls.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 drivers/media/i2c/tvp5150.c | 56 ++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 25 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index dbfc56c87434..895bc2bfb1d1 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -731,8 +731,6 @@ static int tvp5150_set_std(struct v4l2_subdev *sd, v4l2_std_id std)
 	struct tvp5150 *decoder = to_tvp5150(sd);
 	int fmt = 0;
 
-	decoder->norm = std;
-
 	/* First tests should be against specific std */
 
 	if (std == V4L2_STD_NTSC_443) {
@@ -769,13 +767,37 @@ static int tvp5150_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 	else
 		decoder->rect.height = TVP5150_V_MAX_OTHERS;
 
+	decoder->norm = std;
 
 	return tvp5150_set_std(sd, std);
 }
 
+static v4l2_std_id tvp5150_read_std(struct v4l2_subdev *sd)
+{
+	int val = tvp5150_read(sd, TVP5150_STATUS_REG_5);
+
+	switch (val & 0x0F) {
+	case 0x01:
+		return V4L2_STD_NTSC;
+	case 0x03:
+		return V4L2_STD_PAL;
+	case 0x05:
+		return V4L2_STD_PAL_M;
+	case 0x07:
+		return V4L2_STD_PAL_N | V4L2_STD_PAL_Nc;
+	case 0x09:
+		return V4L2_STD_NTSC_443;
+	case 0xb:
+		return V4L2_STD_SECAM;
+	default:
+		return V4L2_STD_UNKNOWN;
+	}
+}
+
 static int tvp5150_reset(struct v4l2_subdev *sd, u32 val)
 {
 	struct tvp5150 *decoder = to_tvp5150(sd);
+	v4l2_std_id std;
 
 	/* Initializes TVP5150 to its default values */
 	tvp5150_write_inittab(sd, tvp5150_init_default);
@@ -792,7 +814,13 @@ static int tvp5150_reset(struct v4l2_subdev *sd, u32 val)
 	/* Initialize image preferences */
 	v4l2_ctrl_handler_setup(&decoder->hdl);
 
-	tvp5150_set_std(sd, decoder->norm);
+	if (decoder->norm == V4L2_STD_ALL)
+		std = tvp5150_read_std(sd);
+	else
+		std = decoder->norm;
+
+	/* Disable autoswitch mode */
+	tvp5150_set_std(sd, std);
 
 	if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
 		/* 8-bit 4:2:2 YUV with discrete sync output */
@@ -829,28 +857,6 @@ static int tvp5150_s_ctrl(struct v4l2_ctrl *ctrl)
 	return -EINVAL;
 }
 
-static v4l2_std_id tvp5150_read_std(struct v4l2_subdev *sd)
-{
-	int val = tvp5150_read(sd, TVP5150_STATUS_REG_5);
-
-	switch (val & 0x0F) {
-	case 0x01:
-		return V4L2_STD_NTSC;
-	case 0x03:
-		return V4L2_STD_PAL;
-	case 0x05:
-		return V4L2_STD_PAL_M;
-	case 0x07:
-		return V4L2_STD_PAL_N | V4L2_STD_PAL_Nc;
-	case 0x09:
-		return V4L2_STD_NTSC_443;
-	case 0xb:
-		return V4L2_STD_SECAM;
-	default:
-		return V4L2_STD_UNKNOWN;
-	}
-}
-
 static void tvp5150_set_default(v4l2_std_id std, struct v4l2_rect *crop)
 {
 	/* Default is no cropping */
-- 
2.17.1
