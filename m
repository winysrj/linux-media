Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4563 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaBWIhF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Feb 2014 03:37:05 -0500
Message-ID: <5309B317.3060603@xs4all.nl>
Date: Sun, 23 Feb 2014 09:36:39 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv4 PATCH 08/11] vb2: q->num_buffers was updated too soon
References: <1392374472-18393-1-git-send-email-hverkuil@xs4all.nl> <1392374472-18393-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392374472-18393-9-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/14/2014 11:41 AM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> In __reqbufs() and __create_bufs() the q->num_buffers field was updated
> with the number of newly allocated buffers, but right after that those are
> freed again if some error had occurred before. Move the line updating
> num_buffers to *after* that error check.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

NACK: this is actually correct behavior since __vb2_queue_free() subtracts
'allocated_buffers' from q->num_buffers. A comment mentioning this might be
useful, though.

Regards,

	Hans

> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index ad3db83..96c5ac6 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -848,13 +848,13 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
>  		 */
>  	}
>  
> -	q->num_buffers = allocated_buffers;
> -
>  	if (ret < 0) {
>  		__vb2_queue_free(q, allocated_buffers);
>  		return ret;
>  	}
>  
> +	q->num_buffers = allocated_buffers;
> +
>  	/*
>  	 * Return the number of successfully allocated buffers
>  	 * to the userspace.
> @@ -957,13 +957,13 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
>  		 */
>  	}
>  
> -	q->num_buffers += allocated_buffers;
> -
>  	if (ret < 0) {
>  		__vb2_queue_free(q, allocated_buffers);
>  		return -ENOMEM;
>  	}
>  
> +	q->num_buffers += allocated_buffers;
> +
>  	/*
>  	 * Return the number of successfully allocated buffers
>  	 * to the userspace.
> 

