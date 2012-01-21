Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36768 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196Ab2AURFB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 12:05:01 -0500
Message-ID: <4F1AF03A.9000502@iki.fi>
Date: Sat, 21 Jan 2012 19:04:58 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] [RFC] dvb: Add DVBv5 properties for quality parameters
References: <1327063080-29399-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327063080-29399-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/20/2012 02:38 PM, Mauro Carvalho Chehab wrote:

Basically I would like to ask slow down API changes since it causes all 
the problems and extra work.

Rather than always doing API changes of our perspective I would like to 
ask if it is possible to ask applications developers to help? Situation 
is very weird, almost all applications are using old APIs whilst we have 
had newer one many years... If application makers are attending to API 
changes then most likely those APIs and new features are taken use sooner.

> The DVBv3 quality parameters are limited on several ways:
> 	- Doesn't provide any way to indicate the used measure;
> 	- Userspace need to guess how to calculate the measure;
> 	- Only a limited set of stats are supported;
> 	- Doesn't provide QoS measure for the OFDM TPS/TMCC
> 	  carriers, used to detect the network parameters for
> 	  DVB-T/ISDB-T;
> 	- Can't be called in a way to require them to be filled
> 	  all at once (atomic reads from the hardware), with may
> 	  cause troubles on interpreting them on userspace;
> 	- On some OFDM delivery systems, the carriers can be
> 	  independently modulated, having different properties.
> 	  Currently, there's no way to report per-layer stats;
>
> This RFC adds the header definitions meant to solve that issues.
> After discussed, I'll write a patch for the DocBook and add support
> for it on some demods. Support for dvbv5-zap and dvbv5-scan tools
> will also have support for those features.
>
> Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
> ---
>   include/linux/dvb/frontend.h |   78 +++++++++++++++++++++++++++++++++++++++++-
>   1 files changed, 77 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
> index cb4428a..f9cdb7d 100644
> --- a/include/linux/dvb/frontend.h
> +++ b/include/linux/dvb/frontend.h
> @@ -320,7 +320,21 @@ struct dvb_frontend_event {
>
>   #define DTV_ENUM_DELSYS		44
>
> -#define DTV_MAX_COMMAND				DTV_ENUM_DELSYS
> +/* Quality parameters */
> +#define DTV_ENUM_QUALITY	45	/* Enumerates supported QoS parameters */
> +#define DTV_QUALITY_SNR		46
> +#define DTV_QUALITY_CNR		47
> +#define DTV_QUALITY_EsNo	48
> +#define DTV_QUALITY_EbNo	49
> +#define DTV_QUALITY_RELATIVE	50

Rather many ways to report signal quality. Is it possible to reduce?
I have feeling having this many different ways to report single subject 
causes app devels to likely skip whole reporting :]

> +#define DTV_ERROR_BER		51
> +#define DTV_ERROR_PER		52
> +#define DTV_ERROR_PARAMS	53	/* Error count at TMCC or TPS carrier */

No enumeration for two bit error rate methods like quality?
I don't still see much difference if it is BER or PER. Users usually 
just want look if there is some errors and compare to uncorrected blocks 
or picture to see if those can be fixed be demod (inner FEC). Random 
running numbers for error rate is just enough, unless you are not making 
some measurement equipment :]

> +#define DTV_FE_STRENGTH		54
> +#define DTV_FE_SIGNAL		55

What is difference these two?

> +#define DTV_FE_UNC		56
> +
> +#define DTV_MAX_COMMAND		DTV_FE_UNC
>
>   typedef enum fe_pilot {
>   	PILOT_ON,
> @@ -372,12 +386,74 @@ struct dtv_cmds_h {
>   	__u32	reserved:30;	/* Align */
>   };
>
> +/**
> + * Scale types for the quality parameters.
> + * @FE_SCALE_DECIBEL: The scale is measured in dB, typically
> + *		  used on signal measures.
> + * @FE_SCALE_LINEAR: The scale is linear.
> + *		     typically used on error QoS parameters.
> + * @FE_SCALE_RELATIVE: The scale is relative.
> + */
> +enum fecap_scale_params {
> +	FE_SCALE_DECIBEL,
> +	FE_SCALE_LINEAR,
> +	FE_SCALE_RELATIVE
> +};

If we end up defining own commands for SNR/CNR/EsNo/EbNo/RELATIVE I 
don't see need to define scale any-more. Almost all those uses de Facto 
scale as dB. Define scale per measurement and use that.

> +
> +/**
> + * struct dtv_status - Used for reading a DTV status property
> + *
> + * @value:	value of the measure. Should range from 0 to 0xffff;
> + * @scale:	Filled with enum fecap_scale_params - the scale
> + *		in usage for that parameter
> + * @min:	minimum value. Not used if the scale is relative.
> + *		For non-relative measures, define the measure
> + *		associated with dtv_status.value == 0.
> + * @max:	maximum value. Not used if the scale is	relative.
> + *		For non-relative measures, define the measure
> + *		associated with dtv_status.value == 0xffff.
> + *
> + * At userspace, min/max values should be used to calculate the
> + * absolute value of that measure, if fecap_scale_params is not
> + * FE_SCALE_RELATIVE, using the following formula:
> + *	 measure = min + (value * (max - min) / 0xffff)
> + *
> + * For error count measures, typically, min = 0, and max = 0xffff,
> + * and the measure represent the number of errors detected.
> + *
> + * Up to 4 status groups can be provided. This is for the
> + * OFDM standards where the carriers can be grouped into
> + * independent layers, each with its own modulation. When
> + * such layers are used (for example, on ISDB-T), the status
> + * should be filled with:
> + *	stat.status[0] = global statistics;
> + *	stat.status[1] = layer A statistics;
> + *	stat.status[2] = layer B statistics;
> + *	stat.status[3] = layer C statistics.

Are those modulations used as top of each, like inner (layer A), "next 
to inner" (layer B), outer (layer C)?
Or just one modulation per stream? I think DVB-T2 have one modulation 
for common channel and then own modulation per each transport stream 
(called PLP in case of DVB-T2). In case of DVB-T2 I see it is enough to 
provide current active stream statistics, not for the all possible PLPs 
there is transmission ongoing. And if needed statistics for common 
channel - but I don't see it very important.

> + * and stat.len should be filled with the latest filled status + 1.
> + * If the frontend doesn't provide a global statistics,
> + * stat.has_global should be 0.
> + * Delivery systems that don't use it, should just set stat.len and
> + * stat.has_global with 1, and fill just stat.status[0].
> + */
> +struct dtv_status {
> +	__u16 value;
> +	__u16 scale;
> +	__s16 min;
> +	__s16 max;
> +} __attribute__ ((packed));
> +
>   struct dtv_property {
>   	__u32 cmd;
>   	__u32 reserved[3];
>   	union {
>   		__u32 data;
>   		struct {
> +			__u8 len;
> +			__u8 has_global;
> +			struct dtv_status status[4];
> +		} stat;
> +		struct {
>   			__u8 data[32];
>   			__u32 len;
>   			__u32 reserved1[3];

regards
Antti

-- 
http://palosaari.fi/
