Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4916 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073AbZKEQSS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 11:18:18 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: hvaibhav@ti.com
Subject: Re: [PATCH V2] Davinci VPFE Capture: Add support for Control ioctls
Date: Thu, 5 Nov 2009 17:18:20 +0100
Cc: linux-media@vger.kernel.org
References: <hvaibhav@ti.com> <1256799064-25031-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <1256799064-25031-1-git-send-email-hvaibhav@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051718.20801.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 29 October 2009 07:51:04 hvaibhav@ti.com wrote:
> From: Vaibhav Hiremath <hvaibhav@ti.com>
> 
> Added support for Control IOCTL,
> 	- s_ctrl
> 	- g_ctrl
> 	- queryctrl
> 
> Change from last patch:
> 	- added room for error return in queryctrl function.
> 	
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> ---
>  drivers/media/video/davinci/vpfe_capture.c |   43 ++++++++++++++++++++++++++++
>  1 files changed, 43 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
> index abe21e4..8275d02 100644
> --- a/drivers/media/video/davinci/vpfe_capture.c
> +++ b/drivers/media/video/davinci/vpfe_capture.c
> @@ -1368,6 +1368,46 @@ static int vpfe_g_std(struct file *file, void *priv, v4l2_std_id *std_id)
>  	return 0;
>  }
> 
> +static int vpfe_queryctrl(struct file *file, void *priv,
> +		struct v4l2_queryctrl *qctrl)
> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +	struct vpfe_subdev_info *sdinfo;
> +	int ret = 0;
> +
> +	sdinfo = vpfe_dev->current_subdev;
> +
> +	ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo->grp_id,
> +					 core, queryctrl, qctrl);
> +
> +	if (ret)
> +		qctrl->flags |= V4L2_CTRL_FLAG_DISABLED;

Please remove this bogus flag. Just do:

	return v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo->grp_id,
				 core, queryctrl, qctrl);

Simple and effective.

Regards,

	Hans

> +
> +	return ret;
> +}
> +
> +static int vpfe_g_ctrl(struct file *file, void *priv, struct v4l2_control *ctrl)
> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +	struct vpfe_subdev_info *sdinfo;
> +
> +	sdinfo = vpfe_dev->current_subdev;
> +
> +	return v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo->grp_id,
> +					 core, g_ctrl, ctrl);
> +}
> +
> +static int vpfe_s_ctrl(struct file *file, void *priv, struct v4l2_control *ctrl)
> +{
> +	struct vpfe_device *vpfe_dev = video_drvdata(file);
> +	struct vpfe_subdev_info *sdinfo;
> +
> +	sdinfo = vpfe_dev->current_subdev;
> +
> +	return v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo->grp_id,
> +					 core, s_ctrl, ctrl);
> +}
> +
>  /*
>   *  Videobuf operations
>   */
> @@ -1939,6 +1979,9 @@ static const struct v4l2_ioctl_ops vpfe_ioctl_ops = {
>  	.vidioc_querystd	 = vpfe_querystd,
>  	.vidioc_s_std		 = vpfe_s_std,
>  	.vidioc_g_std		 = vpfe_g_std,
> +	.vidioc_queryctrl	 = vpfe_queryctrl,
> +	.vidioc_g_ctrl		 = vpfe_g_ctrl,
> +	.vidioc_s_ctrl		 = vpfe_s_ctrl,
>  	.vidioc_reqbufs		 = vpfe_reqbufs,
>  	.vidioc_querybuf	 = vpfe_querybuf,
>  	.vidioc_qbuf		 = vpfe_qbuf,
> --
> 1.6.2.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
