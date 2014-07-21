Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33735 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbaGUJK5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 05:10:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH for v3.17] v4l2-ioctl: don't set PRIV_MAGIC unconditionally in g_fmt()
Date: Mon, 21 Jul 2014 11:11:07 +0200
Message-ID: <18748136.AVYGmbiGvH@avalon>
In-Reply-To: <53CBBFAB.6030907@xs4all.nl>
References: <53CBBFAB.6030907@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Sunday 20 July 2014 15:10:03 Hans Verkuil wrote:
> Regression fix:
> 
> V4L2_PIX_FMT_PRIV_MAGIC should only be set for the VIDEO_CAPTURE and
> VIDEO_OUTPUT buffer types, and not for any others. In the case of
> the win format this overwrites a pointer value that is passed in from
> userspace.
> 
> Since it is already set for the VIDEO_CAPTURE and VIDEO_OUTPUT cases
> anyway this line can just be dropped.

It's set after calling the vidioc_g_fmt_vid_cap or vidioc_g_fmt_vid_out 
operation, which means that driver will not see the flag being set. Couldn't 
that be an issue ?

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
> b/drivers/media/v4l2-core/v4l2-ioctl.c index e620387..c11a13d 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1143,8 +1143,6 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
> bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
>  	int ret;
> 
> -	p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
> -
>  	/*
>  	 * fmt can't be cleared for these overlay types due to the 'clips'
>  	 * 'clipcount' and 'bitmap' pointers in struct v4l2_window.

-- 
Regards,

Laurent Pinchart

