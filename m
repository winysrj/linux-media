Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568Ab3AEClj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 21:41:39 -0500
Date: Sat, 5 Jan 2013 00:41:07 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/6] em28xx: IR RC: get rid of function
 em28xx_get_key_terratec()
Message-ID: <20130105004107.49aa5158@redhat.com>
In-Reply-To: <1356649368-5426-5-git-send-email-fschaefer.oss@googlemail.com>
References: <1356649368-5426-1-git-send-email-fschaefer.oss@googlemail.com>
	<1356649368-5426-5-git-send-email-fschaefer.oss@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 28 Dec 2012 00:02:46 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Module "ir-kbd-i2c" already provides this function as IR_KBD_GET_KEY_KNC1.

See my comment for patch 6/6.

Regards,
Mauro
> 
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/usb/em28xx/em28xx-input.c |   30 +-----------------------------
>  1 Datei geändert, 1 Zeile hinzugefügt(+), 29 Zeilen entfernt(-)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
> index 631e252..62b6cb7 100644
> --- a/drivers/media/usb/em28xx/em28xx-input.c
> +++ b/drivers/media/usb/em28xx/em28xx-input.c
> @@ -85,34 +85,6 @@ struct em28xx_IR {
>   I2C IR based get keycodes - should be used with ir-kbd-i2c
>   **********************************************************/
>  
> -static int em28xx_get_key_terratec(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
> -{
> -	unsigned char b;
> -
> -	/* poll IR chip */
> -	if (1 != i2c_master_recv(ir->c, &b, 1)) {
> -		i2cdprintk("read error\n");
> -		return -EIO;
> -	}
> -
> -	/* it seems that 0xFE indicates that a button is still hold
> -	   down, while 0xff indicates that no button is hold
> -	   down. 0xfe sequences are sometimes interrupted by 0xFF */
> -
> -	i2cdprintk("key %02x\n", b);
> -
> -	if (b == 0xff)
> -		return 0;
> -
> -	if (b == 0xfe)
> -		/* keep old data */
> -		return 1;
> -
> -	*ir_key = b;
> -	*ir_raw = b;
> -	return 1;
> -}
> -
>  static int em28xx_get_key_em_haup(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
>  {
>  	unsigned char buf[2];
> @@ -476,7 +448,7 @@ static int em28xx_register_i2c_ir(struct em28xx *dev, struct rc_dev *rc_dev)
>  	case EM2820_BOARD_TERRATEC_CINERGY_250:
>  		dev->init_data.name = "i2c IR (EM28XX Terratec)";
>  		dev->init_data.type = RC_BIT_OTHER;
> -		dev->init_data.get_key = em28xx_get_key_terratec;
> +		dev->init_data.internal_get_key_func = IR_KBD_GET_KEY_KNC1;
>  		break;
>  	case EM2820_BOARD_PINNACLE_USB_2:
>  		dev->init_data.name = "i2c IR (EM28XX Pinnacle PCTV)";


-- 

Cheers,
Mauro
