Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44759 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbbKIPKa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2015 10:10:30 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] mt9v032: Remove duplicate test for I2C_FUNC_SMBUS_WORD_DATA functionality
Date: Mon, 09 Nov 2015 17:10:40 +0200
Message-ID: <2066788.QMO2xzxPVc@avalon>
In-Reply-To: <1407663709.6912.8.camel@phoenix>
References: <1407663709.6912.8.camel@phoenix>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Axel,

Thank you for the patch.

On Sunday 10 August 2014 17:41:49 Axel Lin wrote:
> Since commit b42261078a91 ("regmap: i2c: fallback to SMBus if the adapter
> does not support standard I2C"), regmap-i2c will check the
> I2C_FUNC_SMBUS_[BYTE|WORD]_DATA functionality based on the regmap_config
> setting if the adapter does not support standard I2C.
> 
> So remove the I2C_FUNC_SMBUS_WORD_DATA functionality check in the driver
> code.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

> ---
>  drivers/media/i2c/mt9v032.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> index d044bce..f9e4bf7 100644
> --- a/drivers/media/i2c/mt9v032.c
> +++ b/drivers/media/i2c/mt9v032.c
> @@ -879,13 +879,6 @@ static int mt9v032_probe(struct i2c_client *client,
>  	unsigned int i;
>  	int ret;
> 
> -	if (!i2c_check_functionality(client->adapter,
> -				     I2C_FUNC_SMBUS_WORD_DATA)) {
> -		dev_warn(&client->adapter->dev,
> -			 "I2C-Adapter doesn't support I2C_FUNC_SMBUS_WORD\n");
> -		return -EIO;
> -	}
> -
>  	mt9v032 = devm_kzalloc(&client->dev, sizeof(*mt9v032), GFP_KERNEL);
>  	if (!mt9v032)
>  		return -ENOMEM;

-- 
Regards,

Laurent Pinchart

