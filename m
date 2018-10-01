Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:57090 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbeJBEPn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2018 00:15:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Michal Simek <michal.simek@xilinx.com>,
        Hyun Kwon <hyun.kwon@xilinx.com>,
        Dhaval Shah <dhaval23031987@gmail.com>
Subject: [RESEND] [PATCH] media: v4l: xilinx: Use SPDX-License-Identifier
Date: Tue,  2 Oct 2018 00:36:01 +0300
Message-Id: <20181001213601.9044-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dhaval Shah <dhaval23031987@gmail.com>

SPDX-License-Identifier is used for the Xilinx Video IP and
related drivers.

Signed-off-by: Dhaval Shah <dhaval23031987@gmail.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
[Added drivers/media/platform/xilinx/Kconfig]
[Added drivers/media/platform/xilinx/Makefile]
[Added include/dt-bindings/media/xilinx-vip.h]
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/xilinx/Kconfig       | 2 ++
 drivers/media/platform/xilinx/Makefile      | 2 ++
 drivers/media/platform/xilinx/xilinx-dma.c  | 5 +----
 drivers/media/platform/xilinx/xilinx-dma.h  | 5 +----
 drivers/media/platform/xilinx/xilinx-tpg.c  | 5 +----
 drivers/media/platform/xilinx/xilinx-vip.c  | 5 +----
 drivers/media/platform/xilinx/xilinx-vip.h  | 5 +----
 drivers/media/platform/xilinx/xilinx-vipp.c | 5 +----
 drivers/media/platform/xilinx/xilinx-vipp.h | 5 +----
 drivers/media/platform/xilinx/xilinx-vtc.c  | 5 +----
 drivers/media/platform/xilinx/xilinx-vtc.h  | 5 +----
 include/dt-bindings/media/xilinx-vip.h      | 5 +----
 12 files changed, 14 insertions(+), 40 deletions(-)

diff --git a/drivers/media/platform/xilinx/Kconfig b/drivers/media/platform/xilinx/Kconfig
index a5d21b7c6e0b..74ec8aaa5ae0 100644
--- a/drivers/media/platform/xilinx/Kconfig
+++ b/drivers/media/platform/xilinx/Kconfig
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
 config VIDEO_XILINX
 	tristate "Xilinx Video IP (EXPERIMENTAL)"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF && HAS_DMA
diff --git a/drivers/media/platform/xilinx/Makefile b/drivers/media/platform/xilinx/Makefile
index e8a0f2a9f733..4cdc0b1ec7a5 100644
--- a/drivers/media/platform/xilinx/Makefile
+++ b/drivers/media/platform/xilinx/Makefile
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
 xilinx-video-objs += xilinx-dma.o xilinx-vip.o xilinx-vipp.o
 
 obj-$(CONFIG_VIDEO_XILINX) += xilinx-video.o
diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index 4ae9d38c9433..c9d5fdb2d407 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Xilinx Video DMA
  *
@@ -6,10 +7,6 @@
  *
  * Contacts: Hyun Kwon <hyun.kwon@xilinx.com>
  *           Laurent Pinchart <laurent.pinchart@ideasonboard.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #include <linux/dma/xilinx_dma.h>
diff --git a/drivers/media/platform/xilinx/xilinx-dma.h b/drivers/media/platform/xilinx/xilinx-dma.h
index e95d136c153a..5aec4d17eb21 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.h
+++ b/drivers/media/platform/xilinx/xilinx-dma.h
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Xilinx Video DMA
  *
@@ -6,10 +7,6 @@
  *
  * Contacts: Hyun Kwon <hyun.kwon@xilinx.com>
  *           Laurent Pinchart <laurent.pinchart@ideasonboard.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #ifndef __XILINX_VIP_DMA_H__
diff --git a/drivers/media/platform/xilinx/xilinx-tpg.c b/drivers/media/platform/xilinx/xilinx-tpg.c
index 851d20dcd550..1399e71d42c2 100644
--- a/drivers/media/platform/xilinx/xilinx-tpg.c
+++ b/drivers/media/platform/xilinx/xilinx-tpg.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Xilinx Test Pattern Generator
  *
@@ -6,10 +7,6 @@
  *
  * Contacts: Hyun Kwon <hyun.kwon@xilinx.com>
  *           Laurent Pinchart <laurent.pinchart@ideasonboard.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #include <linux/device.h>
