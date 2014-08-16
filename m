Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:8368 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbaHPMjk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Aug 2014 08:39:40 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NAE000KTGI3L620@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 16 Aug 2014 08:39:39 -0400 (EDT)
Date: Sat, 16 Aug 2014 09:38:54 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: "nibble.max" <nibble.max@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>,
	"olli.salonen" <olli.salonen@iki.fi>
Subject: Re: [PATCH] m88ts2022: fix high symbol rate transponders missing on
 32bit platform.
Message-id: <20140816093854.39be5017.m.chehab@samsung.com>
In-reply-to: <201408161412275930052@gmail.com>
References: <201408161412275930052@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 16 Aug 2014 14:12:32 +0800
"nibble.max" <nibble.max@gmail.com> escreveu:

> The current m88ts2022 driver will miss the following high symbol rate transponders on Telstar 18 138.0.
> 12385 H 43200, 
> 12690 H 43200,
> 12538 V 41250...
> the code for f_3db_hz will overflow for the high symbol rate.
> for example, symbol rate=41250 KS/s
> symbol_rate * 135UL = 5568750000(1 4BEC 61B0), the value is larger than unsigned int on 32bit platform. 
> that makes the wrong result.
> Exchanging the div and mul position fixs it.
> 
> Signed-off-by: Nibble Max <nibble.max@gmail.com>
> ---
>  drivers/media/tuners/m88ts2022.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/tuners/m88ts2022.c b/drivers/media/tuners/m88ts2022.c
> index 40c42de..65c8acc 100644
> --- a/drivers/media/tuners/m88ts2022.c
> +++ b/drivers/media/tuners/m88ts2022.c
> @@ -314,7 +314,7 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
>  	div_min = gdiv28 * 78 / 100;
>  	div_max = clamp_val(div_max, 0U, 63U);
>  
> -	f_3db_hz = c->symbol_rate * 135UL / 200UL;
> +	f_3db_hz = (c->symbol_rate / 200UL) * 135UL;

Hmm... wouldn't this make worse for low symbol rates?

IMHO, the better is to use a u64 instead, and do_div64().

>  	f_3db_hz +=  2000000U + (frequency_offset_khz * 1000U);
>  	f_3db_hz = clamp(f_3db_hz, 7000000U, 40000000U);
> 

Regards,
-- 

Cheers,
Mauro
