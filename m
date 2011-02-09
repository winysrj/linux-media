Return-path: <mchehab@pedra>
Received: from mailout3.samsung.com ([203.254.224.33]:39640 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab1BIHOM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Feb 2011 02:14:12 -0500
Date: Wed, 09 Feb 2011 16:14:05 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH 1/5] i2c-s3c2410: fix I2C dedicated for hdmiphy
In-reply-to: <1297157427-14560-2-git-send-email-t.stanislaws@samsung.com>
To: 'Tomasz Stanislawski' <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	ben-linux@fluff.org
Message-id: <00ea01cbc828$f2520660$d6f61320$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
References: <1297157427-14560-1-git-send-email-t.stanislaws@samsung.com>
 <1297157427-14560-2-git-send-email-t.stanislaws@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Tomasz Stanislawski wrote:
> 
> The I2C HDMIPHY dedicated controller has different timeout
> handling and reset conditions.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/i2c/busses/i2c-s3c2410.c |   36
+++++++++++++++++++++++++++++++++++-
>  1 files changed, 35 insertions(+), 1 deletions(-)
> 

Cc'ed Ben Dooks who is a maintainer of I2C and Samsung architecture also.

> diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-
> s3c2410.c
> index 6c00c10..99cfe2f 100644
> --- a/drivers/i2c/busses/i2c-s3c2410.c
> +++ b/drivers/i2c/busses/i2c-s3c2410.c
> @@ -54,6 +54,7 @@ enum s3c24xx_i2c_state {
>  enum s3c24xx_i2c_type {
>  	TYPE_S3C2410,
>  	TYPE_S3C2440,
> +	TYPE_S3C2440_HDMIPHY,
>  };
> 
>  struct s3c24xx_i2c {
> @@ -96,7 +97,21 @@ static inline int s3c24xx_i2c_is2440(struct s3c24xx_i2c
> *i2c)
>  	enum s3c24xx_i2c_type type;
> 
>  	type = platform_get_device_id(pdev)->driver_data;
> -	return type == TYPE_S3C2440;
> +	return type == TYPE_S3C2440 || type == TYPE_S3C2440_HDMIPHY;
> +}
> +
> +/* s3c24xx_i2c_is2440_hdmiphy()
> + *
> + * return true is this is an s3c2440 dedicated for HDMIPHY interface
> +*/
> +
> +static inline int s3c24xx_i2c_is2440_hdmiphy(struct s3c24xx_i2c *i2c)
> +{
> +	struct platform_device *pdev = to_platform_device(i2c->dev);
> +	enum s3c24xx_i2c_type type;
> +
> +	type = platform_get_device_id(pdev)->driver_data;
> +	return type == TYPE_S3C2440_HDMIPHY;
>  }
> 
>  /* s3c24xx_i2c_master_complete
> @@ -461,6 +476,13 @@ static int s3c24xx_i2c_set_master(struct s3c24xx_i2c
> *i2c)
>  	unsigned long iicstat;
>  	int timeout = 400;
> 
> +	/* if hang-up of HDMIPHY occured reduce timeout
> +	 * The controller will work after reset, so waiting
> +	 * 400 ms will cause unneccessary system hangup
> +	 */
> +	if (s3c24xx_i2c_is2440_hdmiphy(i2c))
> +		timeout = 10;
> +
>  	while (timeout-- > 0) {
>  		iicstat = readl(i2c->regs + S3C2410_IICSTAT);
> 
> @@ -470,6 +492,15 @@ static int s3c24xx_i2c_set_master(struct s3c24xx_i2c
> *i2c)
>  		msleep(1);
>  	}
> 
> +	/* hang-up of bus dedicated for HDMIPHY occured, resetting */
> +	if (s3c24xx_i2c_is2440_hdmiphy(i2c)) {
> +		writel(0, i2c->regs + S3C2410_IICCON);
> +		writel(0, i2c->regs + S3C2410_IICSTAT);
> +		writel(0, i2c->regs + S3C2410_IICDS);
> +
> +		return 0;
> +	}
> +
>  	return -ETIMEDOUT;
>  }
> 
> @@ -1009,6 +1040,9 @@ static struct platform_device_id
s3c24xx_driver_ids[] =
> {
>  	}, {
>  		.name		= "s3c2440-i2c",
>  		.driver_data	= TYPE_S3C2440,
> +	}, {
> +		.name		= "s3c2440-hdmiphy-i2c",
> +		.driver_data	= TYPE_S3C2440_HDMIPHY,
>  	}, { },
>  };
>  MODULE_DEVICE_TABLE(platform, s3c24xx_driver_ids);
> --


Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

