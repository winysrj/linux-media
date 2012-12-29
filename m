Return-path: <linux-media-owner@vger.kernel.org>
Received: from racoon.tvdr.de ([188.40.50.18]:55784 "EHLO racoon.tvdr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab2L2PtC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Dec 2012 10:49:02 -0500
Received: from dolphin.tvdr.de (dolphin.tvdr.de [192.168.100.2])
	by racoon.tvdr.de (8.14.5/8.14.5) with ESMTP id qBTFFite007378
	for <linux-media@vger.kernel.org>; Sat, 29 Dec 2012 16:15:44 +0100
Received: from [192.168.100.11] (falcon.tvdr.de [192.168.100.11])
	by dolphin.tvdr.de (8.14.4/8.14.4) with ESMTP id qBTFFcD0010500
	for <linux-media@vger.kernel.org>; Sat, 29 Dec 2012 16:15:38 +0100
Message-ID: <50DF091A.4020708@tvdr.de>
Date: Sat, 29 Dec 2012 16:15:38 +0100
From: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-media] [PATCH RFCv3] dvb: Add DVBv5 properties for quality
 parameters
References: <1356739006-22111-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1356739006-22111-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 29.12.2012 00:56, Mauro Carvalho Chehab wrote:
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
> This RFC adds the header definitions meant to solve that issues.
> After discussed, I'll write a patch for the DocBook and add support
> for it on some demods. Support for dvbv5-zap and dvbv5-scan tools
> will also have support for those features.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>   include/uapi/linux/dvb/frontend.h | 78 ++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 77 insertions(+), 1 deletion(-)
>
> v3: Just update http://patchwork.linuxtv.org/patch/9578/ to current tip
>
> diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
> index c12d452..a998b9a 100644
> --- a/include/uapi/linux/dvb/frontend.h
> +++ b/include/uapi/linux/dvb/frontend.h
> @@ -365,7 +365,21 @@ struct dvb_frontend_event {
>   #define DTV_INTERLEAVING			60
>   #define DTV_LNA					61
>
> -#define DTV_MAX_COMMAND				DTV_LNA
> +/* Quality parameters */
> +#define DTV_ENUM_QUALITY	45	/* Enumerates supported QoS parameters */
> +#define DTV_QUALITY_SNR		46
> +#define DTV_QUALITY_CNR		47
> +#define DTV_QUALITY_EsNo	48
> +#define DTV_QUALITY_EbNo	49
> +#define DTV_QUALITY_RELATIVE	50
> +#define DTV_ERROR_BER		51
> +#define DTV_ERROR_PER		52
> +#define DTV_ERROR_PARAMS	53	/* Error count at TMCC or TPS carrier */
> +#define DTV_FE_STRENGTH		54
> +#define DTV_FE_SIGNAL		55
> +#define DTV_FE_UNC		56
> +
> +#define DTV_MAX_COMMAND		DTV_FE_UNC
>
>   typedef enum fe_pilot {
>   	PILOT_ON,
> @@ -452,12 +466,74 @@ struct dtv_cmds_h {
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
>

It would be really nice if there was (finally) a defined interface through which
an application like VDR can retrieve the signal *strength* and *quality* in a normalized
manner. Currently VDR has to do some tricks to get a proper scaling of the values,
since pretty much every frontend uses its own scaling. What VDR needs is a linear scaling in
a range from 0x0000 to 0xFFFF (or anything else, like 0..100, just as long as it
is the same for all frontends). If this is what this patch is aimed at, I'm all
for it!

Klaus
