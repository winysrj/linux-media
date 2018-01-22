Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:42038 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751093AbeAVKh0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 05:37:26 -0500
Date: Mon, 22 Jan 2018 13:37:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] [media] s3c-camif: array underflow in
 __camif_subdev_try_format()
Message-ID: <20180122103714.GA25044@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The while loop is a post op, "while (i-- >= 0)" so the last iteration
will read camif_mbus_formats[-1] and then the loop will exit with "i"
set to -2 and so we do: "mf->code = camif_mbus_formats[-2];".

I've changed it to a pre-op, I've added a check to ensure we found the
right format and I've removed the "mf->code = camif_mbus_formats[i];"
because that is a no-op anyway.

Fixes: babde1c243b2 ("[media] V4L: Add driver for S3C24XX/S3C64XX SoC series camera interface")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index 437395a61065..012f4b389c55 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -1261,11 +1261,11 @@ static void __camif_subdev_try_format(struct camif_dev *camif,
 	/* FIXME: constraints against codec or preview path ? */
 	pix_lim = &variant->vp_pix_limits[VP_CODEC];
 
-	while (i-- >= 0)
+	while (--i >= 0)
 		if (camif_mbus_formats[i] == mf->code)
 			break;
-
-	mf->code = camif_mbus_formats[i];
+	if (i < 0)
+		return;
 
 	if (pad == CAMIF_SD_PAD_SINK) {
 		v4l_bound_align_image(&mf->width, 8, CAMIF_MAX_PIX_WIDTH,
