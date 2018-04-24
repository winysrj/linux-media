Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:37168 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750766AbeDXX5M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 19:57:12 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH] rcar-vin: enable field toggle after a set number of lines for Gen3
Date: Wed, 25 Apr 2018 01:56:52 +0200
Message-Id: <20180424235652.24672-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VIN Gen3 hardware don't have Line Post-Clip capabilities as VIN Gen2
hardware have. To protect against writing outside the capture window
enable field toggle after a set number of lines have been captured.

Capturing outside the allocated capture buffer where observed on R-Car
Gen3 Salvator-XS H3 from the CVBS input if the standard is
misconfigured. That is if a PAL source is connected to the system but
the adv748x standard is set to NTSC. In this case the format reported by
the adv748x is 720x480 and that is what is used for the media pipeline.
The PAL source generates frames in the format of 720x576 and the field
is not toggled until the VSYNC is detected and at that time data have
already been written outside the allocated capture buffer.

With this change the capture in the situation described above results in
garbage frames but that is far better then writing outside the capture
buffer.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index ac07f99e3516a620..b41ba9a4a2b3ac90 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -124,7 +124,9 @@
 #define VNDMR2_VPS		(1 << 30)
 #define VNDMR2_HPS		(1 << 29)
 #define VNDMR2_FTEV		(1 << 17)
+#define VNDMR2_FTEH		(1 << 16)
 #define VNDMR2_VLV(n)		((n & 0xf) << 12)
+#define VNDMR2_HLV(n)		((n) & 0xfff)
 
 /* Video n CSI2 Interface Mode Register (Gen3) */
 #define VNCSI_IFMD_DES1		(1 << 26)
@@ -612,8 +614,9 @@ void rvin_crop_scale_comp(struct rvin_dev *vin)
 
 static int rvin_setup(struct rvin_dev *vin)
 {
-	u32 vnmc, dmr, dmr2, interrupts;
+	u32 vnmc, dmr, dmr2, interrupts, lines;
 	bool progressive = false, output_is_yuv = false, input_is_yuv = false;
+	bool halfsize = false;
 
 	switch (vin->format.field) {
 	case V4L2_FIELD_TOP:
@@ -628,12 +631,15 @@ static int rvin_setup(struct rvin_dev *vin)
 		/* Use BT if video standard can be read and is 60 Hz format */
 		if (!vin->info->use_mc && vin->std & V4L2_STD_525_60)
 			vnmc = VNMC_IM_FULL | VNMC_FOC;
+		halfsize = true;
 		break;
 	case V4L2_FIELD_INTERLACED_TB:
 		vnmc = VNMC_IM_FULL;
+		halfsize = true;
 		break;
 	case V4L2_FIELD_INTERLACED_BT:
 		vnmc = VNMC_IM_FULL | VNMC_FOC;
+		halfsize = true;
 		break;
 	case V4L2_FIELD_NONE:
 		vnmc = VNMC_IM_ODD_EVEN;
@@ -676,11 +682,15 @@ static int rvin_setup(struct rvin_dev *vin)
 		break;
 	}
 
-	/* Enable VSYNC Field Toogle mode after one VSYNC input */
-	if (vin->info->model == RCAR_GEN3)
-		dmr2 = VNDMR2_FTEV;
-	else
+	if (vin->info->model == RCAR_GEN3) {
+		/* Enable HSYNC Field Toggle mode after height HSYNC inputs. */
+		lines = vin->format.height / (halfsize ? 2 : 1);
+		dmr2 = VNDMR2_FTEH | VNDMR2_HLV(lines);
+		vin_dbg(vin, "Field Toogle after %u lines\n", lines);
+	} else {
+		/* Enable VSYNC Field Toogle mode after one VSYNC input. */
 		dmr2 = VNDMR2_FTEV | VNDMR2_VLV(1);
+	}
 
 	/* Hsync Signal Polarity Select */
 	if (!(vin->mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
-- 
2.17.0
