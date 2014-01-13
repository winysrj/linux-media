Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42869 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbaAMShX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 13:37:23 -0500
Received: by mail-ee0-f46.google.com with SMTP id d49so3348881eek.33
        for <linux-media@vger.kernel.org>; Mon, 13 Jan 2014 10:37:22 -0800 (PST)
Message-ID: <52D432A8.5070206@googlemail.com>
Date: Mon, 13 Jan 2014 19:38:32 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, unlisted-recipients:;
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/7] em28xx-audio: fix return code on device disconnect
References: <1389567649-26838-1-git-send-email-m.chehab@samsung.com> <1389567649-26838-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389567649-26838-2-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13.01.2014 00:00, Mauro Carvalho Chehab wrote:
> Alsa has an special non-negative return code to indicate device removal
> at snd_em28xx_capture_pointer(). Use it, instead of an error code.
>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>   drivers/media/usb/em28xx/em28xx-audio.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
> index f3e320098f79..47766b796acb 100644
> --- a/drivers/media/usb/em28xx/em28xx-audio.c
> +++ b/drivers/media/usb/em28xx/em28xx-audio.c
> @@ -434,7 +434,7 @@ static snd_pcm_uframes_t snd_em28xx_capture_pointer(struct snd_pcm_substream
>   
>   	dev = snd_pcm_substream_chip(substream);
>   	if (dev->disconnected)
> -		return -ENODEV;
> +		return SNDRV_PCM_POS_XRUN;
>   
>   	spin_lock_irqsave(&dev->adev.slock, flags);
>   	hwptr_done = dev->adev.hwptr_done_capture;

Reviewed-by: Frank Schäfer <fschaefer.oss@googlemail.com>
