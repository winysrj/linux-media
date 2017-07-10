Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:49939 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753973AbdGJS3w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 14:29:52 -0400
From: Colin King <colin.king@canonical.com>
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] smiapp: make various const arrays static
Date: Mon, 10 Jul 2017 19:29:47 +0100
Message-Id: <20170710182947.17884-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Don't populate const arrays on the stack but instead make them static.
Makes the object code smaller and saves nearly 550 bytes.

Before:
   text	   data	    bss	    dec	    hex	filename
   3638	    752	      0	   4390	   1126	smiapp-quirk.o

After:
   text	   data	    bss	    dec	    hex	filename
   2802	   1040	      0	   3842	    f02	smiapp-quirk.o

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/i2c/smiapp/smiapp-quirk.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-quirk.c b/drivers/media/i2c/smiapp/smiapp-quirk.c
index cb128eae9c54..95c0272bb014 100644
--- a/drivers/media/i2c/smiapp/smiapp-quirk.c
+++ b/drivers/media/i2c/smiapp/smiapp-quirk.c
@@ -71,7 +71,7 @@ static int jt8ew9_limits(struct smiapp_sensor *sensor)
 
 static int jt8ew9_post_poweron(struct smiapp_sensor *sensor)
 {
-	const struct smiapp_reg_8 regs[] = {
+	static const struct smiapp_reg_8 regs[] = {
 		{ 0x30a3, 0xd8 }, /* Output port control : LVDS ports only */
 		{ 0x30ae, 0x00 }, /* 0x0307 pll_multiplier maximum value on PLL input 9.6MHz ( 19.2MHz is divided on pre_pll_div) */
 		{ 0x30af, 0xd0 }, /* 0x0307 pll_multiplier maximum value on PLL input 9.6MHz ( 19.2MHz is divided on pre_pll_div) */
@@ -115,7 +115,7 @@ const struct smiapp_quirk smiapp_jt8ew9_quirk = {
 static int imx125es_post_poweron(struct smiapp_sensor *sensor)
 {
 	/* Taken from v02. No idea what the other two are. */
-	const struct smiapp_reg_8 regs[] = {
+	static const struct smiapp_reg_8 regs[] = {
 		/*
 		 * 0x3302: clk during frame blanking:
 		 * 0x00 - HS mode, 0x01 - LP11
@@ -145,7 +145,7 @@ static int jt8ev1_post_poweron(struct smiapp_sensor *sensor)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 	int rval;
-	const struct smiapp_reg_8 regs[] = {
+	static const struct smiapp_reg_8 regs[] = {
 		{ 0x3031, 0xcd }, /* For digital binning (EQ_MONI) */
 		{ 0x30a3, 0xd0 }, /* FLASH STROBE enable */
 		{ 0x3237, 0x00 }, /* For control of pulse timing for ADC */
@@ -166,7 +166,7 @@ static int jt8ev1_post_poweron(struct smiapp_sensor *sensor)
 		{ 0x33cf, 0xec }, /* For Black sun */
 		{ 0x3328, 0x80 }, /* Ugh. No idea what's this. */
 	};
-	const struct smiapp_reg_8 regs_96[] = {
+	static const struct smiapp_reg_8 regs_96[] = {
 		{ 0x30ae, 0x00 }, /* For control of ADC clock */
 		{ 0x30af, 0xd0 },
 		{ 0x30b0, 0x01 },
-- 
2.11.0
