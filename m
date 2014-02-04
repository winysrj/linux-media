Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3807 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaBDIzv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Feb 2014 03:55:51 -0500
Message-ID: <52F0AAD9.2010806@xs4all.nl>
Date: Tue, 04 Feb 2014 09:54:49 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 9/9] v4l2-ioctl: check CREATE_BUFS format via TRY_FMT.
References: <1391093491-23077-1-git-send-email-hverkuil@xs4all.nl> <1391093491-23077-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1391093491-23077-10-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/30/2014 03:51 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The format passed to VIDIOC_CREATE_BUFS is completely unchecked at
> the moment. So pass it to VIDIOC_TRY_FMT first.

Don't bother reviewing this. I'm going to change this anyway.

Regards,

	Hans

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 707aef7..7b9d59e 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1443,9 +1443,15 @@ static int v4l_dqbuf(const struct v4l2_ioctl_ops *ops,
>  static int v4l_create_bufs(const struct v4l2_ioctl_ops *ops,
>  				struct file *file, void *fh, void *arg)
>  {
> +	struct video_device *vfd = video_devdata(file);
>  	struct v4l2_create_buffers *create = arg;
>  	int ret = check_fmt(file, create->format.type);
>  
> +	if (ret)
> +		return ret;
> +
> +	if (!WARN_ON(!is_valid_ioctl(vfd, VIDIOC_TRY_FMT)))
> +		ret = v4l_try_fmt(ops, file, fh, &create->format);
>  	return ret ? ret : ops->vidioc_create_bufs(file, fh, create);
>  }
>  
> 

