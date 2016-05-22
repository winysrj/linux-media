Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33692 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbcEVQMU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 May 2016 12:12:20 -0400
Received: by mail-wm0-f66.google.com with SMTP id 67so8883696wmg.0
        for <linux-media@vger.kernel.org>; Sun, 22 May 2016 09:12:19 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-media@vger.kernel.org
Cc: crope@iki.fi,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 2/2] [media] rtl28xxu: sort the config symbols which are auto-selected
Date: Sun, 22 May 2016 18:12:07 +0200
Message-Id: <1463933527-11690-3-git-send-email-martin.blumenstingl@googlemail.com>
In-Reply-To: <1463933527-11690-1-git-send-email-martin.blumenstingl@googlemail.com>
References: <1463933527-11690-1-git-send-email-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/media/usb/dvb-usb-v2/Kconfig | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig b/drivers/media/usb/dvb-usb-v2/Kconfig
index fcecbf7..524533d 100644
--- a/drivers/media/usb/dvb-usb-v2/Kconfig
+++ b/drivers/media/usb/dvb-usb-v2/Kconfig
@@ -133,13 +133,13 @@ config DVB_USB_RTL28XXU
 	select DVB_RTL2832
 	select DVB_RTL2832_SDR if (MEDIA_SUBDRV_AUTOSELECT && MEDIA_SDR_SUPPORT)
 	select DVB_SI2168 if MEDIA_SUBDRV_AUTOSELECT
-	select MEDIA_TUNER_QT1010 if MEDIA_SUBDRV_AUTOSELECT
-	select MEDIA_TUNER_MT2060 if MEDIA_SUBDRV_AUTOSELECT
-	select MEDIA_TUNER_MXL5005S if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_E4000 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_FC0012 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_FC0013 if MEDIA_SUBDRV_AUTOSELECT
-	select MEDIA_TUNER_E4000 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_FC2580 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MT2060 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MXL5005S if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_QT1010 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_R820T if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_SI2157 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TUA9001 if MEDIA_SUBDRV_AUTOSELECT
-- 
2.8.2

