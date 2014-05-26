Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50155 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaEZUqG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 16:46:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] smiapp: I2C address is the last part of the subdev name
Date: Mon, 26 May 2014 22:46:24 +0200
Message-ID: <3402705.9k4s8R0HnX@avalon>
In-Reply-To: <1400140602-27282-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1400140602-27282-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Thursday 15 May 2014 10:56:42 Sakari Ailus wrote:
> The I2C address of the sensor device was in the middle of the sub-device
> name and not in the end as it should have been. The smiapp sub-device names
> will change from e.g. "vs6555 1-0010 pixel array" to "vs6555 pixel array
> 1-0010".
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> This was already supposed to be fixed by "[media] smiapp: Use I2C adapter ID
> and address in the sub-device name" but the I2C address indeed was in the
> middle of the sub-device name and not in the end as it should have been.

I don't mind much whether the I2C bus number is in the middle or at the end of 
the name. The current "vs6555 1-0010 pixel array" value looks good to me, as 
it means "the pixel array of the vs6555 1-0010 sensor" in English, but I'm 
fine with "vs6555 pixel array 1-0010" as well.

However, as discussed privately, I think we need to make sure that 
applications don't rely on a specific format for the name. Names must be 
unique, but should not otherwise be parsed by applications to extract device 
location information (at least in my opinion). That information should be 
reported through a separate new ioctl that would report all kind of static 
information about entities. We've discussed that ioctl on and off for years 
(including with ALSA developers), it's "just" a matter of implementing it.

>  drivers/media/i2c/smiapp/smiapp-core.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c
> b/drivers/media/i2c/smiapp/smiapp-core.c index db3d5a6..2413d3c 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -2543,9 +2543,9 @@ static int smiapp_registered(struct v4l2_subdev
> *subdev) }
> 
>  		snprintf(this->sd.name,
> -			 sizeof(this->sd.name), "%s %d-%4.4x %s",
> -			 sensor->minfo.name, i2c_adapter_id(client->adapter),
> -			 client->addr, _this->name);
> +			 sizeof(this->sd.name), "%s %s %d-%4.4x",
> +			 sensor->minfo.name, _this->name,
> +			 i2c_adapter_id(client->adapter), client->addr);
> 
>  		this->sink_fmt.width =
>  			sensor->limits[SMIAPP_LIMIT_X_ADDR_MAX] + 1;

-- 
Regards,

Laurent Pinchart

