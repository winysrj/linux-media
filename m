Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33193 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753997AbeB0PGA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 10:06:00 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: niklas.soderlund@ragnatech.se,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 3/3] media: i2c: adv748x: Add support for i2c_new_secondary_device
Date: Tue, 27 Feb 2018 15:05:50 +0000
Message-Id: <1519743950-28346-4-git-send-email-kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <1519743950-28346-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
References: <1519743950-28346-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham@ideasonboard.com>

The ADV748x has twelve 256-byte maps that can be accessed via the main
I2C ports. Each map has it own I2C address and acts as a standard slave
device on the I2C bus.

Allow a device tree node to override the default addresses so that
address conflicts with other devices on the same bus may be resolved at
the board description level.

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
---
 drivers/media/i2c/adv748x/adv748x-core.c | 77 +++++++++++++++-----------------
 drivers/media/i2c/adv748x/adv748x.h      | 14 ------
 2 files changed, 36 insertions(+), 55 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index 9dcaadaca217..911ccf6eb68c 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -80,21 +80,24 @@ static int adv748x_configure_regmap(struct adv748x_state *state, int region)
 
 	return 0;
 }
+struct adv748x_register_map {
+	const char *name;
+	u8 default_addr;
+};
 
-/* Default addresses for the I2C pages */
-static int adv748x_i2c_addresses[ADV748X_PAGE_MAX] = {
-	ADV748X_I2C_IO,
-	ADV748X_I2C_DPLL,
-	ADV748X_I2C_CP,
-	ADV748X_I2C_HDMI,
-	ADV748X_I2C_EDID,
-	ADV748X_I2C_REPEATER,
-	ADV748X_I2C_INFOFRAME,
-	ADV748X_I2C_CBUS,
-	ADV748X_I2C_CEC,
-	ADV748X_I2C_SDP,
-	ADV748X_I2C_TXB,
-	ADV748X_I2C_TXA,
+static const struct adv748x_register_map adv748x_default_addresses[] = {
+	[ADV748X_PAGE_IO] = { "main", 0x70 },
+	[ADV748X_PAGE_DPLL] = { "dpll", 0x26 },
+	[ADV748X_PAGE_CP] = { "cp", 0x22 },
+	[ADV748X_PAGE_HDMI] = { "hdmi", 0x34 },
+	[ADV748X_PAGE_EDID] = { "edid", 0x36 },
+	[ADV748X_PAGE_REPEATER] = { "repeater", 0x32 },
+	[ADV748X_PAGE_INFOFRAME] = { "infoframe", 0x31 },
+	[ADV748X_PAGE_CBUS] = { "cbus", 0x30 },
+	[ADV748X_PAGE_CEC] = { "cec", 0x41 },
+	[ADV748X_PAGE_SDP] = { "sdp", 0x79 },
+	[ADV748X_PAGE_TXB] = { "txb", 0x48 },
+	[ADV748X_PAGE_TXA] = { "txa", 0x4a },
 };
 
 static int adv748x_read_check(struct adv748x_state *state,
@@ -143,15 +146,20 @@ int adv748x_write_block(struct adv748x_state *state, int client_page,
 	return regmap_raw_write(regmap, init_reg, val, val_len);
 }
 
-static struct i2c_client *adv748x_dummy_client(struct adv748x_state *state,
-					       u8 addr, u8 io_reg)
+static int adv748x_set_slave_addresses(struct adv748x_state *state)
 {
-	struct i2c_client *client = state->client;
+	struct i2c_client *client;
+	unsigned int i;
+	u8 io_reg;
+
+	for (i = ADV748X_PAGE_DPLL; i < ADV748X_PAGE_MAX; ++i) {
+		io_reg = ADV748X_IO_SLAVE_ADDR_BASE + i;
+		client = state->i2c_clients[i];
 
-	if (addr)
-		io_write(state, io_reg, addr << 1);
+		io_write(state, io_reg, client->addr << 1);
+	}
 
-	return i2c_new_dummy(client->adapter, io_read(state, io_reg) >> 1);
+	return 0;
 }
 
 static void adv748x_unregister_clients(struct adv748x_state *state)
@@ -164,13 +172,15 @@ static void adv748x_unregister_clients(struct adv748x_state *state)
 
 static int adv748x_initialise_clients(struct adv748x_state *state)
 {
-	int i;
+	unsigned int i;
 	int ret;
 
 	for (i = ADV748X_PAGE_DPLL; i < ADV748X_PAGE_MAX; ++i) {
-		state->i2c_clients[i] =
-			adv748x_dummy_client(state, adv748x_i2c_addresses[i],
-					     ADV748X_IO_SLAVE_ADDR_BASE + i);
+		state->i2c_clients[i] = i2c_new_secondary_device(
+				state->client,
+				adv748x_default_addresses[i].name,
+				adv748x_default_addresses[i].default_addr);
+
 		if (state->i2c_clients[i] == NULL) {
 			adv_err(state, "failed to create i2c client %u\n", i);
 			return -ENOMEM;
@@ -181,7 +191,7 @@ static int adv748x_initialise_clients(struct adv748x_state *state)
 			return ret;
 	}
 
-	return 0;
+	return adv748x_set_slave_addresses(state);
 }
 
 /**
@@ -347,21 +357,6 @@ static const struct adv748x_reg_value adv748x_sw_reset[] = {
 	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
 };
 
-static const struct adv748x_reg_value adv748x_set_slave_address[] = {
-	{ADV748X_PAGE_IO, 0xf3, ADV748X_I2C_DPLL << 1},
-	{ADV748X_PAGE_IO, 0xf4, ADV748X_I2C_CP << 1},
-	{ADV748X_PAGE_IO, 0xf5, ADV748X_I2C_HDMI << 1},
-	{ADV748X_PAGE_IO, 0xf6, ADV748X_I2C_EDID << 1},
-	{ADV748X_PAGE_IO, 0xf7, ADV748X_I2C_REPEATER << 1},
-	{ADV748X_PAGE_IO, 0xf8, ADV748X_I2C_INFOFRAME << 1},
-	{ADV748X_PAGE_IO, 0xf9, ADV748X_I2C_CBUS << 1},
-	{ADV748X_PAGE_IO, 0xfa, ADV748X_I2C_CEC << 1},
-	{ADV748X_PAGE_IO, 0xfb, ADV748X_I2C_SDP << 1},
-	{ADV748X_PAGE_IO, 0xfc, ADV748X_I2C_TXB << 1},
-	{ADV748X_PAGE_IO, 0xfd, ADV748X_I2C_TXA << 1},
-	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
-};
-
 /* Supported Formats For Script Below */
 /* - 01-29 HDMI to MIPI TxA CSI 4-Lane - RGB888: */
 static const struct adv748x_reg_value adv748x_init_txa_4lane[] = {
@@ -492,7 +487,7 @@ static int adv748x_reset(struct adv748x_state *state)
 	if (ret < 0)
 		return ret;
 
-	ret = adv748x_write_regs(state, adv748x_set_slave_address);
+	ret = adv748x_set_slave_addresses(state);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
index 725662edc4b8..65f83741277e 100644
--- a/drivers/media/i2c/adv748x/adv748x.h
+++ b/drivers/media/i2c/adv748x/adv748x.h
@@ -27,20 +27,6 @@
 #ifndef _ADV748X_H_
 #define _ADV748X_H_
 
-/* I2C slave addresses */
-#define ADV748X_I2C_IO			0x70	/* IO Map */
-#define ADV748X_I2C_DPLL		0x26	/* DPLL Map */
-#define ADV748X_I2C_CP			0x22	/* CP Map */
-#define ADV748X_I2C_HDMI		0x34	/* HDMI Map */
-#define ADV748X_I2C_EDID		0x36	/* EDID Map */
-#define ADV748X_I2C_REPEATER		0x32	/* HDMI RX Repeater Map */
-#define ADV748X_I2C_INFOFRAME		0x31	/* HDMI RX InfoFrame Map */
-#define ADV748X_I2C_CBUS		0x30	/* CBUS MHL Map */
-#define ADV748X_I2C_CEC			0x41	/* CEC Map */
-#define ADV748X_I2C_SDP			0x79	/* SDP Map */
-#define ADV748X_I2C_TXB			0x48	/* CSI-TXB Map */
-#define ADV748X_I2C_TXA			0x4a	/* CSI-TXA Map */
-
 enum adv748x_page {
 	ADV748X_PAGE_IO,
 	ADV748X_PAGE_DPLL,
-- 
2.7.4
