Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37704 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab1ITWSK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Sep 2011 18:18:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v3 1/3] noon010pc30: Conversion to the media controller API
Date: Wed, 21 Sep 2011 00:18:13 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
References: <1316188796-8374-1-git-send-email-s.nawrocki@samsung.com> <1316188796-8374-2-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1316188796-8374-2-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109210018.14185.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for the patch.

On Friday 16 September 2011 17:59:54 Sylwester Nawrocki wrote:
> Replace g/s_mbus_fmt ops with the pad level get/set_fmt operations.
> Add media entity initialization and set subdev flags so the host driver
> creates a subdev device node for the driver.
> A mutex was added for serializing the subdev operations. When setting
> format is attempted during streaming an (EBUSY) error will be returned.
> 
> After the device is powered up it will now remain in "power sleep"
> mode until s_stream(1) is called. The "power sleep" mode is used
> to suspend/resume frame generation at the sensor's output through
> s_stream op.
> 
> While at here simplify the colorspace parameter handling.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

[snip]

> diff --git a/drivers/media/video/noon010pc30.c
> b/drivers/media/video/noon010pc30.c index 35f722a..115d976 100644
> --- a/drivers/media/video/noon010pc30.c
> +++ b/drivers/media/video/noon010pc30.c

[snip]

> @@ -599,6 +641,22 @@ static int noon010_log_status(struct v4l2_subdev *sd)
>  	return 0;
>  }
> 
> +static int noon010_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +	struct v4l2_mbus_framefmt *mf = v4l2_subdev_get_try_format(fh, 0);
> +	struct noon010_info *info = to_noon010(sd);
> +
> +	mutex_lock(&info->lock);
> +	noon010_get_current_fmt(to_noon010(sd), mf);

Should you initialize mf with a constant default format instead of retrieving 
the current format from the sensor ? A non-constant default would probably 
confuse userspace application.

> +
> +	mutex_unlock(&info->lock);
> +	return 0;
> +}

-- 
Regards,

Laurent Pinchart
