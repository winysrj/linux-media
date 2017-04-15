Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34947 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753437AbdDOKFp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Apr 2017 06:05:45 -0400
Received: by mail-wm0-f68.google.com with SMTP id d79so1921390wmi.2
        for <linux-media@vger.kernel.org>; Sat, 15 Apr 2017 03:05:44 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@kernel.org,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 5/5] em28xx: add support for V4L2_PIX_FMT_SRGGB8
Date: Sat, 15 Apr 2017 12:05:04 +0200
Message-Id: <20170415100504.3076-5-fschaefer.oss@googlemail.com>
In-Reply-To: <20170415100504.3076-1-fschaefer.oss@googlemail.com>
References: <20170415100504.3076-1-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index aaa83f9e5c1a..8d253a5df0a9 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -116,6 +116,11 @@ static struct em28xx_fmt format[] = {
 		.depth    = 16,
 		.reg      = EM28XX_OUTFMT_RGB_16_656,
 	}, {
+		.name     = "8 bpp Bayer RGRG..GBGB",
+		.fourcc   = V4L2_PIX_FMT_SRGGB8,
+		.depth    = 8,
+		.reg      = EM28XX_OUTFMT_RGB_8_RGRG,
+	}, {
 		.name     = "8 bpp Bayer BGBG..GRGR",
 		.fourcc   = V4L2_PIX_FMT_SBGGR8,
 		.depth    = 8,
-- 
2.12.2
