Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:33653 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752249AbeCZVqm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 17:46:42 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v13 14/33] rcar-vin: align pixelformat check
Date: Mon, 26 Mar 2018 23:44:37 +0200
Message-Id: <20180326214456.6655-15-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180326214456.6655-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180326214456.6655-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the pixelformat is not supported it should not fail but be set to
something that works. While we are at it move the two different
checks of the pixelformat to the same statement.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 21d765ec9594f95c..8dbd764883976ad1 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -189,12 +189,10 @@ static int __rvin_try_format(struct rvin_dev *vin,
 	u32 walign;
 	int ret;
 
-	/* If requested format is not supported fallback to the default */
-	if (!rvin_format_from_pixel(pix->pixelformat)) {
-		vin_dbg(vin, "Format 0x%x not found, using default 0x%x\n",
-			pix->pixelformat, RVIN_DEFAULT_FORMAT);
+	if (!rvin_format_from_pixel(pix->pixelformat) ||
+	    (vin->info->model == RCAR_M1 &&
+	     pix->pixelformat == V4L2_PIX_FMT_XBGR32))
 		pix->pixelformat = RVIN_DEFAULT_FORMAT;
-	}
 
 	/* Limit to source capabilities */
 	ret = __rvin_try_format_source(vin, which, pix, source);
@@ -233,12 +231,6 @@ static int __rvin_try_format(struct rvin_dev *vin,
 	pix->bytesperline = rvin_format_bytesperline(pix);
 	pix->sizeimage = rvin_format_sizeimage(pix);
 
-	if (vin->info->model == RCAR_M1 &&
-	    pix->pixelformat == V4L2_PIX_FMT_XBGR32) {
-		vin_err(vin, "pixel format XBGR32 not supported on M1\n");
-		return -EINVAL;
-	}
-
 	vin_dbg(vin, "Format %ux%u bpl: %d size: %d\n",
 		pix->width, pix->height, pix->bytesperline, pix->sizeimage);
 
-- 
2.16.2
