Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:38425 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751271AbeCIPxp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 10:53:45 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 07/11] media: lgdt330x: constify several register init arrays
Date: Fri,  9 Mar 2018 12:53:32 -0300
Message-Id: <2e522f38760c12dce1b2a831d663d6284172eb1d.1520610788.git.mchehab@s-opensource.com>
In-Reply-To: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
References: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
In-Reply-To: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
References: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several register init arrays there that can be
constified.

The change reduced a little bit the amount of initialized
data:

   text	   data	    bss	    dec	    hex	filename
   6372	    360	      4	   6736	   1a50	old/drivers/media/dvb-frontends/lgdt330x.o
   6500	    264	      4	   6768	   1a70	new/drivers/media/dvb-frontends/lgdt330x.o

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/lgdt330x.c | 43 ++++++++++++++--------------------
 1 file changed, 18 insertions(+), 25 deletions(-)

diff --git a/drivers/media/dvb-frontends/lgdt330x.c b/drivers/media/dvb-frontends/lgdt330x.c
index e93ffe8891e5..c7355282bb3e 100644
--- a/drivers/media/dvb-frontends/lgdt330x.c
+++ b/drivers/media/dvb-frontends/lgdt330x.c
@@ -186,19 +186,14 @@ static int lgdt330x_sw_reset(struct lgdt330x_state *state)
 
 static int lgdt330x_init(struct dvb_frontend *fe)
 {
-	/*
-	 * Hardware reset is done using gpio[0] of cx23880x chip.
-	 * I'd like to do it here, but don't know how to find chip address.
-	 * cx88-cards.c arranges for the reset bit to be inactive (high).
-	 * Maybe there needs to be a callable function in cx88-core or
-	 * the caller of this function needs to do it.
-	 */
-
+	struct lgdt330x_state *state = fe->demodulator_priv;
+	char  *chip_name;
+	int    err;
 	/*
 	 * Array of byte pairs <address, value>
 	 * to initialize each different chip
 	 */
-	static u8 lgdt3302_init_data[] = {
+	static const u8 lgdt3302_init_data[] = {
 		/* Use 50MHz param values from spec sheet since xtal is 50 */
 		/*
 		 * Change the value of NCOCTFV[25:0] of carrier
@@ -243,24 +238,25 @@ static int lgdt330x_init(struct dvb_frontend *fe)
 		AGC_LOOP_BANDWIDTH0, 0x08,
 		AGC_LOOP_BANDWIDTH1, 0x9a
 	};
-
-	static u8 lgdt3303_init_data[] = {
+	static const u8 lgdt3303_init_data[] = {
 		0x4c, 0x14
 	};
-
-	static u8 flip_1_lgdt3303_init_data[] = {
+	static const u8 flip_1_lgdt3303_init_data[] = {
 		0x4c, 0x14,
 		0x87, 0xf3
 	};
-
-	static u8 flip_2_lgdt3303_init_data[] = {
+	static const u8 flip_2_lgdt3303_init_data[] = {
 		0x4c, 0x14,
 		0x87, 0xda
 	};
 
-	struct lgdt330x_state *state = fe->demodulator_priv;
-	char  *chip_name;
-	int    err;
+	/*
+	 * Hardware reset is done using gpio[0] of cx23880x chip.
+	 * I'd like to do it here, but don't know how to find chip address.
+	 * cx88-cards.c arranges for the reset bit to be inactive (high).
+	 * Maybe there needs to be a callable function in cx88-core or
+	 * the caller of this function needs to do it.
+	 */
 
 	switch (state->config.demod_chip) {
 	case LGDT3302:
@@ -337,11 +333,12 @@ static int lgdt330x_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 static int lgdt330x_set_parameters(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	struct lgdt330x_state *state = fe->demodulator_priv;
 	/*
 	 * Array of byte pairs <address, value>
 	 * to initialize 8VSB for lgdt3303 chip 50 MHz IF
 	 */
-	static u8 lgdt3303_8vsb_44_data[] = {
+	static const u8 lgdt3303_8vsb_44_data[] = {
 		0x04, 0x00,
 		0x0d, 0x40,
 		0x0e, 0x87,
@@ -349,12 +346,11 @@ static int lgdt330x_set_parameters(struct dvb_frontend *fe)
 		0x10, 0x01,
 		0x47, 0x8b
 	};
-
 	/*
 	 * Array of byte pairs <address, value>
 	 * to initialize QAM for lgdt3303 chip
 	 */
-	static u8 lgdt3303_qam_data[] = {
+	static const u8 lgdt3303_qam_data[] = {
 		0x04, 0x00,
 		0x0d, 0x00,
 		0x0e, 0x00,
@@ -367,10 +363,7 @@ static int lgdt330x_set_parameters(struct dvb_frontend *fe)
 		0x49, 0x08,
 		0x4a, 0x9b
 	};
-
-	struct lgdt330x_state *state = fe->demodulator_priv;
-
-	static u8 top_ctrl_cfg[]   = { TOP_CONTROL, 0x03 };
+	u8 top_ctrl_cfg[]   = { TOP_CONTROL, 0x03 };
 
 	int err = 0;
 	/* Change only if we are actually changing the modulation */
-- 
2.14.3
