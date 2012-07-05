Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab2GEQ5g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jul 2012 12:57:36 -0400
Message-ID: <4FF5C77C.7030500@redhat.com>
Date: Thu, 05 Jul 2012 13:57:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] em28xx: Remove useless runtime->private_data usage
References: <1339509222-2714-1-git-send-email-elezegarcia@gmail.com> <1339509222-2714-2-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1339509222-2714-2-git-send-email-elezegarcia@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 12-06-2012 10:53, Ezequiel Garcia escreveu:
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> ---
>   drivers/media/video/em28xx/em28xx-audio.c |    1 -
>   1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/em28xx/em28xx-audio.c b/drivers/media/video/em28xx/em28xx-audio.c
> index d7e2a3d..2fcddae 100644
> --- a/drivers/media/video/em28xx/em28xx-audio.c
> +++ b/drivers/media/video/em28xx/em28xx-audio.c
> @@ -305,7 +305,6 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
>   
>   	snd_pcm_hw_constraint_integer(runtime, SNDRV_PCM_HW_PARAM_PERIODS);
>   	dev->adev.capture_pcm_substream = substream;
> -	runtime->private_data = dev;


Are you sure that this can be removed? I think this is used internally
by the alsa API, but maybe something has changed and this is not
required anymore.

Had you test em28xx audio with this change?

Regards,
Mauro
