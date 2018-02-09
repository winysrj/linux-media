Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48098 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750961AbeBILqD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Feb 2018 06:46:03 -0500
Date: Fri, 9 Feb 2018 13:46:00 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 04/15] v4l2-subdev: without controls return -ENOTTY
Message-ID: <20180209114559.s3gpuzccdsemqhfe@valkosipuli.retiisi.org.uk>
References: <20180208083655.32248-1-hverkuil@xs4all.nl>
 <20180208083655.32248-5-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180208083655.32248-5-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Feb 08, 2018 at 09:36:44AM +0100, Hans Verkuil wrote:
> If the subdev did not define any controls, then return -ENOTTY if
> userspace attempts to call these ioctls.
> 
> The control framework functions will return -EINVAL, not -ENOTTY if
> vfh->ctrl_handler is NULL.
> 
> Several of these framework functions are also called directly from
> drivers, so I don't want to change the error code there.
> 
> Found with vimc and v4l2-compliance.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks for the patch.

If the handler is NULL, can there be support for the IOCTL at all? I.e.
should the missing handler as such result in returning -ENOTTY from these
functions instead of -EINVAL?

> ---
>  drivers/media/v4l2-core/v4l2-subdev.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index 43fefa73e0a3..be7a19272614 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -187,27 +187,43 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  
>  	switch (cmd) {
>  	case VIDIOC_QUERYCTRL:
> +		if (!vfh->ctrl_handler)
> +			return -ENOTTY;
>  		return v4l2_queryctrl(vfh->ctrl_handler, arg);
>  
>  	case VIDIOC_QUERY_EXT_CTRL:
> +		if (!vfh->ctrl_handler)
> +			return -ENOTTY;
>  		return v4l2_query_ext_ctrl(vfh->ctrl_handler, arg);
>  
>  	case VIDIOC_QUERYMENU:
> +		if (!vfh->ctrl_handler)
> +			return -ENOTTY;
>  		return v4l2_querymenu(vfh->ctrl_handler, arg);
>  
>  	case VIDIOC_G_CTRL:
> +		if (!vfh->ctrl_handler)
> +			return -ENOTTY;
>  		return v4l2_g_ctrl(vfh->ctrl_handler, arg);
>  
>  	case VIDIOC_S_CTRL:
> +		if (!vfh->ctrl_handler)
> +			return -ENOTTY;
>  		return v4l2_s_ctrl(vfh, vfh->ctrl_handler, arg);
>  
>  	case VIDIOC_G_EXT_CTRLS:
> +		if (!vfh->ctrl_handler)
> +			return -ENOTTY;
>  		return v4l2_g_ext_ctrls(vfh->ctrl_handler, arg);
>  
>  	case VIDIOC_S_EXT_CTRLS:
> +		if (!vfh->ctrl_handler)
> +			return -ENOTTY;
>  		return v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, arg);
>  
>  	case VIDIOC_TRY_EXT_CTRLS:
> +		if (!vfh->ctrl_handler)
> +			return -ENOTTY;
>  		return v4l2_try_ext_ctrls(vfh->ctrl_handler, arg);
>  
>  	case VIDIOC_DQEVENT:

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
