Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:51188 "EHLO mail.ispras.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751509AbeAZWK0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Jan 2018 17:10:26 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] ir-hix5hd2: fix error handling of clk_prepare_enable()
Date: Sat, 27 Jan 2018 01:10:17 +0300
Message-Id: <1517004617-6742-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Return code of clk_prepare_enable() is ignored in many places.
The patch adds error handling for all of them.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/rc/ir-hix5hd2.c | 35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/media/rc/ir-hix5hd2.c b/drivers/media/rc/ir-hix5hd2.c
index 0ce11c41dfae..700ab4c563d0 100644
--- a/drivers/media/rc/ir-hix5hd2.c
+++ b/drivers/media/rc/ir-hix5hd2.c
@@ -71,9 +71,10 @@ struct hix5hd2_ir_priv {
 	unsigned long		rate;
 };
 
-static void hix5hd2_ir_enable(struct hix5hd2_ir_priv *dev, bool on)
+static int hix5hd2_ir_enable(struct hix5hd2_ir_priv *dev, bool on)
 {
 	u32 val;
+	int ret = 0;
 
 	if (dev->regmap) {
 		regmap_read(dev->regmap, IR_CLK, &val);
@@ -87,10 +88,11 @@ static void hix5hd2_ir_enable(struct hix5hd2_ir_priv *dev, bool on)
 		regmap_write(dev->regmap, IR_CLK, val);
 	} else {
 		if (on)
-			clk_prepare_enable(dev->clock);
+			ret = clk_prepare_enable(dev->clock);
 		else
 			clk_disable_unprepare(dev->clock);
 	}
+	return ret;
 }
 
 static int hix5hd2_ir_config(struct hix5hd2_ir_priv *priv)
@@ -127,9 +129,18 @@ static int hix5hd2_ir_config(struct hix5hd2_ir_priv *priv)
 static int hix5hd2_ir_open(struct rc_dev *rdev)
 {
 	struct hix5hd2_ir_priv *priv = rdev->priv;
+	int ret;
+
+	ret = hix5hd2_ir_enable(priv, true);
+	if (ret)
+		return ret;
 
-	hix5hd2_ir_enable(priv, true);
-	return hix5hd2_ir_config(priv);
+	ret = hix5hd2_ir_config(priv);
+	if (ret) {
+		hix5hd2_ir_enable(priv, false);
+		return ret;
+	}
+	return 0;
 }
 
 static void hix5hd2_ir_close(struct rc_dev *rdev)
@@ -239,7 +250,9 @@ static int hix5hd2_ir_probe(struct platform_device *pdev)
 		ret = PTR_ERR(priv->clock);
 		goto err;
 	}
-	clk_prepare_enable(priv->clock);
+	ret = clk_prepare_enable(priv->clock);
+	if (ret)
+		goto err;
 	priv->rate = clk_get_rate(priv->clock);
 
 	rdev->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
@@ -309,9 +322,17 @@ static int hix5hd2_ir_suspend(struct device *dev)
 static int hix5hd2_ir_resume(struct device *dev)
 {
 	struct hix5hd2_ir_priv *priv = dev_get_drvdata(dev);
+	int ret;
 
-	hix5hd2_ir_enable(priv, true);
-	clk_prepare_enable(priv->clock);
+	ret = hix5hd2_ir_enable(priv, true);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(priv->clock);
+	if (ret) {
+		hix5hd2_ir_enable(priv, false);
+		return ret;
+	}
 
 	writel_relaxed(0x01, priv->base + IR_ENABLE);
 	writel_relaxed(0x00, priv->base + IR_INTM);
-- 
2.7.4
