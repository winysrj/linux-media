Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:54402 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948AbZHRXWT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2009 19:22:19 -0400
Subject: Re: [PATCH] Report only 32kHz for ALSA
From: hermann pitton <hermann-pitton@arcor.de>
To: =?UTF-8?Q?Old=C5=99ich_Jedli=C4=8Dka?= <oldium.pro@seznam.cz>
Cc: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <200908182124.54739.oldium.pro@seznam.cz>
References: <200908182124.54739.oldium.pro@seznam.cz>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 19 Aug 2009 01:16:38 +0200
Message-Id: <1250637398.3813.4.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Dienstag, den 18.08.2009, 21:24 +0200 schrieb Oldřich Jedlička:
> There are several reasons:
> 
>  - SAA7133/35 uses DDEP (DemDec Easy Programming mode), which works in 32kHz
>    only
>  - SAA7134 for TV mode uses DemDec mode (32kHz)
>  - Radio works in 32kHz only
>  - When recording 48kHz from Line1/Line2, switching of capture source to TV
>    means switching to 32kHz without any frequency translation
> 
> Signed-off-by: Oldřich Jedlička <oldium.pro@seznam.cz>

As discussed previously, this is an improvement within our current chip
specific capabilities. Thanks.

Acked-by: hermann pitton <hermann-pitton@arcor.de>

> diff --git a/linux/drivers/media/video/saa7134/saa7134-alsa.c b/linux/drivers/media/video/saa7134/saa7134-alsa.c
> index c09ec3e..504186a 100644
> --- a/linux/drivers/media/video/saa7134/saa7134-alsa.c
> +++ b/linux/drivers/media/video/saa7134/saa7134-alsa.c
> @@ -440,6 +440,16 @@ snd_card_saa7134_capture_pointer(struct snd_pcm_substream * substream)
>  
>  /*
>   * ALSA hardware capabilities definition
> + *
> + *  Report only 32kHz for ALSA:
> + *
> + *  - SAA7133/35 uses DDEP (DemDec Easy Programming mode), which works in 32kHz
> + *    only
> + *  - SAA7134 for TV mode uses DemDec mode (32kHz)
> + *  - Radio works in 32kHz only
> + *  - When recording 48kHz from Line1/Line2, switching of capture source to TV
> + *    means
> + *    switching to 32kHz without any frequency translation
>   */
>  
>  static struct snd_pcm_hardware snd_card_saa7134_capture =
> @@ -453,9 +463,9 @@ static struct snd_pcm_hardware snd_card_saa7134_capture =
>  				SNDRV_PCM_FMTBIT_U8 | \
>  				SNDRV_PCM_FMTBIT_U16_LE | \
>  				SNDRV_PCM_FMTBIT_U16_BE,
> -	.rates =		SNDRV_PCM_RATE_32000 | SNDRV_PCM_RATE_48000,
> +	.rates =		SNDRV_PCM_RATE_32000,
>  	.rate_min =		32000,
> -	.rate_max =		48000,
> +	.rate_max =		32000,
>  	.channels_min =		1,
>  	.channels_max =		2,
>  	.buffer_bytes_max =	(256*1024),
> --


