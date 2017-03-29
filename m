Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:55293 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755774AbdC2OPu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 10:15:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        devicetree@vger.kernel.org
Subject: [PATCHv5 05/11] ARM: dts: exynos: add HDMI controller phandle to exynos4.dtsi
Date: Wed, 29 Mar 2017 16:15:37 +0200
Message-Id: <20170329141543.32935-6-hverkuil@xs4all.nl>
In-Reply-To: <20170329141543.32935-1-hverkuil@xs4all.nl>
References: <20170329141543.32935-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add the new hdmi phandle to exynos4.dtsi. This phandle is needed by the
s5p-cec driver to initialize the CEC notifier framework.

Tested with my Odroid U3.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
CC: linux-samsung-soc@vger.kernel.org
CC: devicetree@vger.kernel.org
CC: Krzysztof Kozlowski <krzk@kernel.org>
---
 arch/arm/boot/dts/exynos4.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index 18def1c774d5..84fcdff140ae 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -771,6 +771,7 @@
 		clocks = <&clock CLK_HDMI_CEC>;
 		clock-names = "hdmicec";
 		samsung,syscon-phandle = <&pmu_system_controller>;
+		hdmi-phandle = <&hdmi>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&hdmi_cec>;
 		status = "disabled";
-- 
2.11.0
