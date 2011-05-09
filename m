Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:15037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755718Ab1EID6b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 May 2011 23:58:31 -0400
Message-ID: <4DC7665E.5000202@redhat.com>
Date: Mon, 09 May 2011 05:58:22 +0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: linux-media@vger.kernel.org,
	Thierry LELEGARD <tlelegard@logiways.com>
Subject: Re: [PATCH 2/8] DVB: dtv_property_cache_submit shouldn't modifiy
 the cache
References: <1304895821-21642-1-git-send-email-obi@linuxtv.org> <1304895821-21642-3-git-send-email-obi@linuxtv.org>
In-Reply-To: <1304895821-21642-3-git-send-email-obi@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 09-05-2011 01:03, Andreas Oberritter escreveu:
> - Use const pointers and remove assignments.

That's OK.

> - delivery_system already gets assigned by DTV_DELIVERY_SYSTEM
>   and dtv_property_cache_sync.

The logic for those legacy params is too complex. It is easy that
a latter patch to break the implicit set via dtv_property_cache_sync().

Do you actually see a bug caused by the extra set for the delivery system?
If not, I prefer to keep this extra re-assignment.
> 
> Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
> ---
>  drivers/media/dvb/dvb-core/dvb_frontend.c |   13 +++----------
>  1 files changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index be0f631..1ac7633 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -1074,7 +1074,7 @@ static void dtv_property_cache_sync(struct dvb_frontend *fe,
>   */
>  static void dtv_property_legacy_params_sync(struct dvb_frontend *fe)
>  {
> -	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> +	const struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>  	struct dvb_frontend_private *fepriv = fe->frontend_priv;
>  	struct dvb_frontend_parameters *p = &fepriv->parameters;
>  
> @@ -1086,14 +1086,12 @@ static void dtv_property_legacy_params_sync(struct dvb_frontend *fe)
>  		dprintk("%s() Preparing QPSK req\n", __func__);
>  		p->u.qpsk.symbol_rate = c->symbol_rate;
>  		p->u.qpsk.fec_inner = c->fec_inner;
> -		c->delivery_system = SYS_DVBS;
>  		break;
>  	case FE_QAM:
>  		dprintk("%s() Preparing QAM req\n", __func__);
>  		p->u.qam.symbol_rate = c->symbol_rate;
>  		p->u.qam.fec_inner = c->fec_inner;
>  		p->u.qam.modulation = c->modulation;
> -		c->delivery_system = SYS_DVBC_ANNEX_AC;
>  		break;
>  	case FE_OFDM:
>  		dprintk("%s() Preparing OFDM req\n", __func__);
> @@ -1111,15 +1109,10 @@ static void dtv_property_legacy_params_sync(struct dvb_frontend *fe)
>  		p->u.ofdm.transmission_mode = c->transmission_mode;
>  		p->u.ofdm.guard_interval = c->guard_interval;
>  		p->u.ofdm.hierarchy_information = c->hierarchy;
> -		c->delivery_system = SYS_DVBT;
>  		break;
>  	case FE_ATSC:
>  		dprintk("%s() Preparing VSB req\n", __func__);
>  		p->u.vsb.modulation = c->modulation;
> -		if ((c->modulation == VSB_8) || (c->modulation == VSB_16))
> -			c->delivery_system = SYS_ATSC;
> -		else
> -			c->delivery_system = SYS_DVBC_ANNEX_B;
>  		break;
>  	}
>  }
> @@ -1129,7 +1122,7 @@ static void dtv_property_legacy_params_sync(struct dvb_frontend *fe)
>   */
>  static void dtv_property_adv_params_sync(struct dvb_frontend *fe)
>  {
> -	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> +	const struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>  	struct dvb_frontend_private *fepriv = fe->frontend_priv;
>  	struct dvb_frontend_parameters *p = &fepriv->parameters;
>  
> @@ -1170,7 +1163,7 @@ static void dtv_property_adv_params_sync(struct dvb_frontend *fe)
>  
>  static void dtv_property_cache_submit(struct dvb_frontend *fe)
>  {
> -	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> +	const struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>  
>  	/* For legacy delivery systems we don't need the delivery_system to
>  	 * be specified, but we populate the older structures from the cache

