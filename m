Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:46488 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbbKYRie (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2015 12:38:34 -0500
From: Lucas Stach <l.stach@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, patchwork-lst@pengutronix.de
Subject: [PATCH v2 5/9] [media] tvp5150: split reset/enable routine
Date: Wed, 25 Nov 2015 18:38:32 +0100
Message-Id: <1448473116-24735-5-git-send-email-l.stach@pengutronix.de>
In-Reply-To: <1448473116-24735-1-git-send-email-l.stach@pengutronix.de>
References: <1448473116-24735-1-git-send-email-l.stach@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

To trigger standard autodetection only the reset part of the routine
is necessary. Split this out to make it callable on its own.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tvp5150.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index cb9675fbf358..6d0f2dede866 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -768,9 +768,6 @@ static v4l2_std_id tvp5150_read_std(struct v4l2_subdev *sd)
 
 static int tvp5150_reset(struct v4l2_subdev *sd, u32 val)
 {
-	struct tvp5150 *decoder = to_tvp5150(sd);
-	v4l2_std_id std;
-
 	/* Initializes TVP5150 to its default values */
 	tvp5150_write_inittab(sd, tvp5150_init_default);
 
@@ -780,6 +777,14 @@ static int tvp5150_reset(struct v4l2_subdev *sd, u32 val)
 	/* Selects decoder input */
 	tvp5150_selmux(sd);
 
+	return 0;
+}
+
+static int tvp5150_enable(struct v4l2_subdev *sd)
+{
+	struct tvp5150 *decoder = to_tvp5150(sd);
+	v4l2_std_id std;
+
 	/* Initializes TVP5150 to stream enabled values */
 	tvp5150_write_inittab(sd, tvp5150_init_enable);
 
@@ -844,6 +849,7 @@ static int tvp5150_enum_mbus_code(struct v4l2_subdev *sd,
 		return -EINVAL;
 
 	code->code = MEDIA_BUS_FMT_UYVY8_2X8;
+
 	return 0;
 }
 
@@ -1179,8 +1185,10 @@ static int tvp5150_set_format(struct v4l2_subdev *sd,
 
 	format->format = *mbus_format;
 
-	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
 		tvp5150_reset(sd, 0);
+		tvp5150_enable(sd);
+	}
 
 	v4l2_dbg(1, debug, sd, "width = %d, height = %d\n", mbus_format->width,
 			mbus_format->height);
@@ -1454,6 +1462,7 @@ static int tvp5150_probe(struct i2c_client *c,
 	}
 	v4l2_ctrl_handler_setup(&core->hdl);
 
+	tvp5150_reset(sd, 0);
 	/* Default is no cropping */
 	tvp5150_set_default(tvp5150_read_std(sd), &core->rect, &core->format);
 
-- 
2.6.2

