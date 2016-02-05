Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:48483 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753733AbcBEP2S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2016 10:28:18 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
	linux-input@vger.kernel.org, lars@opdenkamp.eu,
	linux@arm.linux.org.uk, Kamil Debski <kamil@wypas.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv11 03/17] dts: exynos4412-odroid*: enable the HDMI CEC device
Date: Fri,  5 Feb 2016 16:27:46 +0100
Message-Id: <1454686080-39018-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1454686080-39018-1-git-send-email-hverkuil@xs4all.nl>
References: <1454686080-39018-1-git-send-email-hverkuil@xs4all.nl>
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
index 4f5d379..331ab9f 100644
--- a/arch/arm/boot/dts/exynos4210-universal_c210.dts
+++ b/arch/arm/boot/dts/exynos4210-universal_c210.dts
@@ -223,6 +223,10 @@
 		enable-active-high;
 	};
 
+	cec@100B0000 {
+		status = "okay";
+	};
+
 	hdmi_ddc: i2c-ddc {
 		compatible = "i2c-gpio";
 		gpios = <&gpe4 2 GPIO_ACTIVE_HIGH &gpe4 3 GPIO_ACTIVE_HIGH>;
-- 
2.7.0

