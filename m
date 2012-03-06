Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55958 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab2CFSCE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 13:02:04 -0500
MIME-Version: 1.0
In-Reply-To: <4F53EA7D.4090402@gmail.com>
References: <CAMuHMdVmiqY9uh574_uTK76+28bvhEL0BPnzjDF-bf-0mgj4gg@mail.gmail.com>
	<4F53EA7D.4090402@gmail.com>
Date: Tue, 6 Mar 2012 19:02:02 +0100
Message-ID: <CAMuHMdVE2m-Q+ikyEE5V9dd9cbqCbCC2+CtnkDhq=UTQg2detQ@mail.gmail.com>
Subject: Re: rtl2830: __udivdi3 undefined
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: gennarone@gmail.com
Cc: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 4, 2012 at 23:19, Gianluca Gennari <gennarone@gmail.com> wrote:
> Probably the best solution is to use div_u64.
> The following patch fixed the warning on my 32 bit system.
>
> Signed-off-by: Gianluca Gennari <gennarone@gmail.com>

Thanks, that fixes it (div_u64() is do_div() on 32-bit).

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
>  drivers/media/dvb/frontends/rtl2830.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/dvb/frontends/rtl2830.c
> b/drivers/media/dvb/frontends/rtl2830.c
> index f971d94..45196c5 100644
> --- a/drivers/media/dvb/frontends/rtl2830.c
> +++ b/drivers/media/dvb/frontends/rtl2830.c
> @@ -244,7 +244,7 @@ static int rtl2830_init(struct dvb_frontend *fe)
>
>        num = priv->cfg.if_dvbt % priv->cfg.xtal;
>        num *= 0x400000;
> -       num /= priv->cfg.xtal;
> +       num = div_u64(num, priv->cfg.xtal);
>        num = -num;
>        if_ctl = num & 0x3fffff;
>        dbg("%s: if_ctl=%08x", __func__, if_ctl);

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
