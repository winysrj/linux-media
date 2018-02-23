Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:11780 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751405AbeBWQJG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Feb 2018 11:09:06 -0500
From: Andy Yeh <andy.yeh@intel.com>
To: linux-media@vger.kernel.org
Cc: andy.yeh@intel.com, sakari.ailus@linux.intel.com, tfiga@google.com,
        devicetree@vger.kernel.org, Alan Chiang <alanx.chiang@intel.com>
Subject: [v5 2/2] media: dt-bindings: Add bindings for Dongwoon DW9807 voice coil
Date: Sat, 24 Feb 2018 00:13:42 +0800
Message-Id: <1519402422-9595-3-git-send-email-andy.yeh@intel.com>
In-Reply-To: <1519402422-9595-1-git-send-email-andy.yeh@intel.com>
References: <1519402422-9595-1-git-send-email-andy.yeh@intel.com>
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
