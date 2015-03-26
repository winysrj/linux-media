Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:33957 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbbCZQRj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2015 12:17:39 -0400
Received: by lagg8 with SMTP id g8so49643541lag.1
        for <linux-media@vger.kernel.org>; Thu, 26 Mar 2015 09:17:37 -0700 (PDT)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>,
	Gregor Jasny <gjasny@googlemail.com>,
	linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] libv4lconvert: Fix support for Y16 pixel format
Date: Thu, 26 Mar 2015 17:17:34 +0100
Message-Id: <1427386654-31906-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Y16 is a little-endian format. The original implementation assumed that
it was big-endian.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 lib/libv4lconvert/rgbyuv.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/libv4lconvert/rgbyuv.c b/lib/libv4lconvert/rgbyuv.c
index 0f30192..75c42aa 100644
--- a/lib/libv4lconvert/rgbyuv.c
+++ b/lib/libv4lconvert/rgbyuv.c
@@ -591,6 +591,9 @@ void v4lconvert_y16_to_rgb24(const unsigned char *src, unsigned char *dest,
 		int width, int height)
 {
 	int j;
+
+	src++; /*Y16 is little endian*/
+
 	while (--height >= 0) {
 		for (j = 0; j < width; j++) {
 			*dest++ = *src;
@@ -606,6 +609,8 @@ void v4lconvert_y16_to_yuv420(const unsigned char *src, unsigned char *dest,
 {
 	int x, y;
 
+	src++; /*Y16 is little endian*/
+
 	/* Y */
 	for (y = 0; y < src_fmt->fmt.pix.height; y++)
 		for (x = 0; x < src_fmt->fmt.pix.width; x++){
-- 
2.1.4

