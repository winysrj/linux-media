Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33300 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281AbcDNQSG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Apr 2016 12:18:06 -0400
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	ian.molton@codethink.co.uk, lars@metafoo.de,
	william.towle@codethink.co.uk,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Subject: [PATCH v3 3/7] media: rcar_vin: Use correct pad number in try_fmt
Date: Thu, 14 Apr 2016 18:17:46 +0200
Message-Id: <1460650670-20849-4-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1460650670-20849-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1460650670-20849-1-git-send-email-ulrich.hecht+renesas@gmail.com>
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
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index a752171..43aec3c 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -97,7 +97,7 @@ static int __rvin_try_format_sensor(struct rvin_dev *vin,
 					struct rvin_sensor *sensor)
 {
 	struct v4l2_subdev *sd;
-	struct v4l2_subdev_pad_config pad_cfg;
+	struct v4l2_subdev_pad_config *pad_cfg;
 	struct v4l2_subdev_format format = {
 		.which = which,
 	};
@@ -105,12 +105,18 @@ static int __rvin_try_format_sensor(struct rvin_dev *vin,
 
 	sd = vin_to_sd(vin);
 
+	pad_cfg = v4l2_subdev_alloc_pad_config(sd);
+	if (pad_cfg == NULL)
+		return -ENOMEM;
+
 	v4l2_fill_mbus_format(&format.format, pix, vin->sensor.code);
 
+	format.pad = vin->src_pad_idx;
+
 	ret = v4l2_device_call_until_err(sd->v4l2_dev, 0, pad, set_fmt,
-					 &pad_cfg, &format);
+					 pad_cfg, &format);
 	if (ret < 0)
-		return ret;
+		goto cleanup;
 
 	v4l2_fill_pix_format(pix, &format.format);
 
@@ -119,6 +125,8 @@ static int __rvin_try_format_sensor(struct rvin_dev *vin,
 
 	vin_dbg(vin, "Sensor format: %ux%u\n", sensor->width, sensor->height);
 
+cleanup:
+	v4l2_subdev_free_pad_config(pad_cfg);
 	return 0;
 }
 
-- 
2.7.4

