Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:44473 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965647AbdEZKzg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 06:55:36 -0400
From: Sekhar Nori <nsekhar@ti.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, Kevin Hilman <khilman@kernel.org>,
        Alejandro Hernandez <ajhernandez@ti.com>,
        Sekhar Nori <nsekhar@ti.com>
Subject: [PATCH] davinci: vpif_capture: fix default pixel format for BT.656/BT.1120 video
Date: Fri, 26 May 2017 16:25:27 +0530
Message-ID: <20170526105527.10522-1-nsekhar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For both BT.656 and BT.1120 video, the pixel format
used by VPIF is Y/CbCr 4:2:2 in semi-planar format
(Luma in one plane and Chroma in another). This
corresponds to NV16 pixel format.

This is documented in section 36.2.3 of OMAP-L138
Technical Reference Manual, SPRUH77A.

The VPIF driver incorrectly sets the default format
to V4L2_PIX_FMT_YUV422P. Fix it.

Reported-by: Alejandro Hernandez <ajhernandez@ti.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
---
 drivers/media/platform/davinci/vpif_capture.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 44f702752d3a..128e92d1dd5a 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -513,7 +513,7 @@ static int vpif_update_std_info(struct channel_obj *ch)
 	if (ch->vpifparams.iface.if_type == VPIF_IF_RAW_BAYER)
 		common->fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_SBGGR8;
 	else
-		common->fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUV422P;
+		common->fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_NV16;
 
 	common->fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
@@ -917,8 +917,8 @@ static int vpif_enum_fmt_vid_cap(struct file *file, void  *priv,
 		fmt->pixelformat = V4L2_PIX_FMT_SBGGR8;
 	} else {
 		fmt->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		strcpy(fmt->description, "YCbCr4:2:2 YC Planar");
-		fmt->pixelformat = V4L2_PIX_FMT_YUV422P;
+		strcpy(fmt->description, "YCbCr4:2:2 Semi-Planar");
+		fmt->pixelformat = V4L2_PIX_FMT_NV16;
 	}
 	return 0;
 }
@@ -946,8 +946,8 @@ static int vpif_try_fmt_vid_cap(struct file *file, void *priv,
 		if (pixfmt->pixelformat != V4L2_PIX_FMT_SBGGR8)
 			pixfmt->pixelformat = V4L2_PIX_FMT_SBGGR8;
 	} else {
-		if (pixfmt->pixelformat != V4L2_PIX_FMT_YUV422P)
-			pixfmt->pixelformat = V4L2_PIX_FMT_YUV422P;
+		if (pixfmt->pixelformat != V4L2_PIX_FMT_NV16)
+			pixfmt->pixelformat = V4L2_PIX_FMT_NV16;
 	}
 
 	common->fmt.fmt.pix.pixelformat = pixfmt->pixelformat;
-- 
2.9.0
