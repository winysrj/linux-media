Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35878 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab3C0BKf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 21:10:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Ezequiel Garcia <elezegarcia@gmail.com>,
	Frank Schaefer <fschaefer.oss@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 2/6] v4l2: add new VIDIOC_DBG_G_CHIP_NAME ioctl.
Date: Wed, 27 Mar 2013 02:11:23 +0100
Message-ID: <4375309.Kgln0QGpEZ@avalon>
In-Reply-To: <1363624700-29270-3-git-send-email-hverkuil@xs4all.nl>
References: <1363624700-29270-1-git-send-email-hverkuil@xs4all.nl> <1363624700-29270-3-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 18 March 2013 17:38:16 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Simplify the debugging ioctls by creating the VIDIOC_DBG_G_CHIP_NAME ioctl.
> This will eventually replace VIDIOC_DBG_G_CHIP_IDENT. Chip matching is done
> by the name or index of subdevices or an index to a bridge chip. Most of
> this can all be done automatically, so most drivers just need to provide
> get/set register ops.
> 
> In particular, it is now possible to get/set subdev registers without
> requiring assistance of the bridge driver.

My biggest question is why don't we use the media controller API to get the 
information provided by this new ioctl ?

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-common.c |    5 +-
>  drivers/media/v4l2-core/v4l2-dev.c    |    5 +-
>  drivers/media/v4l2-core/v4l2-ioctl.c  |  115 ++++++++++++++++++++++++++++--
>  include/media/v4l2-ioctl.h            |    3 +
>  include/uapi/linux/videodev2.h        |   34 +++++++---
>  5 files changed, 146 insertions(+), 16 deletions(-)

[snip]

> diff --git a/drivers/media/v4l2-core/v4l2-dev.c
> b/drivers/media/v4l2-core/v4l2-dev.c index de1e9ab..c0c651d 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -591,9 +591,10 @@ static void determine_valid_ioctls(struct video_device

[snip]

> +static int v4l_dbg_g_chip_name(const struct v4l2_ioctl_ops *ops,
> +				struct file *file, void *fh, void *arg)

As this is a debug ioctl that should never be used in application, I would 
like to guard the whole implementation with #ifdef CONFIG_VIDEO_ADV_DEBUG. 
This will make sure that no applications will abuse it, as it won't be 
available in distro kernels.

> +{
> +	struct video_device *vfd = video_devdata(file);
> +	struct v4l2_dbg_chip_name *p = arg;
> +	struct v4l2_subdev *sd;
> +	int idx = 0;
> +
> +	switch (p->match.type) {
> +	case V4L2_CHIP_MATCH_BRIDGE:
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +		if (ops->vidioc_s_register)
> +			p->flags |= V4L2_CHIP_FL_WRITABLE;
> +		if (ops->vidioc_g_register)
> +			p->flags |= V4L2_CHIP_FL_READABLE;
> +#endif
> +		if (ops->vidioc_g_chip_name)
> +			return ops->vidioc_g_chip_name(file, fh, arg);
> +		if (p->match.addr)
> +			return -EINVAL;
> +		if (vfd->v4l2_dev)
> +			strlcpy(p->name, vfd->v4l2_dev->name, sizeof(p->name));
> +		else if (vfd->parent)
> +			strlcpy(p->name, vfd->parent->driver->name, sizeof(p->name));
> +		else
> +			strlcpy(p->name, "bridge", sizeof(p->name));
> +		return 0;
> +
> +	case V4L2_CHIP_MATCH_SUBDEV_IDX:
> +	case V4L2_CHIP_MATCH_SUBDEV_NAME:
> +		if (vfd->v4l2_dev == NULL)
> +			break;
> +		v4l2_device_for_each_subdev(sd, vfd->v4l2_dev) {
> +			if (v4l_dbg_found_match(&p->match, sd, idx++)) {
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +				if (sd->ops->core && sd->ops->core->s_register)
> +					p->flags |= V4L2_CHIP_FL_WRITABLE;
> +				if (sd->ops->core && sd->ops->core->g_register)
> +					p->flags |= V4L2_CHIP_FL_READABLE;
> +#endif
> +				strlcpy(p->name, sd->name, sizeof(p->name));
> +				return 0;
> +			}
> +		}
> +		break;
> +	}
> +	return -EINVAL;
> +}

-- 
Regards,

Laurent Pinchart

