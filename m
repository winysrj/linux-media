Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927Ab2HLP2V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Aug 2012 11:28:21 -0400
Message-ID: <5027CB8A.1020204@redhat.com>
Date: Sun, 12 Aug 2012 12:28:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH RFC 3/3] dvb_frontend: do not allow statistic IOCTLs when
 sleeping
References: <1344551101-16700-1-git-send-email-crope@iki.fi> <1344551101-16700-4-git-send-email-crope@iki.fi>
In-Reply-To: <1344551101-16700-4-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 09-08-2012 19:25, Antti Palosaari escreveu:
> Demodulator cannot perform statistic IOCTLs when it is not tuned.
> Return -EPERM in such case.

While, in general, doing it makes sense, -EPERM is a very bad return code.
It is used to indicate when accessing some resources would require root access.

> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/dvb/dvb-core/dvb_frontend.c | 34 +++++++++++++++++++++++--------
>  1 file changed, 25 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index 4fc11eb..40efcde 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -2157,27 +2157,43 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
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
> +				err = -EPERM;
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
> +				err = -EPERM;
> +		}
>  		break;

Signal strength can still be available even without locking.

>  
>  	case FE_READ_SNR:
> -		if (fe->ops.read_snr)
> -			err = fe->ops.read_snr(fe, (__u16*) parg);
> +		if (fe->ops.read_snr) {
> +			if (fepriv->thread)
> +				err = fe->ops.read_snr(fe, (__u16 *) parg);
> +			else
> +				err = -EPERM;
> +		}
>  		break;
>  
>  	case FE_READ_UNCORRECTED_BLOCKS:
> -		if (fe->ops.read_ucblocks)
> -			err = fe->ops.read_ucblocks(fe, (__u32*) parg);
> +		if (fe->ops.read_ucblocks) {
> +			if (fepriv->thread)
> +				err = fe->ops.read_ucblocks(fe, (__u32 *) parg);
> +			else
> +				err = -EPERM;
> +		}
>  		break;
>  
> -
>  	case FE_DISEQC_RESET_OVERLOAD:
>  		if (fe->ops.diseqc_reset_overload) {
>  			err = fe->ops.diseqc_reset_overload(fe);
> 

Regards,
Mauro
