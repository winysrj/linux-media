Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:34785 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253AbbESJDB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 05:03:01 -0400
Received: by laat2 with SMTP id t2so13095378laa.1
        for <linux-media@vger.kernel.org>; Tue, 19 May 2015 02:02:59 -0700 (PDT)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Peter Seiderer <ps.report@gmx.net>, linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 1/2] qv4l2: gl: Add support for V4L2_PIX_FMT_Y16
Date: Tue, 19 May 2015 11:03:04 +0200
Message-Id: <1432026185-12284-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for a 16 bit wide greyscale format.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
This is the first time that I do something with OpenGL, please take a
good review of this patch before merging.

It has been tested with vivid and an nvidia-glx driver (propietary)
 utils/qv4l2/capture-win-gl.cpp | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/utils/qv4l2/capture-win-gl.cpp b/utils/qv4l2/capture-win-gl.cpp
index c691bfe0c3b9..ee51089b5775 100644
--- a/utils/qv4l2/capture-win-gl.cpp
+++ b/utils/qv4l2/capture-win-gl.cpp
@@ -412,6 +412,7 @@ bool CaptureWinGLEngine::hasNativeFormat(__u32 format)
 		V4L2_PIX_FMT_YUV565,
 		V4L2_PIX_FMT_YUV32,
 		V4L2_PIX_FMT_GREY,
+		V4L2_PIX_FMT_Y16,
 		0
 	};
 
@@ -507,6 +508,7 @@ void CaptureWinGLEngine::changeShader()
 	case V4L2_PIX_FMT_ARGB32:
 	case V4L2_PIX_FMT_ABGR32:
 	case V4L2_PIX_FMT_GREY:
+	case V4L2_PIX_FMT_Y16:
 	default:
 		shader_RGB(m_frameFormat);
 		break;
@@ -614,6 +616,7 @@ void CaptureWinGLEngine::paintGL()
 		break;
 
 	case V4L2_PIX_FMT_GREY:
+	case V4L2_PIX_FMT_Y16:
 	case V4L2_PIX_FMT_RGB332:
 	case V4L2_PIX_FMT_BGR666:
 	case V4L2_PIX_FMT_RGB555:
@@ -1545,6 +1548,10 @@ void CaptureWinGLEngine::shader_RGB(__u32 format)
 		glTexImage2D(GL_TEXTURE_2D, 0, internalFmt, m_frameWidth, m_frameHeight, 0,
 			     GL_LUMINANCE, GL_UNSIGNED_BYTE, NULL);
 		break;
+	case V4L2_PIX_FMT_Y16:
+		internalFmt = manualTransform ? GL_LUMINANCE : GL_SLUMINANCE;
+		glTexImage2D(GL_TEXTURE_2D, 0, internalFmt, m_frameWidth, m_frameHeight, 0,
+			     GL_LUMINANCE, GL_UNSIGNED_SHORT, NULL);
 	case V4L2_PIX_FMT_RGB24:
 	case V4L2_PIX_FMT_BGR24:
 	default:
@@ -1643,6 +1650,11 @@ void CaptureWinGLEngine::render_RGB(__u32 format)
 				GL_LUMINANCE, GL_UNSIGNED_BYTE, m_frameData);
 		break;
 
+	case V4L2_PIX_FMT_Y16:
+		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, m_frameWidth, m_frameHeight,
+				GL_LUMINANCE, GL_UNSIGNED_SHORT, m_frameData);
+		break;
+
 	case V4L2_PIX_FMT_RGB555X:
 	case V4L2_PIX_FMT_XRGB555X:
 	case V4L2_PIX_FMT_ARGB555X:
-- 
2.1.4

