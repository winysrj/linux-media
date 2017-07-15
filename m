Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33604 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbdGOG73 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 02:59:29 -0400
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, heiko@sntech.de, robh+dt@kernel.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com,
        s.nawrocki@samsung.com, tfiga@chromium.org, nicolas@ndufresne.ca,
        Jacob Chen <jacob-chen@iotwrt.com>
Subject: [PATCH v2 5/6] ARM: dts: rockchip: enable RGA for rk3288 devices
Date: Sat, 15 Jul 2017 14:58:39 +0800
Message-Id: <1500101920-24039-6-git-send-email-jacob-chen@iotwrt.com>
In-Reply-To: <1500101920-24039-1-git-send-email-jacob-chen@iotwrt.com>
References: <1500101920-24039-1-git-send-email-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
---
 arch/arm/boot/dts/rk3288-evb.dtsi                 | 4 ++++
 arch/arm/boot/dts/rk3288-firefly-reload-core.dtsi | 4 ++++
 arch/arm/boot/dts/rk3288-firefly.dtsi             | 4 ++++
 arch/arm/boot/dts/rk3288-miqi.dts                 | 4 ++++
 arch/arm/boot/dts/rk3288-popmetal.dts             | 4 ++++
 arch/arm/boot/dts/rk3288-tinker.dts               | 4 ++++
 6 files changed, 24 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288-evb.dtsi b/arch/arm/boot/dts/rk3288-evb.dtsi
index 4905760..ec12162 100644
--- a/arch/arm/boot/dts/rk3288-evb.dtsi
+++ b/arch/arm/boot/dts/rk3288-evb.dtsi
@@ -379,6 +379,10 @@
 	};
 };
 
+&rga {
+	status = "okay";
+};
+
 &usbphy {
 	status = "okay";
 };
diff --git a/arch/arm/boot/dts/rk3288-firefly-reload-core.dtsi b/arch/arm/boot/dts/rk3288-firefly-reload-core.dtsi
index 8134966..fffa92e2 100644
--- a/arch/arm/boot/dts/rk3288-firefly-reload-core.dtsi
+++ b/arch/arm/boot/dts/rk3288-firefly-reload-core.dtsi
@@ -283,6 +283,10 @@
 	};
 };
 
+&rga {
+	status = "okay";
+};
+
 &tsadc {
 	rockchip,hw-tshut-mode = <0>;
 	rockchip,hw-tshut-polarity = <0>;
diff --git a/arch/arm/boot/dts/rk3288-firefly.dtsi b/arch/arm/boot/dts/rk3288-firefly.dtsi
index f520589..74a6ce5 100644
--- a/arch/arm/boot/dts/rk3288-firefly.dtsi
+++ b/arch/arm/boot/dts/rk3288-firefly.dtsi
@@ -500,6 +500,10 @@
 	};
 };
 
+&rga {
+	status = "okay";
+};
+
 &saradc {
 	vref-supply = <&vcc_18>;
 	status = "okay";
diff --git a/arch/arm/boot/dts/rk3288-miqi.dts b/arch/arm/boot/dts/rk3288-miqi.dts
index 21326f3..dc5e6bd 100644
--- a/arch/arm/boot/dts/rk3288-miqi.dts
+++ b/arch/arm/boot/dts/rk3288-miqi.dts
@@ -401,6 +401,10 @@
 	};
 };
 
+&rga {
+	status = "okay";
+};
+
 &saradc {
 	vref-supply = <&vcc_18>;
 	status = "okay";
diff --git a/arch/arm/boot/dts/rk3288-popmetal.dts b/arch/arm/boot/dts/rk3288-popmetal.dts
index aa1f9ec..362e5aa 100644
--- a/arch/arm/boot/dts/rk3288-popmetal.dts
+++ b/arch/arm/boot/dts/rk3288-popmetal.dts
@@ -490,6 +490,10 @@
 	};
 };
 
+&rga {
+	status = "okay";
+};
+
 &tsadc {
 	rockchip,hw-tshut-mode = <0>;
 	rockchip,hw-tshut-polarity = <0>;
diff --git a/arch/arm/boot/dts/rk3288-tinker.dts b/arch/arm/boot/dts/rk3288-tinker.dts
index 525b0e5..1a8c149 100644
--- a/arch/arm/boot/dts/rk3288-tinker.dts
+++ b/arch/arm/boot/dts/rk3288-tinker.dts
@@ -460,6 +460,10 @@
 	status = "okay";
 };
 
+&rga {
+	status = "okay";
+};
+
 &saradc {
 	vref-supply = <&vcc18_ldo1>;
 	status ="okay";
-- 
2.7.4
