Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:39962 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388115AbeGWMEq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 08:04:46 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Subject: [PATCH v3 15/35] media: dt-bindings: media: qcom,camss: Fix whitespaces
Date: Mon, 23 Jul 2018 14:02:32 +0300
Message-Id: <1532343772-27382-16-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1532343772-27382-1-git-send-email-todor.tomov@linaro.org>
References: <1532343772-27382-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use tabs.

CC: Rob Herring <robh+dt@kernel.org>
CC: Mark Rutland <mark.rutland@arm.com>
CC: devicetree@vger.kernel.org
Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/media/qcom,camss.txt       | 92 +++++++++++-----------
 1 file changed, 46 insertions(+), 46 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/qcom,camss.txt b/Documentation/devicetree/bindings/media/qcom,camss.txt
index 032e8ed..e938eb0 100644
--- a/Documentation/devicetree/bindings/media/qcom,camss.txt
+++ b/Documentation/devicetree/bindings/media/qcom,camss.txt
@@ -53,25 +53,25 @@ Qualcomm Camera Subsystem
 	Usage: required
 	Value type: <stringlist>
 	Definition: Should contain the following entries:
-                - "top_ahb"
-                - "ispif_ahb"
-                - "csiphy0_timer"
-                - "csiphy1_timer"
-                - "csi0_ahb"
-                - "csi0"
-                - "csi0_phy"
-                - "csi0_pix"
-                - "csi0_rdi"
-                - "csi1_ahb"
-                - "csi1"
-                - "csi1_phy"
-                - "csi1_pix"
-                - "csi1_rdi"
-                - "ahb"
-                - "vfe0"
-                - "csi_vfe0"
-                - "vfe_ahb"
-                - "vfe_axi"
+		- "top_ahb"
+		- "ispif_ahb"
+		- "csiphy0_timer"
+		- "csiphy1_timer"
+		- "csi0_ahb"
+		- "csi0"
+		- "csi0_phy"
+		- "csi0_pix"
+		- "csi0_rdi"
+		- "csi1_ahb"
+		- "csi1"
+		- "csi1_phy"
+		- "csi1_pix"
+		- "csi1_rdi"
+		- "ahb"
+		- "vfe0"
+		- "csi_vfe0"
+		- "vfe_ahb"
+		- "vfe_axi"
 - vdda-supply:
 	Usage: required
 	Value type: <phandle>
@@ -95,17 +95,17 @@ Qualcomm Camera Subsystem
 		- clock-lanes:
 			Usage: required
 			Value type: <u32>
-                        Definition: The physical clock lane index. The value
-                                    must always be <1> as the physical clock
-                                    lane is lane 1.
+			Definition: The physical clock lane index. The value
+				    must always be <1> as the physical clock
+				    lane is lane 1.
 		- data-lanes:
 			Usage: required
 			Value type: <prop-encoded-array>
-                        Definition: An array of physical data lanes indexes.
-                                    Position of an entry determines the logical
-                                    lane number, while the value of an entry
-                                    indicates physical lane index. Lane swapping
-                                    is supported.
+			Definition: An array of physical data lanes indexes.
+				    Position of an entry determines the logical
+				    lane number, while the value of an entry
+				    indicates physical lane index. Lane swapping
+				    is supported.
 
 * An Example
 
@@ -161,25 +161,25 @@ Qualcomm Camera Subsystem
 			<&gcc GCC_CAMSS_CSI_VFE0_CLK>,
 			<&gcc GCC_CAMSS_VFE_AHB_CLK>,
 			<&gcc GCC_CAMSS_VFE_AXI_CLK>;
-                clock-names = "top_ahb",
-                        "ispif_ahb",
-                        "csiphy0_timer",
-                        "csiphy1_timer",
-                        "csi0_ahb",
-                        "csi0",
-                        "csi0_phy",
-                        "csi0_pix",
-                        "csi0_rdi",
-                        "csi1_ahb",
-                        "csi1",
-                        "csi1_phy",
-                        "csi1_pix",
-                        "csi1_rdi",
-                        "ahb",
-                        "vfe0",
-                        "csi_vfe0",
-                        "vfe_ahb",
-                        "vfe_axi";
+		clock-names = "top_ahb",
+			"ispif_ahb",
+			"csiphy0_timer",
+			"csiphy1_timer",
+			"csi0_ahb",
+			"csi0",
+			"csi0_phy",
+			"csi0_pix",
+			"csi0_rdi",
+			"csi1_ahb",
+			"csi1",
+			"csi1_phy",
+			"csi1_pix",
+			"csi1_rdi",
+			"ahb",
+			"vfe0",
+			"csi_vfe0",
+			"vfe_ahb",
+			"vfe_axi";
 		vdda-supply = <&pm8916_l2>;
 		iommus = <&apps_iommu 3>;
 		ports {
-- 
2.7.4
