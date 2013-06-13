Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:37447 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141Ab3FMKcm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jun 2013 06:32:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v10 15/21] V4L2: add a device pointer to struct v4l2_subdev
Date: Thu, 13 Jun 2013 12:32:34 +0200
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Sascha Hauer <s.hauer@pengutronix.de>
References: <1370939028-8352-1-git-send-email-g.liakhovetski@gmx.de> <1370939028-8352-16-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1370939028-8352-16-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306131232.34552.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 11 June 2013 10:23:42 Guennadi Liakhovetski wrote:
> It is often useful to have simple means to get from a subdevice to the
> underlying physical device. This patch adds such a pointer to struct
> v4l2_subdev and sets it accordingly in the I2C and SPI cases.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/media/v4l2-core/v4l2-common.c |    2 ++
>  include/media/v4l2-subdev.h           |    2 ++
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
> index 3fed63f..accfec6 100644
> --- a/drivers/media/v4l2-core/v4l2-common.c
> +++ b/drivers/media/v4l2-core/v4l2-common.c
> @@ -291,6 +291,7 @@ void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
>  	sd->flags |= V4L2_SUBDEV_FL_IS_I2C;
>  	/* the owner is the same as the i2c_client's driver owner */
>  	sd->owner = client->driver->driver.owner;
> +	sd->dev = &client->dev;
>  	/* i2c_client and v4l2_subdev point to one another */
>  	v4l2_set_subdevdata(sd, client);
>  	i2c_set_clientdata(client, sd);
> @@ -426,6 +427,7 @@ void v4l2_spi_subdev_init(struct v4l2_subdev *sd, struct spi_device *spi,
>  	sd->flags |= V4L2_SUBDEV_FL_IS_SPI;
>  	/* the owner is the same as the spi_device's driver owner */
>  	sd->owner = spi->dev.driver->owner;
> +	sd->dev = &spi->dev;
>  	/* spi_device and v4l2_subdev point to one another */
>  	v4l2_set_subdevdata(sd, spi);
>  	spi_set_drvdata(spi, sd);
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 5298d67..d8756fa 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -585,6 +585,8 @@ struct v4l2_subdev {
>  	void *host_priv;
>  	/* subdev device node */
>  	struct video_device *devnode;
> +	/* pointer to the physical device */

Can you change this comment to:

	/* pointer to the physical device, if any */

It's a small change, but this makes it clear that it's OK to leave it to
NULL for subdevs that don't have an underlying device struct.

Thanks!

	Hans

> +	struct device *dev;
>  };
>  
>  #define media_entity_to_v4l2_subdev(ent) \
> 
