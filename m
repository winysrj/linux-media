Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:48532 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754607AbeDTMcU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 08:32:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/4] media: radio: allow building ISA drivers with COMPILE_TEST
Date: Fri, 20 Apr 2018 08:32:13 -0400
Message-Id: <333f43d5373f6f821c424ccabce3b9b1fa180921.1524227382.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1524227382.git.mchehab@s-opensource.com>
References: <cover.1524227382.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1524227382.git.mchehab@s-opensource.com>
References: <cover.1524227382.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several radio devices only build on i386, because they depend
on ISA. Allow them to build on other archs by adding a
COMPILE_TEST check.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/radio/Kconfig | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 2ed539f9eb87..d363726e9eb1 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -231,7 +231,7 @@ source "drivers/media/radio/wl128x/Kconfig"
 
 menuconfig V4L_RADIO_ISA_DRIVERS
 	bool "ISA radio devices"
-	depends on ISA
+	depends on ISA || COMPILE_TEST
 	default n
 	---help---
 	  Say Y here to enable support for these ISA drivers.
@@ -239,12 +239,13 @@ menuconfig V4L_RADIO_ISA_DRIVERS
 if V4L_RADIO_ISA_DRIVERS
 
 config RADIO_ISA
-	depends on ISA
+	depends on ISA || COMPILE_TEST
 	tristate
 
 config RADIO_CADET
 	tristate "ADS Cadet AM/FM Tuner"
-	depends on ISA && VIDEO_V4L2
+	depends on ISA || COMPILE_TEST
+	depends on VIDEO_V4L2
 	---help---
 	  Choose Y here if you have one of these AM/FM radio cards, and then
 	  fill in the port address below.
@@ -254,8 +255,8 @@ config RADIO_CADET
 
 config RADIO_RTRACK
 	tristate "AIMSlab RadioTrack (aka RadioReveal) support"
-	depends on ISA && VIDEO_V4L2
-	select RADIO_ISA
+	depends on ISA || COMPILE_TEST
+	depends on VIDEO_V4L2
 	---help---
 	  Choose Y here if you have one of these FM radio cards, and then fill
 	  in the port address below.
@@ -285,7 +286,8 @@ config RADIO_RTRACK_PORT
 
 config RADIO_RTRACK2
 	tristate "AIMSlab RadioTrack II support"
-	depends on ISA && VIDEO_V4L2
+	depends on ISA || COMPILE_TEST
+	depends on VIDEO_V4L2
 	select RADIO_ISA
 	---help---
 	  Choose Y here if you have this FM radio card, and then fill in the
@@ -308,7 +310,8 @@ config RADIO_RTRACK2_PORT
 
 config RADIO_AZTECH
 	tristate "Aztech/Packard Bell Radio"
-	depends on ISA && VIDEO_V4L2
+	depends on ISA || COMPILE_TEST
+	depends on VIDEO_V4L2
 	select RADIO_ISA
 	---help---
 	  Choose Y here if you have one of these FM radio cards, and then fill
@@ -328,7 +331,8 @@ config RADIO_AZTECH_PORT
 
 config RADIO_GEMTEK
 	tristate "GemTek Radio card (or compatible) support"
-	depends on ISA && VIDEO_V4L2
+	depends on ISA || COMPILE_TEST
+	depends on VIDEO_V4L2
 	select RADIO_ISA
 	---help---
 	  Choose Y here if you have this FM radio card, and then fill in the
@@ -382,7 +386,8 @@ config RADIO_MIROPCM20
 
 config RADIO_SF16FMI
 	tristate "SF16-FMI/SF16-FMP/SF16-FMD Radio"
-	depends on ISA && VIDEO_V4L2
+	depends on ISA || COMPILE_TEST
+	depends on VIDEO_V4L2
 	---help---
 	  Choose Y here if you have one of these FM radio cards.
 
@@ -391,7 +396,8 @@ config RADIO_SF16FMI
 
 config RADIO_SF16FMR2
 	tristate "SF16-FMR2/SF16-FMD2 Radio"
-	depends on ISA && VIDEO_V4L2
+	depends on ISA || COMPILE_TEST
+	depends on VIDEO_V4L2
 	select RADIO_TEA575X
 	---help---
 	  Choose Y here if you have one of these FM radio cards.
@@ -401,7 +407,8 @@ config RADIO_SF16FMR2
 
 config RADIO_TERRATEC
 	tristate "TerraTec ActiveRadio ISA Standalone"
-	depends on ISA && VIDEO_V4L2
+	depends on ISA || COMPILE_TEST
+	depends on VIDEO_V4L2
 	select RADIO_ISA
 	---help---
 	  Choose Y here if you have this FM radio card.
@@ -415,7 +422,8 @@ config RADIO_TERRATEC
 
 config RADIO_TRUST
 	tristate "Trust FM radio card"
-	depends on ISA && VIDEO_V4L2
+	depends on ISA || COMPILE_TEST
+	depends on VIDEO_V4L2
 	select RADIO_ISA
 	help
 	  This is a driver for the Trust FM radio cards. Say Y if you have
@@ -438,7 +446,8 @@ config RADIO_TRUST_PORT
 
 config RADIO_TYPHOON
 	tristate "Typhoon Radio (a.k.a. EcoRadio)"
-	depends on ISA && VIDEO_V4L2
+	depends on ISA || COMPILE_TEST
+	depends on VIDEO_V4L2
 	select RADIO_ISA
 	---help---
 	  Choose Y here if you have one of these FM radio cards, and then fill
@@ -472,7 +481,8 @@ config RADIO_TYPHOON_MUTEFREQ
 
 config RADIO_ZOLTRIX
 	tristate "Zoltrix Radio"
-	depends on ISA && VIDEO_V4L2
+	depends on ISA || COMPILE_TEST
+	depends on VIDEO_V4L2
 	select RADIO_ISA
 	---help---
 	  Choose Y here if you have one of these FM radio cards, and then fill
-- 
2.14.3