diff --git a/drivers/media/platform/xilinx/xilinx-vip.c b/drivers/media/platform/xilinx/xilinx-vip.c
index 311259129504..5f7efa9f093e 100644
--- a/drivers/media/platform/xilinx/xilinx-vip.c
+++ b/drivers/media/platform/xilinx/xilinx-vip.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Xilinx Video IP Core
  *
@@ -6,10 +7,6 @@
  *
  * Contacts: Hyun Kwon <hyun.kwon@xilinx.com>
  *           Laurent Pinchart <laurent.pinchart@ideasonboard.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #include <linux/clk.h>
diff --git a/drivers/media/platform/xilinx/xilinx-vip.h b/drivers/media/platform/xilinx/xilinx-vip.h
index 42fee2026815..ba939dd52818 100644
--- a/drivers/media/platform/xilinx/xilinx-vip.h
+++ b/drivers/media/platform/xilinx/xilinx-vip.h
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Xilinx Video IP Core
  *
@@ -6,10 +7,6 @@
  *
  * Contacts: Hyun Kwon <hyun.kwon@xilinx.com>
  *           Laurent Pinchart <laurent.pinchart@ideasonboard.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #ifndef __XILINX_VIP_H__
diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
index 5148df007c6e..abf988b494f0 100644
--- a/drivers/media/platform/xilinx/xilinx-vipp.c
+++ b/drivers/media/platform/xilinx/xilinx-vipp.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Xilinx Video IP Composite Device
  *
@@ -6,10 +7,6 @@
  *
  * Contacts: Hyun Kwon <hyun.kwon@xilinx.com>
  *           Laurent Pinchart <laurent.pinchart@ideasonboard.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #include <linux/list.h>
diff --git a/drivers/media/platform/xilinx/xilinx-vipp.h b/drivers/media/platform/xilinx/xilinx-vipp.h
index faf6b6e80b3b..39daa030679e 100644
--- a/drivers/media/platform/xilinx/xilinx-vipp.h
+++ b/drivers/media/platform/xilinx/xilinx-vipp.h
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Xilinx Video IP Composite Device
  *
@@ -6,10 +7,6 @@
  *
  * Contacts: Hyun Kwon <hyun.kwon@xilinx.com>
  *           Laurent Pinchart <laurent.pinchart@ideasonboard.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #ifndef __XILINX_VIPP_H__
diff --git a/drivers/media/platform/xilinx/xilinx-vtc.c b/drivers/media/platform/xilinx/xilinx-vtc.c
index 01c750edcac5..0ae0208d7529 100644
--- a/drivers/media/platform/xilinx/xilinx-vtc.c
+++ b/drivers/media/platform/xilinx/xilinx-vtc.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Xilinx Video Timing Controller
  *
@@ -6,10 +7,6 @@
  *
  * Contacts: Hyun Kwon <hyun.kwon@xilinx.com>
  *           Laurent Pinchart <laurent.pinchart@ideasonboard.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #include <linux/clk.h>
diff --git a/drivers/media/platform/xilinx/xilinx-vtc.h b/drivers/media/platform/xilinx/xilinx-vtc.h
index e1bb2cfcf428..90cf44245283 100644
--- a/drivers/media/platform/xilinx/xilinx-vtc.h
+++ b/drivers/media/platform/xilinx/xilinx-vtc.h
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Xilinx Video Timing Controller
  *
@@ -6,10 +7,6 @@
  *
  * Contacts: Hyun Kwon <hyun.kwon@xilinx.com>
  *           Laurent Pinchart <laurent.pinchart@ideasonboard.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #ifndef __XILINX_VTC_H__
diff --git a/include/dt-bindings/media/xilinx-vip.h b/include/dt-bindings/media/xilinx-vip.h
index 6298fec00685..94ed3edfcc70 100644
--- a/include/dt-bindings/media/xilinx-vip.h
+++ b/include/dt-bindings/media/xilinx-vip.h
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Xilinx Video IP Core
  *
@@ -6,10 +7,6 @@
  *
  * Contacts: Hyun Kwon <hyun.kwon@xilinx.com>
  *           Laurent Pinchart <laurent.pinchart@ideasonboard.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #ifndef __DT_BINDINGS_MEDIA_XILINX_VIP_H__
-- 
Regards,

Laurent Pinchart
