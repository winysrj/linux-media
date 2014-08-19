Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:40828 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbaHSMxJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Aug 2014 08:53:09 -0400
Received: by mail-lb0-f176.google.com with SMTP id u10so5296264lbd.7
        for <linux-media@vger.kernel.org>; Tue, 19 Aug 2014 05:53:08 -0700 (PDT)
From: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
To: m.chehab@samsung.com, horms@verge.net.au, magnus.damm@gmail.com,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com
Cc: laurent.pinchart@ideasonboard.com, linux-sh@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
Subject: [PATCH 5/6] ARM: shmobile: r8a7791: Add JPU device node.
Date: Tue, 19 Aug 2014 16:50:52 +0400
Message-Id: <1408452653-14067-6-git-send-email-mikhail.ulyanov@cogentembedded.com>
In-Reply-To: <1408452653-14067-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
References: <1408452653-14067-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
---
 arch/arm/boot/dts/r8a7791.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7791.dtsi b/arch/arm/boot/dts/r8a7791.dtsi
index c2d0c6e..464962a 100644
--- a/arch/arm/boot/dts/r8a7791.dtsi
+++ b/arch/arm/boot/dts/r8a7791.dtsi
@@ -637,6 +637,13 @@
 		status = "disabled";
 	};
 
+	jpu: jpeg-codec@fe980000 {
+		compatible = "renesas,jpu-r8a7791";
+		reg = <0 0xfe980000 0 0x10300>;
+		interrupts = <0 272 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp1_clks R8A7791_CLK_JPU>;
+	};
+
 	clocks {
 		#address-cells = <2>;
 		#size-cells = <2>;
-- 
2.1.0.rc1

