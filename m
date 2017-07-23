Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35708 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751807AbdGWKN0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Jul 2017 06:13:26 -0400
Received: by mail-wm0-f68.google.com with SMTP id m75so5412400wmb.2
        for <linux-media@vger.kernel.org>; Sun, 23 Jul 2017 03:13:25 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, r.scobie@clear.net.nz
Subject: [PATCH 6/7] [media] dvb-frontends/stv6111: cosmetics: comments fixup, misc
Date: Sun, 23 Jul 2017 12:13:14 +0200
Message-Id: <20170723101315.12523-7-d.scheller.oss@gmail.com>
In-Reply-To: <20170723101315.12523-1-d.scheller.oss@gmail.com>
References: <20170723101315.12523-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv6111.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv6111.c b/drivers/media/dvb-frontends/stv6111.c
index 91e24ba44c30..c4db5e6c18af 100644
--- a/drivers/media/dvb-frontends/stv6111.c
+++ b/drivers/media/dvb-frontends/stv6111.c
@@ -42,7 +42,7 @@ struct slookup {
 };
 
 static struct slookup lnagain_nf_lookup[] = {
-	/*Gain *100dB*/      /*Reg*/
+	/* Gain *100dB // Reg */
 	{ 2572,	0 },
 	{ 2575, 1 },
 	{ 2580, 2 },
@@ -78,7 +78,7 @@ static struct slookup lnagain_nf_lookup[] = {
 };
 
 static struct slookup lnagain_iip3_lookup[] = {
-	/*Gain *100dB*/   /*reg*/
+	/* Gain *100dB // reg */
 	{ 1548,	0 },
 	{ 1552,	1 },
 	{ 1569,	2 },
@@ -114,7 +114,7 @@ static struct slookup lnagain_iip3_lookup[] = {
 };
 
 static struct slookup gain_rfagc_lookup[] = {
-	/*Gain *100dB*/   /*reg*/
+	/* Gain *100dB // reg */
 	{ 4870,	0x3000 },
 	{ 4850,	0x3C00 },
 	{ 4800,	0x4500 },
@@ -174,7 +174,7 @@ static struct slookup gain_rfagc_lookup[] = {
  * a different BB_MAG setting)
  */
 static struct slookup gain_channel_agc_nf_lookup[] = {
-	/*Gain *100dB*/   /*reg*/
+	/* Gain *100dB // reg */
 	{ 7082,	0x3000 },
 	{ 7052,	0x4000 },
 	{ 7007,	0x4600 },
@@ -233,7 +233,7 @@ static struct slookup gain_channel_agc_nf_lookup[] = {
 };
 
 static struct slookup gain_channel_agc_iip3_lookup[] = {
-	/*Gain *100dB*/   /*reg*/
+	/* Gain *100dB // reg */
 	{ 7070,	0x3000 },
 	{ 7028,	0x4000 },
 	{ 7019,	0x4600 },
@@ -483,7 +483,7 @@ static int set_lof(struct stv *state, u32 local_frequency, u32 cutoff_frequency)
 	else
 		icp = 7;
 
-	state->reg[0x02] |= 0x80;   /* LNA IIP3 Mode */
+	state->reg[0x02] |= 0x80; /* LNA IIP3 Mode */
 
 	state->reg[0x03] = (state->reg[0x03] & ~0x80) | (psel << 7);
 	state->reg[0x04] = (div & 0xFF);
@@ -503,7 +503,7 @@ static int set_lof(struct stv *state, u32 local_frequency, u32 cutoff_frequency)
 
 	read_reg(state, 0x03, &tmp);
 	if (tmp & 0x10)	{
-		state->reg[0x02] &= ~0x80;   /* LNA NF Mode */
+		state->reg[0x02] &= ~0x80; /* LNA NF Mode */
 		write_regs(state, 2, 1);
 	}
 	read_reg(state, 0x08, &tmp);
@@ -636,15 +636,15 @@ static int get_rf_strength(struct dvb_frontend *fe, u16 *st)
 
 static struct dvb_tuner_ops tuner_ops = {
 	.info = {
-		.name = "STV6111",
-		.frequency_min  =  950000,
-		.frequency_max  = 2150000,
-		.frequency_step =       0
+		.name		= "STV6111",
+		.frequency_min	= 950000,
+		.frequency_max	= 2150000,
+		.frequency_step	= 0
 	},
-	.set_params        = set_params,
-	.release           = release,
-	.get_rf_strength   = get_rf_strength,
-	.set_bandwidth     = set_bandwidth,
+	.set_params		= set_params,
+	.release		= release,
+	.get_rf_strength	= get_rf_strength,
+	.set_bandwidth		= set_bandwidth,
 };
 
 struct dvb_frontend *stv6111_attach(struct dvb_frontend *fe,
-- 
2.13.0
