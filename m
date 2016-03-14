Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:57202 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934545AbcCNPXj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 11:23:39 -0400
From: Lucas Stach <l.stach@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, patchwork-lst@pengutronix.de
Subject: [PATCH v3 4/9] [media] tvp5150: fix standard autodetection
Date: Mon, 14 Mar 2016 16:23:32 +0100
Message-Id: <1457969017-4088-4-git-send-email-l.stach@pengutronix.de>
In-Reply-To: <1457969017-4088-1-git-send-email-l.stach@pengutronix.de>
References: <1457969017-4088-1-git-send-email-l.stach@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

Make sure to not overwrite decoder->norm when setting the standard
in hardware, but only when instructed by V4L2 API calls.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
---
 drivers/media/i2c/tvp5150.c | 56 +++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 25 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index f6720d1d09ea..21d044b564ad 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -703,8 +703,6 @@ static int tvp5150_set_std(struct v4l2_subdev *sd, v4l2_std_id std)
 	struct tvp5150 *decoder = to_tvp5150(sd);
 	int fmt = 0;
 
-	decoder->norm = std;
-
 	/* First tests should be against specific std */
 
 	if (std == V4L2_STD_NTSC_443) {
@@ -741,13 +739,37 @@ static int tvp5150_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
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
@@ -783,7 +805,13 @@ static int tvp5150_reset(struct v4l2_subdev *sd, u32 val)
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
 	return 0;
 };
 
@@ -808,28 +836,6 @@ static int tvp5150_s_ctrl(struct v4l2_ctrl *ctrl)
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
 static int tvp5150_enum_mbus_code(struct v4l2_subdev *sd,
 		struct v4l2_subdev_pad_config *cfg,
 		struct v4l2_subdev_mbus_code_enum *code)
-- 
2.7.0

