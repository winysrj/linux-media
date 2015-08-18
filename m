Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:65441 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbbHRIi6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2015 04:38:58 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	kamil@wypas.org, linux@arm.linux.org.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv8 03/15] dts: exynos4412-odroid*: enable the HDMI CEC device
Date: Tue, 18 Aug 2015 10:26:28 +0200
Message-Id: <2e99527a2418168338c3b1747e6624df50ff16b4.1439886203.git.hans.verkuil@cisco.com>
In-Reply-To: <cover.1439886203.git.hans.verkuil@cisco.com>
References: <cover.1439886203.git.hans.verkuil@cisco.com>
In-Reply-To: <cover.1439886203.git.hans.verkuil@cisco.com>
References: <cover.1439886203.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kamil Debski <kamil@wypas.org>

Add a dts node entry and enable the HDMI CEC device present in the Exynos4
family of SoCs.

Signed-off-by: Kamil Debski <kamil@wypas.org>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/boot/dts/exynos4210-universal_c210.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4210-universal_c210.dts b/arch/arm/boot/dts/exynos4210-universal_c210.dts
index d4f2b11..06df693 100644
--- a/arch/arm/boot/dts/exynos4210-universal_c210.dts
+++ b/arch/arm/boot/dts/exynos4210-universal_c210.dts
@@ -515,6 +515,10 @@
 		enable-active-high;
 	};
 
+	cec@100B0000 {
+		status = "okay";
+	};
+
 	hdmi_ddc: i2c-ddc {
 		compatible = "i2c-gpio";
 		gpios = <&gpe4 2 0 &gpe4 3 0>;
-- 
2.1.4

