Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:39219 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804Ab3BJUEo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 15:04:44 -0500
Received: by mail-ea0-f174.google.com with SMTP id 1so2408710eaa.19
        for <linux-media@vger.kernel.org>; Sun, 10 Feb 2013 12:04:42 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 4/4] em28xx: VIDIOC_ENUM_FRAMESIZES: consider the scaler limits when calculating the minimum frame size
Date: Sun, 10 Feb 2013 21:05:14 +0100
Message-Id: <1360526714-3216-4-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1360526714-3216-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1360526714-3216-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Output resolutions <=20% of the input resolution exceed the capabilities of the
scaler.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |    8 ++++++--
 1 Datei geändert, 6 Zeilen hinzugefügt(+), 2 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index f745617..86fd907 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1405,8 +1405,12 @@ static int vidioc_enum_framesizes(struct file *file, void *priv,
 
 	/* Report a continuous range */
 	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
-	fsize->stepwise.min_width = 48;
-	fsize->stepwise.min_height = 32;
+	scale_to_size(dev, EM28XX_HVSCALE_MAX, EM28XX_HVSCALE_MAX,
+		      &fsize->stepwise.min_width, &fsize->stepwise.min_height);
+	if (fsize->stepwise.min_width < 48)
+		fsize->stepwise.min_width = 48;
+	if (fsize->stepwise.min_height < 38)
+		fsize->stepwise.min_height = 38;
 	fsize->stepwise.max_width = maxw;
 	fsize->stepwise.max_height = maxh;
 	fsize->stepwise.step_width = 1;
-- 
1.7.10.4

