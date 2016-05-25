Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:35803 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbcEYTTv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2016 15:19:51 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
To: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl
Cc: linux-renesas-soc@vger.kernel.org,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
	William Towle <william.towle@codethink.co.uk>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 2/8] media: rcar_vin: Use correct pad number in try_fmt
Date: Wed, 25 May 2016 21:10:03 +0200
Message-Id: <1464203409-1279-3-git-send-email-niklas.soderlund@ragnatech.se>
In-Reply-To: <1464203409-1279-1-git-send-email-niklas.soderlund@ragnatech.se>
References: <1464203409-1279-1-git-send-email-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>

Fix rcar_vin_try_fmt's use of an inappropriate pad number when calling
the subdev set_fmt function - for the ADV7612, IDs should be non-zero.

Signed-off-by: William Towle <william.towle@codethink.co.uk>
Reviewed-by: Rob Taylor <rob.taylor@codethink.co.uk>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
[uli: adapted to rcar-vin rewrite]
Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 929816b..3788f8a 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -98,7 +98,7 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 					struct rvin_source_fmt *source)
 {
 	struct v4l2_subdev *sd;
-	struct v4l2_subdev_pad_config pad_cfg;
+	struct v4l2_subdev_pad_config *pad_cfg;
 	struct v4l2_subdev_format format = {
 		.which = which,
 	};
@@ -108,10 +108,16 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 
 	v4l2_fill_mbus_format(&format.format, pix, vin->source.code);
 
+	pad_cfg = v4l2_subdev_alloc_pad_config(sd);
+	if (pad_cfg == NULL)
+		return -ENOMEM;
+
+	format.pad = vin->src_pad_idx;
+
 	ret = v4l2_device_call_until_err(sd->v4l2_dev, 0, pad, set_fmt,
-					 &pad_cfg, &format);
+					 pad_cfg, &format);
 	if (ret < 0)
-		return ret;
+		goto cleanup;
 
 	v4l2_fill_pix_format(pix, &format.format);
 
@@ -121,6 +127,8 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 	vin_dbg(vin, "Source resolution: %ux%u\n", source->width,
 		source->height);
 
+cleanup:
+	v4l2_subdev_free_pad_config(pad_cfg);
 	return 0;
 }
 
-- 
2.8.2

