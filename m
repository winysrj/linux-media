Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:56742 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030867AbbKEKAL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Nov 2015 05:00:11 -0500
Subject: Re: [RFC PATCH v9 4/6] media: videobuf2: last_buffer_queued is set at
 fill_v4l2_buffer()
To: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com
References: <1446545802-28496-1-git-send-email-jh1009.sung@samsung.com>
 <1446545802-28496-5-git-send-email-jh1009.sung@samsung.com>
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <563B28A0.8080202@xs4all.nl>
Date: Thu, 5 Nov 2015 11:00:00 +0100
MIME-Version: 1.0
In-Reply-To: <1446545802-28496-5-git-send-email-jh1009.sung@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/03/15 11:16, Junghak Sung wrote:
> The location in which last_buffer_queued is set is moved to fill_v4l2_buffer().
> So, __vb2_perform_fileio() can use vb2_core_dqbuf() instead of
> vb2_internal_dqbuf().
> 
> Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
> Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
> Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

One comment: I think the struct vb2_buf_ops callbacks can all return void
instead of int. I don't think they should ever be allowed to fail.

If you agree, then that can be changed in a separate later.

Regards,

	Hans

> ---
>  drivers/media/v4l2-core/videobuf2-v4l2.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
> index 0ca9f23..b0293df 100644
> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> @@ -270,6 +270,11 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
>  	if (vb2_buffer_in_use(q, vb))
>  		b->flags |= V4L2_BUF_FLAG_MAPPED;
>  
> +	if (!q->is_output &&
> +		b->flags & V4L2_BUF_FLAG_DONE &&
> +		b->flags & V4L2_BUF_FLAG_LAST)
> +		q->last_buffer_dequeued = true;
> +
>  	return 0;
>  }
>  
> @@ -579,10 +584,6 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b,
>  
>  	ret = vb2_core_dqbuf(q, b, nonblocking);
>  
> -	if (!ret && !q->is_output &&
> -			b->flags & V4L2_BUF_FLAG_LAST)
> -		q->last_buffer_dequeued = true;
> -
>  	return ret;
>  }
>  
> 
