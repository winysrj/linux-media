Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:60707 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaLRIwh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 03:52:37 -0500
From: Josh Wu <josh.wu@atmel.com>
To: <nicolas.ferre@atmel.com>
CC: <voice.shen@atmel.com>, <plagnioj@jcrosoft.com>,
	<boris.brezillon@free-electrons.com>,
	<alexandre.belloni@free-electrons.com>,
	<devicetree@vger.kernel.org>, <robh+dt@kernel.org>,
	<linux-media@vger.kernel.org>, <g.liakhovetski@gmx.de>,
	<laurent.pinchart@ideasonboard.com>, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH 1/7] ARM: at91: dts: sama5d3: add isi clock
Date: Thu, 18 Dec 2014 16:51:01 +0800
Message-ID: <1418892667-27428-2-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1418892667-27428-1-git-send-email-josh.wu@atmel.com>
References: <1418892667-27428-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add ISI peripheral clock in sama5d3.dtsi.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
 arch/arm/boot/dts/sama5d3.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index 5f4144d..61746ef 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -214,6 +214,8 @@
 				compatible = "atmel,at91sam9g45-isi";
 				reg = <0xf0034000 0x4000>;
 				interrupts = <37 IRQ_TYPE_LEVEL_HIGH 5>;
+				clocks = <&isi_clk>;
+				clock-names = "isi_clk";
 				status = "disabled";
 			};
 
-- 
1.9.1

