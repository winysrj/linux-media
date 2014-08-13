Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:38047 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaHMJEw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Aug 2014 05:04:52 -0400
Received: by mail-pd0-f169.google.com with SMTP id y10so14233592pdj.0
        for <linux-media@vger.kernel.org>; Wed, 13 Aug 2014 02:04:52 -0700 (PDT)
From: Zhangfei Gao <zhangfei.gao@linaro.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	haifeng.yan@linaro.org, jchxue@gmail.com
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org, Guoxiong Yan <yanguoxiong@huawei.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH 1/2] [media] rc: Add DT bindings for hix5hd2
Date: Wed, 13 Aug 2014 17:03:25 +0800
Message-Id: <1407920606-18788-2-git-send-email-zhangfei.gao@linaro.org>
In-Reply-To: <1407920606-18788-1-git-send-email-zhangfei.gao@linaro.org>
References: <1407920606-18788-1-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Guoxiong Yan <yanguoxiong@huawei.com>

Signed-off-by: Guoxiong Yan <yanguoxiong@huawei.com>
Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
---
 .../devicetree/bindings/media/hix5hd2-ir.txt       |   21 ++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/hix5hd2-ir.txt

diff --git a/Documentation/devicetree/bindings/media/hix5hd2-ir.txt b/Documentation/devicetree/bindings/media/hix5hd2-ir.txt
new file mode 100644
index 000000000000..324048435b64
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/hix5hd2-ir.txt
@@ -0,0 +1,21 @@
+Device-Tree bindings for hix5hd2 ir IP
+
+Required properties:
+- compatible: Should contain "hisilicon,hix5hd2-ir".
+- reg: Base physical address of the controller and length of memory
+  mapped region.
+- interrupts: interrupt-specifier for the sole interrupt generated by
+  the device. The interrupt specifier format depends on the interrupt
+  controller parent.
+- clocks: clock phandle and specifier pair.
+- hisilicon,power-syscon: phandle of syscon used to control power.
+
+Example node:
+
+	ir: ir@f8001000 {
+		compatible = "hisilicon,hix5hd2-ir";
+		reg = <0xf8001000 0x1000>;
+		interrupts = <0 47 4>;
+		clocks = <&clock HIX5HD2_FIXED_24M>;
+		hisilicon,power-syscon = <&sctrl>;
+	};
-- 
1.7.9.5

