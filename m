Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:8801 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753026AbeCPQoS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Mar 2018 12:44:18 -0400
From: Andy Yeh <andy.yeh@intel.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, andy.yeh@intel.com,
        Alan Chiang <alanx.chiang@intel.com>
Subject: [v6 1/2] media: dt-bindings: Add bindings for Dongwoon DW9807 voice coil
Date: Sat, 17 Mar 2018 00:49:22 +0800
Message-Id: <1521218963-15163-2-git-send-email-andy.yeh@intel.com>
In-Reply-To: <1521218963-15163-1-git-send-email-andy.yeh@intel.com>
References: <1521218963-15163-1-git-send-email-andy.yeh@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alan Chiang <alanx.chiang@intel.com>

Dongwoon DW9807 is a voice coil lens driver.

Signed-off-by: Andy Yeh <andy.yeh@intel.com>
---
 Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt | 9 +++++++++
 1 file changed, 9 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt b/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
new file mode 100644
index 0000000..0a1a860
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
2.7.4
