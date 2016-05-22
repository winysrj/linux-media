Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33688 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbcEVQMT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 May 2016 12:12:19 -0400
Received: by mail-wm0-f67.google.com with SMTP id 67so8883635wmg.0
        for <linux-media@vger.kernel.org>; Sun, 22 May 2016 09:12:19 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-media@vger.kernel.org
Cc: crope@iki.fi,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 1/2] [media] rtl28xxu: auto-select more DVB-frontends and tuners
Date: Sun, 22 May 2016 18:12:06 +0200
Message-Id: <1463933527-11690-2-git-send-email-martin.blumenstingl@googlemail.com>
In-Reply-To: <1463933527-11690-1-git-send-email-martin.blumenstingl@googlemail.com>
References: <1463933527-11690-1-git-send-email-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds the missing auto-select bits for DVB-frontends and tuners
(if MEDIA_SUBDRV_AUTOSELECT is enabled) which are used by the various
rtl28xxu devices.
The driver itself probes for three more tuners, but it's not actually
using any of them:
- MEDIA_TUNER_MT2063
- MEDIA_TUNER_MT2266
- MEDIA_TUNER_MXL5007T

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/media/usb/dvb-usb-v2/Kconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig b/drivers/media/usb/dvb-usb-v2/Kconfig
index 3dc8ef0..fcecbf7 100644
--- a/drivers/media/usb/dvb-usb-v2/Kconfig
+++ b/drivers/media/usb/dvb-usb-v2/Kconfig
@@ -127,9 +127,12 @@ config DVB_USB_MXL111SF
 config DVB_USB_RTL28XXU
 	tristate "Realtek RTL28xxU DVB USB support"
 	depends on DVB_USB_V2 && I2C_MUX
+	select DVB_MN88472 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_MN88473 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_RTL2830
 	select DVB_RTL2832
 	select DVB_RTL2832_SDR if (MEDIA_SUBDRV_AUTOSELECT && MEDIA_SDR_SUPPORT)
+	select DVB_SI2168 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_QT1010 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_MT2060 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_MXL5005S if MEDIA_SUBDRV_AUTOSELECT
@@ -138,6 +141,8 @@ config DVB_USB_RTL28XXU
 	select MEDIA_TUNER_E4000 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_FC2580 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_R820T if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_SI2157 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TUA9001 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the Realtek RTL28xxU DVB USB receiver.
 
-- 
2.8.2

