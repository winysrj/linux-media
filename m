Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:56421 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727526AbeJEDAO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 23:00:14 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 1/3] rcar-vin: align width before stream start
Date: Thu,  4 Oct 2018 22:04:00 +0200
Message-Id: <20181004200402.15113-2-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20181004200402.15113-1-niklas.soderlund+renesas@ragnatech.se>
References: <20181004200402.15113-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of aligning the image width to match the image stride at stream
start time do so when configuring the format. This allows the format
width to strictly match the image stride which is useful when enabling
scaling on Gen3.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-dma.c  | 5 +----
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 9 +++++++++
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 92323310f7352147..e752bc86e40153b1 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -597,10 +597,7 @@ void rvin_crop_scale_comp(struct rvin_dev *vin)
 	if (vin->info->model != RCAR_GEN3)
 		rvin_crop_scale_comp_gen2(vin);
 
-	if (vin->format.pixelformat == V4L2_PIX_FMT_NV16)
-		rvin_write(vin, ALIGN(vin->format.width, 0x20), VNIS_REG);
-	else
-		rvin_write(vin, ALIGN(vin->format.width, 0x10), VNIS_REG);
+	rvin_write(vin, vin->format.width, VNIS_REG);
 }
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index dc77682b47857c97..94bc559a0cb1e47a 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -96,6 +96,15 @@ static void rvin_format_align(struct rvin_dev *vin, struct v4l2_pix_format *pix)
 	     pix->pixelformat == V4L2_PIX_FMT_XBGR32))
 		pix->pixelformat = RVIN_DEFAULT_FORMAT;
 
+	switch (pix->pixelformat) {
+	case V4L2_PIX_FMT_NV16:
+		pix->width = ALIGN(pix->width, 0x20);
+		break;
+	default:
+		pix->width = ALIGN(pix->width, 0x10);
+		break;
+	}
+
 	switch (pix->field) {
 	case V4L2_FIELD_TOP:
 	case V4L2_FIELD_BOTTOM:
-- 
2.19.0
