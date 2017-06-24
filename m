Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36116
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751081AbdFXSfq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Jun 2017 14:35:46 -0400
Date: Sat, 24 Jun 2017 15:35:38 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: linux-media@vger.kernel.org, aospan@netup.ru, serjk@netup.ru,
        mchehab@kernel.org
Subject: Re: [PATCH] [media] dvb-frontends/cxd2841er: require FE_HAS_SYNC
 for agc readout
Message-ID: <20170624153538.711af53a@vento.lan>
In-Reply-To: <20170622200328.5387-1-d.scheller.oss@gmail.com>
References: <20170622200328.5387-1-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 22 Jun 2017 22:03:28 +0200
Daniel Scheller <d.scheller.oss@gmail.com> escreveu:

> From: Daniel Scheller <d.scheller@gmx.net>
> 
> When the demod driver puts the demod into sleep or shutdown state and it's
> status is then polled e.g. via "dvb-fe-tool -m", i2c errors are printed
> to the kernel log. If the last delsys was DVB-T/T2:
> 
>   cxd2841er: i2c wr failed=-5 addr=6c reg=00 len=1
>   cxd2841er: i2c rd failed=-5 addr=6c reg=26
> 
> and if it was DVB-C:
> 
>   cxd2841er: i2c wr failed=-5 addr=6c reg=00 len=1
>   cxd2841er: i2c rd failed=-5 addr=6c reg=49
> 
> This happens when read_status unconditionally calls into the
> read_signal_strength() function which triggers the read_agc_gain_*()
> functions, where these registered are polled.
> 
> This isn't a critical thing since when the demod is active again, no more
> such errors are logged, however this might make users suspecting defects.
> 
> Fix this by requiring fe_status FE_HAS_SYNC to be sure the demod is not
> put asleep or shut down. If FE_HAS_SYNC isn't set, additionally set the
> strength scale to NOT_AVAILABLE.

Requiring full lock for signal strength seems too much, as people usually
rely on signal strength to adjust antenna.

You should, instead, just check if the demod is shut down.

Regards,
Mauro

> 
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>  drivers/media/dvb-frontends/cxd2841er.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
> index 08f67d60a7d9..9fff031436f1 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.c
> +++ b/drivers/media/dvb-frontends/cxd2841er.c
> @@ -3279,7 +3279,10 @@ static int cxd2841er_get_frontend(struct dvb_frontend *fe,
>  	else if (priv->state == STATE_ACTIVE_TC)
>  		cxd2841er_read_status_tc(fe, &status);
>  
> -	cxd2841er_read_signal_strength(fe);
> +	if (status & FE_HAS_SYNC)
> +		cxd2841er_read_signal_strength(fe);
> +	else
> +		p->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
>  
>  	if (status & FE_HAS_LOCK) {
>  		cxd2841er_read_snr(fe);



Thanks,
Mauro
