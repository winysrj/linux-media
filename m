Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755691Ab3AEDSB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 22:18:01 -0500
Date: Sat, 5 Jan 2013 00:39:50 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 6/6] ir-kbd-i2c: fix get_key_knc1()
Message-ID: <20130105003950.5463ee70@redhat.com>
In-Reply-To: <1356649368-5426-7-git-send-email-fschaefer.oss@googlemail.com>
References: <1356649368-5426-1-git-send-email-fschaefer.oss@googlemail.com>
	<1356649368-5426-7-git-send-email-fschaefer.oss@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 28 Dec 2012 00:02:48 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> - return valid key code when button is hold
> - debug: print key code only when a button is pressed
> 
> Tested with device "Terratec Cinergy 200 USB" (em28xx).
> 
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/i2c/ir-kbd-i2c.c |   15 +++++----------
>  1 Datei geändert, 5 Zeilen hinzugefügt(+), 10 Zeilen entfernt(-)
> 
> diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
> index 08ae067..2984b7d 100644
> --- a/drivers/media/i2c/ir-kbd-i2c.c
> +++ b/drivers/media/i2c/ir-kbd-i2c.c
> @@ -184,18 +184,13 @@ static int get_key_knc1(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
>  		return -EIO;
>  	}
>  
> -	/* it seems that 0xFE indicates that a button is still hold
> -	   down, while 0xff indicates that no button is hold
> -	   down. 0xfe sequences are sometimes interrupted by 0xFF */
> -
> -	dprintk(2,"key %02x\n", b);
> -
> -	if (b == 0xff)
> +	if (b == 0xff) /* no button */
>  		return 0;
>  
> -	if (b == 0xfe)
> -		/* keep old data */
> -		return 1;
> +	if (b == 0xfe) /* button is still hold */
> +		b = ir->rc->last_scancode; /* keep old data */
> +
> +	dprintk(2,"key %02x\n", b);
>  
>  	*ir_key = b;
>  	*ir_raw = b;

Don't do that. This piece of code is old, and it was added there 
before the em28xx driver. Originally, the ir-i2c-kbd were used by
bttv and saa7134 drivers and the code there were auto-detecting the
I2C IR hardware decoding chips that used to be very common on media
devices. I'm almost sure that the original device that started using
this code is this model:

drivers/media/pci/bt8xx/bttv-cards.c:             .name           = "Typhoon TView RDS + FM Stereo / KNC1 TV Station RDS",

That's why it is called as KNC1, but there are other cards that use
it as well. I think I have one bttv using it. Not sure.

The routine on em28xx is a fork of the original one, that was changed
to work with the devices there.

FYI, most of those I2C IR codes are provided by some generic 8-bits
micro-processor, generally labeled with weird names, like KS007.
The code inside those can be different, depending on the firmware
inside, and also its I2C address.

That's one of the reasons why we moved the code that used to be
inside ir-i2c-kbd into the drivers that actually use it, like
em28xx: this way, we can track its usage and fix, as the remaining
get_key code inside-i2c-kbd are old, auto-detected, nobody knows
precisely what devices use them, and the current developers don't own
the hardware where they're used.

In other words, please, don't touch at the get_key routines inside
ir-kbd-i2c. If you find a bug, please fix at em28xx-input instead, if
you find a bug.

-- 

Cheers,
Mauro
