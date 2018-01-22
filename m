Return-path: <linux-media-owner@vger.kernel.org>
Received: from o1678950229.outbound-mail.sendgrid.net ([167.89.50.229]:4244
        "EHLO o1678950229.outbound-mail.sendgrid.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751096AbeAVMtz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 07:49:55 -0500
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS)
Subject: [PATCH 1/2] media: adv7604: Add support for i2c_new_secondary_device
Date: Mon, 22 Jan 2018 12:49:54 +0000 (UTC)
Message-Id: <1516625389-6362-2-git-send-email-kieran.bingham@ideasonboard.com>
In-Reply-To: <1516625389-6362-1-git-send-email-kieran.bingham@ideasonboard.com>
References: <1516625389-6362-1-git-send-email-kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
content-transfer-encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>=0D
=0D
The ADV7604 has thirteen 256-byte maps that can be accessed via the main=0D
I=C2=B2C ports. Each map has it own I=C2=B2C address and acts as a standard=
 slave=0D
device on the I=C2=B2C bus.=0D
=0D
Allow a device tree node to override the default addresses so that=0D
address conflicts with other devices on the same bus may be resolved at=0D
the board description level.=0D
=0D
Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>=0D
[Kieran: Re-adapted for mainline]=0D
Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>=0D
---=0D
Based upon the original posting :=0D
  https://lkml.org/lkml/2014/10/22/469=0D
---=0D
 .../devicetree/bindings/media/i2c/adv7604.txt      | 18 ++++++-=0D
 drivers/media/i2c/adv7604.c                        | 60 ++++++++++++++----=
----=0D
 2 files changed, 55 insertions(+), 23 deletions(-)=0D
=0D
diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt b/Docu=
mentation/devicetree/bindings/media/i2c/adv7604.txt=0D
index 9cbd92eb5d05..b64e313dcc66 100644=0D
--- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt=0D
+++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt=0D
@@ -13,7 +13,11 @@ Required Properties:=0D
     - "adi,adv7611" for the ADV7611=0D
     - "adi,adv7612" for the ADV7612=0D
 =0D
-  - reg: I2C slave address=0D
+  - reg: I2C slave addresses=0D
+    The ADV76xx has up to thirteen 256-byte maps that can be accessed via =
the=0D
+    main I=C2=B2C ports. Each map has it own I=C2=B2C address and acts as =
a standard=0D
+    slave device on the I=C2=B2C bus. The main address is mandatory, other=
s are=0D
+    optional and revert to defaults if not specified.=0D
 =0D
   - hpd-gpios: References to the GPIOs that control the HDMI hot-plug=0D
     detection pins, one per HDMI input. The active flag indicates the GPIO=
=0D
@@ -35,6 +39,11 @@ Optional Properties:=0D
 =0D
   - reset-gpios: Reference to the GPIO connected to the device's reset pin=
.=0D
   - default-input: Select which input is selected after reset.=0D
+  - reg-names : Names of maps with programmable addresses.=0D
+		It can contain any map needing a non-default address.=0D
+		Possible maps names are :=0D
+		  "main", "avlink", "cec", "infoframe", "esdp", "dpp", "afe",=0D
+		  "rep", "edid", "hdmi", "test", "cp", "vdp"=0D
 =0D
 Optional Endpoint Properties:=0D
 =0D
