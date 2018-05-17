Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33950 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751280AbeEQKnH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 06:43:07 -0400
Received: from lanttu.localdomain (unknown [IPv6:2001:1bc8:1a6:d3d5::e1:1001])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 334E3634C80
        for <linux-media@vger.kernel.org>; Thu, 17 May 2018 13:43:05 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/3] media: dt-bindings: Add bindings for Dongwoon DW9807 voice coil
Date: Thu, 17 May 2018 13:43:02 +0300
Message-Id: <20180517104304.10200-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20180517104304.10200-1-sakari.ailus@linux.intel.com>
References: <20180517104304.10200-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alan Chiang <alanx.chiang@intel.com>

Dongwoon DW9807 is a voice coil lens driver.

Signed-off-by: Alan Chiang <alanx.chiang@intel.com>
Signed-off-by: Andy Yeh <andy.yeh@intel.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt | 9 +++++++++
 1 file changed, 9 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt b/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
new file mode 100644
index 000000000000..0a1a860beaff
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
@@ -0,0 +1,9 @@
+Dongwoon Anatech DW9807 voice coil lens driver
+
+DW9807 is a 10-bit DAC with current sink capability. It is intended for
+controlling voice coil lenses.
+
+Mandatory properties:
+
+- compatible: "dongwoon,dw9807"
+- reg: I2C slave address
-- 
2.11.0
