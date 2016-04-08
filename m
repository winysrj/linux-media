Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51939 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbcDHTgU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2016 15:36:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: javier@osg.samsung.com, sakari.ailus@iki.fi
Subject: [PATCH 2/3] Add support for YUV420 format
Date: Fri,  8 Apr 2016 22:36:13 +0300
Message-Id: <1460144174-25569-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1460144174-25569-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1460144174-25569-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 raw2rgbpnm.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/raw2rgbpnm.c b/raw2rgbpnm.c
index aa4127330ebe..ac3ee31feb8e 100644
--- a/raw2rgbpnm.c
+++ b/raw2rgbpnm.c
@@ -215,6 +215,7 @@ static void raw_to_rgb(const struct format_info *info,
 	unsigned int src_stride = src_size[0] * info->bpp / 8;
 	unsigned int rgb_stride = src_size[0] * 3;
 	unsigned char *src_luma, *src_chroma;
+	unsigned char *src_cb, *src_cr;
 	unsigned char *buf;
 	unsigned int pixel;
 	int r, g, b, a, cr, cb;
@@ -324,6 +325,28 @@ static void raw_to_rgb(const struct format_info *info,
 		}
 		break;
 
+	case V4L2_PIX_FMT_YUV420:
+		src_luma = src;
+		src_cb = &src[src_size[0] * src_size[1]];
+		src_cr = &src[src_size[0] * src_size[1] / 4 * 5];
+		src_stride = src_stride * 8 / 12;
+
+		for (src_y = 0, dst_y = 0; dst_y < src_size[1]; src_y++, dst_y++) {
+			for (dst_x = 0, src_x = 0; dst_x < src_size[0]; ) {
+				a  = src_luma[dst_y*src_stride + dst_x];
+				cb = src_cb[(dst_y/2)*src_stride/2 + dst_x/2];
+				cr = src_cr[(dst_y/2)*src_stride/2 + dst_x/2];
+
+				yuv_to_rgb(a,cb,cr, &r, &g, &b);
+				rgb[src_y*rgb_stride+3*src_x+0] = swaprb ? b : r;
+				rgb[src_y*rgb_stride+3*src_x+1] = g;
+				rgb[src_y*rgb_stride+3*src_x+2] = swaprb ? r : b;
+				src_x++;
+				dst_x++;
+			}
+		}
+		break;
+
 	case V4L2_PIX_FMT_Y12:
 		shift += 2;
 	case V4L2_PIX_FMT_Y10:
-- 
2.7.3

