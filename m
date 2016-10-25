Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:35934 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753680AbcJYXzl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Oct 2016 19:55:41 -0400
Received: by mail-pf0-f173.google.com with SMTP id e6so127444656pfk.3
        for <linux-media@vger.kernel.org>; Tue, 25 Oct 2016 16:55:41 -0700 (PDT)
From: Kevin Hilman <khilman@baylibre.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: Sekhar Nori <nsekhar@ti.com>, Axel Haslam <ahaslam@baylibre.com>,
        =?UTF-8?q?Bartosz=20Go=C5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 3/6] ARM: dts: davinci: da850: add VPIF
Date: Tue, 25 Oct 2016 16:55:33 -0700
Message-Id: <20161025235536.7342-4-khilman@baylibre.com>
In-Reply-To: <20161025235536.7342-1-khilman@baylibre.com>
References: <20161025235536.7342-1-khilman@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add VPIF and VPIF capture nodes to da850.

Note that these are separate nodes because the current media drivers
have two separate drivers for vpif and vpif_capture.

Signed-off-by: Kevin Hilman <khilman@baylibre.com>
---
 arch/arm/boot/dts/da850.dtsi | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
index f79e1b91c680..62c5b3e65071 100644
--- a/arch/arm/boot/dts/da850.dtsi
+++ b/arch/arm/boot/dts/da850.dtsi
@@ -399,7 +399,35 @@
 				<&edma0 0 1>;
 			dma-names = "tx", "rx";
 		};
+
+		vpif: video@0x00217000 {
+			compatible = "ti,vpif";
+			reg = <0x00217000 0x1000>;
+			status = "disabled";
+		};
+
+		vpif_capture: video-capture@0x00217000 {
+			compatible = "ti,vpif-capture";
+			reg = <0x00217000 0x1000>;
+			interrupts = <92>;
+			status = "disabled";
+
+			/* VPIF capture: input channels */
+			port {
+				vpif_ch0: endpoint@0 {
+					  reg = <0>;
+					  bus-width = <8>;
+				};
+
+				vpif_ch1: endpoint@1 {
+					  reg = <1>;
+					  bus-width = <8>;
+					  data-shift = <8>;
+				};
+			};
+		};
 	};
+
 	aemif: aemif@68000000 {
 		compatible = "ti,da850-aemif";
 		#address-cells = <2>;
-- 
2.9.3

