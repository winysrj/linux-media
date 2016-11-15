Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:32797 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752269AbcKOMGE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 07:06:04 -0500
Received: by mail-wm0-f67.google.com with SMTP id u144so25073787wmu.0
        for <linux-media@vger.kernel.org>; Tue, 15 Nov 2016 04:06:03 -0800 (PST)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 2/3] qv4l: support for HSV formats via  OpenGL.
Date: Tue, 15 Nov 2016 13:05:57 +0100
Message-Id: <20161115120558.2872-2-ricardo.ribalda@gmail.com>
In-Reply-To: <20161115120558.2872-1-ricardo.ribalda@gmail.com>
References: <20161115120558.2872-1-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support for HSV32 and HSV24.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 utils/qv4l2/capture-win-gl.cpp | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/utils/qv4l2/capture-win-gl.cpp b/utils/qv4l2/capture-win-gl.cpp
index af1909c936c5..df10d6863402 100644
--- a/utils/qv4l2/capture-win-gl.cpp
+++ b/utils/qv4l2/capture-win-gl.cpp
@@ -185,6 +185,8 @@ void CaptureWinGLEngine::setColorspace(unsigned colorspace, unsigned xfer_func,
 	case V4L2_PIX_FMT_YUV555:
 	case V4L2_PIX_FMT_YUV565:
 	case V4L2_PIX_FMT_YUV32:
+	case V4L2_PIX_FMT_HSV24:
+	case V4L2_PIX_FMT_HSV32:
 		is_rgb = false;
 		break;
 	}
@@ -396,6 +398,8 @@ bool CaptureWinGLEngine::hasNativeFormat(__u32 format)
 		V4L2_PIX_FMT_GREY,
 		V4L2_PIX_FMT_Y16,
 		V4L2_PIX_FMT_Y16_BE,
+		V4L2_PIX_FMT_HSV24,
+		V4L2_PIX_FMT_HSV32,
 		0
 	};
 
@@ -505,6 +509,8 @@ void CaptureWinGLEngine::changeShader()
 	case V4L2_PIX_FMT_GREY:
 	case V4L2_PIX_FMT_Y16:
 	case V4L2_PIX_FMT_Y16_BE:
+	case V4L2_PIX_FMT_HSV24:
+	case V4L2_PIX_FMT_HSV32:
 	default:
 		shader_RGB(m_frameFormat);
 		break;
@@ -647,6 +653,8 @@ void CaptureWinGLEngine::paintGL()
 	case V4L2_PIX_FMT_XBGR32:
 	case V4L2_PIX_FMT_ARGB32:
 	case V4L2_PIX_FMT_ABGR32:
+	case V4L2_PIX_FMT_HSV24:
+	case V4L2_PIX_FMT_HSV32:
 	default:
 		render_RGB(m_frameFormat);
 		break;
@@ -1537,7 +1545,9 @@ void CaptureWinGLEngine::shader_RGB(__u32 format)
 			  format == V4L2_PIX_FMT_BGR666 ||
 			  format == V4L2_PIX_FMT_GREY ||
 			  format == V4L2_PIX_FMT_Y16 ||
-			  format == V4L2_PIX_FMT_Y16_BE;
+			  format == V4L2_PIX_FMT_Y16_BE ||
+			  format == V4L2_PIX_FMT_HSV24 ||
+			  format == V4L2_PIX_FMT_HSV32;
 	GLint internalFmt = manualTransform ? GL_RGBA8 : GL_SRGB8_ALPHA8;
 
 	switch (format) {
@@ -1588,6 +1598,7 @@ void CaptureWinGLEngine::shader_RGB(__u32 format)
 		/* fall-through */
 	case V4L2_PIX_FMT_RGB32:
 	case V4L2_PIX_FMT_XRGB32:
+	case V4L2_PIX_FMT_HSV32:
 		glTexImage2D(GL_TEXTURE_2D, 0, internalFmt, m_frameWidth, m_frameHeight, 0,
 				GL_BGRA, GL_UNSIGNED_INT_8_8_8_8, NULL);
 		break;
@@ -1610,6 +1621,7 @@ void CaptureWinGLEngine::shader_RGB(__u32 format)
 		break;
 	case V4L2_PIX_FMT_RGB24:
 	case V4L2_PIX_FMT_BGR24:
+	case V4L2_PIX_FMT_HSV24:
 	default:
 		glTexImage2D(GL_TEXTURE_2D, 0, internalFmt, m_frameWidth, m_frameHeight, 0,
 				GL_RGB, GL_UNSIGNED_BYTE, NULL);
@@ -1657,6 +1669,22 @@ void CaptureWinGLEngine::shader_RGB(__u32 format)
 			    "   float g = r;"
 			    "   float b = r;";
 		break;
+	case V4L2_PIX_FMT_HSV24:
+	case V4L2_PIX_FMT_HSV32:
+		/* From http://lolengine.net/blog/2013/07/27/rgb-to-hsv-in-glsl */
+		if (m_ycbcr_enc == V4L2_HSV_ENC_256)
+			codeHead += "   float hue = color.r;";
+		else
+			codeHead += "   float hue = (color.r * 256.0) / 180.0;";
+
+		codeHead += "   vec3 c = vec3(hue, color.g, color.b);"
+			    "   vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);"
+			    "   vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);"
+			    "   vec3 ret = c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);"
+			    "   float r = ret.x;"
+			    "   float g = ret.y;"
+			    "   float b = ret.z;";
+		break;
 	default:
 		codeHead += "   float r = color.r;"
 			    "   float g = color.g;"
@@ -1759,6 +1787,7 @@ void CaptureWinGLEngine::render_RGB(__u32 format)
 	case V4L2_PIX_FMT_RGB32:
 	case V4L2_PIX_FMT_XRGB32:
 	case V4L2_PIX_FMT_ARGB32:
+	case V4L2_PIX_FMT_HSV32:
 		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, m_frameWidth, m_frameHeight,
 				GL_BGRA, GL_UNSIGNED_INT_8_8_8_8, m_frameData);
 		break;
@@ -1771,6 +1800,7 @@ void CaptureWinGLEngine::render_RGB(__u32 format)
 		break;
 	case V4L2_PIX_FMT_RGB24:
 	case V4L2_PIX_FMT_BGR24:
+	case V4L2_PIX_FMT_HSV24:
 	default:
 		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, m_frameWidth, m_frameHeight,
 				GL_RGB, GL_UNSIGNED_BYTE, m_frameData);
-- 
2.10.2

