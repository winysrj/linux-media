Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44813 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752516AbbCPACH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 20:02:07 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-omap@vger.kernel.org
Cc: tony@atomide.com, sre@kernel.org, pali.rohar@gmail.com,
	laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Subject: [PATCH 1/4] arm: dts: omap3: Extend the syscon register range
Date: Mon, 16 Mar 2015 02:01:17 +0200
Message-Id: <1426464080-29119-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1426464080-29119-1-git-send-email-sakari.ailus@iki.fi>
References: <1426464080-29119-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The OMAP 3630 syscon register set was missing
OMAP3630_CONTROL_CAMERA_PHY_CTRL register at offset 0x2f0. This register
used to be mapped directly by the omap3isp driver, which is now moving to
use syscon instead. The omap3isp driver did not support DT so no driver
change is needed in this patch.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 arch/arm/boot/dts/omap3.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
index 01b7111..fe0b293 100644
--- a/arch/arm/boot/dts/omap3.dtsi
+++ b/arch/arm/boot/dts/omap3.dtsi
@@ -183,7 +183,7 @@
 
 		omap3_scm_general: tisyscon@48002270 {
 			compatible = "syscon";
-			reg = <0x48002270 0x2f0>;
+			reg = <0x48002270 0x2f4>;
 		};
 
 		pbias_regulator: pbias_regulator {
-- 
1.7.10.4

