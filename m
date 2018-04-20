Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:61304 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753494AbeDTRm7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 13:42:59 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mattia Dongili <malattia@linux.it>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH 2/7] media: meye: allow building it with COMPILE_TEST on non-x86
Date: Fri, 20 Apr 2018 13:42:48 -0400
Message-Id: <0896a07690a7379eb37a603cfe87382455afcb71.1524245455.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1524245455.git.mchehab@s-opensource.com>
References: <cover.1524245455.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1524245455.git.mchehab@s-opensource.com>
References: <cover.1524245455.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver depends on sony-laptop driver, but this is available
only for x86. So, add a stub function, in order to allow building
it on non-x86 too.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
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
index 1a4b77317fa1..72a2e74c62b2 100644
--- a/include/linux/sony-laptop.h
+++ b/include/linux/sony-laptop.h
@@ -28,7 +28,11 @@
 #define SONY_PIC_COMMAND_GETCAMERAROMVERSION	18	/* obsolete */
 #define SONY_PIC_COMMAND_GETCAMERAREVISION	19	/* obsolete */
 
+#ifdef CONFIG_SONY_LAPTOP
 int sony_pic_camera_command(int command, u8 value);
+#else
+static inline int sony_pic_camera_command(int command, u8 value) { return 0; };
+#endif
 
 #endif	/* __KERNEL__ */
 
-- 
2.14.3
