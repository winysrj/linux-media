Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:54335 "EHLO
	smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349AbcHOPHR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 11:07:17 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl
Cc: linux-renesas-soc@vger.kernel.org,
	laurent.pinchart@ideasonboard.com,
	sergei.shtylyov@cogentembedded.com,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv3 08/10] [media] rcar-vin: move chip check for pixelformat support
Date: Mon, 15 Aug 2016 17:06:33 +0200
Message-Id: <20160815150635.22637-9-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160815150635.22637-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160815150635.22637-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The check for if the specific pixelformat is supported on the current
chip should happen in VIDIOC_S_FMT and VIDIOC_TRY_FMT and not when we
try to setup the hardware for streaming.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-dma.c  | 8 +++-----
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 5 +++++
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 496aa97..3df3f0c 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -225,11 +225,9 @@ static int rvin_setup(struct rvin_dev *vin)
 		dmr = 0;
 		break;
 	case V4L2_PIX_FMT_XBGR32:
-		if (vin->chip == RCAR_GEN2 || vin->chip == RCAR_H1) {
-			dmr = VNDMR_EXRGB;
-			break;
-		}
-		/* fall through */
+		/* Note: not supported on M1 */
+		dmr = VNDMR_EXRGB;
+		break;
 	default:
 		vin_err(vin, "Invalid pixelformat (0x%x)\n",
 			vin->format.pixelformat);
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 09df396..ef3464d 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -192,6 +192,11 @@ static int __rvin_try_format(struct rvin_dev *vin,
 	pix->sizeimage = max_t(u32, pix->sizeimage,
 			       rvin_format_sizeimage(pix));
 
+	if (vin->chip == RCAR_M1 && pix->pixelformat == V4L2_PIX_FMT_XBGR32) {
+		vin_err(vin, "pixel format XBGR32 not supported on M1\n");
+		return -EINVAL;
+	}
+
 	vin_dbg(vin, "Requested %ux%u Got %ux%u bpl: %d size: %d\n",
 		rwidth, rheight, pix->width, pix->height,
 		pix->bytesperline, pix->sizeimage);
-- 
2.9.2

