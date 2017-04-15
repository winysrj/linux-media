Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36697 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753234AbdDOKFl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Apr 2017 06:05:41 -0400
Received: by mail-wm0-f66.google.com with SMTP id q125so1908496wmd.3
        for <linux-media@vger.kernel.org>; Sat, 15 Apr 2017 03:05:40 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@kernel.org,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 2/5] em28xx: add missing auto-selections for build
Date: Sat, 15 Apr 2017 12:05:01 +0200
Message-Id: <20170415100504.3076-2-fschaefer.oss@googlemail.com>
In-Reply-To: <20170415100504.3076-1-fschaefer.oss@googlemail.com>
References: <20170415100504.3076-1-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With MEDIA_SUBDRV_AUTOSELECT enabled in the kernel config, the em28xx
driver currently does't select some used subdrivers.
Fix this by adding the missing auto-selections to the Kconfig file.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/Kconfig | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/Kconfig b/drivers/media/usb/em28xx/Kconfig
index aa131cf9989b..4cc029f18aa8 100644
--- a/drivers/media/usb/em28xx/Kconfig
+++ b/drivers/media/usb/em28xx/Kconfig
@@ -12,7 +12,7 @@ config VIDEO_EM28XX_V4L2
 	select VIDEO_TVP5150 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_MSP3400 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_MT9V011 if MEDIA_SUBDRV_AUTOSELECT && MEDIA_CAMERA_SUPPORT
-
+	select VIDEO_OV2640 if MEDIA_SUBDRV_AUTOSELECT && MEDIA_CAMERA_SUPPORT
 	---help---
 	  This is a video4linux driver for Empia 28xx based TV cards.
 
@@ -39,6 +39,7 @@ config VIDEO_EM28XX_DVB
 	depends on VIDEO_EM28XX && DVB_CORE
 	select DVB_LGDT330X if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_LGDT3305 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_LGDT3306A if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_ZL10353 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_TDA10023 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_S921 if MEDIA_SUBDRV_AUTOSELECT
@@ -61,6 +62,10 @@ config VIDEO_EM28XX_DVB
 	select MEDIA_TUNER_SI2157 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_TC90522 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_QM1D1C0042 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_SIMPLE if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_XC2028 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_XC5000 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MT2060 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  This adds support for DVB cards based on the
 	  Empiatech em28xx chips.
-- 
2.12.2
