Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36029 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755841AbdCGTd5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 14:33:57 -0500
Received: by mail-wr0-f193.google.com with SMTP id l37so1482567wrc.3
        for <linux-media@vger.kernel.org>; Tue, 07 Mar 2017 11:33:35 -0800 (PST)
Received: from dvbdev.wuest.de (ip-178-201-73-185.hsi08.unitymediagroup.de. [178.201.73.185])
        by smtp.gmail.com with ESMTPSA id m186sm13760369wmd.21.2017.03.07.10.58.32
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 07 Mar 2017 10:58:33 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 05/13] [media] dvb-frontends/stv0367: make PLLSETUP a function, add 58MHz IC speed
Date: Tue,  7 Mar 2017 19:57:19 +0100
Message-Id: <20170307185727.564-6-d.scheller.oss@gmail.com>
In-Reply-To: <20170307185727.564-1-d.scheller.oss@gmail.com>
References: <20170307185727.564-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

This moves the PLL SETUP code from stv0367ter_init() into a dedicated
function, and also make it possible to configure 58Mhz IC speed at
27MHz Xtal (used on STV0367-based DDB cards/modules in QAM mode).

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0367.c | 73 +++++++++++++++++++++++------------
 drivers/media/dvb-frontends/stv0367.h |  3 ++
 2 files changed, 51 insertions(+), 25 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index 5b52673..da10d9a 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -271,6 +271,53 @@ static void stv0367_write_table(struct stv0367_state *state,
 	}
 }
 
+static void stv0367_pll_setup(struct stv0367_state *state,
+				u32 icspeed, u32 xtal)
+{
+	/* note on regs: R367TER_* and R367CAB_* defines each point to
+	 * 0xf0d8, so just use R367TER_ for both cases
+	 */
+
+	switch (icspeed) {
+	case STV0367_ICSPEED_58000:
+		switch (xtal) {
+		default:
+		case 27000000:
+			dprintk("STV0367 SetCLKgen for 58MHz IC and 27Mhz crystal\n");
+			/* PLLMDIV: 27, PLLNDIV: 232 */
+			stv0367_writereg(state, R367TER_PLLMDIV, 0x1b);
+			stv0367_writereg(state, R367TER_PLLNDIV, 0xe8);
+			break;
+		}
+		break;
+	default:
+	case STV0367_ICSPEED_53125:
+		switch (xtal) {
+			/* set internal freq to 53.125MHz */
+		case 16000000:
+			stv0367_writereg(state, R367TER_PLLMDIV, 0x2);
+			stv0367_writereg(state, R367TER_PLLNDIV, 0x1b);
+			break;
+		case 25000000:
+			stv0367_writereg(state, R367TER_PLLMDIV, 0xa);
+			stv0367_writereg(state, R367TER_PLLNDIV, 0x55);
+			break;
+		default:
+		case 27000000:
+			dprintk("FE_STV0367TER_SetCLKgen for 27Mhz\n");
+			stv0367_writereg(state, R367TER_PLLMDIV, 0x1);
+			stv0367_writereg(state, R367TER_PLLNDIV, 0x8);
+			break;
+		case 30000000:
+			stv0367_writereg(state, R367TER_PLLMDIV, 0xc);
+			stv0367_writereg(state, R367TER_PLLNDIV, 0x55);
+			break;
+		}
+	}
+
+	stv0367_writereg(state, R367TER_PLLSETUP, 0x18);
+}
+
 static int stv0367ter_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	struct stv0367_state *state = fe->demodulator_priv;
@@ -918,31 +965,7 @@ static int stv0367ter_init(struct dvb_frontend *fe)
 	stv0367_write_table(state,
 		stv0367_deftabs[state->deftabs][STV0367_TAB_TER]);
 
-	switch (state->config->xtal) {
-		/*set internal freq to 53.125MHz */
-	case 16000000:
-		stv0367_writereg(state, R367TER_PLLMDIV, 0x2);
-		stv0367_writereg(state, R367TER_PLLNDIV, 0x1b);
-		stv0367_writereg(state, R367TER_PLLSETUP, 0x18);
-		break;
-	case 25000000:
-		stv0367_writereg(state, R367TER_PLLMDIV, 0xa);
-		stv0367_writereg(state, R367TER_PLLNDIV, 0x55);
-		stv0367_writereg(state, R367TER_PLLSETUP, 0x18);
-		break;
-	default:
-	case 27000000:
-		dprintk("FE_STV0367TER_SetCLKgen for 27Mhz\n");
-		stv0367_writereg(state, R367TER_PLLMDIV, 0x1);
-		stv0367_writereg(state, R367TER_PLLNDIV, 0x8);
-		stv0367_writereg(state, R367TER_PLLSETUP, 0x18);
-		break;
-	case 30000000:
-		stv0367_writereg(state, R367TER_PLLMDIV, 0xc);
-		stv0367_writereg(state, R367TER_PLLNDIV, 0x55);
-		stv0367_writereg(state, R367TER_PLLSETUP, 0x18);
-		break;
-	}
+	stv0367_pll_setup(state, STV0367_ICSPEED_53125, state->config->xtal);
 
 	stv0367_writereg(state, R367TER_I2CRPT, 0xa0);
 	stv0367_writereg(state, R367TER_ANACTRL, 0x00);
diff --git a/drivers/media/dvb-frontends/stv0367.h b/drivers/media/dvb-frontends/stv0367.h
index 26c38a0..aaa0236 100644
--- a/drivers/media/dvb-frontends/stv0367.h
+++ b/drivers/media/dvb-frontends/stv0367.h
@@ -25,6 +25,9 @@
 #include <linux/dvb/frontend.h>
 #include "dvb_frontend.h"
 
+#define STV0367_ICSPEED_53125	53125000
+#define STV0367_ICSPEED_58000	58000000
+
 struct stv0367_config {
 	u8 demod_address;
 	u32 xtal;
-- 
2.10.2
