Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34317 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940173AbdAGCMG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2017 21:12:06 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v3 05/24] ARM: dts: imx6qdl-sabrelite: remove erratum ERR006687 workaround
Date: Fri,  6 Jan 2017 18:11:23 -0800
Message-Id: <1483755102-24785-6-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a pin conflict with GPIO_6. This pin functions as a power
input pin to the OV5642 camera sensor, but ENET uses it as the h/w
workaround for erratum ERR006687, to wake-up the ARM cores on normal
RX and TX packet done events. So we need to remove the h/w workaround
to support the OV5642. The result is that the CPUidle driver will no
longer allow entering the deep idle states on the sabrelite.

This is a partial revert of

commit 6261c4c8f13e ("ARM: dts: imx6qdl-sabrelite: use GPIO_6 for FEC
			interrupt.")
commit a28eeb43ee57 ("ARM: dts: imx6: tag boards that have the HW workaround
			for ERR006687")

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 arch/arm/boot/dts/imx6qdl-sabrelite.dtsi | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi b/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
index 1f9076e..795b5a5 100644
--- a/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
@@ -271,9 +271,6 @@
 	txd1-skew-ps = <0>;
 	txd2-skew-ps = <0>;
 	txd3-skew-ps = <0>;
-	interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_HIGH>,
-			      <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
-	fsl,err006687-workaround-present;
 	status = "okay";
 };
 
@@ -374,7 +371,6 @@
 				MX6QDL_PAD_RGMII_RX_CTL__RGMII_RX_CTL	0x1b030
 				/* Phy reset */
 				MX6QDL_PAD_EIM_D23__GPIO3_IO23		0x000b0
-				MX6QDL_PAD_GPIO_6__ENET_IRQ		0x000b1
 			>;
 		};
 
-- 
2.7.4

