Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33192 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753996AbeB0PF7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 10:05:59 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: niklas.soderlund@ragnatech.se,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 2/3] media: i2c: adv748x: Add missing CBUS page
Date: Tue, 27 Feb 2018 15:05:49 +0000
Message-Id: <1519743950-28346-3-git-send-email-kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <1519743950-28346-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
References: <1519743950-28346-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham@ideasonboard.com>

The ADV748x has 12 pages mapped onto I2C addresses.

In the existing implementation only 11 are mapped correctly in the page
enumerations, which causes an off-by-one fault on pages above the
infoframe definition due to a missing 'CBUS' page.

This causes the address for the CEC, SDP, TXA, and TXB to be incorrectly
programmed during the iterations in adv748x_initialise_clients().

Until now this has gone un-noticed due to the fact that following the
creation of the clients - the device is reset and the addresses are
reprogrammed in manually by the call to "adv748x_write_regs(state,
adv748x_set_slave_address);"

As part of moving to dynamic i2c address allocations repair this by
providing the missing CBUS page definition.

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
v2
 - Remove period from commit title.
 - Collect Niklas' RB tag.


 drivers/media/i2c/adv748x/adv748x-core.c | 3 +++
 drivers/media/i2c/adv748x/adv748x.h      | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index faf73949962b..9dcaadaca217 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -52,6 +52,7 @@ static const struct regmap_config adv748x_regmap_cnf[] = {
 	ADV748X_REGMAP_CONF("edid"),
 	ADV748X_REGMAP_CONF("repeater"),
 	ADV748X_REGMAP_CONF("infoframe"),
+	ADV748X_REGMAP_CONF("cbus"),
 	ADV748X_REGMAP_CONF("cec"),
 	ADV748X_REGMAP_CONF("sdp"),
 	ADV748X_REGMAP_CONF("txa"),
@@ -89,6 +90,7 @@ static int adv748x_i2c_addresses[ADV748X_PAGE_MAX] = {
 	ADV748X_I2C_EDID,
 	ADV748X_I2C_REPEATER,
 	ADV748X_I2C_INFOFRAME,
+	ADV748X_I2C_CBUS,
 	ADV748X_I2C_CEC,
 	ADV748X_I2C_SDP,
 	ADV748X_I2C_TXB,
@@ -352,6 +354,7 @@ static const struct adv748x_reg_value adv748x_set_slave_address[] = {
 	{ADV748X_PAGE_IO, 0xf6, ADV748X_I2C_EDID << 1},
 	{ADV748X_PAGE_IO, 0xf7, ADV748X_I2C_REPEATER << 1},
 	{ADV748X_PAGE_IO, 0xf8, ADV748X_I2C_INFOFRAME << 1},
+	{ADV748X_PAGE_IO, 0xf9, ADV748X_I2C_CBUS << 1},
 	{ADV748X_PAGE_IO, 0xfa, ADV748X_I2C_CEC << 1},
 	{ADV748X_PAGE_IO, 0xfb, ADV748X_I2C_SDP << 1},
 	{ADV748X_PAGE_IO, 0xfc, ADV748X_I2C_TXB << 1},
diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
index 6789e2f3bc8c..725662edc4b8 100644
--- a/drivers/media/i2c/adv748x/adv748x.h
+++ b/drivers/media/i2c/adv748x/adv748x.h
@@ -35,6 +35,7 @@
 #define ADV748X_I2C_EDID		0x36	/* EDID Map */
 #define ADV748X_I2C_REPEATER		0x32	/* HDMI RX Repeater Map */
 #define ADV748X_I2C_INFOFRAME		0x31	/* HDMI RX InfoFrame Map */
+#define ADV748X_I2C_CBUS		0x30	/* CBUS MHL Map */
 #define ADV748X_I2C_CEC			0x41	/* CEC Map */
 #define ADV748X_I2C_SDP			0x79	/* SDP Map */
 #define ADV748X_I2C_TXB			0x48	/* CSI-TXB Map */
@@ -48,6 +49,7 @@ enum adv748x_page {
 	ADV748X_PAGE_EDID,
 	ADV748X_PAGE_REPEATER,
 	ADV748X_PAGE_INFOFRAME,
+	ADV748X_PAGE_CBUS,
 	ADV748X_PAGE_CEC,
 	ADV748X_PAGE_SDP,
 	ADV748X_PAGE_TXB,
-- 
2.7.4
