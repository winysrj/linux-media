Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:57013 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162Ab2EIV7Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2012 17:59:16 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 67F8518B012
	for <linux-media@vger.kernel.org>; Wed,  9 May 2012 23:59:14 +0200 (CEST)
Date: Wed, 9 May 2012 23:59:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L: sh_mobile_ceu_camera: don't fail TRY_FMT
Message-ID: <Pine.LNX.4.64.1205092358150.8599@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VIDIOC_TRY_FMT shouldn't fail if the user requests an unsupported pixel
format. Instead the driver should replace it with a supported one. Fix the
sh_mobile_ceu_camera driver accordingly.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/sh_mobile_ceu_camera.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 2ffeb21..9830104 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -1858,8 +1858,12 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 
 	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
 	if (!xlate) {
-		dev_warn(icd->parent, "Format %x not found\n", pixfmt);
-		return -EINVAL;
+		xlate = icd->current_fmt;
+		dev_warn(icd->parent, "Format %x not found, keeping %x\n",
+			 pixfmt, xlate->host_fmt->fourcc);
+		pixfmt = xlate->host_fmt->fourcc;
+		pix->pixelformat = pixfmt;
+		pix->colorspace = icd->colorspace;
 	}
 
 	/* FIXME: calculate using depth and bus width */
-- 
1.7.2.5

