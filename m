Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33320 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752876AbbCGVmS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Mar 2015 16:42:18 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, pali.rohar@gmail.com
Subject: [RFC 14/18] dt: bindings: Add bindings for omap3isp
Date: Sat,  7 Mar 2015 23:41:11 +0200
Message-Id: <1425764475-27691-15-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 .../devicetree/bindings/media/ti,omap3isp.txt      |   64 ++++++++++++++++++++
 MAINTAINERS                                        |    1 +
 2 files changed, 65 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/ti,omap3isp.txt

diff --git a/Documentation/devicetree/bindings/media/ti,omap3isp.txt b/Documentation/devicetree/bindings/media/ti,omap3isp.txt
new file mode 100644
index 0000000..2059524
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/ti,omap3isp.txt
@@ -0,0 +1,64 @@
+OMAP 3 ISP Device Tree bindings
+===============================
+
+More documentation on these bindings is available in
+video-interfaces.txt in the same directory.
+
+Required properties
+===================
+
+compatible	: "ti,omap3-isp"
+reg		: a set of two register block physical addresses and
+		  lengths
+interrupts	: the interrupt number
+iommus		: phandle of the IOMMU
+syscon		: syscon phandle and register offset
+ti,phy-type	: 0 -- 3430; 1 -- 3630
+#clock-cells	: Must be 1 --- the ISP provides two external clocks,
+		  cam_xclka and cam_xclkb, at indices 0 and 1,
+		  respectively. Please find more information on common
+		  clock bindings in ../clock/clock-bindings.txt.
+
+Port nodes (optional)
+---------------------
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
+		  be either 1 or 2. (required CSI-2)
+clock-lanes	: the clock lane (from 1 to 3). (required on CSI-2)
+
+
+Example
+=======
+
+		omap3_isp: omap3_isp@480bc000 {
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
index ddc5a8c..cdeef39 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7079,6 +7079,7 @@ L:	linux-media@vger.kernel.org
 S:	Maintained
 F:	drivers/media/platform/omap3isp/
 F:	drivers/staging/media/omap4iss/
+F:	Documentation/devicetree/bindings/media/ti,omap3isp.txt
 
 OMAP USB SUPPORT
 M:	Felipe Balbi <balbi@ti.com>
-- 
1.7.10.4

