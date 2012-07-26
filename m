Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:55175 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab2GZOyK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 10:54:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: [PATCH] v4l2: typos
Date: Thu, 26 Jul 2012 16:53:58 +0200
Cc: linux-media@vger.kernel.org
References: <1343314105-21878-1-git-send-email-michael.jones@matrix-vision.de>
In-Reply-To: <1343314105-21878-1-git-send-email-michael.jones@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207261653.58551.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 26 July 2012 16:48:25 Michael Jones wrote:
> 
> Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Yup, all typos :-)

Thanks,

	Hans

> ---
>  Documentation/video4linux/v4l2-framework.txt |    2 +-
>  drivers/media/video/omap3isp/ispqueue.c      |    2 +-
>  drivers/media/video/omap3isp/ispresizer.c    |    6 +++---
>  drivers/media/video/v4l2-common.c            |    2 +-
>  include/media/v4l2-common.h                  |    4 ++--
>  include/media/v4l2-subdev.h                  |    2 +-
>  6 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
> index 1f59052..fa01440 100644
> --- a/Documentation/video4linux/v4l2-framework.txt
> +++ b/Documentation/video4linux/v4l2-framework.txt
> @@ -666,7 +666,7 @@ can take a long time you may want to do your own locking for the buffer queuing
>  ioctls.
>  
>  If you want still finer-grained locking then you have to set mutex_lock to NULL
> -and do you own locking completely.
> +and do your own locking completely.
>  
>  It is up to the driver developer to decide which method to use. However, if
>  your driver has high-latency operations (for example, changing the exposure
> diff --git a/drivers/media/video/omap3isp/ispqueue.c b/drivers/media/video/omap3isp/ispqueue.c
> index 9bebb1e..61fc87d 100644
> --- a/drivers/media/video/omap3isp/ispqueue.c
> +++ b/drivers/media/video/omap3isp/ispqueue.c
> @@ -647,7 +647,7 @@ static int isp_video_queue_alloc(struct isp_video_queue *queue,
>  	if (ret < 0)
>  		return ret;
>  
> -	/* Bail out of no buffers should be allocated. */
> +	/* Bail out if no buffers should be allocated. */
>  	if (nbuffers == 0)
>  		return 0;
>  
> diff --git a/drivers/media/video/omap3isp/ispresizer.c b/drivers/media/video/omap3isp/ispresizer.c
> index 14041c9..46ac6df 100644
> --- a/drivers/media/video/omap3isp/ispresizer.c
> +++ b/drivers/media/video/omap3isp/ispresizer.c
> @@ -690,7 +690,7 @@ static void resizer_print_status(struct isp_res_device *res)
>  }
>  
>  /*
> - * resizer_calc_ratios - Helper function for calculate resizer ratios
> + * resizer_calc_ratios - Helper function for calculating resizer ratios
>   * @res: pointer to resizer private data structure
>   * @input: input frame size
>   * @output: output frame size
> @@ -734,7 +734,7 @@ static void resizer_print_status(struct isp_res_device *res)
>   * value will still satisfy the original inequality, as b will disappear when
>   * the expression will be shifted right by 8.
>   *
> - * The reverted the equations thus become
> + * The reverted equations thus become
>   *
>   * - 8-phase, 4-tap mode
>   *	hrsz = ((iw - 7) * 256 + 255 - 16 - 32 * sph) / (ow - 1)
> @@ -759,7 +759,7 @@ static void resizer_print_status(struct isp_res_device *res)
>   * loop', the smallest of the ratio values will be used, never exceeding the
>   * requested input size.
>   *
> - * We first clamp the output size according to the hardware capabilitie to avoid
> + * We first clamp the output size according to the hardware capability to avoid
>   * auto-cropping the input more than required to satisfy the TRM equations. The
>   * minimum output size is achieved with a scaling factor of 1024. It is thus
>   * computed using the 7-tap equations.
> diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
> index 1baec83..105f88c 100644
> --- a/drivers/media/video/v4l2-common.c
> +++ b/drivers/media/video/v4l2-common.c
> @@ -418,7 +418,7 @@ EXPORT_SYMBOL_GPL(v4l2_i2c_tuner_addrs);
>  
>  #if defined(CONFIG_SPI)
>  
> -/* Load a spi sub-device. */
> +/* Load an spi sub-device. */
>  
>  void v4l2_spi_subdev_init(struct v4l2_subdev *sd, struct spi_device *spi,
>  		const struct v4l2_subdev_ops *ops)
> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> index a298ec4..4404829 100644
> --- a/include/media/v4l2-common.h
> +++ b/include/media/v4l2-common.h
> @@ -133,7 +133,7 @@ struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
>  		struct i2c_adapter *adapter, struct i2c_board_info *info,
>  		const unsigned short *probe_addrs);
>  
> -/* Initialize an v4l2_subdev with data from an i2c_client struct */
> +/* Initialize a v4l2_subdev with data from an i2c_client struct */
>  void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
>  		const struct v4l2_subdev_ops *ops);
>  /* Return i2c client address of v4l2_subdev. */
> @@ -166,7 +166,7 @@ struct spi_device;
>  struct v4l2_subdev *v4l2_spi_new_subdev(struct v4l2_device *v4l2_dev,
>  		struct spi_master *master, struct spi_board_info *info);
>  
> -/* Initialize an v4l2_subdev with data from an spi_device struct */
> +/* Initialize a v4l2_subdev with data from an spi_device struct */
>  void v4l2_spi_subdev_init(struct v4l2_subdev *sd, struct spi_device *spi,
>  		const struct v4l2_subdev_ops *ops);
>  #endif
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index c35a354..4cc1652 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -120,7 +120,7 @@ struct v4l2_subdev_io_pin_config {
>  	each pin being configured.  This function could be called at times
>  	other than just subdevice initialization.
>  
> -   init: initialize the sensor registors to some sort of reasonable default
> +   init: initialize the sensor registers to some sort of reasonable default
>  	values. Do not use for new drivers and should be removed in existing
>  	drivers.
>  
> 
