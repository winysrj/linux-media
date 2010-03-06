Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:58269 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813Ab0CFMDi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Mar 2010 07:03:38 -0500
Date: Sat, 6 Mar 2010 13:03:35 +0100
From: Jean Delvare <khali@linux-fr.org>
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Douglas Schilling Landgraf <dougsland@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] bttv: fix compiler warning before kernel 2.6.30
Message-ID: <20100306130335.20f0c723@hyperion.delvare>
In-Reply-To: <4B921F84.3000803@freemail.hu>
References: <20100216182152.44129e46@hyperion.delvare>
	<4B921F5F.4000905@freemail.hu>
	<4B921F84.3000803@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 06 Mar 2010 10:25:24 +0100, Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> Fix the following compiler warnings when compiling before Linux
> kernel version 2.6.30:
>   bttv-i2c.c: In function 'init_bttv_i2c':
>   bttv-i2c.c:440: warning: control reaches end of non-void function
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>

Good catch.

Acked-by: Jean Delvare <khali@linux-fr.org>

Douglas, please apply quickly.

> ---
> diff -r 41c5482f2dac linux/drivers/media/video/bt8xx/bttv-i2c.c
> --- a/linux/drivers/media/video/bt8xx/bttv-i2c.c	Thu Mar 04 02:49:46 2010 -0300
> +++ b/linux/drivers/media/video/bt8xx/bttv-i2c.c	Sat Mar 06 10:22:55 2010 +0100
> @@ -409,7 +409,6 @@
>  	}
>  	if (0 == btv->i2c_rc && i2c_scan)
>  		do_i2c_scan(btv->c.v4l2_dev.name, &btv->i2c_client);
> -#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
> 
>  	return btv->i2c_rc;
>  }
> @@ -417,6 +416,7 @@
>  /* Instantiate the I2C IR receiver device, if present */
>  void __devinit init_bttv_i2c_ir(struct bttv *btv)
>  {
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
>  	if (0 == btv->i2c_rc) {
>  		struct i2c_board_info info;
>  		/* The external IR receiver is at i2c address 0x34 (0x35 for
> 


-- 
Jean Delvare
