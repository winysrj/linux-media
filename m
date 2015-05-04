Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:58524 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbbEDRdp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 13:33:45 -0400
From: Kamil Debski <k.debski@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, k.debski@samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu
Subject: [PATCH v6 03/11] dts: exynos4412-odroid*: enable the HDMI CEC device
Date: Mon, 04 May 2015 19:32:56 +0200
Message-id: <1430760785-1169-4-git-send-email-k.debski@samsung.com>
In-reply-to: <1430760785-1169-1-git-send-email-k.debski@samsung.com>
References: <1430760785-1169-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a dts node entry and enable the HDMI CEC device present in the Exynos4
family of SoCs.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 arch/arm/boot/dts/exynos4412-odroid-common.dtsi |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-odroid-common.dtsi b/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
index 8de12af..e50862d 100644
--- a/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
+++ b/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
@@ -469,6 +469,10 @@
 		status = "okay";
 	};
 
+	cec@100B0000 {
+		status = "okay";
+	};
+
 	hdmi_ddc: i2c@13880000 {
 		status = "okay";
 		pinctrl-names = "default";
-- 
1.7.9.5

