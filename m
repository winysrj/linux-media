Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36222 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759088AbdACU5v (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2017 15:57:51 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
To: shawnguo@kernel.org, kernel@pengutronix.de, fabio.estevam@nxp.com,
        robh+dt@kernel.org, mark.rutland@arm.com, linux@armlinux.org.uk,
        mchehab@kernel.org, gregkh@linuxfoundation.org,
        p.zabel@pengutronix.de
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 08/19] ARM: dts: imx6-sabreauto: add pinctrl for gpt input capture
Date: Tue,  3 Jan 2017 12:57:18 -0800
Message-Id: <1483477049-19056-9-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
References: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add pinctrl groups for both GPT input capture channels.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
index 516bac6..83ac2ff 100644
--- a/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabreauto.dtsi
@@ -457,6 +457,18 @@
 			>;
 		};
 
+		pinctrl_gpt_input_capture0: gptinputcapture0grp {
+			fsl,pins = <
+				MX6QDL_PAD_SD1_DAT0__GPT_CAPTURE1	0x80000000
+			>;
+		};
+
+		pinctrl_gpt_input_capture1: gptinputcapture1grp {
+			fsl,pins = <
+				MX6QDL_PAD_SD1_DAT1__GPT_CAPTURE2	0x80000000
+			>;
+		};
+
 		pinctrl_spdif: spdifgrp {
 			fsl,pins = <
 				MX6QDL_PAD_KEY_COL3__SPDIF_IN 0x1b0b0
-- 
2.7.4

