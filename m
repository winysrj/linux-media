Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43824 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965174Ab2JCRst (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2012 13:48:49 -0400
Received: by wibhr7 with SMTP id hr7so2797393wib.1
        for <linux-media@vger.kernel.org>; Wed, 03 Oct 2012 10:48:48 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: hdegoede@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] libv4lconvert: clarify the behavior and resulting restrictions of v4lconvert_convert()
Date: Wed,  3 Oct 2012 19:48:39 +0300
Message-Id: <1349282919-15332-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 lib/include/libv4lconvert.h |   20 ++++++++++++++++++--
 1 Datei geändert, 18 Zeilen hinzugefügt(+), 2 Zeilen entfernt(-)

diff --git a/lib/include/libv4lconvert.h b/lib/include/libv4lconvert.h
index 167b57d..509655e 100644
--- a/lib/include/libv4lconvert.h
+++ b/lib/include/libv4lconvert.h
@@ -89,8 +89,24 @@ LIBV4L_PUBLIC int v4lconvert_needs_conversion(struct v4lconvert_data *data,
 		const struct v4l2_format *src_fmt,   /* in */
 		const struct v4l2_format *dest_fmt); /* in */
 
-/* return value of -1 on error, otherwise the amount of bytes written to
-   dest */
+/* This function does the following conversions:
+    - format conversion
+    - cropping
+   if enabled:
+    - processing (auto whitebalance, auto gain, gamma correction)
+    - horizontal/vertical flipping
+    - 90 degree (clockwise) rotation
+   
+   NOTE: the last 3 steps are enabled/disabled depending on
+    - the internal device list
+    - the state of the (software emulated) image controls 
+  
+   Therefore this function should
+    - not be used when getting the frames from libv4l
+    - be called only once per frame
+   Otherwise this may result in unintended double conversions !
+  
+   Returns the amount of bytes written to dest an -1 on error */
 LIBV4L_PUBLIC int v4lconvert_convert(struct v4lconvert_data *data,
 		const struct v4l2_format *src_fmt,  /* in */
 		const struct v4l2_format *dest_fmt, /* in */
-- 
1.7.10.4

