Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45891 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbcGRB4c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:32 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lee Jones <lee.jones@linaro.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-doc@vger.kernel.org
Subject: [PATCH 22/36] [media] doc-rst: add omap4_camera documentation
Date: Sun, 17 Jul 2016 22:56:05 -0300
Message-Id: <93db50d6eca773b977598da1f5a2c2382efd61a6.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert the omap4_camera documentation to ReST and add it to
the media/v4l-drivers book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/index.rst        |  1 +
 Documentation/media/v4l-drivers/omap4_camera.rst | 28 ++++++++++++------------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index 272c2dc9ceb1..cb85bca0a077 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -29,4 +29,5 @@ License".
 	ivtv
 	meye
 	omap3isp
+	omap4_camera
 	zr364xx
diff --git a/Documentation/media/v4l-drivers/omap4_camera.rst b/Documentation/media/v4l-drivers/omap4_camera.rst
index a6734aa77242..54b427b28e5f 100644
--- a/Documentation/media/v4l-drivers/omap4_camera.rst
+++ b/Documentation/media/v4l-drivers/omap4_camera.rst
@@ -1,5 +1,9 @@
-                              OMAP4 ISS Driver
-                              ================
+OMAP4 ISS Driver
+================
+
+Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
+
+Copyright (C) 2012, Texas Instruments
 
 Introduction
 ------------
@@ -11,15 +15,15 @@ Which contains several components that can be categorized in 3 big groups:
 - ISP (Image Signal Processor)
 - SIMCOP (Still Image Coprocessor)
 
-For more information, please look in [1] for latest version of:
-	"OMAP4430 Multimedia Device Silicon Revision 2.x"
+For more information, please look in [#f1]_ for latest version of:
+"OMAP4430 Multimedia Device Silicon Revision 2.x"
 
 As of Revision AB, the ISS is described in detail in section 8.
 
-This driver is supporting _only_ the CSI2-A/B interfaces for now.
+This driver is supporting **only** the CSI2-A/B interfaces for now.
 
-It makes use of the Media Controller framework [2], and inherited most of the
-code from OMAP3 ISP driver (found under drivers/media/platform/omap3isp/*),
+It makes use of the Media Controller framework [#f2]_, and inherited most of the
+code from OMAP3 ISP driver (found under drivers/media/platform/omap3isp/\*),
 except that it doesn't need an IOMMU now for ISS buffers memory mapping.
 
 Supports usage of MMAP buffers only (for now).
@@ -40,7 +44,7 @@ Tested platforms
 
 - Tested on mainline kernel:
 
-	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=summary
+	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=summary
 
   Tag: v3.3 (commit c16fa4f2ad19908a47c63d8fa436a1178438c7e7)
 
@@ -52,9 +56,5 @@ include/linux/platform_data/media/omap4iss.h
 References
 ----------
 
-[1] http://focus.ti.com/general/docs/wtbu/wtbudocumentcenter.tsp?navigationId=12037&templateId=6123#62
-[2] http://lwn.net/Articles/420485/
-[3] http://www.spinics.net/lists/linux-media/msg44370.html
---
-Author: Sergio Aguirre <sergio.a.aguirre@gmail.com>
-Copyright (C) 2012, Texas Instruments
+.. [#f1] http://focus.ti.com/general/docs/wtbu/wtbudocumentcenter.tsp?navigationId=12037&templateId=6123#62
+.. [#f2] http://lwn.net/Articles/420485/
-- 
2.7.4

