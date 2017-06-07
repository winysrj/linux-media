Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:46449 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751524AbdFGOqX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Jun 2017 10:46:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>, devicetree@vger.kernel.org
Subject: [PATCH 9/9] ARM: dts: exynos: add needs-hpd to &hdmicec for Odroid-U3
Date: Wed,  7 Jun 2017 16:46:16 +0200
Message-Id: <20170607144616.15247-10-hverkuil@xs4all.nl>
In-Reply-To: <20170607144616.15247-1-hverkuil@xs4all.nl>
References: <20170607144616.15247-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The Odroid-U3 board has an IP4791CZ12 level shifter that is
disabled if the HPD is low, which means that the CEC pin is
disabled as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Andrzej Hajda <a.hajda@samsung.com>
Cc: devicetree@vger.kernel.org
---
 arch/arm/boot/dts/exynos4412-odroidu3.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-odroidu3.dts b/arch/arm/boot/dts/exynos4412-odroidu3.dts
index 7504a5aa538e..7209cb48fc2a 100644
--- a/arch/arm/boot/dts/exynos4412-odroidu3.dts
+++ b/arch/arm/boot/dts/exynos4412-odroidu3.dts
@@ -131,3 +131,7 @@
 	cs-gpios = <&gpb 5 GPIO_ACTIVE_HIGH>;
 	status = "okay";
 };
+
+&hdmicec {
+	needs-hpd;
+};
-- 
2.11.0
