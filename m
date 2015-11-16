Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54910 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbbKPEqm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2015 23:46:42 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 3/4] ARM: Renesas: r8a7790: Enable CLU support in VSPS
Date: Mon, 16 Nov 2015 06:46:44 +0200
Message-Id: <1447649205-1560-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1447649205-1560-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1447649205-1560-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VSPS includes a CLU module, describe it in DT.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 arch/arm/boot/dts/r8a7790.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/r8a7790.dtsi b/arch/arm/boot/dts/r8a7790.dtsi
index a0b2a79cbfbd..4e75b8df09e3 100644
--- a/arch/arm/boot/dts/r8a7790.dtsi
+++ b/arch/arm/boot/dts/r8a7790.dtsi
@@ -832,6 +832,7 @@
 		clocks = <&mstp1_clks R8A7790_CLK_VSP1_S>;
 		power-domains = <&cpg_clocks>;
 
+		renesas,has-clu;
 		renesas,has-lut;
 		renesas,has-sru;
 		renesas,#rpf = <5>;
-- 
2.4.10

