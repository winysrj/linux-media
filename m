Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55126 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab2EKGPk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 02:15:40 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so2872245pbb.19
        for <linux-media@vger.kernel.org>; Thu, 10 May 2012 23:15:38 -0700 (PDT)
From: Ismael Luceno <ismael.luceno@gmail.com>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@gmail.com>
Subject: [PATCH 2/2] au0828: Move under dvb
Date: Fri, 11 May 2012 03:14:52 -0300
Message-Id: <1336716892-5446-2-git-send-email-ismael.luceno@gmail.com>
In-Reply-To: <1336716892-5446-1-git-send-email-ismael.luceno@gmail.com>
References: <1336716892-5446-1-git-send-email-ismael.luceno@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ismael Luceno <ismael.luceno@gmail.com>
---
 drivers/media/dvb/Kconfig                          |    1 +
 drivers/media/dvb/Makefile                         |    1 +
 drivers/media/{video => dvb}/au0828/Kconfig        |    0
 drivers/media/{video => dvb}/au0828/Makefile       |    0
 drivers/media/{video => dvb}/au0828/au0828-cards.c |    0
 drivers/media/{video => dvb}/au0828/au0828-cards.h |    0
 drivers/media/{video => dvb}/au0828/au0828-core.c  |    0
 drivers/media/{video => dvb}/au0828/au0828-dvb.c   |    0
 drivers/media/{video => dvb}/au0828/au0828-i2c.c   |    0
 drivers/media/{video => dvb}/au0828/au0828-reg.h   |    0
 drivers/media/{video => dvb}/au0828/au0828-vbi.c   |    0
 drivers/media/{video => dvb}/au0828/au0828-video.c |    0
 drivers/media/{video => dvb}/au0828/au0828.h       |    0
 drivers/media/video/Kconfig                        |    2 --
 drivers/media/video/Makefile                       |    2 --
 15 files changed, 2 insertions(+), 4 deletions(-)
 rename drivers/media/{video => dvb}/au0828/Kconfig (100%)
 rename drivers/media/{video => dvb}/au0828/Makefile (100%)
 rename drivers/media/{video => dvb}/au0828/au0828-cards.c (100%)
 rename drivers/media/{video => dvb}/au0828/au0828-cards.h (100%)
 rename drivers/media/{video => dvb}/au0828/au0828-core.c (100%)
 rename drivers/media/{video => dvb}/au0828/au0828-dvb.c (100%)
 rename drivers/media/{video => dvb}/au0828/au0828-i2c.c (100%)
 rename drivers/media/{video => dvb}/au0828/au0828-reg.h (100%)
 rename drivers/media/{video => dvb}/au0828/au0828-vbi.c (100%)
 rename drivers/media/{video => dvb}/au0828/au0828-video.c (100%)
 rename drivers/media/{video => dvb}/au0828/au0828.h (100%)

diff --git a/drivers/media/dvb/Kconfig b/drivers/media/dvb/Kconfig
index f6e40b3..1cbb061 100644
--- a/drivers/media/dvb/Kconfig
+++ b/drivers/media/dvb/Kconfig
@@ -43,6 +43,7 @@ source "drivers/media/dvb/ttpci/Kconfig"
 
 comment "Supported USB Adapters"
 	depends on DVB_CORE && USB && I2C
+source "drivers/media/dvb/au0828/Kconfig"
 source "drivers/media/dvb/dvb-usb/Kconfig"
 source "drivers/media/dvb/ttusb-budget/Kconfig"
 source "drivers/media/dvb/ttusb-dec/Kconfig"
diff --git a/drivers/media/dvb/Makefile b/drivers/media/dvb/Makefile
index b2cefe6..3f28163 100644
--- a/drivers/media/dvb/Makefile
+++ b/drivers/media/dvb/Makefile
@@ -19,3 +19,4 @@ obj-y        := dvb-core/	\
 		ddbridge/
 
 obj-$(CONFIG_DVB_FIREDTV)	+= firewire/
