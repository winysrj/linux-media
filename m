Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:60703 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750935AbeEPEWR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 00:22:17 -0400
From: Yong Zhi <yong.zhi@intel.com>
To: sakari.ailus@linux.intel.com, linux-media@vger.kernel.org
Cc: rajmohan.mani@intel.com, tian.shu.qiu@intel.com,
        bingbu.cao@intel.com, jian.xu.zheng@intel.com,
        Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH] [media] MAINTAINERS: Update entry for Intel IPU3 cio2 driver
Date: Tue, 15 May 2018 23:22:06 -0500
Message-Id: <1526444526-7638-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds three more maintainers to the IPU3 CIO2 driver.

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
---
 MAINTAINERS | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 49003f77cedd..309d49a54db8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7150,6 +7150,9 @@ F:	drivers/dma/iop-adma.c
 INTEL IPU3 CSI-2 CIO2 DRIVER
 M:	Yong Zhi <yong.zhi@intel.com>
 M:	Sakari Ailus <sakari.ailus@linux.intel.com>
+M:	Tian Shu Qiu <tian.shu.qiu@intel.com>
+M:	Bingbu Cao <bingbu.cao@intel.com>
+M:	Jian Xu Zheng <jian.xu.zheng@intel.com>
 L:	linux-media@vger.kernel.org
 S:	Maintained
 F:	drivers/media/pci/intel/ipu3/
-- 
2.7.4
