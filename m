Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:34802 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290AbbESJDB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 05:03:01 -0400
Received: by laat2 with SMTP id t2so13095910laa.1
        for <linux-media@vger.kernel.org>; Tue, 19 May 2015 02:03:00 -0700 (PDT)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Peter Seiderer <ps.report@gmx.net>, linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 2/2] qv4l2: gl: Add support for V4L2_PIX_FMT_Y16_BE
Date: Tue, 19 May 2015 11:03:05 +0200
Message-Id: <1432026185-12284-2-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1432026185-12284-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1432026185-12284-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for a 16 bit wide greyscale format in big endian.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
This patch needs to be applied after the headers have been updated
to support Y16_BE. It is scheduled for 4.2.

It has been tested with vivid and an nvidia-glx driver (propietary)
 utils/qv4l2/capture-win-gl.cpp | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/utils/qv4l2/capture-win-gl.cpp b/utils/qv4l2/capture-win-gl.cpp
index ee51089b5775..25dec3e79070 100644
--- a/utils/qv4l2/capture-win-gl.cpp
+++ b/utils/qv4l2/capture-win-gl.cpp
@@ -413,6 +413,7 @@ bool CaptureWinGLEngine::hasNativeFormat(__u32 format)
 		V4L2_PIX_FMT_YUV32,
 		V4L2_PIX_FMT_GREY,
 		V4L2_PIX_FMT_Y16,
+		V4L2_PIX_FMT_Y16_BE,
 		0
 	};
 
@@ -509,6 +510,7 @@ void CaptureWinGLEngine::changeShader()
 	case V4L2_PIX_FMT_ABGR32:
 	case V4L2_PIX_FMT_GREY:
 	case V4L2_PIX_FMT_Y16:
+	case V4L2_PIX_FMT_Y16_BE:
 	default:
 		shader_RGB(m_frameFormat);
 		break;
@@ -617,6 +619,7 @@ void CaptureWinGLEngine::paintGL()
 
 	case V4L2_PIX_FMT_GREY:
 	case V4L2_PIX_FMT_Y16:
+	case V4L2_PIX_FMT_Y16_BE:
 	case V4L2_PIX_FMT_RGB332:
 	case V4L2_PIX_FMT_BGR666:
 	case V4L2_PIX_FMT_RGB555:
@@ -1549,6 +1552,7 @@ void CaptureWinGLEngine::shader_RGB(__u32 format)
 			     GL_LUMINANCE, GL_UNSIGNED_BYTE, NULL);
 		break;
 	case V4L2_PIX_FMT_Y16:
+	case V4L2_PIX_FMT_Y16_BE:
 		internalFmt = manualTransform ? GL_LUMINANCE : GL_SLUMINANCE;
 		glTexImage2D(GL_TEXTURE_2D, 0, internalFmt, m_frameWidth, m_frameHeight, 0,
 			     GL_LUMINANCE, GL_UNSIGNED_SHORT, NULL);
@@ -1654,6 +1658,12 @@ void CaptureWinGLEngine::render_RGB(__u32 format)
 		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, m_frameWidth, m_frameHeight,
 				GL_LUMINANCE, GL_UNSIGNED_SHORT, m_frameData);
 		break;
+	case V4L2_PIX_FMT_Y16_BE:
+		glPixelStorei(GL_UNPACK_SWAP_BYTES, GL_TRUE);
+		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, m_frameWidth, m_frameHeight,
+				GL_LUMINANCE, GL_UNSIGNED_SHORT, m_frameData);
+		glPixelStorei(GL_UNPACK_SWAP_BYTES, GL_FALSE);
+		break;
 
 	case V4L2_PIX_FMT_RGB555X:
 	case V4L2_PIX_FMT_XRGB555X:
-- 
2.1.4

