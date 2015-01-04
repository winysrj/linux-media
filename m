Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:16739 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbbADJDG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Jan 2015 04:03:06 -0500
From: Josh Wu <josh.wu@atmel.com>
To: <devicetree@vger.kernel.org>, <nicolas.ferre@atmel.com>
CC: <grant.likely@linaro.org>, <galak@codeaurora.org>,
	<rob@landley.net>, <robh+dt@kernel.org>,
	<ijc+devicetree@hellion.org.uk>, <pawel.moll@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <voice.shen@atmel.com>,
	<laurent.pinchart@ideasonboard.com>,
	<alexandre.belloni@free-electrons.com>, <plagnioj@jcrosoft.com>,
	<boris.brezillon@free-electrons.com>,
	<linux-media@vger.kernel.org>, <g.liakhovetski@gmx.de>,
	Josh Wu <josh.wu@atmel.com>
Subject: [PATCH v2 1/8] ARM: at91: dts: sama5d3: add isi clock
Date: Sun, 4 Jan 2015 17:02:26 +0800
Message-ID: <1420362153-500-2-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1420362153-500-1-git-send-email-josh.wu@atmel.com>
References: <1420362153-500-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add ISI peripheral clock in sama5d3.dtsi.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
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

