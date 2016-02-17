Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38210 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161552AbcBQPtN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 10:49:13 -0500
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: linux-renesas-soc@vger.kernel.org, niklas.soderlund@ragnatech.se
Cc: linux-media@vger.kernel.org, magnus.damm@gmail.com,
	laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	ian.molton@codethink.co.uk, lars@metafoo.de,
	william.towle@codethink.co.uk,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH/RFC 4/9] media: rcar_vin: Use correct pad number in try_fmt
Date: Wed, 17 Feb 2016 16:48:40 +0100
Message-Id: <1455724125-13004-5-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1455724125-13004-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1455724125-13004-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix rcar_vin_try_fmt's use of an inappropriate pad number when calling
the subdev set_fmt function - for the ADV7612, IDs should be non-zero.

Signed-off-by: William Towle <william.towle@codethink.co.uk>
Reviewed-by: Rob Taylor <rob.taylor@codethink.co.uk>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
[uli: adapted to rcar-vin rewrite]
Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index c667ce5..70dc928 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -294,7 +294,7 @@ static int __rvin_dma_try_format_sensor(struct rvin_dev *vin,
 		struct rvin_sensor *sensor)
 {
 	struct v4l2_subdev *sd;
-	struct v4l2_subdev_pad_config pad_cfg;
+	struct v4l2_subdev_pad_config *pad_cfg;
 	struct v4l2_subdev_format format = {
 		.which = which,
 	};
@@ -303,15 +303,20 @@ static int __rvin_dma_try_format_sensor(struct rvin_dev *vin,
 
 	sd = vin_to_sd(vin);
 
+	pad_cfg = v4l2_subdev_alloc_pad_config(sd);
+	if (pad_cfg == NULL)
+		return -ENOMEM;
+
 	/* Requested */
 	rwidth = pix->width;
 	rheight = pix->height;
 
 	v4l2_fill_mbus_format(&format.format, pix, info->code);
+	format.pad = vin->src_pad_idx;
 	ret = v4l2_device_call_until_err(sd->v4l2_dev, 0, pad, set_fmt,
-			&pad_cfg, &format);
+			pad_cfg, &format);
 	if (ret < 0)
-		return ret;
+		goto cleanup;
 	v4l2_fill_pix_format(pix, &format.format);
 
 	/* Sensor */
@@ -325,7 +330,7 @@ static int __rvin_dma_try_format_sensor(struct rvin_dev *vin,
 		vin_dbg(vin, "sensor format mismatch, see if we can scale\n");
 		ret = rvin_scale_try(vin, pix, rwidth, rheight);
 		if (ret)
-			return ret;
+			goto cleanup;
 	}
 
 	/* Store sensor output format */
@@ -334,6 +339,8 @@ static int __rvin_dma_try_format_sensor(struct rvin_dev *vin,
 		sensor->height = sheight;
 	}
 
+cleanup:
+	v4l2_subdev_free_pad_config(pad_cfg);
 	return 0;
 }
 
-- 
2.6.4

