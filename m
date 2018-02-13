Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965426AbeBMRtN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 12:49:13 -0500
From: Kieran Bingham <kbingham@kernel.org>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v4 5/5] drm: adv7511: Add support for i2c_new_secondary_device
Date: Tue, 13 Feb 2018 17:48:57 +0000
Message-Id: <1518544137-2742-6-git-send-email-kbingham@kernel.org>
In-Reply-To: <1518544137-2742-1-git-send-email-kbingham@kernel.org>
References: <1518544137-2742-1-git-send-email-kbingham@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

The ADV7511 has four 256-byte maps that can be accessed via the main I2C
ports. Each map has it own I2C address and acts as a standard slave
device on the I2C bus.

Allow a device tree node to override the default addresses so that
address conflicts with other devices on the same bus may be resolved at
the board description level.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
v2:
 - Update missing edid-i2c address setting
 - Split out DT bindings
 - Rename and move the I2C default addresses to their own section

v3:
 - No change

v4:
 - Change registration order of packet/cec to fix error path and
   simplify code change.
 - Collect Laurent's RB tag

 drivers/gpu/drm/bridge/adv7511/adv7511.h     |  6 ++++
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c | 42 ++++++++++++++++++----------
 2 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511.h b/drivers/gpu/drm/bridge/adv7511/adv7511.h
index d034b2cb5eee..73d8ccb97742 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511.h
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511.h
@@ -93,6 +93,11 @@
 #define ADV7511_REG_CHIP_ID_HIGH		0xf5
 #define ADV7511_REG_CHIP_ID_LOW			0xf6
 
+/* Hardware defined default addresses for I2C register maps */
+#define ADV7511_CEC_I2C_ADDR_DEFAULT		0x3c
+#define ADV7511_EDID_I2C_ADDR_DEFAULT		0x3f
+#define ADV7511_PACKET_I2C_ADDR_DEFAULT		0x38
+
 #define ADV7511_CSC_ENABLE			BIT(7)
 #define ADV7511_CSC_UPDATE_MODE			BIT(5)
 
@@ -321,6 +326,7 @@ enum adv7511_type {
 struct adv7511 {
 	struct i2c_client *i2c_main;
 	struct i2c_client *i2c_edid;
+	struct i2c_client *i2c_packet;
 	struct i2c_client *i2c_cec;
 
 	struct regmap *regmap;
diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
index efa29db5fc2b..802bc433f54a 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
@@ -586,7 +586,7 @@ static int adv7511_get_modes(struct adv7511 *adv7511,
 	/* Reading the EDID only works if the device is powered */
 	if (!adv7511->powered) {
 		unsigned int edid_i2c_addr =
-					(adv7511->i2c_main->addr << 1) + 4;
+					(adv7511->i2c_edid->addr << 1);
 
 		__adv7511_power_on(adv7511);
 
@@ -969,10 +969,10 @@ static int adv7511_init_cec_regmap(struct adv7511 *adv)
 {
 	int ret;
 
-	adv->i2c_cec = i2c_new_dummy(adv->i2c_main->adapter,
-				     adv->i2c_main->addr - 1);
+	adv->i2c_cec = i2c_new_secondary_device(adv->i2c_main, "cec",
+					ADV7511_CEC_I2C_ADDR_DEFAULT);
 	if (!adv->i2c_cec)
-		return -ENOMEM;
+		return -EINVAL;
 	i2c_set_clientdata(adv->i2c_cec, adv);
 
 	adv->regmap_cec = devm_regmap_init_i2c(adv->i2c_cec,
@@ -1082,8 +1082,6 @@ static int adv7511_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 	struct adv7511_link_config link_config;
 	struct adv7511 *adv7511;
 	struct device *dev = &i2c->dev;
-	unsigned int main_i2c_addr = i2c->addr << 1;
-	unsigned int edid_i2c_addr = main_i2c_addr + 4;
 	unsigned int val;
 	int ret;
 
@@ -1153,23 +1151,34 @@ static int adv7511_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 	if (ret)
 		goto uninit_regulators;
 
-	regmap_write(adv7511->regmap, ADV7511_REG_EDID_I2C_ADDR, edid_i2c_addr);
-	regmap_write(adv7511->regmap, ADV7511_REG_PACKET_I2C_ADDR,
-		     main_i2c_addr - 0xa);
-	regmap_write(adv7511->regmap, ADV7511_REG_CEC_I2C_ADDR,
-		     main_i2c_addr - 2);
-
 	adv7511_packet_disable(adv7511, 0xffff);
 
-	adv7511->i2c_edid = i2c_new_dummy(i2c->adapter, edid_i2c_addr >> 1);
+	adv7511->i2c_edid = i2c_new_secondary_device(i2c, "edid",
+					ADV7511_EDID_I2C_ADDR_DEFAULT);
 	if (!adv7511->i2c_edid) {
-		ret = -ENOMEM;
+		ret = -EINVAL;
 		goto uninit_regulators;
 	}
 
+	regmap_write(adv7511->regmap, ADV7511_REG_EDID_I2C_ADDR,
+		     adv7511->i2c_edid->addr << 1);
+
+	adv7511->i2c_packet = i2c_new_secondary_device(i2c, "packet",
+					ADV7511_PACKET_I2C_ADDR_DEFAULT);
+	if (!adv7511->i2c_packet) {
+		ret = -EINVAL;
+		goto err_i2c_unregister_edid;
+	}
+
+	regmap_write(adv7511->regmap, ADV7511_REG_PACKET_I2C_ADDR,
+		     adv7511->i2c_packet->addr << 1);
+
 	ret = adv7511_init_cec_regmap(adv7511);
 	if (ret)
-		goto err_i2c_unregister_edid;
+		goto err_i2c_unregister_packet;
+
+	regmap_write(adv7511->regmap, ADV7511_REG_CEC_I2C_ADDR,
+		     adv7511->i2c_cec->addr << 1);
 
 	INIT_WORK(&adv7511->hpd_work, adv7511_hpd_work);
 
@@ -1207,6 +1216,8 @@ static int adv7511_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 	i2c_unregister_device(adv7511->i2c_cec);
 	if (adv7511->cec_clk)
 		clk_disable_unprepare(adv7511->cec_clk);
+err_i2c_unregister_packet:
+	i2c_unregister_device(adv7511->i2c_packet);
 err_i2c_unregister_edid:
 	i2c_unregister_device(adv7511->i2c_edid);
 uninit_regulators:
@@ -1233,6 +1244,7 @@ static int adv7511_remove(struct i2c_client *i2c)
 
 	cec_unregister_adapter(adv7511->cec_adap);
 
+	i2c_unregister_device(adv7511->i2c_packet);
 	i2c_unregister_device(adv7511->i2c_edid);
 
 	return 0;
-- 
2.7.4
