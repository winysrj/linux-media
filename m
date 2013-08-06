Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:22359 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab3HFKWX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Aug 2013 06:22:23 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-83.cisco.com [10.54.92.83])
	by ams-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id r76AMGhH015841
	for <linux-media@vger.kernel.org>; Tue, 6 Aug 2013 10:22:20 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/9] qv4l2: fix YUY2 shader
Date: Tue,  6 Aug 2013 12:21:46 +0200
Message-Id: <46f7140b645be29088978e95e8aa454c4bf164b3.1375784415.git.bwinther@cisco.com>
In-Reply-To: <1375784513-18701-1-git-send-email-bwinther@cisco.com>
References: <1375784513-18701-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <f8457ccfdceb6e73b7990efe95f9e3b61d973747.1375784415.git.bwinther@cisco.com>
References: <f8457ccfdceb6e73b7990efe95f9e3b61d973747.1375784415.git.bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed the YUY2 shaders to support scaling.
The new solution has cleaner shader code and texture upload
uses a better format for OpenGL.

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/capture-win-gl.cpp | 68 ++++++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 33 deletions(-)

diff --git a/utils/qv4l2/capture-win-gl.cpp b/utils/qv4l2/capture-win-gl.cpp
index c499f1f..6071410 100644
--- a/utils/qv4l2/capture-win-gl.cpp
+++ b/utils/qv4l2/capture-win-gl.cpp
@@ -1,5 +1,5 @@
 /*
- * The YUY2 shader code was copied and simplified from face-responder. The code is under public domain:
+ * The YUY2 shader code is based on face-responder. The code is under public domain:
  * https://bitbucket.org/nateharward/face-responder/src/0c3b4b957039d9f4bf1da09b9471371942de2601/yuv42201_laplace.frag?at=master
  *
  * All other OpenGL code:
@@ -446,47 +446,51 @@ QString CaptureWinGLEngine::shader_YUY2_invariant(__u32 format)
 {
 	switch (format) {
 	case V4L2_PIX_FMT_YUYV:
-		return QString("y = (luma_chroma.r - 0.0625) * 1.1643;"
-			       "if (mod(xcoord, 2.0) == 0.0) {"
-			       "   u = luma_chroma.a;"
-			       "   v = texture2D(tex, vec2(pixelx + texl_w, pixely)).a;"
+		return QString("if (mod(xcoord, 2.0) == 0.0) {"
+			       "   luma_chroma = texture2D(tex, vec2(pixelx, pixely));"
+			       "   y = (luma_chroma.r - 0.0625) * 1.1643;"
 			       "} else {"
-			       "   v = luma_chroma.a;"
-			       "   u = texture2D(tex, vec2(pixelx - texl_w, pixely)).a;"
+			       "   luma_chroma = texture2D(tex, vec2(pixelx - texl_w, pixely));"
+			       "   y = (luma_chroma.b - 0.0625) * 1.1643;"
 			       "}"
+			       "u = luma_chroma.g - 0.5;"
+			       "v = luma_chroma.a - 0.5;"
 			       );
 
 	case V4L2_PIX_FMT_YVYU:
-		return QString("y = (luma_chroma.r - 0.0625) * 1.1643;"
-			       "if (mod(xcoord, 2.0) == 0.0) {"
-			       "   v = luma_chroma.a;"
-			       "   u = texture2D(tex, vec2(pixelx + texl_w, pixely)).a;"
+		return QString("if (mod(xcoord, 2.0) == 0.0) {"
+			       "   luma_chroma = texture2D(tex, vec2(pixelx, pixely));"
+			       "   y = (luma_chroma.r - 0.0625) * 1.1643;"
 			       "} else {"
-			       "   u = luma_chroma.a;"
-			       "   v = texture2D(tex, vec2(pixelx - texl_w, pixely)).a;"
+			       "   luma_chroma = texture2D(tex, vec2(pixelx - texl_w, pixely));"
+			       "   y = (luma_chroma.b - 0.0625) * 1.1643;"
 			       "}"
+			       "u = luma_chroma.a - 0.5;"
+			       "v = luma_chroma.g - 0.5;"
 			       );
 
 	case V4L2_PIX_FMT_UYVY:
-		return QString("y = (luma_chroma.a - 0.0625) * 1.1643;"
-			       "if (mod(xcoord, 2.0) == 0.0) {"
-			       "   u = luma_chroma.r;"
-			       "   v = texture2D(tex, vec2(pixelx + texl_w, pixely)).r;"
+		return QString("if (mod(xcoord, 2.0) == 0.0) {"
+			       "   luma_chroma = texture2D(tex, vec2(pixelx, pixely));"
+			       "   y = (luma_chroma.g - 0.0625) * 1.1643;"
 			       "} else {"
-			       "   v = luma_chroma.r;"
-			       "   u = texture2D(tex, vec2(pixelx - texl_w, pixely)).r;"
+			       "   luma_chroma = texture2D(tex, vec2(pixelx - texl_w, pixely));"
+			       "   y = (luma_chroma.a - 0.0625) * 1.1643;"
 			       "}"
+			       "u = luma_chroma.r - 0.5;"
+			       "v = luma_chroma.b - 0.5;"
 			       );
 
 	case V4L2_PIX_FMT_VYUY:
-		return QString("y = (luma_chroma.a - 0.0625) * 1.1643;"
-			       "if (mod(xcoord, 2.0) == 0.0) {"
-			       "   v = luma_chroma.r;"
-			       "   u = texture2D(tex, vec2(pixelx + texl_w, pixely)).r;"
+		return QString("if (mod(xcoord, 2.0) == 0.0) {"
+			       "   luma_chroma = texture2D(tex, vec2(pixelx, pixely));"
+			       "   y = (luma_chroma.g - 0.0625) * 1.1643;"
 			       "} else {"
-			       "   u = luma_chroma.r;"
-			       "   v = texture2D(tex, vec2(pixelx - texl_w, pixely)).r;"
+			       "   luma_chroma = texture2D(tex, vec2(pixelx - texl_w, pixely));"
+			       "   y = (luma_chroma.a - 0.0625) * 1.1643;"
 			       "}"
+			       "u = luma_chroma.b - 0.5;"
+			       "v = luma_chroma.r - 0.5;"
 			       );
 
 	default:
@@ -499,8 +503,8 @@ void CaptureWinGLEngine::shader_YUY2(__u32 format)
 	m_screenTextureCount = 1;
 	glGenTextures(m_screenTextureCount, m_screenTexture);
 	configureTexture(0);
-	glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE_ALPHA, m_frameWidth, m_frameHeight, 0,
-		     GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE, NULL);
+	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, m_frameWidth / 2, m_frameHeight, 0,
+		     GL_RGBA, GL_UNSIGNED_BYTE, NULL);
 	checkError("YUY2 shader");
 
 	QString codeHead = QString("uniform sampler2D tex;"
@@ -509,17 +513,15 @@ void CaptureWinGLEngine::shader_YUY2(__u32 format)
 				   "void main()"
 				   "{"
 				   "   float y, u, v;"
+				   "   vec4 luma_chroma;"
 				   "   float pixelx = gl_TexCoord[0].x;"
 				   "   float pixely = gl_TexCoord[0].y;"
 				   "   float xcoord = floor(pixelx * tex_w);"
-				   "   vec4 luma_chroma = texture2D(tex, vec2(pixelx, pixely));"
 				   );
 
 	QString codeBody = shader_YUY2_invariant(format);
 
-	QString codeTail = QString("   u = u - 0.5;"
-				   "   v = v - 0.5;"
-				   "   float r = y + 1.5958 * v;"
+	QString codeTail = QString("   float r = y + 1.5958 * v;"
 				   "   float g = y - 0.39173 * u - 0.81290 * v;"
 				   "   float b = y + 2.017 * u;"
 				   "   gl_FragColor = vec4(r, g, b, 1.0);"
@@ -548,8 +550,8 @@ void CaptureWinGLEngine::render_YUY2()
 	glBindTexture(GL_TEXTURE_2D, m_screenTexture[0]);
 	GLint Y = m_glfunction.glGetUniformLocation(m_shaderProgram.programId(), "tex");
 	glUniform1i(Y, 0);
-	glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, m_frameWidth, m_frameHeight,
-			GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE, m_frameData);
+	glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, m_frameWidth / 2, m_frameHeight,
+			GL_RGBA, GL_UNSIGNED_BYTE, m_frameData);
 	checkError("YUY2 paint");
 }
 #endif
-- 
1.8.3.2

