Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48256 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750925AbeBIMBi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Feb 2018 07:01:38 -0500
Date: Fri, 9 Feb 2018 14:01:36 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 06/15] v4l2-subdev: implement VIDIOC_DBG_G_CHIP_INFO
 ioctl
Message-ID: <20180209120136.heg43pxmrkssy5l7@valkosipuli.retiisi.org.uk>
References: <20180208083655.32248-1-hverkuil@xs4all.nl>
 <20180208083655.32248-7-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180208083655.32248-7-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Feb 08, 2018 at 09:36:46AM +0100, Hans Verkuil wrote:
> The VIDIOC_DBG_G/S_REGISTER ioctls imply that VIDIOC_DBG_G_CHIP_INFO is also
> present, since without that you cannot use v4l2-dbg.
> 
> Just like the implementation in v4l2-ioctl.c this can be implemented in the
> core and no drivers need to be modified.
> 
> It also makes it possible for v4l2-compliance to properly test the
> VIDIOC_DBG_G/S_REGISTER ioctls.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-subdev.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index 6cabfa32d2ed..2a5b5a3fa7a3 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -255,6 +255,19 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  			return -EPERM;
>  		return v4l2_subdev_call(sd, core, s_register, p);
>  	}
> +	case VIDIOC_DBG_G_CHIP_INFO:
> +	{
> +		struct v4l2_dbg_chip_info *p = arg;
> +
> +		if (p->match.type != V4L2_CHIP_MATCH_SUBDEV || p->match.addr)
> +			return -EINVAL;
> +		if (sd->ops->core && sd->ops->core->s_register)
> +			p->flags |= V4L2_CHIP_FL_WRITABLE;
> +		if (sd->ops->core && sd->ops->core->g_register)
> +			p->flags |= V4L2_CHIP_FL_READABLE;
> +		strlcpy(p->name, sd->name, sizeof(p->name));
> +		return 0;
> +	}

This is effectively doing the same as debugfs except that it's specific to
V4L2. I don't think we should endorse its use, and especially not without a
real use case.

>  #endif
>  
>  	case VIDIOC_LOG_STATUS: {
> -- 
> 2.15.1
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
