Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57853 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751415AbdGROeH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 10:34:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Adam Ford <aford173@gmail.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Adam Ford <adam.ford@logicpd.com>
Subject: Re: [RFC PATCH] media: i2c: mt9p031: Add 8-bit support
Date: Tue, 18 Jul 2017 17:34:14 +0300
Message-ID: <2087878.QkLAPtKvOj@avalon>
In-Reply-To: <1500386454-27583-1-git-send-email-aford173@gmail.com>
References: <1500386454-27583-1-git-send-email-aford173@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Adam,

Thank you for the patch.

On Tuesday 18 Jul 2017 09:00:54 Adam Ford wrote:
> From: Adam Ford <adam.ford@logicpd.com>
> 
> By default the camera driver only supports monochrome or color at 12-bit.
> This patch will allow the camera to choose between 12-bit or 8-bit
> resolution. Tested on Logic PD DM3730 Torpedo Development Kit.

I don't think that's right. The MT9P031 can't output 8-bit data. What can be 
done, of course, is connect only the topmost 8 bits of the 12-bit output to an 
8-bit input on a receiver. That supported through the data-shift property that 
should be set on the receiver DT endpoint node.

> Signed-off-by: Adam Ford <adam.ford@logicpd.com>
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/mt9p031.txt
> b/Documentation/devicetree/bindings/media/i2c/mt9p031.txt index
> cb60443..77b0dc1 100644
> --- a/Documentation/devicetree/bindings/media/i2c/mt9p031.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/mt9p031.txt
> @@ -15,6 +15,7 @@ Required Properties:
> 
>  Optional Properties:
>  - reset-gpios: Chip reset GPIO
> +- resolution: Empty (12-bit) or 8 bit resolution
> 
>  For further reading on port node refer to
>  Documentation/devicetree/bindings/media/video-interfaces.txt.
> diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
> index 91d822f..355791d 100644
> --- a/drivers/media/i2c/mt9p031.c
> +++ b/drivers/media/i2c/mt9p031.c
> @@ -1024,6 +1024,7 @@ mt9p031_get_pdata(struct i2c_client *client)
> 
>  	of_property_read_u32(np, "input-clock-frequency", &pdata->ext_freq);
>  	of_property_read_u32(np, "pixel-clock-frequency", &pdata-
>target_freq);
> +	of_property_read_u32(np, "resolution", &pdata->resolution);
> 
>  done:
>  	of_node_put(np);
> @@ -1058,6 +1059,7 @@ static int mt9p031_probe(struct i2c_client *client,
>  	mt9p031->output_control	= MT9P031_OUTPUT_CONTROL_DEF;
>  	mt9p031->mode2 = MT9P031_READ_MODE_2_ROW_BLC;
>  	mt9p031->model = did->driver_data;
> +	mt9p031->resolution = pdata->resolution;
> 
>  	mt9p031->regulators[0].supply = "vdd";
>  	mt9p031->regulators[1].supply = "vdd_io";
> @@ -1123,11 +1125,18 @@ static int mt9p031_probe(struct i2c_client *client,
>  	mt9p031->crop.left = MT9P031_COLUMN_START_DEF;
>  	mt9p031->crop.top = MT9P031_ROW_START_DEF;
> 
> -	if (mt9p031->model == MT9P031_MODEL_MONOCHROME)
> -		mt9p031->format.code = MEDIA_BUS_FMT_Y12_1X12;
> -	else
> -		mt9p031->format.code = MEDIA_BUS_FMT_SGRBG12_1X12;
> -
> +	if (mt9p031->model == MT9P031_MODEL_MONOCHROME) {
> +		if (mt9p031->resolution == 8)
> +			mt9p031->format.code = MEDIA_BUS_FMT_Y8_1X8;
> +		else
> +			mt9p031->format.code = MEDIA_BUS_FMT_Y12_1X12;
> +	}
> +	else {
> +		if (mt9p031->resolution == 8)
> +			mt9p031->format.code = MEDIA_BUS_FMT_SGRBG8_1X8;
> +		else
> +			mt9p031->format.code = MEDIA_BUS_FMT_SGRBG12_1X12;
> +	}
>  	mt9p031->format.width = MT9P031_WINDOW_WIDTH_DEF;
>  	mt9p031->format.height = MT9P031_WINDOW_HEIGHT_DEF;
>  	mt9p031->format.field = V4L2_FIELD_NONE;
> diff --git a/include/media/i2c/mt9p031.h b/include/media/i2c/mt9p031.h
> index 1ba3612..84335cb 100644
> --- a/include/media/i2c/mt9p031.h
> +++ b/include/media/i2c/mt9p031.h
> @@ -11,6 +11,7 @@ struct v4l2_subdev;
>  struct mt9p031_platform_data {
>  	int ext_freq;
>  	int target_freq;
> +	int resolution;
>  };
> 
>  #endif

-- 
Regards,

Laurent Pinchart
