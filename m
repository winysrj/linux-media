Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33275 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab3L1RDD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 12:03:03 -0500
Received: by mail-wi0-f178.google.com with SMTP id bz8so10443209wib.17
        for <linux-media@vger.kernel.org>; Sat, 28 Dec 2013 09:03:01 -0800 (PST)
Received: from [192.168.1.100] (188.29.109.137.threembb.co.uk. [188.29.109.137])
        by mx.google.com with ESMTPSA id cx3sm60704038wib.0.2013.12.28.09.03.00
        for <linux-media@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Sat, 28 Dec 2013 09:03:00 -0800 (PST)
Message-ID: <1388250164.5893.3.camel@canaries32-MCP7A>
Subject: [PATCH 2/3] m88rs2000: Correct m88rs2000_set_fec settings.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Sat, 28 Dec 2013 17:02:44 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Register 0x70 is used to set fec, register 0x76 is used to get fec

Register 0x76 is set to 0x8.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb-frontends/m88rs2000.c | 37 +++++++++++++++++----------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88rs2000.c b/drivers/media/dvb-frontends/m88rs2000.c
index f9d04db..002b109 100644
--- a/drivers/media/dvb-frontends/m88rs2000.c
+++ b/drivers/media/dvb-frontends/m88rs2000.c
@@ -541,33 +541,38 @@ static int m88rs2000_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 static int m88rs2000_set_fec(struct m88rs2000_state *state,
 		fe_code_rate_t fec)
 {
-	u16 fec_set;
+	u8 fec_set, reg;
+	int ret;
+
 	switch (fec) {
-	/* This is not confirmed kept for reference */
-/*	case FEC_1_2:
-		fec_set = 0x88;
+	case FEC_1_2:
+		fec_set = 0x8;
 		break;
 	case FEC_2_3:
-		fec_set = 0x68;
+		fec_set = 0x10;
 		break;
 	case FEC_3_4:
-		fec_set = 0x48;
+		fec_set = 0x20;
 		break;
 	case FEC_5_6:
-		fec_set = 0x28;
+		fec_set = 0x40;
 		break;
 	case FEC_7_8:
-		fec_set = 0x18;
-		break; */
+		fec_set = 0x80;
+		break;
 	case FEC_AUTO:
 	default:
-		fec_set = 0x08;
+		fec_set = 0x0;
 	}
-	m88rs2000_writereg(state, 0x76, fec_set);
 
-	return 0;
-}
+	reg = m88rs2000_readreg(state, 0x70);
+	reg &= 0x7;
+	ret = m88rs2000_writereg(state, 0x70, reg | fec_set);
 
+	ret |= m88rs2000_writereg(state, 0x76, 0x8);
+
+	return ret;
+}
 
 static fe_code_rate_t m88rs2000_get_fec(struct m88rs2000_state *state)
 {
@@ -650,12 +655,8 @@ static int m88rs2000_set_frontend(struct dvb_frontend *fe)
 	if (ret < 0)
 		return -ENODEV;
 
-	/* Unknown */
-	reg = m88rs2000_readreg(state, 0x70);
-	ret = m88rs2000_writereg(state, 0x70, reg);
-
 	/* Set FEC */
-	ret |= m88rs2000_set_fec(state, c->fec_inner);
+	ret = m88rs2000_set_fec(state, c->fec_inner);
 	ret |= m88rs2000_writereg(state, 0x85, 0x1);
 	ret |= m88rs2000_writereg(state, 0x8a, 0xbf);
 	ret |= m88rs2000_writereg(state, 0x8d, 0x1e);
-- 
1.8.5.2


