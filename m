Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:53000 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423Ab3I0SvQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Sep 2013 14:51:16 -0400
Received: by mail-pb0-f42.google.com with SMTP id un15so2941439pbc.1
        for <linux-media@vger.kernel.org>; Fri, 27 Sep 2013 11:51:16 -0700 (PDT)
From: Show Liu <show.liu@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, tom.gall@linaro.org,
	t.katayama@jp.fujitsu.com, vikas.sajjan@linaro.org,
	linaro-kernel@lists.linaro.org, tom.cooksey@arm.com,
	Show Liu <show.liu@linaro.org>
Subject: [PATCH/RFC v3 3/3] add pipe link for display entity
Date: Sat, 28 Sep 2013 02:50:46 +0800
Message-Id: <1380307846-27479-4-git-send-email-show.liu@linaro.org>
In-Reply-To: <1380307846-27479-1-git-send-email-show.liu@linaro.org>
References: <1380307846-27479-1-git-send-email-show.liu@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 arch/arm/boot/dts/rtsm_ve-motherboard.dtsi     |   46 ++++++++++++++++++++++++
 arch/arm/boot/dts/rtsm_ve-v2p-ca15x1-ca7x1.dts |    4 +++
 2 files changed, 50 insertions(+)

diff --git a/arch/arm/boot/dts/rtsm_ve-motherboard.dtsi b/arch/arm/boot/dts/rtsm_ve-motherboard.dtsi
index 6d12566..b4e032a 100644
--- a/arch/arm/boot/dts/rtsm_ve-motherboard.dtsi
+++ b/arch/arm/boot/dts/rtsm_ve-motherboard.dtsi
@@ -166,6 +166,17 @@
 				mode = "VGA";
 				use_dma = <0>;
 				framebuffer = <0x18000000 0x00180000>;
+
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+						port@0 {
+							reg = <0>;
+							clcd_out: endpoint {
+							};
+						};
+				};
 			};
 		};
 
@@ -214,6 +225,41 @@
 			muxfpga@0 {
 				compatible = "arm,vexpress-muxfpga";
 				arm,vexpress-sysreg,func = <7 0>;
+
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					port@0 {
+						reg = <0>;
+						muxfpga_in: endpoint {
+						remote-endpoint = <&clcd_out>;
+						};
+					};
+					port@1 {
+						reg = <1>;
+						muxfpga_out: endpoint {
+						remote-endpoint = <&con_vga_in>;
+						};
+					};
+
+				};
+			};
+
+			con-vga {
+				compatible = "con-vga";
+
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					port@0 {
+						reg = <0>;
+						con_vga_in: endpoint {
+						remote-endpoint = <&muxfpga_out>;
+						};
+					};
+				};
 			};
 
 			shutdown@0 {
diff --git a/arch/arm/boot/dts/rtsm_ve-v2p-ca15x1-ca7x1.dts b/arch/arm/boot/dts/rtsm_ve-v2p-ca15x1-ca7x1.dts
index c59f4b5..45a07c5 100644
--- a/arch/arm/boot/dts/rtsm_ve-v2p-ca15x1-ca7x1.dts
+++ b/arch/arm/boot/dts/rtsm_ve-v2p-ca15x1-ca7x1.dts
@@ -230,4 +230,8 @@
 	};
 };
 
+&clcd_out {
+	remote-endpoint = <&muxfpga_in>;
+};
+
 /include/ "clcd-panels.dtsi"
-- 
1.7.9.5

