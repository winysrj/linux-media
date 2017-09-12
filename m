Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:59252 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750992AbdILUJj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 16:09:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] s3c-camif: fix out-of-bounds array access
Date: Tue, 12 Sep 2017 22:09:18 +0200
Message-Id: <20170912200932.3634089-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While experimenting with older compiler versions, I ran
into a warning that no longer shows up on gcc-4.8 or newer:

drivers/media/platform/s3c-camif/camif-capture.c: In function '__camif_subdev_try_format':
drivers/media/platform/s3c-camif/camif-capture.c:1265:25: error: array subscript is below array bounds

This is an off-by-one bug, leading to an access before the start of the
array, while newer compilers silently assume this undefined behavior
cannot happen and leave the loop at index 0 if no other entry matches.

Since the code is not only wrong, but also has no effect besides the
out-of-bounds access, this patch just removes it.

I found an existing gcc bug for it and added a reduced version
of the function there.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=69249#c3
Fixes: babde1c243b2 ("[media] V4L: Add driver for S3C24XX/S3C64XX SoC series camera interface")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/s3c-camif/camif-capture.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index 25c7a7d42292..c6921f6a5a6a 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -1256,17 +1256,10 @@ static void __camif_subdev_try_format(struct camif_dev *camif,
 {
 	const struct s3c_camif_variant *variant = camif->variant;
 	const struct vp_pix_limits *pix_lim;
-	int i = ARRAY_SIZE(camif_mbus_formats);
 
 	/* FIXME: constraints against codec or preview path ? */
 	pix_lim = &variant->vp_pix_limits[VP_CODEC];
 
-	while (i-- >= 0)
-		if (camif_mbus_formats[i] == mf->code)
-			break;
-
-	mf->code = camif_mbus_formats[i];
-
 	if (pad == CAMIF_SD_PAD_SINK) {
 		v4l_bound_align_image(&mf->width, 8, CAMIF_MAX_PIX_WIDTH,
 				      ffs(pix_lim->out_width_align) - 1,
-- 
2.9.0
