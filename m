Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56723 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbaGVE2G (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 00:28:06 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] rtl2832_sdr: fix Kconfig dependencies
Date: Tue, 22 Jul 2014 07:28:00 +0300
Message-Id: <1406003280-14254-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MEDIA_SDR_SUPPORT and I2C_MUX are needed for rtl2832_sdr.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/Kconfig  | 2 +-
 drivers/media/usb/dvb-usb-v2/Kconfig | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 7225f05..78a95a6 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -448,7 +448,7 @@ config DVB_RTL2832
 
 config DVB_RTL2832_SDR
 	tristate "Realtek RTL2832 SDR"
-	depends on DVB_CORE && I2C && VIDEO_V4L2
+	depends on DVB_CORE && I2C && I2C_MUX && VIDEO_V4L2 && MEDIA_SDR_SUPPORT
 	select DVB_RTL2832
 	select VIDEOBUF2_VMALLOC
 	default m if !MEDIA_SUBDRV_AUTOSELECT
diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig b/drivers/media/usb/dvb-usb-v2/Kconfig
index 0ea144e..66645b0 100644
--- a/drivers/media/usb/dvb-usb-v2/Kconfig
+++ b/drivers/media/usb/dvb-usb-v2/Kconfig
@@ -129,7 +129,7 @@ config DVB_USB_RTL28XXU
 	depends on DVB_USB_V2 && I2C_MUX
 	select DVB_RTL2830
 	select DVB_RTL2832
-	select DVB_RTL2832_SDR if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_RTL2832_SDR if (MEDIA_SUBDRV_AUTOSELECT && MEDIA_SDR_SUPPORT)
 	select MEDIA_TUNER_QT1010 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_MT2060 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_MXL5005S if MEDIA_SUBDRV_AUTOSELECT
-- 
http://palosaari.fi/

