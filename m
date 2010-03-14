Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:64503 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab0CNR2t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Mar 2010 13:28:49 -0400
Received: by fxm27 with SMTP id 27so3080084fxm.28
        for <linux-media@vger.kernel.org>; Sun, 14 Mar 2010 10:28:48 -0700 (PDT)
Message-ID: <4B9D1CD6.3030505@googlemail.com>
Date: Sun, 14 Mar 2010 18:28:54 +0100
From: Frank Schaefer <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] v4l2_ctrl_get_name(): add missing control names, and make
 title for V4L2_CID_BG_COLOR consistent
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_ctrl_get_name(): add missing control names, and make title for
V4L2_CID_BG_COLOR consistent

V4L2_CID_AUTOBRIGHTNESS   was introduced with kernel 2.6.31
V4L2_CID_BAND_STOP_FILTER was introduced with kernel 2.6.32

Signed-off-by: Frank Schaefer <fschaefer.oss@googlemail.com>

diff --git a/drivers/media/video/v4l2-common.c
b/drivers/media/video/v4l2-common.c
index 36b5cb8..e679834 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -431,8 +431,10 @@ const char *v4l2_ctrl_get_name(u32 id)
     case V4L2_CID_CHROMA_AGC:        return "Chroma AGC";
     case V4L2_CID_COLOR_KILLER:        return "Color Killer";
     case V4L2_CID_COLORFX:            return "Color Effects";
+    case V4L2_CID_AUTOBRIGHTNESS:        return "Brightness, Automatic";
+    case V4L2_CID_BAND_STOP_FILTER:        return "Band-Stop Filter";
     case V4L2_CID_ROTATE:            return "Rotate";
-    case V4L2_CID_BG_COLOR:            return "Background color";
+    case V4L2_CID_BG_COLOR:            return "Background Color";
 
     /* MPEG controls */
     case V4L2_CID_MPEG_CLASS:         return "MPEG Encoder Controls";
-- 
1.6.0.2
