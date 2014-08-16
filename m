Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:62281 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaHPGNB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Aug 2014 02:13:01 -0400
Received: by mail-pd0-f170.google.com with SMTP id g10so4497249pdj.1
        for <linux-media@vger.kernel.org>; Fri, 15 Aug 2014 23:12:32 -0700 (PDT)
Date: Sat, 16 Aug 2014 14:12:32 +0800
From: "nibble.max" <nibble.max@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
Cc: "linux-media" <linux-media@vger.kernel.org>,
	"olli.salonen" <olli.salonen@iki.fi>
Subject: [PATCH] m88ts2022: fix high symbol rate transponders missing on 32bit platform.
Message-ID: <201408161412275930052@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current m88ts2022 driver will miss the following high symbol rate transponders on Telstar 18 138.0.
12385 H 43200, 
12690 H 43200,
12538 V 41250...
the code for f_3db_hz will overflow for the high symbol rate.
for example, symbol rate=41250 KS/s
symbol_rate * 135UL = 5568750000(1 4BEC 61B0), the value is larger than unsigned int on 32bit platform. 
that makes the wrong result.
Exchanging the div and mul position fixs it.

Signed-off-by: Nibble Max <nibble.max@gmail.com>
---
 drivers/media/tuners/m88ts2022.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/tuners/m88ts2022.c b/drivers/media/tuners/m88ts2022.c
index 40c42de..65c8acc 100644
--- a/drivers/media/tuners/m88ts2022.c
+++ b/drivers/media/tuners/m88ts2022.c
@@ -314,7 +314,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	div_min = gdiv28 * 78 / 100;
 	div_max = clamp_val(div_max, 0U, 63U);
 
-	f_3db_hz = c->symbol_rate * 135UL / 200UL;
+	f_3db_hz = (c->symbol_rate / 200UL) * 135UL;
 	f_3db_hz +=  2000000U + (frequency_offset_khz * 1000U);
 	f_3db_hz = clamp(f_3db_hz, 7000000U, 40000000U);

-- 
1.9.1

