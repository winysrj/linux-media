Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([94.23.35.102]:43330 "EHLO
	mail.free-electrons.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751659Ab3G0TaA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Jul 2013 15:30:00 -0400
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] [media] stk1160: Build as a module if SND is m and audio support is selected
Date: Sat, 27 Jul 2013 16:29:36 -0300
Message-Id: <1374953376-21070-1-git-send-email-ezequiel.garcia@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by Randy Dunlap:

When CONFIG_SND=m and CONFIG_SND_AC97_CODEC=m and
CONFIG_VIDEO_STK1160=y
CONFIG_VIDEO_STK1160_AC97=y

drivers/built-in.o: In function `stk1160_ac97_register':
(.text+0x122706): undefined reference to `snd_card_create'
drivers/built-in.o: In function `stk1160_ac97_register':
(.text+0x1227b2): undefined reference to `snd_ac97_bus'
drivers/built-in.o: In function `stk1160_ac97_register':
(.text+0x1227cd): undefined reference to `snd_card_free'
drivers/built-in.o: In function `stk1160_ac97_register':
(.text+0x12281b): undefined reference to `snd_ac97_mixer'
drivers/built-in.o: In function `stk1160_ac97_register':
(.text+0x122832): undefined reference to `snd_card_register'
drivers/built-in.o: In function `stk1160_ac97_unregister':
(.text+0x12285e): undefined reference to `snd_card_free'

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
---
 drivers/media/usb/stk1160/Kconfig | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/stk1160/Kconfig b/drivers/media/usb/stk1160/Kconfig
index 1c3a1ec..95584c1 100644
--- a/drivers/media/usb/stk1160/Kconfig
+++ b/drivers/media/usb/stk1160/Kconfig
@@ -1,8 +1,6 @@
-config VIDEO_STK1160
+config VIDEO_STK1160_COMMON
 	tristate "STK1160 USB video capture support"
 	depends on VIDEO_DEV && I2C
-	select VIDEOBUF2_VMALLOC
-	select VIDEO_SAA711X
 
 	---help---
 	  This is a video4linux driver for STK1160 based video capture devices.
@@ -12,9 +10,15 @@ config VIDEO_STK1160
 
 config VIDEO_STK1160_AC97
 	bool "STK1160 AC97 codec support"
-	depends on VIDEO_STK1160 && SND
-	select SND_AC97_CODEC
+	depends on VIDEO_STK1160_COMMON && SND
 
 	---help---
 	  Enables AC97 codec support for stk1160 driver.
-.
+
+config VIDEO_STK1160
+	tristate
+	depends on (!VIDEO_STK1160_AC97 || (SND='n') || SND) && VIDEO_STK1160_COMMON
+	default y
+	select VIDEOBUF2_VMALLOC
+	select VIDEO_SAA711X
+	select SND_AC97_CODEC if SND
-- 
1.8.1.5

