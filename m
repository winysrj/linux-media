Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:46832 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059Ab3GRPL0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jul 2013 11:11:26 -0400
Received: by mail-bk0-f44.google.com with SMTP id 6so1232890bkj.3
        for <linux-media@vger.kernel.org>; Thu, 18 Jul 2013 08:11:25 -0700 (PDT)
Message-ID: <51E80622.3020803@googlemail.com>
Date: Thu, 18 Jul 2013 17:13:38 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Alban Browaeys <alban.browaeys@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, Alban Browaeys <prahal@yahoo.com>
Subject: Re: [PATCH 1/4] [media] em28xx: fix assignment of the eeprom data.
References: <1374015476-26197-1-git-send-email-prahal@yahoo.com>
In-Reply-To: <1374015476-26197-1-git-send-email-prahal@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 17.07.2013 00:57, schrieb Alban Browaeys:
> Set the config structure pointer to the eeprom data pointer (data,
> here eedata dereferenced) not the pointer to the pointer to
> the eeprom data (eedata itself).
>
> Signed-off-by: Alban Browaeys <prahal@yahoo.com>
> ---
>  drivers/media/usb/em28xx/em28xx-i2c.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
> index 4851cc2..c4ff973 100644
> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
> @@ -726,7 +726,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
>  
>  	*eedata = data;
>  	*eedata_len = len;
> -	dev_config = (void *)eedata;
> +	dev_config = (void *)*eedata;
>  
>  	switch (le16_to_cpu(dev_config->chip_conf) >> 4 & 0x3) {
>  	case 0:
Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>

Thanks,
Frank
