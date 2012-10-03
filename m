Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3165 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab2JCGVs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2012 02:21:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH RFC v2] dvb: LNA implementation changes
Date: Wed, 3 Oct 2012 08:21:02 +0200
Cc: linux-media@vger.kernel.org
References: <1349221787-23121-1-git-send-email-crope@iki.fi>
In-Reply-To: <1349221787-23121-1-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210030821.02969.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed October 3 2012 01:49:47 Antti Palosaari wrote:
> * use dvb property cache
> * implement get (thus API minor++)
> * PCTV 290e: 1=LNA ON, all the other values LNA OFF
>   Also fix PCTV 290e LNA comment, it is disabled by default
> 
> Hans and Mauro proposed use of cache implementation of get as they
> were planning to extend LNA usage for analog side too.
> 
> LNA_AUTO value was changed from (~0U) to INT_MIN as (~0U) resulted
> only -1 which is waste of numeric range if need to extend that in
> the future.

Is the sentence above still valid? It doesn't seem to be as LNA_AUTO wasn't
changed.

The code itself looks good to me:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
> Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
> Reported-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
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
> +
>  	default:
>  		return -EINVAL;
>  	}
> diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
> index 44a445c..97112cd 100644
> --- a/drivers/media/dvb-core/dvb_frontend.h
> +++ b/drivers/media/dvb-core/dvb_frontend.h
> @@ -303,7 +303,7 @@ struct dvb_frontend_ops {
>  	int (*dishnetwork_send_legacy_command)(struct dvb_frontend* fe, unsigned long cmd);
>  	int (*i2c_gate_ctrl)(struct dvb_frontend* fe, int enable);
>  	int (*ts_bus_ctrl)(struct dvb_frontend* fe, int acquire);
> -	int (*set_lna)(struct dvb_frontend *, int);
> +	int (*set_lna)(struct dvb_frontend *);
>  
>  	/* These callbacks are for devices that implement their own
>  	 * tuning algorithms, rather than a simple swzigzag
> @@ -391,6 +391,8 @@ struct dtv_frontend_properties {
>  	u8			atscmh_sccc_code_mode_b;
>  	u8			atscmh_sccc_code_mode_c;
>  	u8			atscmh_sccc_code_mode_d;
> +
> +	u32			lna;
>  };
>  
>  struct dvb_frontend {
> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> index 913e522..13ae821 100644
> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> @@ -574,18 +574,19 @@ static void pctv_520e_init(struct em28xx *dev)
>  		i2c_master_send(&dev->i2c_client, regs[i].r, regs[i].len);
>  };
>  
> -static int em28xx_pctv_290e_set_lna(struct dvb_frontend *fe, int val)
> +static int em28xx_pctv_290e_set_lna(struct dvb_frontend *fe)
>  {
> +	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>  	struct em28xx *dev = fe->dvb->priv;
>  #ifdef CONFIG_GPIOLIB
>  	struct em28xx_dvb *dvb = dev->dvb;
>  	int ret;
>  	unsigned long flags;
>  
> -	if (val)
> -		flags = GPIOF_OUT_INIT_LOW;
> +	if (c->lna == 1)
> +		flags = GPIOF_OUT_INIT_HIGH; /* enable LNA */
>  	else
> -		flags = GPIOF_OUT_INIT_HIGH;
> +		flags = GPIOF_OUT_INIT_LOW; /* disable LNA */
>  
>  	ret = gpio_request_one(dvb->lna_gpio, flags, NULL);
>  	if (ret)
> @@ -595,8 +596,8 @@ static int em28xx_pctv_290e_set_lna(struct dvb_frontend *fe, int val)
>  
>  	return ret;
>  #else
> -	dev_warn(&dev->udev->dev, "%s: LNA control is disabled\n",
> -			KBUILD_MODNAME);
> +	dev_warn(&dev->udev->dev, "%s: LNA control is disabled (lna=%u)\n",
> +			KBUILD_MODNAME, c->lna);
>  	return 0;
>  #endif
>  }
> diff --git a/include/linux/dvb/version.h b/include/linux/dvb/version.h
> index 20e5eac..827cce7 100644
> --- a/include/linux/dvb/version.h
> +++ b/include/linux/dvb/version.h
> @@ -24,6 +24,6 @@
>  #define _DVBVERSION_H_
>  
>  #define DVB_API_VERSION 5
> -#define DVB_API_VERSION_MINOR 8
> +#define DVB_API_VERSION_MINOR 9
>  
>  #endif /*_DVBVERSION_H_*/
> 
