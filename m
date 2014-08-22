Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40245 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756098AbaHVK6b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Aug 2014 06:58:31 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Nibble Max <nibble.max@gmail.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	Evgeny Plehov <EvgenyPlehov@ukr.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL FINAL 14/21] m88ts2022: fix 32bit overflow on filter calc
Date: Fri, 22 Aug 2014 13:58:06 +0300
Message-Id: <1408705093-5167-15-git-send-email-crope@iki.fi>
In-Reply-To: <1408705093-5167-1-git-send-email-crope@iki.fi>
References: <1408705093-5167-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Maximum satellite symbol rate used is 45000000Sps which overflows
when multiplied by 135. As final calculation result is fraction,
we could use mult_frac macro in order to keep calculation inside
32 bit number limits and prevent overflow.

Original bug and fix was provided by Nibble Max. I decided to
implement it differently as it is now.

Reported-by: Nibble Max <nibble.max@gmail.com>
Tested-by: Nibble Max <nibble.max@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/m88ts2022.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/tuners/m88ts2022.c b/drivers/media/tuners/m88ts2022.c
index 40c42de..7a62097 100644
--- a/drivers/media/tuners/m88ts2022.c
+++ b/drivers/media/tuners/m88ts2022.c
@@ -314,7 +314,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	div_min = gdiv28 * 78 / 100;
 	div_max = clamp_val(div_max, 0U, 63U);
 
-	f_3db_hz = c->symbol_rate * 135UL / 200UL;
+	f_3db_hz = mult_frac(c->symbol_rate, 135, 200);
 	f_3db_hz +=  2000000U + (frequency_offset_khz * 1000U);
 	f_3db_hz = clamp(f_3db_hz, 7000000U, 40000000U);
 
-- 
http://palosaari.fi/

