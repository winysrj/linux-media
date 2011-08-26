Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40742 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab1HZPFR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Aug 2011 11:05:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 3/5] [media] v4l: simulate old crop API using extended crop/compose API
Date: Fri, 26 Aug 2011 17:05:35 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl
References: <1314363967-6448-1-git-send-email-t.stanislaws@samsung.com> <1314363967-6448-4-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1314363967-6448-4-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108261705.36085.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the patch.

On Friday 26 August 2011 15:06:05 Tomasz Stanislawski wrote:
> This patch allows new video drivers to work correctly with applications
> that use the old-style crop API.  The old crop ioctl is simulated by using
> selection callbacks.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/v4l2-ioctl.c |   86
> +++++++++++++++++++++++++++++++++---- 1 files changed, 76 insertions(+),
> 10 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ioctl.c
> b/drivers/media/video/v4l2-ioctl.c index 6e02b45..543405b 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -1696,11 +1696,31 @@ static long __video_do_ioctl(struct file *file,
>  	{
>  		struct v4l2_crop *p = arg;
> 
> -		if (!ops->vidioc_g_crop)
> +		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
> +
> +		if (ops->vidioc_g_crop) {
> +			ret = ops->vidioc_g_crop(file, fh, p);
> +		} else
> +		if (ops->vidioc_g_selection) {

Does this construct (and the two identical ones in the next two hunks) pass 
checkpatch.pl ?

> +			/* simulate capture crop using selection api */
> +			struct v4l2_selection s = {
> +				.type = p->type,
> +				.target = V4L2_SEL_CROP_ACTIVE,
> +			};
> +
> +			/* crop means compose for output devices */
> +			if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +				s.target = V4L2_SEL_COMPOSE_ACTIVE;

You use

			/* obtaining bounds */
			if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
				s.target = V4L2_SEL_COMPOSE_BOUNDS;
			else
				s.target = V4L2_SEL_CROP_BOUNDS;

below instead of pre-initializing .target. Can you use the same method in all 
locations ?

> +
> +			ret = ops->vidioc_g_selection(file, fh, &s);
> +
> +			/* copying results to old structure on success */
> +			if (!ret)
> +				p->c = s.r;
> +		} else {
>  			break;
> +		}

You can remove the last 'else'.

> 
> -		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
> -		ret = ops->vidioc_g_crop(file, fh, p);
>  		if (!ret)
>  			dbgrect(vfd, "", &p->c);
>  		break;
> @@ -1709,11 +1729,26 @@ static long __video_do_ioctl(struct file *file,
>  	{
>  		struct v4l2_crop *p = arg;
> 
> -		if (!ops->vidioc_s_crop)
> -			break;
>  		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
>  		dbgrect(vfd, "", &p->c);
> -		ret = ops->vidioc_s_crop(file, fh, p);
> +
> +		if (ops->vidioc_s_crop) {
> +			ret = ops->vidioc_s_crop(file, fh, p);
> +		} else
> +		if (ops->vidioc_s_selection) {
> +			/* simulate capture crop using selection api */
> +			struct v4l2_selection s = {
> +				.type = p->type,
> +				.target = V4L2_SEL_CROP_ACTIVE,
> +				.r = p->c,
> +			};
> +
> +			/* crop means compose for output devices */
> +			if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +				s.target = V4L2_SEL_COMPOSE_ACTIVE;
> +
> +			ret = ops->vidioc_s_selection(file, fh, &s);
> +		}
>  		break;
>  	}
>  	case VIDIOC_G_SELECTION:
> @@ -1746,12 +1781,43 @@ static long __video_do_ioctl(struct file *file,
>  	{
>  		struct v4l2_cropcap *p = arg;
> 
> -		/*FIXME: Should also show v4l2_fract pixelaspect */
> -		if (!ops->vidioc_cropcap)
> +		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
> +		if (ops->vidioc_cropcap) {
> +			ret = ops->vidioc_cropcap(file, fh, p);
> +		} else
> +		if (ops->vidioc_g_selection) {
> +			struct v4l2_selection s = { .type = p->type };
> +			struct v4l2_rect bounds;
> +
> +			/* obtaining bounds */
> +			if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +				s.target = V4L2_SEL_COMPOSE_BOUNDS;
> +			else
> +				s.target = V4L2_SEL_CROP_BOUNDS;
> +			ret = ops->vidioc_g_selection(file, fh, &s);
> +			if (ret)
> +				break;
> +			bounds = s.r;

You can assign p->bounds directly here, removing the need for the intermediate 
bounds variable.

> +
> +			/* obtaining defrect */
> +			if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +				s.target = V4L2_SEL_COMPOSE_DEFAULT;
> +			else
> +				s.target = V4L2_SEL_CROP_DEFAULT;
> +			ret = ops->vidioc_g_selection(file, fh, &s);
> +			if (ret)
> +				break;
> +
> +			/* storing results */
> +			p->bounds = bounds;
> +			p->defrect = s.r;
> +			p->pixelaspect.numerator = 1;
> +			p->pixelaspect.denominator = 1;
> +		} else {
>  			break;
> +		}
> 
> -		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
> -		ret = ops->vidioc_cropcap(file, fh, p);
> +		/*FIXME: Should also show v4l2_fract pixelaspect */
>  		if (!ret) {
>  			dbgrect(vfd, "bounds ", &p->bounds);
>  			dbgrect(vfd, "defrect ", &p->defrect);

-- 
Regards,

Laurent Pinchart
