Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:35384 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab3LVQJq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Dec 2013 11:09:46 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MY7002QPU88IV50@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Sun, 22 Dec 2013 11:09:44 -0500 (EST)
Date: Sun, 22 Dec 2013 14:09:40 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] em28xx: fix I2S audio sample rate definitions and info
 output
Message-id: <20131222140940.282a6894@samsung.com>
In-reply-to: <1387721866-8408-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1387721866-8408-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 22 Dec 2013 15:17:46 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> The audio configuration in chip config register 0x00 and eeprom are always
> consistent. But currently the audio configuration #defines for the chip config
> register say 0x20 means 3 sample rates and 0x30 5 sample rates, while the eeprom
> info output says 0x20 means 1 sample rate and 0x30 3 sample rates.
> 
> I've checked the datasheet excerpts I have and it seems that the meaning of
> these bits is different for em2820/40 (1 and 3 sample rates) and em2860+
> (3 and 5 smaple rates).
> I have also checked my Hauppauge WinTV USB 2 (em2840) and the chip/eeprom
> audio config 0x20 matches the sample rates reproted by the USB device
> descriptor (32k only).
> 
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/usb/em28xx/em28xx-core.c |   24 +++++++++++++-----------
>  drivers/media/usb/em28xx/em28xx-i2c.c  |   10 ++++++++--
>  drivers/media/usb/em28xx/em28xx-reg.h  |   10 ++++++----
>  drivers/media/usb/em28xx/em28xx.h      |    3 +--
>  4 Dateien geändert, 28 Zeilen hinzugefügt(+), 19 Zeilen entfernt(-)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
> index f6076a5..192b657 100644
> --- a/drivers/media/usb/em28xx/em28xx-core.c
> +++ b/drivers/media/usb/em28xx/em28xx-core.c
> @@ -525,17 +525,19 @@ int em28xx_audio_setup(struct em28xx *dev)
>  		dev->has_alsa_audio = false;
>  		dev->audio_mode.has_audio = false;
>  		return 0;
> -	} else if ((cfg & EM28XX_CHIPCFG_AUDIOMASK) ==
> -		   EM28XX_CHIPCFG_I2S_3_SAMPRATES) {
> -		em28xx_info("I2S Audio (3 sample rates)\n");
> -		dev->audio_mode.i2s_3rates = 1;
> -	} else if ((cfg & EM28XX_CHIPCFG_AUDIOMASK) ==
> -		   EM28XX_CHIPCFG_I2S_5_SAMPRATES) {
> -		em28xx_info("I2S Audio (5 sample rates)\n");
> -		dev->audio_mode.i2s_5rates = 1;
> -	}
> -
> -	if ((cfg & EM28XX_CHIPCFG_AUDIOMASK) != EM28XX_CHIPCFG_AC97) {
> +	} else if ((cfg & EM28XX_CHIPCFG_AUDIOMASK) != EM28XX_CHIPCFG_AC97) {
> +		if (dev->chip_id < CHIP_ID_EM2860 &&
> +	            (cfg & EM28XX_CHIPCFG_AUDIOMASK) ==
> +		    EM2820_CHIPCFG_I2S_1_SAMPRATE)
> +			dev->audio_mode.i2s_samplerates = 1;

No need to store it at all, as, at least currently, this is not used
anywhere.

This patch could be useful if we could use this to improve em28xx-audio.c.

Otherwise, I would just drop the code that checks it, eventually
just keeping the registers at em28xx-reg.h

> +		else if (dev->chip_id >= CHIP_ID_EM2860 &&
> +			 (cfg & EM28XX_CHIPCFG_AUDIOMASK) ==
> +			 EM2860_CHIPCFG_I2S_5_SAMPRATES)
> +			dev->audio_mode.i2s_samplerates = 5;
> +		else
> +			dev->audio_mode.i2s_samplerates = 3;
> +		em28xx_info("I2S Audio (%d sample rate(s))\n",
> +					       dev->audio_mode.i2s_samplerates);
>  		/* Skip the code that does AC97 vendor detection */
>  		dev->audio_mode.ac97 = EM28XX_NO_AC97;
>  		goto init_audio;
> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
> index c4ff973..f2d5f8a 100644
> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
> @@ -736,10 +736,16 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
>  		em28xx_info("\tAC97 audio (5 sample rates)\n");
>  		break;
>  	case 2:
> -		em28xx_info("\tI2S audio, sample rate=32k\n");
> +		if (dev->chip_id < CHIP_ID_EM2860)
> +			em28xx_info("\tI2S audio, sample rate=32k\n");
> +		else
> +			em28xx_info("\tI2S audio, 3 sample rates\n");
>  		break;
>  	case 3:
> -		em28xx_info("\tI2S audio, 3 sample rates\n");
> +		if (dev->chip_id < CHIP_ID_EM2860)
> +			em28xx_info("\tI2S audio, 3 sample rates\n");
> +		else
> +			em28xx_info("\tI2S audio, 5 sample rates\n");
>  		break;
>  	}
>  
> diff --git a/drivers/media/usb/em28xx/em28xx-reg.h b/drivers/media/usb/em28xx/em28xx-reg.h
> index b769ceb..311fb34 100644
> --- a/drivers/media/usb/em28xx/em28xx-reg.h
> +++ b/drivers/media/usb/em28xx/em28xx-reg.h
> @@ -25,10 +25,12 @@
>  #define EM28XX_R00_CHIPCFG	0x00
>  
>  /* em28xx Chip Configuration 0x00 */
> -#define EM28XX_CHIPCFG_VENDOR_AUDIO		0x80
> -#define EM28XX_CHIPCFG_I2S_VOLUME_CAPABLE	0x40
> -#define EM28XX_CHIPCFG_I2S_5_SAMPRATES		0x30
> -#define EM28XX_CHIPCFG_I2S_3_SAMPRATES		0x20
> +#define EM2860_CHIPCFG_VENDOR_AUDIO		0x80
> +#define EM2860_CHIPCFG_I2S_VOLUME_CAPABLE	0x40
> +#define EM2820_CHIPCFG_I2S_3_SAMPRATES		0x30
> +#define EM2860_CHIPCFG_I2S_5_SAMPRATES		0x30
> +#define EM2820_CHIPCFG_I2S_1_SAMPRATE		0x20
> +#define EM2860_CHIPCFG_I2S_3_SAMPRATES		0x20
>  #define EM28XX_CHIPCFG_AC97			0x10
>  #define EM28XX_CHIPCFG_AUDIOMASK		0x30
>  
> diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
> index 191ef35..4d8c7d2 100644
> --- a/drivers/media/usb/em28xx/em28xx.h
> +++ b/drivers/media/usb/em28xx/em28xx.h
> @@ -292,8 +292,7 @@ struct em28xx_audio_mode {
>  
>  	unsigned int has_audio:1;
>  
> -	unsigned int i2s_3rates:1;
> -	unsigned int i2s_5rates:1;
> +	u8 i2s_samplerates;
>  };
>  
>  /* em28xx has two audio inputs: tuner and line in.


-- 

Cheers,
Mauro
