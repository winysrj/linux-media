Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:33825 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbaHSMxH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Aug 2014 08:53:07 -0400
Received: by mail-lb0-f176.google.com with SMTP id u10so5296221lbd.7
        for <linux-media@vger.kernel.org>; Tue, 19 Aug 2014 05:53:06 -0700 (PDT)
From: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
To: m.chehab@samsung.com, horms@verge.net.au, magnus.damm@gmail.com,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com
Cc: laurent.pinchart@ideasonboard.com, linux-sh@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
Subject: [PATCH 3/6] ARM: shmobile: r8a7790: Add JPU device node.
Date: Tue, 19 Aug 2014 16:50:50 +0400
Message-Id: <1408452653-14067-4-git-send-email-mikhail.ulyanov@cogentembedded.com>
In-Reply-To: <1408452653-14067-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
References: <1408452653-14067-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
---
 arch/arm/boot/dts/r8a7790.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7790.dtsi b/arch/arm/boot/dts/r8a7790.dtsi
index 61fd193..c8bc048 100644
--- a/arch/arm/boot/dts/r8a7790.dtsi
+++ b/arch/arm/boot/dts/r8a7790.dtsi
@@ -600,6 +600,13 @@
 		status = "disabled";
 	};
 
+	jpu: jpeg-codec@fe980000 {
+		compatible = "renesas,jpu-r8a7790";
+		reg = <0 0xfe980000 0 0x10300>;
+		interrupts = <0 272 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp1_clks R8A7790_CLK_JPU>;
+	};
+
 	clocks {
 		#address-cells = <2>;
 		#size-cells = <2>;
-- 
2.1.0.rc1

