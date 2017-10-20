Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:34772 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752278AbdJTKHh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 06:07:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-rockchip@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/4] arm: dts: rockchip: add the cec clk for dw-hdmi on rk3288
Date: Fri, 20 Oct 2017 12:07:31 +0200
Message-Id: <20171020100734.17064-2-hverkuil@xs4all.nl>
In-Reply-To: <20171020100734.17064-1-hverkuil@xs4all.nl>
References: <20171020100734.17064-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The dw-hdmi block needs the cec clk for the rk3288. Add it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 arch/arm/boot/dts/rk3288.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 356ed1e62452..a48352aa1591 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -1124,8 +1124,8 @@
 		reg-io-width = <4>;
 		rockchip,grf = <&grf>;
 		interrupts = <GIC_SPI 103 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&cru  PCLK_HDMI_CTRL>, <&cru SCLK_HDMI_HDCP>;
-		clock-names = "iahb", "isfr";
+		clocks = <&cru  PCLK_HDMI_CTRL>, <&cru SCLK_HDMI_HDCP>, <&cru SCLK_HDMI_CEC>;
+		clock-names = "iahb", "isfr", "cec";
 		power-domains = <&power RK3288_PD_VIO>;
 		status = "disabled";
 
-- 
2.14.1
