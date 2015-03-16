Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44809 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752524AbbCPACH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 20:02:07 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-omap@vger.kernel.org
Cc: tony@atomide.com, sre@kernel.org, pali.rohar@gmail.com,
	laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Subject: [PATCH 2/4] dt: bindings: Add bindings for omap3isp
Date: Mon, 16 Mar 2015 02:01:18 +0200
Message-Id: <1426464080-29119-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1426464080-29119-1-git-send-email-sakari.ailus@iki.fi>
References: <1426464080-29119-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 .../devicetree/bindings/media/ti,omap3isp.txt      |   71 ++++++++++++++++++++
 MAINTAINERS                                        |    1 +
 include/dt-bindings/media/omap3-isp.h              |   22 ++++++
 3 files changed, 94 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/ti,omap3isp.txt
 create mode 100644 include/dt-bindings/media/omap3-isp.h

diff --git a/Documentation/devicetree/bindings/media/ti,omap3isp.txt b/Documentation/devicetree/bindings/media/ti,omap3isp.txt
new file mode 100644
index 0000000..547b493
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/ti,omap3isp.txt
@@ -0,0 +1,71 @@
+OMAP 3 ISP Device Tree bindings
+===============================
+
+The DT definitions can be found in include/dt-bindings/media/omap3-isp.h.
+
+Required properties
+===================
+
+compatible	: must contain "ti,omap3-isp"
+
+reg		: the two registers sets (physical address and length) for the
+		  ISP. The first set contains the core ISP registers up to
+		  the end of the SBL block. The second set contains the
+		  CSI PHYs and receivers registers.
+interrupts	: the ISP interrupt specifier
+iommus		: phandle and IOMMU specifier for the IOMMU that serves the ISP
+syscon		: the phandle and register offset to the Complex I/O or CSI-PHY
+		  register
+ti,phy-type	: 0 -- OMAP3ISP_PHY_TYPE_COMPLEX_IO (e.g. 3430)
+		  1 -- OMAP3ISP_PHY_TYPE_CSIPHY (e.g. 3630)
+#clock-cells	: Must be 1 --- the ISP provides two external clocks,
+		  cam_xclka and cam_xclkb, at indices 0 and 1,
+		  respectively. Please find more information on common
+		  clock bindings in ../clock/clock-bindings.txt.
+
+Port nodes (optional)
+---------------------
+
+More documentation on these bindings is available in
+video-interfaces.txt in the same directory.
+
+reg		: The interface:
+		  0 - parallel (CCDC)
+		  1 - CSIPHY1 -- CSI2C / CCP2B on 3630;
+		      CSI1 -- CSIb on 3430
+		  2 - CSIPHY2 -- CSI2A / CCP2B on 3630;
+		      CSI2 -- CSIa on 3430
+
+Optional properties
+===================
+
+vdd-csiphy1-supply : voltage supply of the CSI-2 PHY 1
+vdd-csiphy2-supply : voltage supply of the CSI-2 PHY 2
+
+Endpoint nodes
+--------------
+
+lane-polarity	: lane polarity (required on CSI-2)
+		  0 -- not inverted; 1 -- inverted
+data-lanes	: an array of data lanes from 1 to 3. The length can
+		  be either 1 or 2. (required on CSI-2)
+clock-lanes	: the clock lane (from 1 to 3). (required on CSI-2)
+
+
+Example
+=======
+
+		isp@480bc000 {
+			compatible = "ti,omap3-isp";
+			reg = <0x480bc000 0x12fc
+			       0x480bd800 0x0600>;
+			interrupts = <24>;
+			iommus = <&mmu_isp>;
+			syscon = <&omap3_scm_general 0x2f0>;
+			ti,phy-type = <1>;
+			#clock-cells = <1>;
+			ports {
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+		};
diff --git a/MAINTAINERS b/MAINTAINERS
index af8df65..a102624 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6949,6 +6949,7 @@ OMAP IMAGING SUBSYSTEM (OMAP3 ISP and OMAP4 ISS)
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 L:	linux-media@vger.kernel.org
 S:	Maintained
+F:	Documentation/devicetree/bindings/media/ti,omap3isp.txt
 F:	drivers/media/platform/omap3isp/
 F:	drivers/staging/media/omap4iss/
 
diff --git a/include/dt-bindings/media/omap3-isp.h b/include/dt-bindings/media/omap3-isp.h
new file mode 100644
index 0000000..b18c60e
--- /dev/null
+++ b/include/dt-bindings/media/omap3-isp.h
@@ -0,0 +1,22 @@
+/*
+ * include/dt-bindings/media/omap3-isp.h
+ *
+ * Copyright (C) 2015 Sakari Ailus
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __DT_BINDINGS_OMAP3_ISP_H__
+#define __DT_BINDINGS_OMAP3_ISP_H__
+
+#define OMAP3ISP_PHY_TYPE_COMPLEX_IO	0
+#define OMAP3ISP_PHY_TYPE_CSIPHY	1
+
+#endif /* __DT_BINDINGS_OMAP3_ISP_H__ */
-- 
1.7.10.4

