Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:54241 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab3GRPPw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jul 2013 11:15:52 -0400
Received: by mail-we0-f173.google.com with SMTP id x54so3009043wes.18
        for <linux-media@vger.kernel.org>; Thu, 18 Jul 2013 08:15:51 -0700 (PDT)
Message-ID: <51E8072C.5070600@googlemail.com>
Date: Thu, 18 Jul 2013 17:18:04 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Alban Browaeys <alban.browaeys@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, Alban Browaeys <prahal@yahoo.com>
Subject: Re: [PATCH 2/4] [media] em28xx: i2s 5 sample rates is a subset of
 3 one.
References: <1374015941-27538-1-git-send-email-prahal@yahoo.com>
In-Reply-To: <1374015941-27538-1-git-send-email-prahal@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 17.07.2013 01:05, schrieb Alban Browaeys:
> As:
> EM28XX_CHIPCFG_I2S_3_SAMPRATES 0x20
> EM28XX_CHIPCFG_I2S_5_SAMPRATES 0x30
>
> the board chipcfg is 0xf0 thus if 3_SAMPRATES is tested
> first and matches while it is a 5_SAMPRATES.
>
> Signed-off-by: Alban Browaeys <prahal@yahoo.com>
> ---
>  drivers/media/usb/em28xx/em28xx-core.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
> index fc157af..3c0c5e9 100644
> --- a/drivers/media/usb/em28xx/em28xx-core.c
> +++ b/drivers/media/usb/em28xx/em28xx-core.c
> @@ -505,13 +505,13 @@ int em28xx_audio_setup(struct em28xx *dev)
>  		dev->audio_mode.has_audio = false;
>  		return 0;
>  	} else if ((cfg & EM28XX_CHIPCFG_AUDIOMASK) ==
> -		   EM28XX_CHIPCFG_I2S_3_SAMPRATES) {
> -		em28xx_info("I2S Audio (3 sample rates)\n");
> -		dev->audio_mode.i2s_3rates = 1;
> -	} else if ((cfg & EM28XX_CHIPCFG_AUDIOMASK) ==
>  		   EM28XX_CHIPCFG_I2S_5_SAMPRATES) {
>  		em28xx_info("I2S Audio (5 sample rates)\n");
>  		dev->audio_mode.i2s_5rates = 1;
> +	} else if ((cfg & EM28XX_CHIPCFG_AUDIOMASK) ==
> +		   EM28XX_CHIPCFG_I2S_3_SAMPRATES) {
> +		em28xx_info("I2S Audio (3 sample rates)\n");
> +		dev->audio_mode.i2s_3rates = 1;
>  	}
>  
>  	if ((cfg & EM28XX_CHIPCFG_AUDIOMASK) != EM28XX_CHIPCFG_AC97) {

What changes ?
If chipcfg is 0xf0, chipcfg & EM28XX_CHIPCFG_AUDIOMASK = 0x30 =
EM28XX_CHIPCFG_I2S_5_SAMPRATES and not 0x20 =
EM28XX_CHIPCFG_I2S_3_SAMPRATES...

Frank
