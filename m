Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:45301 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753901AbbKLJD1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2015 04:03:27 -0500
Subject: Re: [PATCH v2 1/1] v4l2-device: Don't unregister ACPI/Device Tree
 based devices
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
References: <564348C1.1050503@xs4all.nl>
 <1447318867-20537-1-git-send-email-sakari.ailus@linux.intel.com>
Cc: Tommi Franttila <tommi.franttila@intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <564455C9.9060909@xs4all.nl>
Date: Thu, 12 Nov 2015 10:03:05 +0100
MIME-Version: 1.0
In-Reply-To: <1447318867-20537-1-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/12/15 10:01, Sakari Ailus wrote:
> From: Tommi Franttila <tommi.franttila@intel.com>
> 
> When a V4L2 sub-device backed by a DT or ACPI based device was removed,
> the device was unregistered as well which certainly was not intentional,
> as the client device would not be re-created by simply reinstating the
> V4L2 sub-device (indeed the device would have to be there first!).
> 
> Skip unregistering the device in case it has non-NULL of_node or fwnode.
> 
> Signed-off-by: Tommi Franttila <tommi.franttila@intel.com>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> 
> Hi Hans,
> 
> Thanks for the comment! How about this one?

Lovely, thanks!

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> Regards,
> Sakari
> 
>  drivers/media/v4l2-core/v4l2-device.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
> index 5b0a30b..7129e43 100644
> --- a/drivers/media/v4l2-core/v4l2-device.c
> +++ b/drivers/media/v4l2-core/v4l2-device.c
> @@ -118,11 +118,20 @@ void v4l2_device_unregister(struct v4l2_device *v4l2_dev)
>  		if (sd->flags & V4L2_SUBDEV_FL_IS_I2C) {
>  			struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
> -			/* We need to unregister the i2c client explicitly.
> -			   We cannot rely on i2c_del_adapter to always
> -			   unregister clients for us, since if the i2c bus
> -			   is a platform bus, then it is never deleted. */
> -			if (client)
> +			/*
> +			 * We need to unregister the i2c client
> +			 * explicitly. We cannot rely on
> +			 * i2c_del_adapter to always unregister
> +			 * clients for us, since if the i2c bus is a
> +			 * platform bus, then it is never deleted.
> +			 *
> +			 * Device tree or ACPI based devices must not
> +			 * be unregistered as they have not been
> +			 * registered by us, and would not be
> +			 * re-created by just probing the V4L2 driver.
> +			 */
> +			if (client &&
> +			    !client->dev.of_node && !client->dev.fwnode)
>  				i2c_unregister_device(client);
>  			continue;
>  		}
> @@ -131,7 +140,7 @@ void v4l2_device_unregister(struct v4l2_device *v4l2_dev)
>  		if (sd->flags & V4L2_SUBDEV_FL_IS_SPI) {
>  			struct spi_device *spi = v4l2_get_subdevdata(sd);
>  
> -			if (spi)
> +			if (spi && !spi->dev.of_node && !spi->dev.fwnode)
>  				spi_unregister_device(spi);
>  			continue;
>  		}
> 
