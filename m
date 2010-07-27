Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43216 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab0G0Mdh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jul 2010 08:33:37 -0400
Received: by fxm14 with SMTP id 14so580986fxm.19
        for <linux-media@vger.kernel.org>; Tue, 27 Jul 2010 05:33:36 -0700 (PDT)
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 1/2] drivers: usbvideo: remove custom implementation of hex_to_bin()
Date: Tue, 27 Jul 2010 15:32:49 +0300
Message-Id: <aaffa1b668767c4bf7ce9baf2d5c5dfb11784c19.1280233873.git.andy.shevchenko@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/media/video/usbvideo/usbvideo.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/usbvideo/usbvideo.c b/drivers/media/video/usbvideo/usbvideo.c
index 5ac37c6..f1fcf97 100644
--- a/drivers/media/video/usbvideo/usbvideo.c
+++ b/drivers/media/video/usbvideo/usbvideo.c
@@ -282,19 +282,15 @@ static void usbvideo_OverlayChar(struct uvd *uvd, struct usbvideo_frame *frame,
 	};
 	unsigned short digit;
 	int ix, iy;
+	int value;
 
 	if ((uvd == NULL) || (frame == NULL))
 		return;
 
-	if (ch >= '0' && ch <= '9')
-		ch -= '0';
-	else if (ch >= 'A' && ch <= 'F')
-		ch = 10 + (ch - 'A');
-	else if (ch >= 'a' && ch <= 'f')
-		ch = 10 + (ch - 'a');
-	else
+	value = hex_to_bin(ch);
+	if (value < 0)
 		return;
-	digit = digits[ch];
+	digit = digits[value];
 
 	for (iy=0; iy < 5; iy++) {
 		for (ix=0; ix < 3; ix++) {
-- 
1.7.1.1

