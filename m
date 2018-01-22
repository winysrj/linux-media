Return-path: <linux-media-owner@vger.kernel.org>
Received: from o1.7nn.fshared.sendgrid.net ([167.89.55.65]:39964 "EHLO
        o1.7nn.fshared.sendgrid.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751086AbeAVMuA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 07:50:00 -0500
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        David Airlie <airlied@linux.ie>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        John Stultz <john.stultz@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Inki Dae <inki.dae@samsung.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS)
Subject: [PATCH 2/2] drm: adv7511: Add support for i2c_new_secondary_device
Date: Mon, 22 Jan 2018 12:49:59 +0000 (UTC)
Message-Id: <1516625389-6362-3-git-send-email-kieran.bingham@ideasonboard.com>
In-Reply-To: <1516625389-6362-1-git-send-email-kieran.bingham@ideasonboard.com>
References: <1516625389-6362-1-git-send-email-kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
content-transfer-encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ADV7511 has four 256-byte maps that can be accessed via the main I=C2=
=B2C=0D
ports. Each map has it own I=C2=B2C address and acts as a standard slave=0D
device on the I=C2=B2C bus.=0D
=0D
Allow a device tree node to override the default addresses so that=0D
address conflicts with other devices on the same bus may be resolved at=0D
the board description level.=0D
=0D
Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>=0D
---=0D
 .../bindings/display/bridge/adi,adv7511.txt        | 10 +++++-=0D
 drivers/gpu/drm/bridge/adv7511/adv7511.h           |  4 +++=0D
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       | 36 ++++++++++++++----=
----=0D
 3 files changed, 37 insertions(+), 13 deletions(-)=0D
=0D
diff --git a/Documentation/devicetree/bindings/display/bridge/adi,adv7511.t=
xt b/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt=0D
index 0047b1394c70..f6bb9f6d3f48 100644=0D
--- a/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt=0D
+++ b/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt=0D
@@ -70,6 +70,9 @@ Optional properties:=0D
   rather than generate its own timings for HDMI output.=0D
 - clocks: from common clock binding: reference to the CEC clock.=0D
 - clock-names: from common clock binding: must be "cec".=0D
+- reg-names : Names of maps with programmable addresses.=0D
+	It can contain any map needing a non-default address.=0D
+	Possible maps names are : "main", "edid", "cec", "packet"=0D
 =0D
 Required nodes:=0D
 =0D
