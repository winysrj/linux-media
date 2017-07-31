Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:55935 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751054AbdGaL4s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Jul 2017 07:56:48 -0400
To: Maling list - DRI developers <dri-devel@lists.freedesktop.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        "moderated list:ARM/S5P EXYNOS AR..."
        <linux-samsung-soc@vger.kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for v4.13] ARM: dts: exynos: add needs-hpd for Odroid-XU3/4
Message-ID: <89e9a925-66a9-8c26-559c-1b1f0e8070e3@xs4all.nl>
Date: Mon, 31 Jul 2017 13:56:42 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CEC support was added for Exynos5 in 4.13, but for the Odroids we need to set
'needs-hpd' as well since CEC is disabled when there is no HDMI hotplug signal,
just as for the exynos4 Odroid-U3.

This is due to the level-shifter that is disabled when there is no HPD, thus
blocking the CEC signal as well. Same close-but-no-cigar board design as the
Odroid-U3.

Tested with my Odroid XU4.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi b/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
index f92f95741207..a183b56283f8 100644
--- a/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
+++ b/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
@@ -266,6 +266,7 @@

 &hdmicec {
 	status = "okay";
+	needs-hpd;
 };

 &hsi2c_4 {
