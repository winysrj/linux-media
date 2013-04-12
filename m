Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f51.google.com ([209.85.210.51]:49646 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab3DLF4j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 01:56:39 -0400
Received: by mail-da0-f51.google.com with SMTP id g27so988062dan.24
        for <linux-media@vger.kernel.org>; Thu, 11 Apr 2013 22:56:38 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: devicetree-discuss@lists.ozlabs.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: rob.herring@calxeda.com, grant.likely@secretlab.ca,
	robherring2@gmail.com, sachin.kamat@linaro.org, patches@linaro.org,
	Inki Dae <inki.dae@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Ajay Kumar <ajaykumar.rs@samsung.com>
Subject: [PATCH Resend 1/1] Revert "of/exynos_g2d: Add Bindings for exynos G2D driver"
Date: Fri, 12 Apr 2013 11:14:31 +0530
Message-Id: <1365745471-4853-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit 09495dda6a62c74b13412a63528093910ef80edd.
The description is incomplete and the location of this file
is incorrect. Based on discussion with the Samsung media and DRM subsystem
maintainers, the documentaion of Samsung G2D bindings has been placed at:
Documentation/devicetree/bindings/gpu/samsung-g2d.txt

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Ajay Kumar <ajaykumar.rs@samsung.com>
---
The right documentation for G2D bindings has already been merged for 3.10-rc
and hence we need this patch for 3.10-rc too, to avoid confusions due to
multiple documents.
---
 .../devicetree/bindings/drm/exynos/g2d.txt         |   22 --------------------
 1 file changed, 22 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/drm/exynos/g2d.txt

diff --git a/Documentation/devicetree/bindings/drm/exynos/g2d.txt b/Documentation/devicetree/bindings/drm/exynos/g2d.txt
deleted file mode 100644
index 1eb124d..0000000
--- a/Documentation/devicetree/bindings/drm/exynos/g2d.txt
+++ /dev/null
@@ -1,22 +0,0 @@
-Samsung 2D Graphic Accelerator using DRM frame work
-
-Samsung FIMG2D is a graphics 2D accelerator which supports Bit Block Transfer.
-We set the drawing-context registers for configuring rendering parameters and
-then start rendering.
-This driver is for SOCs which contain G2D IPs with version 4.1.
-
-Required properties:
-	-compatible:
-		should be "samsung,exynos-g2d-41".
-	-reg:
-		physical base address of the controller and length
-		of memory mapped region.
-	-interrupts:
-		interrupt combiner values.
-
-Example:
-	g2d {
-		compatible = "samsung,exynos-g2d-41";
-		reg = <0x10850000 0x1000>;
-		interrupts = <0 91 0>;
-	};
-- 
1.7.9.5