@@ -88,7 +91,12 @@ Example=0D
 =0D
 	adv7511w: hdmi@39 {=0D
 		compatible =3D "adi,adv7511w";=0D
-		reg =3D <39>;=0D
+		/*=0D
+		 * The EDID page will be accessible on address 0x66 on the i2c=0D
+		 * bus. All other maps continue to use their default addresses.=0D
+		 */=0D
+		reg =3D <0x39 0x66>;=0D
+		reg-names =3D "main", "edid";=0D
 		interrupt-parent =3D <&gpio3>;=0D
 		interrupts =3D <29 IRQ_TYPE_EDGE_FALLING>;=0D
 		clocks =3D <&cec_clock>;=0D
diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511.h b/drivers/gpu/drm/bri=
dge/adv7511/adv7511.h=0D
index d034b2cb5eee..7d81ce3808e0 100644=0D
--- a/drivers/gpu/drm/bridge/adv7511/adv7511.h=0D
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511.h=0D
@@ -53,8 +53,10 @@=0D
 #define ADV7511_REG_POWER			0x41=0D
 #define ADV7511_REG_STATUS			0x42=0D
 #define ADV7511_REG_EDID_I2C_ADDR		0x43=0D
+#define ADV7511_REG_EDID_I2C_ADDR_DEFAULT	0x3f=0D
 #define ADV7511_REG_PACKET_ENABLE1		0x44=0D
 #define ADV7511_REG_PACKET_I2C_ADDR		0x45=0D
+#define ADV7511_REG_PACKET_I2C_ADDR_DEFAULT	0x38=0D
 #define ADV7511_REG_DSD_ENABLE			0x46=0D
 #define ADV7511_REG_VIDEO_INPUT_CFG2		0x48=0D
 #define ADV7511_REG_INFOFRAME_UPDATE		0x4a=0D
@@ -89,6 +91,7 @@=0D
 #define ADV7511_REG_TMDS_CLOCK_INV		0xde=0D
 #define ADV7511_REG_ARC_CTRL			0xdf=0D
 #define ADV7511_REG_CEC_I2C_ADDR		0xe1=0D
+#define ADV7511_REG_CEC_I2C_ADDR_DEFAULT	0x3c=0D
 #define ADV7511_REG_CEC_CTRL			0xe2=0D
 #define ADV7511_REG_CHIP_ID_HIGH		0xf5=0D
 #define ADV7511_REG_CHIP_ID_LOW			0xf6=0D
@@ -322,6 +325,7 @@ struct adv7511 {=0D
 	struct i2c_client *i2c_main;=0D
 	struct i2c_client *i2c_edid;=0D
 	struct i2c_client *i2c_cec;=0D
+	struct i2c_client *i2c_packet;=0D
 =0D
 	struct regmap *regmap;=0D
 	struct regmap *regmap_cec;=0D
diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c b/drivers/gpu/drm=
/bridge/adv7511/adv7511_drv.c=0D
index efa29db5fc2b..7ec33837752b 100644=0D
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c=0D
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c=0D
@@ -969,8 +969,8 @@ static int adv7511_init_cec_regmap(struct adv7511 *adv)=
=0D
 {=0D
 	int ret;=0D
 =0D
-	adv->i2c_cec =3D i2c_new_dummy(adv->i2c_main->adapter,=0D
-				     adv->i2c_main->addr - 1);=0D
+	adv->i2c_cec =3D i2c_new_secondary_device(adv->i2c_main, "cec",=0D
+					ADV7511_REG_CEC_I2C_ADDR_DEFAULT);=0D
 	if (!adv->i2c_cec)=0D
 		return -ENOMEM;=0D
 	i2c_set_clientdata(adv->i2c_cec, adv);=0D
@@ -1082,8 +1082,6 @@ static int adv7511_probe(struct i2c_client *i2c, cons=
t struct i2c_device_id *id)=0D
 	struct adv7511_link_config link_config;=0D
 	struct adv7511 *adv7511;=0D
 	struct device *dev =3D &i2c->dev;=0D
-	unsigned int main_i2c_addr =3D i2c->addr << 1;=0D
-	unsigned int edid_i2c_addr =3D main_i2c_addr + 4;=0D
 	unsigned int val;=0D
 	int ret;=0D
 =0D
@@ -1153,24 +1151,35 @@ static int adv7511_probe(struct i2c_client *i2c, co=
nst struct i2c_device_id *id)=0D
 	if (ret)=0D
 		goto uninit_regulators;=0D
 =0D
-	regmap_write(adv7511->regmap, ADV7511_REG_EDID_I2C_ADDR, edid_i2c_addr);=
=0D
-	regmap_write(adv7511->regmap, ADV7511_REG_PACKET_I2C_ADDR,=0D
-		     main_i2c_addr - 0xa);=0D
-	regmap_write(adv7511->regmap, ADV7511_REG_CEC_I2C_ADDR,=0D
-		     main_i2c_addr - 2);=0D
-=0D
 	adv7511_packet_disable(adv7511, 0xffff);=0D
 =0D
-	adv7511->i2c_edid =3D i2c_new_dummy(i2c->adapter, edid_i2c_addr >> 1);=0D
+	adv7511->i2c_edid =3D i2c_new_secondary_device(i2c, "edid",=0D
+					ADV7511_REG_EDID_I2C_ADDR_DEFAULT);=0D
 	if (!adv7511->i2c_edid) {=0D
 		ret =3D -ENOMEM;=0D
 		goto uninit_regulators;=0D
 	}=0D
 =0D
+	regmap_write(adv7511->regmap, ADV7511_REG_EDID_I2C_ADDR,=0D
+		     adv7511->i2c_edid->addr << 1);=0D
+=0D
 	ret =3D adv7511_init_cec_regmap(adv7511);=0D
 	if (ret)=0D
 		goto err_i2c_unregister_edid;=0D
 =0D
+	regmap_write(adv7511->regmap, ADV7511_REG_CEC_I2C_ADDR,=0D
+		     adv7511->i2c_cec->addr << 1);=0D
+=0D
+	adv7511->i2c_packet =3D i2c_new_secondary_device(i2c, "packet",=0D
+					ADV7511_REG_PACKET_I2C_ADDR_DEFAULT);=0D
+	if (!adv7511->i2c_packet) {=0D
+		ret =3D -ENOMEM;=0D
+		goto err_unregister_cec;=0D
+	}=0D
+=0D
+	regmap_write(adv7511->regmap, ADV7511_REG_PACKET_I2C_ADDR,=0D
+		     adv7511->i2c_packet->addr << 1);=0D
+=0D
 	INIT_WORK(&adv7511->hpd_work, adv7511_hpd_work);=0D
 =0D
 	if (i2c->irq) {=0D
@@ -1181,7 +1190,7 @@ static int adv7511_probe(struct i2c_client *i2c, cons=
t struct i2c_device_id *id)=0D
 						IRQF_ONESHOT, dev_name(dev),=0D
 						adv7511);=0D
 		if (ret)=0D
-			goto err_unregister_cec;=0D
+			goto err_unregister_packet;=0D
 	}=0D
 =0D
 	adv7511_power_off(adv7511);=0D
@@ -1203,6 +1212,8 @@ static int adv7511_probe(struct i2c_client *i2c, cons=
t struct i2c_device_id *id)=0D
 	adv7511_audio_init(dev, adv7511);=0D
 	return 0;=0D
 =0D
+err_unregister_packet:=0D
+	i2c_unregister_device(adv7511->i2c_packet);=0D
 err_unregister_cec:=0D
 	i2c_unregister_device(adv7511->i2c_cec);=0D
 	if (adv7511->cec_clk)=0D
@@ -1234,6 +1245,7 @@ static int adv7511_remove(struct i2c_client *i2c)=0D
 	cec_unregister_adapter(adv7511->cec_adap);=0D
 =0D
 	i2c_unregister_device(adv7511->i2c_edid);=0D
+	i2c_unregister_device(adv7511->i2c_packet);=0D
 =0D
 	return 0;=0D
 }=0D
-- =0D
2.7.4=0D
