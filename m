Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:59866 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754485AbeDTJtz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 05:49:55 -0400
From: Daniel Mack <daniel@zonque.org>
To: linux-media@vger.kernel.org
Cc: slongerbeam@gmail.com, mchehab@kernel.org,
        Daniel Mack <daniel@zonque.org>
Subject: [PATCH 3/3] media: ov5640: add support for xclk frequency control
Date: Fri, 20 Apr 2018 11:44:19 +0200
Message-Id: <20180420094419.11267-3-daniel@zonque.org>
In-Reply-To: <20180420094419.11267-1-daniel@zonque.org>
References: <20180420094419.11267-1-daniel@zonque.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow setting the xclk rate via an optional 'clock-frequency' property in
the device tree node.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 Documentation/devicetree/bindings/media/i2c/ov5640.txt |  2 ++
 drivers/media/i2c/ov5640.c                             | 10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/i2c/ov5640.txt b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
index 8e36da0d8406..584bbc944978 100644
--- a/Documentation/devicetree/bindings/media/i2c/ov5640.txt
+++ b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
@@ -13,6 +13,8 @@ Optional Properties:
 	       This is an active low signal to the OV5640.
 - powerdown-gpios: reference to the GPIO connected to the powerdown pin,
 		   if any. This is an active high signal to the OV5640.
+- clock-frequency: frequency to set on the xclk input clock. The clock
+		   is left untouched if this property is missing.
 
 The device node must contain one 'port' child node for its digital output
 video port, in accordance with the video interface bindings defined in
diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 78669ed386cd..2d94d6dbda5d 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2685,6 +2685,7 @@ static int ov5640_probe(struct i2c_client *client,
 	struct fwnode_handle *endpoint;
 	struct ov5640_dev *sensor;
 	struct v4l2_mbus_framefmt *fmt;
+	u32 freq;
 	int ret;
 
 	sensor = devm_kzalloc(dev, sizeof(*sensor), GFP_KERNEL);
@@ -2731,6 +2732,15 @@ static int ov5640_probe(struct i2c_client *client,
 		return PTR_ERR(sensor->xclk);
 	}
 
+	ret = of_property_read_u32(dev->of_node, "clock-frequency", &freq);
+	if (ret == 0) {
+		ret = clk_set_rate(sensor->xclk, freq);
+		if (ret) {
+			dev_err(dev, "could not set xclk frequency\n");
+			return ret;
+		}
+	}
+
 	sensor->xclk_freq = clk_get_rate(sensor->xclk);
 	if (sensor->xclk_freq < OV5640_XCLK_MIN ||
 	    sensor->xclk_freq > OV5640_XCLK_MAX) {
-- 
2.14.3
