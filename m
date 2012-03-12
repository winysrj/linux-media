Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48888 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756953Ab2CLT67 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Mar 2012 15:58:59 -0400
Message-ID: <4F5E557D.5000403@iki.fi>
Date: Mon, 12 Mar 2012 21:58:53 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: gennarone@gmail.com
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux-Next <linux-next@vger.kernel.org>
Subject: Re: rtl2830: __udivdi3 undefined
References: <CAMuHMdVmiqY9uh574_uTK76+28bvhEL0BPnzjDF-bf-0mgj4gg@mail.gmail.com> <4F53EA7D.4090402@gmail.com>
In-Reply-To: <4F53EA7D.4090402@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05.03.2012 00:19, Gianluca Gennari wrote:
> Il 29/02/2012 22:30, Geert Uytterhoeven ha scritto:
>> http://kisskb.ellerman.id.au/kisskb/buildresult/5759200/ ERROR:
>> "__udivdi3" [drivers/media/dvb/frontends/rtl2830.ko] undefined!
>>
>> I didn't look too deeply into it, but I think it's caused by the
>> "num /= priv->cfg.xtal" in rtl2830_init() (with num being u64).
>>
>> Can't it use do_div() instead?
>>
>> Gr{oetje,eeting}s,
>>
>> Geert
>>
>> -- Geert Uytterhoeven -- There's lots of Linux beyond ia32 --
>> geert@linux-m68k.org
>>
>> In personal conversations with technical people, I call myself a
>> hacker. But when I'm talking to journalists I just say "programmer"
>> or something like that. -- Linus Torvalds -- To unsubscribe from this
>> list: send the line "unsubscribe linux-media" in the body of a
>> message to majordomo@vger.kernel.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
>>
>
> Probably the best solution is to use div_u64.
> The following patch fixed the warning on my 32 bit system.
>
> Signed-off-by: Gianluca Gennari<gennarone@gmail.com>
> ---
>   drivers/media/dvb/frontends/rtl2830.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/dvb/frontends/rtl2830.c
> b/drivers/media/dvb/frontends/rtl2830.c
> index f971d94..45196c5 100644
> --- a/drivers/media/dvb/frontends/rtl2830.c
> +++ b/drivers/media/dvb/frontends/rtl2830.c
> @@ -244,7 +244,7 @@ static int rtl2830_init(struct dvb_frontend *fe)
>
>   	num = priv->cfg.if_dvbt % priv->cfg.xtal;
>   	num *= 0x400000;
> -	num /= priv->cfg.xtal;
> +	num = div_u64(num, priv->cfg.xtal);
>   	num = -num;
>   	if_ctl = num&  0x3fffff;
>   	dbg("%s: if_ctl=%08x", __func__, if_ctl);

Acked-by: Antti Palosaari <crope@iki.fi>

I have been two weeks on skiing trip and since didn't acked that earlier.


regards
Antti

-- 
http://palosaari.fi/
