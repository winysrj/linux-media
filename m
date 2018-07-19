Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58674 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730273AbeGSMlC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jul 2018 08:41:02 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, robh@kernel.org
Subject: [PATCH 1/1] dt-bindings: dw9714, dw9807-vcm: Add files to MAINTAINERS, rename files
Date: Thu, 19 Jul 2018 14:58:11 +0300
Message-Id: <20180719115811.31559-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the DT binding documentation for dw9714 and dw9807-vcm to the
MAINTAINERS file. The dw9807-vcm binding documentation file is renamed to
match the dw9807's VCM bit's compatible string.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 .../bindings/media/i2c/{dongwoon,dw9807.txt => dongwoon,dw9807-vcm.txt} | 0
 MAINTAINERS                                                             | 2 ++
 2 files changed, 2 insertions(+)
 rename Documentation/devicetree/bindings/media/i2c/{dongwoon,dw9807.txt => dongwoon,dw9807-vcm.txt} (100%)

diff --git a/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt b/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807-vcm.txt
similarity index 100%
rename from Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
rename to Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807-vcm.txt
diff --git a/MAINTAINERS b/MAINTAINERS
index bbd9b9b3d74f..44e917de2c8c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4410,6 +4410,7 @@ L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/i2c/dw9714.c
+F:	Documentation/devicetree/bindings/media/i2c/dongwoon,dw9714.txt
 
 DONGWOON DW9807 LENS VOICE COIL DRIVER
 M:	Sakari Ailus <sakari.ailus@linux.intel.com>
@@ -4417,6 +4418,7 @@ L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/i2c/dw9807.c
+F:	Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807-vcm.txt
 
 DOUBLETALK DRIVER
 M:	"James R. Van Zandt" <jrv@vanzandt.mv.com>
-- 
2.11.0
