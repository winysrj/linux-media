Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:37423 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbaFHSJn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Jun 2014 14:09:43 -0400
Received: by mail-la0-f52.google.com with SMTP id s18so2577306lam.39
        for <linux-media@vger.kernel.org>; Sun, 08 Jun 2014 11:09:42 -0700 (PDT)
From: Alexander Bersenev <bay@hackerdom.ru>
To: linux-sunxi@googlegroups.com, david@hardeman.nu,
	devicetree@vger.kernel.org, galak@codeaurora.org,
	grant.likely@linaro.org, ijc+devicetree@hellion.org.uk,
	james.hogan@imgtec.com, linux-arm-kernel@lists.infradead.org,
	linux@arm.linux.org.uk, m.chehab@samsung.com, mark.rutland@arm.com,
	maxime.ripard@free-electrons.com, pawel.moll@arm.com,
	rdunlap@infradead.org, robh+dt@kernel.org, sean@mess.org,
	srinivas.kandagatla@st.com, wingrime@linux-sunxi.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: Alexander Bersenev <bay@hackerdom.ru>
Subject: [PATCH v9 3/5] ARM: sunxi: Add pins for IR controller on A20 to dtsi
Date: Mon,  9 Jun 2014 00:08:11 +0600
Message-Id: <1402250893-5412-4-git-send-email-bay@hackerdom.ru>
In-Reply-To: <1402250893-5412-1-git-send-email-bay@hackerdom.ru>
References: <1402250893-5412-1-git-send-email-bay@hackerdom.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds pins for two IR controllers on A20

Signed-off-by: Alexander Bersenev <bay@hackerdom.ru>
Signed-off-by: Alexsey Shestacov <wingrime@linux-sunxi.org>
---
 arch/arm/boot/dts/sun7i-a20.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 0ae2b77..c057c3e 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -724,6 +724,20 @@
 				allwinner,drive = <2>;
 				allwinner,pull = <0>;
 			};
+
+			ir0_pins_a: ir0@0 {
+				    allwinner,pins = "PB3","PB4";
+				    allwinner,function = "ir0";
+				    allwinner,drive = <0>;
+				    allwinner,pull = <0>;
+			};
+
+			ir1_pins_a: ir1@0 {
+				    allwinner,pins = "PB22","PB23";
+				    allwinner,function = "ir1";
+				    allwinner,drive = <0>;
+				    allwinner,pull = <0>;
+			};
 		};
 
 		timer@01c20c00 {
-- 
1.9.3

