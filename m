Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:59937 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751115AbbKKNzg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2015 08:55:36 -0500
Subject: Re: [PATCH 1/1] v4l2-device: Don't unregister ACPI/Device Tree based
 devices
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
References: <1447249846-18864-1-git-send-email-sakari.ailus@linux.intel.com>
Cc: Tommi Franttila <tommi.franttila@intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <564348C1.1050503@xs4all.nl>
Date: Wed, 11 Nov 2015 14:55:13 +0100
MIME-Version: 1.0
In-Reply-To: <1447249846-18864-1-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/11/15 14:50, Sakari Ailus wrote:
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
>  drivers/media/v4l2-core/v4l2-device.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
> index 5b0a30b..3c8cc9a 100644
> --- a/drivers/media/v4l2-core/v4l2-device.c
> +++ b/drivers/media/v4l2-core/v4l2-device.c
> @@ -122,7 +122,8 @@ void v4l2_device_unregister(struct v4l2_device *v4l2_dev)
>  			   We cannot rely on i2c_del_adapter to always
>  			   unregister clients for us, since if the i2c bus
>  			   is a platform bus, then it is never deleted. */

Can this comment be extended? This is non-trivial and it is helpful to
document this. Other than that it looks good.

Thanks,

	Hans

> -			if (client)
> +			if (client &&
> +			    !client->dev.of_node && !client->dev.fwnode)
>  				i2c_unregister_device(client);
>  			continue;
>  		}
> @@ -131,7 +132,7 @@ void v4l2_device_unregister(struct v4l2_device *v4l2_dev)
>  		if (sd->flags & V4L2_SUBDEV_FL_IS_SPI) {
>  			struct spi_device *spi = v4l2_get_subdevdata(sd);
>  
> -			if (spi)
> +			if (spi && !spi->dev.of_node && !spi->dev.fwnode)
>  				spi_unregister_device(spi);
>  			continue;
>  		}
> 
