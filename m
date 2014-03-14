Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49061 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755612AbaCNTZq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Mar 2014 15:25:46 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] e4000: fix 32-bit build error
Date: Fri, 14 Mar 2014 21:25:27 +0200
Message-Id: <1394825128-8584-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All error/warnings:
   drivers/built-in.o: In function `e4000_set_params':
>> e4000.c:(.text+0x1219a1b): undefined reference to `__umoddi3'

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/e4000.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index 3b52550..67ecf1b 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -116,6 +116,7 @@ static int e4000_set_params(struct dvb_frontend *fe)
 	struct e4000 *s = fe->tuner_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i, sigma_delta;
+	unsigned int pll_n, pll_f;
 	u64 f_vco;
 	u8 buf[5], i_data[4], q_data[4];
 
@@ -141,8 +142,9 @@ static int e4000_set_params(struct dvb_frontend *fe)
 	}
 
 	f_vco = 1ull * c->frequency * e4000_pll_lut[i].mul;
-	sigma_delta = div_u64(0x10000ULL * (f_vco % s->clock), s->clock);
-	buf[0] = div_u64(f_vco, s->clock);
+	pll_n = div_u64_rem(f_vco, s->clock, &pll_f);
+	sigma_delta = div_u64(0x10000ULL * pll_f, s->clock);
+	buf[0] = pll_n;
 	buf[1] = (sigma_delta >> 0) & 0xff;
 	buf[2] = (sigma_delta >> 8) & 0xff;
 	buf[3] = 0x00;
-- 
1.8.5.3