+obj-$(CONFIG_VIDEO_AU0828)	+= au0828/
diff --git a/drivers/media/video/au0828/Kconfig b/drivers/media/dvb/au0828/Kconfig
similarity index 100%
rename from drivers/media/video/au0828/Kconfig
rename to drivers/media/dvb/au0828/Kconfig
diff --git a/drivers/media/video/au0828/Makefile b/drivers/media/dvb/au0828/Makefile
similarity index 100%
rename from drivers/media/video/au0828/Makefile
rename to drivers/media/dvb/au0828/Makefile
diff --git a/drivers/media/video/au0828/au0828-cards.c b/drivers/media/dvb/au0828/au0828-cards.c
similarity index 100%
rename from drivers/media/video/au0828/au0828-cards.c
rename to drivers/media/dvb/au0828/au0828-cards.c
diff --git a/drivers/media/video/au0828/au0828-cards.h b/drivers/media/dvb/au0828/au0828-cards.h
similarity index 100%
rename from drivers/media/video/au0828/au0828-cards.h
rename to drivers/media/dvb/au0828/au0828-cards.h
diff --git a/drivers/media/video/au0828/au0828-core.c b/drivers/media/dvb/au0828/au0828-core.c
similarity index 100%
rename from drivers/media/video/au0828/au0828-core.c
rename to drivers/media/dvb/au0828/au0828-core.c
diff --git a/drivers/media/video/au0828/au0828-dvb.c b/drivers/media/dvb/au0828/au0828-dvb.c
similarity index 100%
rename from drivers/media/video/au0828/au0828-dvb.c
rename to drivers/media/dvb/au0828/au0828-dvb.c
diff --git a/drivers/media/video/au0828/au0828-i2c.c b/drivers/media/dvb/au0828/au0828-i2c.c
similarity index 100%
rename from drivers/media/video/au0828/au0828-i2c.c
rename to drivers/media/dvb/au0828/au0828-i2c.c
diff --git a/drivers/media/video/au0828/au0828-reg.h b/drivers/media/dvb/au0828/au0828-reg.h
similarity index 100%
rename from drivers/media/video/au0828/au0828-reg.h
rename to drivers/media/dvb/au0828/au0828-reg.h
diff --git a/drivers/media/video/au0828/au0828-vbi.c b/drivers/media/dvb/au0828/au0828-vbi.c
similarity index 100%
rename from drivers/media/video/au0828/au0828-vbi.c
rename to drivers/media/dvb/au0828/au0828-vbi.c
diff --git a/drivers/media/video/au0828/au0828-video.c b/drivers/media/dvb/au0828/au0828-video.c
similarity index 100%
rename from drivers/media/video/au0828/au0828-video.c
rename to drivers/media/dvb/au0828/au0828-video.c
diff --git a/drivers/media/video/au0828/au0828.h b/drivers/media/dvb/au0828/au0828.h
similarity index 100%
rename from drivers/media/video/au0828/au0828.h
rename to drivers/media/dvb/au0828/au0828.h
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index ce1e7ba..5a717eb 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -721,8 +721,6 @@ menuconfig V4L_PCI_DRIVERS
 
 if V4L_PCI_DRIVERS
 
-source "drivers/media/video/au0828/Kconfig"
-
 source "drivers/media/video/bt8xx/Kconfig"
 
 source "drivers/media/video/cx18/Kconfig"
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index a6282a3..90602a9 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -198,8 +198,6 @@ obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
 
 obj-$(CONFIG_VIDEO_SH_VOU)		+= sh_vou.o
 
-obj-$(CONFIG_VIDEO_AU0828) += au0828/
-
 obj-$(CONFIG_USB_VIDEO_CLASS)	+= uvc/
 obj-$(CONFIG_VIDEO_SAA7164)     += saa7164/
 
-- 
1.7.10

