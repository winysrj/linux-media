Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay02.digicable.hu ([92.249.128.188]:38026 "EHLO
	relay02.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab0CFJYx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Mar 2010 04:24:53 -0500
Message-ID: <4B921F5F.4000905@freemail.hu>
Date: Sat, 06 Mar 2010 10:24:47 +0100
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Douglas Schilling Landgraf <dougsland@redhat.com>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] bttv: Move I2C IR initialization
References: <20100216182152.44129e46@hyperion.delvare>
In-Reply-To: <20100216182152.44129e46@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
Jean Delvare wrote:
> Move I2C IR initialization from just after I2C bus setup to right
> before non-I2C IR initialization. This avoids the case where an I2C IR
> device is blocking audio support (at least the PV951 suffers from
> this). It is also more logical to group IR support together,
> regardless of the connectivity.

Something could have gone wrong because this patch and the patch
at http://linuxtv.org/hg/v4l-dvb/rev/659e08177aa3 has the

  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)

and

  #endif

pair at different places. The current result is the following compiler
warning:

  bttv-i2c.c: In function 'init_bttv_i2c':
  bttv-i2c.c:440: warning: control reaches end of non-void function

Regard,

	Márton Németh

>
> This fixes bug #15184:
> http://bugzilla.kernel.org/show_bug.cgi?id=15184
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---
> As this fixes a regression, I suggest pushing to Linus quickly. This is
> a candidate for 2.6.32-stable too.
> 
>  linux/drivers/media/video/bt8xx/bttv-driver.c |    1 +
>  linux/drivers/media/video/bt8xx/bttv-i2c.c    |   10 +++++++---
>  linux/drivers/media/video/bt8xx/bttvp.h       |    1 +
>  3 files changed, 9 insertions(+), 3 deletions(-)
> 
> --- v4l-dvb.orig/linux/drivers/media/video/bt8xx/bttv-i2c.c	2009-12-11 09:47:47.000000000 +0100
> +++ v4l-dvb/linux/drivers/media/video/bt8xx/bttv-i2c.c	2010-02-16 18:14:34.000000000 +0100
> @@ -409,9 +409,14 @@ int __devinit init_bttv_i2c(struct bttv
>  	}
>  	if (0 == btv->i2c_rc && i2c_scan)
>  		do_i2c_scan(btv->c.v4l2_dev.name, &btv->i2c_client);
> -#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
>  
> -	/* Instantiate the IR receiver device, if present */
> +	return btv->i2c_rc;
> +}
> +
> +/* Instantiate the I2C IR receiver device, if present */
> +void __devinit init_bttv_i2c_ir(struct bttv *btv)
> +{
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
>  	if (0 == btv->i2c_rc) {
>  		struct i2c_board_info info;
>  		/* The external IR receiver is at i2c address 0x34 (0x35 for
> @@ -432,7 +437,6 @@ int __devinit init_bttv_i2c(struct bttv
>  		i2c_new_probed_device(&btv->c.i2c_adap, &info, addr_list);
>  	}
>  #endif
> -	return btv->i2c_rc;
>  }
>  
>  int __devexit fini_bttv_i2c(struct bttv *btv)
> --- v4l-dvb.orig/linux/drivers/media/video/bt8xx/bttvp.h	2009-04-06 10:10:24.000000000 +0200
> +++ v4l-dvb/linux/drivers/media/video/bt8xx/bttvp.h	2010-02-16 18:13:31.000000000 +0100
> @@ -281,6 +281,7 @@ extern unsigned int bttv_debug;
>  extern unsigned int bttv_gpio;
>  extern void bttv_gpio_tracking(struct bttv *btv, char *comment);
>  extern int init_bttv_i2c(struct bttv *btv);
> +extern void init_bttv_i2c_ir(struct bttv *btv);
>  extern int fini_bttv_i2c(struct bttv *btv);
>  
>  #define bttv_printk if (bttv_verbose) printk
> --- v4l-dvb.orig/linux/drivers/media/video/bt8xx/bttv-driver.c	2009-12-11 09:47:47.000000000 +0100
> +++ v4l-dvb/linux/drivers/media/video/bt8xx/bttv-driver.c	2010-02-16 18:13:31.000000000 +0100
> @@ -4498,6 +4498,7 @@ static int __devinit bttv_probe(struct p
>  		request_modules(btv);
>  	}
>  
> +	init_bttv_i2c_ir(btv);
>  	bttv_input_init(btv);
>  
>  	/* everything is fine */
> 
> 

