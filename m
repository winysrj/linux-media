Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:44943 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187Ab0BBWtg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Feb 2010 17:49:36 -0500
Received: by fxm7 with SMTP id 7so741042fxm.28
        for <linux-media@vger.kernel.org>; Tue, 02 Feb 2010 14:49:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201002022240.o12MepBf018922@imap1.linux-foundation.org>
References: <201002022240.o12MepBf018922@imap1.linux-foundation.org>
Date: Wed, 3 Feb 2010 02:49:34 +0400
Message-ID: <1a297b361002021449q16cf18aasde504e34219bf30@mail.gmail.com>
Subject: Re: [patch 7/7] drivers/media/dvb/frontends/stv090x.c: fix
	use-uninitlalised
From: Manu Abraham <abraham.manu@gmail.com>
To: akpm@linux-foundation.org
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
	manu@linuxtv.org, mchehab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrew,

On Wed, Feb 3, 2010 at 2:40 AM,  <akpm@linux-foundation.org> wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
>
> Mad guess.
>
> Cc: Manu Abraham <manu@linuxtv.org>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  drivers/media/dvb/frontends/stv090x.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff -puN drivers/media/dvb/frontends/stv090x.c~drivers-media-dvb-frontends-stv090xc-fix-use-uninitlalised drivers/media/dvb/frontends/stv090x.c
> --- a/drivers/media/dvb/frontends/stv090x.c~drivers-media-dvb-frontends-stv090xc-fix-use-uninitlalised
> +++ a/drivers/media/dvb/frontends/stv090x.c
> @@ -2047,7 +2047,7 @@ static int stv090x_chk_tmg(struct stv090
>        u32 reg;
>        s32 tmg_cpt = 0, i;
>        u8 freq, tmg_thh, tmg_thl;
> -       int tmg_lock;
> +       int tmg_lock = 0;
>
>        freq = STV090x_READ_DEMOD(state, CARFREQ);
>        tmg_thh = STV090x_READ_DEMOD(state, TMGTHRISE);
> _
>

Looks good

Reviewed-by: Manu Abraham <manu@linuxtv.org>
Acked-by: Manu Abraham <manu@linuxtv.org>

Thanks,
Manu
