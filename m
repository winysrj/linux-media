Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2304 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab0CQUOd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 16:14:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pawel Osciak <p.osciak@samsung.com>
Subject: Re: [PATCH] v4l: videobuf: make poll() report proper flags for output video devices
Date: Wed, 17 Mar 2010 21:14:42 +0100
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, m-karicheri2@ti.com, chaithrika@ti.com
References: <1268834402-31355-1-git-send-email-p.osciak@samsung.com>
In-Reply-To: <1268834402-31355-1-git-send-email-p.osciak@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201003172114.42210.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 17 March 2010 15:00:02 Pawel Osciak wrote:
> According to the V4L2 specification, poll() should set POLLOUT | POLLWRNORM
> flags for output devices after the frame has been displayed.
> 
> Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
> Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/videobuf-core.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
> index 37afb4e..e93672a 100644
> --- a/drivers/media/video/videobuf-core.c
> +++ b/drivers/media/video/videobuf-core.c
> @@ -1075,8 +1075,14 @@ unsigned int videobuf_poll_stream(struct file *file,
>  	if (0 == rc) {
>  		poll_wait(file, &buf->done, wait);
>  		if (buf->state == VIDEOBUF_DONE ||
> -		    buf->state == VIDEOBUF_ERROR)
> -			rc = POLLIN|POLLRDNORM;
> +		    buf->state == VIDEOBUF_ERROR) {
> +			if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +				rc = POLLIN | POLLRDNORM;
> +			else if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +				rc = POLLOUT | POLLWRNORM;
> +			else
> +				BUG();
> +		}

This is not right. First of all you shouldn't call BUG here. It is better to
default to POLLIN|POLLRDNORM. Secondly, there are more types than just these
two.

This is better:

	switch (q->type) {
		case V4L2_BUF_TYPE_VIDEO_OUTPUT:
		case V4L2_BUF_TYPE_VBI_OUTPUT:
		case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
			rc = POLLOUT | POLLWRNORM;
			break;
		default:
			rc = POLLIN | POLLRDNORM;
			break;
	}

Regards,

	Hans


>  	}
>  	mutex_unlock(&q->vb_lock);
>  	return rc;
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
