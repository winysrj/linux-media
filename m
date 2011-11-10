Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:51877 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934648Ab1KJOoL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 09:44:11 -0500
Message-ID: <4EBBE336.8050501@linuxtv.org>
Date: Thu, 10 Nov 2011 15:44:06 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: PATCH: Query DVB frontend capabilities
References: <CAHFNz9Lf8CXb2pqmO0669VV2HAqxCpM9mmL9kU=jM19oNp0dbg@mail.gmail.com>
In-Reply-To: <CAHFNz9Lf8CXb2pqmO0669VV2HAqxCpM9mmL9kU=jM19oNp0dbg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Manu,

please see my comments below:

On 10.11.2011 15:18, Manu Abraham wrote:
> Hi,
> 
> Currently, for a multi standard frontend it is assumed that it just
> has a single standard capability. This is fine in some cases, but
> makes things hard when there are incompatible standards in conjuction.
> Eg: DVB-S can be seen as a subset of DVB-S2, but the same doesn't hold
> the same for DSS. This is not specific to any driver as it is, but a
> generic issue. This was handled correctly in the multiproto tree,
> while such functionality is missing from the v5 API update.
> 
> http://www.linuxtv.org/pipermail/vdr/2008-November/018417.html
> 
> Later on a FE_CAN_2G_MODULATION was added as a hack to workaround this
> issue in the v5 API, but that hack is incapable of addressing the
> issue, as it can be used to simply distinguish between DVB-S and
> DVB-S2 alone, or another x vs X2 modulation. If there are more
> systems, then you have a potential issue.
> 
> In addition to the patch, for illustrative purposes the stb0899 driver
> is depicted providing the said capability information.
> 
> An application needs to query the device capabilities before
> requesting an operation from the device.
> 
> If people don't have any objections, Probably other drivers can be
> adapted similarly. In fact the change is quite simple.
> 
> Comments ?
> 
> Regards,
> Manu
> 
> 
> query_frontend_capabilities.diff
> 
> 
> diff -r b6eb04718aa9 linux/drivers/media/dvb/dvb-core/dvb_frontend.c
> --- a/linux/drivers/media/dvb/dvb-core/dvb_frontend.c	Wed Nov 09 19:52:36 2011 +0530
> +++ b/linux/drivers/media/dvb/dvb-core/dvb_frontend.c	Thu Nov 10 13:51:35 2011 +0530
> @@ -973,6 +973,8 @@
>  	_DTV_CMD(DTV_GUARD_INTERVAL, 0, 0),
>  	_DTV_CMD(DTV_TRANSMISSION_MODE, 0, 0),
>  	_DTV_CMD(DTV_HIERARCHY, 0, 0),
> +
> +	_DTV_CMD(DTV_DELIVERY_CAPS, 0, 0),
>  };
>  
>  static void dtv_property_dump(struct dtv_property *tvp)
> @@ -1226,7 +1228,18 @@
>  		c = &cdetected;
>  	}
>  
> +	dprintk("%s\n", __func__);
> +
>  	switch(tvp->cmd) {
> +	case DTV_DELIVERY_CAPS:
> +		if (fe->ops.delivery_caps) {
> +			r = fe->ops.delivery_caps(fe, tvp);
> +			if (r < 0)
> +				return r;
> +			else
> +				goto done;

What's the reason for introducing that label and goto?

> +		}
> +		break;
>  	case DTV_FREQUENCY:
>  		tvp->u.data = c->frequency;
>  		break;
> @@ -1350,7 +1363,7 @@
>  		if (r < 0)
>  			return r;
>  	}
> -
> +done:
>  	dtv_property_dump(tvp);
>  
>  	return 0;
> diff -r b6eb04718aa9 linux/drivers/media/dvb/dvb-core/dvb_frontend.h
> --- a/linux/drivers/media/dvb/dvb-core/dvb_frontend.h	Wed Nov 09 19:52:36 2011 +0530
> +++ b/linux/drivers/media/dvb/dvb-core/dvb_frontend.h	Thu Nov 10 13:51:35 2011 +0530
> @@ -305,6 +305,8 @@
>  
>  	int (*set_property)(struct dvb_frontend* fe, struct dtv_property* tvp);
>  	int (*get_property)(struct dvb_frontend* fe, struct dtv_property* tvp);
> +
> +	int (*delivery_caps)(struct dvb_frontend *fe, struct dtv_property *tvp);
>  };

I don't think that another function pointer is required. Drivers can
implement this in their get_property callback. The core could provide a
default implementation, returning values derived from fe->ops.info.type
and the 2G flag.

>  #define MAX_EVENT 8
> @@ -362,6 +364,8 @@
>  
>  	/* DVB-T2 specifics */
>  	u32                     dvbt2_plp_id;
> +
> +	fe_delivery_system_t	delivery_caps[32];
>  };

This array seems to be unused.

Regards,
Andreas

>  struct dvb_frontend {
> diff -r b6eb04718aa9 linux/drivers/media/dvb/frontends/stb0899_drv.c
> --- a/linux/drivers/media/dvb/frontends/stb0899_drv.c	Wed Nov 09 19:52:36 2011 +0530
> +++ b/linux/drivers/media/dvb/frontends/stb0899_drv.c	Thu Nov 10 13:51:35 2011 +0530
> @@ -1605,6 +1605,19 @@
>  	return DVBFE_ALGO_CUSTOM;
>  }
>  
> +static int stb0899_delivery_caps(struct dvb_frontend *fe, struct dtv_property *caps)
> +{
> +	struct stb0899_state *state		= fe->demodulator_priv;
> +
> +	dprintk(state->verbose, FE_DEBUG, 1, "Get caps");
> +	caps->u.buffer.data[0] = SYS_DSS;
> +	caps->u.buffer.data[1] = SYS_DVBS;
> +	caps->u.buffer.data[2] = SYS_DVBS2;
> +	caps->u.buffer.len = 3;
> +
> +	return 0;
> +}
> +
>  static struct dvb_frontend_ops stb0899_ops = {
>  
>  	.info = {
> @@ -1647,6 +1660,8 @@
>  	.diseqc_send_master_cmd		= stb0899_send_diseqc_msg,
>  	.diseqc_recv_slave_reply	= stb0899_recv_slave_reply,
>  	.diseqc_send_burst		= stb0899_send_diseqc_burst,
> +
> +	.delivery_caps			= stb0899_delivery_caps,
>  };
>  
>  struct dvb_frontend *stb0899_attach(struct stb0899_config *config, struct i2c_adapter *i2c)
> diff -r b6eb04718aa9 linux/include/linux/dvb/frontend.h
> --- a/linux/include/linux/dvb/frontend.h	Wed Nov 09 19:52:36 2011 +0530
> +++ b/linux/include/linux/dvb/frontend.h	Thu Nov 10 13:51:35 2011 +0530
> @@ -316,7 +316,9 @@
>  
>  #define DTV_DVBT2_PLP_ID	43
>  
> -#define DTV_MAX_COMMAND				DTV_DVBT2_PLP_ID
> +#define DTV_DELIVERY_CAPS	44
> +
> +#define DTV_MAX_COMMAND				DTV_DELIVERY_CAPS
>  
>  typedef enum fe_pilot {
>  	PILOT_ON,
> 

