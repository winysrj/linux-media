Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33411 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752786AbcJ0Ozk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Oct 2016 10:55:40 -0400
Received: by mail-wm0-f66.google.com with SMTP id m83so3107888wmc.0
        for <linux-media@vger.kernel.org>; Thu, 27 Oct 2016 07:55:27 -0700 (PDT)
Date: Thu, 27 Oct 2016 11:10:05 +0200
From: Marcel Hasler <mahasler@gmail.com>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 3/3] stk1160: Remove VIDEO_STK1160_AC97 and SND_AC97_CODEC
 from Kconfig and Makefile.
Message-ID: <20161027091005.GA21534@arch-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VIDEO_STK1160_AC97 option is no longer needed after the removal of stk1160-mixer. For the
same reason SND and SND_AC97_CODEC are no longer required.

Signed-off-by: Marcel Hasler <mahasler@gmail.com>
---
 drivers/media/usb/stk1160/Kconfig  | 3 +--
 drivers/media/usb/stk1160/Makefile | 4 +---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/stk1160/Kconfig b/drivers/media/usb/stk1160/Kconfig
index 53617da..22dff4f 100644
--- a/drivers/media/usb/stk1160/Kconfig
+++ b/drivers/media/usb/stk1160/Kconfig
@@ -10,8 +10,7 @@ config VIDEO_STK1160_COMMON
 
 config VIDEO_STK1160
 	tristate
-	depends on (!VIDEO_STK1160_AC97 || (SND='n') || SND) && VIDEO_STK1160_COMMON
+	depends on VIDEO_STK1160_COMMON
 	default y
 	select VIDEOBUF2_VMALLOC
 	select VIDEO_SAA711X
-	select SND_AC97_CODEC if SND
diff --git a/drivers/media/usb/stk1160/Makefile b/drivers/media/usb/stk1160/Makefile
index dfe3e90..42d0546 100644
--- a/drivers/media/usb/stk1160/Makefile
+++ b/drivers/media/usb/stk1160/Makefile
@@ -1,10 +1,8 @@
-obj-stk1160-ac97-$(CONFIG_VIDEO_STK1160_AC97) := stk1160-ac97.o
-
 stk1160-y := 	stk1160-core.o \
 		stk1160-v4l.o \
 		stk1160-video.o \
 		stk1160-i2c.o \
-		$(obj-stk1160-ac97-y)
+		stk1160-ac97.o
 
 obj-$(CONFIG_VIDEO_STK1160) += stk1160.o
 
-- 
2.10.1

