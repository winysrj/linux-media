Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068Ab2JGNbn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Oct 2012 09:31:43 -0400
Date: Sun, 7 Oct 2012 10:31:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH RFC v3] dvb: LNA implementation changes
Message-ID: <20121007103133.5bbe9170@redhat.com>
In-Reply-To: <1349252936-2728-1-git-send-email-crope@iki.fi>
References: <1349252936-2728-1-git-send-email-crope@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed,  3 Oct 2012 11:28:56 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> * use dvb property cache
> * implement get (thus API minor++)
> * PCTV 290e: 1=LNA ON, all the other values LNA OFF
>   Also fix PCTV 290e LNA comment, it is disabled by default
> 
> Hans and Mauro proposed use of cache implementation of get as they
> were planning to extend LNA usage for analog side too.
> 
> Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
> Reported-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/dvb-core/dvb_frontend.c | 18 ++++++++++++++----
>  drivers/media/dvb-core/dvb_frontend.h |  4 +++-
>  drivers/media/usb/em28xx/em28xx-dvb.c | 13 +++++++------
>  include/linux/dvb/version.h           |  2 +-
>  4 files changed, 25 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> index 8f58f24..246a3c5 100644
> --- a/drivers/media/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb-core/dvb_frontend.c
> @@ -966,6 +966,8 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
>  		break;
>  	}
>  
> +	c->lna = LNA_AUTO;
> +
>  	return 0;
>  }
>  
> @@ -1054,6 +1056,8 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
>  	_DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_B, 0, 0),
>  	_DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_C, 0, 0),
>  	_DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_D, 0, 0),
> +
> +	_DTV_CMD(DTV_LNA, 0, 0),
>  };
>  
>  static void dtv_property_dump(struct dvb_frontend *fe, struct dtv_property *tvp)
> @@ -1440,6 +1444,10 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
>  		tvp->u.data = fe->dtv_property_cache.atscmh_sccc_code_mode_d;
>  		break;
>  
> +	case DTV_LNA:
> +		tvp->u.data = c->lna;
> +		break;
> +
>  	default:
>  		return -EINVAL;
>  	}
> @@ -1731,10 +1739,6 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
>  	case DTV_INTERLEAVING:
>  		c->interleaving = tvp->u.data;
>  		break;
> -	case DTV_LNA:
> -		if (fe->ops.set_lna)
> -			r = fe->ops.set_lna(fe, tvp->u.data);
> -		break;
>  
>  	/* ISDB-T Support here */
>  	case DTV_ISDBT_PARTIAL_RECEPTION:
> @@ -1806,6 +1810,12 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
>  		fe->dtv_property_cache.atscmh_rs_frame_ensemble = tvp->u.data;
>  		break;
>  
> +	case DTV_LNA:
> +		c->lna = tvp->u.data;
> +		if (fe->ops.set_lna)
> +			r = fe->ops.set_lna(fe);
> +		break;

Hmm... on a second thought, I think that the implementation there should not me that
simple: during tuner sleep, and suspend/resume, you may need to force LNA to off, in
order to save power and prevent device overheat.

Still, as the previous code weren't doing it, I'm still applying it, but I think we
need to properly handle such cases.

Regards,
Mauro

Regards,
Mauro
