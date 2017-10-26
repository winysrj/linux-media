Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40186 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752086AbdJZImv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Oct 2017 04:42:51 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, leonl@leopardimaging.com
Subject: [PATCH 1/1] imx274: Add MAINTAINERS entry
Date: Thu, 26 Oct 2017 11:42:47 +0300
Message-Id: <20171026084247.12660-1-sakari.ailus@linux.intel.com>
In-Reply-To: <20171026065103.28213-1-leonl@leopardimaging.com>
References: <20171026065103.28213-1-leonl@leopardimaging.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add MAINTAINERS entry for imx274 driver and DT bindings.

Signed-off-by: Leon Luo <leonl@leopardimaging.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Hi Leon,

I moved the maintainers entry to a separate patch. It's better this way.

 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 90230fe020f3..b5927bd4fe1e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12486,6 +12486,14 @@ S:	Maintained
 F:	drivers/ssb/
 F:	include/linux/ssb/
 
+SONY IMX274 SENSOR DRIVER
+M:	Leon Luo <leonl@leopardimaging.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/i2c/imx274.c
+F:	Documentation/devicetree/bindings/media/i2c/imx274.txt
+
 SONY MEMORYSTICK CARD SUPPORT
 M:	Alex Dubov <oakad@yahoo.com>
 W:	http://tifmxx.berlios.de/
-- 
2.11.0
