Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:5215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754345Ab0IJPNW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Sep 2010 11:13:22 -0400
Message-ID: <4C8A4B1C.8010002@redhat.com>
Date: Fri, 10 Sep 2010 12:13:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: LMML <linux-media@vger.kernel.org>,
	Steven Toth <stoth@kernellabs.com>
Subject: Re: [PATCH 1/5] cx22702: Clean up register access functions
References: <20100910151943.103f7423@hyperion.delvare> <20100910152700.69edd554@hyperion.delvare>
In-Reply-To: <20100910152700.69edd554@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Em 10-09-2010 10:27, Jean Delvare escreveu:
> * Avoid temporary variables.
> * Optimize success paths.
> * Make error messages consistently verbose.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Steven Toth <stoth@kernellabs.com>
> ---
>  drivers/media/dvb/frontends/cx22702.c |   23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
> 
> --- linux-2.6.32-rc5.orig/drivers/media/dvb/frontends/cx22702.c	2009-10-16 09:47:14.000000000 +0200
> +++ linux-2.6.32-rc5/drivers/media/dvb/frontends/cx22702.c	2009-10-16 09:47:45.000000000 +0200
> @@ -92,33 +92,36 @@ static int cx22702_writereg(struct cx227
>  
>  	ret = i2c_transfer(state->i2c, &msg, 1);
>  
> -	if (ret != 1)
> +	if (ret != 1) {

As a suggestion, if you want to optimize success paths, you should use unlikely() for error
checks. This tells gcc to optimize the code to avoid cache cleanups for the likely condition:

	if (unlikely(ret != 1)) {

>  		printk(KERN_ERR
>  			"%s: error (reg == 0x%02x, val == 0x%02x, ret == %i)\n",
>  			__func__, reg, data, ret);
> +		return -1;
> +	}
>  
> -	return (ret != 1) ? -1 : 0;
> +	return 0;
>  }
>  
>  static u8 cx22702_readreg(struct cx22702_state *state, u8 reg)
>  {
>  	int ret;
> -	u8 b0[] = { reg };
> -	u8 b1[] = { 0 };
> +	u8 data;
>  
>  	struct i2c_msg msg[] = {
>  		{ .addr = state->config->demod_address, .flags = 0,
> -			.buf = b0, .len = 1 },
> +			.buf = &reg, .len = 1 },
>  		{ .addr = state->config->demod_address, .flags = I2C_M_RD,
> -			.buf = b1, .len = 1 } };
> +			.buf = &data, .len = 1 } };
>  
>  	ret = i2c_transfer(state->i2c, msg, 2);
>  
> -	if (ret != 2)
> -		printk(KERN_ERR "%s: readreg error (ret == %i)\n",
> -			__func__, ret);
> +	if (ret != 2) {

Same comment applies here.

> +		printk(KERN_ERR "%s: error (reg == 0x%02x, ret == %i)\n",
> +			__func__, reg, ret);
> +		return 0;
> +	}
>  
> -	return b1[0];
> +	return data;
>  }
>  
>  static int cx22702_set_inversion(struct cx22702_state *state, int inversion)
> 

