Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2572 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab0C2TLT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Mar 2010 15:11:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pawel Osciak <p.osciak@samsung.com>
Subject: Re: [PATCH v2] v4l: videobuf: make poll() report proper flags for output video devices
Date: Mon, 29 Mar 2010 21:11:48 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
References: <1269850591-9590-1-git-send-email-p.osciak@samsung.com>
In-Reply-To: <1269850591-9590-1-git-send-email-p.osciak@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201003292111.48289.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 29 March 2010 10:16:31 Pawel Osciak wrote:
> According to the V4L2 specification, poll() should set POLLOUT | POLLWRNORM
> flags for output devices after the frame has been displayed.
> 
> Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
> Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>

Looks good to me!

Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>

Regards,

	Hans

> ---
>  drivers/media/video/videobuf-core.c |   14 ++++++++++++--
>  1 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
> index 63d7043..921277f 100644
> --- a/drivers/media/video/videobuf-core.c
> +++ b/drivers/media/video/videobuf-core.c
> @@ -1075,8 +1075,18 @@ unsigned int videobuf_poll_stream(struct file *file,
>  	if (0 == rc) {
>  		poll_wait(file, &buf->done, wait);
>  		if (buf->state == VIDEOBUF_DONE ||
> -		    buf->state == VIDEOBUF_ERROR)
> -			rc = POLLIN|POLLRDNORM;
> +		    buf->state == VIDEOBUF_ERROR) {
> +			switch (q->type) {
> +			case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> +			case V4L2_BUF_TYPE_VBI_OUTPUT:
> +			case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
> +				rc = POLLOUT | POLLWRNORM;
> +				break;
> +			default:
> +				rc = POLLIN | POLLRDNORM;
> +				break;
> +			}
> +		}
>  	}
>  	mutex_unlock(&q->vb_lock);
>  	return rc;
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
