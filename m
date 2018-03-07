Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:31840 "EHLO
        bin-vsp-out-02.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933426AbeCGWFm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 17:05:42 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v12 13/33] rcar-vin: update bytesperline and sizeimage calculation
Date: Wed,  7 Mar 2018 23:04:51 +0100
Message-Id: <20180307220511.9826-14-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180307220511.9826-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180307220511.9826-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove over complicated logic to calculate the value for bytesperline
and sizeimage that was carried over from the soc_camera port. There is
no need to find the max value of bytesperline and sizeimage from
user-space as they are set to 0 before the max_t() operation.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index b76d59be64e0132d..55fa69aa7c454928 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -194,10 +194,6 @@ static int __rvin_try_format(struct rvin_dev *vin,
 		pix->pixelformat = RVIN_DEFAULT_FORMAT;
 	}
 
-	/* Always recalculate */
-	pix->bytesperline = 0;
-	pix->sizeimage = 0;
-
 	/* Limit to source capabilities */
 	ret = __rvin_try_format_source(vin, which, pix, source);
 	if (ret)
@@ -232,10 +228,8 @@ static int __rvin_try_format(struct rvin_dev *vin,
 	v4l_bound_align_image(&pix->width, 2, vin->info->max_width, walign,
 			      &pix->height, 4, vin->info->max_height, 2, 0);
 
-	pix->bytesperline = max_t(u32, pix->bytesperline,
-				  rvin_format_bytesperline(pix));
-	pix->sizeimage = max_t(u32, pix->sizeimage,
-			       rvin_format_sizeimage(pix));
+	pix->bytesperline = rvin_format_bytesperline(pix);
+	pix->sizeimage = rvin_format_sizeimage(pix);
 
 	if (vin->info->model == RCAR_M1 &&
 	    pix->pixelformat == V4L2_PIX_FMT_XBGR32) {
-- 
2.16.2
