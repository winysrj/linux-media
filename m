Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:37783 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755752Ab0LQWWz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Dec 2010 17:22:55 -0500
Subject: Re: [PATCH] [media] cx231xx: Fix inverted bits for RC on PV Hybrid
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4D0B9C41.8030704@redhat.com>
References: <4D0B9C41.8030704@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Dec 2010 17:23:29 -0500
Message-ID: <1292624609.1007.21.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Fri, 2010-12-17 at 15:22 -0200, Mauro Carvalho Chehab wrote:
> At Pixelview SBTVD Hybrid, the bits sent by the IR are inverted. Due to that,
> the existing keytables produce wrong codes.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/drivers/media/video/cx231xx/cx231xx-input.c b/drivers/media/video/cx231xx/cx231xx-input.c
> index c236a4e..45e14ca 100644
> --- a/drivers/media/video/cx231xx/cx231xx-input.c
> +++ b/drivers/media/video/cx231xx/cx231xx-input.c
> @@ -27,7 +27,7 @@
>  static int get_key_isdbt(struct IR_i2c *ir, u32 *ir_key,
>  			 u32 *ir_raw)
>  {
> -	u8	cmd;
> +	u8	cmd, scancode;
>  
>  	dev_dbg(&ir->rc->input_dev->dev, "%s\n", __func__);
>  
> @@ -42,10 +42,21 @@ static int get_key_isdbt(struct IR_i2c *ir, u32 *ir_key,
>  	if (cmd == 0xff)
>  		return 0;
>  
> -	dev_dbg(&ir->rc->input_dev->dev, "scancode = %02x\n", cmd);
> -
> -	*ir_key = cmd;
> -	*ir_raw = cmd;
> +	scancode =
> +		 ((cmd & 0x01) ? 0x80 : 0) |
> +		 ((cmd & 0x02) ? 0x40 : 0) |
> +		 ((cmd & 0x04) ? 0x20 : 0) |
> +		 ((cmd & 0x08) ? 0x10 : 0) |
> +		 ((cmd & 0x10) ? 0x08 : 0) |
> +		 ((cmd & 0x20) ? 0x04 : 0) |
> +		 ((cmd & 0x40) ? 0x02 : 0) |
> +		 ((cmd & 0x80) ? 0x01 : 0);

I have to point out this alternate method just for fun:

http://www-graphics.stanford.edu/~seander/bithacks.html#ReverseByteWith32Bits

:D

Regards,
Andy

> +	dev_dbg(&ir->rc->input_dev->dev, "cmd %02x, scan = %02x\n",
> +		cmd, scancode);
> +
> +	*ir_key = scancode;
> +	*ir_raw = scancode;
>  	return 1;
>  }
>  

