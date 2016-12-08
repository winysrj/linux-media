Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52903 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751962AbcLHI4M (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2016 03:56:12 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH RFC] tvp5150: don't touch register TVP5150_CONF_SHARED_PIN if not needed
Date: Thu,  8 Dec 2016 06:55:58 -0200
Message-Id: <d29a265da6e7d8d3a637f189b1cfc2736ec14757.1481186696.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

changeset 460b6c0831cb ("[media] tvp5150: Add s_stream subdev operation
support") added a logic that overrides TVP5150_CONF_SHARED_PIN setting,
depending on the type of bus set via the .set_fmt() subdev callback.

This is known to cause trobules on devices that don't use a V4L2
subdev devnode, and a fix for it was made by changeset 47de9bf8931e
("[media] tvp5150: Fix breakage for serial usage"). Unfortunately,
such fix doesn't consider the case of progressive video inputs,
causing chroma decoding issues on such videos, as it overrides not
only the type of video output, but also other unrelated bits.

So, instead of trying to guess, let's detect if the device is set
via a V4L2 subdev node or not. If not, just ignore the bogus logic.

Fixes: 460b6c0831cb ("[media] tvp5150: Add s_stream subdev operation support")
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---

Devin,

I didn't test this patch. As I explained on my previous e-mail, my current test
scenario for analog TV inputs is not  ideal, as I lack progressive video
and RF output testcases.

Could you please test if this will fix for you? 

Laurent/Javier,

With regards to OMAP3, it would be good to try to reproduce the issues
Devin noticed on your hardware, testing with both progressive and interlaced
sources and checking if the chroma is being decoded properly or not with a
NTSC signal. 

 drivers/media/i2c/tvp5150.c                      | 7 ++++++-
 drivers/media/platform/pxa_camera.c              | 1 +
 drivers/media/platform/soc_camera/soc_mediabus.c | 1 +
 include/media/v4l2-mediabus.h                    | 3 +++
 4 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 6737685d5be5..c8d701291a54 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -795,7 +795,8 @@ static int tvp5150_reset(struct v4l2_subdev *sd, u32 val)
 
 	tvp5150_set_std(sd, decoder->norm);
 
-	if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
+	if (decoder->mbus_type == V4L2_MBUS_PARALLEL ||
+	    decoder->mbus_type == V4L2_MBUS_UNKNOWN)
 		tvp5150_write(sd, TVP5150_DATA_RATE_SEL, 0x40);
 
 	return 0;
@@ -1053,6 +1054,9 @@ static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
 	/* Output format: 8-bit ITU-R BT.656 with embedded syncs */
 	int val = 0x09;
 
+	if (decoder->mbus_type == V4L2_MBUS_UNKNOWN)
+		return 0;
+
 	/* Output format: 8-bit 4:2:2 YUV with discrete sync */
 	if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
 		val = 0x0d;
@@ -1501,6 +1505,7 @@ static int tvp5150_probe(struct i2c_client *c,
 	core->norm = V4L2_STD_ALL;	/* Default is autodetect */
 	core->input = TVP5150_COMPOSITE1;
 	core->enable = true;
+	core->mbus_type = V4L2_MBUS_UNKNOWN;
 
 	v4l2_ctrl_handler_init(&core->hdl, 5);
 	v4l2_ctrl_new_std(&core->hdl, &tvp5150_ctrl_ops,
diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 929006f65cc7..86b60b85d20e 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -593,6 +593,7 @@ static unsigned int pxa_mbus_config_compatible(const struct v4l2_mbus_config *cf
 	common_flags = cfg->flags & flags;
 
 	switch (cfg->type) {
+	case V4L2_MBUS_UNKNOWN:
 	case V4L2_MBUS_PARALLEL:
 		hsync = common_flags & (V4L2_MBUS_HSYNC_ACTIVE_HIGH |
 					V4L2_MBUS_HSYNC_ACTIVE_LOW);
diff --git a/drivers/media/platform/soc_camera/soc_mediabus.c b/drivers/media/platform/soc_camera/soc_mediabus.c
index e3e665e1c503..37c49a10fbe0 100644
--- a/drivers/media/platform/soc_camera/soc_mediabus.c
+++ b/drivers/media/platform/soc_camera/soc_mediabus.c
@@ -490,6 +490,7 @@ unsigned int soc_mbus_config_compatible(const struct v4l2_mbus_config *cfg,
 
 	switch (cfg->type) {
 	case V4L2_MBUS_PARALLEL:
+	case V4L2_MBUS_UNKNOWN:
 		hsync = common_flags & (V4L2_MBUS_HSYNC_ACTIVE_HIGH |
 					V4L2_MBUS_HSYNC_ACTIVE_LOW);
 		vsync = common_flags & (V4L2_MBUS_VSYNC_ACTIVE_HIGH |
diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 34cc99e093ef..8af6b96d628b 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -70,11 +70,14 @@
  * @V4L2_MBUS_BT656:	parallel interface with embedded synchronisation, can
  *			also be used for BT.1120
  * @V4L2_MBUS_CSI2:	MIPI CSI-2 serial interface
+ * @V4L2_MBUS_UNKNOWN:	used to indicate that the device is not controlled
+ *			via a V4L2 subdev devnode interface
  */
 enum v4l2_mbus_type {
 	V4L2_MBUS_PARALLEL,
 	V4L2_MBUS_BT656,
 	V4L2_MBUS_CSI2,
+	V4L2_MBUS_UNKNOWN,
 };
 
 /**
-- 
2.9.3


