Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:57254 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751036AbdJBNir (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Oct 2017 09:38:47 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hansverk@cisco.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH] [media] ov5645: I2C address change
Date: Mon,  2 Oct 2017 16:28:45 +0300
Message-Id: <1506950925-13924-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As soon as the sensor is powered on, change the I2C address to the one
specified in DT. This allows to use multiple physical sensors connected
to the same I2C bus.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/i2c/ov5645.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
index d28845f..8541109 100644
--- a/drivers/media/i2c/ov5645.c
+++ b/drivers/media/i2c/ov5645.c
@@ -33,6 +33,7 @@
 #include <linux/i2c.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/of_graph.h>
 #include <linux/regulator/consumer.h>
@@ -42,6 +43,8 @@
 #include <media/v4l2-fwnode.h>
 #include <media/v4l2-subdev.h>
 
+static DEFINE_MUTEX(ov5645_lock);
+
 #define OV5645_VOLTAGE_ANALOG               2800000
 #define OV5645_VOLTAGE_DIGITAL_CORE         1500000
 #define OV5645_VOLTAGE_DIGITAL_IO           1800000
@@ -590,6 +593,31 @@ static void ov5645_regulators_disable(struct ov5645 *ov5645)
 		dev_err(ov5645->dev, "io regulator disable failed\n");
 }
 
+static int ov5645_write_reg_to(struct ov5645 *ov5645, u16 reg, u8 val,
+			       u16 i2c_addr)
+{
+	u8 regbuf[3] = {
+		reg >> 8,
+		reg & 0xff,
+		val
+	};
+	struct i2c_msg msgs = {
+		.addr = i2c_addr,
+		.flags = 0,
+		.len = 3,
+		.buf = regbuf
+	};
+	int ret;
+
+	ret = i2c_transfer(ov5645->i2c_client->adapter, &msgs, 1);
+	if (ret < 0)
+		dev_err(ov5645->dev,
+			"%s: write reg error %d on addr 0x%x: reg=0x%x, val=0x%x\n",
+			__func__, ret, i2c_addr, reg, val);
+
+	return ret;
+}
+
 static int ov5645_write_reg(struct ov5645 *ov5645, u16 reg, u8 val)
 {
 	u8 regbuf[3];
@@ -729,10 +757,24 @@ static int ov5645_s_power(struct v4l2_subdev *sd, int on)
 	 */
 	if (ov5645->power_count == !on) {
 		if (on) {
+			mutex_lock(&ov5645_lock);
+
 			ret = ov5645_set_power_on(ov5645);
 			if (ret < 0)
 				goto exit;
 
+			ret = ov5645_write_reg_to(ov5645, 0x3100,
+						ov5645->i2c_client->addr, 0x78);
+			if (ret < 0) {
+				dev_err(ov5645->dev,
+					"could not change i2c address\n");
+				ov5645_set_power_off(ov5645);
+				mutex_unlock(&ov5645_lock);
+				goto exit;
+			}
+
+			mutex_unlock(&ov5645_lock);
+
 			ret = ov5645_set_register_array(ov5645,
 					ov5645_global_init_setting,
 					ARRAY_SIZE(ov5645_global_init_setting));
-- 
2.7.4
