Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:34445 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751262AbeEDOMs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 10:12:48 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mattia Dongili <malattia@linux.it>,
        platform-driver-x86@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 2/7 v2] media: meye: allow building it with COMPILE_TEST on non-x86
Date: Fri,  4 May 2018 10:12:37 -0400
Message-Id: <6317031914d6fa11ad57950f9090bb9041997f00.1525443130.git.mchehab+samsung@kernel.org>
In-Reply-To: <CAHp75VfWrcqQS=hfOWixv5juDiVkuLQswwk+CiNZdNhf9HYYVA@mail.gmail.com>
References: <CAHp75VfWrcqQS=hfOWixv5juDiVkuLQswwk+CiNZdNhf9HYYVA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

This driver depends on sony-laptop driver, but this is available
only for x86. So, add a stub function, in order to allow building
it on non-x86 too.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/pci/meye/Kconfig | 3 ++-
 include/linux/sony-laptop.h    | 4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/meye/Kconfig b/drivers/media/pci/meye/Kconfig
index b4bf848be5a0..2e60334ffef5 100644
--- a/drivers/media/pci/meye/Kconfig
+++ b/drivers/media/pci/meye/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_MEYE
 	tristate "Sony Vaio Picturebook Motion Eye Video For Linux"
-	depends on PCI && SONY_LAPTOP && VIDEO_V4L2
+	depends on PCI && VIDEO_V4L2
+	depends on SONY_LAPTOP || COMPILE_TEST
 	---help---
 	  This is the video4linux driver for the Motion Eye camera found
 	  in the Vaio Picturebook laptops. Please read the material in
diff --git a/include/linux/sony-laptop.h b/include/linux/sony-laptop.h
index 1a4b77317fa1..374d0fdb0743 100644
--- a/include/linux/sony-laptop.h
+++ b/include/linux/sony-laptop.h
@@ -28,7 +28,11 @@
 #define SONY_PIC_COMMAND_GETCAMERAROMVERSION	18	/* obsolete */
 #define SONY_PIC_COMMAND_GETCAMERAREVISION	19	/* obsolete */
 
+#if IS_ENABLED(CONFIG_SONY_LAPTOP)
 int sony_pic_camera_command(int command, u8 value);
+#else
+static inline int sony_pic_camera_command(int command, u8 value) { return 0; };
+#endif
 
 #endif	/* __KERNEL__ */
 
-- 
2.17.0
