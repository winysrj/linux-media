Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:64072 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752996AbdHQNqR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Aug 2017 09:46:17 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, rajmohan.mani@intel.com
Subject: [PATCH 1/3] dt-bindings: Add bindings for Dongwoon DW9714 voice coil
Date: Thu, 17 Aug 2017 16:42:54 +0300
Message-Id: <1502977376-22836-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1502977376-22836-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1502977376-22836-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dongwoon DW9714 is a voice coil lens driver.

Also add a vendor prefix for Dongwoon for one did not exist previously.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/devicetree/bindings/media/i2c/dongwoon,dw9714.txt | 9 +++++++++
 Documentation/devicetree/bindings/vendor-prefixes.txt           | 1 +
 2 files changed, 10 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/dongwoon,dw9714.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9714.txt b/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9714.txt
new file mode 100644
index 0000000..b88dcdd
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9714.txt
@@ -0,0 +1,9 @@
+Dongwoon Anatech DW9714 camera voice coil lens driver
+
+DW9174 is a 10-bit DAC with current sink capability. It is intended
+for driving voice coil lenses in camera modules.
+
+Mandatory properties:
+
+- compatible: "dongwoon,dw9714"
+- reg: I²C slave address
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index daf465be..6b6e683 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -88,6 +88,7 @@ dlg	Dialog Semiconductor
 dlink	D-Link Corporation
 dmo	Data Modul AG
 domintech	Domintech Co., Ltd.
+dongwoon	Dongwoon Anatech
 dptechnics	DPTechnics
 dragino	Dragino Technology Co., Limited
 ea	Embedded Artists AB
-- 
2.7.4
