Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:14528 "EHLO
        aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbeJHTkU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2018 15:40:20 -0400
From: bwinther@cisco.com
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com,
        =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
Subject: [PATCH 2/4] qvidcap: Add 16-bit bayer rendering
Date: Mon,  8 Oct 2018 14:28:45 +0200
Message-Id: <20181008122847.25600-2-bwinther@cisco.com>
In-Reply-To: <20181008122847.25600-1-bwinther@cisco.com>
References: <20181008122847.25600-1-bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Bård Eirik Winther <bwinther@cisco.com>

Add OpenGL support to render all v4l2 16-bit bayer formats

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qvidcap/capture-win-gl.cpp | 28 ++++++++++++++++++++++++++++
 utils/qvidcap/v4l2-convert.glsl  | 13 +++++++++----
 2 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/utils/qvidcap/capture-win-gl.cpp b/utils/qvidcap/capture-win-gl.cpp
index 224c1340..04271e4c 100644
--- a/utils/qvidcap/capture-win-gl.cpp
+++ b/utils/qvidcap/capture-win-gl.cpp
@@ -86,6 +86,10 @@ const __u32 formats[] = {
 	V4L2_PIX_FMT_SGBRG12,
 	V4L2_PIX_FMT_SGRBG12,
 	V4L2_PIX_FMT_SRGGB12,
+	V4L2_PIX_FMT_SBGGR16,
+	V4L2_PIX_FMT_SGBRG16,
+	V4L2_PIX_FMT_SGRBG16,
+	V4L2_PIX_FMT_SRGGB16,
 	V4L2_PIX_FMT_HSV24,
 	V4L2_PIX_FMT_HSV32,
 	V4L2_PIX_FMT_GREY,
@@ -842,6 +846,10 @@ bool CaptureGLWin::updateV4LFormat(const cv4l_fmt &fmt)
 	case V4L2_PIX_FMT_SGBRG12:
 	case V4L2_PIX_FMT_SGRBG12:
 	case V4L2_PIX_FMT_SRGGB12:
+	case V4L2_PIX_FMT_SBGGR16:
+	case V4L2_PIX_FMT_SGBRG16:
+	case V4L2_PIX_FMT_SGRBG16:
+	case V4L2_PIX_FMT_SRGGB16:
 		m_is_bayer = true;
 		/* fall through */
 	case V4L2_PIX_FMT_GREY:
@@ -1625,6 +1633,10 @@ void CaptureGLWin::paintGL()
 	case V4L2_PIX_FMT_SGBRG12:
 	case V4L2_PIX_FMT_SGRBG12:
 	case V4L2_PIX_FMT_SRGGB12:
+	case V4L2_PIX_FMT_SBGGR16:
+	case V4L2_PIX_FMT_SGBRG16:
+	case V4L2_PIX_FMT_SGRBG16:
+	case V4L2_PIX_FMT_SRGGB16:
 		render_Bayer(m_v4l_fmt.g_pixelformat());
 		break;
 
@@ -1815,6 +1827,10 @@ static const struct define defines[] = {
 	DEF(V4L2_PIX_FMT_SGBRG12),
 	DEF(V4L2_PIX_FMT_SGRBG12),
 	DEF(V4L2_PIX_FMT_SRGGB12),
+	DEF(V4L2_PIX_FMT_SBGGR16),
+	DEF(V4L2_PIX_FMT_SGBRG16),
+	DEF(V4L2_PIX_FMT_SGRBG16),
+	DEF(V4L2_PIX_FMT_SRGGB16),
 	DEF(V4L2_PIX_FMT_HSV24),
 	DEF(V4L2_PIX_FMT_HSV32),
 	DEF(V4L2_PIX_FMT_GREY),
@@ -2025,6 +2041,10 @@ void CaptureGLWin::changeShader()
 	case V4L2_PIX_FMT_SGBRG12:
 	case V4L2_PIX_FMT_SGRBG12:
 	case V4L2_PIX_FMT_SRGGB12:
+	case V4L2_PIX_FMT_SBGGR16:
+	case V4L2_PIX_FMT_SGBRG16:
+	case V4L2_PIX_FMT_SGRBG16:
+	case V4L2_PIX_FMT_SRGGB16:
 		shader_Bayer();
 		break;
 
@@ -2272,6 +2292,10 @@ void CaptureGLWin::shader_Bayer()
 	case V4L2_PIX_FMT_SGBRG12:
 	case V4L2_PIX_FMT_SGRBG12:
 	case V4L2_PIX_FMT_SRGGB12:
+	case V4L2_PIX_FMT_SBGGR16:
+	case V4L2_PIX_FMT_SGBRG16:
+	case V4L2_PIX_FMT_SGRBG16:
+	case V4L2_PIX_FMT_SRGGB16:
 		glTexImage2D(GL_TEXTURE_2D, 0, GL_R16UI, m_v4l_fmt.g_width(), m_v4l_fmt.g_height(), 0,
 			     GL_RED_INTEGER, GL_UNSIGNED_SHORT, NULL);
 		break;
@@ -2611,6 +2635,10 @@ void CaptureGLWin::render_Bayer(__u32 format)
 	case V4L2_PIX_FMT_SGBRG12:
 	case V4L2_PIX_FMT_SGRBG12:
 	case V4L2_PIX_FMT_SRGGB12:
+	case V4L2_PIX_FMT_SBGGR16:
+	case V4L2_PIX_FMT_SGBRG16:
+	case V4L2_PIX_FMT_SGRBG16:
+	case V4L2_PIX_FMT_SRGGB16:
 		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, m_v4l_fmt.g_width(), m_v4l_fmt.g_height(),
 				GL_RED_INTEGER, GL_UNSIGNED_SHORT, m_curData[0]);
 		break;
diff --git a/utils/qvidcap/v4l2-convert.glsl b/utils/qvidcap/v4l2-convert.glsl
index 6ca12d8d..81879562 100644
--- a/utils/qvidcap/v4l2-convert.glsl
+++ b/utils/qvidcap/v4l2-convert.glsl
@@ -5,6 +5,8 @@
     PIXFMT == V4L2_PIX_FMT_SGRBG10 || PIXFMT == V4L2_PIX_FMT_SRGGB10 || \
     PIXFMT == V4L2_PIX_FMT_SBGGR12 || PIXFMT == V4L2_PIX_FMT_SGBRG12 || \
     PIXFMT == V4L2_PIX_FMT_SGRBG12 || PIXFMT == V4L2_PIX_FMT_SRGGB12 || \
+    PIXFMT == V4L2_PIX_FMT_SBGGR16 || PIXFMT == V4L2_PIX_FMT_SGBRG16 || \
+    PIXFMT == V4L2_PIX_FMT_SGRBG16 || PIXFMT == V4L2_PIX_FMT_SRGGB16 || \
     PIXFMT == V4L2_PIX_FMT_GREY || PIXFMT == V4L2_PIX_FMT_Y16 || \
     PIXFMT == V4L2_PIX_FMT_Y16_BE || PIXFMT == V4L2_PIX_FMT_Z16 || \
     PIXFMT == V4L2_PIX_FMT_Y10 || PIXFMT == V4L2_PIX_FMT_Y12
@@ -112,25 +114,25 @@ void main()
 #if IS_RGB
 
 // Bayer pixel formats
-#if PIXFMT == V4L2_PIX_FMT_SBGGR8 || PIXFMT == V4L2_PIX_FMT_SBGGR10 || PIXFMT == V4L2_PIX_FMT_SBGGR12
+#if PIXFMT == V4L2_PIX_FMT_SBGGR8 || PIXFMT == V4L2_PIX_FMT_SBGGR10 || PIXFMT == V4L2_PIX_FMT_SBGGR12 || PIXFMT == V4L2_PIX_FMT_SBGGR16
 	uvec4 urgb;
 	vec2 cell = vec2(xeven ? xy.x : xy.x - texl_w, yeven ? xy.y : xy.y - texl_h);
 	urgb.r = texture(tex, vec2(cell.x + texl_w, cell.y + texl_h)).r;
 	urgb.g = texture(tex, vec2((cell.y == xy.y) ? cell.x + texl_w : cell.x, xy.y)).r;
 	urgb.b = texture(tex, cell).r;
-#elif PIXFMT == V4L2_PIX_FMT_SGBRG8 || PIXFMT == V4L2_PIX_FMT_SGBRG10 || PIXFMT == V4L2_PIX_FMT_SGBRG12
+#elif PIXFMT == V4L2_PIX_FMT_SGBRG8 || PIXFMT == V4L2_PIX_FMT_SGBRG10 || PIXFMT == V4L2_PIX_FMT_SGBRG12 || PIXFMT == V4L2_PIX_FMT_SGBRG16
 	uvec4 urgb;
 	vec2 cell = vec2(xeven ? xy.x : xy.x - texl_w, yeven ? xy.y : xy.y - texl_h);
 	urgb.r = texture(tex, vec2(cell.x, cell.y + texl_h)).r;
 	urgb.g = texture(tex, vec2((cell.y == xy.y) ? cell.x : cell.x + texl_w, xy.y)).r;
 	urgb.b = texture(tex, vec2(cell.x + texl_w, cell.y)).r;
-#elif PIXFMT == V4L2_PIX_FMT_SGRBG8 || PIXFMT == V4L2_PIX_FMT_SGRBG10 || PIXFMT == V4L2_PIX_FMT_SGRBG12
+#elif PIXFMT == V4L2_PIX_FMT_SGRBG8 || PIXFMT == V4L2_PIX_FMT_SGRBG10 || PIXFMT == V4L2_PIX_FMT_SGRBG12 || PIXFMT == V4L2_PIX_FMT_SGRBG16
 	uvec4 urgb;
 	vec2 cell = vec2(xeven ? xy.x : xy.x - texl_w, yeven ? xy.y : xy.y - texl_h);
 	urgb.r = texture(tex, vec2(cell.x + texl_w, cell.y)).r;
 	urgb.g = texture(tex, vec2((cell.y == xy.y) ? cell.x : cell.x + texl_w, xy.y)).r;
 	urgb.b = texture(tex, vec2(cell.x, cell.y + texl_h)).r;
-#elif PIXFMT == V4L2_PIX_FMT_SRGGB8 || PIXFMT == V4L2_PIX_FMT_SRGGB10 || PIXFMT == V4L2_PIX_FMT_SRGGB12
+#elif PIXFMT == V4L2_PIX_FMT_SRGGB8 || PIXFMT == V4L2_PIX_FMT_SRGGB10 || PIXFMT == V4L2_PIX_FMT_SRGGB12 || PIXFMT == V4L2_PIX_FMT_SRGGB16
 	uvec4 urgb;
 	vec2 cell = vec2(xeven ? xy.x : xy.x - texl_w, yeven ? xy.y : xy.y - texl_h);
 	urgb.b = texture(tex, vec2(cell.x + texl_w, cell.y + texl_h)).r;
@@ -192,6 +194,9 @@ void main()
 #elif PIXFMT == V4L2_PIX_FMT_SBGGR12 || PIXFMT == V4L2_PIX_FMT_SGBRG12 || \
       PIXFMT == V4L2_PIX_FMT_SGRBG12 || PIXFMT == V4L2_PIX_FMT_SRGGB12
 	rgb = vec3(urgb) / 4095.0;
+#elif PIXFMT == V4L2_PIX_FMT_SBGGR16 || PIXFMT == V4L2_PIX_FMT_SGBRG16 || \
+      PIXFMT == V4L2_PIX_FMT_SGRBG16 || PIXFMT == V4L2_PIX_FMT_SRGGB16
+	rgb = vec3(urgb) / 65535.0;
 #endif
 
 #if QUANT == V4L2_QUANTIZATION_LIM_RANGE
-- 
2.17.1
