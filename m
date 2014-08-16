Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:49737 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbaHPNbR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Aug 2014 09:31:17 -0400
Received: by mail-pd0-f172.google.com with SMTP id y13so4794506pdi.31
        for <linux-media@vger.kernel.org>; Sat, 16 Aug 2014 06:31:13 -0700 (PDT)
Date: Sat, 16 Aug 2014 21:31:05 +0800
From: "Max Xiang" <nibble.max@gmail.com>
To: "Mauro Carvalho Chehab" <m.chehab@samsung.com>
Cc: "Antti Palosaari" <crope@iki.fi>,
	"linux-media" <linux-media@vger.kernel.org>,
	"olli.salonen" <olli.salonen@iki.fi>
References: <201408161412275930052@gmail.com>
Subject: Re: Re: [PATCH] m88ts2022: fix high symbol rate transponders missing on32bit platform.
Message-ID: <201408162131013597260@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="=====001_Dragon877687681000_====="
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

--=====001_Dragon877687681000_=====
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit

>Em Sat, 16 Aug 2014 14:12:32 +0800
>"nibble.max" <nibble.max@gmail.com> escreveu:
>
>> The current m88ts2022 driver will miss the following high symbol rate transponders on Telstar 18 138.0.
>> 12385 H 43200, 
>> 12690 H 43200,
>> 12538 V 41250...
>> the code for f_3db_hz will overflow for the high symbol rate.
>> for example, symbol rate=41250 KS/s
>> symbol_rate * 135UL = 5568750000(1 4BEC 61B0), the value is larger than unsigned int on 32bit platform. 
>> that makes the wrong result.
>> Exchanging the div and mul position fixs it.
>> 
>> Signed-off-by: Nibble Max <nibble.max@gmail.com>
>> ---
>>  drivers/media/tuners/m88ts2022.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/drivers/media/tuners/m88ts2022.c b/drivers/media/tuners/m88ts2022.c
>> index 40c42de..65c8acc 100644
>> --- a/drivers/media/tuners/m88ts2022.c
>> +++ b/drivers/media/tuners/m88ts2022.c
>> @@ -314,7 +314,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
>>  	div_min = gdiv28 * 78 / 100;
>>  	div_max = clamp_val(div_max, 0U, 63U);
>>  
>> -	f_3db_hz = c->symbol_rate * 135UL / 200UL;
>> +	f_3db_hz = (c->symbol_rate / 200UL) * 135UL;
>
>Hmm... wouldn't this make worse for low symbol rates?
>
The unit of symbol rate for Satellite is KS/s(1000S/s).
So it is safe to divide 200 at the first.
>IMHO, the better is to use a u64 instead, and do_div64().
>
>>  	f_3db_hz +=  2000000U + (frequency_offset_khz * 1000U);
>>  	f_3db_hz = clamp(f_3db_hz, 7000000U, 40000000U);
>> 
>
>Regards,
>-- 
>
>Cheers,
>Mauro
--=====001_Dragon877687681000_=====
Content-Type: text/x-vcard;
	name="nibble.max(3).vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="nibble.max(3).vcf"

QkVHSU46VkNBUkQNClZFUlNJT046Mi4xDQpOOm5pYmJsZS5tYXg7DQpGTjpuaWJibGUubWF4DQpF
TUFJTDtQUkVGO0lOVEVSTkVUOm5pYmJsZS5tYXhAZ21haWwuY29tDQpSRVY6MjAxNDA4MTZUMjEz
MTAxWg0KRU5EOlZDQVJEDQo=

--=====001_Dragon877687681000_=====--

