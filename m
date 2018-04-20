Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:53398 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754591AbeDTMcU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 08:32:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org
Subject: [PATCH 3/4] sound, media: allow building ISA drivers it with COMPILE_TEST
Date: Fri, 20 Apr 2018 08:32:15 -0400
Message-Id: <3f4d8ae83a91c765581d9cbbd1e436b6871368fa.1524227382.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1524227382.git.mchehab@s-opensource.com>
References: <cover.1524227382.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1524227382.git.mchehab@s-opensource.com>
References: <cover.1524227382.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All sound drivers that don't depend on PNP can be safelly
build with COMPILE_TEST, as ISA provides function stubs to
be used for such purposes.

As a side effect, with this change, the radio-miropcm20
can now be built outside i386 with COMPILE_TEST.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/radio/Kconfig | 3 ++-
 sound/isa/Kconfig           | 9 +++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index d363726e9eb1..8fa403c7149e 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -372,7 +372,8 @@ config RADIO_GEMTEK_PROBE
 
 config RADIO_MIROPCM20
 	tristate "miroSOUND PCM20 radio"
-	depends on ISA && ISA_DMA_API && VIDEO_V4L2 && SND
+	depends on ISA || COMPILE_TEST
+	depends on ISA_DMA_API && VIDEO_V4L2 && SND
 	select SND_ISA
 	select SND_MIRO
 	---help---
diff --git a/sound/isa/Kconfig b/sound/isa/Kconfig
index cb54d9c0a77f..d2a6cdd0395c 100644
--- a/sound/isa/Kconfig
+++ b/sound/isa/Kconfig
@@ -20,7 +20,8 @@ config SND_SB16_DSP
 
 menuconfig SND_ISA
 	bool "ISA sound devices"
-	depends on ISA && ISA_DMA_API
+	depends on ISA || COMPILE_TEST
+	depends on ISA_DMA_API
 	default y
 	help
 	  Support for sound devices connected via the ISA bus.
@@ -38,7 +39,7 @@ config SND_ADLIB
 
 config SND_AD1816A
 	tristate "Analog Devices SoundPort AD1816A"
-	depends on PNP
+	depends on PNP && ISA
 	select ISAPNP
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
@@ -66,7 +67,7 @@ config SND_AD1848
 
 config SND_ALS100
 	tristate "Diamond Tech. DT-019x and Avance Logic ALSxxx"
-	depends on PNP
+	depends on PNP && ISA
 	select ISAPNP
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
@@ -107,7 +108,7 @@ config SND_AZT2316
 
 config SND_AZT2320
 	tristate "Aztech Systems AZT2320"
-	depends on PNP
+	depends on PNP && ISA
 	select ISAPNP
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
-- 
2.14.3
