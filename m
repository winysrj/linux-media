Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48853 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752337AbcKRUBN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 15:01:13 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Antti Palosaari <crope@iki.fi>,
        Matthias Schwarzott <zzam@gentoo.org>,
        Abylay Ospan <aospan@netup.ru>
Subject: [PATCH] [media] Kconfig: fix breakages when DVB_CORE is not selected
Date: Fri, 18 Nov 2016 18:00:51 -0200
Message-Id: <a4afb3ed430af793702c32ff2e68613263291e81.1479499245.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On some weird randconfigs, it is possible to select DVB
drivers, without having the DVB_CORE:

CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_V4L=m
CONFIG_DVB_TUNER_DIB0090=m

This was never supposed to work, but changeset 22a613e89825
("[media] dvb_frontend: merge duplicate dvb_tuner_ops.release implementations")
caused it to be exposed:

   drivers/built-in.o: In function `fc0011_attach':
   (.text+0x1598fb): undefined reference to `dvb_tuner_simple_release'
   drivers/built-in.o:(.rodata+0x55e58): undefined reference to `dvb_tuner_simple_release'
   drivers/built-in.o:(.rodata+0x57398): undefined reference to `dvb_tuner_simple_release'

Fixes: 22a613e89825 ("[media] dvb_frontend: merge duplicate dvb_tuner_ops.release implementations")
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/Kconfig               | 2 +-
 drivers/media/dvb-frontends/Kconfig | 9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index bc643cbf813e..3512316e7a46 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -115,7 +115,7 @@ config MEDIA_CONTROLLER
 
 config MEDIA_CONTROLLER_DVB
 	bool "Enable Media controller for DVB (EXPERIMENTAL)"
-	depends on MEDIA_CONTROLLER
+	depends on MEDIA_CONTROLLER && DVB_CORE
 	---help---
 	  Enable the media controller API support for DVB.
 
diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index b71b747ee0ba..c841fa1770be 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -642,7 +642,7 @@ config DVB_S5H1409
 	  to support this frontend.
 
 config DVB_AU8522
-	depends on I2C
+	depends on DVB_CORE && I2C
 	tristate
 
 config DVB_AU8522_DTV
@@ -656,7 +656,7 @@ config DVB_AU8522_DTV
 
 config DVB_AU8522_V4L
 	tristate "Auvitek AU8522 based ATV demod"
-	depends on VIDEO_V4L2 && I2C
+	depends on VIDEO_V4L2 && DVB_CORE && I2C
 	select DVB_AU8522
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
@@ -722,7 +722,7 @@ config DVB_PLL
 
 config DVB_TUNER_DIB0070
 	tristate "DiBcom DiB0070 silicon base-band tuner"
-	depends on I2C
+	depends on DVB_CORE && I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A driver for the silicon baseband tuner DiB0070 from DiBcom.
@@ -731,7 +731,7 @@ config DVB_TUNER_DIB0070
 
 config DVB_TUNER_DIB0090
 	tristate "DiBcom DiB0090 silicon base-band tuner"
-	depends on I2C
+	depends on DVB_CORE && I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A driver for the silicon baseband tuner DiB0090 from DiBcom.
@@ -879,5 +879,6 @@ comment "Tools to develop new frontends"
 
 config DVB_DUMMY_FE
 	tristate "Dummy frontend driver"
+	depends on DVB_CORE
 	default n
 endmenu
-- 
2.7.4

