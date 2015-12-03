Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:56157 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755946AbbLCOP3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2015 09:15:29 -0500
Date: Thu, 3 Dec 2015 12:15:24 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: linux-media@vger.kernel.org, crope@iki.fi, xpert-reactos@gmx.de
Subject: Re: [PATCH 07/10] si2165: Fix DVB-T bandwidth default
Message-ID: <20151203121524.33bd3130@recife.lan>
In-Reply-To: <1447963442-9764-8-git-send-email-zzam@gentoo.org>
References: <1447963442-9764-1-git-send-email-zzam@gentoo.org>
	<1447963442-9764-8-git-send-email-zzam@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 19 Nov 2015 21:03:59 +0100
Matthias Schwarzott <zzam@gentoo.org> escreveu:


Please, add a description to your patches.

That's said, this patch should be called, instead:

si2165: Fix DVB-T bandwidth auto

DVB auto bandwidth mode (bandwidth_hz == 0) logic was setting
the initial value for dvb_rate to a wrong value. Fix it.

as a zero value here means to let the frontend to auto-detect
the bandwidth. Of course, assuming that si2165 is capable of
doing that.

If si2165 chip or driver doesn't support bandwidth auto-detection, it
should, instead, return -EINVAL.

Are you sure that it will auto-detect the bandwidth if we keep it
as 8MHz?

Regards,
Mauro





> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> ---
>  drivers/media/dvb-frontends/si2165.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
> index 807a3c9..e97b0e6 100644
> --- a/drivers/media/dvb-frontends/si2165.c
> +++ b/drivers/media/dvb-frontends/si2165.c
> @@ -811,19 +811,18 @@ static int si2165_set_frontend(struct dvb_frontend *fe)
>  	u8 val[3];
>  	u32 dvb_rate = 0;
>  	u16 bw10k;
> +	u32 bw_hz = p->bandwidth_hz;
>  
>  	dprintk("%s: called\n", __func__);
>  
>  	if (!state->has_dvbt)
>  		return -EINVAL;
>  
> -	if (p->bandwidth_hz > 0) {
> -		dvb_rate = p->bandwidth_hz * 8 / 7;
> -		bw10k = p->bandwidth_hz / 10000;
> -	} else {
> -		dvb_rate = 8 * 8 / 7;
> -		bw10k = 800;
> -	}
> +	if (bw_hz == 0)
> +		bw_hz = 8000000;
> +
> +	dvb_rate = bw_hz * 8 / 7;
> +	bw10k = bw_hz / 10000;
>  
>  	/* standard = DVB-T */
>  	ret = si2165_writereg8(state, 0x00ec, 0x01);
