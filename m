Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f198.google.com ([209.85.216.198]:59431 "EHLO
	mail-px0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935629Ab0COI7G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Mar 2010 04:59:06 -0400
Received: by pxi36 with SMTP id 36so1736245pxi.21
        for <linux-media@vger.kernel.org>; Mon, 15 Mar 2010 01:59:04 -0700 (PDT)
Message-ID: <4B9DF759.2070400@gmail.com>
Date: Mon, 15 Mar 2010 17:01:13 +0800
From: Huang Shijie <shijie8@gmail.com>
MIME-Version: 1.0
To: Huang Shijie <shijie8@gmail.com>
CC: mchehab@redhat.com, linux-media@vger.kernel.org
Subject: Re: [BUGFIX][PATCH] change some parameters for tlg2300
References: <1268642648-3132-1-git-send-email-shijie8@gmail.com>
In-Reply-To: <1268642648-3132-1-git-send-email-shijie8@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro:
Please ignore this patch.
This patch has side effect : the radio does not run well with this patch.

Best Regards
Huang Shijie.

> The orgin parameters may cause a bug : The audio may lost in certain
> situation (such as open the VLC at the first time).
>
> The origin parameters set a small stop_threshold for snd_pcm_runtime{}.
> So a xrun occurs in some situation.
>
> Signed-off-by: Huang Shijie <shijie8@gmail.com>
> ---
>  drivers/media/video/tlg2300/pd-alsa.c |   10 ----------
>  1 files changed, 0 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/media/video/tlg2300/pd-alsa.c b/drivers/media/video/tlg2300/pd-alsa.c
> index 6f42621..e9ad715 100644
> --- a/drivers/media/video/tlg2300/pd-alsa.c
> +++ b/drivers/media/video/tlg2300/pd-alsa.c
> @@ -21,9 +21,6 @@
>  static void complete_handler_audio(struct urb *urb);
>  #define AUDIO_EP	(0x83)
>  #define AUDIO_BUF_SIZE	(512)
> -#define PERIOD_SIZE	(1024 * 8)
> -#define PERIOD_MIN	(4)
> -#define PERIOD_MAX 	PERIOD_MIN
>  
>  static struct snd_pcm_hardware snd_pd_hw_capture = {
>  	.info = SNDRV_PCM_INFO_BLOCK_TRANSFER |
> @@ -38,18 +35,11 @@ static struct snd_pcm_hardware snd_pd_hw_capture = {
>  	.rate_max = 48000,
>  	.channels_min = 2,
>  	.channels_max = 2,
> -	.buffer_bytes_max = PERIOD_SIZE * PERIOD_MIN,
> -	.period_bytes_min = PERIOD_SIZE,
> -	.period_bytes_max = PERIOD_SIZE,
> -	.periods_min = PERIOD_MIN,
> -	.periods_max = PERIOD_MAX,
> -	/*
>  	.buffer_bytes_max = 62720 * 8,
>  	.period_bytes_min = 64,
>  	.period_bytes_max = 12544,
>  	.periods_min = 2,
>  	.periods_max = 98
> -	*/
>  };
>  
>  static int snd_pd_capture_open(struct snd_pcm_substream *substream)
>   

