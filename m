Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:46625 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497AbaHVCcR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 22:32:17 -0400
Received: by mail-pa0-f42.google.com with SMTP id lf10so15864979pab.29
        for <linux-media@vger.kernel.org>; Thu, 21 Aug 2014 19:32:17 -0700 (PDT)
Date: Fri, 22 Aug 2014 10:32:19 +0800
From: "Nibble Max" <nibble.max@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
Cc: "linux-media" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] m88ts2022: fix 32bit overflow on filter calc
Message-ID: <201408221032169538955@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="=====001_Dragon032238681470_====="
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

--=====001_Dragon032238681470_=====
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit

It works with the high symbol rate transponders.

Tested-by: Nibble Max <nibble.max@gmail.com>

>Maximum satellite symbol rate used is 45000000Sps which overflows
>when multiplied by 135. As final calculation result is fraction,
>we could use mult_frac macro in order to keep calculation inside
>32 bit number limits and prevent overflow.
>
>Original bug and fix was provided by Nibble Max. I decided to
>implement it differently as it is now.
>
>Reported-by: Nibble Max <nibble.max@gmail.com>
>Cc: <stable@kernel.org>
>Signed-off-by: Antti Palosaari <crope@iki.fi>
>---
> drivers/media/tuners/m88ts2022.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/media/tuners/m88ts2022.c b/drivers/media/tuners/m88ts2022.c
>index 40c42de..7a62097 100644
>--- a/drivers/media/tuners/m88ts2022.c
>+++ b/drivers/media/tuners/m88ts2022.c
>@@ -314,7 +314,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
> 	div_min = gdiv28 * 78 / 100;
> 	div_max = clamp_val(div_max, 0U, 63U);
> 
>-	f_3db_hz = c->symbol_rate * 135UL / 200UL;
>+	f_3db_hz = mult_frac(c->symbol_rate, 135, 200);
> 	f_3db_hz +=  2000000U + (frequency_offset_khz * 1000U);
> 	f_3db_hz = clamp(f_3db_hz, 7000000U, 40000000U);
> 
>-- 
>http://palosaari.fi/
>
--=====001_Dragon032238681470_=====
Content-Type: text/x-vcard;
	name="nibble.max(1).vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="nibble.max(1).vcf"

QkVHSU46VkNBUkQNClZFUlNJT046Mi4xDQpOOm5pYmJsZS5tYXg7DQpGTjpuaWJibGUubWF4DQpF
TUFJTDtQUkVGO0lOVEVSTkVUOm5pYmJsZS5tYXhAZ21haWwuY29tDQpSRVY6MjAxNDA4MjJUMTAz
MjE2Wg0KRU5EOlZDQVJEDQo=

--=====001_Dragon032238681470_=====--