@@ -52,7 +61,12 @@ Example:=0D
 =0D
 	hdmi_receiver@4c {=0D
 		compatible =3D "adi,adv7611";=0D
-		reg =3D <0x4c>;=0D
+		/*=0D
+		 * The edid page will be accessible @ 0x66 on the i2c bus. All=0D
+		 * other maps will retain their default addresses.=0D
+		 */=0D
+		reg =3D <0x4c 0x66>;=0D
+		reg-names "main", "edid";=0D
 =0D
 		reset-gpios =3D <&ioexp 0 GPIO_ACTIVE_LOW>;=0D
 		hpd-gpios =3D <&ioexp 2 GPIO_ACTIVE_HIGH>;=0D
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c=0D
index 1544920ec52d..c346b9a8fb57 100644=0D
--- a/drivers/media/i2c/adv7604.c=0D
+++ b/drivers/media/i2c/adv7604.c=0D
@@ -2734,6 +2734,27 @@ static const struct v4l2_ctrl_config adv76xx_ctrl_fr=
ee_run_color =3D {=0D
 =0D
 /* -----------------------------------------------------------------------=
 */=0D
 =0D
+struct adv76xx_register {=0D
+	const char *name;=0D
+	u8 default_addr;=0D
+};=0D
+=0D
+static const struct adv76xx_register adv76xx_secondary_names[] =3D {=0D
+	[ADV76XX_PAGE_IO] =3D { "main", 0x4c },=0D
+	[ADV7604_PAGE_AVLINK] =3D { "avlink", 0x42 },=0D
+	[ADV76XX_PAGE_CEC] =3D { "cec", 0x40 },=0D
+	[ADV76XX_PAGE_INFOFRAME] =3D { "infoframe", 0x3e },=0D
+	[ADV7604_PAGE_ESDP] =3D { "esdp", 0x38 },=0D
+	[ADV7604_PAGE_DPP] =3D { "dpp", 0x3c },=0D
+	[ADV76XX_PAGE_AFE] =3D { "afe", 0x26 },=0D
+	[ADV76XX_PAGE_REP] =3D { "rep", 0x32 },=0D
+	[ADV76XX_PAGE_EDID] =3D { "edid", 0x36 },=0D
+	[ADV76XX_PAGE_HDMI] =3D { "hdmi", 0x34 },=0D
+	[ADV76XX_PAGE_TEST] =3D { "test", 0x30 },=0D
+	[ADV76XX_PAGE_CP] =3D { "cp", 0x22 },=0D
+	[ADV7604_PAGE_VDP] =3D { "vdp", 0x24 },=0D
+};=0D
+=0D
 static int adv76xx_core_init(struct v4l2_subdev *sd)=0D
 {=0D
 	struct adv76xx_state *state =3D to_state(sd);=0D
@@ -2834,13 +2855,26 @@ static void adv76xx_unregister_clients(struct adv76=
xx_state *state)=0D
 }=0D
 =0D
 static struct i2c_client *adv76xx_dummy_client(struct v4l2_subdev *sd,=0D
-							u8 addr, u8 io_reg)=0D
+					       unsigned int i)=0D
 {=0D
 	struct i2c_client *client =3D v4l2_get_subdevdata(sd);=0D
+	struct adv76xx_state *state =3D to_state(sd);=0D
+	struct adv76xx_platform_data *pdata =3D &state->pdata;=0D
+	unsigned int io_reg =3D 0xf2 + i;=0D
+	struct i2c_client *new_client;=0D
+=0D
+	if (pdata && pdata->i2c_addresses[i])=0D
+		new_client =3D i2c_new_dummy(client->adapter,=0D
+					   pdata->i2c_addresses[i]);=0D
+	else=0D
+		new_client =3D i2c_new_secondary_device(client,=0D
+				adv76xx_secondary_names[i].name,=0D
+				adv76xx_secondary_names[i].default_addr);=0D
 =0D
-	if (addr)=0D
-		io_write(sd, io_reg, addr << 1);=0D
-	return i2c_new_dummy(client->adapter, io_read(sd, io_reg) >> 1);=0D
+	if (new_client)=0D
+		io_write(sd, io_reg, new_client->addr << 1);=0D
+=0D
+	return new_client;=0D
 }=0D
 =0D
 static const struct adv76xx_reg_seq adv7604_recommended_settings_afe[] =3D=
 {=0D
@@ -3115,20 +3149,6 @@ static int adv76xx_parse_dt(struct adv76xx_state *st=
ate)=0D
 	/* Disable the interrupt for now as no DT-based board uses it. */=0D
 	state->pdata.int1_config =3D ADV76XX_INT1_CONFIG_DISABLED;=0D
 =0D
-	/* Use the default I2C addresses. */=0D
-	state->pdata.i2c_addresses[ADV7604_PAGE_AVLINK] =3D 0x42;=0D
-	state->pdata.i2c_addresses[ADV76XX_PAGE_CEC] =3D 0x40;=0D
-	state->pdata.i2c_addresses[ADV76XX_PAGE_INFOFRAME] =3D 0x3e;=0D
-	state->pdata.i2c_addresses[ADV7604_PAGE_ESDP] =3D 0x38;=0D
-	state->pdata.i2c_addresses[ADV7604_PAGE_DPP] =3D 0x3c;=0D
-	state->pdata.i2c_addresses[ADV76XX_PAGE_AFE] =3D 0x26;=0D
-	state->pdata.i2c_addresses[ADV76XX_PAGE_REP] =3D 0x32;=0D
-	state->pdata.i2c_addresses[ADV76XX_PAGE_EDID] =3D 0x36;=0D
-	state->pdata.i2c_addresses[ADV76XX_PAGE_HDMI] =3D 0x34;=0D
-	state->pdata.i2c_addresses[ADV76XX_PAGE_TEST] =3D 0x30;=0D
-	state->pdata.i2c_addresses[ADV76XX_PAGE_CP] =3D 0x22;=0D
-	state->pdata.i2c_addresses[ADV7604_PAGE_VDP] =3D 0x24;=0D
-=0D
 	/* Hardcode the remaining platform data fields. */=0D
 	state->pdata.disable_pwrdnb =3D 0;=0D
 	state->pdata.disable_cable_det_rst =3D 0;=0D
@@ -3478,9 +3498,7 @@ static int adv76xx_probe(struct i2c_client *client,=
=0D
 		if (!(BIT(i) & state->info->page_mask))=0D
 			continue;=0D
 =0D
-		state->i2c_clients[i] =3D=0D
-			adv76xx_dummy_client(sd, state->pdata.i2c_addresses[i],=0D
-					     0xf2 + i);=0D
+		state->i2c_clients[i] =3D adv76xx_dummy_client(sd, i);=0D
 		if (!state->i2c_clients[i]) {=0D
 			err =3D -ENOMEM;=0D
 			v4l2_err(sd, "failed to create i2c client %u\n", i);=0D
-- =0D
2.7.4=0D
