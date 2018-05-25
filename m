Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:52425 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965788AbeEYJxC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 05:53:02 -0400
From: bingbu.cao@intel.com
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, tian.shu.qiu@intel.com,
        rajmohan.mani@intel.com, tfiga@chromium.org
Subject: [RESEND PATCH V2 1/2] dt-bindings: Add bindings for AKM ak7375 voice coil lens
Date: Fri, 25 May 2018 17:55:34 +0800
Message-Id: <1527242135-22866-1-git-send-email-bingbu.cao@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Bingbu Cao <bingbu.cao@intel.com>

Add device tree bindings for AKM ak7375 voice coil lens
driver. This chip is used to drive a lens in a camera module.

Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
---
Changes since v1:
 - remove the vendor prefix change
---
 Documentation/devicetree/bindings/media/i2c/ak7375.txt | 8 ++++++++
 1 file changed, 8 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ak7375.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/ak7375.txt b/Documentation/devicetree/bindings/media/i2c/ak7375.txt
new file mode 100644
index 000000000000..aa3e24b41241
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/ak7375.txt
@@ -0,0 +1,8 @@
+Asahi Kasei Microdevices AK7375 voice coil lens driver
+
+AK7375 is a camera voice coil lens.
+
+Mandatory properties:
+
+- compatible: "asahi-kasei,ak7375"
+- reg: I2C slave address
-- 
1.9.1
