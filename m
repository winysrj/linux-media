Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:53499 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbeJHTkU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2018 15:40:20 -0400
From: bwinther@cisco.com
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com,
        =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
Subject: [PATCH 3/4] qv4l2: Add 16-bit bayer rendering
Date: Mon,  8 Oct 2018 14:28:46 +0200
Message-Id: <20181008122847.25600-3-bwinther@cisco.com>
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
 utils/qv4l2/capture-win-gl.cpp | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/utils/qv4l2/capture-win-gl.cpp b/utils/qv4l2/capture-win-gl.cpp
index f7f83326..0adb08b1 100644
--- a/utils/qv4l2/capture-win-gl.cpp
+++ b/utils/qv4l2/capture-win-gl.cpp
@@ -369,6 +369,10 @@ bool CaptureWinGLEngine::hasNativeFormat(__u32 format)
 		V4L2_PIX_FMT_SGBRG12,
 		V4L2_PIX_FMT_SGRBG12,
 		V4L2_PIX_FMT_SRGGB12,
+		V4L2_PIX_FMT_SBGGR16,
+		V4L2_PIX_FMT_SGBRG16,
+		V4L2_PIX_FMT_SGRBG16,
+		V4L2_PIX_FMT_SRGGB16,
 		V4L2_PIX_FMT_YUYV,
 		V4L2_PIX_FMT_YVYU,
 		V4L2_PIX_FMT_UYVY,
@@ -487,6 +491,10 @@ void CaptureWinGLEngine::changeShader()
 	case V4L2_PIX_FMT_SGBRG12:
 	case V4L2_PIX_FMT_SGRBG12:
 	case V4L2_PIX_FMT_SRGGB12:
+	case V4L2_PIX_FMT_SBGGR16:
+	case V4L2_PIX_FMT_SGBRG16:
+	case V4L2_PIX_FMT_SGRBG16:
+	case V4L2_PIX_FMT_SRGGB16:
 		shader_Bayer(m_frameFormat);
 		break;
 
@@ -635,6 +643,10 @@ void CaptureWinGLEngine::paintGL()
 	case V4L2_PIX_FMT_SGBRG12:
 	case V4L2_PIX_FMT_SGRBG12:
 	case V4L2_PIX_FMT_SRGGB12:
+	case V4L2_PIX_FMT_SBGGR16:
+	case V4L2_PIX_FMT_SGBRG16:
+	case V4L2_PIX_FMT_SGRBG16:
+	case V4L2_PIX_FMT_SRGGB16:
 		render_Bayer(m_frameFormat);
 		break;
 
@@ -1874,6 +1886,10 @@ void CaptureWinGLEngine::shader_Bayer(__u32 format)
 	case V4L2_PIX_FMT_SGBRG12:
 	case V4L2_PIX_FMT_SGRBG12:
 	case V4L2_PIX_FMT_SRGGB12:
+	case V4L2_PIX_FMT_SBGGR16:
+	case V4L2_PIX_FMT_SGBRG16:
+	case V4L2_PIX_FMT_SGRBG16:
+	case V4L2_PIX_FMT_SRGGB16:
 		glTexImage2D(GL_TEXTURE_2D, 0, m_glRed16, m_frameWidth, m_frameHeight, 0,
 			     m_glRed, GL_UNSIGNED_SHORT, NULL);
 		break;
@@ -1908,6 +1924,7 @@ void CaptureWinGLEngine::shader_Bayer(__u32 format)
 	case V4L2_PIX_FMT_SBGGR8:
 	case V4L2_PIX_FMT_SBGGR10:
 	case V4L2_PIX_FMT_SBGGR12:
+	case V4L2_PIX_FMT_SBGGR16:
 		codeHead +=	   "   r = texture2D(tex, vec2(cell.x + texl_w, cell.y + texl_h)).r;"
 				   "   g = texture2D(tex, vec2((cell.y == xy.y) ? cell.x + texl_w : cell.x, xy.y)).r;"
 				   "   b = texture2D(tex, cell).r;";
@@ -1915,6 +1932,7 @@ void CaptureWinGLEngine::shader_Bayer(__u32 format)
 	case V4L2_PIX_FMT_SGBRG8:
 	case V4L2_PIX_FMT_SGBRG10:
 	case V4L2_PIX_FMT_SGBRG12:
+	case V4L2_PIX_FMT_SGBRG16:
 		codeHead +=	   "   r = texture2D(tex, vec2(cell.x, cell.y + texl_h)).r;"
 				   "   g = texture2D(tex, vec2((cell.y == xy.y) ? cell.x : cell.x + texl_w, xy.y)).r;"
 				   "   b = texture2D(tex, vec2(cell.x + texl_w, cell.y)).r;";
@@ -1922,6 +1940,7 @@ void CaptureWinGLEngine::shader_Bayer(__u32 format)
 	case V4L2_PIX_FMT_SGRBG8:
 	case V4L2_PIX_FMT_SGRBG10:
 	case V4L2_PIX_FMT_SGRBG12:
+	case V4L2_PIX_FMT_SGRBG16:
 		codeHead +=	   "   r = texture2D(tex, vec2(cell.x + texl_w, cell.y)).r;"
 				   "   g = texture2D(tex, vec2((cell.y == xy.y) ? cell.x : cell.x + texl_w, xy.y)).r;"
 				   "   b = texture2D(tex, vec2(cell.x, cell.y + texl_h)).r;";
@@ -1929,6 +1948,7 @@ void CaptureWinGLEngine::shader_Bayer(__u32 format)
 	case V4L2_PIX_FMT_SRGGB8:
 	case V4L2_PIX_FMT_SRGGB10:
 	case V4L2_PIX_FMT_SRGGB12:
+	case V4L2_PIX_FMT_SRGGB16:
 		codeHead +=	   "   b = texture2D(tex, vec2(cell.x + texl_w, cell.y + texl_h)).r;"
 				   "   g = texture2D(tex, vec2((cell.y == xy.y) ? cell.x + texl_w : cell.x, xy.y)).r;"
 				   "   r = texture2D(tex, cell).r;";
@@ -2005,6 +2025,10 @@ void CaptureWinGLEngine::render_Bayer(__u32 format)
 	case V4L2_PIX_FMT_SGBRG12:
 	case V4L2_PIX_FMT_SGRBG12:
 	case V4L2_PIX_FMT_SRGGB12:
+	case V4L2_PIX_FMT_SBGGR16:
+	case V4L2_PIX_FMT_SGBRG16:
+	case V4L2_PIX_FMT_SGRBG16:
+	case V4L2_PIX_FMT_SRGGB16:
 		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, m_frameWidth, m_frameHeight,
 				m_glRed, GL_UNSIGNED_SHORT, m_frameData);
 		break;
-- 
2.17.1
