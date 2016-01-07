Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44170 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282AbcAGMrY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jan 2016 07:47:24 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Enrico Butera <ebutera@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Eduard Gavin <egavinc@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH v2 05/10] [media] tvp5150: Add s_stream subdev operation support
Date: Thu,  7 Jan 2016 09:46:45 -0300
Message-Id: <1452170810-32346-6-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1452170810-32346-1-git-send-email-javier@osg.samsung.com>
References: <1452170810-32346-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

This patch adds the .s_stream subdev operation to the driver.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

Changes in v2: None

 drivers/media/i2c/tvp5150.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 71473cec236a..fb7a4ddff1fe 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -973,6 +973,21 @@ static int tvp5150_enum_frame_size(struct v4l2_subdev *sd,
 			I2C Command
  ****************************************************************************/
 
+static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	/* Initializes TVP5150 to its default values */
+	/* # set PCLK (27MHz) */
+	tvp5150_write(sd, TVP5150_CONF_SHARED_PIN, 0x00);
+
+	/* Output format: 8-bit ITU-R BT.656 with embedded syncs */
+	if (enable)
+		tvp5150_write(sd, TVP5150_MISC_CTL, 0x09);
+	else
+		tvp5150_write(sd, TVP5150_MISC_CTL, 0x00);
+
+	return 0;
+}
+
 static int tvp5150_s_routing(struct v4l2_subdev *sd,
 			     u32 input, u32 output, u32 config)
 {
@@ -1094,6 +1109,7 @@ static const struct v4l2_subdev_tuner_ops tvp5150_tuner_ops = {
 
 static const struct v4l2_subdev_video_ops tvp5150_video_ops = {
 	.s_std = tvp5150_s_std,
+	.s_stream = tvp5150_s_stream,
 	.s_routing = tvp5150_s_routing,
 	.s_crop = tvp5150_s_crop,
 	.g_crop = tvp5150_g_crop,
-- 
2.4.3

