Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:32852 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752454AbdC2QnU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 12:43:20 -0400
Received: by mail-wr0-f194.google.com with SMTP id u18so4575724wrc.0
        for <linux-media@vger.kernel.org>; Wed, 29 Mar 2017 09:43:19 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org
Cc: liplianin@netup.ru, rjkm@metzlerbros.de, crope@iki.fi
Subject: [PATCH v3 03/13] [media] dvb-frontends/stv0367: refactor defaults table handling
Date: Wed, 29 Mar 2017 18:43:03 +0200
Message-Id: <20170329164313.14636-4-d.scheller.oss@gmail.com>
In-Reply-To: <20170329164313.14636-1-d.scheller.oss@gmail.com>
References: <20170329164313.14636-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Change defaults table writing so tables can be of dynamic length without
having to keep track of their lengths by adding and evaluating an end
marker (reg 0x0000), also move table writing to a dedicated function to
remove code duplication. Additionally mark st_register tables const since
they're used read-only.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0367.c      | 30 ++++++++++++++++++++----------
 drivers/media/dvb-frontends/stv0367_regs.h |  4 ----
 2 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index 0064d9d..5ed52ec 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -99,7 +99,7 @@ struct st_register {
 };
 
 /* values for STV4100 XTAL=30M int clk=53.125M*/
-static struct st_register def0367ter[STV0367TER_NBREGS] = {
+static const struct st_register def0367ter[] = {
 	{R367TER_ID,		0x60},
 	{R367TER_I2CRPT,	0xa0},
 	/* {R367TER_I2CRPT,	0x22},*/
@@ -546,6 +546,7 @@ static struct st_register def0367ter[STV0367TER_NBREGS] = {
 	{R367TER_DEBUG_LT7,	0x00},
 	{R367TER_DEBUG_LT8,	0x00},
 	{R367TER_DEBUG_LT9,	0x00},
+	{0x0000,		0x00},
 };
 
 #define RF_LOOKUP_TABLE_SIZE  31
@@ -573,7 +574,7 @@ static const s32 stv0367cab_RF_LookUp2[RF_LOOKUP_TABLE2_SIZE][RF_LOOKUP_TABLE2_S
 	}
 };
 
-static struct st_register def0367cab[STV0367CAB_NBREGS] = {
+static const struct st_register def0367cab[] = {
 	{R367CAB_ID,		0x60},
 	{R367CAB_I2CRPT,	0xa0},
 	/*{R367CAB_I2CRPT,	0x22},*/
@@ -762,6 +763,7 @@ static struct st_register def0367cab[STV0367CAB_NBREGS] = {
 	{R367CAB_T_O_ID_1,	0x00},
 	{R367CAB_T_O_ID_2,	0x00},
 	{R367CAB_T_O_ID_3,	0x00},
+	{0x0000,		0x00},
 };
 
 static
@@ -901,6 +903,20 @@ static u8 stv0367_getbits(u8 reg, u32 label)
 	return (reg & mask) >> pos;
 }
 #endif
+
+static void stv0367_write_table(struct stv0367_state *state,
+				const struct st_register *deftab)
+{
+	int i = 0;
+
+	while (1) {
+		if (!deftab[i].addr)
+			break;
+		stv0367_writereg(state, deftab[i].addr, deftab[i].value);
+		i++;
+	}
+}
+
 static int stv0367ter_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	struct stv0367_state *state = fe->demodulator_priv;
@@ -1540,15 +1556,12 @@ static int stv0367ter_init(struct dvb_frontend *fe)
 {
 	struct stv0367_state *state = fe->demodulator_priv;
 	struct stv0367ter_state *ter_state = state->ter_state;
-	int i;
 
 	dprintk("%s:\n", __func__);
 
 	ter_state->pBER = 0;
 
-	for (i = 0; i < STV0367TER_NBREGS; i++)
-		stv0367_writereg(state, def0367ter[i].addr,
-					def0367ter[i].value);
+	stv0367_write_table(state, def0367ter);
 
 	switch (state->config->xtal) {
 		/*set internal freq to 53.125MHz */
@@ -2782,13 +2795,10 @@ static int stv0367cab_init(struct dvb_frontend *fe)
 {
 	struct stv0367_state *state = fe->demodulator_priv;
 	struct stv0367cab_state *cab_state = state->cab_state;
-	int i;
 
 	dprintk("%s:\n", __func__);
 
-	for (i = 0; i < STV0367CAB_NBREGS; i++)
-		stv0367_writereg(state, def0367cab[i].addr,
-						def0367cab[i].value);
+	stv0367_write_table(state, def0367cab);
 
 	switch (state->config->ts_mode) {
 	case STV0367_DVBCI_CLOCK:
diff --git a/drivers/media/dvb-frontends/stv0367_regs.h b/drivers/media/dvb-frontends/stv0367_regs.h
index 1d15862..cc66d93 100644
--- a/drivers/media/dvb-frontends/stv0367_regs.h
+++ b/drivers/media/dvb-frontends/stv0367_regs.h
@@ -2639,8 +2639,6 @@
 #define	R367TER_DEBUG_LT9	0xf405
 #define	F367TER_F_DEBUG_LT9	0xf40500ff
 
-#define STV0367TER_NBREGS	445
-
 /* ID */
 #define	R367CAB_ID	0xf000
 #define	F367CAB_IDENTIFICATIONREGISTER	0xf00000ff
@@ -3605,6 +3603,4 @@
 #define	R367CAB_T_O_ID_3	0xf4d3
 #define	F367CAB_TS_ID_I_H	0xf4d300ff
 
-#define STV0367CAB_NBREGS	187
-
 #endif
-- 
2.10.2
