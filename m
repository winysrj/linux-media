Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:58436 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaH1PQo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Aug 2014 11:16:44 -0400
Received: by mail-pa0-f51.google.com with SMTP id rd3so2971804pab.38
        for <linux-media@vger.kernel.org>; Thu, 28 Aug 2014 08:16:41 -0700 (PDT)
From: Zhangfei Gao <zhangfei.gao@linaro.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, sean@mess.org,
	arnd@arndb.de, haifeng.yan@linaro.org, jchxue@gmail.com
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org, Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v3 3/3] ARM: dts: hix5hd2: add ir node
Date: Thu, 28 Aug 2014 23:16:17 +0800
Message-Id: <1409238977-19444-4-git-send-email-zhangfei.gao@linaro.org>
In-Reply-To: <1409238977-19444-1-git-send-email-zhangfei.gao@linaro.org>
References: <1409238977-19444-1-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
---
 arch/arm/boot/dts/hisi-x5hd2.dtsi |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/hisi-x5hd2.dtsi b/arch/arm/boot/dts/hisi-x5hd2.dtsi
index 7b1cb53..1d7cd04 100644
--- a/arch/arm/boot/dts/hisi-x5hd2.dtsi
+++ b/arch/arm/boot/dts/hisi-x5hd2.dtsi
@@ -391,7 +391,7 @@
 		};
 
 		sysctrl: system-controller@00000000 {
-			compatible = "hisilicon,sysctrl";
+			compatible = "hisilicon,sysctrl", "syscon";
 			reg = <0x00000000 0x1000>;
 			reboot-offset = <0x4>;
 		};
@@ -476,5 +476,13 @@
                         interrupts = <0 70 4>;
                         clocks = <&clock HIX5HD2_SATA_CLK>;
 		};
+
+		ir: ir@001000 {
+			compatible = "hisilicon,hix5hd2-ir";
+			reg = <0x001000 0x1000>;
+			interrupts = <0 47 4>;
+			clocks = <&clock HIX5HD2_FIXED_24M>;
+			hisilicon,power-syscon = <&sysctrl>;
+		};
 	};
 };
-- 
1.7.9.5

