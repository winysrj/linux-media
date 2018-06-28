Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59887 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753661AbeF1QVY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 12:21:24 -0400
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: p.zabel@pengutronix.de, afshin.nasser@gmail.com,
        javierm@redhat.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 10/22] [media] tvp5150: split reset/enable routine
Date: Thu, 28 Jun 2018 18:20:42 +0200
Message-Id: <20180628162054.25613-11-m.felsch@pengutronix.de>
In-Reply-To: <20180628162054.25613-1-m.felsch@pengutronix.de>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

To trigger standard autodetection only the reset part of the routine
is necessary during probe(). Split this out to make it callable on its own.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
[m.felsch@pengutronix.de: adapt commit message]
[m.felsch@pengutronix.de: add tvp5150_enable() to tvp5150_s_stream()]
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 drivers/media/i2c/tvp5150.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 895bc2bfb1d1..284694c21556 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -796,9 +796,6 @@ static v4l2_std_id tvp5150_read_std(struct v4l2_subdev *sd)
 
 static int tvp5150_reset(struct v4l2_subdev *sd, u32 val)
 {
-	struct tvp5150 *decoder = to_tvp5150(sd);
-	v4l2_std_id std;
-
 	/* Initializes TVP5150 to its default values */
 	tvp5150_write_inittab(sd, tvp5150_init_default);
 
@@ -808,12 +805,20 @@ static int tvp5150_reset(struct v4l2_subdev *sd, u32 val)
 	/* Selects decoder input */
 	tvp5150_selmux(sd);
 
-	/* Initializes TVP5150 to stream enabled values */
-	tvp5150_write_inittab(sd, tvp5150_init_enable);
-
 	/* Initialize image preferences */
 	v4l2_ctrl_handler_setup(&decoder->hdl);
 
+	return 0;
+}
+
+static int tvp5150_enable(struct v4l2_subdev *sd)
+{
+	struct tvp5150 *decoder = to_tvp5150(sd);
+	v4l2_std_id std;
+
+	/* Initializes TVP5150 to stream enabled values */
+	tvp5150_write_inittab(sd, tvp5150_init_enable);
+
 	if (decoder->norm == V4L2_STD_ALL)
 		std = tvp5150_read_std(sd);
 	else
@@ -1138,6 +1143,8 @@ static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
 	       TVP5150_MISC_CTL_CLOCK_OE;
 
 	if (enable) {
+		tvp5150_enable(sd);
+
 		/*
 		 * Enable the YCbCr and clock outputs. In discrete sync mode
 		 * (non-BT.656) additionally enable the the sync outputs.
-- 
2.17.1
