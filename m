Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49244 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbbBWQhp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 11:37:45 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 3/7] v4l2-subdev.c: add 'which' checks for enum ops.
Date: Mon, 23 Feb 2015 18:38:46 +0200
Message-ID: <8333854.bO18x4suAV@avalon>
In-Reply-To: <1423827006-32878-4-git-send-email-hverkuil@xs4all.nl>
References: <1423827006-32878-1-git-send-email-hverkuil@xs4all.nl> <1423827006-32878-4-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Friday 13 February 2015 12:30:02 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Return an error if an invalid 'which' valid is passed in.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/v4l2-core/v4l2-subdev.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c
> b/drivers/media/v4l2-core/v4l2-subdev.c index 3c8b198..8bafb94 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -321,6 +321,10 @@ static long subdev_do_ioctl(struct file *file, unsigned
> int cmd, void *arg) case VIDIOC_SUBDEV_ENUM_MBUS_CODE: {
>  		struct v4l2_subdev_mbus_code_enum *code = arg;
> 
> +		if (code->which != V4L2_SUBDEV_FORMAT_TRY &&
> +		    code->which != V4L2_SUBDEV_FORMAT_ACTIVE)
> +			return -EINVAL;
> +
>  		if (code->pad >= sd->entity.num_pads)
>  			return -EINVAL;
> 
> @@ -331,6 +335,10 @@ static long subdev_do_ioctl(struct file *file, unsigned
> int cmd, void *arg) case VIDIOC_SUBDEV_ENUM_FRAME_SIZE: {
>  		struct v4l2_subdev_frame_size_enum *fse = arg;
> 
> +		if (fse->which != V4L2_SUBDEV_FORMAT_TRY &&
> +		    fse->which != V4L2_SUBDEV_FORMAT_ACTIVE)
> +			return -EINVAL;
> +
>  		if (fse->pad >= sd->entity.num_pads)
>  			return -EINVAL;
> 
> @@ -359,6 +367,10 @@ static long subdev_do_ioctl(struct file *file, unsigned
> int cmd, void *arg) case VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL: {
>  		struct v4l2_subdev_frame_interval_enum *fie = arg;
> 
> +		if (fie->which != V4L2_SUBDEV_FORMAT_TRY &&
> +		    fie->which != V4L2_SUBDEV_FORMAT_ACTIVE)
> +			return -EINVAL;
> +
>  		if (fie->pad >= sd->entity.num_pads)
>  			return -EINVAL;

-- 
Regards,

Laurent Pinchart

