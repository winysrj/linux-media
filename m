Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35645 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932102AbdEGWKt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 7 May 2017 18:10:49 -0400
Subject: Re: [PATCH v3 1/2] em28xx: Ignore errors while reading from eeprom
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <cover.1493776983.git.mchehab@s-opensource.com>
 <15f3ba8371344a8dac830797216c06e9c5524a81.1493776983.git.mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
From: =?UTF-8?Q?Frank_Sch=c3=a4fer?= <fschaefer.oss@googlemail.com>
Message-ID: <b0c22963-e56f-8236-1386-ea2a15aea0d7@googlemail.com>
Date: Sun, 7 May 2017 19:55:03 +0200
MIME-Version: 1.0
In-Reply-To: <15f3ba8371344a8dac830797216c06e9c5524a81.1493776983.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 03.05.2017 um 04:12 schrieb Mauro Carvalho Chehab:
> While testing support for Terratec H6 rev. 2, it was noticed
> that reading from eeprom there causes a timeout error.
>
> Apparently, this is due to the need of properly setting GPIOs.
>
> In any case, the driver doesn't really require eeprom reading
> to succeed, as this is currently used only for debug.
>
> So, Ignore such errors.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/usb/em28xx/em28xx-i2c.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
> index 8c472d5adb50..60b195c157b8 100644
> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
> @@ -982,8 +982,6 @@ int em28xx_i2c_register(struct em28xx *dev, unsigned bus,
>  			dev_err(&dev->intf->dev,
>  				"%s: em28xx_i2_eeprom failed! retval [%d]\n",
>  				__func__, retval);
> -
> -			return retval;
>  		}
>  	}
>  
Makes sense.

Acked-by: Frank Schäfer <fschaefer.oss@googlemail.com>
