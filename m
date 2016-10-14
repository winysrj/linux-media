Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59142 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757038AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geunyoung Kim <nenggun.kim@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 54/57] [media] platform: don't break long lines
Date: Fri, 14 Oct 2016 17:20:42 -0300
Message-Id: <68fc2da43db37e66ec6a3e1ff0e750b73c3b0f42.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/mx2_emmaprp.c | 3 +--
 drivers/media/platform/pxa_camera.c  | 6 ++----
 drivers/media/platform/via-camera.c  | 7 ++-----
 3 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index e68d271b10af..ea572718a638 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -724,8 +724,7 @@ static int emmaprp_buf_prepare(struct vb2_buffer *vb)
 	q_data = get_q_data(ctx, vb->vb2_queue->type);
 
 	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
-		dprintk(ctx->dev, "%s data will not fit into plane"
-				  "(%lu < %lu)\n", __func__,
+		dprintk(ctx->dev, "%s data will not fit into plane(%lu < %lu)\n", __func__,
 				  vb2_plane_size(vb, 0),
 				  (long)q_data->sizeimage);
 		return -EINVAL;
diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index c12209c701d3..bcdac4932fb1 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -2347,8 +2347,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
 		 * Platform hasn't set available data widths. This is bad.
 		 * Warn and use a default.
 		 */
-		dev_warn(&pdev->dev, "WARNING! Platform hasn't set available "
-			 "data widths, using default 10 bit\n");
+		dev_warn(&pdev->dev, "WARNING! Platform hasn't set available data widths, using default 10 bit\n");
 		pcdev->platform_flags |= PXA_CAMERA_DATAWIDTH_10;
 	}
 	if (pcdev->platform_flags & PXA_CAMERA_DATAWIDTH_8)
@@ -2359,8 +2358,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
 		pcdev->width_flags |= 1 << 9;
 	if (!pcdev->mclk) {
 		dev_warn(&pdev->dev,
-			 "mclk == 0! Please, fix your platform data. "
-			 "Using default 20MHz\n");
+			 "mclk == 0! Please, fix your platform data. Using default 20MHz\n");
 		pcdev->mclk = 20000000;
 	}
 
diff --git a/drivers/media/platform/via-camera.c b/drivers/media/platform/via-camera.c
index 7ca12deba89c..e16f70a5df1d 100644
--- a/drivers/media/platform/via-camera.c
+++ b/drivers/media/platform/via-camera.c
@@ -39,15 +39,12 @@ MODULE_LICENSE("GPL");
 static bool flip_image;
 module_param(flip_image, bool, 0444);
 MODULE_PARM_DESC(flip_image,
-		"If set, the sensor will be instructed to flip the image "
-		"vertically.");
+		"If set, the sensor will be instructed to flip the image vertically.");
 
 static bool override_serial;
 module_param(override_serial, bool, 0444);
 MODULE_PARM_DESC(override_serial,
-		"The camera driver will normally refuse to load if "
-		"the XO 1.5 serial port is enabled.  Set this option "
-		"to force-enable the camera.");
+		"The camera driver will normally refuse to load if the XO 1.5 serial port is enabled.  Set this option to force-enable the camera.");
 
 /*
  * The structure describing our camera.
-- 
2.7.4


