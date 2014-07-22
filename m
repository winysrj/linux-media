Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58197 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbaGVR1x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 13:27:53 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] tuners/Kconfig: fix build when just DTV or SDR is enabled
Date: Tue, 22 Jul 2014 14:27:44 -0300
Message-Id: <1406050064-10846-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by Kbuildtest:
	warning: (VIDEO_PVRUSB2 && VIDEO_TLG2300 && VIDEO_USBVISION && VIDEO_GO7007 && VIDEO_AU0828_V4L2 && VIDEO_CX231XX && VIDEO_TM6000 && VIDEO_EM28XX && VIDEO_IVTV && VIDEO_MXB && VIDEO_CX18 && VIDEO_CX23885 && VIDEO_CX88 && VIDEO_BT848 && VIDEO_SAA7134 && VIDEO_SAA7164) selects VIDEO_TUNER which has unmet direct dependencies (MEDIA_SUPPORT && MEDIA_TUNER)

That happens when:

	# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
	CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
	# CONFIG_MEDIA_RADIO_SUPPORT is not set
	# CONFIG_MEDIA_SDR_SUPPORT is not set
	CONFIG_VIDEO_AU0828_V4L2=y
	CONFIG_VIDEO_CX231XX=y
	CONFIG_VIDEO_TM6000=y
	CONFIG_VIDEO_EM28XX=y
	CONFIG_VIDEO_TUNER=y
	CONFIG_MEDIA_SUPPORT=y

With means that we need to enable MEDIA_TUNER also when DTV
is enabled. While the above config doesn't cover, if we enable
SDR, the same error can also happen.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/tuners/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
index 906461da1310..51edd101f250 100644
--- a/drivers/media/tuners/Kconfig
+++ b/drivers/media/tuners/Kconfig
@@ -1,7 +1,7 @@
 # Analog TV tuners, auto-loaded via tuner.ko
 config MEDIA_TUNER
 	tristate
-	depends on (MEDIA_ANALOG_TV_SUPPORT || MEDIA_RADIO_SUPPORT) && I2C
+	depends on (MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_RADIO_SUPPORT || MEDIA_SDR_SUPPORT) && I2C
 	default y
 	select MEDIA_TUNER_XC2028 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_XC5000 if MEDIA_SUBDRV_AUTOSELECT
-- 
1.9.3

