Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54863 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031442Ab3HIXC1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 19:02:27 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: [PATCH/RFC v3 07/19] video: display: Add pixel coding definitions
Date: Sat, 10 Aug 2013 01:03:06 +0200
Message-Id: <1376089398-13322-8-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pixel codings describe how pixels are transmitted on a physical bus. The
information can be communicated between drivers to configure devices.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/video/display.h | 120 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 120 insertions(+)

diff --git a/include/video/display.h b/include/video/display.h
index 36ff637..ba319d6 100644
--- a/include/video/display.h
+++ b/include/video/display.h
@@ -18,6 +18,126 @@
 #include <linux/module.h>
 #include <media/media-entity.h>
 
+#define DISPLAY_PIXEL_CODING(option, type, from, to, variant) \
+	(((option) << 17) | ((type) << 13) | ((variant) << 10) | \
+	 ((to) << 5) | (from))
+
+#define DISPLAY_PIXEL_CODING_FROM(coding)	((coding) & 0x1f)
+#define DISPLAY_PIXEL_CODING_TO(coding)		(((coding) >> 5) & 0x1f)
+#define DISPLAY_PIXEL_CODING_VARIANT(coding)	(((coding) >> 10) & 7)
+#define DISPLAY_PIXEL_CODING_TYPE(coding)	(((coding) >> 13) & 0xf)
+
+#define DISPLAY_PIXEL_CODING_TYPE_DBI	0
+#define DISPLAY_PIXEL_CODING_TYPE_DPI	1
+
+/* DBI pixel codings. */
+#define DISPLAY_PIXEL_CODING_DBI(from, to, variant) \
+	DISPLAY_PIXEL_CODING_TYPE(DISPLAY_PIXEL_CODING_TYPE_DBI, \
+				  from, to, variant, 0)
+
+/* Standard DBI codings, defined in the DBI specification. */
+/*   17   16   15   14   13   12   11   10    9    8    7    6    5    4    3    2    1    0 */
+/*    -    -    -    -    -    -    -    -    -    - R0,2 R0,1 R0,0 G0,2 G0,1 G0,0 B0,1 B0,0 */
+#define DISPLAY_PIXEL_CODING_DBI_8TO8		DISPLAY_PIXEL_CODING_DBI(8, 8, 0)
+/*    -    -    -    -    -    -    -    -    -    - R0,3 R0,2 R0,1 R0,0 G0,3 G0,2 G0,1 G0,0 */
+/*    -    -    -    -    -    -    -    -    -    - B0,3 B0,2 B0,1 B0,0 R1,3 R1,2 R1,1 R1,0 */
+/*    -    -    -    -    -    -    -    -    -    - G1,3 G1,2 G1,1 G1,0 B1,3 B1,2 B1,1 b1,0 */
+#define DISPLAY_PIXEL_CODING_DBI_12TO8		DISPLAY_PIXEL_CODING_DBI(12, 8, 0)
+/*    -    -    -    -    -    -    -    -    -    - R0,4 R0,3 R0,2 R0,1 R0,0 G0,5 G0,4 G0,3 */
+/*    -    -    -    -    -    -    -    -    -    - G0,2 G0,1 G0,0 B0,4 B0,3 B0,2 B0,1 B0,0 */
+#define DISPLAY_PIXEL_CODING_DBI_16TO8		DISPLAY_PIXEL_CODING_DBI(16, 8, 0)
+/*    -    -    -    -    -    -    -    -    -    - R0,5 R0,4 R0,3 R0,2 R0,1 R0,0    -    - */
+/*    -    -    -    -    -    -    -    -    -    - G0,5 G0,4 G0,3 G0,2 G0,1 G0,0    -    - */
+/*    -    -    -    -    -    -    -    -    -    - B0,5 B0,4 B0,3 B0,2 B0,1 B0,0    -    - */
+#define DISPLAY_PIXEL_CODING_DBI_18TO8		DISPLAY_PIXEL_CODING_DBI(18, 8, 0)
+/*    -    -    -    -    -    -    -    -    -    - R0,7 R0,6 R0,5 R0,4 R0,3 R0,2 R0,1 R0,0 */
+/*    -    -    -    -    -    -    -    -    -    - G0,7 G0,6 G0,5 G0,4 G0,3 G0,2 G0,1 G0,0 */
+/*    -    -    -    -    -    -    -    -    -    - B0,7 B0,6 B0,5 B0,4 B0,3 B0,2 B0,1 B0,0 */
+#define DISPLAY_PIXEL_CODING_DBI_24TO8		DISPLAY_PIXEL_CODING_DBI(24, 8, 0)
+/*    -    -    -    -    -    -    -    -    - R0,5 R0,4 R0,3 R0,2 R0,1 R0,0 G0,5 G0,4 G0,4 */
+/*    -    -    -    -    -    -    -    -    - G0,2 G0,1 G0,0 B0,5 B0,4 B0,3 B0,2 B0,1 B0,0 */
+#define DISPLAY_PIXEL_CODING_DBI_18TO9		DISPLAY_PIXEL_CODING_DBI(18, 9, 0)
+/*    -    - R1,2 R1,1 R1,0 G1,2 G1,1 G1,0 B1,1 B1,0 R0,2 R0,1 R0,0 G0,2 G0,1 G0,0 B0,1 B0,0 */
+#define DISPLAY_PIXEL_CODING_DBI_8TO16		DISPLAY_PIXEL_CODING_DBI(8, 16, 0)
+/*    -    -    -    -    -    - R0,3 R0,2 R0,1 R0,0 G0,3 G0,2 G0,1 G0,0 B0,3 B0,2 B0,1 B0,0 */
+#define DISPLAY_PIXEL_CODING_DBI_12TO16		DISPLAY_PIXEL_CODING_DBI(12, 16, 0)
+/*    -    - R0,4 R0,3 R0,2 R0,1 R0,0 G0,5 G0,4 G0,3 G0,2 G0,1 G0,0 B0,4 B0,3 B0,2 B0,1 B0,0 */
+#define DISPLAY_PIXEL_CODING_DBI_16TO16		DISPLAY_PIXEL_CODING_DBI(16, 16, 0)
+/*    -    - R0,5 R0,4 R0,3 R0,2 R0,1 R0,0    -    - G0,5 G0,4 G0,3 G0,2 G0,1 G0,0    -    - */
+/*    -    - B0,5 B0,4 B0,3 B0,2 B0,1 B0,0    -    - R1,5 R1,4 R1,3 R1,2 R1,1 R1,0    -    - */
+/*    -    - G1,5 G1,4 G1,3 G1,2 G1,1 G1,0    -    - B1,5 B1,4 B1,3 B1,2 B1,1 B1,0    -    - */
+#define DISPLAY_PIXEL_CODING_DBI_18TO16_A	DISPLAY_PIXEL_CODING_DBI(18, 16, 0)
+/*    -    -    -    -    -    -    -    -    -    - R0,5 R0,4 R0,3 R0,2 R0,1 R0,0    -    - */
+/*    -    - G0,5 G0,4 G0,3 G0,2 G0,1 G0,0    -    - B0,5 B0,4 B0,3 B0,2 B0,1 B0,0    -    - */
+#define DISPLAY_PIXEL_CODING_DBI_18TO16_B	DISPLAY_PIXEL_CODING_DBI(18, 16, 1)
+/*    -    - R0,7 R0,6 R0,5 R0,4 R0,3 R0,2 R0,1 R0,0 G0,7 G0,6 G0,5 G0,4 G0,3 G0,2 G0,1 G0,0 */
+/*    -    - B0,7 B0,6 B0,5 B0,4 B0,3 B0,2 B0,1 B0,0 R1,7 R1,6 R1,5 R1,4 R1,3 R1,2 R1,1 R1,0 */
+/*    -    - G1,7 G1,6 G1,5 G1,4 G1,3 G1,2 G1,1 G1,0 B1,7 B1,6 B1,5 B1,4 B1,3 B1,2 B1,1 B1,0 */
+#define DISPLAY_PIXEL_CODING_DBI_24TO16_A	DISPLAY_PIXEL_CODING_DBI(24, 16, 0)
+/*    -    -    -    -    -    -    -    -    -    - R0,7 R0,6 R0,5 R0,4 R0,3 R0,2 R0,1 R0,0 */
+/*    -    - G0,7 G0,6 G0,5 G0,4 G0,3 G0,2 G0,1 G0,0 B0,7 B0,6 B0,5 B0,4 B0,3 B0,2 B0,1 B0,0 */
+#define DISPLAY_PIXEL_CODING_DBI_24TO16_B	DISPLAY_PIXEL_CODING_DBI(24, 16, 1)
+
+/* Non-standard DBI pixel codings. */
+/*   17   16   15   14   13   12   11   10    9    8    7    6    5    4    3    2    1    0 */
+/*    -    -    -    -    -    -    -    -    -    - R0,5 R0,4 R0,3 R0,2 R0,1 R0,0 G0,5 G0,4 */
+/*    -    -    -    -    -    -    -    -    -    - G0,3 G0,2 G0,1 G0,0 B0,5 B0,4 B0,3 B0,2 */
+/*    -    -    -    -    -    -    -    -    -    -    -    -    -    -    -    - B0,1 B0,0 */
+#define DISPLAY_PIXEL_CODING_DBI_18TO8_B	DISPLAY_PIXEL_CODING_DBI(18, 8, 1)
+/*    -    -    -    -    -    -    -    -    -    -    -    -    -    -    -    - R0,5 R0,4 */
+/*    -    -    -    -    -    -    -    -    -    - R0,3 R0,2 R0,1 R0,0 G0,5 G0,4 G0,3 G0,2 */
+/*    -    -    -    -    -    -    -    -    -    - G0,1 G0,0 B0,5 B0,4 B0,3 B0,2 B0,1 B0,0 */
+#define DISPLAY_PIXEL_CODING_DBI_18TO8_C	DISPLAY_PIXEL_CODING_DBI(18, 8, 2)
+/*    -    - R0,5 R0,4 R0,3 R0,2 R0,1 R0,0 G0,5 G0,4 G0,3 G0,2 G0,1 G0,0 B0,5 B0,4 B0,3 B0,2 */
+/*    -    - B0,1 B0,0    -    -    -    -    -    -    -    -    -    -    -    -    -    - */
+#define DISPLAY_PIXEL_CODING_DBI_18TO16_C	DISPLAY_PIXEL_CODING_DBI(18, 16, 2)
+/*    -    - R0,5 R0,4    -    -    -    -    -    -    -    -    -    -    -    -    -    - */
+/*    -    - R0,3 R0,2 R0,1 R0,0 G0,5 G0,4 G0,3 G0,2 G0,1 G0,0 B0,5 B0,4 B0,3 B0,2 B0,1 B0,0 */
+#define DISPLAY_PIXEL_CODING_DBI_18TO16_D	DISPLAY_PIXEL_CODING_DBI(18, 16, 3)
+/*    -    -    -    -    -    - R0,7 R0,6 R0,5 R0,4 R0,3 R0,2 R0,1 R0,0 G0,7 G0,6 G0,5 G0,4 */
+/*    -    -    -    -    -    - G0,3 G0,2 G0,1 G0,0 B0,7 B0,6 B0,5 B0,4 B0,3 B0,2 B0,1 B0,0 */
+#define DISPLAY_PIXEL_CODING_DBI_24TO12		DISPLAY_PIXEL_CODING_DBI(24, 12, 0)
+/* R0,5 R0,4 R0,3 R0,2 R0,1 R0,0 G0,5 G0,4 G0,3 G0,2 G0,1 G0,0 B0,5 B0,4 B0,3 B0,2 B0,1 B0,0 */
+#define DISPLAY_PIXEL_CODING_DBI_18TO18		DISPLAY_PIXEL_CODING_DBI(18, 18, 0)
+
+/* DPI pixel codings. */
+#define DISPLAY_PIXEL_CODING_DPI_RGB(from, to, variant) \
+	DISPLAY_PIXEL_CODING_TYPE(DISPLAY_PIXEL_CODING_TYPE_DPI, \
+				  from, to, variant, 0)
+#define DISPLAY_PIXEL_CODING_DPI_YUV(from, to, variant) \
+	DISPLAY_PIXEL_CODING_TYPE(DISPLAY_PIXEL_CODING_TYPE_DPI, \
+				  from, to, variant, 1)
+
+/* Standard DPI codings, defined in the DPI specification. */
+/* 23 22 21 20 19 28 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0 */
+/*  -  -  -  -  -  -  -  - R4 R3 R2 R1 R0 G5 G4 G3 G2 G1 G0 B4 B3 B2 B1 B0 */
+#define DISPLAY_PIXEL_CODING_DPI_RGB_16TO16	DISPLAY_PIXEL_CODING_DPI_RGB(16, 16, 0)
+/*  -  -  -  -  -  - R5 R4 R3 R2 R1 R0 G5 G4 G3 G2 G1 G0 B5 B4 B3 B2 B1 B0 */
+#define DISPLAY_PIXEL_CODING_DPI_RGB_18TO18	DISPLAY_PIXEL_CODING_DPI_RGB(18, 18, 0)
+/*  -  -  - R4 R3 R2 R1 R0  -  - G5 G4 G3 G2 G1 G0  -  -  - B4 B3 B2 B1 B0 */
+#define DISPLAY_PIXEL_CODING_DPI_RGB_16TO20	DISPLAY_PIXEL_CODING_DPI_RGB(16, 20, 0)
+/*  -  - R4 R3 R2 R1 R0  -  -  - G5 G4 G3 G2 G1 G0  -  - B4 B3 B2 B1 B0  - */
+#define DISPLAY_PIXEL_CODING_DPI_RGB_16TO22	DISPLAY_PIXEL_CODING_DPI_RGB(16, 22, 0)
+/*  -  - R5 R4 R3 R2 R1 R0  -  - G5 G4 G3 G2 G1 G0  -  - B5 B4 B3 B2 B1 B0 */
+#define DISPLAY_PIXEL_CODING_DPI_RGB_18TO22	DISPLAY_PIXEL_CODING_DPI_RGB(18, 22, 0)
+/* R7 R6 R5 R4 R3 R2 R1 R0 G7 G6 G5 G4 G3 G2 G1 G0 B7 B6 B5 B4 B3 B2 B1 B0 */
+#define DISPLAY_PIXEL_CODING_DPI_RGB_24TO24	DISPLAY_PIXEL_CODING_DPI_RGB(24, 24, 0)
+
+/* Non-standard DPI pixel codings. */
+/* 23 22 21 20 19 28 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0 */
+/*  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - R7 R6 R5 R4 R3 R2 R1 R0 */
+/*  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - G7 G6 G5 G4 G3 G2 G1 G0 */
+/*  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - B7 B6 B5 B4 B3 B2 B1 B0 */
+#define DISPLAY_PIXEL_CODING_DPI_RGB_24TO8	DISPLAY_PIXEL_CODING_DPI_RGB(24, 8, 0)
+/*  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - R5 R4 R3 R2 R1 R0 G5 G4 G3 */
+/*  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - G2 G1 G0 B5 B4 B3 B2 B1 B0 */
+#define DISPLAY_PIXEL_CODING_DPI_RGB_18TO9	DISPLAY_PIXEL_CODING_DPI_RGB(18, 9, 0)
+/*  -  -  -  -  -  -  -  -  -  -  -  - R3 R2 R1 R0 G3 G2 G1 G0 B3 B2 B1 B0 */
+#define DISPLAY_PIXEL_CODING_DPI_RGB_12TO12	DISPLAY_PIXEL_CODING_DPI_RGB(12, 12, 0)
+/*  -  -  -  -  -  -  -  -  -  -  -  - R7 R6 R5 R4 R3 R2 R1 R0 G7 G6 G5 G4 */
+/*  -  -  -  -  -  -  -  -  -  -  -  - G3 G2 G1 G0 B7 B6 B5 B4 B3 B2 B1 B0 */
+#define DISPLAY_PIXEL_CODING_DPI_RGB_24TO12	DISPLAY_PIXEL_CODING_DPI_RGB(24, 12, 0)
+
 /* -----------------------------------------------------------------------------
  * Display Entity
  */
-- 
1.8.1.5

