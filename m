Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:46584 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751690AbeA2QcF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 11:32:05 -0500
From: Andy Yeh <andy.yeh@intel.com>
To: linux-media@vger.kernel.org
Cc: andy.yeh@intel.com, sakari.ailus@linux.intel.com,
        tfiga@chromium.org, Alan Chiang <alanx.chiang@intel.com>
Subject: [PATCH v1] media: dt-bindings: Add bindings for Dongwoon DW9807 voice coil
Date: Tue, 30 Jan 2018 00:34:32 +0800
Message-Id: <1517243672-17979-1-git-send-email-andy.yeh@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alan Chiang <alanx.chiang@intel.com>

Dongwoon DW9807 is a voice coil lens driver.

Also add a vendor prefix for Dongwoon for one did not exist previously.

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
