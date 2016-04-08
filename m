Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51936 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758885AbcDHTgT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2016 15:36:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: javier@osg.samsung.com, sakari.ailus@iki.fi
Subject: [PATCH 1/3] Add support for NV16 and NV61 formats
Date: Fri,  8 Apr 2016 22:36:12 +0300
Message-Id: <1460144174-25569-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1460144174-25569-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1460144174-25569-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 raw2rgbpnm.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/raw2rgbpnm.c b/raw2rgbpnm.c
index 96835c3591f5..aa4127330ebe 100644
--- a/raw2rgbpnm.c
+++ b/raw2rgbpnm.c
@@ -81,6 +81,8 @@ static const struct format_info {
 	{ V4L2_PIX_FMT_Y41P,     12,  "Y41P (12  YUV 4:1:1)", 0, 0 },
 	{ V4L2_PIX_FMT_NV12,     12,  "NV12 (12  Y/CbCr 4:2:0)", 0, 0 },
 	{ V4L2_PIX_FMT_NV21,     12,  "NV21 (12  Y/CrCb 4:2:0)", 0, 0 },
+	{ V4L2_PIX_FMT_NV16,     16,  "NV16 (16  Y/CbCr 4:2:2)", 0, 0 },
+	{ V4L2_PIX_FMT_NV61,     16,  "NV61 (16  Y/CrCb 4:2:2)", 0, 1 },
 	{ V4L2_PIX_FMT_YUV410,   -1,  "YUV410 (9  YUV 4:1:0)", 0, 0 },
 	{ V4L2_PIX_FMT_YUV420,   12,  "YUV420 (12  YUV 4:2:0)", 0, 0 },
 	{ V4L2_PIX_FMT_YYUV,     12,  "YYUV (16  YUV 4:2:2)", 0, 0 },
@@ -289,6 +291,39 @@ static void raw_to_rgb(const struct format_info *info,
 		}
 		break;
 
+	case V4L2_PIX_FMT_NV16:
+	case V4L2_PIX_FMT_NV61:
+		src_luma = src;
+		src_chroma = &src[src_size[0] * src_size[1]];
+		src_stride = src_stride * 8 / 16;
+
+		cb_pos = info->cb_pos;
+		cr_pos = 1 - info->cb_pos;
+
+		for (src_y = 0, dst_y = 0; dst_y < src_size[1]; src_y++, dst_y++) {
+			for (dst_x = 0, src_x = 0; dst_x < src_size[0]; ) {
+				cb = src_chroma[dst_y*src_stride + dst_x + cb_pos];
+				cr = src_chroma[dst_y*src_stride + dst_x + cr_pos];
+
+				a  = src_luma[dst_y*src_stride + dst_x];
+				yuv_to_rgb(a,cb,cr, &r, &g, &b);
+				rgb[src_y*rgb_stride+3*src_x+0] = swaprb ? b : r;
+				rgb[src_y*rgb_stride+3*src_x+1] = g;
+				rgb[src_y*rgb_stride+3*src_x+2] = swaprb ? r : b;
+				src_x++;
+				dst_x++;
+
+				a  = src_luma[dst_y*src_stride + dst_x];
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

