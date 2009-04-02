Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:60671 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbZDBRaK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Apr 2009 13:30:10 -0400
Received: by bwz17 with SMTP id 17so621930bwz.37
        for <linux-media@vger.kernel.org>; Thu, 02 Apr 2009 10:30:06 -0700 (PDT)
Message-ID: <49D4F633.1040806@gmail.com>
Date: Thu, 02 Apr 2009 20:30:27 +0300
From: Darius Augulis <augulis.darius@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <lg@denx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] mt9t031: use platform power hook
References: <Pine.LNX.4.64.0904021149580.5263@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0904021149580.5263@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski wrote:
> Use platform power hook to turn the camera on and off.
> 
> Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
> ---
> diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
> index 23f9ce9..2b0927b 100644
> --- a/drivers/media/video/mt9t031.c
> +++ b/drivers/media/video/mt9t031.c
> @@ -141,8 +141,19 @@ static int get_shutter(struct soc_camera_device *icd, u32 *data)
>  
>  static int mt9t031_init(struct soc_camera_device *icd)
>  {
> +	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
> +	struct soc_camera_link *icl = mt9t031->client->dev.platform_data;
>  	int ret;
>  
> +	if (icl->power) {
> +		ret = icl->power(&mt9t031->client->dev, 1);
> +		if (ret < 0) {
> +			dev_err(icd->vdev->parent,
> +				"Platform failed to power-on the camera.\n");
> +			return ret;
> +		}
> +	}

probably you would have to call icl->reset there too?
I guess this camera sensor does have a reset pin?


> +
>  	/* Disable chip output, synchronous option update */
>  	ret = reg_write(icd, MT9T031_RESET, 1);
>  	if (ret >= 0)
> @@ -150,13 +161,23 @@ static int mt9t031_init(struct soc_camera_device *icd)
>  	if (ret >= 0)
>  		ret = reg_clear(icd, MT9T031_OUTPUT_CONTROL, 2);
>  
> +	if (ret < 0 && icl->power)
> +		icl->power(&mt9t031->client->dev, 0);
> +
>  	return ret >= 0 ? 0 : -EIO;
>  }
>  
>  static int mt9t031_release(struct soc_camera_device *icd)
>  {
> +	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
> +	struct soc_camera_link *icl = mt9t031->client->dev.platform_data;
> +
>  	/* Disable the chip */
>  	reg_clear(icd, MT9T031_OUTPUT_CONTROL, 2);
> +
> +	if (icl->power)
> +		icl->power(&mt9t031->client->dev, 0);
> +
>  	return 0;
>  }
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

