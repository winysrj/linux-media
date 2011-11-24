Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755026Ab1KXXtf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 18:49:35 -0500
Message-ID: <4ECED807.7090200@redhat.com>
Date: Thu, 24 Nov 2011 21:49:27 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Andreas Oberritter <obi@linuxtv.org>
Subject: Re: PATCH 03/13: 0003-DVB-Allow-frontend-to-set-DELSYS-Modulation
References: <CAHFNz9+ZZ2KTvCLcj+Eu+FtnEti1wZfKf9My-FMcSf-Ns-Z4QQ@mail.gmail.com>
In-Reply-To: <CAHFNz9+ZZ2KTvCLcj+Eu+FtnEti1wZfKf9My-FMcSf-Ns-Z4QQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 21-11-2011 19:06, Manu Abraham escreveu:

> With any tuner that can tune to multiple delivery systems/standards, it does
> query fe->ops.info.type to determine frontend type and set the delivery
> system type. fe->ops.info.type can handle only 4 delivery systems, viz FE_QPSK,
> FE_QAM, FE_OFDM and FE_ATSC.
> 
> The change allows the tuner to be set to any delivery system specified in
> fe_delivery_system_t and any modulation as specified in fe_modulation_t,
> thereby simplification of issues.
> 
> Signed-off-by: Manu Abraham <abraham.manu@gmail.com>
> ---
>  drivers/media/dvb/dvb-core/dvb_frontend.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
> index 67bbfa7..ec6e8e9 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.h
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
> @@ -113,6 +113,8 @@ enum tuner_param {
>  	DVBFE_TUNER_BANDWIDTH		= (1 <<  3),
>  	DVBFE_TUNER_REFCLOCK		= (1 <<  4),
>  	DVBFE_TUNER_IQSENSE		= (1 <<  5),
> +	DVBFE_TUNER_DELSYS              = (1 <<  6),
> +	DVBFE_TUNER_MODULATION		= (1 <<  7),
>  	DVBFE_TUNER_DUMMY		= (1 << 31)
>  };
>  
> @@ -149,6 +151,8 @@ enum dvbfe_algo {
>  };
>  
>  struct tuner_state {
> +	fe_delivery_system_t delsys;
> +	fe_modulation_t modulation;
>  	u32 frequency;
>  	u32 tunerstep;
>  	u32 ifreq;

Not sure about this patch.

Currently, tuners with newer standards just don't use the dvb_frontend_parameters 
passed into them, using instead fe->dtv_property_cache.

So, in the long term, it seems to make more sense to just change the
set_parameters callback parameters from:

	static int set_params(struct dvb_frontend *fe,
		struct dvb_frontend_parameters *params)

to:

	static int set_params(struct dvb_frontend *fe)

or to explicitly pass the cache as an argument.


Regards,
Mauro.
