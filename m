Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:40203 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbaAEVGv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jan 2014 16:06:51 -0500
Received: by mail-ea0-f182.google.com with SMTP id a15so7578640eae.41
        for <linux-media@vger.kernel.org>; Sun, 05 Jan 2014 13:06:50 -0800 (PST)
Message-ID: <52C9C9AE.5070201@googlemail.com>
Date: Sun, 05 Jan 2014 22:07:58 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, unlisted-recipients:;
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] em28xx: unregister i2c bus 0 if bus 1 fails to register
References: <1388923553-24827-1-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1388923553-24827-1-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 05.01.2014 13:05, schrieb Mauro Carvalho Chehab:
> Fix the error handling logic, making it to unregister i2c bus 0, in
> case of a failure to register the second bus.
>
> Reported-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>  drivers/media/usb/em28xx/em28xx-cards.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> index 541de6df127b..dbce4dc421f9 100644
> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> @@ -2989,6 +2989,9 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
>  		if (retval < 0) {
>  			em28xx_errdev("%s: em28xx_i2c_register bus 1 - error [%d]!\n",
>  				__func__, retval);
> +
> +			em28xx_i2c_unregister(dev, 0);
> +
>  			return retval;
>  		}
>  	}

Reviewed-by: Frank Schäfer <fschaefer.oss@googlemail.com>

