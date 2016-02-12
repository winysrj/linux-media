Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57568 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbcBLVUM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 16:20:12 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org
Subject: [PATCH 1/2] [media] tvp5150: replace MEDIA_ENT_F_CONN_TEST by a control
Date: Fri, 12 Feb 2016 19:18:44 -0200
Message-Id: <bddda7f5f133e3bafa89519e0c8bce832d19e6d9.1455311900.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MEDIA_ENT_F_CONN_TEST is not really a connector, it is actually
a signal generator. Also, as other drivers use the
V4L2_CID_TEST_PATTERN control for signal generators, let's change
the driver accordingly.

Tested with Terratec Grabster AV350.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/i2c/tvp5150.c         | 45 +++++++++++++++++++++++--------------
 include/dt-bindings/media/tvp5150.h |  3 +--
 2 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index b8976028fc82..ef393f5daf2a 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1,5 +1,5 @@
 /*
- * tvp5150 - Texas Instruments TVP5150A/AM1 video decoder driver
+ * tvp5150 - Texas Instruments TVP5150A/AM1 and TVP5151 video decoder driver
  *
  * Copyright (c) 2005,2006 Mauro Carvalho Chehab (mchehab@infradead.org)
  * This code is placed under the terms of the GNU General Public License v2
@@ -27,7 +27,7 @@
 #define TVP5150_MAX_CROP_TOP	127
 #define TVP5150_CROP_SHIFT	2
 
-MODULE_DESCRIPTION("Texas Instruments TVP5150A video decoder driver");
+MODULE_DESCRIPTION("Texas Instruments TVP5150A/TVP5150AM1/TVP5151 video decoder driver");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_LICENSE("GPL");
 
@@ -259,8 +259,12 @@ static inline void tvp5150_selmux(struct v4l2_subdev *sd)
 	int input = 0;
 	int val;
 
-	if ((decoder->output & TVP5150_BLACK_SCREEN) || !decoder->enable)
-		input = 8;
+	/* Only tvp5150am1 and tvp5151 have signal generator support */
+	if ((decoder->dev_id == 0x5150 && decoder->rom_ver == 0x0400) ||
+	    (decoder->dev_id == 0x5151 && decoder->rom_ver == 0x0100)) {
+		if (!decoder->enable)
+			input = 8;
+	}
 
 	switch (decoder->input) {
 	case TVP5150_COMPOSITE1:
@@ -795,6 +799,7 @@ static int tvp5150_reset(struct v4l2_subdev *sd, u32 val)
 static int tvp5150_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct v4l2_subdev *sd = to_sd(ctrl);
+	struct tvp5150 *decoder = to_tvp5150(sd);
 
 	switch (ctrl->id) {
 	case V4L2_CID_BRIGHTNESS:
@@ -808,6 +813,9 @@ static int tvp5150_s_ctrl(struct v4l2_ctrl *ctrl)
 		return 0;
 	case V4L2_CID_HUE:
 		tvp5150_write(sd, TVP5150_HUE_CTL, ctrl->val);
+	case V4L2_CID_TEST_PATTERN:
+		decoder->enable = ctrl->val ? false : true;
+		tvp5150_selmux(sd);
 		return 0;
 	}
 	return -EINVAL;
@@ -1022,15 +1030,6 @@ static int tvp5150_link_setup(struct media_entity *entity,
 
 	decoder->input = i;
 
-	/* Only tvp5150am1 and tvp5151 have signal generator support */
-	if ((decoder->dev_id == 0x5150 && decoder->rom_ver == 0x0400) ||
-	    (decoder->dev_id == 0x5151 && decoder->rom_ver == 0x0100)) {
-		decoder->output = (i == TVP5150_GENERATOR ?
-				   TVP5150_BLACK_SCREEN : TVP5150_NORMAL);
-	} else {
-		decoder->output = TVP5150_NORMAL;
-	}
-
 	tvp5150_selmux(sd);
 #endif
 
@@ -1074,6 +1073,12 @@ static int tvp5150_s_routing(struct v4l2_subdev *sd,
 
 	decoder->input = input;
 	decoder->output = output;
+
+	if (output == TVP5150_BLACK_SCREEN)
+		decoder->enable = false;
+	else
+		decoder->enable = true;
+
 	tvp5150_selmux(sd);
 	return 0;
 }
@@ -1405,9 +1410,6 @@ static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
 		case TVP5150_SVIDEO:
 			input->function = MEDIA_ENT_F_CONN_SVIDEO;
 			break;
-		case TVP5150_GENERATOR:
-			input->function = MEDIA_ENT_F_CONN_TEST;
-			break;
 		}
 
 		input->flags = MEDIA_ENT_FL_CONNECTOR;
@@ -1431,6 +1433,11 @@ err:
 	return ret;
 }
 
+static const char * const tvp5150_test_patterns[2] = {
+	"Disabled",
+	"Black screen"
+};
+
 static int tvp5150_probe(struct i2c_client *c,
 			 const struct i2c_device_id *id)
 {
@@ -1488,7 +1495,7 @@ static int tvp5150_probe(struct i2c_client *c,
 
 	core->norm = V4L2_STD_ALL;	/* Default is autodetect */
 	core->input = TVP5150_COMPOSITE1;
-	core->enable = 1;
+	core->enable = true;
 
 	v4l2_ctrl_handler_init(&core->hdl, 5);
 	v4l2_ctrl_new_std(&core->hdl, &tvp5150_ctrl_ops,
@@ -1502,6 +1509,10 @@ static int tvp5150_probe(struct i2c_client *c,
 	v4l2_ctrl_new_std(&core->hdl, &tvp5150_ctrl_ops,
 			V4L2_CID_PIXEL_RATE, 27000000,
 			27000000, 1, 27000000);
+	v4l2_ctrl_new_std_menu_items(&core->hdl, &tvp5150_ctrl_ops,
+				     V4L2_CID_TEST_PATTERN,
+				     ARRAY_SIZE(tvp5150_test_patterns),
+				     0, 0, tvp5150_test_patterns);
 	sd->ctrl_handler = &core->hdl;
 	if (core->hdl.error) {
 		res = core->hdl.error;
diff --git a/include/dt-bindings/media/tvp5150.h b/include/dt-bindings/media/tvp5150.h
index d30865222082..c852a35e916e 100644
--- a/include/dt-bindings/media/tvp5150.h
+++ b/include/dt-bindings/media/tvp5150.h
@@ -25,9 +25,8 @@
 #define TVP5150_COMPOSITE0 0
 #define TVP5150_COMPOSITE1 1
 #define TVP5150_SVIDEO     2
-#define TVP5150_GENERATOR  3
 
-#define TVP5150_INPUT_NUM  4
+#define TVP5150_INPUT_NUM  3
 
 /* TVP5150 HW outputs */
 #define TVP5150_NORMAL       0
-- 
2.5.0

