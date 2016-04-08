Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51942 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbcDHTg1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2016 15:36:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: javier@osg.samsung.com, sakari.ailus@iki.fi
Subject: [PATCH 3/3] Add support for RGB332 format
Date: Fri,  8 Apr 2016 22:36:14 +0300
Message-Id: <1460144174-25569-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1460144174-25569-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1460144174-25569-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 raw2rgbpnm.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/raw2rgbpnm.c b/raw2rgbpnm.c
index ac3ee31feb8e..0cffcced928a 100644
--- a/raw2rgbpnm.c
+++ b/raw2rgbpnm.c
@@ -432,6 +432,21 @@ static void raw_to_rgb(const struct format_info *info,
 		}
 		free(buf);
 		break;
+	case V4L2_PIX_FMT_RGB332:
+		for (src_y = 0, dst_y = 0; dst_y < src_size[1]; src_y++, dst_y++) {
+			for (src_x = 0, dst_x = 0; dst_x < src_size[0]; ) {
+				pixel = src[dst_y*src_stride + dst_x];
+				r = (pixel << 0) & 0xe0;
+				g = (pixel << 3) & 0xe0;
+				b = (pixel << 6) & 0xc0;
+				rgb[src_y*rgb_stride+3*src_x+0] = swaprb ? b : r;
+				rgb[src_y*rgb_stride+3*src_x+1] = g;
+				rgb[src_y*rgb_stride+3*src_x+2] = swaprb ? r : b;
+				src_x++;
+				dst_x++;
+			}
+		}
+		break;
 	case V4L2_PIX_FMT_RGB555:
 		for (src_y = 0, dst_y = 0; dst_y < src_size[1]; src_y++, dst_y++) {
 			for (src_x = 0, dst_x = 0; dst_x < src_size[0]; ) {
-- 
2.7.3

