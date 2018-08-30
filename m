Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:33333 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727098AbeH3Lkr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Aug 2018 07:40:47 -0400
Subject: Re: [PATCH 2/3] smiapp: Use v4l2_i2c_subdev_set_name
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20180829105233.3852-1-sakari.ailus@linux.intel.com>
 <20180829105233.3852-3-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <211e068a-1e97-4662-e7d6-aeb14611010c@xs4all.nl>
Date: Thu, 30 Aug 2018 09:39:57 +0200
MIME-Version: 1.0
In-Reply-To: <20180829105233.3852-3-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/29/2018 12:52 PM, Sakari Ailus wrote:
> Use v4l2_i2c_subdev_set_name() to set the name of the smiapp driver's
> sub-devices. There is no functional change.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>


Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  drivers/media/i2c/smiapp/smiapp-core.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
> index 1236683da8f7..99f3b295ae3c 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -2617,9 +2617,7 @@ static void smiapp_create_subdev(struct smiapp_sensor *sensor,
>  	ssd->npads = num_pads;
>  	ssd->source_pad = num_pads - 1;
>  
> -	snprintf(ssd->sd.name,
> -		 sizeof(ssd->sd.name), "%s %s %d-%4.4x", sensor->minfo.name,
> -		 name, i2c_adapter_id(client->adapter), client->addr);
> +	v4l2_i2c_subdev_set_name(&ssd->sd, client, sensor->minfo.name, name);
>  
>  	smiapp_get_native_size(ssd, &ssd->sink_fmt);
>  
> @@ -3064,9 +3062,9 @@ static int smiapp_probe(struct i2c_client *client,
>  	if (sensor->minfo.smiapp_profile == SMIAPP_PROFILE_0)
>  		sensor->pll.flags |= SMIAPP_PLL_FLAG_NO_OP_CLOCKS;
>  
> -	smiapp_create_subdev(sensor, sensor->scaler, "scaler", 2);
> -	smiapp_create_subdev(sensor, sensor->binner, "binner", 2);
> -	smiapp_create_subdev(sensor, sensor->pixel_array, "pixel_array", 1);
> +	smiapp_create_subdev(sensor, sensor->scaler, " scaler", 2);
> +	smiapp_create_subdev(sensor, sensor->binner, " binner", 2);
> +	smiapp_create_subdev(sensor, sensor->pixel_array, " pixel_array", 1);
>  
>  	dev_dbg(&client->dev, "profile %d\n", sensor->minfo.smiapp_profile);
>  
> 
