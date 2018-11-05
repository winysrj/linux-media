Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:56603 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729430AbeKFAlM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 19:41:12 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/3] media: imx: lift CSI width alignment restriction
Date: Mon,  5 Nov 2018 16:20:55 +0100
Message-Id: <20181105152055.31254-3-p.zabel@pengutronix.de>
In-Reply-To: <20181105152055.31254-1-p.zabel@pengutronix.de>
References: <20181105152055.31254-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CSI subdevice shouldn't have to care about IDMAC line start
address alignment. With compose rectangle support in the capture
driver, it doesn't have to anymore.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/media/imx/imx-media-capture.c |  9 ++++-----
 drivers/staging/media/imx/imx-media-csi.c     |  2 +-
 drivers/staging/media/imx/imx-media-utils.c   | 15 ++++++++++++---
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
index 2d49d9573056..f87d6e8019e5 100644
--- a/drivers/staging/media/imx/imx-media-capture.c
+++ b/drivers/staging/media/imx/imx-media-capture.c
@@ -204,10 +204,9 @@ static int capture_g_fmt_vid_cap(struct file *file, void *fh,
 }
 
 static int __capture_try_fmt_vid_cap(struct capture_priv *priv,
-				     struct v4l2_subev_format *fmt_src,
+				     struct v4l2_subdev_format *fmt_src,
 				     struct v4l2_format *f)
 {
-	struct capture_priv *priv = video_drvdata(file);
 	const struct imx_media_pixfmt *cc, *cc_src;
 
 	cc_src = imx_media_find_ipu_format(fmt_src->format.code, CS_SEL_ANY);
@@ -250,7 +249,7 @@ static int capture_try_fmt_vid_cap(struct file *file, void *fh,
 	if (ret)
 		return ret;
 
-	return __capture_try_fmt(priv, &fmt_src, f);
+	return __capture_try_fmt_vid_cap(priv, &fmt_src, f);
 }
 
 static int capture_s_fmt_vid_cap(struct file *file, void *fh,
@@ -280,8 +279,8 @@ static int capture_s_fmt_vid_cap(struct file *file, void *fh,
 					      CS_SEL_ANY, true);
 	priv->vdev.compose.left = 0;
 	priv->vdev.compose.top = 0;
-	priv->vdev.compose.width = fmt_src.width;
-	priv->vdev.compose.height = fmt_src.height;
+	priv->vdev.compose.width = fmt_src.format.width;
+	priv->vdev.compose.height = fmt_src.format.height;
 
 	return 0;
 }
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index c4523afe7b48..d39682192a67 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -41,7 +41,7 @@
 #define MIN_H       144
 #define MAX_W      4096
 #define MAX_H      4096
-#define W_ALIGN    4 /* multiple of 16 pixels */
+#define W_ALIGN    1 /* multiple of 2 pixels */
 #define H_ALIGN    1 /* multiple of 2 lines */
 #define S_ALIGN    1 /* multiple of 2 */
 
diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
index 0eaa353d5cb3..5f110d90a4ef 100644
--- a/drivers/staging/media/imx/imx-media-utils.c
+++ b/drivers/staging/media/imx/imx-media-utils.c
@@ -580,6 +580,7 @@ int imx_media_mbus_fmt_to_pix_fmt(struct v4l2_pix_format *pix,
 				  struct v4l2_mbus_framefmt *mbus,
 				  const struct imx_media_pixfmt *cc)
 {
+	u32 width;
 	u32 stride;
 
 	if (!cc) {
@@ -602,9 +603,16 @@ int imx_media_mbus_fmt_to_pix_fmt(struct v4l2_pix_format *pix,
 		cc = imx_media_find_mbus_format(code, CS_SEL_YUV, false);
 	}
 
-	stride = cc->planar ? mbus->width : (mbus->width * cc->bpp) >> 3;
+	/* Round up width for minimum burst size */
+	width = round_up(mbus->width, 8);
 
-	pix->width = mbus->width;
+	/* Round up stride for IDMAC line start address alignment */
+	if (cc->planar)
+		stride = round_up(width, 16);
+	else
+		stride = round_up((width * cc->bpp) >> 3, 8);
+
+	pix->width = width;
 	pix->height = mbus->height;
 	pix->pixelformat = cc->fourcc;
 	pix->colorspace = mbus->colorspace;
@@ -613,7 +621,8 @@ int imx_media_mbus_fmt_to_pix_fmt(struct v4l2_pix_format *pix,
 	pix->quantization = mbus->quantization;
 	pix->field = mbus->field;
 	pix->bytesperline = stride;
-	pix->sizeimage = (pix->width * pix->height * cc->bpp) >> 3;
+	pix->sizeimage = cc->planar ? ((stride * pix->height * cc->bpp) >> 3) :
+			 stride * pix->height;
 
 	return 0;
 }
-- 
2.19.1
