Return-path: <mchehab@pedra>
Received: from adelie.canonical.com ([91.189.90.139]:48778 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab0JRMoi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 08:44:38 -0400
Subject: [PATCH] v4l-utils: libv4l1: When asked for RGB, return RGB and not
 BGR
From: Marc Deslauriers <marc.deslauriers@ubuntu.com>
To: linux-media@vger.kernel.org
Cc: marc.deslauriers@ubuntu.com, hdegoede@redhat.com
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 08:44:32 -0400
Message-ID: <1287405872.6471.23.camel@mdlinux>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

libv4l1: When asked for RGB, return RGB and not BGR

Signed-off-by: Marc Deslauriers <marc.deslauriers@ubuntu.com>
---
 lib/libv4l1/libv4l1.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/libv4l1/libv4l1.c b/lib/libv4l1/libv4l1.c
index cb53899..202f020 100644
--- a/lib/libv4l1/libv4l1.c
+++ b/lib/libv4l1/libv4l1.c
@@ -87,9 +87,9 @@ static unsigned int palette_to_pixelformat(unsigned
int palette)
 	case VIDEO_PALETTE_RGB565:
 		return V4L2_PIX_FMT_RGB565;
 	case VIDEO_PALETTE_RGB24:
-		return V4L2_PIX_FMT_BGR24;
+		return V4L2_PIX_FMT_RGB24;
 	case VIDEO_PALETTE_RGB32:
-		return V4L2_PIX_FMT_BGR32;
+		return V4L2_PIX_FMT_RGB32;
 	case VIDEO_PALETTE_YUYV:
 		return V4L2_PIX_FMT_YUYV;
 	case VIDEO_PALETTE_YUV422:
@@ -118,9 +118,9 @@ static unsigned int pixelformat_to_palette(unsigned
int pixelformat)
 		return VIDEO_PALETTE_RGB555;
 	case V4L2_PIX_FMT_RGB565:
 		return VIDEO_PALETTE_RGB565;
-	case V4L2_PIX_FMT_BGR24:
+	case V4L2_PIX_FMT_RGB24:
 		return VIDEO_PALETTE_RGB24;
-	case V4L2_PIX_FMT_BGR32:
+	case V4L2_PIX_FMT_RGB32:
 		return VIDEO_PALETTE_RGB32;
 	case V4L2_PIX_FMT_YUYV:
 		return VIDEO_PALETTE_YUYV;
-- 
1.7.1


