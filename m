Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:15150 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752132AbeBFEUG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 23:20:06 -0500
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH] media: intel-ipu3: cio2: Use SPDX license headers
Date: Mon,  5 Feb 2018 20:19:53 -0800
Message-Id: <1517890793-9360-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adopt SPDX license headers and update year to 2018.

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
---
 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 12 ++----------
 drivers/media/pci/intel/ipu3/ipu3-cio2.h | 14 ++------------
 2 files changed, 4 insertions(+), 22 deletions(-)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 6c4444b..725973f 100644
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
+ * Copyright (C) 2018 Intel Corporation
  *
  * Based partially on Intel IPU4 driver written by
  *  Sakari Ailus <sakari.ailus@linux.intel.com>
diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.h b/drivers/media/pci/intel/ipu3/ipu3-cio2.h
index 78a5799..6a11051 100644
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
+/* Copyright (C) 2018 Intel Corporation */
 
 #ifndef __IPU3_CIO2_H
 #define __IPU3_CIO2_H
-- 
1.9.1
