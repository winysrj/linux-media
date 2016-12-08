Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37663 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932090AbcLHOqm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2016 09:46:42 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] tvp5150: don't touch register TVP5150_CONF_SHARED_PIN if not needed
Date: Thu,  8 Dec 2016 12:46:37 -0200
Message-Id: <42a5efc3dee39cd14e558df25cc8e7856d2c503b.1481208216.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

commit 460b6c0831cb ("[media] tvp5150: Add s_stream subdev operation
support") added a logic that overrides TVP5150_CONF_SHARED_PIN setting,
depending on the type of bus set via the .set_fmt() subdev callback.

This is known to cause trobules on devices that don't use a V4L2
subdev devnode, and a fix for it was made by commit 47de9bf8931e
("[media] tvp5150: Fix breakage for serial usage"). Unfortunately,
such fix doesn't consider the case of progressive video inputs,
causing chroma decoding issues on such videos, as it overrides not
only the type of video output, but also other unrelated bits.

So, instead of trying to guess, let's detect if the device configuration
is set via Device Tree. If not, just ignore the new logic, restoring
the original behavior.

Fixes: 460b6c0831cb ("[media] tvp5150: Add s_stream subdev operation support")
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---

changes since version 1: added a notice about what's broken at the
tvp5150_stream() logic, and improved patch's description.

changes since RFC: don't touch at enum v4l2_mbus_type.


 drivers/media/i2c/tvp5150.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 6737685d5be5..c9fd36998ac7 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -57,6 +57,7 @@ struct tvp5150 {
 	u16 rom_ver;
 
 	enum v4l2_mbus_type mbus_type;
+	bool has_dt;
 };
 
 static inline struct tvp5150 *to_tvp5150(struct v4l2_subdev *sd)
@@ -795,7 +796,7 @@ static int tvp5150_reset(struct v4l2_subdev *sd, u32 val)
 
 	tvp5150_set_std(sd, decoder->norm);
 
-	if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
+	if (decoder->mbus_type == V4L2_MBUS_PARALLEL || !decoder->has_dt)
 		tvp5150_write(sd, TVP5150_DATA_RATE_SEL, 0x40);
 
 	return 0;
@@ -1053,6 +1054,20 @@ static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
 	/* Output format: 8-bit ITU-R BT.656 with embedded syncs */
 	int val = 0x09;
 
+	if (!decoder->has_dt)
+		return 0;
+
+	/*
+	 * FIXME: the logic below is hardcoded to work with some OMAP3
+	 * hardware with tvp5151. As such, it hardcodes values for
+	 * both TVP5150_CONF_SHARED_PIN and TVP5150_MISC_CTL, and ignores
+	 * what was set before at the driver. Ideally, we should have
+	 * DT nodes describing the setup, instead of hardcoding those
+	 * values, and doing a read before writing values to
+	 * TVP5150_MISC_CTL, but any patch adding support for it should
+	 * keep DT backward-compatible.
+	 */
+
 	/* Output format: 8-bit 4:2:2 YUV with discrete sync */
 	if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
 		val = 0x0d;
@@ -1374,6 +1389,7 @@ static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
 	}
 
 	decoder->mbus_type = bus_cfg.bus_type;
+	decoder->has_dt = true;
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 	connectors = of_get_child_by_name(np, "connectors");
-- 
2.9.3


