Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48706 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727367AbeHMRjP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 13:39:15 -0400
Date: Mon, 13 Aug 2018 11:56:36 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv17 28/34] videobuf2-v4l2: refuse qbuf if queue uses
 requests or vv.
Message-ID: <20180813115636.3eb6439a@coco.lan>
In-Reply-To: <20180804124526.46206-29-hverkuil@xs4all.nl>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
        <20180804124526.46206-29-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat,  4 Aug 2018 14:45:20 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Check if the vb2 queue uses requests, and if so refuse to
> add buffers that are not part of a request. Also check for
> the reverse: a vb2 queue did not use requests, and an attempt
> was made to queue a buffer to a request.
> 
> We might relax this in the future, but for now just return
> -EPERM in that case.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  drivers/media/common/videobuf2/videobuf2-v4l2.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> index 88d8f60c742b..1b2351986230 100644
> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> @@ -378,8 +378,16 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct media_device *md
>  			return ret;
>  	}
>  
> -	if (!(b->flags & V4L2_BUF_FLAG_REQUEST_FD))
> +	if (!(b->flags & V4L2_BUF_FLAG_REQUEST_FD)) {
> +		if (q->uses_requests) {
> +			dprintk(1, "%s: queue uses requests\n", opname);
> +			return -EPERM;
> +		}
>  		return 0;
> +	} else if (q->uses_qbuf) {
> +		dprintk(1, "%s: queue does not use requests\n", opname);
> +		return -EPERM;
> +	}
>  
>  	/*
>  	 * For proper locking when queueing a request you need to be able



Thanks,
Mauro
