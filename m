Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50193 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab0H1Uul (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Aug 2010 16:50:41 -0400
Received: by wwb28 with SMTP id 28so5347253wwb.1
        for <linux-media@vger.kernel.org>; Sat, 28 Aug 2010 13:50:40 -0700 (PDT)
Subject: [PATCH]STV0288 Incorrect bit sample for Vitterbi status.
From: tvbox <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 28 Aug 2010 21:50:25 +0100
Message-ID: <1283028625.2708.6.camel@canaries-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

bit 3(LK) indicates that the Vstatus is locked.
Currently using bit 7(CF) which is usually present, results in early
aborted search in FEC_AUTO and missing channels.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>



diff --git a/linux/drivers/media/dvb/frontends/stv0288.c b/linux/drivers/media/dvb/frontends/stv0288.c
index 2930a5d..bc9b47e 100644
--- a/linux/drivers/media/dvb/frontends/stv0288.c
+++ b/linux/drivers/media/dvb/frontends/stv0288.c
@@ -486,7 +486,7 @@ static int stv0288_set_frontend(struct dvb_frontend *fe,
 	tda[2] = 0x0; /* CFRL */
 	for (tm = -6; tm < 7;) {
 		/* Viterbi status */
-		if (stv0288_readreg(state, 0x24) & 0x80)
+		if (stv0288_readreg(state, 0x24) & 0x8)
 			break;
 
 		tda[2] += 40;

