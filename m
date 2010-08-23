Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39317 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab0HWTbh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Aug 2010 15:31:37 -0400
Received: by wyb32 with SMTP id 32so7158864wyb.19
        for <linux-media@vger.kernel.org>; Mon, 23 Aug 2010 12:31:36 -0700 (PDT)
Subject: [PATCH]STV0288 Incorrect bit sample for Vitterbi status.
From: tvbox <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Aug 2010 20:24:24 +0100
Message-ID: <1282591464.3596.21.camel@canaries-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

bit 3(LK) indicates that the Vstatus is locked.
Currently using bit 7(CF) which is usually present, results in early
aborted search in FEC_AUTO and missing channels.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

diff --git a/drivers/media/dvb/frontends/stv0288.c
b/drivers/media/dvb/frontends
index 2930a5d..bc9b47e 100644
--- a/drivers/media/dvb/frontends/stv0288.c
+++ b/drivers/media/dvb/frontends/stv0288.c
@@ -486,7 +486,7 @@ static int stv0288_set_frontend(struct dvb_frontend
*fe,
        tda[2] = 0x0; /* CFRL */
        for (tm = -6; tm < 7;) {
                /* Viterbi status */
-               if (stv0288_readreg(state, 0x24) & 0x80)
+               if (stv0288_readreg(state, 0x24) & 0x8)
                        break;
 
                tda[2] += 40;


