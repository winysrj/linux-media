Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:49084 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965453AbeFZOAF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Jun 2018 10:00:05 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH 04/32 resend] media: Rename CAMSS driver path
Date: Tue, 26 Jun 2018 16:59:52 +0300
Message-Id: <1530021592-24925-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support for camera subsystem on QComm MSM8996/APQ8096 is to be added
so remove hardware version from CAMSS driver's path.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 MAINTAINERS                                                      | 2 +-
 drivers/media/platform/Kconfig                                   | 2 +-
 drivers/media/platform/Makefile                                  | 2 +-
 drivers/media/platform/qcom/{camss-8x16 => camss}/Makefile       | 0
 drivers/media/platform/qcom/{camss-8x16 => camss}/camss-csid.c   | 2 +-
 drivers/media/platform/qcom/{camss-8x16 => camss}/camss-csid.h   | 2 +-
 drivers/media/platform/qcom/{camss-8x16 => camss}/camss-csiphy.c | 2 +-
 drivers/media/platform/qcom/{camss-8x16 => camss}/camss-csiphy.h | 2 +-
 drivers/media/platform/qcom/{camss-8x16 => camss}/camss-ispif.c  | 2 +-
 drivers/media/platform/qcom/{camss-8x16 => camss}/camss-ispif.h  | 2 +-
 drivers/media/platform/qcom/{camss-8x16 => camss}/camss-vfe.c    | 2 +-
 drivers/media/platform/qcom/{camss-8x16 => camss}/camss-vfe.h    | 2 +-
 drivers/media/platform/qcom/{camss-8x16 => camss}/camss-video.c  | 2 +-
 drivers/media/platform/qcom/{camss-8x16 => camss}/camss-video.h  | 2 +-
 drivers/media/platform/qcom/{camss-8x16 => camss}/camss.c        | 2 +-
 drivers/media/platform/qcom/{camss-8x16 => camss}/camss.h        | 2 +-
 16 files changed, 15 insertions(+), 15 deletions(-)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/Makefile (100%)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss-csid.c (99%)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss-csid.h (98%)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss-csiphy.c (99%)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss-csiphy.h (97%)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss-ispif.c (99%)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss-ispif.h (98%)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss-vfe.c (99%)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss-vfe.h (98%)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss-video.c (99%)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss-video.h (98%)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss.c (99%)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss.h (98%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9fd5e88..ea3d450 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11796,7 +11796,7 @@ L:	linux-media@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/media/qcom,camss.txt
 F:	Documentation/media/v4l-drivers/qcom_camss.rst
-F:	drivers/media/platform/qcom/camss-8x16/
+F:	drivers/media/platform/qcom/camss/
 
 QUALCOMM CPUFREQ DRIVER MSM8996/APQ8096
 M:  Ilia Lin <ilia.lin@gmail.com>
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 2728376..a9765a2 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -90,7 +90,7 @@ config VIDEO_PXA27x
 	  This is a v4l2 driver for the PXA27x Quick Capture Interface
 
 config VIDEO_QCOM_CAMSS
-	tristate "Qualcomm 8x16 V4L2 Camera Subsystem driver"
+	tristate "Qualcomm V4L2 Camera Subsystem driver"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on (ARCH_QCOM && IOMMU_DMA) || COMPILE_TEST
 	select VIDEOBUF2_DMA_SG
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 04bc150..20a7b64 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -88,7 +88,7 @@ obj-$(CONFIG_VIDEO_MEDIATEK_MDP)	+= mtk-mdp/
 
 obj-$(CONFIG_VIDEO_MEDIATEK_JPEG)	+= mtk-jpeg/
 
-obj-$(CONFIG_VIDEO_QCOM_CAMSS)		+= qcom/camss-8x16/
+obj-$(CONFIG_VIDEO_QCOM_CAMSS)		+= qcom/camss/
 
 obj-$(CONFIG_VIDEO_QCOM_VENUS)		+= qcom/venus/
 
diff --git a/drivers/media/platform/qcom/camss-8x16/Makefile b/drivers/media/platform/qcom/camss/Makefile
similarity index 100%
rename from drivers/media/platform/qcom/camss-8x16/Makefile
rename to drivers/media/platform/qcom/camss/Makefile
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-csid.c b/drivers/media/platform/qcom/camss/camss-csid.c
similarity index 99%
rename from drivers/media/platform/qcom/camss-8x16/camss-csid.c
rename to drivers/media/platform/qcom/camss/camss-csid.c
index 226f36e..39ea27b 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-csid.c
+++ b/drivers/media/platform/qcom/camss/camss-csid.c
@@ -4,7 +4,7 @@
  * Qualcomm MSM Camera Subsystem - CSID (CSI Decoder) Module
  *
  * Copyright (c) 2011-2015, The Linux Foundation. All rights reserved.
- * Copyright (C) 2015-2017 Linaro Ltd.
+ * Copyright (C) 2015-2018 Linaro Ltd.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-csid.h b/drivers/media/platform/qcom/camss/camss-csid.h
similarity index 98%
rename from drivers/media/platform/qcom/camss-8x16/camss-csid.h
rename to drivers/media/platform/qcom/camss/camss-csid.h
index 8682d30..8012222 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-csid.h
+++ b/drivers/media/platform/qcom/camss/camss-csid.h
@@ -4,7 +4,7 @@
  * Qualcomm MSM Camera Subsystem - CSID (CSI Decoder) Module
  *
  * Copyright (c) 2011-2014, The Linux Foundation. All rights reserved.
- * Copyright (C) 2015-2017 Linaro Ltd.
+ * Copyright (C) 2015-2018 Linaro Ltd.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-csiphy.c b/drivers/media/platform/qcom/camss/camss-csiphy.c
similarity index 99%
rename from drivers/media/platform/qcom/camss-8x16/camss-csiphy.c
rename to drivers/media/platform/qcom/camss/camss-csiphy.c
index 7e61cab..642de25 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-csiphy.c
+++ b/drivers/media/platform/qcom/camss/camss-csiphy.c
@@ -4,7 +4,7 @@
  * Qualcomm MSM Camera Subsystem - CSIPHY Module
  *
  * Copyright (c) 2011-2015, The Linux Foundation. All rights reserved.
- * Copyright (C) 2016-2017 Linaro Ltd.
+ * Copyright (C) 2016-2018 Linaro Ltd.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-csiphy.h b/drivers/media/platform/qcom/camss/camss-csiphy.h
similarity index 97%
rename from drivers/media/platform/qcom/camss-8x16/camss-csiphy.h
rename to drivers/media/platform/qcom/camss/camss-csiphy.h
index ba87811..9a42209 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-csiphy.h
+++ b/drivers/media/platform/qcom/camss/camss-csiphy.h
@@ -4,7 +4,7 @@
  * Qualcomm MSM Camera Subsystem - CSIPHY Module
  *
  * Copyright (c) 2011-2015, The Linux Foundation. All rights reserved.
- * Copyright (C) 2016-2017 Linaro Ltd.
+ * Copyright (C) 2016-2018 Linaro Ltd.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-ispif.c b/drivers/media/platform/qcom/camss/camss-ispif.c
similarity index 99%
rename from drivers/media/platform/qcom/camss-8x16/camss-ispif.c
rename to drivers/media/platform/qcom/camss/camss-ispif.c
index 9d1af93..636d5e7 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-ispif.c
+++ b/drivers/media/platform/qcom/camss/camss-ispif.c
@@ -4,7 +4,7 @@
  * Qualcomm MSM Camera Subsystem - ISPIF (ISP Interface) Module
  *
  * Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
- * Copyright (C) 2015-2017 Linaro Ltd.
+ * Copyright (C) 2015-2018 Linaro Ltd.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-ispif.h b/drivers/media/platform/qcom/camss/camss-ispif.h
similarity index 98%
rename from drivers/media/platform/qcom/camss-8x16/camss-ispif.h
rename to drivers/media/platform/qcom/camss/camss-ispif.h
index f668306..c90e159 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-ispif.h
+++ b/drivers/media/platform/qcom/camss/camss-ispif.h
@@ -4,7 +4,7 @@
  * Qualcomm MSM Camera Subsystem - ISPIF (ISP Interface) Module
  *
  * Copyright (c) 2013-2014, The Linux Foundation. All rights reserved.
- * Copyright (C) 2015-2017 Linaro Ltd.
+ * Copyright (C) 2015-2018 Linaro Ltd.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c b/drivers/media/platform/qcom/camss/camss-vfe.c
similarity index 99%
rename from drivers/media/platform/qcom/camss-8x16/camss-vfe.c
rename to drivers/media/platform/qcom/camss/camss-vfe.c
index a6329a8..380b90b 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -4,7 +4,7 @@
  * Qualcomm MSM Camera Subsystem - VFE (Video Front End) Module
  *
  * Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
- * Copyright (C) 2015-2017 Linaro Ltd.
+ * Copyright (C) 2015-2018 Linaro Ltd.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-vfe.h b/drivers/media/platform/qcom/camss/camss-vfe.h
similarity index 98%
rename from drivers/media/platform/qcom/camss-8x16/camss-vfe.h
rename to drivers/media/platform/qcom/camss/camss-vfe.h
index 53d5b66..5aa7407 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-vfe.h
+++ b/drivers/media/platform/qcom/camss/camss-vfe.h
@@ -4,7 +4,7 @@
  * Qualcomm MSM Camera Subsystem - VFE (Video Front End) Module
  *
  * Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
- * Copyright (C) 2015-2017 Linaro Ltd.
+ * Copyright (C) 2015-2018 Linaro Ltd.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-video.c b/drivers/media/platform/qcom/camss/camss-video.c
similarity index 99%
rename from drivers/media/platform/qcom/camss-8x16/camss-video.c
rename to drivers/media/platform/qcom/camss/camss-video.c
index ffaa284..0e7b842 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-video.c
+++ b/drivers/media/platform/qcom/camss/camss-video.c
@@ -4,7 +4,7 @@
  * Qualcomm MSM Camera Subsystem - V4L2 device node
  *
  * Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
- * Copyright (C) 2015-2017 Linaro Ltd.
+ * Copyright (C) 2015-2018 Linaro Ltd.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-video.h b/drivers/media/platform/qcom/camss/camss-video.h
similarity index 98%
rename from drivers/media/platform/qcom/camss-8x16/camss-video.h
rename to drivers/media/platform/qcom/camss/camss-video.h
index 38bd1f2..821c1ef 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-video.h
+++ b/drivers/media/platform/qcom/camss/camss-video.h
@@ -4,7 +4,7 @@
  * Qualcomm MSM Camera Subsystem - V4L2 device node
  *
  * Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
- * Copyright (C) 2015-2017 Linaro Ltd.
+ * Copyright (C) 2015-2018 Linaro Ltd.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
diff --git a/drivers/media/platform/qcom/camss-8x16/camss.c b/drivers/media/platform/qcom/camss/camss.c
similarity index 99%
rename from drivers/media/platform/qcom/camss-8x16/camss.c
rename to drivers/media/platform/qcom/camss/camss.c
index 23fda62..d1d27fc 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -4,7 +4,7 @@
  * Qualcomm MSM Camera Subsystem - Core
  *
  * Copyright (c) 2015, The Linux Foundation. All rights reserved.
- * Copyright (C) 2015-2017 Linaro Ltd.
+ * Copyright (C) 2015-2018 Linaro Ltd.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
diff --git a/drivers/media/platform/qcom/camss-8x16/camss.h b/drivers/media/platform/qcom/camss/camss.h
similarity index 98%
rename from drivers/media/platform/qcom/camss-8x16/camss.h
rename to drivers/media/platform/qcom/camss/camss.h
index 4ad2234..0e7cfe6 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss.h
+++ b/drivers/media/platform/qcom/camss/camss.h
@@ -4,7 +4,7 @@
  * Qualcomm MSM Camera Subsystem - Core
  *
  * Copyright (c) 2015, The Linux Foundation. All rights reserved.
- * Copyright (C) 2015-2017 Linaro Ltd.
+ * Copyright (C) 2015-2018 Linaro Ltd.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
-- 
2.7.4
