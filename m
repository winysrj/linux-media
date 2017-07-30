Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:39603 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750991AbdG3NH4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Jul 2017 09:07:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        Archit Taneja <architt@codeaurora.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/4] arm: dts: renesas: add cec clock for Koelsch board
Date: Sun, 30 Jul 2017 15:07:42 +0200
Message-Id: <20170730130743.19681-4-hverkuil@xs4all.nl>
In-Reply-To: <20170730130743.19681-1-hverkuil@xs4all.nl>
References: <20170730130743.19681-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The adv7511 on the Koelsch board has a 12 MHz fixed clock
for the CEC block. Specify this in the dts to enable CEC support.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 arch/arm/boot/dts/r8a7791-koelsch.dts | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7791-koelsch.dts b/arch/arm/boot/dts/r8a7791-koelsch.dts
index 001e6116c47c..88c8957b075b 100644
--- a/arch/arm/boot/dts/r8a7791-koelsch.dts
+++ b/arch/arm/boot/dts/r8a7791-koelsch.dts
@@ -642,11 +642,19 @@
 		};
 	};
 
+	cec_clock: cec-clock {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <12000000>;
+	};
+
 	hdmi@39 {
 		compatible = "adi,adv7511w";
 		reg = <0x39>;
 		interrupt-parent = <&gpio3>;
 		interrupts = <29 IRQ_TYPE_LEVEL_LOW>;
+		clocks = <&cec_clock>;
+		clock-names = "cec";
 
 		adi,input-depth = <8>;
 		adi,input-colorspace = "rgb";
-- 
2.13.1
