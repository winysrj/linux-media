Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:24046 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753186AbeEKOmG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 10:42:06 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 1/2] Revert "media: rcar-vin: enable field toggle after a set number of lines for Gen3"
Date: Fri, 11 May 2018 16:41:25 +0200
Message-Id: <20180511144126.24804-2-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180511144126.24804-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180511144126.24804-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The offending commit was an attempt to fix the issue of writing outside
the capture buffer for VIN Gen3. Unfortunately it only fixed the symptom
of the problem to such a degree I could no longer reproduce it. Revert
the offending commit before a proper fix can be added in a follow-up
patch.

This reverts commit 015060cb7795eac34454696cc9c9f8b76926a401.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index b41ba9a4a2b3ac90..ac07f99e3516a620 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -124,9 +124,7 @@
 #define VNDMR2_VPS		(1 << 30)
 #define VNDMR2_HPS		(1 << 29)
 #define VNDMR2_FTEV		(1 << 17)
-#define VNDMR2_FTEH		(1 << 16)
 #define VNDMR2_VLV(n)		((n & 0xf) << 12)
-#define VNDMR2_HLV(n)		((n) & 0xfff)
 
 /* Video n CSI2 Interface Mode Register (Gen3) */
 #define VNCSI_IFMD_DES1		(1 << 26)
@@ -614,9 +612,8 @@ void rvin_crop_scale_comp(struct rvin_dev *vin)
 
 static int rvin_setup(struct rvin_dev *vin)
 {
-	u32 vnmc, dmr, dmr2, interrupts, lines;
+	u32 vnmc, dmr, dmr2, interrupts;
 	bool progressive = false, output_is_yuv = false, input_is_yuv = false;
-	bool halfsize = false;
 
 	switch (vin->format.field) {
 	case V4L2_FIELD_TOP:
@@ -631,15 +628,12 @@ static int rvin_setup(struct rvin_dev *vin)
 		/* Use BT if video standard can be read and is 60 Hz format */
 		if (!vin->info->use_mc && vin->std & V4L2_STD_525_60)
 			vnmc = VNMC_IM_FULL | VNMC_FOC;
-		halfsize = true;
 		break;
 	case V4L2_FIELD_INTERLACED_TB:
 		vnmc = VNMC_IM_FULL;
-		halfsize = true;
 		break;
 	case V4L2_FIELD_INTERLACED_BT:
 		vnmc = VNMC_IM_FULL | VNMC_FOC;
-		halfsize = true;
 		break;
 	case V4L2_FIELD_NONE:
 		vnmc = VNMC_IM_ODD_EVEN;
@@ -682,15 +676,11 @@ static int rvin_setup(struct rvin_dev *vin)
 		break;
 	}
 
-	if (vin->info->model == RCAR_GEN3) {
-		/* Enable HSYNC Field Toggle mode after height HSYNC inputs. */
-		lines = vin->format.height / (halfsize ? 2 : 1);
-		dmr2 = VNDMR2_FTEH | VNDMR2_HLV(lines);
-		vin_dbg(vin, "Field Toogle after %u lines\n", lines);
-	} else {
-		/* Enable VSYNC Field Toogle mode after one VSYNC input. */
+	/* Enable VSYNC Field Toogle mode after one VSYNC input */
+	if (vin->info->model == RCAR_GEN3)
+		dmr2 = VNDMR2_FTEV;
+	else
 		dmr2 = VNDMR2_FTEV | VNDMR2_VLV(1);
-	}
 
 	/* Hsync Signal Polarity Select */
 	if (!(vin->mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
-- 
2.17.0
