Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36052 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbeIOLFc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Sep 2018 07:05:32 -0400
From: Nathan Chancellor <natechancellor@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] [media] dib7000p: Remove dead code
Date: Fri, 14 Sep 2018 22:47:39 -0700
Message-Id: <20180915054739.14117-1-natechancellor@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clang warns that 'interleaving' is assigned to itself in this function.

drivers/media/dvb-frontends/dib7000p.c:1874:15: warning: explicitly
assigning value of variable of type 'int' to itself [-Wself-assign]
        interleaving = interleaving;
        ~~~~~~~~~~~~ ^ ~~~~~~~~~~~~
1 warning generated.

It's correct. Just removing the self-assignment would sufficiently hide
the warning but all of this code is dead because 'tmp' is zero due to
being multiplied by zero. This doesn't appear to be an issue with
dib8000, which this code was copied from in commit 041ad449683b
("[media] dib7000p: Add DVBv5 stats support").

Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/media/dvb-frontends/dib7000p.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
index 58387860b62d..25843658fc68 100644
--- a/drivers/media/dvb-frontends/dib7000p.c
+++ b/drivers/media/dvb-frontends/dib7000p.c
@@ -1800,9 +1800,8 @@ static u32 dib7000p_get_time_us(struct dvb_frontend *demod)
 {
 	struct dtv_frontend_properties *c = &demod->dtv_property_cache;
 	u64 time_us, tmp64;
-	u32 tmp, denom;
-	int guard, rate_num, rate_denum = 1, bits_per_symbol;
-	int interleaving = 0, fft_div;
+	u32 denom;
+	int guard, rate_num, rate_denum = 1, bits_per_symbol, fft_div;
 
 	switch (c->guard_interval) {
 	case GUARD_INTERVAL_1_4:
@@ -1871,8 +1870,6 @@ static u32 dib7000p_get_time_us(struct dvb_frontend *demod)
 		break;
 	}
 
-	interleaving = interleaving;
-
 	denom = bits_per_symbol * rate_num * fft_div * 384;
 
 	/* If calculus gets wrong, wait for 1s for the next stats */
@@ -1887,9 +1884,6 @@ static u32 dib7000p_get_time_us(struct dvb_frontend *demod)
 	time_us += denom / 2;
 	do_div(time_us, denom);
 
-	tmp = 1008 * 96 * interleaving;
-	time_us += tmp + tmp / guard;
-
 	return time_us;
 }
 
-- 
2.18.0
