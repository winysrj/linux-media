Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40558 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbZFPL4L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 07:56:11 -0400
Date: Tue, 16 Jun 2009 08:56:09 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: hiranotaka@zng.info
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Add the DTV_ISDB_TS_ID property for ISDB-S
Message-ID: <20090616085609.7b816e40@pedra.chehab.org>
In-Reply-To: <87bpq52axw.fsf@wei.zng.jp>
References: <87bpq52axw.fsf@wei.zng.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hirano,

Em Fri, 08 May 2009 00:24:11 +0900
hiranotaka@zng.info escreveu:

> # HG changeset patch
> # User HIRANO Takahito <hiranotaka@zng.info>
> # Date 1235532786 -32400
> # Node ID 5e6932c1b659d6bfea781a81d06098e85c6ff203
> # Parent  fe524e0a64126791bdf3dd94a50bdcdb0592ef7f
> Add the DTV_ISDB_TS_ID property for ISDB-S
> 
> In ISDB-S, time-devision duplex is used to multiplexing several waves
> in the same frequency. Each wave is identified by its own transport
> stream ID, or TS ID. We need to provide some way to specify this ID
> from user applications to handle ISDB-S frontends.
> 
> This code has been tested with Earthsoft PT1 driver, which is under
> development at:
> http://bitbucket.org/hiranotaka/dvb-pt1/

API changes should be submitted together with the driver. This allows us to
better understand driver needs. 

So, please re-submit this when you'll be ready to submit your driver.

Thanks,
Mauro.

> 
> Signed-off-by: HIRANO Takahito <hiranotaka@zng.info>
> 
> diff -r fe524e0a6412 -r 5e6932c1b659 linux/drivers/media/dvb/dvb-core/dvb_frontend.c
> --- a/linux/drivers/media/dvb/dvb-core/dvb_frontend.c	Tue May 05 08:50:54 2009 -0300
> +++ b/linux/drivers/media/dvb/dvb-core/dvb_frontend.c	Wed Feb 25 12:33:06 2009 +0900
> @@ -946,6 +946,11 @@
>  		.cmd	= DTV_TRANSMISSION_MODE,
>  		.set	= 1,
>  	},
> +	[DTV_ISDB_TS_ID] = {
> +		.name	= "DTV_ISDB_TS_ID",
> +		.cmd	= DTV_ISDB_TS_ID,
> +		.set	= 1,
> +	},
>  	/* Get */
>  	[DTV_DISEQC_SLAVE_REPLY] = {
>  		.name	= "DTV_DISEQC_SLAVE_REPLY",
> @@ -1354,6 +1359,9 @@
>  	case DTV_HIERARCHY:
>  		tvp->u.data = fe->dtv_property_cache.hierarchy;
>  		break;
> +	case DTV_ISDB_TS_ID:
> +		tvp->u.data = fe->dtv_property_cache.isdb_ts_id;
> +		break;
>  	default:
>  		r = -1;
>  	}
> @@ -1460,6 +1468,9 @@
>  	case DTV_HIERARCHY:
>  		fe->dtv_property_cache.hierarchy = tvp->u.data;
>  		break;
> +	case DTV_ISDB_TS_ID:
> +		fe->dtv_property_cache.isdb_ts_id = tvp->u.data;
> +		break;
>  	default:
>  		r = -1;
>  	}
> diff -r fe524e0a6412 -r 5e6932c1b659 linux/drivers/media/dvb/dvb-core/dvb_frontend.h
> --- a/linux/drivers/media/dvb/dvb-core/dvb_frontend.h	Tue May 05 08:50:54 2009 -0300
> +++ b/linux/drivers/media/dvb/dvb-core/dvb_frontend.h	Wed Feb 25 12:33:06 2009 +0900
> @@ -355,6 +355,7 @@
>  	fe_modulation_t		isdb_layerc_modulation;
>  	u32			isdb_layerc_segment_width;
>  #endif
> +	u32			isdb_ts_id;
>  };
>  
>  struct dvb_frontend {
> diff -r fe524e0a6412 -r 5e6932c1b659 linux/include/linux/dvb/frontend.h
> --- a/linux/include/linux/dvb/frontend.h	Tue May 05 08:50:54 2009 -0300
> +++ b/linux/include/linux/dvb/frontend.h	Wed Feb 25 12:33:06 2009 +0900
> @@ -307,7 +307,9 @@
>  #define DTV_TRANSMISSION_MODE			39
>  #define DTV_HIERARCHY				40
>  
> -#define DTV_MAX_COMMAND				DTV_HIERARCHY
> +#define DTV_ISDB_TS_ID				41
> +
> +#define DTV_MAX_COMMAND				DTV_ISDB_TS_ID
>  
>  typedef enum fe_pilot {
>  	PILOT_ON,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




Cheers,
Mauro
