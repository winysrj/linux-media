Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:34844 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaAOVU2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jan 2014 16:20:28 -0500
Received: by mail-ee0-f52.google.com with SMTP id e53so1126450eek.25
        for <linux-media@vger.kernel.org>; Wed, 15 Jan 2014 13:20:27 -0800 (PST)
Message-ID: <52D6FBD7.4080005@googlemail.com>
Date: Wed, 15 Jan 2014 22:21:27 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, unlisted-recipients:;
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] [media] em28xx-audio: flush work at .fini
References: <1389717879-24939-1-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389717879-24939-1-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 14.01.2014 17:44, schrieb Mauro Carvalho Chehab:
> As a pending action might be still there at the work
> thread, flush it.
>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>  drivers/media/usb/em28xx/em28xx-audio.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
> index 74575e0ed41b..1563f71a5ea2 100644
> --- a/drivers/media/usb/em28xx/em28xx-audio.c
> +++ b/drivers/media/usb/em28xx/em28xx-audio.c
> @@ -967,6 +967,8 @@ static int em28xx_audio_fini(struct em28xx *dev)
>  	em28xx_info("Closing audio extension");
>  
>  	snd_card_disconnect(dev->adev.sndcard);
> +	flush_work(&dev->wq_trigger);
> +
>  	em28xx_audio_free_urb(dev);
>  
>  	if (dev->adev.sndcard) {
audio_trigger() doesn't re-schedule the work and flush_work() waits
until the current work is finished.

No, wait ! You are calling flush_work here for synchronization, right ?
That makes sense, but you should update the patch description. ;)


