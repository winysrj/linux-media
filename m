Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:64205 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaAMSjz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 13:39:55 -0500
Received: by mail-ee0-f50.google.com with SMTP id d17so883133eek.37
        for <linux-media@vger.kernel.org>; Mon, 13 Jan 2014 10:39:54 -0800 (PST)
Message-ID: <52D43341.7040706@googlemail.com>
Date: Mon, 13 Jan 2014 19:41:05 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, unlisted-recipients:;
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/7] em28xx-audio: simplify error handling
References: <1389567649-26838-1-git-send-email-m.chehab@samsung.com> <1389567649-26838-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389567649-26838-3-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13.01.2014 00:00, Mauro Carvalho Chehab wrote:
> Cleanup the error handling code at em28xx-audio init.
>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>   drivers/media/usb/em28xx/em28xx-audio.c | 27 ++++++++++++++-------------
>   1 file changed, 14 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
> index 47766b796acb..97d9105e6830 100644
> --- a/drivers/media/usb/em28xx/em28xx-audio.c
> +++ b/drivers/media/usb/em28xx/em28xx-audio.c
> @@ -893,10 +893,8 @@ static int em28xx_audio_init(struct em28xx *dev)
>   	adev->udev = dev->udev;
>   
>   	err = snd_pcm_new(card, "Em28xx Audio", 0, 0, 1, &pcm);
> -	if (err < 0) {
> -		snd_card_free(card);
> -		return err;
> -	}
> +	if (err < 0)
> +		goto card_free;
>   
>   	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &snd_em28xx_pcm_capture);
>   	pcm->info_flags = 0;
> @@ -927,20 +925,23 @@ static int em28xx_audio_init(struct em28xx *dev)
>   	}
>   
>   	err = em28xx_audio_urb_init(dev);
> -	if (err) {
> -		snd_card_free(card);
> -		return -ENODEV;
> -	}
> +	if (err)
> +		goto card_free;
>   
>   	err = snd_card_register(card);
> -	if (err < 0) {
> -		em28xx_audio_free_urb(dev);
> -		snd_card_free(card);
> -		return err;
> -	}
> +	if (err < 0)
> +		goto urb_free;
>   
>   	em28xx_info("Audio extension successfully initialized\n");
>   	return 0;
> +
> +urb_free:
> +	em28xx_audio_free_urb(dev);
> +
> +card_free:
> +	snd_card_free(card);
> +
> +	return err;
>   }
>   
>   static int em28xx_audio_fini(struct em28xx *dev)
Reviewed-by: Frank Schäfer <fschaefer.oss@googlemail.com>

