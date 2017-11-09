Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37416 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752622AbdKIA32 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Nov 2017 19:29:28 -0500
From: Yong Zhi <yong.zhi@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: jian.xu.zheng@intel.com, tfiga@chromium.org,
        rajmohan.mani@intel.com, tuukka.toivonen@intel.com,
        hyungwoo.yang@intel.com, chiranjeevi.rapolu@intel.com,
        jerry.w.hu@intel.com, Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH v8 4/4] MAINTAINERS: add entry for Intel IPU3 driver
Date: Wed,  8 Nov 2017 16:30:39 -0800
Message-Id: <1510187439-19125-5-git-send-email-yong.zhi@intel.com>
In-Reply-To: <1510187439-19125-1-git-send-email-yong.zhi@intel.com>
References: <1510187439-19125-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an entry for Intel IPU3 cio2 driver.

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index adbf693..a1ffb73 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6987,6 +6987,14 @@ R:	Dan Williams <dan.j.williams@intel.com>
 S:	Odd fixes
 F:	drivers/dma/iop-adma.c
 
+INTEL IPU3 CSI-2 CIO2 DRIVER
+M:	Yong Zhi <yong.zhi@intel.com>
+M:	Sakari Ailus <sakari.ailus@linux.intel.com>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/pci/intel/ipu3/
+F:	Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
+
 INTEL IXP4XX QMGR, NPE, ETHERNET and HSS SUPPORT
 M:	Krzysztof Halasa <khalasa@piap.pl>
 S:	Maintained
-- 
1.9.1
