Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758697Ab0BRUU0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2010 15:20:26 -0500
Message-ID: <4B7DA0FB.5010506@redhat.com>
Date: Thu, 18 Feb 2010 18:20:11 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: stefan.ringel@arcor.de
CC: linux-media@vger.kernel.org, dheitmueller@kernellabs.com
Subject: Re: [PATCH 09/11] zl10353: tm6000: bugfix reading problems with tm6000
 i2c host
References: <1266255444-7422-1-git-send-email-stefan.ringel@arcor.de> <1266255444-7422-2-git-send-email-stefan.ringel@arcor.de> <1266255444-7422-3-git-send-email-stefan.ringel@arcor.de> <1266255444-7422-4-git-send-email-stefan.ringel@arcor.de> <1266255444-7422-5-git-send-email-stefan.ringel@arcor.de> <1266255444-7422-6-git-send-email-stefan.ringel@arcor.de> <1266255444-7422-7-git-send-email-stefan.ringel@arcor.de> <1266255444-7422-8-git-send-email-stefan.ringel@arcor.de> <1266255444-7422-9-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1266255444-7422-9-git-send-email-stefan.ringel@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

stefan.ringel@arcor.de wrote:
> From: Stefan Ringel <stefan.ringel@arcor.de>
> 
> Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
> 
> diff --git a/drivers/media/dvb/frontends/zl10353.c b/drivers/media/dvb/frontends/zl10353.c
> index 8c61271..9716d7e 100644
> --- a/drivers/media/dvb/frontends/zl10353.c
> +++ b/drivers/media/dvb/frontends/zl10353.c
> @@ -74,7 +74,7 @@ static int zl10353_write(struct dvb_frontend *fe, u8 *ibuf, int ilen)
>  	return 0;
>  }
>  
> -static int zl10353_read_register(struct zl10353_state *state, u8 reg)
> +static int zl10353_read1_register(struct zl10353_state *state, u8 reg)
>  {
>  	int ret;
>  	u8 b0[1] = { reg };
> @@ -97,6 +97,41 @@ static int zl10353_read_register(struct zl10353_state *state, u8 reg)
>  	return b1[0];
>  }
>  
> +static int zl10353_read2_register(struct zl10353_state *state, u8 reg)
> +{
> +	int ret;
> +	u8 b0[1] = { reg - 1 };
> +	u8 b1[1] = { 0 };
> +	struct i2c_msg msg[2] = { { .addr = state->config.demod_address,
> +				    .flags = 0,
> +				    .buf = b0, .len = 1 },
> +				  { .addr = state->config.demod_address,
> +				    .flags = I2C_M_RD,
> +				    .buf = b1, .len = 2 } };
> +
> +	ret = i2c_transfer(state->i2c, msg, 2);
> +
> +	if (ret != 2) {
> +		printk("%s: readreg error (reg=%d, ret==%i)\n",
> +		       __func__, reg, ret);
> +		return ret;
> +	}
> +
> +	return b1[1];
> +}

This patch doesn't look correct to me. The size of the zl10353 read register doesn't 
change when it is used with tm6000. The solution should be at tm6000-i2c, basically
using the same REQ for 2 bytes when only 1 byte is being read.

Cheers,
Mauro
