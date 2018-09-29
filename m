Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44614 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728374AbeI2XKY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Sep 2018 19:10:24 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: joe@perches.com
Subject: [PATCH 1/1] MAINTAINERS: Fix entry for the renamed dw9807 driver
Date: Sat, 29 Sep 2018 19:41:17 +0300
Message-Id: <20180929164117.4762-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver for the dw9807 voice coil was renamed as dw9807-vcm.c to
reflect the fact that the chip also contains an EEPROM. While there is no
EEPROM (nor MFD) driver yet and it may not be ever even needed, the driver
was renamed accordingly. But the MAINTAINERS entry was not. Fix this.

Reported-by: Joe Perches <joe@perches.com>
Fixes: e6c17ada3188 ("media: dw9807-vcm: Recognise this is just the VCM bit of the device")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Thanks, Joe, for reporting this!

 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9989925f658d..721c00f892bd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4511,7 +4511,7 @@ M:	Sakari Ailus <sakari.ailus@linux.intel.com>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
-F:	drivers/media/i2c/dw9807.c
+F:	drivers/media/i2c/dw9807-vcm.c
 F:	Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807-vcm.txt
 
 DOUBLETALK DRIVER
-- 
2.11.0
