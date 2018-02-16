Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:46974 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750884AbeBPXsr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Feb 2018 18:48:47 -0500
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: rajmohan.mani@intel.com, jian.xu.zheng@intel.com,
        Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH] media: intel-ipu3: cio2: Use SPDX license headers
Date: Fri, 16 Feb 2018 17:48:34 -0600
Message-Id: <1518824914-23422-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adopt SPDX license headers for ipu3 cio2 driver.

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
---
 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 12 ++----------
 drivers/media/pci/intel/ipu3/ipu3-cio2.h | 14 ++------------
 2 files changed, 4 insertions(+), 22 deletions(-)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 6c4444b31f4b..af2da03a160f 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1,14 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
- * Copyright (c) 2017 Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License version
- * 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
+ * Copyright (C) 2017 Intel Corporation
  *
  * Based partially on Intel IPU4 driver written by
  *  Sakari Ailus <sakari.ailus@linux.intel.com>
diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.h b/drivers/media/pci/intel/ipu3/ipu3-cio2.h
index 78a5799f08e7..240635be7a31 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.h
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.h
@@ -1,15 +1,5 @@
-/*
- * Copyright (c) 2017 Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License version
- * 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2017 Intel Corporation */
 
 #ifndef __IPU3_CIO2_H
 #define __IPU3_CIO2_H
-- 
2.7.4
