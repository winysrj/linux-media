Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48185 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932416AbcAYQp7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 11:45:59 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Eduard Gavin <egavinc@gmail.com>
Subject: [PATCH] tvp5150: Fix breakage for serial usage
Date: Mon, 25 Jan 2016 14:44:56 -0200
Message-Id: <54ffe2ae9209b607f54142809902764e2eaaf1d2.1453740290.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

changeset 460b6c0831cb ("tvp5150: Add s_stream subdev operation
support") broke for em28xx-based devices with uses tvp5150. On those
devices, touching the TVP5150_MISC_CTL register causes em28xx to stop
streaming.

I suspect that it uses the 27 MHz clock provided by tvp5150 to feed
em28xx. So, change the logic to do nothing on s_stream if the tvp5150 is
not set up to work with V4L2_MBUS_PARALLEL.

Cc: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/i2c/tvp5150.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 437f1a7ecb96..779c6f453cc9 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -975,19 +975,18 @@ static int tvp5150_g_mbus_config(struct v4l2_subdev *sd,
 static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct tvp5150 *decoder = to_tvp5150(sd);
-	/* Output format: 8-bit ITU-R BT.656 with embedded syncs */
-	int val = 0x09;
 
 	/* Output format: 8-bit 4:2:2 YUV with discrete sync */
-	if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
-		val = 0x0d;
+	if (decoder->mbus_type != V4L2_MBUS_PARALLEL)
+		return 0;
 
 	/* Initializes TVP5150 to its default values */
 	/* # set PCLK (27MHz) */
 	tvp5150_write(sd, TVP5150_CONF_SHARED_PIN, 0x00);
 
+	/* Output format: 8-bit ITU-R BT.656 with embedded syncs */
 	if (enable)
-		tvp5150_write(sd, TVP5150_MISC_CTL, val);
+		tvp5150_write(sd, TVP5150_MISC_CTL, 0x09);
 	else
 		tvp5150_write(sd, TVP5150_MISC_CTL, 0x00);
 
-- 
2.5.0

