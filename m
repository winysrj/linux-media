Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:32921 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaAMSwN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 13:52:13 -0500
Received: by mail-ea0-f179.google.com with SMTP id r15so3504534ead.24
        for <linux-media@vger.kernel.org>; Mon, 13 Jan 2014 10:52:12 -0800 (PST)
Message-ID: <52D43623.3010808@googlemail.com>
Date: Mon, 13 Jan 2014 19:53:23 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, unlisted-recipients:;
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 7/7] em28xx: Fix usb diconnect logic
References: <1389567649-26838-1-git-send-email-m.chehab@samsung.com> <1389567649-26838-8-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389567649-26838-8-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13.01.2014 00:00, Mauro Carvalho Chehab wrote:
> Now that everything is extension, the usb disconnect logic should
> be the same.
>
> While here, fix the device name.
>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>   drivers/media/usb/em28xx/em28xx-cards.c | 7 +------
>   1 file changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> index df92f417634a..8fc0a437054e 100644
> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> @@ -3384,12 +3384,7 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
>   
>   	dev->disconnected = 1;
>   
> -	if (dev->is_audio_only) {
> -		em28xx_close_extension(dev);
> -		return;
> -	}
> -
> -	em28xx_info("disconnecting %s\n", dev->vdev->name);
> +	em28xx_info("Disconnecting %s\n", dev->name);
>   
>   	flush_request_modules(dev);
Great.
I noticed this buggy section but finally forgot to remove it.

Reviewed-by: Frank Schäfer <fschaefer.oss@googlemail.com>
