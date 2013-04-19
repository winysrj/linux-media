Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:2504 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab3DSHdu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Apr 2013 03:33:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 06/24] V4L2: add a common V4L2 subdevice platform data type
Date: Fri, 19 Apr 2013 09:33:33 +0200
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de> <1366320945-21591-7-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1366320945-21591-7-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304190933.33775.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu April 18 2013 23:35:27 Guennadi Liakhovetski wrote:
> This struct shall be used by subdevice drivers to pass per-subdevice data,
> e.g. power supplies, to generic V4L2 methods, at the same time allowing
> optional host-specific extensions via the host_priv pointer. To avoid
> having to pass two pointers to those methods, add a pointer to this new
> struct to struct v4l2_subdev.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  include/media/v4l2-subdev.h |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index eb91366..b15c6e0 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -561,6 +561,17 @@ struct v4l2_subdev_internal_ops {
>  /* Set this flag if this subdev generates events. */
>  #define V4L2_SUBDEV_FL_HAS_EVENTS		(1U << 3)
>  
> +struct regulator_bulk_data;
> +
> +struct v4l2_subdev_platform_data {
> +	/* Optional regulators uset to power on/off the subdevice */
> +	struct regulator_bulk_data *regulators;
> +	int num_regulators;
> +
> +	/* Per-subdevice data, specific for a certain video host device */
> +	void *host_priv;
> +};
> +
>  /* Each instance of a subdev driver should create this struct, either
>     stand-alone or embedded in a larger struct.
>   */
> @@ -589,6 +600,8 @@ struct v4l2_subdev {
>  	/* pointer to the physical device */
>  	struct device *dev;
>  	struct v4l2_async_subdev_list asdl;
> +	/* common part of subdevice platform data */
> +	struct v4l2_subdev_platform_data *pdata;
>  };
>  
>  static inline struct v4l2_subdev *v4l2_async_to_subdev(
> 

Sorry, this is the wrong approach.

This is data that is of no use to the subdev driver itself. It really is
v4l2_subdev_host_platform_data, and as such must be maintained by the bridge
driver.

It can use v4l2_get/set_subdev_hostdata() to associate this struct with a
subdev, though.

Regards,

	Hans
