Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:42280 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752209AbdLHMfw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 07:35:52 -0500
From: Dhaval Shah <dhaval23031987@gmail.com>
To: hyun.kwon@xilinx.com, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, michal.simek@xilinx.com
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Dhaval Shah <dhaval23031987@gmail.com>
Subject: [PATCH] media: v4l: xilinx: Use SPDX-License-Identifier
Date: Fri,  8 Dec 2017 18:05:37 +0530
Message-Id: <20171208123537.18718-1-dhaval23031987@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SPDX-License-Identifier is used for the Xilinx Video IP and
related drivers.

Signed-off-by: Dhaval Shah <dhaval23031987@gmail.com>
---
 drivers/media/platform/xilinx/xilinx-dma.c  | 5 +----
 drivers/media/platform/xilinx/xilinx-dma.h  | 5 +----
 drivers/media/platform/xilinx/xilinx-tpg.c  | 5 +----
 drivers/media/platform/xilinx/xilinx-vip.c  | 5 +----
 drivers/media/platform/xilinx/xilinx-vip.h  | 5 +----
 drivers/media/platform/xilinx/xilinx-vipp.c | 5 +----
 drivers/media/platform/xilinx/xilinx-vipp.h | 5 +----
 drivers/media/platform/xilinx/xilinx-vtc.c  | 5 +----
 drivers/media/platform/xilinx/xilinx-vtc.h  | 5 +----
 9 files changed, 9 insertions(+), 36 deletions(-)

diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index 522cdfdd3345..2e5daf7dba1a 100644
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
index 9c49d1d10bee..20a68a65602b 100644
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
index d881cf09876d..cb9ab2c15952 100644
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
-- 
2.11.0
