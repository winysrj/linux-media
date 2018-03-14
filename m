Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:34685 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750998AbeCNPoi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Mar 2018 11:44:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 20/47] media: platform: remove blackfin capture driver
Date: Wed, 14 Mar 2018 16:35:33 +0100
Message-Id: <20180314153603.3127932-21-arnd@arndb.de>
In-Reply-To: <20180314153603.3127932-1-arnd@arndb.de>
References: <20180314153603.3127932-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The blackfin architecture is getting removed, so the video
capture driver is also obsolete.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/Kconfig                 |   2 -
 drivers/media/platform/Makefile                |   2 -
 drivers/media/platform/blackfin/Kconfig        |  16 -
 drivers/media/platform/blackfin/Makefile       |   2 -
 drivers/media/platform/blackfin/bfin_capture.c | 983 -------------------------
 drivers/media/platform/blackfin/ppi.c          | 361 ---------
 include/media/blackfin/bfin_capture.h          |  39 -
 include/media/blackfin/ppi.h                   |  94 ---
 8 files changed, 1499 deletions(-)
 delete mode 100644 drivers/media/platform/blackfin/Kconfig
 delete mode 100644 drivers/media/platform/blackfin/Makefile
 delete mode 100644 drivers/media/platform/blackfin/bfin_capture.c
 delete mode 100644 drivers/media/platform/blackfin/ppi.c
 delete mode 100644 include/media/blackfin/bfin_capture.h
 delete mode 100644 include/media/blackfin/ppi.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 5d8fd71fc454..2136702c95fc 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -31,8 +31,6 @@ source "drivers/media/platform/davinci/Kconfig"
 
 source "drivers/media/platform/omap/Kconfig"
 
-source "drivers/media/platform/blackfin/Kconfig"
-
 config VIDEO_SH_VOU
 	tristate "SuperH VOU video output driver"
 	depends on MEDIA_CAMERA_SUPPORT
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 85e112122f32..2b07f2e2fca6 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -53,8 +53,6 @@ obj-$(CONFIG_VIDEO_TEGRA_HDMI_CEC)	+= tegra-cec/
 
 obj-y					+= stm32/
 
-obj-y                                   += blackfin/
-
 obj-y					+= davinci/
 
 obj-$(CONFIG_VIDEO_SH_VOU)		+= sh_vou.o
diff --git a/drivers/media/platform/blackfin/Kconfig b/drivers/media/platform/blackfin/Kconfig
deleted file mode 100644
index 68fa90151b8f..000000000000
diff --git a/drivers/media/platform/blackfin/Makefile b/drivers/media/platform/blackfin/Makefile
deleted file mode 100644
index 30421bc23080..000000000000
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
deleted file mode 100644
index b7660b1000fd..000000000000
diff --git a/drivers/media/platform/blackfin/ppi.c b/drivers/media/platform/blackfin/ppi.c
deleted file mode 100644
index d3dc765c1609..000000000000
diff --git a/include/media/blackfin/bfin_capture.h b/include/media/blackfin/bfin_capture.h
deleted file mode 100644
index a999a3970c69..000000000000
diff --git a/include/media/blackfin/ppi.h b/include/media/blackfin/ppi.h
deleted file mode 100644
index 987e49e8f9c9..000000000000
-- 
2.9.0
