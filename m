Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:37843 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757102Ab0BBWwK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Feb 2010 17:52:10 -0500
Received: by fxm7 with SMTP id 7so744001fxm.28
        for <linux-media@vger.kernel.org>; Tue, 02 Feb 2010 14:52:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201002022240.o12MeokZ018918@imap1.linux-foundation.org>
References: <201002022240.o12MeokZ018918@imap1.linux-foundation.org>
Date: Wed, 3 Feb 2010 02:52:08 +0400
Message-ID: <1a297b361002021452h70891746md39e9d5491c3fb20@mail.gmail.com>
Subject: Re: [patch 6/7] drivers/media/dvb/frontends/stv090x.c: fix
	use-uninitialised
From: Manu Abraham <abraham.manu@gmail.com>
To: akpm@linux-foundation.org
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
	manu@linuxtv.org, mchehab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 3, 2010 at 2:40 AM,  <akpm@linux-foundation.org> wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
>
> drivers/media/dvb/frontends/stv090x.c: In function 'stv090x_blind_search':
> drivers/media/dvb/frontends/stv090x.c:1967: warning: 'coarse_fail' may be used uninitialized in this function
>
> Cc: Manu Abraham <manu@linuxtv.org>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  drivers/media/dvb/frontends/stv090x.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff -puN drivers/media/dvb/frontends/stv090x.c~drivers-media-dvb-frontends-stv090xc-fix-use-uninitialised drivers/media/dvb/frontends/stv090x.c
> --- a/drivers/media/dvb/frontends/stv090x.c~drivers-media-dvb-frontends-stv090xc-fix-use-uninitialised
> +++ a/drivers/media/dvb/frontends/stv090x.c
> @@ -1964,7 +1964,8 @@ static int stv090x_blind_search(struct s
>        u32 agc2, reg, srate_coarse;
>        s32 cpt_fail, agc2_ovflw, i;
>        u8 k_ref, k_max, k_min;
> -       int coarse_fail, lock;
> +       int coarse_fail = 0;
> +       int lock;
>
>        k_max = 110;
>        k_min = 10;
> _
>

Looks good

Reviewed-by: Manu Abraham <manu@linuxtv.org>
Acked-by: Manu Abraham <manu@linuxtv.org>

Thanks,
Manu
