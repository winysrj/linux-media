Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:9881 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965804AbbDWNDl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2015 09:03:41 -0400
From: Kamil Debski <k.debski@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, k.debski@samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
Subject: [PATCH v4 03/10] dts: exynos4412-odroid*: enable the HDMI CEC device
Date: Thu, 23 Apr 2015 15:03:06 +0200
Message-id: <1429794192-20541-4-git-send-email-k.debski@samsung.com>
In-reply-to: <1429794192-20541-1-git-send-email-k.debski@samsung.com>
References: <1429794192-20541-1-git-send-email-k.debski@samsung.com>
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

