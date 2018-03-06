Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48834 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753245AbeCFNkQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2018 08:40:16 -0500
Date: Tue, 6 Mar 2018 10:40:10 -0300
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: sakari.ailus@linux.intel.com, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] media: ov5645: Fix write_reg return code
Message-ID: <20180306104010.234737a6@vento.lan>
In-Reply-To: <1518082920-11309-1-git-send-email-todor.tomov@linaro.org>
References: <1518082920-11309-1-git-send-email-todor.tomov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu,  8 Feb 2018 11:41:59 +0200
Todor Tomov <todor.tomov@linaro.org> escreveu:

> I2C transfer functions return number of successful operations (on success).
> 
> Do not return the received positive return code but instead return 0 on
> success. The users of write_reg function already use this logic.
> 
> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
> ---
>  drivers/media/i2c/ov5645.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
> index d28845f..9755562 100644
> --- a/drivers/media/i2c/ov5645.c
> +++ b/drivers/media/i2c/ov5645.c
> @@ -600,11 +600,13 @@ static int ov5645_write_reg(struct ov5645 *ov5645, u16 reg, u8 val)
>  	regbuf[2] = val;
>  
>  	ret = i2c_master_send(ov5645->i2c_client, regbuf, 3);
> -	if (ret < 0)
> +	if (ret < 0) {
>  		dev_err(ov5645->dev, "%s: write reg error %d: reg=%x, val=%x\n",
>  			__func__, ret, reg, val);
> +		return ret;
> +	}

Actually, if ret < 3, it should return an error too (like -EREMOTEIO 
or -EIO).

>  
> -	return ret;
> +	return 0;
>  }
>  
>  static int ov5645_read_reg(struct ov5645 *ov5645, u16 reg, u8 *val)



Thanks,
Mauro
