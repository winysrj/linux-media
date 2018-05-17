Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:57704 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750819AbeEQEAv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 00:00:51 -0400
From: bingbu.cao@intel.com
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, bingbu.cao@linux.intel.com,
        tian.shu.qiu@linux.intel.com, rajmohan.mani@intel.com,
        mchehab@kernel.org
Subject: [PATCH 2/3] dt-bindings: Add bindings for AKM ak7375 voice coil lens
Date: Thu, 17 May 2018 12:03:13 +0800
Message-Id: <1526529794-25569-2-git-send-email-bingbu.cao@intel.com>
In-Reply-To: <1526529794-25569-1-git-send-email-bingbu.cao@intel.com>
References: <1526529794-25569-1-git-send-email-bingbu.cao@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Bingbu Cao <bingbu.cao@intel.com>

Add device tree bindings for AKM ak7375 voice coil lens
driver. This chip is used to drive a lens in a camera module.

Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
---
 Documentation/devicetree/bindings/media/i2c/akm,ak7375.txt | 8 ++++++++
 1 file changed, 8 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/akm,ak7375.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/akm,ak7375.txt b/Documentation/devicetree/bindings/media/i2c/akm,ak7375.txt
new file mode 100644
index 000000000000..ec7f3c82dc57
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/akm,ak7375.txt
@@ -0,0 +1,8 @@
+Asahi Kasei Microdevices AK7375 voice coil lens driver
+
+AK7375 is a 12-bit DAC intended for controlling voice coil lenses.
+
+Mandatory properties:
+
+- compatible: "akm,ak7375"
+- reg: I2C slave address
-- 
1.9.1
