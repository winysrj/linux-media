Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46675 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757734AbaGYJnA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 05:43:00 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] Kconfig: fix tuners build warnings
Date: Fri, 25 Jul 2014 12:42:43 +0300
Message-Id: <1406281364-19497-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[next:master 7472/8702] warning: (USB_MSI2500) selects
MEDIA_TUNER_MSI001 which has unmet direct dependencies
((MEDIA_ANALOG_TV_SUPPORT || ..) && ..)

[next:master 7698/8702] warning: (MEDIA_TUNER && ..) selects
MEDIA_TUNER_XC5000 which has unmet direct dependencies
((MEDIA_ANALOG_TV_SUPPORT || ..) && ..)

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
index 51edd10..d79fd1c 100644
--- a/drivers/media/tuners/Kconfig
+++ b/drivers/media/tuners/Kconfig
@@ -16,7 +16,7 @@ config MEDIA_TUNER
 
 menu "Customize TV tuners"
 	visible if !MEDIA_SUBDRV_AUTOSELECT
-	depends on MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_RADIO_SUPPORT
+	depends on MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_RADIO_SUPPORT || MEDIA_SDR_SUPPORT
 
 config MEDIA_TUNER_SIMPLE
 	tristate "Simple tuner support"
@@ -74,6 +74,7 @@ config MEDIA_TUNER_TEA5767
 config MEDIA_TUNER_MSI001
 	tristate "Mirics MSi001"
 	depends on MEDIA_SUPPORT && SPI && VIDEO_V4L2
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Mirics MSi001 silicon tuner driver.
 
-- 
http://palosaari.fi/

