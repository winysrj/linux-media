Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34985 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932431AbeE3WKM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 18:10:12 -0400
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: rajmohan.mani@intel.com, jian.xu.zheng@intel.com,
        tian.shu.qiu@intel.com, bingbu.cao@intel.com,
        Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH v2] [media] MAINTAINERS: Update entry for Intel IPU3 cio2 driver
Date: Wed, 30 May 2018 15:10:16 -0700
Message-Id: <1527718216-826-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds three more maintainers to the IPU3 CIO2 driver.

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
---
 MAINTAINERS | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a38e24a..3dd530e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7157,6 +7157,9 @@ F:	drivers/dma/iop-adma.c
 INTEL IPU3 CSI-2 CIO2 DRIVER
 M:	Yong Zhi <yong.zhi@intel.com>
 M:	Sakari Ailus <sakari.ailus@linux.intel.com>
+M:	Bingbu Cao <bingbu.cao@intel.com>
+R:	Tian Shu Qiu <tian.shu.qiu@intel.com>
+R:	Jian Xu Zheng <jian.xu.zheng@intel.com>
 L:	linux-media@vger.kernel.org
 S:	Maintained
 F:	drivers/media/pci/intel/ipu3/
-- 
2.7.4
