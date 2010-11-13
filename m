Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:49904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398Ab0KMOdc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Nov 2010 09:33:32 -0500
Message-ID: <4CDEA1AE.3030004@redhat.com>
Date: Sat, 13 Nov 2010 12:33:18 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Linux I2C <linux-i2c@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 1/3] i2c: Delete unused adapter IDs
References: <20101105210645.6e47498c@endymion.delvare>
In-Reply-To: <20101105210645.6e47498c@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 05-11-2010 18:06, Jean Delvare escreveu:
> Delete unused I2C adapter IDs. Special cases are:
> 
> * I2C_HW_B_RIVA was still set in driver rivafb, however no other
>   driver is ever looking for this value, so we can safely remove it.
> * I2C_HW_B_HDPVR is used in staging driver lirc_zilog, however no
>   adapter ID is ever set to this value, so the code in question never
>   runs. As the code additionally expects that I2C_HW_B_HDPVR may not
>   be defined, we can delete it now and let the lirc_zilog driver
>   maintainer rewrite this piece of code.
> 
> Big thanks for Hans Verkuil for doing all the hard work :)
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Cc: Jarod Wilson <jarod@redhat.com>

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/video/riva/rivafb-i2c.c |    1 -
>  include/linux/i2c-id.h          |   22 ----------------------
>  2 files changed, 23 deletions(-)
> 
> --- linux-2.6.37-rc1.orig/include/linux/i2c-id.h	2010-11-05 13:55:17.000000000 +0100
> +++ linux-2.6.37-rc1/include/linux/i2c-id.h	2010-11-05 15:05:32.000000000 +0100
> @@ -32,28 +32,6 @@
>   */
>  
>  /* --- Bit algorithm adapters						*/
> -#define I2C_HW_B_BT848		0x010005 /* BT848 video boards */
> -#define I2C_HW_B_RIVA		0x010010 /* Riva based graphics cards */
> -#define I2C_HW_B_ZR36067	0x010019 /* Zoran-36057/36067 based boards */
>  #define I2C_HW_B_CX2388x	0x01001b /* connexant 2388x based tv cards */
> -#define I2C_HW_B_EM28XX		0x01001f /* em28xx video capture cards */
> -#define I2C_HW_B_CX2341X	0x010020 /* Conexant CX2341X MPEG encoder cards */
> -#define I2C_HW_B_CX23885	0x010022 /* conexant 23885 based tv cards (bus1) */
> -#define I2C_HW_B_AU0828		0x010023 /* auvitek au0828 usb bridge */
> -#define I2C_HW_B_CX231XX	0x010024 /* Conexant CX231XX USB based cards */
> -#define I2C_HW_B_HDPVR		0x010025 /* Hauppauge HD PVR */
> -
> -/* --- SGI adapters							*/
> -#define I2C_HW_SGI_VINO		0x160000
> -
> -/* --- SMBus only adapters						*/
> -#define I2C_HW_SMBUS_W9968CF	0x04000d
> -#define I2C_HW_SMBUS_OV511	0x04000e /* OV511(+) USB 1.1 webcam ICs */
> -#define I2C_HW_SMBUS_OV518	0x04000f /* OV518(+) USB 1.1 webcam ICs */
> -#define I2C_HW_SMBUS_CAFE	0x040012 /* Marvell 88ALP01 "CAFE" cam  */
> -
> -/* --- Miscellaneous adapters */
> -#define I2C_HW_SAA7146		0x060000 /* SAA7146 video decoder bus */
> -#define I2C_HW_SAA7134		0x090000 /* SAA7134 video decoder bus */
>  
>  #endif /* LINUX_I2C_ID_H */
> --- linux-2.6.37-rc1.orig/drivers/video/riva/rivafb-i2c.c	2010-11-05 13:55:17.000000000 +0100
> +++ linux-2.6.37-rc1/drivers/video/riva/rivafb-i2c.c	2010-11-05 13:55:19.000000000 +0100
> @@ -94,7 +94,6 @@ static int __devinit riva_setup_i2c_bus(
>  
>  	strcpy(chan->adapter.name, name);
>  	chan->adapter.owner		= THIS_MODULE;
> -	chan->adapter.id		= I2C_HW_B_RIVA;
>  	chan->adapter.class		= i2c_class;
>  	chan->adapter.algo_data		= &chan->algo;
>  	chan->adapter.dev.parent	= &chan->par->pdev->dev;
> 
> 

