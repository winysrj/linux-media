Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422925Ab3DFNpt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Apr 2013 09:45:49 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans-Peter Jansen <hpj@urpla.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] cx24123: improve precision when calculating symbol rate ratio
Date: Sat,  6 Apr 2013 10:45:33 -0300
Message-Id: <1365255933-31611-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <2164572.6O2J60F4uN@xrated>
References: <2164572.6O2J60F4uN@xrated>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Symbol rate ratio were using a rough calculus, as the code was
limited to 32 bits arithmetic. Change it to 64 bits, in order
to better estimate the bandwidth low-pass filter on the demod.

This should reduce the noise and improve reception.

Reported-by: Hans-Peter Jansen <hpj@urpla.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/cx24123.c | 28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/media/dvb-frontends/cx24123.c b/drivers/media/dvb-frontends/cx24123.c
index 68c88ab..a771da3 100644
--- a/drivers/media/dvb-frontends/cx24123.c
+++ b/drivers/media/dvb-frontends/cx24123.c
@@ -26,6 +26,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <asm/div64.h>
 
 #include "dvb_frontend.h"
 #include "cx24123.h"
@@ -452,7 +453,8 @@ static u32 cx24123_int_log2(u32 a, u32 b)
 
 static int cx24123_set_symbolrate(struct cx24123_state *state, u32 srate)
 {
-	u32 tmp, sample_rate, ratio, sample_gain;
+	u64 tmp;
+	u32 sample_rate, ratio, sample_gain;
 	u8 pll_mult;
 
 	/*  check if symbol rate is within limits */
@@ -482,27 +484,11 @@ static int cx24123_set_symbolrate(struct cx24123_state *state, u32 srate)
 
 	sample_rate = pll_mult * XTAL;
 
-	/*
-	    SYSSymbolRate[21:0] = (srate << 23) / sample_rate
-
-	    We have to use 32 bit unsigned arithmetic without precision loss.
-	    The maximum srate is 45000000 or 0x02AEA540. This number has
-	    only 6 clear bits on top, hence we can shift it left only 6 bits
-	    at a time. Borrowed from cx24110.c
-	*/
-
-	tmp = srate << 6;
-	ratio = tmp / sample_rate;
-
-	tmp = (tmp % sample_rate) << 6;
-	ratio = (ratio << 6) + (tmp / sample_rate);
-
-	tmp = (tmp % sample_rate) << 6;
-	ratio = (ratio << 6) + (tmp / sample_rate);
-
-	tmp = (tmp % sample_rate) << 5;
-	ratio = (ratio << 5) + (tmp / sample_rate);
+	/* SYSSymbolRate[21:0] = (srate << 23) / sample_rate */
 
+	tmp = ((u64)srate) << 23;
+	do_div(tmp, sample_rate);
+	ratio = (u32) tmp;
 
 	cx24123_writereg(state, 0x01, pll_mult * 6);
 
-- 
1.8.1.4

