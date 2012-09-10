Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab2IJO14 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Sep 2012 10:27:56 -0400
Message-ID: <504DF8D5.7050709@redhat.com>
Date: Mon, 10 Sep 2012 11:27:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: Re: [PATCH 3/5] dvb_frontend: do not allow statistic IOCTLs when
 sleeping
References: <1345076921-9773-1-git-send-email-crope@iki.fi> <1345076921-9773-4-git-send-email-crope@iki.fi>
In-Reply-To: <1345076921-9773-4-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 15-08-2012 21:28, Antti Palosaari escreveu:
> Demodulator cannot perform statistic IOCTLs when it is not tuned.
> Return -EAGAIN in such case.
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/dvb-core/dvb_frontend.c | 34 +++++++++++++++++++++++++---------
>  1 file changed, 25 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> index 2bc80b1..7d079fb 100644
> --- a/drivers/media/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb-core/dvb_frontend.c
> @@ -2132,27 +2132,43 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
>  			err = fe->ops.read_status(fe, status);
>  		break;
>  	}
> +
>  	case FE_READ_BER:
> -		if (fe->ops.read_ber)
> -			err = fe->ops.read_ber(fe, (__u32*) parg);
> +		if (fe->ops.read_ber) {
> +			if (fepriv->thread)
> +				err = fe->ops.read_ber(fe, (__u32 *) parg);
> +			else
> +				err = -EAGAIN;
> +		}
>  		break;
>  


>  	case FE_READ_SIGNAL_STRENGTH:
> -		if (fe->ops.read_signal_strength)
> -			err = fe->ops.read_signal_strength(fe, (__u16*) parg);
> +		if (fe->ops.read_signal_strength) {
> +			if (fepriv->thread)
> +				err = fe->ops.read_signal_strength(fe, (__u16 *) parg);
> +			else
> +				err = -EAGAIN;
> +		}
>  		break;

This one doesn't look right, as the frontend can be able to get the signal strength
at the analog part (afaik, most DVB-S frontends do that). Also, some drivers just
map it to the tuner RF strength.

The proper approach for it is to break signal strength into two different statistics:
	- analog RF strength;
	- signal strength at the demod, after having demod locked.

It makes sense to return -EAGAIN for the second case, but doing it for the first case
is bad, as the RF strength can be used on DVB-S devices, in order to fine-adjust the 
antenna position.

Regards,
Mauro.
