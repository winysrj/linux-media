Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753344AbeBLSMZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 13:12:25 -0500
From: Kieran Bingham <kbingham@kernel.org>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        David Airlie <airlied@linux.ie>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Inki Dae <inki.dae@samsung.com>
Subject: [PATCH v2 5/5] drm: adv7511: Add support for i2c_new_secondary_device
Date: Mon, 12 Feb 2018 18:11:57 +0000
Message-Id: <1518459117-16733-6-git-send-email-kbingham@kernel.org>
In-Reply-To: <1518459117-16733-1-git-send-email-kbingham@kernel.org>
References: <1518459117-16733-1-git-send-email-kbingham@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

The ADV7511 has four 256-byte maps that can be accessed via the main I²C
ports. Each map has it own I²C address and acts as a standard slave
device on the I²C bus.

Allow a device tree node to override the default addresses so that
address conflicts with other devices on the same bus may be resolved at
the board description level.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

---
v2:
 - Update missing edid-i2c address setting
 - Split out DT bindings
 - Rename and move the I2C default addresses to their own section

 drivers/gpu/drm/bridge/adv7511/adv7511.h     |  6 ++++
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c | 42 ++++++++++++++++++----------
 2 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511.h b/drivers/gpu/drm/bridge/adv7511/adv7511.h
index d034b2cb5eee..04e6759ee45b 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511.h
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511.h
@@ -93,6 +93,11 @@
 #define ADV7511_REG_CHIP_ID_HIGH		0xf5
 #define ADV7511_REG_CHIP_ID_LOW			0xf6
 
+/* Hardware defined default addresses for i2c register maps */
+#define ADV7511_CEC_I2C_ADDR_DEFAULT		0x3c
+#define ADV7511_EDID_I2C_ADDR_DEFAULT		0x3f
+#define ADV7511_PACKET_I2C_ADDR_DEFAULT		0x38
+
 #define ADV7511_CSC_ENABLE			BIT(7)
 #define ADV7511_CSC_UPDATE_MODE			BIT(5)
 
@@ -322,6 +327,7 @@ struct adv7511 {
 	struct i2c_client *i2c_main;
 	struct i2c_client *i2c_edid;
 	struct i2c_client *i2c_cec;
+	struct i2c_client *i2c_packet;
 
 	struct regmap *regmap;
 	struct regmap *regmap_cec;
diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
index efa29db5fc2b..5e61b928c9c0 100644
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
 
@@ -1153,24 +1151,35 @@ static int adv7511_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
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
 	ret = adv7511_init_cec_regmap(adv7511);
 	if (ret)
 		goto err_i2c_unregister_edid;
 
+	regmap_write(adv7511->regmap, ADV7511_REG_CEC_I2C_ADDR,
+		     adv7511->i2c_cec->addr << 1);
+
+	adv7511->i2c_packet = i2c_new_secondary_device(i2c, "packet",
+					ADV7511_PACKET_I2C_ADDR_DEFAULT);
+	if (!adv7511->i2c_packet) {
+		ret = -EINVAL;
+		goto err_unregister_cec;
+	}
+
+	regmap_write(adv7511->regmap, ADV7511_REG_PACKET_I2C_ADDR,
+		     adv7511->i2c_packet->addr << 1);
+
 	INIT_WORK(&adv7511->hpd_work, adv7511_hpd_work);
 
 	if (i2c->irq) {
@@ -1181,7 +1190,7 @@ static int adv7511_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 						IRQF_ONESHOT, dev_name(dev),
 						adv7511);
 		if (ret)
-			goto err_unregister_cec;
+			goto err_unregister_packet;
 	}
 
 	adv7511_power_off(adv7511);
@@ -1203,6 +1212,8 @@ static int adv7511_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 	adv7511_audio_init(dev, adv7511);
 	return 0;
 
+err_unregister_packet:
+	i2c_unregister_device(adv7511->i2c_packet);
 err_unregister_cec:
 	i2c_unregister_device(adv7511->i2c_cec);
 	if (adv7511->cec_clk)
@@ -1234,6 +1245,7 @@ static int adv7511_remove(struct i2c_client *i2c)
 	cec_unregister_adapter(adv7511->cec_adap);
 
 	i2c_unregister_device(adv7511->i2c_edid);
+	i2c_unregister_device(adv7511->i2c_packet);
 
 	return 0;
 }
-- 
2.7.4
