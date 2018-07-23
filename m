Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:39911 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388058AbeGWMEp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 08:04:45 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Subject: [PATCH v3 08/35] media: dt-bindings: media: qcom,camss: Unify the clock names
Date: Mon, 23 Jul 2018 14:02:25 +0300
Message-Id: <1532343772-27382-9-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1532343772-27382-1-git-send-email-todor.tomov@linaro.org>
References: <1532343772-27382-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use more logical clock names - similar to the names in documentation.
This will allow better handling of the clocks in the driver when support
for more hardware versions is added - equivalent clocks on different
hardware versions will have the same name.

CC: Rob Herring <robh+dt@kernel.org>
CC: Mark Rutland <mark.rutland@arm.com>
CC: devicetree@vger.kernel.org
Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 .../devicetree/bindings/media/qcom,camss.txt       | 24 +++++++++++-----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/qcom,camss.txt b/Documentation/devicetree/bindings/media/qcom,camss.txt
index cadeceb..032e8ed 100644
--- a/Documentation/devicetree/bindings/media/qcom,camss.txt
+++ b/Documentation/devicetree/bindings/media/qcom,camss.txt
@@ -53,7 +53,7 @@ Qualcomm Camera Subsystem
 	Usage: required
 	Value type: <stringlist>
 	Definition: Should contain the following entries:
-                - "camss_top_ahb"
+                - "top_ahb"
                 - "ispif_ahb"
                 - "csiphy0_timer"
                 - "csiphy1_timer"
@@ -67,11 +67,11 @@ Qualcomm Camera Subsystem
                 - "csi1_phy"
                 - "csi1_pix"
                 - "csi1_rdi"
-                - "camss_ahb"
-                - "camss_vfe_vfe"
-                - "camss_csi_vfe"
-                - "iface"
-                - "bus"
+                - "ahb"
+                - "vfe0"
+                - "csi_vfe0"
+                - "vfe_ahb"
+                - "vfe_axi"
 - vdda-supply:
 	Usage: required
 	Value type: <phandle>
@@ -161,7 +161,7 @@ Qualcomm Camera Subsystem
 			<&gcc GCC_CAMSS_CSI_VFE0_CLK>,
 			<&gcc GCC_CAMSS_VFE_AHB_CLK>,
 			<&gcc GCC_CAMSS_VFE_AXI_CLK>;
-                clock-names = "camss_top_ahb",
+                clock-names = "top_ahb",
                         "ispif_ahb",
                         "csiphy0_timer",
                         "csiphy1_timer",
@@ -175,11 +175,11 @@ Qualcomm Camera Subsystem
                         "csi1_phy",
                         "csi1_pix",
                         "csi1_rdi",
-                        "camss_ahb",
-                        "camss_vfe_vfe",
-                        "camss_csi_vfe",
-                        "iface",
-                        "bus";
+                        "ahb",
+                        "vfe0",
+                        "csi_vfe0",
+                        "vfe_ahb",
+                        "vfe_axi";
 		vdda-supply = <&pm8916_l2>;
 		iommus = <&apps_iommu 3>;
 		ports {
-- 
2.7.4
