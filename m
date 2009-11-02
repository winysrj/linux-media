Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54134 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932378AbZKBUhJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Nov 2009 15:37:09 -0500
Message-ID: <4AEF3FB5.9080001@gmx.de>
Date: Mon, 02 Nov 2009 21:23:17 +0100
From: Andreas Regel <andreas.regel@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] stv6110x: fix r divider calculation
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixed the calculation of the r divider in stv6110x_set_frequency. It had always the value 3 no matter what frequency was given.

Signed-off-by: Andreas Regel <andreas.regel@gmx.de>

diff -r 43878f8dbfb0 linux/drivers/media/dvb/frontends/stv6110x.c
--- a/linux/drivers/media/dvb/frontends/stv6110x.c	Sun Nov 01 07:17:46 2009 -0200
+++ b/linux/drivers/media/dvb/frontends/stv6110x.c	Mon Nov 02 21:02:22 2009 +0100
@@ -95,7 +95,7 @@
 {
 	struct stv6110x_state *stv6110x = fe->tuner_priv;
 	u32 rDiv, divider;
-	s32 pVal, pCalc, rDivOpt = 0;
+	s32 pVal, pCalc, rDivOpt = 0, pCalcOpt = 1000;
 	u8 i;
 
 	STV6110x_SETFIELD(stv6110x_regs[STV6110x_CTRL1], CTRL1_K, (REFCLOCK_MHz - 16));
@@ -121,8 +121,10 @@
 	for (rDiv = 0; rDiv <= 3; rDiv++) {
 		pCalc = (REFCLOCK_kHz / 100) / R_DIV(rDiv);
 
-		if ((abs((s32)(pCalc - pVal))) < (abs((s32)(1000 - pVal))))
+		if ((abs((s32)(pCalc - pVal))) < (abs((s32)(pCalcOpt - pVal))))
 			rDivOpt = rDiv;
+
+		pCalcOpt = (REFCLOCK_kHz / 100) / R_DIV(rDivOpt);
 	}
 
 	divider = (frequency * R_DIV(rDivOpt) * pVal) / REFCLOCK_kHz;
