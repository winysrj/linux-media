Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:36326 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794Ab3BJUEm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 15:04:42 -0500
Received: by mail-ee0-f42.google.com with SMTP id b47so2784468eek.15
        for <linux-media@vger.kernel.org>; Sun, 10 Feb 2013 12:04:40 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 3/4] em28xx: add function scale_to_size()
Date: Sun, 10 Feb 2013 21:05:13 +0100
Message-Id: <1360526714-3216-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1360526714-3216-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1360526714-3216-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   15 ++++++++++++---
 1 Datei geändert, 12 Zeilen hinzugefügt(+), 3 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 197823c..f745617 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -815,6 +815,17 @@ static void size_to_scale(struct em28xx *dev,
 		*vscale = EM28XX_HVSCALE_MAX;
 }
 
+static void scale_to_size(struct em28xx *dev,
+			  unsigned int hscale, unsigned int vscale,
+			  unsigned int *width, unsigned int *height)
+{
+	unsigned int          maxw = norm_maxw(dev);
+	unsigned int          maxh = norm_maxh(dev);
+
+	*width = (((unsigned long)maxw) << 12) / (hscale + 4096L);
+	*height = (((unsigned long)maxh) << 12) / (vscale + 4096L);
+}
+
 /* ------------------------------------------------------------------
 	IOCTL vidioc handling
    ------------------------------------------------------------------*/
@@ -890,9 +901,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	}
 
 	size_to_scale(dev, width, height, &hscale, &vscale);
-
-	width = (((unsigned long)maxw) << 12) / (hscale + 4096L);
-	height = (((unsigned long)maxh) << 12) / (vscale + 4096L);
+	scale_to_size(dev, hscale, hscale, &width, &height);
 
 	f->fmt.pix.width = width;
 	f->fmt.pix.height = height;
-- 
1.7.10.4

