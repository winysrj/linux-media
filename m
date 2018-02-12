Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932562AbeBLWIT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 17:08:19 -0500
From: Kieran Bingham <kbingham@kernel.org>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v3 4/5] media: adv7604: Add support for i2c_new_secondary_device
Date: Mon, 12 Feb 2018 22:07:52 +0000
Message-Id: <1518473273-6333-5-git-send-email-kbingham@kernel.org>
In-Reply-To: <1518473273-6333-1-git-send-email-kbingham@kernel.org>
References: <1518473273-6333-1-git-send-email-kbingham@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>

The ADV7604 has thirteen 256-byte maps that can be accessed via the main
I²C ports. Each map has it own I²C address and acts as a standard slave
device on the I²C bus.

Allow a device tree node to override the default addresses so that
address conflicts with other devices on the same bus may be resolved at
the board description level.

Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
[Kieran: Re-adapted for mainline]
Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
Based upon the original posting :
  https://lkml.org/lkml/2014/10/22/469

v2:
 - Split out DT bindings from driver updates
 - Return -EINVAL on error paths from adv76xx_dummy_client()

 drivers/media/i2c/adv7604.c | 62 +++++++++++++++++++++++++++++----------------
 1 file changed, 40 insertions(+), 22 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 1544920ec52d..872e124793f8 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2734,6 +2734,27 @@ static const struct v4l2_ctrl_config adv76xx_ctrl_free_run_color = {
 
 /* ----------------------------------------------------------------------- */
 
+struct adv76xx_register {
+	const char *name;
+	u8 default_addr;
+};
+
+static const struct adv76xx_register adv76xx_secondary_names[] = {
+	[ADV76XX_PAGE_IO] = { "main", 0x4c },
+	[ADV7604_PAGE_AVLINK] = { "avlink", 0x42 },
+	[ADV76XX_PAGE_CEC] = { "cec", 0x40 },
+	[ADV76XX_PAGE_INFOFRAME] = { "infoframe", 0x3e },
+	[ADV7604_PAGE_ESDP] = { "esdp", 0x38 },
+	[ADV7604_PAGE_DPP] = { "dpp", 0x3c },
+	[ADV76XX_PAGE_AFE] = { "afe", 0x26 },
+	[ADV76XX_PAGE_REP] = { "rep", 0x32 },
+	[ADV76XX_PAGE_EDID] = { "edid", 0x36 },
+	[ADV76XX_PAGE_HDMI] = { "hdmi", 0x34 },
+	[ADV76XX_PAGE_TEST] = { "test", 0x30 },
+	[ADV76XX_PAGE_CP] = { "cp", 0x22 },
+	[ADV7604_PAGE_VDP] = { "vdp", 0x24 },
+};
+
 static int adv76xx_core_init(struct v4l2_subdev *sd)
 {
 	struct adv76xx_state *state = to_state(sd);
@@ -2834,13 +2855,26 @@ static void adv76xx_unregister_clients(struct adv76xx_state *state)
 }
 
 static struct i2c_client *adv76xx_dummy_client(struct v4l2_subdev *sd,
-							u8 addr, u8 io_reg)
+					       unsigned int i)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct adv76xx_state *state = to_state(sd);
+	struct adv76xx_platform_data *pdata = &state->pdata;
+	unsigned int io_reg = 0xf2 + i;
+	struct i2c_client *new_client;
+
+	if (pdata && pdata->i2c_addresses[i])
+		new_client = i2c_new_dummy(client->adapter,
+					   pdata->i2c_addresses[i]);
+	else
+		new_client = i2c_new_secondary_device(client,
+				adv76xx_secondary_names[i].name,
+				adv76xx_secondary_names[i].default_addr);
 
-	if (addr)
-		io_write(sd, io_reg, addr << 1);
-	return i2c_new_dummy(client->adapter, io_read(sd, io_reg) >> 1);
+	if (new_client)
+		io_write(sd, io_reg, new_client->addr << 1);
+
+	return new_client;
 }
 
 static const struct adv76xx_reg_seq adv7604_recommended_settings_afe[] = {
@@ -3115,20 +3149,6 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
 	/* Disable the interrupt for now as no DT-based board uses it. */
 	state->pdata.int1_config = ADV76XX_INT1_CONFIG_DISABLED;
 
-	/* Use the default I2C addresses. */
-	state->pdata.i2c_addresses[ADV7604_PAGE_AVLINK] = 0x42;
-	state->pdata.i2c_addresses[ADV76XX_PAGE_CEC] = 0x40;
-	state->pdata.i2c_addresses[ADV76XX_PAGE_INFOFRAME] = 0x3e;
-	state->pdata.i2c_addresses[ADV7604_PAGE_ESDP] = 0x38;
-	state->pdata.i2c_addresses[ADV7604_PAGE_DPP] = 0x3c;
-	state->pdata.i2c_addresses[ADV76XX_PAGE_AFE] = 0x26;
-	state->pdata.i2c_addresses[ADV76XX_PAGE_REP] = 0x32;
-	state->pdata.i2c_addresses[ADV76XX_PAGE_EDID] = 0x36;
-	state->pdata.i2c_addresses[ADV76XX_PAGE_HDMI] = 0x34;
-	state->pdata.i2c_addresses[ADV76XX_PAGE_TEST] = 0x30;
-	state->pdata.i2c_addresses[ADV76XX_PAGE_CP] = 0x22;
-	state->pdata.i2c_addresses[ADV7604_PAGE_VDP] = 0x24;
-
 	/* Hardcode the remaining platform data fields. */
 	state->pdata.disable_pwrdnb = 0;
 	state->pdata.disable_cable_det_rst = 0;
@@ -3478,11 +3498,9 @@ static int adv76xx_probe(struct i2c_client *client,
 		if (!(BIT(i) & state->info->page_mask))
 			continue;
 
-		state->i2c_clients[i] =
-			adv76xx_dummy_client(sd, state->pdata.i2c_addresses[i],
-					     0xf2 + i);
+		state->i2c_clients[i] = adv76xx_dummy_client(sd, i);
 		if (!state->i2c_clients[i]) {
-			err = -ENOMEM;
+			err = -EINVAL;
 			v4l2_err(sd, "failed to create i2c client %u\n", i);
 			goto err_i2c;
 		}
-- 
2.7.4
