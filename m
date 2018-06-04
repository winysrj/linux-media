Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2001 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751978AbeFDI5i (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Jun 2018 04:57:38 -0400
From: bingbu.cao@intel.com
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, tfiga@google.com, jacopo@jmondi.org,
        rajmohan.mani@intel.com, bingbu.cao@linux.intel.com,
        tian.shu.qiu@intel.com, jian.xu.zheng@intel.com
Subject: [PATCH v3 1/2] dt-bindings: Add bindings for AKM ak7375 voice coil lens
Date: Mon,  4 Jun 2018 17:00:18 +0800
Message-Id: <1528102819-10485-1-git-send-email-bingbu.cao@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Bingbu Cao <bingbu.cao@intel.com>

Add device tree bindings for asahi-kasei ak7375 voice coil lens
driver. This chip is used to drive a lens in a camera module.

Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>

---
Changes since v1:
    - add the MAINTAINERS change
    - correct the vendor prefix from akm to asahi-kasei
---
---
 Documentation/devicetree/bindings/media/i2c/ak7375.txt | 8 ++++++++
 MAINTAINERS                                            | 8 ++++++++
 2 files changed, 16 insertions(+)
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
diff --git a/MAINTAINERS b/MAINTAINERS
index ea362219c4aa..ad68d75abc84 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2258,6 +2258,14 @@ L:	linux-leds@vger.kernel.org
 S:	Maintained
 F:	drivers/leds/leds-as3645a.c
 
+ASAHI KASEI AK7375 LENS VOICE COIL DRIVER
+M:	Tianshu Qiu <tian.shu.qiu@intel.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/i2c/ak7375.c
+F:	Documentation/devicetree/bindings/media/i2c/ak7375.txt
+
 ASAHI KASEI AK8974 DRIVER
 M:	Linus Walleij <linus.walleij@linaro.org>
 L:	linux-iio@vger.kernel.org
-- 
1.9.1
