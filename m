Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:64139 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754119AbdJIKTw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 06:19:52 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Helen Koike <helen.koike@collabora.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 23/24] media: v4l2-tpg*.h: move headers to include/media/tpg and merge them
Date: Mon,  9 Oct 2017 07:19:29 -0300
Message-Id: <2dfa08c0c3f289cdde6ea4f751f44ff18c212cf5.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2-tpg*.h headers are meant to be used only internally by
vivid and vimc. There's no sense keeping them together with the
V4L2 kAPI headers. Also, one header includes the other as they're
meant to be used together. So, merge them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c |  2 +-
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c   |  2 +-
 drivers/media/platform/vimc/vimc-sensor.c       |  2 +-
 drivers/media/platform/vivid/vivid-core.h       |  2 +-
 include/media/{ => tpg}/v4l2-tpg.h              | 45 +++++++++++++++-
 include/media/v4l2-tpg-colors.h                 | 68 -------------------------
 6 files changed, 48 insertions(+), 73 deletions(-)
 rename include/media/{ => tpg}/v4l2-tpg.h (93%)
 delete mode 100644 include/media/v4l2-tpg-colors.h

diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c
index 5b5f95c38fe1..95b26f6a0d54 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c
@@ -36,7 +36,7 @@
  */
 
 #include <linux/videodev2.h>
