Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:42803
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932496AbcHKQ2f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 12:28:35 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 1/2] [media] tvp5150: use sd internal ops .registered instead .registered_async
Date: Thu, 11 Aug 2016 12:28:15 -0400
Message-Id: <1470932896-25843-2-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1470932896-25843-1-git-send-email-javier@osg.samsung.com>
References: <1470932896-25843-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver is using the struct v4l2_subdev_core_ops .registered_async
callback to register the connector entities and create the pad links
after the subdev entity has been registered with the media device.

But the .registered_async callback isn't needed since the v4l2 core
already calls the struct v4l2_subdev_internal_ops .registered callback
in v4l2_device_register_subdev(), after media_device_register_entity().

So, use the .registered() callback instead of the .registered_async()
that is going to be removed in a following patch since isn't needed.

Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/i2c/tvp5150.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 0b6d46c453bf..52e340c988a0 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1173,7 +1173,7 @@ static int tvp5150_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	return 0;
 }
 
-static int tvp5150_registered_async(struct v4l2_subdev *sd)
+static int tvp5150_registered(struct v4l2_subdev *sd)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct tvp5150 *decoder = to_tvp5150(sd);
@@ -1222,7 +1222,6 @@ static const struct v4l2_subdev_core_ops tvp5150_core_ops = {
 	.g_register = tvp5150_g_register,
 	.s_register = tvp5150_s_register,
 #endif
-	.registered_async = tvp5150_registered_async,
 };
 
 static const struct v4l2_subdev_tuner_ops tvp5150_tuner_ops = {
@@ -1261,6 +1260,10 @@ static const struct v4l2_subdev_ops tvp5150_ops = {
 	.pad = &tvp5150_pad_ops,
 };
 
+static const struct v4l2_subdev_internal_ops tvp5150_internal_ops = {
+	.registered = tvp5150_registered,
+};
+
 
 /****************************************************************************
 			I2C Client & Driver
@@ -1474,6 +1477,7 @@ static int tvp5150_probe(struct i2c_client *c,
 	}
 
 	v4l2_i2c_subdev_init(sd, c, &tvp5150_ops);
+	sd->internal_ops = &tvp5150_internal_ops;
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
-- 
2.5.5

