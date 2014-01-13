Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42984 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbaAMSqQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 13:46:16 -0500
Received: by mail-ee0-f46.google.com with SMTP id d49so3353049eek.33
        for <linux-media@vger.kernel.org>; Mon, 13 Jan 2014 10:46:14 -0800 (PST)
Message-ID: <52D434BE.5080603@googlemail.com>
Date: Mon, 13 Jan 2014 19:47:26 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, unlisted-recipients:;
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 4/7] em28xx-audio: disconnect before freeing URBs
References: <1389567649-26838-1-git-send-email-m.chehab@samsung.com> <1389567649-26838-5-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389567649-26838-5-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13.01.2014 00:00, Mauro Carvalho Chehab wrote:
> URBs might be in usage. Disconnect the device before freeing
> them.
>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>   drivers/media/usb/em28xx/em28xx-audio.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
> index 8e959dae8358..cdc2fcf3e05e 100644
> --- a/drivers/media/usb/em28xx/em28xx-audio.c
> +++ b/drivers/media/usb/em28xx/em28xx-audio.c
> @@ -958,6 +958,7 @@ static int em28xx_audio_fini(struct em28xx *dev)
>   		return 0;
>   	}
>   
> +	snd_card_disconnect(dev->adev.sndcard);
>   	em28xx_audio_free_urb(dev);
>   
>   	if (dev->adev.sndcard) {

Reviewed-by: Frank Schäfer <fschaefer.oss@googlemail.com>

