Return-path: <linux-media-owner@vger.kernel.org>
Received: from racoon.tvdr.de ([188.40.50.18]:33906 "EHLO racoon.tvdr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757909Ab2FBPLc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Jun 2012 11:11:32 -0400
Received: from dolphin.tvdr.de (dolphin.tvdr.de [192.168.100.2])
	by racoon.tvdr.de (8.14.3/8.14.3) with ESMTP id q52F55XT024654
	for <linux-media@vger.kernel.org>; Sat, 2 Jun 2012 17:05:05 +0200
Received: from [192.168.100.10] (hawk.tvdr.de [192.168.100.10])
	by dolphin.tvdr.de (8.14.4/8.14.4) with ESMTP id q52F4Hbv031354
	for <linux-media@vger.kernel.org>; Sat, 2 Jun 2012 17:04:18 +0200
Message-ID: <4FCA2B71.7060700@tvdr.de>
Date: Sat, 02 Jun 2012 17:04:17 +0200
From: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] DVB: stb0899: speed up getting BER values
Content-Type: multipart/mixed;
 boundary="------------040400080106060402040205"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040400080106060402040205
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

stb0899_read_ber() takes 500ms (half a second!) to deliver the current
BER value. Apparently it takes 5 subsequent readings, with a 100ms pause
between them (and even before the first one). This is a real performance
brake if an application freqeuently reads the BER of several devices.
The attached patch reduces this to a single reading, with no more pausing.
I didn't observe any negative side effects of this change.

Signed-off-by: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>

Klaus

--------------040400080106060402040205
Content-Type: text/x-patch;
 name="04-stb0899-ber_no_msleep.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="04-stb0899-ber_no_msleep.diff"

--- a/linux/drivers/media/dvb/frontends/stb0899_drv.c	2012-04-23 15:10:35.994008188 +0200
+++ a/linux/drivers/media/dvb/frontends/stb0899_drv.c	2012-04-23 15:29:40.544837905 +0200
@@ -1135,7 +1135,6 @@
 	struct stb0899_internal *internal	= &state->internal;
 
 	u8  lsb, msb;
-	u32 i;
 
 	*ber = 0;
 
@@ -1143,14 +1142,9 @@
 	case SYS_DVBS:
 	case SYS_DSS:
 		if (internal->lock) {
-			/* average 5 BER values	*/
-			for (i = 0; i < 5; i++) {
-				msleep(100);
-				lsb = stb0899_read_reg(state, STB0899_ECNT1L);
-				msb = stb0899_read_reg(state, STB0899_ECNT1M);
-				*ber += MAKEWORD16(msb, lsb);
-			}
-			*ber /= 5;
+			lsb = stb0899_read_reg(state, STB0899_ECNT1L);
+			msb = stb0899_read_reg(state, STB0899_ECNT1M);
+			*ber = MAKEWORD16(msb, lsb);
 			/* Viterbi Check	*/
 			if (STB0899_GETFIELD(VSTATUS_PRFVIT, internal->v_status)) {
 				/* Error Rate		*/
@@ -1163,13 +1157,9 @@
 		break;
 	case SYS_DVBS2:
 		if (internal->lock) {
-			/* Average 5 PER values	*/
-			for (i = 0; i < 5; i++) {
-				msleep(100);
-				lsb = stb0899_read_reg(state, STB0899_ECNT1L);
-				msb = stb0899_read_reg(state, STB0899_ECNT1M);
-				*ber += MAKEWORD16(msb, lsb);
-			}
+			lsb = stb0899_read_reg(state, STB0899_ECNT1L);
+			msb = stb0899_read_reg(state, STB0899_ECNT1M);
+			*ber = MAKEWORD16(msb, lsb);
 			/* ber = ber * 10 ^ 7	*/
 			*ber *= 10000000;
 			*ber /= (-1 + (1 << (4 + 2 * STB0899_GETFIELD(NOE, internal->err_ctrl))));

--------------040400080106060402040205--
