Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.seznam.cz ([77.75.72.43]:60242 "EHLO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbZESRy1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 13:54:27 -0400
From: Oldrich Jedlicka <oldium.pro@seznam.cz>
To: LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH][RESEND] Use correct sampling rate for TV/FM radio
Date: Tue, 19 May 2009 19:54:18 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
References: <200904142048.14713.oldium.pro@seznam.cz>
In-Reply-To: <200904142048.14713.oldium.pro@seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905191954.19097.oldium.pro@seznam.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 14 of April 2009 at 20:48:14, Oldrich Jedlicka wrote:
> Here is the fix for using the 32kHz sampling rate for TV and FM radio
> (ALSA). The TV uses 32kHz anyway (mode 0; 32kHz demdec on), radio works
> only with 32kHz (mode 1; 32kHz baseband). The ALSA wrongly reported 32kHz
> and 48kHz for everything (TV, radio, LINE1/2).
>
> Now it should be possible to just use the card without the need to change
> the capture rate from 48kHz to 32kHz. Enjoy :-)
>

Hi Mauro,

are there some comments for/against this patch? It is rather long time when I 
sent it, so I would like to know some opinions.

The reason behind this patch is that the code uses 32kHz for TV and for radio 
(the radio cannot use other frequency as far as I know). ALSA then reports 
both 32kHz and 48kHz for TV/radio, but 48kHz cannot be used.

Thanks!

Cheers,
Oldrich.

> Now without word-wrapping.
>
> Signed-off-by: Oldřich Jedlička <oldium.pro@seznam.cz>
> ---
> diff -r dba0b6fae413 linux/drivers/media/video/saa7134/saa7134-alsa.c
> --- a/linux/drivers/media/video/saa7134/saa7134-alsa.c	Thu Apr 09 08:21:42
> 2009 -0300 +++ b/linux/drivers/media/video/saa7134/saa7134-alsa.c	Mon Apr
> 13 23:07:22 2009 +0200 @@ -465,6 +465,29 @@
>  	.periods_max =		1024,
>  };
>
> +static struct snd_pcm_hardware snd_card_saa7134_capture_32kHz_only =
> +{
> +	.info =                 (SNDRV_PCM_INFO_MMAP | SNDRV_PCM_INFO_INTERLEAVED
> | +				 SNDRV_PCM_INFO_BLOCK_TRANSFER |
> +				 SNDRV_PCM_INFO_MMAP_VALID),
> +	.formats =		SNDRV_PCM_FMTBIT_S16_LE | \
> +				SNDRV_PCM_FMTBIT_S16_BE | \
> +				SNDRV_PCM_FMTBIT_S8 | \
> +				SNDRV_PCM_FMTBIT_U8 | \
> +				SNDRV_PCM_FMTBIT_U16_LE | \
> +				SNDRV_PCM_FMTBIT_U16_BE,
> +	.rates =		SNDRV_PCM_RATE_32000,
> +	.rate_min =		32000,
> +	.rate_max =		32000,
> +	.channels_min =		1,
> +	.channels_max =		2,
> +	.buffer_bytes_max =	(256*1024),
> +	.period_bytes_min =	64,
> +	.period_bytes_max =	(256*1024),
> +	.periods_min =		4,
> +	.periods_max =		1024,
> +};
> +
>  static void snd_card_saa7134_runtime_free(struct snd_pcm_runtime *runtime)
>  {
>  	snd_card_saa7134_pcm_t *pcm = runtime->private_data;
> @@ -651,7 +674,13 @@
>  	pcm->substream = substream;
>  	runtime->private_data = pcm;
>  	runtime->private_free = snd_card_saa7134_runtime_free;
> -	runtime->hw = snd_card_saa7134_capture;
> +
> +	if (amux == TV || &card(dev).radio == dev->input) {
> +		/* TV uses 32kHz sampling, AM/FM radio is locked to 32kHz */
> +		runtime->hw = snd_card_saa7134_capture_32kHz_only;
> +	} else {
> +		runtime->hw = snd_card_saa7134_capture;
> +	}
>
>  	if (dev->ctl_mute != 0) {
>  		saa7134->mute_was_on = 1;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


