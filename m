Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:37527 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933262AbdKAVGI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 17:06:08 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH v2 04/26] media: tda8290: initialize agc gain
Date: Wed,  1 Nov 2017 17:05:41 -0400
Message-Id: <b2551ab8a898cf051566173234a94d7dca5d1bd8.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The tuning logic at tda8290 relies on agc_stat and
adc_sat to be initialized. However, as warned by smatch:

	drivers/media/tuners/tda8290.c:261 tda8290_set_params() error: uninitialized symbol 'agc_stat'.
	drivers/media/tuners/tda8290.c:261 tda8290_set_params() error: uninitialized symbol 'adc_sat'.
	drivers/media/tuners/tda8290.c:262 tda8290_set_params() error: uninitialized symbol 'adc_sat'.

That could cause an erratic behavior if PLL is not locked,
as the code will only work if
	!(pll_stat & 0x80) && (adc_sat < 20)

So, initialize it to zero, in order to let the code below
to be called, with should give more chances to adjust the
tuner gain, in order to get a PLL lock.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/tuners/tda8290.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/tuners/tda8290.c b/drivers/media/tuners/tda8290.c
index a59c567c55d6..f226e6ecc175 100644
--- a/drivers/media/tuners/tda8290.c
+++ b/drivers/media/tuners/tda8290.c
@@ -196,7 +196,7 @@ static void tda8290_set_params(struct dvb_frontend *fe,
 	unsigned char addr_adc_sat  = 0x1a;
 	unsigned char addr_agc_stat = 0x1d;
 	unsigned char addr_pll_stat = 0x1b;
-	unsigned char adc_sat, agc_stat,
+	unsigned char adc_sat = 0, agc_stat = 0,
 		      pll_stat;
 	int i;
 
-- 
2.13.6
