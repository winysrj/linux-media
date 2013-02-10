Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:62787 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794Ab3BJUEk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 15:04:40 -0500
Received: by mail-ee0-f42.google.com with SMTP id b47so2786290eek.1
        for <linux-media@vger.kernel.org>; Sun, 10 Feb 2013 12:04:39 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 1/4] em28xx: introduce #define for maximum supported scaling values (register 0x30-0x33)
Date: Sun, 10 Feb 2013 21:05:11 +0100
Message-Id: <1360526714-3216-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The maximum supported scaling value for registers 0x30+0x31 (horizontal scaling)
and 0x32+0x33 (vertical scaling) is 0x3fff, which corresponds to 20% of the
input frame size.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-reg.h   |    2 ++
 drivers/media/usb/em28xx/em28xx-video.c |    8 ++++----
 2 Dateien geändert, 6 Zeilen hinzugefügt(+), 4 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-reg.h b/drivers/media/usb/em28xx/em28xx-reg.h
index 885089e..0a3cb04 100644
--- a/drivers/media/usb/em28xx/em28xx-reg.h
+++ b/drivers/media/usb/em28xx/em28xx-reg.h
@@ -152,6 +152,8 @@
 #define EM28XX_R31_HSCALEHIGH	0x31
 #define EM28XX_R32_VSCALELOW	0x32
 #define EM28XX_R33_VSCALEHIGH	0x33
+#define   EM28XX_HVSCALE_MAX	0x3fff /* => 20% */
+
 #define EM28XX_R34_VBI_START_H	0x34
 #define EM28XX_R35_VBI_START_V	0x35
 #define EM28XX_R36_VBI_WIDTH	0x36
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 6d26123..9451e1e 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -807,12 +807,12 @@ static void get_scale(struct em28xx *dev,
 	unsigned int          maxh = norm_maxh(dev);
 
 	*hscale = (((unsigned long)maxw) << 12) / width - 4096L;
-	if (*hscale >= 0x4000)
-		*hscale = 0x3fff;
+	if (*hscale > EM28XX_HVSCALE_MAX)
+		*hscale = EM28XX_HVSCALE_MAX;
 
 	*vscale = (((unsigned long)maxh) << 12) / height - 4096L;
-	if (*vscale >= 0x4000)
-		*vscale = 0x3fff;
+	if (*vscale > EM28XX_HVSCALE_MAX)
+		*vscale = EM28XX_HVSCALE_MAX;
 }
 
 /* ------------------------------------------------------------------
-- 
1.7.10.4

