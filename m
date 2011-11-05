Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:46530 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253Ab1KEQt7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Nov 2011 12:49:59 -0400
Message-ID: <4EB566CD.7050704@linuxtv.org>
Date: Sat, 05 Nov 2011 17:39:41 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Lawrence Rust <lawrence@softsystem.co.uk>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Revert most of 15cc2bb [media] DVB: dtv_property_cache_submit
 shouldn't modifiy the cache
References: <1320506379.1731.12.camel@gagarin>
In-Reply-To: <1320506379.1731.12.camel@gagarin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05.11.2011 16:19, Lawrence Rust wrote:
> Hi,
> 
> I believe that I have found a problem with dtv_property_cache updating
> when handling the legacy API.  This was introduced between 2.6.39 and
> 3.0.
> 
> dtv_property_cache_submit() in dvb_frontend.c tests the field
> delivery_system and if it's a legacy type (including SYS_UNDEFINED) then
> it calls dtv_property_legacy_params_sync().
> 
> The original patch removed the assignment to delivery_system in this
> function.  However, the legacy API allows delivery_system to be
> SYS_UNDEFINED - in fact is_legacy_delivery_system() tests for this
> value.
> 
> If the delivery_system field is left as SYS_UNDEFINED then when tuning
> is started, fe->ops.set_frontend() fails.
> 
> The current version of MythTV 0.24.1 is affected by this bug when using
> a dvb-s2 card (tbs6981) tuned to a dvb-s channel.

How does MythTV set the parameters (i.e. using which interface, calls)?
If using S2API, it should also set DTV_DELIVERY_SYSTEM.

SYS_UNDEFINED get's set by dvb_frontend_clear_cache() only. I think it
would be better to call dtv_property_cache_init() from there to get rid
of it.

> Signed-off-by: Lawrence Rust <lvr@softsystem.co.uk>
> ---
>  drivers/media/dvb/dvb-core/dvb_frontend.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index 5b6b451..06c3975 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -1076,7 +1076,7 @@ static void dtv_property_cache_sync(struct dvb_frontend *fe,
>   */
>  static void dtv_property_legacy_params_sync(struct dvb_frontend *fe)
>  {
> -	const struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> +	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>  	struct dvb_frontend_private *fepriv = fe->frontend_priv;
>  	struct dvb_frontend_parameters *p = &fepriv->parameters_in;
>  
> @@ -1088,12 +1088,14 @@ static void dtv_property_legacy_params_sync(struct dvb_frontend *fe)
>  		dprintk("%s() Preparing QPSK req\n", __func__);
>  		p->u.qpsk.symbol_rate = c->symbol_rate;
>  		p->u.qpsk.fec_inner = c->fec_inner;
> +		c->delivery_system = SYS_DVBS;
>  		break;
>  	case FE_QAM:
>  		dprintk("%s() Preparing QAM req\n", __func__);
>  		p->u.qam.symbol_rate = c->symbol_rate;
>  		p->u.qam.fec_inner = c->fec_inner;
>  		p->u.qam.modulation = c->modulation;
> +		c->delivery_system = SYS_DVBC_ANNEX_AC;
>  		break;
>  	case FE_OFDM:
>  		dprintk("%s() Preparing OFDM req\n", __func__);
> @@ -1111,10 +1113,15 @@ static void dtv_property_legacy_params_sync(struct dvb_frontend *fe)
>  		p->u.ofdm.transmission_mode = c->transmission_mode;
>  		p->u.ofdm.guard_interval = c->guard_interval;
>  		p->u.ofdm.hierarchy_information = c->hierarchy;
> +		c->delivery_system = SYS_DVBT;
>  		break;
>  	case FE_ATSC:
>  		dprintk("%s() Preparing VSB req\n", __func__);
>  		p->u.vsb.modulation = c->modulation;
> +		if ((c->modulation == VSB_8) || (c->modulation == VSB_16))
> +			c->delivery_system = SYS_ATSC;
> +		else
> +			c->delivery_system = SYS_DVBC_ANNEX_B;
>  		break;
>  	}
>  }

