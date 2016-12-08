Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46484 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932578AbcLHWW2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2016 17:22:28 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 5/6] v4l: tvp5150: Fix comment regarding output pin muxing
Date: Fri,  9 Dec 2016 00:22:45 +0200
Message-Id: <1481235766-24469-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1481235766-24469-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1481235766-24469-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The FID/GLCO/VLK/HVLK and INTREQ/GPCL/VBLK pins are muxed differently
depending on whether the input is an S-Video or composite signal. The
comment that explains the logic doesn't reflect the code. It appears
that the comment is incorrect, as disabling the output data bus in
composite mode makes no sense. Update the comment to match the code.

While at it define macros for the MISC_CTL register bits, the code is
too confusing with numerical values.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/tvp5150.c     | 24 +++++++++++++++++-------
 drivers/media/i2c/tvp5150_reg.h |  9 +++++++++
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 19b79028cac5..18260849fe5a 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -291,8 +291,12 @@ static void tvp5150_selmux(struct v4l2_subdev *sd)
 	tvp5150_write(sd, TVP5150_OP_MODE_CTL, opmode);
 	tvp5150_write(sd, TVP5150_VD_IN_SRC_SEL_1, input);
 
-	/* Svideo should enable YCrCb output and disable GPCL output
-	 * For Composite and TV, it should be the reverse
+	/*
+	 * Setup the FID/GLCO/VLK/HVLK and INTREQ/GPCL/VBLK output signals. For
+	 * S-Video we output the vertical lock (VLK) signal on FID/GLCO/VLK/HVLK
+	 * and set INTREQ/GPCL/VBLK to logic 0. For composite we output the
+	 * field indicator (FID) signal on FID/GLCO/VLK/HVLK and set
+	 * INTREQ/GPCL/VBLK to logic 1.
 	 */
 	val = tvp5150_read(sd, TVP5150_MISC_CTL);
 	if (val < 0) {
@@ -301,9 +305,9 @@ static void tvp5150_selmux(struct v4l2_subdev *sd)
 	}
 
 	if (decoder->input == TVP5150_SVIDEO)
-		val = (val & ~0x40) | 0x10;
+		val = (val & ~TVP5150_MISC_CTL_GPCL) | TVP5150_MISC_CTL_HVLK;
 	else
-		val = (val & ~0x10) | 0x40;
+		val = (val & ~TVP5150_MISC_CTL_HVLK) | ~TVP5150_MISC_CTL_GPCL;
 	tvp5150_write(sd, TVP5150_MISC_CTL, val);
 };
 
@@ -455,7 +459,12 @@ static const struct i2c_reg_value tvp5150_init_enable[] = {
 	},{	/* Automatic offset and AGC enabled */
 		TVP5150_ANAL_CHL_CTL, 0x15
 	},{	/* Activate YCrCb output 0x9 or 0xd ? */
-		TVP5150_MISC_CTL, 0x6f
+		TVP5150_MISC_CTL, TVP5150_MISC_CTL_GPCL |
+				  TVP5150_MISC_CTL_INTREQ_OE |
+				  TVP5150_MISC_CTL_YCBCR_OE |
+				  TVP5150_MISC_CTL_SYNC_OE |
+				  TVP5150_MISC_CTL_VBLANK |
+				  TVP5150_MISC_CTL_CLOCK_OE,
 	},{	/* Activates video std autodetection for all standards */
 		TVP5150_AUTOSW_MSK, 0x0
 	},{	/* Default format: 0x47. For 4:2:2: 0x40 */
@@ -1050,11 +1059,12 @@ static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct tvp5150 *decoder = to_tvp5150(sd);
 	/* Output format: 8-bit ITU-R BT.656 with embedded syncs */
-	int val = 0x09;
+	int val = TVP5150_MISC_CTL_YCBCR_OE | TVP5150_MISC_CTL_CLOCK_OE;
 
 	/* Output format: 8-bit 4:2:2 YUV with discrete sync */
 	if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
-		val = 0x0d;
+		val = TVP5150_MISC_CTL_YCBCR_OE | TVP5150_MISC_CTL_SYNC_OE
+		    | TVP5150_MISC_CTL_CLOCK_OE;
 
 	/* Initializes TVP5150 to its default values */
 	/* # set PCLK (27MHz) */
diff --git a/drivers/media/i2c/tvp5150_reg.h b/drivers/media/i2c/tvp5150_reg.h
index 25a994944918..30a48c28d05a 100644
--- a/drivers/media/i2c/tvp5150_reg.h
+++ b/drivers/media/i2c/tvp5150_reg.h
@@ -9,6 +9,15 @@
 #define TVP5150_ANAL_CHL_CTL         0x01 /* Analog channel controls */
 #define TVP5150_OP_MODE_CTL          0x02 /* Operation mode controls */
 #define TVP5150_MISC_CTL             0x03 /* Miscellaneous controls */
+#define TVP5150_MISC_CTL_VBLK_GPCL	BIT(7)
+#define TVP5150_MISC_CTL_GPCL		BIT(6)
+#define TVP5150_MISC_CTL_INTREQ_OE	BIT(5)
+#define TVP5150_MISC_CTL_HVLK		BIT(4)
+#define TVP5150_MISC_CTL_YCBCR_OE	BIT(3)
+#define TVP5150_MISC_CTL_SYNC_OE	BIT(2)
+#define TVP5150_MISC_CTL_VBLANK		BIT(1)
+#define TVP5150_MISC_CTL_CLOCK_OE	BIT(0)
+
 #define TVP5150_AUTOSW_MSK           0x04 /* Autoswitch mask: TVP5150A / TVP5150AM */
 
 /* Reserved 05h */
-- 
Regards,

Laurent Pinchart

