Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:4094 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752777AbcKOHuI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 02:50:08 -0500
From: Jiancheng Xue <xuejiancheng@hisilicon.com>
To: <robh+dt@kernel.org>, <mark.rutland@arm.com>, <mchehab@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <yanhaifeng@hisilicon.com>,
        <xuejiancheng@hisilicon.com>, <hermit.wangheming@hisilicon.com>,
        <elder@linaro.org>, <bin.chen@linaro.org>,
        Ruqiang Ju <juruqiang@huawei.com>
Subject: [PATCH] [media] ir-hix5hd2: make hisilicon,power-syscon property deprecated
Date: Tue, 15 Nov 2016 15:31:32 +0800
Message-ID: <1479195092-20090-1-git-send-email-xuejiancheng@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ruqiang Ju <juruqiang@huawei.com>

The clock of IR can be provided by the clock provider and controlled
by common clock framework APIs.

Signed-off-by: Ruqiang Ju <juruqiang@huawei.com>
Signed-off-by: Jiancheng Xue <xuejiancheng@hisilicon.com>
---
 .../devicetree/bindings/media/hix5hd2-ir.txt       |  6 +++---
 drivers/media/rc/ir-hix5hd2.c                      | 25 ++++++++++++++--------
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/hix5hd2-ir.txt b/Documentation/devicetree/bindings/media/hix5hd2-ir.txt
index fb5e760..54e1bed 100644
--- a/Documentation/devicetree/bindings/media/hix5hd2-ir.txt
+++ b/Documentation/devicetree/bindings/media/hix5hd2-ir.txt
@@ -8,10 +8,11 @@ Required properties:
 	  the device. The interrupt specifier format depends on the interrupt
 	  controller parent.
 	- clocks: clock phandle and specifier pair.
-	- hisilicon,power-syscon: phandle of syscon used to control power.

 Optional properties:
 	- linux,rc-map-name : Remote control map name.
+	- hisilicon,power-syscon: DEPRECATED. Don't use this in new dts files.
+		Provide correct clocks instead.

 Example node:

@@ -19,7 +20,6 @@ Example node:
 		compatible = "hisilicon,hix5hd2-ir";
 		reg = <0xf8001000 0x1000>;
 		interrupts = <0 47 4>;
-		clocks = <&clock HIX5HD2_FIXED_24M>;
-		hisilicon,power-syscon = <&sysctrl>;
+		clocks = <&clock HIX5HD2_IR_CLOCK>;
 		linux,rc-map-name = "rc-tivo";
 	};
diff --git a/drivers/media/rc/ir-hix5hd2.c b/drivers/media/rc/ir-hix5hd2.c
index d0549fb..d26907e 100644
--- a/drivers/media/rc/ir-hix5hd2.c
+++ b/drivers/media/rc/ir-hix5hd2.c
@@ -75,15 +75,22 @@ static void hix5hd2_ir_enable(struct hix5hd2_ir_priv *dev, bool on)
 {
 	u32 val;

-	regmap_read(dev->regmap, IR_CLK, &val);
-	if (on) {
-		val &= ~IR_CLK_RESET;
-		val |= IR_CLK_ENABLE;
+	if (dev->regmap) {
+		regmap_read(dev->regmap, IR_CLK, &val);
+		if (on) {
+			val &= ~IR_CLK_RESET;
+			val |= IR_CLK_ENABLE;
+		} else {
+			val &= ~IR_CLK_ENABLE;
+			val |= IR_CLK_RESET;
+		}
+		regmap_write(dev->regmap, IR_CLK, val);
 	} else {
-		val &= ~IR_CLK_ENABLE;
-		val |= IR_CLK_RESET;
+		if (on)
+			clk_prepare_enable(dev->clock);
+		else
+			clk_disable_unprepare(dev->clock);
 	}
-	regmap_write(dev->regmap, IR_CLK, val);
 }

 static int hix5hd2_ir_config(struct hix5hd2_ir_priv *priv)
@@ -207,8 +214,8 @@ static int hix5hd2_ir_probe(struct platform_device *pdev)
 	priv->regmap = syscon_regmap_lookup_by_phandle(node,
 						       "hisilicon,power-syscon");
 	if (IS_ERR(priv->regmap)) {
-		dev_err(dev, "no power-reg\n");
-		return -EINVAL;
+		dev_info(dev, "no power-reg\n");
+		priv->regmap = NULL;
 	}

 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
--
1.9.1

