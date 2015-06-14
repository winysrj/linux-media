Return-path: <linux-media-owner@vger.kernel.org>
Received: from iodev.co.uk ([82.211.30.53]:56594 "EHLO iodev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbbFNV7H (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2015 17:59:07 -0400
Date: Sun, 14 Jun 2015 18:51:08 -0300
From: Ismael Luceno <ismael@iodev.co.uk>
To: khalasa@piap.pl (Krzysztof =?UTF-8?B?SGHFgmFzYQ==?=)
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] SOLO6x10: Fix G.723 minimum audio period count.
Message-ID: <20150614185108.43b02128@pirotess>
In-Reply-To: <m33822xr06.fsf@t19.piap.pl>
References: <m3a8waxr86.fsf@t19.piap.pl>
	<m33822xr06.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 08 Jun 2015 15:35:05 +0200
khalasa@piap.pl (Krzysztof Hałasa) wrote:
> The period count is fixed, don't confuse ALSA.
> 
> Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>
> 
> --- a/drivers/media/pci/solo6x10/solo6x10-g723.c
> +++ b/drivers/media/pci/solo6x10/solo6x10-g723.c
> @@ -48,10 +48,8 @@
>  /* The solo writes to 1k byte pages, 32 pages, in the dma. Each 1k
> page
>   * is broken down to 20 * 48 byte regions (one for each channel
> possible)
>   * with the rest of the page being dummy data. */
> -#define G723_MAX_BUFFER		(G723_PERIOD_BYTES *
> PERIODS_MAX) +#define PERIODS			G723_FDMA_PAGES
>  #define G723_INTR_ORDER		4 /* 0 - 4 */
> -#define PERIODS_MIN		(1 << G723_INTR_ORDER)
> -#define PERIODS_MAX		G723_FDMA_PAGES
>  
>  struct solo_snd_pcm {
>  	int				on;
> @@ -130,11 +128,11 @@ static const struct snd_pcm_hardware
> snd_solo_pcm_hw = { .rate_max		= SAMPLERATE,
>  	.channels_min		= 1,
>  	.channels_max		= 1,
> -	.buffer_bytes_max	= G723_MAX_BUFFER,
> +	.buffer_bytes_max	= G723_PERIOD_BYTES * PERIODS,
>  	.period_bytes_min	= G723_PERIOD_BYTES,
>  	.period_bytes_max	= G723_PERIOD_BYTES,
> -	.periods_min		= PERIODS_MIN,
> -	.periods_max		= PERIODS_MAX,
> +	.periods_min		= PERIODS,
> +	.periods_max		= PERIODS,
>  };
>  
>  static int snd_solo_pcm_open(struct snd_pcm_substream *ss)
> @@ -340,7 +338,8 @@ static int solo_snd_pcm_init(struct solo_dev
> *solo_dev) ret = snd_pcm_lib_preallocate_pages_for_all(pcm,
>  					SNDRV_DMA_TYPE_CONTINUOUS,
>  					snd_dma_continuous_data(GFP_KERNEL),
> -					G723_MAX_BUFFER,
> G723_MAX_BUFFER);
> +					G723_PERIOD_BYTES * PERIODS,
> +					G723_PERIOD_BYTES * PERIODS);
>  	if (ret < 0)
>  		return ret;
>  
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-media" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>
