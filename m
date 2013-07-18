Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:43681 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756Ab3GRPZI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jul 2013 11:25:08 -0400
Received: by mail-ea0-f169.google.com with SMTP id h15so1831032eak.0
        for <linux-media@vger.kernel.org>; Thu, 18 Jul 2013 08:25:06 -0700 (PDT)
Message-ID: <51E80958.2000701@googlemail.com>
Date: Thu, 18 Jul 2013 17:27:20 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Alban Browaeys <alban.browaeys@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, Alban Browaeys <prahal@yahoo.com>
Subject: Re: [PATCH 3/4] [media] em28xx: usb power config is in the low byte.
References: <1374015983-27615-1-git-send-email-prahal@yahoo.com>
In-Reply-To: <1374015983-27615-1-git-send-email-prahal@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 17.07.2013 01:06, schrieb Alban Browaeys:
> According to the em2860 datasheet, eeprom byte 08H is Chip
> Configuration Low Byte and 09H is High Byte.
> Usb power configuration is in the Low byte (same as the usb audio
>  class config).
>
> Signed-off-by: Alban Browaeys <prahal@yahoo.com>
> ---
>  drivers/media/usb/em28xx/em28xx-i2c.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
> index c4ff973..6ff7415 100644
> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
> @@ -743,13 +743,13 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
>  		break;
>  	}
>  
> -	if (le16_to_cpu(dev_config->chip_conf) & 1 << 3)
> +	if (le16_to_cpu(dev_config->chip_conf) >> 4 & 1 << 3)
>  		em28xx_info("\tUSB Remote wakeup capable\n");
>  
> -	if (le16_to_cpu(dev_config->chip_conf) & 1 << 2)
> +	if (le16_to_cpu(dev_config->chip_conf) >> 4 & 1 << 2)
>  		em28xx_info("\tUSB Self power capable\n");
>  
> -	switch (le16_to_cpu(dev_config->chip_conf) & 0x3) {
> +	switch (le16_to_cpu(dev_config->chip_conf) >> 4 & 0x3) {
>  	case 0:
>  		em28xx_info("\t500mA max power\n");
>  		break;

NACK.
According to my datasheet excerpt (EM2860 Hardware Specification
8/18/2004), bits 0:3 are used for USB configuration and bits 4:7 for
audio configuration.
So the current code is correct.

Regards,
Frank
