Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:41114 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab3JHHWl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Oct 2013 03:22:41 -0400
Message-id: <5253B2BE.5090209@samsung.com>
Date: Tue, 08 Oct 2013 09:22:38 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vb2: Allow STREAMOFF for io emulator
References: <1380894598-11242-1-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1380894598-11242-1-git-send-email-ricardo.ribalda@gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2013-10-04 15:49, Ricardo Ribalda Delgado wrote:
> A video device opened and streaming in io emulator mode can only stop
> streamming if its file descriptor is closed.
>
> There are some parameters that can only be changed if the device is not
> streaming. Also, the power consumption of a device streaming could be
> different than one not streaming.
>
> With this patch a video device opened in io emulator can be stopped on
> demand.
>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Read/write-based io mode must not be mixed with ioctrl-based IO, so I 
really cannot accept this patch. Check V4L2 documentation for more details.

> ---
>   drivers/media/v4l2-core/videobuf2-core.c | 11 ++++++-----
>   1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 9fc4bab..097fba8 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1686,6 +1686,7 @@ int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
>   }
>   EXPORT_SYMBOL_GPL(vb2_streamon);
>   
> +static int __vb2_cleanup_fileio(struct vb2_queue *q);
>   
>   /**
>    * vb2_streamoff - stop streaming
> @@ -1704,11 +1705,6 @@ EXPORT_SYMBOL_GPL(vb2_streamon);
>    */
>   int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
>   {
> -	if (q->fileio) {
> -		dprintk(1, "streamoff: file io in progress\n");
> -		return -EBUSY;
> -	}
> -
>   	if (type != q->type) {
>   		dprintk(1, "streamoff: invalid stream type\n");
>   		return -EINVAL;
> @@ -1719,6 +1715,11 @@ int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
>   		return -EINVAL;
>   	}
>   
> +	if (q->fileio) {
> +		__vb2_cleanup_fileio(q);
> +		return 0;
> +	}
> +
>   	/*
>   	 * Cancel will pause streaming and remove all buffers from the driver
>   	 * and videobuf, effectively returning control over them to userspace.

Best regards
-- 
Marek Szyprowski
Samsung R&D Institute Poland

