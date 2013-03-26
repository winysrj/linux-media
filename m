Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:48745 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab3CZRao (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 13:30:44 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 10/10] s5p-fimc: Change the driver directory name to
 exynos4-is
Date: Tue, 26 Mar 2013 18:29:52 +0100
Message-id: <1364318992-20562-11-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1364318992-20562-1-git-send-email-s.nawrocki@samsung.com>
References: <1364318992-20562-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The s5p-fimc directory now contains drivers for multiple IP blocks
found in multiple Samsung application processors. This includes FIMC
(CAMIF), MIPI CSIS and FIMC LITE. FIMC-IS (Imaging Subsystem) driver
is going to be put into same directory. Hence we rename it to
exynos4-is as s5p-fimc was only relevant for early version of this
driver, when it only supported FIMC IP block.

The imaging subsystem drivers for Exynos4 SoC series and S5PV210 will
be included in drivers/media/platform/exynos4-is directory, with some
modules shared with exynos5 series, while the rest of exynos5 specific
modules will find their home in drivers/media/platform/exynos5-is.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/Kconfig                     |    2 +-
 drivers/media/platform/Makefile                    |    2 +-
 .../platform/{s5p-fimc => exynos4-is}/Kconfig      |    8 ++++----
 .../platform/{s5p-fimc => exynos4-is}/Makefile     |    2 +-
 .../{s5p-fimc => exynos4-is}/fimc-capture.c        |    2 +-
 .../platform/{s5p-fimc => exynos4-is}/fimc-core.c  |    2 +-
 .../platform/{s5p-fimc => exynos4-is}/fimc-core.h  |    0
 .../{s5p-fimc => exynos4-is}/fimc-lite-reg.c       |    0
 .../{s5p-fimc => exynos4-is}/fimc-lite-reg.h       |    0
 .../platform/{s5p-fimc => exynos4-is}/fimc-lite.c  |    2 +-
 .../platform/{s5p-fimc => exynos4-is}/fimc-lite.h  |    0
 .../platform/{s5p-fimc => exynos4-is}/fimc-m2m.c   |    3 +--
 .../platform/{s5p-fimc => exynos4-is}/fimc-reg.c   |    2 +-
 .../platform/{s5p-fimc => exynos4-is}/fimc-reg.h   |    0
 .../fimc-mdevice.c => exynos4-is/media-dev.c}      |    2 +-
 .../fimc-mdevice.h => exynos4-is/media-dev.h}      |    0
 .../platform/{s5p-fimc => exynos4-is}/mipi-csis.c  |    0
 .../platform/{s5p-fimc => exynos4-is}/mipi-csis.h  |    0
 18 files changed, 13 insertions(+), 14 deletions(-)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/Kconfig (87%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/Makefile (94%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-capture.c (99%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-core.c (99%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-core.h (100%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-lite-reg.c (100%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-lite-reg.h (100%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-lite.c (99%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-lite.h (100%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-m2m.c (99%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-reg.c (99%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/fimc-reg.h (100%)
 rename drivers/media/platform/{s5p-fimc/fimc-mdevice.c => exynos4-is/media-dev.c} (99%)
 rename drivers/media/platform/{s5p-fimc/fimc-mdevice.h => exynos4-is/media-dev.h} (100%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/mipi-csis.c (100%)
 rename drivers/media/platform/{s5p-fimc => exynos4-is}/mipi-csis.h (100%)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 3dcfea6..7813b2a 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -122,7 +122,7 @@ config VIDEO_S3C_CAMIF
 	  will be called s3c-camif.
 
 source "drivers/media/platform/soc_camera/Kconfig"
-source "drivers/media/platform/s5p-fimc/Kconfig"
+source "drivers/media/platform/exynos4-is/Kconfig"
 source "drivers/media/platform/s5p-tv/Kconfig"
 
 endif # V4L_PLATFORM_DRIVERS
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 4817d28..8d691fe 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -28,7 +28,7 @@ obj-$(CONFIG_VIDEO_CODA) 		+= coda.o
 obj-$(CONFIG_VIDEO_MEM2MEM_DEINTERLACE)	+= m2m-deinterlace.o
 
 obj-$(CONFIG_VIDEO_S3C_CAMIF) 		+= s3c-camif/
-obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) 	+= s5p-fimc/
+obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS4_IS) 	+= exynos4-is/
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG)	+= s5p-jpeg/
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC)	+= s5p-mfc/
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_TV)	+= s5p-tv/
diff --git a/drivers/media/platform/s5p-fimc/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
similarity index 87%
rename from drivers/media/platform/s5p-fimc/Kconfig
rename to drivers/media/platform/exynos4-is/Kconfig
index 64c1116..ed96dbc 100644
--- a/drivers/media/platform/s5p-fimc/Kconfig
+++ b/drivers/media/platform/exynos4-is/Kconfig
@@ -1,6 +1,6 @@
 
-config VIDEO_SAMSUNG_S5P_FIMC
-	bool "Samsung S5P/EXYNOS SoC camera interface driver (experimental)"
+config VIDEO_SAMSUNG_EXYNOS4_IS
+	bool "Samsung S5P/EXYNOS4 SoC series Camera Subsystem driver"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && PLAT_S5P && PM_RUNTIME
 	depends on EXPERIMENTAL
 	depends on MFD_SYSCON
@@ -8,7 +8,7 @@ config VIDEO_SAMSUNG_S5P_FIMC
 	  Say Y here to enable camera host interface devices for
 	  Samsung S5P and EXYNOS SoC series.
 
-if VIDEO_SAMSUNG_S5P_FIMC
+if VIDEO_SAMSUNG_EXYNOS4_IS
 
 config VIDEO_S5P_FIMC
 	tristate "S5P/EXYNOS4 FIMC/CAMIF camera interface driver"
@@ -17,7 +17,7 @@ config VIDEO_S5P_FIMC
 	select V4L2_MEM2MEM_DEV
 	help
 	  This is a V4L2 driver for Samsung S5P and EXYNOS4 SoC camera host
-	  interface and video postprocessor (FIMC and FIMC-LITE) devices.
+	  interface and video postprocessor (FIMC) devices.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called s5p-fimc.
diff --git a/drivers/media/platform/s5p-fimc/Makefile b/drivers/media/platform/exynos4-is/Makefile
similarity index 94%
rename from drivers/media/platform/s5p-fimc/Makefile
rename to drivers/media/platform/exynos4-is/Makefile
index 4648514..8c67441 100644
--- a/drivers/media/platform/s5p-fimc/Makefile
+++ b/drivers/media/platform/exynos4-is/Makefile
@@ -1,4 +1,4 @@
-s5p-fimc-objs := fimc-core.o fimc-reg.o fimc-m2m.o fimc-capture.o fimc-mdevice.o
+s5p-fimc-objs := fimc-core.o fimc-reg.o fimc-m2m.o fimc-capture.o media-dev.o
 exynos-fimc-lite-objs += fimc-lite-reg.o fimc-lite.o
 s5p-csis-objs := mipi-csis.o
 
diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
similarity index 99%
rename from drivers/media/platform/s5p-fimc/fimc-capture.c
rename to drivers/media/platform/exynos4-is/fimc-capture.c
index 4d79d64..b9c0817 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -27,7 +27,7 @@
 #include <media/videobuf2-core.h>
 #include <media/videobuf2-dma-contig.h>
 
-#include "fimc-mdevice.h"
+#include "media-dev.h"
 #include "fimc-core.h"
 #include "fimc-reg.h"
 
diff --git a/drivers/media/platform/s5p-fimc/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
similarity index 99%
rename from drivers/media/platform/s5p-fimc/fimc-core.c
rename to drivers/media/platform/exynos4-is/fimc-core.c
index 1edd3aa..1248cdd 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -32,7 +32,7 @@
 
 #include "fimc-core.h"
 #include "fimc-reg.h"
-#include "fimc-mdevice.h"
+#include "media-dev.h"
 
 static char *fimc_clocks[MAX_FIMC_CLOCKS] = {
 	"sclk_fimc", "fimc"
diff --git a/drivers/media/platform/s5p-fimc/fimc-core.h b/drivers/media/platform/exynos4-is/fimc-core.h
similarity index 100%
rename from drivers/media/platform/s5p-fimc/fimc-core.h
rename to drivers/media/platform/exynos4-is/fimc-core.h
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite-reg.c b/drivers/media/platform/exynos4-is/fimc-lite-reg.c
similarity index 100%
rename from drivers/media/platform/s5p-fimc/fimc-lite-reg.c
rename to drivers/media/platform/exynos4-is/fimc-lite-reg.c
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite-reg.h b/drivers/media/platform/exynos4-is/fimc-lite-reg.h
similarity index 100%
rename from drivers/media/platform/s5p-fimc/fimc-lite-reg.h
rename to drivers/media/platform/exynos4-is/fimc-lite-reg.h
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
similarity index 99%
rename from drivers/media/platform/s5p-fimc/fimc-lite.c
rename to drivers/media/platform/exynos4-is/fimc-lite.c
index ca78ac0..70c0cc2 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -31,7 +31,7 @@
 #include <media/videobuf2-dma-contig.h>
 #include <media/s5p_fimc.h>
 
-#include "fimc-mdevice.h"
+#include "media-dev.h"
 #include "fimc-lite.h"
 #include "fimc-lite-reg.h"
 
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.h b/drivers/media/platform/exynos4-is/fimc-lite.h
similarity index 100%
rename from drivers/media/platform/s5p-fimc/fimc-lite.h
rename to drivers/media/platform/exynos4-is/fimc-lite.h
diff --git a/drivers/media/platform/s5p-fimc/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
similarity index 99%
rename from drivers/media/platform/s5p-fimc/fimc-m2m.c
rename to drivers/media/platform/exynos4-is/fimc-m2m.c
index daaaf91..3936b09 100644
--- a/drivers/media/platform/s5p-fimc/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -29,8 +29,7 @@
 
 #include "fimc-core.h"
 #include "fimc-reg.h"
-#include "fimc-mdevice.h"
-
+#include "media-dev.h"
 
 static unsigned int get_m2m_fmt_flags(unsigned int stream_type)
 {
diff --git a/drivers/media/platform/s5p-fimc/fimc-reg.c b/drivers/media/platform/exynos4-is/fimc-reg.c
similarity index 99%
rename from drivers/media/platform/s5p-fimc/fimc-reg.c
rename to drivers/media/platform/exynos4-is/fimc-reg.c
index ee88b94..c276eb8 100644
--- a/drivers/media/platform/s5p-fimc/fimc-reg.c
+++ b/drivers/media/platform/exynos4-is/fimc-reg.c
@@ -14,7 +14,7 @@
 #include <linux/regmap.h>
 
 #include <media/s5p_fimc.h>
-#include "fimc-mdevice.h"
+#include "media-dev.h"
 
 #include "fimc-reg.h"
 #include "fimc-core.h"
diff --git a/drivers/media/platform/s5p-fimc/fimc-reg.h b/drivers/media/platform/exynos4-is/fimc-reg.h
similarity index 100%
rename from drivers/media/platform/s5p-fimc/fimc-reg.h
rename to drivers/media/platform/exynos4-is/fimc-reg.h
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/exynos4-is/media-dev.c
similarity index 99%
rename from drivers/media/platform/s5p-fimc/fimc-mdevice.c
rename to drivers/media/platform/exynos4-is/media-dev.c
index 06d1eb4..6048290 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -30,9 +30,9 @@
 #include <media/media-device.h>
 #include <media/s5p_fimc.h>
 
+#include "media-dev.h"
 #include "fimc-core.h"
 #include "fimc-lite.h"
-#include "fimc-mdevice.h"
 #include "mipi-csis.h"
 
 static int __fimc_md_set_camclk(struct fimc_md *fmd,
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.h b/drivers/media/platform/exynos4-is/media-dev.h
similarity index 100%
rename from drivers/media/platform/s5p-fimc/fimc-mdevice.h
rename to drivers/media/platform/exynos4-is/media-dev.h
diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
similarity index 100%
rename from drivers/media/platform/s5p-fimc/mipi-csis.c
rename to drivers/media/platform/exynos4-is/mipi-csis.c
diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.h b/drivers/media/platform/exynos4-is/mipi-csis.h
similarity index 100%
rename from drivers/media/platform/s5p-fimc/mipi-csis.h
rename to drivers/media/platform/exynos4-is/mipi-csis.h
-- 
1.7.9.5

