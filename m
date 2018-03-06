Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36410 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750933AbeCFNRq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2018 08:17:46 -0500
Date: Tue, 6 Mar 2018 10:17:39 -0300
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: mchehab@s-opensource.com, rascobie@slingshot.co.nz,
        Ralph Metzler <rjkm@metzlerbros.de>,
        "Jasmin J." <jasmin@anw.at>
Subject: Re: [PATCH v2 1/5] media: dvb_frontend: add FEC modes, S2X
 modulations and 64K transmission
Message-ID: <20180306101739.74ff5031@vento.lan>
In-Reply-To: <20180122171346.822-2-d.scheller.oss@gmail.com>
References: <20180122171346.822-1-d.scheller.oss@gmail.com>
        <20180122171346.822-2-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

Em Mon, 22 Jan 2018 18:13:42 +0100
Daniel Scheller <d.scheller.oss@gmail.com> escreveu:

> From: Daniel Scheller <d.scheller@gmx.net>
> 
> Add 1/4 and 1/3 FEC ratios, 64/128/256-APSK S2X modulations and 64K
> transmission mode. Update relevant doc items aswell.

Please properly document DVB-S2X. You need to add something at
Documentation/media/uapi/dvb/fe_property_parameters.rst,
and Documentation/media/uapi/dvb/frontend-property-satellite-systems.rst
in order to properly describe DVB-S2X.

Please take a look at:
	https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/dvb/fe_property_parameters.html
and:
https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/dvb/frontend-property-satellite-systems.html

Basically, for each DVB-S2X parameter, you should say what
values are valid.

Also, I'm not seeing a SYS_DVBS2X delivery system. If the idea is
not to create it, the documentation should state that SYS_DVBS2
should be used, and the Kernel should provide some way to allow
userspace to detect if the DVB-S2X parameters are valid or not.

As we're running out of DVB frontend caps flags, it means that
you need to also add a patch to this series implementing a
new way to query frontend capabilities.

Regards,
Mauro

> 
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>  Documentation/media/frontend.h.rst.exceptions |  6 ++++++
>  include/uapi/linux/dvb/frontend.h             | 13 +++++++++++++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/Documentation/media/frontend.h.rst.exceptions b/Documentation/media/frontend.h.rst.exceptions
> index f7c4df620a52..ae1148be0a39 100644
> --- a/Documentation/media/frontend.h.rst.exceptions
> +++ b/Documentation/media/frontend.h.rst.exceptions
> @@ -84,6 +84,9 @@ ignore symbol APSK_16
>  ignore symbol APSK_32
>  ignore symbol DQPSK
>  ignore symbol QAM_4_NR
> +ignore symbol APSK_64
> +ignore symbol APSK_128
> +ignore symbol APSK_256
>  
>  ignore symbol SEC_VOLTAGE_13
>  ignore symbol SEC_VOLTAGE_18
> @@ -117,6 +120,8 @@ ignore symbol FEC_AUTO
>  ignore symbol FEC_3_5
>  ignore symbol FEC_9_10
>  ignore symbol FEC_2_5
> +ignore symbol FEC_1_4
> +ignore symbol FEC_1_3
>  
>  ignore symbol TRANSMISSION_MODE_AUTO
>  ignore symbol TRANSMISSION_MODE_1K
> @@ -129,6 +134,7 @@ ignore symbol TRANSMISSION_MODE_C1
>  ignore symbol TRANSMISSION_MODE_C3780
>  ignore symbol TRANSMISSION_MODE_2K
>  ignore symbol TRANSMISSION_MODE_8K
> +ignore symbol TRANSMISSION_MODE_64K
>  
>  ignore symbol GUARD_INTERVAL_AUTO
>  ignore symbol GUARD_INTERVAL_1_128
> diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
> index 4f9b4551c534..227268a657cd 100644
> --- a/include/uapi/linux/dvb/frontend.h
> +++ b/include/uapi/linux/dvb/frontend.h
> @@ -296,6 +296,8 @@ enum fe_spectral_inversion {
>   * @FEC_3_5:  Forward Error Correction Code 3/5
>   * @FEC_9_10: Forward Error Correction Code 9/10
>   * @FEC_2_5:  Forward Error Correction Code 2/5
> + * @FEC_1_4:  Forward Error Correction Code 1/4
> + * @FEC_1_3:  Forward Error Correction Code 1/3
>   *
>   * Please note that not all FEC types are supported by a given standard.
>   */
> @@ -313,6 +315,8 @@ enum fe_code_rate {
>  	FEC_3_5,
>  	FEC_9_10,
>  	FEC_2_5,
> +	FEC_1_4,
> +	FEC_1_3,
>  };
>  
>  /**
> @@ -331,6 +335,9 @@ enum fe_code_rate {
>   * @APSK_32:	32-APSK modulation
>   * @DQPSK:	DQPSK modulation
>   * @QAM_4_NR:	4-QAM-NR modulation
> + * @APSK_64:	64-APSK modulation
> + * @APSK_128:	128-APSK modulation
> + * @APSK_256:	256-APSK modulation
>   *
>   * Please note that not all modulations are supported by a given standard.
>   *
> @@ -350,6 +357,9 @@ enum fe_modulation {
>  	APSK_32,
>  	DQPSK,
>  	QAM_4_NR,
> +	APSK_64,
> +	APSK_128,
> +	APSK_256,
>  };
>  
>  /**
> @@ -374,6 +384,8 @@ enum fe_modulation {
>   *	Single Carrier (C=1) transmission mode (DTMB only)
>   * @TRANSMISSION_MODE_C3780:
>   *	Multi Carrier (C=3780) transmission mode (DTMB only)
> + * @TRANSMISSION_MODE_64K:
> + *	Transmission mode 64K
>   *
>   * Please note that not all transmission modes are supported by a given
>   * standard.
> @@ -388,6 +400,7 @@ enum fe_transmit_mode {
>  	TRANSMISSION_MODE_32K,
>  	TRANSMISSION_MODE_C1,
>  	TRANSMISSION_MODE_C3780,
> +	TRANSMISSION_MODE_64K,
>  };
>  
>  /**



Thanks,
Mauro
