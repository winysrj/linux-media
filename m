Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:44967 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab3FQQe7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 12:34:59 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MOJ00JMMQ2ASS50@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 18 Jun 2013 01:34:58 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] Documentation: Update driver's directory in
 video4linux/fimc.txt
Date: Mon, 17 Jun 2013 18:34:36 +0200
Message-id: <1371486876-30421-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update the documentation with the driver's path changed in
commit 56fa1a6a6a7da91e7ece8b01b0ae8adb2926e434
[media] s5p-fimc: Change the driver directory to exynos4-is

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/video4linux/fimc.txt |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/Documentation/video4linux/fimc.txt b/Documentation/video4linux/fimc.txt
index 25f4d34..e51f1b5 100644
--- a/Documentation/video4linux/fimc.txt
+++ b/Documentation/video4linux/fimc.txt
@@ -1,6 +1,6 @@
 Samsung S5P/EXYNOS4 FIMC driver
 
-Copyright (C) 2012 Samsung Electronics Co., Ltd.
+Copyright (C) 2012 - 2013 Samsung Electronics Co., Ltd.
 ---------------------------------------------------------------------------
 
 The FIMC (Fully Interactive Mobile Camera) device available in Samsung
@@ -10,7 +10,7 @@ data from LCD controller (FIMD) through the SoC internal writeback data
 path.  There are multiple FIMC instances in the SoCs (up to 4), having
 slightly different capabilities, like pixel alignment constraints, rotator
 availability, LCD writeback support, etc. The driver is located at
-drivers/media/platform/s5p-fimc directory.
+drivers/media/platform/exynos4-is directory.
 
 1. Supported SoCs
 =================
@@ -36,21 +36,21 @@ Not currently supported:
 =====================
 
 - media device driver
-  drivers/media/platform/s5p-fimc/fimc-mdevice.[ch]
+  drivers/media/platform/exynos4-is/media-dev.[ch]
 
  - camera capture video device driver
-  drivers/media/platform/s5p-fimc/fimc-capture.c
+  drivers/media/platform/exynos4-is/fimc-capture.c
 
  - MIPI-CSI2 receiver subdev
-  drivers/media/platform/s5p-fimc/mipi-csis.[ch]
+  drivers/media/platform/exynos4-is/mipi-csis.[ch]
 
  - video post-processor (mem-to-mem)
-  drivers/media/platform/s5p-fimc/fimc-core.c
+  drivers/media/platform/exynos4-is/fimc-core.c
 
  - common files
-  drivers/media/platform/s5p-fimc/fimc-core.h
-  drivers/media/platform/s5p-fimc/fimc-reg.h
-  drivers/media/platform/s5p-fimc/regs-fimc.h
+  drivers/media/platform/exynos4-is/fimc-core.h
+  drivers/media/platform/exynos4-is/fimc-reg.h
+  drivers/media/platform/exynos4-is/regs-fimc.h
 
 4. User space interfaces
 ========================
@@ -143,7 +143,8 @@ or retrieve the information from /dev/media? with help of the media-ctl tool:
 6. Platform support
 ===================
 
-The machine code (plat-s5p and arch/arm/mach-*) must select following options
+The machine code (arch/arm/plat-samsung and arch/arm/mach-*) must select
+following options:
 
 CONFIG_S5P_DEV_FIMC0       mandatory
 CONFIG_S5P_DEV_FIMC1  \
-- 
1.7.9.5