-#include <media/v4l2-tpg-colors.h>
+#include <media/tpg/v4l2-tpg.h>
 
 /* sRGB colors with range [0-255] */
 const struct color tpg_colors[TPG_COLOR_MAX] = {
diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
index a772976cfe26..f218b336a3ac 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -21,7 +21,7 @@
  */
 
 #include <linux/module.h>
-#include <media/v4l2-tpg.h>
+#include <media/tpg/v4l2-tpg.h>
 
 /* Must remain in sync with enum tpg_pattern */
 const char * const tpg_pattern_strings[] = {
diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
index 02e68c8fc02b..8d2691817aa5 100644
--- a/drivers/media/platform/vimc/vimc-sensor.c
+++ b/drivers/media/platform/vimc/vimc-sensor.c
@@ -23,7 +23,7 @@
 #include <linux/v4l2-mediabus.h>
 #include <linux/vmalloc.h>
 #include <media/v4l2-subdev.h>
-#include <media/v4l2-tpg.h>
+#include <media/tpg/v4l2-tpg.h>
 
 #include "vimc-common.h"
 
diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index 5cdf95bdc4d1..36802947a4b0 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -27,7 +27,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-ctrls.h>
-#include <media/v4l2-tpg.h>
+#include <media/tpg/v4l2-tpg.h>
 #include "vivid-rds-gen.h"
 #include "vivid-vbi-gen.h"
 
diff --git a/include/media/v4l2-tpg.h b/include/media/tpg/v4l2-tpg.h
similarity index 93%
rename from include/media/v4l2-tpg.h
rename to include/media/tpg/v4l2-tpg.h
index 13e49d85cae3..028d81182011 100644
--- a/include/media/v4l2-tpg.h
+++ b/include/media/tpg/v4l2-tpg.h
@@ -26,8 +26,51 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/videodev2.h>
-#include <media/v4l2-tpg-colors.h>
 
+struct color {
+	unsigned char r, g, b;
+};
+
+struct color16 {
+	int r, g, b;
+};
+
+enum tpg_color {
+	TPG_COLOR_CSC_WHITE,
+	TPG_COLOR_CSC_YELLOW,
+	TPG_COLOR_CSC_CYAN,
+	TPG_COLOR_CSC_GREEN,
+	TPG_COLOR_CSC_MAGENTA,
+	TPG_COLOR_CSC_RED,
+	TPG_COLOR_CSC_BLUE,
+	TPG_COLOR_CSC_BLACK,
+	TPG_COLOR_75_YELLOW,
+	TPG_COLOR_75_CYAN,
+	TPG_COLOR_75_GREEN,
+	TPG_COLOR_75_MAGENTA,
+	TPG_COLOR_75_RED,
+	TPG_COLOR_75_BLUE,
+	TPG_COLOR_100_WHITE,
+	TPG_COLOR_100_YELLOW,
+	TPG_COLOR_100_CYAN,
+	TPG_COLOR_100_GREEN,
+	TPG_COLOR_100_MAGENTA,
+	TPG_COLOR_100_RED,
+	TPG_COLOR_100_BLUE,
+	TPG_COLOR_100_BLACK,
+	TPG_COLOR_TEXTFG,
+	TPG_COLOR_TEXTBG,
+	TPG_COLOR_RANDOM,
+	TPG_COLOR_RAMP,
+	TPG_COLOR_MAX = TPG_COLOR_RAMP + 256
+};
+
+extern const struct color tpg_colors[TPG_COLOR_MAX];
+extern const unsigned short tpg_rec709_to_linear[255 * 16 + 1];
+extern const unsigned short tpg_linear_to_rec709[255 * 16 + 1];
+extern const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1]
+					  [V4L2_XFER_FUNC_SMPTE2084 + 1]
+					  [TPG_COLOR_CSC_BLACK + 1];
 enum tpg_pattern {
 	TPG_PAT_75_COLORBAR,
 	TPG_PAT_100_COLORBAR,
diff --git a/include/media/v4l2-tpg-colors.h b/include/media/v4l2-tpg-colors.h
deleted file mode 100644
index 2a88d1fae0cd..000000000000
--- a/include/media/v4l2-tpg-colors.h
+++ /dev/null
@@ -1,68 +0,0 @@
-/*
- * v4l2-tpg-colors.h - Color definitions for the test pattern generator
- *
- * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
- *
- * This program is free software; you may redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- */
-
-#ifndef _V4L2_TPG_COLORS_H_
-#define _V4L2_TPG_COLORS_H_
-
-struct color {
-	unsigned char r, g, b;
-};
-
-struct color16 {
-	int r, g, b;
-};
-
-enum tpg_color {
-	TPG_COLOR_CSC_WHITE,
-	TPG_COLOR_CSC_YELLOW,
-	TPG_COLOR_CSC_CYAN,
-	TPG_COLOR_CSC_GREEN,
-	TPG_COLOR_CSC_MAGENTA,
-	TPG_COLOR_CSC_RED,
-	TPG_COLOR_CSC_BLUE,
-	TPG_COLOR_CSC_BLACK,
-	TPG_COLOR_75_YELLOW,
-	TPG_COLOR_75_CYAN,
-	TPG_COLOR_75_GREEN,
-	TPG_COLOR_75_MAGENTA,
-	TPG_COLOR_75_RED,
-	TPG_COLOR_75_BLUE,
-	TPG_COLOR_100_WHITE,
-	TPG_COLOR_100_YELLOW,
-	TPG_COLOR_100_CYAN,
-	TPG_COLOR_100_GREEN,
-	TPG_COLOR_100_MAGENTA,
-	TPG_COLOR_100_RED,
-	TPG_COLOR_100_BLUE,
-	TPG_COLOR_100_BLACK,
-	TPG_COLOR_TEXTFG,
-	TPG_COLOR_TEXTBG,
-	TPG_COLOR_RANDOM,
-	TPG_COLOR_RAMP,
-	TPG_COLOR_MAX = TPG_COLOR_RAMP + 256
-};
-
-extern const struct color tpg_colors[TPG_COLOR_MAX];
-extern const unsigned short tpg_rec709_to_linear[255 * 16 + 1];
-extern const unsigned short tpg_linear_to_rec709[255 * 16 + 1];
-extern const struct color16 tpg_csc_colors[V4L2_COLORSPACE_DCI_P3 + 1]
-					  [V4L2_XFER_FUNC_SMPTE2084 + 1]
-					  [TPG_COLOR_CSC_BLACK + 1];
-
-#endif
-- 
2.13.6
