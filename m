Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46481 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932667AbcLHWW3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2016 17:22:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 6/6] v4l: tvp5150: Don't override output pinmuxing at stream on/off time
Date: Fri,  9 Dec 2016 00:22:46 +0200
Message-Id: <1481235766-24469-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1481235766-24469-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1481235766-24469-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The s_stream() handler incorrectly writes the whole MISC_CTL register to
enable or disable the outputs, overriding the output pinmuxing
configuration. Fix it to only touch the output enable bits.

The CONF_SHARED_PIN register is also written by the same function,
resulting in muxing the INTREQ signal instead of the VBLK/GPCL signal on
the INTREQ/GPCL/VBLK pin. As the driver doesn't support interrupts this
is obviously incorrect, and breaks operation on other devices. Fix it by
removing the write.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/tvp5150.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 18260849fe5a..9f1104b7c2cd 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1058,22 +1058,27 @@ static const struct media_entity_operations tvp5150_sd_media_ops = {
 static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct tvp5150 *decoder = to_tvp5150(sd);
-	/* Output format: 8-bit ITU-R BT.656 with embedded syncs */
-	int val = TVP5150_MISC_CTL_YCBCR_OE | TVP5150_MISC_CTL_CLOCK_OE;
-
-	/* Output format: 8-bit 4:2:2 YUV with discrete sync */
-	if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
-		val = TVP5150_MISC_CTL_YCBCR_OE | TVP5150_MISC_CTL_SYNC_OE
-		    | TVP5150_MISC_CTL_CLOCK_OE;
+	int val;
 
-	/* Initializes TVP5150 to its default values */
-	/* # set PCLK (27MHz) */
-	tvp5150_write(sd, TVP5150_CONF_SHARED_PIN, 0x00);
+	/* Enable or disable the video output signals. */
+	val = tvp5150_read(sd, TVP5150_MISC_CTL);
+	if (val < 0)
+		return val;
+
+	val &= ~(TVP5150_MISC_CTL_YCBCR_OE | TVP5150_MISC_CTL_SYNC_OE |
+		 TVP5150_MISC_CTL_CLOCK_OE);
+
+	if (enable) {
+		/*
+		 * Enable the YCbCr and clock outputs. In discrete sync mode
+		 * (non-BT.656) additionally enable the the sync outputs.
+		 */
+		val |= TVP5150_MISC_CTL_YCBCR_OE | TVP5150_MISC_CTL_CLOCK_OE;
+		if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
+			val |= TVP5150_MISC_CTL_SYNC_OE;
+	}
 
-	if (enable)
-		tvp5150_write(sd, TVP5150_MISC_CTL, val);
-	else
-		tvp5150_write(sd, TVP5150_MISC_CTL, 0x00);
+	tvp5150_write(sd, TVP5150_MISC_CTL, val);
 
 	return 0;
 }
-- 
Regards,

Laurent Pinchart

