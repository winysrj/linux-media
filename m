Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901Ab3DMOlt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Apr 2013 10:41:49 -0400
Date: Sat, 13 Apr 2013 11:41:44 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] em28xx: give up GPIO register tracking/caching
Message-ID: <20130413114144.097a21a1@redhat.com>
In-Reply-To: <1365846521-3127-2-git-send-email-fschaefer.oss@googlemail.com>
References: <1365846521-3127-1-git-send-email-fschaefer.oss@googlemail.com>
	<1365846521-3127-2-git-send-email-fschaefer.oss@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 13 Apr 2013 11:48:39 +0200
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> The GPIO register tracking/caching code is partially broken, because newer
> devices provide more than one GPIO register and some of them are even using
> separate registers for read and write access.
> Making it work would be too complicated.
> It is also used nowhere and doesn't make sense in cases where input lines are
> connected to buttons etc.
> 
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/usb/em28xx/em28xx-cards.c |   12 ------------
>  drivers/media/usb/em28xx/em28xx-core.c  |   27 ++-------------------------
>  drivers/media/usb/em28xx/em28xx.h       |    6 ------
>  3 Dateien geändert, 2 Zeilen hinzugefügt(+), 43 Zeilen entfernt(-)

...


> @@ -231,14 +215,7 @@ int em28xx_write_reg_bits(struct em28xx *dev, u16 reg, u8 val,
>  	int oldval;
>  	u8 newval;
>  
> -	/* Uses cache for gpo/gpio registers */
> -	if (reg == dev->reg_gpo_num)
> -		oldval = dev->reg_gpo;
> -	else if (reg == dev->reg_gpio_num)
> -		oldval = dev->reg_gpio;
> -	else
> -		oldval = em28xx_read_reg(dev, reg);
> -
> +	oldval = em28xx_read_reg(dev, reg);
>  	if (oldval < 0)
>  		return oldval;


That's plain wrong, as it will break GPIO input.

With GPIO, you can write either 0 or 1 to a GPIO output port. So, your
code works for output ports.

However, an input port requires an specific value (either 1 or 0 depending
on the GPIO circuitry). If the wrong value is written there, the input port
will stop working.

So, you can't simply read a value from a GPIO input and write it. You need
to shadow the GPIO write values instead.

Regards,
Mauro
