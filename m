Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60634 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaLBMdA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Dec 2014 07:33:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 2/2] v4l2-subdev: drop get/set_crop pad ops
Date: Tue, 02 Dec 2014 14:33:32 +0200
Message-ID: <1497494.cKnlhkNNR9@avalon>
In-Reply-To: <1417522901-43604-2-git-send-email-hverkuil@xs4all.nl>
References: <1417522901-43604-1-git-send-email-hverkuil@xs4all.nl> <1417522901-43604-2-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday 02 December 2014 13:21:41 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Drop the duplicate get/set_crop pad ops and only use get/set_selection.
> It makes no sense to have two duplicate ops in the internal subdev API.

Totally agreed, thank you for working on this.

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/v4l2-core/v4l2-subdev.c | 8 --------
>  include/media/v4l2-subdev.h           | 4 ----
>  2 files changed, 12 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c
> b/drivers/media/v4l2-core/v4l2-subdev.c index 543631c..19a034e 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -283,10 +283,6 @@ static long subdev_do_ioctl(struct file *file, unsigned
> int cmd, void *arg) if (rval)
>  			return rval;
> 
> -		rval = v4l2_subdev_call(sd, pad, get_crop, subdev_fh, crop);
> -		if (rval != -ENOIOCTLCMD)
> -			return rval;
> -
>  		memset(&sel, 0, sizeof(sel));
>  		sel.which = crop->which;
>  		sel.pad = crop->pad;
> @@ -308,10 +304,6 @@ static long subdev_do_ioctl(struct file *file, unsigned
> int cmd, void *arg) if (rval)
>  			return rval;
> 
> -		rval = v4l2_subdev_call(sd, pad, set_crop, subdev_fh, crop);
> -		if (rval != -ENOIOCTLCMD)
> -			return rval;
> -
>  		memset(&sel, 0, sizeof(sel));
>  		sel.which = crop->which;
>  		sel.pad = crop->pad;
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 5860292..b052184 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -503,10 +503,6 @@ struct v4l2_subdev_pad_ops {
>  		       struct v4l2_subdev_format *format);
>  	int (*set_fmt)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
>  		       struct v4l2_subdev_format *format);
> -	int (*set_crop)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
> -		       struct v4l2_subdev_crop *crop);
> -	int (*get_crop)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
> -		       struct v4l2_subdev_crop *crop);
>  	int (*get_selection)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
>  			     struct v4l2_subdev_selection *sel);
>  	int (*set_selection)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,

-- 
Regards,

Laurent Pinchart

