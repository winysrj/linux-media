Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35738 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730016AbeKUVuh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Nov 2018 16:50:37 -0500
Received: by mail-wm1-f66.google.com with SMTP id c126so5336327wmh.0
        for <linux-media@vger.kernel.org>; Wed, 21 Nov 2018 03:16:37 -0800 (PST)
From: Rui Miguel Silva <rui.silva@linaro.org>
To: sakari.ailus@linux.intel.com,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v8 06/12] ARM: dts: imx7s: add mipi phy power domain
Date: Wed, 21 Nov 2018 11:15:52 +0000
Message-Id: <20181121111558.10838-7-rui.silva@linaro.org>
In-Reply-To: <20181121111558.10838-1-rui.silva@linaro.org>
References: <20181121111558.10838-1-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add power domain index 0 related with mipi-phy to imx7s.

While at it rename pcie power-domain node to remove pgc prefix.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 arch/arm/boot/dts/imx7s.dtsi | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index aa8df7d93b2e..6e2e4f99cdb0 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -608,7 +608,13 @@
 					#address-cells = <1>;
 					#size-cells = <0>;
 
-					pgc_pcie_phy: pgc-power-domain@1 {
+					pgc_mipi_phy: power-domain@0 {
+						#power-domain-cells = <0>;
+						reg = <0>;
+						power-supply = <&reg_1p0d>;
+					};
+
+					pgc_pcie_phy: power-domain@1 {
 						#power-domain-cells = <0>;
 						reg = <1>;
 						power-supply = <&reg_1p0d>;
-- 
2.19.1
